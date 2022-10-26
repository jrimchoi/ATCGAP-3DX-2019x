
<%@page import="com.dassault_systemes.enovia.dcl.DCLConstants"%>
<%--  enoDCLCreateFormValidation.jsp

  Copyright (c) 1992-2017 Dassault Systemes.
  All Rights Reserved.
  This program contains proprietary and trade secret information of MatrixOne,
  Inc.  Copyright notice is precautionary only
  and does not evidence any actual or intended publication of such program

   static const char RCSID[] = "$Id: emxJSValidation.jsp.rca 1.1.5.4 Wed Oct 22 15:48:43 2008 przemek Experimental przemek $";
--%>
<%@include file = "../common/emxNavigatorInclude.inc"%>
<%-- <jsp:include page="../documentcommon/enoDocumentCommonCreateFormValidation.jsp" flush="true"/>--%>
<%
out.clear();
response.setContentType("text/javascript; charset=" + response.getCharacterEncoding());
String strLanguage = request.getHeader("Accept-Language");
String strAlertMsg = EnoviaResourceBundle.getProperty(context, DCLConstants.DCL_STRING_RESOURCE, context.getLocale(), "enoDocumentControl.Alert.Msg.SelectOrganization");
String strAlertMsgInterval = EnoviaResourceBundle.getProperty(context, DCLConstants.DCL_STRING_RESOURCE, context.getLocale(), "enoDocumentControl.Alert.Msg.PeriodicReviewInterval");
String strSMEAlert = EnoviaResourceBundle.getProperty(context, DCLConstants.DCL_STRING_RESOURCE, context.getLocale(), "enoDocumentControl.Alert.Msg.SMESelect");
String strAlertDate = EnoviaResourceBundle.getProperty(context, DCLConstants.DCL_STRING_RESOURCE, context.getLocale(), "enoDocumentControl.Alert.ValidImplementationDate");
String strAlertPercentCompleteInterval = EnoviaResourceBundle.getProperty(context, DCLConstants.DCL_STRING_RESOURCE, context.getLocale(), "enoDocumentControl.Alert.Msg.PercentValueValidation");
String strAlertPercentComplete = EnoviaResourceBundle.getProperty(context, DCLConstants.DCL_STRING_RESOURCE, context.getLocale(), "enoDocumentControl.Alert.Msg.PercentValue");
String strNotificationAlert = EnoviaResourceBundle.getProperty(context, "enoDocumentControlStringResource", context.getLocale(), "enoDocumentControl.Alert.Msg.NotANumber");
String strAlerMsgForValidNumber = EnoviaResourceBundle.getProperty(context, DCLConstants.DCL_STRING_RESOURCE, context.getLocale(), "enoDocumentControl.Alert.Msg.ValidNumber");
String strAlerMsgForValidDate = EnoviaResourceBundle.getProperty(context, DCLConstants.DCL_STRING_RESOURCE, context.getLocale(), "enoDocumentControl.Alert.Msg.ValidDate");

