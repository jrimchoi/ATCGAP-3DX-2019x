# @PROGDOC: 3DXSolidWorks class library to implement Business Object creation and manipulation methods
# @Namespace/Class =  3DXSolidWorks
# @Methods =
# @Properties =
# @Program =  3DXSolidWorks.lib.tcl
# @Version  = 1.0
# @Synopsis = implementation specific functions/methods
# @Purpose = to provide methods/properties for 3DXSolidWorks utilities
# @Implementation = eval [mql print program 3DXSolidWorks.lib.tcl select code dump]
# @Package =
# @Object = 

################################################################################
######## Module Package Management - load libraries ############################


# Library extension to base libraries

namespace eval 3DXSolidWorks {

	proc xCheckoutSolidWorksAssembly {sType sName sRev sFolderPath sFilename} {
		set ixCheckoutSolidWorksAssembly $::FALSE
		if {[::xBO::getBOExist "$sType" "$sName" "$sRev"] == $::TRUE} {
			set oID [::xBO::getBOID "$sType" "$sName" "$sRev"]
			if {[::xUtil::isNull "$sFilename"] == $::FALSE} {			
				set ixCheckoutSolidWorksAssembly [::xBO::xCheckout $oID "$sFolderPath" "asm" "$sFilename"]
			} else {
				#~ file is null
				set ixCheckoutSolidWorksAssembly [::xUtil::errMsg 11 "xCheckoutSolidWorksAssembly() - $sType $sName $sRev"
			}
		} else {
			set ixCheckoutSolidWorksAssembly [::xUtil::errMsg 18 "xCheckoutSolidWorksAssembly() - $sType $sName $sRev - filename is null or file does not exist for format: $sFormat"
		}
		return $ixCheckoutSolidWorksAssembly
	}
	
	
	namespace export  xCheckoutSolidWorksAssembly ;

}; #~endNamespace 3DXSolidWorks


#~ Extend functions of xBO library or overload existing functions
namespace eval xBO {

	proc xCheckout {oID sFolderPath sFormat sFilename} {
		set ixCheckout $::FALSE
		set xFilename [lindex [split [mql print bus $oID select format\[$sFormat\].file.name dump |] |] 0]
		if {[string match -nocase "$sFilename" "$xFilename"] == 1 } {
			if {[file isdirectory "$sFolderPath"] == 1} {
				if {[catch {mql checkout bus $oID format "$sFormat" file "$xFilename" "$sFolderPath"} err] == 0} {
					set ixCheckout $::TRUE
				} else {
					set ixCheckout [::xUtil::errMsg 603 "xCheckout() - [mql print bus $oID select dump " "] $sFolderPath $sFormat $sFilename - $err"]
				}
			} else {
				set ixCheckout [::xUtil::errMsg 603 "xCheckout() - [mql print bus $oID select dump " "] $sFolderPath $sFormat $sFilename - folder path invalid"]
			}
		} else {
			set ixCheckout [::xUtil::errMsg 603 "xCheckout() - [mql print bus $oID select dump " "] $sFolderPath $sFormat $sFilename - filename requested does not match Object: $xFilename"]
		}
		return $ixCheckout
	}
	
	namespace export  xCheckout ;

}; #~endNamespace xBO

#~ Extend functions of xUtil library or overload existing functions
namespace eval xUtil {

	proc xCreateCheckoutDirectory {sFolderPath} {
		set ixCreateCheckoutDirectory $::FALSE
		if {[file exists "$sFolderPath"] == 0} {
			set x [file mkdir "$sFolderPath"]
			if {[file isdirectory "$sFolderPath"] == 1} {
				set ixCreateCheckoutDirectory $::TRUE
			} else {
				set ixCreateCheckoutDirectory [::xUtil::errMsg 602 "xCreateCheckoutDirectory() - $sFolderPath"]
			}
		} else {
			set ixCreateCheckoutDirectory [::xUtil::errMsg 601 "xCreateCheckoutDirectory() - $sFolderPath"]
		}
		
		return $ixCreateCheckoutDirectory
	}

	#~	example line: EventStatus|Timestamp|T|N|R|ID|FilePath|vault|policy|current|originated|modified|owner|organization|project|iov|dov|checkoutMsg
	# @Method(global): ::xUtil::log(sEvent sRcd (optional sLogFile)) - takes EVENT and ReCorD and writes a log entry to the global LOGPATH
	proc log {sEvent sRcd {sLogFile ""}} {
		if {"$sLogFile" == ""} {
			set sLogFile "$::LOGPATH"
		}
		set sTimeStampX [string toupper [clock format [clock seconds] -format "%m/%d/%Y %r"]]
		set x [::xUtil::appendFile "$sEvent|${sTimeStampX}|$sRcd" "$sLogFile"]
	}

	proc xGetEnv {} {
		return [lindex [split [mql temp query bus Document ENVIRONMENT * select dump |] |] 2]
	}

	
	namespace export  xCreateCheckoutDirectory ;

}; #~endNamespace xUtil

