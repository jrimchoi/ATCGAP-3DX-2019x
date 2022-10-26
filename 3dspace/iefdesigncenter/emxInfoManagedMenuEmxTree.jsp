	<%--  emxInfoManagedMenuEmxTree.jsp

	   Copyright (c) 2016 Dassault Systemes. All rights reserved.
	   This program contains proprietary and trade secret information of
	   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
	   and does not evidence any actual or intended publication of such program

	--%>
	<%--
	  Name of the File : emxInfoManagedMenuEmxTree.jsp

	  Description : This jsp gets appropriate IEF menu for given objects & forwards to emxTree

	--%>

	<%@ page import="com.matrixone.MCADIntegration.uicomponents.beans.*" %>
	<%@ page import="com.matrixone.MCADIntegration.server.beans.*,com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.*" %>
	<%@include file="emxInfoCentralUtils.inc" %>
	<%@include file="emxInfoUtils.inc"%>
          <%@include file="../emxTagLibInclude.inc"%>
	<%@ include file="../integrations/MCADTopErrorInclude.inc" %>
	<%--Put IEF Menu Name in session--%>

	<%!
		public static String getAppProperty(ServletContext application, String key)
		{
			Properties appProps = (Properties)application.getAttribute(propertyAlias);
			if (appProps == null)
				return null;

			return appProps.getProperty(key);
		}


		private boolean isMenuExists(Context context, String symbolicBusType)
		{
			boolean isExists = false;

			try
			{
				String output		= MqlUtil.mqlCommand(context, "list menu $1",symbolicBusType);

				if (output!=null && output.trim().length()>0)
				{
					isExists = true;
				}
			}
			catch (Exception exception)
			{
			   System.out.println("Error while looking for type menu");
			}

			return isExists;
		}

		private String getMenuNameForType(Context context, String busType,ServletContext application) throws Exception
		{
			String menuName			= "";
			String parentBusType	= "";

			String symbolicBusType	= FrameworkUtil.getAliasForAdmin(context, "type", busType, true);
			boolean isExists		= isMenuExists(context, symbolicBusType);

			if(isExists)
			{
				menuName = symbolicBusType;
				if( menuName.equals("type_ProjectVault"))
				{
					String strAlternateName = getAppProperty(application,"eServiceSuiteDesignerCentral.emxTreeAlternateMenuName.type_ProjectVault");

					if(strAlternateName!=null)
						menuName= strAlternateName;
				}
			}

			else
			{
				//Get parent type's menu
				String output		= MqlUtil.mqlCommand(context, "print type $1 select $2 dump",busType,"derived");

				if (output != null && !output.equals(""))
				{
					parentBusType	= output.trim();
					menuName		= getMenuNameForType(context, parentBusType,application);
				}
			}

			if(menuName == null || menuName.equals(""))
			{
					// Support business object of the Workspace Management and Team Central
					if (isMenuExists(context, symbolicBusType))
							menuName = symbolicBusType;
						else {
							String symbolicParentBusType	= FrameworkUtil.getAliasForAdmin(context, "type", parentBusType, true);
							if (isMenuExists(context, symbolicParentBusType))
							   menuName = symbolicParentBusType;
							else
							   menuName = "type_BusinessObject";
				}
			}


			return menuName;
		}
	%>

	<%
		
		String queryString		= (String) emxGetQueryString(request);

		MCADIntegrationSessionData integSessionData	= (MCADIntegrationSessionData) session.getAttribute(MCADServerSettings.MCAD_INTEGRATION_SESSION_DATA_OBJECT);
		MCADMxUtil util								= new MCADMxUtil(context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());

		boolean isTransactionStarted = false;

		try
		{
			String errorMessage	= "";
	        String sMenuName	= "";
			try
			{
				if(!context.isTransactionActive())
				{
					isTransactionStarted = true;
					util.startReadOnlyTransaction(context);
				}

				String sBusObjId			= (String) emxGetParameter(request, "objectId");
				BusinessObject busObject	= new BusinessObject(sBusObjId);

				busObject.open(context);

				String busType = busObject.getTypeName();

				busObject.close(context);

				String integrationName						= util.getIntegrationName(context, sBusObjId);


				MCADGlobalConfigObject globalConfigObject	= integSessionData.getGlobalConfigObject(integrationName,context);
				// [NDM] QWJ
				if(globalConfigObject != null && !globalConfigObject.isCreateVersionObjectsEnabled() && !util.isMajorObject(context, sBusObjId))
				{
					BusinessObject majorBus = util.getMajorObject(context,busObject);
					majorBus.open(context);
					busType	= majorBus.getTypeName();
					String majorObjectId	= majorBus.getObjectId();
					majorBus.close(context);

					StringTokenizer tokenizer = new StringTokenizer(queryString, "&");
					StringBuffer queryStringBuffer = new StringBuffer();
					while(tokenizer.hasMoreTokens())
					{
					   String token = tokenizer.nextToken();

					   if (token != null)
					   {
						   if (queryStringBuffer.length() > 0)
							  queryStringBuffer.append("&");
						   if (token.startsWith("objectId"))
							  queryStringBuffer.append("objectId="+majorObjectId);
						   else
							  queryStringBuffer.append(token);
					   }
					}
					if (queryStringBuffer.length() > 0)
					   queryString = queryStringBuffer.toString();
				}
				sMenuName	= getMenuNameForType(context, busType,application);
			}
			catch(Exception e)
			{
				errorMessage	= e.getMessage();
				emxNavErrorObject.addMessage(errorMessage);
			}
			String sActionURL	= "../common/emxTree.jsp?treeMenu=" + sMenuName + "&" + queryString;

			sActionURL = sActionURL.replace(' ','+');
		
			if ((emxNavErrorObject.toString()).trim().length() == 0)
			{
%>
				<script language="JavaScript">
					document.location.href="<%=XSSUtil.encodeForJavaScript(integSessionData.getClonedContext(session),sActionURL)%>";
				</script>

<%
			}
			else
			{
%>
			<script language="JavaScript">
			document.location.href="<%=XSSUtil.encodeForJavaScript(integSessionData.getClonedContext(session),sActionURL)%>";
			</script>

			<html>
					<body>
						<link rel="stylesheet" href="../emxUITemp.css" type="text/css">
						&nbsp;
						  <table width="90%" border=0  cellspacing=0 cellpadding=3  class="formBG" align="center" >
							<tr >
                                                          <!--XSSOK-->
							  <td class="errorHeader"><%=integSessionData.getStringResource("mcadIntegration.Server.Heading.Error")%></td>
							</tr>
							<tr align="center">
							  <td class="errorMessage" align="center"><xss:encodeForHTML><%=emxNavErrorObject%></xss:encodeForHTML></td>
							</tr>
						  </table>
					</body>
			</html>
<%
		}
	}
	finally
	{
		if(isTransactionStarted)
			util.commitReadOnlyTransaction(context);
	}
%>


