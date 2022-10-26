<%--  emxInfoNavigateDataLoader.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoNavigateDataLoader.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxInfoNavigateDataLoader.jsp $
 * 
 * *****************  Version 44  *****************
 * User: Rahulp       Date: 10/02/03   Time: 15:59
 * Updated in $/InfoCentral/src/infocentral
 * 
 * ***********************************************
 *
--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<html>

<!-- IEF imports Start -->
<%@ page import = "matrix.db.*, matrix.util.*,com.matrixone.servlet.*,java.util.*" %>
<%@ page import = "com.matrixone.MCADIntegration.server.beans.*,com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.*" %>
<!-- IEF imports End -->

<%@include file= "../common/emxNavigatorInclude.inc"%>
<%@include file= "emxInfoTableInclude.inc"%>
<%@include file= "emxInfoTreeTableUtil.inc"%>
<%@include file= "../common/emxNavigatorTopErrorInclude.inc"%>

<%@ page import="com.matrixone.MCADIntegration.uicomponents.beans.*" %>

<jsp:useBean id="emxTableObject" class="com.matrixone.apps.framework.ui.UITable" scope="request"/>

<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUIConstants.js"></script>

<%--CueTip-Start--%>
<%@ page import="com.matrixone.MCADIntegration.uicomponents.util.*"%>
<%@ page import = "java.awt.Color"%>
<%--CueTip-End--%>
<!-- 16/2/2004 changed to enable progress animation/status msg-->
<script language="Javascript">
	top.window.status = "Building tree please wait...";
  var progressBarCheck = 1;
  function removeProgressBar(){
    progressBarCheck++;
    if (progressBarCheck < 10){
      if (parent.frames[0].document.progress){
        parent.frames[0].document.progress.src = "../common/images/utilSpacer.gif";
      }else{
        setTimeout("removeProgressBar()",500);
      }
    }
    return true;
	}
</script>
<!--End of change on 1/2/2004 -->
<!--Function FUN080585 : Removal of Cue, Tips and Views-->
<%
String timeStamp = null;

