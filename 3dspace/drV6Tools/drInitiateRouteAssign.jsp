<%--
  drInitiateRouteAssign.jsp
  Copyright (c) 1993-2015 Dassault Systemes.
  All Rights Reserved.
  This program contains proprietary and trade secret information of
  Dassault Systemes.
  Copyright notice is precautionary only and does not evidence any actual
  or intended publication of such program
--%>

<%-- Common Includes --%>
<%@include file="../common/emxNavigatorTopErrorInclude.inc"%>
<%@include file="../common/emxCompCommonUtilAppInclude.inc"%>
<%@include file="../emxUICommonAppInclude.inc"%>

<%@page import="com.matrixone.apps.domain.util.XSSUtil"%>
<%@page import="matrix.db.Context"%>
<%@page import="com.designrule.drv6tools.common.drContext"%>
<%@page import="com.designrule.drv6tools.route.drRouteUtil"%>
<%@page import="com.designrule.drv6tools.route.drInitiateRouteResult"%>
<%@page import="com.designrule.drv6tools.route.drRouteTemplateBusinessObject"%>
<%@page import="com.designrule.drv6tools.route.drRouteTask"%>
<%@page import="com.designrule.drv6tools.route.drRouteTaskAssignee"%>
<%@page import="com.designrule.drv6tools.route.drRouteTasks"%>
<%@page import="com.designrule.drv6tools.route.drRouteTaskAssignees"%>
<%@page import="com.designrule.drv6tools.common.drBusinessObject"%>
<%@page import="com.designrule.drv6tools.common.drBusinessObjects"%>
<%@page import="com.designrule.drv6tools.debug.drLogger"%>
<%@page import="org.apache.log4j.Logger"%>

