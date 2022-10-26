<%--  emxInfoNavigatePrint.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
    $Archive: /InfoCentral/src/infocentral/emxInfoNavigatePrint.jsp $
    $Revision: 1.3.1.3$
    $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxInfoNavigatePrint.jsp $
 * 
 * *****************  Version 9  *****************
 * User: Rahulp       Date: 1/16/03    Time: 3:01p
 * Updated in $/InfoCentral/src/infocentral
 * 
 *******************************************
--%>

<%@include file= "../common/emxNavigatorInclude.inc"%>
<%@include file= "emxInfoTableInclude.inc"%>
<%@include file= "emxInfoTreeTableUtil.inc"%>

<%@include file= "../common/emxNavigatorTopErrorInclude.inc"%>

<%@ page import="com.matrixone.MCADIntegration.uicomponents.util.*,java.io.*"%>
<jsp:useBean id="emxTableObject" class="com.matrixone.apps.framework.ui.UITable" scope="request"/>
<link rel="stylesheet" href="../common/styles/emxUIDefaultPF.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIListPF.css" type="text/css">
<link rel="stylesheet" href="../emxUITemp.css" type="text/css">

<%

try
{
	String featureName		= MCADGlobalConfigObject.FEATURE_NAVIGATE;
	String isFeatureAllowed = "";

	//extract the request parameters
	String sTimeStamp = emxGetParameter(request, "TimeStamp");
	String header = emxGetParameter(request, "header");
	String objectId = emxGetParameter(request, "objectId");
	String suiteKey = emxGetParameter(request, "suiteKey");
	String sComboNewTableName = emxGetParameter(request, "WSTable");
	String sIsDefaultTable = emxGetParameter(request, "IsDefaultTable" );
	String sAdminTable = emxGetParameter(request, "table");
	String sortColumnName = emxGetParameter(request, "SortKey");
	String sortDirection = emxGetParameter(request, "sortDirection");
	String sRelationshipName = emxGetParameter(request,"RelationshipName");

	String integrationName = "";
	MCADGlobalConfigObject globalConfigObject = null;
	MCADMxUtil util							  = null;
	IEFConfigUIUtil iefConfigUIUtil			  = null; 
	MCADIntegrationSessionData integSessionData	= (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");

	if(integSessionData != null)
	{
		util				= new MCADMxUtil(integSessionData.getClonedContext(session), integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
		integrationName		= util.getIntegrationName(integSessionData.getClonedContext(session),objectId);
		
		isFeatureAllowed		= integSessionData.isFeatureAllowedForIntegration(integrationName, featureName);
		if(isFeatureAllowed.startsWith("true"))
			globalConfigObject  = integSessionData.getGlobalConfigObject(integrationName,integSessionData.getClonedContext(session));
		else
			emxNavErrorObject.addMessage(isFeatureAllowed.substring(isFeatureAllowed.indexOf("|")+1, isFeatureAllowed.length()));

		iefConfigUIUtil     = new IEFConfigUIUtil(integSessionData.getClonedContext(session),integSessionData, integrationName);
	}

	//To find the table selected from WSTables combobox is admin table or ws table.
	boolean bAdminTableSelected = false;
	if(sComboNewTableName != null && iefConfigUIUtil != null)
	{
		Vector adminTableNames = iefConfigUIUtil.getAdminTableNames(globalConfigObject); 
		if(adminTableNames != null && adminTableNames.size() > 0)
		{
			bAdminTableSelected = adminTableNames.contains(sComboNewTableName);
		}
	}

	//default sort column name
	if( sortColumnName == null )
		sortColumnName =  "";

	if (sortDirection == null)
		sortDirection = "ascending";

	//get the table heading data
	Vector vectorColList = null;
    boolean isAdminTable=false;
	//if null, user may have no tables defined, or tables defined with none selected
	if (bAdminTableSelected == true || ( sIsDefaultTable != null && sIsDefaultTable.equals("true") ) )
	{
		Vector userRoleList = (Vector)session.getValue("emxRoleList");
		if(bAdminTableSelected == true)
			sAdminTable = sComboNewTableName;

		vectorColList = openAdminTable( context, application, request, sAdminTable, emxTableObject, userRoleList) ;
		isAdminTable=true;
	}
	else{
		try
		{
			vectorColList = openTableWithCheckBox(context, sComboNewTableName);
		}
		catch(MatrixException ex)
		{
			if(ex.toString()!=null && (ex.toString().trim()).length()>0)
				emxNavErrorObject.addMessage(ex.toString().trim());

			//to avoid null pointer exception & to continue to load the tree alteast
			vectorColList = new Vector();
		}
	}

	//get the table heading
	String sTableHeading = getNavigateTableHeadings(vectorColList,request,false,sortDirection, sortColumnName, true);

	// define select values for doing expand select on the business object
	SelectList selListGeneric = new SelectList();
	selListGeneric.addName();
	selListGeneric.addType();
	selListGeneric.addRevision();
	selListGeneric.addId();

	SelectList selListGenericRels = new SelectList();
	selListGenericRels.addId();

	BusinessObject boGeneric = new BusinessObject(objectId);
	boGeneric.open(context);

	// load the table expressions
	loadTableExpressions(vectorColList, selListGeneric, selListGenericRels);

	//Do expand select on the business object to get the root node data
	ExpansionWithSelect  expWithSelectData = util.expandSelectBusObject(context,boGeneric, sRelationshipName, "*", selListGeneric, selListGenericRels, true, true, (short)1, "", "", (short)0, false, false);

	boGeneric.close(context);

	//get root info.
	Hashtable hashTableGeneric = expWithSelectData.getRootData();

	String sType = (String)hashTableGeneric.get("type");
	String sName = (String)hashTableGeneric.get("name");
	//Internationalize the type name
	sType = i18nNow.getMXI18NString(sType.trim(), "", request.getHeader("Accept-Language"),"Type");

	String sRevision = (String)hashTableGeneric.get("revision");

	//get the navigate data from the session
	MapList mapNavigateList = (MapList)(session.getValue("IEF_INFNavigateMap"+ sTimeStamp));
	HashMap mapNavigateData = (HashMap)(session.getValue("IEF_INFNavigateData"+ sTimeStamp));

	// Show the header if the mode is "PrinterFriendly"
	if (header != null)
		header = parseTableHeader(application, context, header, objectId, suiteKey, request.getHeader("Accept-Language"));

	String userName = (new com.matrixone.servlet.FrameworkServlet().getFrameContext(session)).getUser();
	java.util.Date currentDateObj = new java.util.Date(System.currentTimeMillis());
	String currentTime = currentDateObj.toString();

	//Display a headerstring ...with header & user name & time
	String sTreeHeading = i18nStringNowLocal("emxIEFDesignCenter.Tree.Heading", request.getHeader("Accept-Language"));
%>
	<html>
	<!--XSSOK-->
	<title><%=header%></title>
	<body>
	<hr noshade>
	<table border="0" width="100%" cellspacing="2" cellpadding="4">
	<tr>
	<!--XSSOK-->
    <td class="pageHeader" width="100%"><%=header%></td>
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

	<table width="100%" cellspacing="2" cellpadding="4" >
	
	<tr><th class=heading nowrap align=left>&nbsp;<%=sTreeHeading%>&nbsp;<img src=images/utilSpace.gif width=6 height=16 >&nbsp;</th>
	<!--XSSOK-->
	<%=sTableHeading%>
	</tr>
	<tr><img src=images/utilSpace.gif width=6 height=16 ></tr>
    <!--XSSOK-->
	<tr class='listCell'><td> <%=sName%> </td>

<%
	//print the root node data
    //Function FUN080585 : Removal of Cue, Tips and Views
	String sRootNodeData = loadTableValues(vectorColList, hashTableGeneric, null,request,context,isAdminTable,sComboNewTableName, true);
	sRootNodeData = removeAnchorTags( sRootNodeData );
	sRootNodeData = removeCueStyleSheet( sRootNodeData );
	out.println(sRootNodeData + "</tr>");
	//call the function which prints the navigate child data
	printNavigatePage(mapNavigateList, mapNavigateData, out );
}
catch(Exception ex)
{
	//Log the exception
	if(ex.toString()!=null && (ex.toString().trim()).length()>0)
		emxNavErrorObject.addMessage(ex.toString().trim());
}

%>

</table>
</body>

<%!
	//function to print the navigate page
	static public void printNavigatePage( MapList mapNavigateList, HashMap mapNavigateData, JspWriter jspwriter) throws IOException
	{
		//populate the data
		for (int i = 0; i < mapNavigateList.size(); i++)
		{
			//Extract all the properties of the node ( a row in tree or table )
			IEF_INFNavigateMap nodeMap = ((IEF_INFNavigateMap)mapNavigateList.get(i));
			String sNodeId = (String)(nodeMap.get("id"));
			boolean boolCanHaveChildren = nodeMap.getCanHaveChildrenStatus();
			String sRelId = (String)(nodeMap.get("id[connection]"));
			IEF_INFNavigateData nodeData = (IEF_INFNavigateData)mapNavigateData.get( sNodeId + "|" +sRelId);
			ArrayList nodeDataList = nodeData.getNodeData();
			//extract the values from the array list
			String sNodeName = (String)nodeDataList.get(0);
			//String sNodeRevision= (String)nodeDataList.get(1);
			//String sNodeType = (String)nodeDataList.get(2);
			String sNodeBusId  =(String)nodeDataList.get(3);
			String sNodeRelWithSelName  = (String)nodeDataList.get(4);
			String sNodeArrowDir  = (String)nodeDataList.get(5);
			String sNodeTableData  = (String)nodeDataList.get(6);
			sNodeTableData = modifyCheckboxInputTags(sNodeTableData);
			String strNodeNameID = "root_" + i;
			nodeMap.put("NodeID", strNodeNameID);
		//  before adding the data remove the onMouseOver events from the tableData
			sNodeTableData = removeAnchorTags( sNodeTableData );
			sNodeTableData = removeCueStyleSheet( sNodeTableData );
			jspwriter.println( "<tr class='listCell'><td>" +  sNodeName + "&nbsp;" + "</td>" + sNodeTableData + "</tr>");

			//if the node has children and if it is expanded state print the children too
			if( nodeMap.hasChildren() && nodeMap.getExpandStatus() )
			{
				printNavigatePage( nodeMap.getChildMap(), mapNavigateData , jspwriter);
			}

		} //end for

	}

	//function to replace the content in the anchor tags
	static public String removeAnchorTags( String sNodeTableData)
	{
		//find all the instances of "<a" tag and remove the content inside that tag
		String returnString = sNodeTableData ;
		int intAnchorBeginIndex = sNodeTableData.indexOf("<a");
		int intAnchorEndIndex = 0;
		//loop through the string for all instances
		while( intAnchorBeginIndex !=-1)
		{			
			//form the string by removing the contents in the anchor tag
			String sBeforeAnchor = returnString.substring(0, intAnchorBeginIndex);
			intAnchorEndIndex = returnString.indexOf("</a>", intAnchorBeginIndex);
			String anchorValue = returnString.substring(intAnchorBeginIndex,intAnchorEndIndex+1);
			int anchorImgStartIndex = anchorValue.indexOf("<img");
			int anchorImgEndIndex = anchorValue.indexOf(">", anchorImgStartIndex);
			String imgValue = "";
			if(anchorImgStartIndex!=-1 && anchorImgStartIndex<anchorImgEndIndex)
				imgValue = anchorValue.substring(anchorImgStartIndex, anchorImgEndIndex+1);
			if(imgValue != null && imgValue.length() > 0)
				imgValue = replaceString(imgValue, "\\", "");

			int startIndex = anchorValue.lastIndexOf('>');
			int endIndex = anchorValue.lastIndexOf('<');
			String value="";
            if(startIndex!=-1 && startIndex<endIndex)
				value = anchorValue.substring(startIndex+1,endIndex);
			if(imgValue != null && imgValue.length() > 0)
				value = imgValue;

			String sAfterAnchor = returnString.substring(intAnchorEndIndex+4, 
				returnString.length());

			returnString = sBeforeAnchor + value+sAfterAnchor;
			intAnchorBeginIndex = returnString.indexOf("<a", intAnchorBeginIndex + 1);
        }//end of while
		//return the formed string
        return returnString;
    }
	
	//function to remove the cue style sheet
	static public String removeCueStyleSheet(String sNodeTableData)
	{
		//find all the instances of "<a" tag and remove the content inside that tag
		String returnString = sNodeTableData ;
		int intCueStyleSheetBeginIndex = sNodeTableData.indexOf("<STYLE TYPE='text/css'> .cueClass");
		int intCueStyleSheetEndIndex = 0;
		//loop through the string for all instances
		while( intCueStyleSheetBeginIndex !=-1)
		{
			
			//form the string by removing the contents in the CueStyleSheet tag
			String sBeforeCueStyleSheet = returnString.substring(0, intCueStyleSheetBeginIndex);
			intCueStyleSheetEndIndex = returnString.indexOf("}</style>", intCueStyleSheetBeginIndex);
			String sAfterCueStyleSheet = returnString.substring(intCueStyleSheetEndIndex+9);
			returnString = sBeforeCueStyleSheet + sAfterCueStyleSheet;
			intCueStyleSheetBeginIndex = returnString.indexOf("<STYLE TYPE='text/css'> .cueClass", intCueStyleSheetEndIndex);
        }//end of while
		
		//return the formed string
        return returnString;        
	}

	//function to replace the content in the anchor tags
	static public String modifyCheckboxInputTags( String sNodeTableData)
	{
		//find all the instances of "<input" tag and modify the img content inside that tag
		String returnString = sNodeTableData ;
		int intBeginIndex = sNodeTableData.indexOf("<input");
		int intEndIndex = 0;
		
		//form the string by removing the contents in the input tag
		String sBeforeInput = returnString.substring(0, intBeginIndex);
		intEndIndex = returnString.indexOf(">", intBeginIndex);

		String sValue = returnString.substring(intBeginIndex,intEndIndex+1);
		int startIndex = sValue.lastIndexOf('>');
		String value="";

		String imgValue = "<img src='images/iconCheckoffdisabled.gif'>";
		value = imgValue;

		String sAfterInput = returnString.substring(intEndIndex+6, 
			returnString.length());

		returnString = sBeforeInput + value + sAfterInput;

        return returnString;
    }


%>

<%@include file= "../common/emxNavigatorBottomErrorInclude.inc"%>

</html>
