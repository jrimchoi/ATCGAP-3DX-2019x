
<%@page import="com.dassault_systemes.enovia.dcl.DCLConstants"%>
<%@page import="com.matrixone.apps.framework.ui.UINavigatorUtil"%>
<%--  enoDCLCreateFormValidation.jsp

  Copyright (c) 1992-2017 Dassault Systemes.
  All Rights Reserved.
  This program contains proprietary and trade secret information of MatrixOne,
  Inc.  Copyright notice is precautionary only
  and does not evidence any actual or intended publication of such program

   static const char RCSID[] = "$Id: emxJSValidation.jsp.rca 1.1.5.4 Wed Oct 22 15:48:43 2008 przemek Experimental przemek $";
--%>
<%@include file = "../common/emxNavigatorInclude.inc"%>
<%
String strAlertMsg = EnoviaResourceBundle.getProperty(context, DCLConstants.DCL_STRING_RESOURCE, context.getLocale(), "enoDocumentControl.Alert.Msg.SelectOrganization");
String strAlertMsgInterval = EnoviaResourceBundle.getProperty(context, DCLConstants.DCL_STRING_RESOURCE, context.getLocale(), "enoDocumentControl.Alert.Msg.PeriodicReviewInterval");
String strSMEAlert = EnoviaResourceBundle.getProperty(context, DCLConstants.DCL_STRING_RESOURCE, context.getLocale(), "enoDocumentControl.Alert.Msg.SMESelect");
String strAlertImplDateInApprovedState = EnoviaResourceBundle.getProperty(context, DCLConstants.DCL_STRING_RESOURCE, context.getLocale(), "enoDocumentControl.Alert.ImplementationDateInApprovedState");
String strAlertImplDate = EnoviaResourceBundle.getProperty(context, DCLConstants.DCL_STRING_RESOURCE, context.getLocale(), "enoDocumentControl.Alert.SpecifyImplementationDate");
String strAlertDate = EnoviaResourceBundle.getProperty(context, DCLConstants.DCL_STRING_RESOURCE, context.getLocale(), "enoDocumentControl.Alert.ValidImplementationDate");
String strObjectId=XSSUtil.encodeForURL(context, emxGetParameter(request,"objectId"));
String strAlertPercentCompleteInterval = EnoviaResourceBundle.getProperty(context, DCLConstants.DCL_STRING_RESOURCE, context.getLocale(), "enoDocumentControl.Alert.Msg.PercentValue");
String strNotificationAlert = EnoviaResourceBundle.getProperty(context, "enoDocumentControlStringResource", context.getLocale(), "enoDocumentControl.Alert.Msg.NotANumber");
String strAlertForSpecialCharacters = EnoviaResourceBundle.getProperty(context, DCLConstants.DCL_STRING_RESOURCE, context.getLocale(), "enoDocumentControl.Alert.Msg.SpecialCharactersNotAllowed");
%>
<script type="text/javascript" src="../common/scripts/emxUIFormHandler.js"></script>
  	<script language=javascript>	
	function ReplaceAll(Source,stringToFind,stringToReplace)
	{
	  var temp = Source;
	  var index = temp.indexOf(stringToFind);
	  while(index != -1)
	  {
	   temp = temp.replace(stringToFind,stringToReplace);
	   index = temp.indexOf(stringToFind);
	  }
	  return temp;
	}
	function disableOrEnableFormFields()
	{
		var flag = getQueryVariable("flag");
		var showTrainingEnabledEditable = getQueryVariable("showTrainingEnabledEditable");
		var objForm = document.forms[0];
			if(flag == 'showSMEOnly')
		{
			emxFormDisableField("Description",false);
			document.editDataForm.ResponsibleOrganizationDisplay.disabled=true;
			document.editDataForm.btnResponsibleOrganization.disabled=true;
			emxFormDisableField("Title",false);
		}
		else
		{
			document.editDataForm.Description.disabled=false;
		document.editDataForm.ResponsibleOrganizationDisplay.disabled=false;
		document.editDataForm.btnResponsibleOrganization.disabled=false;
		}
		if(flag == 'editSME')
		{
			document.editDataForm.Description.disabled=true;
			document.editDataForm.Title.disabled=true;
			document.editDataForm.ResponsibleOrganizationDisplay.disabled=true;
			document.editDataForm.btnResponsibleOrganization.disabled=true;
		}
		if(showTrainingEnabledEditable == 'false')
			document.editDataForm.TrainingEnabled.disabled=true;
	}

	function getQueryVariable(variable)
	{
	       var query = window.location.search.substring(1);
	       var vars = query.split("&");
	       for (var i=0;i<vars.length;i++) {
	               var pair = vars[i].split("=");
	               if(pair[0] == variable){return pair[1];}
	       }
	       return(false);
	}
		
	function disablePeriodicReviewInterval()
	{
	  var objForm = document.forms[0];
	  var selectedType =null;
	  var fieldPeriodicRevInterval = objForm.elements["PeriodicReviewEnabled"].value;
	  var fieldRespOrg = objForm.elements["ResponsibleOrganizationDisplay"].value;
	  //selectedType = objForm.elements["TypeActualDisplay"].value;
	  var srr = document.getElementById('calc_Type');
	  srr = srr.nextSibling;
	  var selectedType1 = srr.children[0].innerHTML;
	  var index = selectedType1.indexOf("&nbsp;");
	  if(selectedType1.indexOf("&nbsp;") != -1)
	  {
	 	  selectedType1 = selectedType1.substring(0,index);
	  }
	  selectedType=ReplaceAll(selectedType1," ","");
	  if(fieldPeriodicRevInterval == 'No')
	  {
		document.getElementById("calc_SubjectMatterExpert").className = 'createLabel';
		document.getElementById("calc_SubjectMatterExpert").children[0].className = 'createLabel';
		document.editDataForm.PeriodicReviewEnabled.value=fieldPeriodicRevInterval;
		document.editDataForm.PeriodicReviewEnabledfieldValue.value=fieldPeriodicRevInterval;
		document.editDataForm.PeriodicReviewInterval.disabled=true;
		document.editDataForm.PeriodicReviewInterval.value="";
		document.editDataForm.PeriodicReviewIntervalfieldValue.value="";
	     	document.editDataForm.SubjectMatterExpertDisplay.disabled=true;
	     	document.editDataForm.SubjectMatterExpertDisplay.value="";
	     	document.editDataForm.SubjectMatterExpert.value="";
		document.editDataForm.SubjectMatterExpertOID.value="";
		document.editDataForm.btnSubjectMatterExpert.disabled=true;
	 }
	 else
	 {
		  document.getElementById("calc_SubjectMatterExpert").className = 'labelRequired';
		  document.editDataForm.PeriodicReviewEnabled.value=fieldPeriodicRevInterval;
		  document.editDataForm.PeriodicReviewEnabledfieldValue.value=fieldPeriodicRevInterval;
		  document.editDataForm.PeriodicReviewInterval.disabled=false;
	  	  document.editDataForm.SubjectMatterExpertDisplay.disabled=false;
	  	  document.editDataForm.btnSubjectMatterExpert.disabled=false;
		  fieldRespOrg = ReplaceAll(fieldRespOrg," ","");  
		  if(fieldRespOrg == "")
		  {
	/* XSSOK */	    var respOrgAlert = "<%=strAlertMsg %>";
		    alert(respOrgAlert); 
		    return false;
		  }
		  else
		  {
			  var propertKeyGen= fieldRespOrg+"."+"ReviewInterval";
			  var xmlhttp;
			  if (window.XMLHttpRequest)
			  {// code for IE7+, Firefox, Chrome, Opera, Safari
				  xmlhttp=new XMLHttpRequest();
			  }
			  else
			  {// code for IE6, IE5
				 xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
			  }
			  var URL = "../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:getPeriodicReviewInterval&propertyKey="+propertKeyGen+"&selectedType="+selectedType1;
			  var responseText = emxUICore.getDataPost(URL);
			  responseText = responseText.replace(/(^[\s]+|[\s]+$)/g, '');
			  document.editDataForm.PeriodicReviewInterval.value=responseText;
			  document.editDataForm.PeriodicReviewIntervalfieldValue.value=responseText;
		  }
	  }
	}
	function validateRangeofPeriodicInterval()
	{
	  var interval = document.editDataForm.PeriodicReviewInterval.value;
	  var fieldPeriodicRevInterval = document.editDataForm.PeriodicReviewEnabled.value;
	  var smeValue = document.editDataForm.SubjectMatterExpertDisplay.value;
	  if(fieldPeriodicRevInterval == "Yes")
	  {
		  if(fieldPeriodicRevInterval=="Yes" && smeValue == "")
		  {
	/* XSSOK */	   var SMEalert = "<%=strSMEAlert%>"
		   alert(SMEalert);
		   return false;
		  }
		  else if(interval<1 || interval>99)
		  {			  
	/* XSSOK */	   var alertMsg = "<%=strAlertMsgInterval%>";
		   alert(alertMsg);
		   return false;
		  }
		  else
		  {
		    return true;
		  }
	  }
	  else
	  {
	     return true;
	  }
	}
	function hideSMEAndIntervalFields()
	{
			//var periodicEnabled = document.editDataForm.PeriodicReviewEnabled.value;
		//var row5 = document.getElementById("calc_Script");
		//var row6 = row5.nextSibling;
	        //row6.style.display = "none";
		//if(periodicEnabled == "No")
		//{
			//document.editDataForm.PeriodicReviewInterval.disabled=true;
			//document.editDataForm.PeriodicReviewInterval.value="";
		  	//document.editDataForm.PeriodicReviewIntervalfieldValue.value="";
	     	//document.editDataForm.SubjectMatterExpertDisplay.disabled=true;
	     	//document.editDataForm.SubjectMatterExpertDisplay.value="";
	     	//document.editDataForm.SubjectMatterExpert.value="";
		  //	document.editDataForm.SubjectMatterExpertOID.value="";
		   // document.editDataForm.btnSubjectMatterExpert.disabled=true;
		//}
	}
	function updateTitleField()
	{
		var actualTitleField = document.editDataForm.Title.value;
		document.editDataForm.Title.value = actualTitleField;
		document.editDataForm.TitlefieldValue.value=actualTitleField;
	} 
	function updateDescriptionField()
	{
		var actualDescritptionField = document.editDataForm.Description.value;
		document.editDataForm.Description.value = actualDescritptionField;
		document.editDataForm.DescriptionfieldValue.value=actualDescritptionField;
	}
	function updatePeriodicIntervalFields()
	{
		var actualIntervalField = document.editDataForm.PeriodicReviewInterval.value;
		document.editDataForm.PeriodicReviewInterval.value = actualIntervalField;
	    document.editDataForm.PeriodicReviewIntervalfieldValue.value=actualIntervalField;
	}

	function changeTranferActionsData()
	{
		var URL = "";
		var objForm = document.forms[0];
		var selectedValue = objForm.elements["TransferAction"].value;
		var pathArray = "../common/emxForm.jsp?form=DCLTransferAssignment&mode=edit&suiteKey=DocumentControl&StringResourceFileId=enoDocumentControlStringResource&SuiteDirectory=documentcontrol&targetLocation=popup&postProcessURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:transferAssignments";
		var smeFormLink = "appendFields=DCLTransferAssignmentSME";
		var dcaFormLink = "appendFields=DCLTransferImplementingOrganizationRepresentative";
	
		if(selectedValue == "Subject Matter Expert")
		{
			URL = pathArray + "&" +smeFormLink;
		}
		if(selectedValue == "Implementing Organization Representative")
		{
			URL = pathArray + "&" +dcaFormLink;
		}
		getTopWindow().location.href = URL;
	}
	function enableOrDisableFields()
        {


 var vImplementationPeriodOption = document.getElementById("ImplementationPeriodOptionId").value;
if(vImplementationPeriodOption=="Specify Implementation Period")
{
		hideImplementationPeriodDate();
}
if(vImplementationPeriodOption=="Specify Implementation Date")
{

		hideImplementationPeriod()

}
	if(vImplementationPeriodOption=="Default Implementation Period")
{
	hideImplementationPeriodDate();
	hideImplementationPeriod();
}


         
        }

     function   hideImplementationPeriodDate()
        {
		var vImplementationDate = document.getElementById("calc_Implementation Date");
			vImplementationDate.style.display = 'none';
			var cal=document.getElementById("Implementation Date").parentElement.parentElement.parentElement.parentElement.parentElement.parentElement;

cal.style.display = 'none';
        }
      function  hideImplementationPeriod()
        {
		var vImplementationPeriod= document.getElementById("calc_Implementation Period");
           
	
		vImplementationPeriod.style.display = 'none';
         

document.getElementById('Implementation Period').style.display = 'none';


var cal1=document.getElementById("Implementation Period").parentElement.parentElement;
cal1.style.display = 'none';

        }
	function enableOrDisableEffectivityFields()
	{
	        var vImplementationPeriodOption = document.getElementById("ImplementationPeriodOptionId").value;
	        var vImplementationDate = document.getElementById("calc_Implementation Date");

  var vImplementationDateField = document.getElementById("Implementation Date").parentElement.parentElement.parentElement.parentElement.parentElement.parentElement;


	        var vImplementationPeriod= document.getElementById("calc_Implementation Period");
  var vImplementationPeriodField = document.getElementById("Implementation Period");

var cal1=document.getElementById("Implementation Period").parentElement.parentElement;
    
	        if(vImplementationPeriodOption=="Specify Implementation Period")
                {
			 	vImplementationDate.style.display = 'none';
				vImplementationPeriod.style.display = '';

vImplementationDateField.style.display = 'none';
				vImplementationPeriodField.style.display = '';
cal1.style.display = '';



                }
	        else if(vImplementationPeriodOption=="Specify Implementation Date")
                {             
	       	 	vImplementationDate.style.display = '';
vImplementationDateField.style.display = '';

	       		vImplementationPeriod.style.display = 'none';
vImplementationPeriodField.style.display = 'none';
cal1.style.display = 'none';

	       		vImplementationDate.className = 'labelRequired';
                }
	        else if(vImplementationPeriodOption=="Default Implementation Period")
                { 
	       		 vImplementationDate.style.display = 'none';
vImplementationDateField.style.display = 'none';
				vImplementationPeriod.style.display = 'none';
vImplementationPeriodField.style.display = 'none';
cal1.style.display = 'none';

                }
     }

	function validateImplementationDate()
	{
		var vFieldValue = document.getElementById("ImplementationPeriodOptionId").value;
		if(vFieldValue=="Specify Implementation Date")
		{
			var vImplementationDateValue = document.getElementById("Implementation Date").value;
			if(vImplementationDateValue=="")
			{				
			/* XSSOK */	 alert("<%=strAlertImplDate%>");
				 return false;
			}
			else
			{
				var vImplementationDate_msvalue = document.getElementsByName("Implementation Date_msvalue")[0];
	    		var vImplementationDate = new Date();
	    		vImplementationDate.setTime(vImplementationDate_msvalue.value);
	    		vImplementationDate.setHours(0,0,0,0); 
	    		var todayDate = new Date();
	    		todayDate.setHours(0,0,0,0); 
	    		if(parseInt(vImplementationDate.getTime())<parseInt(todayDate.getTime()))
	    		{	    			
	    		/* XSSOK */	alert("<%=strAlertDate%>");
	    			return false;
		    	}
			}
		}
		 return true;
	}
	function validateImplementationPeriodOption()
	{
		var vReasonForChangeValue = document.getElementById("calc_ReasonForChange");
		if(null!=vReasonForChangeValue && vReasonForChangeValue!="")
		{
			var vFieldValue = document.getElementById("ImplementationPeriodOptionId").value;
			if(vFieldValue!="Specify Implementation Date")
			{				
			/* XSSOK */	alert("<%=strAlertImplDateInApprovedState%>");
				return false;
			}
		}
		return true;
	}
	function validateCompleteImplementationDate()
	{
	     		var vDueDateValue = document.getElementById("ImplementationDate").value;
		    	var vDueDate_msvalue = document.getElementsByName("ImplementationDate_msvalue")[0];
	    		var vDueDate = new Date();
	    		vDueDate.setTime(vDueDate_msvalue.value);
	    		vDueDate.setHours(0,0,0,0); 
	    		var todayDate = new Date();
	    		todayDate.setHours(0,0,0,0); 
	    		if(vDueDateValue=="")
				{
					 return true;
				}
				else
				{
	    			if(parseInt(vDueDate.getTime())<parseInt(todayDate.getTime()))
	    			{	    				
	    			/* XSSOK */	alert("<%=strAlertDate%>");
	    				return false;
		    		}
		    	}
			
		 return true;
	}
	function validateEFormDueDate()
	{
		var vDueDateValue = document.getElementById("Due Date").value;
		var vDueDate_msvalue = document.getElementsByName("Due Date_msvalue")[0];
		var vDueDate = new Date();
		vDueDate.setTime(vDueDate_msvalue.value);
		vDueDate.setHours(0,0,0,0); 
		var todayDate = new Date();
		todayDate.setHours(0,0,0,0); 
		if(vDueDateValue=="")
		{
			 return true;
		}
		else
		{
			if(parseInt(vDueDate.getTime())<parseInt(todayDate.getTime()))
			{
			/* XSSOK */	alert("<%=strAlertDate%>");
				return false;
    		}
    	}
	
 return true;
	}
	function validatePercentCompleteValue()
	{
		var interval = document.getElementById("PercentComplete").value;
		  if(interval<0 || interval>=100)
		  {
			/* XSSOK */  alert("<%=strAlertPercentCompleteInterval%>");
			  return false;
		  }
		  else
		  {
		     return true;
		  }
	}
	

 function addFields()
		{
			var objForm = document.forms[0];
			var fieldPeriodicReviewDisposition = objForm.elements["PeriodicReviewDisposition"].value;
			if(fieldPeriodicReviewDisposition == null || fieldPeriodicReviewDisposition == "" || fieldPeriodicReviewDisposition == 'Keep Released')
			  {
		 		document.getElementById("CreateId").disabled = true;
			  }
			  
			if(fieldPeriodicReviewDisposition == 'Changes Required')
			  {
		    	document.getElementById("CreateId").disabled = false;
			  }
		}
	
	
	function removeFieldCreate()
	{
    	document.getElementById("CreateId").disabled = true;
	}
	
	function checkPassword()
	{
		var password = document.getElementById("Password_html").children[0].value;
		var sbURL= "../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLPeriodicReviewUI:periodicReviewDone&validatePassword=Yes&password="+password;
		var xmlResult = emxUICore.getXMLData(sbURL);
		var value = xmlResult.childNodes[0].children[0].textContent;
		if(value == 'false')
			{
			alert("Invalid Password");
			document.getElementById("Password_html").children[0].value = "";
			return false;
			}
		else{
			return true;
		}
	
	}
	
	function validateNameForSpecialCharacters()
	{
		
		var fieldName = findFrame(getTopWindow(),"slideInFrame").document.getElementById("Name").value;
		var iChars = "\"#$@%*,?\<>[]|:";
		for (var i = 0; i < fieldName.length; i++) {
    	if (iChars.indexOf(fieldName.charAt(i)) != -1) {
       		 alert ("<%=strAlertForSpecialCharacters%>");
        	return false;
    	}
		}
		return true;
    }
	</script>
	

