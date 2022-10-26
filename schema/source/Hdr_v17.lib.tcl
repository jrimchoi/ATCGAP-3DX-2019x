# @PROGDOC: Universal GLOBAL Constants supporting all X packages in project
# @Namespace/Class = (global) + xLib
# @Methods = UpdateLibDir(sLibDir), FindLib(sLibFile), LoadAllLibs() 
# @Properties = ::LIBDIR
# @Program = Hdr_v17.lib.tcl
# @Version  = 17.0
# @Synopsis = implementation support library
# @Purpose = to provide global constants and library mgmt
# @Implementation = source Hdr.lib.tcl (source C:/root/Razorleaf.VSTS/ACG/Migration/Lib)
# @Package = package require Hdr;
# @Object = (null)


###############################################################################
#~ ABORTONERROR: 0=ignore errors and continue import (no transaction boundary mgmt)
#~ ABORTONERROR: 1=manage transaction boundaries, abort trans on errors
set ::ABORTONERROR 0
#~ DEBUG: 0=off 1=on
set DEBUG 1
#~ VERBOSE: 0=off 1=stack trace 2=MQL RPE ENV 3+=full dump of namespace environment
set VERBOSE 1
#~ SILENT: prompt to pause, 0=silent 1=not silent
set SILENT 0
#~ LOG: 0=no logging to LOGPATH 1=log to logpath 2=log to obj description 3=log to obj history
set LOG 1
#~ DEFAULTOWNER: if no owner is present in the data, use this owner for obj creation
set DEFAULTOWNER "UTBMIG"
#~ OOTB: 1 = use out-of-the-box functions, 0 = use only internal functions
set OOTB 0
#~ TRACE: 0=off, 1=trace before/after commands
set TRACE 1
#~ TRACETYPE: list of validate trace types:
set TRACETYPE "mql"

###############################################################################
#~ GLOBAL constants - tri-boolean state
set ERR -1
set FALSE 0
set TRUE 1

#~~~ Generic Tri-Boolean Constants values
set TRUE 1
set FALSE 0
set ERROR -1

set DELIMS [list = / ]

#~ Trigger constants
set BLOCK 1
set PASS  0
###############################################################################
#~ sTimeStamp: marker for part of unique process thread ID
set sTimeStamp  [clock seconds]
set sTimeStampX [clock format [clock seconds] -format "%a%Y%b%dv%H%M%S"]


###############################################################################
#~ global constants
set iBUFFERSIZE 1000
set iFILEPTR_INITOFFSET 0
set xTRUE   1
set xFALSE  0
set xERROR -1

###############################################################################
#~ error severity levels
set ERRSEV(INFORMATIONAL)		0
set ERRSEV(WARNING)				-1
set ERRSEV(NONCATASTROPHIC)		-2
set ERRSEV(CATASTROPHIC)		-5
set ERRSEV(ABORTTRANSACTION)	-7
set ERRSEV(ABORTIMMEDIATE)		-9

