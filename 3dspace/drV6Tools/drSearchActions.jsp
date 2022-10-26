<%@ include file = "../emxUICommonAppInclude.inc"%>
<%@ page errorPage = "emxNavigatorErrorPage.jsp"%>
<%@ page import = "com.designrule.drv6tools.common.drContext, com.designrule.drv6tools.debug.drLogger, com.designrule.drv6tools.Operations, com.designrule.drv6tools.eFunctionType, com.designrule.drv6tools.Result"%>
<%@ page import = "com.designrule.drv6tools.search.drSearchActions" %>
<%@ page import = "org.apache.log4j.Logger" %>
<script language = "Javascript" src="../common/scripts/emxUIConstants.js"></script>
<%
Logger log = drLogger.getLogger(drContext.class);
String objectId = emxGetParameter(request, "objectId");
String emxTableRowId = emxGetParameter(request, "emxTableRowId");
String actionId = emxGetParameter(request, "actionId");
String drtoolsKey = emxGetParameter(request, "drtoolsKey");
if(actionId != null && !actionId.isEmpty()){
    drSearchActions searchActionsObject = new drSearchActions(context);
   	drtoolsKey = searchActionsObject.getDrlToolsKey(actionId);
}

log.trace("drSearchActions.jsp :::: objectId = "+objectId);
log.trace("drSearchActions.jsp :::: emxTableRowId = "+emxTableRowId);
log.trace("drSearchActions.jsp :::: actionId = "+actionId);
log.trace("drSearchActions.jsp :::: drtoolsKey = "+drtoolsKey);

StringBuilder redirectURL = new StringBuilder();
redirectURL.append("../drV6Tools/drV6Tools.jsp?");
redirectURL.append("&objectId="+objectId);
redirectURL.append("&emxTableRowId="+emxTableRowId);
redirectURL.append("&actionId="+actionId);
redirectURL.append("&drtoolsKey="+drtoolsKey);

log.trace("drSearchActions.jsp :::: Redirect URL = "+redirectURL.toString());
response.sendRedirect(redirectURL.toString());

%>