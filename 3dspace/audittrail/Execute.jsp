<%@page import="java.util.HashMap"%>
<%@include file="../common/emxNavigatorInclude.inc"%>
<%@include file="../emxUICommonHeaderBeginInclude.inc"%>
<%@page import="com.matrixone.apps.domain.DomainObject, com.matrixone.apps.domain.util.*"%>
<%@include file="../emxUICommonHeaderEndInclude.inc"%>
<%@include file="../common/emxNavigatorTopErrorInclude.inc"%>
<%@page import="com.matrixone.servlet.*"%>
<%@ page import="com.matrixone.servlet.*,matrix.db.*"%>
<html>
<link rel="stylesheet" type="text/css" href="../common/styles/emxUIDefault.css"/>
<% 
	boolean chooserMode = false;
	boolean validateToken = false;
	
	if(emxGetParameter(request, "chooserMode") != null && emxGetParameter(request, "chooserMode") != "")
		chooserMode = Boolean.parseBoolean(emxGetParameter(request, "chooserMode"));
	if(emxGetParameter(request, "validateToken") != null && emxGetParameter(request, "validateToken") != "")
		validateToken = Boolean.parseBoolean(emxGetParameter(request, "validateToken"));
	if(validateToken && !chooserMode)
	{
%><%@include file="../common/enoviaCSRFTokenValidation.inc"%><% 
	}
%>
<form name="forwardForm" method="post" target="">
	<%
	final boolean debug = "true".equalsIgnoreCase(emxGetParameter(request, "debug"));
	System.out.println("URL="+request.getRequestURI());
	if (debug) {
		System.out.println("-----Parameters to " + request.getRequestURI() + "-----");
	}
	// Collect all the parameters
	Map<String, String[]> parameterMap = new HashMap<String, String[]>();
	Enumeration paramEnum = emxGetParameterNames (request);
	while (paramEnum.hasMoreElements()) {
		String parameter = (String)paramEnum.nextElement();
		String[] values = emxGetParameterValues(request, parameter);
		
		parameterMap.put(parameter, values);
		
		for (String value : values) {
			if (debug) {
				System.out.println(parameter + "=" + value);
			}
%> <input type="hidden" name="<%=parameter%>"
	value="<xss:encodeForHTMLAttribute><%=value%></xss:encodeForHTMLAttribute>" /><%		
		}
	}
	
	if (debug) {
		System.out.println("-----");
	}%>

</form>
<script language="javascript">

function modifyAndSubmitForwardForm(newParameters, excludeParameters,url,formObj) {
	if(!formObj) {
		formObj = document.forms["forwardForm"];
	}
	if(!excludeParameters) {
		excludeParameters = new Array("action");
	}
	else {
		if(excludeParameters.indexOf("action")==-1) {
			excludeParameters.push("action");
		}
	}
	for(var i=0; i<excludeParameters.length;i++) {
		var element = formObj.ownerDocument.getElementsByName(excludeParameters[i])[0];
		if(element) {
			formObj.removeChild(element);
		}
	}
	for(var parameterName in newParameters) {
		var inputElement = document.createElement("input");
		inputElement.setAttribute("type", "hidden");
		inputElement.setAttribute("name", parameterName);
		inputElement.setAttribute("value", newParameters[parameterName]);
		formObj.appendChild(inputElement);
	}
	formObj.action=url;
	formObj.submit();
}

function sleep(delay) {
    var start = new Date().getTime();
    while (new Date().getTime() < start + delay);
 }
  
</script><%	
	String action = emxGetParameter(request, "executeAction");
	String suiteKey = emxGetParameter(request, "suiteKey");
	//This fix is required to get correct context in postProcesssURL
	matrix.db.Context reqContext = (matrix.db.Context)request.getAttribute("context");
	if(reqContext!=null)
	{
		context = reqContext;
	}
	String jsFunctionCall = null;
	String strURL = null;
	
	try 
	{
		if (action == null || action == "") 
		{
           throw new Exception("Error: Mandatory parameter 'executeAction' missing.");
        }
		Map mCSMap = UINavigatorUtil.getImageData(context, pageContext);
		parameterMap.put("ImageData", new String[]{mCSMap.get("MCSURL").toString()});
		String suiteDirectory = UINavigatorUtil.getRegisteredDirectory(context, suiteKey);
		parameterMap.put("strURL", new String[]{strURL});
		strURL = "../audittrail/ExecutePostActions.jsp";
		StringList programInfo = FrameworkUtil.split(action, ":");
		String programName = (String)programInfo.get(0);
		String methodName = (String)programInfo.get(1);
	
		//This fix is required for advance compare
		if(methodName.indexOf('?')!=-1)
		{
			StringList methodNameList  = FrameworkUtil.split(methodName, "?");
			methodName = (String)methodNameList.get(0);
		}
		FrameworkUtil.validateMethodBeforeInvoke(context, programName, methodName, com.dassault_systemes.enovia.audittrail.AuditTrailExecuteCallable.class);
		String[] args = JPO.packArgs(parameterMap);
		jsFunctionCall = (String)JPO.invoke(context, programName, args, methodName, args, String.class);
	}
	catch (Exception exp) {
		exp.printStackTrace();
		String message = FrameworkUtil.findAndReplace(exp.getMessage(), "\\", "\\\\");
		message = FrameworkUtil.findAndReplace(message, "\"", "\\\"");
		jsFunctionCall = "alert(\"" + XSSUtil.encodeForJavaScript(context,  message) + "\")";
		
	}%>
<script language="javascript" src="../common/scripts/emxUICore.js"></script>

<jsp:include page="<%=strURL%>"></jsp:include>

<script type="text/javascript">
	<%=(jsFunctionCall != null)?jsFunctionCall:""%>
</script>

<%@include file="../common/emxNavigatorBottomErrorInclude.inc"%>
<%@include file="../emxUICommonEndOfPageInclude.inc"%>
</body>
</html>
</html>
