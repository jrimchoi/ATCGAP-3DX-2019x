<%--  emxInfoSearchDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxInfoSearchDialog.jsp   -   Form page for Basic Search
  $Archive: /InfoCentral/src/infocentral/emxInfoSearchDialog.jsp $
--%>

<%--
 *
 * $History: emxInfoSearchDialog.jsp $
 ******************  Version 34  *****************
 * User: Rajesh G  Date: 02/15/04    Time: 3:39p
 * Updated in $/InfoCentral/src/infocentral
 * To enable the esc key and key board support
 *
 * *****************  Version 32  *****************
 * User: Shashikantk  Date: 1/11/03    Time: 3:39p
 * Updated in $/InfoCentral/src/infocentral
 * The popup windows (choosers) are now opened by a function
 * showModalDialog() from common/scripts/emxUIModal.js
 *
 * *****************  Version 31  *****************
 * User: Snehalb      Date: 1/10/03    Time: 9:52a
 * Updated in $/InfoCentral/src/infocentral
 * Changing form method from get to post
 *
 * *****************  Version 30  *****************
 * User: Shashikantk  Date: 12/12/02   Time: 5:55p
 * Updated in $/InfoCentral/src/infocentral
 * Alerts for error if any
 *
 * *****************  Version 29  *****************
 * User: Rahulp       Date: 12/02/02   Time: 6:47p
 * Updated in $/InfoCentral/src/infocentral
 *
 * ************************************************
 *
 --%>

<%@ page import="com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.beans.*"  %>

<%@include file= "emxInfoCentralUtils.inc"%>
<%@include file= "../emxJSValidation.inc"%>
<%@include file= "../emxUICommonHeaderBeginInclude.inc"%>

<script language="JavaScript" src="emxInfoUIModal.js"></script>
<script language="javascript" src="emxInfoCentralJavaScriptUtils.js"></script>
<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script> <%--Required by emxUIActionbar.js below--%>
<script language="JavaScript" src="../common/scripts/emxUIActionbar.js" type="text/javascript"></script> <%--To show javascript error messages--%>
<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICore.js"></script>

<script language="Javascript">

	function doSearch() {
		var framefooter = findFrame(parent,"footer");
		var strQueryLimit = framefooter.document.bottomCommonForm.QueryLimit.value;
		document.frmPowerSearch.queryLimit.value = strQueryLimit;

		document.frmPowerSearch.txtType.value = trimWhitespace(document.frmPowerSearch.txtType.value);
		if (document.frmPowerSearch.txtType.value ==  ''){
			alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Error.ChooseType</framework:i18nScript>");
			document.frmPowerSearch.btnTypeSelector.focus();
			return;
		}

		document.frmPowerSearch.ui_txtName.value = trimWhitespace(document.frmPowerSearch.ui_txtName.value);
		if (charExists(document.frmPowerSearch.ui_txtName.value, '"')){
			alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.SpecialCharacters</framework:i18nScript>");
			document.frmPowerSearch.ui_txtName.focus();
			return;
		}
		var sName = document.frmPowerSearch.ui_txtName.value;
		document.frmPowerSearch.txtName.value = document.frmPowerSearch.ui_txtName.value;

		document.frmPowerSearch.txtRev.value = trimWhitespace(document.frmPowerSearch.txtRev.value);
		if (charExists(document.frmPowerSearch.txtRev.value, '"')){
			alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.SpecialCharacters</framework:i18nScript>");
			document.frmPowerSearch.txtRev.focus();
			return;
		}

		document.frmPowerSearch.txtType.value = trimWhitespace(document.frmPowerSearch.txtType.value);
		if (charExists(document.frmPowerSearch.txtType.value, '"')){
			alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.SpecialCharacters</framework:i18nScript>");
			document.frmPowerSearch.txtType.focus();
			return;
		}

		document.frmPowerSearch.txtOwner.value = trimWhitespace(document.frmPowerSearch.txtOwner.value);
		if (charExists(document.frmPowerSearch.txtOwner.value, '"')){
			alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.SpecialCharacters</framework:i18nScript>");
			document.frmPowerSearch.txtOwner.focus();
			return;
		}

		document.frmPowerSearch.txtVault.value = trimWhitespace(document.frmPowerSearch.txtVault.value);
		if (charExists(document.frmPowerSearch.txtVault.value, '"')){
			alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.SpecialCharacters</framework:i18nScript>");
			document.frmPowerSearch.txtVault.focus();
			return;
		}

		framefooter.isAbruptClose = false;
		document.frmPowerSearch.submit();
	}

	//specify the place to return the string AS A STRING...this cannot be an actual object reference or it will cause an error

	//define the variables required for showing the type chooser
	var strTxtType = "document.forms['frmPowerSearch'].selType";
	var txtType = null;

	var strTxtTypeDisp = "document.forms['frmPowerSearch'].txtType";
	var txtTypeDisp = null;

	//can abstracts be selected?
	var bAbstractSelect = true;
	var bMultiSelect = true;
	//define variables required for showing vault chooser
	var bVaultMultiSelect = true;
	var strTxtVault = "document.forms['frmPowerSearch'].txtVault";
	var txt_Vault = null;

