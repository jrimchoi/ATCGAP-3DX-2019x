# @PROGDOC: xBO class library to implement Business Object creation and manipulation methods
# @Namespace/Class =  xBO
# @Methods =
# @Properties =
# @Program =  xBO_v17.lib.tcl
# @Version  = 17.0
# @Synopsis = implementation main thread
# @Purpose = to provide methods/properties for
# @Implementation = source x.tcl
# @Package =
# @Object = 

###############################################################################
#~ Log event headers
set HISTEVENT(0)  "MIGRATION.CREATE"
set HISTEVENT(1)  "MIGRATION.UPDATE"
set HISTEVENT(2)  "MIGRATION.CHECKIN"
set HISTEVENT(3)  "MIGRATION.CONNECT"

set HISTEVENT(98)  "MIGRATION.CUSTOM"
set HISTEVENT(99) "MIGRATION.ERROR"
###############################################################################

################################################################################
######## Module Package Management - load libraries ############################

package provide xBO

array set xLibrary [::xLib::FindLib "xUtil.lib.tcl"]
if {[array get xLibrary STATUS] == $::ERROR }  {
   puts "ERROR:: $::ERRCODES(998) - Library path $sLibraryPath"
   #exit $::ERROR
}
package ifneeded xUtil 1.0 [list source [lindex [array get xLibrary LIBFILEPATH] 1]]

package require xUtil
################################################################################


# @NAMESPACE::xBO - implements utilities for creation and manipulation of business objects in Matrix
namespace eval ::xBO {

	proc init {} {
	}

	# @Method(global): ::xBO::verifyBusinessObjectHasFile(oID) - returns boolean TRUE if BO contains at least 1 file
	proc verifyBusinessObjectHasFile {oID} {
		set bVerifyBusinessObjectHasFile $::FALSE

		set x [mql print businessobject $oID select format.hasfile dump]
		if {[string compare "$x" "TRUE"] == 0} {
			set bVerifyBusinessObjectHasFile $::TRUE
		}
		return $bVerifyBusinessObjectHasFile
	}

	# @Method(global): ::xBO::getBOExist(sType sName sRev) - returns boolean TRUE if BO exists
	proc getBOExist { sType sName sRev } {
		set xBOExists [mql print bus "$sType" "$sName" "$sRev" select exists dump]
		if {"$xBOExists" == "TRUE"} {
			set bExists $::TRUE
		} elseif {"$xBOExists" == "FALSE"} {
			set bExists $::FALSE
		} else {
			set bExists $::ERR
		}
		return $bExists
	}

	# @Method(global): ::xBO::getBOID(sType sName sRev) - returns object ID, else boolean ERROR if BO doese not exist
	proc getBOID { sType sName sRev } {
		if {[getBOExist "$sType" "$sName" "$sRev"] == $::TRUE} {
			set oBOID [mql print bus "$sType" "$sName" "$sRev" select ID dump];
		} else {
			set oBOID $::ERR
		}
		return $oBOID
	}

	proc findObjects { sType sName sRev } {
		set xfindObjects(0) $::FALSE
		foreach iObj [split [mql temp query bus "$sType" "$sName" "$sRev" select id dump |] \n] {
			array set xfindObjects [list [incr xfindObjects(0)] [split $iObj |]]
		}
		return [array get xfindObjects]
	}

	proc findOtherObjectsByFilename {sType sFilenameBasename sFileExtension {sFormat ""}} {
		#~ search by Filename
		set sfindOtherObjectsByFilename ""
		if {"$sFormat" == ""} {
			set lObj [split [mql temp query bus "$sType" * * notexpandtype where "format.file.name ~= \"*${sFilenameBasename}*.${sFileExtension}\""                 select id format.file.name dump |] \n]
		} else {
			set lObj [split [mql temp query bus "$sType" * * notexpandtype where "format\[${sFormat}\].file.name ~= \"*${sFilenameBasename}*.${sFileExtension}\""   select id format\[generic\].file.name dump |] \n]
		}
		#~ get only the sFileExtension file to return
		foreach iObj $lObj {
			set s1Type [lindex [split $iObj |] 0]
			set s1Name [lindex [split $iObj |] 1]
			set s1Rev  [lindex [split $iObj |] 2]
			set o1ID   [lindex [split $iObj |] 3]
			set l1File [lrange [split $iObj |] 4 end]
			set s1File ""
			foreach iFile $l1File {
				set s1FilenameObjType  [lindex [split [file rootname  $iFile] _] 0]
				set s1FilenameBasename [file rootname  $iFile]
				set s1FilenameBaseRev  [lindex [split [file rootname  $iFile] _] 2]
				set s1FilenameBaseVer  [lindex [split [file rootname  $iFile] _] 3]
				#~ s1FileExtension should always be XML
				set s1FileExtension    [lindex [split [file extension $iFile] .] 1]
				#puts "$s1FilenameObjType $s1FilenameBasename $s1FilenameBaseRev $s1FileExtension"
				if {[string compare "$sType" "$s1Type"] == 0 && \
					[string compare "$sFilenameBasename" "$s1FilenameBasename"] == 0 && \
					[string compare "$sFileExtension" "$s1FileExtension"] == 0 } {
					set s1File $iFile
					if {[::xUtil::isNull "$sfindOtherObjectsByFilename"] != $::TRUE} {
						append sfindOtherObjectsByFilename "\n"
					}
					append sfindOtherObjectsByFilename "$s1Type" "|" "$s1Name" "|" "$s1Rev" "|" "$o1ID" "|" "$s1File"
					break;
				}
			}
		}
		return "$sfindOtherObjectsByFilename"
	}

	# mql temp query bus Document * * vault "eService Production" vault "eService Production" where 'attribute\[gapLegacyPDMIdentifier\].value smatch \"1021 Skid Calcs Rev 1.0.xls\"'
	# Document|G-000000004|0|Document Release|7124.52964.18464.48818
	# Document|G-000000004|1|Document Release|7124.52964.62756.5008
	# Document|G-000000004|2|Document Release|7124.52964.6292.64306
	# 0 1 OID {7124.52964.18464.48818 7124.52964.62756.5008 7124.52964.6292.64306} REV {0 1 2} NAME {G-000000004 G-000000004 G-000000004} TYPE {Document Document Document}
	proc findOtherObjectsByLegacyName {sType sLegacyName sPolicy {sVault "eService Production"} {sLegacyIdentifier "gapLegacyPDMIdentifier" }} {
		set xfindOtherObjectsByLegacyName(0) $::FALSE
		set iObjCntr 0
		set x [catch {mql temp query bus "$sType" * * vault "$sVault" notexpandtype where "attribute\[${sLegacyIdentifier}\].value smatch \"$sLegacyName\"" select policy id dump |} err]
		if {$x == 0} {
			foreach iObj [split [mql temp query bus "$sType" * * vault "$sVault" notexpandtype where "attribute\[${sLegacyIdentifier}\].value smatch \"$sLegacyName\"" select policy id dump |] \n] {
				#~ validate matching policies
				set xName   [lindex [split $iObj |] 1]
				set xRev    [lindex [split $iObj |] 2]
				set xPolicy [lindex [split $iObj |] 3]
				set xOID    [lindex [split $iObj |] 4]
				if {[string match -nocase [string toupper "$sPolicy"] [string toupper "$xPolicy"]] == 1} {
					#~policy of propose object and matching gapLegacyPDMIdentifier are the same, use this name, and revise
					set xfindOtherObjectsByLegacyName(0) $::TRUE
					lappend xfindOtherObjectsByLegacyName(TYPE) "$sType"
					lappend xfindOtherObjectsByLegacyName(NAME) "$xName"
					lappend xfindOtherObjectsByLegacyName(REV)  "$xRev"
					lappend xfindOtherObjectsByLegacyName(OID)  "$xOID"
				}
			}
		} else {
			set xfindOtherObjectsByLegacyName(0) [::xUtil::errMsg 60 "findOtherObjectsByLegacyName() - unhandeled illegal character in search params"]
		}
		return [array get xfindOtherObjectsByLegacyName]
	}

	proc findOtherObjectsByRevision { sType sName sPolicy} {
		foreach iObj [split [mql temp query bus "$sType" "$sName" * select policy id dump |] \n] {
			set xName   [lindex [split $iObj |] 1]
			set xRev    [lindex [split $iObj |] 2]
			set xPolicy [lindex [split $iObj |] 3]
			set xOID    [lindex [split $iObj |] 4]
			if {[string match -nocase [string toupper "$sPolicy"] [string toupper "$xPolicy"]] == 1} {
				lappend xfindOtherObjectsByRevision $iObj
			}
		}
		return $xfindOtherObjectsByRevision
	}

	#~ Supported Rev Sequence formats:
	#~	A,B,C,D,E,F,G,H,J,K,P,R,T,U,V,W,X,Y - range of explicit members
	#~	A-Z - range of inclusive members
	#~	0,1,2... - elipsis indicates implied continuation of members per pattern
	#~	A-Z,AA-ZZ - indicates ranges of inclusive members in a continuation of members
	#~ iterates through the REVSEQ array, matching patterns as far as the Policy Rev Seq goes
	#~ returns the REVSEQ array index for the pattern to be used

	#~ REVSEQ(0) "0,1,2,...,27"
	#~ REVSEQ(1) "A,B,C,...,Z"	  
	proc getPolicyRevisionSequenceIdx {sPolicy} {
		set igetPolicyRevisionSequence -1
		set sPolicyRevSeqDef [split [mql print policy "$sPolicy" select revision dump] ,]
		set sPolicyRevSeqPattern [lrange $sPolicyRevSeqDef 0 [expr [lsearch $sPolicyRevSeqDef "..."] - 1]]
		set iSrchLimit [llength $sPolicyRevSeqPattern]
		set iSrchCntr 0
		for {set i 0} {$i <= [expr [array size ::REVSEQ] -1]} {incr i} {
			set lCurrentRevSeqPattern [split [lindex [array get ::REVSEQ $i] 1] ,]
			foreach iPolicyRevSeqPattern $sPolicyRevSeqPattern {
				#puts "searching for: $iPolicyRevSeqPattern in $lCurrentRevSeqPattern"
				if {[lsearch $lCurrentRevSeqPattern $iPolicyRevSeqPattern] > -1} {
					incr iSrchCntr
				}
			}
			#puts "$iSrchCntr == $iSrchLimit"
			if {$iSrchCntr == $iSrchLimit} {
				#~ pattern has been validated, break loop, and return TRUE indicating
				#puts "Found IT!"
				set igetPolicyRevisionSequence $i
				break;
			} else {
				#puts "still going: $iSrchCntr"
			}
		}
		return $igetPolicyRevisionSequence
	}


	#~ XREVSEQ(A-Z) "A,B,C,...,Z"
	#~ XREVSEQ(0-9) "0,1,2,3,4,5,6,7,8,9"
	#~ XREVSEQ(0,1,2...) "0,1,2,3,4,5,6,7,8,9,...,500"
	#~ XREVSEQ(A-Z,AA-ZZ) "A,B,C,...,Z,AA,AB,AC,...ZZ"
	proc getPolicyRevisionSequenceIdx2 {sPolicy} {
		set igetPolicyRevisionSequenceIdx2 $::FALSE
		set sPolicyRevSeqDef [mql print policy "$sPolicy" select revision dump]
		if {[::xUtil::isNull [array names ::XREVSEQ "$sPolicyRevSeqDef"]] != $::TRUE} {
			#~found rev seq pattern in XREVSEQ array
			set igetPolicyRevisionSequenceIdx2 "$sPolicyRevSeqDef"
		} 			
		return $igetPolicyRevisionSequenceIdx2
	}

	proc getPolicyRevisionSequence {sPolicy} {
		set sgetPolicyRevisionSequence $::FALSE
		set iREVSEQidx [::xBO::getPolicyRevisionSequenceIdx "$sPolicy"]
		if {$iREVSEQidx != -1} {
			#~ Policy rev seq OK, get index of current rev, then get next
			set sgetPolicyRevisionSequence [split [lindex [array get ::REVSEQ $iREVSEQidx] 1] ,]
		} else {
			#~ could not get rev seq
			set sgetPolicyRevisionSequence [::xUtil::errMsg 46 "Could not get revision sequnce for policy $sPolicy"]
		}
		return "$sgetPolicyRevisionSequence"
	}

	proc getPolicyRevisionSequence2 {sPolicy} {
		set sgetPolicyRevisionSequence $::FALSE
		set iREVSEQidx [::xBO::getPolicyRevisionSequenceIdx2 "$sPolicy"]
		if {$iREVSEQidx != -1} {
			#~ Policy rev seq OK, get index of current rev, then get next
			set sgetPolicyRevisionSequence [split [lindex [array get ::XREVSEQ $iREVSEQidx] 1] ,]
		} else {
			#~ could not get rev seq
			set sgetPolicyRevisionSequence [::xUtil::errMsg 46 "Could not get revision sequnce for policy $sPolicy"]
		}
		return "$sgetPolicyRevisionSequence"
	}
	  

	#~ validates the REV sent is in the revision sequence of the  POLICY
	proc validateObjectRevisionSequence {sPolicy sRev} {
		set bvalidateObjectRevisionSequence $::FALSE
		set iREVSEQidx [::xBO::getPolicyRevisionSequenceIdx2 "$sPolicy"]
		if {$iREVSEQidx == 0} {
			set iREVSEQidx [::xBO::getPolicyRevisionSequenceIdx "$sPolicy"]
		}
		if {$iREVSEQidx != -1 && $iREVSEQidx != 0} {
			#~ now validate the sRev
			if {[lsearch [split [lindex [array get ::REVSEQ $iREVSEQidx] 1] ,] "$sRev"] != -1} {
				set bvalidateObjectRevisionSequence $::TRUE
			} elseif {[lsearch [split [lindex [array get ::XREVSEQ $iREVSEQidx] 1] ,] "$sRev"] != -1} {
				set bvalidateObjectRevisionSequence $::TRUE
			} else {
				set bvalidateObjectRevisionSequence [::xUtil::errMsg 46 "revision $sRev not part of sequence for policy $sPolicy"]
			}
		} else {
			#~ was not able to resolve a full Rev Seq patter from policy to REVSEQ, an error
			set bvalidateObjectRevisionSequence [::xUtil::errMsg 46 "could not verify revision sequence for policy $sPolicy"]
		}
		return $bvalidateObjectRevisionSequence
	}

	proc getAllBusinessObjectRevisionsByQuery {sType sName sRev sPolicy} {
		set lgetAllBusinessObjectRevisions(0) $::FALSE
		set lRevs {}
		foreach iObj [split [mql temp query bus "$sType" "$sName" * notexpandtype select id policy dump |] \n] {
			set xPolicy [lindex [split $iObj |] 4]
			set xRev [lindex [split $iObj |] 2]
			puts "$iObj\nxPolicy=$xPolicy & xRev=$xRev"
			if {[string compare -nocase "$sPolicy" "$xPolicy"] >= 0} {
				lappend lRevs "$xRev"
			}
		}
		set lgetAllBusinessObjectRevisions(0) [lsearch -exact $lRevs $sRev] 
		set lgetAllBusinessObjectRevisions(REVS) $lRevs
		return [array get lgetAllBusinessObjectRevisions]
	}

