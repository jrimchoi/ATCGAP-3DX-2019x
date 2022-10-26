<%--
*!================================================================
 *  JavaScript Create Form Validaion
 *  QICCreateFormValidation.jsp
 *
 *  Copyright (c) 1992-2017 Dassault Systemes. All Rights Reserved.
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
<%@page import="matrix.db.Context"%>
<%@page import="com.dassault_systemes.enovia.lsa.LSAException"%>
<% 
matrix.db.Context context = Framework.getFrameContext(session); 
%>

<%!
       private String getEncodedI18String(Context context, String key) throws LSAException {
              try {
                     return XSSUtil.encodeForJavaScript(context,Helper.getI18NString(context, Helper.StringResource.AUDIT, key));
              } catch (Exception e) {
                     throw new LSAException(e);
              }
       }
%>
//=================================================================
// Validation for various Audit Forms and Fields
//=================================================================


function checkAuditType()
	{
         var fieldAuditType = document.getElementById("Audit TypeId");
		 var FieldValue=fieldAuditType.options[fieldAuditType.selectedIndex].text;
	     var fieldSupplierLabel = document.getElementById("calc_Suppliers");
	     var fieldSupplierValue = document.getElementsByName("SuppliersDisplay")[0];
	     var fieldSupplierButton = document.getElementsByName("btnSuppliers")[0];	     
	    
	     if(FieldValue=="Supplier")
	     {
	     	  enableDisableLabels("Suppliers",true);
			  fieldSupplierLabel.style.display="";
			  fieldSupplierValue.style.display="";
			  fieldSupplierButton.style.display="";
	     }
		else
		{
			  enableDisableLabels("Suppliers",false);
			  fieldSupplierLabel.style.display="none";			 
			  fieldSupplierValue.style.display="none";
			  fieldSupplierButton.style.display="none";			 
	  	}
		
		//make the Audit External Infor field visible and nivisible
		var varField = document.getElementById("Audit External Info");
		if(FieldValue=="Other")
		{
			varField.style.visibility = "visible";
		}
		else
		{
			varField.style.visibility = "hidden";
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

function checkSupplier() {
		var auditType = document.getElementsByName("Audit Type")[0];
		if(auditType.value == "Supplier") {
			var supplier = document.getElementsByName("SuppliersDisplay")[0];
			if(supplier.value.length == 0) {
				/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.SupplierRequired")%>");
				supplier.focus();
				return false;
			}
		}
		return true;	
}

function checkTemplateName() {
	if(confirmFieldLimit125(this.value.length) == true) {
		if(checkDuplicateTemplateName(this.value) == true) {
			return true;
		}
	}
	this.focus();
	return false;
}

function confirmFieldLimit125(numChars)
{
    if (numChars > 125)
	{
    	/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.AuditTemplateFieldLength")%>");
       this.focus();
       return false;
    }
	return true;
}

function checkDuplicateTemplateName(templateName) {
    var pageParams = getTopWindow().location.search;
    if (pageParams == "") {
            pageParams = "?";
        }
        else {
            pageParams += "&";
    }
    // Build URL and include the parameters we need to pass
    var url = "../common/iwCSAjaxController.jsp" + pageParams + "listProgramName=" + escape("com.dassault_systemes.enovia.lsa.audit.services.ui.AuditAuditTemplate:checkDuplicateTemplateNameFieldAjax");
    url += "&" + escape("templateName") + "=" + escape(templateName);
    
    // Create the appropriate request based on 
    // browser being used
    if (window.XMLHttpRequest) {
       	request = new XMLHttpRequest();
    }
    else if (window.ActiveXObject) {
       	request = new ActiveXObject("Microsoft.XMLHTTP");
    }

    // Make the synchrounous call. The 'false' makes 
    // this synchronous
    request.open("GET", url, false);
    request.send(null);
    var resText = request.responseText.split("ajaxResponse");       
    var jsObject = eval("(" + resText[1] + ")");
    var result = jsObject.result;
    // Parse the return value to see if the
    // validation passed
    if (result[0].value == "false") {
   	/*XSS OK*/ 	alert("'" + templateName + "'" + " " + "<%=getEncodedI18String(context,"LQIAudit.Message.NameNotUnique")%>");
    return false;
    } else {
       	return true;
    }
}

function auditRequestTemplateChangeHandler(){
	var templateOID = document.getElementsByName("AuditRequestTemplateOID")[0].defaultValue;
		
	if(templateOID==""){
		// The user removed the template so clear all values
    	setValuesFromAuditRequestTemplate("","","");
		return;
	}else{
		// Make AJAX call to get the data we need
		var result = getAuditRequestTemplateData(templateOID);	
			
		// Pull the various fields out of the data returned from the
		// AJAX call
    	var description = getResultValue(result,"description");
    	var scope = getResultValue(result,"scope");
    	var auditFunctionArea = getResultValue(result,"Audit Functional Area");
    	// Set all values
    	setValuesFromAuditRequestTemplate(description,scope,auditFunctionArea);
	}
}

