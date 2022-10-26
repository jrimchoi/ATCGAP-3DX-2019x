###############################################################################
# NOTE: REMOVE THE FOLLOWING LINE BEFORE SUBMITTING TO PS DATABASE
# $RCSfile: eServicecommonTrigcChangeOwner_if.tcl.rca $ $Revision: 1.20 $
#
# @libdoc       eServicecommonTrigcChangeOwner_if
#
# @Library:     Interface for changing ownership of an object.
#
# @Brief:       Change the ownership of an object to a specified user or
#               user logged on.
#
# @Description: see procedure description
#
# @libdoc       Copyright (c) 1993-2018, Dassault Systemes. All Rights Reserved.
#               This program contains proprietary and trade secret
#               information of Matrix One, Inc.  Copyright notice is
#               precautionary only and does not evidence any actual or
#               intended publication of such program.
#
# The following sample code is provided for your reference purposes in
# connection with your use of the Matrix System (TM) software product
# which you have licensed from MatrixOne, Inc. ("MatrixOne").
# The sample code is provided to you without any warranty of any kind
# whatsoever and you agree to be responsible for the use and/or incorporation
# of the sample code into any software product you develop. You agree to fully
# and completely indemnify and hold MatrixOne harmless from any and all loss,
# claim, liability or damages with respect to your use of the Sample Code.
#
# Subject to the foregoing, you are permitted to copy, modify, and distribute
# the sample code for any purpose and without fee, provided that (i) a
# copyright notice in the in the form of "Copyright 1995 - 1998 MatrixOne Inc.,
# Two Executive Drive, Chelmsford, MA  01824. All Rights Reserved" appears
# in all copies, (ii) both the copyright notice and this permission notice
# appear in supporting documentation and (iii) you are a valid licensee of
# the Matrix System software.
#
###############################################################################

tcl;
eval {

###############################################################################
#
# Define Global Variables
#
###############################################################################


###############################################################################
#
# Procedure:    utLoad
#
# Description:  Procedure to load other tcl utilities procedures.
#
# Parameters:   sProgram                - Tcl file to load
#
# Returns:      sOutput                 - Filtered tcl file
#               glUtLoadProgs           - List of loaded programs
#
###############################################################################

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
# end utload


###############################################################################
#
# Load MQL/Tcl utility procedures
#
###############################################################################
eval  [ utLoad eServiceSchemaVariableMapping.tcl]
eval  [utLoad eServicecommonDEBUG.tcl]

###############################################################################
#
# Define Procedures
#
###############################################################################

#******************************************************************************
# @procdoc      eServicecommonTrigcChangeOwner_if
#
# @Brief:       Change ownership of object.
#
# @Description: This program will change the ownership of the object to user
#               who is specified in RPE variable.  If no user is defined, then
#               the user who is logged on will become the new owner of the
#               object.
#
# @Parameters:  Inputs via RPE:
#                     sObjId      - Object's Id
#                     [mql env 1] - The user to change ownership to.  If this
#                                   field is left blank the user logged on will
#                                   become the new owner.
#
# @Returns:     0 if successfull
#               1 if not successfull
#
# @Usage:       For use as trigger action on promote
#
# @Example:     configure mxTrigMgr thusly:
#               [mql env 1] - Corporate
#
# @procdoc
#******************************************************************************
    # Get Program names
    set progname      [mql get env 0]
    set RegProgName   "eServiceSchemaVariableMapping.tcl"

    mql verbose off

    # Load Schema Mapping
    eval [utLoad $RegProgName]

    # Get data values from RPE
    set sObjId [mql get env OBJECTID]
    set sNewOwner [mql get env 1]

    # If nothing is entered change ownership to user logged on
    if {[string trim $sNewOwner] == ""} {
        set sNewOwner [mql get env USER]
    }

    # Initialize Error variables
    set mqlret 0
    set outStr ""

    if {$mqlret == 0} {
        # Change ownership
        set sCmd {mql mod bus $sObjId owner $sNewOwner}

        set mqlret [catch {eval $sCmd} outstr]
    }

    if {$mqlret == 1} {
        mql notice "$progname :\n\n$outstr"
        return 1
    } else {
        return $mqlret
    }
}
# end eServicecommonTrigcChangeOwner_if


# End of Module

