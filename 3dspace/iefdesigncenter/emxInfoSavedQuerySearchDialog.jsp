<%--  emxInfoSavedQuerySearchDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
    $Archive: /InfoCentral/src/infocentral/emxInfoSavedQuerySearchDialog.jsp $
    $Revision: 1.3.1.3$
    $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoSavedQuerySearchDialog.jsp $
 * 
 * *****************  Version 13  *****************
 * User: Rahulp       Date: 4/02/03    Time: 12:45
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 12  *****************
 * User: Rahulp       Date: 1/15/03    Time: 3:40p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 11  *****************
 * User: Rahulp       Date: 1/15/03    Time: 12:19p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 10  *****************
 * User: Rahulp       Date: 11/29/02   Time: 1:08p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 9  *****************
 * User: Rahulp       Date: 02/11/28   Time: 17:14
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 8  *****************
 * User: Snehalb      Date: 11/25/02   Time: 7:56p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 7  *****************
 * User: Rahulp       Date: 11/13/02   Time: 2:52p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 6  *****************
 * User: Gauravg      Date: 11/07/02   Time: 3:41p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 5  *****************
 * User: Rahulp       Date: 10/30/02   Time: 1:13p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 4  *****************
 * User: Rahulp       Date: 10/21/02   Time: 2:45p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 3  *****************
 * User: Rahulp       Date: 10/17/02   Time: 12:53p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 2  *****************
 * User: Rahulp       Date: 10/16/02   Time: 4:33p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 1  *****************
 * User: Bhargava     Date: 9/24/02    Time: 5:41p
 * Created in $/InfoCentral/src/InfoCentral
 *
 * ***********************************************
 * 
--%>

<%@include file = "emxInfoCentralUtils.inc"%>
<%@include file = "../emxUICommonHeaderBeginInclude.inc"%>

<script language="Javascript">

    function trim(str)
    {
        while(str.length != 0 && str.substring(0,1) == ' ')
        {
            str = str.substring(1);
        }
        while(str.length != 0 && str.substring(str.length -1) == ' ')
        {
            str = str.substring(0, str.length -1);
        }
        return str;
    }

    function doSearch() 
    {
		var form = parent.frames[2].frames[1].document.emxTableForm;
		var queryName="";
        for (var i=0;i<form.elements.length;i++)
        {
            var element = form.elements[i];
            if ((element.name == 'emxTableRowId') && (element.type == 'radio'))
            {
                if(element.checked == true)
                    queryName=element.value;
            }
        }
        if(queryName=="")
        {
       <%
		  String I18NResourceBundle = "emxIEFDesignCenterStringResource";
		  String acceptLanguage = request.getHeader("Accept-Language");
		  String strErrorMsg = i18nNow.getI18nString("emxIEFDesignCenter.ConnectSavedQuery.SelectQuery",I18NResourceBundle,acceptLanguage);
      %>
            alert("<%=strErrorMsg%>");
  	        return;
        }
		var timeStamp = form.timeStampAdvancedSearch.value;
		var strQueryLimit = parent.frames[3].document.bottomCommonForm.QueryLimit.value;
        form.target="_parent";
//	    form.target="_top";
//      form.action= "emxInfoSavedQueryResults.jsp?queryLimit="+strQueryLimit+"&appendCheckFlag="+   form.chkAppendReplace[1].checked+"&timeStampAdvancedSearch="+timeStamp;
        form.action= "emxInfoModifyQueryDialog.jsp?queryLimit="+strQueryLimit+"&timeStampAdvancedSearch="+timeStamp+"&TextSearch=true&Advanced=true";
	    form.submit();    
    } //end of function doSearch() 
</script>

<%
      String includePage = "emxInfoCustomTable.jsp";
%>
<!--XSSOK-->
<jsp:include page="<%=includePage%>" flush="true" />
