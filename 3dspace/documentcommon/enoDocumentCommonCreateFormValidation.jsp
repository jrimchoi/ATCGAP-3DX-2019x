
<%@page import="java.net.URLEncoder"%>
<%@page import="com.matrixone.apps.framework.ui.UINavigatorUtil"%>
<%--  enoDocumentCommonCreateFormValidation.jsp

  Copyright (c) 1992-2017 Dassault Systemes.
  All Rights Reserved.
  This program contains proprietary and trade secret information of MatrixOne,
  Inc.  Copyright notice is precautionary only
  and does not evidence any actual or intended publication of such program

   static const char RCSID[] = "$Id: emxJSValidation.jsp.rca 1.1.5.4 Wed Oct 22 15:48:43 2008 przemek Experimental przemek $";
--%>
<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@page import="com.dassault_systemes.enovia.documentcommon.DCConstants"%>
<%
out.clear();
String strLanguage = request.getHeader("Accept-Language");
response.setContentType("text/javascript; charset=" + response.getCharacterEncoding());
String strAlertMsg = EnoviaResourceBundle.getProperty(context, "enoDocumentControlStringResource", context.getLocale(), "enoDocumentControl.Alert.Msg.SelectOrganization");
String strAlertMsgInterval = EnoviaResourceBundle.getProperty(context, "enoDocumentControlStringResource", context.getLocale(), "enoDocumentControl.Alert.Msg.PeriodicReviewInterval");
String strSMEAlert = EnoviaResourceBundle.getProperty(context, "enoDocumentControlStringResource", context.getLocale(), "enoDocumentControl.Alert.Msg.SMESelect");
String strNotificationAlert = EnoviaResourceBundle.getProperty(context, "enoDocumentControlStringResource", context.getLocale(), "enoDocumentControl.Alert.Msg.NotANumber");
String strActionMode=DCConstants.ACTION_MODE;
String strParentOID=DCConstants.PARENT_OID;
%>
  function getCreateDocumentURL(valueForType)  
	{
		    var typeName="";
		    var typeValue="";
		    var objForm = document.forms[0];
		    var selectedType =null;
		    selectedType = valueForType;
		    selectedType = ReplaceAll(selectedType," ","");
	
		    var getTypeURL = "../documentcommon/enoDCExecute.jsp?dcAction=ENODCDocument:getSelectedType&suiteKey=DocumentCommon&selectedType="+selectedType;
		    var responseType = emxUICore.getDataPost(getTypeURL);
		    responseType = responseType.replace(/(^[\s]+|[\s]+$)/g, '');

		    var URL = "../common/emxCreate.jsp?type=type_"+selectedType+"&autoNameChecked=true&suiteKey=DocumentCommon&SuiteDirectory=documentcommon&header=enoDocumentCommon.Label.CreateNewDocument&mode=create&preProcessJavaScript=makeSMERequired&postProcessURL=../documentcommon/enoDCExecute.jsp?dcAction=ENODCDocument:createDocumentPostProcess";
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
			URL = getCreateDocumentURL(typeActualValueFromGlobal);
			var pathArray = window.location.href.split('&');
			if(pathArray.indexOf("actionMode=ReferenceDocument")>-1 && typeActualValueFromGlobal!=="Quality System Document"){
				URL = URL +"&submitAction=doNothing&DCMode=createdocument&form=DCCreateDocument&appendURL="+ReplaceAll(typeActualValueFromGlobal," ","")+"|DocumentControl";
			}
			else{
				URL = URL +"&submitAction=doNothing&DCMode=createdocument&form=DCLCreateControlledDocument&preProcessJavaScript=makeSMERequired";
			}
	       
	       	var pathArray = window.location.href.split('&');
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
	  var index = temp.indexOf(stringToFind);
	  while(index != -1)
	  {
	   temp = temp.replace(stringToFind,stringToReplace);
	   index = temp.indexOf(stringToFind);
	  }
	  return temp;
	}
	
	
	function updatePRI(bAlert)
	{
	  var objForm = document.forms[0];
	  var selectedType =null;
	  var fieldPeriodicRevInterval = objForm.elements["PeriodicReviewEnabled"].value;
	  var fieldRespOrg = objForm.elements["ResponsibleOrganizationDisplay"].value;
	  
	  if((objForm.TypeActual[0] != null))
	  {
		    	selectedType = objForm.TypeActual[0].value;
	  }
      else
	  {
		selectedType = objForm.TypeActual.value;
	  }
	  selectedType = ReplaceAll(selectedType," ","");
	  if(fieldPeriodicRevInterval == 'No')
	  {
	  	
	  	document.getElementById("calc_SubjectMatterExpert").className = 'createLabel';
	    document.getElementById("calc_SubjectMatterExpert").children[0].className = 'createLabel';
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
	  	  document.emxCreateForm.PeriodicReviewInterval.disabled=false;
		  fieldRespOrg = ReplaceAll(fieldRespOrg," ","");   
		  document.emxCreateForm.PeriodicReviewInterval.disabled=false;
	  	  document.emxCreateForm.SubjectMatterExpertDisplay.disabled=false;
	  	  document.emxCreateForm.btnSubjectMatterExpert.disabled=false;
		  if(fieldRespOrg == "")
		  {
		    var respOrgAlert = "<%=strAlertMsg%>"; /* XSSOK */
		    if(bAlert)
		    {
		    	alert(respOrgAlert);
		    }
		    
		    return false;
		  }
		  else
		  {
		      var propertKeyGen= selectedType+"."+fieldRespOrg+"."+"ReviewInterval";
			  var language= '<xss:encodeForURL><%=strLanguage %></xss:encodeForURL>';
			  var URL = "../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:getPeriodicReviewInterval&propertyKey="+propertKeyGen+"&language="+language;
			  var responseText = emxUICore.getDataPost(URL);
			 responseText = responseText.replace(/(^[\s]+|[\s]+$)/g, '');
			  document.emxCreateForm.PeriodicReviewInterval.value=responseText;
		  }
	  }
	}
	
	function disablePeriodicReviewInterval()
	{
		updatePRI(true);
	}
	
	function validateRangeofPeriodicInterval()
	{
	  var interval = document.emxCreateForm.PeriodicReviewInterval.value;
	  var fieldPeriodicRevInterval = document.emxCreateForm.PeriodicReviewEnabled.value;
	  var smeValue = document.emxCreateForm.SubjectMatterExpertDisplay.value;
	  if(fieldPeriodicRevInterval == "Yes")
	  {
		  if(fieldPeriodicRevInterval=="Yes" && smeValue == "")
		  {
		   var SMEalert = "<%=strSMEAlert%>"; /* XSSOK */
		   alert(SMEalert);
		   return false;
		  }
		  else if(interval<1 || interval>99)
		  {
		   var alertMsg = "<%=strAlertMsgInterval%>"; /* XSSOK */
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
	function makeSMERequired()
	{
		var objForm = document.forms[0];
		if(objForm.elements["PeriodicReviewEnabled"]){
		var fieldPeriodicRevInterval = objForm.elements["PeriodicReviewEnabled"].value;
		if(fieldPeriodicRevInterval == 'No')
		  {
		     document.getElementById("calc_SubjectMatterExpert").className = 'createLabel';
	         document.getElementById("calc_SubjectMatterExpert").children[0].className = 'createLabel';
		  }
		else
		{
		      document.getElementById("calc_SubjectMatterExpert").className = 'labelRequired';
		}
	}
	}
	function disableImplementationNotificationsThreshold()
	{
		$(document).ready(function(){
			if($("#ImplementationNotificationsEnabledId").val() == 'No')
				{
					$("#ImplementationNotificationsThreshold").attr("disabled",true).val("");
				}
				else{
					$("#ImplementationNotificationsThreshold").attr("disabled",false);
				}
		});
	}

	function getTemplateFields()
	{
			var templateId=document.getElementsByName("TemplateOID")[0].value;
			var URL = "../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:getTemplateDetails&templateOID="+templateId;
	
			var responseText = emxUICore.getDataPost(URL);
       		responseText = responseText.replace(/(^[\s]+|[\s]+$)/g, '');
		    	
	    	var responseArray = responseText.split('|');
			document.emxCreateForm.Title.value=responseArray[0];
			document.emxCreateForm.Description.value=responseArray[1];
			document.emxCreateForm.ResponsibleOrganization.value=responseArray[2];
			document.emxCreateForm.ResponsibleOrganizationOID.value=responseArray[3];
			document.emxCreateForm.ResponsibleOrganizationDisplay.value=responseArray[2];
			document.emxCreateForm.PeriodicReviewInterval.value=responseArray[4];
			document.emxCreateForm.PeriodicReviewEnabled.value=responseArray[5];
			updatePRI(false);
			
	}

	

