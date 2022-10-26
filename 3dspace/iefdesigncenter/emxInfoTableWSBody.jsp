<%--  emxInfoTableWSBody.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoTableWSBody.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxInfoTableWSBody.jsp $
 * 
 * *****************  Version 64  *****************
 * User: Shashikantk  Date: 2/10/03    Time: 5:30p
 * Updated in $/InfoCentral/src/infocentral
 * Now sorting will be done on TNR basis
 * 
 * *****************  Version 50  *****************
 *
--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<html>

<%@ page import = "com.matrixone.MCADIntegration.uicomponents.beans.*"%>
<%@include file = "emxInfoTableInclude.inc" %>

<%@ page import="com.matrixone.MCADIntegration.uicomponents.util.*, com.matrixone.MCADIntegration.server.beans.*, com.matrixone.MCADIntegration.server.*" %>
<%@include file="emxInfoCentralUtils.inc"%>
<jsp:useBean id="emxNavErrorObject" class="com.matrixone.apps.domain.util.FrameworkException" scope="request"/>

<%@page import ="com.matrixone.apps.domain.util.*" %>
<%@ page import = "matrix.db.*, matrix.util.*,com.matrixone.servlet.*,java.util.*" %>
<%@include file = "emxInfoTreeTableUtil.inc"%>
<%@ include file="../emxUICommonHeaderBeginInclude.inc"%>

<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>
// Function FUN080585 : Removal of Cue, Tips and Views
<script language="JavaScript">
function showAlt(th,e,text){
	if (text != 'none')
	{
		if (document.layers )
		{
			var doc = window.parent.frames[1].document;
			doc.tooltip.document.write('<layer bgColor="#ffffd0" style="border:1px solid black;font-family: verdana, helvetica, arial, sans-serif; font-size: 8pt;color:#000000"><font face=arial size=2>'+text+'</font></layer>');
			doc.tooltip.document.close();
			doc.tooltip.left=e.pageX+5;
			doc.tooltip.top=e.pageY+5;
			doc.tooltip.visibility="show";
		}
	}
	return;
}

function hideAlt(){
	if (document.layers){
		var doc = window.parent.frames[1].document;
		doc.tooltip.visibility="hidden";
	}
	return;
}
var progressBarCheck = 1;
  function removeProgressBar(){
	progressBarCheck++;
    if (progressBarCheck < 10){
      if (parent.frames["listHead"] && parent.frames["listHead"].document.imgProgress){
        parent.frames["listHead"].document.imgProgress.src = "../common/images/utilSpacer.gif";
      }else{
        setTimeout("removeProgressBar()",500);
      }
    }
    return true;
  }

function showAlert(message)
{
	alert(message);
}