try
{	
	String featureName		= MCADGlobalConfigObject.FEATURE_NAVIGATE;
	String isFeatureAllowed = "";
	//Get all the required parameters
	String objectId			= emxGetParameter(request, "objectId");
	String newTableName		= emxGetParameter(request, "selTable");
	String reSortKey		= emxGetParameter(request, "reSortKey");
	//when reSoryKey is not null that means this is used for sorting 
	//in that case get the wstable name without decode
	if( reSortKey != null )
		newTableName = emxGetParameter(request, "selTable");
    if(reSortKey == null && newTableName != null)
	    newTableName = MCADUrlUtil.hexDecode(newTableName);
	
	String sortColumnName	= emxGetParameter(request, "SortKey");
	String sortDirection	= emxGetParameter(request, "sortDirection");
	String sIsDefaultTable	= emxGetParameter(request, "IsDefaultTable" );
	String sAdminTable		= emxGetParameter(request, "selTable");
    if(reSortKey == null && sAdminTable != null)
    {
        sAdminTable = MCADUrlUtil.hexDecode(sAdminTable);
    }
	String isAdmTable = emxGetParameter(request, "isAdminTable");

	//Extract the filters ( from/to ) check box values
	String toFrom				= emxGetParameter(request,"toFrom");
	String sRelationshipName	= emxGetParameter(request,"RelationshipName");
	String sAllRelationsFlag	= emxGetParameter(request, "AllRelations");
	String sWSFilterName		= emxGetParameter(request,"WSFilter");
	String sIsDefaultFilter		= emxGetParameter(request, "IsDefaultFilter" );
	String sTreeHeading			= i18nStringNowLocal("emxIEFDesignCenter.Tree.Heading", request.getHeader("Accept-Language"));

	//~~~~~~~~~~~~~~Cue-Tip Start~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	//Function FUN080585: Removal of Cues, Tips
	//Start read-only transaction for better performance
	context.start(true);
	
	//~~~~~~~~~~~~~~Cue-Tip End~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	//if "All" is choosen in the relation combo ..then the string to be passed is "*"
	if (sRelationshipName == null || ( sAllRelationsFlag != null && sAllRelationsFlag.compareTo("true") == 0 ) )
	{
		sRelationshipName = "*";
	}

	if(toFrom==null|| toFrom.equals("null"))
		toFrom="*";
	boolean bExpandTo     = false;
	boolean bExpandFrom   = false;
    
	if(toFrom.equals("to"))
	{
		bExpandTo     = true;
	}
    else if(toFrom.equals("from"))
	{
		bExpandFrom   = true;
	}
    else if(toFrom.equals("*"))
	{ 
		bExpandFrom   = true;
		bExpandTo   = true;
	}

	//default sort column name
	if( sortColumnName == null )
		sortColumnName =  "";

	if (sortDirection == null)
		sortDirection = "ascending";

	//resort key is used to decide whether the the sorting is done or the page is getting loaded for the first time
	//hence this is also required along with the sort column name
	if (reSortKey != null && reSortKey.length() > 0)
		sortColumnName = reSortKey;

	//Extract the relation data from the business object

	String sBusId         = objectId;
	String sIcons         = emxGetParameter(request, "icons");

	String integrationName = "";
	MCADGlobalConfigObject globalConfigObject = null;
	MCADMxUtil util							  = null;

	MCADIntegrationSessionData integSessionData	= (MCADIntegrationSessionData) session.getAttribute(MCADServerSettings.MCAD_INTEGRATION_SESSION_DATA_OBJECT);
	
	if(integSessionData != null)
	{
		util					= new MCADMxUtil(integSessionData.getClonedContext(session), integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
		integrationName			= util.getIntegrationName(integSessionData.getClonedContext(session),sBusId);
		
		isFeatureAllowed		= integSessionData.isFeatureAllowedForIntegration(integrationName, featureName);
		if(isFeatureAllowed.startsWith("true"))
			globalConfigObject  = integSessionData.getGlobalConfigObject(integrationName,integSessionData.getClonedContext(session));			
		else
			emxNavErrorObject.addMessage(isFeatureAllowed.substring(isFeatureAllowed.indexOf("|")+1, isFeatureAllowed.length()));
	}

	if(null != globalConfigObject)
	{
		Hashtable relsAndEnds = globalConfigObject.getRelationshipsOfClass(MCADAppletServletProtocol.ASSEMBLY_LIKE);
		if(relsAndEnds.size() > 0)
		{
			sRelationshipName  = "";
			Enumeration relnEnum = relsAndEnds.keys();
			while(relnEnum.hasMoreElements())
			{
				sRelationshipName = sRelationshipName + (String)relnEnum.nextElement()
				+ ",";
			}
		}
	}
	else if(isFeatureAllowed.startsWith("true"))
	{
		ResourceBundle iefProperties = ResourceBundle.getBundle("ief");
		sRelationshipName			 = iefProperties.getString("mcadIntegration.Server.NavigateRelationships");
	}

	BusinessObject boGeneric = new BusinessObject(sBusId);
	boGeneric.open(context);

	String sBOId = boGeneric.getObjectId();
	String sBOType = boGeneric.getTypeName();
	String sBOName = boGeneric.getName();
	String sBORevision = boGeneric.getRevision();

	boolean bDrawIcons = false;

	//toggle icons on/off
	if (sIcons != null) {
		if (sIcons.equalsIgnoreCase("off")) {
			bDrawIcons = false;
		} else {
			bDrawIcons = true;
		}
	}

	// define select values
	SelectList selListGeneric = new SelectList();
	selListGeneric.addName();
	selListGeneric.addType();
	selListGeneric.addRevision();
	selListGeneric.addId();

	SelectList selListGenericRels = new SelectList();
	selListGenericRels.addId();

	Vector vectorColList = null;
	int htmlTableWidth = 0;
	int objectColWidth = 0;
	int totalHeadings = 0;
	boolean isAdminTable=Boolean.valueOf(isAdmTable).booleanValue();

	//if null, user may have no tables defined, or tables defined with none selected
	if (isAdmTable != null && isAdmTable.equals("true") )
	{
		Vector userRoleList = (Vector)session.getValue("emxRoleList");
		vectorColList = openAdminTable( context, application, request, sAdminTable, emxTableObject, userRoleList) ;
		htmlTableWidth = 250; //getHtmlTableWidth(vectorColList);
		objectColWidth = 250;
		totalHeadings = vectorColList.size();
	}
	else{
		try
		{
			vectorColList = openTableWithCheckBox(context, newTableName);
		}
		catch(MatrixException ex)
		{
			if(ex.toString()!=null && (ex.toString().trim()).length()>0)
				emxNavErrorObject.addMessage(ex.toString().trim());

			//to avoid null pointer exception & to continue to load the tree alteast
			vectorColList = new Vector();
		}
		htmlTableWidth = getHtmlTableWidth(vectorColList);
		objectColWidth = 250;
		totalHeadings = vectorColList.size();
	}
	// load the table expressions
	loadTableExpressions(vectorColList, selListGeneric, selListGenericRels);

	//expand the BO 1 levels to get the objects at the current level.
	ExpansionWithSelect  expWithSelectData = util.expandSelectBusObject(context,boGeneric, sRelationshipName, "*", selListGeneric, selListGenericRels, bExpandTo,bExpandFrom, (short)1, "", "", (short)0, false, false);

	boGeneric.close(context);

	//get root info.
	Hashtable hashTableGeneric = expWithSelectData.getRootData();

	String sType = (String)hashTableGeneric.get("type");
	String sName = (String)hashTableGeneric.get("name");
	
	//Internationalize the type name
	String sTypeIntl	= i18nNow.getMXI18NString(sType.trim(), "", request.getHeader("Accept-Language"),"Type");
	String sRevision	= (String)hashTableGeneric.get("revision");
	String sId			= (String)hashTableGeneric.get("id");

    String sMenuName = getINFMenuName( request, context, sId );
	
	RelationshipWithSelectItr relWithSelItrGeneric = null;
	RelationshipWithSelectList relWithSelListGeneric = expWithSelectData.getRelationships();
	// read the default table list, and look this table up

	//Visuals visualsDefault = null; //context.getDefaultVisuals();//FUN080585: Removal of deprecated function getDefaultVisuals	
	//TableItr tableItrGeneric = new TableItr(visualsDefault.getTables());

	String sTableHeading = getNavigateTableHeadings(vectorColList,request,false,sortDirection, sortColumnName, false);

	//Implementing WS Filters
	//Get the filtered relation IDs and then later filter out the main list obtained through expandselect
	//using these relation IDs
	//Not a very elegant approach but to use the rest of the functionality as it is this is the best possible approach
	//finally when MQL is used inplace of ADK all these things will go

	Vector vecRelID = new Vector();
	MQLCommand mqlCommand = null;
	String sRoleName = sWSFilterName.substring(0,sWSFilterName.indexOf("::"));
	try
	{
		if( sWSFilterName != null )
		{
			mqlCommand = new MQLCommand();
			String query = "";
			boolean ret = false;
			if(sWSFilterName.indexOf("::") != -1){
				sWSFilterName = sWSFilterName.substring(sWSFilterName.indexOf("::") + 2);
				//command = "set workspace user '"+ sRoleName +"'; evaluate  Table '"+ tableName +"'"+idStr + " dump |";        	
				ret = mqlCommand.executeCommand(context, "set workspace user $1; expand bus $2 filter $3 $4 dump $5 select rel $6",sRoleName,objectId,"terse",sWSFilterName,"id","|");
			}else{
				ret = mqlCommand.executeCommand(context, "expand bus $2 filter $3 $4 dump $5 select rel $6",sRoleName,objectId,"terse",sWSFilterName,"id","|");
			} // End of if(sWSFilterName.indexOf("::") != -1)    
			
			if(ret)
			{
				String objects = mqlCommand.getResult();
				StringTokenizer tokenizer = new StringTokenizer(objects , "\n");
				int tokenCount = tokenizer.countTokens();
				for(int i = 0 ; i<tokenCount; i++)
				{
					StringTokenizer tokenizer1 = new StringTokenizer(tokenizer.nextToken(), "|");
					String relid ="";
					int index=0;
					while(tokenizer1.hasMoreTokens())
					{
						String token = tokenizer1.nextToken();
						if( index==4)
							vecRelID.add(token);
						
						index++;
					}
					
				}
			}
		}
	}
	catch(Exception ex)
	{
		if(ex.toString()!=null && (ex.toString().trim()).length()>0)
			emxNavErrorObject.addMessage(ex.toString().trim());
	}

	//Populate the tree table data

%>

<script language="javascript">

	//set the mouse pointer to busy
	//parent.setMousePointer();

<%
	//If the user is sorting the elements then get the object list from the session
	//sort them and then populate the tree, table data
	//otherwise extract the list from the business object
	// timeStamp to handle the multiple windows etc
	timeStamp = emxGetParameter(request, "TimeStamp");
	//~~~CueTip-Start~~~
	
	//Function FUN080585: Removal of Cues, Tips

	//~~~CueTip-End~~~
    
	//check if the page is getting re sorted or loaded for the first time
	if(reSortKey == null )
	{
	//~~~CueTip-Start~~~	
	//Function FUN080585: Removal of Cues, Tips
		//~~~~~~~~~~~~~~~~~~~~~~~~CueTip-End~~~~~~~~~~~~~~~~~~~~~~~~

		MapList mapNavigateList;
		HashMap mapNavigateData;
		//Create the root elements
%>
 	    var rowHeight = parent.varRowHeight;
		var tree = parent.tree;		
		//XSSOK
		//Function FUN080585: Removal of Cues, Tips
		tree.createRoot("&nbsp;<%=sName%>&nbsp;&nbsp;&nbsp;", "<%=drawIconInNavigate(context, application, sType)%>", null, null, "<%=sId%>", "<%=sId%>" , true, "<%=sMenuName%>");		
        //XSSOK			
		parent.setHeading("<tr height="+rowHeight+"><td class=heading nowrap align=left>&nbsp;<%=sTreeHeading%>&nbsp;<img src=images/utilSpace.gif  >&nbsp;</td></tr>",tree);
		var table = parent.table;
		//XSSOK
		//Function FUN080585: Removal of Cues, Tips
		table.createRoot("<td ><img src=images/utilSpace.gif  >&nbsp;</td><%=loadTableValues(vectorColList, hashTableGeneric, null,request,context,isAdminTable,newTableName,false)%>", "<%=sId%>","<%=sId%>", true);
		//XSSOK
		parent.setHeading("<td class=heading nowrap align=left><img src=images/utilSpace.gif >&nbsp;<%=sTableHeading%></td>",table);
<%
		//Store the lists in the session
		mapNavigateList = new MapList();
		session.putValue("IEF_INFNavigateMap"+ timeStamp, mapNavigateList);
		mapNavigateData = new HashMap();
		session.putValue("IEF_INFNavigateData"+ timeStamp, mapNavigateData);


		boolean boolChildsExists = false;
		//~~~CueTip-Start~~~
		int arrCounter = 0;
		//~~~CueTip-End~~~

		//if root has data and the relationship list contains some objects
		if(hashTableGeneric.size() >0 && relWithSelListGeneric.size() > 0 )  
		{
			relWithSelItrGeneric = new RelationshipWithSelectItr(relWithSelListGeneric);
			Vector vectAllRelationships = new Vector();
			//create vector with all relWithSelect objects
			//we'll use this object to look ahead and check for child objects
			while (relWithSelItrGeneric.next()) 
			{
				RelationshipWithSelect relWithSelObject = relWithSelItrGeneric.obj();
				vectAllRelationships.add(relWithSelObject);
				//~~~CueTip-Start~~~
				if(relWithSelItrGeneric.obj().getLevel() == 1){
					arrCounter++;
				}
				//~~~CueTip-End~~~
			}

		//~~~CueTip-Start~~~
		//Function FUN080585: Removal of Cues, Tips
			//~~~~~~~~~~~~~~~~~~~~~~~~CueTip-End~~~~~~~~~~~~~~~~~~~~~~~~

			relWithSelItrGeneric.reset();
			String sRowColor = "odd";
			int iCount = 0;
			String sFillerImage = "";
			String sArrowDir = "";
			String sRelWithSelName = "";
			String sTableValues = "";
			boolean bHasChildren = true;
			RelationshipWithSelect relWithSelGeneric = null;
			int iCurLevel = 0;
			int k=0;
			//Function FUN080585: Removal of Cues, Tips
			
			//added by nagesh
			int q=1;
			int relationshipCount = 0;
			while (relWithSelItrGeneric.next()) 
			{
				relWithSelGeneric = relWithSelItrGeneric.obj();
				
				//create front of display
				iCurLevel = relWithSelGeneric.getLevel();
				if (iCurLevel == 1)
				{
				  //Get the relation ID
				  Hashtable hashTableRel2 = relWithSelGeneric.getRelationshipData();
				  String relID = (String)hashTableRel2.get("id");

				  //when filters are applied check if this relation is filtered out
				  if( sWSFilterName != null )
				  {
				    if( !vecRelID.contains(relID) )
						continue;
				  }
				  //once we reach here means at least one child exists
				  boolChildsExists = true;
				  //check if this object has children
//				  bHasChildren = hasChildren(iCount, relWithSelGeneric, vectAllRelationships);
				  Hashtable hashTableRel = relWithSelGeneric.getTargetData();
				  sType = (String)hashTableRel.get("type");
				  sName = (String)hashTableRel.get("name");
				  sRevision = (String)hashTableRel.get("revision");
   				  sId = (String)hashTableRel.get("id");
					hashTableRel.put("id[connection]",relID);
				  sRelWithSelName = relWithSelGeneric.getName();
				//~~~~~~Cue-Tip Start~~~~~~~~~~~~~~~~~~
				//Function FUN080585: Removal of Cues, Tips
				//~~~~~~~~~~~~~~~~~~~~~~~~CueTip-End~~~~~~~~~~~~~~~~~~~~~~~~
				  
				  //Function FUN080585: Removal of Cues, Tips						
				  sTableValues = loadTableValues(vectorColList, hashTableRel,relWithSelGeneric, request,context,isAdminTable,newTableName, false);
				  sArrowDir = getArrowDirection(relWithSelGeneric, sId, bExpandTo,request);
				  	
				  //Child is getting added ... add it to the list in the session as well
				  IEF_INFNavigateMap nodeMap = new IEF_INFNavigateMap();
				  nodeMap.put("id", sId );
				  //also store the relation id ( to be used when the relation object is not stored in session )
				  nodeMap.put("id[connection]", relID );
				  String strNodeID = "root_" + iCount;
				  nodeMap.put("NodeID", strNodeID);
  				  nodeMap.setCanHaveChildrenStatus(bHasChildren);
				  mapNavigateList.add(nodeMap);
				  //Create a data map and update the data
				  IEF_INFNavigateData nodeData = new IEF_INFNavigateData();			  
				  nodeData.setNodeData(sName,sRevision,sType,sBusId,sRelWithSelName,sArrowDir,sTableValues);
				  mapNavigateData.put( sId+"|"+relID, nodeData);
				} // check level = 1

				//increment counter
				iCount++;

			} //while
			
			//Function FUN080585: Removal of Cues, Tips
			// if("true".equalsIgnoreCase(sShowCueTip))
			//sort the objects before adding them to the list
			//mapNavigateList = sortNavigateObjects(context, mapNavigateList, vectorColList, 
			//	sortColumnName, sortDirection, null);
        	PopulateTreeTableFirstLevelChildren( context, application, request, mapNavigateList,  mapNavigateData, false, out/*,cueStyleMap*/);
		}
		if( !boolChildsExists || hashTableGeneric.size() ==0 || relWithSelListGeneric.size() == 0)
		{
        //error no matches....
%>
			tree.root.addChild("<%=i18nStringNowLocal("emxIEFDesignCenter.Tree.NoObjectsFound",request.getHeader("Accept-Language"))%>", "images/iconDelete.gif" ,null,null,null,null,false);
			table.root.addChild("<td class=tableValue colspan=<%=totalHeadings+1%> align=center ><%=i18nStringNowLocal("emxIEFDesignCenter.Tree.NoObjectsFound",request.getHeader("Accept-Language"))%></td>" );
<%
		}
                //Function FUN080585: Removal of Cues, Tips
	} //if reSortKey == null
	else
	{
	
		//Function FUN080585: Removal of Cues, Tips
		//~~~CueTip-Start~~~
		//~~~~~~~~~~~~~~~~~~~~~~~~CueTip-End~~~~~~~~~~~~~~~~~~~~~~~~
		//clear the existing children

%>
		var tree = parent.tree;
        var rowHeight = parent.varRowHeight;
        //Function FUN080585: Removal of Cues, Tips
		//XSSOK
		tree.createRoot("&nbsp;<%=sName%>&nbsp;&nbsp;&nbsp;", "<%=drawIconInNavigate(context, application, sType)%>", null, null, "<%=sId%>", "<%=sId%>" , true, "<%=sMenuName%>");		
        //XSSOK
		parent.setHeading("<tr height="+rowHeight+"><td class=heading nowrap align=left>&nbsp;<%=sTreeHeading%>&nbsp;<img src=images/utilSpace.gif  >&nbsp;</td></tr>",tree);

		var table = parent.table;
		//Function FUN080585: Removal of Cues, Tips
		//XSSOK
		table.createRoot("<td><img src=images/utilSpace.gif >&nbsp;</td><%=loadTableValues(vectorColList, hashTableGeneric, null,request,context,isAdminTable,newTableName, false)%>", "<%=sId%>","<%=sId%>", true);
		//XSSOK
		parent.setHeading("<td class=heading><img src=images/utilSpace.gif  >&nbsp;<%=sTableHeading%></td>",table);

		tree.root.nodes = null;
		table.root.nodes = null;
		selectedNode = null;

<%
    
		//Get the list from the session
		MapList mapNavigateList = (MapList)(session.getValue("IEF_INFNavigateMap"+ timeStamp));
		HashMap mapNavigateData = (HashMap)(session.getValue("IEF_INFNavigateData"+ timeStamp));


		// sort the list based on the sort column key
		mapNavigateList = sortNavigateObjects(context, mapNavigateList, vectorColList, sortColumnName, sortDirection, null);
		
		//Function FUN080585: Removal of Cues, Tips
		PopulateTreeTableFirstLevelChildren( context, application, request, mapNavigateList,  mapNavigateData, true, out);

		//if there are no nodes ..create a node which says "no objects found"
		if( mapNavigateList.size() == 0)
		{
%>
			tree.root.addChild("<%=i18nStringNowLocal("emxIEFDesignCenter.Tree.NoObjectsFound",request.getHeader("Accept-Language"))%>", "images/iconDelete.gif" ,null,null,null,null,false);
			table.root.addChild("<td class=tableValue colspan=<%=totalHeadings+1%> align=center ><%=i18nStringNowLocal("emxIEFDesignCenter.Tree.NoObjectsFound",request.getHeader("Accept-Language"))%></td>" );
<%
		}
		//Function FUN080585: Removal of Cues, Tips
	} //else of ( if reSortKey == null )
	//System.gc();

	//Commit the transaction
    util.commitTransaction(context);
}
catch(Exception ex)
{
	try
	{
		if(context.isTransactionActive())
		context.abort();
	}
	catch(Exception exception)
	{
	}

	//Log the exception
	if(ex.toString()!=null && (ex.toString().trim()).length()>0)
		emxNavErrorObject.addMessage(ex.toString().trim());
}
%>
	//Refresh the tree & Table
	tree.refresh();
	table.refresh();
	//set the scroll check here as the tree and table are already refreshed
	parent.scrollCheck();
	tree.setScrollPosition();

	//Addd by nagesh on 16/2/2004 to enable progrese animation/status msg 
	top.window.status = "Done";
	removeProgressBar();//use this function to remove clock progress animation
	//end of changes on 16/2/2004

	//reset the mouse pointer
	//parent.resetMousePointer();
</script>
<script language="JavaScript">
	var tableFrame = findFrame(top, "listDisplay");
	var navTableDataForm = tableFrame.document.forms['emxTableForm'];
	if(navTableDataForm)
	{
		var actBarUrl = "emxBlank.jsp";
		navTableDataForm.action = actBarUrl;
		navTableDataForm.target = "listFoot";
		navTableDataForm.submit();
	}
</script>
<%@include file= "../common/emxNavigatorBottomErrorInclude.inc"%>
</html>
