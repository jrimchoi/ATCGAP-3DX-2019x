tcl;
eval {
    proc utLoad { sProgram } { 

	global glUtLoadProgs env

	if { ! [ info exists glUtLoadProgs ] } {
	    set glUtLoadProgs {}
	}

	if { [ lsearch $glUtLoadProgs $sProgram ] < 0 } {
	    lappend glUtLoadProgs $sProgram
	} else {
	    return ""
	}

	if { [ catch {
		    set sDir "$env(TCL_LIBRARY)/mxTclDev"
		    set pFile [ open "$sDir/$sProgram" r ]
		    set sOutput [ read $pFile ]
		    close $pFile

		} ] == 0 } { return $sOutput }

	set  sOutput [ mql print program \"$sProgram\" select code dump ]

	return $sOutput
    }
    # end utLoad

    eval  [utLoad eServiceSchemaVariableMapping.tcl]
    eval  [utLoad eServicecommonPSUtilities.tcl]
    eval  [utLoad eServicecommonDEBUG.tcl]

    set sVault [mql get env 1]
    set sPrimaryObjectType [mql get env 2]
    set sNewName [mql get env 3]
    set sRev [mql get env 4]
    set sSafetyVault [mql get env 5]
    set ObjectPolicy [mql get env 6]
    set sRealUser [mql get env 7]
    set CreateAdditional [mql get env 8]
    set ObjectGeneratorName [mql get env 9]
    set ObjectGeneratorRevision [mql get env 10]
    set RegProgName "eServiceSchemaVariableMapping.tcl"

    set mqlret 0
    set sTypeeServiceObjectGenerator      [eServiceGetCurrentSchemaName  type $RegProgName          type_eServiceObjectGenerator ]
    set sReleServiceAdditionalObject      [eServiceGetCurrentSchemaName  relationship $RegProgName  relationship_eServiceAdditionalObject ]
    set sAttreServiceNamePrefix           [eServiceGetCurrentSchemaName  attribute $RegProgName     attribute_eServiceNamePrefix ]
    set sAttreServiceNameSuffix           [eServiceGetCurrentSchemaName  attribute $RegProgName     attribute_eServiceNameSuffix ]
    set sAttreServiceConnectRelation      [eServiceGetCurrentSchemaName  attribute $RegProgName     attribute_eServiceConnectRelation ]

    set lConSolidateSet       {}
    set lErrorSet             {}


    # Add object
    if {$sVault == "ADMINISTRATION"} {
	set sCmd {mql add bus $sPrimaryObjectType $sNewName $sRev vault "$sSafetyVault" policy "$ObjectPolicy" select id dump}
	set sReturnVault $sSafetyVault
    } else {                                              
	set sCmd {mql add bus $sPrimaryObjectType $sNewName $sRev vault "$sVault" policy "$ObjectPolicy" select id dump}
	set sReturnVault $sVault
    }
    set mqlret [catch {eval $sCmd} outstr]

    if {$mqlret == 0} {
	set sNewObjectID $outstr
    }
    # change owner to real user
    if {$mqlret == 0} {
	set sCmd {mql mod bus "$sNewObjectID" owner "$sRealUser" }
	set mqlret [catch {eval $sCmd} outstr]
    }

    #if {$mqlret == 0} {
    #   set sCmd {mql print bus $sPrimaryObjectType $sNewName $sRev select id dump}
    #   set mqlret [catch {eval $sCmd} outstr]
    #  }

    if {$mqlret == 0} {                   
	lappend lConSolidateSet [ list $sNewObjectID $sPrimaryObjectType $sNewName $sRev $sReturnVault]
    }

    if {($mqlret == 0) && ($CreateAdditional == "Additional")} {

	set sCmd {mql expand bus "$sTypeeServiceObjectGenerator" "$ObjectGeneratorName" "$ObjectGeneratorRevision" \
		   from relationship $sReleServiceAdditionalObject  \
		   select bus \
		      id \
		      attribute\[$sAttreServiceNamePrefix\].value \
		      attribute\[$sAttreServiceNameSuffix\].value \
		   select relationship \
		      attribute\[$sAttreServiceConnectRelation\].value \
		   dump |}
	set mqlret [catch {eval $sCmd} outstr]

	if {$mqlret == 0} {

	    set outstr [split $outstr \n]

	    foreach i $outstr {

		set sAdditonalObject          [string trim [lindex [split $i |] 4 ] ]
		set sAdditonalPrefix          [string trim [lindex [split $i |] 7 ] ]
		set sAdditonalSuffix          [string trim [lindex [split $i |] 8 ] ]
		set sAdditonalConnectRel      [string trim [lindex [split $i |] 9 ] ]

		if {[string first "type_" "$sAdditonalObject"] == 0} {
		    set sAdditonalObject [eServiceGetCurrentSchemaName  type "$RegProgName" "$sAdditonalObject"]
		}
		if {[string first "relationship_" "$sAdditonalConnectRel"] == 0} {
		    set sAdditonalConnectRel [eServiceGetCurrentSchemaName  type "$RegProgName" "$sAdditonalConnectRel"]
		}
		set sAddPolicy                [mxTypeGetDfltPolicy $sAdditonalObject]
		set sAddRev                   [mxPolGetInitRev $sAddPolicy]

		set sAddNewName "$sAdditonalPrefix$sNextNumber$sAdditonalSuffix"

		set sCmd {mql temp query bus "$sAdditonalObject" "$sAddNewName" "sAddRev" select exists id dump | }
		set mqlret [catch {eval $sCmd} outstr]

		if {$mqlret == 0} {

		    set sExistence [string trim [lindex [split $outstr |] 3]]
		    set sID        [string trim [lindex [split $outstr |] 4]]

		    if {$sExistence != "TRUE"} {
			if {$sVault == "ADMINISTRATION"} {
			    set sCmd {mql add bus $sAdditonalObject $sAddNewName $sAddRev vault "$sSafetyVault" policy "$sAddPolicy" select id dump | }
			    set sReturnVault $sSafetyVault
			} else {
			    set sCmd {mql add bus $sAdditonalObject $sAddNewName $sAddRev policy "$sAddPolicy" select id dump | }
			    set sReturnVault $sSafetyVault
			}
			set mqlret [catch {eval $sCmd} outstr]

			# if {$mqlret == 0} {
			#     set sCmd {mql print bus $sAdditonalObject $sAddNewName $sAddRev select id dump}
			#     set mqlret [catch {eval $sCmd} outstr]
			# }

			if {$mqlret == 0} {
			    set sNewObjectID $outstr
			    lappend lConSolidateSet [ list $sNewObjectID $sAdditonalObject $sAddNewName $sAddRev $sReturnVault]

			}
		    }

		    if {$mqlret == 0} {
			set sCmd {mql mod bus "$sNewObjectID" owner "$sRealUser" }
			set mqlret [catch {eval $sCmd} outstr]
		    }

		    if {$mqlret == 0} {
			set sCmd {mql connect bus "$sPrimaryObjectType" "$sNewName" "$sRev" \
				rel "$sAdditonalConnectRel" to "$sNewObjectID"}
			set mqlret [catch {eval $sCmd} outstr]
		    }
		}
	    }
	}
    }
    if {$mqlret == 0} {
	return $lConSolidateSet
    } else {
	if {[lindex $lErrorSet 1] == ""} {
	    set lErrorSet [list "" "$outstr"]
	}
	return $lErrorSet
    }
}

