<%--
*!================================================================
 *  JavaScript Form Validaion
 *  PQCFormValidation.jsp
 *
 *  Copyright (c) 1992-2018 Dassault Systemes. All Rights Reserved.
 *  This program contains proprietary and trade secret information
 *  of MatrixOne,Inc. Copyright notice is precautionary only
 *  and does not evidence any actual or intended publication of such program
 *
 *=================================================================
 *
--%>

<jsp:include page="../LSACommonFramework/LSACommonFrameworkFormValidation.jsp" flush="true"/>
<%@page import="matrix.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.matrixone.apps.domain.util.*"%>
<%@page import="com.dassault_systemes.enovia.lsa.Helper,com.dassault_systemes.enovia.lsa.ticket.TicketException"%>
<%@page import ="com.matrixone.servlet.Framework,matrix.db.Context"%>

<%@include file = "../emxContentTypeInclude.inc"%>
<% matrix.db.Context context = Framework.getFrameContext(session); %>

<%!
private String getI18NString(Context context, String key) throws TicketException {
	try {
		return XSSUtil.encodeForJavaScript(context, Helper.getI18NString(context,Helper.StringResource.COLS, key));
	} catch (Exception e) {
		throw new TicketException(e);
	}
}
%>

<script type="text/javascript" src="../common/scripts/emxUIFormHandler.js"></script>

<script language="javascript">

//=================================================================
// Validation for various Complaints Forms and Fields
//=================================================================

//CREATED BY V8L - START

function validateReceivedProductSerialNumber() 
{
	var receivedProductSerialNumber = document.getElementById("ReceivedProductSerialNumber").value;
	var url = "../common/iwCSAjaxController.jsp?listProgramName=com.dassault_systemes.enovia.lsa.complaint.services.ui.ReturnFulfillment:validateReceivedProductSerialNumber";
	url += "&receivedProductSerialNumber"+"="+receivedProductSerialNumber;
	
	if (window.XMLHttpRequest) {
        request = new XMLHttpRequest();
    }
    else if (window.ActiveXObject) {
        request = new ActiveXObject("Microsoft.XMLHTTP");
    }

    request.open("GET", url, true);
    request.onreadystatechange = function () { validateReceivedProductSerialNumberCallback(request); }
    request.send(null);
}
function validateReceivedProductSerialNumberCallback(request) {
	var receivedProductSerialNumber = document.getElementById("ReceivedProductSerialNumber");
    if (request.readyState == 4) {
        if (request.status == 200) {
            // handle the response js object
            var jsObject = eval("(" + request.responseText + ")");//validateSerialNumber
            var result = jsObject.result;
            for (var i = 0; i < result.length; i++) {
                	   if(result[i].text.toLowerCase()=="no")
                	   	receivedProductSerialNumber.style.backgroundColor = "#FF3300";
                	   else
                		receivedProductSerialNumber.style.backgroundColor = "#99FF66";
                }
            }
        }

        request = null;
    }
