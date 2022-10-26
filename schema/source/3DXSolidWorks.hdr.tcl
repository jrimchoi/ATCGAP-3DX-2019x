# @PROGDOC: Universal GLOBAL Constants supporting all X packages in project
# @Namespace/Class = (global) + xLib
# @Methods = UpdateLibDir(sLibDir), FindLib(sLibFile), LoadAllLibs() 
# @Properties = ::LIBDIR
# @Program = 3DXSolidWorks.hdr.tcl
# @Version  = 1.0
# @Synopsis = implementation support library
# @Purpose = to provide global constants and library mgmt
# @Implementation = source 3DXSolidWorks.hdr.tcl
# @Implementation = eval [mql print program 3DXSolidWorks.hdr.tcl select code dump] 
# @Package = package require 3DXSolidWorks.hdr;
# @Object = (null)


###############################################################################
#~ error codes
set ERRCODES(600) "Error - could not create SolidWorks checkout folder"
set ERRCODES(601) "Error - already exists SolidWorks checkout folder"
set ERRCODES(602) "Error - could not validate SolidWorks checkout folder"
set ERRCODES(603) "Error - SolidWorks checkout failed"


###############################################################################
#~ event status
set EVENTCODE(RDY) "READY(3DX)"
set EVENTCODE(LOK) "LOCKED(ACG)"
set EVENTCODE(DON) "DONE(ACG)"
set EVENTCODE(ERR) "ERROR(ACG)"
set EVENTCODE(D2N) "DONE(3DX)"
set EVENTCODE(E2R) "ERROR(3DX)"
set EVENTCODE(600) "Special Sub Eventstatus - Start here with Solidworks related events"

