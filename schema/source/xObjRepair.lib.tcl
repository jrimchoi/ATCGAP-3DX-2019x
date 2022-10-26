# @Program = xObjRepair.lib.tcl


# businessobject MS Excel Document G-0000005727 20
# attribute[gapLegacyPDMIdentifier].value = 12000398-671 SAP SPARE PRS.XLS
# attribute[gapLegacyRevision].value = T v1
# attribute[gapLegacyPrevRev].value =
# attribute[gapLegacyNextRev].value =

# STEPS:
# 1. find obj that has possible rev chain issue
# 2. eval NEXTREV/PREVREV attr. If not null, then proceed
# 3. validate if NEXTREV/PREVREV are not part of REV chain
# 4. validate that NEXTREV/PREVREV objs DO exist
# 5. run function: updateObjectRevisionSequence2 sType sName sRev sPrevRev sNextRev


# @NAMESPACE::xObjInspector - implements utilities for reporting on business objects in Matrix
namespace eval ::xObjRepair {

	proc init {} {
	}

	proc xObjRepair {sType sName sRev {oID ""} {sPolicy ""}} {
		
		if {[::xUtil::isNull "$oID"] == $::TRUE} {
			set oID [::xBO::getBOID "$sType" "$sName" "$sRev"]
		} 
		if {[::xUtil::isNull "$sPolicy"] == $::TRUE} {
			set x [catch {mql print bus $oID select policy dump} err]
			if {$x == 0} {
				set sPolicy $err
			} else {
				return [::xUtil::errMsg 26 "$err"]
			}
		}
		
		#~ revision chain repair ...
		set x [::xObjRepair::ObjRevisionChainRestoration "$sType" "$sName" "$sRev" "$oID" "$sPolicy" ]

		#~ objects with same Legacy number but diff G-######
		

		#~ repair Workspace/Folder structure

		if {$::REPORTOBJSTATUS == $::TRUE} {
			append sLogName [join [list "$sType" "$sName" "$sRev"] "-"] ".log"
			set fLog [file join $::REPORTPATH $sLogName]

			switch $::REPORTVERBOSITY {
				0 {
					#~ do nothing
				};

				1 {
					set x [::xObjInspector::inspectBusinessObject $oID $fLog]
				};

				2 {
					set x [::xObjInspector::inspectBusinessObject $oID $fLog]
					set x [::xObjInspector::inspectEnvironment $fLog]
				};

				3 {
					set x [::xObjInspector::inspectBusinessObject $oID $fLog]
					set x [::xObjInspector::inspectEnvironment $fLog]
					set x [::xObjInspector::inspectCommands $fLog]
				};

				default {
					#~ do nothing
				};
			}; #~endSwitchCase
			
		}

	}

