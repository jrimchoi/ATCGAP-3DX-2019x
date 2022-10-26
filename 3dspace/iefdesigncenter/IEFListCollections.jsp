<%--  IEFListCollections.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>

<%@ page import = "com.matrixone.MCADIntegration.server.*,com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.beans.*,java.util.*,com.matrixone.apps.domain.util.*" %>


<%

String sActionURL								=	"../common/emxIndentedTable.jsp?header=emxIEFDesignCenter.Common.Collections&program=IEFListCollectionsByUser:getTableData&selection=multiple&sortColumnName=CollectionName&sortDirection=ascending&pagination=10&toolbar=IEFCollectionsTopActionBarActions&HelpMarker=emxhelpdsccollections&table=DSCCollections&suiteKey=DesignerCentral&objectCompare=false&expandLevelFilter=false";
String acceptLanguage							= request.getHeader("Accept-Language");
String errorMessage								= "";
String featureName								= MCADGlobalConfigObject.FEATURE_COLLECTIONS;
MCADIntegrationSessionData integSessionData		= (MCADIntegrationSessionData)session.getAttribute(MCADServerSettings.MCAD_INTEGRATION_SESSION_DATA_OBJECT);
matrix.db.Context context = integSessionData.getClonedContext(session);
MCADServerResourceBundle serverResourceBundle	= new MCADServerResourceBundle(acceptLanguage);
String portalMode								= Request.getParameter(request,"portalMode");
String errorPage								= "/integrations/emxAppletTimeOutErrorPage.jsp";

if(null != portalMode)
	sActionURL+="&portalMode="+portalMode;

if(integSessionData == null)
{
%> 

    <jsp:forward page="<%=XSSUtil.encodeForHTML(context,errorPage)%>" />              

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
        <jsp:forward page="<%=XSSUtil.encodeForHTML(context,errorPage)%>" />              
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
	var forwardURL  = "<%=XSSUtil.encodeForJavaScript(integSessionData.getClonedContext(session),sActionURL)%>";
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
