<%@page import="matrix.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.matrixone.apps.domain.util.*"%>
<%@page import ="com.matrixone.servlet.Framework"%>
<%@page import="com.dassault_systemes.enovia.riskmgmt.*"%>
<%@page import="matrix.db.Context"%>
<%!
       private String getEncodedI18String(Context context, String key) throws Exception {
              try {
                     return XSSUtil.encodeForJavaScript(context,RiskMgmtUtil.getI18NString(context, RiskMgmtConstants.RISK_MGMT_STRING_RESOURCE, key));
              } catch (Exception e) {
                     throw new Exception(e);
              }
       }
%>
<%
String referer     = request.getHeader("Referer");
matrix.db.Context context = Framework.getFrameContext(session);
// emxCreate.jsp validation does not work if you use the script tags
if (referer.indexOf("emxCreate.jsp") < 0) {
%>
 
<script language="javascript">
<%
}
%>

function isEmptyOrDash(str)
{
    if(typeof str == 'undefined' || str == '-' || str == ' ' || str == '') {
	return true;
    } else {

	return false;
    }
}

function severityFieldChangeHdlr()
{
    var severityField   = document.forms[0].Severity;
    var occurrenceField = document.forms[0].Occurrence;
    var RPNField        = document.forms[0].RPN;

    if(isEmptyOrDash(severityField.value)  && !isEmptyOrDash(occurrenceField.value != '-'))
    {
	occurrenceField.value = '-';

	if(typeof RPNField != 'undefined' && RPNField.value != '-')
	{
	    RPNField.value = '-';
	    RPNField.style.backgroundColor = 'white';
	}
    }
    else if(!isEmptyOrDash(severityField.value) && !isEmptyOrDash(occurrenceField.value) && typeof RPNField != 'undefined')
    {
	RPNField.value = severityField.value * occurrenceField.value;
	setRPNFieldColor(severityField.value, occurrenceField.value, RPNField);
    }
}

function validateSevAndOcc(){
	var sev = $("[name=Severity]").val();
	var occ = $("[name=Occurrence]").val();
	if (sev != null && sev != '' && sev != '-') {
		 if (occ == null || occ == '' || occ == '-') {
			 /*XSS OK*/ alert('<%=getEncodedI18String(context,"RiskMgmt.Common.OccurrenceMandatory.Validation.Message")%>');
			return false;
		}
	}
	if (occ != null && occ != '' && occ != '-') {
		 if (sev == null || sev == '' || sev == '-') {
			 /*XSS OK*/ alert('<%=getEncodedI18String(context,"RiskMgmt.Common.SevirityMandatory.Validation.Message")%>');
			return false;
		}
	}
	return true;
}

function occurrenceFieldChangeHdlr()
{
    var severityField   = document.forms[0].Severity;
    var occurrenceField = document.forms[0].Occurrence;
    var RPNField        = document.forms[0].RPN;

    if(isEmptyOrDash(occurrenceField.value)  && !isEmptyOrDash(severityField.value))
    {
	severityField.value = '-';

	if(typeof RPNField != 'undefined' && RPNField.value != '-')
	{
	    RPNField.value = '-';
	    RPNField.style.backgroundColor = 'white';
	}
    }
    else if(!isEmptyOrDash(occurrenceField.value) && !isEmptyOrDash(severityField.value) && typeof RPNField != 'undefined')
    {
	RPNField.value = severityField.value * occurrenceField.value;
	setRPNFieldColor(severityField.value, occurrenceField.value, RPNField);
    }
}

function setRPNFieldColor(severity, occurrence, RPNField)
{
    if(severity == 5 || (severity==4 && occurrence > 2) || (severity==3 && occurrence == 5))
    {
	RPNField.style.backgroundColor = '#FF3030'; //red
    }
    else if(severity*occurrence <= 2 || (severity == 2 && occurrence == 2) || (severity == 1 && occurrence == 3))
    {
	RPNField.style.backgroundColor = '#00FF00'; //green
    }
    else
    {
	RPNField.style.backgroundColor = '#FFFF00'; //yellow
    }
}

