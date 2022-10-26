# @PROGDOC: 3DXSolidWorks_Dnld.tcl & 3DXSolidWorks_Upld.tcl support Solid Works Assembly Family internal path repair effort
# @Namespace/Class = (global)
# @Methods = (packge loading)
# @Properties = (N/A)
# @Program = Atlas Copco\Migration\SolidWorksAssyRepair\3DXSolidWorks_Upld.tcl
# @Version  = 1.0
# @Synopsis = implementation main thread - Upload Solid Works Assembly Family
# @Purpose = to provide methods/properties for Update of data from foreign systems to 3DX
# @Package = provides (N/A)
# @Package = requires CFG, HDR, xUtil, xBO, 3DXSolidWorks.hdr.tcl, 3DXSolidWorks.cfg.tcl, 3DXSolidWorks.lib.tcl
# @Object = (N/A)
# @ 3DXMigration Import:
#   C:\R2017x\3DSpace\win_b64\code\bin\mql.exe -c "set context user creator; exec prog 3DXSolidWorks_Upld.tcl;"

tcl;

eval {
	#~ load default HDR then implementation specific HDR to overload settings
	eval [mql print program Hdr_v17.lib.tcl select code dump]
	eval [mql print program 3DXMigrationSolution.cfg select code dump]
	#~ load default CFG then implementation specific CFG to overload settings
	eval [mql print program 3DXSolidWorks.hdr.tcl select code dump]
	eval [mql print program 3DXSolidWorks.cfg.tcl select code dump]

	#~ load default xUTIL
	eval [mql print program xUtil_v16.lib.tcl select code dump]
	#~ load default xBO_v17
	eval [mql print prog xBO_v17.lib.tcl   select code dump]

	#~ load 3DXSolidWorks for extended 3DXSolidWorks functions + overload xUtil & xBO
	eval [mql print program 3DXSolidWorks.lib.tcl select code dump]


	#~ 1. iterate through D:\ACGMZ\staging\SolidWorks\logs\SolidWorksDownload.log 

	#~ 2. parse TNR log entry for T N R and path
	#	2.1 Validate Object in 3DX: T N R ID format[asm].file.name
	#	2.2 validate TNR folder path in ACGMZ 
	#	2.3 validate file in ACGMZ TNR folder

	#~ 3. Checkin: format[asm].file 1000B110.SLDASM from folder (above)

	#~ 4. write log entries:
	#~ 4.1 D:\ACGMZ\staging\SolidWorks\logs\SolidWorksUpload.log
	#~	example line: EventStatus|Timestamp|Path2ACGMZ|T|N|R|ID|FilePath|vault|policy|current|originated|modified|owner|organization|project|iov|dov|checkoutMsg
	#~		D2N.sema = checkin was successful
	#~	example line: D2N(3DX)|Timestamp|Path2ACGMZ|T|N|R|ID|vault|policy|current|originated|modified|owner|organization|project|iov|dov|checkoutMsg
	#~		E2R.sema = there was an error in checking out or checking in the file from/to the 3DX object
	#~	example line: ERR(3DX)|Timestamp|Path2ACGMZ|T|N|R|ID|vault|policy|current|originated|modified|owner|organization|project|iov|dov|checkoutMsg

	#~	example line: EventStatus|T|N|R|ID|gapLegacyPDMIdentifier|Filename|FilePath|vault|policy|current|originated|modified|owner|organization|project|iov|dov|checkoutMsg
	#set sTimeStampX [clock format [clock seconds] -format "%a%Y%b%dv%H%M%S"]
	set sEnv [::xUtil::xGetEnv]
	set sDowloadLogFileName  [file join "$::ACGMZ_LOG" "SolidWorksDownload(${sEnv}).log"]
	set ::LOGPATH  [file join "$::ACGMZ_LOG" "SolidWorksUpload(${sEnv}).log"]

	set x [mql trigger off]
	
	set xCheckinMsg ""

	if {[file exist $sDowloadLogFileName] == 1 } {
		
		foreach iLogData [split [::xUtil::readFile $sDowloadLogFileName] \n] {
			puts "PROCESSING:: $iLogData"
			set sEventStatusCkout [lindex [split $iLogData |] 0]

			if {[string match -nocase "STATUS" "$sEventStatusCkout"] == 0} {

				set sType [lindex [split $iLogData |] 2]
				set sName [lindex [split $iLogData |] 3]
				set sRev  [lindex [split $iLogData |] 4]
				set oID   [lindex [split $iLogData |] 5]
				set sGapLegacyPDMIdentifier   [lindex [split $iLogData |] 6]
				set sFilename [lindex [split $iLogData |] 7]
				set sFilePath [lindex [split $iLogData |] 8]

				puts "Status - $sEventStatusCkout"

				if {[string match -nocase "$::EVENTCODE(D2N)" "$sEventStatusCkout"] == 1} {

					#set iObjData [mql print bus $oID select type name revision attribute\[gapLegacyPDMIdentifier\] format\[asm\].file.name dump |]
					set x [catch {mql print bus $oID select type name revision attribute\[gapLegacyPDMIdentifier\] format\[asm\].file.name dump |} iObjData]
					if {$x == 0} {
						set s1Type [lindex [split $iObjData |] 0]
						set s1Name [lindex [split $iObjData |] 1]
						set s1Rev  [lindex [split $iObjData |] 2]
						set s1GapLegacyPDMIdentifier   [lindex [split $iObjData |] 3]
						set s1Filename [lindex [split $iObjData |] 4]

						if {[string match -nocase "$sType" "$s1Type"] == 1 && [string match -nocase "$sName" "$s1Name"] == 1 && [string match -nocase "$sRev" "$s1Rev"] == 1 } {
							#~ initial validation - TNR is the same
							if {[string match -nocase "$sGapLegacyPDMIdentifier" "$s1GapLegacyPDMIdentifier"] == 1} {
								#~ secondary validation - GapLegacyPDMIdentifier
								if {[string match -nocase "$sFilename" "$s1Filename"] == 1} {
									#~ tertiary validation - file name
									set iCheckinStatus [::xBO::checkinBusinessObject $oID "asm" "$sFilePath" R]
									if {$iCheckinStatus == $::TRUE} {
										#~ log entry - checkin success
										set sEventStatus $::EVENTCODE(D2N)
										set xCheckinMsg "CHECKINSUCCESS: $sFilePath"
									} else {
										#~ log entry - checkin failed
										set sEventStatus $::EVENTCODE(E2R)
										set xCheckinMsg "CHECKINFAILED: $sFilePath"
									}
								} else {
									#~ sFilename in log record and object did not match
									set sEventStatus $::EVENTCODE(E2R)
									set xCheckinMsg "CHECKINFAILED: $sFilename .NEQ. $s1Filename"
								}
							} else {
								#~ GapLegacyPDMIdentifier in log record and object did not match
								set sEventStatus $::EVENTCODE(E2R)
								set xCheckinMsg "CHECKINFAILED: $sGapLegacyPDMIdentifier .NEQ. $s1GapLegacyPDMIdentifier"
							}
						} else {
							#~ TNR in log record and object did not match
							set sEventStatus $::EVENTCODE(E2R)
							set xCheckinMsg "CHECKINFAILED: $sType $sName $sRev .NEQ. $s1Type $s1Name $s1Rev"
						}
					} else {
						#~ print businessobject error
						set sEventStatus $::EVENTCODE(E2R)
						set xCheckinMsg "CHECKINFAILED: could not resolve $sType $sName $sRev"
					}
				} else {
					#~ EventStatus from CHECKOUT was ERROR
					set sEventStatus $::EVENTCODE(E2R)
					set xCheckinMsg "CHECKINFAILED: CheckOUT error from log $sEventStatusCkout $sType $sName $sRev"
				}
			} else {
				set sEventStatus $::EVENTCODE(D2N)
				set xCheckinMsg "HEADER: Header Encountered"
			}; #~ endIF go past log header

			set sRcd [join [list "$iLogData" "$xCheckinMsg" ] |]
			set x [::xUtil::log "$sEventStatus" "$sRcd" "$::LOGPATH"]

		}; #~ endForeach Loop

	} else {
		#~ log file does NOT exist
		set sEventStatus $::EVENTCODE(E2R)
		set xCheckinMsg "CHECKINFAILED: could NOT open Download Logfile $sDowloadLogFileName"
		set x [::xUtil::log "$sEventStatus" "$xCheckinMsg" "$::LOGPATH"]
	}



}; #~endEval

