<%--  DSCSearchFooterPage.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  

   static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/DSCSearchFooterPage.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>

<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoSearchFooterPage.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$
--%>

<%@include file = "emxInfoCentralUtils.inc"%> 	
<%@ page import = "com.matrixone.apps.framework.ui.*" %>
<%@ page import = "com.matrixone.apps.framework.ui.*" %>
<%@page import ="com.matrixone.apps.domain.util.*" %>


<html>
<head>
<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css"><!--This is required for the font of the text-->
<link rel="stylesheet" href="../common/styles/emxUIDialog.css" type="text/css" ><!--This is required for the cell (td) back ground colour-->
<link rel="stylesheet" href="../common/styles/emxUIList.css" type="text/css" >
<script language="JavaScript">
function turnOffProgress() {
        if(document.images['imgProgress']){
                document.images['imgProgress'].src = "../common/images/utilSpacer.gif";
        }else if (parent.frames.length > 1) {
                if (parent.frames['searchContent'].document.images['imgProgress']) {
                        parent.frames['searchContent'].document.images['imgProgress'].src = "../common/images/utilSpacer.gif";
                }else if (parent.frames.length > 0) {
                    if (parent.frames['searchHead'].document.images['imgProgress']) {
                            parent.frames['searchHead'].document.images['imgProgress'].src = "../common/images/utilSpacer.gif";
                    } else {
                            setTimeout("turnOffProgress()", 500);
                    }  
                }
        }
}  

</script>
</head>

<body onunload="javascript:unloadSearch()">

<%
    String I18NResourceBundle = "emxIEFDesignCenterStringResource";
    String acceptLanguage = request.getHeader("Accept-Language");
%>

<script language="javascript">

var isAbruptClose = true;
var cache = 'cache';

    function formFindValue(form, name)
    {
        for (var i = 0; i < form.elements.length; i++)
        {
            var elementName = '' + form.elements[i].name;
            if (name == elementName)
                return form.elements[i].value;
        }
        return "";
    }

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
                var frame = parent.frames['searchContent'];
                var form = frame.document.forms[0];
				var findType = formFindValue(form, 'findType');
				if (findType == 'FindLike')
				{
				   parent.searchContent.doFindLike();
				}
				else
				{
					var doSearch = true;
					if (findType == 'queryFind') //find type is "Saved Query"
						doSearch = parent.searchContent.validateSavedSearchQuery(); //check whether user has selected a query or not
					
					if(doSearch) // do the seach only if a query is selected
						parent.searchContent.doSearch(true);
					else
						parent.searchContent.focus();
				}
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
            parent.searchContent.doSearch(true);
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

		parent.searchContent.parent.window.close();
	}
window.onload=turnOffProgress;
</script>

<form name="bottomCommonForm"  onSubmit="return false">

<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0" name="FooterLinks">
<tr><td colspan=2><img src="spacer.gif" width="1" height="9"></td></tr>
<tr>
<td>
<table border="0" name="FooterLinksContainer">

<%
    String strQueryTo = i18nNow.getI18nString("emxIEFDesignCenter.PowerSearch.LimitTo",I18NResourceBundle,acceptLanguage);
	String strResults = i18nNow.getI18nString("emxIEFDesignCenter.PowerSearch.Results",I18NResourceBundle,acceptLanguage);
    String sQueryLimit=Request.getParameter(request,"QueryLimit");
	if( ( sQueryLimit == null ) || ( sQueryLimit.equals("null") ) || ( sQueryLimit.equals("") ) ){
	 sQueryLimit=Request.getParameter(request,"qlim");
	}
//System.out.println("+++ DSCSearchFootPage.jsp: QueryLimit = " + sQueryLimit);
    String strFind = i18nNow.getI18nString("emxIEFDesignCenter.Common.Find",I18NResourceBundle,acceptLanguage);
    String strCancel = i18nNow.getI18nString("emxIEFDesignCenter.Common.Cancel",I18NResourceBundle,acceptLanguage);
    if( ( sQueryLimit == null ) || ( sQueryLimit.equals("null") ) || ( sQueryLimit.equals("") ) )
    {
%>
    <tr><td colspan="4">&nbsp;<b><%=strQueryTo%></b><input type="text" name="QueryLimit" value="100">  </td></tr></table></td>
<%
    }
    else 
    {
        Integer integerLimit = new Integer(sQueryLimit);
        int intLimit = integerLimit.intValue();

        if( intLimit > 0 )
        {
%>
      <tr><td  name="QueryTo"><%=strQueryTo%></td><td>&nbsp;<input type="text" size="5" name="QueryLimit" value="<xss:encodeForHTMLAttribute><%=sQueryLimit%></xss:encodeForHTMLAttribute>"></td>
      <td name="QueryResults"><%=strResults%></td><td>&nbsp;&nbsp;</td></tr></table></td>
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
<table border="0" cellspacing="0" cellpadding="0" align="right" name="FooterLink">
 <tr>
   <td align="right">&nbsp;&nbsp;</td>
       <td align="right" ><a href="javascript:validateLimit()"  ><img name="FindImage" src="../iefdesigncenter/images/emxUIButtonNext.gif" border="0" ></a>&nbsp</td>
     <td align="right" ><a name="FindLink" href="javascript:validateLimit()" ><%=strFind%></a>&nbsp&nbsp;</td>
     <td align="right" ><a href="javascript:closeWindow()"  ><img name="CancelImage"src="../iefdesigncenter/images/emxUIButtonCancel.gif" border="0" ></a>&nbsp</td>
     <td align="right" ><a name="CancelLink" href="javascript:closeWindow()"  ><%=strCancel%></a>&nbsp&nbsp;</td>
  </tr>
 </table>
 </td>
 </tr>
 </table>
</form>
</body>
</html>
