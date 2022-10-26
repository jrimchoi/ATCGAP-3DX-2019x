<%--  DSCPSEEditActionsPreProcessing.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>

<%@page import="com.matrixone.MCADIntegration.server.beans.MCADMxUtil,com.matrixone.MCADIntegration.utils.MCADStringUtils"%>
<%@page import="matrix.db.BusinessObject"%>
<%@ include file ="../integrations/MCADTopInclude.inc" %>


<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<%
	MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
	Context IEFContext                          = integSessionData.getClonedContext(session);
	ENOCsrfGuard.validateRequest(IEFContext, session, request, response);
	MCADServerResourceBundle resourceBundle    =  integSessionData.getResourceBundle();
	MCADMxUtil util                             = new MCADMxUtil(IEFContext, integSessionData.getLogger(), resourceBundle, integSessionData.getGlobalCache());
	MCADGlobalConfigObject globalConfigObject	= null;
	MCADServerGeneralUtil serverUtil			= null;
	boolean isRootNodeSelected = false;
        Vector invalidCADTypeForPSE					= new Vector();

	invalidCADTypeForPSE.addElement("drawing");
	invalidCADTypeForPSE.addElement("insertedobject");	// for ACAD OLE Attachment
	invalidCADTypeForPSE.addElement("linkedobject");    // for SE OLE Attachment
	invalidCADTypeForPSE.addElement("embeddedComponent"); // changes for IR 585517 - embedded Component
	invalidCADTypeForPSE.addElement(MCADMxUtil.getActualNameForAEFData(IEFContext,"type_IEFDocument")); // changes for IR-707780 - edit operation is invalid for IEFDocument.

	String languageStr = request.getHeader("Accept-Language");
	String integrationName = emxGetParameter(request,"integrationName");
	String objectId  	 = emxGetParameter(request, "objectId");

        String editAction	 = emxGetParameter(request, "editAction");
		String table = emxGetParameter(request, "table");
	String[] objectIds	 = emxGetParameterValues(request, "emxTableRowId");
	String[] parentObjIds = null;
	String[] relIds		  = null;
	String errorMessage	 = "";
	String confirmMessage	 = "";
	String relId         = "";
	String parentObjId   = "";
	String parentMinorId = "";
	String ObjMinorId = "";
	BusinessObject selectedObj = null;
	BusinessObject parentObj = null;
	
	Hashtable parentchildrel = new Hashtable(); //this hashtable will have entries for selected objectid as key and parent id as value 
	

	if(null == objectIds || objectIds.length <= 0)
	{
		errorMessage = resourceBundle.getString("mcadIntegration.Server.Message.ErrorNoSelection");
	}
	else if ( (objectIds.length > 1 ) && !(editAction.equalsIgnoreCase("Remove")))
	{
		 errorMessage = resourceBundle.getString("mcadIntegration.Server.Message.MultipleSelection");
	}
	else
	{
		parentObjIds = new String[objectIds.length];
		relIds = new String[objectIds.length];
		for(int i =0; i<objectIds.length;i++)
		{
            String objectDetails = objectIds[i];
			Enumeration objectDetailsTokens = MCADUtil.getTokensFromString(objectIds[i],"|");

			if(objectDetailsTokens.hasMoreElements())
			{
				relId = (String)objectDetailsTokens.nextElement();
				relIds[i] = relId;
				if(objectDetailsTokens.hasMoreElements())
				{
					objectId = (String)objectDetailsTokens.nextElement();
					selectedObj = new BusinessObject(objectId);
					ObjMinorId = util.getLatestMinorID(IEFContext, selectedObj);
					objectIds[i] = objectId;
				}
				if(objectDetailsTokens.hasMoreElements())
				{
					parentObjId = (String)objectDetailsTokens.nextElement();
					parentObj = new BusinessObject(parentObjId);
					parentchildrel.put(objectId,parentObjId);
				
				
					parentMinorId = util.getLatestMinorID(IEFContext, parentObj);
					parentObjIds[i] = parentObjId;
				}
				if(parentObjId.equalsIgnoreCase(""))
				{
					isRootNodeSelected = true;
					if(editAction.equalsIgnoreCase("Replace") || editAction.equalsIgnoreCase("Remove") || editAction.equalsIgnoreCase("Replace Revision"))
					{
						errorMessage	= resourceBundle.getString("mcadIntegration.Server.Message.InvalidNodeSelected");
					}
				}
			}
		}

		if (objectIds!=null && objectIds.length > 0 && objectId!=null && objectId!="" && !"".equalsIgnoreCase(objectId))
		{
			if(integrationName==null)
			{
				integrationName = util.getIntegrationName(IEFContext, objectId);
			}
			globalConfigObject = integSessionData.getGlobalConfigObject(integrationName,IEFContext);
			serverUtil = new MCADServerGeneralUtil(IEFContext, globalConfigObject, integSessionData.getResourceBundle(), integSessionData.getGlobalCache());

			if(editAction.equalsIgnoreCase("Cut") || editAction.equalsIgnoreCase("Remove") || editAction.equalsIgnoreCase("Replace") || editAction.equalsIgnoreCase("Replace Revision") || editAction.equalsIgnoreCase("Add Existing"))
			{
				IEFBaselineHelper baseLineHelper = new IEFBaselineHelper(IEFContext,integSessionData,integrationName);
				boolean isConnectedToBaseline = false;
				if(editAction.equalsIgnoreCase("Add Existing")){
					isConnectedToBaseline	 = baseLineHelper.isBaselineRelationshipExistsForId(IEFContext, ObjMinorId);
				}
				else {
					isConnectedToBaseline	 = baseLineHelper.isBaselineRelationshipExistsForId(IEFContext, parentMinorId);
				}

				if(isConnectedToBaseline)
				{
					Hashtable tokensTable = new Hashtable(4);

					if(editAction.equalsIgnoreCase("Add Existing")){
						selectedObj.open(IEFContext);

						tokensTable.put("TYPE",selectedObj.getTypeName() );
						tokensTable.put("NAME",selectedObj.getName() );
						tokensTable.put("REVISION",selectedObj.getRevision() );

						selectedObj.close(IEFContext);
					}
					else{
						parentObj = new BusinessObject((String)parentchildrel.get(objectId));
						
						parentObj.open(IEFContext);

						tokensTable.put("TYPE",parentObj.getTypeName() );
						tokensTable.put("NAME",parentObj.getName() );
						tokensTable.put("REVISION",parentObj.getRevision() );

						parentObj.close(IEFContext);
					}
					errorMessage	= resourceBundle.getString("mcadIntegration.Server.Message.CannotEditBaselineStructure", tokensTable);
				}
			}

			String relNameFromMap = "";

			Hashtable relClassMapTable  = globalConfigObject.getRelationshipsOfClass(MCADServerSettings.CAD_SUBCOMPONENT_LIKE);
			Enumeration relClassEnums             = relClassMapTable.keys();
			if(relClassEnums.hasMoreElements())
			{
				relNameFromMap = (String)relClassEnums.nextElement();
			}

			for(int i =0; i<objectIds.length;i++)
			{
				try
				{
					boolean bLockStatus = false;
					BusinessObject busObj = null;
					
					busObj = new BusinessObject(objectIds[i]);
					busObj.open(IEFContext);
					String busType = busObj.getTypeName();
					String cadType= util.getCADTypeForBO(IEFContext,busObj);
					
					parentObj = new BusinessObject((String)parentchildrel.get(objectIds[i]));
					if(!MCADStringUtils.isNullOrEmpty((String)parentchildrel.get(objectIds[i])))
					{
					    parentObj.open(IEFContext);
					    String parentCadType= util.getCADTypeForBO(IEFContext,parentObj);
						
					    parentObj.close(IEFContext);
						
                        //changes made for IR-469020 (EditAction operations are restricted if the parenttype of selected object is family or instace like)
						
					    if(globalConfigObject.isTypeOfClass(parentCadType,MCADAppletServletProtocol.TYPE_FAMILY_LIKE) || globalConfigObject.isTypeOfClass(parentCadType,MCADAppletServletProtocol.TYPE_INSTANCE_LIKE))
					    {
					    	errorMessage	= resourceBundle.getString("mcadIntegration.Server.Message.InvalidParentTypeForOperation");
					    }
					}

					if(editAction.equalsIgnoreCase("Add New") || editAction.equalsIgnoreCase("Add Existing") || editAction.equalsIgnoreCase("Paste"))
					{
						if(globalConfigObject.isTypeOfClass(cadType,MCADAppletServletProtocol.TYPE_COMPONENT_LIKE))
						{
							errorMessage	= resourceBundle.getString("mcadIntegration.Server.Message.InvalidTypeForOperation");
						}
						String currentState = (String)util.getCurrentState(IEFContext, busObj).getName();
						if (serverUtil.isBusObjectFinalized(IEFContext, busObj))
						{
							errorMessage	= resourceBundle.getString("mcadIntegration.Server.Message.InvalidNodeSelected");
						}
					}
					if(globalConfigObject.isTypeOfClass(cadType,MCADAppletServletProtocol.TYPE_FAMILY_LIKE) || globalConfigObject.isTypeOfClass(cadType,MCADAppletServletProtocol.TYPE_INSTANCE_LIKE) || globalConfigObject.isTypeOfClass(cadType,MCADAppletServletProtocol.TYPE_OBJECT_WITHOUTFILE_LIKE))
					{
							errorMessage	= resourceBundle.getString("mcadIntegration.Server.Message.InvalidTypeForOperation");
					}
					if(invalidCADTypeForPSE.contains(cadType))
					{
						errorMessage	= resourceBundle.getString("mcadIntegration.Server.Message.InvalidTypeForOperation");
					}
					busObj.close(IEFContext);
					
					if(relIds!=null && relIds.length > 0)
					{
						if(!isRootNodeSelected)
						{
							if(editAction.equalsIgnoreCase("Replace") || editAction.equalsIgnoreCase("Remove") || editAction.equalsIgnoreCase("Cut"))
							{
								Relationship rel = new Relationship(relIds[i]);
								rel.open(IEFContext);
								String relType = rel.getTypeName();
								rel.close(IEFContext);

								if(!(relNameFromMap.equalsIgnoreCase(relType)))
								{
									errorMessage	= resourceBundle.getString("mcadIntegration.Server.Message.InvalidRelationshipType");
								}
							}
						}
					}
					if(!(editAction.equalsIgnoreCase("Copy")))
					{

						if(editAction.equalsIgnoreCase("Replace") || editAction.equalsIgnoreCase("Remove") || editAction.equalsIgnoreCase("Cut") || editAction.equalsIgnoreCase("Replace Revision"))
						{
							if(editAction.equalsIgnoreCase("Remove"))
							{
								confirmMessage = UINavigatorUtil.getI18nString("emxIEFDesignCenter.Confirm.Remove","emxIEFDesignCenterStringResource",languageStr);
							}
							if((parentObjIds[i]!=null) && !("".equals(parentObjIds[i])))
							{
								busObj = new BusinessObject(parentObjIds[i]);
							}
						}
						else
						{
							busObj = new BusinessObject(objectIds[i]);
						}

						busObj.open(IEFContext);
						String busName = busObj.getName();
						BusinessObject majorObj = util.getMajorObject(IEFContext, busObj);
						busObj.close(IEFContext);
						if(null == majorObj)
							majorObj = busObj;
						majorObj.open(IEFContext);
						bLockStatus = majorObj.isLocked(IEFContext);

						Hashtable errorDetails = new Hashtable();
						errorDetails.put("NAME", busName);

						if(bLockStatus)
						{
							String lockerName = majorObj.getLocker(IEFContext).getName();
							String currentUserName = IEFContext.getUser();

							if(!(lockerName.equalsIgnoreCase(currentUserName)))
							{
								 errorDetails.put("LOCKER", lockerName);
								 errorMessage = resourceBundle.getString("mcadIntegration.Server.Message.ObjectAlreadyLocked",errorDetails);
							}
						}
						else
						{
							errorMessage	= resourceBundle.getString("mcadIntegration.Server.Message.ObjectLockRequired",errorDetails);
						}
						majorObj.close(IEFContext);
					}
				  /*busObj = new BusinessObject(objectIds[i]);
					busObj.open(IEFContext);
					String busType = busObj.getTypeName();
					String cadType= util.getCADTypeForBO(IEFContext,busObj);

					parentObj.open(IEFContext);
					String parentCadType= util.getCADTypeForBO(IEFContext,parentObj);
					parentObj.close(IEFContext);

					if(globalConfigObject.isTypeOfClass(parentCadType,MCADAppletServletProtocol.TYPE_FAMILY_LIKE) || globalConfigObject.isTypeOfClass(parentCadType,MCADAppletServletProtocol.TYPE_INSTANCE_LIKE))
					{
						errorMessage	= resourceBundle.getString("mcadIntegration.Server.Message.InvalidParentTypeForOperation");
					}

					if(editAction.equalsIgnoreCase("Add New") || editAction.equalsIgnoreCase("Add Existing") || editAction.equalsIgnoreCase("Paste"))
					{
						if(globalConfigObject.isTypeOfClass(cadType,MCADAppletServletProtocol.TYPE_COMPONENT_LIKE))
						{
							errorMessage	= resourceBundle.getString("mcadIntegration.Server.Message.InvalidTypeForOperation");
						}
						String currentState = (String)util.getCurrentState(IEFContext, busObj).getName();
						if (serverUtil.isBusObjectFinalized(IEFContext, busObj))
						{
							errorMessage	= resourceBundle.getString("mcadIntegration.Server.Message.InvalidNodeSelected");
						}
					}
					if(globalConfigObject.isTypeOfClass(cadType,MCADAppletServletProtocol.TYPE_FAMILY_LIKE) || globalConfigObject.isTypeOfClass(cadType,MCADAppletServletProtocol.TYPE_INSTANCE_LIKE) || globalConfigObject.isTypeOfClass(cadType,MCADAppletServletProtocol.TYPE_OBJECT_WITHOUTFILE_LIKE))
					{
							errorMessage	= resourceBundle.getString("mcadIntegration.Server.Message.InvalidTypeForOperation");
					}
					if(invalidCADTypeForPSE.contains(cadType))
					{
						errorMessage	= resourceBundle.getString("mcadIntegration.Server.Message.InvalidTypeForOperation");
					}
					busObj.close(IEFContext);*/
				}
				catch(Exception e)
				{
					e.printStackTrace();
				}
			}
		}
	}
