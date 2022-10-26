# @PROGDOC: xUtil Object Implementations
# @Namespace/Class = xUtil
# @Methods = isNull, dirList, verifyFileExists, log, get_stack, errMsg, dbgMsg, setTraceOn, setTraceOff, msg, readFile, writeFile, appendFile, getFileBaseName, getFileExtension, getFileExtension2, getFilePath, fileInfo, listDir, getActiveUser, verifyProcess
# @Properties =
# @Program = xUtil_v16.lib.tcl
# @Version  = 16.0
# @Synopsis = implementation support library
# @Purpose = to provide global utilities for the following areas: Files/dirs, processes, messaging, and Null handling
# @Implementation = source xUtil.lib.tcl
# @Package = package require xUtil;
# @Object = ::xUtil - utility related functions

package provide xUtil 1.0

set sTimeStampX [clock format [clock seconds] -format "%a%Y%b%dv%H%M%S"]
set ::LOGPATH  "C:/root/tmp/staging/log/3dxMigration_${sTimeStampX}.log"

set ::GLOBALERRCNT 0
array set ::GLOBALERRSTACK [list $::GLOBALERRCNT 0]

# @NAMESPACE::xUtil - implements utilities for the following areas: Files/dirs, processes, messaging, and Null handling
namespace eval ::xUtil {

	proc init {} {
		set ::GLOBALERRCNT 0
		array set ::GLOBALERRSTACK [list $::GLOBALERRCNT 0]
	}

	proc queryErrorRegistry {} {
		foreach {idx iErr} [array get ::GLOBALERRSTACK] {
			append x "$iErr" "\n"
		}
		return "$x"
	}

	proc displayErrorRegistry {} {
		puts [queryErrorRegistry]
	}

	proc writeERRSema {} {
		set x [appendFile [queryErrorRegistry] $::XMLOBJERR]
	}

	proc writeDONSema {} {
		set x [appendFile [queryErrorRegistry] $::XMLOBJDON]
	}

	proc reportProcedures {} {
		set lCmdList [list]
		set lExclusion [list ::tcl ::msgcat ]
		foreach iNamespace [namespace children] {
			foreach i [info procs ${iNamespace}::*] { 
				if {[lsearch $lExclusion $iNamespace] == -1} {
					set j [info args $i]
					lappend  lCmdList "${i}(${j})"		
				}
			}
		}
		foreach i [lsort $lCmdList] { puts $i }
	}

	proc reportAllCommands {{pattern *}} {
		return [lsort -unique [concat [
			info commands $pattern] [
			array names ::auto_index $pattern]
		]]
	}

	proc reportInternalCommands {} {
		foreach i [split [info commands]] { puts "$i" }
	}
	
	proc logEventTimestamp {} {
		set sCmdLvlInfo [info level 1]
		#set sCmdArgs [info args [info level 1]]
		set sTimeStampX [clock format [clock seconds] -format "%Y%b%d %H:%M:%S"]
		puts "3DXMQL::${sTimeStampX}:${sCmdLvlInfo}"
	}


	# @Method(global): ::xUtil::isNull(sString) - returns boolean FALSE if string not null or TRUE if it is
      proc isNull {sString} {
           set bIsNull $::FALSE
           if { "$sString" == ""}               {set bIsNull $::TRUE }
           if { [string length "$sString"] < 1} {set bIsNull $::TRUE }
           if { [string compare "$sString" ""] == 0} {set bIsNull $::TRUE }
           if { [string compare "!${sString}!" "!!"] == 0} {set bIsNull $::TRUE }
           if { [regexp ^$ "$sString"] == 1 } {set bIsNull $::TRUE }
           if { [llength $sString] == 0 }  {set bIsNull $::TRUE }
           return $bIsNull
      }

      # @Method(global): ::xUtil::dirList(dir ext form=LIST|PARA) - returns a listing of the content of the directory, in formats LIST or PARAgraph
      proc dirList { dir ext {form LIST}} {
        set contents [glob -directory $dir *$ext]
        foreach i $contents {
           switch [string toupper $form] {
                  "LIST" {
                      lappend xDirList $i
                  }
                  "PARA" {
                      append xDirList $i
                      append xDirList "\n"
                  }
                  default {
                      lappend xDirList $i
                  }
           }
         }
         return $xDirList
      }
	
