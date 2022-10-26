<%--  DSCLockedObjects.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>

<%@ page import = "com.matrixone.MCADIntegration.server.*,com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.beans.*,java.util.*,com.matrixone.apps.domain.util.*" %>
<%@page import="com.matrixone.servlet.Framework"%>
<%@page import="matrix.db.Context"%> 
<%

String sActionURL								= "DSCIndentedTable.jsp?toolbar=DSCLockedObjectsTopActionBar&header=emxIEFDesignCenter.Common.LockedObjects&program=IEFObjectsLockedBy:getList&selection=multiple&table=DSCDefault&showIntegrationOption=true&funcPageName=MyLockedObjects&HelpMarker=emxhelplockedobjects&suiteKey=DesignerCentral&jpoAppServerParamList=session:GCOTable,session:GCO,session:LCO&objectCompare=false&refreshFrame=lockedObjectsFrame";
Context context = Framework.getFrameContext(session);
String acceptLanguage							= request.getHeader("Accept-Language");
String errorMessage								= "";
String featureName								= "LockedObjects";
MCADIntegrationSessionData integSessionData		= (MCADIntegrationSessionData)session.getAttribute(MCADServerSettings.MCAD_INTEGRATION_SESSION_DATA_OBJECT);
MCADServerResourceBundle serverResourceBundle	= new MCADServerResourceBundle(acceptLanguage);

ResourceBundle iefProps							= ResourceBundle.getBundle("emxIEFDesignCenter");
String queryLimit								= iefProps.getString("eServiceInfoCentral.QueryLimit");

if(null != queryLimit)
	sActionURL+="&DSCMyLockedObjectLimit="+queryLimit;
	
String portalMode								= Request.getParameter(request,"portalMode");
String errorPage								= "../integrations/emxAppletTimeOutErrorPage.jsp";

if(null != portalMode)
	sActionURL+="&portalMode="+portalMode;

if(integSessionData == null)
{
%> 
    <jsp:forward page="<%=XSSUtil.encodeForHTML(context, errorPage)%>" />              

<%

}
else 
{
	String isFeatureAllowed	= integSessionData.isFeatureAllowedForIntegration("", featureName);

	MCADLocalConfigObject lco = integSessionData.getLocalConfigObject();
	if(lco == null  ||  lco.getIntegrationNameGCONameMapping().size() == 0 || integSessionData.isNonIntegrationUser())
	{
		errorPage += "?featureName="+featureName;
%> 
        <jsp:forward page="<%=XSSUtil.encodeForHTML(context, errorPage)%>" />              
<%
	}
}

%>

<script language="JavaScript">
//XSSOK
var message = "<%= errorMessage %>" + "";
if( message == "")
{
	var isIE11 = !!navigator.userAgent.match(/Trident.*rv[ :]*11\./);
	var forwardURL  = "<%=XSSUtil.encodeForJavaScript(context, sActionURL)%>";
	if(isIE11)
	{
		 forwardURL+= "&isBrowserIE=true";
	}
	else
	{
		forwardURL+= "&isBrowserIE=false";
	}

	document.location.href= forwardURL;
}
</script>

