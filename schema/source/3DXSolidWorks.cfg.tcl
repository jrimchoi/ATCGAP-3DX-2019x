#####################################################################
####### Environment Settings below                            #######
set ::ACGMZ "C:/root/ACGMZ/staging/SolidWorks"

#~ validate paths for checkout/checkin from localhost to drive mounts or UNC
if {[file isdirectory "E:/"] == 1} {
	set ::ACGMZ "E:/"
} elseif {[file isdirectory "E:/"] == 1} {
	set ::ACGMZ "E:/
} elseif {[file isdirectory "E:/] == 1} {
	set ::ACGMZ "E:/
}

set ::ACGMZ_BIN [file join "$::ACGMZ" "bin"]
set ::ACGMZ_LOG [file join "$::ACGMZ" "log"]

#####################################################################

#####################################################################
####### Override Default Settings by Uncommenting and Setting #######
####### only remote # from lines that start with "set"        #######
####### change values recommended in the comment #~ above     #######
#~ ABORTONERROR: 0=ignore errors and continue import (no transaction boundary mgmt)
#~ ABORTONERROR: 1=manage transaction boundaries, abort trans on errors
#set ::ABORTONERROR 1
#~ DEBUG: 0=off 1=on
#set ::DEBUG 1
#~ VERBOSE: 0=off 1=stack trace 2=MQL RPE ENV 3+=full dump of namespace environment
#set ::VERBOSE 1
#~ SILENT: prompt to pause, 0=silent 1=not silent
#set ::SILENT 1
#~ LOG: 0=no logging to LOGPATH 1=log to logpath 2=log to obj description 3=log to obj history
#set ::LOG 1
#~ DEFAULTOWNER: if no owner is present in the data, use this owner for obj creation
#set ::DEFAULTOWNER "creator"
#####################################################################