String strActionMode=DCLConstants.ACTION_MODE;
String strParentOID=DCLConstants.PARENT_OID;
String strRangeYes = EnoviaResourceBundle.getProperty(context, "enoDocumentControlStringResource", context.getLocale(), "enoDocumentControl.Range.Yes");
String strRangeNo = EnoviaResourceBundle.getProperty(context, "enoDocumentControlStringResource", context.getLocale(), "enoDocumentControl.Range.No");
%>
  
	function getCreateDocumentTemplateURL(valueForType)
	{
		    var typeName="";
		    var typeValue="";
      		    var objForm = document.forms[0];
		    var selectedType =null;
		    selectedType = valueForType;
		    selectedType = ReplaceAll(selectedType," ","");
                    var getTypeURL = "../documentcommon/enoDCExecute.jsp?dcAction=ENODCDocument:getSelectedType&suiteKey=DocumentControl&selectedType="+selectedType;
		    var responseType = emxUICore.getDataPost(getTypeURL);
		    responseType = responseType.replace(/(^[\s]+|[\s]+$)/g, '');
		    var URL = "../common/emxCreate.jsp?type=type_"+selectedType+"&autoNameChecked=true&suiteKey=DocumentControl&SuiteDirectory=documentcontrol&header=enoDocumentControl.Command.CreateNewTemplate&mode=create&preProcessJavaScript=makeSMERequired&HelpMarker=emxhelprequirementcreate&postProcessURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLTemplateUI:createDocumentTemplatePostProcess";
			return URL;
	} 
	function showTemplate(field,value)
	{
			var URL = "";
			var objForm = document.forms[0];
			var typeActualValueFromGlobal = "";
	        var s = document.location.href;
			var objForm = document.forms[0];
			typeActualValueFromGlobal = objForm.elements["TypeActual"].value;
		URL = getCreateDocumentTemplateURL(typeActualValueFromGlobal);
	        URL = URL +"&submitAction=doNothing&DCMode=createdocumenttemplate&form=DCLCreateDocumentTemplate";
			getTopWindow().location.href = URL;
	}
	function contains(a, obj) 
	{
	    for (var i = 0; i < a.length; i++) 
		{
	        if (a[i] === obj) 
			{
	            return true;
	        }
	    }
	    return false;
	}
	function ReplaceAll(Source,stringToFind,stringToReplace)
	{
	  var temp = Source;
	  if(typeof(temp) == "string"){
	  var index = temp.indexOf(stringToFind);
	  while(index != -1)
	  {
	   temp = temp.replace(stringToFind,stringToReplace);
	   index = temp.indexOf(stringToFind);
	  }
	  }
	  return temp;
	}
	function disablePeriodicReviewInterval()
	{
		var objForm = document.forms[0];
	  	var selectedType =null;
		var fieldPeriodicRevInterval = objForm.elements["PeriodicReviewInterval"].value
		var fieldPeriodicRevEnabled = objForm.elements["PeriodicReviewEnabled"].value;
		var fieldRespOrg = objForm.elements["ResponsibleOrganizationDisplay"].value;
		var path = window.location.href
		var pathArray = path.split('&');
	  
		var templateId="";
		 
	  	if(!contains(pathArray,'DCMode=createdocumenttemplate')){
	  		//fix for IR-447454-3DEXPERIENCER2017x
	  		if(path.indexOf('selTemplateId') == -1) {
		 		templateId=document.getElementsByName("TemplateOID")[0].value;
	  		}
	  		else
	  		{
	  			var reg = new RegExp( '[?&]selTemplateId=([^&#]*)', 'i' );
	    		var string = reg.exec(path);
		 			templateId = string[1];
	  		}	
	  	}
	  
	  	if((objForm.TypeActual[0] != null))
	  	{
			selectedType = objForm.TypeActual[0].value;
	  	}
      	else
	 	{
			selectedType = objForm.TypeActual.value;
	  	}
	  	
		if(fieldPeriodicRevEnabled == 'No')
	  	{
	   		document.getElementById("calc_SubjectMatterExpert").className = 'createLabel';
	        document.getElementById("calc_SubjectMatterExpert").children[0].className = 'createLabel';
	        document.getElementById("calc_PeriodicReviewInterval").classList.remove("labelRequired");
	  		document.emxCreateForm.PeriodicReviewInterval.disabled=true;
	  		document.emxCreateForm.PeriodicReviewInterval.value="";
	  		document.emxCreateForm.SubjectMatterExpertDisplay.disabled=true;
         	document.emxCreateForm.SubjectMatterExpertDisplay.value="";
        	document.emxCreateForm.SubjectMatterExpert.value="";
	  		document.emxCreateForm.SubjectMatterExpertOID.value="";
            document.emxCreateForm.btnSubjectMatterExpert.disabled=true;
	  	}
		else
		{
	        document.getElementById("calc_SubjectMatterExpert").className = 'labelRequired';
		  	document.emxCreateForm.PeriodicReviewInterval.disabled=(!(templateId == ""));
	  	  	document.emxCreateForm.SubjectMatterExpertDisplay.disabled=false;
	  	  	document.emxCreateForm.btnSubjectMatterExpert.disabled=false;
		  	document.getElementById("calc_PeriodicReviewInterval").className = 'labelRequired';
		  
		   	if(fieldPeriodicRevInterval == "")
		  	{ 
		 		if(fieldRespOrg == "" && templateId != "")
		  		{
		  
		    		var respOrgAlert = "<%=strAlertMsg %>"; /* XSSOK */
		    		alert(respOrgAlert);
		    		return false;
		  		}
			  	else if(fieldRespOrg != "")
		  		{
		      		var propertKeyGen= ReplaceAll(fieldRespOrg," ","")+"."+"ReviewInterval";
			  		var URL = "../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:getPeriodicReviewInterval&propertyKey="+propertKeyGen+"&selectedType="+selectedType;
			  		var responseText = emxUICore.getDataPost(URL);
			  		responseText = responseText.replace(/(^[\s]+|[\s]+$)/g, '');
			  		document.emxCreateForm.PeriodicReviewInterval.value=responseText;
		 		}
	  		}
			if(fieldPeriodicRevInterval != "")
			{
				if(fieldRespOrg == "")
					document.emxCreateForm.PeriodicReviewInterval.value="";
				else
				{
					if(templateId == "")
					{
						var propertKeyGen= ReplaceAll(fieldRespOrg," ","")+"."+"ReviewInterval";
						var URL = "../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:getPeriodicReviewInterval&propertyKey="+propertKeyGen+"&selectedType="+selectedType;
						var responseText = emxUICore.getDataPost(URL);
						responseText = responseText.replace(/(^[\s]+|[\s]+$)/g, '');
						document.emxCreateForm.PeriodicReviewInterval.value=responseText;
					}
					else
					{
						var URL = "../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:getTemplaterespOrg&templateId="+templateId;
						var responseText = emxUICore.getDataPost(URL);
						responseText = responseText.replace(/(^[\s]+|[\s]+$)/g, '');
						if(responseText != fieldRespOrg)
						{
							var propertKeyGen= ReplaceAll(fieldRespOrg," ","")+"."+"ReviewInterval";
							var URL = "../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:getPeriodicReviewInterval&propertyKey="+propertKeyGen+"&selectedType="+selectedType;
							var responseText = emxUICore.getDataPost(URL);
							responseText = responseText.replace(/(^[\s]+|[\s]+$)/g, '');
							document.emxCreateForm.PeriodicReviewInterval.value=responseText;
						}
					}
				}
			}
		}
	}
	
	
	function validateRangeofPeriodicInterval()
	{
	
	  var interval = document.emxCreateForm.PeriodicReviewInterval.value;
	  var fieldPeriodicRevInterval = document.emxCreateForm.PeriodicReviewEnabled.value;
	  var smeValue = document.emxCreateForm.SubjectMatterExpertDisplay.value;
	  if(fieldPeriodicRevInterval == "Yes")
	  {
		if(isNaN(interval) || (interval<1 || interval>99))
	  	  {
	  	     var alertMsg = "<%=strAlertMsgInterval%>"; /* XSSOK */
	  	     alert(alertMsg);
	  	     return false;
	  	  }
		  else if(fieldPeriodicRevInterval == "Yes" && smeValue == "")
		  {
		   var SMEalert = "<%=strSMEAlert%>"; /* XSSOK */
		   alert(SMEalert);
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

	function hideSMEAndIntervalFields(objId,autoNaming)
	{

		var periodicEnabled = document.emxCreateForm.PeriodicReviewEnabled.value;
		var row5 = document.getElementById("calc_Script"); 
		row5.style.display = "none";
		if(periodicEnabled == "No")
		{
			document.emxCreateForm.PeriodicReviewInterval.value="";
			document.emxCreateForm.PeriodicReviewInterval.disabled=true;
			document.emxCreateForm.SubjectMatterExpertDisplay.disabled=true;
	     	document.emxCreateForm.SubjectMatterExpertDisplay.value="";
	     	document.emxCreateForm.SubjectMatterExpert.value="";
	     	document.emxCreateForm.SubjectMatterExpertOID.value="";
		  	document.emxCreateForm.btnSubjectMatterExpert.disabled=true;
		}
		else
		{
			var URL = "../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:getSubjectMatterExpertOfTemplate&selTemplateId="+objId;
			var responseText = emxUICore.getDataPost(URL);
			responseText=responseText.trim();
			var arrResp=responseText.split("|");
			
			document.emxCreateForm.SubjectMatterExpertDisplay.value=arrResp[0];
			document.emxCreateForm.SubjectMatterExpert.value=arrResp[0];
	     	document.emxCreateForm.SubjectMatterExpertOID.value=arrResp[1];
		}
		if(autoNaming=='Mandatory')
		{
			var vName = document.getElementById("calc_Name");
			     vName.style.display = 'none';
		}
		else
		{
			var vName1 = document.getElementById("calc_Name");
		     vName1.style.display = '';
		}
		
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
	    			
	    				alert("<%=strAlertDate%>"); /* XSSOK */
	    				return false;
		    		}
		    	}
			
		 return true;
	}
	function validateEFormTableDueDate()
	{
		var vDueDate_msvalue = arguments[0];
	    var currentCell = emxEditableTable.getCurrentCell();
        var rowId = currentCell.rowID;
        var vDueDateCell = emxEditableTable.getCellValueByRowId(rowId,"DueDate");
		var vDueDateValue = vDueDateCell.value.current.actual;
		var vDueDate = new Date();
	    vDueDate.setTime(vDueDate_msvalue);
	    		
	    vDueDate.setHours(0,0,0,0); 
	    var todayDate = new Date();
	    todayDate.setHours(0,0,0,0); 
	    if(vDueDate=="")
		{
			 return true;
		}
		else
		{
   			if(parseInt(vDueDate.getTime()) < parseInt(todayDate.getTime()))
   			{
   			
   				alert("<%=strAlertDate%>"); /* XSSOK */
   				return false;
    		}
    	}
	 return true;
	}
	 function disableActionTaskNoOfDays(objectId)
	 {
	
		var startValue=document.getElementsByName(objectId+'StartValue')[0].value;
		var noOfDays=document.getElementsByName(objectId+'Days')[0];
	
		if(startValue!='Asssignee Set Due Date')
		{
			
			noOfDays.disabled=false;
		}
		else
		{
			noOfDays.disabled=true;
		}
	 }
	 function getURLParameter(name) {
  return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null
}
	 function makeSMERequired()
	{
		getTemplateScript();
		 var objForm = document.forms[0];
		var fieldPeriodicRevInterval = objForm.elements["PeriodicReviewEnabled"].value;
		if(fieldPeriodicRevInterval == 'No')
		  {
		document.getElementById("calc_SubjectMatterExpert").className = 'createLabel';
	    document.getElementById("calc_SubjectMatterExpert").children[0].className = 'createLabel';
	    document.getElementById("calc_PeriodicReviewInterval").classList.remove("labelRequired");
	    
		  }
		else
			{
			document.getElementById("calc_SubjectMatterExpert").className = 'labelRequired';
			  document.getElementById("calc_PeriodicReviewInterval").className = 'labelRequired';
			}
		var reloadKey = getURLParameter("reloadKey");
	
		if(reloadKey=='Yes')
		{
		var templateId = getURLParameter("templateId");
		var templateName = getURLParameter("templateName");
		document.emxCreateForm.TemplateDisplay.value=templateName;
		document.emxCreateForm.TemplateOID.value=templateId;
		document.emxCreateForm.Template.value=templateId;
		}
		
	}
		function validatePercentCompleteValueOnTable()
	{
		var vPercentComplete_msvalue = arguments[0];
		  if(isNaN(vPercentComplete_msvalue) || (vPercentComplete_msvalue<0 || vPercentComplete_msvalue>100))
		  {
			  alert("<%=strAlertPercentCompleteInterval%>"); /* XSSOK */
			  return false;
		  }
		  else
		  {
		     return true;
		  }
	}
	function validatePercentCompleteValueOnTrainingDocumentTable()
	{
		var vPercentComplete_msvalue = arguments[0];
		  if(isNaN(vPercentComplete_msvalue) || (vPercentComplete_msvalue<0 || vPercentComplete_msvalue>=100))
		  {
			  alert("<%=strAlertPercentComplete%>"); /* XSSOK */
			  return false;
		  }
		  else
		  {
		     return true;
		  }
	}
	
	function disableImplementationNotificationsThreshold(val)
	{
		var element = document.getElementById(val);
		var strValue = element.options[element.selectedIndex].text;
		var thresholdID = ReplaceAll(val,"EN","TH");
		if(strValue === "No")
				{
					document.getElementById(thresholdID).value = "";
					document.getElementById(thresholdID).disabled = true;
				}
				else{
					document.getElementById(thresholdID).disabled = false;
				}
	}
	
	function validateThresholdValue(val)
	{
		var bool = true;
		var nan = document.getElementById(val).value;
			if(isNaN(nan) || nan === ""){
					var alertMsg = "<%=strNotificationAlert%>";
					alert(alertMsg);
					bool = false;
					return bool;
				}
		return bool;
	}

	function updatePRI(bAlert)
	{
	  var objForm = document.forms[0];
	  var selectedType =null;
	  var fieldPeriodicRevInterval = objForm.elements["PeriodicReviewEnabled"].value;
	  var fieldRespOrg = objForm.elements["ResponsibleOrganizationDisplay"].value;
	  var fieldTemplate = objForm.elements["ResponsibleOrganizationDisplay"].value;
	  
	  if((objForm.TypeActual[0] != null))
	  {
		    	selectedType = objForm.TypeActual[0].value;
	  }
      else
	  {
		selectedType = objForm.TypeActual.value;
	  }
	  if(fieldPeriodicRevInterval == 'No')
	  {
	  	
	  	document.getElementById("calc_SubjectMatterExpert").className = 'createLabel';
	    document.getElementById("calc_SubjectMatterExpert").children[0].className = 'createLabel';
	    document.getElementById("calc_PeriodicReviewInterval").classList.remove("labelRequired");
	    
	  	document.emxCreateForm.PeriodicReviewInterval.disabled=true;
	  	document.emxCreateForm.PeriodicReviewInterval.value="";
	  	document.emxCreateForm.SubjectMatterExpertDisplay.disabled=true;
                document.emxCreateForm.SubjectMatterExpertDisplay.value="";
                document.emxCreateForm.SubjectMatterExpert.value="";
	  	document.emxCreateForm.SubjectMatterExpertOID.value="";
                document.emxCreateForm.btnSubjectMatterExpert.disabled=true;
	  	
	  }
	  else
	  {
	          document.getElementById("calc_SubjectMatterExpert").className = 'labelRequired';
	          document.getElementById("calc_PeriodicReviewInterval").className = 'labelRequired';
	  	  document.emxCreateForm.PeriodicReviewInterval.disabled=false;
		  fieldRespOrg = ReplaceAll(fieldRespOrg," ","");  
		  document.emxCreateForm.PeriodicReviewInterval.disabled=false;
	  	  document.emxCreateForm.SubjectMatterExpertDisplay.disabled=false;
	  	  document.emxCreateForm.btnSubjectMatterExpert.disabled=false;
		  if(fieldRespOrg == "" && fieldTemplate != "")
		  {
		    var respOrgAlert = "<%=strAlertMsg%>"; /* XSSOK */
		    if(bAlert)
		    {
		    	alert(respOrgAlert);
		    }
		    
		    return false;
		  }
		  else if(fieldRespOrg != "" && fieldTemplate != "")
		  {
		      var propertKeyGen= fieldRespOrg+"."+"ReviewInterval";
			  var language= '<xss:encodeForURL><%=strLanguage %></xss:encodeForURL>';
			  var URL = "../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:getPeriodicReviewInterval&propertyKey="+propertKeyGen+"&language="+language+"&selectedType="+selectedType;
			  var responseText = emxUICore.getDataPost(URL);
			 responseText = responseText.replace(/(^[\s]+|[\s]+$)/g, '');
			  document.emxCreateForm.PeriodicReviewInterval.value=responseText;
		  }
	  }
	}

	function getTemplateFields()
	{
			var vFileCheckinRow = document.getElementById("calc_FileCheckin");
			var vFileCheckinElem = document.getElementById("FileCheckinId");
			var templateId=document.getElementsByName("TemplateOID")[0].value;
			var objForm = document.forms[0];
   	        var template = objForm.elements["Template"].value;
			var URL = "../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:getTemplateDetails&templateOID="+templateId;
				var responseText = emxUICore.getDataPost(URL);
       		responseText = responseText.replace(/(^[\s]+|[\s]+$)/g, '');
		    	
	    	var responseArray = responseText.split('|');
	    
	    	//	Changes done since Template will be of different type than document object.Hence no need to copy type of template to the document
	    	//	document.emxCreateForm.TypeActual.value=responseArray[12];
			//document.emxCreateForm.TypeActualDisplay.value=responseArray[12];
			
			document.emxCreateForm.Title.value=responseArray[0];
			document.emxCreateForm.Description.value=responseArray[1];
 			if(document.emxCreateForm.ResponsibleOrganization)
			     document.emxCreateForm.ResponsibleOrganization.value=responseArray[2];
			document.emxCreateForm.ResponsibleOrganizationOID.value=responseArray[3];
			document.emxCreateForm.ResponsibleOrganizationDisplay.value=responseArray[2];
			document.emxCreateForm.PeriodicReviewInterval.value=responseArray[4];
			document.emxCreateForm.PeriodicReviewEnabled.value=responseArray[5];
			
			document.emxCreateForm.SubjectMatterExpert.value=responseArray[8];
			document.emxCreateForm.SubjectMatterExpertDisplay.value=responseArray[8];
			document.emxCreateForm.SubjectMatterExpertOID.value=responseArray[9];
			
			var catagoryField=document.emxCreateForm.Category;
			
			if(template!=""){
			if(catagoryField){
			  document.emxCreateForm.Category.disabled=true;
			  document.emxCreateForm.Category.value=responseArray[6];
			  }
			  
			  document.emxCreateForm.PeriodicReviewInterval.readOnly=true;
			  document.emxCreateForm.PeriodicReviewEnabled.disabled=true;
	  document.emxCreateForm.TrainingEnabled.disabled=true;
			  document.emxCreateForm.TrainingEnabled.value=responseArray[10];
			}
			else{
			if(catagoryField){
				document.emxCreateForm.Category.disabled=false;
				}
				document.emxCreateForm.PeriodicReviewInterval.readOnly=false;
			 	document.emxCreateForm.PeriodicReviewEnabled.disabled=false;
			 	document.emxCreateForm.TrainingEnabled.disabled=false;
			}
			if("false" == responseArray[7])
			{
				vFileCheckinElem.value = 'No';
				vFileCheckinRow.style.display = 'none';
			}
			else
			{
				vFileCheckinElem.value = 'Yes';
				vFileCheckinRow.style.display = '';
			}
				if("Mandatory" == responseArray[11])
			{
				var vName = document.getElementById("calc_Name");
			     vName.style.display = 'none';
			}
			else
			{
				var vName1 = document.getElementById("calc_Name");
			     vName1.style.display = '';
			}
			//updatePRI(false);
			
	}
	function getTemplateDetails()
	{		
			var templateId=document.getElementsByName("eFormOID")[0].value;
			var URL = "../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLEFormTemplateUI:getTemplateDetails&templateOID="+templateId;
			var responseText = emxUICore.getDataPost(URL);
			var responseArray = responseText.split('|');
			document.emxCreateForm.ResponsibleOrganization.value=responseArray[1];
			document.emxCreateForm.ResponsibleRole.value=responseArray[0];
			
			document.emxCreateForm.eFormRequirement.value=responseArray[2];
   	}
	function getCreateDocumentURL(valueForType)  
	{
		    var typeName="";
		    var typeValue="";
		    var objForm = document.forms[0];
		    var selectedType =null;
		    selectedType = valueForType;
		    selectedType = ReplaceAll(selectedType," ","");
	
		    var getTypeURL = "../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:getSelectedType&suiteKey=DocumentControl&selectedType="+selectedType;
		    var responseType = emxUICore.getDataPost(getTypeURL);
		    responseType = responseType.replace(/(^[\s]+|[\s]+$)/g, '');
		    responseType = responseType.split("|");
		    if(($.inArray('TRUE', responseType))>-1){
		    	var URL = "../common/emxCreate.jsp?type=type_"+selectedType+"&autoNameChecked=true&suiteKey=DocumentControl&SuiteDirectory=documentcontrol&header=enoDocumentCommon.Label.CreateNewDocument&mode=create&postProcessURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:createDocumentPostProcess&subTypeQSD=true";
		    }
		    else{
		    	var URL = "../common/emxCreate.jsp?type=type_"+selectedType+"&autoNameChecked=true&suiteKey=DocumentControl&SuiteDirectory=documentcontrol&header=enoDocumentCommon.Label.CreateNewDocument&mode=create&postProcessURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCDocument:createDocumentPostProcess";
		    }
		    return URL;
	} 
	function modifyForm(field,value)
	{
				var URL = "";
			var objForm = document.forms[0];
			var typeActualValueFromGlobal = "";
	        var s = document.location.href;
			var objForm = document.forms[0];
			typeActualValueFromGlobal = objForm.elements["TypeActual"].value;
			var TemplateOIDv = objForm.elements["TemplateOID"].value;
			var TemplateDisplay = objForm.elements["TemplateDisplay"].value;
			URL = getCreateDocumentURL(typeActualValueFromGlobal);
			var pathArray = window.location.href.split('&');
			if(pathArray.indexOf("actionMode=ReferenceDocument")>-1 && typeActualValueFromGlobal!=="Quality System Document" && URL.indexOf("subTypeQSD=true")<0){
				URL = URL +"&submitAction=doNothing&DCMode=createdocument&form=DCCreateDocument&appendURL="+ReplaceAll(typeActualValueFromGlobal," ","")+"|DocumentControl";
			}
			else{
	        	URL = URL +"&submitAction=doNothing&DCMode=createdocument&form=DCLCreateControlledDocument&preProcessJavaScript=makeSMERequired&templateOID="+TemplateOIDv+"&TemplateDisplayName="+TemplateDisplay+"&StringResourceFileId=enoDocumentControlStringResource&appendURL="+ReplaceAll(typeActualValueFromGlobal," ","")+"|DocumentControl";
	       	}
 			for (var i = 0; i < pathArray.length; i++) 
			{
				var value=pathArray[i];
				if(value.indexOf('<%=strActionMode%>') != -1) /* XSSOK */
				{
					URL = URL + "&"+value;
				}
				if(value.indexOf('<%=strParentOID%>') != -1) /* XSSOK */
				{
					URL = URL + "&"+value;
				}
				if(value.indexOf('type=type_' + ReplaceAll(typeActualValueFromGlobal," ","")) > 0){
					return;
				}
			}
			getTopWindow().location.href = URL;
	}
	
function disableImplementationNotificationsThresholdOnEdit(){
		var colVal = trim(arguments[0]);
		var currentCell = emxEditableTable.getCurrentCell();
		var rowId = currentCell.rowID;
		
		if(colVal == "false"){
			emxEditableTable.setCellValueByRowId(rowId,"ImplementationNotificationsThreshold","","",true);
			emxEditableTable.setCellEditableByRowId(rowId,"ImplementationNotificationsThreshold",false, true); 
				}
				else{
			emxEditableTable.setCellValueByRowId(rowId,"ImplementationNotificationsThreshold","10","10", true);
			emxEditableTable.setCellEditableByRowId(rowId,"ImplementationNotificationsThreshold",true, true);
		}
				}

	function validateThresholdValueOnEdit()
	{
		var bool = true;
		var colVal = trim(arguments[0]);
		if(isNaN(colVal)){
			var alertMsg = "<%=strNotificationAlert%>";
			alert(alertMsg);
			bool = false;
		}
		return bool;
	}
	
		
function modifyCheckbox()
{
		var frames=document.getElementsByName("magicalframe");
		frames[0].removeAttribute("onload");
		var parentNode=frames[0].parentNode;
		parentNode.removeChild(frames[0]);	
	var frame = findFrame(getTopWindow(),"content");
		var inputs = frame.document.getElementsByTagName("INPUT");
	
		for (var i = 0; i < inputs.length; i++) 
		{
			var inputName = inputs[i].name;
			if(inputName == "chkList")
			{
				inputs[i].setAttribute("onclick","setCheckboxStatus(this);selectAllCustomData(this);");
			}
			if (inputName == "emxTableRowIdActual" && inputs[i].type == "checkbox")
			{
				inputs[i].setAttribute("onclick","enableRequiredFields(this);doFreezePaneCheckboxClick(this, event); doCheckSelectAll();");
			}
		}
}

function enableRequiredFields(element)
{
	var vYes="Yes";
	var vNo="No";
	
    unregisterWindowResizeEvent();

	var frame = findFrame(getTopWindow(),"content");
	var res = element.id;
	res = res.substring(7, res.length);
	var rowNode = emxUICore.selectSingleNode(frame.oXML, "/mxRoot/rows//r[@id = '" + res + "']");
	if(element.checked==true)
	{
 		rowNode.setAttribute("mandatory", "Yes");
 		rowNode.setAttribute("mandatoryStatus", "No");
 	}
	else
	{
		rowNode.removeAttribute("mandatory");
		rowNode.removeAttribute("mandatoryStatus");
        }
       //rebuildView();		
}

function unregisterWindowResizeEvent(){
            try
            {
                var i = registeredEvents.lEvents.length - 1;
                while(i >= 0){
                    var event = registeredEvents.lEvents[i];
                    if(event[1]=='resize'){

                        if(event[0].removeEventListener){
                            event[0].removeEventListener(event[1], event[2], event[3]);
                        };
    
                        event[0][event[1]] = null;
                      }
                    i--;
                 };
            }
            catch(e){
            }
}

function updateMandatoryColumnOxml(element)
{
	var vYes="Yes";
	var vNo="No";
	
	var frame = findFrame(getTopWindow(),"content");
	var res = element.id;
	res = res.substring(19, res.length);
	var selectedValue = element.value;
	var xPath = "/mxRoot/rows//r[@id = '" + res + "']/c[3]";
	var textColumn = emxUICore.selectSingleNode(frame.oXML, xPath);

	if(element != null)
		{
			var mandatoryStatus = new String();
			var rowNode = emxUICore.selectSingleNode(frame.oXML, "/mxRoot/rows//r[@id = '" + res + "']");
			textColumn.removeChild(textColumn.childNodes[0]);
			
			var newElem=frame.oXML.createElement("select");
            newElem.setAttribute("onChange","updateMandatoryColumnOxml(this);");
            newElem.setAttribute("id","selectboxMandatory_"+res);
            
            var newOptionYes=frame.oXML.createElement("option");
            newOptionYes.setAttribute("value",vYes);
            if(isIE){
                newOptionYes.text="<%=strRangeYes%>";
            }
            else{
                newOptionYes.textContent="<%=strRangeYes%>";
            }
            
            var newOptionNo=frame.oXML.createElement("option");
            newOptionNo.setAttribute("value",vNo);
            if(isIE){
                newOptionNo.text="<%=strRangeNo%>";
            }
            else{
                newOptionNo.textContent="<%=strRangeNo%>";
            }
            
			if(selectedValue == 'Yes')
			{
				newOptionYes.setAttribute("selected","true");
				rowNode.setAttribute("mandatoryStatus", "Yes");
			}
			if(selectedValue == 'No')
			{
				newOptionNo.setAttribute("selected","true");
				rowNode.setAttribute("mandatoryStatus", "No");
			}
	        
	        newElem.appendChild(newOptionYes);
	        newElem.appendChild(newOptionNo);
	        textColumn.appendChild(newElem);
    		textColumn.setAttribute("a","");
   		}
}

function updateValuesColumnOxml(element)
{
	
	var frame = findFrame(getTopWindow(),"content");
	var res = element.id;
	res = res.substring(10, res.length);
	var xPath = "/mxRoot/rows//r[@id = '" + res + "']/c[4]";
	var textColumn = emxUICore.selectSingleNode(frame.oXML, xPath);
	if(element != null)
	{
		var selectRangeValues = new String();
		var rowNode = emxUICore.selectSingleNode(frame.oXML, "/mxRoot/rows//r[@id = '" + res + "']");
		
		textColumn.removeChild(textColumn.childNodes[0]);
        var newElem=frame.oXML.createElement("select");
        newElem.setAttribute("onChange","updateValuesColumnOxml(this);");
        newElem.setAttribute("multiple","true");
        newElem.setAttribute("id","selectbox_"+res);
		
		for (var i = 0; i < element.options.length; i++){
      		var newOption=frame.oXML.createElement("option");
            newOption.setAttribute("value",element.options[i].value);
            if(isIE){
                newOption.text=element.options[i].text;
            }
            else{
                newOption.textContent=element.options[i].textContent;
			}
      		if(element.options[i].selected == true){
                newOption.setAttribute("selected","true");
      			selectRangeValues = selectRangeValues.concat(element.options[i].value).concat(",");
  			}				
            newElem.appendChild(newOption);
		}
    	
    	textColumn.appendChild(newElem);
    	textColumn.setAttribute("a","");
    	selectRangeValues = selectRangeValues.substring(0, selectRangeValues.length - 1);
    	rowNode.setAttribute("rangeValues", selectRangeValues);
   	}
}

function selectAllCustomData(element)
{
	var frame = findFrame(getTopWindow(),"content");
	var filterValue = frame.document.getElementById("DCLAttributeNameMatches").value;
	var allRows = emxUICore.selectNodes(frame.oXML, "/mxRoot/rows//r");
	if(element.checked==true)
	{
		for (var i = 0; i < allRows.length; i++)
		{
			var rowId = allRows[i].getAttribute("id");
			allRows[i].setAttribute("mandatory","Yes");
			allRows[i].setAttribute("mandatoryStatus","No");
			var columnNodeMandatory = emxUICore.selectSingleNode(allRows[i],"c[3]");
			var columnNodeValues = emxUICore.selectSingleNode(allRows[i],"c[4]");
			if(columnNodeMandatory != null)
			{
	            columnNodeMandatory.removeChild(columnNodeMandatory.childNodes[0]);
	            
	            var newElem=frame.oXML.createElement("select");
	            newElem.setAttribute("onChange","updateMandatoryColumnOxml(this);");
	            newElem.setAttribute("id","selectboxMandatory_"+rowId);
	            
	            var newOptionYes=frame.oXML.createElement("option");
	            newOptionYes.setAttribute("value","<%=strRangeYes%>");
	            if(isIE){
	               newOptionYes.text="<%=strRangeYes%>";
                }
                else{
	               newOptionYes.textContent="<%=strRangeYes%>";
                }
	            
	            var newOptionNo=frame.oXML.createElement("option");
	            newOptionNo.setAttribute("value","<%=strRangeNo%>");
	            newOptionNo.setAttribute("selected","true");
	            if(isIE){
	               newOptionNo.text="<%=strRangeNo%>";
                }
                else{
	               newOptionNo.textContent="<%=strRangeNo%>";
                }
	            
	            newElem.appendChild(newOptionYes);
	            newElem.appendChild(newOptionNo);
	            columnNodeMandatory.appendChild(newElem);

    			columnNodeMandatory.setAttribute("a","");
			}
			if(columnNodeValues != null)
			{
				var valuesHTMLContent = columnNodeValues.innerHTML;

				if(valuesHTMLContent)
				{
				
					var parser = new DOMParser();
					var el = parser.parseFromString(valuesHTMLContent, "text/xml");
					var optionContent = el.getElementsByTagName( 'option' );
					var selectRangeValues = new String();

				    columnNodeValues.removeChild(columnNodeValues.childNodes[0]);
		            var newElem=frame.oXML.createElement("select");
		            newElem.setAttribute("onChange","updateValuesColumnOxml(this);");
		            newElem.setAttribute("multiple","true");
		            newElem.setAttribute("id","selectbox_"+rowId);

					for (var s = 0; s < optionContent.length; s++)
					{
						selectRangeValues = selectRangeValues.concat(optionContent[s].getAttribute("value")).concat(",");
                        var newOption=frame.oXML.createElement("option");
                        newOption.setAttribute("value",optionContent[s].getAttribute("value"));
                        newOption.setAttribute("selected","true");
                        if(isIE){
                          newOption.text=optionContent[s].getAttribute("text");
                        }
                        else{
                          newOption.textContent=optionContent[s].getAttribute("textContent");
					}
                        newElem.appendChild(newOption);
					}
		            columnNodeValues.appendChild(newElem);
					
				columnNodeValues.setAttribute("a","");
    				selectRangeValues = selectRangeValues.substring(0, selectRangeValues.length - 1);	
    				allRows[i].setAttribute("rangeValues", selectRangeValues);
    			}
			}
		}
		
	}
	else
	{
		for (var i = 0; i < allRows.length; i++)
		{
			var rowId = allRows[i].getAttribute("id");
			allRows[i].removeAttribute("mandatory");
			allRows[i].removeAttribute("mandatoryStatus");
			var columnNodeMandatory = emxUICore.selectSingleNode(allRows[i],"c[3]");
			var columnNodeValues = emxUICore.selectSingleNode(allRows[i],"c[4]");
			if(columnNodeMandatory != null)
			{
			    columnNodeMandatory.removeChild(columnNodeMandatory.childNodes[0]);
		        var newElem=frame.oXML.createElement("select");
		        newElem.setAttribute("onChange","updateMandatoryColumnOxml(this);");
		        newElem.setAttribute("disabled","true");
		        newElem.setAttribute("id","selectboxMandatory_"+rowId);
		        
		        var newOptionYes=frame.oXML.createElement("option");
		        newOptionYes.setAttribute("value","<%=strRangeYes%>");
		        if(isIE){
		            newOptionYes.text="<%=strRangeYes%>";
                }
                else{
                    newOptionYes.textContent="<%=strRangeYes%>";
                }

		        var newOptionNo=frame.oXML.createElement("option");
		        newOptionNo.setAttribute("value","<%=strRangeNo%>");
		        newOptionNo.setAttribute("selected","true");
		        if(isIE){
		            newOptionNo.text="<%=strRangeNo%>";
                }
                else{
                    newOptionNo.textContent="<%=strRangeNo%>";
                }
		        
		        newElem.appendChild(newOptionYes);
		        newElem.appendChild(newOptionNo);
		        columnNodeMandatory.appendChild(newElem);

    			columnNodeMandatory.setAttribute("a","");
  				}	
			if(columnNodeValues != null)
			{
				var valuesHTMLContent = columnNodeValues.innerHTML;
				if(valuesHTMLContent)
				{
					var parser = new DOMParser();
					var el = parser.parseFromString(valuesHTMLContent, "text/xml");
                    var optionContent = el.getElementsByTagName( 'option' );
					
					columnNodeValues.removeChild(columnNodeValues.childNodes[0]);
		            var newElem=frame.oXML.createElement("select");
		            newElem.setAttribute("onChange","updateValuesColumnOxml(this);");
		            newElem.setAttribute("multiple","true");
		            newElem.setAttribute("disabled","true");
		            newElem.setAttribute("id","selectbox_"+res);
		            
		            for (var s = 0; s < optionContent.length; s++)
                    {
                        var newOption=frame.oXML.createElement("option");
                        newOption.setAttribute("value",encodeHtmlEntity(optionContent[s].getAttribute("value")));
                        newOption.setAttribute("selected","true");
                        if(isIE){
                          newOption.text=encodeHtmlEntity(optionContent[s].getAttribute("text"));
                        }
                        else{
                          newOption.textContent=encodeHtmlEntity(optionContent[s].getAttribute("textContent"));
                        }
                        newElem.appendChild(newOption);
                    }
		            columnNodeValues.appendChild(newElem);
					
    				columnNodeValues.setAttribute("a","");
    				allRows[i].removeAttribute("rangeValues");
  			}
		}
	}
}
	rebuildView();
}

function encodeHtmlEntity(text) 
{
var charGlobal = new String(); 
for(var i=0;i<text.length;i++)
{
	var charId = text.charCodeAt(i);
	if(!(charId == 32 || (charId>=65 && charId<=90) || (charId>=97 && charId<=122) || (charId>=49 && charId<=57)))
	{
		charGlobal = charGlobal.concat("&#"+charId+";");
	}
	else
	{
		charGlobal = charGlobal.concat(text.charAt(i));
	}
}
return charGlobal;
}
	function disableImplementationNotificationsThresholdOnEdit(){
		var colVal = trim(arguments[0]);
		var currentCell = emxEditableTable.getCurrentCell();
		var rowId = currentCell.rowID;
		
		if(colVal == "false"){
			emxEditableTable.setCellValueByRowId(rowId,"ImplementationNotificationsThreshold","","",true);
			emxEditableTable.setCellEditableByRowId(rowId,"ImplementationNotificationsThreshold",false, true); 
				}
				else{
			emxEditableTable.setCellValueByRowId(rowId,"ImplementationNotificationsThreshold","10","10", true);
			emxEditableTable.setCellEditableByRowId(rowId,"ImplementationNotificationsThreshold",true, true);
		}
				}

	function validateThresholdValueOnEdit()
	{
		var bool = true;
		var colVal = trim(arguments[0]);
		if(isNaN(colVal)){
			var alertMsg = "<%=strNotificationAlert%>";
			alert(alertMsg);
			bool = false;
		}
		return bool;
	}
		function promoteOrdemote(objectId,action)
	{
	<%context.clearClientTasks(); %>
		var queryString = "&objectId="+objectId+"&suiteKey=DocumentControl&action="+action;
			
		var response=emxUICore.getDataPost("../questionnaire/enoQuestionnaireExecute.jsp?questionAction=ENOQuestionUI:findQuestionOnChange",queryString);
		alert(response);
		<%
			String errorMsg="";
			if(response.toString().contains("Error"))
			{
				
					context.updateClientTasks();
					ClientTaskList listNotices 	= context.getClientTasks();	
					ClientTaskItr itrNotices 	= new ClientTaskItr(listNotices);
					StringBuilder sbMessages	= new StringBuilder();
					errorMsg=EnoviaResourceBundle.getProperty(context, "emxFrameworkStringResource",Locale.US,"emxFramework.Error.OperationFailed");
					System.out.println("itrNotices-"+itrNotices);
					System.out.println(response);
					if(response.toString().contains("Cannot promote - all requirements not satisfied")){
						errorMsg = EnoviaResourceBundle.getProperty(context, "emxFrameworkStringResource",Locale.US,"emxFramework.LifeCycle.PromotionFailed.ErrorMessage");
					}else{
						System.out.println("itrNotices"+itrNotices);
					while (itrNotices.next()) {
						System.out.println("itrNotices1"+itrNotices);
						ClientTask clientTaskMessage =  itrNotices.obj();
							sbMessages.append("\\n\\r").append((String) clientTaskMessage.getTaskData());
						}
						errorMsg = errorMsg + sbMessages.toString();
						
					}
					context.clearClientTasks();
					errorMsg = errorMsg.replace("\"", "\\\"");
			}
			if(errorMsg!="")
			{		
		      %>
				alert("<%=errorMsg%>");
			 <%
			}	
		%>	

	}
	function openEditPage(objectId,type){
	var submitURL="";
	if(type=='Change Order')
	{
		 submitURL+="../common/emxForm.jsp?form=type_ChangeOrderSlidein&formHeader=EnterpriseChangeMgt.Heading.EditCO&HelpMarker=emxhelpchangeorderedit&mode=edit&submitAction=doNothing&preProcessJavaScript=preProcessInEditCO&postProcessJPO=enoECMChangeOrder:coPostProcessJPO&type=type_ChangeOrder&postProcessURL=../enterprisechangemgt/ECMCommonRefresh.jsp?functionality=editCOFromRMB";
		submitURL+="&objectId="+objectId+"&parentOID="+objectId;
		submitURL +="&emxSuiteDirectory=enterprisechangemgt&suiteKey=EnterpriseChangeMgt&SuiteDirectory=enterprisechangemgt&StringResourceFileId=emxEnterpriseChangeMgtStringResource";
	}
	if(type=='Change Action')
	{
		submitURL+="../common/emxForm.jsp?form=type_ChangeActionSlidein&formHeader=EnterpriseChangeMgt.Heading.EditCA&HelpMarker=emxhelpchangeactionedit&mode=edit&submitAction=doNothing&type=type_ChangeAction&postProcessURL=../enterprisechangemgt/ECMCommonRefresh.jsp?functionality=editCAFromRMB";
		submitURL+="&objectId="+objectId+"&parentOID="+objectId;
		submitURL +="&emxSuiteDirectory=enterprisechangemgt&suiteKey=EnterpriseChangeMgt&SuiteDirectory=enterprisechangemgt&StringResourceFileId=emxEnterpriseChangeMgtStringResource";
	}
	if(type=='Quality System Document')
	{
		submitURL+="../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:showDocumentEditView&validateToken=false";
		submitURL+="&objectId="+objectId+"&parentOID="+objectId;
		submitURL +="&emxSuiteDirectory=enterprisechangemgt&suiteKey=EnterpriseChangeMgt&SuiteDirectory=enterprisechangemgt&StringResourceFileId=emxEnterpriseChangeMgtStringResource";
	}
		getTopWindow().showSlideInDialog(submitURL, true);
	var contentFrame=findFrame(getTopWindow(), "DCMyDocumentsTab");
	contentFrame.emxEditableTable.refreshStructureWithOutSort();
	}
	
	function openViewPage(objectId)
	{
		var submitURL="../common/emxTree.jsp?mode=insert&objectId="+objectId;
			submitURL = submitURL + "&HelpMarker=emxhelpchangeorderedit";
		getTopWindow().showModalDialog(submitURL,250,250,true);
	}
	function openViewPageDiv(objectId)
	{
	
	
		var queryString = "&objectId="+objectId+"&suiteKey=DocumentControl";
		var response=emxUICore.getDataPost("../questionnaire/enoQuestionnaireExecute.jsp?questionAction=ENODCLDocumentUI:getBasicProperties",queryString);
		var divView= document.getElementById(objectId);
		divView.innerHTML=response;
	 	divView.style.visibility= 'visible';
	
	}
	
function openLifecycle(objectId)
{
	var submitUrl="../common/emxLifecycle.jsp?toolbar=AEFLifecycleMenuToolBar&header=emxFramework.Lifecycle.LifeCyclePageHeading&export=false";
	submitUrl+="&mode=advanced&objectId="+objectId;
	showModalDialog(submitUrl,250,250,true);
}
function refreshDC(objectId,action)
{
var contentFrame=findFrame(getTopWindow(), "DCMyDocumentsTab");
contentFrame.location.href=contentFrame.location.href;

}
function openApprovePage(submitUrl)
{
showModalDialog(submitUrl,250,250,true);
}
function showTooltip(objectName,objectId)
{
var tooltip= document.getElementById(objectName);
tooltip.style.visibility= 'visible';
	if(objectId!='')
	{
		var basicToolTip= document.getElementById(objectId);
		if(basicToolTip)
			basicToolTip.style.visibility= 'hidden';
			showRoute(objectId);
	}
	

}
function hideTooltip(objectName,objectId)
{
var tooltip= document.getElementById(objectName);
tooltip.style.visibility= 'hidden';
if(objectId!='')
	{
	var basicToolTip= document.getElementById(objectId);
	if(basicToolTip)
		basicToolTip.style.visibility= 'hidden';
	}
	
}
function showRoute(objectId)
{
	var queryString = "&objectId="+objectId+"&suiteKey=DocumentControl";
	var response=emxUICore.getDataPost("../questionnaire/enoQuestionnaireExecute.jsp?questionAction=ENODCLDocumentUI:getApproversImage",queryString);
	var imgDiv= document.getElementById(objectId+'Images');
	imgDiv.innerHTML=response;
}
function openTreePage(objectId)
	{
		var submitURL="../common/emxTree.jsp?mode=insert&objectId="+objectId;
		getTopWindow().showModalDialog(submitURL,250,250,true);
	}
	
	function openHistoryPage(objectId){
	var submitUrl="../audittrail/Execute.jsp?executeAction=ENOAuditTrails:preProcessHistory&structuralHistory=false&mode=";
	submitUrl+="&objectId="+objectId;
	getTopWindow().showModalDialog(submitUrl,250,250,true);
	
	}
	
	function openConditionsPage(objectId)
	{
	var url='../questionnaire/enoQuestionnaireExecute.jsp?questionAction=ENOQuestionUI:getPromoteBlockingConditionsHTML&validateToken=false&mqlNoticeMode=true&objectId='+objectId;
	var doc=emxUICore.getDataPost(url);
	var promoteBlock=document.getElementById(objectId+'Blocking');
	alert(doc.substring(1));
	promoteBlock.innerHTML= doc.substring(1);
	promoteBlock.style.visibility= 'visible';
	
	}
	
  function	enableImplemenationOtionsinImplPlan(){
  
	var currentCell = emxEditableTable.getCurrentCell();
	var currentCellValue = currentCell.value.current.actual;
    var rowId = currentCell.rowID;
 
	
	if(currentCellValue == 'Specify Implementation Period')
		{
     		emxEditableTable.setCellEditableByRowId(rowId,"Planned Effective Date",false,true);
       		emxEditableTable.setCellEditableByRowId(rowId,"Planned Imp Period",true,true);
  		}
  	else  if(currentCellValue == 'Specify Implementation Date'){
   				emxEditableTable.setCellValueByRowId(rowId,"Planned Imp Period","","",true);
   				emxEditableTable.setCellEditableByRowId(rowId,"Planned Imp Period",false,true);
         		emxEditableTable.setCellEditableByRowId(rowId,"Planned Effective Date",true,true);
   		}else {
    			emxEditableTable.setCellEditableByRowId(rowId,"Planned Imp Period",false,true);
         		emxEditableTable.setCellEditableByRowId(rowId,"Planned Effective Date",false,true);
        }
  }
  
  function validateEffectivityPeriod()
	{
	   var interval = arguments[0];
		if(interval=="")
		{
			 return true;
		}
		if(isNaN(interval) || (interval<0))
	  	  {
	  	     var alertMsg = "<%=strAlerMsgForValidNumber%>"; /* XSSOK */
	  	     alert(alertMsg);
	  	     return false;
	  	 }
	 		 else
	  	{
	     return true;
	   }
	}
	
	function validatePastDateForTable()
	{
		var vDueDate_msvalue = arguments[0];
   		var currentCell = emxEditableTable.getCurrentCell();
    	var rowId = currentCell.rowID;
    	var vDueDateCell = emxEditableTable.getCellValueByRowId(rowId,"Planned Effective Date");
		var vDueDateValue = vDueDateCell.value.current.actual;
		var vDueDate = new Date();
	    vDueDate.setTime(vDueDate_msvalue);
	    		
	    vDueDate.setHours(0,0,0,0); 
	    var todayDate = new Date();
	    todayDate.setHours(0,0,0,0); 
	    if(vDueDate=="")
		{
			 return true;
		}
		else
		{
   			if(parseInt(vDueDate.getTime()) < parseInt(todayDate.getTime()))
   			{
   			 var alertMsg = "<%=strAlerMsgForValidDate%>"; /* XSSOK */
	  	     alert(alertMsg);
  				return false;
    		}
    	}
		 return true;
	}
  
  function getTemplateScript()
  {
  				var templateId='';
				var templateName='';
				var params = getTopWindow().location.href;
				if(params.indexOf('templateOID') !== -1)
				{
					var splitt=params.split('&');
					var i=0;
					for(i=0;i<splitt.length;i++)
					{
						var tempId=splitt[i];
						if(tempId.indexOf('templateOID')!=-1)
						{
						
							var tempIdArray=tempId.split('=');
							templateId=tempIdArray[1];
						}
						if(tempId.indexOf('TemplateDisplayName')!=-1)
						{
							var tempIdArray1=tempId.split('=');
							templateName=tempIdArray1[1];
						}
					} 
				}
  
		       
				var templateDisplay = document.getElementsByName('TemplateDisplay');
				if(null!=templateDisplay[0]){
				templateDisplay[0].disabled = true;
				 if(templateId!=''){
						templateDisplay[0].value=templateName;
						var template1 = document.getElementsByName('Template');
						template1[0].value=templateName;
						var templateOID= document.getElementsByName('TemplateOID');
						templateOID[0].value=templateId;
						getTemplateFields(templateId);
				}
				var vTemplateChooser = document.getElementsByName('btnTemplate');
				var objForm = document.forms[0];
				var selectedType =null;
				selectedType = objForm.elements['TypeActual'].value;
				selectedType = ReplaceAll(selectedType," ",""); 
				vTemplateChooser[0].onclick = function () { 
				javascript:showChooser('../common/emxFullSearch.jsp?field=TYPES=type_CONTROLLEDDOCUMENTS:CURRENT=policy_ControlledDocumentTemplate.state_Active&fieldNameOID=TemplateOID&form=DCLDocumentsSearchFilters&massPromoteDemote=false&suiteKey=DocumentControl&submitURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLTemplateAttributesGroupingUI:getSelectedTemplateInterface&table=DCLDocumentsSearch&fieldNameDisplay=TemplateDisplay&fieldNameActual=Template&submitAction=refreshCaller&selection=single&formInclusionList=DCL_DOC_RO','600','600','true','','Template') } 
						
				var vTemplate = document.getElementById('calc_Template')
  
				var vFirstField = vTemplate.parentNode.firstChild;
				var c1 = vTemplate.cloneNode(true);
				try {
					vTemplate.parentNode.insertBefore(vTemplate, vFirstField.nextElementSibling);
					}
			   catch(e) 
				 {
				 alert('ERR')
				 }
				 }
				 
  }
  
 function disableFieldAssigneeChoice() 
{
	
	var btnAssignee = document.getElementsByName("btnAssignee")[0];
	var objectId = document.getElementsByName("objectId")[0].value;
	var fieldTitle = document.emxCreateForm.Title;
			
	var vAssigneeChoice  = document.getElementsByName("AssigneeChoice");
	for (var i = 0; i < vAssigneeChoice.length; i++) {       
            	if (vAssigneeChoice[i].value.toLowerCase() == "complaint member") {
            		vAssigneeChoice[i].checked = true;
					callAjaxForPhysicalId(objectId);
          		 break;
            }
           
    }
}

		
		function callAjaxForPhysicalId(objectId){
var url = "../ActionTasks/iwCSAjaxController.jsp" + "?" + "listProgramName=" + "com.dassault_systemes.enovia.actiontasks.ui.ActionTasks:preProcessSetPhysicalid&objectId="+objectId;
	if (window.XMLHttpRequest) {
        request = new XMLHttpRequest();
    }
    else if (window.ActiveXObject) {
        request = new ActiveXObject("Microsoft.XMLHTTP");
    }
	request.open("GET", url, true);
	request.onreadystatechange = function () { setPhysicalId(request); }
	request.send(null);
}
	
	function setPhysicalId(request)
{
	if (request.readyState == 4) {
        if (request.status == 200) {
            // handle the response js object
            var resText = request.responseText.split("ajaxResponse");
            var jsObject = eval("(" + resText[1] + ")");
            var result = jsObject.result;
            var vPhysicalId = result[0].value;
            var btnAssignee  =document.getElementsByName("btnAssignee")[0];
            btnAssignee.onclick = function () {
            			javascript:showFullSearchChooserInForm('../common/emxFullSearch.jsp?field=TYPES=type_Person:CURRENT=policy_Person.state_Active:PQC_COMPLAINT_RELATED_ASSIGNEE='+vPhysicalId+'&table=AEFPersonChooserDetails&selection=multiple&submitURL=../common/AEFSearchUtil.jsp&fieldNameActual=Assignee&fieldNameDisplay=AssigneeDisplay&fieldNameOID=AssigneeOID&suiteKey=&showInitialResults=true','Assignee');
          		  		return false; 
          		};
		}
        request = null;
    }
}	
		
function validatePastDate()
{
    if (this.value != null && this.value != "") {
     var formFieldDateMS = document.getElementsByName(this.name + "_msvalue")[0].value;
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
        if(msForm < msNow)
        {
           var alertMsg = "<%=strAlerMsgForValidDate%>"; /* XSSOK */
	   alert(alertMsg);
  	   return false;
        }
    }
    return true;
}
  
  
  function changeTypeOfDocument(field,value)
	{
			var objForm = document.forms[0];
			var typeActualValueFromGlobal = "";
			var selTemplateIdValue = getURLParameter("selTemplateId");
			typeActualValueFromGlobal = objForm.elements["TypeActual"].value;
			var type=ReplaceAll(typeActualValueFromGlobal," ","");
			var URL =" ../common/emxCreate.jsp?type=type_"+ type+ "&createJPO=ENODCDocument:createDocument&form=DCLCreateDocumentFromTemplate&helpMarker=emxhelpcreatedocfromtemplate&preProcessJavaScript=makeSMERequired&submitAction=doNothing&autoNameChecked=true&header=enoDocumentControl.Command.CreateDocumentFromTemplate&DCMode=createdocument&suiteKey=DocumentControl&StringResourceFileId=enoDocumentControlStringResource&SuiteDirectory=documentcontrol&selTemplateId=" + selTemplateIdValue + "&postProcessURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLAdminActions:createDocumentFromTemplatePostProcess&callledFor=connectTemplatetoDocument";
			getTopWindow().location.href = URL;
}