function updateRPNField()
{
    var severityField   = document.forms[0].Severity;
    var occurrenceField = document.forms[0].Occurrence;
    var RPNField        = document.forms[0].RPN;

    if(isEmptyOrDash(occurrenceField.value))
    {
	if(!isEmptyOrDash(severityField.value))
	{
	    severityField.value  = '-'
	}
	
	if(!isEmptyOrDash(RPNField.value))
	{
	    RPNField.value = '-';
	}
    }
    else if(isEmptyOrDash(severityField.value))
    {
	if(!isEmptyOrDash(occurrenceField.value))
	{
	    occurrenceField.value = '-';
	}
	
	if(!isEmptyOrDash(RPNField.value))
	{
	    RPNField.value = '-';
	}
    }
    else
    {
	 RPNField.value =  severityField.value * occurrenceField.value;
    }
}

function updateHazardTypeField()
{
    if(document.forms[0].ImpactType.value.indexOf('Hazard') < 0)
    {
	document.forms[0].HazardType.value = "None";
    }
}

function enableDisableRiskReductionNotNeededRationale() {

    var riskReductionNeeded = document.getElementById("RiskReductionNeededId").value;
    if (riskReductionNeeded == "No") {
	setLabelsAsMandOrNonMand("RiskReductionNotNeededRationale",true);
	enableField("RiskReductionNotNeededRationale");
    } else{
	setLabelsAsMandOrNonMand("RiskReductionNotNeededRationale",false);
	disableField("RiskReductionNotNeededRationale", true);
    }
}

function isNullOrEmpty(str) {

    if(str == null || str=='null' || str=='') {
	return true;
    }
    return false;
}

function getMsg(msg, str) {

    if(msg != '') {
	
	msg = msg + ', ' + str;
    } else {

	msg = str;
    }

    return msg;
}

function validateRiskReductionNotNeededRationale() {

    var riskReductionNeeded             = document.getElementById("RiskReductionNeededId").value;
    var riskReductionNotNeededRationale = document.getElementById("RiskReductionNotNeededRationale").value;
    var occurrence                      = document.getElementById("OccurrenceId").value;
    var severity                        = document.getElementById("SeverityId").value;
    var description                     = document.getElementById("Description").value;
    var acceptanceCriteria              = document.getElementById("AcceptanceCriteria").value;

    if (riskReductionNeeded != "Undefined") {

	var msg = '';

	if (riskReductionNeeded == "No" && isNullOrEmpty(riskReductionNotNeededRationale)) {

	   /*XSS OK */ msg = getMsg(msg, '<%=getEncodedI18String(context,"RiskMgmt.Common.RiskReductionNotNeededRationale")%>');
	}

	if(isNullOrEmpty(occurrence)) {
	    
		/*XSS OK */ msg = getMsg(msg, '<%=getEncodedI18String(context,"RiskMgmt.Common.CurrentOccurrence")%>');
	}

	if(isNullOrEmpty(severity)){

		/*XSS OK */ msg = getMsg(msg, '<%=getEncodedI18String(context,"RiskMgmt.Common.CurrentSeverity")%>');
	}

	if(isNullOrEmpty(acceptanceCriteria)) {

		/*XSS OK */ msg = getMsg(msg, '<%=getEncodedI18String(context,"RiskMgmt.Common.AcceptanceCriteria")%>');
	}

	if(isNullOrEmpty(description)) {

		/*XSS OK */ msg = getMsg(msg, '<%=getEncodedI18String(context,"RiskMgmt.Common.Description")%>');
	}
	
	if(msg != '') {

		/*XSS OK */ alert('<%=getEncodedI18String(context,"RiskMgmt.Message.MissingCriteria")%>' + ' ' + msg);
	    return false;
	}
    }
    
    return true;
}

function enableDisableLabels(labelName,enable){
	var labels = document.getElementsByTagName("label");
	var noOfLabels = labels.length;	
	for (var index = 0; index < noOfLabels; index++) {
		var label = labels[index];		
		if((label.htmlFor == labelName) && (enable == true)) {
			label.style.display = 'block';
		}
		if((label.htmlFor == labelName) && (enable == false)) {
			label.style.display = 'none';
		}		
	}	
}