//below is preprocess javascript on fulfillment
function getNewContactFieldsForReturnFulfillment() 
{
	getNewContactFields();
}
function getNewContactFields() 
{
	var vActualType = document.getElementsByName("TypeActual")[0].value;
	var vContactType = document.getElementById("calc_ContactType");
	var vCSalutation = document.getElementById("calc_CSalutation");
	var vCFName = document.getElementById("calc_CFName");
	var vCAddress1 = document.getElementById("calc_CAddress1");
	var vCState = document.getElementById("calc_CState");
	var vCCountry = document.getElementById("calc_CCountry");
	var vCEmail = document.getElementById("calc_CEmail");
	var vCHome = document.getElementById("calc_CHome");
	var vCBU = document.getElementById("calc_BusinessUnit");
	var vNewContactCreateCheck  = document.getElementById("NewContactCreateCheck");
	var vCustomerDetailDisplay = document.getElementsByName("ContactDisplay")[0];
	var vCustomerDetail = document.getElementsByName("Contact")[0];
	var vCustomerDetailExisting = document.getElementsByName("ContactOID")[0];
	var vBtnCustomerDetail = document.getElementsByName("btnContact")[0];
	var vContactName = document.getElementById("calc_Contact");
	document.getElementById("CSalutation").value="";
	document.getElementById("CFName").value=null;
	document.getElementById("CMName").value="";
	document.getElementById("CLName").value="";
	document.getElementById("CAddress1").value="";
	document.getElementById("CCountry").value="";
	document.getElementById("CHome").value="";
	document.getElementById("CWork").value="";
	document.getElementById("CEmail").value="";
	if(!(!(vNewContactCreateCheck.checked) && vNewContactCreateCheck.value=="Yes")){
		vCustomerDetailDisplay.disabled = true;
		vCustomerDetail.disabled = true;
		vCustomerDetailExisting.disabled = true;
		vBtnCustomerDetail.disabled = true;
		vContactType.style.visibility = "visible";
		vCSalutation.style.visibility = "visible";
		vCFName.style.visibility = "visible";
		vCAddress1.style.visibility = "visible";
		vCState.style.visibility = "visible";	
		vCCountry.style.visibility = "visible";
		vCEmail.style.visibility = "visible";	
		vCHome.style.visibility = "visible";
		vCBU.style.visibility = "visible";
		vCFName.children[0].className = 'labelRequired';
		vCFName.children[4].className = 'labelRequired';
		vCBU.children[0].className = 'labelRequired';
		vContactName.children[0].className = 'createLabel';
		
		if(vActualType == "Complaint"||vActualType == "Equipment Service Request"||vActualType == "Inquiry"){
			vContactType.value="Reporter";			
		}
		else if (vActualType == "Complaint Product Fulfillment"){
			vContactType.value="Customer";
		}
	}else{
		vCustomerDetailDisplay.disabled = false;
		vCustomerDetail.disabled = false;
		vCustomerDetailExisting.disabled = false;
		vBtnCustomerDetail.disabled = false;
		vContactType.style.visibility = "hidden";
		vCSalutation.style.visibility = "hidden";
		vCFName.style.visibility = "hidden";
		vCAddress1.style.visibility = "hidden";
		vCState.style.visibility = "hidden";
		vCCountry.style.visibility = "hidden";
		vCHome.style.visibility = "hidden";
		vCEmail.style.visibility = "hidden";
		vCBU.style.visibility = "hidden";
		vCFName.children[0].className = 'createLabel';
		vCFName.children[4].className = 'createLabel';
		vCBU.children[0].className = 'createLabel';
		vContactName.children[0].className = 'labelRequired';
	} 
}
function preProcessReturnEdit() 
{
	var returned = document.getElementById("ProductReturnedId").value;
	 if (returned.toLowerCase() == "yes") {
		document.getElementById("RMANumber").disabled = false;
	   	document.getElementById("NotReturnedRationaleId").value = "";
	   	document.getElementById("NotReturnedRationaleId").disabled = true;
	   	document.getElementsByName("ReceivedDate")[0].disabled = false;
		document.getElementsByName("ReceivedDate_date")[0].style.display = '';
	 } else if (returned.toLowerCase() == "no") {
	   	document.getElementById("RMANumber").disabled = true;
	   	document.getElementById("RMANumber").value = "";
	   	document.getElementById("NotReturnedRationaleId").disabled = false;
	   	document.getElementsByName("ReceivedDate")[0].disabled = true;
		document.getElementsByName("ReceivedDate_date")[0].style.display = 'none';
	 }
}
function validateProductReturnedForReturn() 
{
	 var returned = document.getElementById("ProductReturnedId").value;
	 if (returned.toLowerCase() == "yes") {
		if(document.getElementsByName("ReceivedDate")[0].value == "" || document.getElementsByName("ReceivedDate")[0].value == null){
			alert("Enter Date");
		}
	 }
}
function enableFieldForProductToBeReturned() 
{
	 var returned = document.getElementById("ProductReturnedId").value;
	 if (returned.toLowerCase() == "yes") {
	  	document.getElementById("RMANumber").disabled = false;
	   	document.getElementById("NotReturnedRationaleId").value = "";
	   	document.getElementById("NotReturnedRationaleId").disabled = true;
	   	document.getElementsByName("ReceivedDate")[0].disabled = false;
		document.getElementsByName("ReceivedDate_date")[0].style.display = '';
	 } else if (returned.toLowerCase() == "no") {
	   	document.getElementById("RMANumber").disabled = true;
	   	document.getElementById("RMANumber").value = "";
	   	document.getElementById("NotReturnedRationaleId").disabled = false;
	   	document.getElementsByName("ReceivedDate")[0].disabled = true;
		document.getElementsByName("ReceivedDate_date")[0].style.display = 'none';
	 }else{
	   	document.getElementById("RMANumber").disabled = true;
	   	document.getElementById("NotReturnedRationaleId").disabled = true;
	   	document.getElementsByName("ReceivedDate")[0].disabled = true;
		document.getElementsByName("ReceivedDate_date")[0].style.display = 'none';
	 }
}
function validateRMANumberForReturnCreate()
{
	var returned = document.getElementById("ProductReturnedId").value;
    var formFieldRMANumber = document.getElementById("RMANumber").value;
    if (returned.toLowerCase() == "-") {
    	 alert("<%=getI18NString(context,"PQC.ReturnFulfillment.ProductReturned.ErrorMessage")%>"); //XSSOK
    	return false;
    }
    if (returned.toLowerCase() == "yes") {
	    if (formFieldRMANumber == null || formFieldRMANumber == "") {
	    	 alert("<%=getI18NString(context,"PQC.ReturnFulfillment.RMANumer.ErrorMessage")%>"); //XSSOK
	        return false;
	   	}
    }
    return true;
}
function validateDispositionForReturn()
{
	var returned = document.getElementById("ProductReturnedId").value;
    var disposition = document.getElementById("DispositionId").value;
    if (returned.toLowerCase() == "-") {
    	 alert("<%=getI18NString(context,"PQC.ReturnFulfillment.ProductReturned.ErrorMessage")%>"); //XSSOK
    	return false;
    }
    if (returned.toLowerCase() == "yes") {
    	if (disposition == null || disposition == "") {
	    	 alert("<%=getI18NString(context,"PQC.ReturnFulfillment.Disposition.ErrorMessage")%>"); //XSSOK
	    	 return false;
    	}
    }
    if (returned.toLowerCase() == "no") {
	    if (disposition == null || disposition == "") {
	    	 alert("<%=getI18NString(context,"PQC.ReturnFulfillment.Disposition.ErrorMessage")%>"); //XSSOK
	        return false;
	   	}
    }
    return true;
}
function validateNotReturnedRationaleIdForReturnCreate()
{
	var returned = document.getElementById("ProductReturnedId").value;
    var formFieldNotReturnedRationaleId = document.getElementById("NotReturnedRationaleId").value;
    if (returned.toLowerCase() == "-") {
    	 alert("<%=getI18NString(context,"PQC.ReturnFulfillment.ProductReturned.ErrorMessage")%>"); //XSSOK
    	return false;
    }
    if (returned.toLowerCase() == "no") {
	    if (formFieldNotReturnedRationaleId == null || formFieldNotReturnedRationaleId == "") {
	    	alert("<%=getI18NString(context,"PQC.ReturnFulfillment.ReturnDisposition.ErrorMessage")%>"); //XSSOK
	        return false;
	   	}
   	}
    return true;
}
function validateFulfillmentAmountForFulfillment()
{
	var formFieldFulfillmentType = document.getElementById("FulfillmentTypeId").value;
	var formFieldFulfillmentAmount = document.getElementById("FulfillmentAmount").value;
	if (formFieldFulfillmentType.toLowerCase() == "cheque" || formFieldFulfillmentType.toLowerCase() == "credit") {
		if (formFieldFulfillmentAmount == null || formFieldFulfillmentAmount == "") {
			alert("<%=getI18NString(context,"PQC.ReturnFulfillment.Amount.ErrorMessage")%>"); //XSSOK
			return false;
		}
	}
	return true;
}
function validateNotEvaluatedJustificationForReturnEdit()
{
	var formFieldDispositionId = document.getElementById("DispositionId").value;
	var formFieldNotEvaluatedJustification = document.getElementById("NotEvaluatedJustification").value;
	if (formFieldDispositionId.toLowerCase() == "returned but not evaluated") {
		if (formFieldNotEvaluatedJustification == null || formFieldNotEvaluatedJustification == "") {
			alert("<%=getI18NString(context,"PQC.ReturnFulfillment.NotEvaluatedJustification.ErrorMessage")%>"); //XSSOK
			return false;
		}
	}
	return true;
}
function validateFormPQCContactCreateFieldNewCustomerName()
{
	var vNewContactCreateCheck  = document.getElementById("NewContactCreateCheck");
	var vNewCustomerName = document.getElementById("NewCustomerName").value;
	if(vNewContactCreateCheck.checked && vNewContactCreateCheck.value=="Yes"){
		if (vNewCustomerName == null || vNewCustomerName == "") {
			alert("<%=getI18NString(context,"PQC.ReturnFulfillment.CustomerName.ErrorMessage")%>"); //XSSOK
			return false;
		}
	}
    return true;
}
function validateFormPQCContactCreateFieldCFName()
{
	var vNewContactCreateCheck  = document.getElementById("NewContactCreateCheck");
	var vCFName = document.getElementById("CFName").value;
	if(vNewContactCreateCheck.checked && vNewContactCreateCheck.value=="Yes"){
		if (vCFName == null || vCFName == "") {
			alert("<%=getI18NString(context,"PQC.ReturnFulfillment.FirstName.ErrorMessage")%>"); //XSSOK
			return false;
		}
	}
    return true;
}
function validateFormPQCContactCreateFieldCLName()
{
	var vNewContactCreateCheck  = document.getElementById("NewContactCreateCheck");
	var vCLName = document.getElementById("CLName").value;
	if(vNewContactCreateCheck.checked && vNewContactCreateCheck.value=="Yes"){
		if (vCLName == null || vCLName == "") {
			alert("<%=getI18NString(context,"PQC.ReturnFulfillment.LastName.ErrorMessage")%>"); //XSSOK
			return false;
		}
	}
    return true;
}
function validateFormPQCContactCreateFieldBusinessUnit()
{
	var vNewContactCreateCheck  = document.getElementById("NewContactCreateCheck");
	var vBusinessUnit = document.getElementById("BusinessUnit").value;
	if(vNewContactCreateCheck.checked && vNewContactCreateCheck.value=="Yes"){
		if (vBusinessUnit == null || vBusinessUnit == "") {
			alert("<%=getI18NString(context,"PQC.ReturnFulfillment.BusinessUnit.ErrorMessage")%>"); //XSSOK
			return false;
		}
	}
    return true;
}
function validateReceivedDate()
{
    // If the user didn't change the field, do not execute this check.  
    // This will help with dates selected in differing timezones.
    var returned = document.getElementById("ProductReturnedId").value;
	 if (returned.toLowerCase() == "yes") {
	    if(document.getElementsByName("ReceivedDate")[0].value == "" || document.getElementsByName("ReceivedDate")[0].value == null){
				alert("<%=getI18NString(context,"PQC.ReturnFulfillment.ReceivedDateIfNotEntered.ErrorMessage")%>"); //XSSOK
				return false;
			}
	    
	    if (this.value != null && this.value != "") {
	     var formFieldDateMS = document.getElementsByName(this.name + "_msvalue")[0].value;
	        // remove 12 hrs before testing the date chosen to account for Matrix setting
	        // the time to 12:00 noon from the date picker
	        var formFieldDateMS_num = formFieldDateMS - 43200000;
	
	        var formDate = new Date(formFieldDateMS_num);
	        formDate.setHours(0);
	        formDate.setMinutes(0);
	        formDate.setSeconds(0);
	        formDate.setMilliseconds(0);
	
	        var now = new Date();
	        now.setHours(0);
	        now.setMinutes(0);
	        now.setSeconds(0);
	        now.setMilliseconds(0);
	
	        var msForm = formDate.valueOf();
	        var msNow = now.valueOf();
	        if(msForm > msNow)
	        {
	        	alert("<%=getI18NString(context,"FTComplaints.Common.DateCannotBeGreaterThanToday")%>"); //XSSOK
	            return false;
	        }
	    }	
    }

    return true;
}
//CREATED BY V8L - END