###############################################################################
#~ error codes
set ERRCODES(0) "Error - An Error has occured"
set ERRCODES(1) "Error - Attribute value out-of-range"
set ERRCODES(2) "Error - Relationship Disconnect not allowed"
set ERRCODES(3) "Error - File Base name returned null"
set ERRCODES(4) "Error - File does not exist or is a Directory."
set ERRCODES(5) "Error - Target File exists and cannot be overwritten"
set ERRCODES(6) "Error - Delete attempt failed, File exists"
set ERRCODES(7) "Error - Businessobject File rename failed"
set ERRCODES(8) "Error - Businessobject Checkin failed"
set ERRCODES(9) "Error - Businessobject Rename Attempt failed"
set ERRCODES(10) "Error - Businessobject Connection Attempt failed"
set ERRCODES(11) "Error - Businessobject does not exist"
set ERRCODES(12) "Error - Businessobject disconnect failed, Object will be orphaned"
set ERRCODES(13) "Error - Set creation failed"
set ERRCODES(14) "Error - Filename must be updated before action"
set ERRCODES(15) "Error - Businessobject Delete attempt failed"
set ERRCODES(16) "Error - Businessobject Create attempt failed"
set ERRCODES(17) "Error - Businessobject Modify attempt failed"
set ERRCODES(18) "Error - Businessobject Checkout attempt failed"
set ERRCODES(19) "Error - Businessobject Promote/Approve attempt failed"
set ERRCODES(20) "Error - Businessobject Demote/Reject attempt failed"
set ERRCODES(21) "Error - Businessobject Specifications can not be resolved"
set ERRCODES(22) "Error - Can not auto-increment object version"
set ERRCODES(23) "Error - Businessobject has no file"
set ERRCODES(24) "Error - Businessobject already exists, cannot create"
set ERRCODES(25) "Error - Integration temporary Businessobject deleted"
set ERRCODES(26) "Error - Cannot determine Policy revision sequence"
set ERRCODES(27) "Error - Cannot change Businessobject Policy"
set ERRCODES(28) "Error - Cannot update Businessobject Attribute"
set ERRCODES(29) "Error - Cannot update Businessobject ACAD Drawing Integraton Attributes"
set ERRCODES(30) "Error - Businessobject Incorrect Type, NOT ACAD Drawing"
set ERRCODES(31) "Error - Relationship(Vaulted Documents Rev2) can not update Object"
set ERRCODES(32) "Error - Businessobject PROJECT is null"
set ERRCODES(33) "Error - Connection, can not delete connection"
set ERRCODES(34) "Error - Businessobject file deletion error"
set ERRCODES(35) "Error - Attribute does not exist"
set ERRCODES(36) "Error - Invalid Collaborative Space"
set ERRCODES(38) "Error - Invalid WorkSpace"
set ERRCODES(39) "Error - Invalid WorkSpace Folder structure"
set ERRCODES(40) "Error - Invalid Interface/Attribute Group"
set ERRCODES(41) "Error - Invalid classification"
set ERRCODES(42) "Error - could not update object attributes"
set ERRCODES(43) "Error - could not update object Description"
set ERRCODES(44) "Error - invalid Workspace/Folder"
set ERRCODES(45) "Error - Cannot revise Businessobject revision chain"
set ERRCODES(46) "Error - Revision sequence could not be validated"
set ERRCODES(47) "Error - Next revision is outside Policy Revision sequence"
set ERRCODES(48) "Error - Cannot create File Version or Derived Output"
set ERRCODES(49) "Error - Cannot udpate Businessobject Property(s)"

set ERRCODES(50) "Error - xAutonamer: no Autonamer object for this TYPE"
set ERRCODES(51) "Error - xAutonamer: the Object old/native name has already been used in the system"
set ERRCODES(52) "Error - xAutonamer: the Object new/autogenerated name has already been used in the system"
set ERRCODES(53) "Error - xAutonamer: Could not update AUTONAMER Object with NEXT number"
set ERRCODES(54) "Error - xAutonamer: NEXT number has exceeded Autonamer total padding size"

set ERRCODES(60) "Error - Query returned exception, aborting"


set ERRCODES(100) "Error - Minimum Object Credentials not in Migration Schema, aborting"
set ERRCODES(101) "Error - Malformed Object Schema definition, aborting"
set ERRCODES(102) "Error - Malformed Object record"
set ERRCODES(103) "Error - Migration Object already exists"
set ERRCODES(104) "Error - Migration Object Validation Failed"

set ERRCODES(200) "Error - PnO Security Model: Error occured"
set ERRCODES(201) "Error - PnO Security Model: Invalid Project"
set ERRCODES(202) "Error - PnO Security Model: Invalid Project (Collaborative Space)"
set ERRCODES(203) "Error - PnO Security Model: Invalid Project (PnOProject)"
set ERRCODES(203) "Error - PnO Security Model: Invalid Project (Security Context)"

set ERRCODES(250) "Error - PnO Security Model: Invalid Organization (Company)"


set ERRCODES(500) "Error - Cannot close Project"

set ERRCODES(997) "SYSTEM Error - Library path not valid for code DLL(s), Aborting"
set ERRCODES(998) "SYSTEM Error - Library path not valid for code libraries"
set ERRCODES(999) "SYSTEM Error - RPE error"
set ERRCODES(1000) "SYSTEM TEST - This is a test of the error code system"


set WARNCODES(28) "WARNING: attribute range member"

set WARNCODES(35) "WARNING: set attribute failed"

set WARNCODES(100) "WARNING: no TO object detected, will construct relationship later"
set WARNCODES(101) "WARNING: attribute does not exist on Object"

###############################################################################
#~ for looping through multiple DB files
set xDBFILEID "txt"

#~ Minimum Schema required to validate an object definition at LEVEL 2
set MINSCHEMA [list TYPE NAME REVISION OWNER VAULT POLICY]


###############################################################################
#~ Field, Key, and Name/value pair delimiters for "flat file" DB parsing
set cFLDDELIM "|"
set cKEYDELIM ":"
set cPAIRDELIM "="
set cSUBDELIM  "/"