%>
<script language="JavaScript" src="../integrations/scripts/IEFUIConstants.js" type="text/javascript"></script>
<script language="JavaScript" src="../integrations/scripts/IEFUIModal.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUIModal.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUIConstants.js" type="text/javascript"></script>
<script language="JavaScript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>

<head>
<script language="JavaScript">

<%
	if (objectIds!=null && objectIds.length > 0 && objectId!=null && objectId!="" && !"".equalsIgnoreCase("objectId") && errorMessage!=null && "".equals(errorMessage))
{
%>
    //XSSOK
	var parentObjectId = '<%= parentObjId %>';
	//XSSOK
	var objectId = '<%=objectId%>';
	//XSSOK
	var relId = '<%=relId%>';
	var objectIds = new Array( '<%=objectIds.length%>');
	var parentObjIds = new Array( '<%=parentObjIds.length%>');
	var relIds = new Array( '<%=relIds.length%>');
	<%
		  for(int i=0; i < objectIds.length; i++)
		  {
			  %>
				  objectIds[<%=i%>] = "<%=objectIds[i]%>";
				  parentObjIds[<%=i%>] = "<%=parentObjIds[i]%>";
				  relIds[<%=i%>] = "<%=relIds[i]%>"
			  <%
		  }
}

%>

var integFrame = getIntegrationFrame(this);
var integrationName = '<%=XSSUtil.encodeForJavaScript(IEFContext,integrationName)%>';
var editAction = '<%=XSSUtil.encodeForJavaScript(IEFContext,editAction)%>';
var mxmcadApplet = integFrame.getAppletObject();

