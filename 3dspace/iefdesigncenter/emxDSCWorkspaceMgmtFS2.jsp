<%--  emxDSCWorkspaceMgmtFS2.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxDSCWorkspaceMgmtFS.jsp - Main frameset for WSM

--%>


<%@ include file ="../integrations/MCADTopInclude.inc" %>
<%@ page import="matrix.db.BusinessObject,com.matrixone.apps.domain.util.*" %>

<%-- // emxTeamCommonUtilAppInclude.inc needs context otherwise it fails to complie --%>
<%
 matrix.db.Context context = Framework.getFrameContext(session);
%>

<%@ include file = "../teamcentral/emxTeamCommonUtilAppInclude.inc" %>
<%@ include file = "../teamcentral/emxTeamUtil.inc" %>


<%@include file = "../common/enoviaCSRFTokenValidation.inc"%>

<%
 MCADIntegrationSessionData integSessionData	= (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
 String operationTitle							= integSessionData.getStringResource("mcadIntegration.Server.Title.ManageWorkspaces");
 %>
<%!
 public static final String formatMessage(String msg)
    {       

        StringBuffer sbuf = new StringBuffer();

        char [] cArray = msg.toCharArray();

        for(int i=0; i<cArray.length; i++)
        {
            char c[] = new char[1];
            c[0] = cArray[i];

            if((new String(c)).equals("\'"))
            {
                sbuf.append("\\");
                sbuf.append(new String(c));
            }
            else if((new String(c)).equals("\\"))
            {
                sbuf.append("\\");
                sbuf.append(new String(c));
            }
            else if((new String(c)).equals("\""))
            {
                sbuf.append("\\");
                sbuf.append(new String(c));
            }
            else
            {
                sbuf.append(new String(c));
            }

        }

        return sbuf.toString();
    }  
%>
<head>
<!--XSSOK-->
<title><%=operationTitle%></title>
<script language="javascript" src="../common/scripts/emxUICore.js"></script>
<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
<script language="javascript"></script>
<script language="javascript" src="../integrations/scripts/MCADUtilMethods.js"></script>
<script language="javascript" src="../integrations/scripts/IEFUIModal.js"></script>
<script language="javascript" src="../common/scripts/emxUICoreTree.js"></script>
<script language="javascript" src="../common/scripts/emxUITreeUtil.js"></script>
<script language="javascript" src="../common/scripts/emxUIModal.js"></script>
<script language="javascript" src="emxDSCWorkspaceMgmtTree.js"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>

<%!

   /* Processing overview

      Local Workspaces
         This code takes a flat list of directory paths and converts it to a tree
         representation.  The tree is defined as a hierarchy of nested TreeMaps, one
         for each directory.  The TreeMaps are keyed by subdirectory name and have 
         a value of a vector containing (subDirPath, subDirNodes) where subDirPath 
         is the full path down to this subdirectory and subDirNodes is a TreeMap of
         the subdirectories under the current one.
         
         The tree is actually rendered in Javascript so renderTree outputs the 
         Javascript code on the fly to create the proper node hierarchy.

      Team Central Workspaces
         The top level workspaces for the user are obtained and then recursively
         traversed to popuplate the subfolder hierarchy.  The tree is rendered
         similar to the local workspace case.
   */
 private static final class Helper {   

   HashMap pathToNodeMap;
   HashMap pathToJsCodeMap = new HashMap();
   String wsmDetailsContent = "../common/emxBlank.jsp";
   final String m_initialDir;
   final String m_initialFolderId;
   
   final TreeMap rootNode;

   int childNum = 0;
   boolean isProjectFolderID 	= false;
   
   public  Helper(TreeMap rootNode, HttpServletRequest request) {
      String initialDir = Request.getParameter(request,"initialDir");
      String initialFolderId  = Request.getParameter(request,"initialFolderId");
      
	 if(initialFolderId!=null && initialFolderId.equals(""))
		initialFolderId=null;
      
      if(initialDir != null && (initialDir.equals("0") || initialDir.equals(""))){
                     initialDir = null;
      }
      if(initialDir != null && (initialDir.endsWith("\\") || initialDir.endsWith("/"))){
          initialDir = initialDir.substring(0,(initialDir.length()-1));
      }

      this.rootNode=rootNode;
        pathToNodeMap = new HashMap();
        pathToNodeMap.put("", rootNode);

        this.m_initialDir = initialDir;
        this.m_initialFolderId = initialFolderId;
      
      if(m_initialFolderId != null)
      {
    	  try
    	  {
			 HttpSession session1			= request.getSession(true);
			 MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData)session1.getAttribute("MCADIntegrationSessionDataObject");
		
	    	 MCADFolderUtil folderUtil 		= new MCADFolderUtil(integSessionData.getClonedContext(session1), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
			 BusinessObject workspaceObj  	= folderUtil.getTopWorkspaceObject(integSessionData.getClonedContext(session1), m_initialFolderId);
			 String workspaceType 			= workspaceObj.getTypeName();
	  
			 if(workspaceType.equalsIgnoreCase(DomainConstants.TYPE_PROJECT_SPACE))
				isProjectFolderID = true;
    	 
    	  }catch(Exception e){}
      }
   }


   void processSubDir(String subDir, String subDirPath, String parentPath)
   // Updates pathToNodeMap and creates a new TreeMap node for a given subdirectory.
   {
      
      /* The working set may have different entries for C: vs c: (and possibly subdir names varying only in capitalization on a case-insensitive system).  
      For case-insensitive systems, always store lowercase entries in pathToNodeMap keys. */
      
      String mapPath;  
      String tmpParentPath;

      // Force drive letters to lowercase (sometimes they get stored in upper case, sometimes in lower case)
      mapPath = subDirPath;
      tmpParentPath = parentPath;

      // If this directory has been processed, there is nothing else to do
      TreeMap thisNode = (TreeMap) pathToNodeMap.get(mapPath);
      if (thisNode != null) return;

      // Find the parent directory node (it will always have been processed by this point)
      TreeMap parentNode = (TreeMap) pathToNodeMap.get(tmpParentPath);

      // Add this level to the parent node and register in maps
      TreeMap subDirNode = new TreeMap();
      Vector subDirInfo = new Vector();

      subDirInfo.add(subDirPath);         // Each node consists of a vector of (path, subdirs)
      subDirInfo.add(subDirNode);
      parentNode.put(subDir, subDirInfo);
      pathToNodeMap.put(mapPath, subDirNode);
   }   
   
   void renderLocalWorkspace(String integrationName, String detailsURL, String jsParentVar, 
                                     TreeMap node, javax.servlet.jsp.JspWriter out) throws java.io.IOException
   // Recursively renders the tree into Javascript calls to create the actual web page tree.
   // jsParentVar is the Javascript variable name of the parent node to add subnodes
   // at this level to. Node will be recursively rendered. out is the standard JSP out stream

     {
      Iterator nodeIter = node.keySet().iterator();

      // Iterate through subnodes below this one and for each one get the
      // subdir name/path and its subnodes to be recursively processed.  For
      // each subnode, generate appropriate Javascript calls.
      while (nodeIter.hasNext())
      {
         String subDir = (String) nodeIter.next();
         Vector subNodeInfo = (Vector) node.get(subDir);
         String subDirPath = (String) subNodeInfo.elementAt(0);
         TreeMap subNode = (TreeMap) subNodeInfo.elementAt(1);

         // Force directory sep on raw drive letters
         if (subDirPath.length() == 2 && subDirPath.charAt(1) == ':') subDirPath += '\\';

         int thisChildNum = childNum;
         
         // childNodes maintains a list of all the created nodes so the proper
         // hierarchy can be created.
         String jsCode = genLocalWorkspaceJsCode(childNum, subDir, subDirPath, detailsURL, jsParentVar, integrationName);
         out.print(jsCode);
         childNum++;
         renderLocalWorkspace(integrationName, detailsURL, "childNodes[" + thisChildNum + "]", subNode, out);
      }
   }

   String genLocalWorkspaceJsCode(int childNum, String nodeText, String subDirPath, 
                                          String detailsURL, String jsParentVar, 
                                          String integrationName)
   {
         String detailsContent = "";
		 try
	     {
			 detailsContent = detailsURL + "&dirPath=" + MCADUrlUtil.hexEncode(subDirPath) + "&integrationName=" + integrationName;
	     }
	     catch(Exception exception)
		 {
			System.out.println("Exception: " + exception.getMessage());
		 }
         
         String jsCode = "childNodes[" + childNum + "] = new emxDSCWorkspaceMgmtTreeNode('iconSmallFolder.gif', '../../iefdesigncenter/images/iconSmallFolderOpen.gif', '', '" +
                          nodeText + "', '" + detailsContent;
                          
         String expandCode = "wsmTree.nodes[childNodes["+childNum+"].nodeID].expanded = true;\n";
         pathToJsCodeMap.put(nodeText, expandCode);
        
         if(m_initialDir != null && subDirPath.equalsIgnoreCase(m_initialDir))
         {
             wsmDetailsContent = detailsContent;
          
             jsCode = jsCode + "', 'detailsDisplay', null, null);" +
             jsParentVar + ".addChild(childNodes[" + childNum + "]);\n" +
             "wsmTree.setSelectedNode(childNodes[" + childNum + "]);\n"+
             "localWorkspace.expanded = true;\n";
             
             StringTokenizer stt =  new StringTokenizer(subDirPath, "/\\"); 
		   
		     while (stt.hasMoreTokens())
		     {
		         String nextToken = stt.nextToken();
		         String tempExCode = (String) pathToJsCodeMap.get(nextToken);
		         if(tempExCode != null) {
		             jsCode = jsCode + tempExCode;
		         }
		     }
         } 
         else 
         {
             jsCode = jsCode +  "', 'detailsDisplay', null, null);\n" +
             jsParentVar + ".addChild(childNodes[" + childNum + "]);";
         }
                             
         return jsCode;
   }
   
   

   private void renderWorkspace(int level, String integrationName, String jsParentVar, String sFolderObjId, javax.servlet.jsp.JspWriter out,
                                matrix.db.Context context, HttpSession session, boolean isProjectType, String RELATIONSHIP_VAULTS,boolean bEnableAppletFreeUI) throws Exception {
   // Recursively renders a workspace or folder into Javascript calls to create the actual web page tree.
   // jsParentVar is the Javascript variable name of the parent node to add subnodes
   // at this level to.
   //
   // sFolderObjId will be recursively rendered.
   // out is the standard JSP out stream
   // level indicates the recursion level (0 being topmost (sFolderObjId will be a workspace in this case
   // for 1+ it will be a workspace vault)
  
    String SELECT_TO_OBJECT_TYPE	= new StringBuffer("from[").append(RELATIONSHIP_VAULTS).append("].to.type").toString();
	String SELECT_TO_OBJECT_NAME	= new StringBuffer("from[").append(RELATIONSHIP_VAULTS).append("].to.name").toString();
	String SELECT_TO_OBJECT_ID		= new StringBuffer("from[").append(RELATIONSHIP_VAULTS).append("].to.id").toString();
		
	String ATTRIBUTE_COUNT = new StringBuffer("attribute[").append(MCADMxUtil.getActualNameForAEFData(context, "attribute_Count")).append("]").toString();
		
	StringList busSelectionList = new StringList();
	busSelectionList.add(DomainObject.SELECT_NAME);	
	
	busSelectionList.add(ATTRIBUTE_COUNT);
	busSelectionList.add(SELECT_TO_OBJECT_TYPE);
	busSelectionList.add(SELECT_TO_OBJECT_NAME);
	busSelectionList.add(SELECT_TO_OBJECT_ID);
	busSelectionList.add(DomainObject.SELECT_TYPE);
	busSelectionList.add(DomainObject.SELECT_ATTRIBUTE_TITLE);
	String oids[] = new String[1];
	oids[0] = sFolderObjId;
	BusinessObjectWithSelectList busWithSelectionList = BusinessObject.getSelectBusinessObjectData(context, oids, busSelectionList);
	BusinessObjectWithSelect busWithSelect = busWithSelectionList.getElement(0);
   
      String sFolderName = busWithSelect.getSelectData(DomainObject.SELECT_NAME);     
       
	String typeName1=busWithSelect.getSelectData(DomainObject.SELECT_TYPE);
 
        String sFolderTitle ="";
	
	if(typeName1.equals(DomainConstants.TYPE_CONTROLLED_FOLDER))
	 {
             sFolderTitle = busWithSelect.getSelectData(DomainObject.SELECT_ATTRIBUTE_TITLE); 
	 }
	 
	 
	  
      // Get document count for workspace vault
      int docCount = 0;
      if (level > 0)
      {
         String countAttr = busWithSelect.getSelectData(ATTRIBUTE_COUNT);
         docCount = Integer.parseInt(countAttr);
      }      

      // Prep to create javascript
      String icon, selectedIcon;
      String nodeText;
      String url;		   //url will hit when node is selected
      String url2 = "";    //url2 will hit when icon2 is selected (will always be displayed in a modal popup)
      
      if(isProjectType)
      {
    	  url2 	= "../common/emxTree.jsp?objectId=" + sFolderObjId + "&suiteKey=eServiceSuiteProgramCentral" + 
          "&objectUrl=emxProgramCentralProjectSummaryFS.jsp?objectName=" + sFolderName + "&objectId=" + sFolderObjId +
          "&emxSuiteDirectory=programcentral&AppendParameters=true";
      }
      else 
      {
    	  url2 	= "../common/emxTree.jsp?objectId=" + sFolderObjId +"&suiteKey=eServiceSuiteTeamCentral" + 
                  "&objectUrl=emxTeamWorkspaceDetailsFS.jsp?objectName=" + sFolderName + "&objectId=" + sFolderObjId +
                   "&emxSuiteDirectory=teamcentral&AppendParameters=true";
      }
      url2 = formatMessage(url2);
      url2 = MCADMxUtil.encodeURLParameters(url2);   	//IR-638648-3DEXPERIENCER2018x 
      if (level == 0)
      {
         icon = getIcon(level,isProjectType); //"iconSmallWorkspace.png"; // i.e. workspace level
         selectedIcon = icon;
         nodeText = sFolderName;
         nodeText = formatMessage(nodeText);
         
         if(isProjectType)
         {
         	String objURL 	= "&objectUrl=emxProgramCentralProjectSummaryFS.jsp?" + "objectName=" + formatMessage(sFolderName) +
         	"&emxSuiteDirectory=programcentral&AppendParameters=true&objectId=" + sFolderObjId + "&relId=null&jsTreeID=root";
         	
         	url = "../common/emxForm.jsp?form=PMCProjectDetailsViewForm&mode=view&HelpMarker=emxhelpworkspaceproperties" +
         	"&workspaceId=" + sFolderObjId + objURL;
         }
         else{
        	String objURL 	= "&objectUrl=emxTeamWorkspaceDetailsFS.jsp?" + "objectName=" + formatMessage(sFolderName) + 
        	"&emxSuiteDirectory=teamcentral&AppendParameters=true&objectId=" + sFolderObjId +"&relId=null&jsTreeID=root";
        	
         url = "../common/emxForm.jsp?form=type_Workspace&mode=view&toolbar=TMCWorkspaceDetialsToolBar&HelpMarker=emxhelpworkspaceproperties" +
         "&workspaceId=" + sFolderObjId + objURL;
      }
         url = MCADMxUtil.encodeURLParameters(url);     	//IR-638648-3DEXPERIENCER2018x 
      }
      else
      {
		 MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData)session.getAttribute("MCADIntegrationSessionDataObject");
			
		 if(integSessionData != null)
		 {
			HashMap globalConfigObjectTable = (HashMap)integSessionData.getIntegrationNameGCOTable(context);	
			session.setAttribute("GCOTable", globalConfigObjectTable);
		 }
		 
         icon = getIcon(level,isProjectType); //"iconSmallFolder.png";
         selectedIcon = icon;
 
        if(isProjectType)
		{
			if(!typeName1.equals(DomainConstants.TYPE_CONTROLLED_FOLDER))
			{
         	nodeText = sFolderName;
			}
			else
			{
				nodeText = sFolderTitle;
			}
			
		}
         else 
         nodeText = sFolderName + "(" + docCount + ")";

         nodeText = formatMessage(nodeText);
         url = getTableURL(sFolderObjId, isProjectType,bEnableAppletFreeUI);
      }

      int thisChildNum = childNum;

      String jsCode = "childNodes[" + childNum + "] = new emxDSCWorkspaceMgmtTreeNode('" + icon + "', '" + selectedIcon + "', 'images/iconActionNewWindow.gif', '" +
                  nodeText + "', '" + url + "', 'detailsDisplay', '" + url2 + "', null);\n" +
                  jsParentVar + ".addChild(childNodes[" + childNum + "]);";

      if(m_initialFolderId != null && m_initialFolderId.equals(sFolderObjId))
      {
    	  jsCode = jsCode + "var parentNode = childNodes[" + childNum + "].getParent();\n"+
    	  "var parentNodeArray = new Array;\n"+
    	  "var parentCount  = 0;\n"+
    	  "while(parentNode != null && parentNode != root){\n"+
    	  "   parentNodeArray[parentCount++] = parentNode;\n"+
    	  "   parentNode                     = parentNode.getParent();\n"+
    	  "}\n"+
    	  "for(var i = parentCount-1 ; i >= 0 ; i--){\n"+
    	  "	parentNodeArray[i].expanded = true;\n"+
    	  "}\n"+
    	  "wsmTree.setSelectedNode(childNodes[" + childNum + "]);\n";
      }
                  
                  
      out.print(jsCode);                  
      childNum++;

      // Cycle through the list of subfolders and recursively process and sort
	  //changes made for IR-663464
	  String supportExpansion = "TRUE";
	  
	  try 
	  {
			ResourceBundle iefProperties = PropertyResourceBundle.getBundle("ief");
			supportExpansion = (iefProperties.getString("mcadIntegration.DECSupportForWorkspaceExpansion.Enable")).trim();
									
	  } 
	  catch (Exception e) 
	  {
			System.out.println("No entry found for mcadIntegration.DECSupportForWorkspaceExpansion.Enable in ief properties");
	  }
	  if(supportExpansion.equalsIgnoreCase("TRUE"))
	   {
		   
	        StringList typeList = busWithSelect.getSelectDataList(SELECT_TO_OBJECT_TYPE);
	        StringList nameList = busWithSelect.getSelectDataList(SELECT_TO_OBJECT_NAME);
	        StringList idList = busWithSelect.getSelectDataList(SELECT_TO_OBJECT_ID);
	             
	        MapList folderNameIdMapList   = new MapList();
	        TreeMap folderMap   = new TreeMap();
	        if(typeList!= null)
	        { 
	        	Iterator typeitr = typeList.iterator();
	        	Iterator nameitr = nameList.iterator();
	        	Iterator iditr = idList.iterator();
	        
	        	while (typeitr != null && typeitr.hasNext()) 
	        	{
	        		HashMap folderNameIdMap = new HashMap();
	        		String typeName = (String) typeitr.next();
	        		String folderName = (String) nameitr.next();
	        		String subFolderId = (String) iditr.next();
	        		String folderTypeID=typeName+"|"+subFolderId;
	        		folderNameIdMap.put("id", folderTypeID);
	        		folderNameIdMap.put("name", folderName);
	        		folderMap.put(folderName, folderTypeID);
	        		folderNameIdMapList.add(folderNameIdMap);
	        	}  
	        }   
            String RELATIONSHIP_SUBVAULTS = MCADMxUtil.getActualNameForAEFData(context, "relationship_SubVaults");
            folderNameIdMapList.sort("name", "ascending", "String");
	        for(int i=0; i<folderNameIdMapList.size(); i++)
            { 
	        	HashMap folderNameIdMap			= (HashMap) folderNameIdMapList.get(i);
	        	String folderName 				= (String)folderNameIdMap.get("name");
	        	String folderTypeID	 			= (String)folderNameIdMap.get("id");
	            Enumeration folderTypeIDElements = MCADUtil.getTokensFromString(folderTypeID, "|");
	            String typeName = "";
	            String subFolderId = "";
            
	            while(folderTypeIDElements.hasMoreElements())
	            {
	        		typeName    = (String)folderTypeIDElements.nextElement();
	        		subFolderId = (String)folderTypeIDElements.nextElement();
	        	}
                 
                 // Only traverse down into subfolders
		  /* changes made for IR-592057 */
                 if ((typeName.equals(DomainConstants.TYPE_WORKSPACE_VAULT))||(typeName.equals(DomainConstants.TYPE_CONTROLLED_FOLDER)))
                 {
                    renderWorkspace(level+1, integrationName, "childNodes[" + thisChildNum + "]", subFolderId,
                                    out, context, session,isProjectType, RELATIONSHIP_SUBVAULTS,bEnableAppletFreeUI);
                 }
              }
	    }  return;
   }

   private StringList getTopLevelWorkspaces(matrix.db.Context context, HttpSession session) throws MatrixException {
      String sFtr       = null; // emxGetParameter(request,"mx.page.filter");
      if (sFtr==null)
      {
         sFtr = "All";
      }
    
      com.matrixone.apps.common.Person person = com.matrixone.apps.common.Person.getPerson(context);
      String spersonName = com.matrixone.apps.common.Person.getDisplayName(context, person.getName());
      
      //build object-select statements
      StringList selectTypeStmts = new StringList();
      selectTypeStmts.add(DomainObject.SELECT_TYPE);
      selectTypeStmts.add(DomainObject.SELECT_NAME);
      selectTypeStmts.add(DomainObject.SELECT_ID);
      selectTypeStmts.add(DomainObject.SELECT_DESCRIPTION);
      selectTypeStmts.add(DomainObject.SELECT_OWNER);
      selectTypeStmts.add(DomainObject.SELECT_CURRENT);
      selectTypeStmts.add(DomainObject.SELECT_POLICY);
      
       String queryTypeWhere   = "";
       String expandTypeWhere  = "";
      
       // where for the query, show workspaces in the "Active" state only, and the users(roles) must have read access on the workspace.
       queryTypeWhere = "('" + DomainObject.SELECT_CURRENT + "' == 'Active')";
      
         // where for the expand, show workspaces in the "Active" state for members, Owner can see the Workspace in any state.
       if (sFtr.equals("Active")) {
         expandTypeWhere = "('" + DomainObject.SELECT_CURRENT + "' == 'Active')";
       } else {
         expandTypeWhere = "('" + DomainObject.SELECT_OWNER + "' == '"+person.getName()+"' || '" + DomainObject.SELECT_CURRENT + "' == 'Active')";
       }
      
       //get the vaults of the Person's company
       DomainObject domainPerson = DomainObject.newInstance(context,person);
       String personVault = person.getVaultName(context);
      
       //query selects
       StringList objectSelects = new StringList();
       objectSelects.add(DomainObject.SELECT_ID);
       //have to include SELECT_TYPE as a select since the expand has includeTypePattern
       objectSelects.add(DomainObject.SELECT_TYPE);
      
       //build type and rel patterns
       Pattern typePattern = new Pattern(DomainConstants.TYPE_PROJECT_MEMBER);
       typePattern.addPattern(DomainConstants.TYPE_PROJECT);
       Pattern relPattern = new Pattern(DomainConstants.RELATIONSHIP_PROJECT_MEMBERSHIP);
       relPattern.addPattern(DomainConstants.RELATIONSHIP_PROJECT_MEMBERS);
      
       // type and rel patterns to include in the final resultset
       Pattern includeTypePattern = new Pattern(DomainConstants.TYPE_PROJECT);
       Pattern includeRelPattern = new Pattern(DomainConstants.RELATIONSHIP_PROJECT_MEMBERS);
      
       // get all workspaces that the user is a Project-Member
       MapList workspaceList = person.getRelatedObjects(context,
                                           relPattern.getPattern(),  //String relPattern
                                           typePattern.getPattern(), //String typePattern
                                           objectSelects,            //StringList objectSelects,
                                           null,                     //StringList relationshipSelects,
                                           true,                     //boolean getTo,
                                           true,                     //boolean getFrom,
                                           (short)2,                 //short recurseToLevel,
                                           expandTypeWhere,          //String objectWhere,
                                           "",                       //String relationshipWhere,
                                           includeTypePattern,       //Pattern includeType,
                                           includeRelPattern,        //Pattern includeRelationship,
                                           null);                    //Map includeMap
      
       // get all workspaces that the current user is a member since one of his roles is a member
       MapList roleWorkspaceList = DomainObject.findObjects(context,
                                      DomainConstants.TYPE_PROJECT,                // type pattern
                                      DomainObject.QUERY_WILDCARD, // namePattern
                                      DomainObject.QUERY_WILDCARD, // revPattern
                                      DomainObject.QUERY_WILDCARD, // ownerPattern
                                      personVault,                 // get the Person Company vault
                                      queryTypeWhere,              // where expression
                                      true,                        // expandType
                                      objectSelects);               // object selects 
      
       Iterator workspaceListItr = workspaceList.iterator();
       Iterator roleWorkspaceListItr = roleWorkspaceList.iterator();
      
       // get a list of workspace id's for the member
       StringList workspaceIdList = new StringList();

       while(workspaceListItr.hasNext())
       {
         Map workspaceMap = (Map)workspaceListItr.next();
         String workspaceId = (String)workspaceMap.get(DomainObject.SELECT_ID);
         workspaceMap.remove("relationship");
         workspaceMap.remove("level");
         workspaceIdList.addElement(workspaceId);
       }
      
       while(roleWorkspaceListItr.hasNext())
       {
         Map workspaceMap = (Map)roleWorkspaceListItr.next();
         String workspaceId = (String)workspaceMap.get(DomainObject.SELECT_ID);
         if(!workspaceIdList.contains(workspaceId))
         {
           workspaceIdList.addElement(workspaceId);
           workspaceList.add(workspaceMap);
         }
       }
       return workspaceIdList;
   }
   //FUN079585 : Change NLS for Workspace, Workspace Template and Folder.
    private String getIcon(int level,boolean isProject){
	   String icon="";
	   if (level == 0)
	   {
		   if(!isProject)
	   		   icon = "iconSmallWorkspace.png";
		   else
			   icon = "iconSmallProject.png";
	   }
	   else
	   {
		   icon = "iconSmallFolder.png";
	   }
	   return icon;
   } 
// End of code based on emxTeamMyWorkspaceSummary.jsp

}

   static final String getTableURL(String folderId, boolean isProject,boolean bEnableAppletFreeUI)
   {
	   StringBuffer tableURL = new StringBuffer("../common/emxIndentedTable.jsp?objectId=");
	   
		if(isProject)
			tableURL.append(folderId).append("&workspaceId=").append(folderId).append("&suiteKey=eServiceSuiteDesignerCentral&program=DSCProjectFolderContent:getFolderContent&table=DSCDefault&topActionbar=DSCMCADTopActionBar&selection=multiple&Submit=false&header=Content&portalMode=true&jpoAppServerParamList=session:GCOTable&sortColumnName=Name&sortDirection=ascending&rememberSelection=false&showTabHeader=true");   
		else
		{
			if(!bEnableAppletFreeUI)
			{
	     	tableURL.append(folderId).append("&workspaceId=").append(folderId).append("&suiteKey=eServiceSuiteDesignerCentral&program=emxTeamContentBase:getFolderContentIds&table=DSCDefault&topActionbar=DSCMCADTopActionBar&selection=multiple&Submit=false&header=Content&portalMode=true&jpoAppServerParamList=session:GCOTable&sortColumnName=Name&sortDirection=ascending&rememberSelection=false&showTabHeader=true");
			}
			else
			{
				tableURL.append(folderId).append("&workspaceId=").append(folderId).append("&suiteKey=eServiceSuiteDesignerCentral&program=emxTeamContentBase:getFolderContentIds&table=DSCDefault&topActionbar=DSCMCADTopActionBarAppletFree&selection=multiple&Submit=false&header=Content&portalMode=true&jpoAppServerParamList=session:GCOTable&sortColumnName=Name&sortDirection=ascending&rememberSelection=false&showTabHeader=true");
			}
		}
   	   return tableURL.toString();
   }
