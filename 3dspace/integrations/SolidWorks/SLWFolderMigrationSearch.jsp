<%--  SLWFolderMigrationSearch.jsp

  Copyright Dassault Systemes, 1992-2007. All rights reserved.
  This program contains proprietary and trade secret information of
  Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
  and does not evidence any actual or intended publication of such program

--%>

<%@include file = "../../iefdesigncenter/DSCSearchUtils.inc" %>
<%@include file = "../../iefdesigncenter/DSCAppletUtils.inc" %>
<%@ include file = "../MCADResponseHeaderInclude.inc" %>
<%@include file = "../../emxUICommonAppInclude.inc"%>
<%@include file = "../../emxUICommonHeaderBeginInclude.inc" %>
<%@ page import="com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.beans.*,com.matrixone.apps.domain.util.*,com.matrixone.MCADIntegration.server.*,com.matrixone.MCADIntegration.server.cache.*"  %>

<%
    MCADIntegrationSessionData integSessionData	= (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
	MCADLocalConfigObject lco					= integSessionData.getLocalConfigObject();
           
   if(lco == null  ||  lco.getIntegrationNameGCONameMapping().size() == 0 || integSessionData.isNonIntegrationUser())
   {
	  String featureName		= MCADGlobalConfigObject.FEATURE_SEARCH;
	  String errorPage			= "../emxAppletTimeOutErrorPage.jsp?featureName="+featureName;
%>
	  <jsp:forward page="<%=errorPage%>" />
<%
    }
	String queryString		= emxGetQueryString (request);
	String integrationName	= emxGetParameter(request, "integrationName");

	if(integSessionData != null)
	{
		if (integrationName == null || integrationName.equals(""))
		{
		   integrationName = getDefaultIntegrationName(request, integSessionData);
		}
	}
%>

<%	
	Context _context	= integSessionData.getClonedContext(session);
    MCADGlobalConfigObject globalConfigObject	= integSessionData.getGlobalConfigObject(integrationName,_context);
    HashMap globalConfigObjectTable				= (HashMap)integSessionData.getIntegrationNameGCOTable(_context);

    session.setAttribute("GCOTable", globalConfigObjectTable);
	session.setAttribute("GCO", globalConfigObject);
	session.setAttribute("LCO", lco);
    
    MCADMxUtil _mxUtil  = new MCADMxUtil(_context, new MCADServerResourceBundle("en-US"), new IEFGlobalCache());
    Map programMap      = new HashMap();
    programMap.put("GCO", globalConfigObject);
    String [] packedGCO = JPO.packArgs(programMap);

    String txtType		= _mxUtil.executeJPO(_context, "SLWFolderMigration", "getTypesForTypeChooser", packedGCO);
	
	String searchURL				= "../../common/emxFullSearch.jsp";

	String sTable					= Request.getParameter(request,"table");
	String selection				= Request.getParameter(request,"selection");
	String sCancelLabel				= Request.getParameter(request,"cancelLabel");
	String sCallbackFunction		= Request.getParameter(request,"callbackFunction");
	String sSubmitLabel				= Request.getParameter(request,"submitLabel");
	
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

    String folderObjectId		= Request.getParameter(request,"objectId");

	sTable					= (sTable == null || sTable.length() == 0) ? "SLWFolderMigrationSearch" : sTable;
	selection				= (selection == null || selection.length() == 0) ? "multiple" : selection;
	sToolbar				= (sToolbar == null || sToolbar.length() == 0) ? "SLWFolderMigrationActions" : sToolbar;
	sCancelLabel			= (sCancelLabel == null || sCancelLabel.length() == 0) ? "emxFramework.GlobalSearch.Cancel" : sCancelLabel;
	jpoAppServerParamList	= (jpoAppServerParamList == null || jpoAppServerParamList.length() == 0) ? "session:GCOTable,session:GCO,session:LCO" : jpoAppServerParamList;
	showInitialResults		= (showInitialResults == null || showInitialResults.length() == 0) ? "false" : showInitialResults;
	
String sField = "TYPES=" + txtType;// + "&form=SLWFolderMigrationSearch";
%>

<html>
<body>
<form name="frmDSCFullSearch" method="post">

<%if(sTable != null)
{
%>
	<input type="hidden" name="table" value="<%=sTable%>" />
<%
}
%>
<%if(selection != null)
{
%>
	<input type="hidden" name="selection" value="<%=selection%>" />
<%
}
%>
<%if(sToolbar != null)
{
%>
	<input type="hidden" name="toolbar" value="<%=sToolbar%>" />
<%
}
%>
<%if(sCancelLabel != null)
{
%>
	<input type="hidden" name="cancelLabel" value="<%=sCancelLabel%>" />
<%
}
%>
<%if(showInitialResults != null)
{
%>
	<input type="hidden" name="showInitialResults" value="<%=showInitialResults%>" />
<%
}
%>
<%if(sField != null)
{
%>
	<input type="hidden" name="field" value="<%=sField%>" />
<%
}
%>
<%if(jpoAppServerParamList != null)
{
%>
	<input type="hidden" name="jpoAppServerParamList" value="<%=jpoAppServerParamList%>" />
<%
}
%>
<%if(sCallbackFunction != null)
{
%>
	<input type="hidden" name="callbackFunction" value="<%=sCallbackFunction%>" />
<%
}
%>

<%if(sSubmitLabel != null)
{
%>
	<input type="hidden" name="submitLabel" value="<%=sSubmitLabel%>" />
<%
}
%>
<%if(sViewFormBased != null)
{
%>
	<input type="hidden" name="viewFormBased" value="<%=sViewFormBased%>" />
<%
}
%>
<%if(sSubmitURL != null)
{
%>
	<input type="hidden" name="submitURL" value="<%=sSubmitURL%>" />
<%
}
%>
<%if(sMandatorySearchParam != null)
{
%>
	<input type="hidden" name="mandatorySearchParam" value="<%=sMandatorySearchParam%>" />
<%
}
%>
<%if(sExcludeOID != null)
{
%>
	<input type="hidden" name="excludeOID" value="<%=sExcludeOID%>" />
<%
}
%>
<%if(sExcludeOIDprogram != null)
{
%>
	<input type="hidden" name="excludeOIDprogram" value="<%=sExcludeOIDprogram%>" />
<%
}
%>
<%if(sHideHeader != null)
{
%>
	<input type="hidden" name="hideHeader" value="<%=sHideHeader%>" />
<%
}
%>
<%if(sFormName != null)
{
%>
	<input type="hidden" name="formName" value="<%=sFormName%>" />
<%
}
%>
<%if(sFrameName != null)
{
%>
	<input type="hidden" name="frameName" value="<%=sFrameName%>" />
<%
}
%>
<%if(sFieldNameActual != null)
{
%>
	<input type="hidden" name="fieldNameActual" value="<%=sFieldNameActual%>" />
<%
}
%>
<%if(sFieldNameDisplay != null)
{
%>
	<input type="hidden" name="fieldNameDisplay" value="<%=sFieldNameDisplay%>" />
<%
}
%>
<%if(sFormInclusionList != null)
{
%>
	<input type="hidden" name="formInclusionList" value="<%=sFormInclusionList%>" />
<%
}
%>
<%if(sSearchCollectionEnabled != null)
{
%>
	<input type="hidden" name="searchCollectionEnabled" value="<%=sSearchCollectionEnabled%>" />
<%
}
%>
<%if(sCollection != null)
{
%>
	<input type="hidden" name="COLLECTION" value="<%=sCollection%>" />
<%
}
%>
<%if(sFreezePane != null)
{
%>
	<input type="hidden" name="freezePane" value="<%=sFreezePane%>" />
<%
}
%>
<%if(folderObjectId != null)
{
%>
	<input type="hidden" name="folderObjectId" value="<%=folderObjectId%>" />
<%
}
%>
</form>
</body>
</html>

<script language="javascript">
document.frmDSCFullSearch.action =  "<%=searchURL%>";
document.frmDSCFullSearch.submit();
</script>