var isAppletInited = mxmcadApplet && mxmcadApplet.getIsAppletInited();


function editStructure()
{
    //XSSOK
	if("<%=errorMessage%>" == '')
	{
		var integFrame	= getIntegrationFrame(this);
		if(editAction == "Add New")
		{
			integFrame.setActiveRefreshFrame(parent.window);
			var isCheckoutRequired       = "FALSE";
			var isFolderDisabled       = "FALSE";
			var startDesignDetails = "none"+"|"+""+"|"+isCheckoutRequired+"|"+objectId+"|"+isFolderDisabled;
			integFrame.getAppletObject().callCommandHandlerSynchronously(integrationName, "createStartDesignPage", startDesignDetails);
		}
		else if(editAction == "Add Existing")
		{
                        var tableName = "<%= XSSUtil.encodeForJavaScript(IEFContext,table) %>";

			if(tableName == "null" || tableName == "")
			{
				tableName = "DSCGeneric";
			}
			var url = "../common/emxFullSearch.jsp?field=TYPES=type_CADDrawing,type_CADModel&table=" + tableName + "&showVersion=true&cancelLabel=emxFramework.GlobalSearch.Cancel&showSavedQuery=true&selection=multiple&toolbar=DSCDefaultTopActionBar&showSavedQuery=true&jpoAppServerParamList=session:GCOTable,session:GCO,session:LCO&showInitialResults=false&submitURL=../iefdesigncenter/DSCPSESearchResultCallBack.jsp?";
			showModalDialog(url, '850', '630');
		}
		else if(editAction == "Replace")
		{
                        var tableName = "<%= XSSUtil.encodeForJavaScript(IEFContext,table) %>";

			if(tableName == "null" || tableName == "")
			{
				tableName = "DSCGeneric";
			}
			var url = "../common/emxFullSearch.jsp?field=TYPES=type_CADDrawing,type_CADModel&table=" + tableName + "&showVersion=true&cancelLabel=emxFramework.GlobalSearch.Cancel&showSavedQuery=true&selection=single&toolbar=DSCDefaultTopActionBar&showSavedQuery=true&jpoAppServerParamList=session:GCOTable,session:GCO,session:LCO&showInitialResults=false&submitURL=../iefdesigncenter/DSCPSESearchResultCallBack.jsp?";
			showModalDialog(url, '850', '630');
		}

		else if(editAction == "Replace Revision")
		{
			var url = "../iefdesigncenter/DSCReplaceFinalizedRevObjectFS.jsp?parentObjectId="+parentObjectId+"&objectId="+objectId+"&integrationName="+integrationName;
			showIEFModalDialog(url, '750', '500');
		}

		else if(editAction == "Remove")
		{
		    //XSSOK
			if(confirm("<%=confirmMessage%>"))
			{
			objectId=objectIds[0];
			parentObjectId=parentObjIds[0];
			relId = relIds[0];
			for(var i=1;i<objectIds.length;i++)
			{
				objectId = objectId+"|"+objectIds[i];
				parentObjectId = parentObjectId+"|"+parentObjIds[i];
				relId = relId+"|"+relIds[i];
			}
			var connectionForm = document.connectionForm;
			connectionForm.parentObjectId.value = parentObjectId;
			connectionForm.objectId.value = objectId;
			connectionForm.relId.value = relId;
			connectionForm.editAction.value = editAction;
			connectionForm.submit();
		}
		}
		else if(editAction == "Cut")
		{
			var cutFromStructure =  eval(parent.window.emxEditableTable.prototype.cut);
            cutFromStructure();
		}
		else if(editAction == "Copy")
		{
			var coppyFromStructure =  eval(parent.window.emxEditableTable.prototype.copy);
            coppyFromStructure();
		}
		else if(editAction == "Paste")
		{
			var pasteToStructure =  eval(parent.window.emxEditableTable.prototype.pasteAsChild);
            pasteToStructure();
		}
	}
	else
	{
	    //XSSOK
		alert("<%=errorMessage%>");
	}
}

