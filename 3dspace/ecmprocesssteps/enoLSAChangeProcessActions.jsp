<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@page import="java.text.*,java.io.*, java.util.*, javax.json.Json,javax.json.JsonArrayBuilder,javax.json.JsonObject,javax.json.JsonObjectBuilder, org.w3c.dom.*"%>
<%@page import="com.matrixone.apps.common.Lifecycle, com.matrixone.apps.framework.lifecycle.LifeCyclePolicyDetails"%>
<%
	try{
	
	String objectId			= request.getParameter("objectId");
	String rootObjectId		= request.getParameter("rootobjectId");
	String operationName	= request.getParameter("operationName");
	context 		= Framework.getFrameContext(session);
	String message = null;

	if(!isNullOrEmpty(operationName)) {
		message = executeOperation(context, objectId, operationName);
	}

	if(!isNullOrEmpty(message)) {
		JsonObjectBuilder returnData = Json.createObjectBuilder();
		returnData.add("message", message);
		
		response.setContentType("application/json");
		response.setHeader("Content-Disposition", "inline");
		response.getWriter().print(returnData.build());
		out.flush();
	}

	} catch (Exception exp) {
		exp.printStackTrace();
		throw exp;
	}
%>

<%!
private boolean isNullOrEmpty(String input)
{
	if(input == null || input.equals("") || input.equals("null")) return true;
	
	return false;
}

//TODO: This function needs to be in ProcessDashboard class
private String executeOperation(Context context, String objectId, String operationName)
{
	String message = null;

	try {

		DomainObject activeObj =  DomainObject.newInstance(context, objectId);
		//if(operationName.equals(PARAMS.OPERATION_PROMOTE)) {
		if (operationName.equals("promote")) { //TODO: comment this and uncomment previous line after moving to ProcessDashboard
        com.matrixone.apps.framework.lifecycle.LifeCycleUtil.checksToPromoteObject(context, activeObj);
			activeObj.promote(context);
		}

	} catch (Exception ex) {

		message = ex.getMessage();
		System.out.println("message......" + message);
	}

	return message;

}
%>
	
}

