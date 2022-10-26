<%--  emxCollectionsEditDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxCollectionsEditDialog.jsp   - Dialog page to take input for editing a Collection.


      static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxCollectionsEditDialog.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>
<%@ page import = "com.matrixone.MCADIntegration.utils.*" %>

<%@include file = "../emxUICommonAppInclude.inc"%>
<%@include file = "../common/emxCompCommonUtilAppInclude.inc"%>
<script language="JavaScript" src="../common/scripts/emxUICollections.js" type="text/javascript"></script>

<%@include file = "../emxUICommonHeaderBeginInclude.inc"%>
<%@include file = "../emxJSValidation.inc" %>

<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<%
  String languageStr = request.getHeader("Accept-Language");
  String jsTreeID    = emxGetParameter(request,"jsTreeID");
  String suiteKey    = emxGetParameter(request,"suiteKey");
  String objectName  = emxGetParameter(request,"objectName");
  
  String setName = objectName;
  objectName = MCADUrlUtil.hexDecode(objectName);
//  objectName = FrameworkUtil.decodeURL(objectName,"UTF-8");
 %>

<script language="Javascript" >

  function cancelMethod()
  {
     top.close();
  }
  //XSSOK
  var originalName = "<%=objectName%>";

  function doneMethod()
  {
     var nameValue = document.editForm.collectionName.value;
     document.editForm.nameChanged.value = !(nameValue == originalName);

     var nameCheckValue = checkForNameBadChars(nameValue,false);

     //validate that all required fields are entered
     if(nameValue==null || nameValue=="")
     {
        alert("<emxUtil:i18nScript localize="i18nId">emxFramework.Collections.NewCollection</emxUtil:i18nScript>");
        document.editForm.collectionName.focus();
        return;
     }
     else if (charExists(nameValue, '"')||charExists(nameValue, '\'')||charExists(nameValue, '#')||(nameCheckValue == false))
     {
         alert("<emxUtil:i18nScript localize="i18nId">emxFramework.Common.InvalidName</emxUtil:i18nScript>");
        document.editForm.collectionName.focus();
        return;
     }
     else
     {
        document.editForm.submit();
     }
  }

</script>

<%@include file = "../emxUICommonHeaderEndInclude.inc" %>
<%
    long collectionCnt = SetUtil.getCount(context, objectName);

    // ----------- set up the url to do the edit and refresh itself.
    StringBuffer editURL = new StringBuffer("emxCollectionsEditProcess.jsp?objectName=");
    editURL.append(setName);
    editURL.append("&jsTreeID=");
    editURL.append(jsTreeID);
    editURL.append("&suiteKey=");
    editURL.append(suiteKey);
    String output = MqlUtil.mqlCommand(context, "list property on set $1",objectName);
    int endNameIndex = output.indexOf("value");
    String  dbDesc ="";

    if(endNameIndex > -1)
    dbDesc = output.substring(endNameIndex+6);

    if(dbDesc.equalsIgnoreCase("null")||  dbDesc==null)
    dbDesc="";
%>
<!--XSSOK-->
<form name="editForm" method="post" onsubmit="doneMethod(); return false" action="<%=editURL.toString()%>">
<%
boolean csrfEnabled = ENOCsrfGuard.isCSRFEnabled(context);
if(csrfEnabled)
{
  Map csrfTokenMap = ENOCsrfGuard.getCSRFTokenMap(context, session);
  String csrfTokenName = (String)csrfTokenMap .get(ENOCsrfGuard.CSRF_TOKEN_NAME);
  String csrfTokenValue = (String)csrfTokenMap.get(csrfTokenName);
%>
  <!--XSSOK-->
  <input type="hidden" name= "<%=ENOCsrfGuard.CSRF_TOKEN_NAME%>" value="<%=csrfTokenName%>" />
  <!--XSSOK-->
  <input type="hidden" name= "<%=csrfTokenName%>" value="<%=csrfTokenValue%>" />
<%
}
//System.out.println("CSRFINJECTION::emxCollectionsEditDialog.jsp::form::editForm");
%>

<table border="0" width="100%" cellpadding="5" cellspacing="2">
  <tr>
    <td class="labelRequired"><emxUtil:i18n localize="i18nId">emxFramework.Common.Name</emxUtil:i18n></td>
	<!--XSSOK-->
    <td class="inputField"><input type="text" name="collectionName" size="25" value="<%=objectName%>" onFocus="this.select()">
    <input type="hidden" name="nameChanged" value="false">
    </td>
  </tr>
  <tr>
    <td class="label"><emxUtil:i18n localize="i18nId">emxFramework.Common.Description</emxUtil:i18n></td>
    <td class="inputField">
	    <!--XSSOK-->
        <textarea cols="25" rows="5" name="description"  onFocus="this.select()"><%=dbDesc%></textarea>
    </td>
    </td>
  </tr>
  <tr>
    <td class="label"><emxUtil:i18n localize="i18nId">emxFramework.Collections.ItemCount</emxUtil:i18n></td>
    <td class="field"><%=collectionCnt%>&nbsp;</td>
    </td>
  </tr>
</table>
<input type="image" height="1" width="1" border="0" />
</form>

<%@include file = "../emxUICommonEndOfPageInclude.inc" %>
