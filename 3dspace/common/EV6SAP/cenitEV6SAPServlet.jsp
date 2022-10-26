<%@ include file = "../../emxUICommonAppInclude.inc"%>
<%@ include file = "../../emxI18NMethods.inc"%>
<%@ page errorPage = "emxNavigatorErrorPage.jsp"%>
<%@ page import = "matrix.db.Context" %>
<%@ page language="java" %>
<script language = "Javascript" src="../../common/scripts/emxUIConstants.js"></script>
<%

String URI = request.getRequestURI();
StringTokenizer ST = new StringTokenizer(URI, "/");
String Hostname = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/" + ST.nextToken() + "/";
String Mode = emxGetParameter(request, "Mode");
String Operation = emxGetParameter(request, "Operation");
String ObjectId = emxGetParameter(request, "objectId");

String User = context.getUser();
String Password = context.getPassword();
String Language = context.getLocale().getLanguage();
String Vault = context.getVault().getName();
String DialogMode = emxGetParameter(request, "DialogMode");
String ProgressInfo = emxGetParameter(request, "ProgressInfo");
String ev6sapPreTrace = System.getenv("EV6SAP_PRE_TRACE");
boolean Trace = ev6sapPreTrace != null && ! ev6sapPreTrace.isEmpty();

	java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>222>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>JSP / \n\n\n----------EV6SAP Servlet JSP " + df.format(new Date()) + "----------");
    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>222>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>JSP / URI: " + URI);
    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>JSP / Hostname: " + Hostname);
    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>JSP / Mode: " + Mode);
    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>JSP / User: " + User);
    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>JSP / Lang: " + Language);
    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>JSP / Vault: " + Vault);
    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>JSP / Operation: " + Operation);
    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>JSP / ObjectID: " + ObjectId);
    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>JSP / DialogMode: " + DialogMode);
    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>JSP / ProgressInfo1234: " + ProgressInfo);	

	
	
System.out.println("JSP / 1 before");


String Refresh = emxGetParameter(request, "Refresh");


System.out.println("JSP / 1 before");


if (Trace) System.out.println("JSP / 1 before");
	
	
	
	System.out.println("JSP /2 before");
request.setAttribute("context",context);
request.setAttribute("URI", URI);
request.setAttribute("Hostname", Hostname);
request.setAttribute("Mode", Mode);
request.setAttribute("User", User);
request.setAttribute("Language", Language);
request.setAttribute("Vault", Vault);
request.setAttribute("Operation", Operation);
request.setAttribute("ObjectID", ObjectId);
request.setAttribute("DialogMode", DialogMode);
request.setAttribute("ProgressInfo", ProgressInfo);
request.setAttribute("Password", Password);

System.out.println("JSP /4 before");
RequestDispatcher dispatcher = request.getRequestDispatcher("/ev6sapServlet");

if (dispatcher != null){

dispatcher.include(request, response);

} 
	
	

%>
<H2></H2>
<script language="Javascript">
window.close();
</script>

