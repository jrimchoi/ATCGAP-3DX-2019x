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
String strAlertDate = EnoviaResourceBundle.getProperty(context, "enoQuestionnaireStringResource", context.getLocale(), "enoQuestionnaire.ConfirmMessage.CompleteEForm");

%>
<script type="text/javascript" src="../common/scripts/emxUIFormHandler.js"></script>
  	<script language=javascript>
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
				alert("<%=strAlertDate%>");
				return false;
    		}
    	}
	
 return true;
	}
	</script>

