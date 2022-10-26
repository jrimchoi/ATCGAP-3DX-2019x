
<%--  QuestionnaireCommonImportFS.jsp
  Copyright (c) 1992-2018 Dassault Systemes.
  All Rights Reserved.
  This program contains proprietary and trade secret information
  of MatrixOne, Inc.   Copyright notice is precautionary only and
  does not evidence any actual or intended publication of such program
--%>

<%--
This page imports the required classes and defines some commonly
used methods
--%>

<%@include file = "../emxUICommonAppInclude.inc"%>
<%@ include file = "../emxUICommonHeaderBeginInclude.inc"%>
<%@page import="com.matrixone.apps.domain.util.*"%>
<%@page import="matrix.db.Context"%>
<%@page import="matrix.util.StringList"%>
<%@page import="com.dassault_systemes.enovia.questionnaire.QuestionnaireConstants"%>
<%@page import="com.matrixone.apps.domain.util.XSSUtil"%>
<jsp:useBean id="formBean" scope="session" class="com.matrixone.apps.common.util.FormBean"/>

<%!
private String getHTMLString(Context context, String key) throws Exception {
	return XSSUtil.encodeForHTML(context,EnoviaResourceBundle.getProperty(context, QuestionnaireConstants.QUESTION_STRING_RESOURCE, context.getLocale(),key));
	
}
private String getString(Context context, String key) throws Exception {
	return XSSUtil.encodeForJavaScript(context,EnoviaResourceBundle.getProperty(context, QuestionnaireConstants.QUESTION_STRING_RESOURCE, context.getLocale(),key));
	
}
%>
<%
String strImport=(String)emxGetParameter(request,"import");
String strObjectId=(String)emxGetParameter(request,"objectId");

