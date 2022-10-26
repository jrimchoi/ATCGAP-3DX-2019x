# @Program = xObjInspector.lib.tcl

# @NAMESPACE::xObjInspector - implements utilities for reporting on business objects in Matrix
namespace eval ::xObjInspector {

	proc init {} {
	}
	

	proc inspectEnvironment {{fLog ""}} {
		append sLogData "\n#############################################################################\n"
		append sLogData "############################ ENVIRONMENT INSPECTOR ############################\n"
		append sLogData "#############################################################################\n"

		append sLogData "\n#-------------------------   RPE ENV   -------------------------#\n"
		append sLogData [mql list env]

		append sLogData "\n#-------------------------   TCL ENV   -------------------------#\n"
		foreach {p v } [array get ::env] { append sLogData "$p = $v" }

		set x [::xUtil::appendFile "$sLogData" "$fLog"]

	}

	proc inspectCommands {{fLog ""}} {
		append sLogData "\n#############################################################################\n"
		append sLogData "############################ COMMAND INSPECTOR ############################\n"
		append sLogData "#############################################################################\n"

		foreach iCmd [info proc ::*] {
			append sLogData "$iCmd"
		}
		foreach iNmsp [namespace children] {
			append sLogData "Namespace: $iNmsp ---------------------\n"
			foreach iCmd [info proc ::${iNmsp}::*] {
				set xArgs [info args $iCmd]
				append sLogData "${iCmd} ($xArgs)\n"
			}
		}
		set x [::xUtil::appendFile "$sLogData" "$fLog"]
	}

	proc inspectBusinessObject { {oID ""} {fLog ""}} {

		append sLogData "\n#############################################################################\n"
		append sLogData "########################### BUSINESSOBJECT INSPECTOR ###########################\n"
		append sLogData "#############################################################################\n"

		if {[string compare "$oID" ""] == 0 } {
			set oXID ${OBJECTID}
		} else {
			set oXID "$oID"
		}

		append sLogData "\n\n#------------------------- BUSINESSOBJECT -------------------------#\n"
		foreach {t n r oID o v p c fn fc sPrj} [split [mql print bus ${oXID} select type name revision id owner vault policy current format.file.name format.file.capturedfile attribute\[SC_PSS Project Number\] dump |] |] { break ;}
		append sLogData "--- Extended Basics ---\n"
		append sLogData "Type=$t \nName=$n \nRev=$r \noID=$oID \nOwner=$o \nVault=$v \nPolicy=$p \nCurrent State=$c \nFile=$fn \nCapturedFile=$fc \n"

		append sLogData "\n#------------------   BUSINESSOBJECT LIFECYCLE   ------------------#\n"
		set sStates [mql print bus $oID select policy.state dump -->]
		set sCurrentState [split [mql print bus $oID select current dump |] |]
		regsub  "$sCurrentState" "$sStates" "($sCurrentState)" sStates2
		append sLogData "Policy($p): $sStates2 \n"

		append sLogData "\n#------------------   BUSINESSOBJECT ATTRIBUTES   ------------------#\n"
		append sLogData "[mql print bus ${oXID} select attribute.value] \n"

		set x [catch {mql expand bus $oXID} xObjConnections]
		if {$x == 0} {
		append sLogData "\n#------------------   BUSINESSOBJECT CONNECTIONS   ------------------#\n"
			append sLogData "$xObjConnections\n"
		}

		append sLogData "\n\n#----------------------- BUSINESSOBJECT HISTORY -----------------------#\n"
		set sHistory [mql print bus $oXID select history]
		append sLogData "$sHistory \n"
		
		append sLogData "\n\n###########################################################################\n"
		append sLogData "######################### END LISTING #####################################\n"
		append sLogData "###########################################################################\n\n\n"
		

		set x [::xUtil::appendFile "$sLogData" "$fLog"]

	
	}

	set x [::xObjInspector::init]


}; #~endNamespace

