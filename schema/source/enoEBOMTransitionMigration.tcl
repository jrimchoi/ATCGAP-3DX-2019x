#Script to run the EBOM and EBOM History relationship modification

###############################################################################
#                                                                             #
#   Copyright (c) 2003-2018 Dassault Systemes.  All Rights Reserved.          #
#   This program contains proprietary and trade secret information of         #
#   Matrix One, Inc.  Copyright notice is precautionary only and does not     #
#   evidence any actual or intended publication of such program.              #
#                                                                             #
###############################################################################

tcl;
eval {
mql set env REGISTRATIONPROGRAM "eServiceSchemaVariableMapping.tcl"
mql set context user creator;
mql verbose on;
mql trigger off;
set prefixval [mql get env 1]
append prefixval "."  
puts stdout "-----------------------------------------------------------"	
puts stdout "Transition command for TreeOrder ,PLM_ExtenalID and V_description attribute Starts...."
puts stdout "-----------------------------------------------------------"	
puts stdout ""

	set sCmdEBOM {mql print relationship EBOM select attribute\[TreeOrder\] attribute\[PLM_ExternalID\] attribute\[V_description\] dump |}
	set ebomResult [catch {eval $sCmdEBOM} outStr]
	
	set sCmdEBOMHistory {mql print relationship 'EBOM History' select attribute\[TreeOrder\] attribute\[PLM_ExternalID\] attribute\[V_description\] dump |}
	set ebomHistoryResult [catch {eval $sCmdEBOMHistory} outStr1] 
	
	set lEBOMAttr [split $outStr "|"]
	set attrTreeOrder [lindex $lEBOMAttr 0]
	set attrPLMExternalId [lindex $lEBOMAttr 1]
	set attrVDescription [lindex $lEBOMAttr 2]
	
	set lEBOMHistoryAttr [split $outStr1 "|"]
	set attrHistoryTreeOrder [lindex $lEBOMHistoryAttr 0]
	set attrHistoryPLMExternalId [lindex $lEBOMHistoryAttr 1]
	set attrHistoryVDescription [lindex $lEBOMHistoryAttr 2]
	
	#Add Tree Order attribute to EBOM and EBOM History -start
	if {[string trim $attrTreeOrder] == "FALSE"} { 
		set ebomTransCmd {mql transition attribute copy "Find Number" to TreeOrder relationship EBOM}
		
		set mqlretebom [catch {eval $ebomTransCmd} outStrebom] 
		
		if {$mqlretebom == 0} { 
			puts stdout "Attribute TreeOrder added to EBOM relationship"
		} else {
			puts stdout "Error adding Attribute TreeOrder to EBOM relationship"
		}
	} else {
		puts stdout "Attribute TreeOrder exists in EBOM relationship"
	}
	
	if {[string trim $attrHistoryTreeOrder] == "FALSE"} { 
		
		set ebomhistTransCmd {mql transition attribute copy "Find Number" to TreeOrder relationship "EBOM History"}
		
		set mqlretebomhist [catch {eval $ebomhistTransCmd} outStrebomhist] 
		
		if {$mqlretebomhist == 0} { 
			puts stdout "Attribute TreeOrder added to EBOM History relationship"
		} else {
			puts stdout "Error adding Attribute TreeOrder to EBOM History relationship"
		}
		
	} else {
		puts stdout "Attribute TreeOrder exists in EBOM History relationship"
	}
	#Add Tree Order attribute to EBOM and EBOM History -end
	
	#Add PLM_ExternalID attribute to EBOM and EBOM History -start
	if {[string trim $attrPLMExternalId] == "FALSE"} { 
		set ebomPLMExternalIDTransCmd {mql transition attribute copy "Find Number" to "PLM_ExternalID" prefix $prefixval relationship EBOM}
		
		set mqlretebom [catch {eval $ebomPLMExternalIDTransCmd} outStrebom]
		
		if {$mqlretebom == 0} { 
			puts stdout "Attribute PLM_ExternalID added to EBOM relationship"
		} else {
			puts stdout "Error adding Attribute PLM_ExternalID to EBOM relationship"
		}
	} else {
		puts stdout "Attribute PLM_ExternalID exists in EBOM relationship"
	}	

	if {[string trim $attrHistoryPLMExternalId] == "FALSE"} { 
		
		set ebomhistPLMExternalIDTransCmd {mql transition attribute copy "Find Number" to "PLM_ExternalID" prefix $prefixval relationship "EBOM History"}
		
		set mqlretPLMExternalIDebomhist [catch {eval $ebomhistPLMExternalIDTransCmd} outStrebomhist] 
		
		if {$mqlretPLMExternalIDebomhist == 0} { 
			puts stdout "Attribute PLM_ExternalID added to EBOM History relationship"
		} else {
			puts stdout "Error adding Attribute PLM_ExternalID to EBOM History relationship"
		}
		
	} else {
		puts stdout "Attribute PLM_ExternalID exists in EBOM History relationship"
	}
	#Add PLM_ExternalID attribute to EBOM and EBOM History -end
	
	#Add V_description attribute to EBOM and EBOM History -start
	if {[string trim $attrVDescription] == "FALSE"} { 
		set ebomVdescription {mql modify relationship EBOM add attribute "V_description"}
		
		set mqlretebom [catch {eval $ebomVdescription} outStrebom]
		
		if {$mqlretebom == 0} { 
			puts stdout "Attribute V_description added to EBOM relationship"
		} else {
			puts stdout "Error adding Attribute V_description to EBOM relationship"
		}
	} else {
		puts stdout "Attribute V_description exists in EBOM relationship"
	}	

	if {[string trim $attrHistoryVDescription] == "FALSE"} { 
		
		set ebomHistoryVdescription {mql modify relationship "EBOM History" add attribute "V_description"}
		
		set mqlretVdescriptionebomhist [catch {eval $ebomHistoryVdescription} outStrebomhist] 
		
		if {$mqlretVdescriptionebomhist == 0} { 
			puts stdout "Attribute V_description added to EBOM History relationship"
		} else {
			puts stdout "Error adding Attribute V_description to EBOM History relationship"
		}
		
	} else {
		puts stdout "Attribute V_description exists in EBOM History relationship"
	}
	#Add V_description attribute to EBOM and EBOM History -end

puts stdout ""
puts stdout "-----------------------------------------------------------"	
puts stdout "Transition command for TreeOrder ,PLM_ExtenalID and V_description attribute Ends...."
puts stdout "-----------------------------------------------------------"	
mql trigger on;
mql verbose off;
}

