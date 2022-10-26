<%--  emxInfoRequestWrapperMethods.inc

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  

   static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxInfoRequestWrapperMethods.inc 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>
<%@ page import = "matrix.db.*, matrix.util.* ,com.matrixone.servlet.*, java.util.*, java.io.*" %>
<%!
  //
  // check for URL appended values if not found, then look in Request Headers and return the string
  //
  static public String emxGetParameter(HttpServletRequest request, String parameter)
  {
    String parameterValue = request.getParameter(parameter);
    if (parameterValue == null || "null".equals(parameterValue)) {
      parameterValue = (String)request.getAttribute(parameter);
    }
    return parameterValue;
  }
%>

<%!
  //
  // if same parameter is sent multiple times in a request
  //
  static public String[] emxGetParameterValues(HttpServletRequest request, String parameter)
  {
    String parameterValues[] = request.getParameterValues(parameter);
    return parameterValues;
   }
%>

<%!
  //
  // return the list of parameter names
  //
  static Enumeration emxGetParameterNames(HttpServletRequest req)
  {
    Enumeration parameterNamesEnum = req.getParameterNames();
    return (parameterNamesEnum);
  }
%>

<%!
  //
  // return the Querystring of request
  //
  static public String emxGetQueryString(HttpServletRequest request)
  {

    String queryString = request.getQueryString();
    return queryString;
  }

  %>