%>

<%
   String portalMode 		= Request.getParameter(request,"portalMode");
   String portalCommand 	= Request.getParameter(request,"portalCommand");
   String integrationName 	= Request.getParameter(request,"integrationName");
   String dirAliases 		= Request.getParameter(request,"dirAliases");
   String isCSECommand 		= Request.getParameter(request,"isCSECommand");
   
   matrix.db.Context clonedContext  = integSessionData.getClonedContext(session);
   
   Hashtable integNameGCOMapping 	= integSessionData.getLocalConfigObject().getIntegrationNameGCONameMapping();
   boolean isIntegrationExcluded 	= integSessionData.getLocalConfigObject().isWSMIntegrationExcluded (integNameGCOMapping.keySet());

   String detailsURL = "emxDSCWorkspaceMgmtDetails.jsp?table=DSCWorkspaceMgmtDetails&program=DSCGenerateWorkspaceMgmtDetails:getFileList&objectBased=false&toolbar=DSCWorkspaceMgmtDetailsTopActionBarActions&selection=none&sortColumnName=Type&customize=false&sortDirection=descending&isCSECommand="+isCSECommand;
   
   if (portalMode != null) detailsURL	 = detailsURL + "&portalMode=" + XSSUtil.encodeForURL(clonedContext,portalMode);
   if (portalCommand != null) detailsURL = detailsURL + "&portalCommand=" + XSSUtil.encodeForURL(clonedContext,portalCommand);   
   
   final TreeMap rootNode = new TreeMap(); 
   final Helper helper = new Helper(rootNode,request);

   boolean bShowProject 	= com.matrixone.MCADIntegration.server.beans.MCADMxUtil.isProgramCentralInstalled(clonedContext);