      # @Method(global): ::xUtil::listDir(sDir) - simple directory listing, returns listing
	  proc listDir {{sDir .}} {
			variable lDirContent {}
			array set lFileInfo [::xUtil::fileInfo "$sDir"]
			if {[lindex [array get lFileInfo EXISTS] 1] == "$::TRUE" &&  [lindex [array get lFileInfo TYPE] 1] == "DIRECTORY"} {
				set lDirContent [glob -nocomplain [file join "$sDir" "*" ]]
			}
			return $lDirContent
	  }

      # @Method(global): ::xUtil::verifyFileExists(sFilePath osObjType=F|D) - returns boolean TRUE if the F(ile)/D(irectory) is of stated class and exist, FALSE if not
      proc verifyFileExists { sFilePath {osObjType F} } {
           set bVerifyFileExists $::FALSE
           if {[file exists "$sFilePath"] == 1} {
              switch [string toupper $osObjType] {
                     F {
                       if {[file isfile "$sFilePath"] } {
                           set bVerifyFileExists $::TRUE
                       }
                     }
                     D {
                        if {[file isdirectory "$sFilePath"] } {
                           set bVerifyFileExists $::TRUE
                       }
                     }
                     default {
                       if {[file isfile "$sFilePath"] } {
                             set bVerifyFileExists $::TRUE
                         }
                     }
              }
           } else {
              set bVerifyFileExists $::FALSE
           }
           return $bVerifyFileExists
      }

      # @Method(global): ::xUtil::log(sEvent sRcd (optional sLogFile)) - takes EVENT and ReCorD and writes a log entry to the global LOGPATH
      proc log {sEvent sRcd {sLogFile ""}} {
			if {"$sLogFile" == ""} {
				set sLogFile "$::LOGPATH"
			}
		   set sTimeStampX [string toupper [clock format [clock seconds] -format "%m/%d/%Y %r"]]
           set x [::xUtil::appendFile "3DXMQL:: ${sTimeStampX} - $sEvent : $sRcd" "$sLogFile"]
		   set x [::xUtil::appendFile "3DXMQL:: ${sTimeStampX} - $sEvent : $sRcd" "$::XMLOBJLOG"]
      }


      # @Method(internal): ::xUtil::get_stack() - recursively extracates the program stack and returns the trace for error analysis
      proc get_stack {} {
          set result {}
		  append result "\n\n========================== START STACK TRACE ==========================\n\n"
          for {set i [expr {[info level] -2}]} {$i >0} {incr i -1} {
			  lappend result [info level $i] "\n\n"
          }
		  append result "\n\n=========================== END STACK TRACE ==========================="
          return $result
      }

      # @Method(global): ::xUtil::errMsg(errcode args) - takes a globally defined error code ::ERRCODES(errcode) and variable argument message(s) and outputs based on global VERBOSE, DEBUG, and LOG settings
      proc errMsg {errcode args {errsev $::ERRSEV(INFORMATIONAL)}} {
           append sOutput "ERROR:: ($errcode)"
           append sOutput "  $::ERRCODES($errcode)"
           append sOutput "  $args"
           if {$::VERBOSE >= 1} {
			  append sOutput "\n [get_stack](): \n\n\n"
           }
           if {$::VERBOSE >= 2} {
              set x [mql list env]
                append sOutput  "\n*** MQL Local Env ***\n"
                append sOutput  "$x" "\n"
                append sOutput  "\n***      END      ***\n"
           }
           if {$::DEBUG == 1} {
                set x [puts "$sOutput" ]
           } else {
                set x [mql notice "$sOutput" ]
           }
           if {$::LOG == 0} {
			 #~ Log = 0 do nothing
           } elseif {$::LOG == 1} {
				set x [::xUtil::log "$::ERRCODES($errcode)" "$sOutput"]
           }
		   #~ Global Error registry to output to ERR.sema
		   array set ::GLOBALERRSTACK [list [incr ::GLOBALERRCNT] "ERROR($::GLOBALERRCNT).ERRCODES($errcode).$::ERRCODES($errcode) - $args"]

           return $::ERR
      }

