<%--
  drUpdateApprovalRouteAssignees.jsp
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
<%-- <%@include file="../common/enoviaCSRFTokenValidation.inc"%> --%>

<%@page import="com.matrixone.apps.domain.util.XSSUtil"%>
<%@page import="matrix.db.Context"%>
<%@page import="com.designrule.drv6tools.common.drContext"%>
<%@page import="com.designrule.drv6tools.route.drRouteUtil"%>
<%@page import="com.designrule.drv6tools.route.drInitiateRouteResult"%>
<%@page import="com.designrule.drv6tools.route.drRouteBusinessObject"%>
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
String routeDescription = "Description";
String createFormHeaderText = "Approval Route";
String createFormTemplateLabelText = "Name";

String taskId       = emxGetParameter(request, "taskId");
String targetLocation = emxGetParameter(request, "targetLocation");
String routeId      = emxGetParameter(request, "routeId");
String Comments = emxGetParameter(request, "Comments");
String getCommentsFromTaskId = emxGetParameter(request, "getCommentsFromTaskId");
String isEncoded = emxGetParameter(request,"isEncoded");
String ApprovalStatus   = emxGetParameter(request, "ApprovalStatus");
String approvalStatus = emxGetParameter(request, "approvalStatus");
String flag = emxGetParameter(request,"flag");
String showCommentsReqAlert = emxGetParameter(request, "showCommentsReqAlert");
String action = emxGetParameter(request,"action");

drRouteUtil routeUtil=new drRouteUtil(context);
HashMap requestMap 	= UINavigatorUtil.getRequestParameterMap(pageContext);
drRouteBusinessObject routeBusinessObject=routeUtil.getRouteBusinessObject(JPO.packArgs(requestMap));

//Build OOTB Task Complete process URL
StringBuilder buildPageAction = new StringBuilder(200);
buildPageAction.append("../components/emxTaskCompleteProcess.jsp?");
buildPageAction.append("taskId="+taskId);
buildPageAction.append("&targetLocation="+targetLocation);
buildPageAction.append("&routeId="+routeId);
buildPageAction.append("&Comments="+Comments);
buildPageAction.append("&getCommentsFromTaskId="+getCommentsFromTaskId);
buildPageAction.append("&isEncoded="+isEncoded);
buildPageAction.append("&ApprovalStatus="+ApprovalStatus);
buildPageAction.append("&approvalStatus="+approvalStatus);
buildPageAction.append("&flag="+flag);
buildPageAction.append("&showCommentsReqAlert="+showCommentsReqAlert);
buildPageAction.append("&action="+action);

String assigneePageAction=buildPageAction.toString();

%>

<html style="background:#FFFFFF;">
	<head>
		<title>Assign Tasks</title>
		<script src="../common/scripts/jquery-latest.js"></script>
		<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
		<script language="javascript" src="../common/scripts/emxUICore.js"></script>
		<script language="javascript" src="../common/scripts/emxUIModal.js"></script>
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
			var showSlidein = "<%=showCommentsReqAlert%>";
			function submitData(createRoute) {
				var canProceed=true;
				var assigneeAlertMsg="";
				$('.inputField').each(function() {
					var optional=$(this).attr('optional');
					var name=$(this).attr('name');
					var disabled=$(this).prop('disabled');
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
						objform.target="listHidden";
						objform.action = "<%=assigneePageAction%>";
						objform.submit();
					}else{
						alert("Your previous request is in process, please wait...");
					}
					if(showSlidein=="true"){
						getTopWindow().close();
					}else{
						getTopWindow().closeSlideInDialog();
					}				
				}else{
					alert("Please select assignee for "+assigneeAlertMsg);
				}
			}	
			
			function closeAssigneeWindow(){
				if(showSlidein=="true"){
					getTopWindow().close();
				}else{
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
				<table>	
					<tr>
					<tr>
						<td class="label" width="150"><%=createFormTemplateLabelText%></td>
						<td class="inputField"><text id='routeTemplateName' name="routeName" cols="40" rows="5"><%=routeBusinessObject.getName()%></text></td>
					</tr>	
					<tr>
						<td class="label" width="150"><%=routeDescription%></td>
						<td class="inputField"><text id='routeDescription' name="routeDescription" cols="40" rows="5"><%=routeBusinessObject.getDescription()%></text></td>
					</tr>
					<tr>
						<td class="label" width="150" style="background-color: #b2b2ff;font-weight:bold;">Task</td>
						<td class="inputField" style="background-color: #b2b2ff;font-weight:bold;"><text id='routeAssignee' name="routeAssignee" cols="40" rows="5">Assignee</text></td>
					</tr>					
					<% 
					String className;
					String taskTitle;
					for(drRouteTask routeTask:routeBusinessObject.getRouteTasks()){%>
					<tr>
					<% 
					className="labelRequired";
					if(routeTask.isOptional()){
						className="label";
					}
					taskTitle=routeTask.getRouteNode().getTitle();
					if(routeBusinessObject.isShowTaskSequence()){
						taskTitle=routeTask.getRouteNode().getRouteSequence()+"."+taskTitle;
					}
					%>					
						<td class="<%=className%>" width="150"><%=taskTitle%></td>
						<td class="field">
							<select name="<%=routeTask.getRouteNode().getTitle()%>" size="1" <%=routeTask.getDisabled()%> optional="<%=routeTask.isOptional()%>" class="inputField" style="width: 100%;">
							<%for(drRouteTaskAssignee routeTaskAssignee: routeTask.getRouteTaskAssignees()){ %>
								<option value="<%=routeTaskAssignee.getUserName()%>" ><%=routeTaskAssignee.getDisplayName()%></option>
							<%}%>    
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
											<td><a onclick="closeAssigneeWindow(true)" href="javascript:void(0)"><img border="0" alt="Cancel" src="../common/images/buttonDialogCancel.gif"></a> </td>
											<td><a onclick="closeAssigneeWindow(true)" href="javascript:void(0)"><button class="btn-default" type="button">Cancel</button></a></td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>	
		<!-- <iframe id="listHidden" class="hidden-frame" name="listHidden" width="0%" height="0%"/>	 -->
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
