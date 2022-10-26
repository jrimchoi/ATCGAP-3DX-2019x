<%--  emxCollectionsDetailsFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxCollectionsDetailsFS.jsp   - FS Detail page for Collections.


   static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxCollectionsDetailsFS.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>
<%@page import="com.matrixone.apps.domain.util.*"%>
<%@page import="java.util.*"%>
<%@include file="../emxUIFramesetUtil.inc"%>
<%@include file="../common/emxCompCommonUtilAppInclude.inc"%>


<%
  framesetObject fs = new framesetObject();
  fs.setDirectory(appDirectory);

  String initSource = emxGetParameter(request,"initSource");
  if (initSource == null){
    initSource = "";
  }
  String language               = request.getHeader("Accept-Language");
  String jsTreeID   = emxGetParameter(request,"jsTreeID");
  String suiteKey   = emxGetParameter(request,"suiteKey");
  String objectName  = emxGetParameter(request,"treeLabel");

 String tmpHeading = i18nNow.getI18nString(
    				"emxFramework.Common.CollectionsPropertiesPageHeading",
    				"emxFrameworkStringResource", language);

	System.out.println("--tmpHeading1->"+tmpHeading);
  // Changed for bug 305200
  String objectNameForHeading = objectName;

  String charSet = response.getCharacterEncoding();
  if(charSet == null || charSet.equals(""))
	charSet = "UTF-8";

  objectNameForHeading = FrameworkUtil.decodeURL(objectName, charSet);

  String tmpName = new String (objectNameForHeading);

  //String PageHeading = tmpName + FrameworkUtil.encodeURL(tmpHeading,charSet);
  
  String PageHeading            = tmpName + tmpHeading;
  PageHeading = XSSUtil.encodeForURL(context, PageHeading);
  StringBuffer contentURL = new StringBuffer("emxCollectionsDetails.jsp");

  // add these parameters to each content URL, and any others the App needs
  contentURL.append("?suiteKey=");
  contentURL.append(suiteKey);
  contentURL.append("&initSource=");
  contentURL.append(initSource);
  contentURL.append("&jsTreeID=");
  contentURL.append(jsTreeID);
  contentURL.append("&objectName=");
  contentURL.append(objectName);

  String finalURL=contentURL.toString();
  String sHeaderLink = i18nNow.getI18nString(
    				"emxFramework.Command.EditDetails",
    				"emxFrameworkStringResource", language);
  // Marker to pass into Help Pages
  // icon launches new window with help frameset inside
  String HelpMarker = "emxhelpdsccollprops";

  fs.useCache(false);
  fs.initFrameset(PageHeading,HelpMarker,finalURL,true,false,false,false);
  fs.setStringResourceFile("emxFrameworkStringResource");

  fs.setToolbar("AEFCollectionsPropertiesToolBar");

  fs.writePage(out);

%>
