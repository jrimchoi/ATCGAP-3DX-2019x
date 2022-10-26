<%--  emxTypeSelectorForm.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxTypeSelectorForm.jsp  -  Search results page for Spec search
  $Archive: /InfoCentral/src/infocentral/emxTypeSelectorForm.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$
--%>

<%--
 *
 * $History: emxTypeSelectorForm.jsp $
 * 
 * *****************  Version 8  *****************
 * User: Shashikantk  Date: 12/11/02   Time: 7:03p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 7  *****************
 * User: Snehalb      Date: 11/26/02   Time: 5:12p
 * Updated in $/InfoCentral/src/InfoCentral
 * indented
 * 
 * *****************  Version 6  *****************
 * User: Shashikantk  Date: 11/23/02   Time: 6:56p
 * Updated in $/InfoCentral/src/InfoCentral
 * Code cleanup
 * 
 * *****************  Version 5  *****************
 * User: Shashikantk  Date: 11/21/02   Time: 6:56p
 * Updated in $/InfoCentral/src/InfoCentral
 * Removed the space between <%@include file and '='.
 * 
 ************************************************
 *
--%>

<%@include file="emxInfoCentralUtils.inc"%> 			<%--For context, request wrapper methods, i18n methods--%>
<%
    String languageStr = request.getHeader("Accept-Language");
    String sMessage=i18nNow.getI18nString("emxIEFDesignCenter.Common.SelectAType", "emxIEFDesignCenterStringResource",languageStr);
%>
<html>
<head>
<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIList.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIDialog.css" type="text/css">
<title>Untitled</title>

<script language="javascript">

    function doDone() 
    {
        if (top.localTree.selectedNodeID != -1) 
        {
            var selvalue = top.localTypeBrowser.getValue();
            var absval="";
            var transval="";
            while(selvalue.indexOf(",") != -1) 
            {
                var firstTok = selvalue.slice(0, selvalue.indexOf(","));
                var absVal1 = firstTok.substring(0, firstTok.indexOf("|"));
                var transval1 = firstTok.substring(absVal1.length+1,firstTok.length);

                absval += ","+ absVal1;
                transval += "," +transval1;

                selvalue = selvalue.substring(firstTok.length+1, selvalue.length);
            }
            if(selvalue.indexOf("|") != -1) 
            {
                absval  += "," + selvalue.slice(0, selvalue.indexOf("|"));
                transval += ","+ selvalue.slice(selvalue.indexOf("|")+1, selvalue.length);
            }

            if(absval.charAt(0) == ',') 
            {
                absval = absval.substring(1, absval.length);
            }
            if(transval.charAt(0) == ',') 
            {
                transval = transval.substring(1, transval.length);
            }

            //top.txtType.value = top.localTypeBrowser.getValue();
            // Pass back the abs & translated values.
            //alert(window.opener);
            top.txtType.value = absval;
            top.txtTypeDisp.value = transval;

            if (top.bReload) 
            {
                top.opener.reload();
            }
            top.close();
        } 
        else 
        {
            alert("<%=sMessage%>");
        }
    }
    
    function doCancel() 
    {
        top.close();
    }
</script>

</head>
<body>

<table border="0" cellspacing="0" cellpadding="0" width="100%">
  <tr><td>&nbsp</td></tr>
  <tr>

<%
    String I18NResourceBundle = "emxIEFDesignCenterStringResource";
    String strSubmit = i18nNow.getI18nString("emxIEFDesignCenter.Button.Select",I18NResourceBundle,languageStr);
    String strCancel = i18nNow.getI18nString("emxIEFDesignCenter.Button.Cancel",I18NResourceBundle,languageStr);
%>
    <td align="right">
      <table border="0">
        <tr>
          <td align="right"><a href="javascript:doDone()"><img src="../common/images/buttonDialogDone.gif" border="0"><%=strSubmit%></a></td>
          <td align="right"><a href="javascript:doCancel()"><img src="../common/images/buttonDialogCancel.gif" border="0"><%=strCancel%></a></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>

</html>