%>

<script Language="Javascript" type="text/javascript">

   var childNodes = new Array;
   var wsmTree = new emxDSCWorkspaceMgmtTree("WSMTree");


   // Manually add to the global list of trees (needed by emxUICoreTree handleClick
   // method and others).
   top.trees['WSMTree'] = wsmTree;
   top.trees[top.trees.length] = wsmTree;

   // Create root node and the top level Local Workspaces nodes
   //XSSOK
   // IR-598517-3DEXPERIENCER2018x - removed 'emxIEFDesignCenter.Common.Workspaces' property from root node
   wsmTree.createRoot(new emxDSCWorkspaceMgmtTreeNode("", "", "","","../common/emxBlank.jsp", 'detailsDisplay', null, null));
   var root = wsmTree.root;
   //XSSOK
   <%
   boolean bEnableAppletFreeUI = MCADMxUtil.IsAppletFreeUI(context);
   if(!bEnableAppletFreeUI)
   {
   %>
   var localWorkspace = new emxDSCWorkspaceMgmtTreeNode("iconSmallFolder.gif", "../../iefdesigncenter/images/iconSmallFolderOpen.gif", "","<%= UINavigatorUtil.getI18nString("emxIEFDesignCenter.Common.LocalWorkspace","emxIEFDesignCenterStringResource", request.getHeader("Accept-Language")) %>","emxDSCWorkspaceMgmtLocalWorkspace.jsp", 'detailsDisplay', null, null);
   <% if(isIntegrationExcluded == false) {%>
    root.addChild(localWorkspace);
       <%}}%>
   //XSSOK
   //IR-596684-3DEXPERIENCER2018x -changed icon names
   var matrixWorkspaces = new emxDSCWorkspaceMgmtTreeNode("iconSmallWorkspace.png", "iconSmallWorkspace.png", "","<%= UINavigatorUtil.getI18nString("emxIEFDesignCenter.Common.MatrixWorkspaces","emxIEFDesignCenterStringResource", request.getHeader("Accept-Language")) %>","../common/emxTable.jsp?program=emxWorkspace:getAllMyDeskWorkspace,emxWorkspace:getActiveMyDeskWorkspace&table=TMCMyDeskWorkspaceSummary&header=emxTeamCentral.Common.Workspace&toolbar=TMCWorkspaceSummaryToolBar&programLabel=emxTeamCentral.Filter.All,emxTeamCentral.Filter.Active&sortColumnName=Name&sortDirection=ascending&selection=multiple&HelpMarker=emxhelpworkspaces&suiteKey=TeamCentral&StringResourceFileId=emxTeamCentralStringResource&SuiteDirectory=teamcentral",'detailsDisplay', null, null);
   root.addChild(matrixWorkspaces);

   <% if(bShowProject) {%>
   //XSSOK
   	var matrixProjects = new emxDSCWorkspaceMgmtTreeNode("iconSmallProject.gif", "iconSmallProject.gif", "","<%= UINavigatorUtil.getI18nString("emxIEFDesignCenter.Common.MatrixProjects","emxIEFDesignCenterStringResource", request.getHeader("Accept-Language")) %>","../common/emxIndentedTable.jsp?program=emxProjectSpace:getActiveProjects,emxProjectSpace:getCompletedProjects,emxProjectSpace:getHoldProjects,emxProjectSpace:getCancelProjects,emxProjectSpace:getAllProjects&programLabel=emxProgramCentral.Common.ActiveProjects,emxProgramCentral.Common.CompletedProjects,emxProgramCentral.Common.HoldProjects,emxProgramCentral.Common.CancelProjects,emxProgramCentral.Common.All&table=PMCProjectSpaceMyDesk&selection=multiple&header=emxProgramCentral.ProgramTop.Projects&suiteKey=eServiceSuiteProgramCentral&SuiteDirectory=programcentral&sortColumnName=Name&sortDirection=ascending&Export=false&toolbar=PMCProjectSummaryToolBar&expandProgram=emxProjectSpace:getSubProjectsList&HelpMarker=emxhelpprojectsummary&FilterFramePage=../programcentral/emxProgramVaultFilterInclude.jsp&FilterFrameSize=40&freezePane=Name&expandLevelFilter=false&StringResourceFileId=emxProgramCentralStringResource",'detailsDisplay', null, null);
  	
	
	
  	
   	root.addChild(matrixProjects);
   <%}%>
   
   // Select the Local Workspace node but don't refresh it unless the user 
   // actually clicks on it.  This is because the tree display frame has not
   // yet been created.
   // select local workspace only if initialDir is null
   
   <% if(helper.m_initialDir == null && isIntegrationExcluded == false && !bEnableAppletFreeUI) {%>
   wsmTree.setSelectedNode(localWorkspace);

<%
   }
   MCADSessionData sessionData = integSessionData.getSessionData();
  
   if(!bEnableAppletFreeUI)
   {
   Vector dirNames = sessionData.getAllDirectoryNames("");
   // Initialize root level
   
      if(helper.m_initialDir != null) {
          detailsURL = "emxDSCWorkspaceMgmtDetails.jsp?table=DSCWorkspaceMgmtDetails&program=DSCGenerateWorkspaceMgmtDetails:getFileList&objectBased=false&toolbar=DSCWorkspaceMgmtDetailsTopActionBarActions&selection=none&sortColumnName=In%20Session&sortDirection=descending&isCSECommand="+isCSECommand;
      }
      
   // Cycle and process directories
   
   for (int ii=0; ii < dirNames.size(); ii++)
   {
      String path = (String) dirNames.elementAt(ii);
         
      // Cycle path and process each level (note must support both UNIX and Windows paths)
      
      int curIndex = 0;
      
      // First skip any leader delimiters to get to the first level in the path.
      // For Windows the drive letter is considered the first level
      
      while (curIndex < path.length())
      {
         char curChar = path.charAt(curIndex);
         if (curChar != '/' && curChar != '\\') break;
         curIndex++;
      }
   
      // For root directory case on UNIX (i.e. "/"), backup the index so the / char
      // is used as the directory name.
      
      if (curIndex == 1 && curIndex == path.length()) curIndex = 0;
   
      // Find each path level and process.
   
      String parentPath = ""; // Initially the parent path is empty (i.e. the root)
      do {
         int dirStart = curIndex;
         while (curIndex < path.length())
         {
            char curChar = path.charAt(curIndex);
            if (curChar == '/' || curChar == '\\' || curIndex == path.length() - 1)
            {
               // If last char in path, take the remainder of the path (i.e. up to curIndex + 1)
               // unless the last char is a delimiter (which it will be in the case of a 
               // Windows drive root like c:\)
               
               if (curIndex == path.length() - 1 && curChar != '\\') curIndex++;

               String dirLevel = path.substring(dirStart, curIndex);
               String fullPath = path.substring(0, curIndex);
               helper.processSubDir(dirLevel, fullPath, parentPath);
               parentPath = fullPath;  // Make this path the parent for the next level
                  
               curIndex++;
               break;
            }
            curIndex++;
         }
      } while (curIndex < path.length());
   }

   // Process directory aliases
   TreeMap dirAliasesMap = new TreeMap();
   
   if(dirAliases != null)
   {
   StringTokenizer st =  new StringTokenizer(dirAliases, "|"); 
   int numAliases = java.lang.Integer.parseInt(st.nextToken()); 

   while (st.hasMoreTokens())
   {
      String alias	= st.nextToken();
      String dir = st.nextToken();
      dirAliasesMap.put(dir, alias);
   }
   }

   // Render directory tree
   //initialize wsmDetailsContent, else it is picking up from previous access
   if(isIntegrationExcluded == false){
   helper.wsmDetailsContent = "../common/emxBlank.jsp";
   helper.childNum = 0;

   helper.renderLocalWorkspace(integrationName, detailsURL, "localWorkspace", rootNode, out);
   
   Iterator daIter = dirAliasesMap.keySet().iterator();
   while (daIter.hasNext())
   {
      String dir = (String) daIter.next();
      // Only display if the aliased directory has WS entries
      if (helper.pathToNodeMap.containsKey(dir))
      {
         String jsCode = helper.genLocalWorkspaceJsCode(helper.childNum, (String) dirAliasesMap.get(dir), dir, detailsURL, "localWorkspace", integrationName);
         out.print(jsCode);
         helper.childNum++;
      }
   }
   }
   }
   // Get list of Team Central workspaces and sort
   StringList wsList = helper.getTopLevelWorkspaces(clonedContext, session);
  MapList wsMapList	= new MapList();
