
<%--  MedDRADictionaryUploadCustomCreateFS.jsp
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

<%@include file="../emxUICommonAppInclude.inc"%>
<%@ include file="../emxUICommonHeaderBeginInclude.inc"%>
<%@page import="com.dassault_systemes.enovia.dataimport.Helper"%>
<%@page import="matrix.db.Context"%>
<%@page import="matrix.util.StringList"%>
<%@page import="com.dassault_systemes.enovia.dataimport.DIMPException"%>
<%@page import="com.matrixone.apps.domain.Job"%>
<jsp:useBean id="formBean" scope="session"
	class="com.matrixone.apps.common.util.FormBean" />

<%!
private String getString(Context context, String key) throws DIMPException {
	try {
		return XSSUtil.encodeForHTML(context,Helper.getI18NString(context, "emxDIMPStringResource", key));
	} catch (Exception e) {
		throw new DIMPException(e);
	}
}
%>
<%
String strImport=(String)emxGetParameter(request,"import");
if(UIUtil.isNotNullAndNotEmpty(strImport)&&strImport.equals("true"))
{
 %>
<html>
<head>
</head>
<body onload=turnOffProgress();>
	<div id="pageHeadDiv">
		<form>
			<table>
				<tr>
					<td class="page-title"><h2 id="ph">
							<xss:encodeForHTML><%=getString(context, "DIMP.Label.ImportData")%></xss:encodeForHTML>
						</h2></td>
				</tr>
			</table>
		</form>
	</div>

	<div id='divPageBody'>
		<form name="ImportData" action="ImportDataCustom.jsp" method="post"
			enctype="multipart/form-data">
			<table border="0" width="100%">
				<tr>
					<td class="labelRequired" width="20%" align="right" nowrap="nowrap">
						<xss:encodeForHTML><%=getString(context, "DIMP.Form.Label.Directory")%></xss:encodeForHTML>
					</td>
					<td class="field" width="80%"><input type="file" id="FilePath"
						name="FilePath" size="18" /></td>
				</tr>
				<tr>
					<td width="20" align="left" width="20%" nowrap="nowrap"><xss:encodeForHTML>&nbsp;&nbsp;<%=getString(context, "DIMP.Form.Label.Notification")%></xss:encodeForHTML>
					</td>
					<td class="field" width="80%"><input type="textarea"
						id="EmailIds" name="EmailIds" size="18" /></td>
				</tr>
				<tr>
					<td><input type="hidden" id="app" name="app"
						value=<%=(String)emxGetParameter(request,"application")%> /></td>
				</tr>
			</table>
		</form>
	</div>
	<div id="divPageFoot">
		<div id="divDialogButtons">
			<table width="100%" border="0" align="center" cellspacing="2"
				cellpadding="3">
				<tr>
					<td align="right">
						<table border="0" cellspacing="0">
							<tr>
								<td><div id="NextImage">
										<a href="javascript:submitForm()" class="button"> <img
											src="../common/images/buttonDialogDone.gif" border="0" alt="" />
										</a>
									</div></td>
								<td>&nbsp;</td>
								<td><div id="NextText">
										<a href="javascript:submitForm()" class="button"> <%=getString(context, "DIMP.Button.Done")%>
										</a>
									</div></td>
								<td>&nbsp;&nbsp;</td>
								<td>
									<div id="CloseImage">
										<a href="javascript:cancel()" class="button"> <img
											src="../common/images/buttonDialogCancel.gif" border="0"
											alt="" />
										</a>
									</div>
								</td>
								<td>&nbsp;</td>
								<td>
									<div id="CloseText">
										<a href="javascript:cancel()" class="button"> <%=getString(context, "DIMP.Button.Cancel")%>
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
   		getTopWindow().window.closeSlideInDialog();
   	}
   	
	function submitForm()
   	{
		var emailStr = document.getElementsByName("EmailIds")[0].value;
		var validiateEmailIds = "";
		if(emailStr != null && emailStr != ""){
		validiateEmailIds = emailStr.split(",");
			for(i=0;i<=validiateEmailIds.length-1;i++) {
	        	var AtPos = validiateEmailIds[i].lastIndexOf("@");
				var DotPos= validiateEmailIds[i].lastIndexOf(".");
				if(!((AtPos>0)&&(DotPos>0)&&(AtPos<DotPos))) {
					alert("<%=getString(context, "DIMP.Message.InvalidEmailId")%>");
				}
			}
		}
		var vFilePath=document.getElementById("FilePath").value;
		if(vFilePath=='')
		{
			alert("<%=getString(context, "DIMP.Message.FilePathRequired")%>");
		}
		else
		{	
	      var uploadForm = document.getElementsByName("ImportData")[0];
          uploadForm.encoding = "multipart/form-data";
          uploadForm.submit();
		}
   	}
   	</script>
<%
	}
else
{
		formBean.processForm(session, request);
		Map parameterMap = new HashMap();
		
		String dimpWebAppPath = getServletConfig().getServletContext().getRealPath("/DIMP");
		
		parameterMap.put("dimpWebAppPath",dimpWebAppPath);
		parameterMap.put("FilePath",formBean.getElementValue("FilePath"));
		parameterMap.put("EmailIds",formBean.getElementValue("EmailIds"));
		parameterMap.put("application",formBean.getElementValue("app"));
		
		String[] args = JPO.packArgsRemote(parameterMap);
		String validateResult = JPO.invoke(context, "com.dassault_systemes.enovia.dataimport.ui.ImportData", null, "validateImportXML", args, String.class);
		
		if(!Helper.isNullOrEmpty(validateResult)) {
			%><script>alert("<%=XSSUtil.encodeForJavaScript(context,validateResult)%>");</script><%
		}
		else{
		Job job = new Job("com.dassault_systemes.enovia.dataimport.ui.ImportData", "importDataToEnovia", args);
		
        %>
<script>alert("<%=getString(context, "DIMP.Message.ImportInProcessMessage")%>")</script>
<%
		job.createAndSubmit(context);
		}%>
<script>getTopWindow().window.closeSlideInDialog();</script>
<%
	}
%>
