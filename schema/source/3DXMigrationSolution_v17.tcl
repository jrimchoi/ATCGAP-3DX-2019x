# @PROGDOC: 3DX Migration Solution is a tool to import CSV or XML based 3DX Object Specifications
# @PROGDOC: 3DX Migration Solution operates based on the "PLM Object Portfolio" architecture
# @PROGDOC: the "PLM Object Portfolio" architecture provides a "migration zone" in which any data-source may export object specification data in a normalized format to be imported by the 3DX Migration Solution
# @PROGDOC: the "PLM Object Portfolio" architecture "migration zone" is a set of folders located on a common network storage platform that both the exporting system(s) and the 3DX Migration Solution "Queue Manager" has access to at an OS and NETWORK level
# @PROGDOC: Queue management operates iteratively to scan the "IN" (box) as a "watched folder" for "PLM Object Portfolio" containers (folders) to appear and be processed
# @PROGDOC: Job management activates when the Queue is operational and passes the path to the "PLM Object Portfolio" container, that has a RDY (ready) semaphore (indicating that the exporting process is complete), and does not yet have a LOK (lock) semaphore indicating that another Queue has taken ownership of the Job
# @PROGDOC: Job elements consist of a single XML or CSV metadata specification for a Portfolio of object(s) that represent a "complete" set, such as a Master object with connecting version Objects
# @PROGDOC: Further, job elements will be all files in a readable format (decrypted) that are to be checked-in to the respective objects as represented in the aforementioned business object(s)
# @PROGDOC: Upon process completion, the "PLM Object Portfolio" container will be moved to an Archive container if no errors were generated during migration.
# @PROGDOC: However, if an error on import occured, the "PLM Object Portfolio" container will be moved to an container to be examined for issues and remediated
# @PROGDOC: Any "PLM Object Portfolio" container elements that have been "repaired" may be moved to the IN container again for reprocessing
# @Namespace/Class = (global)
# @Methods = (packge loading)
# @Properties = (N/A)
# @Program = C:/root/Razorleaf.VSTS/ACG/Migration/Script/3DXMigrationSolution_v17.tcl
# @Version  = 17.0
# @Synopsis = implementation main thread
# @Purpose = to provide methods/properties for Migration of data from foreign systems to 3DX
# @Implementation = (MQL) run 3DXMigrationSolution_v17.tcl
# @Implementation = (TCL) source 3DXMigrationSolution_v17.tcl
# @Package = provides (N/A)
# @Package = requires HDR, xUtil, xDB, tdom, xmlBusinessObject, xBO, xJobQueueMgmt
# @Object = (N/A)
# @TRANSFORMATION:
#   C:\temp\Atlas\Transform\dist>java -jar TransformXML.jar PCExportConfig.xml
# @ 3DXMigration Import:
#   C:\R2017x\3DSpace\win_b64\code\bin\mql.exe -c "set context user creator;set env XMLObj //SomeServer/acgmz/staging/in/Drawing_1234_A; exec prog 3DXMigrationSolution.tcl;"
# @Implementation Setting: LOADLIBSFROMFILE - is set 0, then load script libraries from file search paths, 1 then Matrix Program objects

tcl;