function processSearchResult(objList)
{
	try
	{
		childObjectId = objList;
		var connectionForm = document.connectionForm;
		connectionForm.parentObjectId.value = parentObjectId;
		connectionForm.objectId.value = objectId;
		connectionForm.childObjectId.value = childObjectId;
		connectionForm.relId.value = relId;
		connectionForm.editAction.value = editAction;
		connectionForm.submit();
		window.focus();
	}
	catch(e)
	{
		alert(e.message);
		return -1;
	}
	return 0;
}

</script>

</head>

<body onload= editStructure() >
<form name="connectionForm" action="DSCPSEEditActionsPostProcessing.jsp" method="post">
<%
boolean csrfEnabled = ENOCsrfGuard.isCSRFEnabled(IEFContext);
if(csrfEnabled)
{
  Map csrfTokenMap = ENOCsrfGuard.getCSRFTokenMap(IEFContext, session);
  String csrfTokenName = (String)csrfTokenMap .get(ENOCsrfGuard.CSRF_TOKEN_NAME);
  String csrfTokenValue = (String)csrfTokenMap.get(csrfTokenName);
%>
  <!--XSSOK-->
  <input type="hidden" name= "<%=ENOCsrfGuard.CSRF_TOKEN_NAME%>" value="<%=csrfTokenName%>" />
  <!--XSSOK-->
  <input type="hidden" name= "<%=csrfTokenName%>" value="<%=csrfTokenValue%>" />
<%
}
//System.out.println("CSRFINJECTION::DSCPSEEditActionsPreProcessing.jsp::form::connectionForm");
%>

   <input type="hidden" name="parentObjectId" value="">
   <input type="hidden" name="objectId" value="">
   <input type="hidden" name="childObjectId" value="">
   <input type="hidden" name="relId" value="">
   <input type="hidden" name="editAction" value="">
</form>
</body>

