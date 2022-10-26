<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@page import="com.dassault_systemes.enovia.documentcommon.DCConstants"%>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
<%
boolean showNoticeMsg=false;
String errorMsg ="";
try{
context.updateClientTasks();
ClientTaskList listNotices 	= context.getClientTasks();	
ClientTaskItr itrNotices 	= new ClientTaskItr(listNotices);
StringBuilder sbMessages	= new StringBuilder();

while (itrNotices.next()) {
	System.out.println("itrNotices1"+itrNotices);
	ClientTask clientTaskMessage =  itrNotices.obj();
		sbMessages.append((String) clientTaskMessage.getTaskData());
		sbMessages.append("\n\n");
	}
	

	errorMsg = sbMessages.toString();

context.clearClientTasks();

showNoticeMsg= errorMsg != null && !errorMsg.equals("") && !errorMsg.equals("null");


		

}
catch (Exception e) {
	
}




String strObjectId = emxGetParameter(request, DCConstants.OBJECTID);
String strRefreshTableContent = emxGetParameter(request, "refreshTableContent");

String message = (String)session.getValue("error.message");
	boolean showAlert = message != null && !message.equals("") && !message.equals("null");
	session.removeValue("error.message");


if("true".equalsIgnoreCase(strRefreshTableContent))
{
%>
<script language="Javascript">
if("<%=showAlert%>" == "true") {
  	alert("<xss:encodeForJavaScript><%=message%></xss:encodeForJavaScript>");

  }
if("<%=showNoticeMsg%>" == "true") {
  	alert("<xss:encodeForJavaScript><%=errorMsg%></xss:encodeForJavaScript>");

  }


   	getTopWindow().getWindowOpener().location.href = getTopWindow().getWindowOpener().location.href;
   	getTopWindow().closeWindow();
</script>	
<%
}
else
{
%>
<script language="Javascript" src="../common/scripts/emxUIConstants.js"></script>
<script language="Javascript">
if("<%=showAlert%>" == "true") {
  	alert("<xss:encodeForJavaScript><%=message%></xss:encodeForJavaScript>");

  }

if("<%=showNoticeMsg%>" == "true") {
  	alert("<xss:encodeForJavaScript><%=errorMsg%></xss:encodeForJavaScript>");

  }

	var contentFrame = findFrame(getTopWindow().getWindowOpener().getTopWindow(), "content");
	if(contentFrame)
	{ 
		contentFrame.document.location.href = "../common/emxTree.jsp?objectId=<%=XSSUtil.encodeForURL(context, strObjectId)%>";
	}
	getTopWindow().closeWindow();
</script>
<%
}
%>

