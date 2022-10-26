
<%@page import="com.dassault_systemes.enovia.periodicreview.PeriodicReviewConstants"%>
<%@page import="com.matrixone.apps.framework.ui.UINavigatorUtil"%>
<%--  enoDCLCreateFormValidation.jsp

  Copyright (c) 1992-2018 Dassault Systemes.
  All Rights Reserved.
  This program contains proprietary and trade secret information of MatrixOne,
  Inc.  Copyright notice is precautionary only
  and does not evidence any actual or intended publication of such program

   static const char RCSID[] = "$Id: emxJSValidation.jsp.rca 1.1.5.4 Wed Oct 22 15:48:43 2008 przemek Experimental przemek $";
--%>
<%@include file = "../common/emxNavigatorInclude.inc"%>
<%
String strAlertMsg = EnoviaResourceBundle.getProperty(context, PeriodicReviewConstants.PERIODIC_REVIEW_STRING_RESOURCE, context.getLocale(), "enoPeriodicReview.Alert.Msg.SelectOrganization");
String strAlertMsgInterval = EnoviaResourceBundle.getProperty(context, PeriodicReviewConstants.PERIODIC_REVIEW_STRING_RESOURCE, context.getLocale(), "enoPeriodicReview.Alert.Msg.PeriodicReviewInterval");
String strSMEAlert = EnoviaResourceBundle.getProperty(context, PeriodicReviewConstants.PERIODIC_REVIEW_STRING_RESOURCE, context.getLocale(), "enoPeriodicReview.Alert.Msg.SMESelect");
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
	  var fieldPeriodicRevEnabled = objForm.elements["PeriodicReviewEnabled"].value;
	  var fieldRespOrg = objForm.elements["ResponsibleOrganization"].value;
	  var selectedType1 = objForm.elements["Type"].value;
	  selectedType=ReplaceAll(selectedType1," ","");
	  if(fieldPeriodicRevEnabled == 'No')
	  {
		document.getElementById("calc_SubjectMatterExpert").className = 'createLabel';
		document.getElementById("calc_SubjectMatterExpert").children[0].className = 'createLabel';
		document.getElementById("calc_PeriodicReviewInterval").classList.remove("labelRequired");

		document.editDataForm.PeriodicReviewEnabled.value=fieldPeriodicRevEnabled;
		document.editDataForm.PeriodicReviewEnabledfieldValue.value=fieldPeriodicRevEnabled;
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
		   document.getElementById("calc_PeriodicReviewInterval").className = 'labelRequired';
		  document.editDataForm.PeriodicReviewEnabled.value=fieldPeriodicRevEnabled;
		  document.editDataForm.PeriodicReviewEnabledfieldValue.value=fieldPeriodicRevEnabled;
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
			  var propertKeyGen= selectedType+"."+fieldRespOrg+"."+"ReviewInterval";
			  var xmlhttp;
			  if (window.XMLHttpRequest)
			  {// code for IE7+, Firefox, Chrome, Opera, Safari
				  xmlhttp=new XMLHttpRequest();
			  }
			  else
			  {// code for IE6, IE5
				 xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
			  }
			  var URL = "../periodicreview/enoPRExecute.jsp?prAction=ENOPeriodicReviewUI:getPeriodicReviewInterval&propertyKey="+propertKeyGen;
			  var responseText = emxUICore.getDataPost(URL);
			  responseText = responseText.replace(/(^[\s]+|[\s]+$)/g, '');
			  document.editDataForm.PeriodicReviewInterval.value=responseText;
			  document.editDataForm.PeriodicReviewIntervalfieldValue.value=responseText;
		  }
	  }
	}
	function getData(url){
		var xmlhttp;
		  if (window.XMLHttpRequest)
		  {// code for IE7+, Firefox, Chrome, Opera, Safari
			  xmlhttp=new XMLHttpRequest();
		  }
		  else
		  {// code for IE6, IE5
			 xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
		  }
		  //var URL = "../periodicreview/enoPRExecute.jsp?prAction=ENOPeriodicReviewUI:getPeriodicReviewInterval&propertyKey="+propertKeyGen;
		  var responseText = emxUICore.getDataPost(url);
		  responseText = responseText.replace(/(^[\s]+|[\s]+$)/g, '');
		  return responseText;
	}
	function hideSMEAndIntervalFields()
	{
		document.getElementById('calc_Type').style.display = 'none';
		document.getElementById('Type').style.display = 'none';
		document.getElementById('calc_ResponsibleOrganization').style.display = 'none';
		document.getElementById('ResponsibleOrganization').style.display = 'none';
		
		var select = document.getElementById("PeriodicReviewEnabledId");
		if(select == undefined){	//object is in released state
			document.getElementById("calc_SubjectMatterExpert").className = 'labelRequired';
			document.getElementById("calc_PeriodicReviewInterval").className = 'labelRequired';

		}
		else {
			var value = select.options[0].value
			if(value != "Yes" || value != "No")
				select.remove(0);
			var periodicEnabled = document.editDataForm.PeriodicReviewEnabled.value;
			if (periodicEnabled == "Yes"){
				document.getElementById("calc_SubjectMatterExpert").className = 'labelRequired';
				document.getElementById("calc_PeriodicReviewInterval").className = 'labelRequired';

			}
			else	//if PR Enabled = No or Blank(if interface not present on object)
			{
				document.editDataForm.PeriodicReviewInterval.disabled=true;
				document.editDataForm.PeriodicReviewInterval.value="";
			  	document.editDataForm.PeriodicReviewIntervalfieldValue.value="";
		     	document.editDataForm.SubjectMatterExpertDisplay.disabled=true;
		     	document.editDataForm.SubjectMatterExpertDisplay.value="";
		     	document.editDataForm.SubjectMatterExpert.value="";
			  	document.editDataForm.SubjectMatterExpertOID.value="";
			    document.editDataForm.btnSubjectMatterExpert.disabled=true;
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
	function updatePeriodicIntervalFields()
	{
		var actualIntervalField = document.editDataForm.PeriodicReviewInterval.value;
		document.editDataForm.PeriodicReviewInterval.value = actualIntervalField;
	    document.editDataForm.PeriodicReviewIntervalfieldValue.value=actualIntervalField;
	}
	function enableOrDisableFields()
        {
		var vImplementationDate = document.getElementById("calc_Implementation Date");
		var vImplementationPeriod= document.getElementById("calc_Implementation Period");
           
		vImplementationDate.style.display = 'none';
		vImplementationPeriod.style.display = 'none';
         
        }	
	function hideFieldCreate()
	{
    	document.getElementById("CreateId").disabled = true;
	}
	function addFields()
	{
		var objForm = document.forms[0];
		var fieldPeriodicReviewDisposition = objForm.elements.PeriodicReviewDisposition[0].checked;
		if(true == fieldPeriodicReviewDisposition )
		  {
			document.getElementById("CreateId").value = "";
	 		document.getElementById("CreateId").disabled = true;
		  }
		  
		if(false == fieldPeriodicReviewDisposition)
		  {
	    	document.getElementById("CreateId").disabled = false;
		  }
	}
	
	function disablePeriodicReviewFields(disable,objId)
	{
		if(document.editDataForm.PeriodicReviewInterval)
			document.editDataForm.PeriodicReviewInterval.disabled=disable;
		
		if(document.editDataForm.PeriodicReviewEnabled)
			document.editDataForm.PeriodicReviewEnabled.disabled=disable;
		
		var URL = "../periodicreview/enoPRExecute.jsp?prAction=ENOPeriodicReviewUI:getSubjectMatterExpertOfTemplate&selTemplateId="
							+ objId;
		var responseText = emxUICore.getDataPost(URL);
		responseText=responseText.trim();
		var arrResp=responseText.split("|");
		document.editDataForm.SubjectMatterExpertDisplay.value=arrResp[0];
		document.editDataForm.SubjectMatterExpert.value=arrResp[0];
     	document.editDataForm.SubjectMatterExpertOID.value=arrResp[1];
	}
	</script>
	

