<%--  emxDSCWorkspaceMgmtRefreshFiles.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--Perform refresh (i.e. checkout current) on selected files

--%>

<%@ include file="../integrations/MCADTopInclude.inc" %>
<%@ include file="../integrations/MCADTopErrorInclude.inc" %>
<%@ include file="emxDSCWorkspaceMgmtUtils.inc" %>

<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<html>
<head>
</head>
<body>

<script language="javascript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>

<%
   String acceptLanguage = request.getHeader("Accept-Language");
   
   // Retrieve selected items from the table
   String[] tableRowIds = emxGetParameterValues(request, "emxTableRowId");

   // Retrieve other parameters
   String action = emxGetParameter(request, "action");  // "refresh" or "revert"
   String dirPath = (String) session.getAttribute("wsmDirPath");
   String dirSep = (String) session.getAttribute("wsmDirSep");
 
   MCADServerResourceBundle serverResourceBundle = new MCADServerResourceBundle(acceptLanguage);
   MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
   MCADSessionData sessionData = integSessionData.getSessionData();
   Context context = integSessionData.getClonedContext(session);
   MCADMxUtil util = new MCADMxUtil(context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
   
   ENOCsrfGuard.validateRequest(context, session, request, response);
   
   if(integSessionData != null)
   {
      try
      {
         // Filter out non-matrix selections
         Vector parsedSelection = this.parseSelection(context, tableRowIds, integSessionData, util, true, true);
         Vector objectIds		= (Vector) parsedSelection.elementAt(0);
         Vector fileNames		= (Vector) parsedSelection.elementAt(1);
         String integrationName = (String) parsedSelection.elementAt(2);

         if (objectIds.size() >  0)
         {

            // Verify selections are all for a single integration
            if (integrationName.length() > 0)
            {
            	String xmlString = "";
            	
            	if (action.equalsIgnoreCase("refresh"))
            	{

			   // Create XML packet for downloading files
			   xmlString = "<?xml version=\"1.0\"?><command name='checkforupdatecurrent' cse='" + integrationName + "'>";
			   
			   xmlString += "<cadobjectlist>";
			   
			   for (int ii = 0; ii < objectIds.size(); ii++)
			   {
			   	  String cadType = "";
			   	  
				  String objectId = (String) objectIds.elementAt(ii);
				  String fileName = (String) fileNames.elementAt(ii);
				  MCADBusObjectSessionInfo[] boInfo = sessionData.getData(fileName, dirPath, "");
				  String revisionToGet = boInfo[0].getRevision();
				  String objectIdToGet = boInfo[0].getObjectId();

				  // If doing a refresh, get the latest revision info and update revisionToGet and
				  // objectIdToGet

				  if (action.equalsIgnoreCase("refresh"))
				  {
						BusinessObject busObj = new BusinessObject(boInfo[0].getObjectId());
   
						// Get latest revision/version from JPO.
						busObj.open(context);
						String[] args		= new String[4];
						String [] packedGCO = JPO.packArgs(integSessionData.getGlobalConfigObject(integrationName,context));
						cadType				= util.getCADTypeForBO(context,busObj);
						objectIdToGet		= busObj.getObjectId();
						
						busObj.close(context);                     			
					}

				  xmlString += "<cadobject cadid='" + objectIdToGet;
				  xmlString += "' type='" + cadType;
				  xmlString += "' mxfilename='" + fileName;
				  xmlString += "' fullfilename='" + dirPath + dirSep + fileName;
				  xmlString += "' mxdirname='" + dirPath;
				  xmlString += "' name='" + boInfo[0].getName();
				  xmlString += "' uid='" + boInfo[0].getName() + "|" + dirPath + dirSep + fileName;
				  xmlString += "' modified='false' selectable='true' />";
				  
			   }
	       xmlString += "</cadobjectlist>";		
               xmlString += "</command>";
               //System.out.println("+++++++++++++++++xmlString=" + xmlString);
		   try 
		   {
		       xmlString = MCADUrlUtil.hexEncode(xmlString);
		   }
		   catch(Exception exception)
		   {
			   System.out.println("Exception: " + exception.getMessage());
		   }
		}
		else //Revert action
		{
			// Create XML packet for downloading files
			   boolean isFileReadOnlyBehaviour = false;
			   xmlString = "<?xml version=\"1.0\"?><files >";
			   for (int ii = 0; ii < objectIds.size(); ii++)
			   {
				  String objectId = (String) objectIds.elementAt(ii);
				  String fileName = (String) fileNames.elementAt(ii);
				  MCADBusObjectSessionInfo[] boInfo = sessionData.getData(fileName, dirPath, "");
				  String revisionToGet = boInfo[0].getRevision();
				  String objectIdToGet = boInfo[0].getObjectId();
				  String typeToGet = boInfo[0].getType();
				  
				  BusinessObject revertbusObj = new BusinessObject(boInfo[0].getObjectId());
				  revertbusObj.open(context);
				  
			          MCADServerGeneralUtil serverGeneralUtil = new MCADServerGeneralUtil(context,integSessionData, integrationName);
			          boolean isFinalized = serverGeneralUtil.isBusObjectFinalized(context,revertbusObj);
			          // [NDM] OP6
					  boolean isMajor  = util.isMajorObject(context, revertbusObj.getObjectId());//integSessionData.getGlobalConfigObject(integrationName, integSessionData.getClonedContext(session)).isMajorType(revertbusObj.getTypeName());
					      
			          //If Business Object is finalized, checkout the file from Major obejct as Minor object does
			          // not have file
					  String locker = null;
			          if(isFinalized && !isMajor)
			          {
			                 BusinessObject majorBusObj = util.getMajorObject(context,revertbusObj);
			                 majorBusObj.open(context);
			                 objectIdToGet = majorBusObj.getObjectId();
							 revisionToGet = majorBusObj.getRevision();
			                 typeToGet = majorBusObj.getTypeName();
			                 majorBusObj.close(context);
			                 
			           }
					   String objectIdforWsEntry = null;
					   if(isFinalized)
				       {	
						   locker  = revertbusObj.getLocker(context).getName();
						   objectIdforWsEntry = revertbusObj.getObjectId();
					   }
					   else
					   {
					      BusinessObject majorBusObj = util.getMajorObject(context,revertbusObj);
			              majorBusObj.open(context);
						  objectIdforWsEntry = majorBusObj.getObjectId();
						  locker  = majorBusObj.getLocker(context).getName();
			                 majorBusObj.close(context);

			           }
					   String makeFileReadOnly = "true";
					   String workingSetDir	   = null;	
			           if(integSessionData.getGlobalConfigObject(integrationName,context) != null && integSessionData.getGlobalConfigObject(integrationName,context).isFileReadOnlyBehaviour())
					   {
							isFileReadOnlyBehaviour = true;
							String userName = context.getUser();
							if(locker != null && locker.length() > 0 && locker.equals(userName))
						    {
								makeFileReadOnly = "false";	
							}
							StringList oidList = new StringList();
		                	oidList.add(objectIdforWsEntry);

							Hashtable workingSetTable = util.getWorkingSetEntries(context,integSessionData.getGlobalConfigObject(integrationName,context),integSessionData,oidList);
			           
							 workingSetDir = (String)workingSetTable.get(objectIdforWsEntry);
					   }
			           revertbusObj.close(context);
			           
				  // If doing a refresh, get the latest revision info and update revisionToGet and
				  // objectIdToGet
				
				  if (action.equalsIgnoreCase("refresh"))
				  {
						BusinessObject busObj = new BusinessObject(boInfo[0].getObjectId());
   
						// Get latest revision/version from JPO.
						busObj.open(context);
						String nameCadTypeArg = boInfo[0].getName() + "|" + util.getCADTypeForBO(context,busObj);
			
						Hashtable argsForJPO = new Hashtable();
						argsForJPO.put("NameAndCadType", nameCadTypeArg);
						argsForJPO.put(MCADServerSettings.GCO_OBJECT, integSessionData.getGlobalConfigObject(integrationName,context));
						argsForJPO.put(MCADServerSettings.LANGUAGE_NAME, integSessionData.getLanguageName());

						String [] packedArgs = JPO.packArgs(argsForJPO);

						String latestRevisionAndVersion = (String)util.executeJPO(context,"MCADGetLatestRevisionAndVersion", "getRevisionAndVersion" , packedArgs, String.class);
						busObj.close(context);
			
						// Set the revision to download as the latest
						StringTokenizer tokens = new StringTokenizer(latestRevisionAndVersion, "|");
						revisionToGet = (String) tokens.nextElement() + "." + (String) tokens.nextElement();

						//FIXME - may want to do a check and skip this file if the current rev == latest and file is not obsolete
						//        (i.e. newer file checked into same version, note this may be an expensive check).
   
						// Get the oid of the latest major business object.  Note this is needed
						// because RefreshHelper.downloadFiles seems to ignore the requested mxversion and
						// always gets the specified oid.
						BusinessObject majorObj = new BusinessObject(boInfo[0].getType(), boInfo[0].getName(), revisionToGet, "");
						majorObj.open(context);
						objectIdToGet = majorObj.getObjectId();
						majorObj.close(context);
					}
				  
				  String familyID				  = serverGeneralUtil.getTopLevelFamilyObjectForInstance(context, objectIdToGet);
				  String instancehasfile		  = "";

				  if(familyID != null && !familyID.equals("") && !familyID.equals("null"))
				  {
						instancehasfile = "true";
				  }
				  else
				  {
						familyID = "";
				  }
				  
				  xmlString += "<file>";
				  xmlString += "<busid>" + objectIdToGet + "</busid>";
				  xmlString += "<familyid>" + familyID + "</familyid>";
				  xmlString += "<instancehasfile>" + instancehasfile + "</instancehasfile>";
				  xmlString += "<formatname>" + boInfo[0].getFormat() + "</formatname>";
				  xmlString += "<filename>" + fileName + "</filename>";
				  xmlString += "<filenamewithpath>" + dirPath + dirSep + fileName + "</filenamewithpath>";
				  xmlString += "<mxtype>" + typeToGet + "</mxtype>";
				  xmlString += "<name>" + boInfo[0].getName() + "</name>";
				  xmlString += "<mxversion>" + revisionToGet + "</mxversion>";
				  xmlString += "<filepath>" + dirPath + "</filepath>";
				  if(isFileReadOnlyBehaviour)
				  {
					  xmlString += "<workingsetlocationlist>" + workingSetDir + "</workingsetlocationlist>";
					  xmlString += "<makefilereadonly>" + makeFileReadOnly + "</makefilereadonly>";
				  }
				  xmlString += "</file>";
			   }
           	   xmlString += "</files>";
			   
			   // To protect backslash chars through to javascript
			   xmlString = MCADUrlUtil.hexEncode(xmlString);			  			   
		}
		
               String confirmMsg;
               if (action.equalsIgnoreCase("refresh"))
                  confirmMsg = UINavigatorUtil.getI18nString("emxIEFDesignCenter.WorkspaceMgmt.RefreshConfirmDialog","emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"));
               else
                  confirmMsg = UINavigatorUtil.getI18nString("emxIEFDesignCenter.WorkspaceMgmt.RevertConfirmDialog","emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"));

%>
               <script language="JavaScript">

                  // Confirm user really wants to do this and execute the refresh
                  // Note the details frame will be refreshed from the applet
				  //XSSOK
                  var action = "<%= action %>";
                  if(action == "refresh")
                  {
                  //doRefresh = confirm('<%= confirmMsg %>');
                  //if (doRefresh)
                  {
                     var integFrame	= getIntegrationFrame(window);
					 //XSSOK
					 var xmlString	= hexDecode('<%= integrationName %>', "<%=xmlString%>");
					 //XSSOK
                     integFrame.getAppletObject().callCommandHandler("<%= integrationName %>", 'createRefreshSelectionPage', xmlString);
                  }
	          }
	          else
	          {
	          	  // Confirm user really wants to do this and execute the refresh
	                  // Note the details frame will be refreshed from the applet
					  //XSSOK
	                  doRefresh = confirm("<%= confirmMsg %>");
	                  if (doRefresh)
	                  {
	                     var integFrame	= getIntegrationFrame(window);
						 //XSSOK
						 var xmlString	= hexDecode('<%= integrationName %>', "<%= xmlString %>");
						 //XSSOK
						 integFrame.getAppletObject().callCommandHandler("<%= integrationName %>", 'wsmDownloadFiles', xmlString);
	                  }
	          }
               </script>
<%
            }
            else // Multiple integrations were selected
            {
%>
               <script language="javascript" type="text/javascript">
			                  //XSSOK
                              alert ("<%=  UINavigatorUtil.getI18nString("emxIEFDesignCenter.ErrorMsg.MultipleIntegrationTypesSelected","emxIEFDesignCenterStringResource", acceptLanguage) %>");
               </script>               
<%
            }
         }
         else
         {
%>
               <script language="javascript" type="text/javascript">
			      //XSSOK
                  alert ("<%=  UINavigatorUtil.getI18nString("emxIEFDesignCenter.ErrorMsg.NoMatrixItemsSelected","emxIEFDesignCenterStringResource", acceptLanguage) %>");
               </script>               
<%
         }
      }
      catch(Exception exception)
      {
         emxNavErrorObject.addMessage(exception.getMessage());
      }
   }
   else
   {  
      String errorMessage  = serverResourceBundle.getString("mcadIntegration.Server.Message.ServerFailedToRespondSessionTimedOut");    
      emxNavErrorObject.addMessage(errorMessage);
   }
%>

</body>
</html>
