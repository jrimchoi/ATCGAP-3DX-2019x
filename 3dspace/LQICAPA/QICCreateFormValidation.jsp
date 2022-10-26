<%--
*!================================================================
 *  JavaScript Create Form Validaion
 *  QICCreateFormValidation.jsp
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
<%@page import="com.dassault_systemes.enovia.lsa.qic.QICException"%>
<%@page import="matrix.db.Context"%>
<%@include file = "../emxContentTypeInclude.inc"%>
<% matrix.db.Context context = Framework.getFrameContext(session); %>
<%!
       private String getEncodedI18String(Context context, String key) throws QICException {
              try {
                     return XSSUtil.encodeForJavaScript(context,Helper.getI18NString(context, Helper.StringResource.QIC, key));
              } catch (Exception e) {
                     throw new QICException(e);
              }
       }
%>

//=================================================================
// Validation for various CAPA Forms and Fields
//=================================================================

function checkForCAPAType()
{
	alert("inside Create form validation method");
}

function showSubFactorsBasedOnFactor() {	
		emxFormReloadField("SubFactor");
		return true;
}

function showSubFactorsBasedOnTableFactor() {	
	emxEditableTable.reloadCell("SubFactor");
	return true;
}

function preProcessCreateDefectCause() 
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
	  	enableDisableFields("ReasonNotDetectedId",true);	  	
	 } else{
	  	enableDisableLabels("ReasonNotDetected",false);
	  	enableDisableFields("ReasonNotDetectedId",false);  		
	 }
	 enableDisableOtherReason();
}

