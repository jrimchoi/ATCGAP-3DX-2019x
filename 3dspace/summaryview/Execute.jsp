<%@include file="../common/emxNavigatorInclude.inc"%>
<%@include file="../emxUICommonHeaderBeginInclude.inc"%>
<%@page import="com.matrixone.apps.domain.DomainObject, com.matrixone.apps.domain.util.*"%>
<%@include file="../emxUICommonHeaderEndInclude.inc"%>
<%@include file="../common/emxNavigatorTopErrorInclude.inc"%>
<%@page import="com.dassault_systemes.enovia.summaryview.SummaryViewExecuteCallable"%>
<%@page import="com.matrixone.servlet.*, javax.servlet.ServletContext"%>

<%
	boolean chooserMode = false;
	boolean validateToken = true;
	boolean ajaxModeSent = true;
	if(emxGetParameter(request, "chooserMode") != null && emxGetParameter(request, "chooserMode") != "")
		chooserMode = Boolean.parseBoolean(emxGetParameter(request, "chooserMode"));
	if(emxGetParameter(request, "validateToken") != null && emxGetParameter(request, "validateToken") != "")
		validateToken = Boolean.parseBoolean(emxGetParameter(request, "validateToken"));
	if(emxGetParameter(request, "ajaxMode") != null && emxGetParameter(request, "ajaxMode") != "")
				ajaxModeSent = Boolean.parseBoolean(emxGetParameter(request, "ajaxMode"));
		if(validateToken && !chooserMode && !ajaxModeSent)
	{
%>
	<%@include file="../common/enoviaCSRFTokenValidation.inc"%>
<%
	}
%>
<form name="forwardForm" action="<%=request.getRequestURI()%>"
	method="post" target="">
<%
	final boolean debug = "true".equalsIgnoreCase(emxGetParameter(request, "debug"));
	Map<String, String[]> parameterMap = new HashMap<String, String[]>();
	String eSummaryViewWebAppPath = getServletConfig().getServletContext().getRealPath("/summaryview");
	if(eSummaryViewWebAppPath.contains("\\")) {
		eSummaryViewWebAppPath = eSummaryViewWebAppPath.replace("\\","/");
	}
	parameterMap.put("SummaryViewWebAppPath", new String[] {eSummaryViewWebAppPath});
	String timeZone = (String)session.getValue("timeZone");
	parameterMap.put("timeZone", new String[] {timeZone});
	//This fix is required to get correct context in postProcesssURL
	matrix.db.Context reqContext = (matrix.db.Context)request.getAttribute("context");
	if(reqContext!=null)
	{
		context = reqContext;
	}
%> 	<input type="hidden" name="eSummaryViewWebAppPath"
			value="<xss:encodeForHTMLAttribute><%=eSummaryViewWebAppPath%></xss:encodeForHTMLAttribute>" />
	<input type="hidden" name="timeZone"
			value="<xss:encodeForHTMLAttribute><%=timeZone%></xss:encodeForHTMLAttribute>" />
<%

	if (debug) {
		System.out.println("-----Parameters to " + request.getRequestURI() + "-----");
	}

	// Collect all the parameters
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
<script language="javascript">
function modifyAndSubmitForwardForm(newParameters, excludeParameters,url) {
	var formObj = document.forms["forwardForm"];
	if(!excludeParameters) {
		excludeParameters = new Array("action");
	}
	else {
		if(excludeParameters.indexOf("action")==-1) {
			excludeParameters.push("action");
		}
	}
	for(var i=0; i<excludeParameters.length;i++) {
		var element = document.getElementsByName(excludeParameters[i])[0];
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
</script>
<%
	String executeAction = emxGetParameter(request, "executeAction");
	String suiteKey = emxGetParameter(request, "suiteKey");
	String ajaxMode = emxGetParameter(request, "ajaxMode");

	String jsFunctionCall = null;
	String strURL = null;

	try
	{
		if (executeAction == null || "".equals(executeAction))
		{
			executeAction = emxGetParameter(request, "action");
			if (executeAction==null || "".equals(executeAction)) {
				throw new Exception("Error: Mandatory parameter 'executeAction' missing.");
			}
        }
		if(suiteKey == null || "".equals(suiteKey))
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
		StringList programInfo = FrameworkUtil.split(executeAction, ":");
		String programName = (String)programInfo.get(0);
		String methodName = (String)programInfo.get(1);
		//This fix is required for advance compare
		if(methodName.indexOf('?')!=-1)
		{
			StringList methodNameList  = FrameworkUtil.split(methodName, "?");
			methodName = (String)methodNameList.get(0);
		}
		//Validating the JPO with Summary View Callable class-START
		FrameworkUtil.validateMethodBeforeInvoke(context, programName, methodName, com.dassault_systemes.enovia.summaryview.SummaryViewExecuteCallable.class);
		//END
		String[] args = JPO.packArgs(parameterMap);

		if("true".equals(ajaxMode))
		{
			Map<String,String> mAjax = (Map)JPO.invoke(context, programName, args, methodName, args, Map.class);

               String responseText="{\"result\":";
               responseText+="[";
			for (Iterator iterator = mAjax.keySet().iterator(); iterator.hasNext();) {
				String strKey = (String) iterator.next();
				String strValue=mAjax.get(strKey);
				responseText += "{\"text\": \"" + strKey + "\", \"value\": \"" + strValue + "\"}";
                     if(iterator.hasNext()) {
                            responseText+=",";
                     }
			}
			responseText += "]}";
			response.setContentType("application/json; charset=utf-8");

			PrintWriter writer = response.getWriter();
			writer.write(responseText);
			writer.close();
		}
		else
		{
		      jsFunctionCall = (String)JPO.invoke(context, programName, args, methodName, args, String.class);
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

<script type="text/javascript">
	<%=(jsFunctionCall != null)?jsFunctionCall:""%>
</script>

<%@include file="../common/emxNavigatorBottomErrorInclude.inc"%>
<%@include file="../emxUICommonEndOfPageInclude.inc"%>
