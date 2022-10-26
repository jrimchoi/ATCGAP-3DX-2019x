# @PROGDOC: 3DX Object Self-Restore is a tool to repair objects that are incomplete or damaged after migration or in other conditions
# @PROGDOC: it contains both repairative and health-check functions to assure object is operating as designed
# @Namespace/Class = (global)
# @Methods = (packge loading)
# @Properties = (N/A)
# @Program = C:\root\Razorleaf.VSTS\Atlas Copco\Migration\Script\3DXObjSelfRestore.tcl
# @Version  = 1.0
# @Synopsis = implementation main thread
# @Purpose = to provide methods/properties for object restoration
# @Implementation = (MQL) run %srcpath%/3DXObjSelfRestore.tcl
# @Implementation = (TCL) source %srcpath%/3DXObjSelfRestore.tcl
# @Implementation = (MQL) exec program 3DXObjSelfRestore.tcl;
# @Package = provides (N/A)
# @Package = requires HDR, xUtil, xBO
# @Object = (N/A)
# @DOC - Health checks
# @DOC	1. mandatory primary (basics) object properties
# @DOC	2. object state
# @DOC	3. object inter-relationship structure
# @DOC	4. object intra-relationship structure (versions, etc.)
# @DOC	5. PnO Security settings and structure
# @DOC	- Object Reporting (Inspect Object)
# @DOC	1. mandatory primary (basics) object properties
# @DOC	2. object state
# @DOC	3. object inter-relationship structure
# @DOC	4. object intra-relationship structure (versions, etc.)
# @DOC	5. PnO Security settings and structure
# @DOC	- Object/structure repairs
# @DOC	1. Object Properties (basics):
# @DOC	1.A correct type/name/revision issues
# @DOC	1.B correct vault
# @DOC	1.C correct policy / state issues
# @DOC	1.D correct revision chain issues
# @DOC	2.A 


tcl;

eval {


#~ OBJREPAIRMODE: 0=single obj mode, get RPE TNR
#~ OBJREPAIRMODE: 1=find objects by gapLegacyPrevRev/gapLegacyNextRev search and repair
#~ OBJREPAIRMODE: 2=find objects by gapLegacyPDMIdentifier and process
#~ OBJREPAIRMODE: 3=find objects by select attribute and process
set ::OBJREPAIRMODE 1

#~ REPORTOBJSTATUS: FALSE (0) turns of all reporting, TRUE (1) turns on
set ::REPORTOBJSTATUS 0
#~ REPORTVERBOSITY: 0=no reporting, 1=Inspect obj only, 2=inspect env, 3=inspect TCL cmds, env, etc.
set ::REPORTVERBOSITY 0

set ::REPORTPATH "c:/root/tmp"

set sTimeStampX [clock format [clock seconds] -format "%a%Y%b%dv%H%M%S"]
set ::GLOBALLOG  [join [list $::REPORTPATH "/3DXObjSelfRestore_" "$sTimeStampX" ".log"] ""]
set ::::XMLOBJLOG $::GLOBALLOG 


eval [mql print program Hdr_v17.lib.tcl					select code dump]
eval [mql print program xUtil_v16.lib.tcl				select code dump]
eval [mql print program xBO_v17.lib.tcl					select code dump]
eval [mql print program xObjInspector.lib.tcl			select code dump]
eval [mql print program xObjHealthCheck.lib.tcl			select code dump]
eval [mql print program xObjRepair.lib.tcl				select code dump]

#eval [mql print program eServicecommonShadowAgent.tcl	select code dump]

set b3DXObjSelfRestore $::FALSE

#pushShadowAgent

if {$::OBJREPAIRMODE == 0} {
	set sType [mql get env TYPE]
	set sName [mql get env NAME]
	set sRev  [mql get env REVISION]
	set oID   [::xBO::getBOID "$sType" "$sName" "$sRev"]

	if {$oID != $::ERR} {
		set x [::xObjRepair::xObjRepair "$sType" "$sName" "$sRev" "$oID"]
		set b3DXObjSelfRestore $::TRUE
	} else {
		set b3DXObjSelfRestore $::ERROR 
	}
};

if {$::OBJREPAIRMODE == 1} {
	foreach iObj [split [mql temp query bus * * * vault "eService Production" where "policy nsmatch *Version* && (attribute\[gapLegacyPrevRev\] nsmatch \"\" || attribute\[gapLegacyNextRev\] nsmatch \"\")" select id policy attribute\[gapLegacyPDMIdentifier\]  dump |] \n] {
		puts "INSPECTING:: $iObj"
		set sType   [lindex [split $iObj |] 0]
		set sName   [lindex [split $iObj |] 1]
		set sRev    [lindex [split $iObj |] 2]
		set oID     [lindex [split $iObj |] 3]
		set sPolicy [lindex [split $iObj |] 4]
		set sLegacyPDMIdentifier [lindex [split $iObj |] 5]

		set x [::xObjRepair::xObjRepair "$sType" "$sName" "$sRev" "$oID" "$sPolicy"]
	}
	set b3DXObjSelfRestore $::TRUE

}; 

if {$::OBJREPAIRMODE == 2} {

	set b3DXObjSelfRestore $::TRUE
}; 

if {$::OBJREPAIRMODE == 3} {

	set b3DXObjSelfRestore $::TRUE
}; 

#popShadowAgent

exit;
return $b3DXObjSelfRestore

};

