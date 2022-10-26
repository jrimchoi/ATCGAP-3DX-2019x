<%--  emxDSCWorkspaceMgmtLockUnlockFiles.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>


<%@ include file="../integrations/MCADTopInclude.inc" %>
<%@ include file="../integrations/MCADTopErrorInclude.inc" %>
<%@ include file="emxDSCWorkspaceMgmtUtils.inc" %>

<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>
<%
	String acceptLanguage = request.getHeader("Accept-Language");
	   
	// Retrieve selected items from the table
	String[] tableRowIds = emxGetParameterValues(request, "emxTableRowId");

	// Retrieve other parameters
	String action  = emxGetParameter(request, "action");  // "lock" or "unlock"
	String dirPath = (String) session.getAttribute("wsmDirPath");
	String dirSep  = (String) session.getAttribute("wsmDirSep");

	MCADServerResourceBundle serverResourceBundle	= new MCADServerResourceBundle(acceptLanguage);
	MCADIntegrationSessionData integSessionData		= (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
	MCADSessionData sessionData						= integSessionData.getSessionData();

	Context _context = integSessionData.getClonedContext(session);
	MCADMxUtil util  = new MCADMxUtil(_context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());

	Vector objectIds				= null;
	Vector fileNames				= null;
	String operationStatus			= "";
	String integNameForSelection	= "";
	Vector wsEntryBoids				= null;

	   ENOCsrfGuard.validateRequest(_context, session, request, response);
	
	if(integSessionData != null)
	{
		try
		{
			// Filter out non-matrix selections
			Vector parsedSelection = this.parseSelection(_context, tableRowIds, integSessionData, util, true, true);
		 
			objectIds				= (Vector) parsedSelection.elementAt(0);
			fileNames				= (Vector) parsedSelection.elementAt(1);
			integNameForSelection	= (String) parsedSelection.elementAt(2);
			wsEntryBoids 			= (Vector) parsedSelection.elementAt(3);
   
			// Determine if locking or unlocking
			boolean bLock = false;
			if (action.equalsIgnoreCase("lock")) 
				bLock = true;
   
			// Cycle the selected objects and retrieve the object ID for each and do the lock/unlock   

			String objIds = null;
			StringBuffer objIdBuffer = new StringBuffer();
			String integrationName								  = null;
			for (int ii=0; ii < objectIds.size(); ii++)
			{
				String objectId = (String) objectIds.elementAt(ii);

				objIdBuffer.append(objectIds.elementAt(ii));
				if(ii < objectIds.size() -1)
				objIdBuffer.append("#");
				
				integrationName								  = util.getIntegrationName(_context, objectId);
			}
			objIds = objIdBuffer.toString();			

			String makeFileReadOnlyDetails = null;
			makeFileReadOnlyDetails = objIds+"|"+bLock+"|"+integrationName;
			String headerRes = "mcadIntegration.Server.Title.LockUnlokResult";
%>
		
			<script language="JavaScript" src="../integrations/scripts/IEFUIConstants.js" type="text/javascript"></script>
			<script language="JavaScript" src="../integrations/scripts/IEFUIModal.js" type="text/javascript"></script>
			<script language="JavaScript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
			<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
			<script language = "Javascript">
			//XSSOK
			var makeFileReadOnlyDetails = '<%=makeFileReadOnlyDetails%>';
			//XSSOK
			var integrationName = '<%=integrationName%>';			
			var integrationFrame = getIntegrationFrame(this);
			var response = integrationFrame.getAppletObject().callCommandHandlerSynchronously("", 'executeLockUnlockCommand', makeFileReadOnlyDetails);	
                        
                        if(response != null && response.length > 0)
			{		
				messageToShow =  response;			
                //XSSOK				
				var messageDialogURL = "../integrations/DSCErrorMessageDialogFS.jsp?messageHeader=<%= headerRes %>&headerImage=images/iconError.gif&showExportIcon=false";
				showIEFModalDialog(messageDialogURL, 500, 400);
			}
			</script>
<%
			operationStatus = MCADAppletServletProtocol.TRUE;
		}
		catch(Exception exception)
		{
			operationStatus = MCADAppletServletProtocol.FALSE;
			emxNavErrorObject.addMessage(exception.getMessage());
		}
	}
	else
	{  
		String errorMessage  = serverResourceBundle.getString("mcadIntegration.Server.Message.ServerFailedToRespondSessionTimedOut");    
		emxNavErrorObject.addMessage(errorMessage);
	}
%>

<html>
<head>
<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
<script language="javascript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>

<%
	if (objectIds != null && objectIds.size() > 0)
	{   	
   		boolean isRFAEnabled = false;
   		try
   		{
			Context context	= integSessionData.getClonedContext(session);

   			if(!integNameForSelection.equals(""))
   			{
   				MCADGlobalConfigObject  globalConfigObject	= (MCADGlobalConfigObject)integSessionData.getGlobalConfigObject(integNameForSelection,context);
   				isRFAEnabled								= globalConfigObject.isRapidFileAccessEnabled();			
   			}
   		
			StringBuffer userHardlinkDirBuffer = new StringBuffer();
			userHardlinkDirBuffer.append(integSessionData.getRapidFileAccessServerMappedDrive(""));
			userHardlinkDirBuffer.append(dirSep);
			userHardlinkDirBuffer.append(context.getUser());
		
			String userHardlinkDirectory   = userHardlinkDirBuffer.toString();
		    
			String isOSWindow = "false";
			String osName = System.getProperty("os.name");
			if(osName.contains("Windows"))
				isOSWindow = "true";

			dirPath	= MCADUtil.getModifiedDirPath(dirPath, isOSWindow);
			
			if(isRFAEnabled && dirPath != null && !dirPath.equals("") && dirPath.startsWith(userHardlinkDirectory.toLowerCase()))
   			{
				MCADServerGeneralUtil serverGeneralUtil	= new MCADServerGeneralUtil(context,integSessionData, integNameForSelection);
				
				if(action.equalsIgnoreCase("lock") && operationStatus.indexOf("true") > -1)
				{
					MCADLocalConfigObject lco = (MCADLocalConfigObject)integSessionData.getLocalConfigObject();
			   		String checkoutDir = lco.getCheckoutDirectory(integNameForSelection);
		   	
					Hashtable userDirAliasTable = lco.getUserDirAliasMap();
					if(userDirAliasTable != null && userDirAliasTable.containsKey(integNameForSelection))
					{
						Hashtable userDirMap = (Hashtable)userDirAliasTable.get(integNameForSelection);
						if((userDirMap != null) && (userDirMap.size() > 0) && userDirMap.containsKey(checkoutDir))
						{
							checkoutDir = (String)userDirMap.get(checkoutDir);	
						}
					} 	
				    
			   		// Create XML packet for downloading files
					StringBuffer xmlStr = new StringBuffer("<?xml version=\"1.0\"?><files >");
					for (int ii = 0; ii < objectIds.size(); ii++)
					{
						//Send the boid for actual entry in the working set
						String objectId = (String) wsEntryBoids.elementAt(ii);
						String fileName = (String) fileNames.elementAt(ii);
						MCADBusObjectSessionInfo[] boInfo = sessionData.getData(fileName, dirPath, "");
						String revisionToGet = boInfo[0].getRevision();
						String objectIdToGet = objectId;
						String typeToGet = boInfo[0].getType();
						
						BusinessObject downloadbusObj = new BusinessObject(objectId);
					  
						downloadbusObj.open(context);
				  
						String familyID		   = serverGeneralUtil.getTopLevelFamilyObjectForInstance(context, objectId);
						String instancehasfile = "";

						if(familyID != null && !familyID.equals("") && !familyID.equals("null"))
						{
							instancehasfile = "true";
						}
						else
						{
							familyID = "";
						}
					  
						boolean isFinalized = serverGeneralUtil.isBusObjectFinalized(context,downloadbusObj);

						//If Business Object is finalized, checkout the file from Major obejct as Minor object does
						// not have file
						if(isFinalized)
						{
							BusinessObject majorBusObj = util.getMajorObject(context,downloadbusObj);
							
							// if majorBusObj is null means objectId is major id
							if(majorBusObj == null)
								majorBusObj = downloadbusObj;
							
							if(!majorBusObj.isOpen())
								majorBusObj.open(context);
							objectIdToGet = majorBusObj.getObjectId();
							revisionToGet = majorBusObj.getRevision();
							typeToGet = majorBusObj.getTypeName();
							 
							if(majorBusObj.isOpen())
								majorBusObj.close(context);
						}
						
						if(downloadbusObj.isOpen())
							downloadbusObj.close(context);
						String Args[]=new String[3];
						Args[0]=objectIdToGet;
						Args[1]="format["+boInfo[0].getFormat()+"].file.name";
						Args[2]="|";
						String fileNameDetails = util.executeMQL(context, "print bus $1 select $2 dump $3",Args);

						
						if(fileNameDetails.startsWith("true"))
						{
							fileNameDetails = fileNameDetails.substring(5);

							StringTokenizer strTokenizer = new StringTokenizer(fileNameDetails, "|");
							while(strTokenizer.hasMoreTokens())
							{
								fileName   = strTokenizer.nextToken();

								xmlStr.append("<file>");
								xmlStr.append("<busid>" + objectIdToGet + "</busid>");
								xmlStr.append("<integrationname>" + integNameForSelection + "</integrationname>");
								xmlStr.append("<familyid>" + familyID + "</familyid>");
								xmlStr.append("<instancehasfile>" + instancehasfile + "</instancehasfile>");
								xmlStr.append("<formatname>" + boInfo[0].getFormat() + "</formatname>");
								xmlStr.append("<filename>" + fileName + "</filename>");
								xmlStr.append("<filenamewithpath>" + checkoutDir + dirSep + fileName + "</filenamewithpath>");
								xmlStr.append("<mxtype>" + typeToGet + "</mxtype>");
								xmlStr.append("<name>" + boInfo[0].getName() + "</name>");
								xmlStr.append("<mxversion>" + revisionToGet + "</mxversion>");
								xmlStr.append("<filepath>" + checkoutDir + "</filepath>");
								xmlStr.append("<srcdir>" + dirPath + "</srcdir>");
								xmlStr.append("<destdir>" + checkoutDir + "</destdir>");

								String capturedFileName = serverGeneralUtil.getCapturedFileNameForObject(objectIdToGet, boInfo[0].getFormat(), fileName);
								xmlStr.append("<capturedfilename>" + capturedFileName + "</capturedfilename>");

								xmlStr.append("</file>");
							}
						}						
					}
					xmlStr.append("</files>");
					String xmlString = java.net.URLEncoder.encode(xmlStr.toString());  // Escape to protect backslash chars through to javascript
%>
					<script language="javascript" type="text/javascript">
						var integFrame	= getIntegrationFrame(window);
						//XSSOK
						var xmlString = unescape("<%=xmlString%>".replace(/\+/g, " "));  // Note XML is passed in escaped format from the Java code
						//XSSOK
						integFrame.getAppletObject().callCommandHandler("<%= integNameForSelection %>", 'wsmDownloadFilesAndRemoveHardlinks', xmlString);
					</script>
<%
				}
				else
				{
				}
			}			
		}
		catch(Exception e)
		{
			System.out.println("Exception while donwloaing file on Lock operation:" + e.getMessage());
			e.printStackTrace();
			emxNavErrorObject.addMessage(e.getMessage());
		}
			
%>
		<script language="javascript" type="text/javascript">
		// Refresh details frame if any lock/unlocks were done
		var tabFrame = findFrame(parent, "listDisplay");
		if(tabFrame != 'undefined' && tabFrame != null && (response == null || response.length == 0))
		{
			// Refresh the table (note we must reinvoke the table wrapper emxDSCWorkspaceDetails to reinvoke the applet and get the updated file list)
			var newHref = tabFrame.parent.document.location.href.replace('common/emxTable', 'iefdesigncenter/emxDSCWorkspaceMgmtDetails');
			tabFrame.parent.document.location.href = newHref;
		}
		</script>
<%
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
%> 
</script>
<body>
</body>
</html>