var browser = navigator.userAgent.toLowerCase();
	function cptKey(e)
	{
		var pressedKey = ("undefined" == typeof (e)) ? event.keyCode : e.keyCode ;
	if(browser.indexOf("msie") > -1)
	{
		if (((pressedKey == 8) ||((pressedKey == 37) && (event.altKey)) || ((pressedKey == 39) && (event.altKey))) &&((event.srcElement.form == null) || (event.srcElement.isTextEdit == false)))
			return false;
		if( (pressedKey == 37 && event.altKey) || (pressedKey == 39 && event.altKey) && (event.srcElement.form == null || event.srcElement.isTextEdit == false))
			return false;
	}
	else if(browser.indexOf("mozilla") > -1 || browser.indexOf("netscape") > -1)
	{
		var targetType =""+ e.target.type;
		if(targetType.indexOf("undefined") > -1)
		{
			if( pressedKey == 8 || pressedKey == 37 )
				return false;
		}
    }
		if (pressedKey == "27")
		{
			// ASCII code of the ESC key
			top.window.close();
		}
	}
// Add a handler
if(browser.indexOf("msie") > -1){
   document.onkeydown = cptKey ;
}else if(browser.indexOf("mozilla") > -1 || browser.indexOf("netscape") > -1){
	document.onkeypress = cptKey ;
}

</script>