	#~ getNextRevision(sPolicy sRev sNext) - if sRev is valid for sPolicy, return next rev if sNext=1, else if sNext=0, get prev rev
	proc getNextRevision {sPolicy sRev {iNext 1}} {
		set sgetNextRevision $::FALSE
		#~ method 1 - lookup based on predefined REV sequences 
		if {[::xBO::validateObjectRevisionSequence "$sPolicy" "$sRev"] == $::TRUE} {
			set iREVSEQidx [::xBO::getPolicyRevisionSequenceIdx2 "$sPolicy"]
			if {$iREVSEQidx != 0} {
				set lRevSeq [split [lindex [array get ::XREVSEQ $iREVSEQidx] 1] ,]
					if {$iNext == 1} {
						#~ Next revision
						set sNextRev [lindex $lRevSeq [expr [lsearch $lRevSeq $sRev] + 1]]
					} else {
						#~ Previous revision
						set sNextRev [lindex $lRevSeq [expr [lsearch $lRevSeq $sRev] - 1]]
					}
				if {[::xUtil::isNull "$sNextRev"] != $::TRUE} {
					set sgetNextRevision "$sNextRev"
				} else {
					set sgetNextRevision [::xUtil::errMsg 47 "Rev = $sRev, Policy $sPolicy rev sequence = $lRevSeq"]
				}
			} else {
				set iREVSEQidx [::xBO::getPolicyRevisionSequenceIdx "$sPolicy"]
				if {$iREVSEQidx != -1} {
					#~ Policy rev seq OK, get index of current rev, then get next
					set lRevSeq [split [lindex [array get ::REVSEQ $iREVSEQidx] 1] ,]
					set sNextRev [lindex $lRevSeq [expr [lsearch $lRevSeq $sRev] + 1]]
						if {$iNext == 1} {
							#~ Next revision
							set sNextRev [lindex $lRevSeq [expr [lsearch $lRevSeq $sRev] + 1]]
						} else {
							#~ Previous revision
							set sNextRev [lindex $lRevSeq [expr [lsearch $lRevSeq $sRev] - 1]]
						}
					if {[::xUtil::isNull "$sNextRev"] != $::TRUE} {
						set sgetNextRevision "$sNextRev"
					} else {
						#error - NEXT REV is past end of sequence
						set sgetNextRevision [::xUtil::errMsg 47 "Rev = $sRev, Policy $sPolicy rev sequence = $lRevSeq"]
					}
				} else {
					#error - bad rev sequence array index
					set sgetNextRevision [::xUtil::errMsg 47 "Could not identify reg sequnce: Rev = $sRev, Policy $sPolicy"
				}
			}
		} else {
			#error - REV not found in Policy revision sequence
			set sgetNextRevision [::xUtil::errMsg 47 "could not find Rev = $sRev in Policy $sPolicy" rev sequence]
		}
		return $sgetNextRevision
	}

	proc updateObjectRevisionSequence {sType sName sRev s2Type s2Name s2Rev} {
		set bupdateObjectRevisionSequence $::FALSE
		set x [catch {mql revise businessobject "$sType" "$sName" "$sRev" businessobject "$s2Type" "$s2Name" "$s2Rev"} err]
		if {$x != 0} {
			#~ revise bus failed, likely source businessobject is not revisable
			set bupdateObjectRevisionSequence [::xUtil::errMsg 45 "$sType $sName $sRev --> $s2Type $s2Name $s2Rev - $err"]
		} else {
			set bupdateObjectRevisionSequence $::TRUE
		}
		return $bupdateObjectRevisionSequence 
	}

	proc updateObjectRevisionSequence2 {sType sName sRev sPrevRev sNextRev} {
		set bupdateObjectRevisionSequence $::FALSE

		set bPrevRevExist [::xBO::getBOExist "$sType" "$sName" "$sPrevRev"]
		set bNextRevExist [::xBO::getBOExist "$sType" "$sName" "$sNextRev"]

		if {$bPrevRevExist == $::TRUE} {
			set x [catch {mql revise businessobject "$sType" "$sName" "$sPrevRev" businessobject "$sType" "$sName" "$sRev"} err]
			if {$x != 0} {
				#~ revise bus failed, likely source businessobject is not revisable
				set bupdateObjectRevisionSequence [::xUtil::errMsg 45 "$sType $sName $sPrevRev --> $sType $sName $sRev - $err"]
			} else {
				#~ remove previous revision VAULTED OBJECTS relationship to folder if it exists:
				set bupdateObjectRevisionSequence $::TRUE
			}
		}
		if {$bNextRevExist == $::TRUE} {
			set x [catch {mql revise businessobject "$sType" "$sName" "$sRev" businessobject "$sType" "$sName" "$sNextRev"} err]
			if {$x != 0} {
				#~ revise bus failed, likely source businessobject is not revisable
				set bupdateObjectRevisionSequence [::xUtil::errMsg 45 "$sType $sName $sRev --> $sType $sName $sNextRev - $err"]
			} else {
				set bupdateObjectRevisionSequence $::TRUE
			}
		}
		return $bupdateObjectRevisionSequence 
	}


	  
	# @Method(global): ::xBO::updateBusinessObjectDescription(oID sAttrValue4 iAppend) - updates businessobject description with sAttrValue4. if iAppend=0 then replace, if iAppend=1 append after newline (default)
	proc updateBusinessObjectDescription {oID sAttrValue {iAppend 1}} {
		set bupdateBusinessObjectDescription $::FALSE

		regsub -all -- "\%7C"  "$sAttrValue" "|"  sAttrValue1
		regsub -all -- "\%20"  "$sAttrValue1" " "  sAttrValue2
		regsub -all -- "\%0A"  "$sAttrValue2" "\n" sAttrValue3
		regsub -all -- "\%3A"  "$sAttrValue3" ":"  sAttrValue4
		regsub -all -- "\%91"  "$sAttrValue4" "\\\["  sAttrValue5
		regsub -all -- "\%93"  "$sAttrValue5" "\\\]"  sAttrValue6

		if {$iAppend == 1} {
			set x [catch {mql print businessobject $oID select description dump} sDesc]
			if {$x == 0} {
				append sDesc "\n" [subst "$sAttrValue6"]
			}
		} else {
			set sDesc [subst "$sAttrValue6"]
		}
		puts "updateBusinessObjectDescription() sDesc = $sDesc"

		set x [catch {mql modify businessobject $oID description "$sDesc"} err]
		if {$x > 0} {
			set bupdateBusinessObjectDescription  [::xUtil::errMsg 43 "updateBusinessObjectDescription(): $oID description = $xDesc ~ error: $err"]
		} else {
			set bupdateBusinessObjectDescription $::TRUE
		}
		return $bupdateBusinessObjectDescription
	}

	# @Method(global): ::xBO::updateBusinessObjectAttributes(oID lAttributeNameValuePairs) - this command iteratively calls setBOAttributeValue(oID sAttributeName xAttributeValue) to update object attribute values from Name=Value pairs in list of attributes
	proc updateBusinessObjectAttributes {oID lAttributeNameValuePairs} {
		puts "Object to be updated: [mql print bus $oID select type name revision]"
		puts "Attributes to be updated:"
		foreach iattr $lAttributeNameValuePairs { puts "$iattr"}

		set xupdateBusinessObjectAttributes(0) $::FALSE
		foreach iAttr $lAttributeNameValuePairs {
				puts "... processing: $iAttr"
				set sAttributeName  [lindex [split $iAttr $::cPAIRDELIM] 0]
				set sAttributeValue [lindex [split $iAttr $::cPAIRDELIM] 1]
				if {[::xBO::setBOAttributeValue $oID "$sAttributeName" "$sAttributeValue"] != $::TRUE} {
					set xupdateBusinessObjectAttributes(0)  [::xUtil::errMsg 28 "updateBusinessObjectAttributes(): $oID $sAttributeName = $sAttributeValue"]
					set xupdateBusinessObjectAttributes($sAttributeName) "$sAttributeValue"
					#~ stop processing other attributes on error
					break;
				} else {
					set xupdateBusinessObjectAttributes(0) $::TRUE
					set xupdateBusinessObjectAttributes($sAttributeName) "$sAttributeValue"
				}
			}
		return [array get xupdateBusinessObjectAttributes]
	}

	proc updateBusinessObjectAttributes2 {oID lAttributeNameValuePairs} {
		puts "Object to be updated: [mql print bus $oID select type name revision]"
		regsub -all -- "\%7C"  "$lAttributeNameValuePairs" "|"  sAttrValue1
				regsub -all -- "\%20"  "$sAttrValue1" " "  sAttrValue2
				regsub -all -- "\%0A"  "$sAttrValue2" "\n" sAttrValue3
				regsub -all -- "\%3A"  "$sAttrValue3" ":"  sAttrValue4
				regsub -all -- "\%33"  "$sAttrValue4" "\""  sAttrValue5
				regsub -all -- "\%39"  "$sAttrValue5" "\'"  sAttrValue6

		puts "Attributes to be updated:"
		foreach iattr $lAttributeNameValuePairs { puts "$iattr"}

		set xupdateBusinessObjectAttributes(0) $::FALSE
		foreach iAttr $lAttributeNameValuePairs {
				puts "... processing: $iAttr"
				set sAttributeName  [lindex [split $iAttr $::cPAIRDELIM] 0]
				set sAttributeValue [lindex [split $iAttr $::cPAIRDELIM] 1]
				if {[::xBO::setBOAttributeValue2 $oID "$sAttributeName" "$sAttributeValue"] != $::TRUE} {
					set xupdateBusinessObjectAttributes(0)  [::xUtil::errMsg 28 "updateBusinessObjectAttributes(): $oID $sAttributeName = $sAttributeValue"]
					set xupdateBusinessObjectAttributes($sAttributeName) "$sAttributeValue"
					#~ stop processing other attributes on error
					break;
				} else {
					set xupdateBusinessObjectAttributes(0) $::TRUE
					set xupdateBusinessObjectAttributes($sAttributeName) "$sAttributeValue"
				}
			}
		return [array get xupdateBusinessObjectAttributes]
	}


	proc findCollaborativeSpace {{sCollaborativeSpace "*"}} {
		return [split [mql temp query bus PnOProject ${sCollaborativeSpace} * select owner vault policy current id dump |] \n]
	}

	  
	proc validateCollaborativeSpace {sCollaborativeSpace} {
		set xvalidateCollaborativeSpace(0) $::FALSE
		foreach iCollaborativeSpace [::xBO::findCollaborativeSpace "$sCollaborativeSpace"] {
			foreach {t n r o v p s oID} [split $iCollaborativeSpace |] { break; }
			if {[string compare $r '-'] == 1} {
				set xvalidateCollaborativeSpace(oID) $oID
				set xvalidateCollaborativeSpace(0) $::TRUE
			}
		}
		return [array get xvalidateCollaborativeSpace]
	}

	proc updateOrganization {oID sOrganization} {
		#~set organization property of Object
		set bupdateOrganization $::FALSE
		set x [catch {mql mod bus $oID organization "$sOrganization"} err]
		if {$x != 0} {
			set bupdateOrganization [::xUtil::errMsg 250 "$oID organization $sOrganization : $err"]
		} else {
			set bupdateOrganization $::TRUE
		}
		return $bupdateOrganization
	}
	  
	# @Method(global): ::xBO::updateCollaborativeSpace(oID sCollaborativeSpace) - 
	proc updateCollaborativeSpace { oID sCollaborativeSpace } {
		set xUpdateCollaborativeSpace(0) $::FALSE
		array set xValidCS [::xBO::validateCollaborativeSpace "$sCollaborativeSpace"]
		if {$xValidCS(0) == $::TRUE} {
			set x [catch {mql modify businessobject $oID "project" "$sCollaborativeSpace"} xErr]
			::xUtil::dbgMsg "modify businessobject $oID project $sCollaborativeSpace - result = $xErr"
			if {$x != 0} {
				set xUpdateCollaborativeSpace(0) [::xUtil::errMsg 36 "updateCollaborativeSpace() - could not set CollaborativeSpace : [mql print bus $oID select type name revision dump]" "- $xErr"]
			} else {
				#~ updateCollaborativeSpace successful
				set xUpdateCollaborativeSpace(0) $::TRUE
				set xUpdateCollaborativeSpace(oID) [lindex [array get xValidCS oID] 1]
			}
		} else {
			set xUpdateCollaborativeSpace(0) [::xUtil::errMsg 36 "updateCollaborativeSpace() - invalid CollaborativeSpace - cannot set: [mql print bus $oID select type name revision dump]"]
		}
		return [array get xUpdateCollaborativeSpace]
	}

	# @Method(global): ::xBO::createBusinessObject(sType sName sRev sPolicy sVault sOwner) - returns array object, with object ID boolean TRUE, else boolean ERROR if BO doese not exist
	proc createBusinessObject { sType sName sRev sPolicy sVault sOwner {sCurrentState ""} } {
		set xCreateBusinessObject(0) $::FALSE

		#~CAD TYPE INCLUSION LIST - turn triggers ON for these object types
		set iRunWithTriggers $::FALSE
		if {[lsearch -nocase "$::CADTYPEINCLUSIONLIST"  "$sType"] > -1} {
			#~ incoming TYPE is a member of the CAD TYPE INCLUSION LIST
			if {[string compare "$::CADPOLICYINCLUSIONLIST($sType)" "$sPolicy"] == 0} {
				#~ policy is in inclusion List
				set iRunWithTriggers $::TRUE
				puts "DBGMSG:: ****** TRIGGERS ENABLED FOR: $sType"
			}
		}

		if {[::xBO::getBOExist "$sType" "$sName" "$sRev"] == $::TRUE} {
			set xCreateBusinessObject(0) [::xUtil::errMsg 24 "\nObject already exists\n" "$sType $sName $sRev"]
		} else {
			if {[::xUtil::isNull "$sCurrentState"] == $::FALSE} {
					if {$iRunWithTriggers} { set y [catch {mql trigger on} err] }
						if {$::TRACE == 1} { mql trace type "$::TRACETYPE" on; }
							puts "DBGMSG:: command issued: mql add bus $sType $sName $sRev policy $sPolicy vault $sVault owner $sOwner current $sCurrentState"
							set x [catch {mql add bus "$sType" "$sName" "$sRev" policy "$sPolicy" vault "$sVault" owner "$sOwner" current "$sCurrentState" } xErr]
						if {$::TRACE == 1} { 
							mql trace type "$::TRACETYPE" off; 
							puts "DBGMSG:: resulting trace:\n$xErr"
						}
					if {$iRunWithTriggers} { set y [catch {mql trigger off} err] }
						if {$x != 0} {
							set xCreateBusinessObject(0) [::xUtil::errMsg 16 "could not create: $sType $sName $sRev $sPolicy $sVault $sOwner at state $sCurrentState - $xErr"]
						} else {
							set xCreateBusinessObject(0) $::TRUE
							set xCreateBusinessObject(OID) [::xBO::getBOID "$sType" "$sName" "$sRev"]
						}
			} elseif {[::xUtil::isNull "$sCurrentState"] == $::TRUE} {
					if {$iRunWithTriggers} { set y [catch {mql trigger on} err] }
						if {$::TRACE == 1} { mql trace type "$::TRACETYPE" on; }
						puts "DBGMSG:: command issued: mql add bus $sType $sName $sRev policy $sPolicy vault $sVault owner $sOwner"
						set x [catch {mql add bus "$sType" "$sName" "$sRev" policy "$sPolicy" vault "$sVault" owner "$sOwner"} xErr]
						if {$::TRACE == 1} { 
							mql trace type "$::TRACETYPE" off; 
							puts "DBGMSG:: resulting trace:\n$xErr"
						}
					if {$iRunWithTriggers} { set y [catch {mql trigger off} err] }
						if {$x != 0} {
							set xCreateBusinessObject(0) [::xUtil::errMsg 16 "could not create: $sType $sName $sRev $sPolicy $sVault $sOwner - $xErr"]
						} else {
							set xCreateBusinessObject(0) $::TRUE
							set xCreateBusinessObject(OID) [::xBO::getBOID "$sType" "$sName" "$sRev"]
						}			 
			} 

		}
		return [array get xCreateBusinessObject]
	}

	# @Method(global): ::xBO::createBusinessObject(sType sName sRev sPolicy sVault sOwner) - returns array object, with object ID boolean TRUE, else boolean ERROR if BO doese not exist
	proc createBusinessObject0 { sType sName sRev sPolicy sVault sOwner {sCurrentState ""} } {
		set xCreateBusinessObject(0) $::FALSE

		if {[::xBO::getBOExist "$sType" "$sName" "$sRev"] == $::TRUE} {
			set xCreateBusinessObject(0) [::xUtil::errMsg 24 "\nObject already exists\n" "$sType $sName $sRev"]
		} else {
			if {[::xUtil::isNull "$sCurrentState"] == $::FALSE} {
					set x [catch {mql add bus "$sType" "$sName" "$sRev" policy "$sPolicy" vault "$sVault" owner "$sOwner" current "$sCurrentState" } xErr]
					if {$x != 0} {
					set xCreateBusinessObject(0) [::xUtil::errMsg 16 "could not create: $sType $sName $sRev $sPolicy $sVault $sOwner" "- $xErr"]
					} else {
					set xCreateBusinessObject(0) $::TRUE
					set xCreateBusinessObject(OID) [::xBO::getBOID "$sType" "$sName" "$sRev"]
					}
			} elseif {[::xUtil::isNull "$sCurrentState"] == $::TRUE} {
					set x [catch {mql add bus "$sType" "$sName" "$sRev" policy "$sPolicy" vault "$sVault" owner "$sOwner"} xErr]
					if {$x != 0} {
					set xCreateBusinessObject(0) [::xUtil::errMsg 16 "could not create: $sType $sName $sRev $sPolicy $sVault $sOwner" "- $xErr"]
					} else {
					set xCreateBusinessObject(0) $::TRUE
					set xCreateBusinessObject(OID) [::xBO::getBOID "$sType" "$sName" "$sRev"]
					}			 
			} 
		}
		return [array get xCreateBusinessObject]
	}


	proc inheritInterfaces {fromOID toOID} {
		set binheritInterfaces $::FALSE
		if {[catch {mql print bus $fromOID select interface dump |} xParentInterfaces] == 0} {
			if {[catch {mql print bus $toOID select interface dump |} xChildInterfaces] == 0} {
				set lChildInterfaces [split $xChildInterfaces |]
				foreach iParentInterface [split $xParentInterfaces |] {
					if {[lsearch $lChildInterfaces $iParentInterface] == -1} {
						#~ Parent interface is not on inheriting object
						set binheritInterfaces [::xBO::addInterface $toOID "$iParentInterface"]
					} else {
						#~ Parent interface is already on inheriting object
					}
				}
			}
		}
		return $binheritInterfaces
	}

	proc inheritInterfaces2 {fromOID toOID} {
		set binheritInterfaces2 $::FALSE
		set x [::xBO::inheritInterfaces $fromOID $toOID]
		foreach iClassLib [split [mql expand  bus $fromOID to rel Subclass recurse to all select bus id interface dump |] \n] {
			#~ iterate through all parents up the SubClass relationship tree to get interfaces
			set sClassLibOID [lindex [split $iClassLib |] 6]
			set sClassLibInterface [lindex [split $iClassLib |] 7]
			puts "$sClassLibOID --> $sClassLibInterface"
			if {[::xUtil::isNull "$sClassLibInterface"] == $::FALSE} {
				set x [::xBO::inheritInterfaces $sClassLibOID $toOID]
			}
		}
		if {[catch {mql print bus $toOID select interface dump |} xChildInterfaces] == 0} {
			if {[::xUtil::isNull "$xChildInterfaces"] == $::FALSE} {
				set binheritInterfaces2 $::TRUE
			}
		} 
		return $binheritInterfaces2
	}

	proc inheritInterfaces3 {fromOID toOID} {
		set binheritInterfaces3 $::FALSE
		foreach iMxSysInterface [split [mql print bus $fromOID select attribute\[mxsysInterface\].value dump |] |] {
			set binheritInterfaces3 [::xBO::addInterface $toOID "$iMxSysInterface"]
		}
		return $binheritInterfaces3
	}


	proc addInterface {OID sInterface} {
		set baddInterface $::FALSE
		::xUtil::dbgMsg "addInterface() - Add Interface $sInterface to object [mql print bus $OID select type name revision]"
		if {[catch {mql mod bus $OID add interface "$sInterface"} err] != 0} {
			set baddInterface [::xUtil::errMsg 40 "$err"]
		} else {
			set baddInterface $::TRUE
		}
		return $baddInterface
	}
	  
	proc removeInterface {OID sInterface} {
		set bremoveInterface $::FALSE
		if {[catch {mql mod bus $OID remove interface "$sInterface"} err] != 0} {
			set bremoveInterface $::ERROR
		} else {
			set bremoveInterface $::TRUE
		}
		return $bremoveInterface
	}

	proc validateInterface {sInterface} {
		set bvalidateInterface $::FALSE
		set x [mql list interface "$sInterface"]
		if {[::xUtil::isNull "$x"] == $::FALSE} {
		set bvalidateInterface $::TRUE
		}
		return $bvalidateInterface
	}


	# @Method(global): ::xBO::createBusinessObject2(sType sName sRev sPolicy sVault sOwner sClassification) - creates the object with INTERFACE - sClassification(AttributeName=AttributeValue | INTERFACE=InterfaceName), returns array object, with object ID boolean TRUE, else boolean ERROR if BO doese not exist
	# @	implementation - sClassification(ClassLibraryTYPE|ClassLibraryNAME) - The ClassLibrary object will be connected to the primary object relationship(Classified ITem).from and any Interface attached to the ClassLibrary will be inherited to the subordinate
	# @   metadata format  - <classification>Class Library TYPE|Class Library Name</classification>
	# @   metadata example - <classification>Document Family|AG_ProductCenter</classification>
	proc createBusinessObject2 { sType sName sRev sPolicy sVault sOwner sClassification } {
		set xCreateBusinessObject(0) $::FALSE
		set sClassificationRelationship "Classified Item"

		if {[::xBO::getBOExist "$sType" "$sName" "$sRev"] == $::TRUE} {
			set xCreateBusinessObject(0) [::xUtil::errMsg 24 "\nObject already exists\n" "$sType $sName $sRev"]
		} else {
			if {[::xUtil::isNull "$sClassification"] == $::FALSE} {
				set sClassLibraryType  [lindex [split "$sClassification" /] 0]
				set sClassLibraryName  [lindex [split "$sClassification" /] 1]
				foreach iClassLibObj [::xBO::findObjects "$sClassLibraryType"  "$sClassLibraryName" *]  { 
					lappend lClassLibrary [lindex $iClassLibObj 3] 
				}
				if {[llength $lClassLibrary] > 0} {
				#~ set INTERACE directly
				set x [catch {mql add bus "$sType" "$sName" "$sRev" policy "$sPolicy" vault "$sVault" owner "$sOwner"} xErr]
				if {$x != 0} {
					set xCreateBusinessObject(0) [::xUtil::errMsg 16 "could not create: $sType $sName $sRev $sPolicy $sVault $sOwner"]
				} else {
					set xCreateBusinessObject(0) $::TRUE
					set xCreateBusinessObject(OID) [::xBO::getBOID "$sType" "$sName" "$sRev"]
					foreach iClassLibOID $lClassLibrary {
						array set xInterfaceInheritance [::xBO::createConnectionInheritInterfaces $iClassLibOID $xCreateBusinessObject(OID) $sClassificationRelationship]
					}
				}
				}
			}
		}
		return [array get xCreateBusinessObject]
	}

	# @Method(global): ::xBO::createBusinessObject3(sType sName sRev sPolicy sVault sOwner sClassification) - creates the object with INTERFACE - sClassification(AttributeName=AttributeValue | INTERFACE=InterfaceName), returns array object, with object ID boolean TRUE, else boolean ERROR if BO doese not exist
	# @	implementation - sClassification(AttributeName=AttributeValue) - The attribute AttributeName is a trigger enabled attribute that will implement an INTERFACE based on correlation to AttributeValue. 
	# @	implementation - sClassification(INTERFACE=InterfaceName)
	proc createBusinessObject3 { sType sName sRev sPolicy sVault sOwner sClassification } {
		set xCreateBusinessObject(0) $::FALSE

		if {[::xBO::getBOExist "$sType" "$sName" "$sRev"] == $::TRUE} {
			set xCreateBusinessObject(0) [::xUtil::errMsg 24 "\nObject already exists\n" "$sType $sName $sRev"]
		} else {
			if {[::xUtil::isNull "$sClassification"] == $::FALSE} {
				set sClassificationAttributeName  [lindex [split "$sClassification" =] 0]
				set sClassificationAttributeValue [lindex [split "$sClassification" =] 1]
				if {"$sClassificationAttributeName" == "INTERFACE" } {
					#~ set INTERACE directly
					set x [catch {mql add bus "$sType" "$sName" "$sRev" policy "$sPolicy" vault "$sVault" owner "$sOwner" add interface "$sClassificationAttributeValue"} xErr]
					if {$x != 0} {
						set xCreateBusinessObject(0) [::xUtil::errMsg 16 "could not create: $sType $sName $sRev $sPolicy $sVault $sOwner"]
					} else {
						set xCreateBusinessObject(0) $::TRUE
						set xCreateBusinessObject(OID) [::xBO::getBOID "$sType" "$sName" "$sRev"]
					}
				} elseif {"$sClassificationAttributeName" == "ATTRIBUTEGROUP" } {
					#~ set INTERACE directly
					set x [catch {mql add bus "$sType" "$sName" "$sRev" policy "$sPolicy" vault "$sVault" owner "$sOwner" add interface "$sClassificationAttributeValue"} xErr]
					if {$x != 0} {
						set xCreateBusinessObject(0) [::xUtil::errMsg 16 "could not create: $sType $sName $sRev $sPolicy $sVault $sOwner"]
					} else {
						set xCreateBusinessObject(0) $::TRUE
						set xCreateBusinessObject(OID) [::xBO::getBOID "$sType" "$sName" "$sRev"]
					}
				} elseif {"$sClassificationAttributeName" == "CLASSFAMILY" } {
					#~ set INTERACE directly
					set x [catch {mql add bus "$sType" "$sName" "$sRev" policy "$sPolicy" vault "$sVault" owner "$sOwner"} xErr]
					if {$x != 0} {
						set xCreateBusinessObject(0) [::xUtil::errMsg 16 "could not create: $sType $sName $sRev $sPolicy $sVault $sOwner"]
					} else {
						set xCreateBusinessObject(0) $::TRUE
						set xCreateBusinessObject(OID) [::xBO::getBOID "$sType" "$sName" "$sRev"]
					}
				} else {
					#~ implement INTERACE indirectly via attribute
					set x [catch {mql add bus "$sType" "$sName" "$sRev" policy "$sPolicy" vault "$sVault" owner "$sOwner" "$sClassificationAttributeName" "$sClassificationAttributeValue"} xErr]
					if {$x != 0} {
						set xCreateBusinessObject(0) [::xUtil::errMsg 16 "could not create: $sType $sName $sRev $sPolicy $sVault $sOwner"]
					} else {
						set xCreateBusinessObject(0) $::TRUE
						set xCreateBusinessObject(OID) [::xBO::getBOID "$sType" "$sName" "$sRev"]
					}
				}
			} else {
				#~ create object with no INTERACE
				set x [catch {mql add bus "$sType" "$sName" "$sRev" policy "$sPolicy" vault "$sVault" owner "$sOwner"} xErr]
				if {$x != 0} {
					set xCreateBusinessObject(0) [::xUtil::errMsg 16 "could not create: $sType $sName $sRev $sPolicy $sVault $sOwner"]
				} else {
					set xCreateBusinessObject(0) $::TRUE
					set xCreateBusinessObject(OID) [::xBO::getBOID "$sType" "$sName" "$sRev"]
				}
			}
		}
		return [array get xCreateBusinessObject]
	}


	#~ Native file = 1234.Doc
	#~ Viewable file = 1234_doc.PDF 
	proc createDerivedOutputObject {oID sFormat sViewableFile} {
		set xcreateDerivedOutputObject(0) $::FALSE

		#~ if this is an XML file, do not create a derived output for it, there will never be a PDF rendering
		set sExtension [string toupper [lindex [split [file extension [file tail $sViewableFile]] "."] 1]]
		if {[lsearch $::DERIVEDOUTPUTFILEEXTENSIONEXCLUSIONLIST "$sExtension"] > -1} {
			return [array get xcreateDerivedOutputObject]
		}


		puts "################################ DERIVED OUTPUT OBJECT ########################################"
		puts "NOTDBG:: Derived Output: create for - businessobject [mql print bus $oID select type name revision] sFormat= $sFormat sViewableFile= $sViewableFile"
		
		set lObj	[split [mql print bus $oID select type name revision policy current owner attribute\[Originator\] attribute\[gapLegacyPDMIdentifier\] dump |] |]
		#~ Main obj params, used in logic
		set sType		[lindex $lObj 0]
		set sName		[lindex $lObj 1]
		set sRev		[lindex $lObj 2]
		set sPolicy		[lindex $lObj 3]		
		set sState		[lindex $lObj 4]
		#~ shared obj params, used as is
		set sOwner		[lindex $lObj 5]
		set sOriginator [lindex $lObj 6]
		set sLegacyPDMIdentifier [lindex $lObj 7]
		set sCAD_Type	[string tolower "PDF"]
		
		if {[lsearch -nocase $::DERIVEDOUTPUTFORMATINCLUSIONLIST [string toupper "$sFormat"]] > -1} {
			regsub -all -- "_" [file rootname [file tail "$sViewableFile"]] "\." sNewFilepath
		} else {
			set sNewFilepath [file tail "$sViewableFile"]
		}

		if {[lsearch -nocase "$::DERIVEDOUTPUTINCLUSIONLIST"  "$sType"] > -1} {
			#~ TYPE is in inclusion List
			if {[lsearch -nocase [split "$::DERIVEDOUTPUTPOLICYINCLUSIONLIST($sType)" ","] "$sPolicy"] >= 0} {
				#~ POLICY is in inclusion List
				if {[lsearch -nocase [split "$::DERIVEDOUTPUTMAINSTATEINCLUSIONLIST($sType)" ","] "$sState"] >= 0} {
					#~ CURRENT STATE is in inclusion List
					set s1Type "Derived Output"
					set s1Name "$sName"
					set s1Rev  "$sRev"
					if {[lsearch -nocase [split "$::DERIVEDOUTPUTPOLICYINCLUSIONLIST($sType)" ","] "$sPolicy"] == 0} {
						set s1Policy "Derived Output Policy"
						set s1State  "Exists"
					} else {
						set s1Policy "Version"
						set s1State  "Exists"
					}
					set s1Vault "eService Production"
					set s1Owner "$sOwner"

					#~ create DERIVED OUTPUT object
					if {[::xBO::getBOExist "$s1Type" "$s1Name" "$s1Rev"] == $::FALSE} {
						puts "NOTDBG:: Creating DERIVED OUTPUT Object: $s1Type $s1Name $s1Rev $s1Policy $s1Vault $s1Owner"
							
						array set xcreateDerivedOutputObject [::xBO::createBusinessObject "$s1Type" "$s1Name" "$s1Rev" "$s1Policy" "$s1Vault" "$s1Owner"]

						if {[lindex [array get xcreateDerivedOutputObject 0] 1] == $::TRUE } {
							set oDOID [lindex [array get xcreateDerivedOutputObject OID] 1]
							#~ update Description to FILENAME
							set x [::xBO::updateBusinessObjectDescription $oDOID "$sNewFilepath" 0]
								if {$x != $::TRUE} {
									set xcreateDerivedOutputObject(0) [::xUtil::errMsg 48 "could not update Derived Output Description: $s1Type $s1Name $s1Rev Title = $sNewFilepath"]
								}

							#~ Update object with Attributes
							set x [::xBO::setBOAttributeValue $oDOID Title "$sNewFilepath"]
								if {$x != $::TRUE} {
									set xcreateDerivedOutputObject(0) [::xUtil::errMsg 48 "could not update Derived Output Title: $s1Type $s1Name $s1Rev Title = $sNewFilepath"]
								}
							set x [::xBO::setBOAttributeValue $oDOID Originator "$sOriginator"]
								if {$x != $::TRUE} {
									set xcreateDerivedOutputObject(0) [::xUtil::errMsg 48 "could not update Derived Output Originator: $s1Type $s1Name $s1Rev Originator = $sOriginator"]
								}
							set x [::xBO::setBOAttributeValue $oDOID "CAD Type" "$sCAD_Type"]
								if {$x != $::TRUE} {
									set xcreateDerivedOutputObject(0) [::xUtil::errMsg 48 "could not update Derived Output Title: $s1Type $s1Name $s1Rev  CAD TYPE = $sCAD_Type"]
								}
				
							#~ if this is the latest version make connections
							puts "NOTDBG:: createDerivedOutputObject() Connecting the DERIVED OUTPUT "
							### use createConnection3() and pass rel attr name and sNewFilepath

							array set xDOConnection [::xBO::createConnection3   "$oID" "$oDOID" "Derived Output" "CAD Object Name" "$sNewFilepath" ]
								if {$xDOConnection(0) != $::TRUE} {
									set xcreateDerivedOutputObject(0) [::xUtil::errMsg 48 "could not connect Derived Output (Derived Output): $s1Type $s1Name $s1Rev" ]
								}

								
						}
					} else {
						set xcreateDerivedOutputObject(0) $::TRUE
						set xcreateDerivedOutputObject(OID)  [::xBO::getBOID "$s1Type" "$s1Name" "$s1Rev"]
						set oDOID $xcreateDerivedOutputObject(OID)
					}
					
					#~ checkin file(s) into DO object
					if {[string match -nocase "" "$sViewableFile"] != 1} {
						if {[lsearch -nocase $::DERIVEDOUTPUTFORMATINCLUSIONLIST "$sFormat"] > -1} {
							puts "NOTDBG:: checkin Derived Output object $sViewableFile"
							puts "createDerivedOutputObject():: mql checkin businessobject [mql print bus $oDOID select type name revision dump] append $sViewableFile"
							set x [catch {mql checkin businessobject $oDOID format "$sFormat" append "$sViewableFile"} err]
							if {$x != 0} {
								set xcreateDerivedOutputObject(0) [::xUtil::errMsg 48 "createDerivedOutputObject() [mql print bus $oDOID select type name revision dump |] - failed to checkin $sViewableFile - error $err"
							}
						}
					}
				}
			}
		}

		return [array get xcreateDerivedOutputObject]
	}

	proc createFileVersionObject {oID sFormat sNewFilepath {sLatestVersion ""} {sVersionPrefix ""} } {
		#~ create Version object and use sNewFilepath to get filename for object TITLE
		set bcreateFileVersionObject $::FALSE


		if {[lsearch $::VERSIONFORMATEXCLUSIONS "$sFormat"] > -1} {
			#~ this format is VIEWABLE and does not get a VERSION obj
			return $bcreateFileVersionObject
		}


		set sType		[mql print bus $oID select type  dump]
		set sMasterName	[mql print bus $oID select name  dump]
		set sMasterRev	[mql print bus $oID select revision  dump]
		set sOwner		[mql print bus $oID select owner dump]
		set sOriginator [mql print bus $oID select attribute\[Originator\] dump]
		set sLegacyPDMIdentifier [mql print bus $oID select attribute\[gapLegacyPDMIdentifier\] dump]
		
		if {[::xUtil::isNull "$sLatestVersion"] == $::TRUE } {
			set sLatestVersion 1
		}

		if {[lsearch $::VERSIONABLETYPEINCLUSIONLIST "$sType"] >= 0} {
			puts "################################ VERSION OBJECT ########################################"
			puts "NOTDBG:: Versionable: businessobject [mql print bus $oID select type name revision]"
			set sFilename [file tail "$sNewFilepath"]
			set sPolicy $::VERSIONABLETYPEPOLICY($sType)
			set sVault "eService Production"
			
			#~ create Version object NAME
			if {[::xUtil::isNull "$sVersionPrefix"] == $::TRUE } {
				set sName [join [list [clock seconds] [file tail "$sFilename"]] "_"]
			} else {
				set sName [join [list "$sVersionPrefix" [file tail "$sFilename"]] "_"]
			}

			#set sName "$sVersionPrefix"

			#~ Derive the version of the file being checked in
			set sCurrentVersionofFile [lindex [split [lindex [split "$sNewFilepath" /] 1] _] 2]
			if {[::xUtil::isNull "$sCurrentVersionofFile"] == $::TRUE } {
				set sRev "$sLatestVersion"
			} else {
				set sRev "$sCurrentVersionofFile"
			}

			set sTitle "$sFilename"
			puts "NOTDBG:: Versioning: businessobject [mql print bus $oID select type name revision] with $sType $sName $sRev"

			#~ create VERSION object, if exists get oID
			if {[::xBO::getBOExist "$sType" "$sName" "$sRev"] == $::TRUE} {
				#~ version created by previous file Checkin
				array set xObjCreate 0 $::TRUE
				array set xObjCreate OID [::xBO::getBOID "$sType" "$sName" "$sRev"]
			} else {
				puts "NOTDBG:: Creating Version Object: $sType $sName $sRev $sPolicy $sVault $sOwner"
				array set xObjCreate [::xBO::createBusinessObject "$sType" "$sName" "$sRev" "$sPolicy" "$sVault" "$sOwner"]
			}

			if {[lindex [array get xObjCreate 0] 1] == $::TRUE } {
				set oVerID [lindex [array get xObjCreate OID] 1]

				#~ Update object with Attributes
				set x [::xBO::setBOAttributeValue $oVerID Title "$sTitle"]
					if {$x != $::TRUE} {
						set bcreateFileVersionObject [::xUtil::errMsg 48 "could not update Version Title: $sType $sName $sRev Title = $sTitle"]
					}
				set x [::xBO::setBOAttributeValue $oVerID Originator "$sOriginator"]
					if {$x != $::TRUE} {
						set bcreateFileVersionObject [::xUtil::errMsg 48 "could not update Version Originator: $sType $sName $sRev Originator = $sOriginator"]
					}
				
				#~ if this is the latest version make connections
				if {[string match -nocase "$sRev" "$sLatestVersion"] == 1} {
					puts "NOTDBG:: Connecting the ACTIVE/LATEST Version"
					set x [::xBO::createConnection2   "$oID" "$oVerID" "Active Version"]
						if {$x != $::TRUE} {
							set bcreateFileVersionObject [::xUtil::errMsg 48 "could not connect Version (Active Version): $sType $sName $sRev"]
						}
					set x [::xBO::createConnection2   "$oID" "$oVerID" "Latest Version"]
						if {$x != $::TRUE} {
							set bcreateFileVersionObject [::xUtil::errMsg 48 "could not connect Version (Latest Version): $sType $sName $sRev"]
						}
				}

				
				#~ after creating VERSION object, create mating DO
				if {[lsearch -nocase "$::DERIVEDOUTPUTFORMATINCLUSIONLIST"  "$sFormat"] > -1} {
					#~ create Derived Output
				} else {
					#~ checkin file(s) into VERSION object
					if {[string match -nocase "$sRev" "$sLatestVersion"] != 1} {
						puts "NOTDBG:: checkin Version object $sNewFilepath"
						puts "createFileVersionObject():: mql checkin businessobject [mql print bus $oVerID select type name revision dump] append $sNewFilepath"
						set x [catch {mql checkin businessobject $oVerID append "$sNewFilepath"} err]
					}
				}
				
				array set xCheckin [::xBO::createDerivedOutputObject $oVerID "$sFormat" "$sNewFilepath"]
				puts "NOTDBG:: return value from createDerivedOutputObject() = [array get xCheckin]"
				
				#~ connect Derived Output - main to version
				set x [::xBO::connectDerivedOutputMaintoActiveVersion $oID "$sNewFilepath" "$sLatestVersion" "$sVersionPrefix" ]

				#~ repair revision chain for VERSION objects
				foreach iObjRev [findOtherObjectsByRevision "$sType" "$sName" "$sPolicy"] {
					lappend lActiveRevs [lindex [split $iObjRev |] 2]
				}

				set lRevSequence [split $::XREVSEQ([mql print policy "$sPolicy" select revision dump]) ,]

				set sFirstRev [lindex $lRevSequence 0]
				set idxFirstRev 0

				set sLastRev  [lindex $lRevSequence end]
				set idxLastRev [llength $lRevSequence]

				set idxCurRev [lsearch $lRevSequence $sRev]

				if {$idxCurRev >= $idxFirstRev && $idxCurRev <= $idxLastRev} {
					set idxPreRev [expr $idxCurRev - 1]
					set idxNexRev [expr $idxCurRev + 1]
					if {$idxPreRev >= $idxFirstRev} {
						set sPrevRev  [lindex $lRevSequence $idxPreRev]
					} else {
						set sPrevRev  ""
					}
					if {$idxNexRev <= $idxLastRev} {
						set sNextRev  [lindex $lRevSequence $idxNexRev]
					} else {
						set sNextRev  ""
					}
					puts "NOTDBG:: checkin Version object $sNewFilepath"
					set x [::xBO::updateObjectRevisionSequence2 "$sType" "$sName" "$sRev" "$sPrevRev" "$sNextRev"]

				} else {
					#~Invalid rev
				}
				#set x [::xBO::updateObjectRevisionSequence2 "$sType" "$sName" "$sRev" "$sPrevRev" "$sNextRev"]
			} else {
					set bcreateFileVersionObject [::xUtil::errMsg 48 "could not create Version: $sType $sName $sRev $sPolicy $sVault $sOwner"]
			}

		} else {
			#~ this is not a versionable type
			puts "WRNDBG:: NOT Versionable: businessobject [mql print bus $oID select type name revision]"
			set bcreateFileVersionObject $::TRUE
		}
		return $bcreateFileVersionObject
	}

	proc getValidVersion {sRev sPolicy} {
		set xgetValidVersion(0) $::TRUE
		set sPrevRev ""
		set sNextRev ""

		set sPolicyRevisions [mql print policy "$sPolicy" select revision dump]
		if { [string match "$sPolicyRevisions" ""] == 1 } {
			#~ no policy based revision chains defined
			if {[regexp -nocase -- {[\.\:\-\_]} "$sRev" sVerDelim] > 0} {
				set sMajorVer [lindex [split $sRev $sVerDelim] 0]
				set sMinorVer [lindex [split $sRev $sVerDelim] 1]
				if {[string is integer $sMinorVer] == 1 } {
					if {$sMinorVer > 0} {
						set sPrevRev [join [list "$sMajorVer" [expr $sMinorVer - 1]] $sVerDelim]
					} else {
						set sPrevRev ""
					}
					set sNextRev [join [list "$sMajorVer" [expr $sMinorVer + 1]] $sVerDelim]
				} elseif {[string is alpha $sMinorVer] == 1 } {
					set lREVSEQ [split $::REVSEQ(1) ,]
					set idxFirstVer 0
					set idxMinorVer [lsearch -nocase $lREVSEQ $sMinorVer]
					set idxLastVer  [llength $lREVSEQ]
					if {$idxMinorVer > $idxFirstVer && $idxMinorVer < $idxLastVer} {
						set sPrevRev [join [list "$sMajorVer" [lindex $lREVSEQ [expr $idxMinorVer - 1]]] $sVerDelim]
						set sNextRev [join [list "$sMajorVer" [lindex $lREVSEQ [expr $idxMinorVer + 1]]] $sVerDelim]
					} elseif {$idxMinorVer == $idxFirstVer && $idxMinorVer < $idxLastVer} {
						set sPrevRev ""
						set sNextRev [join [list "$sMajorVer" [lindex $lREVSEQ [expr $idxMinorVer + 1]]] $sVerDelim]
					} elseif {$idxMinorVer > $idxFirstVer && $idxMinorVer == $idxLastVer} {
						set sPrevRev [join [list "$sMajorVer" [lindex $lREVSEQ [expr $idxMinorVer - 1]]] $sVerDelim]
						set sNextRev ""
					} else {
						set sPrevRev ""
						set sNextRev ""
					}
				} else {
					set sPrevRev ""
					set sNextRev ""
				}
			} else {
				if {[string is integer $sRev] == 1 } {
					if {$sRev > 0} {
						set sPrevRev [expr $sRev - 1]
					} else {
						set sPrevRev ""
					}
					set sNextRev [expr $sRev + 1]
				} elseif {[string is alpha $sRev] == 1 } {
					set lREVSEQ [split $::REVSEQ(1) ,]
					set idxFirstVer 0
					set idxCurrVer [lsearch -nocase $lREVSEQ $sRev]
					set idxLastVer [llength $lREVSEQ]
					if {$idxCurrVer > $idxFirstVer && $idxCurrVer < $idxLastVer} {
						set sPrevRev [lindex $lREVSEQ [expr $idxCurrVer - 1]]
						set sNextRev [lindex $lREVSEQ [expr $idxCurrVer + 1]]
					} elseif {$idxCurrVer == $idxFirstVer && $idxCurrVer < $idxLastVer} {
						set sPrevRev ""
						set sNextRev [lindex $lREVSEQ [expr $idxCurrVer + 1]]
					} elseif {$idxCurrVer > $idxFirstVer && $idxCurrVer == $idxLastVer} {
						set sPrevRev [lindex $lREVSEQ [expr $idxCurrVer - 1]]
						set sNextRev ""
					} else {
						set sPrevRev ""
						set sNextRev ""
					}
				} else {
					set sPrevRev ""
					set sNextRev ""
				}
			}
		} else {
			#~ rev chain defined in policy
			set lRevSequence [split $::XREVSEQ([mql print policy "$sPolicy" select revision dump]) ,]

			set sFirstRev [lindex $lRevSequence 0]
			set idxFirstRev 0

			set sLastRev  [lindex $lRevSequence end]
			set idxLastRev [llength $lRevSequence]

			set idxCurRev [lsearch $lRevSequence $sRev]

			if {$idxCurRev >= $idxFirstRev && $idxCurRev <= $idxLastRev} {
				set idxPreRev [expr $idxCurRev - 1]
				set idxNexRev [expr $idxCurRev + 1]
				if {$idxPreRev >= $idxFirstRev} {
					set sPrevRev  [lindex $lRevSequence $idxPreRev]
				} else {
					set sPrevRev  ""
				}
				if {$idxNexRev <= $idxLastRev} {
					set sNextRev  [lindex $lRevSequence $idxNexRev]
				} else {
					set sNextRev  ""
				}
			}
		}
		set xgetValidVersion(PREVREV) "$sPrevRev"
		set xgetValidVersion(CURRREV) "$sRev"
		set xgetValidVersion(NEXTREV) "$sNextRev"
		return [array get xgetValidVersion]
	}

	proc repairRevLinks4VersionObjects {sType sName sRev sPolicy} {
		#~ repair revision chain for VERSION objects
		#~ NEXTREV A.2 0 1 CURRREV A.1 PREVREV A.0

		foreach iObjRev [findOtherObjectsByRevision "$sType" "$sName" "$sPolicy"] {
			lappend lActiveRevs [lindex [split $iObjRev |] 2]
		}

		array set xVersions [::xBO::getValidVersion "$sRev" "$sPolicy"]
		set sPrevRev [lindex [array get xVersions PREVREV] 1]
		set sNextRev [lindex [array get xVersions NEXTREV] 1]
		
		set x [::xBO::updateObjectRevisionSequence2 "$sType" "$sName" "$sRev" "$sPrevRev" "$sNextRev"]

		return $::TRUE
	}

	# |---Document_3D INSTRUMENTS LLC 45533312_-_1
	# |   ---3D INSTRUMENTS LLC 45533312_-_1
	# |       ---3D INSTRUMENTS LLC 45533312_-_1    <-- this is the folder in focus
	# |           ---3D INSTRUMENTS LLC 45533312.PDF
	proc getVersionName {sFormat sNewFilepath sLatestVersion} {
		#~ extract version info from path
		regsub -all -- "\%3A"   "sLatestVersion" ":" sLatestVersion1
		set sLatestActiveVersion [lindex [split "$sLatestVersion1" :] 1]
		if {[lsearch $::VERSIONFORMATEXCLUSIONS "$sFormat"] != -1} {
			#~ this is for the XML files
		} else {
			set sVerFolder [file tail [file dirname $sNewFilepath]]
			set sTNRFolder [lindex [split $sNewFilepath /] 0]
			if {[string compare [string toupper "$sVerFolder"] [string toupper "$sTNRFolder"]] == 0} {
				#~ this means the file is in the master folder - anomoloy
			} else {
				#~ this is a sub version folder
				set sVer [lindex [split [string reverse "$sVerFolder"] _] 0]
				set sRev [lindex [split [string reverse "$sVerFolder"] _] 1]

			}
		}
	}
	
	# @Method(global): ::xBO::checkinBusinessObject(oID sFormat sNewFilepath  (fAppend "A")) - checks in file into businessobject oID, TRUE if successful, ERROR if failed
	proc checkinBusinessObject2 {oID sFormat sNewFilepath {fAppend "A"} {sLatestVersion ""} {sVersionPrefix ""}} {
		::xUtil::dbgMsg "checkinBusinessObject2() ... Checking in file: [mql print bus $oID select type name revision] $sFormat $sNewFilepath Latest Version = $sLatestVersion Version Prefix = $sVersionPrefix"
		set bCheckinBusinessObject $::FALSE
		switch [string toupper $fAppend] {
				A* { set sAppend "append" }
				R* { set sAppend "" }
				default { set sAppend "append" }
		}
		if {[::xUtil::verifyFileExists "$sNewFilepath" F] == $::TRUE} {
			::xUtil::dbgMsg  "... file verified: $sNewFilepath"

			if {[::xUtil::isNull "$sLatestVersion"] == $::TRUE} {
				set sLatestVersion 0
			}

			array set xCheckin [::xBO::createDerivedOutputObject $oID "$sFormat" "$sNewFilepath"]
			puts "NOTDBG:: return value from createDerivedOutputObject() = [array get xCheckin]"
			set bCheckin 0
			set err ""

			#~ if sFormat =  Viewable then create Derived Output object for MASTER obj, and checkin viewable
			if {[lsearch -nocase "$::DERIVEDOUTPUTFORMATINCLUSIONLIST"  "$sFormat"] > -1} {
				#~ create Derived Output
				array set xCheckin [::xBO::createDerivedOutputObject $oID "$sFormat" "$sNewFilepath"]
				puts "NOTDBG:: return value from createDerivedOutputObject() = [array get xCheckin]"
				set bCheckin 0
				set err ""

			} else {
				#~ main object checkin
				set bCheckin [catch {mql checkin businessobject $oID format "$sFormat" "$sAppend" "$sNewFilepath"} err]
				puts "checkinBusinessObject2():: mql checkin businessobject [mql print bus $oID select type name revision dump] format $sFormat $sAppend $sNewFilepath"
				puts "Output:: $err"
			}

			set x [::xBO::connectDerivedOutputMaintoActiveVersion $oID "$sNewFilepath" "$sLatestVersion" "$sVersionPrefix" ]

			#~ verify that this is NOT a VERSION object from the XML Obj Def
			set sObjPolicy [mql print bus $oID select policy dump]
			puts "Policy:: $::AUTONAMERPOLICYEXCLUSIONLIST $sObjPolicy"

			if {[lsearch -nocase $::AUTONAMERPOLICYEXCLUSIONLIST "$sObjPolicy"] == -1} {
				puts "Policy:: $sObjPolicy is NOT excluded"
				if {$bCheckin == 0} {
					puts "No Errors on Checkin: $sNewFilepath"
					set sNewFileName [file tail "$sNewFilepath"]
					set lUpdatedFile [::xBO::getBusinessObjectFilename2 $oID]
					::xUtil::dbgMsg  "...validating: sNewFileName=$sNewFileName vs files in obj=$lUpdatedFile"
					#~ exclude any FORMAT in VERSIONFORMATEXCLUSIONS from creating a VERSION object
					#if {[lsearch -nocase $::VERSIONFORMATEXCLUSIONS "$sFormat"] == -1} {
					#	if {[lsearch -exact $lUpdatedFile "$sNewFileName"] != -1} {
							#puts "...Validated File Checked IN: $lUpdatedFile"
							#::xUtil::dbgMsg  "...Validated File Checked IN: $lUpdatedFile"
							set bCheckinBusinessObject $::TRUE
							set x [::xBO::createFileVersionObject $oID "$sFormat" "$sNewFilepath" "$sLatestVersion" "$sVersionPrefix"]
							#~ if sFormat is PDF, then createFileVersionObject() will return FALSE but this is not an ERROR

					#	} else {
					#		puts "...NOT Validated File Checked IN: $lUpdatedFile"
					#		puts "Filename Checkin MAY have failed - could not verify file in object \n [mql print bus $oID select type name revision]\n $sFormat - $sNewFilepath"
					#		set bCheckinBusinessObject [::xUtil::errMsg 8 "Filename Checkin MAY have failed - could not verify file in object \n [mql print bus $oID select type name revision]\n $sFormat - $sNewFilepath"]
					#	}
					#} else {
					#	puts "DBGWARN: $sFormat is in the FORMAT Exclusion List: $::VERSIONFORMATEXCLUSIONS"
					#	set bCheckinBusinessObject $::TRUE
					#}
				} else {
					::xUtil::dbgMsg  "... got an error from checkin: $sNewFilepath \n$err"
					puts "Filename Checkin failed  [mql print bus $oID select type name revision]\n $sFormat - $sNewFilepath \n $err"
					set bCheckinBusinessObject [::xUtil::errMsg 8 "Filename Checkin failed  [mql print bus $oID select type name revision]\n $sFormat - $sNewFilepath \n $err"]
				}
			} else {
				set bCheckinBusinessObject $::TRUE
				puts "Policy:: $sObjPolicy IS excluded"
				#~ try to repair VERSION (rev) chain
				set sType [mql print bus $oID select type dump]
				set sName [mql print bus $oID select name dump]
				set sRev  [mql print bus $oID select revision dump]
				set x [::xBO::repairRevLinks4VersionObjects "$sType" "$sName" "$sRev" "$sObjPolicy"]

				array set xCreateDO [::xBO::createDerivedOutputObject $oID "$sFormat" "$sNewFilepath"]
				if {$xCreateDO(0) == $::TRUE} {
					array set xDOMasterOID [::xBO::findMainObjDerivedOutput $oID]
					if {$xDOMasterOID(0) == $::TRUE} {
						set oDOMasterOID  $xDOMasterOID(OID)
						set oDOVersionOID $xCreateDO(OID)
						set x [::xBO::createConnection2   "$oDOMasterOID" "$oDOVersionOID" "Active Version"]
						set x [::xBO::createConnection2   "$oDOMasterOID" "$oDOVersionOID" "Latest Version"]
						set bCheckinBusinessObject $::TRUE
					} else {
						#~ could not locate DO for Main obj
						#~ this is not an error DO for Main may not yet exist
						set bCheckinBusinessObject $::TRUE
					}
				} else {
					#~ did not create DO - possible XML file, not an error 
					set bCheckinBusinessObject $::TRUE
				}
			}

		} else {
			puts  "... file NOT verified: $sNewFilepath"
			::xUtil::dbgMsg  "... file NOT verified: $sNewFilepath"
			set bCheckinBusinessObject [::xUtil::errMsg 4 "Filename Checkin failed - filepath does not exist: $sNewFilepath \n [mql print bus $oID select type name revision]\n $sFormat - $sNewFilepath \n" ]
		}
		return $bCheckinBusinessObject
	}

	proc connectDerivedOutputMaintoActiveVersion { oID sNewFilepath sLatestVersion sVersionPrefix } {
		set bconnectDerivedOutputMaintoActiveVersion $::FALSE
		
		set lObj	[split [mql print bus $oID select type name revision policy current owner attribute\[Originator\] attribute\[gapLegacyPDMIdentifier\] dump |] |]
		#~ Main obj params, used in logic
		set sType		[lindex $lObj 0]
		set sName		[lindex $lObj 1]
		set sRev		[lindex $lObj 2]
		set sPolicy		[lindex $lObj 3]		
		set sState		[lindex $lObj 4]
		set sOwner		[lindex $lObj 5]
		set sOriginator [lindex $lObj 6]
		set sLegacyPDMIdentifier [lindex $lObj 7]

		puts "********************************* START DERIVED OUTPUT: CONNECT MAIN TO VERSION *************************************"
		set sDOType "Derived Output"
				
		set sDOMasterName  "$sName"
		set sDOMasterRev   "$sRev"

		set sDOVersionName [join [list "$sVersionPrefix" [file tail "$sNewFilepath"]] "_"]
		set sDOVersionRev "$sLatestVersion"

		puts "NOTDBG:: SEARCHING - Derived output MAIN:\n\t$sDOType $sDOMasterName $sDOVersionRev";
		puts "NOTDBG:: SEARCHING - Derived output VERSION:\n\t$sDOType $sDOVersionName $sDOMasterRev";

		if {[::xBO::getBOExist "$sDOType" "$sDOMasterName" "$sDOMasterRev"] == $::TRUE} {
			puts "NOTDBG:: FOUND - Derived output MAIN: $sDOType $sDOMasterName $sDOMasterRev";
			if {[::xBO::getBOExist "$sDOType" "$sDOVersionName" "$sDOVersionRev"] == $::TRUE} {
				puts "NOTDBG:: FOUND - Derived output VERSION: $sDOType $sDOVersionName $sDOVersionRev";
				set oDOMasterOID  [::xBO::getBOID "$sDOType" "$sDOMasterName"  "$sDOMasterRev"]
				set oDOVersionOID [::xBO::getBOID "$sDOType" "$sDOVersionName" "$sDOVersionRev"]
				set x [::xBO::createConnection2   "$oDOMasterOID" "$oDOVersionOID" "Active Version"]
				if {$x == $::TRUE} {
					set x [::xBO::createConnection2   "$oDOMasterOID" "$oDOVersionOID" "Latest Version"]
					if {$x == $::TRUE} {
						set bconnectDerivedOutputMaintoActiveVersion $::TRUE
					} else {
						set bconnectDerivedOutputMaintoActiveVersion $::ERROR
					}
				} else {
					set bconnectDerivedOutputMaintoActiveVersion $::ERROR
				}
			}
		}

		puts "********************************* END DERIVED OUTPUT: CONNECT MAIN TO VERSION *************************************"
		
		return $bconnectDerivedOutputMaintoActiveVersion
	}

	proc findMainObjDerivedOutput { oID } {
		set xfindMainObjDerivedOutput(0) $::FALSE
		#~ navigate relationships from any number of structural object positions
		#~ ... from MAIN to mainDO
		#~ ... from VER to MAIN to mainDO
		#~ ... from verDO to VER to MAIN to mainDO

		# @FIRST TRY: GET DO OBJECT ID FROM RELATIONSHIP NAVIGATION
		set lObj	[split [mql print bus $oID select type name revision policy current owner attribute\[Originator\] attribute\[gapLegacyPDMIdentifier\] dump |] |]
			set sType		[lindex $lObj 0]
			set sName		[lindex $lObj 1]
			set sRev		[lindex $lObj 2]
			set sPolicy		[lindex $lObj 3]		
			set sState		[lindex $lObj 4]
			set sOwner		[lindex $lObj 5]
			set sOriginator [lindex $lObj 6]
			set sLegacyPDMIdentifier [lindex $lObj 7]

			puts "DBGNOT:: locating Main Derived output from $sType $sName $sRev"
		
		if {[lsearch $::DERIVEDOUTPUTINCLUSIONLIST "$sType"] > -1} {
			#~ this is a main or ver obj
			if {[string first "Version" "$sPolicy"] == -1} {
				#~ Main --> DO
				puts "DBGNOT:: locating Main Derived output from MAIN object"
				set lDOobj  [split [mql expand bus $oID from rel "Derived Output" select bus id dump |] |]
				if {[::xUtil::isNull "$lDOobj"] == $::FALSE} {
					set sDOType		[lindex $lDOobj 3]
					set sDOName		[lindex $lDOobj 4]
					set sDORev		[lindex $lDOobj 5]
					set oDOID		[lindex $lDOobj 6]
					set xfindMainObjDerivedOutput(0) $::TRUE
					set xfindMainObjDerivedOutput(OID) $oDOID
				} else {
					puts "DBGWRN:: NOT AN ERROR: no Derived Output connected to: $sType $sName $sRev ******"
				}
			} else {
				#~ from Version --> Main --> DO
				puts "DBGNOT:: locating Main Derived output from VERSION object"
				set lMainObj [split [mql expand bus $oID from rel VersionOf select bus id dump |] |]
					if {[::xUtil::isNull "$lMainObj"] == $::FALSE} {	
						set sMainType	[lindex $lMainObj 3]
						set sMainName	[lindex $lMainObj 4]
						set sMainRev	[lindex $lMainObj 5]
						set oMainID		[lindex $lMainObj 6]

						set lDOobj  [split [mql expand bus $oMainID from rel "Derived Output" select bus id dump |] |]
							if {[::xUtil::isNull "$lDOobj"] == $::FALSE} {
								set sDOType		[lindex $lDOobj 3]
								set sDOName		[lindex $lDOobj 4]
								set sDORev		[lindex $lDOobj 5]
								set oDOID		[lindex $lDOobj 6]
								set xfindMainObjDerivedOutput(0) $::TRUE
								set xfindMainObjDerivedOutput(OID) $oDOID
							} else {
								puts "DBGWRN:: NOT AN ERROR: no Derived Output connected to: $sMainType $sMainName $sMainRev ******"
							}
					} else {
						puts "DBGWRN:: NOT AN ERROR: no Derived Output connected to: $sType $sName $sRev ******"
					}
			}

		} elseif {[string match "$sType" "Derived Output"] > -1} {
			#~ is this the Main DO or the Version DO
			if {[string first "Derived" "$sPolicy"] > -1} {
				#~ this is the Main DO - no where to go, return it
				puts "DBGNOT:: this is Main Derived output!"
				set oDOID $oID
				set xfindMainObjDerivedOutput(0) $::TRUE
				set xfindMainObjDerivedOutput(OID) $oDOID
			} else {
				#~ this is the Version DO to Version to Main to Main DO
				puts "DBGNOT:: locating Main Derived output from VERSION Derived Output object"
				set lVerobj  [split [mql expand bus $oID to rel "Derived Output" select bus id dump |] |]
				if {[::xUtil::isNull "$lVerobj"] == $::FALSE} {
					set sVerType	[lindex $lVerobj 3]
					set sVerName	[lindex $lVerobj 4]
					set sVerRev		[lindex $lVerobj 5]
					set oVerID		[lindex $lVerobj 6]
					set lMainObj [split [mql expand bus $oVerID from rel VersionOf select bus id dump |] |]
					if {[::xUtil::isNull "$lMainObj"] == $::FALSE} {
						set sMainType	[lindex $lMainObj 3]
						set sMainName	[lindex $lMainObj 4]
						set sMainRev	[lindex $lMainObj 5]
						set oMainID		[lindex $lMainObj 6]
						set lDOobj  [split [mql expand bus $oMainID from rel "Derived Output" select bus id dump |] |]
						if {[::xUtil::isNull "$lDOobj"] == $::FALSE} {
							set sDOType		[lindex $lDOobj 3]
							set sDOName		[lindex $lDOobj 4]
							set sDORev		[lindex $lDOobj 5]
							set oDOID		[lindex $lDOobj 6]
							set xfindMainObjDerivedOutput(0) $::TRUE
							set xfindMainObjDerivedOutput(OID) $oDOID
						} else {
							puts "DBGWRN:: NOT AN ERROR: no Derived Output connected to: $sMainType $sMainName $sMainRev ******"
						}
					} else {
						puts "DBGWRN:: NOT AN ERROR: no Derived Output connected to: $sVerType $sVerName $sVerRev ******"
					}
				} else {
					puts "DBGWRN:: NOT AN ERROR: no Derived Output connected to: $sType $sName $sRev ******"
				}
			}
		}

		# @SECOND TRY - ATTEMPT TO FIND DO BY T.N.R. CONSTRUCTS
		if {$xfindMainObjDerivedOutput(0) == $::FALSE} {
			if {[lsearch $::DERIVEDOUTPUTINCLUSIONLIST "$sType"] > -1} {
				if {[string first "Version" "$sPolicy"] == -1} {
					#main
					set sDOType "Derived Output"
					set sDOName "$sName"
					set sDORev  "$sRev"
				} else {
					#version
					set sDOType "Derived Output"
					set sDOName "$sName"
					set sDORev  [lindex [split "$sRev" "."] 0]
				}
			} elseif {[string match "$sType" "Derived Output"] > -1} {
				if {[string first "Version" "$sPolicy"] == -1} {
					#main
					set sDOType "$sType"
					set sDOName "$sName"
					set sDORev  "$sRev"
				} else {
					#version
					set sDOType "$sType"
					set sDOName "$sName"
					set sDORev   [lindex [split "$sRev" "."] 0]
				}
			}
			if {[::xUtil::isNull "$sDOType"] == $::FALSE} {
				set oDOID [::xBO::getBOID "$sDOType" "$sDOName" "$sDORev"]
				if {$oDOID != $::ERROR} {
					set xfindMainObjDerivedOutput(0) $::TRUE
					set xfindMainObjDerivedOutput(OID) $oDOID
				}
			}
		}

		return [array get xfindMainObjDerivedOutput]
	}

	# @Method(global): ::xBO::checkinBusinessObject(oID sFormat sNewFilepath  (fAppend "A")) - checks in file into businessobject oID, TRUE if successful, ERROR if failed
	proc checkinBusinessObject {oID sFormat sNewFilepath {fAppend "A"} } {
		::xUtil::dbgMsg "checkinBusinessObject() ... Checking in file: [mql print bus $oID select type name revision] $sFormat $sNewFilepath"
		set bCheckinBusinessObject $::FALSE
		switch [string toupper $fAppend] {
				A* { set sAppend "append" }
				R* { set sAppend "" }
				default { set sAppend "append" }
		}
		if {[::xUtil::verifyFileExists "$sNewFilepath" F] == $::TRUE} {
			::xUtil::dbgMsg  "... file verified: $sNewFilepath"
			set x [catch {mql checkin businessobject $oID format "$sFormat" "$sAppend" "$sNewFilepath"} err]
			puts "Output:: $err"
			if {$x == 0} {
				set sNewFileName [file tail "$sNewFilepath"]
				set lUpdatedFile [::xBO::getBusinessObjectFilename2 $oID]
				::xUtil::dbgMsg  "...validating: sNewFileName=$sNewFileName vs files in obj=$lUpdatedFile"
				if {[lsearch -exact $lUpdatedFile "$sNewFileName"] != -1} {
					set bCheckinBusinessObject $::TRUE
					::xUtil::dbgMsg  "...Validated File Checked IN: $lUpdatedFile"
				} else {
					puts "...NOT Validated File Checked IN: $lUpdatedFile"
					set bCheckinBusinessObject [::xUtil::errMsg 8 "Filename Checkin MAY have failed - could not verify file in object" "[mql print bus $oID select type name revision]\n" "$sFormat - $sNewFilepath"]
				}
			} else {
				::xUtil::dbgMsg  "... got an error from checkin: $sNewFilepath \n$err"
				set bCheckinBusinessObject [::xUtil::errMsg 8 "Filename Checkin failed " "[mql print bus $oID select type name revision]\n" "$sFormat - $sNewFilepath" "\n $err"]
			}
		} else {
			::xUtil::dbgMsg  "... file NOT verified: $sNewFilepath"
			set bCheckinBusinessObject [::xUtil::errMsg 4 "Filename Checkin failed - filepath does not exist: $sNewFilepath \n" "[mql print bus $oID select type name revision]\n" "$sFormat - $sNewFilepath \n" ]
		}
		return $bCheckinBusinessObject
	}

	# @Method(global): ::xBO::insertBusinessObjectHistory(oID iEventID sComment) - inserts a history record into businessobject oID, using HISTEVENT array of events
	proc insertBusinessObjectHistory { oID iEventID sComment } {
		set x [catch {mql mod bus $oID add history "$::HISTEVENT($iEventID)" comment "$sComment" } xErr]
		return 0
	}


	# @Method(global): ::xBO::deleteBusinessObject(oID) - deletes a businessobject oID, returns boolean TRUE if successful otherwise ERROR
	proc deleteBusinessObject { oID } {
		set bDeleteBusinessObject $::TRUE

		if {[catch {mql delete businessobject $oID} xErr] != 0} {
			#~ Delete failed
			set bDeleteBusinessObject [::xUtil::errMsg 15 "\n $xErr"]
		}
		return $bDeleteBusinessObject
	}

	# @Method(global): ::xBO::deleteBusinessObject2(oID) - deletes a businessobject oID with TRIGGERS OFF, returns boolean TRUE if successful otherwise ERROR
	proc deleteBusinessObject2 { oID } {
		set bDeleteBusinessObject $::TRUE

		set iTrig [mql trigger off;]
		set x [catch {mql delete businessobject $oID} xErr]
		set iTrig [mql trigger on;]

		if {$x != 0} {
			#~ Delete failed
			set bDeleteBusinessObject [::xUtil::errMsg 15 "\n $xErr"]
		}

		return $bDeleteBusinessObject
	}

	# @Method(global): ::xBO::deleteBusinessObjectFile(oID sFormat sFile) - deletes a file contained in a businessobject oID, returns boolean TRUE if successful otherwise ERROR
	proc deleteBusinessObjectFile {oID sFormat sFile} {
		set bDeleteBusinessObjectFile $::FALSE

		set x [catch {mql del bus $oID format "$sFormat" file "$sFile"} xErr]
		if {$x == 0} {
			set bDeleteBusinessObjectFile $::TRUE
		} else {
			set bDeleteBusinessObjectFile [::xUtil::errMsg 34 "$xErr"]
		}

		return $bDeleteBusinessObjectFile
	}


	# @Method(global): ::xBO::getBusinessObjectFilename(oID (sFormat)) - returns a TCL list of files in a businessobject oID, boolean FALSE if no files
	proc getBusinessObjectFilename {oID {sFormat ""}} {
		set xGetBusinessObjectFilename $::FALSE
		if {[mql print bus $oID select format.hasfile dump] == "TRUE"} {
			if {[::xUtil::isNull "$sFormat"] == $::TRUE} {
			set xGetBusinessObjectFilename [split [mql print bus $oID select format.file.name dump |] |]
			} else {
			set xGetBusinessObjectFilename [split [mql print bus $oID select format\[$sFormat\].file.name dump |] |]
			}
			if {[::xUtil::isNull "$xGetBusinessObjectFilename"] == $::TRUE } {
			set xGetBusinessObjectFilename $::FALSE
			}
		}
		return "$xGetBusinessObjectFilename"
	}

	proc getBusinessObjectFilename2 {oID} {
		set xGetBusinessObjectFilename $::FALSE
		if {[lindex [split [mql print bus $oID select format.hasfile dump] ,] 0] == "TRUE"} {
			set xGetBusinessObjectFilename [split [mql print bus $oID select format.file.name dump |] |]
			if {[::xUtil::isNull "$xGetBusinessObjectFilename"] == $::TRUE } {
			set xGetBusinessObjectFilename $::FALSE
			}
		}
		return "$xGetBusinessObjectFilename"
	}

	proc updateBusinessObjectProperty {oID sPropertyName sPropertyValue} {
		set bupdateBusinessObjectProperty $::FALSE
		set sAttrValue4 "$sPropertyValue"
		regsub -all -- "\%7C"  "$sAttrValue4" "|"  sAttrValue3
		regsub -all -- "\%20"  "$sAttrValue3" " "  sAttrValue2
		regsub -all -- "\%0A"  "$sAttrValue2" "\n" sAttrValue1
		regsub -all -- "\%3A"  "$sAttrValue1" ":"  sAttrValue
		set sPropertyValue "$sAttrValue"
		if {[::xBO::isAttribute "$sPropertyName"] == $FALSE} {
			puts "mql modify bus $oID $sPropertyName $sPropertyValue"
			set x [catch {mql modify bus $oID "$sPropertyName" "$sPropertyValue"} err]
			if {$x != 0} {
				set bupdateBusinessObjectProperty [::xUtil::errMsg 49 "Property update failed: Object [mql print bus $oID select type name rev dump] $sPropertyName = $sPropertyValue"]
			} else {
				set bupdateBusinessObjectProperty $::TRUE
			}
		} else {
			#property is actually an attribute
			puts "calling: setBOAttributeValue $sPropertyName $sPropertyValue"
			set bupdateBusinessObjectProperty [::xBO::setBOAttributeValue $oID "$sPropertyName" "$sPropertyValue"]
		}
		return $bupdateBusinessObjectProperty
	}

	#<originator>John.Doe</originator>
	proc updateBusinessObjectOriginator {oID sPropertyValue} {
		set bupdateBusinessObjectOriginator $::FALSE
		set sAttrValue4 "$sPropertyValue"
		regsub -all -- "\%7C"  "$sAttrValue4" "|"  sAttrValue3
		regsub -all -- "\%20"  "$sAttrValue3" " "  sAttrValue2
		regsub -all -- "\%0A"  "$sAttrValue2" "\n" sAttrValue1
		regsub -all -- "\%3A"  "$sAttrValue1" ":"  sAttrValue
		set sPropertyValue "$sAttrValue"
		set x [catch {mql modify bus $oID "Originator" "$sPropertyValue"} err]
		if {$x != 0} {
			set bupdateBusinessObjectOriginator [::xUtil::errMsg 49 "Property update failed: Object [mql print bus $oID select type name rev dump] $sPropertyName = $sPropertyValue"]
		} else {
			set bupdateBusinessObjectOriginator $::TRUE
		}

		return $bupdateBusinessObjectOriginator
	}

	#~<originated>07/11/2014 08:11:09 AM</originated>
	proc updateBusinessObjectOriginatedDate {oID sPropertyValue} {
		set bupdateBusinessObjectOriginatedDate $::FALSE
		set sAttrValue4 "$sPropertyValue"
		regsub -all -- "\%7C"  "$sAttrValue4" "|"  sAttrValue3
		regsub -all -- "\%20"  "$sAttrValue3" " "  sAttrValue2
		regsub -all -- "\%0A"  "$sAttrValue2" "\n" sAttrValue1
		regsub -all -- "\%3A"  "$sAttrValue1" ":"  sAttrValue
		set sPropertyValue "$sAttrValue"
		set x [catch {mql modify bus $oID originated "$sPropertyValue"} err]
		if {$x != 0} {
			set bupdateBusinessObjectOriginatedDate [::xUtil::errMsg 49 "Property update failed: Object [mql print bus $oID select type name rev dump] $sPropertyName = $sPropertyValue"]
		} else {
			set bupdateBusinessObjectOriginatedDate $::TRUE
		}

		return $bupdateBusinessObjectOriginatedDate
	}

	#<modified>08/22/2014 08:27:48 AM</modified>
	proc updateBusinessObjectModifiedDate {oID sPropertyValue} {
		set bupdateBusinessObjectModifiedDate $::FALSE
		set sAttrValue4 "$sPropertyValue"
		regsub -all -- "\%7C"  "$sAttrValue4" "|"  sAttrValue3
		regsub -all -- "\%20"  "$sAttrValue3" " "  sAttrValue2
		regsub -all -- "\%0A"  "$sAttrValue2" "\n" sAttrValue1
		regsub -all -- "\%3A"  "$sAttrValue1" ":"  sAttrValue
		set sPropertyValue "$sAttrValue"
		set x [catch {mql modify bus $oID gapLegacyReleased "$sPropertyValue"} err]
		if {$x != 0} {
			set bupdateBusinessObjectModifiedDate [::xUtil::errMsg 49 "Property update failed: Object [mql print bus $oID select type name rev dump] $sPropertyName = $sPropertyValue"]
		} else {
			set bupdateBusinessObjectModifiedDate $::TRUE
		}

		return $bupdateBusinessObjectModifiedDate
	}

	proc isAttribute {sAttribute} {
		#see if this is an attribute, ret=0 no, ret=1 yes
		set bisAttribute $::FALSE
		set sAttrStatus [mql list attribute "$sAttribute"]
		if {[::xUtil::isNull "$sAttrStatus"] == $::FALSE } {
			set bisAttribute $::TRUE
		}
		return $bisAttribute
	}


	# @Method(internal): ::xBO::getAttributeRange(sAttributeName) - determines if attribute has a range and returns the values as a list, otherwise FALSE
	proc getAttributeRange {sAttributeName} {
		set x [split [regsub -all -- {= } [mql print attribute "$sAttributeName" select range dump] ""] ,]
		if {[llength $x] < 1} {
			set lAttributeRange $::FALSE
		} else {
			set lAttributeRange $x
		}
		return $lAttributeRange
	}

	# @Method(internal): ::xBO::getAttributeRange2(sAttributeName) - determines if attribute has a range and returns an array, index 0 count, the values as a list, otherwise FALSE
	proc getAttributeRange2 {sAttributeName} {
		set xAttributeRange(0) $::FALSE
		set idx 0
		set x [catch {mql list attribute "$sAttributeName"} err]
		if {[::xUtil::isNull "err"] == $::TRUE} {
			#~ attribute does not exist return error
			set xAttributeRange(0) [::xUtil::warnMsg 35 "getAttributeRange2() - $sAttributeName"]
		} else {
			set x [split [regsub -all -- {= } [mql print attribute "$sAttributeName" select range dump] ""] ,]
			if {[llength $x] < 1} {
				set xAttributeRange(0) $::FALSE
			} else {
				set xAttributeRange(0) [llength $x] 
				set xAttributeRange(1) $x
			}
		}
		return [array get xAttributeRange]
	}

	# @Method(internal): ::xBO::getAttributeRange3(sAttributeName) - determines if attribute has a range and returns an array, index 0 count, the values as a list, otherwise FALSE
	proc getAttributeRange3 {sAttributeName} {
		set xAttributeRange(0) $::FALSE
		set idx 0
		set x [split [regsub -all -- {= } [mql print attribute "$sAttributeName" select range dump] ""] ,]
		if {[llength $x] < 1} {
			set xAttributeRange(0) $::FALSE
		} else {
			set xAttributeRange(0) [llength $x] 
			foreach iRangeMember $x {
			set xAttributeRange([incr idx]) $iRangeMember
			}
		}
		return [array get xAttributeRange]
	}

	# @Method(internal): ::xBO::verifyBOAttribute(oID sAttributeName) - validate that teh attribute is present on the businessobject specified by oID, return boolean TRUE if it does, otherwise FALSE
	proc verifyBOAttribute {oID sAttributeName} {
		set x [split [mql print bus $oID select attribute dump |] |]
		if {[lsearch $x "$sAttributeName"] == -1} {
			set bVerify $::FALSE
		} else {
			set bVerify $::TRUE
		}
		return $bVerify
	}

	# @Method(global): ::xBO::getBOAttributeValue(oID sAttributeName) - returns the value contained in the attribute otherwise ERROR
	proc getBOAttributeValue {oID sAttributeName} {
		if {[verifyBOAttribute $oID $sAttributeName] == $::TRUE} {
			set sAttrValue [mql print bus $oID select attribute\[$sAttributeName\] dump]
		} else {
			set sAttrValue [::xUtil::warnMsg 35 "getBOAttributeValue() - $sAttributeName does not exist"]
		}
		return "$sAttrValue"
	}

	# @Method(global): ::xBO::setBOAttributeValue(oID sAttributeName xAttributeValue) - determines if the attribute has a range and then validtes the new value is within the range, otherwise sets the value, if new value and old value are the same, just returns TRUE
	proc setBOAttributeValue {oID sAttributeName xAttributeValue} {
		#~ add fault tolerance for metadata that may not be an oID attribute

		set sAttrOld   [::xBO::getBOAttributeValue $oID "$sAttributeName"]
			#~ if the new attr does not exist on the BO Type, return error
			if {"$sAttrOld" == $::ERROR} {
						set bAttrModStatus [::xUtil::warnMsg 35 "setBOAttributeValue() - $sAttributeName does not exist"]
						return $bAttrModStatus
			}
			#~ if the new attr value requested is already set, exit with TRUE
			if {"$sAttrOld" == "$xAttributeValue"} {
						set bAttrModStatus $::TRUE
						return $bAttrModStatus
			}

		#~ determine if attribute has a range, and if xAttributeValue is a range member
		array set xAttrRange [::xBO::getAttributeRange2 "$sAttributeName"]
		set iAttrRange [lindex [array get xAttrRange 0] 1]
		set lAttrRange [lindex [array get xAttrRange 1] 1]
		if {$iAttrRange == $::FALSE} {
			#if iSearchRange is FALSE, then no range requirements
			set iSearchRange $::FALSE
		} else {
			# if iSearchRange is -1, then Attribute has range, and the value is incorrect
			set iSearchRange [lsearch $lAttrRange "$xAttributeValue"]
			if {$iSearchRange < 0} {
			set bAttrModStatus [::xUtil::warnMsg 28 "$oID\($sAttributeName\)=$xAttributeValue - Invalid range member = $lAttrRange"]
			return $bAttrModStatus
			}
		}
		#~ if the xAttributeValue is a new value, and there is no range or it is a range member, then process
		#~ iSearchRange = 0 there is no range, iSearchRange > 0
		if {$iSearchRange >= 0} {
			if {$sAttrOld != $::ERR} {
				set x [catch {mql modify bus $oID "$sAttributeName" "$xAttributeValue"} xErr]
				set bAttrModStatus $::TRUE
				if 0 {
						if {$x == $::ERR} {
							set bAttrModStatus [::xUtil::warnMsg 28 "$oID\($sAttributeName\)=$xAttributeValue - $xErr"]
						} else {
							set sAttrNew [::xBO::getBOAttributeValue $oID "$sAttributeName"]
							if {"$sAttrNew" == "$xAttributeValue"} {
								set bAttrModStatus $::TRUE
							} elseif {"$sAttrNew" == "$sAttrOld"} {
								set bAttrModStatus $::FALSE
							} else {
								set bAttrModStatus $::ERR
							}
						}
				}
			} else {
				set bAttrModStatus [::xUtil::warnMsg 28 "could not get sAttr value returned an error: $oID\($sAttributeName\)=$xAttributeValue"]
			}
		}
		return $bAttrModStatus
	}

	proc setBOAttributeValue2 {oID sAttributeName xAttributeValue} {
		#~ add fault tolerance for metadata that may not be an oID attribute

		set sAttrOld   [::xBO::getBOAttributeValue $oID "$sAttributeName"]
			#~ if the new attr does not exist on the BO Type, return error
			if {"$sAttrOld" == $::ERROR} {
						set bAttrModStatus [::xUtil::warnMsg 35 "setBOAttributeValue2() - $sAttributeName does not exist"]
						return $bAttrModStatus
			}
			#~ if the new attr value requested is already set, exit with TRUE
			if {"$sAttrOld" == "$xAttributeValue"} {
						set bAttrModStatus $::TRUE
						return $bAttrModStatus
			}

		#~ determine if attribute has a range, and if xAttributeValue is a range member
		array set xAttrRange [::xBO::getAttributeRange2 "$sAttributeName"]
		set iAttrRange [lindex [array get xAttrRange 0] 1]
		set lAttrRange [lindex [array get xAttrRange 1] 1]
		if {$iAttrRange == $::FALSE} {
			#if iSearchRange is FALSE, then no range requirements
			set iSearchRange $::FALSE
		} else {
			# if iSearchRange is -1, then Attribute has range, and the value is incorrect
			set iSearchRange [lsearch $lAttrRange "$xAttributeValue"]
			if {$iSearchRange < 0} {
			set bAttrModStatus [::xUtil::warnMsg 28 "$oID\($sAttributeName\)=$xAttributeValue - Invalid range member = $lAttrRange"]
			return $bAttrModStatus
			}
		}
		#~ if the xAttributeValue is a new value, and there is no range or it is a range member, then process
		#~ iSearchRange = 0 there is no range, iSearchRange > 0
		if {$iSearchRange >= 0} {
			if {$sAttrOld != $::ERR} {
				regsub -all -- "\%7C"  "$xAttributeValue" "|"  sAttrValue1
				regsub -all -- "\%20"  "$sAttrValue1" " "  sAttrValue2
				regsub -all -- "\%0A"  "$sAttrValue2" "\n" sAttrValue3
				regsub -all -- "\%3A"  "$sAttrValue3" ":"  sAttrValue4
				regsub -all -- "\%33"  "$sAttrValue4" "\""  sAttrValue5
				regsub -all -- "\%39"  "$sAttrValue5" "\'"  sAttrValue6

				set x [catch {mql modify bus $oID "$sAttributeName" "$sAttrValue6"} xErr]
				set bAttrModStatus $::TRUE
				if 0 {
						if {$x == $::ERR} {
							set bAttrModStatus [::xUtil::warnMsg 28 "$oID\($sAttributeName\)=$sAttrValue6 - $xErr"]
						} else {
							set sAttrNew [::xBO::getBOAttributeValue $oID "$sAttributeName"]
							if {"$sAttrNew" == "$sAttrValue6"} {
								set bAttrModStatus $::TRUE
							} elseif {"$sAttrNew" == "$sAttrOld"} {
								set bAttrModStatus $::FALSE
							} else {
								set bAttrModStatus $::ERR
							}
						}
				}
			} else {
				set bAttrModStatus [::xUtil::warnMsg 28 "could not get sAttr value returned an error: $oID\($sAttributeName\)=$sAttrValue6"]
			}
		}
		return $bAttrModStatus
	}


	
	# ~ lConnectNameValuePairs etype=Document/ename=101A11.TIF/erevision=0/relationship=Active Version/myend=from
	proc connectBusinessObjectStructure {xOID lConnectNameValuePairs} {
		::xUtil::dbgMsg "Object xOID to be updated: [mql print bus $xOID select type name revision]"
		set bconnectBusinessObjectStructure $::FALSE
		foreach iConnection $lConnectNameValuePairs {
			
			::xUtil::dbgMsg "connectBusinessObjectStructure() iConnection: $iConnection"
			
			set iT [lindex [split [lindex [split $iConnection /] 0] =] 1]
			set iN [lindex [split [lindex [split $iConnection /] 1] =] 1]
			set iR [lindex [split [lindex [split $iConnection /] 2] =] 1]
			set iC [lindex [split [lindex [split $iConnection /] 3] =] 1]
			set iE [lindex [split [lindex [split $iConnection /] 4] =] 1]
			
			::xUtil::dbgMsg "connectBusinessObjectStructure() xConn Params = $iT . $iN . $iR . $iC . $iE"
			
#			set iRunWithTriggers $::FALSE
#			if {[lsearch -nocase "$::CADTYPEINCLUSIONLIST"  "$iT"] > -1} {
#					set iRunWithTriggers $::TRUE
#					puts "DBGMSG:: ****** TRIGGERS ENABLED FOR: $iT"
#			}
#			if {$iRunWithTriggers} { set y [catch {mql trigger on} err] }


			#~ it the master object was Autonamed, and the old-new name pair is in teh registry, use new name
			if {[llength $::NAMEMAPREGISTRY ] > 0} {
				foreach iObjMapPair $::NAMEMAPREGISTRY {
					set sOldName [lindex [split $iObjMapPair =] 0]
					set sNewName [lindex [split $iObjMapPair =] 1]
					if {[string compare "$iN" "$sOldName"] == 0} {
						set iN "$sNewName"

						::xUtil::dbgMsg "connectBusinessObjectStructure() sNewName = $sNewName"
					}
				}
			}

			
			set yOID     [::xBO::getBOID "$iT" "$iN" "$iR"]
			::xUtil::dbgMsg "connectBusinessObjectStructure(getBOID) $iT $iN $iR - yOID = $yOID"

			if {$yOID != $::ERROR} {
				::xUtil::dbgMsg "yOID = [mql print bus $yOID select type name revision]"

				if {[string toupper "$iE"] == "FROM"} {
					set bconnectBusinessObjectStructure [::xBO::createConnection2 "$yOID" "$xOID" "$iC"]
				} else {
					set bconnectBusinessObjectStructure [::xBO::createConnection2 "$xOID" "$yOID" "$iC"]
				}
				if {$bconnectBusinessObjectStructure == $::ERROR} { 
					break; 
				} else {
					::xUtil::dbgMsg "Success:: xOID= [mql print bus $xOID select type name revision dump |] --($iC)-- [mql print bus $yOID select type name revision dump |] "
				}
			} else {
				#~ the TO object does not yet exist - it may come later, pass with warning
				set bconnectBusinessObjectStructure $::TRUE

				set x [::xUtil::warnMsg 100 "Parent([mql print bus $xOID select type name revision dump]) <- $iC ($iE) -> Child($iT $iN $iR)"]
			}
		}
		::xUtil::dbgMsg "Return status:: $bconnectBusinessObjectStructure"

#		if {$iRunWithTriggers} { set y [catch {mql trigger off} err] }

		return $bconnectBusinessObjectStructure
	}
	  
	# @ Returns = array index 0 = status of operation TRUE/FALSE, if TRUE, array index oRelID = Relationship object ID
	#~ format output: 1|Security Context Project|from|Security Context|Domain Expert.Razorleaf.Default|-|64464.32237.22660.64848|64464.32237.22660.16226
	proc createConnection {fromOID toOID sRel} {
		set xCreateConnection(0) $::FALSE
		set oRelID 0
		set x [catch {mql connect businessobject $fromOID relationship "$sRel" to  $toOID} err]
		if {$x == 1} {
			set xCreateConnection(0) [::xUtil::errMsg 10 "$err"]
		} else {
			foreach iRel [split [mql expand bus $fromOID rel "$sRel" select bus id select rel id dump |] \n] {
				foreach {l r d t n r oID rID} [split $iRel |] { break; }
				if {$toOID == $oID} {
					set oRelID "$rID"
					break; 
				}
			}
			set xCreateConnection(0) $::TRUE
			if {$oRelID != "0"} {
				set xCreateConnection(oRelID) $oRelID
			}
		}
		return [array get xCreateConnection]
	}

	proc createConnection2 {fromOID toOID sRel} {
		set bcreateConnection2 $::FALSE
		set x [catch {mql connect businessobject $fromOID relationship "$sRel" to  $toOID} err]
		if {$x == 1} {
			set bcreateConnection2 [::xUtil::errMsg 10 "$err"]
			::xUtil::dbgMsg "ERRDBG:: ($err) connect businessobject $fromOID relationship $sRel to  $toOID"
		} else {
			set bcreateConnection2 $::TRUE
		}
		return $bcreateConnection2
	}

	# @ Returns = array index 0 = status of operation TRUE/FALSE, if TRUE, array index oRelID = Relationship object ID
	#~ format output: 1|Security Context Project|from|Security Context|Domain Expert.Razorleaf.Default|-|64464.32237.22660.64848|64464.32237.22660.16226
	#~ attribute[CAD Object Name].value = 6440B111.SLDDRW
	proc createConnection3 {fromOID toOID sRel {sAttrName ""} {sAttrValue ""}} {
		set xCreateConnection(0) $::FALSE
		set oRelID 0
		set x [catch {mql connect businessobject $fromOID relationship "$sRel" to  $toOID} err]
		if {$x == 1} {
			set xCreateConnection(0) [::xUtil::errMsg 10 "$err"]
		} else {
			foreach iRel [split [mql expand bus $fromOID rel "$sRel" select bus id select rel id dump |] \n] {
				foreach {l r d t n r oID rID} [split $iRel |] { break; }
				if {$toOID == $oID} {
					set oRelID "$rID"
					break; 
				}
			}
			set xCreateConnection(0) $::TRUE
			if {$oRelID != "0"} {
				if {[::xUtil::isNull "$sAttrName"] == $::FALSE && [::xUtil::isNull "$sAttrValue"] == $::FALSE} {
					#~ set attr on rel connection
					set x [catch {mql modify connection $oRelID "$sAttrName" "$sAttrValue"} err]
					if {$x != 0} {
						puts "DBGWRN:: relationship Attribute -  [mql print $fromID select type name revision] $err"
					}
				}
				set xCreateConnection(oRelID) $oRelID
			}
		}
		return [array get xCreateConnection]
	}

	# @ Returns = array index 0 = status of xCreateConnection TRUE/FALSE, array index 1 = status of inheritInterfaces TRUE/FALSE, if both TRUE array index oRelID = Relationship ID
	proc createConnectionInheritInterfaces {fromOID toOID sRel} {
			set bCreateConnectionInheritInterfaces [::xBO::createConnection2 $fromOID $toOID $sRel]
			if {$bCreateConnectionInheritInterfaces ==  $::TRUE} {
		 		set bCreateConnectionInheritInterfaces [::xBO::inheritInterfaces3 $fromOID $toOID]
				if {$bCreateConnectionInheritInterfaces != $::TRUE} {
				set bCreateConnectionInheritInterfaces [::xUtil::errMsg 41 "could not inherit interface from connection: [mql print bus $fromOID select type name revision] -- $sRel --> [mql print bus $toOID select type name revision]"] 
				}
			} else {
				set bCreateConnectionInheritInterfaces [::xUtil::errMsg 41 "could not create connection: [mql print bus $fromOID select type name revision] -- $sRel --> [mql print bus $toOID select type name revision]"] 
			}
			return $bCreateConnectionInheritInterfaces
	}

	proc deleteConnection { oRelID } {
			set bDeleteConnection $::FALSE
			set x [catch {mql delete connection $oRelID} xErr];
			if {$x == 0} {
				set bDeleteConnection $::TRUE
			} else {
				set bDeleteConnection [::xUtil::errMsg 33 "$xErr"]
			}

			return $bDeleteConnection
	}

	# @Method(internal): ::xBO::classifyBusinessObject(toOID sClassification sClassificationRel) - connect toOID to all members of class family (sClassification) and inherits interface(s) from those members
	# @  format: toOID = object ID of object to be Classified
	# @  format: sClassification = ClassFamilyTYPE|ClassFamilyName - used to search for 1-N family members by revision
	# @  format: sClassificationRel = classification relationship that will connect toOID from Class Family members via sClassificationRel, default Classified ITem
	# @ Returns = FALSE if no lib found, compound multi-boolean in array index 0/1, and sClassificationRel instance OID in index oRelID
	proc classifyBusinessObject {toOID sClassification {sClassificationRel "Classified Item" } } {
			set bClassifyBusinessObject $::FALSE
			#~ get a list of all Oid of Class Family Libs that match the T/N/R pattern
			array set xClassOid [::xBO::findLibrary "$sClassification"]
			if {$xClassOid(0) > $::FALSE} {
					foreach {idx iClassOid} [array get xClassOid] {
						::xUtil::dbgMsg "$idx = $iClassOid"
						if {$idx > 0} {
							set bClassifyBusinessObject $::FALSE
							set iClassStatus [::xBO::createConnectionInheritInterfaces $iClassOid $toOID "$sClassificationRel"]
							if {$iClassStatus == $::TRUE} {
								set bClassifyBusinessObject $::TRUE
							} else {
								set bClassifyBusinessObject [::xUtil::errMsg 41 "could not Classify object: $sClassification --> [mql print bus $toOID select type name revision]"] 
							}
						}
					}
			} else {
				#~ no Class Family Lib found
				set bClassifyBusinessObject [::xUtil::errMsg 41 "could not locate Classification Library: $sClassification --> [mql print bus $toOID select type name revision]"] 
			}
			return $bClassifyBusinessObject
	}
		

	proc addInterfaceBusinessObject {oID sInterface} {
		set baddInterfaceBusinessObject(0) $::FALSE
		::xUtil::dbgMsg "addInterfaceBusinessObject() - Add Interface $sInterface to object [mql print bus $oID select type name revision]"
		if {[::xBO::validateInterface "$sInterface"] == $::TRUE } {
			if {[lsearch [split [mql print bus $oID select interface dump |] |] "$sInterface"] == -1 } {
				#~ interface is not previously on Object
				set baddInterfaceBusinessObject(0) [::xBO::addInterface $oID "$sInterface"]
			} else {
				#~ interface is already on object do not add second time, not an error
				set baddInterfaceBusinessObject(0) $::TRUE
			}
		} else {
			#~did not find interface
			set baddInterfaceBusinessObject(0) [::xUtil::errMsg 40 "Interface = $sInterface does not exist"]
		}
		::xUtil::dbgMsg "addInterfaceBusinessObject() - return [array get baddInterfaceBusinessObject]"
		return [array get baddInterfaceBusinessObject]
	}



	#~ depricated: <classification>CLASSFAMILY=DocumentFamily(ProductCenter)</classification>
	#~ <classification>DocumentFamily|ProductCenter</classification>
	# @ Returns = FALSE if no sClassFamily found, (0)=TRUE + (iOID)=OID of Class Family Member(s) found 
	proc findLibrary { sClassFamily } {
			set xfindLibrary(0) $::FALSE
			set sClassLibraryType [lindex [split $sClassFamily "$::cSUBDELIM"] 0]
			set sClassLibraryName [lindex [split $sClassFamily "$::cSUBDELIM"] 1]
			set sClassLibraryRev  "*"
			foreach iClassLibOid [split [mql temp query bus "$sClassLibraryType" "$sClassLibraryName" "$sClassLibraryRev" select id dump |] \n] {
					foreach {iType iName iRev iOID} [split $iClassLibOid |] { break; }
					set xfindLibrary([incr xfindLibrary(0)]) $iOID
					lappend iClassOID $iOID
			}
			return [array get xfindLibrary]
	}

		
	proc findWorkspace {sWorkspace} {
		#~ locate the workspace, return woID
		set xfindWorkspace(0) $::FALSE
		foreach iWorkspace [split [mql temp query bus Workspace "$sWorkspace" * select id dump |] \n] {
			set xfindWorkspace(0) $::TRUE
			set xfindWorkspace(wOID) [lindex [split $iWorkspace |] 3]
		}
		return [array get xfindWorkspace]
	}


	proc findWorkspaceFolderPath {sWorkspace sFolderpath} {
		#~ navigate from Workspace to WorkspaceVaults and return 1-N paths /Workspace/Folder/Folder/Folder
		#~ stub
	}
		
	proc attachWorkspaceFolders {oID sWorkspace sFolderPath {sFolderRel "Vaulted Objects"}} {
			#~ attach Workspace to Document oID
			set battachWorkspaceFolders $::FALSE
			array set oWorkspace [::xBO::findWorkspace "$sWorkspace"]
			set oMasterWorkspaceID [lindex [array get oWorkspace wOID] 1]
			if {$oWorkspace(0) == $::TRUE} {
				#~ validate folders
				array set oFolder [::xBO::validateFolderPath "$sFolderPath"]
				if {$oFolder(0) == $::TRUE} {
				#~folders valid, returns lowest folder OID
				set battachWorkspaceFolders [::xBO::createConnection2 $oFolder(oID) $oID "$sFolderRel"]
				} else {
					#~ folder path not valid
					set battachWorkspaceFolders [::xUtil::errMsg 44 "Folders: $sFolderPath not valid"]
				}
			} else {
				#~ could not validate Workspace
				set battachWorkspaceFolders [::xUtil::errMsg 44 "sWorkspace: $sWorkspace not valid"]
			}
			return $battachWorkspaceFolders
	}

	proc attachWorkspaceFolders2 {oID sWorkspace sFolderPath {sFolderRel "Vaulted Objects"}} {
			#~ attach Workspace to Document oID
			set battachWorkspaceFolders $::FALSE
			array set oWorkspace [::xBO::findWorkspace "$sWorkspace"]
			set oMasterWorkspaceID [lindex [array get oWorkspace wOID] 1]
			if {$oWorkspace(0) == $::TRUE} {
				#~ validate folders
				set sLastFolder [lindex [split $sFolderPath /] end]
				set iFolderStat $::FALSE
				foreach iFolder [split $sFolderPath /] {
					array set oFolder [::xBO::validateFolderPath2 $oMasterWorkspaceID "$iFolder"]
					if {$oFolder(0) == $::TRUE} {
						set oMasterWorkspaceID   [lindex [array get oFolder wOID] 1]
						set sMasterWorkspaceName [lindex [split [mql print bus $oMasterWorkspaceID select type name revision dump |] |] 1]
						if {[string compare -nocase "$sLastFolder" "$sMasterWorkspaceName"] == 0} {
							set battachWorkspaceFolders [::xBO::createConnection2 $oMasterWorkspaceID $oID "$sFolderRel"]
							set iFolderStat $::TRUE
							break;
						}
					}
				}
				if {$iFolderStat != $::TRUE} {
					#~ folder path not valid
					set battachWorkspaceFolders [::xUtil::errMsg 44 "Folders: $sFolderPath not valid"]
				}
			} else {
				#~ could not validate Workspace
				set battachWorkspaceFolders [::xUtil::errMsg 44 "sWorkspace: $sWorkspace not valid"]
			}
			return $battachWorkspaceFolders
	}

	proc validateFolderPath2 {oWorkspaceOID sFolder} {
		set bvalidateFolderPath2(0) $::FALSE
		set iWorkspaceCntr 1
		foreach iWorkspaceChildren [split [mql expand bus "$oWorkspaceOID" from rel "Data Vaults,Sub Vaults,Linked Folders" recurse to 5 select bus id dump |] \n] {
			set sWorkspaceChildName  [lindex [split $iWorkspaceChildren |] 4]
			set oWorkspaceChildID    [lindex [split $iWorkspaceChildren |] 6]
			if {[string compare -nocase "$sFolder" "$sWorkspaceChildName"] == 0} {
				set bvalidateFolderPath2(0) $::TRUE
				set bvalidateFolderPath2(wOID) $oWorkspaceChildID
				break;
			}
		}
		return [array get bvalidateFolderPath2]
	}


	proc validateFolderPath {sFolderPath} {
		set bvalidateFolderPath(0) $::FALSE
		set lFolderPath [split "$sFolderPath" "/"]
		set iWorkspaceCntr 1
		foreach iWorkspaceElement $lFolderPath {
			set lWorkspace [split [mql temp query bus Workspace* "$iWorkspaceElement" * select id dump |] \n]
			if {[llength $lWorkspace] > 0 } {
				foreach iWorkspace  $lWorkspace {
					set sWorkspaceType  [lindex [split $iWorkspace |] 0]
					set sWorkspaceName  [lindex [split $iWorkspace |] 1]
					set sWorkspaceRev   [lindex [split $iWorkspace |] 2]
					set oWorkspaceID    [lindex [split $iWorkspace |] 3]
					#set oWorkspaceID    [mql print bus "$sWorkspaceType" "$sWorkspaceName" "$sWorkspaceRev" select id dump]
					foreach iWorkspaceChildren [split [mql expand bus "$oWorkspaceID" from rel "Data Vaults,Sub Vaults,Linked Folders"  recurse to 1 dump |] \n] {
						set sWorkspaceChildName  [lindex [split $iWorkspaceChildren |] 4]
						if {[lsearch -exact $lFolderPath "$sWorkspaceChildName"] >= 0} {
							incr iWorkspaceCntr
						}
					}
				}
			} else {
				set bvalidateFolderPath(0) [::xUtil::errMsg 44 "Error: no workspace named: $iWorkspaceElement"]
				break;
			}
		}
		if {$iWorkspaceCntr == [llength $lFolderPath]} {
			set bvalidateFolderPath(oID) "$oWorkspaceID"
			set bvalidateFolderPath(0) $::TRUE 
		} else {
			set bvalidateFolderPath(0) [::xUtil::errMsg 44 "Folder path NOT Validated: $sFolderPath"]
		}
		return [array get bvalidateFolderPath]
	}

	namespace export  verifyBusinessObjectHasFile ;
	namespace export  getBOExist ;
	namespace export  getBOID ;
	namespace export  createBusinessObject ;
	namespace export  checkinBusinessObject ;
	namespace export  insertBusinessObjectHistory ;
	namespace export  deleteBusinessObject ;
	namespace export  deleteBusinessObject2 ;
	namespace export  deleteBusinessObjectFile ;
	namespace export  getBusinessObjectFilename ;
	namespace export  getBOAttributeValue ;
	namespace export  setBOAttributeValue ;
	namespace export  createConnection ;
	namespace export  deleteConnection ;

}; #~ end namespace xBO

