<%@include file="../common/emxNavigatorInclude.inc"%>
<%@include file="../emxUICommonHeaderBeginInclude.inc"%>
<%@page import="com.matrixone.apps.domain.DomainObject, com.matrixone.apps.domain.util.*"%>
<%@include file="../emxUICommonHeaderEndInclude.inc"%>
<%@include file="../common/emxNavigatorTopErrorInclude.inc"%>
<%@page import="com.matrixone.servlet.*"%>
<%@page import="com.dassault_systemes.enovia.riskmgmt.ExecuteCallable"%>

<%
	boolean chooserMode = false;
	boolean validateToken = true;
	if(emxGetParameter(request, "chooserMode") != null && emxGetParameter(request, "chooserMode") != "")
		chooserMode = Boolean.parseBoolean(emxGetParameter(request, "chooserMode"));
	if(emxGetParameter(request, "validateToken") != null && emxGetParameter(request, "validateToken") != "")
		validateToken = Boolean.parseBoolean(emxGetParameter(request, "validateToken"));
	if(validateToken && !chooserMode)
	{
%>
	<%@include file="../common/enoviaCSRFTokenValidation.inc"%>
<% 
	}
%>
<form name="forwardForm" action="<%=XSSUtil.encodeForJavaScript(context,request.getRequestURI())%>"
	method="post" target="">
<%
	final boolean debug = "true".equalsIgnoreCase(emxGetParameter(request, "debug"));
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
%> <input type="hidden" name="<%=XSSUtil.encodeForJavaScript(context,parameter)%>"
	value="<xss:encodeForHTMLAttribute><%=value%></xss:encodeForHTMLAttribute>" />
<%		
		}
	}
	
	if (debug) {
		System.out.println("-----");
	}
%>
</form>
<script type="text/javascript" src="../common/scripts/jquery-latest.js"></script>
<script language="javascript">
function modifyAndSubmitForwardForm(newParameters, excludeParameters,url) {
	var formObj = document.forms["forwardForm"];
	if(excludeParameters!=null) {
		for(var i=0; i<excludeParameters.length;i++) {
			var element = document.getElementsByName(excludeParameters[i])[0];
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
</script>
<%	
	final String action = emxGetParameter(request, "action");
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
           throw new Exception("Error: Mandatory parameter 'action' missing.");
        }
		if(suiteKey == null || suiteKey == "") 
		{
			throw new Exception("Error: Mandatory parameter 'suiteKey' missing.");
		}
		
		if(suiteKey.indexOf('?')!=-1)
		{
			StringList suiteKeyList  = FrameworkUtil.split(suiteKey, "?");
			suiteKey = (String)suiteKeyList.get(0);
		}
		
		String suiteDirectory = UINavigatorUtil.getRegisteredDirectory(context, suiteKey);
		strURL = "../" + suiteDirectory + "/ExecutePostActions.jsp";
		StringList programInfo = FrameworkUtil.split(action, ":");
		String programName = (String)programInfo.get(0);
		String methodName = (String)programInfo.get(1);
	
		//This fix is required for advance compare
		if(methodName.indexOf('?')!=-1)
		{
			StringList methodNameList  = FrameworkUtil.split(methodName, "?");
			methodName = (String)methodNameList.get(0);
		}
		//Validating the JPO with Callable class-START
		FrameworkUtil.validateMethodBeforeInvoke(context, programName, methodName, com.dassault_systemes.enovia.riskmgmt.ExecuteCallable.class); 
		//END
		String[] args = JPO.packArgs(parameterMap);
		jsFunctionCall = (String)JPO.invoke(context, programName, args, methodName, args, String.class);
	}
	catch (Exception exp) {
		exp.printStackTrace();
		String message = FrameworkUtil.findAndReplace(exp.getMessage(), "\\", "\\\\");
		message = FrameworkUtil.findAndReplace(message, "\"", "\\\"");
		/* XSS OK*/jsFunctionCall = "alert(\"" + XSSUtil.encodeForJavaScript(context,  message) + "\")";
		
	}
%>

<script language="javascript" src="../common/scripts/emxUICore.js"></script>

<jsp:include page="<%=strURL%>"></jsp:include>

<script type="text/javascript">
	/*XSS OK*/ <%=(jsFunctionCall != null)?jsFunctionCall:""%>
</script>

<%@include file="../common/emxNavigatorBottomErrorInclude.inc"%>
<%@include file="../emxUICommonEndOfPageInclude.inc"%>
