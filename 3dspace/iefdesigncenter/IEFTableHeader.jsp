<%--  IEFTableHeader.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<html>

<%@include file = "emxInfoTableInclude.inc"%>
<%@include file = "emxInfoCentralUtils.inc"%>
<%@include file = "emxInfoUtils.inc"%>
<%@include file = "IEFTableInclude.inc"%>
<%@include file = "../integrations/MCADTopErrorInclude.inc"%>

<%@ page import = "com.matrixone.MCADIntegration.uicomponents.util.*"%>
<%@ page import="java.util.*,java.io.*, java.net.*,com.matrixone.MCADIntegration.server.*,com.matrixone.MCADIntegration.server.beans.*, com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.utils.customTable.*"  %>
<%@ page import = "matrix.db.*, matrix.util.*,com.matrixone.servlet.*,com.matrixone.apps.framework.ui.*,com.matrixone.apps.domain.util.*, com.matrixone.apps.domain.*"%>

<%
	String errorMessage = serverResourceBundle.getString("mcadIntegration.Server.Message.ExportNotSupported");
%>

<script language="JavaScript" src="emxInfoUIModal.js"></script> 
<script language="JavaScript" src="emxInfoCentralJavaScriptUtils.js"></script>

<script language="JavaScript">

function csvExport()
{
    var contentFrame = parent.frames["listDisplay"];

	if(contentFrame.document.emxTableForm)
	{
		var sTimeStamp = contentFrame.document.emxTableForm.timeStamp.value;		
		var wsTable =  contentFrame.document.emxTableForm.WSTable.value;
		
		var fromTable = null;
		if (wsTable != "" )
			fromTable = "fromTable=WS";
		else
			fromTable = "fromTable=ADMIN";

		parent.frames["listHidden"].location.href = "../integrations/IEFTableExport.jsp?fromPage=tabless&timeStamp="+sTimeStamp+"&"+fromTable;
	}
	else
	{
		alert("<%=XSSUtil.encodeForJavaScript(context, errorMessage)%>");
	}
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
</script>

<%
    String sTarget              =  emxGetSessionParameter(request, "targetLocation");
    String header               = emxGetSessionParameter(request, "header");
    String objectId             = emxGetSessionParameter(request, "objectId");
    String relId                = emxGetSessionParameter(request, "relId");
    String sHelpMarker			= emxGetSessionParameter(request, "HelpMarker");
    String suiteKey             = emxGetSessionParameter(request, "suiteKey");
    String inquiryList          = emxGetSessionParameter(request, "inquiry");
    String inquiryLabel         = emxGetSessionParameter(request, "inquiryLabel");
    String programList          = emxGetSessionParameter(request, "program");
    String programLabel         = emxGetSessionParameter(request, "programLabel");
    String selectedFilter       = emxGetSessionParameter(request, "selectedFilter");
    String sActionBarName       = emxGetSessionParameter(request, "topActionbar");

    String tipPage              = emxGetSessionParameter(request, "TipPage");
    String printerFriendly      = emxGetSessionParameter(request, "PrinterFriendly");
    String relatedPage          = emxGetSessionParameter(request, "RelatedPage");
	String sTableName           = emxGetSessionParameter(request, "WSTable");
    String sWorkSpaceFilterName = emxGetSessionParameter(request, "WorkSpaceFilter");
    String sRelDirection        = emxGetSessionParameter(request,"RelDirection");
    String sRelationName        = emxGetSessionParameter(request,"RelationName");
	String acceptLanguage       = request.getHeader("Accept-Language");
	//Used for passing admin Object name like collection name etc.
	String adminObjectName      = emxGetSessionParameter(request, "setName");	
	String isAdminTable         = emxGetSessionParameter(request, "IsAdminTable");
	String actionBarPos         = "32";
	String timeStamp            = emxGetParameter(request, "timeStamp");
	String isPopup              = emxGetParameter(request, "isPopup");
	String pageHeader           = emxGetParameter(request, "pageHeader");	
	String funcPageName         = emxGetParameter(request, "funcPageName");


	MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
	Context clonedContext						= integSessionData.getClonedContext(session);
	MCADMxUtil util                             = new MCADMxUtil(clonedContext, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
	

	header					= integSessionData.getStringResource(header);
	String integrationName	= util.getIntegrationName(clonedContext, objectId);
	IEFConfigUIUtil iefConfigUIUtil             = new IEFConfigUIUtil(clonedContext, integSessionData, integrationName);
	
	MCADGlobalConfigObject globalConfig			= integSessionData.getGlobalConfigObject(integrationName,clonedContext);

	boolean isCreateVersionObject				= globalConfig.isCreateVersionObjectsEnabled();
	
	String defaultTableName = integSessionData.getStringResource("mcadIntegration.Server.FieldName.DefaultTableName");

	String encodedContentURL         = emxGetParameter(request, "encodedContentURL");
	String encodedDefaultFooterPage  = emxGetParameter(request, "encodedDefaultFooterPage");
	String appName                   = application.getInitParameter("ematrix.page.path");
	String tableName             = emxGetParameter(request, "tableName");
	try
	{
		tableName = MCADUrlUtil.hexDecode(tableName);
	}
	catch(Exception e)
	{
		//leave the tableName as it is
	}
	
    StringList filterStrList      = new StringList();
    StringList filterLabelStrList = new StringList();

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
    
    if(adminObjectName != null && adminObjectName != "" && adminObjectName !=" ")
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
			bus.open( clonedContext );
			String sRevText = i18nStringNow("emxIEFDesignCenter.Common.Rev", request.getHeader("Accept-Language"));
			
			if(!isCreateVersionObject)
			{
				BusinessObject majorBus = util.getMajorObject(clonedContext, bus);
								
				if(majorBus == null)
					majorBus = bus;

				if(!majorBus.isOpen())
					majorBus.open(clonedContext);

				header = majorBus.getTypeName()+"  "+ majorBus.getName() + "  " + sRevText + " " + majorBus.getRevision() + ":" + header;
				majorBus.close(clonedContext);
			}
			else
			{	
				header =bus.getTypeName()+"  "+ bus.getName() + "  " + sRevText + " " + bus.getRevision() + ":" + header;		
			}

			if(bus.isOpen())
					bus.close(clonedContext);
		}
		catch(MatrixException ex)
		{
			System.out.println("MatrixException = " +ex );
		}
    }



    String suiteDir = "";
    String registeredSuite = "";

    if ( suiteKey != null && suiteKey.startsWith("eServiceSuite") )
    {
        registeredSuite = suiteKey.substring(13);

        if ( (registeredSuite != null) && (registeredSuite.trim().length() > 0 ) )
            suiteDir = UINavigatorUtil.getRegisteredDirectory(application, registeredSuite);
    }

