<%--  emxInfoPeopleSearch.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%-- emxInfoPeopleSearch.jsp - for people search

  $Archive: /InfoCentral/src/infocentral/emxInfoPeopleSearch.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoPeopleSearch.jsp $
 * 
 * *****************  Version 8  *****************
 * User: Shashikantk  Date: 1/13/03    Time: 8:54p
 * Updated in $/InfoCentral/src/infocentral
 * Removed "Decode" to work in Japanees
 * 
 * *****************  Version 7  *****************
 * User: Shashikantk  Date: 11/29/02   Time: 7:38p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 6  *****************
 * User: Shashikantk  Date: 11/29/02   Time: 7:37p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * ***********************************************
 *
--%>

<%--
	//This JSP is getting called when user clicks on the bottom action bar of user search results page. 
	//The bottom action bar displays "select" link. 
	//The opener of this window is that page from where the user search button is clicked. 
	//There the field for the user input gets populated
	
--%>
<%@include file="emxInfoCentralUtils.inc"%> 			<%--For context, request wrapper methods, i18n methods--%>
<%
	String sUser	= emxGetParameter(request, "emxTableRowId");
%>

<script language="Javascript">
	top.window.opener.txtUserField.value = "<%=XSSUtil.encodeForHTML(context,sUser)%>";
	top.window.close();
</script>
