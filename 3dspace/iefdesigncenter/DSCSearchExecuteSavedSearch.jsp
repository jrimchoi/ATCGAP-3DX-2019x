<%--  DSCSearchExecuteSavedSearch.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%@ page buffer="100kb" autoFlush="false" %>
<%-- 

   static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/DSCSearchExecuteSavedSearch.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>
<%@ page import="com.matrixone.jdom.*,
                 com.matrixone.jdom.Document,
                 com.matrixone.jdom.input.*,
                 com.matrixone.jdom.output.*" %>

<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<%@include file		= "DSCSearchUtils.inc"%>

<html>
<head>
<script language="javascript">
function doSubmit()
{
    document.forms[0].submit();
}
</script>
</head>
<title></title>
<body>
<form name='hiddenForm' method='post' action='emxInfoTable.jsp' target='_parent'>


<% // DSC 10.6 SP2 
   String sErrorMsg = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Error.SearchFailed",request.getHeader("Accept-Language"));
   String timeStampAdvancedSearch		= Request.getParameter(request,"timeStampAdvancedSearch");
   //sErrorMsg = URLEncoder.encode(sErrorMsg);
%>
<input type=hidden name="topActionbar" value="DSCSearchResultTopActionBar">
<input type=hidden name="pagination" value="10">
<input type=hidden name="selection" value="multiple">
<input type=hidden name="headerRepeat" value="10">
<input type=hidden name="targetLocation" value="popup">
<input type=hidden name="sortColumnName" value="name">
<input type=hidden name="Sortdirection" value="ascending">
<input type=hidden name="table" value="DSCDefault">
<!--XSSOK-->
<input type=hidden name="errorMessage" value="<%=sErrorMsg%>">
<input type=hidden name="expandCheckFlag" value="true">
<input type=hidden name="header" value="emxIEFDesignCenter.Header.SearchResults">
<input type=hidden name="suiteKey" value="DesignerCentral">
<input type=hidden name="timeStampAdvancedSearch" value="<xss:encodeForHTMLAttribute><%=timeStampAdvancedSearch%></xss:encodeForHTMLAttribute>">

<%
String findType				= "";
String appendCheckFlag		= "false";

try
{
    String sSearchParameters			= emxGetParameter(request, "searchParameters");  

	StringTokenizer tk	= new StringTokenizer(sSearchParameters, "{}");

	while(tk.hasMoreTokens())
	{
	    String token	= tk.nextToken();
		int pos			= token.indexOf("=");
		String paramName = "";
		String paramValue = "";
		if (pos >= 0) {
		  paramName = token.substring(0, pos);
		  paramValue = token.substring(pos+1, token.length());
			
		  if(paramName.equals("appendCheckFlag"))
		  {
			 appendCheckFlag = paramValue;
		  }

		  int posComma = paramValue.indexOf(",");

		  if (posComma >= 0 && !paramName.equalsIgnoreCase("txtType") && !paramName.equalsIgnoreCase("txtVault"))
		     paramValue = paramValue.substring(posComma+1);

		  if (paramName.equals("findType"))
		     findType = paramValue;
%>
            <!--XSSOK-->
            <input type='hidden' name="<%=paramName%>" value="<%=paramValue%>">
<%
	    }
	}
}
catch (Exception e)
{
}

//clear the output buffer
%>
<input type='hidden' name='table' value='DSCDefault'>
<input type='hidden' name='findType' value="<xss:encodeForHTMLAttribute><%=findType%></xss:encodeForHTMLAttribute>">
<input type='hidden' name='appendCheckFlag' value="<xss:encodeForHTMLAttribute><%=appendCheckFlag%></xss:encodeForHTMLAttribute>">
</form>
<script language="javascript">
    document.forms[0].target = "_parent";
    document.forms[0].submit();
</script>
</body>
</html>

