<%--  DSCCompareStructureComparisonReport.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  DSCCompareStructureComparisonReport.jsp   - The Processing page for expanding the Structure's of 2 assemblies and comparing


--%>
<%@ include file = "../integrations/MCADTopInclude.inc" %>

<%
	String structure1ID	= emxGetParameter(request, "structure1Id");
	String structure2ID	= emxGetParameter(request, "structure2Id");
	String showp1unique	= emxGetParameter(request, "showp1unique");
	String showp2unique	= emxGetParameter(request, "showp2unique");
	String showcommon	= emxGetParameter(request, "showcommon");

	MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
	
	Context context		= integSessionData.getClonedContext(session);
	MCADMxUtil util		= new MCADMxUtil(context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
	
	String integrationName					  = util.getIntegrationName(context, structure1ID);
	MCADGlobalConfigObject globalConfigObject = integSessionData.getGlobalConfigObject(integrationName,context);

	String[] packedGCO = new String[2];
	packedGCO = JPO.packArgs(globalConfigObject);

	String[] args = new String[7];
	args[0]  = packedGCO[0];
	args[1]  = packedGCO[1];
	args[2]  = integSessionData.getLanguageName();
	args[3]  = integrationName;
	args[4]	 = structure1ID;
	args[5]  = structure2ID;

	Hashtable structureInfoTable = (Hashtable)JPO.invoke(context, "IEFCompareStructureComparisonReport", null, "getStructureComparisionReportData", args, Hashtable.class);
	
	if(structureInfoTable.size() >0)
	{
		Hashtable structure1UniqueInfoTable		= (Hashtable)structureInfoTable.get("structure1UniqueInfoTable");
		Hashtable structure2UniqueInfoTable		= (Hashtable)structureInfoTable.get("structure2UniqueInfoTable");
		Hashtable structureCommonInfoTable		= (Hashtable)structureInfoTable.get("structureCommonInfoTable");

		session.putValue("emxUnique1", structure1UniqueInfoTable);
		session.putValue("emxUnique2", structure2UniqueInfoTable);
		session.putValue("emxCommon", structureCommonInfoTable);
	}

	String reportGeneratorURL = "DSCCompareStructureComparisonDetailsReportFS.jsp?strructure1Id=" + structure1ID + "&structure2Id=" + structure2ID + "&showp1unique=" + showp1unique + "&showp2unique=" + showp2unique + "&showcommon=" + showcommon;
	request.setAttribute("complete", "true");
%>

<jsp:forward page="<%= reportGeneratorURL %>"/>
