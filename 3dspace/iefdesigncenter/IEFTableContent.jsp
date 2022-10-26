<%--  IEFTableContent.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%@ include file ="../integrations/MCADTopInclude.inc"%>

<%
	String tableName             = emxGetParameter(request, "tableName");
	String encodedDefaultPageURL = emxGetParameter(request, "encodedDefaultPageURL");
    String timeStamp             = emxGetParameter(request, "timeStamp");	
	String decodedDefaultPageURL = MCADUrlUtil.hexDecode(encodedDefaultPageURL);	
	String pageURL               = "";
	String matrixTableName		 = "";
	try	
	{
		tableName = MCADUrlUtil.hexDecode(tableName);
	}
	catch (Exception e)
	{
		//leave the tableName as it is
	}

    MCADIntegrationSessionData integSessionData	= (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
    Context context                             = integSessionData.getClonedContext(session);
    MCADMxUtil util                             = new MCADMxUtil(context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
	IEFConfigUIUtil iefConfigUIUtil             = new IEFConfigUIUtil(context, integSessionData, "");
	
	if(tableName.equals("Default"))
		pageURL = decodedDefaultPageURL;
	else
	{
		boolean isSystemTable	= iefConfigUIUtil.isSystemTable(context, tableName);
		matrixTableName	        = iefConfigUIUtil.getFilteredMatrixTableName(tableName, isSystemTable);
		String appName          = application.getInitParameter("ematrix.page.path");
		
		if(isSystemTable == true)
		{
			 pageURL = "/iefdesigncenter/emxInfoTableAdminBody.jsp?selection=null&table=" + matrixTableName +"&timeStamp" + timeStamp + "&footerRefreshRequired=false&pagination=0&IsAdminTable=true";
		}
		else
		{
			 pageURL = "/iefdesigncenter/emxInfoTableWSBody.jsp?selection=null&WSTable=" + matrixTableName +"&timeStamp" + timeStamp + "&footerRefreshRequired=false&pagination=0";
		}
	}

%>
<!--XSSOK-->
<jsp:forward page ="<%=pageURL%>"/>
