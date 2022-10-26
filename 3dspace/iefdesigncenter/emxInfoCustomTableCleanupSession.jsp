<%--  emxInfoCustomTableCleanupSession.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  
  $Archive: /InfoCentral/src/InfoCentral/emxInfoCustomTableCleanupSession.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$
  
  Name of the File :emxInfoCustomTableCleanupSession.jsp
  
  Description : This jsp page removes table information stored in session objects


--%>

<%--
 *
 * $History: emxInfoCustomTableCleanupSession.jsp $
 * 
 * *****************  Version 3  *****************
 * User: Sameeru      Date: 02/11/15   Time: 5:14p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 2  *****************
 * User: Gauravg      Date: 9/30/02    Time: 5:56p
 * Updated in $/InfoCentral/src/InfoCentral
 *
 *
 ***********************************************
 --%>

<%
    String timeStamp = request.getParameter("timeStamp");

    if (timeStamp != null && session.getAttribute("TableData" + timeStamp) != null)
        session.removeAttribute("TableData" + timeStamp);

    if (session.getAttribute("CurrentIndex" + timeStamp) != null)
        session.removeAttribute("CurrentIndex" + timeStamp);
       
    if (session.getAttribute("ColumnDefinitions" + timeStamp) != null)
        session.removeAttribute("ColumnDefinitions" + timeStamp);
%>
<script language="JavaScript">
window.close();
</script>