function validateFutureCompletionDate()
{
    // If the user didn't change the field, do not execute this check.  
    // This will help with dates selected in differing timezones.
    if (!dateFieldChanged(this)){
        return true;
    }
    
    if (this.value != null && this.value != "") {
     var formFieldDateMS = document.getElementsByName(this.name + "_msvalue")[0].value;
        // remove 12 hrs before testing the date chosen to account for Matrix setting
        // the time to 12:00 noon from the date picker
        var formFieldDateMS_num = formFieldDateMS - 43200000;

        var formDate = new Date(formFieldDateMS_num);
        formDate.setHours(0);
        formDate.setMinutes(0);
        formDate.setSeconds(0);
        formDate.setMilliseconds(0);

        var now = new Date();
        now.setHours(0);
        now.setMinutes(0);
        now.setSeconds(0);
        now.setMilliseconds(0);

        var msForm = formDate.valueOf();
        var msNow = now.valueOf();
        if(msForm > msNow)
        {
        	alert("<%=getI18NString(context,"FTComplaints.Common.DateCannotBeGreaterThanToday")%>"); //XSSOK
            return false;
        }
    }

    return true;
}

var dateFieldsInitialValue = new Array(); // Global array containing date form date fields w/initial values

// Walk the DOM and indentify the date fields. Set the 'dateFieldsInitialValue' array.
emxUICore.addEventHandler(window, "load",function() {
    var inputTags = document.getElementsByTagName("input");
    var dateFieldsCounter = 0;
    for(i=0; i<inputTags.length; i++){
        var inputTag = inputTags[i];
        if(endsWith(inputTag.name,"_msvalue")){
            dateFieldsInitialValue[dateFieldsCounter++]= inputTag.name+"|"+inputTag.value;
        }
    }
});

