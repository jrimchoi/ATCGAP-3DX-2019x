# @Program = xObjHealthCheck.lib.tcl
namespace eval ::xObjHealthCheck {

	proc init {} {
	}

	proc ObjAutonameHealthCheck {sType sName sRev oID sPolicy {sAttrLegacyPDMIdentifier ""} } {
		set sLogFile [file join "$::REPORTPATH" "gapLegacyPDMIdentifier.log"]
		set lNoGoRevs [list "BL" "BL?" "BL??" "BL???" "BL????"]
		if {[lsearch $lNoGoRevs $sRev] == -1 } {
			if {[::xUtil::isNull "$sAttrLegacyPDMIdentifier"] == $::TRUE} {
				set sAttrLegacyPDMIdentifier [::xBO::getBOAttributeValue $oID gapLegacyPDMIdentifier]
			}
			if {[::xUtil::isNull "$sAttrLegacyPDMIdentifier"] == $::FALSE} {
				array set xOtherBusinessObjects [::xBO::findOtherObjectsByLegacyName "$sType" "$sAttrLegacyPDMIdentifier" "$sPolicy"]
				if {$xOtherBusinessObjects(0) == $::TRUE} {
					set lNames [split [lindex [array get xOtherBusinessObjects NAME] 1]]
					set lRevs  [split [lindex [array get xOtherBusinessObjects REV] 1]]
				
					if {[lsearch -nocase -not $lNames "$sName"] == -1 } {
						#~ case where all members by gapLegacyPDMIdentifier have same G-###s
						set sRcd "NO-ANOMOLY: $sType $sName $sRev --> $lRevs"
						puts "$sRcd"
						set x [::xUtil::appendFile "$sRcd" "$sLogFile"]
					} else {
						#~ case where there are anomolous G-###s
						for {set i 0} {$i <= [llength $lNames]} {incr i} {
							set s1Name [lindex $lNames $i]
							set s1Rev  [lindex $lRevs $i]
							set sRcd "ANOMOLY: $sType $sName $sRev --> $sType $s1Name $s1Rev"
							puts "$sRcd"
							set x [::xUtil::appendFile "$sRcd" "$sLogFile"]
						}
					}
				} else {
					#~ search returned a FALSE (no objs) or ERROR
				}
			} else {
				#~ gapLegacyPDMIdentifier is null therefore cannot search
			}
		} else {
			#~ is a NO GO REV
		}
	}
	
	proc findAllGNumbers { } {
		foreach iObj [split [mql temp query bus DOCUMENTS G-* 0 vault "eService Production" where "policy nsmatch *Version* && attribute\[gapLegacyPDMIdentifier\] nsmatch \"\"" select id policy attribute\[gapLegacyPDMIdentifier\]  dump |] \n] {
			set sType [lindex [split $iObj |] 0]
			set sName [lindex [split $iObj |] 1]
			set sRev  [lindex [split $iObj |] 2]
			set oID   [lindex [split $iObj |] 3]
			set sPolicy [lindex [split $iObj |] 4]
			set sAttrLegacyPDMIdentifier [lindex [split $iObj |] 5]

			set x [ObjAutonameHealthCheck "$sType" "$sName" "$sRev" "$oID" "$sPolicy" "$sAttrLegacyPDMIdentifier" ]
		}
	}

	set x [init]

}; #~endNamespace

