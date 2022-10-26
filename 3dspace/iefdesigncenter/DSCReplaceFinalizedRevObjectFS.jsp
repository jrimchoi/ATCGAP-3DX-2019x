<%--  DSCReplaceFinalizedRevObjectFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%@ page import = "com.matrixone.MCADIntegration.server.*,com.matrixone.MCADIntegration.server.beans.*,com.matrixone.apps.domain.util.*" %>
<%@ page import = "matrix.db.*" %>

<%@ include file ="../integrations/MCADTopInclude.inc" %>
<%@ include file ="../integrations/MCADTopErrorInclude.inc" %>

<%!

public String isParentEBOMSyched(Context context, String parentId, MCADMxUtil util)
{
	String ebomRelActualName	= "";
	String isParentEbomSynced	= "false";
	String exprValCommand		= "";
	String sResult				= "";
	try
	{
		ebomRelActualName = util.getActualNameForAEFData(context, "relationship_PartSpecification");
		sResult = util.execEvalExprStringForRel(context,new BusinessObject(parentId),"to",ebomRelActualName,"");

		if(sResult.startsWith("true"))
		{
			isParentEbomSynced = sResult.substring(5);		
		}
		else
		{
			sResult = sResult.substring(6);
			isParentEbomSynced = "Failed|"+sResult;		
		}
	}
	catch (Exception e)
	{
		isParentEbomSynced = "Failed|"+sResult;
	}	
	return isParentEbomSynced;
}


%>

<%
        Context context= Framework.getMainContext(session);
	String acceptLanguage	= request.getHeader("Accept-Language");
	String parentObjectId	= (String)Request.getParameter(request,"parentObjectId");
	String objectId			= (String)Request.getParameter(request,"objectId");
	String integrationName	= (String)Request.getParameter(request,"integrationName");
	String errorMessage		= "";
	String isParentEbomSynced = "false";

	String warningMessage   = "";	

	MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
	MCADServerResourceBundle resourceBundle     = new MCADServerResourceBundle(acceptLanguage);
	
	if(integSessionData == null)
	{
        errorMessage = resourceBundle.getString("mcadIntegration.Server.Message.ServerFailedToRespondSessionTimedOut");
	}
	else
	{	
		Context IEFContext = integSessionData.getClonedContext(session);				
		MCADMxUtil util    = new MCADMxUtil(IEFContext, integSessionData.getLogger(), resourceBundle, integSessionData.getGlobalCache());

		isParentEbomSynced = isParentEBOMSyched(IEFContext, parentObjectId, util);

		warningMessage = resourceBundle.getString("mcadIntegration.Server.Message.ReplaceRevisionReDoEBOM");

		if(isParentEbomSynced.startsWith("Failed"))
			errorMessage = isParentEbomSynced.substring(7);
	}
%>

<%@include file = "../integrations/MCADBottomErrorInclude.inc"%>

<%
	if ("".equals(errorMessage.trim()))
	{
	} else {
%>
	<link rel="stylesheet" href="../emxUITemp.css" type="text/css">
	&nbsp;
      <table width="90%" border=0  cellspacing=0 cellpadding=3  class="formBG" align="center" >
        <tr >
		  <!--XSSOK-->
          <td class="errorHeader"><%=resourceBundle.getString("mcadIntegration.Server.Heading.Error")%></td>
        </tr>
        <tr align="center">
          <td class="errorMessage" align="center"><%=XSSUtil.encodeForHTML(context, errorMessage)%></td>
        </tr>
      </table>
<%
	}
%>

<html>
<head>
<script language="JavaScript" src="scripts/IEFUIConstants.js"></script>
<script language="JavaScript" src="scripts/IEFUIModal.js"></script>
<script src="scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
<script language="JavaScript">

var integrationName		= '<%= XSSUtil.encodeForJavaScript(context,integrationName) %>';
//XSSOK
var warningMessage		= "<%= warningMessage %>";
//XSSOK
var isParentEbomSynced	= "<%= isParentEbomSynced %>";

function selectObjectForReplace()
{
	//Show warning to user if parent is ebom synched.

	if( isParentEbomSynced == "true")
		showAlert(warningMessage, "false");

	var objForm = parent.frames["decFormDisplay"].frames['listDisplay'].document.forms['emxTableForm'];//framedecFormDisplay.frames['listDisplay'].document.forms['emxTableForm'];

	var selectedObjectId ="";
	if (objForm && objForm.emxTableRowId)
	{
		if (objForm.emxTableRowId[0])
		{
			for (var i = 0; i < objForm.emxTableRowId.length; i++)
			{
				if(objForm.emxTableRowId[i].checked == true)
				{
					selectedObjectId = objForm.emxTableRowId[i].value;
					break;
				}
			}
		} 
		else
		{
			if(objForm.emxTableRowId.checked == true)
			{
				selectedObjectId = objForm.emxTableRowId.value;
			}
		}
	}
	parent.top.opener.processSearchResult(selectedObjectId);	
	top.window.close();
}

function closeModalDialog()
{
   window.close();
}

function showAlert(message, close)
{
	alert(message);
	if(close == "true")
		closeModalDialog();
}

function onWindowClose()
{
	closeModalDialog();
}

</script>
</head>

<frameset rows="80,*,80" frameborder="no" framespacing="0" onUnload="javascript:onWindowClose()" onBeforeUnload="javascript:onWindowClose()">
	<frame name="decHeaderDisplay" src="DSCReplaceFinalizedRevObjectHeader.jsp" scrolling=no>
	<frame name="decFormDisplay" src="DSCReplaceFinalizedRevObjectContent.jsp?parentObjectId=<%=XSSUtil.encodeForJavaScript(context,parentObjectId)%>&objectId=<%=XSSUtil.encodeForJavaScript(context,objectId)%>&integrationName=<%=XSSUtil.encodeForJavaScript(context,integrationName)%>" marginheight="3">
	<frame name="decBottomDisplay" src="DSCReplaceFinalizedRevObjectFooter.jsp" scrolling=no >
</frameset>
</html>


