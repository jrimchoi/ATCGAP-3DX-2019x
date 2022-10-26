<%--  emxInfoNavigateHeader.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoNavigateHeader.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoNavigateHeader.jsp $
 * 
 * *****************  Version 38  *****************
 * User: Rahulp       Date: 4/02/03    Time: 16:37
 * Updated in $/InfoCentral/src/infocentral
 * 
 * ***********************************************
 *
--%>

<html>


<%@include file= "../common/emxNavigatorInclude.inc"%>
<%@include file= "emxInfoTableInclude.inc"%>
<%@include file= "emxInfoTreeTableUtil.inc"%>
<%@include file= "../common/emxNavigatorTopErrorInclude.inc"%>
<%@ page import = "com.matrixone.MCADIntegration.uicomponents.util.*"%>
<%@ page import="java.util.*,java.io.*, java.net.*,com.matrixone.MCADIntegration.server.*,com.matrixone.MCADIntegration.server.beans.*, com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.utils.customTable.*"  %>
<%@ page import = "matrix.db.*, matrix.util.*,com.matrixone.servlet.*,com.matrixone.apps.framework.ui.*,com.matrixone.apps.domain.util.*, com.matrixone.apps.domain.*"%>
<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<script language="JavaScript" src="emxInfoUIModal.js"></script> 
<script language="JavaScript" src="emxInfoCentralJavaScriptUtils.js"></script>
<script language="Javascript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
<!--// Function FUN080585 : Removal of Cue, Tips and Views-->
<%!
    /*
    // return the Querystring of request
    // This method is used here because There is one more method available in 
    // file "../emxRequestWrapperMethods.inc" which is included in file "../common/emxNavigatorInclude.inc". 
    // To not to use that function this function is defined here 
    */
    static public String emxGetQueryStringNav(HttpServletRequest request)
    {
		String queryString = "";
		Enumeration enumParamNames = emxGetParameterNames(request);
		while(enumParamNames.hasMoreElements()) {
		  String paramName=(String) enumParamNames.nextElement();
		  String paramValue="";
		  paramValue = (String)emxGetParameter(request, paramName);
		  queryString+=paramName+"="+paramValue+"&";
        }
        if((null != queryString) && !("null".equalsIgnoreCase(queryString)) && (queryString.trim().length() != 0))
        	queryString=queryString.substring(0,queryString.length()-1);
        else
        	queryString = "";
        return queryString;
    }
%>


