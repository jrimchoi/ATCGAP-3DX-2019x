<%--  eServiceFramework.inc

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
    $Archive: /InfoCentral/src/infocentral/eServiceFramework.inc $
    $Revision: 1.3.1.3$
    $Author: ds-mbalakrishnan$
--%>

<%--
 *
 * $History: eServiceFramework.inc $
 * 
 * *****************  Version 5  *****************
 * User: Rahulp       Date: 1/14/03    Time: 4:00p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 4  *****************
 * User: Snehalb      Date: 11/26/02   Time: 3:10p
 * Updated in $/InfoCentral/src/InfoCentral
 *
 * ***********************************************
 *
--%>

<%@ page import = "matrix.db.*, matrix.util.* ,com.matrixone.servlet.*, java.util.*,java.io.*" errorPage="eServiceError.jsp"%>

<%
    String pageName = request.getRequestURI();
    if (emxGetQueryString(request)!= null) 
    {
        pageName += "?" + emxGetQueryString(request);
    }
    Framework.setTargetPage(session, pageName);
    
    if (!Framework.isLoggedIn(request)) 
    {
%>
        <jsp:forward page ="../emxLogin.jsp"/>
<%
        return;
    }
    matrix.db.Context context = Framework.getFrameContext(session);  

    //This is to make sure that this file is not included twice in any jsp page.  
    int intemxInfoContentType = 0;
%>

<%!
    //
    // check for URL appened values if not found, then look in Request Headers and return the string
    //
    static public String getParam(HttpServletRequest request, String parameter) throws MatrixException
    {
        String parameterValue = request.getParameter(parameter);
        if (parameterValue == null) 
        {
            parameterValue = (String)request.getAttribute(parameter);
        }
        return parameterValue;
    }
%>

<%@include file="emxInfoRequestWrapperMethods.inc" %>