<%
final Logger log = drLogger.getLogger(this.getClass());
try{
	String templateName = request.getParameter("templateName");
	String objectId = request.getParameter("objectId");
	String templateId = request.getParameter("templateId");
	String routeDescription = request.getParameter("routeDescription");
	String emxTableRowId = request.getParameter("emxTableRowId");
	String createFormHeaderText = request.getParameter("CreateFormHeaderText");
	String createFormTemplateLabelText = request.getParameter("CreateFormTemplateLabelText");
	String isOneRoutePerObject = request.getParameter("isOneRoutePerObject");
	String isAutoStart = request.getParameter("isAutoStart");
	String initialteRouteActivityID = request.getParameter("initialteRouteActivityID");
	HashMap requestMap 	= UINavigatorUtil.getRequestParameterMap(pageContext);
	
	//parameterMap will be used to validate route content before creating any route
	Map<String, String[]> parameterMap = request.getParameterMap();
	drRouteUtil routeUtil=new drRouteUtil(context,parameterMap);
	drRouteTemplateBusinessObject routeTemplateBusinessObject=routeUtil.getRouteTemplateBusinessObject(JPO.packArgs(requestMap));
	String userName=context.getUser();
	
	//START : Redirect to error report dialog if any failure while running validations
	if(routeTemplateBusinessObject.isAbortProcess()){
	%>	
		<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
		<script language="javascript" src="../common/scripts/emxUICore.js"></script>
		<script language="javascript" src="../common/scripts/emxUIModal.js"></script>
		<script type="text/javascript">
			showNonModalDialog("../drV6Tools/drErrorReportDialog.jsp");
			if (typeof window !== 'undefined' && window.closeWindow) {
				if(window.closeWindow()){
					window.closeWindow();
				}else{
					getTopWindow().closeSlideInDialog();
				}
			}else{
				getTopWindow().closeSlideInDialog();
			}
		</script>
	<%	return;
	}
	//END : Redirect to error report dialog if any failure while running validations
	%>

	<html style="background:#FFFFFF;">
		<head>
			<title>Assign Tasks</title>
			<script src="../common/scripts/jquery-latest.js"></script>
			<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
			<script language="JavaScript" src="../common/scripts/emxUIConstants.js" type="text/javascript"></script>
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
				if (!String.prototype.startsWith) {
				  String.prototype.startsWith = function(searchString, position) {
					position = position || 0;
					return this.indexOf(searchString, position) === position;
				  };
				}		
				function submitData(createRoute) {
					var canProceed=true;
					var assigneeAlertMsg="";
					$('.inputField').each(function() {
						var optional=$(this).attr('optional');
						var disabled=$(this).prop('disabled');
						var name=$(this).attr('name');
						$(this).find('option:selected').each(function(){;
							var element = $(this);
							if (disabled == false && optional === "false" && element.val().startsWith("role_")) {
								assigneeAlertMsg+=name+", ";  
								canProceed=false;
							}
						});
					}); 
					if(canProceed){
						if (jsDblClick()) {
							var objform = document.forms['assignRouteForm'];
							objform.action = "drInitiateRouteAssignProcess.jsp";
							objform.submit();
						}else{
							alert("Your previous request is in process, please wait...");
						}					
					}else{
						alert("Please select assignee for "+assigneeAlertMsg);
					}
				}

				function closeAssignWindow(){
					if (typeof window !== 'undefined' && window.closeWindow) {
						if(window.closeWindow()){
							window.closeWindow();
						}else{
							getTopWindow().closeSlideInDialog();
						}
					}else{
						getTopWindow().closeSlideInDialog();
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
								<h2><%=createFormHeaderText%></h2>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div id="createRouteDiv" style="padding-top:40px;padding-bottom:40px;">
				<form nsubmit="return false;" method="post" name="assignRouteForm" id="assignRouteForm">
				<input type="hidden" value ='<xss:encodeForHTMLAttribute><%=emxTableRowId%></xss:encodeForHTMLAttribute>' name ="emxTableRowId" id = "emxTableRowId" />
				<input type="hidden" value ='<xss:encodeForHTMLAttribute><%=templateId%></xss:encodeForHTMLAttribute>' name ="templateId" id = "templateId" />
				<input type="hidden" value ='<xss:encodeForHTMLAttribute><%=objectId%></xss:encodeForHTMLAttribute>' name ="objectId" id = "objectId" />
				<input type="hidden" value ='<xss:encodeForHTMLAttribute><%=templateName%></xss:encodeForHTMLAttribute>' name ="templateName" id = "templateName" />
				<input type="hidden" value ='<xss:encodeForHTMLAttribute><%=routeDescription%></xss:encodeForHTMLAttribute>' name ="routeDescription" id = "routeDescription" />
				<input type="hidden" value ='<xss:encodeForHTMLAttribute><%=createFormTemplateLabelText%></xss:encodeForHTMLAttribute>' name ="CreateFormTemplateLabelText" id = "CreateFormTemplateLabelText" />
				<input type="hidden" value ='<xss:encodeForHTMLAttribute><%=createFormHeaderText%></xss:encodeForHTMLAttribute>' name ="CreateFormHeaderText" id = "CreateFormHeaderText" />
				<input type="hidden" value ='<xss:encodeForHTMLAttribute><%=isOneRoutePerObject%></xss:encodeForHTMLAttribute>' name ="isOneRoutePerObject" id = "isOneRoutePerObject" />
				<input type="hidden" value ='<xss:encodeForHTMLAttribute><%=isAutoStart%></xss:encodeForHTMLAttribute>' name ="isAutoStart" id = "isAutoStart" />
				<input type="hidden" value ='<xss:encodeForHTMLAttribute><%=initialteRouteActivityID%></xss:encodeForHTMLAttribute>' name ="initialteRouteActivityID" id = "initialteRouteActivityID" />
					<table>	
						<tr>
						<tr>
							<td class="labelRequired" width="150"><%=createFormTemplateLabelText%></td>
							<td class="inputField"><text id='routeTemplateName' name="routeDescription" cols="40" rows="5"><%=templateName%></text></td>
						</tr>	
						<tr>
							<td class="label" width="150">Route Description</td>
							<td class="inputField"><text id='routeDescription' name="routeDescription" cols="40" rows="5"><%=routeDescription%></text></td>
						</tr>
						<tr>
							<td class="label" width="150" style="background-color: #b2b2ff;font-weight:bold;">Task</td>
							<td class="inputField" style="background-color: #b2b2ff;font-weight:bold;"><text id='routeAssignee' name="routeAssignee" cols="40" rows="5">Assignee</text></td>
						</tr>					
						<% 
						String className;
						String taskTitle;
						for(drRouteTask routeTask:routeTemplateBusinessObject.getRouteTasks()){%>
						<tr>
						<% 
						className="labelRequired";
						if(routeTask.isOptional()){
							className="label";
						}
						taskTitle=routeTask.getRouteNode().getTitle();
						if(routeTemplateBusinessObject.isShowTaskSequence()){
							taskTitle=routeTask.getRouteNode().getRouteSequence()+"."+taskTitle;
						}
						%>
							<td class="<%=className%>" width="150"><%=taskTitle%></td>
							<td class="field">
								<select name="<%=routeTask.getRouteNode().getTitle()%>" size="1" <%=routeTask.getDisabled()%> optional="<%=routeTask.isOptional()%>" class="inputField" style="width: 100%;">
								<%for(drRouteTaskAssignee routeTaskAssignee: routeTask.getRouteTaskAssignees()){ %>
									<option value="<%=routeTaskAssignee.getUserName()%>" ><%=routeTaskAssignee.getDisplayName()%></option>
								<%} %>    
								</select>
							</td>
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
												<td><a onclick="submitData(true)" href="javascript:void(0)"><img border="0" alt="Assign" src="../common/images/buttonDialogDone.gif"></a> </td>
												<td><a onclick="submitData(true)" href="javascript:void(0)"><button class="btn-default" type="button">Assign</button></a></td>					
												<td><a onclick="closeAssignWindow()" href="javascript:void(0)"><img border="0" alt="Cancel" src="../common/images/buttonDialogCancel.gif"></a> </td>
												<td><a onclick="closeAssignWindow()" href="javascript:void(0)"><button class="btn-default" type="button">Cancel</button></a></td>
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
    	log.error(ex.toString().trim());
        emxNavErrorObject.addMessage(ex.toString().trim());
    }
}
%>

<%@include file="../common/emxNavigatorBottomErrorInclude.inc"%>
