<%--  emxInfoSearchFooterPage.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%-- 

   static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxInfoSearchFooterPage.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>

<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoSearchFooterPage.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$
--%>

<%@include file   ="emxInfoCentralUtils.inc"%> 	
<%@ page import = "com.matrixone.apps.framework.ui.*" %>
<%@ page import = "com.matrixone.apps.framework.ui.*" %>

<html>
<head>
<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css"><!--This is required for the font of the text-->
<link rel="stylesheet" href="../common/styles/emxUIDialog.css" type="text/css" ><!--This is required for the cell (td) back ground colour-->
<link rel="stylesheet" href="../common/styles/emxUIList.css" type="text/css" >
</head>

<body onunload="javascript:unloadSearch()">

<%
    String I18NResourceBundle = "emxIEFDesignCenterStringResource";
    String acceptLanguage = request.getHeader("Accept-Language");
%>

<script language="javascript">

var isAbruptClose = true;

    function validateLimit() 
    {
        var strQueryLimit = document.bottomCommonForm.QueryLimit.value;
        if(strQueryLimit != "")
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
				isAbruptClose = false;
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
	    }else
        {
			isAbruptClose = false;
            parent.searchBody.doSearch();
        }
        return;
    } //end of function validateLimit() 

	function unloadSearch() 
    {
		if(isAbruptClose)
			closeWindow();
	}

	function closeWindow() 
    {
		isAbruptClose = false;
		parent.searchBody.parent.window.close();
	}
</script>

<form name="bottomCommonForm"  onSubmit="return false">

<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">
<tr><td colspan=2><img src="spacer.gif" width="1" height="9"></td></tr>
<tr>
<td>
<table border="0">

<%
    String strQueryTo = i18nNow.getI18nString("emxIEFDesignCenter.PowerSearch.LimitTo",I18NResourceBundle,acceptLanguage);
    String strResults = i18nNow.getI18nString("emxIEFDesignCenter.PowerSearch.Results",I18NResourceBundle,acceptLanguage);
    String sQueryLimit=request.getParameter("QueryLimit");
	if( ( sQueryLimit == null ) || ( sQueryLimit.equals("null") ) || ( sQueryLimit.equals("") ) ){
	 sQueryLimit=request.getParameter("qlim");
	}

    String strFind = i18nNow.getI18nString("emxIEFDesignCenter.Common.Find",I18NResourceBundle,acceptLanguage);
    String strCancel = i18nNow.getI18nString("emxIEFDesignCenter.Common.Cancel",I18NResourceBundle,acceptLanguage);
    if( ( sQueryLimit == null ) || ( sQueryLimit.equals("null") ) || ( sQueryLimit.equals("") ) )
    {
%>
    <tr><td colspan="4">&nbsp;<input type="hidden" name="QueryLimit" value="">  </td></tr></table></td>
<%
    }
    else 
    {
        Integer integerLimit = new Integer(sQueryLimit);
        int intLimit = integerLimit.intValue();

        if( intLimit > 0 )
        {
%>
      <!--XSSOK-->
      <tr><td><%=strQueryTo%></td><td>&nbsp;<input type="text" size="5" name="QueryLimit" value="<%=sQueryLimit%>"></td>
      <td><%=strResults%></td><td>&nbsp;&nbsp;</td></tr></table></td>
 <%     }
        else
        {
%>
      <tr><td colspan="4">&nbsp;<input type="hidden" name="QueryLimit" value="">  </td></tr></table></td>
<%
        }
    }
%>

<td align="right">
<table border="0" cellspacing="0" cellpadding="0" align="right">
 <tr>
   <td align="right">&nbsp;&nbsp;</td>
       <td align="right" ><a href="javascript:validateLimit()"  ><img src="../iefdesigncenter/images/emxUIButtonNext.gif" border="0" ></a>&nbsp</td>
     <td align="right" ><a href="javascript:validateLimit()"  ><%=strFind%></a>&nbsp&nbsp;</td>
     <td align="right" ><a href="javascript:closeWindow()"  ><img src="../iefdesigncenter/images/emxUIButtonCancel.gif" border="0" ></a>&nbsp</td>
     <td align="right" ><a href="javascript:closeWindow()"  ><%=strCancel%></a>&nbsp&nbsp;</td>

  </tr>
 </table>
 </td>
  </tr>
 </table>
</form>
</body>
</html>
