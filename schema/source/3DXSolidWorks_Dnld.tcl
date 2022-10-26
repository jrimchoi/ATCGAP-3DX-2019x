# @PROGDOC: 3DXSolidWorks_Dnld.tcl & 3DXSolidWorks_Upld.tcl support Solid Works Assembly Family internal path repair effort
# @Namespace/Class = (global)
# @Methods = (packge loading)
# @Properties = (N/A)
# @Program = Atlas Copco\Migration\SolidWorksAssyRepair\3DXSolidWorks_Dnld.tcl
# @Version  = 1.0
# @Synopsis = implementation main thread - Download Solid Works Assembly Family
# @Purpose = to provide methods/properties for Update of data from foreign systems to 3DX
# @Package = provides (N/A)
# @Package = requires CFG, HDR, xUtil, xBO, 3DXSolidWorks.hdr.tcl, 3DXSolidWorks.cfg.tcl, 3DXSolidWorks.lib.tcl
# @Object = (N/A)
# @ 3DXMigration Import:
#   C:\R2017x\3DSpace\win_b64\code\bin\mql.exe -c "set context user creator; exec prog 3DXSolidWorks_Dnld.tcl;"

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


	#~ 1. query all applicable objects

	#~ 2. iterate through above query list and create TNR folders in
	#	D:\ACGMZ\staging\SolidWorks
	#	\\TBISUSEN128\ACGMZ\staging\SolidWorks
	#~ example: D:\ACGMZ\staging\SolidWorks\SW_Assembly_Family~1000B110.SLDASM~0

	#~ 3. Checkout: format[asm].file 1000B110.SLDASM to folder (above)

	#~ 4. write log entries:
	#~ 4.1 D:\ACGMZ\staging\SolidWorks\log\SolidWorksDownload(timestamp).log
	#~	example line: EventStatus|Timestamp|T|N|R|ID|FilePath|vault|policy|current|originated|modified|owner|organization|project|iov|dov|checkoutMsg
	#set sTimeStampX [clock format [clock seconds] -format "%a%Y%b%dv%H%M%S"]
	set sEnv [::xUtil::xGetEnv]
	set ::LOGPATH  [file join "$::ACGMZ_LOG" "SolidWorksDownload(${sEnv}).log"]

	set x [mql trigger off]

	#set x [mql temp query bus \"SW Assembly Family\" 1000B9.SLDASM,1003B111.SLDASM,1003B111.SLDASM,1003B111.SLDASM  0,1,2,BL* where \"policy nsmatch *Version* && attribute\[gapLegacyPDMIdentifier\] nsmatch \'\'\" limit 10 select id attribute\[gapLegacyPDMIdentifier\] format\[asm\].file.name dump |]
#	foreach iObj [split [mql temp query bus \"SW Assembly Family\" 1000B9.SLDASM,1003B111.SLDASM,1003B111.SLDASM,1003B111.SLDASM  0,1,2,BL* where \"policy nsmatch *Version* && attribute\[gapLegacyPDMIdentifier\] nsmatch \'\'\" limit 10 select id attribute\[gapLegacyPDMIdentifier\] format\[asm\].file.name dump |] \n] {}

	set sFormat "asm"

	foreach iObj [split [mql temp query bus \"SW Assembly Family\" * * where \"policy nsmatch *Version* && attribute\[gapLegacyPDMIdentifier\] nsmatch \'\'\" select id attribute\[gapLegacyPDMIdentifier\] format\[asm\].file.name dump |] \n] {
		set sType [lindex [split $iObj |] 0]
		set sName [lindex [split $iObj |] 1]
		set sRev  [lindex [split $iObj |] 2]
		if {[string last ? $sRev] > -1 } {
			#~ regsub ? for ^
			regsub -all -- "\\\?"  "$sRev" "^"  sRev2
		} else {
			set sRev2 "$sRev"
		}
		


		set oID   [lindex [split $iObj |] 3]
		set sgapLegacyPDMIdentifier [lindex [split $iObj |] 4]
		#~ sFilename can be null, write error and loop out
		set sFilename [lindex [split $iObj |] 5]

		if {[::xUtil::isNull "$sFilename"] == $::FALSE} {
			set x [join [list "$sType" "$sName" "$sRev2"] ~]
			regsub -all -- " "  "$x" "_"  sFolderName
			set sFolderPath [file join $::ACGMZ "$sFolderName"]
			set sFilePath [file join "$sFolderPath" "$sFilename"]

			puts "PROCESSING:: $iObj output to $sFilePath"

			set iFolderStat [::xUtil::xCreateCheckoutDirectory "$sFolderPath"]
			if {$iFolderStat == $::TRUE} {
				set iCheckoutStat [::3DXSolidWorks::xCheckoutSolidWorksAssembly "$sType" "$sName" "$sRev" "$sFolderPath" "$sFilename"]
				if {$iCheckoutStat == $::TRUE} {
						set sEventStatus $::EVENTCODE(D2N)
						set xCheckoutMsg "CHECKOUTSUCCESS: $sFilePath"
					} else {
						set sEventStatus $::EVENTCODE(E2R)
						set xCheckoutMsg "CHECKOUTFAILURE: $sFilePath"
					}
			} else {
				set sEventStatus $::EVENTCODE(E2R)
				set xCheckoutMsg "CHECKOUTFAILURE:  could not create directory: $sFolderPath"
			}
		} else {
			#~ filename is null
			set sEventStatus $::EVENTCODE(E2R)
			set xCheckoutMsg "CHECKOUTFAILURE:  Object file content for format $sFormat is null"

		}

		#~	example line: EventStatus|T|N|R|ID|gapLegacyPDMIdentifier|Filename|FilePath|vault|policy|current|originated|modified|owner|organization|project|iov|dov|checkoutMsg
		set sRcd [mql print bus $oID select vault policy current originated modified owner organization project iov dov dump |]
		set sRcd2 [join [list "$iObj" "$sFilePath" "$sRcd"] |]
		set x [::xUtil::log "$sEventStatus" "$sRcd2" "$::LOGPATH"]

	}

	set x [mql trigger on]


}; #~endEval

exit;

