#***********************************************************************
#	gapDECPromoteValidationChecks.tcl
#***********************************************************************
#
#	This script is used to prevent the promotion of a DEC object if specified checks do not pass              
# 
#***********************************************************************
#	Ver 	Date		Who		Update description
#
#	1		2020-12-14		SJF		Initial Creation based upon drlDECPromoteValidationChecks.tcl ver 8
#
#***********************************************************************

tcl;

proc Debug { sDebugText } {

	global bDebug

	set sDebugPrefix "DEBUG: "
	set sDebugMessage "${sDebugPrefix}${sDebugText}"

	if { $bDebug == "TRUE" } {
		puts $sDebugMessage
	}
}

proc outputErrorMessage { lStateValues } {
	
	global sOutputMessage
	
	set lEmptyAttributes [ checkValues $lStateValues ]

	Debug "Returned List of Empty Attributes: $lEmptyAttributes"

	if { $lEmptyAttributes != "" } {
	
		foreach sEmptyValue $lEmptyAttributes {
			append sOutputMessage \10"- ${sEmptyValue}"
			Debug "sOutputMessage: $sOutputMessage" 
		}
		
		mql notice $sOutputMessage
		return 1
	} else {
		return 0
	}
}

proc GetLatestVersion { sObjectID } {
	Debug "Getting Latest Version.."
	set lVersion [ split [ mql expand bus $sObjectID from rel "Latest Version" recurse to 1 select bus id dump | ] | ]
	set sVersionID [ lindex $lVersion 6 ]
	return $sVersionID
}

proc GetMainFromVersion { sObjectID } {
	Debug "Getting Main from Version.."
	set lMain [ split [ mql expand bus $sObjectID from rel "VersionOf" recurse to 1 select bus id dump | ] | ]
	set sMainID [ lindex $lMain 6 ]
	return $sMainID
}

proc GetID { sType sName sRevision } {
	Debug "Getting ID for '$sType' '$sName' '$sRevision'.."
	set sID [ mql print bus $sType $sName $sRevision select id dump | ]
	Debug "ID = $sID"
	return $sID
}

proc GetDerivedType { sType } {
	Debug "Getting Derived Type for $sType"
	set sDerivedType [ mql print type $sType select derived dump | ] 
	Debug "Derived Type = $sDerivedType"
	return $sDerivedType
}

proc CheckRenamedSaveAsOnMain { sObjectID } {

	global sStatusIssue
	global sStatusMessage
    global iCounter
	global lChecksToRun
		
	if { [ lsearch $lChecksToRun "CHECK_RENAMED_OR_SAVEAS" ] != -1 } {
		
		Debug "Running check for Renamed or Save As"
		
		set lObject [ split [ mql print bus $sObjectID select type name revision dump | ] | ]
		set sType [ lindex $lObject 0 ]
		set sName [ lindex $lObject 1 ]
		set sRevision [ lindex $lObject 2 ]
		
		Debug "Checking Main Object '$sType' '$sName' '$sRevision' ($sObjectID) Found."
		
		set lDesignStatus [ split [ mql print bus $sObjectID select attribute\[Renamed From\] dump | ] | ]
		
		set sDesignStatusRenamed [ lindex $lDesignStatus 0 ]
		
		if { $sDesignStatusRenamed != "" } {
		
			Debug "Renamed value is not blank"
			
			set iCounter [ expr {$iCounter+ 1} ] 
						set sStatusIssue 1
						append sStatusMessage "--- $iCounter) "
			append sStatusMessage "'$sType' '$sName' '$sRevision' has been named either via the Rename or Saved As but has not been reopened and saved in the CAD application. "
			Debug "sStatusMessage: $sStatusMessage" 			
		
		}  else  {
		
			Debug "Object '$sObjectID' has not been Renamed or SaveAs"
			
		}
	} else {
		Debug "Skipping check for Renamed or Save As, Not Required"
	}	
}


