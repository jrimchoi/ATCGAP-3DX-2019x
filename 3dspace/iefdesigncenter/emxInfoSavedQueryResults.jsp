<%--  emxInfoSavedQueryResults.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoSavedQueryResults.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoSavedQueryResults.jsp $
 * 
 * *****************  Version 15  *****************
 * User: Snehalb      Date: 1/13/03    Time: 1:15p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 14  *****************
 * User: Rahulp       Date: 1/10/03    Time: 2:32p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 13  *****************
 * User: Rahulp       Date: 1/06/03    Time: 3:54p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 12  *****************
 * User: Rahulp       Date: 11/29/02   Time: 4:55p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 11  *****************
 * User: Rahulp       Date: 02/11/28   Time: 20:12
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 10  *****************
 * User: Rahulp       Date: 02/11/28   Time: 17:14
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 9  *****************
 * User: Snehalb      Date: 11/26/02   Time: 1:39p
 * Updated in $/InfoCentral/src/InfoCentral
 * added try-catch block around encode
 * 
 * *****************  Version 8  *****************
 * User: Gauravg      Date: 11/14/02   Time: 7:05p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 7  *****************
 * User: Mallikr      Date: 02/11/12   Time: 18:53
 * Updated in $/InfoCentral/src/InfoCentral
 * internationalization bug fixes
 * 
 * *****************  Version 6  *****************
 * User: Gauravg      Date: 11/07/02   Time: 3:41p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 5  *****************
 * User: Rahulp       Date: 10/31/02   Time: 11:32a
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 4  *****************
 * User: Rahulp       Date: 10/22/02   Time: 3:44p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 3  *****************
 * User: Rahulp       Date: 10/17/02   Time: 5:24p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 1  *****************
 * User: Rahulp       Date: 10/16/02   Time: 4:32p
 * Created in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 3  *****************
 * User: Bhargava     Date: 5/10/02    Time: 2:20p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 1  *****************
 * User: Bhargava     Date: 9/25/02    Time: 2:50p
 * Created in $/InfoCentral/src/InfoCentral
 *
 * ***********************************************
 *
--%>
<%@include file = "emxInfoCentralUtils.inc"%>
<%@ page import = "java.net.*" %>
<%
    try
    {
	    String header = "emxIEFDesignCenter.Header.SearchResults";
        String suiteKey = emxGetParameter(request, "suiteKey");
%>
    <!--XSSOK-->
	<jsp:forward page="emxInfoTable.jsp"><jsp:param name="program" value="IEFFilterQuery:getList"/><jsp:param name="table" value="DSCDefault"/><jsp:param name="header" value="<%=header%>"/>
          <jsp:param name="bottomActionbar" value=""/>
          <jsp:param name="topActionbar" value="DSCSearchResultTopActionBar"/>
          <jsp:param name="pagination" value="10"/>
          <jsp:param name="selection" value="multiple"/>
          <jsp:param name="targetLocation" value="popup"/>                      
        </jsp:forward>

<%
    }
    catch( Exception ex )
    {
        //do nothing
    }
%>

