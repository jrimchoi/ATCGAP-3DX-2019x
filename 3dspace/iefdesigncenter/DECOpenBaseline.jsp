<%--  DECOpenBaseline.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%@include file="../common/emxNavigatorInclude.inc"%>
<%@ include file="../integrations/MCADTopErrorInclude.inc" %>
<%@ page import="com.matrixone.MCADIntegration.server.beans.*,com.matrixone.MCADIntegration.utils.*,matrix.db.*,com.matrixone.MCADIntegration.server.*"%>

<%
	String[] emxTableRowId	= emxGetParameterValues(request,"emxTableRowId");
	String designObjId		= emxGetParameter(request, "objectId");
	String baselineObjId	= "";

	String designObjVer				= "";
	String integrationName			=  emxGetParameter(request, "integrationName");

	MCADIntegrationSessionData integSessionData		= (MCADIntegrationSessionData)session.getAttribute(MCADServerSettings.MCAD_INTEGRATION_SESSION_DATA_OBJECT);
	MCADServerResourceBundle resourceBundle     =  integSessionData.getResourceBundle();
	MCADMxUtil util		                        = new MCADMxUtil(context, integSessionData.getLogger(),resourceBundle,integSessionData.getGlobalCache()); 

	if(integrationName==null)
	{		
		integrationName = util.getIntegrationName(context, designObjId);
	}

	MCADGlobalConfigObject globalConfigObject	= integSessionData.getGlobalConfigObject(integrationName,context);

	if(emxTableRowId[0].indexOf("|") != -1)
	{
		Vector idList	= MCADUtil.getVectorFromString(emxTableRowId[0], "|");
		baselineObjId	= (String)idList.elementAt(0);
			try
			{

					String[] oids = new String[1];
					oids[0] = baselineObjId;			
					  
					String attRootNodeDetails= util.getActualNameForAEFData(context, "attribute_RootNodeDetails");
					String SELECT_ATTR_ROOTNODE_DETAILS = "attribute["+attRootNodeDetails+"]";

					StringList busSelects = new StringList(2);			
					busSelects.add(SELECT_ATTR_ROOTNODE_DETAILS);
					BusinessObjectWithSelectList busWithSelectionList = BusinessObject.getSelectBusinessObjectData(context, oids, busSelects);

					BusinessObjectWithSelect busWithSelect = (BusinessObjectWithSelect)busWithSelectionList.elementAt(0);
					String rootNodeDetails		= busWithSelect.getSelectData(SELECT_ATTR_ROOTNODE_DETAILS);

					String busType	= "";
					String busName	= "";
					String revision	= "";

						if(null != rootNodeDetails && !"".equals(rootNodeDetails) && rootNodeDetails.indexOf("|") == -1){
							BusinessObject borootId = new BusinessObject(rootNodeDetails);
							borootId.open(context);
							busType = borootId.getTypeName();
							busName = borootId.getName();
							revision 	= borootId.getRevision();
							borootId.close(context);
							
						} else {
					Vector tnrDetails	= MCADUtil.getVectorFromString(rootNodeDetails, "|");
					
					
							busType	= (String)tnrDetails.elementAt(0);
							busName 	= (String)tnrDetails.elementAt(1);
							revision 	= (String)tnrDetails.elementAt(2);		
						}

					BusinessObject busObject = new BusinessObject(busType, busName, revision , "");
					busObject.open(context);
					designObjId	= busObject.getObjectId(context);
					busObject.close(context);
			}
			catch(Exception e)
			{
			     emxNavErrorObject.addMessage(e.getMessage());
			}
	}

	StringBuffer urlBuffer = new StringBuffer();		urlBuffer.append("../iefdesigncenter/emxIndentedTableWrapper.jsp?expandProgramMenu=DECPSEBaselineFormat&direction=from&tableMenu=DSCPSETableFilter&jpoAppServerParamList=session:GCO,session:GCOTable,session:LCO&freezePane=Name&selection=multiple&toolbar=DSCPSETopActionBar&editLink=false&header=emxIEFDesignCenter.Header.Navigate&portalMode=false&suiteKey=eServiceSuiteDesignerCentral&objectId=");
	urlBuffer.append(designObjId);
	urlBuffer.append("&baselineId=");
	urlBuffer.append(baselineObjId);
	
	String url = urlBuffer.toString();
	
%>
<html>
<head>
</head>
<body>
    <!--XSSOK CAUSED REG-->
	<jsp:forward page="<%=url%>" />
</body>
</html>