function setValuesFromAuditRequestTemplate(description,scope,auditFunctionArea){
   	emxFormSetValue("description",description,description);
   		
   	var Scope = document.getElementById("Audit Sub-SystemId");
   	Scope.value=scope;
   		
   	var AuditFunctionArea = document.getElementById("Audit Functional AreaId");
   	AuditFunctionArea.value = auditFunctionArea;
}

function getAuditRequestTemplateData(auditRequestTemplateId){
	var queryString="&ajaxMode=true&suiteKey=LQIAudit&auditRequestTemplateId="+auditRequestTemplateId; //XSSOK
	var response = emxUICore.getDataPost("../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.audit.services.ui.AuditRequestTemplate:getAuditRequestsTemplateInformationAjax",queryString);
	var jsObject = eval('(' + response + ')');
	var result = jsObject.result;
	return result;
}

// Helper routine to find a parameter in a map.
function getResultValue(result,key){
	for(var i = 0; i < result.length; i++) {
		if(result[i].text==key){
			return result[i].value;
		}
    }
    // did not find it so return nothing.
    return "";
}

function auditTemplateChangeHandler() {
	var templateOID = document.getElementsByName("AuditTemplateOID")[0];
	if(templateOID.value==""){
		// The user removed the template so clear all values
		setValuesFromTemplate("","","","","","","","","");
		return;
	}else{
		// Make AJAX call to get the data we need
		var result = getAuditTemplateData(templateOID);	
			
		// Pull the various fields out of the data returned from the
		// AJAX call
    	var description = getResultValue(result,"description");
    	var auditType = getResultValue(result,"auditType");
    	var scope = getResultValue(result,"scope");
    	var auditExternalInfo = getResultValue(result,"auditExternalInfo");
    	var connectedLocation = getResultValue(result,"connectedLocation");
    	var connectedLocationID = getResultValue(result,"connectedLocationID");
    	var connectedSupplier = getResultValue(result,"connectedSupplier");
    	var connectedSupplierID = getResultValue(result,"connectedSupplierID");
    	var connectedAuditedItemsName = getResultValue(result,"connectedAuditedItemsName");
    	var connectAuditedItemsIds = getResultValue(result,"connectAuditedItemsIds");
    		
    	// Set all values
    	setValuesFromTemplate(description,auditType,scope,auditExternalInfo,connectedLocation,connectedLocationID,connectedSupplier,connectedSupplierID,connectedAuditedItemsName,connectAuditedItemsIds);
	}
}

function getAuditTemplateData(templateOID){
	var queryString="&ajaxMode=true&suiteKey=LQIAudit&templateOID="+templateOID.defaultValue; //XSSOK
	var response = emxUICore.getDataPost("../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.audit.services.ui.AuditAuditTemplate:getTemplateInformationAjax",queryString);
	var jsObject = eval('(' + response + ')');
	var result = jsObject.result;
	return result;
}

