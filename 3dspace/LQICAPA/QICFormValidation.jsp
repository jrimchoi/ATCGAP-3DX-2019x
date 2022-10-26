<%--
*!================================================================
 *  JavaScript Form Validaion
 *  QICFormValidation.jsp
 *
 *  Copyright (c) 1992-2018 Dassault Systemes. All Rights Reserved.
 *  This program contains proprietary and trade secret information
 *  of MatrixOne,Inc. Copyright notice is precautionary only
 *  and does not evidence any actual or intended publication of such program
 *
 *=================================================================
 *
--%>

<%@page import="matrix.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.matrixone.apps.domain.util.*"%>
<%@page import="com.dassault_systemes.enovia.lsa.Helper"%>
<%@page import ="com.matrixone.servlet.Framework"%>

<%@include file = "../emxContentTypeInclude.inc"%>

<script language="javascript">

<% matrix.db.Context context = Framework.getFrameContext(session); %>

function setOrganizationAsOwnersOrg()
{
	emxFormReloadField("ResponsibleOrganization");
	var vResponsibleOrganization = document.getElementById("ResponsibleOrganization");
	vResponsibleOrganization.disabled=true;
}

function showSubFactorsBasedOnFactor() {	
	emxFormReloadField("SubFactor");
	return true;
}


function preProcessViewDefectCause() 
{
	alert("preProcessViewDefectCause");
	var calc_OtherReason = document.getElementById("calc_OtherReason").value;
	calc_OtherReason.style.visibility = "hidden";
}

function preProcessEditDefectCause() 
{
	emxFormReloadField("SubFactor");
	enableDisableReasonNotDetected();
	enableDisableOtherReason();
}

function enableDisableReasonNotDetected() {	
	var DefectDetectedWithinQualityPlan = document.getElementById("DefectDetectedWithinQualityPlanId").value;	
	if (DefectDetectedWithinQualityPlan == "No") {
	  	enableDisableLabels("ReasonNotDetected",true);
	  	setLabelsAsMandOrNonMand("ReasonNotDetected",true);	
	  	enableDisableFields("ReasonNotDetected",true);	  	
	 } else{
	  	enableDisableLabels("ReasonNotDetected",false);
	  	enableDisableFields("ReasonNotDetected",false);  		
	 }
	 enableDisableOtherReason();
}

function enableDisableOtherReason() {	
	 var DefectDetectedWithinQualityPlan = document.getElementById("DefectDetectedWithinQualityPlanId").value;
	 var ReasonNotDetectedId = document.getElementById("ReasonNotDetectedId").value;
	 if (DefectDetectedWithinQualityPlan == "No" && ReasonNotDetectedId == "Other") {
	  	enableDisableLabels("OtherReason",true);
	  	setLabelsAsMandOrNonMand("OtherReason",true);
	  	enableDisableFields("OtherReason",true);	  	
	 } else{
	   	enableDisableLabels("OtherReason",false);
	  	enableDisableFields("OtherReason",false);	   
	 }
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
		label.className = 'createLabel';
	}					
}	
}

function enableDisableFields(fieldId,enable){
if(enable == true){
document.getElementById(fieldId).style.display = 'block';	
}
if(enable == false){
document.getElementById(fieldId).style.display = 'none';	
}
}

function highLightField()
{
	var param1var = getQueryVariable("formfield");
	alert("param1var="+param1var);
	var row=document.getElementById("calc_"+param1var);
	var cells = row.getElementsByTagName('td');
	cells[0].style.backgroundColor = "#ffff00";
	
}

function validateOtherReason() 
{
	 var ReasonNotDetectedId = document.getElementById("ReasonNotDetectedId").value;
	 var OtherReasonId = document.getElementById("OtherReasonId").value;	 
	 if ((ReasonNotDetectedId == "Other") && (OtherReasonId == "")) {
		  alert("Must enter value for Other Reason"); 
		  return false; 	
	 }
	 return true;
}

</script>
