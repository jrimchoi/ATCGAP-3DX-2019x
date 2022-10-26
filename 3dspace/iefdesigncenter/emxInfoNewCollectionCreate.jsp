<%--  emxInfoNewCollectionCreate.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoNewCollectionCreate.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoNewCollectionCreate.jsp $
 * 
 * *****************  Version 9  *****************
 * User: Priteshb     Date: 12/19/02   Time: 6:54p
 * Updated in $/InfoCentral/src/infocentral
 * Adding else condition
 * 
 * *****************  Version 8  *****************
 * User: Gauravg      Date: 12/13/02   Time: 7:23p
 * Updated in $/InfoCentral/src/infocentral
 * Removed sorting feature in column header
 * 
 * *****************  Version 6  *****************
 * User: Gauravg      Date: 11/27/02   Time: 5:10p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 5  *****************
 * User: Gauravg      Date: 11/27/02   Time: 12:34p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 4  *****************
 * User: Snehalb      Date: 11/25/02   Time: 3:41p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 3  *****************
 * User: Mallikr      Date: 11/22/02   Time: 3:43p
 * Updated in $/InfoCentral/src/InfoCentral
 * code cleanup
 * 
 * *****************  Version 2  *****************
 * User: Bhargava     Date: 5/14/02    Time: 5:09p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 1  *****************
 * User: Bhargava     Date: 9/27/02    Time: 11:54a
 * Created in $/InfoCentral/src/InfoCentral
 *
 * ***********************************************
 *
--%>
<%@include file="emxInfoCentralUtils.inc" %>

<%@ page import="java.net.*, com.matrixone.apps.domain.*,com.matrixone.apps.domain.util.*" %>
<%@include file = "../emxTagLibInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<%@include file="../emxUICommonHeaderBeginInclude.inc" %>
<%@include file="../emxJSValidation.inc" %>


<%!
    public MapList getSelectedItems(Context context, 
        HttpServletRequest request,HttpSession session) throws FrameworkException, Exception
    {        
        String timeStamp =  emxGetParameter(request,"timeStamp");
        String[] objectIds = (String[])session.getAttribute("ObjectIds"+timeStamp);
        session.removeAttribute("ObjectIds" + timeStamp);
                
        MapList partList = new MapList(objectIds.length);

        StringList sList = new StringList();
        sList.addElement(DomainObject.SELECT_ID);
        sList.addElement(DomainObject.SELECT_NAME);
        sList.addElement(DomainObject.SELECT_TYPE);
        sList.addElement(DomainObject.SELECT_REVISION);
        sList.addElement(DomainObject.SELECT_DESCRIPTION);

        BusinessObjectWithSelectList boSelectList = BusinessObjectWithSelect.getSelectBusinessObjectData(context, objectIds, sList);

        for(int count=0; count<boSelectList.size();count++)
        {
            BusinessObjectWithSelect boSelect = (BusinessObjectWithSelect)boSelectList.elementAt(count);
            Map map = new Hashtable();
            map.put(DomainObject.SELECT_ID, boSelect.getSelectData(DomainObject.SELECT_ID));
            map.put(DomainObject.SELECT_NAME,boSelect.getSelectData(DomainObject.SELECT_NAME));
            map.put(DomainObject.SELECT_TYPE,boSelect.getSelectData(DomainObject.SELECT_TYPE));
            map.put(DomainObject.SELECT_REVISION,boSelect.getSelectData(DomainObject.SELECT_REVISION));
            map.put(DomainObject.SELECT_DESCRIPTION,boSelect.getSelectData(DomainObject.SELECT_DESCRIPTION));
            partList.add(map);
        }
        return partList;
    }
%>

<%
	MapList resultMapList = null;
	
	try
	{    
		resultMapList = getSelectedItems(context,request,session);
		
	}
	catch(Exception ex)
	{
	}
    String setName = emxGetParameter(request, "setName");
    String startPage = emxGetParameter(request, "startPage");
    String locale  = request.getHeader("Accept-Language");
%>