// Compare the initial value with the current value to detect a difference.
function dateFieldChanged(ele){
    var flag = false;
    for(i=0; i<dateFieldsInitialValue.length; i++){
        if(startsWith(dateFieldsInitialValue[i], ele.name)){
            var eleMSValue = document.getElementsByName(ele.name+"_msvalue");
            //alert(eleMSValue);
            // If the initial value and the current value are different, then the user changed the field.
            if(!endsWith(dateFieldsInitialValue[i],eleMSValue[0].value)){
                flag = true;
            }
            break;
        }
    }
    return flag;
}

function startsWith(str, prefix) {
    return str.slice(0, prefix.length) == prefix;
}

function endsWith(str, suffix) {
    return str.indexOf(suffix, str.length - suffix.length) !== -1;
}
//added by v8l for edit page fututre date validation
function validateFutureCompletionDateEdit()
{
    if (this.value != null && this.value != "") {
        var formFieldDateMS = document.getElementsByName(this.name + "_msvalue")[0].value;
           // remove 12 hrs before testing the date chosen to account for Matrix setting
           // the time to 12:00 noon from the date picker
           var formFieldDateMS_num = formFieldDateMS - 43200000;

           var formDate = new Date(formFieldDateMS_num);
           formDate.setHours(0);
           formDate.setMinutes(0);
           formDate.setSeconds(0);
           formDate.setMilliseconds(0);

           var now = new Date();
           now.setHours(0);
           now.setMinutes(0);
           now.setSeconds(0);
           now.setMilliseconds(0);

           var msForm = formDate.valueOf();
           var msNow = now.valueOf();
           if(msForm > msNow)
           {
        	   alert("<%=getI18NString(context,"FTComplaints.Common.DateCannotBeGreaterThanToday")%>"); //XSSOK
               return false;
           }
       }

       return true;
}