	proc ObjRevisionChainRestoration {sType sName sRev oID sPolicy} {
		#~~~~
		#~ get current rev chain from the object, verify that if sRev is the 1st rev
		#~ get rev chain information from current obj for Next/Prev rev 
		set sPolicyRevSeq [mql print policy "$sPolicy" select revision dump]
		set lRevSeq [split $::XREVSEQ($sPolicyRevSeq) ,]
		set sFirstRev [lindex $lRevSeq 0]
		set sLastRev  [lindex $lRevSeq end-1]

		if {[string match "$sRev" "$sFirstRev"] == 1} {
			#~ sRev is first rev of policy sequence
			set iObjPrevRev 2
		} else {
			#~ if there is no Prev rev in obj rev chain
			set lRevs [split [mql print bus $oID select previous.revision dump |] |]
			set sObjPrevRev [lindex $lRevs 0]
				set iObjPrevRev 0
				if {[::xUtil::isNull "$sObjPrevRev"] != $::TRUE} {
					set iObjPrevRev 1
				}
		}

		if {[string match "$sRev" "$sLastRev"] == 1} {
			#~ sRev is first rev of policy sequence
			set iObjNextRev 2
		} else {
			set lRevs [split [mql print bus $oID select next.revision dump |] |]
			set sObjNextRev [lindex $lRevs 0]
				#~ if there is no Next rev in obj rev chain
				set iObjNextRev 0			
				if {[::xUtil::isNull "$sObjNextRev"] == $::FALSE} {
					set iObjNextRev 1
				}
		}

		#~ get Next/Prev rev attributes from current obj - Product Center XML Metadata
		set sAttrNextRev [::xBO::getBOAttributeValue $oID gapLegacyNextRev]
		set sAttrPrevRev [::xBO::getBOAttributeValue $oID gapLegacyPrevRev]
			set iAttrNextRev  $::FALSE
			set iAttrPrevRev  $::FALSE
			if {$sAttrNextRev != $::FALSE || $sAttrNextRev != $::ERROR } {
				set iAttrNextRev  $::TRUE
			}
			if {$sAttrPrevRev != $::FALSE || $sAttrPrevRev != $::ERROR} {
				set iAttrPrevRev  $::TRUE
			}

		#~ get Next/Prev sequence values from policy 1=next(default) -1=prev
		# set sPolicyNextRev [::xBO::getNextRevision "$sPolicy" $sRev 1]
		# set sPolicyPrevRev [::xBO::getNextRevision "$sPolicy" $sRev -1]
			# set iPolicyNextRev $::FALSE
			# set iPolicyPrevRev $::FALSE
			# if {$sPolicyNextRev == $::FALSE || $sPolicyNextRev == $::ERROR } {
				# set iPolicyNextRev $::TRUE
			# }
			# if {$sPolicyPrevRev == $::FALSE || $sPolicyPrevRev == $::ERROR} {
				# set iPolicyPrevRev $::TRUE
			# }

		#~ validate if the Next/Prev rev obj exists to prepare revision resequencing 
		set bPrevRevExist [::xBO::getBOExist "$sType" "$sName" "$sAttrPrevRev"]
		set bNextRevExist [::xBO::getBOExist "$sType" "$sName" "$sAttrNextRev"]
			if {$bNextRevExist == $::TRUE} {
				set iNextRevExist $::TRUE
			} else {
				set iNextRevExist $::FALSE
			}
			if {$bPrevRevExist == $::TRUE} {
				set iPrevRevExist $::TRUE
			} else {
				set iPrevRevExist $::FALSE
			}

		#~ if Obj next/prev rev is null AND the obj attribute gapLegacyPrevRev/NextRev has a value AND the prev/next rev object EXISTS
		#~ iObjPrevRev == 0 - means that no detected Prev Rev in rev chain (1=prevrev or 2 = 1st rev)
		#~ iAttrPrevRev == TRUE - means that the PrevRev attribute did have a value for PrevRev
		#~ iPrevRevExist == TRUE - means that an obj exists as T N PrevRev
		
		if {$iObjPrevRev == 0 && $iAttrPrevRev == $::TRUE && $iPrevRevExist == $::TRUE} {
			set sPrevRev $sAttrPrevRev
		} else {
			set sPrevRev ""
		}
		if {$iObjNextRev == 0 && $iAttrNextRev == $::TRUE && $iNextRevExist == $::TRUE} {
			set sNextRev $sAttrNextRev
		} else {
			set sNextRev ""
		}

		if {[::xUtil::isNull "$sPrevRev"] == $::FALSE || [::xUtil::isNull "$sNextRev"] == $::FALSE} {
			set x [::xUtil::appendFile "REPAIRS-APPLIED:: $sType $sName $sRev - ${sPrevRev}/${sNextRev}" "$::GLOBALLOG"]
			
			#~ update the current object revision sequence
			#set lObjByAllRevs2 [::xBO::updateObjectRevisionSequence2 "$sType" "$sName" "$sRev" "$sPrevRev" "$sNextRev"]
			set lObjByAllRevs2 [::xBO::updateObjectRevisionSequence2 "$sType" "$sName" "$sRev" "$sPrevRev" ""]

			#~ if above operations successful, NULL gapLegacyPrevRev
			if {[::xBO::setBOAttributeValue $oID "gapLegacyPrevRev" ""] != $::TRUE} {
				set xupdateBusinessObjectAttributes(0)  [::xUtil::errMsg 28 "updateBusinessObjectAttributes(): $oID $sAttributeName = $sAttributeValue"]
			}
			#~ if above operations successful, NULL gapLegacyNextRev
			if {[::xBO::setBOAttributeValue $oID "gapLegacyNextRev" ""] != $::TRUE} {
				set xupdateBusinessObjectAttributes(0)  [::xUtil::errMsg 28 "updateBusinessObjectAttributes(): $oID $sAttributeName = $sAttributeValue"]
			}
		} else {
			set x [::xUtil::appendFile "REPAIRS-PASSED:: $sType $sName $sRev - ${sPrevRev}/${sNextRev}" "$::GLOBALLOG"]

			#~ all null
			if {$iObjPrevRev == $::TRUE && [string match "$sObjPrevRev" "$sAttrPrevRev"] == 1} {
				#~ if obj was found with correct rev seq, NULL gapLegacyPrevRev
				if {[::xBO::setBOAttributeValue $oID "gapLegacyPrevRev" ""] != $::TRUE} {
					set xupdateBusinessObjectAttributes(0)  [::xUtil::errMsg 28 "updateBusinessObjectAttributes(): $oID $sAttributeName = $sAttributeValue"]
				}
			}
			if {$iObjNextRev == $::TRUE && [string match "$sObjNextRev" "$sAttrNextRev"] == 1} {
				#~ if obj was found with correct rev seq, NULL gapLegacyPrevRev
				if {[::xBO::setBOAttributeValue $oID "gapLegacyNextRev" ""] != $::TRUE} {
					set xupdateBusinessObjectAttributes(0)  [::xUtil::errMsg 28 "updateBusinessObjectAttributes(): $oID $sAttributeName = $sAttributeValue"]
				}
			}
		}
	}


