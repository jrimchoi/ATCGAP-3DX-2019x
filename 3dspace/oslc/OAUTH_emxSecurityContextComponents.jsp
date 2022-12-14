<%--  emxSecurityContextComponents.jsp   - security context selection page for MatrixOne applications

   Copyright (c) 1992-2015 Dassault Systemes.
   All Rights Reserved.
   This program contains proprietary and trade secret information of MatrixOne,
   Inc.  Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

      static const char RCSID[] = $Id: emxSecurityContextSelection.jsp $
--%>
<%@ page import="matrix.db.*, matrix.util.*, com.matrixone.servlet.*, java.text.* ,java.util.* , java.net.URLEncoder, com.matrixone.apps.domain.util.*, com.matrixone.apps.framework.taglib.*"  %>
<%@ page import="com.matrixone.apps.domain.util.PersonUtil" %>
<%@ page import="com.matrixone.apps.domain.util.PropertyUtil" %>
<%@ page import="com.matrixone.json.*"%>
<%
//JPA+
Context context= Framework.getMainContext(session);
String securityContextCompParamVal = request.getParameter("scParamValue");
String securityContextCompParamType = request.getParameter("scParamType");
JSONArray jarr=new JSONArray(); 
if (securityContextCompParamType.equalsIgnoreCase("Company"))
{
	StringList projectList = PersonUtil.getProjects(context,context.getUser(),securityContextCompParamVal);
	if (projectList.size() <= 0)
	{
		projectList = PersonUtil.getProjects(context,context.getUser(),"");
	}
	for(int i = 0 ; i < projectList.size() ; i++)
	{
		String strComp = (String)projectList.get(i);
		jarr.put(strComp);
	}
	
	String project = (String)projectList.get(0);
	StringList roleList = PersonUtil.getRoles(context,context.getUser(), securityContextCompParamVal, project);
	if (roleList.size() <= 0)
	{
		roleList = PersonUtil.getRoles(context,context.getUser(),"","");
	}
	String languageStr = request.getHeader("Accept-Language");
	String strRoleDisplay ="";
	for(int i = 0 ; i < roleList.size() ; i++)
	{
		String strComp = (String)roleList.get(i);
		strRoleDisplay = i18nNow.getRoleI18NString(strComp, languageStr);
		jarr.put("role_"+strComp +"|" + strRoleDisplay );
	}

}
if (securityContextCompParamType.equalsIgnoreCase("Project"))
{
	String org = request.getParameter("org");
	StringList roleList = PersonUtil.getRoles(context,context.getUser(), org, securityContextCompParamVal);
	String languageStr = request.getHeader("Accept-Language");
	String strRoleDisplay ="";
	if (roleList.size() <= 0)
	{
		String strComp = PersonUtil.getDefaultSCRole(context,context.getUser());
		strRoleDisplay = strComp;
		try
        {
        	strRoleDisplay = i18nNow.getRoleI18NString(strComp, languageStr);
        } catch (Exception ex)
        {
        	//Do Nothing just display actual role name
        }
		jarr.put(strComp + "|" + strRoleDisplay);			
	}
	else
	{
		for(int i = 0 ; i < roleList.size() ; i++)
		{
			String strComp = (String)roleList.get(i);
			strRoleDisplay = strComp;
			try
	        {
	        	strRoleDisplay = i18nNow.getRoleI18NString(strComp, languageStr);
	        } catch (Exception ex)
	        {
	        	//Do Nothing just display actual role name
	        }
			jarr.put(strComp + "|" + strRoleDisplay);
		}
	}

}
response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
response.setHeader("Pragma", "no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server
response.setContentType("text/html; charset=UTF-8");
out.print(jarr.toString());
%>