function validateInvestigationDetails()
{
    var vInvMethodsValue = document.getElementsByName("Complaint Investigation MethodsDisplay")[0].value;
    var vResultCodesValue = document.getElementsByName("Results CodeDisplay")[0].value;
    var vConclusionCodesValue = document.getElementsByName("Conclusion CodeDisplay")[0].value;

        if(vInvMethodsValue=="")
        	{
        	 alert("<%=getI18NString(context,"PQC.Complaint.Investigation.ComplaintInvestigationMethodRequired")%>"); //XSSOK
			 	return false;
        	}
        if(vResultCodesValue=="")
    		{
        	 alert("<%=getI18NString(context,"PQC.Complaint.Investigation.ComplaintInvestigationResultCodeRequired")%>"); //XSSOK
		 		return false;
    		}
        if(vConclusionCodesValue=="")
			{
        	 alert("<%=getI18NString(context,"PQC.Complaint.Investigation.ComplaintInvestigationConclusionCodeRequired")%>"); //XSSOK
	 			return false;
			}
    return true;
}

function validateRiskAnalysisDetails()
{
    var vRiskAnalysisRequiredValue = document.getElementById("Complaint Risk Analysis RequiredId").value;

    	if (vRiskAnalysisRequiredValue.toLowerCase() == "no") {
    		var vComments = document.getElementById("Comments").value;
			if(vComments=="")
				{
					alert("<%=getI18NString(context,"PQC.Complaint.Investigation.RiskAnalysisNotRequiredRationaleRequiredForNoRiskAnalysis")%>"); //XSSOK
					return false;
				}
    	} 
    return true;
}