%>

<head>
	<title>Table Header</title>
<!--Enable AEF style toolbar change start -->

	<%@include file = "emxInfoUIConstantsInclude.inc"%>
		<script language="javascript" type="text/javascript" src="emxInfoHelpInclude.js"></script>
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
    if(isPopup != null && !isPopup.equals("") )
    {
       if(isPopup.equals("false") &&  !isPopup.equals(""))	
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
<form name="tableHeaderForm" method="post">
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
				<!--XSSOK-->
<td class="pageHeader" width="60%"><%=header%></td>

<td align="right" class="filter"><select class="filter"  name="filterTable" onChange="onFilterOptionChange()">
<%
        if (selectedFilter == null || selectedFilter.length() == 0)
            selectedFilter = (String)filterStrList.get(0);
			
        for (int i=0; i < filterStrList.size(); i++ )
        {
            String optionSelect = "";
            String filterItem = (String)filterStrList.get(i);
            String filterLabel = (String)filterLabelStrList.get(i);
            
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
<td class="pageHeader" width="1%" nowrap><%=header%></td>

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

<script language="javascript">
var contentframe = parent.frames["listDisplay"];
var footerframe = parent.frames["footerFrame"];
var headerframe = parent.frames["pageheader"];
</script>
    <table class="formBG" cellpadding="0" cellspacing="0" border="0">
      <tr >
        <td align="left" class="filter" nowrap><%=i18nStringNow("emxIEFDesignCenter.Common.Views", acceptLanguage)%>&nbsp;<select name="workSpaceTable" onChange="onWSTableOptionChange(contentframe,headerframe,footerframe,'<%=pageHeader%>', '<%=encodedContentURL%>', '<%=encodedDefaultFooterPage%>','<%=timeStamp%>','<%=isPopup%>','<%=funcPageName%>', '<%=objectId%>','<%=integrationName%>','<%=defaultTableName%>','<%=sActionBarName%>', false, false)">
          
<%
        //read the default table list, and look this table up
		Vector allTables = iefConfigUIUtil.getAdminAndWorkspaceTableNamesWithPrefix(clonedContext, integrationName, integSessionData);
        String sTableNameStr = "";
		String sTableNameStrWithPrefix = "";
		boolean isSystemTable = true;
        String sSelected = "";		
		String defaultTable =  iefConfigUIUtil.getDefaultCustomTableName(integrationName, funcPageName, integSessionData);
		for(int i=0; i < allTables.size(); i++)
		{
			sTableNameStrWithPrefix = (String)allTables.elementAt(i);
			if(defaultTableName.equals(sTableNameStrWithPrefix))
			{
				sTableNameStr = defaultTableName ;
				
			}
			else
			{
				isSystemTable = iefConfigUIUtil.isSystemTable(clonedContext, sTableNameStrWithPrefix);
				sTableNameStr = iefConfigUIUtil.getFilteredMatrixTableName(sTableNameStrWithPrefix,isSystemTable);
			}
			sSelected = "";
			if(tableName != null )
			{
				if(sTableNameStrWithPrefix.equals(tableName))
				{
					sSelected = "selected";
				}

			}
			else if (sTableNameStrWithPrefix.equals(defaultTable))
			{
				sSelected = "selected";
			}
%>
            <!--XSSOK-->
            <option value= "<%=sTableNameStr%>" <%=sSelected%>><%=sTableNameStrWithPrefix%></option>
<%
        }
// Function FUN080585 : Removal of Cue, Tips and Views
%>
          </select>
        </td>
      </tr>
    </table>
	<table border="0" cellspacing="0" cellpadding="0" width="100%">
		<tr>
			<td align="right" >
			<a href='javascript:openIEFHelp("emxhelpdscversions")'><img src="../integrations/images/buttonContextHelp.gif" width="16" height="16" border="0" ></a>
			</td>
		</tr>
	</table>
	
<%
    if ( !(sActionBarName == null) && !(sActionBarName.equals("")) && !(sActionBarName.equalsIgnoreCase("null")) )
    {
%>
	<!-- Use this code to enable AEF style toolbar -->
		<jsp:include page = "../common/emxToolbar.jsp" flush="true">
			<jsp:param name="toolbar" value="<%=XSSUtil.encodeForURL(context, sActionBarName)%>"/>
			<jsp:param name="objectId" value="<%=XSSUtil.encodeForURL(context, objectId)%>"/>
			<jsp:param name="parentOID" value="<%=XSSUtil.encodeForURL(context, objectId)%>"/>
			<jsp:param name="timeStamp" value="<%=XSSUtil.encodeForURL(context, timeStamp)%>"/>
			<jsp:param name="header" value="<%=XSSUtil.encodeForURL(context, header)%>"/>
			<jsp:param name="PrinterFriendly" value="<%=XSSUtil.encodeForURL(context, printerFriendly)%>"/>
			<jsp:param name="helpMarker" value="<%=XSSUtil.encodeForURL(context, sHelpMarker)%>"/>
			<jsp:param name="suiteKey" value="<%=XSSUtil.encodeForURL(context, suiteKey)%>"/>
			<jsp:param name="tipPage" value="<%=XSSUtil.encodeForURL(context, tipPage)%>"/>
			<jsp:param name="export" value="false"/>
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
