<%--  DSCReplaceObjectsOptionDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  DSCReplaceObjectsOptionDialog.jsp   -   Displays the UI required for showing the option

--%>

<%@include file ="../integrations/MCADTopInclude.inc"%>
<%@include file="emxInfoUtils.inc"%>


<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<%
	String acceptLanguage	= request.getHeader("Accept-Language");
	String jsTreeID			= emxGetParameter(request, "jsTreeID");
	String suiteKey			= emxGetParameter(request, "suiteKey");
	String objectID			= emxGetParameter(request, "objectId");
	String[] objectIds		= emxGetParameterValues(request, "emxTableRowId");

	MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");

	Context context = integSessionData.getClonedContext(session);
	MCADMxUtil util = new MCADMxUtil(context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
	

	String relIDBusID = objectIds[0]; 

	String selectedRelID	= relIDBusID.substring(0, relIDBusID.indexOf('|'));
	String selectedObjectID = relIDBusID.substring(relIDBusID.indexOf('|') + 1);

	String integrationName						= util.getIntegrationName(context, selectedObjectID);
	MCADGlobalConfigObject globalConfigObject	= integSessionData.getGlobalConfigObject(integrationName,context);

	String templateLabelForComponent			= i18nStringNowLocal("emxIEFDesignCenter.CreateCADStructure.SelectComponentTemplate", acceptLanguage);
	String templateLabelForAssembly				= i18nStringNowLocal("emxIEFDesignCenter.CreateCADStructure.SelectAssemblyTemplate", acceptLanguage);
	
	String[] packedGCO = new String[2];
	packedGCO = JPO.packArgs(globalConfigObject);

	String[] args = new String[9];
	args[0]  = packedGCO[0];
	args[1]  = packedGCO[1];
	args[2]  = integSessionData.getLanguageName();
	args[3]  = integrationName;
	args[4]  = selectedRelID;
	args[5]  = selectedObjectID;
	args[6]  = templateLabelForComponent;
	args[7]  = templateLabelForAssembly;

	Hashtable structureCreationData = (Hashtable)util.executeJPO(context, "IEFReplaceObjectsOptionDialog", "getStructureCreationData", args, Hashtable.class);

	String templatesComboControlString	= (String)structureCreationData.get("templatesComboControlString");
	String templateLabel				= (String)structureCreationData.get("templateLabel");

	String cadTypeAttrName	= util.getActualNameForAEFData(context, "attribute_CADType");
	String cadType			= util.getAttributeForBO(context, objectID, cadTypeAttrName);
	boolean isInstanceType	= globalConfigObject.isTypeOfClass(cadType, MCADAppletServletProtocol.TYPE_INSTANCE_LIKE);
	boolean isFamilyLike	= globalConfigObject.isTypeOfClass(cadType, MCADAppletServletProtocol.TYPE_FAMILY_LIKE);
%>

<html>
<head>
<title> Remove Objects </title>

<style type="text/css"> 
	body { background-color: white; }
	body, th, td, p, select, option { font-family: Verdana, Arial, Helvetica, Sans-Serif; font-size: 10pt; }
	a { color: #003366; }
	a:hover { }
	td.pageHeader {  font-family: Arial, Helvetica, Sans-Serif; font-size: 13pt; font-weight: bold; color: #990000; } 
	td.pageBorder {  background-color: #003366; } 
	th { text-align: left; color: white; background-color: #336699; font-size: 10pt;}
</style>

<script language="JavaScript">

function submit()
{
	var formObject = document.replaceObject;
	formObject.submit();
}

</script>
</head>

<body>
<form name="replaceObject" method="post" target="_self" action="DSCReplaceObjects.jsp">

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
//System.out.println("CSRFINJECTION::DSCReplaceObjectsOptionDialog.jsp::form::replaceObject");
%>

<table border="0" width="100%">
	  <tr><th width="100%"><%=i18nStringNowLocal("emxIEFDesignCenter.CreateCADStructure.SelectTemplateObjects", acceptLanguage)%></th></tr>
	  <tr><td>&nbsp;</td></tr>
</table>
<%
if(templatesComboControlString.equals(""))
{
%>
	<tr>
		<td><b><%=i18nStringNowLocal("emxIEFDesignCenter.Message.MissingTemplate", acceptLanguage)%></b></td>
	</tr>
<%
}
else if(isInstanceType || isFamilyLike)
{
%>
	<tr>
		<td><b><%=i18nStringNowLocal("emxIEFDesignCenter.ReplaceObject.Message.NotSupportedForFamily", acceptLanguage)%></b></td>
	</tr>
<%
}
else
{
%>
	<table border="0" width="100%">
		<tr>
		    <!--XSSOK-->
			<td width="30%" nowrap><b><%=templateLabel%></b></td>
			<!--XSSOK-->
			<td width="70%"><%= templatesComboControlString %></td>
		</tr>
	</table>
<%
}
%>

<input type="hidden" name="objectId" value="<xss:encodeForHTMLAttribute><%= objectID  %></xss:encodeForHTMLAttribute>">
<input type="hidden" name="suiteKey" value="<xss:encodeForHTMLAttribute><%= suiteKey %></xss:encodeForHTMLAttribute>">
<input type="hidden" name="jsTreeID" value="<xss:encodeForHTMLAttribute><%= jsTreeID %></xss:encodeForHTMLAttribute>">
<!--XSSOK-->
<input type="hidden" name="integrationName" value="<%= integrationName %>">
<%
	for(int i=0; i<objectIds.length; i++)
	{
%>
<input type="hidden" name="emxTableRowId" value="<%= objectIds[i] %>">
<%
	}
%>

</form>
</body>
</html>