</script>
<%
	// Related to collection
    String setName         = emxGetSessionParameter(request,"setName");
    String sTarget         =  emxGetSessionParameter(request, "targetLocation");
	String displayMode     = emxGetSessionParameter(request, "displayMode");
	String pagination      = emxGetSessionParameter(request, "pagination");
	String topActionbar    = emxGetSessionParameter(request, "topActionbar");
	String bottomActionbar = emxGetSessionParameter(request, "bottomActionbar");
	String objectId        = emxGetSessionParameter(request, "objectId");
	String relId           = emxGetSessionParameter(request, "relId");
	String sortColumnName  = emxGetParameter(request, "sortColumnName");
	String sortDirection   = emxGetSessionParameter(request, "sortDirection");
	String tableName       = emxGetSessionParameter(request, "table");
	String inquiry         = emxGetSessionParameter(request, "inquiry");
	String sPage           = emxGetSessionParameter(request, "page");
	String header          = emxGetSessionParameter(request, "header");
	String jsTreeID        = emxGetSessionParameter(request, "jsTreeID");
	String selection       = emxGetSessionParameter(request, "selection");
	String timeStamp       = emxGetSessionParameter(request, "timeStamp");
	String reSortKey       = emxGetParameter(request, "reSortKey");
	String sPFmode         = emxGetSessionParameter(request, "PFmode");
	String sHeaderRepeat   = emxGetSessionParameter(request, "headerRepeat");
	String sRelDirection   = emxGetSessionParameter(request,"RelDirection");
	String sRelationName   = emxGetSessionParameter(request,"RelationName");
	String sWSTableName    = emxGetParameter(request, "WSTable");
	String integrationName = emxGetSessionParameter(request, "integrationName");
	String acceptLanguage  = request.getHeader("Accept-Language");
	String sProgram		   = emxGetSessionParameter(request,"program");
	String sRefresh		   = emxGetSessionParameter(request,"refresh");
	String sTableFilter	   = request.getParameter("TableFilter");
	String sTimeZone       = (String)session.getAttribute("timeZone");

	String errorMessage	   = "";
	String relationship    = emxGetSessionParameter(request, "relationship");//required for where used level filter
	String end			   = emxGetSessionParameter(request, "end");//required for where used level filter

	if(selection == null)
		selection = "multiple";

	if (null == sProgram) sProgram = "";
	// Refresh the Http Session Data Set when requested
	if (null != sRefresh && sRefresh.equalsIgnoreCase("true") && null != sProgram)
	{
		
		String jpoProgram = sProgram.substring(0, sProgram.indexOf(":") );
		String jpoMethod = sProgram.substring(sProgram.indexOf(":")+1 );
		Enumeration enumParamNames = emxGetParameterNames(request);
		HashMap paramMap = (HashMap)session.getAttribute("ParameterList" + timeStamp);
		
		while(enumParamNames.hasMoreElements())
		{
			String paramName = (String) enumParamNames.nextElement();
			String paramValue = null;
			if(request.getMethod().equals("POST"))
			{
				paramValue = (String)emxGetParameter(request, paramName);
			}
			else 
			{
				paramValue = (String)emxGetParameter(request, paramName);
			}
		   
			if (paramValue != null && paramValue.trim().length() > 0 )
				paramMap.put(paramName, paramValue);
		}
		
		paramMap.put("languageStr", request.getHeader("Accept-Language") );
		
		if(integrationName != null && integrationName.length() != 0 && !integrationName.equalsIgnoreCase("null"))
		{
			MCADIntegrationSessionData integSessionData	= (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");			
			MCADGlobalConfigObject globalConfigObject   = integSessionData.getGlobalConfigObject(integrationName,integSessionData.getClonedContext(session));

            HashMap globalConfigObjectTable             = (HashMap)integSessionData.getIntegrationNameGCOTable(integSessionData.getClonedContext(session));					
			paramMap.put("GCOTable", globalConfigObjectTable);
			paramMap.put("GCO", globalConfigObject);		
			paramMap.put("LCO", (Object)integSessionData.getLocalConfigObject());		
		}
		// Put the filter name and value pairs into the paramMap
		String[] intArgs = new String[]{};
		
		if (sTableFilter != null)
		{
		   StringTokenizer filterTokenizer = new StringTokenizer(sTableFilter, "|");
		   while (filterTokenizer.hasMoreTokens())
		   {
			  String token = filterTokenizer.nextToken();
			  if (null == token || 0 == token.length()) continue;
			  int pos = token.indexOf('=');
			  if (pos > 0)
			  {
				 String name = token.substring(0, pos);
				 String value = token.substring(pos+1, token.length());

				 paramMap.put(name, value);
			  }
		   }
		}
		// refresh the HTTP session BusObjList 
		try
		{ 
			ContextUtil.startTransaction(context, false);

			MapList relBusObjList = (MapList)JPO.invoke(context, jpoProgram, intArgs, jpoMethod, JPO.packArgs(paramMap), 		                                MapList.class); 
			session.removeAttribute("BusObjList" + timeStamp);
			session.setAttribute("BusObjList" + timeStamp, relBusObjList); 

			for (int i = 0; i < relBusObjList.size(); i++)
			{
			   Map objDetails = (Map)relBusObjList.get(i);
			   String id = (String)objDetails.get("id");
			   String level = (String)objDetails.get("level");
			}
			
			ContextUtil.commitTransaction(context);
		}
		catch (MatrixException me)
		{
			ContextUtil.abortTransaction(context);
			me.printStackTrace();
		}
	}

	MCADServerResourceBundle serverResourceBundle = new MCADServerResourceBundle(acceptLanguage);
	
	if(sWSTableName == null || "".equals(sWSTableName))
    {
        String funcPageName = emxGetSessionParameter(request, "funcPageName");

		MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData)session.getAttribute("MCADIntegrationSessionDataObject");
	    Context context1                            = integSessionData.getClonedContext(session);
	    MCADMxUtil util                             = new MCADMxUtil(context1, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
        IEFConfigUIUtil iefConfigUIUtil             = new IEFConfigUIUtil(context1,integSessionData, integrationName);
		
        sWSTableName =  integSessionData.getStringResource("mcadIntegration.Server.FieldName.DefaultTableName");
        sWSTableName =  iefConfigUIUtil.getFilteredMatrixTableName(sWSTableName,false);
    }

    String sQueryLimit = emxGetSessionParameter(request,"queryLimit");
	String suiteKey = emxGetSessionParameter(request, "suiteKey");
	String docDetailsPage = "";
	String IsAdminTable = emxGetSessionParameter(request,"IsAdminTable");
	String sFooterRefreshRequired = emxGetSessionParameter(request, "footerRefreshRequired");
	// Get business object list from session
	MapList relBusObjList = (MapList)session.getAttribute("BusObjList" + timeStamp);
	HashMap paramMap      = (HashMap)session.getAttribute("ParameterList" + timeStamp);
	// business object list for current page
	MapList relBusObjPageList = new MapList();
	int noOfItemsPerPage = 0;
	BusinessObject boGeneric                  = null;
	//Initialize all the variables
	String sObjectId        = "";
	String sObjName         = "";
	String sType            = "";
	String sName            = "";
	String sRev             = "";
	String sRowStr          = "";
	boolean bReadAccess     = false;
	int iReadAccess         = 0;
	boolean checkBoxDefined = false;

	String selectType   = new String();
	String selectString = new String();
	Vector vecColList                         = null;
//	SelectList selList                        = null;
//	SelectList selListRels                    = null;
	if (sortDirection == null)
		sortDirection = "ascending";
	if (reSortKey != null && reSortKey.length() > 0)
		sortColumnName = reSortKey;
	if(sortColumnName==null)
    	sortColumnName="name";
// Function FUN080585 : Removal of Cue, Tips and Views
//Extract the column Details of the selected workspace table
try
{
	ContextUtil.startTransaction(context, true);
	//open table ..if the user has deleted the table while on the search results
	//then prompt the user that the table does not exists and show him the table with 
	//single default column
	try
	{
		vecColList = openTable(context,sWSTableName);
	}
	catch(MatrixException ex)
	{
	    if(ex.toString()!=null && (ex.toString().trim()).length()>0)
			errorMessage = ex.toString().trim();	
		
		//to show the table with default column and avoid null pointer exception
		vecColList = new Vector();
	}
//    selListRels = new SelectList();
//    selList = new SelectList();
    // define select values
//    selList.addName();
//    selList.addType();
//    selList.addRevision();
//    selList.addId();
    //Load the table expressions
//	loadTableExpressions(vecColList, selList, selListRels);
	//Form the vector of column build the column Names
	int noOfColumns            = vecColList.size();
	String columnNames[]       = new String[noOfColumns];
	String columnExpressions[] = new String[noOfColumns];
	Boolean columnBOTypes[]    = new Boolean[noOfColumns];
	Enumeration eNumCol        = vecColList.elements();
	int iCount                 = 0;
	Vector vectorTempCol       = null;
	Boolean boType             = null;
	while (eNumCol.hasMoreElements())
	{
		vectorTempCol = (Vector)eNumCol.nextElement();
		columnNames[iCount] = (String)vectorTempCol.elementAt(0);
		columnBOTypes[iCount] = (Boolean)vectorTempCol.elementAt(3);
		columnExpressions[iCount] = (String)vectorTempCol.elementAt(1);
		iCount++;
	}
	Hashtable rowDataTable = null;
	if(columnNames !=null && columnNames.length > 0)
	{
		session.setAttribute("ColHeading" + timeStamp, columnNames);
		rowDataTable = new Hashtable(columnNames.length);
	}

	//Sort the objects based on the sort column choosen
	if (relBusObjList != null && relBusObjList.size() > 0 && vecColList != null && vecColList.size() > 0 )
    {
		
        if (sortColumnName != null && sortColumnName.trim().length() > 0 && (!(sortColumnName.equals("null"))) )
        {
			//no need to decode the name
            //sortColumnName = com.matrixone.apps.domain.util.XSSUtil.decodeFromURL(sortColumnName);

			//Bult a Hash Map to send to the sort objects function
            HashMap sortColumMap = null;
			//incase of Object Link the column is sorted on "TNR" basis
            if( sortColumnName.compareToIgnoreCase("object") == 0 )
			{
				sortColumMap = new HashMap();
				sortColumMap.put("name",sortColumnName);
				sortColumMap.put("expression_businessobject", sortColumnName);
			}
			else
			{
				for( int i=0; i< noOfColumns; i++)
				{
					if (columnNames[i] != null && columnNames[i].equals(sortColumnName) )
					{
						sortColumMap = new HashMap();
						if( columnBOTypes[i].booleanValue() )
						{
							sortColumMap.put("expression_businessobject", columnExpressions[i]);
						}
						else
						{
							sortColumMap.put("expression_relationship",columnExpressions[i]);
						}
						sortColumMap.put("name",columnNames[i]);
						break;
					}
				}
				
			}
            // long time2Check = System.currentTimeMillis();
            // sort the list based on the sort column key	        
            if (sortColumMap != null)
			{
				relBusObjList = sortObjects(context, relBusObjList, sortColumMap, sortDirection, paramMap);
				session.removeAttribute("BusObjList" + timeStamp);
				session.setAttribute("BusObjList" + timeStamp, relBusObjList);
			}


        }
    }

	//See the pagination properties
	if (pagination == null || pagination.trim().length() == 0 || pagination.equals("null") )
	{
	    pagination = UINavigatorUtil.getSystemProperty(application, "emxFramework.PaginationRange");
	    if (pagination == null)
            pagination = "10";
    } else if ( pagination.equals("0") ) {
        pagination = "0";
        displayMode = "singlePage";
    }
    noOfItemsPerPage = Integer.parseInt(pagination);

	if (relBusObjList != null && relBusObjList.size() > 0)
    {
        if (noOfItemsPerPage == 0)
            noOfItemsPerPage = relBusObjList.size();
		
		
		Integer iCurrentIndex = (Integer)session.getAttribute("CurrentIndex" + timeStamp);
        if (null == iCurrentIndex)
        {
           session.setAttribute("CurrentIndex" + timeStamp, new Integer(0));
        }        
        

        int currentIndex = ((Integer)session.getAttribute("CurrentIndex" + timeStamp)).intValue();
		
		if ( sPage == null || sPage.trim().length() == 0 || sPage.equals("null") )
          sPage = "1";
		if ( (sPFmode == null || !sPFmode.equals("true")) && !"current".equals(sPage))
        {
        	if (sPage != null && sPage.equals("next")) {
          		currentIndex += noOfItemsPerPage;
        	} else if (sPage != null && sPage.equals("previous")) {
          		currentIndex -= noOfItemsPerPage;
        	} else if (sPage != null && Integer.parseInt(sPage) >= 1) {
          	int pageNo = Integer.parseInt(sPage);
          		currentIndex = (pageNo - 1) * noOfItemsPerPage;
        	} else {
          		currentIndex = 0;
        	}
        }	

        Integer currentIndexObj = new Integer(currentIndex);
        session.setAttribute("CurrentIndex" + timeStamp, currentIndexObj);

        int lastPageIndex;
        if (displayMode != null && displayMode.compareTo("multiPage") == 0)
        {
            // currentIndex = 0;
            lastPageIndex = currentIndex + noOfItemsPerPage;
        } else if (displayMode != null && displayMode.compareTo("singlePage") == 0)
        {
            currentIndex = 0;
            lastPageIndex = currentIndex + relBusObjList.size();
        } else {
            lastPageIndex = currentIndex + noOfItemsPerPage;
        }

        for (int i = currentIndex; i < lastPageIndex; i++)
        {
            if (i >= relBusObjList.size())
                break;
            relBusObjPageList.add(relBusObjList.get(i));
        }
		if(relBusObjPageList!=null && relBusObjPageList.size() > 0 )
			session.setAttribute("PageBusObjList" + timeStamp, relBusObjPageList);

	} // end of if null check for relBusObjList
// Function FUN080585 : Removal of Cue, Tips and Views
%>

<head>
<title>Table View</title>
<%
if ( sPFmode != null && sPFmode.equals("true") )
{
%>
	<link rel="stylesheet" href="../common/styles/emxUIDefaultPF.css" type="text/css">
	<link rel="stylesheet" href="../common/styles/emxUIListPF.css" type="text/css">
<%
}   else {
%>
	<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css">
	<link rel="stylesheet" href="../common/styles/emxUIList.css" type="text/css">
<%
}
%>

	<%@include file = "emxInfoUIConstantsInclude.inc"%>
	<script language="JavaScript" src="emxInfoUIModal.js" type="text/javascript"></script>
	<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICore.js"></script>
</head>


<body onLoad="removeProgressBar()">
<form name=emxTableForm method="post">

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
//System.out.println("CSRFINJECTION");
%>


<%
	// Show the header if the mode is "PrinterFriendly"
	if ( sPFmode != null && sPFmode.equals("true") )
	{
		header = parseTableHeader(application, context, header, objectId, suiteKey, request.getHeader("Accept-Language"));
		String userName = (new com.matrixone.servlet.FrameworkServlet().getFrameContext(session)).getUser();
		java.util.Date currentDateObj = new java.util.Date(System.currentTimeMillis());
		String currentTime = currentDateObj.toString();

%>
		<hr noshade>
		<table border="0" width="100%" cellspacing="2" cellpadding="4">
		<tr>
		<!--XSSOK-->
        <td class="pageHeader" width="60%"><%=header%></td>
        <td width="1%"><img src="../common/images/utilSpacer.gif" width="1" height="28" alt=""></td>
        <td width="39%" align="right"></td>
        <td nowrap>
            <table>
			<!--XSSOK-->
            <tr><td nowrap=""><%=userName%></td></tr>
			<!--XSSOK-->
            <tr><td nowrap=""><%=currentTime%></td></tr>
            </table>
        </td>
		</tr>
		</table>
		<hr noshade>
<%
	}


	if ( sPFmode != null && sPFmode.equals("true") )
	{
%>
		<table border="0" width="100%">
		<tr>
		<td><img src="../common/images/utilSpacer.gif" border="0" width="5" height="30" alt=""></td>
		</tr>
		</table>
		<table border="0" cellpadding="5" cellspacing="0" width="100%">
<%
	} else {
%>
		<table border="0" cellpadding="3" cellspacing="2" width="100%">
<%
	}
%>
    <tr>
	
<%

	//Based on the sort column choosen display the appropriate image
	String sortImage = "";
    String nextSortDirection = "";
    if (sortDirection.compareTo("ascending") == 0)
    {
        nextSortDirection = "descending";
		sortImage		  = "../common/images/utilSortArrowUp.gif";
    } else {
        nextSortDirection = "ascending";
		sortImage		  = "../common/images/utilSortArrowDown.gif";
    }

    // show Check box or radio only if a checkbox column is not defined explicitly
    if ( !(checkBoxDefined) )
    {
		if ( sPFmode != null && sPFmode.equals("true") )
		{
%>
			<!-- <th></th> -->
<%      } else 
		{
			if (selection.compareTo("single") == 0  )
			{
%>
				<th width="2%">&nbsp;</th>
<%
			} else if (selection.compareTo("multiple") == 0)
			{
%>
				<th width="2%" style="text-align:center"><input type="checkbox" name="chkList" onclick="checkAll()"></th>
<%
			}
		}
	}
	if( sPFmode != null && sPFmode.equals("true") )
	{
%>
		<th width="30%"> <%=i18nStringNowLocal("emxIEFDesignCenter.Common.Object", request.getHeader("Accept-Language"))%> </th>
<%	}
	else //if not in printer friendly mode
	{	 
		//Show sort Icon if the sort column matches with the label
		if( sortColumnName.compareTo("object") == 0 )
		{
%>
			<th width="30%"><table border="0" cellspacing="0" cellpadding="0"><tr><th>
			<a href="javascript:reloadTable('object','<%=XSSUtil.encodeForJavaScript(context,nextSortDirection)%>','true')"> <%=i18nStringNowLocal("emxIEFDesignCenter.Common.Object", request.getHeader("Accept-Language"))%> </a>
			<!--XSSOK-->
			</th><td><img src="<%=sortImage%>" align="absmiddle" border="0" /></td></tr></table>
			</th>
<%	
		}
		else
		{
%>
			<th width="30%">
			<a href="javascript:reloadTable('object','<%=XSSUtil.encodeForJavaScript(context,sortDirection)%>','true')"> <%=i18nStringNowLocal("emxIEFDesignCenter.Common.Object", request.getHeader("Accept-Language"))%> </a>
			</th>
<%  
		}
	}
%>
    
	<!--XSSOK-->
    <%=getFlatTableHeadings(vecColList,request,false,sortDirection, sortColumnName, sPFmode)%>
<%
	if( sPFmode == null || sPFmode.equals("false")){
%>
	<th width="4%"> &nbsp; </th>
<%
	}
%>
	</tr>

<%

   //hard coded in Admin table body too
	int headerRepeatCount = 14;

	if (sHeaderRepeat != null && sHeaderRepeat.trim().length() > 0 && !"null".equalsIgnoreCase(sHeaderRepeat))
		headerRepeatCount = Integer.parseInt(sHeaderRepeat);

	//Iterate through and get the business objects
	for ( int i=0; i< relBusObjPageList.size(); i++ )
	{
		Vector rowData       = null;

		//HashMap elementMap = (HashMap)relBusObjPageList.get(i);
		HashMap elementMap = (HashMap)getHashMap(relBusObjPageList.get(i));
		
		//Extract the object ID and relation ID from the map
        String elementOID = (String)elementMap.get("id");
        String elementRELID = (String)elementMap.get("id[connection]");
		//bReadAccess = !elementOID.equals("#DENIED!");
		if(elementOID.equals("#DENIED!"))
				bReadAccess=false;
		else{
            String access="read";
            BusinessObject bObj = new BusinessObject(elementOID);
         	bReadAccess = FrameworkUtil.hasAccess(context,bObj,access);
		}
		// Get the basics of business object. Name, Revision and Description
		sType =(String)elementMap.get("type");
        sName = (String)elementMap.get("name");
        sRev =(String)elementMap.get("revision");

		if(bReadAccess)
		{
			boGeneric = new BusinessObject(elementOID);
    		boGeneric.open(context);
			if(sType==null)
				sType = boGeneric.getTypeName();
			if(sName==null)
				sName = boGeneric.getName();
			if(sRev==null)
				sRev = boGeneric.getRevision();
            rowData =evaluateTable(elementOID,elementRELID,sWSTableName,vecColList,context);
			boGeneric.close(context);			
		} 
		else
			rowData = new Vector();
   

		//Internationalize the type name
		if(sType!=null)
			sType=sType.trim();
		String orgType  = sType;
        if(sType!=null)
		sType = i18nNow.getMXI18NString(sType, "", request.getHeader("Accept-Language"),"Type");
		sRowStr = "even";
		String checkboxName = "emxTableRowId";
    	String sValue = "";
        if (elementRELID == null || elementRELID.trim().length() == 0)
            sValue = elementOID;
        else
            sValue = elementRELID + "|" + elementOID;

		sObjName = sType+"<br>"+sName+"<br>"+sRev;

        if ((i % 2) == 0) {
          sRowStr = "odd";
        }
	// Function FUN080585 : Removal of Cue, Tips and Views
		//showing the repeat header
		if ( (i != 0) && (headerRepeatCount != 0) && (i % headerRepeatCount == 0) )
		{
%>
			<tr>
<%
			if (selection.compareTo("single") == 0 || selection.compareTo("multiple") == 0)
			{
%>
				<th class="sub" width="5%">&nbsp;</th>
<%
			}
			//Show the default Object Column
			//Show sort Icon if the sort column matches with the label
			if(sortDirection.compareTo("ascending") == 0)
				sortImage = "../common/images/utilSortArrowUp.gif";
			else
				sortImage = "../common/images/utilSortArrowDown.gif";
			
			if( sortColumnName.compareTo("type") == 0 )
			{
%>
				<th class="sub" width="30%"><table border="0" cellspacing="0" cellpadding="0"><tr><th class="sub">
				<%=i18nStringNowLocal("emxIEFDesignCenter.Common.Object", request.getHeader("Accept-Language"))%>
				</th><td>
				<!--XSSOK-->
				<img src="<%=sortImage%>" align="absmiddle" border="0" /></td></tr></table>
				</th>
<%	
			}
			else
			{
%>
				<th class="sub" width="30%">
				<%=i18nStringNowLocal("emxIEFDesignCenter.Common.Object", request.getHeader("Accept-Language"))%>
				</th>
<%			}
			//Show the rest of the column hearders
			for (int k = 0; k < noOfColumns; k++)
			{
       			String sColumName = columnNames[k];
				if (sortColumnName == null || (sortColumnName.compareTo(sColumName) != 0))
				{
%>					<th class="sub"><%=columnNames[k]%><%

				}
				else
				{
%>					<th class="subSorted"> <%
					

%>					<%=columnNames[k]%>
					<img src="<%=sortImage%>" align="absmiddle" border="0" />
<%
				}
%>				</th><%
			}
			//show the column for pop up window icon
			if( sPFmode == null || sPFmode.equals("false")){
%>
			<th class="sub" width="4%"> &nbsp; </th>
<%
			}
%>
			</tr>

<%		} //repeat header ends Here

%>		
        <!--XSSOK-->
        <tr class="<%=sRowStr%>">
			
<%		// Show default Check box column, only if a checkbox column is explicitly not defined
		if ( !(checkBoxDefined) )
		{
			if ( sPFmode != null && sPFmode.equals("true") )
			{
%>
			   <!-- <th></th> -->
<%		    } else 
			{
				if(!elementOID.equals(objectId)&& bReadAccess){			
	            
					if (selection.compareTo("multiple") == 0) {
%>
                    <!--XSSOK-->
					<td style="text-align: center"><input type="checkbox" name="<%=checkboxName%>" value="<%=sValue%>" onclick="doCheckboxClick(this);doSelectAllCheck(this)" ></td>
<%
					} else if (selection.compareTo("single") == 0) {
%>
                    <!--XSSOK-->
					<td style="text-align: center"><input type="radio" name="<%=checkboxName%>" value="<%=sValue%>" onclick="doCheckboxClick(this)"></td>
<%
					}
				}
				else{
%>
				<td style="text-align: center"><img src="images/iconCheckoffdisabled.gif" ></td>
<%
				}
			}
		}
		//get the image defined for this type
		String objectIcon = new String();
		objectIcon = UINavigatorUtil.getTypeIconProperty(context, application, orgType);
        if (objectIcon == null || objectIcon.length() == 0 )
            objectIcon = "../common/images/iconSmallDefault.gif";
        else
            objectIcon = "../common/images/" + objectIcon;

		//Set the window properties
        String menuName = getINFMenuName( request, context, elementOID);
		String colItemHref = "../common/emxTree.jsp?AppendParameters=true&objectId=" + elementOID + "&treeMenu=" + menuName;
		//These values are hard coded as there is no way for the user to set these values
		String windowWidth= "700";
        String windowHeight= "600";
		String popupModal = "false";
		String targetLocations = "content";
		
		String sCellClass = "listCell";

		if ( sPFmode != null && sPFmode.equals("true") )
		{
			//Do not show hyper links
                        // Function FUN080585 : Removal of Cue, Tips and Views
			sCellClass = "listCell";
                       // Function FUN080585 : Removal of Cue, Tips and Views
%>
            <!--XSSOK-->
			<td class="<%=sCellClass%>" >
				<table>
					<tr>
						<td>
						    <!--XSSOK-->
							<img border="0" src="<%=objectIcon%>">
						</td>
						<td>
						    <!--XSSOK-->
							<%=sObjName%>
						</td>
					</tr>
				</table>
			</td>
			<!--XSSOK-->
			<%=loadFlatTableValues(vecColList, rowData,request,sCellClass,elementMap,context,sPFmode,bReadAccess)%>
<%
		}else
		{
                        // Function FUN080585 : Removal of Cue, Tips and Views
			sCellClass = "object";
                       // Function FUN080585 : Removal of Cue, Tips and Views
	    	if(bReadAccess){		
%>			
			<td>
				<table>
					<tr>
						<td>
						    <!--XSSOK-->
							<a href="javascript:emxTableColumnLinkClick('<%=colItemHref%>','<%=windowWidth%>', '<%=windowHeight%>', '<%=popupModal%>', '<%=targetLocations%>' )"> <img border="0" src="<%=objectIcon%>" class="<%=sCellClass%>""></a>
						</td>
						<td>
						    <!--XSSOK-->
							<a href="javascript:emxTableColumnLinkClick('<%=colItemHref%>','<%=windowWidth%>', '<%=windowHeight%>', '<%=popupModal%>', '<%=targetLocations%>' )" class=<%=sCellClass%>>
							<!--XSSOK-->
							<%=sObjName%></a>
						</td>
					</tr>
				</table> 
			</a></td>
<%
                                // Function FUN080585 : Removal of Cue, Tips and Views
				sCellClass = "none";
                               // Function FUN080585 : Removal of Cue, Tips and Views
%>
            <!--XSSOK-->
			<%=loadFlatTableValues(vecColList, rowData,request,sCellClass,elementMap,context,sPFmode,bReadAccess)%>

<%		}
        
		else{
%>
        <!--XSSOK-->
		<td class=<%=sCellClass%>" >
				<table>
					<tr>
						<td>
						    <!--XSSOK-->
							<img border="0" src="<%=objectIcon%>"" >
						</td>
						<td>
						    <!--XSSOK-->
							<%=sObjName%>
						</td>
					</tr>
				</table>
		</td>
		    <!--XSSOK-->
			<%=loadFlatTableValues(vecColList, rowData,request,sCellClass,elementMap,context,sPFmode,bReadAccess)%>
<%
		}
		}
%>
		</tr>
<%	
	String keyName ="";
	if (elementRELID == null || elementRELID.trim().length() == 0 || elementRELID.equals("null"))
		keyName = elementOID;
	else
		keyName = elementOID + "|" + elementRELID;

	if(rowDataTable!=null)
		rowDataTable.put(keyName,rowData);

	} //end for
	if(rowDataTable!=null)
		session.setAttribute("DataTable"+ timeStamp, rowDataTable);

%>
</table>

<%
//~~~~~~~~~Set this Workspace Table to active mode~~~~~~~~~~~~~~
	if(sWSTableName.indexOf("::") == -1){
		MQLCommand mqlCmd = new MQLCommand();
		String sCommand = "";
		mqlCmd.open(context);
		mqlCmd.executeCommand(context, "modify table $1 $2",sWSTableName.trim(),"active");
		mqlCmd.close(context);
	}
//~~~~~~~~~~~~~~~~~~~~~~~End~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ContextUtil.commitTransaction(context);

//Catch the Exception and do the cleanup
} catch (Exception ex) {
    ContextUtil.abortTransaction(context);

    if(ex.toString()!=null && (ex.toString().trim()).length()>0)
        errorMessage = ex.toString().trim();

}
%>

<input type="hidden" name="timeStamp" value="<xss:encodeForHTMLAttribute><%=timeStamp%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="sRelationName" value="<xss:encodeForHTMLAttribute><%=emxGetSessionParameter(request,"sRelationName")%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="selection" value="<xss:encodeForHTMLAttribute><%=selection%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="pagination" value="<xss:encodeForHTMLAttribute><%=noOfItemsPerPage%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="list" value="<xss:encodeForHTMLAttribute><%=inquiry%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="sortColumnName" value="<xss:encodeForHTMLAttribute><%=sortColumnName%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="reSortKey" value="<xss:encodeForHTMLAttribute><%=sortColumnName%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="table" value="<xss:encodeForHTMLAttribute><%=tableName%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="sortDirection" value="<xss:encodeForHTMLAttribute><%=sortDirection%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="page" value="<xss:encodeForHTMLAttribute><%=sPage%></xss:encodeForHTMLAttribute>">
<!--XSSOK-->
<input type="hidden" name="header" value="<%=header%>">
<input type="hidden" name="objectId" value="<xss:encodeForHTMLAttribute><%=objectId%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="relId" value="<xss:encodeForHTMLAttribute><%=relId%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="jsTreeID" value="<xss:encodeForHTMLAttribute><%=jsTreeID%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="displayMode" value="<xss:encodeForHTMLAttribute><%=displayMode%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="topActionbar" value="<xss:encodeForHTMLAttribute><%=topActionbar%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="bottomActionbar" value="<xss:encodeForHTMLAttribute><%=bottomActionbar%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="headerRepeat" value="<xss:encodeForHTMLAttribute><%=sHeaderRepeat%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="parentOID" value="<xss:encodeForHTMLAttribute><%=objectId%></xss:encodeForHTMLAttribute>">
<!--XSSOK-->
<input type="hidden" name="WSTable" value="<%=sWSTableName%>">
<input type="hidden" name="RelDirection" value="<xss:encodeForHTMLAttribute><%=sRelDirection%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="RelationName" value="<xss:encodeForHTMLAttribute><%=sRelationName%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="targetLocation" value="<xss:encodeForHTMLAttribute><%=sTarget%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="queryLimit" value="<xss:encodeForHTMLAttribute><%=sQueryLimit%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="suitKey" value="<xss:encodeForHTMLAttribute><%=suiteKey%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="displayMode" value="<xss:encodeForHTMLAttribute><%=displayMode%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="IsAdminTable" value="<xss:encodeForHTMLAttribute><%=IsAdminTable%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="integrationName" value="<xss:encodeForHTMLAttribute><%=integrationName%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="tableFilter" value="">
<input type="hidden" name="relationship" value="<xss:encodeForHTMLAttribute><%=relationship%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="end" value="<xss:encodeForHTMLAttribute><%=end%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="timeZone" value="<xss:encodeForHTMLAttribute><%=sTimeZone%></xss:encodeForHTMLAttribute>">

<!-- added by bhargav-->
<input type="hidden" name="setName" value="<xss:encodeForHTMLAttribute><%=setName%></xss:encodeForHTMLAttribute>">


</form>
<script language="JavaScript">

//XSSOK
if("<%=sFooterRefreshRequired%>" == null || !<%="false".equals(sFooterRefreshRequired)%>)
{
	if (document.emxTableForm)
	{
		var actBarUrl = "emxInfoTableFooter.jsp?displayMode=" + "<%=XSSUtil.encodeForURL(context,displayMode)%>";
		//&RelDirection=<%=sRelDirection%>&RelationName=<%=sRelationName%>";
		document.emxTableForm.action = actBarUrl;
		document.emxTableForm.target = "listFoot";
		document.emxTableForm.submit();
	}
}
	if(parent.frames[0].document.imgProgress)
	{
		parent.frames[0].document.imgProgress.src = "../common/images/utilSpacer.gif";
	}

</script>
<%
	if (!"".equals(errorMessage.trim()))
	{
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

<div id="tooltip" style="position:absolute; visibility:hidden;  z-index:1000"></div>
</body>

<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>

</html>