function getCommentsField()
{
	var vRiskAnalysisRequiredValue = document.getElementById("Complaint Risk Analysis RequiredId").value;
	var vComments = document.getElementById("calc_Comments");
	if (vRiskAnalysisRequiredValue.toLowerCase() == "no") {
		vComments.children[0].className = 'labelRequired';
	}
	else{
		vComments.children[0].className = 'createLabel';
	}
			
}

function validateFormCreateComplaintFieldComplaintSource()
{
	var vComplaintSource  = document.getElementById("ComplaintSourceId").value;
	if (vComplaintSource == null || vComplaintSource == " ") {
			alert("<%=getI18NString(context,"PQC.Complaint.ComplaintSource.EmptyError")%>"); //XSSOK
			return false;
		}	
    return true;
}

/**
 * Function for validating form fields for ComplaintProperties
 */
function validateComplaintProperties(){
	var Flag = querystring('flag')[0];
	var arrFlag=Flag.split(",");
	var isOwner		   = arrFlag[0];
	var isOriginator   = arrFlag[1];
	var hasQMRole	   = arrFlag[2];
	var hasCIRole	   = arrFlag[3];
	var complaintState = arrFlag[4];
	var fieldArray = ["AwarenessDate","DistributorAwarenessDate","Source","Severity","CountryOfOrigin","Comments","PurchaseOrderName","ComplaintHandlingUnit","CustomerClosureDate"];
	setFormFieldEditAccess(fieldArray, false);
	if((isOriginator=="TRUE"||hasQMRole=="TRUE")&&(complaintState=="Create"||complaintState=="InProcess")){
		setFormFieldEditAccess([fieldArray[0],fieldArray[2],fieldArray[3],fieldArray[7]], true);
	}
	if(((isOwner=="TRUE"||hasQMRole=="TRUE")&&(complaintState=="Create"||complaintState=="InProcess"))||(hasCIRole=="TRUE"&&complaintState=="InProcess")){
		setFormFieldEditAccess([fieldArray[1],fieldArray[4],fieldArray[5],fieldArray[6]], true);
	}
	if(((isOwner=="TRUE"||hasQMRole=="TRUE")&&complaintState=="Create")||(isOwner=="TRUE"&&complaintState=="InProcess")){
		setFormFieldEditAccess([fieldArray[8]], true);
	}
}

function setFormFieldEditAccess(fieldArray, disable){
	for(var i = 0; i < fieldArray.length; i++){
//Comment to be removed
		emxFormDisableField(fieldArray[i],disable);
	}
}

