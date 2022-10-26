<%--  eServiceError.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/InfoCentral/eServiceError.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$
 
--%>

<%--
 *
 * $History: eServiceError.jsp $
 * 
 * *****************  Version 5  *****************
 * User: Mallikr      Date: 11/26/02   Time: 6:24p
 * Updated in $/InfoCentral/src/InfoCentral
 * added header
 *
 * ***********************************************
 *
--%>

<%@ page import = "matrix.db.*, matrix.util.*, com.matrixone.servlet.*" isErrorPage="true" %>

<%//Start Internationalization%>
<%@include file = "../emxTagLibInclude.inc"%>
<framework:localize id="framework" bundle="emxIEFDesignCenterStringResource" locale='<%= request.getHeader("Accept-Language") %>'/>
<%!
  // Call this method to internationalize variables in java.
  // i18nStringNow("stringid", request.getHeader("Accept-Language"));
  static public String i18nStringNow(String text, String languageStr)
  {
    com.matrixone.apps.domain.util.i18nNow  loc = new com.matrixone.apps.domain.util.i18nNow();
    return (String) loc.GetString("emxIEFDesignCenterStringResource ", languageStr, text);
  }
%>
<%//End Internationalization%>

<html>
<head>
<style type="text/css" >
TABLE.error {	BACKGROUND-COLOR: #f00}
TH.error {	FONT-WEIGHT: bold; FONT-SIZE: 13px; COLOR: #fff; BACKGROUND-COLOR: #f00; TEXT-ALIGN: left}
TD.errMsg {	FONT-WEIGHT: bold; FONT-SIZE: 11px; COLOR: #f00; BACKGROUND-COLOR: #eee}
</style>
<script language="JavaScript">
function reDirect(){
//XSSOK
	alert("<%=exception.toString().trim()%>");
	parent.window.close();
}


</script>
</head>

<body bgColor=white onLoad="reDirect()">

<%
  matrix.db.Context context = null;

  if (exception == null) {
    exception = new Exception("\"Exception Unavailable\"");
  }

  try{
    context = Framework.getFrameContext(session);
  }catch(Exception e){
    context = null;
  }

%>
</body>
</html>