function setLabelsAsMandOrNonMand(labelName, mand){
	var labels = document.getElementsByTagName("label");
	var noOfLabels = labels.length;	
	for (var index = 0; index < noOfLabels; index++) {
		var label = labels[index];		
		if((label.htmlFor == labelName) && (mand == true)) {
			label.className = 'labelRequired';
		}
		if((label.htmlFor == labelName) && (mand == false)){
			label.className = 'label';
		}					
	}	
 }
 
function disableField(fieldId, clearValue) {
    
    document.getElementById(fieldId).disabled=true;
    document.getElementById(fieldId).value='';
}

function enableField(fieldId) {
    
    document.getElementById(fieldId).disabled=false;
}

function validateRiskReductionNotRequiredRationale(){
	  var riskReductionNeeded             = document.getElementById("RiskReductionRequiredId").value;
	  var riskReductionNotNeededRationale = document.getElementById("RiskReductionNotRequiredRationale").value;
		if (riskReductionNeeded == "No" && (isNullOrEmpty(riskReductionNotNeededRationale) || riskReductionNotNeededRationale=="Undefined")) {
			/*XSS OK */ alert('<%=getEncodedI18String(context,"RiskMgmt.Hazard.Message.RiskReductionNotNeededRationaleRequired")%>');
			return false;
		}
	  
	  return true;
}

function validateRiskAcceptabilityJustification(){
	  var riskAcceptable             = document.getElementById("RiskAcceptableId").value;
	  var riskAcceptabilityJustification = document.getElementById("RiskAcceptabilityJustification").value;
		if ((riskAcceptable == "No" || riskAcceptable=="Yes") && (isNullOrEmpty(riskAcceptabilityJustification) || riskAcceptabilityJustification =="Undefined")) {
			/*XSS OK */ alert('<%=getEncodedI18String(context,"RiskMgmt.Hazard.Message.RiskAcceptabilityJustificationRequired")%>');
			return false;
		}
	  
	  return true;
}

function validateRiskAcceptabilityCriteria(){
	  var riskReductionNeeded             = document.getElementById("RiskReductionRequiredId").value;
	  var riskAcceptabilityCriteria = document.getElementById("RiskAcceptabilityCriteria").value;
		if (riskReductionNeeded == "Yes" && (isNullOrEmpty(riskAcceptabilityCriteria) || riskAcceptabilityCriteria =="Undefined")) {
			/*XSS OK */ alert('<%=getEncodedI18String(context,"RiskMgmt.Hazard.Message.RiskAcceptabilityCriteriaRequired")%>');
			return false;
		}
	  
	  return true;
}

function enableDisableRiskAcceptabilityJustification() {

    var riskAcceptable = document.getElementById("RiskAcceptableId").value;
    if (riskAcceptable == "No" || riskAcceptable=="Yes") {
		setLabelsAsMandOrNonMand("RiskAcceptabilityJustification",true);
		enableField("RiskAcceptabilityJustification");
    }else{
    	setLabelsAsMandOrNonMand("RiskAcceptabilityJustification",false);
		disableField("RiskAcceptabilityJustification", true);
    }
}

function enableDisableFieldsOnRiskReductionRequiredChange() {

    var riskReductionNeeded = document.getElementById("RiskReductionRequiredId").value;
    if (riskReductionNeeded == "No") {
		setLabelsAsMandOrNonMand("RiskReductionNotRequiredRationale",true);
		enableField("RiskReductionNotRequiredRationale");
		setLabelsAsMandOrNonMand("RiskAcceptabilityCriteria",false);
		disableField("RiskAcceptabilityCriteria", true);
    } else if(riskReductionNeeded == "Yes"){
    		setLabelsAsMandOrNonMand("RiskAcceptabilityCriteria",true);
    		enableField("RiskAcceptabilityCriteria");
    		setLabelsAsMandOrNonMand("RiskReductionNotRequiredRationale",false);
			disableField("RiskReductionNotRequiredRationale", true);
    }else{
    		setLabelsAsMandOrNonMand("RiskAcceptabilityCriteria",false);
			disableField("RiskAcceptabilityCriteria", true);
			setLabelsAsMandOrNonMand("RiskReductionNotRequiredRationale",false);
			disableField("RiskReductionNotRequiredRationale", true);
    }
}

<%
// emxCreate.jsp validation does not work if you use the script tags
if (referer.indexOf("emxCreate.jsp") < 0) {
%>
</script>
<%
}
%>