function enableFormFields(){
	var fieldArray = ["AwarenessDate","DistributorAwarenessDate","Source","Severity","CountryOfOrigin","Comments","PurchaseOrderName","ComplaintHandlingUnit","CustomerClosureDate"];
	setFormFieldEditAccess(fieldArray, true);
	return true;
}
	/**
     * Function for fetching values for a key in the document URL
     */
	function querystring(key) {
		var re=new RegExp('(?:\\?|&)'+key+'=(.*?)(?=&|$)','gi');
		var r=[], m;
		while ((m=re.exec(document.location.search)) != null) r.push(m[1]);
		return r;
	}
	function validateFormPQCContactCreateFieldContactName()
	{
			var vNewContactCreateCheck  = document.getElementsByName("NewContactCreateCheck");
			var vCustomerDetailDisplay = document.getElementsByName("ContactDisplay")[0].value;
			
			if(((vNewContactCreateCheck[1].checked) && vNewContactCreateCheck[1].value=="No") || ((vNewContactCreateCheck[0].checked) && vNewContactCreateCheck[0].value=="No")){
				if (vCustomerDetailDisplay == null || vCustomerDetailDisplay == "") {
					alert("<%=getI18NString(context,"PQC.Complaint.ContactRequired.ErrorMessage")%>"); //XSSOK
					return false;
				}
			}
		    return true;
	}
	function setModelNumberAsPerModel()
	{
		emxFormReloadField("ModelNumber");
		var vModelNumber = document.getElementById("ModelNumber");
		vModelNumber.disabled=true;
	}
	
	
	function validateDateEdit()
	{
	   	    if (this.value != null && this.value != "") {
	        var formFieldDateMS = document.getElementsByName(this.name + "_msvalue")[0].value;
	        var DateSentToDecontamination =document.getElementById("Complaint Equipment Date Sent For Decontamination").value;
	        var DateReceivedForDecontamination =document.getElementById("Complaint Equipment Date Received For Decontamination").value;
	        var DateSentFromDecontamination =document.getElementById("Complaint Equipment Date Sent From Decontamination").value;
	        var DateReceivedFromDecontamination =document.getElementById("Complaint Equipment Date Received From Decontamination").value;	  
            var sentDate = new Date(DateSentToDecontamination);
	        var receivedDate = new Date(DateReceivedForDecontamination);
	        var sentDateFromDecontamination = new Date(DateSentFromDecontamination);
	        var receivedDateFromDecontamination = new Date(DateReceivedFromDecontamination);
	        
	        if(sentDate>receivedDate){
	        	 alert("<%=getI18NString(context,"FTComplaints.Equipment.ReceivedDateCannotBeGreaterThanSentDate")%>"); //XSSOK
	        	 return false;
	        }
	        if(sentDateFromDecontamination>receivedDateFromDecontamination){
	        	 alert("<%=getI18NString(context,"FTComplaints.Equipment.ReceivedDateCannotBeGreaterThanSentDate")%>"); //XSSOK
	        	 return false;
	        }

	           // remove 12 hrs before testing the date chosen to account for Matrix setting
	           // the time to 12:00 noon from the date picker
	           var formFieldDateMS_num = formFieldDateMS - 43200000;

	           var formDate = new Date(formFieldDateMS_num);
	           formDate.setHours(0);
	           formDate.setMinutes(0);
	           formDate.setSeconds(0);
	           formDate.setMilliseconds(0);

	           var now = new Date();
	           now.setHours(0);
	           now.setMinutes(0);
	           now.setSeconds(0);
	           now.setMilliseconds(0);

	           var msForm = formDate.valueOf();
	           var msNow = now.valueOf();
	           if(msForm > msNow)
	           {
	        	   alert("<%=getI18NString(context,"FTComplaints.Common.DateCannotBeGreaterThanToday")%>"); //XSSOK
	               return false;
	           }
	       }

	       return true;
	}
	
	function reloadFormComplaintEventCloumnProductModel()
	{
		emxFormReloadField("ReleasedProduct");
	}
</script>




