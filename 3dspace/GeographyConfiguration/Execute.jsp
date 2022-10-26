<%@include file="../common/emxNavigatorInclude.inc"%>
<%@include file="../emxUICommonHeaderBeginInclude.inc"%>
<%@page import="com.matrixone.apps.domain.DomainObject"%>
<%@include file="../emxUICommonHeaderEndInclude.inc"%>
<%@include file="../common/emxNavigatorTopErrorInclude.inc"%>
<%@include file="../common/enoviaCSRFTokenValidation.inc"%>
<%@page import="com.matrixone.servlet.*"%>
<%@page import="com.dassault_systemes.enovia.geographyconfiguration.ExecuteCallable"%>

<form name="forwardForm" action="<%=request.getRequestURI()%>"
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
%> <input type="hidden" name="<%=parameter%>"
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
<%-- Method for conversion from get to post of the request parameters --%>
<script language="javascript">
function modifyAndSubmitForwardForm(newParameters, excludeParameters,url) {
	var formObj = document.forms["forwardForm"];
	for(var i=0; i<excludeParameters.length;i++) {
		var element=formObj.elements[excludeParameters[i]];
		formObj.removeChild(element);
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
	final String suiteKey = emxGetParameter(request, "suiteKey");
	matrix.db.Context reqContext = (matrix.db.Context)request.getAttribute("context");
	if(reqContext!=null)
		context = reqContext;

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
		
		String suiteDirectory = UINavigatorUtil.getRegisteredDirectory(suiteKey);
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
		//Validating the JPO with LSA Callable class-START
		FrameworkUtil.validateMethodBeforeInvoke(context, programName, methodName, com.dassault_systemes.enovia.geographyconfiguration.ExecuteCallable.class); 
		//END
		String[] args = JPO.packArgs(parameterMap);
		jsFunctionCall = (String)JPO.invoke(context, programName, args, methodName, args, String.class);
		if (debug) {
		    System.out.println("Inside Execute.jsp calling JS function -------------> " + jsFunctionCall);
		}
	}
	catch (Exception exp) {
		exp.printStackTrace();
		String message = FrameworkUtil.findAndReplace(exp.getMessage(), "\\", "\\\\");
		message = FrameworkUtil.findAndReplace(message, "\"", "\\\"");
		jsFunctionCall = "alert(\"" + XSSUtil.encodeForJavaScript(context,  message) + "\")";
		
	}
%>

<script language="javascript" src="../common/scripts/emxUICore.js"></script>

<jsp:include page="<%=strURL%>"></jsp:include>

<script language="javascript" src="../common/scripts/emxUICore.js"></script>
<script type="text/javascript">
	<%=(jsFunctionCall != null)?jsFunctionCall:""%>;
</script>

<%@include file="../common/emxNavigatorBottomErrorInclude.inc"%>
<%@include file="../emxUICommonEndOfPageInclude.inc"%>
