<%--  emxNavigatorErrorPage.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
   emxNavigatorError.jsp -- error page referenced by emxNavigatorInclude.jsp


   static const char RCSID[] = "$Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxNavigatorErrorPage.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$";
--%>

<%@ page import = "matrix.db.*,matrix.util.*,com.matrixone.servlet.*" isErrorPage="true"%>
<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUIActionbar.js"></script>
<%
matrix.db.Context context = Framework.getFrameContext(session);
%>
<html>
<head>
<%@include file = "../emxMQLNotice.inc"%>
</head>

<body>

<%
    //if null exception object, create one to display
    if (exception == null) {
       exception = new Exception("\"Exception Unavailable\"");
    }
	String sError= exception.toString();
	sError = sError.replace('\n',' ');
	sError = sError.replace('\r',' ');
%>
<script language="JavaScript">		
    //XSSOK	
	showError("<%=exception%>");
</script>
</body>
</html>


