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

    set lErrorSet {}
    set sRetryCount [mql get env 1]
    set sRetryDelay [mql get env 2]
    set sNumberGeneratorId [mql get env 3]

    set sAttreServiceNextNumber           [eServiceGetCurrentSchemaName  attribute "eServiceSchemaVariableMapping.tcl" attribute_eServiceNextNumber ]

    # push to Shadow agent to have access to the number generator object
    #pushShadowAgent

    set mqlret [catch {mql start thread} outstr]
    if {$mqlret != 0} {
        set lErrorSet [list "" "mql start thread failed: $outstr"]
        return -code 1 $lErrorSet
    }

    set mqlret [catch {mql start transaction} outstr]
    if {$mqlret != 0} {
        set lErrorSet [list "" "mql start transaction failed: $outstr"]
        catch {mql kill thread} outstr
        return -code 1 $lErrorSet
    }

    set i $sRetryCount

    # start retry loop, try to lock until number of retry limit reached              
    while {$i > 0} {

        # Try to lock the Name Generator Object. When sucessfully locked we
        # prevent other from modify the number generator at the same time
        set sCmd {mql lock bus "$sNumberGeneratorId"}
        set mqlret [catch {eval $sCmd} outstr]

        # Lock sucessfull
        if {$mqlret == 0} {
            break

        # Lock failed
        } else {

             # If not locked and we was not able to lock, something 
             # else is wrong, return from this proc with the error
             if {[string first "locked" "$outstr"] == -1} {
                #popShadowAgent
                return -code 1 [list "" "The Number Generator ($sNumberGeneratorObject) could not generate the name, contact the Administrator. $outstr"]
             }

             # wait for sRetryDelay ms
             after $sRetryDelay

             # Decrease the counter
             incr i -1
        }
    }
    # End of while loop for the retry


    # If errors, the object is not accessible after sRetryCount, warn
    # the user and stop any further processing
    if {$mqlret != 0} {
        #popShadowAgent
        set lErrorSet [list "" "The Number Generator Object ($sNumberGeneratorObject) is busy, Please try later, If the problem persists contact the Administrator\n$outstr"]
        return -code 1 $lErrorSet
    } 

    # no errors were encountered and number generator is now locked.
    # It is now safe to get the next number attribute
    if {$mqlret == 0 } {
        # get the value of the next number attribute
        set sCmd {mql print bus "$sNumberGeneratorId" \
                      select \
                          attribute\[$sAttreServiceNextNumber\].value \
                      dump |}
        set mqlret [catch {eval $sCmd} outstr]
        if {$mqlret != 0} {
            set sCmd {mql unlock bus "$sNumberGeneratorId"}
            set mqlret1 [catch {eval $sCmd} outstr1]
        }
    }
    if {$mqlret == 0} {
        set lResult $outstr

        set sNextNumber    [string trim [lindex [split $lResult |] 0] ]
        set sModNextNumber [utStrSequence $sNextNumber 1]

        # modify the new number attribute on number generator object
        # with the new value
        set sCmd {mql mod bus "$sNumberGeneratorId" "$sAttreServiceNextNumber" "$sModNextNumber"}
        set mqlret [catch {eval $sCmd} outstr]
        if {$mqlret != 0} {
            set sCmd {mql unlock bus "$sNumberGeneratorId"}
            set mqlret1 [catch {eval $sCmd} outstr1]
        }
    }

    # end of processing of the number generator, unlock the object
    if {$mqlret == 0} {
        set sCmd {mql unlock bus "$sNumberGeneratorId"}
        set mqlret [catch {eval $sCmd} outstr]
    }

    set mqlret [catch {mql commit transaction} outstr]
    if {$mqlret != 0} {
        set lErrorSet [list "" "mql commit transaction failed: $outstr"]
        catch {mql kill thread} outstr
        return -code 1 $lErrorSet
    }

    set mqlret [catch {mql kill thread} outstr]
    if {$mqlret != 0} {
        set lErrorSet [list "" "mql kill thread failed: $outstr"]
        return -code 1 $lErrorSet
    }
    return -code 0 [list "$sNextNumber"]
    #popShadowAgent
}