function setValuesFromTemplate(description,auditType,scope,auditExternalInfo,connectedLocation,connectedLocationID,connectedSupplier,connectedSupplierID,connectedAuditedItemsName,connectAuditedItemsIds) {
   	emxFormSetValue("description",description,description);
  
   	//set the value of Audit Type
   	var AuditType = document.getElementsByName("Audit Type")[0];
   	//var AuditType = document.getElementById("Audit Type");
	var AuditExternalInfo = document.getElementById("Audit External Info");
	AuditType.value=auditType;
	
	if("Other" == auditType)
	{
		var AuditExternalInfo = document.getElementById("Audit External Info");
		AuditExternalInfo.style.visibility = "visible";
		AuditExternalInfo.value = auditExternalInfo;
	}
	
	emxFormSetValue("Suppliers",connectedSupplierID,connectedSupplier);
	emxFormSetValue("Audit Location",connectedLocationID,connectedLocation);
	emxFormSetValue("Audit Device",connectAuditedItemsIds,connectedAuditedItemsName);
	emxFormReloadField('Audit Device');

	checkAuditType();

	var scopeArray = new Array();
	//setting the value of Scope or SubSystem
	var subCount = document.getElementById("SUB_Count");
	var new_value = scope;

	scopeArray = new_value.split(",");
	var varScope = "";
	var bFlag = true;
	var sFormattedString = "";
	var SubSystem;
		
	// First clear all checkboxes so we start with a clean slate
		
	// clear any custom scopes that may have been added    
   	while(true){
        var customScope = document.getElementsByName("customScope")[0];
      	if(customScope!=undefined){
			customScope.parentNode.removeChild(customScope);
		}else{
			break;
		}
  	}
			
	//iterate through the available scopes from template and check the appropriate ones
	for (i=0; i < scopeArray.length; i++)
	{
		varScope = scopeArray[i] ; 
		for(var j=1; j <= subCount.value; j++) 
		{		
			var AuditSubSystem = "Audit Sub-System"+j;
			SubSystem = document.getElementById(AuditSubSystem);
			//if available, mark it as checked.
			if( varScope == SubSystem.value )
			{
				SubSystem.checked = "checked";
				bFlag = false;
				//if found break the loop;
				break;
			}
		}
		
		//if not found in the checked item list, means its a custom added scope.
		if(bFlag && varScope != "" && varScope.length > 0)
		{
			//create DIV HTML Text and add 
			var fieldName = "SUB_Audit Sub-System" ;
			var count = document.getElementById("count_"+fieldName);
			numOfAuditors = eval(count.value);
			var anchorDiv = document.getElementById("anchorDiv_"+fieldName);
			var divIdName = "Auditor_"+numOfAuditors+"_Div_"+fieldName;
			var newdiv = document.createElement("DIV");
			newdiv.setAttribute("id",divIdName);
			newdiv.setAttribute("name", "customScope");
		
			var sHTML = '&nbsp;';
			sHTML += '<img src="images/iconSmallPerson.gif" alt="" name="'+varScope+'"/>';
			sHTML += '&nbsp;'+ varScope;
			sHTML += '&nbsp;<a href="javascript:;" onclick="removeAuditor(\''+divIdName+'\',\''+fieldName+'\');">Remove</a>';
			newdiv.innerHTML = sHTML;
			anchorDiv.appendChild(newdiv);
				
			numOfAuditors++;
			count.value = numOfAuditors;
				
			//format if there are multiple values
			if(sFormattedString == ""){
				sFormattedString = varScope ;
			}else{
				sFormattedString = sFormattedString + "," + varScope ;
			}
		}
		bFlag = true;
	}
		
	//update final variable to hold the values for saving purpose
	if(sFormattedString != null && sFormattedString != "" && sFormattedString.length > 0)
	{
		var formattedAuditors = document.getElementsByName("Final_"+fieldName)[0];
		formattedAuditors.value = sFormattedString;
		//assign value to have old value updated to the field.
		var varOldVal = document.getElementById("ARR_"+fieldName);
		varOldVal.value = sFormattedString;
	}
}

function checkAuditTypeAndIsReAudit()
{
	checkAuditType();
	checkIsReAudit();
}

function findingScopeFieldCheck()
{
	var varCount = document.getElementById("SUB_Count");
	var varCountNo=varCount.value;
	var varScope;
	var varBlank=false;
	var ScopeArray = new Array();
	//Getting the Scope values
	for( h=1;h<=varCountNo;h++)
	{
	  varScope = document.getElementById("Audit Sub-System"+h);
	  ScopeArray[h]=varScope;

	}
	//Give the alert messages if the Required fields are blank
	for( j=1;j<ScopeArray.length;j++)
	{
	    if(ScopeArray[j].checked)
		 {
			varBlank=true;
		 }
	}
	//check for additional scope entered by user for Audit
	var additionalFinalScope = document.getElementsByName("Final_SUB_Audit Sub-System")[0];
	if(additionalFinalScope != undefined)
	{
		if(additionalFinalScope.value != "")
		{
			varBlank=true;
		}
	}

	if(varBlank==false)
	{
		/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.ScopevalueMessage")%>");
		 return false;
	}
	return true;
}

function validatePlannedDateToEndDate()
	{
		var endDateFeild = document.getElementById("Audit Planned End Date");
		var endDateValue = endDateFeild.value;
	 	var endDate_msvalue = document.getElementsByName("Audit Planned End Date_msvalue")[0];
		var startDate_msvalue = document.getElementsByName("Audit Planned Start Date_msvalue")[0];
		var endDate = new Date();
		endDate.setTime(endDate_msvalue.value);
		endDate.setHours(0,0,0,0); 
       	var startDate= new Date();
      	startDate.setTime(startDate_msvalue.value);
       	startDate.setHours(0,0,0,0); 
		if(endDateValue=="")
		{
			 return true;
		}
		else if(startDate>endDate)
		{
			/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.PlannedEndDateValue")%>");
			endDateFeild.focus();
			return false;
		} 
		return true;
}
function checkIsReAudit()
	{
	var isReAudit = emxFormGetValue("AuditIsReAudit");
	if(isReAudit!=null && isReAudit.current.actual=="Yes")
	{
		emxFormDisableField("AuditReAudit",true);
		setLabelsAsMandOrNonMand("AuditReAudit",true);
		
	}else{
	  	emxFormDisableField("AuditReAudit", false);
	  	emxFormSetValue("AuditReAudit","","");
	  	setLabelsAsMandOrNonMand("AuditReAudit",false);
	}
}

