<%--  DSCPSEEditActionsPostProcessing.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>

<%@ include file ="../integrations/MCADTopInclude.inc" %>

<%@ include file="../integrations/MCADTopErrorInclude.inc" %>
<%@page import = "com.matrixone.apps.domain.util.*" %>

<%!
	public boolean doesCircularReferenceExist(Context context, String parentId, String childId, MCADMxUtil util, String relName, String relEnd)
	{
		boolean isParent = false;
		String end       = "to";
		try
		{
			BusinessObject parentObj = new BusinessObject(parentId);
			BusinessObject childObj = new BusinessObject(childId);
			if( (relEnd!=null) && !("".equals(relEnd)) && (relEnd.equalsIgnoreCase("to")))
			{
				end   = "from";						
			}			
			BusinessObjectList relatedBusObjList = util.getRelatedBusinessObjects(context, childObj, relName, end, (short)1, null);
			relatedBusObjList.add(childObj);
			BusinessObjectItr itr = new BusinessObjectItr(relatedBusObjList);
			while(itr.next())
			{
				BusinessObject busObj = itr.obj();
				String busId = busObj.getObjectId();
				if(busId.equalsIgnoreCase(parentId))
				{
					isParent = true;				
				}
			}
		}
		catch(Exception e)
		{
			System.out.println("Error :: "+e.getMessage());
		}
		return isParent;
	}


	private HashMap getAssemblyStructure(Context context, String parentId, MCADMxUtil util, String relName, String relEnd)
	{
		HashMap assemblyStructure = new HashMap();
		String end       = "to";
		
		String busId				= "";
		String busName				= "";
		String busTypeName			= "";
		String busRevision			= "";
				
		try 
		{
			if( (relEnd!=null) && !("".equals(relEnd)) && (relEnd.equalsIgnoreCase("to")))
			{
				end   = "from";						
			}

			BusinessObject parentObj = new BusinessObject(parentId);
				
					
			Hashtable childTNRTable = new Hashtable();
			BusinessObjectList relatedBusObjList = util.getRelatedBusinessObjects(context, parentObj, relName, end, (short)1, null);
			BusinessObjectItr itr = new BusinessObjectItr(relatedBusObjList);

			while(itr.next())
			{
				BusinessObject busObj = itr.obj();
				busId = busObj.getObjectId();
				
				busObj.open(context);
				
				busName			= busObj.getName();
				busTypeName		= busObj.getTypeName();
				busRevision		= busObj.getRevision();
				//For caching
				String key = busTypeName +"|"+ busName;
				childTNRTable.put(key,busRevision);
				assemblyStructure.put(parentId,childTNRTable);
				busObj.close(context);
			}
		}
		catch(Exception e)
		{
			System.out.println("Error :: "+e.getMessage());
		}
		return assemblyStructure;
	}
	
	public boolean isBusTypeMappedInGCO(Context context, String childId, MCADGlobalConfigObject globalConfigObject, MCADMxUtil util)
	{
		boolean isTypeMapped = false;
		try
		{		
			BusinessObject childObj = new BusinessObject(childId);
			childObj.open(context);
			String childObjType		= childObj.getTypeName();
			childObj.close(context);

			Vector mappedMxTypes	= globalConfigObject.getAllMappedTypes();	   
			Enumeration mappedMxTypesElements = mappedMxTypes.elements(); 	   
			while(mappedMxTypesElements.hasMoreElements())
			{			
				String mxType = (String)mappedMxTypesElements.nextElement();
				String correspondingMxType = util.getCorrespondingType(context, mxType);
				if( childObjType.equalsIgnoreCase(correspondingMxType.trim()) || childObjType.equalsIgnoreCase(mxType.trim()))
				{
					isTypeMapped = true;
				}
			}
		}
		catch(Exception e)
		{
			System.out.println("Error :: "+e.getMessage());
		}
		return isTypeMapped;
	}

	public boolean isCadTypeAllowedForPSE(String cadType)
	{
		// for ACAD OLE and SE OLE Attachment
		if(cadType.equals("insertedobject") || cadType.equals("linkedobject") || cadType.equals("embeddedComponent"))
			return true;
		else 
			return false;
	}

	private boolean isSameObjectWithDiffRev(Context context, String objectId, String childId, MCADMxUtil util, MCADGlobalConfigObject globalConfigObject)
	{
		boolean retValue	= false;

		try
		{
			String oldBusName		= "";
			String oldBusType		= "";
			String newBusName		= "";
			String newBusType		= "";

			String[] objIds			= new String[2];
			objIds[0]				= objectId;
			objIds[1]				= childId;
			
			String REL_VERSION_OF	= MCADMxUtil.getActualNameForAEFData(context, "relationship_VersionOf");
			String SELECT_ON_MAJOR	= "from[" + REL_VERSION_OF + "].to.";

			StringList busSelectionList = new StringList();
			busSelectionList.add("id");
			busSelectionList.add("name");
			busSelectionList.add("type");
			busSelectionList.add(SELECT_ON_MAJOR + "type");

			BusinessObjectWithSelectList buslWithSelectionList = BusinessObject.getSelectBusinessObjectData(context, objIds, busSelectionList);		

			for(int i = 0; i < buslWithSelectionList.size(); i++)
			{			
				BusinessObjectWithSelect busObjectWithSelect = (BusinessObjectWithSelect)buslWithSelectionList.elementAt(i);

				String id		= busObjectWithSelect.getSelectData("id");
				String name		= busObjectWithSelect.getSelectData("name");
				String type		= busObjectWithSelect.getSelectData("type");

				if(!util.isMajorObject(context, id))//! globalConfigObject.isMajorType(type)) // [NDM] OP6
					type = util.getCorrespondingType(context, type);

				if(null != id && ! "".equals(id) && id.equals(objectId))
				{
					oldBusName	= name;
					oldBusType	= type;
				}
				
				if(null != id && ! "".equals(id) && id.equals(childId))
				{
					newBusName	= name;
					newBusType	= type;
				}
			}
			
			if(null != oldBusName && null != oldBusType && null != newBusName && null != newBusType 
			&& !"".equals(oldBusName) && !"".equals(oldBusType) && !"".equals(newBusName) && !"".equals(newBusType) && oldBusName.equals(newBusName) && oldBusType.equals(newBusType))
				retValue = true;
		}
		catch(Exception e)
		{
			System.out.println("Exception occured : "+e.getMessage());
		}

		return retValue;
	}
