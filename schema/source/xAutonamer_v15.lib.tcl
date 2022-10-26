# @PROGDOC: xAutonamer class library to implement Business Object creation and manipulation methods
# @Namespace/Class =  xAutonamer
# @Methods = ::xAutonamer::autoNameGenerator()
# @Properties = none
# @Program =  xAutonamer_v15.lib.tcl
# @Version  = 15.0
# @Synopsis = implementation library for Autoname Object based name generation for new businessobject creation
# @Purpose = to provide methods/properties for Autoname Object name generation for object creation based on the AUTONAMERTYPEINCLUSIONLIST
# @Implementation = eval [mql print program xAutonamer.lib.tcl select code dump]
# @Package = xAutonamer
# @Object = eService Object Generator, eService Number Generator

# businessobject "eService Object Generator" type_DOCUMENTS
    # attribute[eService Name Prefix].value = G-
    # attribute[eService Name Suffix].value =
    # attribute[eService Processing Time Limit].value = 60 ;# of times it will iterate to try and create a unique name, if generated name is taken
    # attribute[eService Retry Count].value = 5
    # attribute[eService Retry Delay].value = 60
    # attribute[eService Safety Policy].value = policy_Document
    # attribute[eService Safety Vault].value = vault_eServiceAdministration
# businessobject "eService Number Generator" type_DOCUMENTS
    # attribute[eService Next Number].value = 000000031

# % mql expand businessobject "eService Object Generator" type_DOCUMENTS ""
# 1  eService Number Generator  to  eService Number Generator  type_DOCUMENTS

# % mql print businessobject "eService Number Generator" type_DOCUMENTS "" select locked
# business object  eService Number Generator type_DOCUMENTS
    # locked = FALSE
# % mql lock bus "eService Number Generator" type_DOCUMENTS ""
# % mql print businessobject "eService Number Generator" type_DOCUMENTS "" select locked
# business object  eService Number Generator type_DOCUMENTS
    # locked = TRUE
# % mql unlock bus "eService Number Generator" type_DOCUMENTS ""
# % mql print businessobject "eService Number Generator" type_DOCUMENTS "" select locked
# business object  eService Number Generator type_DOCUMENTS
    # locked = FALSE


package provide xAutonamer

namespace eval xAutonamer {

	proc init {} {
	}
	
	proc getAutonamer {sType {iMaxRecusionDepth	8}} {
		set xgetAutonamer(0) $::FALSE
		
		set sObjGenParameters	"eService Object Generator"
		set sObjGenStateful		"eService Number Generator"
		set sObjGenPrefix		"type"

		set sCurrType "$sType"

		for {set i 0} {$i < $iMaxRecusionDepth} {incr i} {	
			set sObjGenName [join [list "$sObjGenPrefix" "$sCurrType"] "_"]
			set sObjGenStatus [mql print bus "$sObjGenParameters" "$sObjGenName" "" select exists dump]
			if {[string compare "FALSE" [string toupper $sObjGenStatus]] == 0} {
				#~ Autonamer not found, seek derived parent type and check again
				set sDerivable [mql print type "$sCurrType" select derived.admintype dump]
				if {[string compare "DERIVABLETYPE" [string toupper "$sDerivable"]] == 0} {
					#~ type derivable, find parent, set to current type
					set sDeriveFromType [mql print type "$sCurrType" select derived dump]
					if {[string compare "$sDeriveFromType" ""] == 0} {
						#~ this is an error
						set xgetAutonamer(0) [::xUtil::errMsg 50 "no autonamer found, type derivable but sDeriveFromType null $sType"]
						break;
					} else {
						set sCurrType "$sDeriveFromType"
					}
				} else {
					set xgetAutonamer(0) [::xUtil::errMsg 50 "no autonamer found, type not derivable $sType < $sCurrType"]
					break;
				}
			} else {
				#~ object autonamer found
				set xgetAutonamer(PARAMOID) [mql print bus "$sObjGenParameters" "$sObjGenName" "" select id dump]
				set xgetAutonamer(STATEOID) [mql print bus "$sObjGenStateful"   "$sObjGenName" "" select id dump]
				set xgetAutonamer(0) $::TRUE
				break;
			}
		}
		return [array get xgetAutonamer]
	}


#	% mql temp query businessobject "eService Number Generator" type_* * select attribute\[eService Next Number\].value dump |
	proc genName {sType sName sRev xAutoNamerOID sPrefix sSuffix} {
		set xgenName(0) $::FALSE

		set iAutonamerNextValue [mql print bus $xAutoNamerOID select attribute\[eService Next Number\].value dump]
		#~ see if the old object using the native name exists
		set bOldObjectStatus [mql print bus "$sType" "$sName" "$sRev" select exists dump]
		#~ construct the new autoname generated name and see if it exist 
		set sNewName [join [list "$sPrefix" "$iAutonamerNextValue" "$sSuffix"] ""]
		set bNEWObjectStatus [mql print bus "$sType" "$sNewName" "$sRev" select exists dump]
		
		#~ check and see if either the OLD (nativename) or NEW (autoname) returned TRUE to inquiry
		if {[string compare [string toupper "$bOldObjectStatus"] "TRUE"] == 0} {
			#~ the OLD name has already been used and an object exists
			set xgenName(0) [::xUtil::errMsg 51 "Legacy System Object exists: $sType $sName $sRev"]
		} elseif {[string compare [string toupper "$bNEWObjectStatus"] "TRUE"] == 0} {
			#~ the NEW name has already been used and an object exists
			set xgenName(0) [::xUtil::errMsg 52 "NEW Autogenerated Name System Object exists: $sType $sNewName $sRev"]
		} else {
			#~ neither the old or new name has been used, so good to go
			set xgenName(0) $::TRUE
			set xgenName(NAME) "$sNewName"
			set xgenName(CURRENT) "$iAutonamerNextValue"
		}
		return [array get xgenName]
	}

