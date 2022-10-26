<%@ include file = "../emxUICommonAppInclude.inc"%>
<%@ page errorPage = "emxNavigatorErrorPage.jsp"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<script language="Javascript" src="../common/scripts/emxUIConstants.js"></script>
<script language="Javascript">window.moveTo(9000, 9000);</script>
<%
String uri = request.getRequestURI();
StringTokenizer st = new StringTokenizer(uri, "/");
String hostname = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/" + st.nextToken() + "/";
String user = context.getUser();
String password = context.getPassword();
String language = context.getLocale().getLanguage();
String vault = context.getVault().getName();
String mode = emxGetParameter(request, "mode");
String operation = emxGetParameter(request, "operation");
String objectId = emxGetParameter(request, "objectId");
String fieldName = emxGetParameter(request, "fieldNameActual");
String tableRowIdList[] = emxGetParameterValues(request, "emxTableRowId");
String drtoolsKey = emxGetParameter(request, "drtoolsKey");
String postProcessURL = emxGetParameter(request, "postProcessURL");

String tableRowIds = null;
if (tableRowIdList != null) {
        tableRowIds = "";
        for (int i = 0; i < tableRowIdList.length; i++)
                tableRowIds += "," + tableRowIdList[i];
        tableRowIds = tableRowIds.substring(1);
}
String drlTrace = System.getenv("DRL_TRACE");
boolean trace = drlTrace != null && ! drlTrace.isEmpty();
if (trace) {
    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    System.out.println("\n\n\n----------drV6ToolsAppletJSP " + df.format(new Date()) + "----------");
    System.out.println("JSP / Uri = " + uri);
    System.out.println("JSP / Hostname = " + hostname);
    System.out.println("JSP / User = " + user);
    System.out.println("JSP / Lang = " + language);
    System.out.println("JSP / Vault = " + vault);
    System.out.println("JSP / Mode = " + mode);
    System.out.println("JSP / Operation = " + operation);
    System.out.println("JSP / ObjectId = " + objectId);
        System.out.println("JSP / TableRowIds = " + tableRowIds);
        System.out.println("JSP / fieldName = " + fieldName);
        System.out.println("JSP / drtoolsKey = " + drtoolsKey);
        System.out.println("JSP / postProcessURL = " + postProcessURL);
//	Enumeration e = emxGetParameterNames(request);
//	int i = 0;
//  while (e.hasMoreElements())
//		System.out.println("JSP / Parameter[" + i++ + "] = " + e.nextElement());
}
if (mode == null) {
    if (trace) System.out.println("JSP / 1 before");
%>
<p>
<applet code="com.designrule.drv6tools.DRLApplet.class" jnlp_href="drV6Tools.jnlp">
    <param name="hostname" value="<%=hostname%>">
    <param name="user" value="<%=user%>">
    <param name="password" value="<%=password%>">
    <param name="language" value="<%=language%>">
    <param name="vault" value="<%=vault%>">
    <param name="operation" value="<%=operation%>">
    <param name="objectId" value="<%=objectId%>">
    <param name="tableRowIds" value="<%=tableRowIds%>">
    <param name="fieldName" value="<%=fieldName%>">
    <param name="drtoolsKey" value="<%=drtoolsKey%>">
    <param name="postProcessURL" value="<%=postProcessURL%>">
</applet>
</p>
<%
    if (trace) System.out.println("JSP / 1 after");
} else {
    if (trace) System.out.println("JSP / 2 before");
    if (mode.equalsIgnoreCase("refresh")) {
%>
<script language="Javascript">
	var postProcessURL = "<%=postProcessURL%>";
	alert(postProcessURL);
    var content = findFrame(top, "detailsDisplay");
    if (content == null) content = findFrame(top, "content");
    if (content != null)
    {
        if (postProcessURL == null || postProcessURL == "" || postProcessURL == "null")
        {
            content.document.location.href = content.document.location.href;   
        } else {
            content.document.location.href = postProcessURL;
        }
	}
    
</script>
<%
    } else if (mode.equalsIgnoreCase("cancel")) {
%>
<script language="Javascript">
    top.close();
</script>
<%
    } else if (mode.equalsIgnoreCase("value")) {
        String fieldNameDisplay = emxGetParameter(request, "fieldNameDisplay");
        String fieldNameActual = emxGetParameter(request, "fieldNameActual");
        String fieldValue = emxGetParameter(request, "fieldValue");
        if (trace) {
            System.out.println("JSP / FieldNameDisplay = " + fieldNameDisplay);
            System.out.println("JSP / FieldNameActual = " + fieldNameActual);
            System.out.println("JSP / FieldValue = " + fieldValue);
        }
%>
<script language="Javascript">
    var fieldValue = <%=fieldValue%>;
    if (fieldValue.indexOf("\01") > 0) {
        var nameValuePairs = fieldValue.split("\01");
        for (var i = 0; i < nameValuePairs.length; i++) {
            var nameValue = nameValuePairs[i].split("=");
            var setString = "top.opener.document.forms[0]['" + nameValue[0] + "'].value='" + nameValue[1] + "';";
                     		alert(setString);
            try {
                eval(setString);
            } catch (err) {
                alert("Failed to update " + nameValue[0] + " with value " + nameValue[1] + err.message);
            }
        }
    } else {
        var setString = "top.opener.document.forms[0]['<%=fieldNameDisplay%>'].value=<%=fieldValue%>;";
             	alert(setString);
        eval(setString);
        var setString = "top.opener.document.forms[0]['<%=fieldNameActual%>'].value=<%=fieldValue%>;";
              	alert(setString);
        eval(setString);
    }
    top.close();
</script>
<%
    }
    if (trace) System.out.println("JSP / 2 after");
}
%>