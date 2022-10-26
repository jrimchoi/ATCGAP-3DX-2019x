<%--  emxComponentsValidateUserProcess.jsp -
   Copyright (c) 1992-2017 Dassault Systemes.
   All Rights Reserved.
   This program contains proprietary and trade secret information of MatrixOne,
   Inc.  Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

   static const char RCSID[] = "$Id: emxComponentsValidateUserProcess.jsp.rca 1.14 Wed Oct 22 16:17:48 2008 przemek Experimental przemek $"
--%>
<%@ page import="com.matrixone.apps.framework.ui.UINavigatorUtil,com.matrixone.apps.domain.util.BackgroundProcess" %>

<%@include file = "../emxUICommonAppInclude.inc"%>
<%@include file = "../components/emxComponentsUtil.inc"%> 
<%@ page import = "com.dassault_systemes.enovia.periodicreview.PeriodicReviewConstants"%>

<%@ page import="com.matrixone.apps.framework.ui.UINavigatorUtil,com.matrixone.apps.domain.util.BackgroundProcess" %>


<html>
	<head>
<%
boolean bEnableFDA = "TRUE".equalsIgnoreCase(EnoviaResourceBundle.getProperty(context, "emxFramework.Routes.EnableFDA"));
if(bEnableFDA)
{
		  String passportURL = PropertyUtil.getEnvironmentProperty(context, "PASSPORT_URL");
		  boolean is3DPassportServerInUse = (passportURL != null && passportURL.length() > 0);
	boolean bExternalAuth = "TRUE".equalsIgnoreCase(EnoviaResourceBundle.getProperty(context, "emxFramework.External.Authentication"));
	String strLogoutURL = Framework.getClientSideURL(response, "emxLogout.jsp");
	if (bExternalAuth && is3DPassportServerInUse) {
			  strLogoutURL = passportURL + "/logout?service=" + PropertyUtil.getEnvironmentProperty(context, "MYAPPS_URL");
		  }
%>

		<script language="Javascript">
			function doLogout() {
				var logoutURL = "<%=strLogoutURL%>";
				//
				// Can't use teh getTopWindow() function because it is not defined/included here.
				top.opener.top.location.href = logoutURL;
			}
			function resetForm() {
				parent.frames["pagecontent"].document.forms["verifyForm"].reset();
			}
		</script>
	</head>
<body>

<form name="newForm" method="post">
<%@include file = "../common/enoviaCSRFTokenInjection.inc"%>
<%
String username = emxGetParameter(request,"userName");
String pwd = emxGetParameter(request,"password");
boolean showUserName = "true".equalsIgnoreCase(emxGetParameter(request, "showUserName"));
String fromPage = emxGetParameter(request,"fromPage");
String keyValue = emxGetParameter(request,"keyValue");
// Added for bug 354935
boolean bcasesensitive = true;
String strQuery = "print system casesensitive";
String strResult = MqlUtil.mqlCommand(context,strQuery);
if(strResult != null)
{
	StringList strlTemp = FrameworkUtil.split(strResult,"=");

	if(strlTemp != null && strlTemp.size() > 0 && "off".equalsIgnoreCase( (String) strlTemp.get(1)))
	{
	    bcasesensitive = false;
	}
}
// Ended
if(!showUserName) {
	username = (context.getUser()).toString();
}

String contextUser = context.getUser();
if(!bcasesensitive) {
    username = username.toLowerCase();
    contextUser = contextUser.toLowerCase();
}

String errMsg = null;
if (bExternalAuth) {
	if (username.equals(contextUser)) {
   	    // If passport URL exist then go to 3DPassport server, else there may be other external authentication mechanism
	    // and we fall out to the authentication using context object
	   	if (is3DPassportServerInUse) {
	   		try {
	   			com.matrixone.apps.domain.util.CASAuthentication casAuthentication = (com.matrixone.apps.domain.util.CASAuthentication)session.getAttribute("com.matrixone.apps.domain.util.CASAuthentication");
				if (casAuthentication == null) {
				
				 	casAuthentication = new com.matrixone.apps.domain.util.CASAuthentication(passportURL);
				 	session.setAttribute("com.matrixone.apps.domain.util.CASAuthentication", casAuthentication);
				}
				casAuthentication.authenticate(username, pwd);//TODO What about the tenant value??
				session.removeAttribute("com.matrixone.apps.domain.util.CASAuthentication");
			} 
	   		catch (Exception ex) {
		    	//
		    	// The 3DPassport confiuguration should be same as emxFramework.Routes.VerificationCount or there should be a way to know 
		    	// max failure allowed by the 3DPassport server.
		    	//
		    	int maxCount = Integer.parseInt(EnoviaResourceBundle.getProperty(context, "emxFramework.Routes.VerificationCount"));
		    	 String strCount = (String)session.getAttribute("VerificationCount");
		    	 int count = (strCount != null && !"".equals(strCount))?Integer.parseInt(strCount):0;
		    	
		    	 count++;
		    	 session.setAttribute("VerificationCount", String.valueOf(count));
		    	 
		    	 if (count >= maxCount) {
		    		 errMsg = "'"+ PersonUtil.getFullName(context) + "' " + EnoviaResourceBundle.getProperty(context,"emxFrameworkStringResource", context.getLocale(), "emxFramework.Routes.PersonInactivatedSubject");
		    		 session.invalidate();
%>
					<script language="Javascript">
						alert("<%=XSSUtil.encodeForJavaScript(context, errMsg)%>");
						doLogout();
					</script>
<%
		    	 }
		    	 else {
		    		 errMsg = ComponentsUtil.i18nStringNow("emxComponents.UserAuthentication.Error",request.getHeader("Accept-Language"));
%>
		   	    	<script language="Javascript">
			   	    	alert("<%=XSSUtil.encodeForJavaScript(context, errMsg)%>");
			   	    	resetForm();
		   	    	</script>
<%
		    	 }
		    	 
		    	 return;
		    }
	   	}
	   	else {
		try {
	   			HashMap creds = new HashMap();
	   	        creds.put("MX_PAM_USERNAME", username);
	   	        creds.put("MX_PAM_PASSWORD", pwd);
	   	        creds.put("MX_PAM_TENANT", context.getTenant());
	   	        Context ctx = new Context(":bos", "");
	   	        ctx.setCredentials(creds);
	   	        ctx.connect();
	   	     context.resetContext(username, "", context.getVault().toString());
	   	    } catch (Exception ex) {
	   	    	errMsg = ComponentsUtil.i18nStringNow("emxComponents.UserAuthentication.Error",request.getHeader("Accept-Language"));
%>
	   	    	<script language="Javascript">
		   	    	alert("<%=XSSUtil.encodeForJavaScript(context, errMsg)%>");
		   	    	parent.window.close();
	   	    	</script>
<%
    	        return;            
	   	    }   		
	   	}
	}
	else {
		errMsg = ComponentsUtil.i18nStringNow("emxComponents.UserAuthentication.Error",request.getHeader("Accept-Language"));
%>
		<script language="Javascript">
		  alert("<%=XSSUtil.encodeForJavaScript(context, errMsg)%>");
		  resetForm();
		</script>
<%	
		return;
	}
} else {
    String strMaxCount = EnoviaResourceBundle.getProperty(context,"emxFramework.Routes.VerificationCount");
    String strCount = (String)session.getValue("VerificationCount");
    int maxCount = Integer.parseInt(strMaxCount);
    int count = (strCount != null && !"".equals(strCount))?Integer.parseInt(strCount):0;

    if(count == maxCount-1 && ( ((bcasesensitive)?!username.equals(context.getUser()):!username.equalsIgnoreCase(context.getUser()))|| !pwd.equals(context.getPassword())))
    {
        com.matrixone.apps.common.Person person = com.matrixone.apps.common.Person.getPerson(context);
        StringList personIds = new StringList();
        personIds.add(person.getId());

        //send notification to people configured in property file
        String notificationUsers = EnoviaResourceBundle.getProperty(context,"emxFramework.Routes.NotifyPeople");
        String subject = EnoviaResourceBundle.getFrameworkStringResourceProperty(context, "emxFramework.Routes.PersonInactivatedMessage", context.getLocale());
        String message =  EnoviaResourceBundle.getProperty(context, PeriodicReviewConstants.PERIODIC_REVIEW_STRING_RESOURCE, context.getLocale(),
				"enoPeriodicReview.Notification.PersonInactivatedMessage");
        if(notificationUsers != null)
        {
         StringList notificationUserList = FrameworkUtil.split(notificationUsers,",");
         MailUtil.sendMessage(context,
                                    notificationUserList,
                                    null,
                                    null,
                                    subject,
                                    context.getUser() + " " + message,
                                    null);
        }

      //  person.triggerDemoteAction(context,personIds); 
try {	            
	            BackgroundProcess backgroundProcess = new BackgroundProcess();
	            Object objectArray[]	 = {context, personIds};
	            Class objectTypeArray[]  = {context.getClass(),personIds.getClass()};
	            com.matrixone.apps.common.Person object = new com.matrixone.apps.common.Person(person.getId());
	            backgroundProcess.submitJob(context, person, "deactivatePersonInBackGround", objectArray, objectTypeArray);
	        } catch(Exception ex) {
	        	session.invalidate();
	            throw new FrameworkException(ex);
	        }
        session.invalidate();

        String failedAuthentication1 = ComponentsUtil.i18nStringNow("emxComponents.UserAuthentication.Fail1",request.getHeader("Accept-Language"));
        String failedAuthentication2 = ComponentsUtil.i18nStringNow("emxComponents.UserAuthentication.Fail2",request.getHeader("Accept-Language"));
        errMsg = failedAuthentication1 + " " + maxCount + " " + failedAuthentication2;
%>
		<script language="Javascript">
			alert("<%=XSSUtil.encodeForJavaScript(context, errMsg)%>");
			doLogout();
		</script>
<%

        return;
    }
    else if (((bcasesensitive)?!username.equals(context.getUser()):!username.equalsIgnoreCase(context.getUser())) || !pwd.equals(context.getPassword()))
    {
    	
    	
        errMsg = ComponentsUtil.i18nStringNow("emxComponents.UserAuthentication.Error",request.getHeader("Accept-Language"));
        session.putValue("VerificationCount",String.valueOf(++count));
%>
		<script language="Javascript">
			alert("<%=XSSUtil.encodeForJavaScript(context, errMsg)%>");
			resetForm();
		</script>
<%
        return;
    }
    else
    {
        session.removeAttribute("VerificationCount");
    }
}
}
final String action = emxGetParameter(request, "action");

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
       throw new Exception("Error: Mandatory parameter 'action' missing.");
    }
	
	matrix.db.Context reqContext = (matrix.db.Context)request.getAttribute("context");
	if(reqContext!=null)
	{
		context = reqContext;
	}
	Map<String, String[]> parameterMap = new HashMap<String, String[]>();
	Enumeration paramEnum = emxGetParameterNames (request);
	while (paramEnum.hasMoreElements()) {
		String parameter = (String)paramEnum.nextElement();
		String[] values = emxGetParameterValues(request, parameter);
		
		parameterMap.put(parameter, values);
		
		for (String value : values) {
%>
			<input type="hidden" name="<%=parameter%>" value="<xss:encodeForHTMLAttribute><%=value%></xss:encodeForHTMLAttribute>"/>
<%		
		}
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
	//FrameworkUtil.validateMethodBeforeInvoke(context, programName, methodName, com.dassault_systemes.enovia.periodicreview.ExecuteCallable.class);
	String[] args = JPO.packArgs(parameterMap);
	mResponse = (Map)JPO.invoke(context, programName, args, methodName, args, Map.class);
	strJavaScript = (String)mResponse.get("JavaScript");
	}
catch (Exception exp) {
	exp.printStackTrace();
	String message = FrameworkUtil.findAndReplace(exp.getMessage(), "\n", "\\n");
	message = FrameworkUtil.findAndReplace(message, "\"", "\\\"");
	strJavaScript = "alert(\"" + message + "\");";
}
if(!UIUtil.isNullOrEmpty(strJavaScript))
{
%>
	<jsp:include page="<%=strURL%>"></jsp:include>
	<script type="text/javascript">
	
	function decodeHtmlEntity(text) {
		  return text.replace(/&#(\d+);/g, function(match,dec) {
		    return String.fromCharCode(dec);
		  });
		}
/* XSSOK */	<%=strJavaScript%> 
	</script>
				
<%-- <%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
<%@include file = "../emxUICommonEndOfPageInclude.inc"%> --%>
	

<%		}
%>
</form>
</body>
</html>



