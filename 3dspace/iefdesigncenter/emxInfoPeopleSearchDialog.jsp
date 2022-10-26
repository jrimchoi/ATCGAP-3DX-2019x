<%--  emxInfoPeopleSearchDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%-- emxInfoPeopleSearchDialog.jsp - dialog for people search

  $Archive: /InfoCentral/src/infocentral/emxInfoPeopleSearchDialog.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxInfoPeopleSearchDialog.jsp $
 * 
 * *****************  Version 17  *****************
 * User: Shashikantk  Date: 12/13/02   Time: 6:27p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 16  *****************
 * User: Snehalb      Date: 12/13/02   Time: 3:15p
 * Updated in $/InfoCentral/src/infocentral
 * initialized the helpmarker appropriately
 * 
 * *****************  Version 15  *****************
 * User: Shashikantk  Date: 12/13/02   Time: 12:18p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 14  *****************
 * User: Shashikantk  Date: 12/11/02   Time: 7:21p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 13  *****************
 * User: Shashikantk  Date: 12/05/02   Time: 10:48a
 * Updated in $/InfoCentral/src/infocentral
 * code for calling the custom table is modified
 * 
 * *****************  Version 12  *****************
 * User: Shashikantk  Date: 12/02/02   Time: 4:45p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 11  *****************
 * User: Shashikantk  Date: 11/23/02   Time: 6:56p
 * Updated in $/InfoCentral/src/InfoCentral
 * Code cleanup
 * 
 * *****************  Version 10  *****************
 * User: Shashikantk  Date: 11/21/02   Time: 6:56p
 * Updated in $/InfoCentral/src/InfoCentral
 * Removed the space between "include file" and '='.
 * 
 * ***********************************************
 *
--%>
<%@ page import = "java.net.*" %>
<%@include file="emxInfoCentralUtils.inc"%> 			<%--For context, request wrapper methods, i18n methods--%>
<%@include file= "../emxUICommonHeaderBeginInclude.inc"%>		<%--Required for displaying the required text--%>

<script language="javascript" src="../common/scripts/emxJSValidationUtil.js"></script> <%--For calling trimWhitespace() to remove leading and trailing whitespace from a string--%>

<%
	String header = "emxIEFDesignCenter.Common.SelectPerson";
	String sSuiteKey = emxGetParameter(request, "suiteKey");
	String sActionURL = "emxInfoCustomTable.jsp?custHeader=" + header 
        + "&custProgram=IEFFindUsers&custSelection=single&custSortColumnName=Name" 
        + "&custSortDirection=ascending" 
        + "&custSortType=string"
        + "&custBottomActionbar=IEFUsersBottomActionBar"
        + "&custTopActionbar=IEFUsersTopActionBar"
        + "&custTargetLocation=popup"
        + "&HelpMarker=emxHelpInfoPeopleSearchDialog"
        + "&suiteKey=" + sSuiteKey;
%>
<html>
<head>
<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIList.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIForm.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIProperties.css" type="text/css" ><!--This is required for the cell (td) back ground colour-->
<link rel="stylesheet" href="../emxUITemp.css" type="text/css">

<script language="Javascript">
	function doSearch() {
		var sURLString = "";
		var sQueryLimitRef = parent.frames[3].document.bottomCommonForm.QueryLimit;
		var strQueryLimit = sQueryLimitRef.value;
		if (isNaN(strQueryLimit) == true)
		{
			alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.PowerSearch.LimitMustBeNumeric</framework:i18nScript>");
			sQueryLimitRef.value = 100;
			sQueryLimitRef.focus();
			return;
		}
		else if (strQueryLimit > 32767)
		{
			alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.PowerSearch.LimitMustBeLessThan</framework:i18nScript>");
			sQueryLimitRef.value = 100;
			sQueryLimitRef.focus();
			return;
		}
		else if (strQueryLimit <= 0)
		{
			alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.PowerSearch.LimitMustBeGreaterThan</framework:i18nScript>");
			sQueryLimitRef.value = 100;
			sQueryLimitRef.focus();
			return;
		}else if (strQueryLimit == "")
        {
                alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.PowerSearch.LimitMustBeGreaterThan</framework:i18nScript>");                
                sQueryLimitRef.value = 100;
                sQueryLimitRef.focus();
                return;
	    }	

		//XSSOK
		var strSuiteKey = "<%=sSuiteKey%>";
		//XSSOK
		var strHeader = "<%=header%>";
		document.frmPeopleSearch.queryLimit.value = strQueryLimit;			

		document.frmPeopleSearch.txtFilter.value = trimWhitespace(document.frmPeopleSearch.txtFilter.value);
		if (charExists(document.frmPeopleSearch.txtFilter.value, '"')){
			alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.SpecialCharacters</framework:i18nScript>");			
			document.frmPeopleSearch.txtFilter.focus();
			return;
		}
		document.frmPeopleSearch.submit();
	}
  
</script>
<head>
<%@include file= "../emxUICommonHeaderEndInclude.inc"%>


<%
  String languageStr = request.getHeader("Accept-Language");
  String appDirectory = (String)application.getAttribute("eServiceSuiteIEFDesignCenter.Directory");
%>
<Body class="content">
<form name="frmPeopleSearch" method="post" target="_top" action="<%=XSSUtil.encodeForHTML(context,sActionURL)%>" onSubmit="return false">


  <table border="0" width="100%" cellpadding="5" cellspacing="2">
      <tr>
	    <td class="label"><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.Name</framework:i18n></td>
	    <td class="field"><input type=text value="*" size="16" name="txtFilter"></td>
	  </tr>

	  <tr>
	    <td class="label"><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.TopLevel</framework:i18n></td>
	    <td class="field"><input type="checkbox" name="chkbxTopLevel" value="unchecked" onClick="javascript:if(this.value == 'unchecked'){this.value='checked';}else{this.value='unchecked';}">&nbsp;<img src="images/iconPerson.gif" border="0"></td>
	  </tr>
	  <tr>
	    <td class="label"><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.Person</framework:i18n></td>
	    <td class="field"><input type="checkbox" checked name="chkbxPerson" value="checked" onClick="javascript:if(this.value == 'unchecked'){this.value='checked';}else{this.value='unchecked';}">&nbsp;<img src="images/iconPerson.gif" border="0"></td>
	  </tr>
	  <tr>
	    <td class="label"><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.Group</framework:i18n></td>
	    <td class="field"><input type="checkbox" checked name="chkbxGroup" value="checked" onClick="javascript:if(this.value == 'unchecked'){this.value='checked';}else{this.value='unchecked';}">&nbsp;<img src="images/iconGroup.gif" border="0"></td>
	  </tr>
	  <tr>
	    <td class="label"><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.Role</framework:i18n></td>
	    <td class="field"><input type="checkbox" checked name="chkbxRole" value="checked" onClick="javascript:if(this.value == 'unchecked'){this.value='checked';}else{this.value='unchecked';}">&nbsp;<img src="images/iconRole.gif" border="0"></td>
	  </tr>
	  <input type=hidden name="queryLimit" value="">
  </table>
</Body>
</html>
