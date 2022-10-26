<%--  emxIndentedTableWrapper.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>

<%@ page import = "java.net.*,java.util.ResourceBundle" %>
<%@ page import = "java.util.*, com.matrixone.apps.domain.util.*, com.matrixone.MCADIntegration.server.beans.*, com.matrixone.MCADIntegration.utils.*" %>
<%@ page import = "matrix.db.*"%>
<%@ page import = "com.matrixone.MCADIntegration.uicomponents.util.*" %>
<%@ page import = "java.util.regex.Pattern" %>

<% 
	String integrationName			= Request.getParameter(request,"integrationName");
	String objectId					= Request.getParameter(request,"objectId");
	String originalObjectId					= Request.getParameter(request,"originalObjectId");
	String baselineId				= Request.getParameter(request,"baselineId");
	String relationship				= Request.getParameter(request,"relationship");
	String resequenceRelationship	= Request.getParameter(request,"resequenceRelationship");
	String expandProgram			= Request.getParameter(request,"expandProgram");
	String expandProgramMenu		= Request.getParameter(request,"expandProgramMenu");
	String direction				= Request.getParameter(request,"direction");
	String table					= Request.getParameter(request,"table");
	String tableMenu				= Request.getParameter(request,"tableMenu");
	String jpoAppServerParamList	= Request.getParameter(request,"jpoAppServerParamList");
	String freezePane				= Request.getParameter(request,"freezePane");
	String selection				= Request.getParameter(request,"selection");
	String editLink					= Request.getParameter(request,"editLink");
	String toolbar					= Request.getParameter(request,"toolbar");
	String header					= Request.getParameter(request,"header");
	String editRelationship			= Request.getParameter(request,"editRelationship");
	String suiteKey					= Request.getParameter(request,"suiteKey");
        String helpMarker			= Request.getParameter(request,"HelpMarker");
	String connectionProgram		= Request.getParameter(request,"connectionProgram");
	String portalMode				= Request.getParameter(request,"portalMode");
	String preProcessJPO			= Request.getParameter(request,"preProcessJPO");
	String suiteDirectory	 		= Request.getParameter(request,"emxSuiteDirectory");
	String categoryTree = Request.getParameter(request,"categoryTreeName");
	String printerFriendly			= Request.getParameter(request,"PrinterFriendly") == null ? "true":Request.getParameter(request,"PrinterFriendly") ;

	String instanceSelection		= Request.getParameter(request,"DECNavigateInstanceList");
	String applyURL					= Request.getParameter(request,"applyURL"); //IR-642818	
	String insertNewRow				= Request.getParameter(request,"insertNewRow"); //IR-702716	
	
	String errorMessage				= "";

	String tablePageURL   = "../common/emxIndentedTable.jsp?";	
	String appendParams = "";
	String showMajor = Request.getParameter(request,"showMajor");

	helpMarker	   = (helpMarker == null) ? "emxhelpdscnavigator" : helpMarker;

	if(null != helpMarker)
	{
		appendParams = appendParams + "&HelpMarker=" + helpMarker;
	}
	if (null != relationship)
	{
		appendParams = appendParams + "&relationship=" + relationship;
	}
	if (null != resequenceRelationship)
	{
		appendParams = appendParams + "&resequenceRelationship=" + resequenceRelationship;
	}
	if (null != expandProgram)
	{
		appendParams = appendParams + "&expandProgram=" + expandProgram;
	}
	if (null != expandProgramMenu)
	{
		appendParams = appendParams + "&expandProgramMenu=" + expandProgramMenu;
	}
	if (null != direction)
	{
	    appendParams = appendParams + "&direction=" + direction;
	}
	if (null != table)
	{
	    appendParams = appendParams + "&table=" + table;
	}
	if (null != tableMenu)
	{
	    appendParams = appendParams + "&tableMenu=" + tableMenu;
	}	
	if (null != jpoAppServerParamList)
	{
	    appendParams = appendParams + "&jpoAppServerParamList=" + jpoAppServerParamList;
	}
	if (null != freezePane)
	{
	    appendParams = appendParams + "&freezePane=" + freezePane;
	}
	if (null != selection)
	{
	    appendParams = appendParams + "&selection=" + selection;
	}

	if (null != header)
	{
	   appendParams = appendParams + "&header=" + header;
	}
	if (null != editRelationship)
	{
	   appendParams = appendParams + "&editRelationship=" + editRelationship;
	}
	if (null != suiteKey)
	{
		appendParams = appendParams + "&suiteKey=" + suiteKey;
	}
	if (null != connectionProgram)
	{
		appendParams = appendParams + "&connectionProgram=" + connectionProgram;
	}
	if (null != portalMode)
	{
		appendParams = appendParams + "&portalMode=" + portalMode;
	}
	if (null != preProcessJPO)
	{
		appendParams = appendParams + "&preProcessJPO=" + preProcessJPO;
	}
	if (null != baselineId)
	{
		appendParams = appendParams + "&baselineId=" + baselineId;
	}
        if (null != suiteDirectory)
	{
		appendParams = appendParams + "&SuiteDirectory=" + suiteDirectory;
	}
	if (null != categoryTree)
	{
		appendParams = appendParams + "&categoryTreeName=" + categoryTree;
	}
		
    //IR-642818	
	if (null != applyURL)
	{
	   appendParams = appendParams + "&applyURL=" + applyURL;
	}
		
	//IR-702716
	if (null != insertNewRow)
	{
	   appendParams = appendParams + "&insertNewRow=" + insertNewRow;
	}
		
	MCADIntegrationSessionData integSessionData	= (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");		
	Context IEFContext                          = integSessionData.getClonedContext(session);
	MCADMxUtil util                             = new MCADMxUtil(IEFContext, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
	MCADObjectsIdentificationUtil objIdUtil  	= new MCADObjectsIdentificationUtil(IEFContext, integSessionData);
try
{	
	ArrayList physicalidList = new ArrayList();
	physicalidList.add(objectId);
	Map physicalIdObjIDMap = objIdUtil.getOidListFromPhysicalidList(IEFContext,physicalidList,null,null,null);
	objectId = (String)physicalIdObjIDMap.values().iterator().next();
	// store the objectId paased into temp varaible, which will be passed to next if the objectId is modified
	if(instanceSelection != null)
	{
		objectId = instanceSelection;
	}
	else
	{
		originalObjectId = objectId;
	}
	if(integrationName==null)
	{	
		integrationName = util.getIntegrationName(IEFContext, objectId);
	}
	
	IEFConfigUIUtil iefConfigUIUtil             = new IEFConfigUIUtil(IEFContext, integSessionData, integrationName);
	if(integrationName != null )
	{	
		String isFeatureAllowed = integSessionData.isFeatureAllowedForIntegration(integrationName, MCADGlobalConfigObject.FEATURE_NAVIGATE);
		if(!isFeatureAllowed.startsWith("true"))
		{
			errorMessage = isFeatureAllowed.substring(isFeatureAllowed.indexOf("|")+1, isFeatureAllowed.length());			
		}
		else
		{
			IEFIntegAccessUtil mcadUtil              = new IEFIntegAccessUtil(IEFContext, integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
			Vector assignedIntegrations = mcadUtil.getAssignedIntegrations(IEFContext);

			MCADGlobalConfigObject globalConfigObject = integSessionData.getGlobalConfigObject(integrationName,IEFContext);
					
			if(globalConfigObject!=null)
			{
				HashMap globalConfigObjectTable			  = (HashMap)integSessionData.getIntegrationNameGCOTable(IEFContext);	
				MCADServerGeneralUtil serverUtil = new MCADServerGeneralUtil(IEFContext, globalConfigObject, integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
					
				session.setAttribute("GCOTable", globalConfigObjectTable);
				session.setAttribute("GCO", globalConfigObject);				
				session.setAttribute("LCO", (Object)integSessionData.getLocalConfigObject());
				
                //IR-642818 ++++
                String strCADMxRelAttributesMapTo = globalConfigObject.CADMxRelAttributesMapToString();
                
				if(strCADMxRelAttributesMapTo != null && strCADMxRelAttributesMapTo.length() > 0)
				{
				String[] vCADMxRelAttributesMapArr = strCADMxRelAttributesMapTo.split("\n");				
				StringBuilder vCADMxRelAttributesMapResult = new StringBuilder();

					for(int i=0;i < vCADMxRelAttributesMapArr.length ;i++)
					{
					String[] vCADMxRelAttributesMap = vCADMxRelAttributesMapArr[i].split(Pattern.quote("|"));
					vCADMxRelAttributesMapResult.append(vCADMxRelAttributesMap[1]);
					vCADMxRelAttributesMapResult.append("|");
				    }				
				session.setAttribute("CADMxRelAttributesMap", vCADMxRelAttributesMapResult.toString());
				}
               //IR-642818 ----

				BusinessObject busTmpObj = new BusinessObject(objectId);
				busTmpObj.open(IEFContext);

					if(null != showMajor)
					{
						if(util.isMajorObject(IEFContext, objectId))//globalConfigObject.isMajorType(busTmpObj.getTypeName()))
						{
							showMajor="true";
						}
					}
					
					busTmpObj.close(IEFContext);

						
				String cadType = util.getCADTypeForBO(IEFContext, new BusinessObject(objectId));
				boolean isFamily = globalConfigObject.isTypeOfClass(cadType,MCADAppletServletProtocol.TYPE_FAMILY_LIKE);
				
				BusinessObject busObj = new BusinessObject(objectId);
				busObj.open(IEFContext);
//[NDM] starts
				if(null != toolbar)
				{
					 if(baselineId!=null && !"".equals(baselineId)){
									toolbar= "DSCNavigateActionBarForBaseline";
					 }else if (objectId != null && !util.isMajorObject(IEFContext, objectId))
					  {
						 toolbar= "DSCNavigateActionBarForVersion";
						 editLink="false";
						 
			ResourceBundle iefProps = ResourceBundle.getBundle("emxIEFDesignCenter");
			String sKey = "emxDesignerCentral.LateralViews.EnableAsSavedView";
			String isAsSavedViewSupported = iefProps.getString(sKey);			
						boolean bisAsSavedViewSupported = false;
						if(isAsSavedViewSupported.contains(integrationName))
						{
							bisAsSavedViewSupported =  true;
						}			
		
						if(bisAsSavedViewSupported)
						{
						 expandProgramMenu = "DSCPSEDisplayFormatIterations";
					  }
					  }
					 appendParams = appendParams + "&toolbar=" + toolbar;
				 
				}
				if(assignedIntegrations.contains(integrationName) && null != editLink){
					appendParams = appendParams + "&editLink=" + editLink;
				}
				if (null != expandProgramMenu)
				{
					appendParams = appendParams + "&expandProgramMenu=" + expandProgramMenu;
				}				
//{NDM] ends

				if(isFamily)
				{	
					objectId = serverUtil.getInstanceIdFromFamilyIdForNavigation(IEFContext,objectId);

				}
				busObj.close(IEFContext);
			}				
		}

		if(null != showMajor)
		{
			appendParams = appendParams + "&showMajor=" + showMajor;
		}

		tablePageURL += "objectId=" + objectId + appendParams;
		if(!objectId.equals(originalObjectId))
		{
			tablePageURL += "&originalObjectId=" + originalObjectId;			
		}
	}
}	
catch(Exception e)
{
	errorMessage = e.getMessage();
}

%>	

	
<html>

<head>


<script language="javascript">

</script>
</head>

<body>

<%
	if ("".equals(errorMessage.trim()))
	{
%>
	<script language="javascript">
	<%
	if(instanceSelection != null)
	{
%>
		var url = parent.location.href;

        if(url.indexOf("objectId=") > 0)
        {
            url = url.replace(/objectId=[^&]*/, "objectId=" + "<%=XSSUtil.encodeForJavaScript(IEFContext,objectId)%>");
        }
        else
        {
            url += "&objectId=" + "<%=XSSUtil.encodeForJavaScript(IEFContext,objectId)%>";
        }
		
				parent.location.href = url;
<%
	}
else
{
%>
		window.location.replace("<%=XSSUtil.encodeForJavaScript(IEFContext,tablePageURL)%>");

<%
}
%>

	</script>
<%
	} 

	else {
%>
	<link rel="stylesheet" href="../emxUITemp.css" type="text/css">
	&nbsp;
      <table width="90%" border=0  cellspacing=0 cellpadding=3  class="formBG" align="center" >
        <tr >
          <!--XSSOK-->
          <td class="errorHeader"><%=integSessionData.getStringResource("mcadIntegration.Server.Heading.Error")%></td>
        </tr>
        <tr align="center">
          <td class="errorMessage" align="center"><xss:encodeForHTML><%=errorMessage%></xss:encodeForHTML></td>
        </tr>
      </table>
<%
	}
%>
</body>
</html>