function auditReAuditFieldCheck(){
	var auditReAudit = emxFormGetValue("AuditReAudit");
	var isReAudit = emxFormGetValue("AuditIsReAudit");
	if(isReAudit!=null && isReAudit.current.actual=="Yes" && (null==auditReAudit.current.actual || ""==auditReAudit.current.actual || undefined==auditReAudit.current.actual))
	{
		/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.ReAuditOf")%>");
		 return false;		
	}
	return true;
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

function createAuditFromContextAuditRequestPreProcess(){
	checkAuditTypeAndIsReAudit();
		
	var contextRequestId = emxUICore.getContextId(false);
    var requestObjectIds = new Array();
    requestObjectIds.push(contextRequestId);
	var result = getAuditRequestsData(requestObjectIds);
	var description = getResultValue(result,"description");
	var scope = getResultValue(result,"scope");
	setValuesFromAuditRequest(description,scope);
}

function createAuditFromAuditRequestPreProcess(){
	checkAuditTypeAndIsReAudit();
	var sourceFrame = findFrame(getTopWindow(), "QICAUDAuditRequests");
	var checkedItem = sourceFrame.getCheckedCheckboxes();
	var requestObjectIds = new Array();
	for (var e in checkedItem){
		var aId = e.split("|");
		var objId  = aId[1];
		requestObjectIds.push(objId);
	}
	var result = getAuditRequestsData(requestObjectIds);
	var description = getResultValue(result,"description");
	var scope = getResultValue(result,"scope");
	setValuesFromAuditRequest(description,scope);
}

function getAuditRequestsData(requestObjectIds){
	var queryString="&ajaxMode=true&suiteKey=LQIAudit&requestObjectIds="+requestObjectIds; //XSSOK
	var response = emxUICore.getDataPost("../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.audit.services.ui.AuditRequest:getAuditRequestsInformationAjax",queryString);
	var jsObject = eval('(' + response + ')');
	var result = jsObject.result;
	return result;
}

function setValuesFromAuditRequest(description,scope){
  	emxFormSetValue("description",description,description);
   		
   	var scopeArray = new Array();
	//setting the value of Scope or SubSystem
	var subCount = document.getElementById("SUB_Count");
	var new_value = scope;

	scopeArray = new_value.split(",");
	var varScope = "";
	var bFlag = true;
	var sFormattedString = "";
	var SubSystem;
		
	// First clear all checkboxes so we start with a clean slate
		
	// clear any custom scopes that may have been added    
   	while(true){
        var customScope = document.getElementsByName("customScope")[0];
       	if(customScope!=undefined){
			customScope.parentNode.removeChild(customScope);
		}else{
			break;
		}
   	}
			
	//iterate through the available scopes from template and check the appropriate ones
	for (i=0; i < scopeArray.length; i++)
	{
		varScope = scopeArray[i] ; 
		for(var j=1; j <= subCount.value; j++) 
		{		
			var AuditSubSystem = "Audit Sub-System"+j;
			SubSystem = document.getElementById(AuditSubSystem);
			//if available, mark it as checked.
			if( varScope == SubSystem.value )
			{
				SubSystem.checked = "checked";
				bFlag = false;
				//if found break the loop;
				break;
			}
		}
		
		//if not found in the checked item list, means its a custom added scope.
		if(bFlag && varScope != "" && varScope.length > 0)
		{
			//create DIV HTML Text and add 
			var fieldName = "SUB_Audit Sub-System" ;
			var count = document.getElementById("count_"+fieldName);
			numOfAuditors = eval(count.value);
			var anchorDiv = document.getElementById("anchorDiv_"+fieldName);
			var divIdName = "Auditor_"+numOfAuditors+"_Div_"+fieldName;
			var newdiv = document.createElement("DIV");
			newdiv.setAttribute("id",divIdName);
			newdiv.setAttribute("name", "customScope");
		
			var sHTML = '&nbsp;';
			sHTML += '<img src="images/iconSmallPerson.gif" alt="" name="'+varScope+'"/>';
			sHTML += '&nbsp;'+ varScope;
			sHTML += '&nbsp;<a href="javascript:;" onclick="removeAuditor(\''+divIdName+'\',\''+fieldName+'\');">Remove</a>';
			newdiv.innerHTML = sHTML;
			anchorDiv.appendChild(newdiv);
				
			numOfAuditors++;
			count.value = numOfAuditors;
				
			//format if there are multiple values
			if(sFormattedString == ""){
				sFormattedString = varScope ;
			}else{
				sFormattedString = sFormattedString + "," + varScope ;
			}
		}
		bFlag = true;
	}
}