###############################################################################
#~~~ File Kind: file kind is a derivative of the file extension as mapped to a generic/normalized type of file, that can in lueu of explicite MXFORMAT be used
#~~~      The file EXT as returned by fileInfo() can be the associative array index to determine the KIND, also returned by fileInfo()
set xFILEKIND(DWG)      "CAD"
set xFILEKIND(DGN)      "CAD"
set xFILEKIND(SLDPART)  "CAD"
set xFILEKIND(SLDASSY)  "CAD"
set xFILEKIND(DOC)      "DOC"
set xFILEKIND(DOCX)     "DOC"
set xFILEKIND(XLS)      "DOC"
set xFILEKIND(XLSX)     "DOC"
set xFILEKIND(XML)      "XML"
set xFILEKIND(LOG)      "LOG"
set xFILEKIND(LOG)      "LOG"
set xFILEKIND(SEMA)     "SEMA"

###############################################################################
#~ revision sequence key maps
set ::REVSEQ(0) "0,1,2,3,4,5,6,7,8,9,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27"
set ::REVSEQ(1) "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"

set ::XREVSEQ(BL?,BL??,BL???) "BL?,BL??,BL???"

set ::XREVSEQ(A-Z) "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"
set ::XREVSEQ(0-9) "0,1,2,3,4,5,6,7,8,9"
set ::XREVSEQ(0,1,2,...) "0,1,2,3,4,5,6,7,8,9,"
for {set i 10} {$i <= 500} {incr i} {
	append ::XREVSEQ(0,1,2,...) "$i" ","
}
set ::XREVSEQ(1,2,3,...) "1,2,3,4,5,6,7,8,9,"
for {set i 10} {$i <= 500} {incr i} {
	append ::XREVSEQ(1,2,3,...) "$i" ","
}
set ::XREVSEQ(A-Z,AA-ZZ) "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,"
foreach iRev [split [lindex [array get ::XREVSEQ "A-Z"] 1] ,] {
	foreach jRev [split [lindex [array get ::XREVSEQ "A-Z"] 1] ,] {
		append ::XREVSEQ(A-Z,AA-ZZ) "$iRev" "$jRev" ","
	}
}

###############################################################################
#~ Autonamer Object inclusions and exceptions
set ::AUTONAMERTYPEINCLUSIONLIST [list "Document" \
"MS Word Document" \
"MS Excel Document" \
"MS PowerPoint Document" \
"Drawing Print" \
"gapCalculatedOutputSpecification" \
"gapGAPSpecification" \
"gapSoftwareSpecification" \
"Quality Document" \
"Quality System Document" \
"gapAutoCAD"]

set ::AUTONAMERTYPEEXCLUSIONLIST [list ]

set ::AUTONAMERPOLICYINCLUSIONLIST [list ]

set ::AUTONAMERPOLICYEXCLUSIONLIST [list "Version" \
"Requirement Version" \
"Versioned Design TEAM Policy" \
"Version Document" \
"Versioned Design Policy" \
"Versioned Design TEAM Policy" \
"RFQ History Version" \
"RFQ Pending Version"]

###############################################################################
#~ Versionable Object inclusions and exceptions
set ::VERSIONABLETYPEINCLUSIONLIST [list "DOCUMENTS" \
"Document" \
"Requirement" \
"Version Document" \
"gapGAPSpecification" \
"MS Word Document" \
"MS Excel Document" \
"MS PowerPoint Document" \
"Drawing Print" \
"gapAutoCAD" \
"Quality System Document"]


array set ::VERSIONABLETYPEPOLICY [list DOCUMENTS "Version"]
array set ::VERSIONABLETYPEPOLICY [list Requirement "Requirement Version"]
array set ::VERSIONABLETYPEPOLICY [list "Version Document" "Version Document"]
array set ::VERSIONABLETYPEPOLICY [list "gapGAPSpecification" "Version"]
array set ::VERSIONABLETYPEPOLICY [list "Document" "Version"]
array set ::VERSIONABLETYPEPOLICY [list "MS Word Document" "Version"]
array set ::VERSIONABLETYPEPOLICY [list "MS Excel Document" "Version"]
array set ::VERSIONABLETYPEPOLICY [list "MS PowerPoint Document" "Version"]
array set ::VERSIONABLETYPEPOLICY [list "Drawing Print" "Version"]
array set ::VERSIONABLETYPEPOLICY [list "gapAutoCAD" "Version"]
array set ::VERSIONABLETYPEPOLICY [list "Quality System Document" "Version"]

set ::VERSIONFORMATEXCLUSIONS [list "PDF"]



###############################################################################
#~ CAD Object inclusions and exceptions, for turning triggers ON during create
set ::CADTYPEINCLUSIONLIST [list "SW Component Family" \
"SW Component Instance" \
"SW Assembly Family" \
"SW Assembly Instance" \
"SW Drawing" ]

