<%--
  drUpdateApprovalRoute.jsp
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

<%
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

StringBuilder buildPageAction = new StringBuilder(200);
buildPageAction.append("../drV6Tools/drUpdateApprovalRouteAssignees.jsp?");
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
	</head>
	<body>		
		<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
		<script language="javascript" src="../common/scripts/emxUICore.js"></script>
		<script language="javascript" src="../common/scripts/emxUIModal.js"></script>
		<script language="Javascript" >
		var showSlidein="<%=showCommentsReqAlert%>";
		if(showSlidein == "true"){
			showNonModalDialog("<%=assigneePageAction%>");
		}else{
			getTopWindow().showSlideInDialog("<%=assigneePageAction%>");
		}
		</script>
	</body>
</html>
<%@include file="../common/emxNavigatorBottomErrorInclude.inc"%>
