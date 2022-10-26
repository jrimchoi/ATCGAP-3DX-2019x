<%--  DSCRecentCheckinFiles.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>

<%@ page import = "com.matrixone.MCADIntegration.server.*,com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.beans.*,java.util.*,com.matrixone.apps.domain.util.*" %>
<%

String sActionURL								= "DSCIndentedTable.jsp?toolbar=DSCDefaultTopActionBar&header=emxIEFDesignCenter.Common.RecentlyCheckedInFiles&program=DSCCheckinHistoryUtil:getRecentCheckinFiles&selection=multiple&table=DSCRecentCheckinFiles&showIntegrationOption=true&funcPageName=RecentlyCheckedInFiles&HelpMarker=emxhelpdscrecentlychecked&suiteKey=DesignerCentral&jpoAppServerParamList=session:GCOTable,session:GCO,session:LCO&objectCompare=false&sortColumnName=CheckinDate&sortDirection=descending&refreshFrame=recentCheckinFilesFrame";
String acceptLanguage							= request.getHeader("Accept-Language");
String errorMessage								= "";
String featureName									= "RecentlyCheckedInFiles";
MCADIntegrationSessionData integSessionData		= (MCADIntegrationSessionData)session.getAttribute(MCADServerSettings.MCAD_INTEGRATION_SESSION_DATA_OBJECT);
MCADServerResourceBundle serverResourceBundle	= new MCADServerResourceBundle(acceptLanguage);
String portalMode								= Request.getParameter(request,"portalMode");
String errorPage								= "../integrations/emxAppletTimeOutErrorPage.jsp";

if(null != portalMode)
	sActionURL+="&portalMode="+portalMode;

if(integSessionData == null)
{
%> 

    <jsp:forward page="<xss:encodeForHTML><%=errorPage%></xss:encodeForHTML>" />              

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

        <jsp:forward page="<xss:encodeForHTML><%=errorPage%></xss:encodeForHTML>" />              
<%
	}
}

%>

<script language="JavaScript">
//XSSOK-->
var message = "<%= errorMessage %>" + "";
if( message == "")
{
	var isIE11 = !!navigator.userAgent.match(/Trident.*rv[ :]*11\./);
	//XSSOK-->
	var forwardURL  = "<%=sActionURL%>";
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