	proc updateNextName {xAutoNamerOID sNextValue} {
		set bupdateNextName $:FALSE
		
		set x [catch {mql mod bus $xAutoNamerOID "eService Next Number" "$sNextValue"} err ]
		if {$x == 0} {
			set bupdateNextName $::TRUE
		} else {
			set bupdateNextName [::xUtil::errMsg 53 "Could not update Autonamer: $xAutoNamerOID : $err"]
		}
		return $bupdateNextName
	}

	proc incrAutonameNextValue {iAutonamerCurrentValue {iIncrBy 1} {iIncrLen 0} } {
		set xincrAutonameNextValue(0) $::FALSE
		
		set iAutoValueOldLen [string length $iAutonamerCurrentValue]

		set x [string trimleft $iAutonamerCurrentValue 0]
		#~ if this is an initial Autonamer value, trim left will null it, so reset to integer 0
		if {[::xUtil::isNull "$x"] == $::TRUE} {
			set x 0
		}
		#~ increment the integer value for the autonamer by iIncrBy
		incr x $iIncrBy
		
		if {$x > 0} {
			#~ valid auto incrementation to auto number value, now reapply 0 padding
			if {$iIncrLen > 0} {
				set xincrAutonameNextValue(NEWNAME) [format "%0${iIncrLen}d" $x]
			} else {
				set xincrAutonameNextValue(NEWNAME) [format "%0${iAutoValueOldLen}d" $x]
			}
			
			set iAutoValueNewLen [string length $xincrAutonameNextValue(NEWNAME)]

			if {$iAutoValueNewLen == $iAutoValueOldLen || $iAutoValueNewLen == $iIncrLen} {
				set xincrAutonameNextValue(0) $::TRUE
			} else {
				#~~~ error 54
				set xincrAutonameNextValue(0) [::xUtil::errMsg 54 "Update Autonamer: autonamer integer overflow: "]
			}
			
		} else {
			
			set xincrAutonameNextValue(0) $::ERROR
		}
		return [array get xincrAutonameNextValue]
	}

