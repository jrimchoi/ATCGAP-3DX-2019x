<%--  emxInfoConnectSearchFooterPage.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
    $Archive: /InfoCentral/src/infocentral/emxInfoConnectSearchFooterPage.jsp $
    $Revision: 1.3.1.3$
    $Author: ds-mbalakrishnan$

    Connect Search dialog footer

--%>
<%--
 *
 * $History: emxInfoConnectSearchFooterPage.jsp $
 * 
 * *****************  Version 9  *****************
 * User: Shashikantk  Date: 12/04/02   Time: 4:02p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 8  *****************
 * User: Shashikantk  Date: 11/27/02   Time: 10:58a
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 7  *****************
 * User: Snehalb      Date: 11/23/02   Time: 5:02p
 * Updated in $/InfoCentral/src/InfoCentral
 * cleaned up code for indentation, added file header
 *
 * ***********************************************
 *
--%>

<%@include file ="emxInfoCentralUtils.inc"%> 	
<%@page import = "com.matrixone.apps.framework.ui.*" %>
<%@page import = "com.matrixone.apps.framework.ui.*" %>

<html>
<head>
<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css"><!--This is required for the font of the text-->
<link rel="stylesheet" href="../common/styles/emxUIDialog.css" type="text/css" ><!--This is required for the cell (td) back ground colour-->
<link rel="stylesheet" href="../common/styles/emxUIList.css" type="text/css" >
</head>

<body>
<%
    String I18NResourceBundle = "emxIEFDesignCenterStringResource";
    String acceptLanguage = request.getHeader("Accept-Language");
    // rajeshg - changed for custom relationship addition- 01/09/04
	String sConnect = null;
	sConnect = (String)session.getAttribute("DirectConnect");
	// end
	String isTemplateType = (String)session.getAttribute("isTemplateType");
%>

<form name="bottomCommonForm"  onSubmit="return false" >

<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">
<tr><td colspan=2><img src="spacer.gif" width="1" height="9"></td></tr>
<tr>
<td>
<table border="0">

<%
    String strQueryTo = i18nNow.getI18nString("emxIEFDesignCenter.PowerSearch.LimitTo",I18NResourceBundle,acceptLanguage);
    String strResults = i18nNow.getI18nString("emxIEFDesignCenter.PowerSearch.Results",I18NResourceBundle,acceptLanguage);
    String sQueryLimit = request.getParameter("QueryLimit");
	if( ( sQueryLimit == null ) || ( sQueryLimit.equals("null") ) || ( sQueryLimit.equals("") ) ){
	 sQueryLimit=request.getParameter("qlim");

	}

    String strPrev   = i18nNow.getI18nString("emxIEFDesignCenter.Common.Previous",I18NResourceBundle,acceptLanguage);
    String strFind   = i18nNow.getI18nString("emxIEFDesignCenter.Common.Next",I18NResourceBundle,acceptLanguage);
    String strCancel = i18nNow.getI18nString("emxIEFDesignCenter.Common.Cancel",I18NResourceBundle,acceptLanguage);

    if( ( sQueryLimit == null ) 
        || ( sQueryLimit.equals("null") ) 
        || ( sQueryLimit.equals("") ) )
    {
%>
    <tr><td colspan="4">&nbsp;<input type="hidden" name="QueryLimit" value="">  </td></tr></table></td>
<%
    }
    else 
    {
        Integer integerLimit = new Integer(sQueryLimit);
        int intLimit = integerLimit.intValue();

        if(intLimit>0)
        { 
%>
      <!--XSSOK-->
      <tr><td><%=strQueryTo%></td><td>&nbsp;<input type="text" size="5" name="QueryLimit" value="<%=sQueryLimit%>"></td>
      <td><%=strResults%></td><td>&nbsp;&nbsp;</td></tr></table></td>
 <% 
        }
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
    
   
<%
// rajeshg - changed for custom relationship addition- 01/09/04
if ( !("true".equals(sConnect)) )
{
%>
   <td align="right">&nbsp;&nbsp;</td>
    <!--XSSOK-->
    <td align="right" ><a href="javascript:frames['searchBody'].previousPage('<%=isTemplateType%>')"  ><img src="../iefdesigncenter/images/emxUIButtonPrevious.gif" border="0" ></a>&nbsp</td>
	 <!--XSSOK-->
     <td align="right" ><a href="javascript:frames['searchBody'].previousPage('<%=isTemplateType%>')"  ><%=strPrev%></a>&nbsp&nbsp;</td>
<%
// end
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
