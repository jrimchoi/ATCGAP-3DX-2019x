<%--
  drInitiateRouteAssignProcess.jsp
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
<%@page import="com.designrule.drv6tools.common.drBusinessObject"%>
<%@page import="com.designrule.drv6tools.common.drBusinessObjects"%>
<%@page import="com.designrule.drv6tools.domain.drRoute"%>
<%@page import="com.designrule.drv6tools.debug.drLogger"%>
<%@page import="org.apache.log4j.Logger"%>

<%
final Logger log = drLogger.getLogger(this.getClass());
	try{
	String templateName = request.getParameter("templateName");
	String routeDescription = request.getParameter("routeDescription");
	String createFormHeaderText = request.getParameter("CreateFormHeaderText");
	String createFormTemplateLabelText = request.getParameter("CreateFormTemplateLabelText");
	HashMap requestMap 	= UINavigatorUtil.getRequestParameterMap(pageContext);
	drRouteUtil routeUtil = new drRouteUtil(context);
	ArrayList<drRoute> routeList = routeUtil.createNewRoute(JPO.packArgs(requestMap)); 
	StringBuilder routeNames = new  StringBuilder();
	String url = "";
	for(drRoute route: routeList){
		routeNames.append("<a style='text-decoration: none !important;' href='javascript:showNonModalDialog(\"../common/emxTree.jsp?objectId="+route.getObjectID()+"\",575,575)'>");
		routeNames.append(route.getName()+"</a>");
		routeNames.append("<br/> ");	
	}
	%>

	<html style="background:#FFFFFF;">
		<head>
			<title>Assign Tasks</title>
			<script src="../common/scripts/jquery-latest.js"></script>
			<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
			<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
			<script language="javascript" src="../common/scripts/emxUICore.js"></script>
			<script language="javascript" src="../common/scripts/emxUIModal.js"></script>
			<link rel="stylesheet" href="../common/styles/emxUIDefault.css" />
			<link rel="stylesheet" href="../common/styles/emxUIProperties.css" />
			<link rel="stylesheet" href="../common/styles/emxUIForm.css" />
			<link rel="stylesheet" href="../common/styles/emxUIList.css" />		

			<script type="text/javascript">
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
			<div id="createRouteDiv">
				<form nsubmit="return false;" method="post" name="assignRouteForm" id="assignRouteForm">
					<table>	
						<tr>
						<tr>
							<td class="labelRequired" width="150"><%=createFormTemplateLabelText%></td>
							<td class="inputField"><text id='routeTemplateName' name="routeDescription" cols="40" rows="5"><%=templateName%></text></td>
						</tr>
						<tr>
							<td class="label" width="150" style="background-color: #b2b2ff;font-weight:bold;">Created the approval route: </td>
							<td class="inputField" style="background-color: #b2b2ff;font-weight:bold;"><%=routeNames.toString()%></td>
						</tr>									
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
												<td><a onclick="closeAssignWindow()" href="javascript:void(0)"><img border="0" alt="Close" src="../common/images/buttonDialogCancel.gif"></a> </td>
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
			<script type="text/javascript">
				var parentFrame = findFrame(top, "AEFLifecycleApprovals");
				if(!parentFrame){
					parentFrame = findFrame(top, "detailsDisplay");
				}
				if(parentFrame){
					parentFrame.document.location.href = parentFrame.document.location.href;
				}
				parentFrame = findFrame(top, "ECMCAProperties");
				if(parentFrame){
					parentFrame = findFrame(top, "detailsDisplay");
					if(parentFrame){
						parentFrame.document.location.href = parentFrame.document.location.href;
					}
				}
			</script>		
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
