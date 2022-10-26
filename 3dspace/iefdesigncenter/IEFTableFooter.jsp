<%--  IEFTableFooter.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%@ include file ="../integrations/MCADTopInclude.inc"%>

<%
	String tableName                 = MCADUrlUtil.hexDecode(emxGetParameter(request, "tableName"));	
	String encodedDefaultFooterPage  = emxGetParameter(request, "encodedDefaultFooterPage");	
	String decodedDefaultFooterPage	 = MCADUrlUtil.hexDecode(encodedDefaultFooterPage);	
	String isPopup                   = emxGetParameter(request, "isPopup");	
	String pageUrl                   = "";

    MCADIntegrationSessionData integSessionData  = (MCADIntegrationSessionData)session.getAttribute("MCADIntegrationSessionDataObject");
    String defaultTableName                      = integSessionData.getStringResource("mcadIntegration.Server.FieldName.DefaultTableName");
	
	        if(tableName.equals(defaultTableName))
	        {
			pageUrl=decodedDefaultFooterPage;

		}
		else
		{
		String mcadRoleList = integSessionData.getPropertyValue("mcadIntegration.MCADRoles");		
		
			if(isPopup.equals("true"))
			{
			pageUrl = "../common/emxAppBottomPageInclude.jsp?beanName=null&dir=mcadintegration&links=1&dialog=true&usepg=false&ldisp1=mcadIntegration.Server.ButtonName.Done&lhref1=parent.window.close()&lacc1=" + mcadRoleList + "&lpop1=false&ljs1=true&licon1=emxUIButtonDone.gif&wsize1=0&oidp=null&strfile=iefStringResource";
			
			}
			else
			{
				pageUrl = "../common/emxAppBottomPageInclude.jsp?beanName=null&dir=mcadintegration&links=0";
			}
		}	
%>
<!--XSSOK-->
<jsp:forward page ="<%=pageUrl%>"/>

