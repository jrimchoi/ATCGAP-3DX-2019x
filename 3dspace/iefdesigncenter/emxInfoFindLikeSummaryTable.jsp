<%--  emxInfoFindLikeSummaryTable.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
    $Archive: /InfoCentral/src/infocentral/emxInfoAdvancedSearchSummaryTable.jsp $
    $Revision: 1.3.1.3$
    $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoAdvancedSearchSummaryTable.jsp $
 * 
 * *****************  Version 12  *****************
 * User: Rahulp       Date: 1/16/03    Time: 10:14p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 11  *****************
 * User: Rahulp       Date: 12/03/02   Time: 1:43p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 10  *****************
 * User: Rahulp       Date: 11/29/02   Time: 4:55p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 9  *****************
 * User: Snehalb      Date: 11/25/02   Time: 8:12p
 * Updated in $/InfoCentral/src/InfoCentral
 * added try-catch block for encode
 * 
 * *****************  Version 8  *****************
 * User: Mallikr      Date: 02/11/12   Time: 18:53
 * Updated in $/InfoCentral/src/InfoCentral
 * internationalization bug fixes
 * 
 * *****************  Version 7  *****************
 * User: Rahulp       Date: 11/08/02   Time: 12:45p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 6  *****************
 * User: Gauravg      Date: 11/07/02   Time: 3:41p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 5  *****************
 * User: Mallikr      Date: 10/30/02   Time: 3:32p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 4  *****************
 * User: Rahulp       Date: 10/29/02   Time: 12:51p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 3  *****************
 * User: Bhargava     Date: 5/10/02    Time: 2:20p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 1  *****************
 * User: Bhargava     Date: 9/25/02    Time: 2:50p
 * Created in $/InfoCentral/src/InfoCentral
 *
 * ***********************************************
 *
--%>
<%@include file="emxInfoCentralUtils.inc"%>
<%@ page import = "com.matrixone.MCADIntegration.utils.*" %>


<%!

  public String replaceString(String str,String replace,String newString){
	  while(str.indexOf(replace)!=-1){
		  int index =str.indexOf(replace);
		  String restStr=str.substring(index+replace.length());
		  str=str.substring(0,index)+newString+restStr;
	  }
	  return str;
  }

%>
<html>
<head>
<script language="javascript">
function redirectToNewLocation()
{
	document.findLikeForm.method="post";
	document.findLikeForm.target="_parent" ;
	document.findLikeForm.action="emxInfoTable.jsp";
	document.findLikeForm.submit();
}
</script>
</head>
<body onLoad="redirectToNewLocation()">
<form  name="findLikeForm">


<%
 String funcPageName        = MCADGlobalConfigObject.PAGE_SEARCH_RESULTS;
 Enumeration enumParamNames = emxGetParameterNames(request);
 while(enumParamNames.hasMoreElements()) 
 {
	String paramName = (String) enumParamNames.nextElement();
	String paramValue = emxGetParameter(request, paramName);
	paramValue = replaceString(paramValue,"\"", "&quot;");
%>
<!--XSSOK-->
<input type=hidden name="<%=paramName%>" value="<%=paramValue%>" >
<%
 }
%>
<!--XSSOK-->
<input type=hidden name="funcPageName" value="<%=funcPageName%>" >
</form>
</body>
</html>
