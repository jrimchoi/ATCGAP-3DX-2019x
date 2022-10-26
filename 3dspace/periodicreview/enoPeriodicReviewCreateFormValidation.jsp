
<%@page import="com.dassault_systemes.enovia.periodicreview.PeriodicReviewConstants"%>
<%--  enoDCLCreateFormValidation.jsp

  Copyright (c) 1992-2018 Dassault Systemes.
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
String strAlertMsg = EnoviaResourceBundle.getProperty(context, PeriodicReviewConstants.PERIODIC_REVIEW_STRING_RESOURCE, context.getLocale(), "enoPeriodicReview.Alert.Msg.SelectOrganization");
String strAlertMsgInterval = EnoviaResourceBundle.getProperty(context, PeriodicReviewConstants.PERIODIC_REVIEW_STRING_RESOURCE, context.getLocale(), "enoPeriodicReview.Alert.Msg.PeriodicReviewInterval");
String strSMEAlert = EnoviaResourceBundle.getProperty(context, PeriodicReviewConstants.PERIODIC_REVIEW_STRING_RESOURCE, context.getLocale(), "enoPeriodicReview.Alert.Msg.SMESelect");
%>
  
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
	function disablePeriodicReviewInterval()
	{
	  var objForm = document.forms[0];
	  var selectedType =null;
	  var fieldPeriodicRevInterval = objForm.elements["PeriodicReviewInterval"].value
	  var fieldPeriodicRevEnabled = objForm.elements["PeriodicReviewEnabled"].value;
	  var fieldRespOrg = objForm.elements["ResponsibleOrganizationDisplay"].value;
	  var pathArray = window.location.href.split('&');
	  
	  if(!contains(pathArray,'DCMode=createdocumenttemplate')){
	  	var fieldTemplate = objForm.elements["TemplateDisplay"].value;
	  	var templateId=document.getElementsByName("TemplateOID")[0].value;
	  }
	  
	  fieldRespOrg = ReplaceAll(fieldRespOrg," ","");   
		  if((objForm.TypeActual[0] != null))
		  {
			    	selectedType = objForm.TypeActual[0].value;
		  }
	      else
		  {
			selectedType = objForm.TypeActual.value;
		  }
		  selectedType = ReplaceAll(selectedType," ","");
	 
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
		  else{
		          document.getElementById("calc_SubjectMatterExpert").className = 'labelRequired';
			  document.getElementById("calc_PeriodicReviewInterval").className = 'labelRequired';
		  	  document.emxCreateForm.PeriodicReviewInterval.disabled=false;
		  	  document.emxCreateForm.SubjectMatterExpertDisplay.disabled=false;
		  	  document.emxCreateForm.btnSubjectMatterExpert.disabled=false;
		  
		   if(fieldPeriodicRevInterval == "")
		  	{ 
			  if(fieldRespOrg == "" && fieldTemplate != "")
			  {
			    var respOrgAlert = "<%=strAlertMsg %>"; /* XSSOK */
			    alert(respOrgAlert);
			    return false;
			  }
			  else if(fieldRespOrg != "")
			  {
			      var propertKeyGen= selectedType+"."+fieldRespOrg+"."+"ReviewInterval";
		              var URL = "../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:getPeriodicReviewInterval&propertyKey="+propertKeyGen;
			      var responseText = emxUICore.getDataPost(URL);
			      responseText = responseText.replace(/(^[\s]+|[\s]+$)/g, '');
			      document.emxCreateForm.PeriodicReviewInterval.value=responseText;
			  }
			}
		if(fieldPeriodicRevInterval != ""){
			if(fieldRespOrg == "")
				document.emxCreateForm.PeriodicReviewInterval.value="";
			else{
				if(fieldTemplate == ""){
				var propertKeyGen= selectedType+"."+fieldRespOrg+"."+"ReviewInterval";
				var URL = "../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:getPeriodicReviewInterval&propertyKey="+propertKeyGen;
				var responseText = emxUICore.getDataPost(URL);
				responseText = responseText.replace(/(^[\s]+|[\s]+$)/g, '');
				document.emxCreateForm.PeriodicReviewInterval.value=responseText;
				}
				else{
				var URL = "../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:getTemplaterespOrg&templateId="+templateId;
				var responseText = emxUICore.getDataPost(URL);
				responseText = responseText.replace(/(^[\s]+|[\s]+$)/g, '');
				if(responseText != fieldRespOrg){
					var propertKeyGen= selectedType+"."+fieldRespOrg+"."+"ReviewInterval";
					var URL = "../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:getPeriodicReviewInterval&propertyKey="+propertKeyGen;
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
	function hideSMEAndIntervalFields()
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
	}
	 function makeSMERequired()
	{
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
	  selectedType = ReplaceAll(selectedType," ","");
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
		      var propertKeyGen= selectedType+"."+fieldRespOrg+"."+"ReviewInterval";
			  var language= '<xss:encodeForURL><%=strLanguage %></xss:encodeForURL>';
			  var URL = "../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:getPeriodicReviewInterval&propertyKey="+propertKeyGen+"&language="+language;
			  var responseText = emxUICore.getDataPost(URL);
			 responseText = responseText.replace(/(^[\s]+|[\s]+$)/g, '');
			  document.emxCreateForm.PeriodicReviewInterval.value=responseText;
		  }
	  }
	}