array set ::CADPOLICYINCLUSIONLIST [list "SW Component Family"		"Design TEAM Definition"]
array set ::CADPOLICYINCLUSIONLIST [list "SW Component Instance"	"Design TEAM Definition"]
array set ::CADPOLICYINCLUSIONLIST [list "SW Assembly Family"		"Design TEAM Definition"]
array set ::CADPOLICYINCLUSIONLIST [list "SW Assembly Instance"		"Design TEAM Definition"]
array set ::CADPOLICYINCLUSIONLIST [list "SW Drawing"				"Design TEAM Definition"]



###############################################################################
#	The purpose of this section is to define the conditions under which
#	a Derived Output object is created and connected to a MAIN or VERSION
#	object.
#	Where:
#		- INCLUSION = create a derived output where ALL inclusion rules are TRUE
#		- EXCLUSION = do NOT create derived output where ANY exclusion rules are TRUE
#		- (Intrinsic) = nothing is included if it is not explicitely defined
#	TYPE:	only create Derived Output object for TYPE defined in list
#	POLICY: if TYPE, then only create Derived Output object for obj of TYPE where policy = one of the specified policies
#	STATE:	if TYPE .and. POLICY, then object must be in one of the members of the CDL (comma delimited list) - Note cumulative for all policies

#~ Derived Output Object TYPE inclusions and exceptions
set ::DERIVEDOUTPUTINCLUSIONLIST [list "gapGAPSpecification" \
"gapAutoCAD" \
"MS Excel Document" \
"MS Word Document" \
"Quality System Document" \
"gapSoftwareSpecification" \
"ACAD Drawing" \
"SW Drawing" ]

#~ DERIVED OUTPUT OBJECT File Format(s) as defined for creation and population of attached derived output objects
set ::DERIVEDOUTPUTFORMATINCLUSIONLIST [list "PDF"]


#~ DERIVED OUTPUT OBJECT POLICY INCLUSIONS AND EXCEPTIONS
array set ::DERIVEDOUTPUTPOLICYINCLUSIONLIST [list 	"gapSoftwareSpecification" 	"Part Specification,Version"]
array set ::DERIVEDOUTPUTPOLICYINCLUSIONLIST [list 	"gapGAPSpecification"		"Part Specification,Version"]
array set ::DERIVEDOUTPUTPOLICYINCLUSIONLIST [list 	"MS Word Document"			"Document Release,Version"]
array set ::DERIVEDOUTPUTPOLICYINCLUSIONLIST [list 	"MS Excel Document"			"Document Release,Version"]
array set ::DERIVEDOUTPUTPOLICYINCLUSIONLIST [list 	"ACAD Drawing"				"CAD Drawing,Version"]
array set ::DERIVEDOUTPUTPOLICYINCLUSIONLIST [list 	"gapAutoCAD"				"CAD Drawing,Version"]
array set ::DERIVEDOUTPUTPOLICYINCLUSIONLIST [list 	"SW Drawing"				"Design TEAM Definition,Versioned Design TEAM Policy"]
array set ::DERIVEDOUTPUTPOLICYINCLUSIONLIST [list 	"Quality System Document"	"Controlled Documents,Version"]

#~ DERIVED OUTPUT OBJECT STATE INCLUSIONS AND EXCEPTIONS
array set ::DERIVEDOUTPUTMAINSTATEINCLUSIONLIST [list 	"gapSoftwareSpecification"	"Release,Obsolete,Exists"]
array set ::DERIVEDOUTPUTMAINSTATEINCLUSIONLIST [list 	"gapGAPSpecification"		"Release,Obsolete,Exists"]
array set ::DERIVEDOUTPUTMAINSTATEINCLUSIONLIST [list 	"MS Word Document"			"RELEASED,OBSOLETE,Exists"]
array set ::DERIVEDOUTPUTMAINSTATEINCLUSIONLIST [list 	"MS Excel Document"			"RELEASED,OBSOLETE,Exists"]
array set ::DERIVEDOUTPUTMAINSTATEINCLUSIONLIST [list 	"ACAD Drawing"				"Release,Obsolete,Exists"]
array set ::DERIVEDOUTPUTMAINSTATEINCLUSIONLIST [list 	"gapAutoCAD"				"Release,Obsolete,Exists"]
array set ::DERIVEDOUTPUTMAINSTATEINCLUSIONLIST [list 	"SW Drawing"				"RELEASED,OBSOLETE,Exists"]
array set ::DERIVEDOUTPUTMAINSTATEINCLUSIONLIST [list 	"Quality System Document"	"Released,Superseded,Obsolete,Exists"]

