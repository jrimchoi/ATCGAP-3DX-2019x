<%--  IEFCollectionsItem.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>

<%@ page import="java.util.*,java.io.*, java.net.*,com.matrixone.MCADIntegration.server.*,com.matrixone.MCADIntegration.server.beans.*, com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.utils.customTable.*"  %>
<%@ page import = "matrix.db.*, matrix.util.*,com.matrixone.servlet.*,com.matrixone.apps.framework.ui.*,com.matrixone.apps.domain.util.*, com.matrixone.apps.domain.*"%>
<%@page import ="com.matrixone.apps.domain.util.*" %>
<%@ include file ="../emxRequestWrapperMethods.inc" %>
<%@ include file="../common/emxNavigatorTopErrorInclude.inc" %>

<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<html>
<head>

<%
    Context context          = null;
	String objectID			 = Request.getParameter(request,"objectId");
	String progName			 = Request.getParameter(request,"program");	
	String headerKey		 = Request.getParameter(request,"header");	
	String helpMarker		 = Request.getParameter(request,"HelpMarker");
	String table     		 = Request.getParameter(request,"table");
	String topActionbar		 = Request.getParameter(request,"topActionbar");
	String sortColumnName	 = Request.getParameter(request,"sortColumnName");
	String suiteKey			 = Request.getParameter(request,"suiteKey");
	String sortDirection	 = Request.getParameter(request,"sortDirection");
	String selection		 = Request.getParameter(request,"selection");
	String pagination		 = Request.getParameter(request,"pagination");
	String sSetName		 = Request.getParameter(request,"setName");
	
	
	progName	   = (progName == null) ? "IEFFetchCollectionDetails:getList" : progName;
	table   	   = (table == null) ? "DSCDefault" : table;
	topActionbar   = (topActionbar == null) ? "IEFViewCollectionTopActionBar" : topActionbar;
	suiteKey	   = (suiteKey == null) ? "eServiceSuiteDesignerCentral" : suiteKey;
	headerKey	   = (headerKey == null) ? "emxIEFDesignCenter.Command.CollectionItems" : headerKey;
	helpMarker	   = (helpMarker == null) ? "emxhelpdscitems" : helpMarker;
	selection 	   = (selection == null) ? "multiple" : selection;
	sortColumnName = (sortColumnName == null) ? "Name" : sortColumnName;
	sortDirection  = (sortDirection == null) ? "ascending" : sortDirection;
	pagination     = (pagination == null) ? "10" : pagination;
	
	String integrationName						= "";
	String headerString							= "";
	String errorMessage							= "";

	MCADGlobalConfigObject  globalConfigObject	= null;

	MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute(MCADServerSettings.MCAD_INTEGRATION_SESSION_DATA_OBJECT);
	
	String acceptLanguage						  = request.getHeader("Accept-Language");
	MCADServerResourceBundle serverResourceBundle = new MCADServerResourceBundle(acceptLanguage);
    
	if(integSessionData == null)
	{
        errorMessage = serverResourceBundle.getString("mcadIntegration.Server.Message.ServerFailedToRespondSessionTimedOut");
	}
	else
	{
		context				= integSessionData.getClonedContext(session);
		MCADMxUtil util		= new MCADMxUtil(context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
		integrationName		= util.getIntegrationName(context, objectID);
		headerString		= integSessionData.getStringResource(headerKey);
		
		globalConfigObject			= integSessionData.getGlobalConfigObject(integrationName,context);

		session.setAttribute("GCO",globalConfigObject);
		session.setAttribute("LCO",integSessionData.getLocalConfigObject());
		session.setAttribute("GCOTable",integSessionData.getIntegrationNameGCOTable(context));
	}

	String setName				= sSetName;
	CacheUtil.setCacheObject(context, "DEC_CollectionName", setName);
	/*String queryString			= emxGetQueryString (request);
	StringTokenizer qStrtoken	= new StringTokenizer(queryString, "&");
    while (qStrtoken.hasMoreTokens())
    {
		String strMsg = qStrtoken.nextToken();
		if(strMsg.startsWith("setName"))
		{
			String encodedSetName = strMsg.substring(strMsg.indexOf("=")+1);
			//setName = MCADUrlUtil.hexDecode(encodedSetName);
			setName = XSSUtil.decodeForURL(encodedSetName)
		}
		else if(strMsg.startsWith("treeLabel"))
			setName = strMsg.substring(strMsg.indexOf("=")+1);
	}*/
%>

</head>
<body>
<form name="whereUsedForm" action="../common/emxIndentedTable.jsp">
	<input type="hidden" name="program" value="<xss:encodeForHTMLAttribute><%=progName%></xss:encodeForHTMLAttribute>"/>
	<input type="hidden" name="expandLevelFilter" value="false">
	<input type="hidden" name="jpoAppServerParamList" value="session:GCOTable,session:LCO,session:GCO">
	<input type="hidden" name="table" value="<xss:encodeForHTMLAttribute><%=table%></xss:encodeForHTMLAttribute>"/>
	<input type="hidden" name="sortColumnName" value="<xss:encodeForHTMLAttribute><%=sortColumnName%></xss:encodeForHTMLAttribute>"/>
	<input type="hidden" name="sortDirection" value="<xss:encodeForHTMLAttribute><%=sortDirection%></xss:encodeForHTMLAttribute>"/>
	<input type="hidden" name="selection" value="<xss:encodeForHTMLAttribute><%=selection%></xss:encodeForHTMLAttribute>"/>
	<input type="hidden" name="topActionbar" value="<xss:encodeForHTMLAttribute><%=topActionbar%></xss:encodeForHTMLAttribute>"/>
	<input type="hidden" name="header" value="<xss:encodeForHTMLAttribute><%=headerKey%></xss:encodeForHTMLAttribute>"/>
	<input type="hidden" name="suiteKey" value="<xss:encodeForHTMLAttribute><%=suiteKey%></xss:encodeForHTMLAttribute>"/>
	<input type="hidden" name="objectCompare" value="false">
	<input type="hidden" name="objectId" value="<xss:encodeForHTMLAttribute><%=objectID%></xss:encodeForHTMLAttribute>"/>
	<input type="hidden" name="HelpMarker" value="<xss:encodeForHTMLAttribute><%=helpMarker%></xss:encodeForHTMLAttribute>"/>
	<input type="hidden" name="pagination" value="<xss:encodeForHTMLAttribute><%=pagination%></xss:encodeForHTMLAttribute>"/>
	<input type="hidden" name="setName" value="<xss:encodeForHTMLAttribute><%=setName%></xss:encodeForHTMLAttribute>"/>
</form>

<%@ include file="../common/emxNavigatorBottomErrorInclude.inc" %>

<%
	if ("".equals(errorMessage.trim()))
	{
%>
	<SCRIPT LANGUAGE="JavaScript">
		document.whereUsedForm.submit();
	</SCRIPT>
<%
	} else {
%>
	<link rel="stylesheet" href="../emxUITemp.css" type="text/css">
	&nbsp;
      <table width="90%" border=0  cellspacing=0 cellpadding=3  class="formBG" align="center" >
        <tr >
		  <!--XSSOK-->
          <td class="errorHeader"><%=serverResourceBundle.getString("mcadIntegration.Server.Heading.Error")%></td>
        </tr>
        <tr align="center">
		  <!--XSSOK-->
          <td class="errorMessage" align="center"><%=errorMessage%></td>
        </tr>
      </table>
<%
	}
%>
</body>
</html>
