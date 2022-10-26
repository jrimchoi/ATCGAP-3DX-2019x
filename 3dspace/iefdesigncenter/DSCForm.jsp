<%--  DSCForm.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: DSCForm.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>


<%@ page import = "java.net.*,java.util.ResourceBundle" %>
<%@include file = "../emxUICommonAppInclude.inc"%>
<%@include file = "../teamcentral/emxTeamCommonUtilAppInclude.inc"%>
<%@include file = "../emxUICommonHeaderBeginInclude.inc" %>
<%@include file = "DSCCommonUtils.inc" %>
<%@include file = "../common/emxUIConstantsInclude.inc"%>
<%@ page import="com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.beans.*,com.matrixone.apps.domain.util.*"  %>
<script language="javascript" type="text/javascript" src="../common/scripts/emxUICalendar.js"></script>
<script language="JavaScript" src="../iefdesigncenter/emxInfoUIModal.js"></script> 
<script language="javascript" src="../iefdesigncenter/emxInfoCentralJavaScriptUtils.js"></script>
<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script> <%--Required by emxUIActionbar.js below--%>
<script language="JavaScript" src="../common/scripts/emxUIActionbar.js" type="text/javascript"></script> <%--To show javascript error messages--%>
<script language="JavaScript" src="../common/scripts/emxJSValidationUtil.js" type="text/javascript"></script> <%--To show javascript error messages--%>
<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICore.js"></script>
<%!
    private boolean isWebFormExists(Context context, String symbolicBusType)
    {
        try
  		{
  	                     
            String output = MqlUtil.mqlCommand(context, "list form $1",symbolicBusType);
                              
            if (null != output)
            {
                output = output.trim();
            }
                                
            if (output != null && output.length() > 0)
            {
                return true;
            }
        }
        catch (Exception e)
        {
           return false;
        }

        return false;
    }

	private String getWebFormNameForType(Context context, String busType) throws Exception
	{
		String webFormName = "";

		String symbolicBusType	= FrameworkUtil.getAliasForAdmin(context, "type", busType, true);
		boolean isExists		= isWebFormExists(context, symbolicBusType);
		if(isExists)
		{
			webFormName = symbolicBusType;
		}
		else
		{
			//Get parent's web form 
			BusinessType busObjectType = new BusinessType(busType, context.getVault());
			busObjectType.open(context);
			String parentBusType = busObjectType.getParent(context);
			busObjectType.close(context);
			
			webFormName = getWebFormNameForType(context, parentBusType);
		}

		return webFormName;
	}

	private void waitForSessionToInitialize(HttpSession session)
	{
		MCADIntegrationSessionData integrationSessionData	= (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
	    boolean appletLoaded = false;
	
	   if (integrationSessionData == null)
	   {
		  long elapsedTime	   = 0L;
		  long timeOutInterval = 10 * 1000L;
	
		  try
		  {
			  ResourceBundle iefProps	= ResourceBundle.getBundle("emxIEFDesignCenter");
			  String sTimeOutInterval	= iefProps.getString("eServiceInfoCentral.AbortTimeOutInSecs");
	
			  if (sTimeOutInterval != null && sTimeOutInterval.length() > 0)
			  {
				   timeOutInterval = Long.parseLong(sTimeOutInterval) * 1000L;
			  }
		  }
		 catch (Exception e)
		 {
			 // do nothing
		 }
	
		while(false == appletLoaded && timeOutInterval > elapsedTime)
		{
		 
			try
			{
				Thread.sleep(1000);
				elapsedTime += 1000L;   
			
				 integrationSessionData	= (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
				 if (integrationSessionData != null)
				 {
					Context integContext = integrationSessionData.getClonedContext(session);
					appletLoaded = true;
					break;
				 } 
			}
			catch (Exception e)
			{
				 // basically continue;
				 continue;
			}
		}	  
	   }
	}
%>
<%
	String sParam = "";
	String symbolicBusType = "";
	String sTypeWebForm = "";
	String busType = "";
	//[NDM]
	String objectId = "";
	int i = 0;
	
	waitForSessionToInitialize(session);
	
	MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
	Context clonedContext									= Framework.getFrameContext(session);
	try
  	{
  		objectId = (String)emxGetParameter(request, "objectId");
		if (null != objectId)
		{
			int iCount = 10;
				
			while(integSessionData==null)
			{
				if(iCount==0)
				{
					break;
				}
				iCount--;
				Thread.sleep(1000);
				integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
			}
			if(integSessionData != null) 
			{
				MCADMxUtil util	= new MCADMxUtil(context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
				
				String IS_VERSION_OBJ = MCADMxUtil.getActualNameForAEFData(context,"attribute_IsVersionObject");
				String SELECT_ISVERSIONOBJ = "attribute["+IS_VERSION_OBJ+"]";					
				String SELECT_PHYID = "physicalid";
				
				StringList slSelectsForInputID = new StringList(4);
				slSelectsForInputID.addElement(SELECT_ISVERSIONOBJ);
				slSelectsForInputID.addElement(SELECT_PHYID);
				slSelectsForInputID.addElement(DomainConstants.SELECT_ID);				
				slSelectsForInputID.addElement(DomainConstants.SELECT_TYPE);
				
				StringList slOid = new StringList(1);
				slOid.addElement(objectId);
				
				String [] oidsTopLevel		  = new String [slOid.size()];
				slOid.toArray(oidsTopLevel);

				BusinessObjectWithSelectList buslWithSelectionList = BusinessObject.getSelectBusinessObjectData(context, oidsTopLevel, slSelectsForInputID);
				
				BusinessObjectWithSelect busObjectWithSelect 		= (BusinessObjectWithSelect)buslWithSelectionList.elementAt(0);				
				String sThisBusType         = (String)busObjectWithSelect.getSelectData(DomainConstants.SELECT_TYPE);
				//System.out.println("-sThisBusType---"+sThisBusType);
				
				String isThisVersionObj         = (String)busObjectWithSelect.getSelectData(SELECT_ISVERSIONOBJ);
				boolean isVersion = Boolean.valueOf(isThisVersionObj).booleanValue();				
				//System.out.println("-isVersionObj---"+isVersion);
				
				String sThisPhyid         = (String)busObjectWithSelect.getSelectData(SELECT_PHYID);
				if(sThisPhyid.equals(objectId)){
					objectId = (String)busObjectWithSelect.getSelectData(DomainConstants.SELECT_ID);
				}
				//System.out.println("-after objectId---"+objectId);
				
				// The web form is same as the symbolic name of the 
				// major business object type
				BusinessObject busObject = new BusinessObject(objectId);
				// [NDM] QWJ Start
				busObject.open(context);
				//busType	= busObject.getTypeName();
				busType	= sThisBusType;
				// [NDM] QWJ End
				
				//boolean isMajorObject	= util.isMajorObject(context, objectId);
				boolean isMajorObject	= !isVersion;
				if (!isMajorObject)
				{
					BusinessObject majorBusObject = util.getMajorObject(context,busObject);
					if (null != majorBusObject)
					{
						majorBusObject.open(context);
						busType      = majorBusObject.getTypeName();
						majorBusObject.close(context);
					}
				}

				busObject.close(context);

				sTypeWebForm = getWebFormNameForType(context, busType);
				
			}
			else
			{
				BusinessObject busObject = new BusinessObject(objectId);
				busObject.open(context);
				busType = busObject.getTypeName();
				busObject.close(context);
				
				sTypeWebForm = getWebFormNameForType(context, busType);
			}
		}
	}
  	catch (Exception e)
  	{
  	   System.out.println("DSCWebForm.jsp: " + e.toString());
  	}

	for(Enumeration searchParams = emxGetParameterNames(request);searchParams.hasMoreElements();)
	{
		

		String searchParam  = (String) XSSUtil.encodeForURL(clonedContext,(String) searchParams.nextElement());
		String value = XSSUtil.encodeForURL(clonedContext,emxGetParameter(request, searchParam));

		if (null == searchParam) continue;
		if (searchParam.equals("treeLabel")) continue;
	//[NDM] start
	// if search parameter is toolbar and object is minor, set different toolbar for minor
		if (searchParam.equals("toolbar"))
		{
			if(null != objectId && integSessionData != null) 
			{
				MCADMxUtil util	= new MCADMxUtil(context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
				if(!util.isMajorObject(context, objectId))
				{
					value = "DSCNavigateActionBarForVersion";	
				}
			}
		}
//[NDM] ends
		// brings up web form of the major type if exists
		if (searchParam.equals("form"))
		{
		    if (sTypeWebForm != null && sTypeWebForm.length() > 0)
		        value = sTypeWebForm;
		}
		if (i > 0) sParam += "&";
		String param = searchParam + "=" + value;
		sParam+=param;
		i++;
	}
	//redirect to the search results page ( displayed using emxInfoTable.jsp )
	//User jsp:forward instead of sendRedirect for faser processing
	String sFwdPage = "../common/emxForm.jsp?" + sParam;
%>

<html>
<head>
<script language="javascript">

function redirectToNewLocation()
{
  window.location.replace("<%=XSSUtil.encodeForJavaScript(clonedContext,sFwdPage)%>");
}

</script>
</head>
<body onLoad="redirectToNewLocation()">

</body>
</html>
