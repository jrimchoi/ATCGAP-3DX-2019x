<%--  emxProductCommonInclude.inc

  Copyright (c) 1992-2018 Dassault Systemes.
  All Rights Reserved.
  This program contains proprietary and trade secret information of MatrixOne,
  Inc.  Copyright notice is precautionary only and does not evidence any actual
  or intended publication of such program.

  static const char RCSID[] = "$Id: /ENOVariantConfigurationBase/CNext/webroot/configuration/emxProductCommonInclude.inc 1.3.2.1.1.1 Wed Oct 29 22:27:16 2008 GMT przemek Experimental$"

--%>

<%@include file = "../emxTagLibInclude.inc"%>
<%
String acceptLanguage = request.getHeader("Accept-Language");

//Code to be inserted for the bundle to be read from prop file.
String bundle = "emxConfigurationStringResource";
String DateFrm = "";

%>
 <!-- XSSOK -->
<framework:localize id="i18nId" bundle="emxConfigurationStringResource" locale='<%=acceptLanguage%>'/>



