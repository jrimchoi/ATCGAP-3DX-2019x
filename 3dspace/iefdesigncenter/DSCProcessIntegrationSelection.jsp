<%--  DSCProcessIntegrationSelection.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>

<%@ page import="com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.beans.*,matrix.db.*,com.matrixone.apps.domain.util.*"  %>
<%@include file="emxInfoCentralUtils.inc" %>
<%@include file = "../emxTagLibInclude.inc"%>

<%
	MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
	context										= integSessionData.getClonedContext(session);
	MCADMxUtil util								= new MCADMxUtil(context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());

	String integrationName						= Request.getParameter(request,"DSCIntegrationListFilter");
	MCADGlobalConfigObject globalConfigObject	= integSessionData.getGlobalConfigObject(integrationName,context);

	String myLockedObjectLimit					= Request.getParameter(request, "DSCMyLockedObjectLimit");
	String myLockedObjectNameFilter				= Request.getParameter(request, "DSCMyLockedObjectsNameFilter");

	session.setAttribute("GCO", globalConfigObject);
%>

<script language="javascript">
	
		var url = parent.location.href;

		if(isNaN("<%=XSSUtil.encodeForJavaScript(context,myLockedObjectLimit)%>") == true)
		{
			alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.PowerSearch.LimitMustBeNumeric</framework:i18nScript>");
		}
		else if("<%=XSSUtil.encodeForJavaScript(context,myLockedObjectLimit)%>" <= 0)
		{
			alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.PowerSearch.LimitMustBeGreaterThan</framework:i18nScript>");
		}
		else if("<%=XSSUtil.encodeForJavaScript(context,myLockedObjectLimit)%>" > 32767)
		{
			alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.PowerSearch.LimitMustBeLessThan</framework:i18nScript>");
		}
		else
		{
			if(url.indexOf("integrationName=") > 0)
			{
				url = url.replace(/integrationName=[^&]*/, "integrationName=" + "<%=XSSUtil.encodeForURL(context,integrationName)%>");
			}
			else
			{
				url += "&integrationName=" + "<%=XSSUtil.encodeForURL(context,integrationName)%>";
			}
			
			if(url.indexOf("DSCMyLockedObjectLimit=") > 0)
			{
				url = url.replace(/DSCMyLockedObjectLimit=[^&]*/, "DSCMyLockedObjectLimit=" + "<%=XSSUtil.encodeForURL(context,myLockedObjectLimit)%>");
			}
			else
			{
				url += "&DSCMyLockedObjectLimit=" + "<%=XSSUtil.encodeForURL(context,myLockedObjectLimit)%>";
			}

			if(url.indexOf("DSCMyLockedObjectsNameFilter=") > 0)
			{
				url = url.replace(/DSCMyLockedObjectsNameFilter=[^&]*/, "DSCMyLockedObjectsNameFilter=" + "<%=XSSUtil.encodeForURL(context,myLockedObjectNameFilter)%>");
			}
			else
			{
				url += "&DSCMyLockedObjectsNameFilter=" + "<%=XSSUtil.encodeForURL(context,myLockedObjectNameFilter)%>";
			}
			
			parent.location.href = url;
		}
</script>