String RELATIONSHIP_DATA_VAULTS = MCADMxUtil.getActualNameForAEFData(context, "relationship_ProjectVaults");
	String oids[] = new String[wsList.size()];
	wsList.toArray(oids);
		
	StringList busSelectionList = new StringList();
	busSelectionList.add(DomainObject.SELECT_NAME);
	busSelectionList.add(DomainObject.SELECT_ID);

	BusinessObjectWithSelectList busWithSelectionList = BusinessObject.getSelectBusinessObjectData(integSessionData.getClonedContext(session), oids,busSelectionList);
	for(int i = 0; i < busWithSelectionList.size(); i++)
	{
		HashMap idMap 		= new HashMap();
		BusinessObjectWithSelect busWithSelect = busWithSelectionList.getElement(i);
		idMap.put("id",busWithSelect.getSelectData(DomainObject.SELECT_ID));		
		idMap.put("name",busWithSelect.getSelectData(DomainObject.SELECT_NAME));
		wsMapList.add(idMap);
	}   
	wsMapList.sort("name", "ascending", "String");
   // Create top level nodes for each and then recursively process their subfolders
	for ( int i=0; i<wsMapList.size(); i++)
   {
		Map idMap 	=(Map) wsMapList.get(i);
		String wsId = (String) idMap.get("id");

		helper.renderWorkspace(0, integrationName, "matrixWorkspaces", /* wsName, */ wsId, out, integSessionData.getClonedContext(session), request.getSession(true), false, RELATIONSHIP_DATA_VAULTS,bEnableAppletFreeUI);
   }  

    // Get list of Program Central workspaces and sort
	String [] userIds 		    = new String[1];

	DomainObject personObject = com.matrixone.apps.domain.util.PersonUtil.getPersonObject(clonedContext);
	userIds[0]				  = personObject.getObjectId(clonedContext);				  
	MCADFolderUtil folderUtil = new MCADFolderUtil(clonedContext, integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
	
	MapList projectSpaceList = new MapList();
	
	folderUtil.getPojectSpaceIdList(clonedContext, userIds, projectSpaceList, null, null);
	
	for ( int i=0; i<projectSpaceList.size(); i++)
	{
		HashMap inputObject = (HashMap)projectSpaceList.get(i);
		String prjId		= (String)inputObject.get("id");
		
	    helper.renderWorkspace(0, integrationName, "matrixProjects", prjId, out, clonedContext, request.getSession(true), true, RELATIONSHIP_DATA_VAULTS,bEnableAppletFreeUI);
   }  
   
   if(helper.m_initialFolderId != null)
   {
	   helper.wsmDetailsContent	 = getTableURL(helper.m_initialFolderId, helper.isProjectFolderID,bEnableAppletFreeUI);  
   }
%>

function showProgressBar(queryString)
{
	showIEFModalDialog("IEFProgressBar.jsp?" + queryString, 410, 120);
	return top.modalDialog.contentWindow;
}

function closeProgressBar()
{
	if(top.modalDialog && !top.modalDialog.contentWindow.closed)
	{
		top.modalDialog.contentWindow.close();
	}
}

function closeModalDialog()
{
	closeWindow();
	window.close();
}

function showAlert(message, close)
{
	alert(message);
}

function closeWindow()
{
	if("<%= XSSUtil.encodeForJavaScript(integSessionData.getClonedContext(session),integrationName) %>" != "")
	{
        if (top.opener != null && top.opener != 'undefined')
			top.opener.getAppletObject().callCommandHandler('<%=  XSSUtil.encodeForJavaScript(integSessionData.getClonedContext(session),integrationName) %>', 'cancelOperation', true);		
	}
}

function refreshTablePage()
{
	trees.WSMTree.refresh();
	frames["detailsDisplay"].location.href  = frames["detailsDisplay"].location.href;
}


var frameDisplay = "";

frameDisplay += '<FRAMESET COLS="25%,*" onUnload="javascript:closeWindow()">';
frameDisplay += '   <frame name="wsmTree" src="emxDSCWorkspaceMgmtTreeRefresh.jsp">';
frameDisplay += '   <frame name="detailsDisplay" src="<xss:encodeForHTML><%=helper.wsmDetailsContent %></xss:encodeForHTML>">';
frameDisplay += '</frameset>';

document.write(frameDisplay);

</script>
</head>