eval {
set ::LOADLIBSFROMFILE 1
set ::CODEBIN  64


#################################################################################
######## Module Package Management - load libraries #############################

if {$::LOADLIBSFROMFILE == 0} {
		#~ Load the header file, which must be in the same folder as the master script ~#
		#~ the HDR file has all the global constants and library mgmt namespace ~~~~~~~~#
		source [file join [file dirname [info script]] Hdr.lib.tcl]
		source [file join [file dirname [info script]] 3DXMigrationSolution.cfg]

		#~ Add all potential library paths to LIBDIR ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		set sLibraryPath "C:/root/lib/tdom-0.9-windows-x86/tdom0.9.0"
		if {[::xLib::UpdateLibDir "$sLibraryPath"] == $::ERROR} {
		   puts "ERROR:: $::ERRCODES(998) - Library path $sLibraryPath"
		   #exit $::ERROR
		}

		set sLibraryPath "C:/root/Razorleaf.VSTS/ACG/Migration/Lib"
		if {[::xLib::UpdateLibDir "$sLibraryPath"] == $::ERROR} {
		   puts "ERROR:: $::ERRCODES(998) - Library path $sLibraryPath"
		   #exit $::ERROR
		}

		#if 0 {
		#	set sLibraryPath "C:/root/RazorLeaf/ACGap/script/lib"
		#	if {[::xLib::UpdateLibDir "$sLibraryPath"] == $::ERROR} {
		#	   puts "ERROR:: $::ERRCODES(998) - Library path $sLibraryPath"
		#	   #exit $::ERROR
		#	}
		#}


		#~ Append Package Libraries needed for this platform to execute ~~~~~~~~~~~~~~~~#
		#~~~ xUtil - all standard functions for files, code mgmt, etc.
		array set xLibrary [::xLib::FindLib "xUtil.lib.tcl"]
		if {[array get xLibrary STATUS] == $::ERROR }  {
		   puts "ERROR:: $::ERRCODES(998) - Library path $sLibraryPath"
		   #exit $::ERROR
		}
		array set LIBCODE [list xUtil [lindex [array get xLibrary LIBFILEPATH] 1]]
		package ifneeded xUtil 1.0 [list source [lindex [array get LIBCODE xUtil] 1]]

		#~ xDB - package to manage CSV style DB imports
		array set xLibrary [::xLib::FindLib "xDB.lib.tcl"]
		if {[array get xLibrary STATUS] == $::ERROR }  {
		   puts "ERROR:: $::ERRCODES(998) - Library path $sLibraryPath"
		   #exit $::ERROR
		}
		array set LIBCODE [list xDB [lindex [array get xLibrary LIBFILEPATH] 1]]
		package ifneeded xDB 1.0 [list source [lindex [array get LIBCODE xDB] 1]]

		#~ xmlBusinessObject - parse XML DOM tree, instantiate Business Objects from tags
		array set xLibrary [::xLib::FindLib "xmlBusinessObject.lib.tcl"]
		if {[array get xLibrary STATUS] == $::ERROR }  {
		   puts "ERROR:: $::ERRCODES(998) - Library path $sLibraryPath"
		   #exit $::ERROR
		}
		array set LIBCODE [list xmlBusinessObject [lindex [array get xLibrary LIBFILEPATH] 1]]
		package ifneeded xmlBusinessObject 1.0 [list source [lindex [array get LIBCODE xmlBusinessObject] 1]]

		#~ xJobQueMgmt - manages queue runtime, locating jobs, and processing
		array set xLibrary [::xLib::FindLib "xJobQueMgmt.lib.tcl"]
		if {[array get xLibrary STATUS] == $::ERROR }  {
		   puts "ERROR:: $::ERRCODES(998) - Library path $sLibraryPath"
		   #exit $::ERROR
		}
		array set LIBCODE [list xJobQueMgmt [lindex [array get xLibrary LIBFILEPATH] 1]]
		package ifneeded xJobQueMgmt 1.0 [list source [lindex [array get LIBCODE xJobQueMgmt] 1]]

		#~ xBO - all function calls to exec MQL commands to create/modify/connect/checkin Business Objects
		array set xLibrary [::xLib::FindLib "xBO.lib.tcl"]
		if {[array get xLibrary STATUS] == $::ERROR }  {
		   puts "ERROR:: $::ERRCODES(998) - Library path $sLibraryPath"
		   #exit $::ERROR
		}
		array set LIBCODE [list xBO [lindex [array get xLibrary LIBFILEPATH] 1]]
		package ifneeded xBO 1.0 [list source [lindex [array get LIBCODE xBO] 1]]


		#~ TDOM - standard TCL XML/DOM parsing and attribute rendering, used with xmlBusinessObject
		array set xLibrary [::xLib::FindLib "tdom090.dll"]
		if {[array get xLibrary STATUS] == $::ERROR }  {
		   puts "ERROR:: $::ERRCODES(998) - Library path $sLibraryPath"
		   #exit $::ERROR
		}
		set TDOMDLL [lindex [array get xLibrary LIBFILEPATH] 1]

		array set xLibrary [::xLib::FindLib "tdom.tcl"]
		if {[array get xLibrary STATUS] == $::ERROR }  {
		   puts "ERROR:: $::ERRCODES(998) - Library path $sLibraryPath"
		   #exit $::ERROR
		}
		set TDOMTCL [lindex [array get xLibrary LIBFILEPATH] 1]

		package ifneeded tdom 0.9.0 \
		"load [list $TDOMDLL];\
				 source [list $TDOMTCL]"


		#if 0 { 
		#set LIBDIR "C:/root/lib/tdom-0.9-windows-x86/tdom0.9.0"
		#package ifneeded tdom 0.9.0 \
		#"load [list [file join $LIBDIR tdom090.dll]];\
		#         source [list [file join $LIBDIR tdom.tcl]]"
		#}



		#~ Require needed packages for platform ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		#package require xUtil
		source [lindex [array get LIBCODE xUtil] 1]
		#package require xDB
		source [lindex [array get LIBCODE xDB] 1]

		#package require tdom
		if {$::CODEBIN == 32} {	
			load "C:/root/Razorleaf.VSTS/ACG/Migration/Lib/tdom090.dll"
			source "C:/root/Razorleaf.VSTS/ACG/Migration/Lib/tdom.tcl"
		} else {
			#load "C:/R2017x/3DSpace/win_b64/code/bin/tdom083.dll"
			#source "C:/R2017x/3DSpace/win_b64/code/bin/tdom.tcl"
			if {[file exists "C:/R2017x/3DSpace/win_b64/code/bin/tdom083.dll"] == 1} {
				load "C:/R2017x/3DSpace/win_b64/code/bin/tdom083.dll"
			} elseif {[file exists "C:/root/lib/tdom083.dll"] == 1} {
				load "C:/root/lib/tdom083.dll/tdom083.dll"
			} elseif {[file exists [file join "$::ACGMZ_LIB" "tdom083.dll"]] == 1} {
				load [file join "$::ACGMZ_LIB" "tdom083.dll"]
			} elseif {[file exists [file join "$::3DX_BIN" "tdom083.dll"]] == 1} {
				load [file join "$::::3DX_BIN" "tdom083.dll"]
			} else {
				#~ Abort 3DXMigrationSolution, cannot load TDOM083
				set x [::xUtil::errMsg 997 "Critial Failure to load TDOM083.dll"]
				exit;
			}
		}
		#package require xmlBusinessObject
		source [lindex [array get LIBCODE xmlBusinessObject] 1]
		#package require xBO
		source [lindex [array get LIBCODE xBO] 1]
		#package require xJobQueueMgmt
		source [lindex [array get LIBCODE xJobQueMgmt] 1]
} else {
	#~ load from program objects in Matrix
	eval [mql print program Hdr_v17.lib.tcl select code dump]
	eval [mql print program 3DXMigrationSolution.cfg select code dump]
	eval [mql print program xUtil_v16.lib.tcl select code dump]
	eval [mql print program xmlBusinessObject_v16.lib.tcl select code dump]


	if {[file exists "C:/R2017x/3DSpace/win_b64/code/bin/tdom083.dll"] == 1} {
		load "C:/R2017x/3DSpace/win_b64/code/bin/tdom083.dll"
	} elseif {[file exists "C:/enoviaV6R2017x/studio/win_b64/code/bin/tdom083.dll"] == 1} {
		load "C:/enoviaV6R2017x/studio/win_b64/code/bin/tdom083.dll"
	} elseif {[file exists [file join "$::ACGMZ_LIB" "tdom083.dll"]] == 1} {
		load [file join "$::ACGMZ_LIB" "tdom083.dll"]
	} elseif {[file exists [file join "$::3DX_BIN" "tdom083.dll"]] == 1} {
		load [file join "$::3DX_BIN" "tdom083.dll"]
	} else {
		#~ Abort 3DXMigrationSolution, cannot load TDOM083
		set x [::xUtil::errMsg 997 "Critial Failure to load TDOM083.dll"]
		exit;
	}
	eval [mql print program tdom.tcl select code dump]



	#eval [mql print prog xBO_v17.lib.tcl   select code dump]
	eval [mql print prog xBO_v17hf201812141400.lib.tcl  select code dump]


	#eval [mql print program xJobQueMgmt_v14.lib.tcl select code dump]
	#eval [mql print program xBanner_v13.lib.tcl select code dump]

	if {$::OOTB == 1} {
		namespace eval xOOTB {
			eval [mql print program eServicecommonNameGeneratorProc.tcl select code dump]
		}
	} else {
		eval [mql print program xAutonamer_v15.lib.tcl select code dump]
	}


}
################################################################################

#~ IF the ENV Variable XMLObj is set at launch, then it will process a
#~ single job, based on the UNC path to the XML object definition
#~ ELSE it will go full JobQueueManagement mode

#puts $::COPYRIGHT(Banner)

# mql history off;
# mql history on;


if {[mql exists env global XMLObj] == 1 } {
	set sXMLObj [mql get env global XMLObj]
} elseif {[mql exists env XMLObj] == 1 } {
	set sXMLObj [mql get env XMLObj]
} else {
	#~ exist with errors
	puts "ERROR:: could not locate in local or global RPE - XMLObj"
	set iExitCode [::xUtil::errMsg 999 "3DXMigrationSolution.tcl(MAIN) - could not locate in local or global RPE - XMLObj, aborting"]
	set x [::xUtil::writeERRSema]
	exit;
}

puts "Processing XML Object Definition: $sXMLObj"
if {[file exists $sXMLObj] } {
	if {$::ABORTONERROR == 1} {
		set x [mql start transaction]
	}
	
	cd [file dirname $sXMLObj]
	
	append  ::XMLOBJLOG [file join [file dirname $sXMLObj] [file rootname [file tail $sXMLObj]]] ".log"
	append  ::XMLOBJDON [file join [file dirname $sXMLObj] "DON.sema"]
	append  ::XMLOBJERR [file join [file dirname $sXMLObj] "ERR.sema"]


	set x [mql trigger off]

	set x [::xmlBusinessObject::xImportXMLObject $sXMLObj]

	set x [mql trigger on]


	cd c:/root

	if {$::GLOBALERRCNT > 0} {
		set iExitCode [::xUtil::errMsg 0 "3DXMigrationSolution.tcl(MAIN) - Errors returned by migration process, see LOG"]
		set x [mql set env GLOBALERRCNT $::GLOBALERRCNT]
		puts  [::xUtil::queryErrorRegistry]
		if {$::ABORTONERROR == 1} {
			set x [mql abort transaction]
		}
		set x [::xUtil::writeERRSema]
	} else {
		::xUtil::dbgMsg "3DXMigrationSolution.tcl(MAIN) - $sXMLObj processed successfully, exit 0"
		if {$::ABORTONERROR == 1} {
			set x [mql commit transaction]
		}
		set iExitCode 0
		set x [::xUtil::writeDONSema]
	}
} else {
	#~ exist with errors
	puts "ERROR:: could not locate XML Object Definition: $sXMLObj"
	set iExitCode [::xUtil::errMsg 999 "3DXMigrationSolution.tcl(MAIN) - sXMLObj XML Object Definition does not exist, aborting"]
	set x [::xUtil::writeERRSema]
	exit;
}


#if 0 {
#	#~ run Job/Queue Management
#	set x [::xJobQueueMgmt::xJobQueueMgmt]
#}
 

#exit $iExitCode;
exit;

}; #~ endEval