proc CheckLockStatusOnMain { sObjectID } {

	global sStatusIssue
	global sStatusMessage
    global iCounter
	global lChecksToRun
		
	if { [ lsearch $lChecksToRun "CHECK_LOCKED" ] != -1 } {
	
		Debug "Running check for Locked"

		set lObject [ split [ mql print bus $sObjectID select type name revision dump | ] | ]
		set sType [ lindex $lObject 0 ]
		set sName [ lindex $lObject 1 ]
		set sRevision [ lindex $lObject 2 ]
			
		Debug "Main Object '$sType' '$sName' '$sRevision' ($sObjectID) Found."

		set lDesignStatus [ split [ mql print bus $sObjectID select locked dump | ] | ]
		
		set sDesignLockedStatus [ lindex $lDesignStatus 0 ]
		
		if { $sDesignLockedStatus == "TRUE" } {
		
			Debug "locked value is TRUE"
			
			set iCounter [ expr {$iCounter+ 1} ] 
			set sStatusIssue 1
			append sStatusMessage "--- $iCounter) "
			append sStatusMessage  "'$sType' '$sName' '$sRevision' is currently locked, and must be unlocked before continuing. "
			Debug "sStatusMessage: $sStatusMessage" 			
		
		}  else  {
			Debug "Object '$sObjectID' is not locked"
		}
		
	} else {
		Debug "Skipping check for Locked, Not Required"
	}
}


proc CheckObsoleteStatusOnMain { sObjectID } {
		
	global sStatusIssue
	global sStatusMessage
    global iCounter
	global lChecksToRun
		
	if { [ lsearch $lChecksToRun "CHECK_OBSOLETE" ] != -1 } {
	
		Debug "Running check for Obsolete"
		
		set lObject [ split [ mql print bus $sObjectID select type name revision dump | ] | ]
		set sType [ lindex $lObject 0 ]
		set sName [ lindex $lObject 1 ]
		set sRevision [ lindex $lObject 2 ]
		
		Debug "Checking Main Object '$sType' '$sName' '$sRevision' ($sObjectID)."

		set lDesignStatus [ split [ mql print bus $sObjectID select current dump | ] | ]
		
		set sDesignObsStatus [ lindex $lDesignStatus 0 ]
		
		if { $sDesignObsStatus == "OBSOLETE" } {
		
			Debug "state value is OBSOLETE"
			
			set iCounter [ expr {$iCounter+ 1} ] 
			set sStatusIssue 1
			append sStatusMessage "--- $iCounter) "
			append sStatusMessage  "'$sType' '$sName' '$sRevision' is at a state of OBSOLETE, CAD structure must be updated to remove obsolete object before continuing.. "
			Debug "sStatusMessage: $sStatusMessage" 			
		
		}  else  {
		
			Debug "Object '$sObjectID' is not Obsolete"
			
		}
		
	} else {
			Debug "Skipping check for Obsolete, Not Required"
	}
		
}