if(UIUtil.isNotNullAndNotEmpty(strImport)&&strImport.equals("true"))
{
	
 %>
		 	<html>
    	<head>
		  	<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script>
			<script language="JavaScript" src="../common/scripts/emxUICore.js"></script>
			<script language="JavaScript" src="../common/scripts/emxUICoreMenu.js"></script>
			<script language="JavaScript" src="../common/scripts/emxUIToolbar.js"></script>
			<script language="JavaScript" src="../common/scripts/emxUIFilterUtility.js"></script>
			<script language="JavaScript" src="../common/scripts/emxUIActionbar.js"></script>
			<script language="JavaScript" src="../common/scripts/emxUIModal.js"></script>
			<script language="JavaScript" src="../common/scripts/emxNavigatorHelp.js"></script>
			<script language="JavaScript" src="../emxUIPageUtility.js"></script>
			<script language="JavaScript" src="../common/scripts/emxUIBottomPageJavaScriptInclude.js"></script>
			<script language="JavaScript" type="text/JavaScript">
				addStyleSheet("emxUIDefault");    
				addStyleSheet("emxUIToolbar");    
				addStyleSheet("emxUIMenu");    
				addStyleSheet("emxUIDOMLayout");
				addStyleSheet("emxUIDialog");
			</script>
  		</head>
    	<body onload=turnOffProgress();>		
	    	<div id="pageHeadDiv">
	    		<form>
	    			<table>
						<tr>
							<td class="page-title"><h2 id="ph"><xss:encodeForHTML><%=EnoviaResourceBundle.getProperty(context, QuestionnaireConstants.QUESTION_STRING_RESOURCE, context.getLocale(),"enoQuestionnaire.Title.ImportQuestion")%></xss:encodeForHTML></h2></td>
							<td class="functions">
            					<table>
            						<tr>
           					 			<td class="progress-indicator"><div id="imgProgressDiv"></div></td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<jsp:include page = "../common/emxToolbar.jsp" flush="true">
					    <jsp:param name="toolbar" value=""/>
					    <jsp:param name="suiteKey" value="Components"/>
					    <jsp:param name="PrinterFriendly" value="false"/>
					    <jsp:param name="export" value="false"/>
					</jsp:include>
				</form>							
			</div>
			
			<div id='divPageBody'>
				<form name="ImportQuestion" action="QuestionnaireCommonImportFS.jsp" method="post" enctype="multipart/form-data" return false">
		 			<table border="0" width="100%">
		 		<tr>
		 		 <td class="labelRequired" width="20%" align="right" nowrap="nowrap">
                  <xss:encodeForHTML><%=EnoviaResourceBundle.getProperty(context, QuestionnaireConstants.QUESTION_STRING_RESOURCE, context.getLocale(),"enoQuestionnaire.Title.ImportFromFile")%></xss:encodeForHTML>
                </td>
		        <td class="field" width="80%"><input type="file" id="FilePath" name="FilePath" size="18" /><input type="hidden" id="objectId" name="objectId" value="<%=strObjectId%>"/></td>
		        
		       </tr>
		       <%-- <tr>
		 		 <td class="labelRequired" width="20%" align="right" nowrap="nowrap">
                 <%=getHTMLString(context, "Regulatory.Common.Title")%>
                </td>
		        <td class="field" width="80%"><input type="text" id="Title" name="Title" size="18" /></td>
		       </tr>
		        <tr>
		 		 <td class="labelRequired" width="20%" align="right" nowrap="nowrap">
                 <%=getHTMLString(context, "Regulatory.Common.Description")%>
                </td>
		        <td class="field" width="80%"><textarea  id="Description" name="Description"></textarea></td>
		       </tr> --%>
		  		</table>
			 </form>
			</div>
			<div id="divPageFoot">
				<div id="divDialogButtons">
				  <table width="100%" border="0" align="center" cellspacing="2" cellpadding="3">
					<tr>
					  <td align="right">
						<table border="0" cellspacing="0">
						  <tr>
							<td><div id="NextImage">
									<a href="javascript:submitForm()" class="button">
									<img src="../common/images/buttonDialogDone.gif" border="0" alt=""/>
								</a>
								</div>
							</td>
							<td>&nbsp;</td>
							<td><div id="NextText">
										<a href="javascript:submitForm()" class="button">
										<%=getHTMLString(context, "Questionnaire.Button.Done")%>
									</a>
								</div>
							</td>
			                <td>&nbsp;&nbsp;</td>
						  	<td>
								<div id="CloseImage">
									<a href="javascript:cancel()" class="button">
										<img src="../common/images/buttonDialogCancel.gif" border="0" alt=""/>
									</a>
								</div>
							</td>
							<td>&nbsp;</td>
							<td>
								<div id="CloseText">
									<a href="javascript:cancel()" class="button">
										<%=getHTMLString(context, "Questionnaire.Button.Cancel")%>
									</a>
								</div>
							</td>
						  </tr>
			
						</table>
					  </td>
					</tr>
				  </table>
				</div>			
    	</body>
   	</html>
   	<script>
   	function cancel()
   	{
   		top.close();
   	}
	function submitForm()
   	{
		var vFilePath=document.getElementById("FilePath").value;
		if(vFilePath=='')
		{
			alert("<%=getString(context, "enoQuestionnaire.Message.FilePathRequired")%>");
		}
		else
		{	
	      var uploadForm = document.getElementsByName("ImportQuestion")[0];
          uploadForm.encoding = "multipart/form-data";
          uploadForm.submit ();
		}
   	}
   	</script>
<%
	}
else
{
		 formBean.processForm(session, request);
		 Map parameterMap = new HashMap();
		parameterMap.put("FilePath",formBean.getElementValue("FilePath"));
		parameterMap.put("objectId",formBean.getElementValue("objectId"));
		
		// Collect all the parameters
		Enumeration paramEnum = emxGetParameterNames(request);
		while (paramEnum.hasMoreElements()) {
			String parameter = (String) paramEnum.nextElement();
			String[] values = emxGetParameterValues(request, parameter);
			parameterMap.put(parameter, values);
		}
		String[] args = JPO.packArgs(parameterMap);
		String jsFunctionCall = (String) JPO.invoke(context, "ENOQuestionnaireAdminActions", args,
				"preProcessImportQuestions", args, String.class);
		 Map parameterMap1 = new HashMap();
		 String strURl="../questionnaire/ExecutePostActions.jsp";
%>

	<jsp:include page="<%=strURl%>"></jsp:include>
		<script type="text/javascript">
		<%=(jsFunctionCall != null)?jsFunctionCall:""%>
	</script>
<%
	}
%>