	  # @Method(global): ::xUtil::warnMsg(wrncode args) - takes a globally defined error code ::ERRCODES(errcode) and variable argument message(s) and outputs based on global VERBOSE, DEBUG, and LOG settings
      proc warnMsg {wrncode args} {
           append sOutput "WARNING:: ($wrncode)"
           append sOutput "  $::WARNCODES($wrncode)"
           append sOutput "  $args"
		   set x [mql notice "$sOutput" ]
		   puts "$sOutput"
		   set x [::xUtil::log "$::WARNCODES($wrncode)" "$sOutput"]
	   }

	   proc hitAnyKey {} {
	   	   #~ command processor
		   if {$::SILENT == 1} {
			   puts "\nHit Enter to continue, Q to quit, T to enter an TCL command sub-processor:"
				set sCmd [gets stdin] 
				switch -exact -- [string index [string tolower "$sCmd"] 0] {
					q {
						#~ quit
						puts "...quitting"
						exit -1;
						return 0;
					}
					t {
						#~ MQL sub-processor
						set sMqlCmd "GO"
						puts "Enter TCL command to process, Q to quit TCL sub-processor:"
						while {"$sMqlCmd" != "q"} {
							puts -nonewline "TCL>>>>> "
							set sMqlCmd [gets stdin]
							if {[string index [string tolower "$sMqlCmd"] 0] == "q"} {
								break;
							} else {
								set x [catch {eval $sMqlCmd} sOutput]
								puts "$sOutput"
							}
						}
					}
					default {
						puts "...proceeding"
					}
				}
				unset sCmd
			}
	   }

      # @Method(global): ::xUtil::dbgMsg(sMsg) - outputs a Debug message based on global DEBUG, VERBOSE and LOG settings. ::DEBUG == ::TRUE turns on, ::FALSE turns off
      proc dbgMsg {sMsg} {
          if {$::DEBUG == 1} {
             set sOutput "\n\n--------------- Start DEBUG Trace ---------------\n"
             if {$::VERBOSE >= 1} {
				append sOutput "\n [get_stack](): \n $sMsg \n"
             } elseif {$::VERBOSE >= 2} {
                set x [mql list env]
                append sOutput  "\n\n\n*** MQL Local Env ***\n"
                append sOutput  "$x"
             } elseif {$::VERBOSE >= 3} {
				set x [::xUtil::reportProcedures]
				append sOutput  "\n\n\n*** Full Namespace-Procedure Dump ***\n"
                append sOutput  "$x"
			 }

             if {$::LOG == 0} {
             } elseif {$::LOG == 1} {
                set x [::xUtil::log "\n\nDEBUG::" "$sOutput"]
             }
			 set x [::xUtil::hitAnyKey] 
             append sOutput "\n--------------- End DEBUG Trace ---------------\n\n"
             set x [puts "$sOutput" ]
          }
          return 0
      }

      # @Method(global): ::xUtil::setTraceOn(sLogFile) / ::xUtil::setTraceOff() - turns MQL tracing on/off, if  sLogFile arg is provided, traces to file
      proc setTraceOn {{sLogFile ""}} {
           if {[::xUtil::isNull "$sLogFile"] == $::TRUE } {
              set x [mql trace type mql,jpo,trigger on];
           } else {
              set x [mql trace type mql,jpo,trigger filename "$sLogFile"];
           }
      }
       proc setTraceOff {} {
           set x [mql trace type mql,jpo,trigger off];
      }

      # @Method(global): ::xUtil::Msg(sMsg) - outputs a notification message
      proc msg {args} {
           if {$::SILENT == $::FALSE} {
              puts "Notification:\n$args"
           }
      }


      # @Method(global): ::xUtil::readFile(sFileName) - reads entire content of sFileName as a text (non-binary) and returns
      proc readFile {sFileName} {
           set fp [open "$sFileName" r]
            set sData [read $fp]
            close $fp
            return "$sData"
      }

      # @Method(global): ::xUtil::writeFile(sData sFileName) - writes text in sData to file sFileName and closes the file
      proc writeFile {sData sFileName}  {
          set fp [open $sFileName "w"]
          puts -nonewline $fp "$sData"
          flush $fp
          close $fp
      }

      # @Method(global): ::xUtil::deleteFile(sFile) - deletes specified file, or directory (with all content)
      proc deleteFile {sFile} {
           set bdeleteFile $::FALSE
           if {[file exists $sFile] == 1} {
               set x [file delete -force -- $sFile]
                set bdeleteFile $::TRUE
           }
           return $bdeleteFile
      }