proc CheckPreviousRevIsReleasedMain { sObjectID } {
		
	global sStatusIssue
	global sStatusMessage
    global iCounter
	global lChecksToRun
		
	if { [ lsearch $lChecksToRun "CHECK_PREVIOUS_IS_RELEASED" ] != -1 } {
	
		Debug "Running check for previous revision is released"
		
		set lObject [ split [ mql print bus $sObjectID select type name revision dump | ] | ]
		set sType [ lindex $lObject 0 ]
		set sName [ lindex $lObject 1 ]
		set sRevision [ lindex $lObject 2 ]
		
		Debug "Checking Main Object '$sType' '$sName' '$sRevision' ($sObjectID)."
		
		#set iFound [ mql eval expr 'count TRUE' on temp query bus "$sType" * * where " revision == last AND name ~~ '$sName' AND policy == '$sPolicy'" ]
		#Debug "Number Found = $iFound"
		
		set sPreviousMinor [ mql print bus $sObjectID select previousminor dump | ]

		if { "_$sPreviousMinor" == "_" } {
			Debug "No previous revision found."
		} else {
			Debug "Previous revision '$sType' '$sName' '$sPreviousMinor' found."
			set sPreviousMinorState [  mql print bus $sType $sName $sPreviousMinor select current dump | ]
			Debug "Previous revision state = $sPreviousMinorState"
			
			if { $sPreviousMinorState != "RELEASED" } {
			
				if { $sPreviousMinorState != "OBSOLETE" } {
			
					Debug "state value is not RELEASED or OBSOLETE"
					
					set iCounter [ expr {$iCounter+ 1} ] 
					set sStatusIssue 1
					append sStatusMessage "--- $iCounter) "
					append sStatusMessage  "'$sType' '$sName' '$sRevision' has a previous revision '$sPreviousMinor' which has not been released, '$sType' '$sName' '$sPreviousMinor' must be released before continuing.. "
					Debug "sStatusMessage: $sStatusMessage" 			
				}  else  {
					Debug "Object '$sObjectID' is OBSOLETE"
				}
			}  else  {
				Debug "Object '$sObjectID' is RELEASED"
			}
		}
	} else {
			Debug "Skipping check for Previous Un-Released Revision, Not Required"
	}
		
}

proc CheckLatestStatusOnVersion { sObjectID } {

	global sStatusIssue
	global sStatusMessage
	global iCounter
	global lChecksToRun
		
	if { [ lsearch $lChecksToRun "CHECK_LATEST" ] != -1 } {
	
		Debug "Running check for Latest Version"
		
		set lObject [ split [ mql print bus $sObjectID select type name revision dump | ] | ]
		set sType [ lindex $lObject 0 ]
		set sName [ lindex $lObject 1 ]
		set sRevision [ lindex $lObject 2 ]
		
		Debug "Checking Version Object '$sType' '$sName' '$sRevision' ($sObjectID)."

		set IsLatestVersion [ mql print bus $sObjectID select relationship\[Latest Version\].to.name dump] 
										
		if {[ llength $IsLatestVersion ] > 0} {
		  set IsLatestVersion "TRUE" 
		} else {
		  set IsLatestVersion "FALSE"
		}				
		
		if { $IsLatestVersion == "FALSE" } {
		
			Debug "Object is not Latest Version"
			set iCounter [ expr {$iCounter+ 1} ] 
			set sStatusIssue 1
			append sStatusMessage "--- $iCounter) "
			append sStatusMessage "'$sType' '$sName' '$sRevision' is not the latest version, CAD structure must be updated to latest before continuing. "
			Debug "sStatusMessage: $sStatusMessage" 			
		}  else  {
			Debug "Object '$sObjectID' is latest"	
		}
	} else {
		Debug "Skipping check for Latest Version, Not Required"
	}
		
}


proc RetrieveCADSubComponents { sObjectID } {

	Debug "Running:  RetrieveCADSubComponents"
	global lProcessedSubComponentIDs
	global lChecksToRun

	if { $sObjectID ni $lProcessedSubComponentIDs } {

		lappend lProcessedSubComponentIDs $sObjectID
	
		set lSubComponents [ split [ mql expand bus $sObjectID from rel "CAD SubComponent" recurse to 0 select bus id dump | ] \n ]
		
		foreach sSubComponent $lSubComponents {
			set lSubComponent [ split $sSubComponent | ]
			set sType [ lindex $lSubComponent 3 ]
			set sName [ lindex $lSubComponent 4 ]
			set sRevision [ lindex $lSubComponent 5 ]
			set sSubComponentID [ lindex $lSubComponent 6 ]

			if { $sSubComponentID ni $lProcessedSubComponentIDs } {
				Debug "Sub Component Linked Object '$sType' '$sName' '$sRevision' ($sSubComponentID) Found."
				
				lappend lProcessedSubComponentIDs $sSubComponentID
					
				CheckLatestStatusOnVersion "$sSubComponentID"
				RetrieveCATIAV5GeometryImport "$sSubComponentID"
				
				set sMainSubComponentID [ GetMainFromVersion "$sSubComponentID" ] 
				CheckRenamedSaveAsOnMain "$sMainSubComponentID"
				CheckLockStatusOnMain "$sMainSubComponentID"		
				CheckObsoleteStatusOnMain "$sMainSubComponentID"	
				
				
			}
		}	
	}

}

