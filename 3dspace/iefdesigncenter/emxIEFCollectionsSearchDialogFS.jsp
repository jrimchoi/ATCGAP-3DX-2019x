<%--  emxIEFCollectionsSearchDialogFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
 <%-- 

  static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxIEFCollectionsSearchDialogFS.jsp 1.3.1.4 Wed Jul 23 14:57:04 2008 GMT ds-agautam Experimental$
--%>

<%@include file="../emxUIFramesetUtil.inc"%>
<jsp:useBean id="indentedTableBean" class="com.matrixone.apps.framework.ui.UITableIndented" scope="session" />
<%@ page import= "com.matrixone.apps.domain.util.FrameworkUtil"%>

<%
  // ----------------- Do Not Edit Above ------------------------------

  String charSet = request.getCharacterEncoding();
  if(charSet == null || charSet.equals(""))
	charSet = "UTF-8";


String contextSetName = CacheUtil.getCacheString(context, "DEC_CollectionName");

String sCollectionId = SetUtil.getCollectionId(context,contextSetName);
	

  String objectId = emxGetParameter(request,"objectId");
  
  String jsTreeID = emxGetParameter(request,"jsTreeID");
  String collection = emxGetParameter(request,"collection");
 // String sCollectionName="";
  //String sCollectionId = "";
 /* if (collection != null && 
      !"null".equalsIgnoreCase(collection) &&
      !"".equalsIgnoreCase(collection) &&
      "true".equalsIgnoreCase(collection)) {
    String timeStamp = emxGetParameter(request,"timeStamp");
    /*sCollectionName  = emxGetParameter(request,"setName");
  sCollectionId = SetUtil.getCollectionId(context,sCollectionName);
  sCollectionId = emxGetParameter(request,"relId");
//System.out.println("<<--sCollectionId-->>"+sCollectionId);	
    HashMap tableData = indentedTableBean.getTableData(timeStamp);
    HashMap requestMap = indentedTableBean.getRequestMap(tableData);
    String s1CollectionId = emxGetParameter(request,"relId");
//	System.out.println("<<--s1CollectionId-->>"+s1CollectionId);	
  }
*/
  // Specify URL to come in middle of frameset
  StringBuffer contentURL = new StringBuffer(100);
  contentURL.append("../iefdesigncenter/DSCFullSearch.jsp?selection=multiple&hideHeader=true&showClipboard=false");
  

  // add these parameters to each content URL, and any others the App needs
  contentURL.append("&submitURL=");
  contentURL.append("../common/emxCollectionsAddToProcess.jsp?CollectionId="+sCollectionId);
  
  response.sendRedirect(contentURL.toString());
%>
