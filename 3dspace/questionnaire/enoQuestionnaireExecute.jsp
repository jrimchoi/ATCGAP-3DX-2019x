<%@page import="com.matrixone.apps.domain.util.XSSUtil"%>
<%@include file="../common/emxNavigatorInclude.inc"%>
<%@include file="../emxUICommonHeaderBeginInclude.inc" %>
<%@include file="../emxUICommonHeaderEndInclude.inc" %>
<%@include file="../common/emxNavigatorTopErrorInclude.inc"%>
<%@page import="com.matrixone.apps.framework.ui.UIUtil"%>
<%@page import="com.dassault_systemes.enovia.questionnaire.QuestionnaireConstants"%>

<%@page import="matrix.db.ClientTask"%>
<%@page import="matrix.db.ClientTaskItr"%>
<%@page import="matrix.db.ClientTaskList"%>

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
<form name="DCLParamForm" action="" method="post" target="">
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
	final String action = emxGetParameter(request, QuestionnaireConstants.QUESTION_ACTION);
	final String mqlNoticeMode = emxGetParameter(request, "mqlNoticeMode");
	
	String suiteKey = emxGetParameter(request, "suiteKey");
	suiteKey="Questionnaire";
	String ajaxMode = emxGetParameter(request, "ajaxMode");
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
		if ((mqlNoticeMode==null || mqlNoticeMode=="") && action == null || action == "") 
		{
           throw new Exception("Error: Mandatory parameter 'questionAction' missing.");
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
		
		String programName="";
		String methodName="";
		String[] args=null;
		
		if(action!=null && !action.isEmpty())
		{
			StringList programInfo = FrameworkUtil.split(action, ":");
			programName = (String)programInfo.get(0);
			methodName  = (String)programInfo.get(1);
			//This fix is required for advance compare
			if(methodName.indexOf('?')!=-1)
			{
				StringList methodNameList  = FrameworkUtil.split(methodName, "?");
				methodName = (String)methodNameList.get(0);
			}
			//Validating the JPO with LSA Callable class-START
			FrameworkUtil.validateMethodBeforeInvoke(context, programName, methodName, com.dassault_systemes.enovia.questionnaire.ExecuteCallable.class); 
			//END
			args = JPO.packArgs(parameterMap);
		}
		
		if("true".equals(mqlNoticeMode))
		{
			Map<String,String> mAjax = (Map)JPO.invoke(context, programName, args, methodName, args, Map.class);
			
			ArrayList<String> msgVector=new ArrayList<String>();
			context.updateClientTasks();
            ClientTaskList listNotices = context.getClientTasks();
            ClientTaskItr itrNotices = new ClientTaskItr(listNotices);
			
            StringBuilder sbMsgs=new StringBuilder();
		
            while (itrNotices.next()) {
                ClientTask clientTaskMessage = itrNotices.obj();
                String sTaskData = (String) clientTaskMessage.getTaskData();
                //msgVector.addElement(sTaskData);
                sbMsgs.append(sTaskData).append("\n");
            }
            
            context.clearClientTasks();
            
            PrintWriter writer = response.getWriter();
            writer.write(mAjax.get("count").toString()+mAjax.get("html").toString());
			writer.close();
		}
		else if("true".equals(ajaxMode))
		{
			Map<String,String> mAjax = (Map)JPO.invoke(context, programName, args, methodName, args, Map.class);

               String responseText="{\"result\":";
               responseText+="[";
			for (Iterator iterator = mAjax.keySet().iterator(); iterator.hasNext();) {
				String strKey = (String) iterator.next();
				String strValue=mAjax.get(strKey);
				responseText += "{\"text\": \"" + strKey + "\", \"value\": \"" + XSSUtil.encodeForHTMLAttribute(context, strValue) + "\"}";
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
	if ( null != jsFunctionCall && jsFunctionCall.contains("Ajax$") ){
		StringList slAjaxString=FrameworkUtil.split(jsFunctionCall, "$");
		out.clear();
		out.println((String)slAjaxString.get(1));
		jsFunctionCall="";
	}
	}
	catch (Exception exp) {
		exp.printStackTrace();
		String message = FrameworkUtil.findAndReplace(exp.getMessage(), "\\", "\\\\");
		message = FrameworkUtil.findAndReplace(message, "\"", "\\\"");
		jsFunctionCall = "alert(\"" + XSSUtil.encodeForJavaScript(context,  message) + "\")";
	}
%>
<% if(null != jsFunctionCall && ""!= jsFunctionCall){
		%>
<script language="javascript" src="../common/scripts/emxUICore.js"></script>

<jsp:include page="<%=strURL%>"></jsp:include>

			<script type="text/javascript">
	<%=(jsFunctionCall != null)?jsFunctionCall:""%>
			</script>
	
		<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
	<%@include file = "../emxUICommonEndOfPageInclude.inc"%>
	<%
	}
	%>
	
