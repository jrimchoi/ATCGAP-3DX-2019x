###############################################################################
# NOTE: REMOVE THE FOLLOWING LINE BEFORE SUBMITTING TO PS DATABASE
# $RCSfile: eServicecommonTrigcRequiredFormat_if.tcl.rca $ $Revision: 1.21 $
#
# @libdoc       eServicecommonTrigcRequiredFormat_if
#
# @Library:     Interface for required format checks for triggers
#
# @Brief:       Compare specified attribute to its default value
#
# @Description: see procedure description
#
# @libdoc       Copyright (c) 1993-2016, Dassault Systemes. All Rights Reserved.
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
eval  [ utLoad eServicecommonDEBUG.tcl ]
eval  [ utLoad eServiceSchemaVariableMapping.tcl]
eval  [ utLoad eServicecommonRequiredFormat.tcl ]
###############################################################################
#
# Define Procedures
#
###############################################################################

#******************************************************************************
# @procdoc      eServicecommonTrigcRequiredFormat_if.tcl
#
# @Brief:       Check that at one file having size greater then zero exsists
#               in specified format.
#
# @Description: Check that at one file having size greater then zero exsists
#               in specified format.
#
# @Parameters:  format    -- format to search for.
#
# @Returns:     0 for no file, 1 otherwise
#
#
# @procdoc
#******************************************************************************

  #
  # Debugging trace - note entry
  #
  set progname      "eServicecommonTrigcRequiredFormat_if"
  set RegProgName   "eServiceSchemaVariableMapping.tcl"
  mxDEBUGIN "$progname"
  mql verbose off;
  set sSearchKey             [mql get env 1]
  set lFormatPropertyList    [mql get env 2]
  set bSizeCheck             [mql get env 3]

  set lFormatList {}

  #  look for schema names
  if {$sSearchKey != "default" && $sSearchKey != "all"} {
      foreach sItem $lFormatPropertyList {
          lappend lFormatList [eServiceGetCurrentSchemaName format $RegProgName $sItem ]
      }
  }


  #
  # Get data values from RPE
  #
  set sType     [ mql get env TYPE ]
  set sName     [ mql get env NAME ]
  set sRev      [ mql get env REVISION ]

  #
  # Error handling variables
  #
  set mqlret 0
  set outStr ""

  set mqlret [catch {eval eServicecommonRequiredFormat {$sType} {$sName} {$sRev} {$sSearchKey} {$lFormatList} {$bSizeCheck}} outStr]

  #
  # Debugging trace - note exit
  #
  mxDEBUGOUT "$progname"

  #return -code $mqlret "$outStr"
  exit $mqlret
}
# end eServicecommonTrigcRequiredFormat_if


# End of Module