%>


<%		
	String childObjectId	= Request.getParameter(request,"childObjectId");
	String parentObjectId	= Request.getParameter(request,"parentObjectId");
	String relId			= Request.getParameter(request,"relId");
	String objectId			= Request.getParameter(request,"objectId");
	String editAction		= Request.getParameter(request,"editAction");
	String integrationName	= Request.getParameter(request,"integrationName");
	String acceptLanguage	= request.getHeader("Accept-Language");
	
	String errorMessage				= "";
	String childObjectIds[]			= null;	

	MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
	Context context								= integSessionData.getClonedContext(session);
	MCADServerResourceBundle resourceBundle     =  integSessionData.getResourceBundle();
	MCADMxUtil util		                        = new MCADMxUtil(context, integSessionData.getLogger(),resourceBundle,integSessionData.getGlobalCache()); 
	String objId								= objectId;	
	
	if(objectId.contains("|"))
		objId = objectId.substring(0,objectId.indexOf("|"));

	if(integrationName==null)
	{		
		integrationName = util.getIntegrationName(context, objId);
	}

	MCADGlobalConfigObject globalConfigObject	= integSessionData.getGlobalConfigObject(integrationName,context);
	MCADServerGeneralUtil serverUtil			= new MCADServerGeneralUtil(context, globalConfigObject, integSessionData.getResourceBundle(), integSessionData.getGlobalCache());	
    
	String relName	        	= "";
	String relType				= "";
	String relEnd               = "";  
	Hashtable relClassMapTable  = globalConfigObject.getRelationshipsOfClass(MCADServerSettings.CAD_SUBCOMPONENT_LIKE);
	Enumeration relClassEnums   = relClassMapTable.keys();

	if(relClassEnums.hasMoreElements())
	{
		relName = (String)relClassEnums.nextElement();		
		relEnd = (String)relClassMapTable.get(relName);					
	}

    relType = relName +"|"+relEnd;

	String callbackFunctionName = "loadMarkUpXML";
    
	HashMap assemblyStructure = null;
	
    if( editAction.equalsIgnoreCase("Add Existing") || editAction.equalsIgnoreCase("Replace") || editAction.equalsIgnoreCase("Replace Revision"))
	{
		boolean isSameObjectWithDiffRev = false;

		if(editAction.equalsIgnoreCase("Replace"))
			isSameObjectWithDiffRev = isSameObjectWithDiffRev(context, objectId, childObjectId, util, globalConfigObject);

		if(! isSameObjectWithDiffRev)
		assemblyStructure = getAssemblyStructure(context, objectId, util, relName, relEnd);
		else			
			errorMessage = resourceBundle.getString("mcadIntegration.Server.Message.SameObjectWithDiffRev");
	}
	
	if(!editAction.equalsIgnoreCase("Remove"))
	{		
		boolean isParentFinalized = false;
		
		if(null != objectId && !objectId.equals(""))
		{
			BusinessObject parentBusObj = new BusinessObject(objectId);
			parentBusObj.open(context);
			
			if(serverUtil.isBusObjectFinalized(context, parentBusObj))
				isParentFinalized = true;

			parentBusObj.close(context);
		}
		
		StringTokenizer childObjectIdsDetails = new StringTokenizer(childObjectId,"|");						
		if(childObjectIdsDetails.hasMoreTokens())
		{			
			childObjectIds = new String[childObjectIdsDetails.countTokens()];			
			for( int i=0; i<childObjectIds.length; i++)
			{	
				childObjectIds[i]		= childObjectIdsDetails.nextToken();		
				BusinessObject busObj	= new BusinessObject(childObjectIds[i]);					
				busObj.open(context);		
				String busType			= busObj.getTypeName();
				
				boolean isChildFinalized	= false;
				if (util.isMajorObject(context, busObj.getObjectId()))//globalConfigObject.isMajorType(busType)) // [NDM] OP6
				{
					if (!serverUtil.isBusObjectFinalized(context, busObj))
					{		
						childObjectIds[i] = util.getActiveVersionObject(context, childObjectIds[i]);
					}
					else
						isChildFinalized = true;
				}
				else if (serverUtil.isBusObjectFinalized(context, busObj))
				{
					isChildFinalized	= true;
					busObj				= util.getMajorObject(context, busObj);
					childObjectIds[i]	= busObj.getObjectId(context);
				}
				String childName = busObj.getName();
	
				String childTypeName = busObj.getTypeName();
				String childRevision = busObj.getRevision();
			
				busObj.close(context);
				boolean isMappedTypeforIntegration = isBusTypeMappedInGCO(context, childObjectIds[i], globalConfigObject,util);

				boolean isCadTypeAllowedForPSE     = isCadTypeAllowedForPSE(util.getCADTypeForBO(context, busObj));
								
				if(isMappedTypeforIntegration)
				{
					if(isParentFinalized && !isChildFinalized)
					{
						Hashtable msgTable = new Hashtable();
						msgTable.put("NAME", childName);
						errorMessage = resourceBundle.getString("mcadIntegration.Server.Message.StateMissMatch", msgTable);
					}
					else if(isCadTypeAllowedForPSE)
					{
						Hashtable errorDetails = new Hashtable();
						String errorData = resourceBundle.getString("mcadIntegration.Server.ColumnName.Type")+ " " + ":" + " " + childTypeName + " " + resourceBundle.getString("mcadIntegration.Server.ColumnName.Name") + " " + ":" + " " + childName;
						errorDetails.put("NAME", errorData);
						errorMessage = resourceBundle.getString("mcadIntegration.Server.Message.InvalidCadTypeSelected", errorDetails);
					}
					else
					{
						boolean isParent = false;
						if( editAction.equalsIgnoreCase("Add Existing"))
						{	
							if(null != assemblyStructure && !assemblyStructure.isEmpty() && assemblyStructure.containsKey(objectId))
							{
								Hashtable childTable = (Hashtable)assemblyStructure.get(objectId);
								String inputKey = childTypeName + "|" + childName;
								String existingChildRevision = "";

								if(childTable.containsKey(inputKey))
								{
									existingChildRevision = (String)childTable.get(inputKey);
								}

								if(!"".equals(existingChildRevision) && !childRevision.equals(existingChildRevision.trim()))
								{
									Hashtable msgTable = new Hashtable();
									String key = childTypeName + " " + childName;
									msgTable.put("NAME", key);
									errorMessage = resourceBundle.getString("mcadIntegration.Server.Message.InvalidSelection", msgTable);
								}
							}
						
							
							isParent = doesCircularReferenceExist(context, objectId, childObjectIds[i], util, relName, relEnd);
						}
						else if (editAction.equalsIgnoreCase("Replace") || editAction.equalsIgnoreCase("Replace Revision"))
						{
							isParent = doesCircularReferenceExist(context, parentObjectId, childObjectIds[i], util, relName, relEnd);
						}
						if(isParent)
						{
							errorMessage = resourceBundle.getString("mcadIntegration.Server.Message.ReplaceDesignCircularRef");	
						}
					}
				}
				else
				{
					Hashtable errorDetails = new Hashtable();
					errorDetails.put("INTEGNAME",integrationName);
					errorMessage = resourceBundle.getString("mcadIntegration.Server.Message.UnSupportedTypeForIntegration",errorDetails);
				}				
			}
		}		
	}    	
	
	String strInput = "<mxRoot>";
	String markup    = "";

	if((errorMessage == null) || ("".equals(errorMessage.trim())))
	{
		if(editAction.equalsIgnoreCase("Add New"))
		{
			try
			{			
				strInput = strInput + "<object objectId=\"" + objectId + "\">";
				int i = 0;
				for( i =0; i<childObjectIds.length; i++)
				{
					strInput = strInput + "<object objectId=\""+childObjectIds[i]+"\" relId=\"" +relId+ "\" relType=\""+relType+"\" markup=\"add\"></object>";
				}
				strInput = strInput+ "</object></mxRoot>";			
				%>

			

				<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
				<script language="javascript" src="../integrations/scripts/MCADUtilMethods.js"></script>
				<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
				<script language="Javascript">				

				var integFrame	= getIntegrationFrame(this);
				var contentFrame = integFrame.getActiveRefreshFrame();				
                //XSSOK				
				var callbackFunction = eval(contentFrame.emxEditableTable.prototype.<%=callbackFunctionName%>);	
				//XSSOK
				callbackFunction('<%=strInput%>', "true");
				parent.window.close();

				</script>
			<%
			}
			catch(Exception e)
			{
			}
		}
		else if(editAction.equalsIgnoreCase("Add Existing"))
		{			
			try
			{
				strInput = strInput + "<object objectId=\"" + objectId + "\">";
				int i = 0;
				for( i =0; i<childObjectIds.length; i++)
				{
					strInput = strInput + "<object objectId=\""+childObjectIds[i]+"\" relId=\"" +relId+ "\" relType=\""+relType+"\" markup=\"add\"></object>";
				}
				strInput = strInput+ "</object></mxRoot>";	
			%>
				<script language="Javascript"> 					
                //XSSOK				
				var callbackFunction = eval(parent.window.emxEditableTable.prototype.<%=callbackFunctionName%>);
                //XSSOK
				var status = callbackFunction('<%=strInput%>', "true");
				</script>
			<%					
			}
			catch(Exception e)
			{
			}		
		}

		else if(editAction.equalsIgnoreCase("Replace"))
		{		
			try
			{
				if( "".equalsIgnoreCase(relId) || (relId==null))
				{
					Vector relLst = util.findRelationShip(context,objectId, parentObjectId,
					true, "all", relName);				
					relId = (String) relLst.firstElement();						
				}
				strInput = strInput + "<object objectId=\"" + parentObjectId + "\"><object objectId=\""+objectId+"\" relId=\"" + relId + "\" markup=\"cut\"></object>";

				childObjectId = childObjectIds[0];

				strInput = strInput + "<object objectId=\""+childObjectId+"\" relId=\"" +relId+ "\" relType=\""+relType+"\" markup=\"add\"></object>";

				strInput = strInput + "</object></mxRoot>";

			%>			
				<script language="Javascript"> 
                //XSSOK
				var callbackFunction = eval(parent.window.emxEditableTable.prototype.<%=callbackFunctionName%>); 
				//XSSOK
				var status = callbackFunction('<%=strInput%>', "true");	

				</script>
				
			<%

			}
			catch(Exception e)
			{
			}
		}	

		else if(editAction.equalsIgnoreCase("Replace Revision"))
		{		
			try
			{
				if( "".equalsIgnoreCase(relId) || (relId==null))
				{
					Vector relLst = util.findRelationShip(context,objectId, parentObjectId,
					true, "all", relName);				
					relId = (String) relLst.firstElement();						
				}

				//For MicroStation no CAD Subcomponent Relationship
				//However Replace  Revision alone is allowed
				if((null == relType || "".equals(relType) || "|".equals(relType.trim())) && (relId!=null && !"".equalsIgnoreCase(relId)))
				{
					Relationship oldRel = new Relationship(relId);	
					oldRel.open(context);
					
					relName = oldRel.getTypeName();

					relEnd = (String) globalConfigObject.getRelationshipsOfClass(MCADAppletServletProtocol.ASSEMBLY_LIKE).get(relName);		

					oldRel.close(context);

					relType = relName +"|"+relEnd;
				}

				if(null == relType || "".equals(relType) || "|".equals(relType.trim()))
					relType = "CAD SubComponent|to";

				//relType = relType + "|remove|"+objectId;

				strInput = strInput + "<object objectId=\"" + parentObjectId + "\"><object objectId=\""+objectId+"\" relId=\"" + relId + "\" relType=\""+relType+ "\" markup=\"cut\"></object>";
				
				childObjectId = childObjectIds[0];
				
				strInput = strInput + "<object objectId=\""+childObjectId+"\" tobeRemovedId=\""+objectId+"\" relId=\"" +relId+ "\" relType=\""+relType+"\" markup=\"add\"></object>";

				strInput = strInput + "</object></mxRoot>";

			%>			
				<script language="Javascript"> 
                //XSSOK
				var callbackFunction = eval(parent.window.emxEditableTable.prototype.<%=callbackFunctionName%>); 
				//XSSOK
				var status = callbackFunction('<%=strInput%>', "true");	

				</script>
				
			<%

			}
			catch(Exception e)
			{
			}
		}

		else if(editAction.equalsIgnoreCase("Remove"))
		{		
			try
			{			
				StringTokenizer objectIdsDetails = new StringTokenizer(objectId,"|");
				StringTokenizer parentObjIdsDetails = new StringTokenizer(parentObjectId,"|");	
				StringTokenizer relIdsDetails = new StringTokenizer(relId,"|");			
				

				if(objectIdsDetails.hasMoreTokens())
				{					
					int count = objectIdsDetails.countTokens();
					for( int i=0; i<count; i++)			
					{					
						objectId = objectIdsDetails.nextToken();
						if(parentObjIdsDetails.hasMoreTokens())
						{
							parentObjectId = parentObjIdsDetails.nextToken();
						}
						if(relIdsDetails.hasMoreTokens())
						{
							relId = relIdsDetails.nextToken();
						}					
						if( "".equalsIgnoreCase(relId) || (relId==null))
						{
							Vector relLst = util.findRelationShip(context,objectId, parentObjectId,
							true, "all", relName);				
							relId = (String) relLst.firstElement();						
						}					
						strInput = strInput + "<object objectId=\"" + parentObjectId + "\"><object objectId=\""+objectId+"\" relId=\"" + relId + "\" relType=\""+relType+ "\" markup=\"cut\"></object></object>";
					}
					
					strInput = strInput + "</mxRoot>";					
					
					%>

						<script language="Javascript">  				
						//XSSOK
						var callbackFunction = eval(parent.window.emxEditableTable.prototype.<%=callbackFunctionName%>);			 
                        //XSSOK						
						var status = callbackFunction('<%=strInput%>', "true");
						
						</script>

					<%	
				}	
							}
			catch(Exception e)
			{
			}
		} 
	}
%>
	 <%@include file = "../common/enoviaCSRFTokenValidation.inc"%>
<head>
<script language="JavaScript" src="../integrations/scripts/IEFUIConstants.js" type="text/javascript"></script>
<script language="JavaScript" src="../integrations/scripts/IEFUIModal.js" type="text/javascript"></script>
<script language="JavaScript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>

<script language="JavaScript">	

function showErrorMessage()
{		
    //XSSOK
	if("<%=errorMessage%>" != '')
	{	
	    //XSSOK
		alert("<%=errorMessage%>");
	}
}

</script>
</head>

<body onload= showErrorMessage() >

</body>
