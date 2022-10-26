<%@page import="java.util.HashMap"%>
<%@include file="../common/emxNavigatorInclude.inc"%>
<%@include file="../emxUICommonHeaderBeginInclude.inc"%>
<%@page import="com.matrixone.apps.domain.DomainObject, com.matrixone.apps.domain.util.*"%>
<%@include file="../emxUICommonHeaderEndInclude.inc"%>
<%@include file="../common/emxNavigatorTopErrorInclude.inc"%>
<%@ page import="com.matrixone.servlet.*,matrix.db.*"%>
<!DOCTYPE>
<html>
<link rel="stylesheet" type="text/css" href="../common/styles/emxUIDefault.css"/>
<% boolean isComplete = "download-complete".equalsIgnoreCase(emxGetParameter(request, "downloadStatus"));%>
<script type="text/javascript">
if(<%=isComplete%>) {
	document.body.className="download-complete";
}
</script>
<body onLoad="resizeWindow();" class="download-progress">
<form name="downloadForm" action="" method="post" target="">
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
	
<div id="emxDialogBody">
    <div id="progress">
        <h1><emxUtil:i18n localize="i18nId">Downloading...</emxUtil:i18n></h1>
        <p><emxUtil:i18n localize="i18nId">Do not close this window until the download is complete or your file transfer will be interrupted.</emxUtil:i18n></p>
    </div>
    <div id="complete">
        <h1><emxUtil:i18n localize="i18nId">Download Complete</emxUtil:i18n></h1>
        <p><emxUtil:i18n localize="i18nId">Your File Transfer is complete. Please close this window to continue.</emxUtil:i18n></p>
    </div>
</div>
<div id="emxDialogFoot">
    <div id ="closeButton" ><input type="button" value="Close" onclick="javascript:window.close();"/></div>
</div>
</form>
<script type="text/javascript">

function resizeWindow()
{	
	window.resizeTo(550,300);
	if(document.body.className=="download-progress") {
		document.forms["downloadForm"].action="../DownloadPackage/Execute.jsp";
	}
	else {
		document.forms["downloadForm"].action="";
	}
	document.forms["downloadForm"].submit();
}

function doSubmit() 
{
    //document.forms["downloadForm"].progress.src="../common/images/utilSpacer.gif";
    document.forms["downloadForm"].submit();
}
</script>
</body>
</html>
