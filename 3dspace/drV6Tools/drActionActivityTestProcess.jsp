<%--
  drActionActivityTestProcess.jsp
  Copyright (c) 1993-2015 Dassault Systemes.
  All Rights Reserved.
  This program contains proprietary and trade secret information of
  Dassault Systemes.
  Copyright notice is precautionary only and does not evidence any actual
  or intended publication of such program
--%> 

<%@include file="../common/emxNavigatorTopErrorInclude.inc"%>
<%@include file="../common/emxCompCommonUtilAppInclude.inc"%>
<%@include file="../emxUICommonAppInclude.inc"%>
<%@include file="../common/emxFormConstantsInclude.inc"%>
<%@page import="com.designrule.drv6tools.activities.actions.drActionActivity"%>
<%@page import="com.designrule.drv6tools.drlToolsEnoviaObject"%>
<%@page import="com.designrule.drv6tools.common.drContext"%>
<%@page import="com.designrule.drv6tools.common.drBusinessObject"%>
<%@page import="com.designrule.drv6tools.drToolsRunOnObject"%>
<%@page import="com.designrule.drv6tools.activities.actions.drActionResultObject"%>
<%@page import="com.designrule.drv6tools.activities.actions.drActionActivityTestResult"%>

<%
try
{
	String startObjectOID = request.getParameter("StartObjectOID");
	drlToolsEnoviaObject toolsEnoviaObject = new drlToolsEnoviaObject(context);
	drContext drcontext = (drContext)toolsEnoviaObject;
	startObjectOID = drcontext.getResultFromMQLCommand("print bus " + startObjectOID + " select id dump |", true);
	String environmentVariables = request.getParameter("EnvironmentVariables");
	String actionActivityId = emxGetParameter(request,"ActionActivityId"); 
	drActionActivity actionActivity = new drActionActivity(toolsEnoviaObject,actionActivityId);
	//Set env variables
	actionActivity.setTestEnvironmentVariables(environmentVariables);
	
	drBusinessObject sourceObject = new drBusinessObject(drcontext,startObjectOID);
	drToolsRunOnObject runOnObject = new drToolsRunOnObject(sourceObject);
	drActionResultObject resultObject = actionActivity.runActionActivty(runOnObject);
	drActionActivityTestResult actionActivityTestResult = new drActionActivityTestResult(drcontext,resultObject);
%>

<html style="background:#FFFFFF;">
	<head>
		<title>Test Results</title>
		<script src="../common/scripts/jquery-latest.js"></script>
		<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
		<script language="JavaScript" src="../common/scripts/emxAdminUtils.js" type="text/javascript"></script>
		<link rel="stylesheet" href="../common/styles/emxUIDefault.css" />
		<link rel="stylesheet" href="../common/styles/emxUIProperties.css" />
		<link rel="stylesheet" href="../common/styles/emxUIForm.css" />
		<link rel="stylesheet" href="../common/styles/emxUIList.css" />
		<style>
			div#divPageFoot,
			div#pageHeadDiv {
				position:fixed;
			}
		</style>	
		<script type="text/javascript">
			function closeAssignWindow(){
				if (typeof window !== 'undefined' && window.closeWindow) {
					if(window.closeWindow()){
						window.closeWindow();
					}
				}else{
					top.close();
				}
			}			
		</script>		
	</head>
	<body>		
		<div id="pageHeadDiv">
			<table>
				<tbody>
					<tr>
						<td class="page-title">
							<h2>Test Results</h2>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div id="runTestDiv" style="padding-top:40px;padding-bottom:40px;">
			<form nsubmit="return false;" method="post" name="runTestForm" id="runTestForm">
				<table>	
					<tr>
						<td class="field" width="20"><img width="16" height="16" src="../common/images/<%=actionActivityTestResult.getOverallStatus()%>" border="0" alt=""/></td>
						<% if(actionActivityTestResult.getFailMessage().isEmpty()){%>
						<td class="field">'<%=actionActivity.getName()%>' action completed successfully</td>
						<%}else{%>
							<td class="field">'<%=actionActivity.getName()%>' action returned failure. Please see below logs.</td>
							<td class="field"><pre><span class="inner-pre"><%=actionActivityTestResult.getFailMessage()%></span><pre></td>
						<%}%>
					</tr>
				</table>
				<table>	
					<tr>
						<td class="label" style="padding-left:10px" width="150" ><b>Level</b></td>
						<td class="label" width="150"><b>Action Name</b></td>
						<td class="label" width="150"><b>Status</b></td>
						<td class="label" width="150"><b>Action Type</b></td>
						<td class="label" width="150"><b>Log</b></td>
						<td class="label" width="150"><b>Action Activity</b></td>
						<td class="label" width="150"><b>Current Object</b></td>
						<td class="label" width="150"><b>Source Object</b></td>
						<td class="label" width="150"><b>Parent Object</b></td>
					</tr>
					<%
					String objectId = "";
					String treeURL = "../common/emxTree.jsp?objectId=";
					String link = "";
					for(drActionActivityTestResult testResult : actionActivityTestResult.getTestResults()){
					%>
					<tr>
						<td class="field" style="padding-left:10px" nowrap width="150"><%=testResult.getLevel()%></td>
						<td class="field" width="150"><%=testResult.getActionName()%></td>
						<td class="field" width="150"><img width="16" height="16"  src="../common/images/<%=testResult.getStatus()%>" border="0" alt=""/></td>
						<td class="field" width="150"><%=testResult.getActionType()%></td>
						<td class="field"><pre><span class="inner-pre"><%=testResult.getLogMessage()%></span><pre></td>
						<%
						objectId = testResult.getActionActivityId();
						if(!objectId.isEmpty()){
							link = treeURL + objectId;
						%>
						<td class="field" width="150"><a style='text-decoration: none !important;' href="javascript:showNonModalDialog('<%=link%>',575,575)"><%=testResult.getActionActivityName()%></a></td>
						<%}else{%>
							<td class="field" width="150"><%=testResult.getActionActivityName()%></td>
						<%}
						objectId = testResult.getCurrentObjectId();
						if(!objectId.isEmpty()){
							link = treeURL + objectId;
						%>
						<td class="field" width="150"><a style='text-decoration: none !important;' href="javascript:showNonModalDialog('<%=link%>',575,575)"><%=testResult.getCurrentObjectName()%></a></td>
						<%}else{%>
							<td class="field" width="150"><%=testResult.getCurrentObjectName()%></td>
						<%}
						objectId = testResult.getSourceObjectId();
						if(!objectId.isEmpty()){
							link = treeURL + objectId;
						%>
						<td class="field" width="150"><a style='text-decoration: none !important;' href="javascript:showNonModalDialog('<%=link%>',575,575)"><%=testResult.getSourceObjectName()%></a></td>
						<%}else{%>
							<td class="field" width="150"><%=testResult.getSourceObjectName()%></td>
						<%}
						objectId = testResult.getParentObjectId();
						if(!objectId.isEmpty()){
							link = treeURL + objectId;
						%>
						<td class="field" width="150"><a style='text-decoration: none !important;' href="javascript:showNonModalDialog('<%=link%>',575,575)"><%=testResult.getParentObjectName()%></a></td>
						<%}else{%>
							<td class="field" width="150"><%=testResult.getParentObjectName()%></td>
						<%}%>
					</tr>
					<%}%>
				</table>
			</form>
		</div>	
		<div id="divPageFoot">
			<div id="divDialogButtons">
				<table>
					<tbody>
						<tr>
							<td class="buttons">
								<table>
									<tbody>
										<tr>								
											<td><a onclick="closeAssignWindow()" href="javascript:void(0)"><button class="btn-default" type="button">Close</button></a></td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>		
	</body>
</html>
<%	
}catch(Exception ex){
    if (ex.toString() != null && (ex.toString().trim()).length() > 0){
        emxNavErrorObject.addMessage(ex.toString().trim());
    }
}
%>

<%@include file="../common/emxNavigatorBottomErrorInclude.inc"%>
