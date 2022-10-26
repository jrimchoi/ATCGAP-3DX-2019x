<%--  DSCFullSearch.jsp

  Copyright (c) 2016 Dassault Systemes. All rights reserved.
  This program contains proprietary and trade secret information of
  Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
  and does not evidence any actual or intended publication of such program

--%>

<%@include file = "DSCSearchUtils.inc" %>
<%@include file = "DSCAppletUtils.inc" %>
<%@ include file = "../integrations/MCADResponseHeaderInclude.inc" %>
<%@include file = "../emxUICommonAppInclude.inc"%>
<%@include file = "../emxUICommonHeaderBeginInclude.inc" %>
<%@ page import="com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.beans.*,com.matrixone.apps.domain.util.*"  %>


<%
	MCADIntegrationSessionData integSessionData	= (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
	MCADLocalConfigObject lco								= integSessionData.getLocalConfigObject();
        
	Context _context		= integSessionData.getClonedContext(session);

	MCADMxUtil util					= new MCADMxUtil(_context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());

   Boolean isVPLMAdmin					= false;

   if((lco == null  ||  lco.getIntegrationNameGCONameMapping().size() == 0 || integSessionData.isNonIntegrationUser()))
   {
		if(MCADMxUtil.isSolutionBasedEnvironment(_context))
   {
			HashMap argumentsMap = new HashMap();
			argumentsMap.put("languageStr", request.getHeader("Accept-Language"));

			String [] packedArguments = JPO.packArgs(argumentsMap);
			isVPLMAdmin				= (Boolean)util.executeJPO(context, "DSCTEAMAccessUtil", "checkAccessForVPLMAdmin", packedArguments, Boolean.class);
		}
		if(!isVPLMAdmin)
		   {

	  String featureName		= MCADGlobalConfigObject.FEATURE_SEARCH;
	  String errorPage			= "../integrations/emxAppletTimeOutErrorPage.jsp?featureName="+featureName;
%>
          <!--XSSOK-->
	  <jsp:forward page="<%=errorPage%>" />
<%
    }
   }
	String queryString			= emxGetQueryString (request);
	String integrationName	= emxGetParameter(request, "integrationName");

	String showVersion = "";
	showVersion = Request.getParameter(request,"showVersion");
	if(integSessionData != null)
	{
		if (integrationName == null || integrationName.equals(""))
		{
		   integrationName = getDefaultIntegrationName(request, integSessionData);
		}
	}

	String txtType			= "type_CADDrawing,type_CADModel";

	StringBuffer exclusionTypes		= new StringBuffer();
	String txtExclusionTypes		= "";
	StringBuffer versionedTxtTypes	= new StringBuffer();
	
	if(integrationName != null || isVPLMAdmin)
	{
		txtType	 = integSessionData.getTypesForTypeChooser(_context);
		
		if(txtType != null && !"".equals(txtType) && null != showVersion && "true".equals(showVersion))
		{
			StringTokenizer typeTokens = new StringTokenizer(txtType, ",");
			while(typeTokens.hasMoreTokens())
			{
				String symbolicTypeName				= (String)typeTokens.nextElement();

				String actualTypeName				= util.getActualNameForAEFData(_context, symbolicTypeName);
				String actualCorrespondingType		= util.getCorrespondingType(_context, actualTypeName);
				String symbolicCorrespondingType	= util.getSymbolicName(context, "type", actualCorrespondingType);
				
				versionedTxtTypes.append(",");
				versionedTxtTypes.append(symbolicCorrespondingType);
			}

			txtType = txtType + versionedTxtTypes.toString();
		}
	}
		
	if(integrationName != null)
	{
		session.setAttribute("GCOTable", (HashMap)integSessionData.getIntegrationNameGCOTable(_context));
		session.setAttribute("GCO", integSessionData.getGlobalConfigObject(integrationName,_context));
		session.setAttribute("LCO", (Object)integSessionData.getLocalConfigObject());
	}
	String sTextSearch = Request.getParameter(request,"txtTextSearch");
	String sdefault ="NAME="+sTextSearch ;
	
	
	String searchURL				= "../common/emxFullSearch.jsp";

	String sTable					= Request.getParameter(request,"table");
	String selection				= Request.getParameter(request,"selection");
	String sCancelLabel				= Request.getParameter(request,"cancelLabel");
	String sCallbackFunction		= Request.getParameter(request,"callbackFunction");
	String sSubmitLabel				= Request.getParameter(request,"submitLabel");
	String sShowSavedQuery			= Request.getParameter(request,"showSavedQuery");
	String sToolbar					= Request.getParameter(request,"toolbar");
	String sViewFormBased			= Request.getParameter(request,"viewFormBased");
	String sSubmitURL				= Request.getParameter(request,"submitURL");
	String sMandatorySearchParam	= Request.getParameter(request,"mandatorySearchParam");
	String sExcludeOID				= Request.getParameter(request,"excludeOID");
	String sExcludeOIDprogram		= Request.getParameter(request,"excludeOIDprogram");
	String sHideHeader				= Request.getParameter(request,"hideHeader");
	String sFormName				= Request.getParameter(request,"formName");
	String sFrameName				= Request.getParameter(request,"frameName");
	String sFieldNameActual			= Request.getParameter(request,"fieldNameActual");
	String sFieldNameDisplay		= Request.getParameter(request,"fieldNameDisplay");
	String sFormInclusionList		= Request.getParameter(request,"formInclusionList");
	String sSearchCollectionEnabled = Request.getParameter(request,"searchCollectionEnabled");
	
	String sCollection				= Request.getParameter(request,"COLLECTION");
	String sFreezePane				= Request.getParameter(request,"freezePane");

	String jpoAppServerParamList	= Request.getParameter(request,"jpoAppServerParamList");

	String showInitialResults		= Request.getParameter(request,"showInitialResults");

	if(isVPLMAdmin)
	{
		sToolbar = "DSCDefaultVPLMAdminTopActionBar";
	}

	sTable					= (sTable == null || sTable.length() == 0) ? "DSCGeneric" : sTable;
	selection				= (selection == null || selection.length() == 0) ? "multiple" : selection;
	sToolbar				= (sToolbar == null || sToolbar.length() == 0) ? "DSCDefaultTopActionBar" : sToolbar;
	sCancelLabel			= (sCancelLabel == null || sCancelLabel.length() == 0) ? "emxFramework.GlobalSearch.Cancel" : sCancelLabel;
	sShowSavedQuery			= (sShowSavedQuery == null || sShowSavedQuery.length() == 0) ? "true" : sShowSavedQuery;
	jpoAppServerParamList	= (jpoAppServerParamList == null || jpoAppServerParamList.length() == 0) ? "session:GCOTable,session:GCO,session:LCO" : jpoAppServerParamList;
	showInitialResults		= (showInitialResults == null || showInitialResults.length() == 0) ? "false" : showInitialResults;
//[NDM] start    
String fieldSeperator 	= EnoviaResourceBundle.getProperty(context,"emxFramework.FullTextSearch.FieldSeparator");
	String sField 			= "TYPES=" + txtType + fieldSeperator + "isVersionObject=False" ;
//[NDM] end
%>

<html>
<body>
<form name="frmDSCFullSearch" method="post">
<%if(sTextSearch != null)
{
%>
        <!--XSSOK-->
	<input type="hidden" name="txtTextSearch" value="<%=sTextSearch%>" />
	<input type="hidden" name="default" value="<%=sdefault%>" />
<%
}
%>

<%if(sTable != null)
{
%>
        <!--XSSOK-->
	<input type="hidden" name="table" value="<%=XSSUtil.encodeForJavaScript(_context,sTable)%>" />
<%
}
%>
<%if(selection != null)
{
%>
         <!--XSSOK-->
	<input type="hidden" name="selection" value="<%=XSSUtil.encodeForJavaScript(_context,selection)%>" />
<%
}
%>
<%if(sToolbar != null)
{
%>
         <!--XSSOK-->
	<input type="hidden" name="toolbar" value="<%=sToolbar%>" />
<%
}
%>
<%if(sCancelLabel != null)
{
%>
         <!--XSSOK-->
	<input type="hidden" name="cancelLabel" value="<%=XSSUtil.encodeForJavaScript(_context,sCancelLabel)%>" />
<%
}
%>
<%if(showInitialResults != null)
{
%>
         <!--XSSOK-->
	<input type="hidden" name="showInitialResults" value="<%=showInitialResults%>" />
<%
}
%>
<%if(sField != null)
{
%>
         <!--XSSOK-->
	<input type="hidden" name="field" value="<%=sField%>" />
<%
}
%>

<%if(sShowSavedQuery != null)
{
%>
         <!--XSSOK-->
	<input type="hidden" name="showSavedQuery" value="<%=XSSUtil.encodeForJavaScript(_context,sShowSavedQuery)%>" />
<%
}
%>
<%if(jpoAppServerParamList != null)
{
%>
         <!--XSSOK-->
	<input type="hidden" name="jpoAppServerParamList" value="<%=jpoAppServerParamList%>" />
<%
}
%>
<%if(sCallbackFunction != null)
{
%>
        <!--XSSOK-->
	<input type="hidden" name="callbackFunction" value="<%=sCallbackFunction%>" />
<%
}
%>

<%if(sSubmitLabel != null)
{
%>
        <!--XSSOK-->
	<input type="hidden" name="submitLabel" value="<%=XSSUtil.encodeForJavaScript(_context,sSubmitLabel)%>" />
<%
}
%>
<%if(sViewFormBased != null)
{
%>
         <!--XSSOK-->
	<input type="hidden" name="viewFormBased" value="<%=sViewFormBased%>" />
<%
}
%>
<%if(sSubmitURL != null)
{
%>
         <!--XSSOK-->
	<input type="hidden" name="submitURL" value="<%=XSSUtil.encodeForJavaScript(_context,sSubmitURL)%>" />
<%
}
%>
<%if(sMandatorySearchParam != null)
{
%>
         <!--XSSOK-->
	<input type="hidden" name="mandatorySearchParam" value="<%=sMandatorySearchParam%>" />
<%
}
%>
<%if(sExcludeOID != null)
{
%>
         <!--XSSOK-->
	<input type="hidden" name="excludeOID" value="<%=sExcludeOID%>" />
<%
}
%>
<%if(sExcludeOIDprogram != null)
{
%>
        <!--XSSOK-->
	<input type="hidden" name="excludeOIDprogram" value="<%=sExcludeOIDprogram%>" />
<%
}
%>
<%if(sHideHeader != null)
{
%>
        <!--XSSOK-->
	<input type="hidden" name="hideHeader" value="<%=sHideHeader%>" />
<%
}
%>
<%if(sFormName != null)
{
%>
         <!--XSSOK-->
	<input type="hidden" name="formName" value="<%=sFormName%>" />
<%
}
%>
<%if(sFrameName != null)
{
%>
         <!--XSSOK-->
	<input type="hidden" name="frameName" value="<%=sFrameName%>" />
<%
}
%>
<%if(sFieldNameActual != null)
{
%>
         <!--XSSOK-->
	<input type="hidden" name="fieldNameActual" value="<%=sFieldNameActual%>" />
<%
}
%>
<%if(sFieldNameDisplay != null)
{
%>
         <!--XSSOK-->
	<input type="hidden" name="fieldNameDisplay" value="<%=sFieldNameDisplay%>" />
<%
}
%>
<%if(sFormInclusionList != null)
{
%>
         <!--XSSOK-->
	<input type="hidden" name="formInclusionList" value="<%=sFormInclusionList%>" />
<%
}
%>
<%if(sSearchCollectionEnabled != null)
{
%>
        <!--XSSOK-->
	<input type="hidden" name="searchCollectionEnabled" value="<%=sSearchCollectionEnabled%>" />
<%
}
%>
<%if(sCollection != null)
{
%>
        <!--XSSOK-->
	<input type="hidden" name="COLLECTION" value="<%=sCollection%>" />
<%
}
%>
<%if(sFreezePane != null)
{
%>
        <!--XSSOK-->
	<input type="hidden" name="freezePane" value="<%=sFreezePane%>" />
<%
}
%>
</form>
</body>
</html>

<script language="javascript">
document.frmDSCFullSearch.action =  "<%=XSSUtil.encodeForJavaScript(_context,searchURL)%>";
document.frmDSCFullSearch.submit();
</script>