#~ DERIVED OUTPUT OBJECT FILE EXTENSION EXCEPTIONS
set ::DERIVEDOUTPUTFILEEXTENSIONEXCLUSIONLIST [list "XML"]

###############################################################################



###############################################################################
#~ Name Cross-Mapping registry for old vs autonamer generated names for Relationship mapping
set ::NAMEMAPREGISTRY {}

###############################################################################
#~ Default LOG/DON/ERR semaphore paths, to prevent errors, set to global area first
set sTimeStampX [clock format [clock seconds] -format "%a%Y%b%dv%H%M%S"]
set  ::XMLDEFAULTPATH "C:/root/tmp/staging/log/"
set  ::XMLDEFAULTLOG [file join $::XMLDEFAULTPATH "3dxMigration_${sTimeStampX}.log"]
set  ::XMLDEFAULTDON [file join $::XMLDEFAULTPATH "DON.sema"]
set  ::XMLDEFAULTERR [file join $::XMLDEFAULTPATH "ERR.sema"]


###############################################################################

namespace eval ::xCfg {

	# @Method(global): ::xUtil::loadConfig() - loads 3DXMigrationSolution.cfg, instantiate settings at global namespace
	proc loadConfig {{sScriptPath ""}} {
		if {"$sScriptPath" == ""} {
			set sScriptPath [info script]
		}
		set sCFG_Path [file dirname [file normalize "$sScriptPath"]]
		append sCfgFileName [file tail [file rootname "$sScriptPath"]] ".cfg"
		set sCFG_File [file join $sCFG_Path $sCfgFileName]
		if {[file exists $sCFG_File]} { 
			set x [source $sCFG_File] 
		}
	}

	proc validateProductDirectoryStructure {} {
		if {[string compare -nocase [info vars ::ACGMZ] ""] == 0} {
			::xCfg::loadConfig
		} else {
			puts "Config loaded: ACGMZ"
		}
		foreach iDir $::ACGMZ_SETTINGS {
			set xDir [subst $[subst $iDir]]
			if {[file exists $xDir] && [file isdirectory $xDir]} {
				puts "is Directory Exists: $xDir"
			} else {
				puts "Directory NOT Exists: $xDir"
			}
		}
	}

	proc ::xCfg::test {} {
		foreach iDir $::ACGMZ_SETTINGS {
			set xDir [subst $[subst $iDir]]
			puts $xDir
		}
	}
	proc ::xCfg::test2 {} { info vars }

}; #~endNamespace(xCfg)

###############################################################################
# @NAMESPACE::xLib - implements utilities for updating the Library search path, and finding a library within the current search path
namespace eval ::xLib {
    # @Method(global): ::xUpdateLibDir(sLibDir) - adds sLibDir to the list of global ::LIBDIR folders, returns TRUE if added, FALSE if already there, ERROR if does not exist
    proc UpdateLibDir {sLibDir} {
         set bxAddToLibPaths $::FALSE
         if {[file exists "$sLibDir"] == 1 && [lsearch $::LIBDIR "$sLibDir"] == -1} {
            lappend ::LIBDIR "$sLibDir"
            set bxAddToLibPaths $::TRUE
         } elseif {[file exists "$sLibDir"] != 1} {
            set bxAddToLibPaths $::ERROR
         }
         return $bxAddToLibPaths
    }

    # @Method(global): ::FindLib(sLibFile) - searches sLibDir to find the library file, returns status of search and fully qualified lib file path
    proc FindLib {sLibFile} {
         set xxFindLib(STATUS) $::FALSE
         set xxFindLib(LIBFILEPATH) ""

         set sGetFileExtension  [string toupper [lindex [split [file extension $sLibFile] .] 1]]
         switch -exact -- "$sGetFileExtension" {
                LIB -
                TCL -
                SO -
                DLL {
                       foreach iLibDir $::LIBDIR {
                           set sLibFilePath [file join "$iLibDir" "$sLibFile"]
                           if {[file exists $sLibFilePath] == 1} {
                                set xxFindLib(STATUS) $::TRUE
                                set xxFindLib(LIBFILEPATH) "$sLibFilePath"
                           }
                       }
                }
                default {
                        set xxFindLib(STATUS) $::ERROR
                }
         }
         return [array get xxFindLib]
    }

    proc LoadAllLibs {} {

    }
} ; #~endNamespace(xLib)


###############################################################################
#~ Library Package Provision and loading
set LIBDIR [list]

package provide hdr 1.0

###############################################################################