	proc autoNameGenerator2 {sType sName sRev} {
		 set xAutoNameGenerator(0) $::FALSE
		 
		 array set xAutoNamer [::xAutonamer::getAutonamer "$sType"]
		 
		 if {$xAutoNamer(0) == $::TRUE} {
		
			set sPrefix [mql print bus $xAutoNamer(PARAMOID) select attribute\[eService Name Prefix\].value dump]
			set sSuffix [mql print bus $xAutoNamer(PARAMOID) select attribute\[eService Name Suffix\].value dump]
			
			# Number of retrys to create unique object name, if current one is used
			set iProcessingTriesLimit	[mql print bus $xAutoNamer(PARAMOID) select attribute\[eService Processing Time Limit\].value dump]
			# Number of times to retry if the "eService Number Generator" is locked
			set iRetryCnt				[mql print bus $xAutoNamer(PARAMOID) select attribute\[eService Retry Count\].value dump]
			# Number of seconds to wait between each retry if "eService Number Generator" is locked
			set iRetryDelay				[expr [mql print bus $xAutoNamer(PARAMOID) select attribute\[eService Retry Delay\].value dump] * 1000]
			
			for {set i 0} {$i <= $iRetryCnt} {incr i} {
				set isAutonamerLocked [mql print bus $xAutoNamer(STATEOID) select locked dump]
				if {[string compare [string toupper "$isAutonamerLocked"] "FALSE"] == 0} {
					puts "Debugger: Autonamer unlocked: $xAutoNamer(STATEOID) "
					set x [catch {mql lock bus $xAutoNamer(STATEOID)} err]
					puts "Debugger: Autonamer LOCKED for this process: $xAutoNamer(STATEOID) "
					
						array set xNewName [::xAutonamer::genName "$sType" "$sName" "$sRev" $xAutoNamer(STATEOID) "$sPrefix" "$sSuffix"]
						puts "Debugger: Autonamer New Name Generated: [array get xNewName] "
						
						if {$xNewName(0) == $::TRUE } {
							set xAutoNameGenerator(NAME) "$xNewName(NAME)"
							array set x1 [::xAutonamer::incrAutonameNextValue "$xNewName(CURRENT)"]
							puts "Debugger: Autonamer NEXT Name Generated: [array get x1] "
							
							if {$x1(0) == $::TRUE} {
								set xAutoNameGenerator(NEXTVALUE) "$x1(NEWNAME)"
								set xAutoNameGenerator(0) [::xAutonamer::updateNextName $xAutoNamer(STATEOID) "$xAutoNameGenerator(NEXTVALUE)"]
								puts "Debugger: Autonamer New Name UPDATED: $xAutoNamer(STATEOID) $xAutoNameGenerator(NEXTVALUE) "
							} else {
								set xAutoNameGenerator(0) [::xUtil::errMsg 42 "Could not increment autoname to new name for: $sType $sName $sRev"]
							}
						} else {
							set xAutoNameGenerator(0) [::xUtil::errMsg 42 "Could not generate name for: $sType $sName $sRev"]
						}
					
					set x [catch {mql unlock bus $xAutoNamer(STATEOID)} err]
					puts "Debugger: Autonamer UNLOCKED for this process: $xAutoNamer(STATEOID) - DONE!"
					
					break;
				} else {
					#~ autoname object locked by another process, wait iRetryDelay seconds
					puts "Debugger: Autonamer is LOCKED wait iRetryDelay: $xAutoNamer(STATEOID) "
					after $iRetryDelay
				}
			}; #~endForeach

		} else {
			#~ error no name generator
			set xAutoNameGenerator(0) [::xUtil::errMsg 42 "No Autonamer for: $sType $sName $sRev"]
			set xAutoNameGenerator(0) $::FALSE
		}
		
		#set x [catch {mql unlock bus $xAutoNamer(STATEOID)} err]
		#puts "Debugger: BACKUP Autonamer UNLOCKED for this process: $xAutoNamer(STATEOID) - DONE!"
		#~ returns: 
		#~   xAutoNameGenerator(0)=TRUE/FALSE 
		#~   xAutoNameGenerator(NAME)=Generated Name 
		#~   xAutoNameGenerator(NEXTVALUE)=Next number in sequence that "eService Number Generator" type_DOCUMENTS is set o
		return [array get xAutoNameGenerator]
	}

