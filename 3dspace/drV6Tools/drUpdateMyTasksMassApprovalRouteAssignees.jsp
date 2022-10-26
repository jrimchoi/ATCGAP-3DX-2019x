<%--
  drUpdateMyTasksMassApprovalRouteAssignees.jsp
  Copyright (c) 1993-2015 Dassault Systemes.
  All Rights Reserved.
  This program contains proprietary and trade secret information of
  Dassault Systemes.
  Copyright notice is precautionary only and does not evidence any actual
  or intended publication of such program
--%>

<%-- Common Includes --%>
<%@page import="com.matrixone.apps.domain.DomainConstants"%>
<%@include file="../common/emxNavigatorTopErrorInclude.inc"%>
<%@include file="../common/emxCompCommonUtilAppInclude.inc"%>
<%@include file="../emxUICommonAppInclude.inc"%>

<%@page import="com.matrixone.apps.domain.DomainConstants" %>
<%@page import="com.matrixone.apps.domain.DomainObject" %>
<%@page import="matrix.util.StringList"%>
<%@page import="matrix.db.Context"%>
<%@page import="com.matrixone.apps.common.util.ComponentsUIUtil"%>
<%@page import="com.designrule.drv6tools.common.drContext"%>
<%@page import="com.designrule.drv6tools.route.drRouteUtil"%>
<%@page import="com.designrule.drv6tools.route.drRouteBusinessObject"%>
<%@page import="com.designrule.drv6tools.route.drRouteTask"%>
<%@page import="com.designrule.drv6tools.route.drRouteTaskAssignee"%>
<%@page import="com.designrule.drv6tools.route.drRouteTasks"%>
<%@page import="com.designrule.drv6tools.debug.drLogger"%>
<%@page import="org.apache.log4j.Logger"%>

<%
    // get the timeStamp from the incoming HttpRequest 
    String timeStamp = (String) emxGetParameter(request,"timeStamp"); 
    // define the table bean 
%> 
    <jsp:useBean id="tableBean" class="com.matrixone.apps.framework.ui.UITable" scope="session"/> 
