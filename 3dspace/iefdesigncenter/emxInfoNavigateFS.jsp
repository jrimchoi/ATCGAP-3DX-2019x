<%--  emxInfoNavigateFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoNavigateFS.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxInfoNavigateFS.jsp $
 *
 * *****************  Version 43  *****************
 * User: Manasr       Date: 1/31/03    Time: 8:16p
 * Updated in $/InfoCentral/src/infocentral
 * Made changes for bug fixing of back functionality.
 *
 * *****************  Version 42  *****************
 * User: Rahulp       Date: 31/01/03   Time: 17:03
 * Updated in $/InfoCentral/src/infocentral
 *
 * *****************  Version 41  *****************
 * User: Rahulp       Date: 31/01/03   Time: 16:17
 * Updated in $/InfoCentral/src/infocentral
 *
 * *****************  Version 40  *****************
 * User: Manasr       Date: 1/31/03    Time: 11:57a
 * Updated in $/InfoCentral/src/infocentral
 * Bug fix, exception handled.
 *
 * *****************  Version 39  *****************
 * User: Manasr       Date: 1/30/03    Time: 7:26p
 * Updated in $/InfoCentral/src/infocentral
 * Made changes for menu manager.
 *
 * *****************  Version 38  *****************
 * User: Rahulp       Date: 1/16/03    Time: 10:33a
 * Updated in $/InfoCentral/src/infocentral
 *
 * *****************  Version 37  *****************
 * User: Snehalb      Date: 1/15/03    Time: 6:42p
 * Updated in $/InfoCentral/src/infocentral
 * changes for configurable menu
 *
 * *****************  Version 36  *****************
 * User: Rahulp       Date: 1/15/03    Time: 3:40p
 * Updated in $/InfoCentral/src/infocentral
 *
 * *****************  Version 35  *****************
 * User: Rahulp       Date: 1/15/03    Time: 1:25p
 * Updated in $/InfoCentral/src/infocentral
 *
 * *****************  Version 34  *****************
 * User: Mallikr      Date: 1/12/03    Time: 5:04p
 * Updated in $/InfoCentral/src/infocentral
 * navigate jap changes
 *
 * *****************  Version 33  *****************
 * User: Rahulp       Date: 1/12/03    Time: 1:59p
 * Updated in $/InfoCentral/src/infocentral
 *
--%>

<%@ page import="com.matrixone.MCADIntegration.uicomponents.beans.*" %>
<%
//Added by gaurav for scalability testing::
// timeStamp to handle the multiple windows ( cleaning up session ) etc
String sTimeStamp = Long.toString(System.currentTimeMillis());

long time1Check = System.currentTimeMillis();
session.setAttribute("Time1" + sTimeStamp,new Long(time1Check));
%>

<%@include file= "../common/emxNavigatorInclude.inc"%>
<%@include file= "emxInfoTableInclude.inc"%>
<%@include file= "emxInfoTreeTableUtil.inc"%>
<%@include file= "../common/emxNavigatorTopErrorInclude.inc"%>
<%@ include file="../emxUICommonHeaderBeginInclude.inc"%>

<%@ page import = "com.matrixone.MCADIntegration.utils.*"  %>
<%@ page import = "java.util.*,java.io.*, java.net.*,com.matrixone.MCADIntegration.server.*,com.matrixone.MCADIntegration.server.beans.*, com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.utils.customTable.*"  %>
<%@ page import = "matrix.db.*, matrix.util.*,com.matrixone.servlet.*,com.matrixone.apps.framework.ui.*,com.matrixone.apps.domain.util.*, com.matrixone.apps.domain.*"%>

<%

	//URL to view Business Object Details
	//URL will look like       <'busObjectDetailsPage'>&busId=< bo id for object >
	//String busObjectDetailsPage = "../common/emxTree.jsp";
	String busObjectDetailsPage = "emxInfoManagedMenuEmxTree.jsp";