	#~ findOtherObjectsByAttribute gapGAPSpecification gapLegacyPDMIdentifier 671A52.XLS "Part Specification"
	proc findOtherObjectsByAttribute {sType sAttrName sAttrValue sPolicy {sVault "eService Production"}} {
		set xfindOtherObjectsByAttribute(0) $::FALSE
		set iObjCntr 0
		set x [catch {mql temp query bus "$sType" * * vault "$sVault" notexpandtype where "attribute\[${sAttrName}\].value smatch \"${sAttrValue}\"" select policy id dump |} err]
		if {$x == 0} {
			foreach iObj [split [mql temp query bus "$sType" * * vault "$sVault" notexpandtype where "attribute\[${sAttrName}\].value smatch \"${sAttrValue}\"" select policy id dump |] \n] {
				#~ validate matching policies
				set xName   [lindex [split $iObj |] 1]
				set xRev    [lindex [split $iObj |] 2]
				set xPolicy [lindex [split $iObj |] 3]
				set xOID    [lindex [split $iObj |] 4]
				if {[string match -nocase [string toupper "$sPolicy"] [string toupper "$xPolicy"]] == 1} {
					set xfindOtherObjectsByAttribute(0) $::TRUE
					lappend xfindOtherObjectsByAttribute(TYPE) "$sType"
					lappend xfindOtherObjectsByAttribute(NAME) "$xName"
					lappend xfindOtherObjectsByAttribute(REV)  "$xRev"
					lappend xfindOtherObjectsByAttribute(OID)  "$xOID"
				}
			}
		} else {
			set xfindOtherObjectsByAttribute(0) [::xUtil::errMsg 60 "findOtherObjectsByAttribute() - unhandeled illegal character in search params"]
		}
		return [array get xfindOtherObjectsByAttribute]
	}


}; #~endNameSpace