function enableDisableOtherReason() {	
	 var DefectDetectedWithinQualityPlan = document.getElementById("DefectDetectedWithinQualityPlanId").value;
	 var ReasonNotDetectedId = document.getElementById("ReasonNotDetectedId").value;
	 if (DefectDetectedWithinQualityPlan == "No" && ReasonNotDetectedId == "Other") {
	  	enableDisableLabels("OtherReason",true);
	  	setLabelsAsMandOrNonMand("OtherReason",true);
	  	enableDisableFields("OtherReasonId",true);	  	
	 } else{
	   	enableDisableLabels("OtherReason",false);
	  	enableDisableFields("OtherReasonId",false);	   
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

function changeLabelFontColor(){
	var labels = document.getElementsByTagName("label");
		var noOfLabels = labels.length;		
		for (var index = 0; index < noOfLabels; index++) {
			var label = labels[index];			
			if(label.htmlFor == "CopyFrom") {
				label.style.display = 'none';
			}			
		}
}

function appendCopyOptionsForCopyFromExistingCAPA() {
	var vCreateMode = document.getElementsByName("CreateMode")[0];
	var vCopyFrom = document.getElementsByName("CopyFromDisplay")[0];
	var vBtnCopyFrom = document.getElementsByName("btnCopyFrom")[0];
	var vFolderContents = document.getElementById("FolderContentsId");
	var vTasks = document.getElementById("TasksId");
	var vTaskDeliverables = document.getElementById("TaskDeliverablesId");
	var vAddSourceAsRelatedCAPA = document.getElementById("AddSourceAsRelatedCAPAId");
	var vTemplate = document.getElementById("TemplateId");
	var vTemplateQuestion = document.getElementsByName("TemplateQuestionDisplay")[0];
	var vBtnTemplateQuestion = document.getElementsByName("btnTemplateQuestion")[0];
	
	if(vCreateMode.value == "CAPA Template") {
		vCopyFrom.disabled = true;
		vBtnCopyFrom.disabled = true;
		vFolderContents.disabled = true;
		vTasks.disabled = true;
		vTaskDeliverables.disabled = true;
	 	vAddSourceAsRelatedCAPA.disabled = true;
	 	vTemplate.disabled = false;
	 	vTemplateQuestion.disabled = true;
	 	vTemplateQuestion.value = "";
	 	vBtnTemplateQuestion.disabled = true;
	 	setLabelsAsMandOrNonMand("CopyFrom", false);
	 	setLabelsAsMandOrNonMand("CopyFrom", false);
	
	} else if(vCreateMode.value == "Existing CAPA") {
		vCopyFrom.disabled = false;
		vBtnCopyFrom.disabled = false;
		vFolderContents.disabled = false;
		vTasks.disabled = false;
		vTaskDeliverables.disabled = false;
	 	vAddSourceAsRelatedCAPA.disabled = false;
	 	vTemplate.disabled = true;
	 	vTemplate.selectedIndex = 0;
	 	vTemplateQuestion.disabled = true;
	 	vTemplateQuestion.value = "";
	 	vBtnTemplateQuestion.disabled = true;
	 	setLabelsAsMandOrNonMand("CopyFrom", true);
	    setLabelsAsMandOrNonMand("TemplateQuestion", false);
	 	
	} else {
		vCopyFrom.disabled = true;
		vBtnCopyFrom.disabled = true;
		vFolderContents.disabled = true;
		vTasks.disabled = true;
		vTaskDeliverables.disabled = true;
	 	vAddSourceAsRelatedCAPA.disabled = true;
	 	vTemplate.disabled = true;
	 	vTemplate.selectedIndex = 0;
	 	vTemplateQuestion.disabled = true;
	 	vTemplateQuestion.value = "";
	 	vBtnTemplateQuestion.disabled = true;
	 	setLabelsAsMandOrNonMand("CopyFrom", false);
	    setLabelsAsMandOrNonMand("TemplateQuestion", false);
	}
}

function hideCopyOptionsForCopyFromExistingCAPA() {
	var vType = document.getElementsByName("TypeActual");
	var vCopyFrom = document.getElementsByName("CopyFromDisplay")[0];
	var vBtnCopyFrom = document.getElementsByName("btnCopyFrom")[0];
	var vFolderContents = document.getElementById("FolderContentsId");
	var vTasks = document.getElementById("TasksId");
	var vTaskDeliverables = document.getElementById("TaskDeliverablesId");
	var vAddSourceAsRelatedCAPA = document.getElementById("AddSourceAsRelatedCAPAId");
	var vTemplate = document.getElementById("TemplateId");
	var vTemplateQuestion = document.getElementsByName("TemplateQuestionDisplay")[0];
	var vBtnTemplateQuestion = document.getElementsByName("btnTemplateQuestion")[0];
	if(vTemplate.value != "") {
	 	vCopyFrom.disabled = true;
		vBtnCopyFrom.disabled = true;
		vFolderContents.disabled = true;
		vTasks.disabled = true;
		vTaskDeliverables.disabled = true;
	 	vAddSourceAsRelatedCAPA.disabled = true;
	 	
	 	var vTemplateDetails = vTemplate.value.split("-");
	 	if (vTemplateDetails[1] == "No") {
	 	 	vTemplateQuestion.disabled = true;
			vBtnTemplateQuestion.disabled = true;
	 	} else {
	 		setLabelsAsMandOrNonMand("TemplateQuestion", true);
	 	}
	} else {
		vTemplateQuestion.disabled = true;
		vBtnTemplateQuestion.disabled = true;
	}
}

function appendTemplateIdInOnClickURL() {
	var vTemplate = document.getElementById("TemplateId");
	var vTemplateQuestion = document.getElementsByName("TemplateQuestionDisplay")[0];
	var vBtnTemplateQuestion = document.getElementsByName("btnTemplateQuestion")[0];
	var vCopyFrom = document.getElementsByName("CopyFromDisplay")[0];
	var vBtnCopyFrom = document.getElementsByName("btnCopyFrom")[0];
	var vFolderContents = document.getElementById("FolderContentsId");
	var vTasks = document.getElementById("TasksId");
	var vTaskDeliverables = document.getElementById("TaskDeliverablesId");
	var vAddSourceAsRelatedCAPA = document.getElementById("AddSourceAsRelatedCAPAId");
	
	var vTemplateDetails = vTemplate.value.split("-");
	vTemplateQuestion.value = "";
	vCopyFrom.value = "";
	if(vTemplateDetails[0] == "") {
		vTemplateQuestion.disabled = true;
 		vBtnTemplateQuestion.disabled = true;
 		setLabelsAsMandOrNonMand("TemplateQuestion", false);
 		vCopyFrom.disabled = false;
		vBtnCopyFrom.disabled = false;
		vFolderContents.disabled = false;
		vTasks.disabled = false;
		vTaskDeliverables.disabled = false;
	 	vAddSourceAsRelatedCAPA.disabled = false;
 		
	} else if (vTemplateDetails[1] == "No") {
		vTemplateQuestion.disabled = true;
 		vBtnTemplateQuestion.disabled = true;
 		setLabelsAsMandOrNonMand("TemplateQuestion", false);
 		vCopyFrom.disabled = true;
		vBtnCopyFrom.disabled = true;
		vFolderContents.disabled = true;
		vTasks.disabled = true;
		vTaskDeliverables.disabled = true;
	 	vAddSourceAsRelatedCAPA.disabled = true;
	} else {
		vTemplateQuestion.disabled = false;
 		vBtnTemplateQuestion.disabled = false;
		vBtnTemplateQuestion.onclick = function() {
		
			var test = vTemplateDetails[0];
			javascript:showChooser("../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.qic.services.ui.CAPA:actionAppendQuestionObjectIDs&suiteKey=LQICAPA&fieldNameActual=TemplateQuestion&fieldNameDisplay=TemplateQuestionDisplay&fieldNameOID=TemplateQuestionOID&suiteKey=LQICAPA&validateToken=false&templateId=" + vTemplateDetails[0],'600','600','true','','TemplateQuestion');
		    
	    };
	    setLabelsAsMandOrNonMand("TemplateQuestion", true);
	    vCopyFrom.disabled = true;
		vBtnCopyFrom.disabled = true;
		vFolderContents.disabled = true;
		vTasks.disabled = true;
		vTaskDeliverables.disabled = true;
	 	vAddSourceAsRelatedCAPA.disabled = true;
	}
}

function validateTemplateQuestion() 
{	var vTemplate = document.getElementById("TemplateId");
	var vTemplateQuestion = document.getElementsByName("TemplateQuestionDisplay")[0].value;
	
	var vTemplateDetails = vTemplate.value.split("-");
	
	 if (vTemplateDetails[1] == "Yes" && vTemplateQuestion == "") {
	 	  /*XSS OK*/ var msg = "<%=getEncodedI18String(context,"QIC.CAPATemplate.MustEnterValueForTemplateQuestion")%>"; 
		  alert(msg); 
		  return false; 	
	 }
	 return true;
}

function setTaskDeliverablesOption()
{
	var tasks = emxFormGetValue("Tasks");
	if(tasks!=null && tasks.current.actual=="IGNORE")
	{
		emxFormSetValue("TaskDeliverables", "IGNORE");
		emxFormDisableField("TaskDeliverables",false);
		
	}else{
		emxFormSetValue("TaskDeliverables", "COPY");
		emxFormDisableField("TaskDeliverables",true);
	}
}