<%
	/* IEF additions Start
	Reasons:
	1. To see whether integration is active.
	2. Add code to show a field called InstanceName.
  	*/

	MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
	Context _context							= integSessionData.getClonedContext(session);

	String instanceNameLable	= null;
	Vector iefFamilyTypes		= null;
	if(integSessionData != null)
	{
		iefFamilyTypes = integSessionData.getValidFamilyTypes(_context);

		instanceNameLable = integSessionData.getStringResource("mcadIntegration.Server.FieldName.InstanceName");
	}
	/* IEF additions End */

	String languageStr = request.getHeader("Accept-Language");
	try{
		// For append replace time stamp
		String sTimeStampPassed = emxGetParameter(request, "timeStamp");
		//  String suiteKey = emxGetParameter(request, "suiteKey");

   	    String strTypeList = "type_CADDrawing,type_CADModel";
		if(integSessionData != null)
		{
			 strTypeList = integSessionData.getTypesForTypeChooser(_context);
		}

		String integrationsTypeList = "";
		StringTokenizer typeTokens	= new StringTokenizer(strTypeList, ",");
		while (typeTokens.hasMoreTokens())
        {
			String strType = typeTokens.nextToken().trim();

			if (strType != null && strType.length()>0)
            {
				String realName	= PropertyUtil.getSchemaProperty( _context, strType);

				if(integrationsTypeList.equals(""))
					integrationsTypeList = realName;
				else
					integrationsTypeList = integrationsTypeList + "," + realName;
			}
		}
%>

<%@include file= "../emxUICommonHeaderEndInclude.inc"%>
<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<form name="frmPowerSearch" id="idForm" method="post" action="emxInfoSearchSummaryTable.jsp" target="_parent" onSubmit="return false">



<!-- IEF additions Start -->
<input type=hidden name="txtWhereClause" value="">
<input type="hidden" name="txtInstanceName" value="*">
<!-- IEF additions End -->
<input type=hidden name="selType" value="">
<input type=hidden name="timeStampAdvancedSearch" value="<%=sTimeStampPassed%>">
<input type=hidden name="queryLimit" value="">
<input type=hidden name="suiteKey" value="<%=sInfoCentralSuite%>">
<input type=hidden name="selType" value="">
<input type="hidden" name="txtName" value="*">

<table border="0" cellspacing="2" cellpadding="3" width="100%" >
  <tr>
    <td class="label"><%=i18nNow.getBasicI18NString("Type",  languageStr)%></td>
    <td class="inputField">
      <input type=text value="<%=integrationsTypeList%>" size="16" name="txtType" readonly="readonly" <%=sKeyPress%>>
      <input type=button name="btnTypeSelector" value="..." onClick="showTypeSelector('<%=strTypeList%>','true', 'frmPowerSearch', 'txtType', 'true')";>
    </td>
  </tr>
  <tr>
    <td class="label"><%=i18nNow.getBasicI18NString("Name",  languageStr)%></td>
    <td class="inputField"><input type="text" name="ui_txtName" size="16" value="*" <%=sKeyPress%>></td>
<!-- IEF Changes Start -->
<%
	if(integSessionData != null && iefFamilyTypes != null && iefFamilyTypes.size() > 0)
	{
%>
  	<td class="inputField"><input type="checkbox" name="DoInstanceSearch" checked OnClick="clicked_DoInstanceSearch();" <%=sKeyPress%>></td>
    <td class="label"><%=i18nNow.getBasicI18NString("ApplyToInstance",  languageStr)%></td>
<%
	}
%>
<!-- IEF Changes End -->
  </tr>
  <tr>
    <td class="label"><%=i18nNow.getBasicI18NString("Revision",  languageStr)%></td>
    <td class="inputField"><input type="text" name="txtRev" size="16" value="*" <%=sKeyPress%>></td>
  </tr>

  <tr>
    <td class="label"><%=i18nNow.getBasicI18NString("Owner",  languageStr)%></td>
    <td class="inputField"><input type="text" name="txtOwner" size="16" value="*" <%=sKeyPress%>></td>
  </tr>
<!-- IEF Changes Start -->
<%
	if(integSessionData != null && iefFamilyTypes != null && iefFamilyTypes.size() > 0)
	{
%>
  <tr>
    <td class="label"><%= instanceNameLable %></td>
    <td class="inputField"><input type="text" name="ui_txtInstanceName" size="16" value="*" style="background-color:silver;" DISABLED <%=sKeyPress%>></td>
  </tr>
<%
	}
%>
<!-- IEF Changes End -->
  <tr>
    <td class="label"><%=i18nNow.getBasicI18NString("Vault",  languageStr)%></td>
    <td class="inputField">
       <input type=text value="*" size="16" name="txtVault" <%=sKeyPress%>>
      <input type=button value="..." onClick=showVaultSelector()>
    </td>
  </tr>
</table>
<table>
 <tr>
	<td ><input type="radio" name="chkAppendReplace" value="replace" checked <%=sKeyPress%> ></td>
    <td ><framework:i18n localize="i18nId">emxIEFDesignCenter.Search.ReplaceObjects</framework:i18n></td>
	<td ><input type="radio" name="chkAppendReplace" value="append" <%=sKeyPress%> ></td>
    <td ><framework:i18n localize="i18nId">emxIEFDesignCenter.Search.AppendObjects</framework:i18n></td>
  </tr>
 </table>
</form>
<%
  } catch (Exception e) {
    String sError = e.getMessage();
%>
	<script language="JavaScript">
		showError("<%=sError%>");
		window.parent.close();
	</script>
<%
    return;
  }

%>

<%@include file= "../emxUICommonEndOfPageInclude.inc"%>