<%
final Logger log = drLogger.getLogger(this.getClass());
try{
	 drRouteUtil routeUtil=new drRouteUtil(context);
	 HashMap requestMap 	= UINavigatorUtil.getRequestParameterMap(pageContext);
	 ArrayList<drRouteBusinessObject> routeBusinessObjects = new ArrayList<drRouteBusinessObject>();
	 HashMap tableDataMap = null;
	// get the tableDataMap and the requestMap from the table bean 
	tableDataMap = (HashMap) tableBean.getTableData(timeStamp);	
	if(tableDataMap!=null)
	{
		boolean abortProcess = false;
		try {
			MapList objectList = (MapList) tableBean.getObjectList(tableDataMap);
			Map taskInfo;
			String strValidApprovalStatusAction = "";
			for (Iterator itrObjectList = objectList.iterator(); itrObjectList.hasNext();) {
				taskInfo = (Map) itrObjectList.next();
				requestMap.put("taskId", (String) taskInfo.get(DomainConstants.SELECT_ID));
				requestMap.put("routeId", (String) taskInfo.get("relationship[" + DomainConstants.RELATIONSHIP_ROUTE_TASK + "].to.id"));
				strValidApprovalStatusAction = (String) taskInfo.get("ValidApprovalStatusAction");
				if (strValidApprovalStatusAction == null || "".equals(strValidApprovalStatusAction) || "null".equals(strValidApprovalStatusAction)) {
					continue;
				} else {
					if ("IT-Approve".equals(strValidApprovalStatusAction)) {
						strValidApprovalStatusAction = (String)taskInfo.get("Approval Status" + (String) taskInfo.get("serialNumber"));
						requestMap.put("action",strValidApprovalStatusAction);
						drRouteBusinessObject routeBusinessObject = routeUtil.getRouteBusinessObject(JPO.packArgs(requestMap));
						if(routeBusinessObject.isAbortProcess()){
							abortProcess = true;
						}
						routeBusinessObjects.add(routeBusinessObject);
					}
				}
			}
		} catch (Exception ex) {
			throw ex;
		}
		tableBean.setTableData(timeStamp, tableDataMap);
		String routeDescription = "Description";
		String createFormHeaderText = "Approval Route";
		String createFormTemplateLabelText = "Route Name";
		
		//START : Redirect to error report dialog if any failure while running validations
		if(abortProcess){
		%>	
			<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
			<script language="javascript" src="../common/scripts/emxUICore.js"></script>
			<script language="javascript" src="../common/scripts/emxUIModal.js"></script>
			<script type="text/javascript">
				showNonModalDialog("../drV6Tools/drErrorReportDialog.jsp");
				getTopWindow().close();
			</script>
		<%	return;
		}
		//END : Redirect to error report dialog if any failure while running validations
		%>

	<html style="background:#FFFFFF;">
		<head>
			<title>Assign Tasks</title>
			<script src="../common/scripts/jquery-latest.js"></script>
			<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
			<script language="javascript" src="../common/scripts/emxUICore.js"></script>
			<script language="javascript" src="../common/scripts/emxUIModal.js"></script>
			<link rel="stylesheet" href="../common/styles/emxUIDefault.css" />
			<link rel="stylesheet" href="../common/styles/emxUIProperties.css" />
			<link rel="stylesheet" href="../common/styles/emxUIForm.css" />
			<link rel="stylesheet" href="../common/styles/emxUIList.css" />
			<style>
				div#divPageFoot,
				div.page-foot {
					position:fixed;
					bottom:0;
					left:0;
					right:0;
					color:#6e6e6e;
					background:#f0f0f0;
					border-top:1px solid #e6e7e8;
					padding:1px;
				}
				
				.blank_row
				{
					height: 24px !important;
					line-height: 24px;
					background-color: #ffffff;
					border-bottom:2px solid #ffffff;
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
						var name=$(this).attr('displayName');
						var disabled=$(this).prop('disabled');
						$(this).find('option:selected').each(function(){;
							var element = $(this);
							if (disabled == false && optional === "false" && element.val().startsWith("role_")) {
								assigneeAlertMsg+=name+"\n";  
								canProceed=false;
							}
						}); 
					}); 
					if(canProceed){
						var objform = document.forms['assignRouteForm'];
						objform.target="listHidden";
						objform.action = "../common/emxLifecycleTasksMassApprovalProcess.jsp";
						objform.submit();
						getTopWindow().close();
					}else{
						alert("Please select assignee for the following tasks.\n"+assigneeAlertMsg);
					}
				}
				
				//For auto submit
				$( function() {
					var canProceed=true;
					$('.inputField').each(function() {
						$(this).find('option').each(function(){;
							canProceed=false;
						});
					}); 
					if(canProceed){
						var objform = document.forms['assignRouteForm'];
						objform.target="listHidden";
						objform.action = "../common/emxLifecycleTasksMassApprovalProcess.jsp";
						objform.submit();
						getTopWindow().close();
					}
				});
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
			<div id="createRouteDiv" style="padding-bottom:50px;">
				<form nsubmit="return false;" method="post" name="assignRouteForm" id="assignRouteForm">
					<input type="hidden" name="timeStamp" value="<xss:encodeForHTMLAttribute><%=timeStamp%></xss:encodeForHTMLAttribute>"/>
					<input type="hidden" name="processRouteAssignee" value="true"/>
					<table>	
						<%for(drRouteBusinessObject routeBusinessObject:routeBusinessObjects){
							if(routeBusinessObject.getRouteTasks().size()>0 == false){
								continue;
							}%>
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
										<select name="<%=routeTask.getRouteNode().getTitle()%>#SPLIT#<%=routeTask.getRouteNode().getObjectID()%>#SPLIT#<%=routeBusinessObject.getObjectID()%>" displayName="<%=routeBusinessObject.getName()%> - <%=routeTask.getRouteNode().getTitle()%>" size="1" <%=routeTask.getDisabled()%> optional="<%=routeTask.isOptional()%>" class="inputField" style="width: 100%;">
										<%for(drRouteTaskAssignee routeTaskAssignee: routeTask.getRouteTaskAssignees()){ %>
											<option value="<%=routeTaskAssignee.getUserName()%>" ><%=routeTaskAssignee.getDisplayName()%></option>
										<%}%>    
										</select>
									</td>
								</tr>
							<%}%>
							<tr class="blank_row">
								<th colspan="4"></th>
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
												<td><a onclick="getTopWindow().close();" href="javascript:void(0)"><img border="0" alt="Cancel" src="../common/images/buttonDialogCancel.gif"></a> </td>
												<td><a onclick="getTopWindow().close();" href="javascript:void(0)"><button class="btn-default" type="button">Cancel</button></a></td>
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
	<%}else{%>
		<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
		<script type="text/javascript">
			alert("An error occurred while processing your request. Please try again.");
			top.close();
		</script>
	<%}%>
<%	
}catch(Exception ex){
    if (ex.toString() != null && (ex.toString().trim()).length() > 0){
    	log.error(ex.toString().trim());
        emxNavErrorObject.addMessage(ex.toString().trim());
    }
}
%>
<%@include file="../common/emxNavigatorBottomErrorInclude.inc"%>
