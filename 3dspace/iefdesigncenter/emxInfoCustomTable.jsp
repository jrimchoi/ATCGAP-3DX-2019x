<%--  emxInfoCustomTable.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  
  $Archive: /InfoCentral/src/infocentral/emxInfoCustomTable.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$
  
  Name of the File : emxInfoCustomTable.jsp 
  Description : This file sets the framset for custom table page.

--%>

<%--
 *
 * $History: emxInfoCustomTable.jsp $
 * 
 * *****************  Version 27  *****************
 * User: Rahulp       Date: 1/15/03    Time: 3:40p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 26  *****************
 * User: Rahulp       Date: 1/15/03    Time: 1:25p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 25  *****************
 * User: Rahulp       Date: 1/14/03    Time: 4:00p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 24  *****************
 * User: Shashikantk  Date: 12/12/02   Time: 3:11p
 * Updated in $/InfoCentral/src/infocentral
 * Header frame made smaller
 * 
 * *****************  Version 23  *****************
 * User: Gauravg      Date: 12/11/02   Time: 8:55p
 * Updated in $/InfoCentral/src/infocentral
 *
 * ************************************************
 --%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<html>

<%@ page import = "com.matrixone.MCADIntegration.server.beans.*, com.matrixone.MCADIntegration.utils.*" %>

<%@ page import="com.matrixone.MCADIntegration.uicomponents.util.*" %>
<%@ page import="com.matrixone.MCADIntegration.uicomponents.beans.*" %>
<%@ page import="com.matrixone.servlet.*" %>

<%@include file = "emxInfoCustomTableInclude.inc"%>
<%@include file = "emxMQLNotice.inc"%>
<%@ include file = "DSCAppletUtils.inc" %>

