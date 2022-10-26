<%--  emxTypeTreeHeader.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
    $Archive: /InfoCentral/src/infocentral/emxTypeTreeHeader.jsp $
    $Revision: 1.3.1.3$
    $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxTypeTreeHeader.jsp $
 * 
 * *****************  Version 13  *****************
 * User: Rahulp       Date: 1/16/03    Time: 8:43p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 12  *****************
 * User: Rahulp       Date: 1/14/03    Time: 4:00p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 11  *****************
 * User: Sameeru      Date: 03/01/07   Time: 15:56
 * Updated in $/InfoCentral/src/infocentral
 * Internationalising Tool Tip - done
 * 
 * *****************  Version 10  *****************
 * User: Priteshb     Date: 12/13/02   Time: 9:20p
 * Updated in $/InfoCentral/src/infocentral
 * HelpMarker integration
 * 
 * *****************  Version 9  *****************
 * User: Shashikantk  Date: 12/11/02   Time: 7:35p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 8  *****************
 * User: Snehalb      Date: 11/26/02   Time: 5:12p
 * Updated in $/InfoCentral/src/InfoCentral
 * indented
 * 
 * *****************  Version 7  *****************
 * User: Shashikantk  Date: 11/23/02   Time: 6:56p
 * Updated in $/InfoCentral/src/InfoCentral
 * Code cleanup
 * 
 * *****************  Version 6  *****************
 * User: Shashikantk  Date: 11/21/02   Time: 6:56p
 * Updated in $/InfoCentral/src/InfoCentral
 * Removed the space between <%@include file and '='.
 *
 ************************************************
 *
--%>

<%@include file="emxInfoCentralUtils.inc"%> 			<%--For context, request wrapper methods, i18n methods--%>
<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>
<script language="javascript" type="text/javascript" src="emxInfoHelpInclude.js"></script>
  <script language="javascript" src="emxInfoTypeBrowser.js"></script>

<%
    String pageHeading = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Common.SelectType", request.getHeader("Accept-Language"));   
//    String appendParam = emxGetQueryString(request);
	String helpHTML = "";
    String helpMarker = "emxHelpTypeSelectorDialog";
	String help=FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Common.Help",request.getHeader("Accept-Language"));
	String appDirectory = (String)application.getAttribute("eServiceSuiteIEFDesignCenter.Directory");
	helpHTML = "<a href=\"javascript:openHelp('" + helpMarker + "', '" + appDirectory + "', '" + langStr + "')\"><img src=\"../integrations/images/buttonContextHelp.gif\" alt="+help+" border=\"0\"></a>";
	String sChkbxTopLevel= emxGetParameter(request,"chkbxTopLevel");
	String sType= emxGetParameter(request,"strType");
	String checked="true".equals(sChkbxTopLevel)?"checked":"";
%>

<script language="JavaScript">


	function refresh(){
	var topLevel='false';
	if(document.forms[0].topLavel.checked)
	topLevel='true';
    document.forms[1].chkbxTopLevel.value=topLevel;
	document.forms[1].target='_top';
	document.forms[1].action='emxTypeSelectorDialog.jsp';
	document.forms[1].submit();
	}
</script>
<html>
  <head>
<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIList.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIDialog.css" type="text/css">
<script language="javascript" src="../emxUIFilterUtility.js"></script>
  </head>
<body onload="loadTree()">

<form name ='headerform' method="post" action="emxTypeSelectorTree.jsp?" target="treeDisplay">

<%
boolean csrfEnabled = ENOCsrfGuard.isCSRFEnabled(context);
if(csrfEnabled)
{
  Map csrfTokenMap = ENOCsrfGuard.getCSRFTokenMap(context, session);
  String csrfTokenName = (String)csrfTokenMap .get(ENOCsrfGuard.CSRF_TOKEN_NAME);
  String csrfTokenValue = (String)csrfTokenMap.get(csrfTokenName);
%>
  <!--XSSOK-->
  <input type="hidden" name= "<%=ENOCsrfGuard.CSRF_TOKEN_NAME%>" value="<%=csrfTokenName%>" />
  <!--XSSOK-->
  <input type="hidden" name= "<%=csrfTokenName%>" value="<%=csrfTokenValue%>" />
<%
}
//System.out.println("CSRFINJECTION");
%>

<input type=hidden name="strType"  value ="<xss:encodeForHTMLAttribute><%=sType%></xss:encodeForHTMLAttribute>">
<input type=hidden name="chkbxTopLevel"  value ="<xss:encodeForHTMLAttribute><%=sChkbxTopLevel%></xss:encodeForHTMLAttribute>">
<table border="0" cellspacing="2" cellpadding="0" width="100%">
<tr>
      <td class="pageBorder"><img src="../spacer.gif" width="1" height="1"></td>
</tr>
</table>

<table border="0" width="100%" cellpadding="2">
  <tr>
    <!--XSSOK-->
    <td class="pageHeader"><%=pageHeading%><img src="../spacer.gif" width="1" height="1"></td>
	<td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="../common/images/utilProgressDialog.gif" width="34" height="28" name="progress" ></td>
  </tr>
</table>
<table border="0" cellspacing="2" cellpadding="0" width="100%">
<tr>
      <td class="pageBorder"><img src="../spacer.gif" width="1" height="1"></td>
  </tr>
</table>

<table border="0" width="60%" align="right">
<tr>
	<td class="field" align="right"><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.TopLevel</framework:i18n></td>
	<!--XSSOK-->
	<td class="field" align="left"><input type="checkbox" name="topLavel" value="toplevel" <%=checked%> ></td>
	<!--XSSOK-->
	<td align="left"><a href="javascript:refresh()" ><img src="images/iconFilter.gif" border="0" alt="<%=FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Common.Refresh", request.getHeader("Accept-Language"))%>"></a></td>
	<!--XSSOK-->
    <td align="right"><%=helpHTML%></td>
</tr>
</table>

  <input type="hidden" name="txtName" />
  <input type="hidden" name="txtID" />
</form>
<form name ="header2" method="post" action="emxTypeSelectorTree.jsp" target="treeDisplay">

<%
boolean csrfEnabled1 = ENOCsrfGuard.isCSRFEnabled(context);
if(csrfEnabled1)
{
  Map csrfTokenMap1 = ENOCsrfGuard.getCSRFTokenMap(context, session);
  String csrfTokenName1 = (String)csrfTokenMap1 .get(ENOCsrfGuard.CSRF_TOKEN_NAME);
  String csrfTokenValue1 = (String)csrfTokenMap1.get(csrfTokenName1);
%>
  <!--XSSOK-->
  <input type="hidden" name= "<%=ENOCsrfGuard.CSRF_TOKEN_NAME%>" value="<%=csrfTokenName1%>" />
  <!--XSSOK-->
  <input type="hidden" name= "<%=csrfTokenName1%>" value="<%=csrfTokenValue1%>" />
<%
}
//System.out.println("CSRFINJECTION");
%>

<input type=hidden name="strType"  value ="<xss:encodeForHTMLAttribute><%=sType%></xss:encodeForHTMLAttribute>">
<input type=hidden name="chkbxTopLevel"  value ="<xss:encodeForHTMLAttribute><%=sChkbxTopLevel%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="numTypes" />
<script language="javascript">
    function loadTree() 
    {
        document.forms[1].submit();
    }
</script>
</form>
</body>
</html>
