<%@include file="../common/emxNavigatorInclude.inc"%>
<%@include file="../emxUICommonHeaderBeginInclude.inc" %>
<%@include file="../emxUICommonHeaderEndInclude.inc" %>
<%@include file="../common/emxNavigatorTopErrorInclude.inc"%>
<%@include file="../common/enoviaCSRFTokenValidation.inc"%>

<%@page import="com.matrixone.apps.framework.ui.UIUtil"%>
<%@page import="com.dassault_systemes.enovia.documentcommon.DCConstants"%>
<%@page import="matrix.util.StringList"%>
<form name="DCParamForm" action="" method="post" target="">
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
%>
			<input type="hidden" name="<%=parameter%>" value="<xss:encodeForHTMLAttribute><%=value%></xss:encodeForHTMLAttribute>"/>
<%		
		}
	}
	
	if (debug) {
		System.out.println("-----");
	}
%>
</form>

<%	
	final String action = emxGetParameter(request, DCConstants.DC_ACTION);

	Map mResponse = null;
	String strJavaScript = null;
	String strInclude = null;
	String strAjax = null;
	String[] saIncludeJS = null;
	String strURL = "../documentcontrol/ExecutePostActions.jsp";
	try 
	{
		if (action == null || action == "") 
		{
           throw new Exception("Error: Mandatory parameter 'dcAction' missing.");
        }
		
		matrix.db.Context reqContext = (matrix.db.Context)request.getAttribute("context");
		if(reqContext!=null)
		{
			context = reqContext;
		}
		
		StringList slProgramInfo = FrameworkUtil.split(action, ":");
		String programName = (String)slProgramInfo.get(0);
		String methodName  = (String)slProgramInfo.get(1);
		StringList slParamInMethod = FrameworkUtil.split(methodName, "?");
		if(slParamInMethod.size() > 1){
			String strParam = (String)(FrameworkUtil.split(methodName, "?")).get(1);
			String strKey = (String)(FrameworkUtil.split(strParam, "=")).get(0);
			String[] saValues = new String[1];
			saValues[0] = (String)(FrameworkUtil.split(strParam, "=")).get(1);
			parameterMap.put(strKey,saValues);
			methodName = (String)(FrameworkUtil.split(methodName, "?")).get(0);
		}
		FrameworkUtil.validateMethodBeforeInvoke(context, programName, methodName, com.dassault_systemes.enovia.documentcommon.ExecuteCallable.class);
		String[] args = JPO.packArgs(parameterMap);
		System.out.println("DCExecute -> prog : "+programName+" method : "+methodName);
		mResponse = (Map)JPO.invoke(context, programName, args, methodName, args, Map.class);
		strJavaScript = (String)mResponse.get(DCConstants.ACTION_JAVASCRIPT);
		strInclude = (String)mResponse.get(DCConstants.ACTION_INCLUDEJSP);
		saIncludeJS = (String[])mResponse.get(DCConstants.ACTION_INCLUDEJAVASCRIPT);
		strAjax = (String)mResponse.get(DCConstants.ACTION_AJAX);
	}
	catch (Exception exp) {
		exp.printStackTrace();
		String message = FrameworkUtil.findAndReplace(exp.getMessage(), "\n", "\\n");
		message = FrameworkUtil.findAndReplace(message, "\"", "\\\"");
		strJavaScript = "alert(\"" + message + "\");";
	}
    if( null != strAjax && !"null".equalsIgnoreCase(strAjax) ){
		
			out.clear();
			out.println(strAjax);
	}
	else
	{
		if(!UIUtil.isNullOrEmpty(strInclude))
		{
			%>
		<!-- XSSOK -->	<jsp:include page="<%=strInclude%>"></jsp:include>
			<%
		}
		if(saIncludeJS != null){
			for (String strJSFile : saIncludeJS) {
				%>
		<!-- XSSOK -->		<script type="text/javascript" src="<%=strJSFile%>"></script>
				<%
			}
		}
		if(!UIUtil.isNullOrEmpty(strJavaScript))
		{
%>
<jsp:include page="<%=strURL%>"></jsp:include>
			<script type="text/javascript" src="../common/scripts/jquery-latest.js"></script>
			<script type="text/javascript">
		 /* XSSOK */ 	<%=strJavaScript%>
			</script>
						
	<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
	<%@include file = "../emxUICommonEndOfPageInclude.inc"%>
			

<%		}
	}
%>