proc RetrieveCATIAV5GeometryImport { sObjectID } {

	Debug "Running:  RetrieveCATIAV5GeometryImport"
	global lProcessedCATIAV5GeometryImportIDs
	global lChecksToRun

	if { $sObjectID ni $lProcessedCATIAV5GeometryImportIDs } {

		lappend lProcessedCATIAV5GeometryImportIDs $sObjectID
		#puts "expand bus $sObjectID from rel 'CATIA V5 Geometry Import' recurse to 0 select bus id dump | "
		set lSubComponents [ split [ mql expand bus $sObjectID from rel "CATIA V5 Geometry Import" recurse to 0 select bus id dump | ] \n ]
		
		foreach sSubComponent $lSubComponents {
			set lSubComponent [ split $sSubComponent | ]
			set sType [ lindex $lSubComponent 3 ]
			set sName [ lindex $lSubComponent 4 ]
			set sRevision [ lindex $lSubComponent 5 ]
			set sSubComponentID [ lindex $lSubComponent 6 ]

			if { $sSubComponentID ni $lProcessedCATIAV5GeometryImportIDs } {
				Debug "CATIA V5 Geometry Import Linked Object '$sType' '$sName' '$sRevision' ($sSubComponentID) Found."
				
				lappend lProcessedCATIAV5GeometryImportIDs $sSubComponentID
				
				#Ticket 8643 - Promote operation failing due to incorrect object ID being passed to procedure
				if { [ mql print bus $sSubComponentID select attribute\[Is Version Object\] dump ] } {
					Debug "Object ID '$sSubComponentID' is a version, checking for latest status and finding the main object..."
					CheckLatestStatusOnVersion "$sSubComponentID"					
					set sMainSubComponentID [ GetMainFromVersion "$sSubComponentID" ] 
					
				} else {
					Debug "Object ID '$sSubComponentID' is already the main object..."
					set sMainSubComponentID $sSubComponentID
				}
				
				Debug "here $sMainSubComponentID"
				CheckRenamedSaveAsOnMain "$sMainSubComponentID"
				CheckLockStatusOnMain "$sMainSubComponentID"		
				CheckObsoleteStatusOnMain "$sMainSubComponentID"	
				
			}
		}	
	}

}

proc RetrieveRelatedModels { sObjectID } {

	global lChecksToRun

	set lVersionObjects [ split [ mql expand bus $sObjectID to rel "Associated Drawing" recurse to 1 select bus id dump | ] \n ]
			
	foreach sVersion $lVersionObjects {
		set lVersion [ split $sVersion | ]
		set sType [ lindex $lVersion 3 ]
		set sName [ lindex $lVersion 4 ]
		set sRevision [ lindex $lVersion 5 ]
		set sVersionID [ lindex $lVersion 6 ]
	
		Debug "Related Model Object '$sType' '$sName' '$sRevision' ($sVersionID) Found."
		
		CheckLatestStatusOnVersion "$sVersionID"
		RetrieveCATIAV5GeometryImport $sVersionID
		
		set sMainID [ GetMainFromVersion "$sVersionID" ] 
		CheckRenamedSaveAsOnMain "$sMainID" 
		CheckLockStatusOnMain "$sMainID" 	
		CheckObsoleteStatusOnMain "$sMainID" 	

		RetrieveCADSubComponents $sVersionID
	
	}
	
}