//    String busObjectDetailsPage =                     "emxInfoObjectCheckAccesses.jsp?access=Read&actionURL=../common/emxTree.jsp&targetLocation=popup";

	//URL to view Relationship Object Details
	//URL will look like       <'relObjectDetailsPage'>?relId=<rel id passed in>&comboRelationshipName=<rel name passed in>
	String relObjectDetailsPage = "emxInfoObjectCheckAccesses.jsp?access=Read&actionURL=emxInfoRelationshipDetailsDialogFS.jsp&targetLocation=popup";

	//View icons and Rel. arrows
	String viewRelArrows ="True";
	String viewIcons = "True";

	//page to load child objects from
	String loadChildrenPage = "emxInfoNavigateLoadAllChildren.jsp";

	String toggleExpandPage = "emxInfoNavigateToggleExpand.jsp";

	//TBD: Decide how to get these colours
	//colors
	String LineColor = "#dedede";
	String HighlightColor ="#ffffcc";
	String HeadingBackgroundColor ="#336699";
	String HeadingFontColor = "#ffffff";
	String PageBackgroundColor = "#ffffff";
	String PageFontColor = "#003366";

	// open the passed in table
	Vector vectorColList = null;
	int htmlTableWidth = 0;
	int numberOfColumns = 0;
	String sTableName = "";


	//pass the required parameters to the subsequent pages
	String sHeaderString = emxGetParameter(request, "header");
	if(sHeaderString == null || sHeaderString.equals(""))
		sHeaderString = "emxIEFDesignCenter.Header.Navigate";
	String sHeaderStringUnresolved = sHeaderString;

	String suiteKey = emxGetParameter(request, "suiteKey");

	if(suiteKey == null || suiteKey.equals(""))
		suiteKey = "eServiceSuiteDesignerCentral";

	String sPopupFlag = emxGetParameter(request, "popup");
	String portalMode = emxGetParameter(request, "portalMode");

	if(null == portalMode)
		portalMode = "false";

	String sDefaultTableFlag = null;
	sTableName			     = emxGetParameter(request, "WSTable");
	sDefaultTableFlag	     = emxGetParameter(request ,"IsDefaultTable");
	String sAdminTableName   = emxGetParameter(request, "table");
	if(sAdminTableName == null || sAdminTableName.equals(""))
		sAdminTableName = "DSCNavigate";

	String sSortKey       = emxGetParameter(request, "SortKey");
	String sSortDirection = emxGetParameter(request, "sortDirection");

	String tableName = emxGetParameter(request, "TableName");

	if(tableName != null)
		tableName = MCADUrlUtil.hexDecode(tableName);

	String sHelpMarker = emxGetParameter(request, "HelpMarker");

	if(sHelpMarker == null || sHelpMarker.equals(""))
		sHelpMarker = "emxhelpdscnavigator";

	String featureName = MCADGlobalConfigObject.FEATURE_NAVIGATE;

	String activeFrame = emxGetParameter(request, "activeFrame");

	if(activeFrame == null || activeFrame.equals("") || activeFrame.equals("null"))
		activeFrame = "listDisplay";

	MCADIntegrationSessionData integSessionData	= (MCADIntegrationSessionData) session.getAttribute(MCADServerSettings.MCAD_INTEGRATION_SESSION_DATA_OBJECT);
	String errorMessage = "";
	//the session may have expired. Show error.
	if(integSessionData == null)
	{
		MCADServerResourceBundle serverResourceBundle = new MCADServerResourceBundle(request.getHeader("Accept-Language"));

        errorMessage		= serverResourceBundle.getString("mcadIntegration.Server.Message.ServerFailedToRespondSessionTimedOut");
		emxNavErrorObject.addMessage(errorMessage);
	}
	//go ahead only if integSessionData is not null.
	else
	{
		MCADMxUtil util                             = new MCADMxUtil(context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());


		String sBusId								= emxGetParameter(request, "objectId");
		String integrationName						= "";
		if(sBusId != null && !"".equals(sBusId))
			integrationName  = util.getIntegrationName(context, sBusId);

		IEFConfigUIUtil iefConfigUIUtil             = new IEFConfigUIUtil(context, integSessionData, integrationName);

		String isFeatureAllowed = integSessionData.isFeatureAllowedForIntegration(integrationName, featureName);
		if(!isFeatureAllowed.startsWith("true"))
		{
			errorMessage = isFeatureAllowed.substring(isFeatureAllowed.indexOf("|")+1, isFeatureAllowed.length());
			emxNavErrorObject.addMessage(errorMessage);
		}
		else
		{
			if(integrationName !=null && !integrationName.equals(""))
			{
				MCADGlobalConfigObject globalConfigObject = integSessionData.getGlobalConfigObject(integrationName,context);
				MCADServerGeneralUtil genUtil			  = new MCADServerGeneralUtil(context, globalConfigObject, integSessionData.getResourceBundle(), integSessionData.getGlobalCache());

				sBusId									  = genUtil.getValidObjctId(context, sBusId);
			}

			String funcPageName = MCADGlobalConfigObject.PAGE_NAVIGATOR;

			boolean isAdminTable = false;
			String selTable = "";
			if(integrationName !=null && !integrationName.equals("") && !integrationName.equals("null"))
			{
				if(tableName == null)
				{
					tableName = iefConfigUIUtil.getDefaultCustomTableName(integrationName, funcPageName, integSessionData);
					if(tableName.equals("Default"))
					{
						 selTable     = "DSCNavigate";
						 isAdminTable = true;
					}
					else
					{
						isAdminTable = iefConfigUIUtil.isSystemTable(context, tableName);
						selTable     = iefConfigUIUtil.getFilteredMatrixTableName(tableName,isAdminTable);
					}
				}
				else
				{
					if(tableName.equals("Default") || tableName.equals(integSessionData.getStringResource("mcadIntegration.Server.FieldName.DefaultTableName")))
					{
						 selTable     = "DSCNavigate";
						 isAdminTable = true;
					}
					else
					{
						 isAdminTable = iefConfigUIUtil.isSystemTable(context, tableName);
						 selTable     = iefConfigUIUtil.getFilteredMatrixTableName(tableName,isAdminTable);
					}
				}
			}
			else
			{
				tableName	 = "Default";
				selTable     = "DSCNavigate";
				isAdminTable = true;
			}

			try
			{
				//Page can have a table name passed in as well as a relationship name
				//If no table name, default table is used. If no tables defined, should not make it to this page
				//If no relationship name '*' (all) is assumed

				// see if we are reloading the table
				if (sTableName == null || sTableName.length() <= 0) {
					//FUN080585: Removal of deprecated function getDefaultVisuals
					Table tableGeneric = null; //context.getDefaultVisuals().getTables().getActive();
					if (tableGeneric != null) {
						sTableName = tableGeneric.getName();
					}
				}

				//if null, user may have no tables defined, or tables defined with none selected
				if (sTableName == null || ( sDefaultTableFlag != null && sDefaultTableFlag.equals("true") ) )
				{
					htmlTableWidth = 500;
					numberOfColumns = 18;
					sDefaultTableFlag = "true"; //take care of the case when there are no table defined
				}
				else
				{
					try
					{
						vectorColList = openTableWithCheckBox(context, sTableName);
						htmlTableWidth = getHtmlTableWidth(vectorColList);
						numberOfColumns = vectorColList.size();
					}
					catch(MatrixException ex)
					{
						if(ex.toString()!=null && (ex.toString().trim()).length()>0)
							emxNavErrorObject.addMessage(ex.toString().trim());

						//set the default values and proceed
						htmlTableWidth = 500;
						numberOfColumns = 18;
					}

				}
			}
			catch(Exception ex)
			{
				if(ex.toString()!=null && (ex.toString().trim()).length()>0)
					emxNavErrorObject.addMessage(ex.toString().trim());
			}

			String backId    = emxGetParameter(request, "backId");
			if(backId == null)
				backId = "";
			// Expecting input: BOID1|BOID2|BOID3...
			// Break up the string into individual BO ids to make an array.
			StringTokenizer tokBusIds = new StringTokenizer( backId, "|" );
			String sMenuName = "";

			try
			{
				sMenuName = getINFMenuName( request, context, sBusId );
			}
			catch (MatrixException ex)
			{
				if(ex.toString()!=null && (ex.toString().trim()).length()>0)
					emxNavErrorObject.addMessage(ex.toString().trim());

				//set the default values and proceed
				htmlTableWidth = 500; //400;
				numberOfColumns = 18;
			}

			String sBusObjectDetailsPageForPopup = "../common/emxTree.jsp?treeMenu=" + sMenuName;
			String sRelationshipName			 = emxGetParameter(request, "RelationshipName");
			String sToFrom						 = emxGetParameter(request, "toFrom");
			String sAllRelations				 = emxGetParameter(request, "AllRelations");
			String unFormattedRelationshipName = null;

			try
			{
				if (sRelationshipName != null){
					unFormattedRelationshipName = sRelationshipName;
					sRelationshipName = java.net.URLEncoder.encode( sRelationshipName);
					sRelationshipName = "&RelationshipName=" + sRelationshipName;
				} else{
					//make into equiv of Javascript null to be used later
					unFormattedRelationshipName = "*";
					sRelationshipName = "";
				}
			}
			catch( Exception ex )
			{
				unFormattedRelationshipName = "*";
				if(ex.toString()!=null && (ex.toString().trim()).length()>0)
					emxNavErrorObject.addMessage(ex.toString().trim());
			}

			if(sToFrom == null)
				sToFrom = "*";

			if(sAllRelations == null)
				sAllRelations = "true"; //"false";

			String sWSFilterName  = emxGetParameter(request, "WSFilter" );

			try
			{
				if( sWSFilterName != null )
					sWSFilterName = java.net.URLEncoder.encode( sWSFilterName);
				if( sTableName != null )
					sTableName = java.net.URLEncoder.encode( sTableName);

			}
			catch(Exception ex )
			{
				//do nothing
			}

			String sIsDefaultFilter  = emxGetParameter(request, "IsDefaultFilter" );

			String pageParameters = "objectId=" +sBusId + "&WSTable=" + sTableName  ;

			if( sWSFilterName != null && sWSFilterName.length() != 0 )
			{
				pageParameters += "&WSFilter=" + sWSFilterName + "&IsDefaultFilter=" + sIsDefaultFilter;
			}
		//	else
			{
				pageParameters += sRelationshipName + "&toFrom=" + sToFrom + "&AllRelations=" + sAllRelations;
			}
			//append the remaining common parameters
			pageParameters += "&TimeStamp=" + sTimeStamp + "&header=" + sHeaderString+"&suiteKey=" + suiteKey + "&table="+ sAdminTableName + "&funcPageName="+ funcPageName;

			if( sDefaultTableFlag!= null && sDefaultTableFlag.equals("true"))
			{
				pageParameters += "&IsDefaultTable=true";
			}

			if(sHelpMarker != null)
			{
				pageParameters += "&HelpMarker=" + sHelpMarker;
			}

			//append the popup window flag
			if( sPopupFlag!= null )
				pageParameters += "&popup=" + sPopupFlag;

			String sSelectedCues = emxGetParameter(request,"CueNames");
			String sSelectedTips = emxGetParameter(request,"TipNames");

		/*	try
			{
				if( sSelectedCues != null )
						sSelectedCues = java.net.URLEncoder.encode( sSelectedCues);
				if( sSelectedTips != null )
						sSelectedTips = java.net.URLEncoder.encode( sSelectedTips);
			}
			catch(Exception exception)
			{
			}

			if(sSelectedCues != null)
				session.setAttribute("selectedcues", sSelectedCues);
			if(sSelectedTips != null)
				session.setAttribute("selectedtips", sSelectedTips);
		*/

			pageParameters += "&CueNames=" + sSelectedCues + "&TipNames=" + sSelectedTips + "&tableName=" + MCADUrlUtil.hexEncode(tableName) + "&selTable=" + MCADUrlUtil.hexEncode(selTable) + "&isAdminTable=" + isAdminTable + "&integrationName=" + integrationName+ "&portalMode=" + portalMode;

			String sHeaderPage = "emxInfoNavigateHeader.jsp?" + pageParameters;
			String sDataLoaderPage = "emxInfoNavigateDataLoader.jsp?" + pageParameters;

			//append the sort key to the data loader page
			if( sSortKey!= null )
				sDataLoaderPage += "&SortKey=" + sSortKey;
			if( sSortDirection != null )
				sDataLoaderPage += "&sortDirection=" + sSortDirection;

			//Not an elegant way of getting the tool tips
			//but forced to do this here as these tags are not working when included between <>
			String sIconToolTip = i18nStringNowLocal("emxIEFDesignCenter.Tree.ClickIcon",request.getHeader("Accept-Language"));
			String sExpandToolTip = i18nStringNowLocal("emxIEFDesignCenter.Tree.ClickExpand",request.getHeader("Accept-Language"));

			if (sHeaderString != null)
				sHeaderString = parseTableHeader(application, context, sHeaderString, sBusId, suiteKey, request.getHeader("Accept-Language"));
		/*
			//~~~~~~~~~Set this Workspace Table to active mode~~~~~~~~~~~~~~
				if(sTableName.indexOf("::") == -1){
					MQLCommand mqlCmd = new MQLCommand();
					mqlCmd.open(context);
					mqlCmd.executeCommand(context, "modify table $1 $2;",sTableName.trim(),"active");
					mqlCmd.close(context);
				}
			//~~~~~~~~~~~~~~~~~~~~~~~End~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		*/
		%>

		<html>
		<head>

			<!--XSSOK-->
			<title><%=sHeaderString%></title>
<script language="JavaScript" src="../common/scripts/emxUIConstants.js" type="text/javascript"></script>
		<script language="javascript">

			//turn aspects of tree/table on or off
			//XSSOK
			var varViewRelArrows = "<%=viewRelArrows.toLowerCase()%>";
			var frametreeTableDataLoad = null;
			var ids = null;
			var frameName = "navigateFrame";

			//XSSOK
			var varViewIcons = "<%=viewIcons.toLowerCase()%>";
			//var varViewIcons = "";

			//object details page
			//XSSOK
			var varBusObjectDetailsPage = "<%=busObjectDetailsPage%>";

			//relationship details page
			//XSSOK
			var varRelDetailsPage = "<%=relObjectDetailsPage%>";

			//page which will load up children
			//XSSOK
			var varLoadChildrenPage = "<%=loadChildrenPage%>";

			//page which will toggle the expand status on the server
			//XSSOK
			var varToggleExpandPage = "<%=toggleExpandPage%>";

			//XSSOK
			var varIconToolTip = "<%=sIconToolTip%>";
			//XSSOK
			var varExpandToolTip = "<%=sExpandToolTip%>";

			//XSSOK
			var varTimeStamp = "<%=sTimeStamp%>";
			var varRowHeight = "20";

			//define classes used to style tree and table as elements of array
			// note: Stylesheet is written inline because of netscape issues with external stylesheets in multiple frames
			jsStyles = new Array();

			//background color of tables
			//XSSOK
			jsStyles[0] = "body { background-color: <%=PageBackgroundColor%>; }";

			//default font family,color,size
			jsStyles[1] = "body, th, td, p { font-family: verdana, helvetica, arial, sans-serif; font-size: 8pt; }";

			//XSSOK
			jsStyles[2] = "a { color: <%=PageFontColor%>; text-decoration: none; }";

			//bar heading across top of both frames
			//XSSOK
			jsStyles[3] = "td.heading { background-color: <%=HeadingBackgroundColor%>;font-family: verdana, helvetica, arial, sans-serif; font-size: 8pt;color:<%=HeadingFontColor%>;}";

			//text within cells not within links
			//XSSOK
			jsStyles[4] = "td.tableValue { font-family: verdana, helvetica, arial, sans-serif; font-size: 8pt;color:<%=PageFontColor%>}";

			//selected row/table backcolor
			<!--XSSOK-->
			jsStyles[5] = "tr.selected { background-color: <%=HighlightColor%>}";
			<!--XSSOK-->
			jsStyles[6] = "table.selected { background-color: <%=HighlightColor%>}";
			jsStyles[7] = "a:hover { }";
			jsStyles[8] = "td.root { }";
			jsStyles[9] = "td.root a { font-weight: bold; text-decoration: underline; }";
			jsStyles[10] = "td.root a:hover { }";
			<!--XSSOK-->
			jsStyles[11] = "td.line { background-color:<%=LineColor%> }";
			//table heading

			/* Table Header Appearance */
			jsStyles[12] =   "th { text-align: left; color: white; background-color: #336699; }"

			/* Table Header Link Appearance */
			jsStyles[13]    =  "th a { text-align: left; color: white; text-decoration: none;  }"
			jsStyles[14]    =  "th a:hover { text-decoration: underline; color: #ccffff; }";

			jsStyles[15]    = "th.heading { background-color: <%=HeadingBackgroundColor%>;}";
			jsStyles[16]    = "a.heading { background-color: <%=HeadingBackgroundColor%>;font-family: verdana, helvetica, arial, sans-serif; font-size: 8pt;color:<%=HeadingFontColor%>; }";

		</script>

		<script language="JavaScript" src="../integrations/scripts/MCADUtilMethods.js"></script>
		<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
		<script language="JavaScript" src="emxInfoNavigateTableUtil.js"></script>

		<script language="javascript" >

		<%
			int iSize = tokBusIds.countTokens();
		%>

			var arrBackIds = new Array(<%=iSize%>);
		<%
			int iInc = 0;
			while(tokBusIds.hasMoreTokens())
			{
				String sNxtBOId = tokBusIds.nextToken();
		%>
				arrBackIds[<%=iInc%>] = "<%=sNxtBOId%>";
		<%
				iInc++;
			}
		%>

			var table = new jsTable(<%=htmlTableWidth%>,<%=numberOfColumns%>);

			// Now passing array of BO Ids instead of just one.
			var tree = new jsTree(table, arrBackIds,"<%=sTableName%>","<%=unFormattedRelationshipName%>","<%=sToFrom%>" ,"<%=sAllRelations%>", "<%=sHeaderStringUnresolved%>", "<%=suiteKey%>", "<%=sDefaultTableFlag%>", "<%=sAdminTableName%>", "<%=sWSFilterName%>", "<%=sPopupFlag%>");

			//Sort the table on change of sort column.
			//this function has to be kept here as this is refered from tableFrame
			function sortNavigateTable( sortColumnName, sortDirection)
			{

				if(sortColumnName == "")
					return;

				var selectedTable = frametreeTableDataLoad.document.tableHeaderForm.workSpaceTable.options[frametreeTableDataLoad.document.tableHeaderForm.workSpaceTable.selectedIndex].value;

				var newPageURL;
				newPageURL = "emxInfoNavigateDataLoader.jsp?objectId=<%=sBusId%><%=sRelationshipName%>&busObjectDetailsPage=<%=sBusObjectDetailsPageForPopup%>&TimeStamp=<%=sTimeStamp%>&sortDirection=" + sortDirection + "&page=1";
				newPageURL += "&selTable=" + selectedTable + "&isAdminTable=<%=isAdminTable%>";

				if (sortDirection != null)
					newPageURL = newPageURL + "&sortDirection=" + sortDirection;

				//append the default table flag
				if( frametreeTableDataLoad.document.tableHeaderForm.workSpaceTable.selectedIndex == 0)
					  newPageURL += "&IsDefaultTable=true";

				//set the sort variables with the tree so that the expanding children will be presorted
				tree.reSortKey = sortColumnName;
				tree.sortDirection = sortDirection;

				//window.frames['treeTableDataLoad'].location= newPageURL;
				frametreeTableDataLoad.document.tableHeaderForm.reSortKey.value = sortColumnName;
				frametreeTableDataLoad.document.tableHeaderForm.WSTable.value = selectedTable;
				frametreeTableDataLoad.document.tableHeaderForm.action = newPageURL;
				frametreeTableDataLoad.document.tableHeaderForm.target = "treeTableDataLoad";
				frametreeTableDataLoad.document.tableHeaderForm.submit();
			}

			//cleanup session
			function cleanupSessionNavigate( timeStamp )
			{

				var url = "emxInfoNavigateCleanupSession.jsp?TimeStamp=" + timeStamp;
				//document.frames['treeTableHeader'].location= url;
				//open a hidden window beyond the window screen and call the cleanup session in that
				var winparams = "width=1,height=1,screenX=2500,screenY=2500,top=2500,left=2500,resizable=no";
				var win = window.open(url,"CleanUp",winparams);
				//no need to blur as the window is opened in out of screen coordinates
				//win.blur();
			}

			function displayLockUnLock(strURL)
			{
			   var targetFrame = findHiddenFrame(top, "listDisplay");
			   if(targetFrame != null)
			   {
				   targetFrame.location.href=strURL;

					//Update only the table body when the selection changes
					var newTable = frametreeTableDataLoad.document.tableHeaderForm.workSpaceTable.options[frametreeTableDataLoad.document.tableHeaderForm.workSpaceTable.selectedIndex].value;

					//Update the table name with the jstree
					tree.tableName = newTable;
					var arrBackId = tree.backId;

					var strBackIds = "";

					for(var i = 0; i < (arrBackId.length-1);i++)
					{
						strBackIds += arrBackId[i] + "|";
					}
					if(arrBackId.length > 0)
						strBackIds += arrBackId[i];

					var varToFilter = frametreeTableDataLoad.document.tableHeaderForm.toDirection.checked;
					var varFromFilter = frametreeTableDataLoad.document.tableHeaderForm.fromDirection.checked;
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
					frametreeTableDataLoad.document.tableHeaderForm.toFrom.value = varToFrom;
					var newPageURL = "emxInfoNavigateFS.jsp?reSortKey=name&backId=" + strBackIds + "&AllRelations=true&portalMode=<%=portalMode%>";
					if(frametreeTableDataLoad.document.tableHeaderForm.workSpaceTable.selectedIndex == 0)
						newPageURL += "&IsDefaultTable=true";
					if( frametreeTableDataLoad.document.tableHeaderForm.workSpaceFilter && frametreeTableDataLoad.document.tableHeaderForm.workSpaceFilter.selectedIndex == 0)
						newPageURL += "&IsDefaultFilter=true";
					frametreeTableDataLoad.document.tableHeaderForm.WSTable.value =  newTable;
					frametreeTableDataLoad.document.tableHeaderForm.action = newPageURL;
					frametreeTableDataLoad.document.tableHeaderForm.target = "_parent";
					frametreeTableDataLoad.document.tableHeaderForm.submit();
			   }
			}

			function reloadNavigateTable(arrBackId)
			{
				var strBackIds = "";

				for(var i = 0; i < (arrBackId.length-1);i++)
				{
					strBackIds += arrBackId[i] + "|";
				}
				if(arrBackId.length > 0)
					strBackIds += arrBackId[i];

				var varToFilter		= frametreeTableDataLoad.document.tableHeaderForm.toDirection.checked;
				var varFromFilter	= frametreeTableDataLoad.document.tableHeaderForm.fromDirection.checked;
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
				frametreeTableDataLoad.document.tableHeaderForm.toFrom.value = varToFrom;

				//table id is hexEncoded
				var tableName = frametreeTableDataLoad.document.tableHeaderForm.workSpaceTable.options[frametreeTableDataLoad.document.tableHeaderForm.workSpaceTable.selectedIndex].id;
				frametreeTableDataLoad.document.tableHeaderForm.TableName.value = tableName;

				var newPageURL = "emxInfoNavigateFS.jsp?reSortKey=name&backId=" + strBackIds + "&AllRelations=true&portalMode=<%=portalMode%>";

				if(frametreeTableDataLoad.document.tableHeaderForm.workSpaceTable.selectedIndex == 0)
					newPageURL += "&IsDefaultTable=true";
				if( frametreeTableDataLoad.document.tableHeaderForm.workSpaceFilter && frametreeTableDataLoad.document.tableHeaderForm.workSpaceFilter.selectedIndex == 0)
					newPageURL += "&IsDefaultFilter=true";

				frametreeTableDataLoad.document.tableHeaderForm.action = newPageURL;
				frametreeTableDataLoad.document.tableHeaderForm.target = "_parent";
				frametreeTableDataLoad.document.tableHeaderForm.submit();
				frametreeTableDataLoad.focus();
			}

			function setListDisplayAsActiveFrame()
			{
				var activeFrame = '<%=activeFrame%>' + "" ;
				var integrationFrame = getIntegrationFrame(this);
				integrationFrame.setActiveRefreshFrame(window.frames[activeFrame]);
				frametreeTableDataLoad = findFrame(this,"treeTableDataLoad");
			}

		</script>

		</head>

		<frameset rows="110,*,0,0,0" frameborder="no" border=1 onUnload="javascript:cleanupSessionNavigate( '<%=sTimeStamp%>');" onLoad="javascript:setListDisplayAsActiveFrame()">
			<frame name="listHead" src="<%=sHeaderPage%>" scrolling="no" marginwidth=0 marginheight=0>
			<frameset cols="250,*" frameborder="yes" border=1  framespacing=2 >
				<frame name="folderDisplay" src="emxBlank.jsp?showTimer=true" marginwidth=0 marginheight=0>
				<frame name="listDisplay" src="emxBlank.jsp?showTimer=true" marginwidth=0 marginheight=0 scrolling="yes">
			</frameset>

			<frame name="treeTableDataLoad" src="<%=sDataLoaderPage%>" scrolling="no">
			<frame name="listFoot" src="emxBlank.jsp" marginheight="0" marginwidth="0">
			<frame name="hiddenTableFrame" src="emxBlank.jsp" marginheight="0" marginwidth="0"/>
		</frameset>

		</html>

	<%
	} //end of feature allowed check
}// end of integSessionData null check
%>
<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