<script language="JavaScript">

    function checkField(field)
    {
      field.value = trimWhitespace(field.value);
      badCharacters = checkForBadChars(field);
      if(badCharacters.length != 0) 
      {
        alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.ErrorMsg.InvalidInputMsg</framework:i18nScript>"+badCharacters+"\n <framework:i18nScript localize="i18nId">emxIEFDesignCenter.ErrorMsg.InvalidCharMsg</framework:i18nScript> \n" + badChars);
        return false;
      }
      return true;
    }

    function submitform()
    {
        //if(!checkField(document.createForm.txtCollectionName)) 
        //    return;
        if( document.createForm.txtCollectionName.value == "")
        {
          alert("<framework:i18n localize="i18nId">emxIEFDesignCenter.Collection.EnterNewCollectionName</framework:i18n>");
          return;
        }

        document.createForm.submit();
    }

	function cancelCreate()
	{
		parent.window.close();
	}


</script>

<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>
<form name="createForm" method="post"  action="emxInfoNewCollectionProcessing.jsp" target="_parent">

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
//System.out.println("CSRFINJECTION::emxInfoNewCollectionCreate.jsp");
%>


<table border="0" cellpadding="5" cellspacing="2" width="100%" class="formBG">
<tr>
<td class="labelRequired" width="150"><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.Name</framework:i18n></td>
<td class="field" >
<input type="text" name="txtCollectionName" size="30" >
</td>
</tr>
</table>


<!-- Now display the list of Parts that we are adding to the collection -->


<table border="0" width="100%" cellspacing="2" cellpadding="3" >
<tr>
  <th nowrap="nowrap">
     <!--XSSOK-->
     <%=UINavigatorUtil.getI18nString("emxIEFDesignCenter.Common.Name","emxIEFDesignCenterStringResource", locale)%>     
 </th>
  <th nowrap="nowrap">
     <!--XSSOK-->
     <%=UINavigatorUtil.getI18nString("emxIEFDesignCenter.Common.Type","emxIEFDesignCenterStringResource", locale)%> 
  </th>
  <th nowrap="nowrap">
     <!--XSSOK-->
     <%=UINavigatorUtil.getI18nString("emxIEFDesignCenter.Common.Revision","emxIEFDesignCenterStringResource", locale)%>     
  </th>
  <th nowrap="nowrap">
    <!--XSSOK-->
    <%=UINavigatorUtil.getI18nString("emxIEFDesignCenter.Common.Description","emxIEFDesignCenterStringResource", locale)%>     
  </th>

</tr>

<%
if(resultMapList.size()== 0)
{
  %>
  <tr>
  <td colspan="5" style="text-align:center " class="errorMessage"><framework:i18n localize="i18nId">emxIEFDesignCenter.Chooser.NoItemsFound</framework:i18n>
  </td>
  </tr>
  <%
}
  else
{
%>
<!--XSSOK-->
<framework:mapListItr mapList="<%=resultMapList%>" mapName="pcMap">
  <%
  String pcId = (String)pcMap.get(DomainObject.SELECT_ID);
  String pcName = (String)pcMap.get(DomainObject.SELECT_NAME);
  String pcType = (String)pcMap.get(DomainObject.SELECT_TYPE);
  String pcRevision = (String)pcMap.get(DomainObject.SELECT_REVISION);
  String pcDesc = (String)pcMap.get(DomainObject.SELECT_DESCRIPTION);
  String url = "../common/emxTree.jsp?objectId="+pcId;
  %>
  <tr class='<framework:swap id="1"/>'>
    <td>
      <!--img src="../common/images/iconSmallPart.gif" border="0"-->
      <img src= "../common/images/utilSpacer.gif" width="2" height="6" border="0">
      <b><%=pcName%></b>
    </td>
    <td><%=pcType%></td>
    <td><%=pcRevision%></td>
    <td><%=pcDesc%></td>
  </tr>
  <input type="hidden" name="emxTableRowId" value="<%=pcId%>">
</framework:mapListItr>
<input type="hidden" name="mode" value="create">
<input type="hidden" name="setName" value="<xss:encodeForHTMLAttribute><%=setName%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="startPage" value="<xss:encodeForHTMLAttribute><%=startPage%></xss:encodeForHTMLAttribute>">
</table>
</form>

<%
} //End of else
%>
