<%--  emxInfoTableHeader.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoTableHeader.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxInfoTableHeader.jsp $
 * 
 * *****************  Version 49  *****************
 * User: Rahulp       Date: 31/01/03   Time: 20:27
 * Updated in $/InfoCentral/src/infocentral
 * 
 * ********************************************************
--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<html>

<%@include file = "emxInfoTableInclude.inc"%>
<%@ page import = "com.matrixone.apps.domain.util.*, com.matrixone.MCADIntegration.server.beans.*,com.matrixone.MCADIntegration.server.*,com.matrixone.MCADIntegration.utils.*" %>
<%@include file="emxInfoCentralUtils.inc"%>
<%@include file="emxInfoUtils.inc"%>             <%--For i18nStringNowLocal()--%>
<%@ page import = "matrix.db.*,com.matrixone.MCADIntegration.uicomponents.util.*" %>
<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<%
	MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute(MCADServerSettings.MCAD_INTEGRATION_SESSION_DATA_OBJECT);

	Context _context							= integSessionData.getClonedContext(session);
	IEFIntegAccessUtil util              = new IEFIntegAccessUtil(_context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
	

	String workspacePrefix						= integSessionData.getStringResource("mcadIntegration.Server.FieldName.WorkspaceTablePrefix");	
	String adminPrefix							= integSessionData.getStringResource("mcadIntegration.Server.FieldName.AdminTablePrefix");
	String defaultTableName						= integSessionData.getStringResource("mcadIntegration.Server.FieldName.DefaultTableName");

	String showIntegrationOption				= (String)emxGetParameter(request, "showIntegrationOption");
	String sfuncPageName						= (String)emxGetParameter(request, "funcPageName");
	String showAllTables						= (String)emxGetParameter(request, "showAllTables");
	String sAdminTableURL						= FrameworkUtil.encodeURLParamValues("emxInfoTableAdminBody.jsp?");
	String sWSTableURL							= FrameworkUtil.encodeURLParamValues("emxInfoTableWSBody.jsp?");

	String currIntegName						= emxGetSessionParameter(request,"integrationName");
	IEFConfigUIUtil iefConfigUIUtil             = new IEFConfigUIUtil(_context, integSessionData, currIntegName);

	if(sfuncPageName == null)
		sfuncPageName = "";
	
	if(showAllTables == null)
		showAllTables = "true";

	MapList integrationList = new MapList();
	if (null != showIntegrationOption && showIntegrationOption.equals("true"))
	{
	    try
	    {
	       String [] init   	= new String[] {};
	       HashMap paramMap = new HashMap();
	       
	       paramMap.put("LCO", (Object)integSessionData.getLocalConfigObject());
	       integrationList		= (MapList)JPO.invoke(_context, "DSC_CommonUtil", init, "getUserIntegrationAssignments", JPO.packArgs(paramMap), MapList.class);
	       if (null != integrationList && integrationList.size() <= 1)
	           showIntegrationOption = "false";

		   if(showIntegrationOption.equals("true"))
				showAllTables = "false";
		}
	    catch (Exception e)
	    {
	       System.out.println("emxInfoTableHeader.jsp: " + e.toString());
	    }
	}

	String integNameDefaultTableList  = null;

	for (int i = 0; i < integrationList.size(); i++) 
	{
		try
		{
			Map integMap = (Map)integrationList.get(i);
			String isAdminTable = null;
			String integName = (String)integMap.get("integrationName");				
			iefConfigUIUtil             = new IEFConfigUIUtil(_context, integSessionData, integName);
			String integDefaultTableName = iefConfigUIUtil.getDefaultCustomTableName(integName, sfuncPageName, integSessionData);

			if(integDefaultTableName!=null)
			{		
				if(integDefaultTableName.equals("Default") || integDefaultTableName.equals(integSessionData.getStringResource("emxIEFDesignCenter.Common.Default")))
				{
					integDefaultTableName = "DSCDefault";
					isAdminTable = "true";
				}
				else
				{
					boolean isSystemTable = iefConfigUIUtil.isSystemTable(_context, integDefaultTableName);
					isAdminTable = iefConfigUIUtil.isSystemTable(_context, integDefaultTableName) + "";
					integDefaultTableName = iefConfigUIUtil.getFilteredMatrixTableName(integDefaultTableName, isSystemTable);
				}
				
				if(i>0)
					integNameDefaultTableList = integNameDefaultTableList + ";" + integName + "=" + integDefaultTableName + "|" + isAdminTable;
				else 
					integNameDefaultTableList = integName + "=" + integDefaultTableName + "|" + isAdminTable;
				
			}
		}
		catch(Exception e)
	    {
	       System.out.println("emxInfoTableHeader.jsp: " + e.toString());
	    }

	}
%>


<script language="JavaScript" src="emxInfoUIModal.js"></script> 
<script language="JavaScript" src="emxInfoCentralJavaScriptUtils.js"></script>
<script language="JavaScript" src="../integrations/scripts/IEFUIConstants.js" type="text/javascript"></script>
<script language="JavaScript" src="../integrations/scripts/IEFUIModal.js" type="text/javascript"></script>
<script language="JavaScript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>



<script language="JavaScript">

function csvExport()
{
    var contentFrame = parent.frames["listDisplay"];
    var sTimeStamp = contentFrame.document.emxTableForm.timeStamp.value;

	var wsTable =  contentFrame.document.emxTableForm.WSTable.value;
	if (wsTable != "" )
	var fromTable = "fromTable=WS";
	else
	var fromTable = "fromTable=ADMIN";

	parent.frames['listHidden'].location.href = "../integrations/IEFTableExport.jsp?fromPage=tabless&timeStamp="+sTimeStamp+"&"+fromTable;
}

//Define varaibles required for showing Cue or Tip chooser
// Function FUN080585 : Removal of Cue, Tips and Views
var browser = navigator.userAgent.toLowerCase();
function cptKey(e) 
{
	var pressedKey = ("undefined" == typeof (e)) ? event.keyCode : e.keyCode ;
	if(browser.indexOf("msie") > -1)
	{
		if(((pressedKey == 8) ||((pressedKey == 37) && (event.altKey)) || ((pressedKey == 39) && (event.altKey))) &&((event.srcElement.form == null) || (event.srcElement.isTextEdit == false)))
			return false;
		if( (pressedKey == 37 && event.altKey) || (pressedKey == 39 && event.altKey) && (event.srcElement.form == null || event.srcElement.isTextEdit == false))
			return false;
	}
	else if(browser.indexOf("mozilla") > -1 || browser.indexOf("netscape") > -1)
	{
		var targetType =""+ e.target.type;
		if(targetType.indexOf("undefined") > -1)
		{
			if( pressedKey == 8 || pressedKey == 37 )
				return false;
		}
    }
    if (pressedKey == "27") 
    { 
       // ASCII code of the ESC key
       top.window.close();
    }
  }
// Add a handler
if(browser.indexOf("msie") > -1){
   document.onkeydown = cptKey ;
}else if(browser.indexOf("mozilla") > -1 || browser.indexOf("netscape") > -1){
	document.onkeypress = cptKey ;	
}

function onWSTableOptionChangeLocal()
{
	
	var tableType = "admin";
	parent.frames["listDisplay"].document.emxTableForm.IsAdminTable.value = "true";

	var tableName				= document.tableHeaderForm.workSpaceTable.options[document.tableHeaderForm.workSpaceTable.selectedIndex].text;
	var integrationName			= parent.frames['listDisplay'].document.emxTableForm.integrationName.value;
	//XSSOK
	var indexOfWorkspacePrefix	= tableName.indexOf("<%=workspacePrefix%>");

	if(indexOfWorkspacePrefix == 0)
	{
		tableType = "workspace";
		parent.frames["listDisplay"].document.emxTableForm.IsAdminTable.value="false";
	}

	onWSTableOptionChange(tableType, integrationName);
}

function onIntegrationOptionChange(integName)
{
	parent.frames["listDisplay"].document.emxTableForm.integrationName.value = integName;	
	// Get the default integTable for this IntegName
	var integdefaultTableNameType  = null;
	//XSSOK
	var integNameDefaultTableList = "<%=integNameDefaultTableList%>";	
	if(integNameDefaultTableList!=null)
	{
		integNameDefaultTableList = integNameDefaultTableList.split(';');
		for(var j = 0; j < integNameDefaultTableList.length; j++)
		{
			var integnameTableValuePair = integNameDefaultTableList[j].split('=');		
			var integname = integnameTableValuePair[0];
			var tableNameTypevalue = integnameTableValuePair[1];
			if(integname == integName)
				integdefaultTableNameType = tableNameTypevalue;				
			
		}
	}

	var  integdefaultTable = integdefaultTableNameType.split('|');
	integdefaultTable = integdefaultTable[0];

	var urlHead = changeIntegrationNameInURL(parent.frames["listHead"].document.location.href, integName, integdefaultTableNameType, "false");

	var urlDisplay = changeIntegrationNameInURL(parent.frames["listDisplay"].document.location.href,integName,integdefaultTableNameType, "true");
	
	parent.frames["listHead"].document.location.href = urlHead;
	parent.frames["listDisplay"].document.emxTableForm.target = "_self";
	parent.frames["listDisplay"].document.emxTableForm.action = urlDisplay + '&refresh=true';
	parent.frames["listDisplay"].document.emxTableForm.submit();
}

function changeIntegrationNameInURL(inURL,integName,integdefaultTableNameType,modifyURLHeader)
{
	
	var outURL = "";
	var paramArray = inURL.split('?');
	var integdefaultTableName = integdefaultTableNameType.split('|');
	var integdefaultTable = integdefaultTableName[0];
	var isAdminTable = integdefaultTableName[1];
	var integrationNameAddedinURL = "false";

	// replaces the integrationName with the Integraton name from user selection
	if (paramArray)
	{
		if(modifyURLHeader!=null && modifyURLHeader == 'true')
		{
			if(isAdminTable == 'true')
			    //XSSOK
				outURL = "<%=sAdminTableURL%>";
			else
			    //XSSOK
				outURL = "<%=sWSTableURL%>";
		}
		else
			outURL  = paramArray[0] + '?';

		if(paramArray.length > 1)
		{
			var sParameter = paramArray[1];
			var sNameValuePairArray = sParameter.split('&');
			if (sNameValuePairArray.length > 0)
			{
				for (var i = 0; i < sNameValuePairArray.length; i++)
				{
					var nameValuePair = sNameValuePairArray[i].split('=');
					var name = nameValuePair[0];
					var value = nameValuePair[1];
						
					if (name == 'integrationName')
					{
					   if(i>0)
						   outURL += '&';

					   outURL += 'integrationName=' + integName;
					   integrationNameAddedinURL = "true";
					}
					else if((name == 'selectedTable' || name == 'WSTable' || name == 'table' || name ==  'IsAdminTable') )
					{	
						// do nothing ignore this we will create this based on the current default table for selected integName
					}
					else
					{
					   if(i>0)
						   outURL += '&';
					
					   outURL += sNameValuePairArray[i];
					}
		
				}
			}	
		}
	}


	if(integrationNameAddedinURL == 'false')
		outURL = outURL + '&integrationName=' + integName;

	if(isAdminTable == 'true')
		outURL = outURL + "&IsAdminTable=true" + '&selectedTable=' +integdefaultTable +  "&table=" + integdefaultTable ;
	else
		outURL = outURL +  "&IsAdminTable=false" + '&selectedTable=' +integdefaultTable   + "&WSTable=" + integdefaultTable ;

	return outURL;
}
</script>

<%
    String sTarget  =  emxGetSessionParameter(request, "targetLocation");
	String header   = emxGetSessionParameter(request, "header");
    String objectId = emxGetSessionParameter(request, "objectId");
    String relId    = emxGetSessionParameter(request, "relId");
    //String sHelpMarker = "emxHelpInfoSearchResults";
		
	String sHelpMarker            = emxGetSessionParameter(request, "HelpMarker");
	String suiteKey               = emxGetSessionParameter(request, "suiteKey");
	String inquiryList            = emxGetSessionParameter(request, "inquiry");
    String inquiryLabel           = emxGetSessionParameter(request, "inquiryLabel");
    String programList            = emxGetSessionParameter(request, "program");
    String programLabel           = emxGetSessionParameter(request, "programLabel");
    String selectedFilter         = emxGetSessionParameter(request, "selectedFilter");
    String sActionBarName         = emxGetSessionParameter(request, "topActionbar");
    String tipPage                = emxGetSessionParameter(request, "TipPage");
    String printerFriendly        = emxGetSessionParameter(request, "PrinterFriendly");
	String relatedPage            = emxGetSessionParameter(request, "RelatedPage");
	String sTableName             = emxGetSessionParameter(request, "WSTable");
    String sWorkSpaceFilterName   = emxGetSessionParameter(request, "WorkSpaceFilter");
    String sRelDirection          = emxGetSessionParameter(request,"RelDirection");
    String sRelationName          = emxGetSessionParameter(request,"RelationName");
	String integrationName		  = emxGetSessionParameter(request,"integrationName");
	String sShowWSTable			  = emxGetSessionParameter(request,"showWSTable");	
	String acceptLanguage         = request.getHeader("Accept-Language");
	//Used for passing admin Object name like collection name etc.
	String adminObjectName        = emxGetSessionParameter(request, "setName");
	String sDefault               = emxGetSessionParameter(request,"table");
	String isAdminTable           = emxGetSessionParameter(request, "IsAdminTable");
	String actionBarPos           = "32";
	String timeStamp              = emxGetParameter(request, "timeStamp");
    StringList filterStrList      = new StringList();
    StringList filterLabelStrList = new StringList();
	String funcPageName           = emxGetSessionParameter(request, "funcPageName");	
	String tableForDefault        = emxGetSessionParameter(request, "tableForDefault");
	String selectedTable          = emxGetSessionParameter(request, "selectedTable");
	String selectedTableWithPrefix = "";

	String portalMode = emxGetParameter(request, "portalMode");

	if(portalMode == null || portalMode.equals("") || !portalMode.equalsIgnoreCase("true"))
		portalMode = "false";

	if(isAdminTable == null)
		isAdminTable = "false";

	if(selectedTable != null && !"".equals(selectedTable))
	{
		if("true".equals(isAdminTable))
		{
			selectedTableWithPrefix = adminPrefix + selectedTable;
		}
		else
		{
			selectedTableWithPrefix = workspacePrefix + selectedTable;
		}
	}

    // Get the list of enquiries and label
    if (inquiryList != null && inquiryList.trim().length() > 0 )
    {
        if (inquiryList.indexOf(",") > 0 )
            filterStrList = FrameworkUtil.split(inquiryList, ",");

        if (inquiryLabel != null && inquiryLabel.trim().length() > 0 )
        {
            if (inquiryLabel.indexOf(",") > 0 )
                filterLabelStrList = FrameworkUtil.split(inquiryLabel, ",");
        }
    } 
    else if (programList != null && programList.trim().length() > 0 )
    {
        if (programList.indexOf(",") > 0 )
            filterStrList = FrameworkUtil.split(programList, ",");

        if (programLabel != null && programLabel.trim().length() > 0 )
        {
            if (programLabel.indexOf(",") > 0 )
                filterLabelStrList = FrameworkUtil.split(programLabel, ",");
        }
    }

    if (header != null)
        header = parseTableHeader(application, context, header, objectId, suiteKey, acceptLanguage);
    
    if(adminObjectName != null && !adminObjectName.trim().equals("") && !adminObjectName.trim().equals("null"))
    {
      header = adminObjectName + ":" + header;	
    }    

	// rajeshg
	// always chaeck for "null"
	// done for collection problem.
    if( ( objectId != null ) && !("null".equals(objectId)) && ( ! ( objectId.trim().equals("") ) ) )
    {
		try
    {
        BusinessObject bus = new BusinessObject( objectId );
        bus.open( context );
        String sRevText = i18nStringNow("emxIEFDesignCenter.Common.Rev", request.getHeader("Accept-Language"));
        header =bus.getTypeName()+"  "+ bus.getName() + "  " + sRevText + " " + bus.getRevision() + ":" + header;
        bus.close(context);
    }
		catch(MatrixException ex)
		{
			System.out.println("MatrixException = " +ex );
		}
    }

    String suiteDir = "";
    String registeredSuite = "";
	String stringResFileId = "";

	if ( suiteKey != null)
	{
		if(suiteKey.startsWith("eServiceSuite") )
    {
        registeredSuite = suiteKey.substring(13);
		}
		else
		{		
			registeredSuite = suiteKey;	
		}
        if ( (registeredSuite != null) && (registeredSuite.trim().length() > 0 ) )
		{
            suiteDir = UINavigatorUtil.getRegisteredDirectory(application, registeredSuite);
				stringResFileId = UINavigatorUtil.getStringResourceFileId(application, registeredSuite);
		}
    }
%>

<head>
	<title>Table Header</title>
<!--Enable AEF style toolbar change start -->

	<%@include file = "emxInfoUIConstantsInclude.inc"%>
		<script language="javascript" type="text/javascript" src="../integrations/scripts/IEFHelpInclude.js"></script>
		<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICore.js"></script>
        <script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICoreMenu.js"></script>
        <script language="JavaScript" type="text/javascript" src="../common/scripts/emxUIToolbar.js"></script>
		<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUIConstants.js"></script>	
	<%@include file = "../emxStyleDefaultInclude.inc"%>
	        <script language="JavaScript" type="text/javascript">
            addStyleSheet("emxUIToolbar");
            addStyleSheet("emxUIMenu");
        </script>
<% 
    if(sTarget != null && !sTarget.equals("") && !sTarget.trim().equals("null"))
    {
       if(sTarget.equals("content") &&  !sTarget.equals(""))	
       {
		          	
%>
		<link rel="stylesheet" type="text/css" href="../common/styles/emxUIDefault.css" />
		<link rel="stylesheet" type="text/css" href="../common/styles/emxUIList.css" />
<%       	
       }
       else
       {
		   
%>
		
		<link rel="stylesheet" type="text/css" href="../common/styles/emxUIList.css" />
		<link rel="stylesheet" type="text/css" href="../common/styles/emxUISearch.css" />	       
<%	
       }
    }
    else
    {
		
%>    	
  		<link rel="stylesheet" type="text/css" href="../common/styles/emxUIDefault.css" />
		<link rel="stylesheet" type="text/css" href="../common/styles/emxUIList.css" />		
<%    	
    }
%>	

<!--Enable AEF style toolbar change start -->
</head>

<body marginheight="0">
<link rel="stylesheet" href="../integrations/styles/emxIEFCommonUI.css" type="text/css">
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
//System.out.println("CSRFINJECTION");
%>

<%
	if(timeStamp!=null && timeStamp.trim().length()>0 && !timeStamp.equals("null")){
	HashMap map = (HashMap)session.getAttribute("ParameterList" + timeStamp);
	Iterator itr = map.keySet().iterator();
	while(itr.hasNext()){
	String paramName=(String)itr.next();
	String paramValue="";
	Object valueObject = (Object)map.get(paramName);
	if(valueObject != null)
		paramValue = (String)(valueObject.toString());
	if(!paramName.equalsIgnoreCase("relationshipName") && !paramName.equalsIgnoreCase("filterTable")&&
	   !paramName.equalsIgnoreCase("workSpaceTable") &&	   !paramName.equalsIgnoreCase("WorkSpaceFilter")&&
	   !paramName.equalsIgnoreCase("toDirection")&&
	   !paramName.equalsIgnoreCase("fromDirection")&&
	   !paramName.equalsIgnoreCase("IsAdminTable")&&
	   !paramName.equalsIgnoreCase("page")&& 
	   !paramName.equalsIgnoreCase("WSTable")){

%>
<!--XSSOK-->
<input type="hidden" name="<%=paramName%>" value="<%=paramValue%>">
<%
	}
    }
	}	
%>
		<table  border="0" cellspacing="2" cellpadding="0" width="100%">
			<tr>
			<td width="99%">
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
		   <tr>
		     <td class="pageBorder"><img src="../common/images/utilSpacer.gif" width="1" height="1" alt=""></td>
		   </tr>
			</table>

<%
    if (filterStrList != null && filterStrList.size() > 1)
    {
%>
				<table border="0" width="100%" cellspacing="0" cellpadding="0">
				<tr>
<td class="node" width="60%"><xss:encodeForHTML><%=header%></xss:encodeForHTML></td>
<td>&nbsp;&nbsp;&nbsp;&nbsp;<img src="../common/images/utilProgressDialog.gif" width="34" height="28" name="imgProgress"></td>
<td align="right" class="filter"><select class="filter"  name="filterTable" onChange="onFilterOptionChange()">
<%
        if (selectedFilter == null || selectedFilter.length() == 0)
            selectedFilter = (String)filterStrList.get(0);
			
        for (int i=0; i < filterStrList.size(); i++ )
        {
            String optionSelect = "";
            String filterItem = (String)filterStrList.get(i);
            String filterLabel = (String)filterLabelStrList.get(i);
            
		    if(filterLabel.length() != 0 && filterLabel != null)
			{		
				filterLabel = UINavigatorUtil.getI18nString(filterLabel, stringResFileId , acceptLanguage);	
			}
            if (filterItem.equalsIgnoreCase(selectedFilter) )
                optionSelect = "selected";
%>
<!--XSSOK-->
<option value="<%=filterItem%>" <%=optionSelect%> ><%=filterLabel%></option>
<%
        }
%>
</select></td>
</tr>
</table>
<%
    } 
    else 
    {
%>

<table border="0" width="100%" cellspacing="0" cellpadding="0">
<tr>
<!--XSSOK-->
<td class="pageHeader" width="1%" nowrap><%=MCADUtil.escapeStringForHTML(header)%></td>
<td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="../common/images/utilProgressDialog.gif" width="34" height="28" name="imgProgress" ></td>
				</tr>
				</table>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tr>
<td class="pageBorder"><img src="../common/images/utilSpacer.gif" width="1" height="1" alt=""></td>
</tr>
</table>
</td>
<td><img src="../common/images/utilSpacer.gif" alt="" width="4"></td>
</tr>
<tr><td>
<script language="JavaScript">
    // This variable positions the action item list from the top os the frame
    //var actionItemTopPos = 55;
	//XSSOK
    var actionItemTopPos=<%=actionBarPos%>;
    var actionItemLeftPos= 10;
    var visibleLinks = 4;
</script>
</td></tr>
</table>
<%
    }

    if( ( relatedPage != null ) && ( relatedPage.equals("true") ) )
    {
%>
<table border="0" width="100%" cellspacing="0" cellpadding="0">
<tr>
   <td><img src="../common/images/utilSpacer.gif" width="5" height="1" alt=""></td>
				</tr>
<tr>
   <td><%@include file = "emxInfoRelationshipFilter.inc"%></td>
</tr>

				</table>
<%
    }
//*******************************************************
// Displaying work space tables
//*******************************************************

%>

<table border="0" width="100%" cellspacing="0" cellpadding="0">
<tr>
   <td><img src="../common/images/utilSpacer.gif" width="5" height="2" alt=""></td>
</tr>
</table>

 <% if(sShowWSTable==null || !sShowWSTable.equals("false")) { %>
    <table class="formBG" cellpadding="0" cellspacing="0" border="0">
      <tr >
        <td align="left" class="filter" nowrap><%=i18nStringNow("emxIEFDesignCenter.Common.Views", acceptLanguage)%>&nbsp;<select name="workSpaceTable" onChange="onWSTableOptionChangeLocal()">
<%
        //read the default table list, and look this table up
        //FUN080585: Removal of deprecated function getDefaultVisuals
        //Visuals visualsDefault        = null; //context.getDefaultVisuals();
        //Vector allTables              = iefConfigUIUtil.getAdminAndWorkspaceTableNamesWithPrefix(context, integSessionData);

		Vector allTables              = new Vector();
		if(showAllTables.equalsIgnoreCase("false") && integrationName != null && !integrationName.equals(""))
			allTables = iefConfigUIUtil.getAdminAndWorkspaceTableNamesWithPrefix(context,integrationName, integSessionData);
		else
		{	
			if(util.getAssignedIntegrations(context).size() > 0)
			{
				allTables = iefConfigUIUtil.getAdminAndWorkspaceTableNamesWithPrefix(context, integSessionData);
			}
			else
			{
				allTables.addAll(iefConfigUIUtil.getWorkspaceTableNamesWithPrefix(context));
				allTables.addElement("Default");
			}
		}

        String tableNameStr           = "";
		String tableNameStrWithPrefix = "";
		String isSelected             = "";
		boolean isSystemTable         = true;        
		String defaultTable           = integSessionData.getStringResource("mcadIntegration.Server.FieldName.DefaultTableName");
		for(int i=0; i < allTables.size(); i++)
        {
			tableNameStrWithPrefix = (String)allTables.elementAt(i);
			if(defaultTableName.equals(tableNameStrWithPrefix))
				tableNameStr = tableForDefault;
			else
		    {
				isSystemTable = iefConfigUIUtil.isSystemTable(context, tableNameStrWithPrefix);
				tableNameStr  = iefConfigUIUtil.getFilteredMatrixTableName(tableNameStrWithPrefix,isSystemTable);
		    }
            isSelected = "";			
			if(!"".equals(selectedTableWithPrefix))
			{
				if(selectedTableWithPrefix.equals(tableNameStrWithPrefix))					
					isSelected = "selected";
			}
			else if(tableNameStrWithPrefix.equals(defaultTable))
				isSelected = "selected";

%>
             <!--XSSOK-->
             <option value= "<%=XSSUtil.encodeForHTML(_context,tableNameStr)%>" <%=isSelected%>><%=tableNameStrWithPrefix%></option>
<%
        }
        
%>
          </select>
        </td>
<%        
       if (null != showIntegrationOption && showIntegrationOption.equals("true")) 
       { 
 %>
        <td align="right" class="filter">&nbsp;&nbsp;<%=i18nStringNow("emxIEFDesignCenter.Common.Integration", acceptLanguage)%>&nbsp;
           <select name="integrationName" id="integrationName" onChange="javascript:onIntegrationOptionChange(this.options[this.selectedIndex].value); return true;">
<%        for (int i = 0; i < integrationList.size(); i++) 
          {
             Map integMap = (Map)integrationList.get(i);
             String integName = (String)integMap.get("integrationName");
             String selected = (integName.equals(integrationName) ? "selected" : "");
 %>
              <!--XSSOK-->
              <option <%=selected%> value="<%=integName%>"><%=integName%></option>
<%        } %>
           </select>
        </td>
<%      }  
// Function FUN080585 : Removal of Cue, Tips and Views
%>
	</tr>
</table>

<% } //if(sShowWSTable==null || !sShowWSTable.equals("false")) %>


<%
	//if ( !(sActionBarName == null) && !(sActionBarName.equals("")) && !(sActionBarName.equalsIgnoreCase("null")) )
	if ( "false" != sActionBarName)
    {
%>
	<!-- Use this code to enable AEF style toolbar -->
		<jsp:include page = "../common/emxToolbar.jsp" flush="true">
			<jsp:param name="toolbar" value="<%=XSSUtil.encodeForHTML(_context,sActionBarName)%>"/>
			<jsp:param name="objectId" value="<%=XSSUtil.encodeForHTML(_context,objectId)%>"/>
			<jsp:param name="parentOID" value="<%=XSSUtil.encodeForHTML(_context,objectId)%>"/>
			<jsp:param name="timeStamp" value="<%=XSSUtil.encodeForHTML(_context,timeStamp)%>"/>
			<jsp:param name="header" value="<%=XSSUtil.encodeForHTML(_context,header)%>"/>
			<jsp:param name="PrinterFriendly" value="<%=XSSUtil.encodeForHTML(_context,printerFriendly)%>"/>
			<jsp:param name="helpMarker" value="<%=XSSUtil.encodeForHTML(_context,sHelpMarker)%>"/>
			<jsp:param name="suiteKey" value="<%=XSSUtil.encodeForHTML(_context,suiteKey)%>"/>
			<jsp:param name="tipPage" value="<%=XSSUtil.encodeForHTML(_context,tipPage)%>"/>
			<jsp:param name="export" value="false"/>
			<jsp:param name="portalMode" value="<%=XSSUtil.encodeForHTML(_context,portalMode)%>"/>
		</jsp:include> 
<%
    }
%>
</td>
<td><img src="images/utilSpacer.gif" alt="" width="4"></td>
</tr>
</table>
</form>
</body>
</html>
