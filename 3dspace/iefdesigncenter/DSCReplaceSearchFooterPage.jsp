<%--  DSCReplaceSearchFooterPage.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
    Connect Search dialog footer    
--%>

<%@include file ="emxInfoCentralUtils.inc"%> 	
<%@page import = "com.matrixone.apps.framework.ui.*" %>
<%@page import = "com.matrixone.apps.framework.ui.*" %>

<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<html>
<head>
<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIDialog.css" type="text/css" >
<link rel="stylesheet" href="../common/styles/emxUIList.css" type="text/css" >
</head>

<body>
<%
    String I18NResourceBundle	= "emxIEFDesignCenterStringResource";
    String acceptLanguage		= request.getHeader("Accept-Language");

	String isPreviousRequired	= emxGetParameter(request, "previousRequired");
	String queryLimit			= emxGetParameter(request, "queryLimit");
%>

<script language="javascript">
    
    function validateLimit() 
    {   
		var selectedCollection	= parent.frames[2].ids;
		if(selectedCollection != null && selectedCollection != "" && selectedCollection != "~~")
		{
			var collectionsSearch	= true;
			selectedCollectionArray = selectedCollection.split('~');
			selectedCollection		= selectedCollectionArray[1];
		}

		var strQueryLimit = document.bottomCommonForm.QueryLimit.value;
        if (strQueryLimit != "")
        {
            if (isNaN(strQueryLimit) == true)
            {
<%
                String strNaNErrorMsg = i18nNow.getI18nString("emxIEFDesignCenter.PowerSearch.LimitMustBeNumeric",I18NResourceBundle,acceptLanguage);
%>
                alert("<%=strNaNErrorMsg%>");
                document.bottomCommonForm.QueryLimit.value = 100;
                document.bottomCommonForm.QueryLimit.focus();
            }
            else if (strQueryLimit > 32767)
            {
<%
                String strLimitSizeErrorMsg = i18nNow.getI18nString("emxIEFDesignCenter.PowerSearch.LimitMustBeLessThan",I18NResourceBundle,acceptLanguage);
%>
                alert("<%=strLimitSizeErrorMsg%>");
                document.bottomCommonForm.QueryLimit.value = 100;
                document.bottomCommonForm.QueryLimit.focus();
            }
	        else if (strQueryLimit <= 0)
            {
<%
                strLimitSizeErrorMsg = i18nNow.getI18nString("emxIEFDesignCenter.PowerSearch.LimitMustBeGreaterThan",I18NResourceBundle,acceptLanguage);
%>
                alert("<%=strLimitSizeErrorMsg%>");
                document.bottomCommonForm.QueryLimit.value = 100;
                document.bottomCommonForm.QueryLimit.focus();
	        }
            else
            {
                if(collectionsSearch)
					parent.searchBody.frames["listDisplay"].doSearch(selectedCollection);
				else
					parent.searchBody.doSearch();
            }
        }
		else if (strQueryLimit == "")
		{
<%
			strLimitSizeErrorMsg = i18nNow.getI18nString("emxIEFDesignCenter.PowerSearch.LimitMustBeGreaterThan",I18NResourceBundle,acceptLanguage);
%>
			alert("<%=strLimitSizeErrorMsg%>");
			document.bottomCommonForm.QueryLimit.value = 100;
			document.bottomCommonForm.QueryLimit.focus();
		}
        else
        {
			if(collectionsSearch)
				parent.searchBody.frames["listDisplay"].doSearch(selectedCollection);
			else
				parent.searchBody.doSearch();
        }
        return;
    }

    function previousPage() 
    {
        var form = parent.searchBody.document.frmConnectSearch;
        if(form == null)
	        form = parent.searchBody.frames[0].document.typeList; 

        var objectId = form.objectId.value;

		window.top.location.href = 
            "DSCReplaceSearchWizardFS.jsp?objectId=" + objectId
			+ "&HelpMarker=emxHelpInfoObjectConnectWizard1FS";
        return;
    }

</script>

<form name="bottomCommonForm"  onSubmit="return false" method="post">

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
//System.out.println("CSRFINJECTION ::DSCReplaceSearchFooterPage.jsp::form::bottomCommonForm");
%>


<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">
<tr><td colspan=2><img src="spacer.gif" width="1" height="9"></td></tr>
<tr>
<td>
<table border="0">

<%
    String strQueryTo	= i18nNow.getI18nString("emxIEFDesignCenter.PowerSearch.LimitTo",I18NResourceBundle,acceptLanguage);
    String strResults	= i18nNow.getI18nString("emxIEFDesignCenter.PowerSearch.Results",I18NResourceBundle,acceptLanguage);
    String strPrev		= i18nNow.getI18nString("emxIEFDesignCenter.Common.Previous",I18NResourceBundle,acceptLanguage);
    String strFind		= i18nNow.getI18nString("emxIEFDesignCenter.Common.Next",I18NResourceBundle,acceptLanguage);
    String strCancel	= i18nNow.getI18nString("emxIEFDesignCenter.Common.Cancel",I18NResourceBundle,acceptLanguage);

	Integer integerLimit = new Integer(queryLimit);
	int intLimit = integerLimit.intValue();

	if(intLimit > 0)
	{ 
%>
      <!--XSSOK-->
      <tr><td><%=strQueryTo%></td><td>&nbsp;<input type="text" size="5" name="QueryLimit" value="<%=queryLimit%>"></td>
      <td><%=strResults%></td><td>&nbsp;&nbsp;</td></tr></table></td>
 <% 
	}
	else
	{
%>
      <tr><td colspan="4">&nbsp;<input type="hidden" name="QueryLimit" value="">  </td></tr></table></td>
<%
	}
%>

<td align="right">
<table border="0" cellspacing="0" cellpadding="0" align="right">
 <tr>
    
   
<%
if ("true".equals(isPreviousRequired))
{
%>
	<td align="right">&nbsp;&nbsp;</td>
    <td align="right" ><a href="javascript:previousPage()"  ><img src="../iefdesigncenter/images/emxUIButtonPrevious.gif" border="0" ></a>&nbsp</td>
    <td align="right" ><a href="javascript:previousPage()"  ><%=strPrev%></a>&nbsp&nbsp;</td>
<%
}
%>
    <td align="right" ><a href="javascript:validateLimit()"  ><img src="../iefdesigncenter/images/emxUIButtonNext.gif" border="0" ></a>&nbsp</td>
    <td align="right" ><a href="javascript:validateLimit()"  ><%=strFind%></a>&nbsp&nbsp;</td>

    <td align="right" ><a href="javascript:parent.searchBody.parent.window.close()"  ><img src="../iefdesigncenter/images/emxUIButtonCancel.gif" border="0" ></a>&nbsp</td>
    <td align="right" ><a href="javascript:parent.searchBody.parent.window.close()"  ><%=strCancel%></a>&nbsp&nbsp;</td>
  </tr>
 </table>
 </td>
  </tr>
 </table>
</form>
</body>
</html>
