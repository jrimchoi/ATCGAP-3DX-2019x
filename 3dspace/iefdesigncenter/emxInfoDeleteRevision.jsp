<%--  emxInfoDeleteRevision.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoDeleteRevision.jsp $
  $Revision: 1.3.1.4$
  $Author: ds-hbhatia$

--%>

<%--
 *
 * $History: emxInfoDeleteRevision.jsp $
 * 
 * *****************  Version 16  *****************
 * User: Rahulp       Date: 12/09/02   Time: 5:37p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 15  *****************
 * User: Mallikr      Date: 11/22/02   Time: 5:57p
 * Updated in $/InfoCentral/src/InfoCentral
 * code cleanup
 * 
--%>

<%@include file = "emxInfoCentralUtils.inc"%>
<%@ page import = "matrix.db.*" %>
<%@ page import = "com.matrixone.MCADIntegration.server.*" %>
<%@ page import = "com.matrixone.MCADIntegration.server.beans.*" %>
<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>
<html>
<%


    MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
	MCADMxUtil util = null;

	if(integSessionData != null) 
	 {
		util = new MCADMxUtil(context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
	 }


	String objectId				= emxGetParameter(request, "objectId");
	String idList[]				= emxGetParameterValues(request, "emxTableRowId");
	StringList exceptionList	= new StringList();

	for(int i=0; i<idList.length; ++i)
	{
		StringTokenizer strTok = new StringTokenizer(idList[i], "|");
		String busId = null;										 
		if(strTok.hasMoreTokens())
			busId = strTok.nextToken();

		//remove the object if it is not the one currently displayed
		if(null != busId && !busId.equals(objectId))
		{
			BusinessObject busObject = new BusinessObject(busId);
			try
			{
				util.setRPEVariablesForIEFOperation(context,MCADServerSettings.ISDECDelete);

				ENOCsrfGuard.validateRequest(context, session, request, response);
			  	ContextUtil.startTransaction(context, true);
				busObject.remove(context);
				ContextUtil.commitTransaction(context);
			}
			catch(Exception exception)
			{
				ContextUtil.abortTransaction(context);
				exceptionList.add(exception.toString().trim());
			}
			finally
			{
				util.unsetRPEVariablesForIEFOperation(context,MCADServerSettings.ISDECDelete);
			}
		}
		else if(null != busId)
		{
			String busMsg= i18nStringNow("emxIEFDesignCenter.Error.Self", request.getHeader("Accept-Language"));
			exceptionList.add(busMsg);
		}  
}
	
for (int k =0 ;k<exceptionList.size();k++)
{
	String exceptionMsg=((String)(exceptionList.get(k))).trim();
	exceptionMsg = exceptionMsg.replace('\n',' ');
%>
         <script language="JavaScript">
		    //XSSOK
			alert("<%=exceptionMsg%>");
		</script>		
<%
}
%>
<script language="JavaScript">
	   parent.location.href=parent.location.href;
</script>  