      # @Method(global): ::xUtil::copyFile(srcFile tgtFile) - copies SRC to TGT.
      # @   where: SRC=(c:/temp/file.txt) isFile TGT=(c:/dir2) isDirectory, copy the file into the directory
      # @   where: SRC=(c:/temp/file.txt) isFile TGT=(c:/dir2/MyFile.txt) isFile, delete TGT, copy the SRC file to target DIR with new name
      # @   where: SRC=(c:/temp/1Dir) isDirectory TGT=(c:/temp/dir2/) isDirectory, delete TGT, copy the SRC dir to target DIR with new name
      proc copyFile {srcFile tgtFile} {
           set bcopyFile $::FALSE
           #~ if tgtFile exists and is not a directory, delete it, otherwise leave it
           if {[file exists $tgtFile] == 1 && [file isfile $tgtFile] == 1 && [file isdirectory $tgtFile] == 0} {
              set x [::xUtil::deleteFile $tgtFile]
           }
           if {[file exists $srcFile] == 1} {
              set x [file copy -force -- $srcFile $tgtFile]
               if {[file isfile $srcFile] == 1 && [file isdirectory $tgtFile] == 1} {
                  set sTargetFile [file join $tgtFile [file tail $srcFile] ]
               } else {
                  set sTargetFile $tgtFile
               }
               if {[file exists $sTargetFile] == 1} {
                  set bcopyFile $::TRUE
               }
           }
           return $bcopyFile
      }

      # @Method(global): ::xUtil::moveFile(srcFile tgtFile) - moves SRC to TGT.
      # @   where: SRC=(c:/temp/file.txt) isFile TGT=(c:/dir2) isDirectory, copy the file into the directory, delete the original
      # @   where: SRC=(c:/temp/file.txt) isFile TGT=(c:/dir2/MyFile.txt) isFile and exists, do NOT move the SRC but return an ERROR
      # @   where: SRC=(c:/temp/1Dir) isDirectory TGT=(c:/temp/dir2/) lowest dir does NOT exist, then move, otherwise return an ERROR
      proc moveFile {srcFile tgtFile} {
           set bmoveFile $::FALSE
           if  {[file exists $tgtFile] == 1 && [file isfile $tgtFile] == 1 && [file isdirectory $tgtFile] == 0} {
              set x [::xUtil::deleteFile $tgtFile]
           }
           if {[::xUtil::copyFile $srcFile $tgtFile] == $::TRUE} {
               if {[file isfile $srcFile] == 1 && [file isdirectory $tgtFile] == 1} {
                  set sTargetFile [file join $tgtFile [file tail $srcFile] ]
               } else {
                  set sTargetFile $tgtFile
               }
               if {[file exists $sTargetFile] == 1 && [file exists $srcFile] == 1} {
                  set x [::xUtil::deleteFile $srcFile]
                  set bmoveFile $::TRUE
               } else {
                  set bmoveFile $::ERROR
               }
           } else {
              set bmoveFile $::ERROR
           }
           return $bmoveFile
      }



      # @Method(global): ::xUtil::appendFile(sData sFileName) - appends text in sData to end of file sFileName and closes the file
      proc appendFile {sData sFileName}  {
          set fp [open $sFileName "a"]
		  #fileevent $fp writable ::xUtil::setWriteable
          puts $fp "$sData"
          close $fp
      }

	  proc setWriteable {} {
	  	  set ::WRITEABLE $::TRUE
		  return $::TRUE
	  }

      # @Method(global): ::xUtil::getFileBaseName(sFilePath) - takes a full/relative file path and returns the file basename (/root/tmp/dog.txt -- dog.txt)
      proc getFileBaseName { sFilePath } {
         set sGetFileBaseName [file tail [file rootname $sFilePath]]
         if {[string length "$sGetFileBaseName"] == 0 } {
            set sGetFileBaseName [errMsg 3 "\n$sFilePath" "attempt to resolve basename failed"]
         }
         return "$sGetFileBaseName"
      }

      # @Method(global): ::xUtil::getFileExtension(sFilename) - takes a full/relative file path and returns the file extension in upper case (/root/tmp/dog.txt -- TXT)
      proc getFileExtension { sFilename } {
         set sGetFileExtension [string toupper [lindex [split [file extension $sFilename] .] 1]]
         if {[string length "$sGetFileExtension"] == 0 } {
            set sGetFileBaseName [errMsg 3 "\n$sFilePath" "attempt to resolve extension failed"]
         }
         return "$sGetFileExtension"
      }

