<%--  emxBlank.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>


<html>
<title>blank Document</title>
<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css">
<%@page import ="com.matrixone.apps.domain.util.*" %>
<%
	String sShowTimer=Request.getParameter(request,"showTimer");
	if((null != sShowTimer) && !("null".equalsIgnoreCase(sShowTimer)) && (sShowTimer.length() !=0)){
%>
	<body id="blankBody" name="blankBody" onLoad="JavaScript:document.getElementById('blankBody').style.cursor='wait';"  onUnload="JavaScript:document.getElementById('blankBody').style.cursor='';">
<%
	}else{
%>
	<body>
<%
	}
%>
</body>
</html>