<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script>
<%
    //Sets the Target Page value in the session
    //String pageName = request.getRequestURI();
    String pageName = "emxInfoCustomTable.jsp";
	
	//Gets JPO program Name
    String programList = emxGetParameter(request, "custProgram");
    
    //Get timeStamp to handle the table data,column definitions and current index
    String timeStamp = Long.toString(System.currentTimeMillis());

    //Collect all the parameters passed-in and forward them to Tree frame.
    String appendParams = "timeStamp=" + timeStamp + "&" + emxGetQueryString(request);
    String tableHeaderURL = UINavigatorUtil.encodeURL("emxInfoCustomTableHeader.jsp?" + appendParams);    
    String tableBodyURL = UINavigatorUtil.encodeURL("emxInfoCustomTableBody.jsp?" + appendParams);

	MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");  
	
	if (emxGetQueryString(request) != null) {
		pageName += "?" + emxGetQueryString(request);
	}

	Framework.setTargetPage(session, pageName); 

	//Get no of items per page as specified in request parameters
	String pagination = emxGetParameter(request, "custPagination");

	String suiteKey = emxGetParameter(request, "suiteKey"); 
	String registeredSuite = null;
	String suiteDir        = null;
	String stringResFileId = null;

	if ( suiteKey != null && suiteKey.startsWith("eServiceSuite") )
		registeredSuite = suiteKey.substring(13);
	else if( suiteKey != null)
		 registeredSuite = suiteKey;

	if ( (registeredSuite != null) && (registeredSuite.trim().length() > 0 ) )
	{
	  suiteDir = UINavigatorUtil.getRegisteredDirectory(application, registeredSuite);
	  stringResFileId = UINavigatorUtil.getStringResourceFileId(application, registeredSuite);          
	}

        
	//Create CustomMaplist which will be used to collect table data
	IEF_CustomMapList tableData = new IEF_CustomMapList();

	//Create collection to store column definitions
	ArrayList columnDefs = new ArrayList();

	try 
	{
		//Starts database transaction   
		//Parse JPO name specfied as request parameter
	
		ContextUtil.startTransaction(context, true);

		if (programList != null && programList.length() > 0 ) 
		{
			String program = "";

			String tableDataMethodName = "getTableData";

			String columnDefinitionsMethodName = "getColumnDefinitions";
			

			String programParam = "";

			if (programList.indexOf(",") > 0 )
				programParam = programList.substring(0, programList.indexOf(","));
			else
				programParam = programList;
		
			// Build hasmap out of parameters that were passed as request parameters to this page
			// this hashmap is sent as an input parameter to the JPO being called
			if (programParam != null)
			{
				Enumeration enumParamNames = emxGetParameterNames(request);
	   
				HashMap paramMap = new HashMap();
				while(enumParamNames.hasMoreElements())
				{
					String paramName = (String) enumParamNames.nextElement();
					String paramValue = (String)emxGetParameter(request, paramName);
					if (paramValue != null && paramValue.trim().length() > 0 )
						paramMap.put(paramName, paramValue);
				}
				paramMap.put("languageStr", request.getHeader("Accept-Language") );
				paramMap.put("stringResFileId",stringResFileId);
				paramMap.put("charSet",request.getCharacterEncoding());
				//image Servlet url passed to the jpo
				//System.out.println("ImageServletUrl: "+InfoImageServlet.getURL(null));
				//paramMap.put("ImageServletUrl",InfoImageServlet.getURL(null));

				HashMap globalConfigObjectTable = (HashMap)integSessionData.getIntegrationNameGCOTable();
				paramMap.put("GCOTable", globalConfigObjectTable);
			
		   
				String[] intArgs = new String[]{};            
				try 
				{
					tableData = (IEF_CustomMapList)JPO.invoke(context, programParam, intArgs, "getTableData", JPO.packArgs(paramMap), 				 IEF_CustomMapList.class);
					columnDefs = (ArrayList)JPO.invoke(context, programParam, intArgs,"getColumnDefinitions", JPO.packArgs(paramMap), 				  ArrayList.class);
				
				} 
				catch (MatrixException me)
				{
					emxNavErrorObject.addMessage("Unable to invoke Method : " + "in JPO : " + programParam);
					if (me.toString() != null && (me.toString().trim()).length() > 0)
				   emxNavErrorObject.addMessage(me.toString().trim());
				}
			
			}
		}

		// Determine number of objects to be displayed at a time on a page
		if ( ( tableData != null ) && ( tableData.size() > 0 ) )
		{
			int noOfItemsPerPage = 0;
			if (pagination != null)
			{
				noOfItemsPerPage = Integer.parseInt(pagination);
				if (noOfItemsPerPage == 0)
					noOfItemsPerPage = tableData.size();
			}

			//Save the resuls of JPO into session
			//Save current index in the session

			Integer currentIndex = new Integer((noOfItemsPerPage));
			session.setAttribute("TableData" + timeStamp, tableData);
			session.setAttribute("CurrentIndex" + timeStamp, currentIndex);	      
		}

		//Save column definitons in the session
		if(columnDefs != null && columnDefs.size()>0 )
		{    
			session.setAttribute("ColumnDefinitions" + timeStamp,columnDefs);
		}    
	} 
	catch (Exception ex)
	{
		ContextUtil.abortTransaction(context);
		if (ex.toString() != null && (ex.toString().trim()).length() > 0)
			emxNavErrorObject.addMessage(ex.toString().trim());
	} 
	finally 
	{
		ContextUtil.commitTransaction(context);
	}

	//Sets current page in session variable
	Framework.setCurrentPage(session,Framework.getTargetPage(session));

%>

	<head>
	<title>ENOVIA - Table View</title>
	<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
	</head>

	 <frameset rows="75,*,50,0" framespacing="0" frameborder="no" border="0" onunload="JavaScript:cleanupCustomTableSession('<%=XSSUtil.encodeForJavaScript(context,timeStamp)%>')">
	 <!--XSSOK-->
	<frame name="listHead" src="<%=tableHeaderURL%>" noresize="noresize" marginheight="0" marginwidth="10" border="0" scrolling="no" />
	<!--XSSOK-->
	<frame name="listDisplay" src="<%=tableBodyURL%>" noresize="noresize" marginheight="10" marginwidth="10" />
     	<frame name="listFoot" src="../common/emxBlank.jsp" noresize="noresize" marginheight="0" marginwidth="10" border="0" scrolling="no" />
		 <frame name="hiddenCustomFrame" id="hiddenCustomFrame" noresize src="emxBlank.jsp" scrolling="no" marginheight="0" marginwidth="0" frameborder="0" />
    </frameset>
</html>