	proc autoNameGenerator {sType sName sRev} {
		 set xAutoNameGenerator(0) $::FALSE
		 
		 array set xAutoNamer [::xAutonamer::getAutonamer "$sType"]
		 
		 if {$xAutoNamer(0) == $::TRUE} {
		
			set sPrefix [mql print bus $xAutoNamer(PARAMOID) select attribute\[eService Name Prefix\].value dump]
			set sSuffix [mql print bus $xAutoNamer(PARAMOID) select attribute\[eService Name Suffix\].value dump]
			
			# Number of retrys to create unique object name, if current one is used
			set iProcessingTriesLimit	[mql print bus $xAutoNamer(PARAMOID) select attribute\[eService Processing Time Limit\].value dump]
			# Number of times to retry if the "eService Number Generator" is locked
			set iRetryCnt				[expr [mql print bus $xAutoNamer(PARAMOID) select attribute\[eService Retry Count\].value dump] * 100]
			# Number of seconds to wait between each retry if "eService Number Generator" is locked
			set iRetryDelay				[expr [mql print bus $xAutoNamer(PARAMOID) select attribute\[eService Retry Delay\].value dump] * 1]
			
			for {set i 0} {$i <= $iRetryCnt} {incr i} {
				set x [catch {mql lock bus $xAutoNamer(STATEOID)} err]
				if {$x == 0} {
					puts "Debugger: Autonamer LOCKED for this process: $xAutoNamer(STATEOID) "
					
						array set xNewName [::xAutonamer::genName "$sType" "$sName" "$sRev" $xAutoNamer(STATEOID) "$sPrefix" "$sSuffix"]
						puts "Debugger: Autonamer New Name Generated: [array get xNewName] "
						
						if {$xNewName(0) == $::TRUE } {
							set xAutoNameGenerator(NAME) "$xNewName(NAME)"
							array set x1 [::xAutonamer::incrAutonameNextValue "$xNewName(CURRENT)"]
							puts "Debugger: Autonamer NEXT Name Generated: [array get x1] "
							
							if {$x1(0) == $::TRUE} {
								set xAutoNameGenerator(NEXTVALUE) "$x1(NEWNAME)"
								set xAutoNameGenerator(0) [::xAutonamer::updateNextName $xAutoNamer(STATEOID) "$xAutoNameGenerator(NEXTVALUE)"]
								puts "Debugger: Autonamer New Name UPDATED: $xAutoNamer(STATEOID) $xAutoNameGenerator(NEXTVALUE) "
							} else {
								set xAutoNameGenerator(0) [::xUtil::errMsg 42 "Could not increment autoname to new name for: $sType $sName $sRev"]
							}
						} else {
							set xAutoNameGenerator(0) [::xUtil::errMsg 42 "Could not generate name for: $sType $sName $sRev"]
						}
					
					set x [catch {mql unlock bus $xAutoNamer(STATEOID)} err]
					puts "Debugger: Autonamer UNLOCKED for this process: $xAutoNamer(STATEOID) - DONE!"
					
					break;
				} else {
					#~ autoname object locked by another process, wait iRetryDelay seconds
					puts "Debugger: Autonamer is LOCKED wait iRetryDelay: $xAutoNamer(STATEOID) "
					after $iRetryDelay
				}
			}; #~endForeach

		} else {
			#~ error no name generator
			set xAutoNameGenerator(0) [::xUtil::errMsg 42 "No Autonamer for: $sType $sName $sRev"]
			set xAutoNameGenerator(0) $::FALSE
		}
		
		#set x [catch {mql unlock bus $xAutoNamer(STATEOID)} err]
		#puts "Debugger: BACKUP Autonamer UNLOCKED for this process: $xAutoNamer(STATEOID) - DONE!"
		#~ returns: 
		#~   xAutoNameGenerator(0)=TRUE/FALSE 
		#~   xAutoNameGenerator(NAME)=Generated Name 
		#~   xAutoNameGenerator(NEXTVALUE)=Next number in sequence that "eService Number Generator" type_DOCUMENTS is set o
		return [array get xAutoNameGenerator]
	}

	namespace export  autoNameGenerator ;


}; #~endNamespace:xAutonamer