proc RunChecksOnSelectedObject { sObjectID sType sName sRevision} {

	Debug "Running Checks on selected object '$sType' '$sName' '$sRevision' ($sObjectID) Found."
	
	CheckRenamedSaveAsOnMain $sObjectID 
	CheckLockStatusOnMain $sObjectID 
	CheckObsoleteStatusOnMain $sObjectID
	CheckPreviousRevIsReleasedMain $sObjectID
	RetrieveCATIAV5GeometryImport [ GetLatestVersion "$sObjectID" ]
}


	
eval {

	set sError [ catch {
	
		#Enable/disable debug output & Auto Commit
		set bDebug FALSE
		set bOutputENV FALSE
		
		set iRetCode 0
        set iCounter 0
		
		Debug "==================================================================================================="
		Debug "Running gapDECPromoteValidationChecks.tcl"
		Debug "==================================================================================================="
		#Outputs the available environment variables if the boolean is true
		if { $bOutputENV == "TRUE" } {
			set lENV [ mql list env ]
			Debug "Env: $lENV"
		}
		
		#Retrieve Attribute Values

		set sStateName [ mql get env STATENAME ]		
		set sObjectID [ mql get env OBJECTID ]
		set sType [ mql get env TYPE ]
		set sName [ mql get env NAME ]
		set sRevision [ mql get env REVISION ]
		set sEvent [ mql get env EVENT ]
		set sAllowedTypes [ mql get env 1 ]
		set sAllowedStates [ mql get env 2 ]
		set sChecksToRun [ mql get env 3 ]

		# TEST OBJECT SECTION - FOR USE IN TESTING VIA COMMAND LINE MQL ONLY
		#set sStateName IN_WORK
		#set sType CATPart  
		#set sName ENV0195447
		#set sEvent Promote
		#set sRevision A
		#set sObjectID [ GetID $sType $sName $sRevision ]
		#set sAllowedTypes CATDrawing,CATPart,CATProduct
		#set sAllowedStates IN_WORK
		#set sChecksToRun CHECK_RENAMED_OR_SAVEAS,CHECK_LOCKED,CHECK_LATEST,CHECK_OBSOLETE,CHECK_PREVIOUS_IS_RELEASED 
		#CHECK_RENAMED_OR_SAVEAS,CHECK_LOCKED,CHECK_LATEST,CHECK_OBSOLETE

		
		
		
		set lAllowedTypes [ split $sAllowedTypes , ]
		set lAllowedStates [ split $sAllowedStates , ]	
		set lChecksToRun [ split $sChecksToRun , ]
		
		set sOutputMessage "--The following values require entering before '$sType' '$sName' '$sRevision' can be ${sEvent}d:"
		set sStatusMessage "--The object '$sType' '$sName' '$sRevision' can not be ${sEvent}d because: "
		
		set sStatusIssue 0
		
		set lStateValues ""
		set lProcessedSubComponentIDs ""
		set lProcessedCATIAV5GeometryImportIDs ""
		
		
		if { [ lsearch $lAllowedTypes $sType ] != -1 || $sAllowedTypes == "all" } {
			
			Debug "Type of '$sType' is required. Assessing..."

			if { [ lsearch $lAllowedStates $sStateName ] != -1 } {
				Debug "Operation of $sEvent from '$sStateName' state"
				
				RunChecksOnSelectedObject "$sObjectID" "$sType" "$sName" "$sRevision"
	
				set sVersionID [ GetLatestVersion "$sObjectID" ]

				set sDerivedType [ GetDerivedType "$sType" ] 
				if { $sDerivedType == "MCAD Drawing" } {
					RetrieveRelatedModels $sVersionID 
				} else {
					RetrieveCADSubComponents $sVersionID
				}
				
			} else {
				Debug "Checks for state of '$sStateName' is not required, will not check for attribute values"
			}			
			
		} else {
			Debug "Type of '$sType' is not required, will not check for attribute values"
		}
		

		
		if { $sStatusIssue } {
		
 			mql notice $sStatusMessage
			set iRetCode 1
		
		}
		
		

	} sMessage ]
		
	if {$sError} {
		mql notice \10"$sMessage"
		set iRetCode 1
		
	} 	
	
	return -code $iRetCode
		
}


