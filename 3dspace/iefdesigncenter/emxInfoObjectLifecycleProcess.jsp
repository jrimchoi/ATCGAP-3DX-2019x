<%--  emxInfoObjectLifecycleProcess.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
    $Archive: /InfoCentral/src/InfoCentral/emxInfoObjectLifecycleProcess.jsp $
    $Revision: 1.3.1.3$
    $Author: ds-mbalakrishnan$

    Description :  This page processes the commands requested by the user for the 
         business object to promote/demote an object from its current state.

--%>

<%--
 *
 * $History: emxInfoObjectLifecycleProcess.jsp $
 * 
 * *****************  Version 8  *****************
 * User: Snehalb      Date: 11/26/02   Time: 6:28p
 * Updated in $/InfoCentral/src/InfoCentral
 * added few comments
 * 
 * *****************  Version 7  *****************
 * User: Gauravg      Date: 11/26/02   Time: 12:25p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 6  *****************
 * User: Snehalb      Date: 11/25/02   Time: 5:20p
 * Updated in $/InfoCentral/src/InfoCentral
 *
 * ***********************************************
 *
--%>
<link rel="stylesheet" type="text/css" href="../common/styles/emxUIDefault.css" >
<%@include file="emxInfoCentralUtils.inc" %>
<%@include file="../common/emxNavigatorTopErrorInclude.inc"%>
<%@ page  import="com.matrixone.MCADIntegration.server.*,com.matrixone.MCADIntegration.server.beans.*,com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.cache.*" %>

<script src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
<script language="JavaScript">

<%
	String requestURI				= request.getRequestURI();
	String pathWithDSCDir			= requestURI.substring(0, requestURI.lastIndexOf('/'));
    String pathWithAppName			= pathWithDSCDir.substring(0, pathWithDSCDir.lastIndexOf('/'));

    String sCommand						= (String) emxGetParameter(request, "cmd");
    String sBusObjId					= (String) emxGetParameter(request, "parentOID");
    String topActionbar					= (String) emxGetParameter(request, "topActionbar");
    String header						= (String) emxGetParameter(request, "header");
    String helpMarker					= (String) emxGetParameter(request, "HelpMarker");
    String sViewableCurrentStateName	= (String) emxGetParameter(request, "currentState");
	String sRefreshFrame				= (String) emxGetParameter(request, "refreshFrame");
    String sErrorMsg					= "";
	String featureName					= ""; 
	String isFeatureAllowed				= "";

	if(sCommand.equals("promote"))
		featureName = MCADGlobalConfigObject.FEATURE_PROMOTE;
	else
		featureName = MCADGlobalConfigObject.FEATURE_DEMOTE;

    try
    {
        BusinessObject bo = new BusinessObject(sBusObjId);
		MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");

		if(integSessionData == null)//user may not have any integration assigned or the session may have expired. Show error.
		{
			MCADServerResourceBundle serverResourceBundle = new MCADServerResourceBundle(request.getHeader("Accept-Language"));

			String errorMessage		= serverResourceBundle.getString("mcadIntegration.Server.Message.ServerFailedToRespondSessionTimedOut");
			emxNavErrorObject.addMessage(errorMessage);
		}
		else //go ahead only if integSessionData is not null.
		{
			MCADMxUtil _util				= new MCADMxUtil(context, integSessionData.getResourceBundle(), new IEFGlobalCache());
			bo.open(context);
			String busID					= bo.getObjectId();
			String iefintegrationName		= _util.getIntegrationName(context, busID);

			isFeatureAllowed				=integSessionData.isFeatureAllowedForIntegration(iefintegrationName, featureName);

			if(!isFeatureAllowed.startsWith("true"))
			{
				String errorMessage = isFeatureAllowed.substring(isFeatureAllowed.indexOf("|")+1, isFeatureAllowed.length());
				emxNavErrorObject.addMessage(errorMessage);
			}
			else
			{
				MCADGlobalConfigObject globalConfig		= integSessionData.getGlobalConfigObject(iefintegrationName,context);
		    
				String busType			= bo.getTypeName();
				String typeName			= busType;
				String majorObjectID	= "";

				// [NDM] OP6
				/*if(!globalConfig.isMajorType(typeName))
				{						
					typeName = _util.getCorrespondingType(context, typeName);
				}*/

				boolean isOperationAllowed = integSessionData.isOperationAllowed(context,iefintegrationName,typeName,featureName);
				
				if(!isOperationAllowed)
				{
					sErrorMsg = sCommand + " " + UINavigatorUtil.getI18nString("emxIEFDesignCenter.Error.OperationNotAllowed","emxIEFDesignCenterStringResource", request.getHeader("Accept-Language")) + " " + busType;
				}
				
				if(!("".equalsIgnoreCase(sErrorMsg)))
				{
					%>			
                     //XSSOK					
					alert("<%=sErrorMsg%>");        
					<%
				}
				else
				{
					//if command is promote
					if (sCommand.equals("promote")) 
					{	
						String finalizationDetails = iefintegrationName + "|" + busID;
%>

//XSSOK
var iefIntegrationName	= "<%=iefintegrationName%>";
var finalizationDetails	= "<%=finalizationDetails%>";
showFinalizationPage(iefIntegrationName, finalizationDetails);
				
<%
					}
					else if (sCommand.equals("demote")) 
					{
						if(!_util.isMajorObject(context, busID))//globalConfig.isMinorType(busType)) //[NDM] OP6
						{
							BusinessObject majorBusObject = _util.getMajorObject(context,bo);

							if(majorBusObject == null)
							{
								Hashtable messageDetails = new Hashtable(2);
								messageDetails.put("NAME", bo.getName());
								
								MCADServerException.createException(integSessionData.getStringResource("mcadIntegration.Server.Message.CannotPerformOperationAsMajorAbsentOrNotAccessible", messageDetails), null);                    
							}

							majorBusObject.open(context);
							majorObjectID = majorBusObject.getObjectId();
							majorBusObject.close(context);
						}
						else
						{
							majorObjectID = busID;						
						}
%>
				
//XSSOK				
var iefIntegrationName	= "<%=iefintegrationName%>";
//XSSOK
var majorObjectID		= "<%=majorObjectID%>";
//XSSOK
var pathWithAppName		= "<%=pathWithAppName%>";
showUndoFinalizationPage(iefIntegrationName, majorObjectID, pathWithAppName);
				
<%
					}
					//Enable mql notice change start 2/2/2004
					if(!("".equalsIgnoreCase(sErrorMsg)))
					{
%>
//XSSOK			
alert("<%=sErrorMsg%>");
			
<%
					}
					//Enable mql notice change end 2/2/2004
					bo.close(context);
				}
			}
		}//end of integSessionData null check
    }
    catch(Exception ex) 
    {
        if( ( ex.toString()!=null ) && (ex.toString().trim()).length()>0 )
            emxNavErrorObject.addMessage(ex.toString().trim());
    }
%>

    //XSSOK
	var refreshFrame		= getFrameObject(top, '<%=sRefreshFrame%>');
	var integrationFrame	= getIntegrationFrame(this);
	if(integrationFrame != null)
		integrationFrame.setActiveRefreshFrame(refreshFrame);

</script>
<%@include file= "../common/emxNavigatorBottomErrorInclude.inc"%>