      # @Method(global): ::xUtil::getFileExtension2(sFilename) - takes a full/relative file path and returns the file extension (/root/tmp/dog.txt -- txt)
      proc getFileExtension2 { sFilename } {
         set sGetFileExtension [lindex [split [file extension $sFilename] .] 1]
         if {[string length "$sGetFileExtension"] == 0 } {
            set sGetFileBaseName [errMsg 3 "\n$sFilePath" "attempt to resolve extension failed"]
         }
         return "$sGetFileExtension"
      }

      # @Method(global): ::xUtil::getFilePath(sFilename) - takes a full/relative file path and returns the parent directory path
      proc getFilePath { sFilename } {
          set sGetFilePath [file dirname "$sFilename"]
          return $sGetFilePath
      }

      # @Method(global): ::xUtil::fileInfo(sFile) - takes a file, and returns an associative array with TYPE/DIR/TAILNAME/BASENAME/EXT/KIND
      proc fileInfo {sFile} {
         if {[file exists "$sFile"] == 1} {
             set xFile(EXISTS) $::TRUE
             set xFile(NAME) "$sFile"
             if {[file isfile "$sFile"] == 1 } {
                set xFile(TYPE) "FILE"
                set xFile(DIR)  [file dirname "$sFile"]
                set xFile(TAILNAME)  [file tail "$sFile"]
                set xFile(BASENAME)  [file rootname [file tail "$sFile"]]
                set xFile(EXT)  [lindex [split [file extension "$sFile"] .] 1]
                set xFile(KIND)  [lindex [array get ::xFILEKIND [string toupper [lindex [split [file extension "$sFile"] .] 1]]] 1]
             } elseif {[file isdirectory "$sFile"] == 1 } {
                set xFile(TYPE) "DIRECTORY"
             } else {
                set xFile(TYPE) "UNKNOWN"
             }
         } else {
            set xFile(EXISTS) $::FALSE
         }
         return [array get xFile]
      }

    # @Method(global): ::xUtil::listDir(sDir) - takes a DIR path (. is default) and returns the content, generic
    proc listDir {{sDir .}} {
         variable lDirContent {}
         array set lFileInfo [::xUtil::fileInfo "$sDir"]
         if {[lindex [array get lFileInfo EXISTS] 1] == "$::TRUE" &&  [lindex [array get lFileInfo TYPE] 1] == "DIRECTORY"} {
            set lDirContent [glob -nocomplain [file join "$sDir" "*" ]]
         }
         return $lDirContent
    }

    # @Method(global): ::xUtil::getActiveUser() - get the current OS or Matrix user (when applicable)
    proc getActiveUser {} {
         set x [lindex [array get env USERNAME] 1]
         regsub -all -- " " [lindex [array get env USERNAME] 1] "" x1
         #regsub -all -- "\\." "$x" "" y
         return $x
    }


    # @Method(global): ::xUtil::verifyProcess(iPID) - takes an integer PID (process ID) and verifies if it is on the CPU process stack (tasklist)
    proc verifyProcess {iPID} {
           set bverifyProcess $::FALSE
           set sProcInfo [lindex [split [exec cmd /c tasklist /nh /fo CSV /fi "PID eq $iPID"] \n] end]
           if {[string match "*$iPID*" "$sProcInfo"] == 1} {
              set bverifyProcess $::TRUE
           }
           return $bverifyProcess
    }

    namespace export  isNull;
    namespace export  dirList;
    namespace export  verifyFileExists;
    namespace export  log;
    namespace export  get_stack;
    namespace export  errMsg;
    namespace export  dbgMsg;
    namespace export  setTraceOn;
    namespace export  setTraceOff;
    namespace export  msg;
    namespace export  readFile;
    namespace export  writeFile;
    namespace export  appendFile;
    namespace export  getFileBaseName;
    namespace export  getFileExtension;
    namespace export  getFileExtension2;
    namespace export  getFilePath;
    namespace export  fileInfo;
    namespace export  listDir;
    namespace export  getActiveUser;
    namespace export  verifyProcess;

	set x [::xUtil::init]

}; #~end namespace xUtil

