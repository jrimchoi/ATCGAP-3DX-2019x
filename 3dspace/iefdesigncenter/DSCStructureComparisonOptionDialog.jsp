<%--  DSCStructureComparisonOptionDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  DSCCompareStructureComparisonOptionDialog.jsp   -  Dialog for Structure Comparison Report providing user with different options of report display



--%>

<%@include file = "emxInfoCentralUtils.inc"%>
<%@ include file = "../emxUICommonHeaderBeginInclude.inc" %>
<%@page import ="com.matrixone.MCADIntegration.server.beans.*,com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.*" %>
<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>
<%
	String I18NResourceBundle	= "emxIEFDesignCenterStringResource";
	String acceptLanguage		= request.getHeader("Accept-Language");
	String headerKey			= i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.SelectCompare", I18NResourceBundle, acceptLanguage);

	String part1Id = emxGetParameter(request, "structure1Id");
	String part2Id = emxGetParameter(request, "structure2Id");

	String objectId		= emxGetParameter(request, "objectId");
	String suiteKey		= emxGetParameter(request, "suiteKey");
	String timeStamp	= emxGetParameter(request, "timeStamp");

	HashMap requestParamMap = (HashMap)session.getAttribute("ParameterList" + timeStamp);

	String txtType		= (String)requestParamMap.get("txtType");
	String txtName		= (String)requestParamMap.get("txtName");
	String txtRev		= (String)requestParamMap.get("txtRev");
	String txtOwner		= (String)requestParamMap.get("txtOwner");
	String txtVault		= (String)requestParamMap.get("txtVault");

	String errorMsg     = "";

	MCADIntegrationSessionData integSessionData		= (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
	MCADServerResourceBundle serverResourceBundle	= new MCADServerResourceBundle(request.getHeader("Accept-Language"));
	if(integSessionData != null)
	{
		Context iefContext		= integSessionData.getClonedContext(session);
		MCADMxUtil util			= new MCADMxUtil(iefContext, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
		String integrationName1	= util.getIntegrationName(iefContext, part1Id);
		String integrationName2	= util.getIntegrationName(iefContext, part2Id);

		String isFeatureAllowed	= integSessionData.isFeatureAllowedForIntegration(integrationName1, MCADGlobalConfigObject.FEATURE_STRUCTURE_COMPARISON);
		if(!isFeatureAllowed.startsWith("true"))
			errorMsg = isFeatureAllowed.substring(isFeatureAllowed.indexOf("|")+1, isFeatureAllowed.length());
		else
			isFeatureAllowed	= integSessionData.isFeatureAllowedForIntegration(integrationName2, MCADGlobalConfigObject.FEATURE_STRUCTURE_COMPARISON);

		if(!isFeatureAllowed.startsWith("true"))
			errorMsg = isFeatureAllowed.substring(isFeatureAllowed.indexOf("|")+1, isFeatureAllowed.length());
 	}
	else
		errorMsg = serverResourceBundle.getString("mcadIntegration.Server.Message.ServerFailedToRespondSessionTimedOut");
%>

<script language="javascript">
//XSSOK
var error = "<%=errorMsg%>" + "";
if(error != "")
{
	alert(error);
}

function submit()
{
	if(error != "")
	{
		alert(error);
		return;
	}
	else if (document.selectOptions.showp1unique.checked == false && document.selectOptions.showp2unique.checked == false && document.selectOptions.showcommon.checked == false)
	{
	       //XSSOK
		var msg = "<%=i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.SelectSectionToDisplay", I18NResourceBundle, acceptLanguage)%>";

		alert(msg);
		return;
	}
	else
	{
		document.selectOptions.submit();
		return;
	}
}

function goBack()
{
	document.selectOptions.action="emxInfoTable.jsp?expandCheckFlag=true";
	document.selectOptions.submit();
}

</script>

<%@include file = "../emxUICommonHeaderEndInclude.inc" %>

<form name="selectOptions" method="post" onSubmit="javascript:submit(); return false" action="DSCCompareStructureComparisonReport.jsp" target="_parent">
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
//System.out.println("CSRFINJECTION::DSCStructureComparisonOptionDialog.jsp::form::selectOptions");
%>

        <!--XSSOK-->
	<input type=hidden name="structure1Id" value="<%=part1Id%>">
        <!--XSSOK-->
	<input type=hidden name="structure1Id" value="<%=part1Id%>">
        <!--XSSOK-->
	<input type=hidden name="structure2Id" value="<%=part2Id%>">
        <!--XSSOK-->
	<input type=hidden  name=objectId value="<%=objectId%>" >
	<input type=hidden  name=sRelationName value="" >
	<input type=hidden  name=sRelDirection value="" >
	<input type=hidden  name=program value="IEFAdvancedFind:getList" >
	<input type=hidden  name=table value="DSCDefault" >
	<input type=hidden  name=topActionbar value="DSCCompareStructureTopActionBarActions">
	<!--XSSOK-->
	<input type=hidden  name=header value="<%=headerKey%>" >
	<input type=hidden  name=selection value="single">
	<input type=hidden  name=pagination value="10">
	<input type=hidden  name=headerRepeat value="10">
	<input type=hidden name="queryLimit" value="">
	<input type=hidden name="targetLocation" value="popup">
        <!--XSSOK-->
	<input type=hidden name="suiteKey" value="<%=suiteKey%>">
	<input type=hidden name="HelpMarker" value="emxhelpdsccomparestructure">
	<!--XSSOK-->
        <input type="hidden" name="txtType" value="<%=txtType%>">
        <!--XSSOK-->
	<input type="hidden" name="txtName" value="<%=txtName%>">
        <!--XSSOK-->
	<input type="hidden" name="txtRev" value="<%=txtRev%>">
        <!--XSSOK-->
	<input type="hidden" name="txtOwner" value="<%=txtOwner%>">
        <!--XSSOK-->
	<input type="hidden" name="txtVault" value="<%=txtVault%>">
        <!--XSSOK-->
	<input type="hidden" name="timeStamp" value="<%=timeStamp%>">

<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tr>
<td>&nbsp;</td>
</tr>
<tr>
<td>&nbsp;</td>
</tr>
<tr>
<td>&nbsp;</td>
</tr>
</table>

  <table border="0" cellspacing="0" cellpadding="0" width="100%">
<tr>
<td>&nbsp;</td>
</tr>
  </table>

  <table border="0" cellpadding="25" cellspacing="2" width="100%">
    <tr>
      <td width="170" class="label">
        <label for="sections"><%= i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.Sections", I18NResourceBundle, acceptLanguage)%></label>
      </td>
      <td class="inputField" width="380">
        <table border=0>
          <tr>
            <td>
              <input type="checkbox" checked value="p1comp" name="showp1unique" id="showp1unique" >
            </td>
            <td><%= i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.Part1UniqueComponents", I18NResourceBundle, acceptLanguage)%></td>
          </tr>
          <tr>
            <td>
              <input type="checkbox" checked value="p2comp" name="showp2unique" id="showp2unique" >
            </td>
            <td><%= i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.Part2UniqueComponents", I18NResourceBundle, acceptLanguage)%></td>
          </tr>
          <tr>
            <td>
              <input type="checkbox"  value="commoncomp" name="showcommon" id="showcommon" >
            </td>
            <td><%= i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.CommonComponents", I18NResourceBundle, acceptLanguage)%></td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</form>

<%@include file = "../emxUICommonEndOfPageInclude.inc" %>