<%

	//Get the request parameters
    String tableForDefault      = "";
    String sHeader			    = emxGetParameter(request, "header");
    String objectId				= emxGetParameter(request, "objectId");
    String sHelpMarker			= emxGetParameter(request, "HelpMarker");
    String suiteKey				= emxGetParameter(request, "suiteKey");
    String tipPage				= emxGetParameter(request, "TipPage");
    String printerFriendly		= emxGetParameter(request, "PrinterFriendly");
    String sTableName		    = emxGetParameter(request, "WSTable");
    String sWorkSpaceFilterName = emxGetParameter(request, "WSFilter");
	String sTimeStamp			= emxGetParameter(request, "TimeStamp");
	String sAdminTableName      = emxGetParameter(request, "table");
    String toFrom				= emxGetParameter(request,"toFrom");
    String RelationshipName		= emxGetParameter(request,"RelationshipName");
	String funcPageName         = emxGetParameter(request,"funcPageName");
	String tableName            = emxGetParameter(request,"tableName"); 
	String integrationName		= emxGetParameter(request,"integrationName");
	String portalMode			= emxGetParameter(request, "portalMode");

	if(portalMode == null || portalMode.equals("") || !portalMode.equalsIgnoreCase("true"))
		portalMode = "false";

	if(tableName != null)
        tableName = MCADUrlUtil.hexDecode(tableName);

	MCADIntegrationSessionData integSessionData	= (MCADIntegrationSessionData) session.getAttribute(MCADServerSettings.MCAD_INTEGRATION_SESSION_DATA_OBJECT);

	Context context1                            = integSessionData.getClonedContext(session);
	MCADMxUtil util                             = new MCADMxUtil(context1, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
	IEFConfigUIUtil iefConfigUIUtil             = new IEFConfigUIUtil(context1, integSessionData, integrationName);

    String defaultTableName = integSessionData.getStringResource("mcadIntegration.Server.FieldName.DefaultTableName");
	if(tableName!= null)
	{
		if(!tableName.equals(defaultTableName))
        {
            boolean isAdminTable = iefConfigUIUtil.isSystemTable(context1, tableName);
		    String selTable      = iefConfigUIUtil.getFilteredMatrixTableName(tableName,isAdminTable);
		    tableForDefault      = selTable;
        }
        else
        {
            tableForDefault = "DSCNavigate";
        }
		
	}
	else
	{
        tableName       = defaultTableName;
		tableForDefault = "DSCNavigate";
	}	

	if(toFrom==null )
		toFrom="*";
    String tochecked="";
    String fromchecked="";
    
	if(toFrom.equals("to"))
	{
      tochecked="checked";
	}
    
	if(toFrom.equals("from"))
	{
      fromchecked="checked";
	}
    
	if(toFrom.equals("*"))
    { 
      tochecked="checked";
      fromchecked="checked";
    }

	String header = sHeader;
	if (sHeader != null)
        header = parseTableHeader(application, context, sHeader, objectId, suiteKey, request.getHeader("Accept-Language"));

	//These things are used for help markers
    String suiteDir = "";
    String registeredSuite = "";

    if ( suiteKey != null && suiteKey.startsWith("eServiceSuite") )
    {
        registeredSuite = suiteKey.substring(13);

        if ( (registeredSuite != null) && (registeredSuite.trim().length() > 0 ) )
            suiteDir = UINavigatorUtil.getRegisteredDirectory(application, registeredSuite);
    }

	BusinessType btConnObj = null;
	String sRevision = "";
	String sType = "";
	String sName = "";
	try
	{
		//Create a business object from the object ID
		BusinessObject  boObject  = null;
		boObject  = new BusinessObject(objectId);
		boObject.open(context);
		
		//Get the business Type ..used later to get the relationship types
		btConnObj  = boObject.getBusinessType(context);
		
		//get the type, name , revision to append them to the header
		sRevision = boObject.getRevision();
		sType = boObject.getTypeName();
		sName = boObject.getName();

		boObject.close(context);

	}
	catch( MatrixException ex )
	{
		if(ex.toString()!=null && (ex.toString().trim()).length()>0)
			emxNavErrorObject.addMessage(ex.toString().trim());
	}

	//append TNR to header
	String sRevText = i18nStringNowLocal("emxIEFDesignCenter.Common.Rev", request.getHeader("Accept-Language"));
	header = sType+"  "+sName + "  " + sRevText + " " + sRevision + ":" + header;
%>

<head>
	<title>Navigator</title>

	<%@include file = "emxInfoUIConstantsInclude.inc"%>
	<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICore.js"></script>
    <script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICoreMenu.js"></script>
    <script language="JavaScript" type="text/javascript" src="../common/scripts/emxUIToolbar.js"></script>
	<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUIConstants.js"></script>
		<%@include file = "../emxStyleDefaultInclude.inc"%>
	<script language="JavaScript" type="text/javascript">
            addStyleSheet("emxUIToolbar");
            addStyleSheet("emxUIMenu");
    </script>
    	
  	<link rel="stylesheet" type="text/css" href="../common/styles/emxUIDefault.css" />
	<link rel="stylesheet" type="text/css" href="../common/styles/emxUIList.css" />		

	<script language="javascript" type="text/javascript" src="emxInfoUIModal.js"></script>
	<script language="javascript" type="text/javascript" src="../integrations/scripts/IEFHelpInclude.js"></script>
	<script language="JavaScript" src="../integrations/scripts/MCADUtilMethods.js"></script>
	<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>

</head>

<body>

<form name="tableHeaderForm" method="post">

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
//System.out.println("CSRFINJECTION::emxInfoNavigateHeader.jsp");
%>

	<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td ><img src="../common/images/utilSpacer.gif" width="1" height="5" alt=""></td>
	</tr>
	</table>

	<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
	<td class="pageBorder"><img src="../common/images/utilSpacer.gif" width="1" height="1" alt=""></td>
	</tr>
	</table>
	<!-- change start for enable progress animation on 16/2/2004 by nagesh-->
	<table border="0" width="100%" cellspacing="0" cellpadding="2">
	<tr>
	    <!--XSSOK-->
		<td class="pageHeader" width="1%" nowrap><%=header%></td>
		<td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img name="progress" src="../common/images/utilProgressDialog.gif" width="34" height="28"  ></td>
	</tr>
	</table>
	<!-- change end on 16/2/2004-->
	<table border="0" cellspacing="0" cellpadding="0" width="100%">
		<tr>
		<td class="pageBorder"><img src="../common/images/utilSpacer.gif" width="1" height="1" alt=""></td>
		</tr>
	</table>
	<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td ><img src="../common/images/utilSpacer.gif" width="1" height="5" alt=""></td>
	</tr>
	</table>

    <table class="formBG" width="100%" cellpadding="3" cellspacing="2" border="0">
    <tr >
    <td align="left" class="filter" nowrap>
	<%=i18nStringNowLocal("emxIEFDesignCenter.Common.Views", request.getHeader("Accept-Language"))%>
	&nbsp;<select name="workSpaceTable" onChange="onChangeWSTable()">
<%

try
{
    //read the default table list, and look this table up
    //FUN080585: Removal of deprecated function getDefaultVisuals
    //Visuals visualsDefault = null;//context.getDefaultVisuals();
    //Vector allTables    = iefConfigUIUtil.getAdminAndWorkspaceTableNamesWithPrefix(context1, integSessionData);
	
	Vector allTables = new Vector();

	if(null != integrationName && !integrationName.equals("") && !integrationName.equals("null"))
		allTables = iefConfigUIUtil.getAdminAndWorkspaceTableNamesWithPrefix(context1, integrationName, integSessionData);
	else
	{
		allTables.addAll(iefConfigUIUtil.getWorkspaceTableNamesWithPrefix(context1));
		allTables.addElement("Default");
	}

    String tableNameStr           = "";
	String tableNameStrWithPrefix = "";
	String isSelected             = "";	
	boolean isSystemTable         = true;    

	for(int i=0; i < allTables.size(); i++)
	{
		tableNameStrWithPrefix = (String)allTables.elementAt(i);
		if(defaultTableName.equals(tableNameStrWithPrefix))
			tableNameStr = defaultTableName;
		else
		{
			isSystemTable = iefConfigUIUtil.isSystemTable(context, tableNameStrWithPrefix);
			tableNameStr = iefConfigUIUtil.getFilteredMatrixTableName(tableNameStrWithPrefix,isSystemTable);
		}
        
		isSelected = "";
	
		if (tableNameStr.equals(tableName))
        {
			isSelected = "selected";
        }
		  
		  String hexEncodedTableName = MCADUrlUtil.hexEncode(tableNameStr);
%>
           <!--XSSOK-->
           <option ID="<%=hexEncodedTableName%>" value= "<%=tableNameStr%>"<%=isSelected%>><%=tableNameStrWithPrefix%></option>
<%
        }	
%>
	</select>
<!--// Function FUN080585 : Removal of Cue, Tips and Views-->
    </td>
    <!--XSSOK-->
	<td><input type="checkbox" name="toDirection"  <%=tochecked%> >
    &nbsp;<%=i18nStringNowLocal("emxIEFDesignCenter.Common.To", request.getHeader("Accept-Language"))%></td>
	<!--XSSOK-->
    <td><input type="checkbox" name="fromDirection"  <%=fromchecked%> >
    &nbsp;<%=i18nStringNowLocal("emxIEFDesignCenter.Common.From", request.getHeader("Accept-Language"))%></td>

	<td><a href="javascript:onChangeRelationFilter()" ><img src="images/iconFilter.gif" border="0" title="<%=i18nStringNowLocal("emxIEFDesignCenter.Common.Refresh", request.getHeader("Accept-Language"))%>"></a>
	<a href="javascript:onChangeRelationFilter()" ><%=i18nStringNowLocal("emxIEFDesignCenter.Common.Refresh", request.getHeader("Accept-Language"))%></a></td>
<!--// Function FUN080585 : Removal of Cue, Tips and Views-->
</tr>
</table>
</td>

<%
String sActionBarName = "DSCNavigateTopActionBarActions";
%>

<tr><td
<!-- Use this code to enable AEF style toolbar -->
<jsp:include page = "../common/emxToolbar.jsp" flush="true">
	<jsp:param name="toolbar" value="<xss:encodeForHTMLAttribute><%=sActionBarName%></xss:encodeForHTMLAttribute>"/>
	<jsp:param name="objectId" value="<xss:encodeForHTMLAttribute><%=objectId%></xss:encodeForHTMLAttribute>"/>
	<jsp:param name="parentOID" value="<xss:encodeForHTMLAttribute><%=objectId%></xss:encodeForHTMLAttribute>"/>
	<jsp:param name="timeStamp" value="<xss:encodeForHTMLAttribute><%=sTimeStamp%></xss:encodeForHTMLAttribute>"/>
	<jsp:param name="header" value="<xss:encodeForHTMLAttribute><%=header%></xss:encodeForHTMLAttribute>"/>
	<jsp:param name="PrinterFriendly" value="<xss:encodeForHTMLAttribute><%=printerFriendly%></xss:encodeForHTMLAttribute>"/>
	<jsp:param name="helpMarker" value="<xss:encodeForHTMLAttribute><%=sHelpMarker%></xss:encodeForHTMLAttribute>"/>
	<jsp:param name="suiteKey" value="<xss:encodeForHTMLAttribute><%=suiteKey%></xss:encodeForHTMLAttribute>"/>
	<jsp:param name="tipPage" value="<xss:encodeForHTMLAttribute><%=tipPage%></xss:encodeForHTMLAttribute>"/>
	<jsp:param name="export" value="false"/>
	<jsp:param name="portalMode" value="<xss:encodeForHTMLAttribute><%=portalMode%></xss:encodeForHTMLAttribute>"/>
</jsp:include> 
</td></tr>

	<table border="0" cellspacing="0" cellpadding="0" width="100%">
		<tr>
		<td class="pageBorder"><img src="../common/images/utilSpacer.gif" width="1" height="1" alt=""></td>
		</tr>
	</table>
	<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td ><img src="../common/images/utilSpacer.gif" width="1" height="5" alt=""></td>
	</tr>
	</table>
<%	

}
catch( MatrixException ex )
{
	if(ex.toString()!=null && (ex.toString().trim()).length()>0)
		emxNavErrorObject.addMessage(ex.toString().trim());
}

%>
    </tr>
    </table>

<!-- Form Hidden variables ....used for form posting -->
<input type="hidden" name="header" value="<xss:encodeForHTMLAttribute><%=sHeader%></xss:encodeForHTMLAttribute>"> 
<input type="hidden" name="objectId" value="<xss:encodeForHTMLAttribute><%=objectId%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="HelpMarker" value="<xss:encodeForHTMLAttribute><%=sHelpMarker%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="suiteKey" value="<xss:encodeForHTMLAttribute><%=suiteKey%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="TipPage" value="<xss:encodeForHTMLAttribute><%=tipPage%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="PrinterFriendly" value="<xss:encodeForHTMLAttribute><%=printerFriendly%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="WSTable" value="<xss:encodeForHTMLAttribute><%=sTableName%></xss:encodeForHTMLAttribute>"> 
<input type="hidden" name="WSFilter" value="<xss:encodeForHTMLAttribute><%=sWorkSpaceFilterName%></xss:encodeForHTMLAttribute>">
<!--XSSOK-->
<input type="hidden" name="toFrom" value="<%=toFrom%>">
<input type="hidden" name="table" value="<xss:encodeForHTMLAttribute><%=sAdminTableName%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="TableName" value="">
<input type="hidden" name="reSortKey" value="">
<input type="hidden" name="activeFrame" value="">
</form>

<script language="javascript">

	// Function to refresh on any actions in the filter bar
	//this function is kept in the same file as request.getQueryString does not work in a JS file
	function onChangeRelationFilter()
	{
		//get the relationship selected & the directions
		var varToFilter = document.tableHeaderForm.toDirection.checked;
		var varFromFilter = document.tableHeaderForm.fromDirection.checked;

		var varWSTableName = document.tableHeaderForm.workSpaceTable.options[document.tableHeaderForm.workSpaceTable.selectedIndex].value;

		var varToFrom = "*";
		if( varToFilter && varFromFilter )
		{
			varToFrom = "*";
		}
		else if( varToFilter )
		{
			varToFrom = "to";
		}
		else if( varFromFilter ) 
		{
			varToFrom = "from";
		}

		//set the form variables
		document.tableHeaderForm.toFrom.value = varToFrom;
		document.tableHeaderForm.WSTable.value = varWSTableName;
       	var varWSFilterName ="";
	    if(document.tableHeaderForm.workSpaceFilter)	
		varWSFilterName= document.tableHeaderForm.workSpaceFilter.options[document.tableHeaderForm.workSpaceFilter.selectedIndex].value;

		document.tableHeaderForm.WSFilter.value = varWSFilterName;
		var arrBackId = parent.tree.backId;
		
        var strBackIds = "";
        
        for(var i = 0; i < (arrBackId.length-1);i++)
        {
            strBackIds += arrBackId[i] + "|";
        }
        if(arrBackId.length > 0)
            strBackIds += arrBackId[i];

		//Id is hexencoded for the corresponding table name
		var tableName = document.tableHeaderForm.workSpaceTable.options[document.tableHeaderForm.workSpaceTable.selectedIndex].id;

		//XSSOK
		var integName = "<%= integrationName%>";

		document.tableHeaderForm.TableName.value = tableName;
        
		//Resort column type is hard coded to "name" for WS tables
        newPageURL = "emxInfoNavigateFS.jsp?reSortKey=name&portalMode=<%=XSSUtil.encodeForURL(context,portalMode)%>&backId=" + strBackIds;
		newPageURL += "&AllRelations=true";
		if(document.tableHeaderForm.workSpaceTable.selectedIndex == 0)
			newPageURL += "&IsDefaultTable=true";
		if(document.tableHeaderForm.workSpaceFilter && document.tableHeaderForm.workSpaceFilter.selectedIndex == 0)
			newPageURL += "&IsDefaultFilter=true";
		document.tableHeaderForm.action = newPageURL;
		document.tableHeaderForm.target = "_parent";
        document.tableHeaderForm.submit();

		return;
	}
	function onChangeWSFilter()
	{
		//get the choosen filter name
		
		var varWSFilterName ="";
	    if(document.tableHeaderForm.workSpaceFilter)	
		varWSFilterName= document.tableHeaderForm.workSpaceFilter.options[document.tableHeaderForm.workSpaceFilter.selectedIndex].value;
		var varWSTableName = document.tableHeaderForm.workSpaceTable.options[document.tableHeaderForm.workSpaceTable.selectedIndex].value;
		document.tableHeaderForm.WSTable.value = varWSTableName;
		document.tableHeaderForm.WSFilter.value = varWSFilterName;
		//remove the value in the choosesn relationship
		var varToFilter = document.tableHeaderForm.toDirection.checked;
		var varFromFilter = document.tableHeaderForm.fromDirection.checked;
		var varToFrom = "*";
		if( varToFilter && varFromFilter )
		{
			varToFrom = "*";
		}
		else if( varToFilter )
		{
			varToFrom = "to";
		}
		else if( varFromFilter ) 
		{
			varToFrom = "from";
		}
		
		document.tableHeaderForm.toFrom.value = varToFrom;

		var newPageURL = "";
        var arrBackId = parent.tree.backId;
        
        var strBackIds = "";
        
        for(var i = 0; i < (arrBackId.length-1);i++)
        {
            strBackIds += arrBackId[i] + "|";
        }
        if(arrBackId.length > 0)
            strBackIds += arrBackId[i];
		
		var tableName = document.tableHeaderForm.workSpaceTable.options[document.tableHeaderForm.workSpaceTable.selectedIndex].id;

		document.tableHeaderForm.TableName.value	= tableName;
		
		//Resort column type is hard coded to "name" for WS tables
        newPageURL = "emxInfoNavigateFS.jsp?reSortKey=name&portalMode=<%=XSSUtil.encodeForURL(context,portalMode)%>&backId=" + strBackIds;
		//if none is choosen just return from here
		if( document.tableHeaderForm.workSpaceFilter && document.tableHeaderForm.workSpaceFilter.selectedIndex == 0)
			newPageURL += "&IsDefaultFilter=true";
		else
			newPageURL += "&IsDefaultFilter=false";
		//append the default table flag        
		if( document.tableHeaderForm.workSpaceTable.selectedIndex == 0)
			newPageURL += "&IsDefaultTable=true"
		//if(document.tableHeaderForm.RelationshipName.selectedIndex == 0)
			newPageURL += "&AllRelations=true";
		document.tableHeaderForm.action = newPageURL;
		document.tableHeaderForm.target = "_parent";
        document.tableHeaderForm.submit();
		return;
	}

	//Reload the the table on change of WS Table.
	//this function has to be here as request.getQueryString does not work in a .js file
    function onChangeWSTable() 
    {
		//Update only the table body when the selection changes
        var newTable = document.tableHeaderForm.workSpaceTable.options[document.tableHeaderForm.workSpaceTable.selectedIndex].value;

		//Update the table name with the jstree
		parent.tree.tableName = newTable;
		var arrBackId = parent.tree.backId;
		
        var strBackIds = "";
        
        for(var i = 0; i < (arrBackId.length-1);i++)
        {
            strBackIds += arrBackId[i] + "|";
        }
        if(arrBackId.length > 0)
            strBackIds += arrBackId[i];
        
		var varToFilter = document.tableHeaderForm.toDirection.checked;
		var varFromFilter = document.tableHeaderForm.fromDirection.checked;
		var varToFrom = "*";
		if( varToFilter && varFromFilter )
		{
			varToFrom = "*";
		}
		else if( varToFilter )
		{
			varToFrom = "to";
		}
		else if( varFromFilter ) 
		{
			varToFrom = "from";
		}
		
		document.tableHeaderForm.toFrom.value = varToFrom;
        var newPageURL = "emxInfoNavigateFS.jsp?reSortKey=name&portalMode=<%=XSSUtil.encodeForURL(context,portalMode)%>&backId=" + strBackIds;
		//if(document.tableHeaderForm.RelationshipName.selectedIndex == 0)
			newPageURL += "&AllRelations=true";
		if(document.tableHeaderForm.workSpaceTable.selectedIndex == 0)
			newPageURL += "&IsDefaultTable=true";

		var TableName  = document.tableHeaderForm.workSpaceTable.options[document.tableHeaderForm.workSpaceTable.selectedIndex].text;
		var tableValue = document.tableHeaderForm.workSpaceTable.options[document.tableHeaderForm.workSpaceTable.selectedIndex].value;

		if(TableName.indexOf(tableValue) == -1 && document.tableHeaderForm.workSpaceTable.selectedIndex != 0)
		{
			TableName = TableName.substring(0, TableName.indexOf(':') + 1) + tableValue;
		}
		
		if( document.tableHeaderForm.workSpaceFilter && document.tableHeaderForm.workSpaceFilter.selectedIndex == 0)
			newPageURL += "&IsDefaultFilter=true";
		document.tableHeaderForm.WSTable.value		=  newTable;
		document.tableHeaderForm.action				= newPageURL;
		document.tableHeaderForm.target				= "_parent";

		TableName     = document.tableHeaderForm.workSpaceTable.options[document.tableHeaderForm.workSpaceTable.selectedIndex].id;

		document.tableHeaderForm.TableName.value	= TableName;
        document.tableHeaderForm.submit();

		return;
    }
	//Function to Navigate to the currently selected Node
	function navigateThere()
	{
		//get the currently selected ID
		var objectId = parent.selectedNodeBOId;
		
		//weird but to make it work on both weblogic & websphere
		if( objectId && objectId != null && objectId != "null")
		{
			//store the current root ID as back ID
            var thereId = parent.tree.root.id;
            var arrBackId = parent.tree.backId;
			var strBackIds = "";
            for(var i = 0; i < (arrBackId.length-1);i++)
            {
                strBackIds += arrBackId[i] + "|";
            }
            if(arrBackId.length > 0)
                strBackIds += arrBackId[arrBackId.length-1] + "|" + thereId;
            else
                strBackIds += thereId;
            
			document.tableHeaderForm.objectId.value = objectId;
			var newPageURL = "";
            newPageURL = "emxInfoNavigateFS.jsp?backId=" + strBackIds+ "&objectId=" + objectId + "&portalMode=<%=XSSUtil.encodeForURL(context,portalMode)%>";
			//append the default table flag        
			if( document.tableHeaderForm.workSpaceTable.selectedIndex == 0)
				newPageURL += "&IsDefaultTable=true";
				
			//Resort column type is hard coded to "name" for WS tables
			newPageURL += "&reSortKey=name";

			//if(document.tableHeaderForm.RelationshipName.selectedIndex == 0)
				newPageURL += "&AllRelations=true";
			document.tableHeaderForm.action = newPageURL;


			var varToFilter = document.tableHeaderForm.toDirection.checked;
			var varFromFilter = document.tableHeaderForm.fromDirection.checked;
			var varToFrom = "*";
			if( varToFilter && varFromFilter )
			{
				varToFrom = "*";
			}
			else if( varToFilter )
			{
				varToFrom = "to";
			}
			else if( varFromFilter ) 
			{
				varToFrom = "from";
			}
			//set the form variables
			document.tableHeaderForm.toFrom.value = varToFrom;
			document.tableHeaderForm.target = "_parent";
			document.tableHeaderForm.submit();
		}
	}

	//Function to go back to the previous Navigator Page
	function navigateBack()
	{
		//get the back ID
		var objectId = parent.tree.backId.pop();
        var arrBackId = parent.tree.backId;
        
        var strBackIds = "";
        
        for(var i = 0; i < (arrBackId.length-1);i++)
        {
            strBackIds += arrBackId[i] + "|";
        }
        if(arrBackId.length > 0)
            strBackIds += arrBackId[arrBackId.length-1];
        
		//weird but to make it work on both weblogic & websphere
		if( objectId && objectId != null && objectId != "null" )
		{
			//navigate to the back ID
			document.tableHeaderForm.objectId.value = objectId;

			var newPageURL = "";
            newPageURL = "emxInfoNavigateFS.jsp?objectId=" + objectId + "&backId=" + strBackIds+"&portalMode=<%=XSSUtil.encodeForURL(context,portalMode)%>";

			//append the default table flag        
			if( document.tableHeaderForm.workSpaceTable.selectedIndex == 0)
				newPageURL += "&IsDefaultTable=true";

			//Resort column type is hard coded to "name" for WS tables
			newPageURL += "&reSortKey=name";

			//if(document.tableHeaderForm.RelationshipName.selectedIndex == 0)
				newPageURL += "&AllRelations=true";
			document.tableHeaderForm.action = newPageURL;
			document.tableHeaderForm.target = "_parent";
			document.tableHeaderForm.submit();

		}
	}

	function openPrinterFriendlyPage()
	{
	    //XSSOK
		var sQueryString = "<%=emxGetQueryStringNav(request)%>";
		var strFeatures = "scrollbars=yes,toolbar=yes,location=no,resizable=yes";
		var url = "emxInfoNavigatePrint.jsp?" + sQueryString;
		printDialog = window.open(url, "PF" + (new Date()).getTime(), strFeatures);

	}

</script>


</body>
<%@include file= "../common/emxNavigatorBottomErrorInclude.inc"%>

</html>
