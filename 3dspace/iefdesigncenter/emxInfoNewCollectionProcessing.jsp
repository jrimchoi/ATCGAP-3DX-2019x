<%--  emxInfoNewCollectionProcessing.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoNewCollectionProcessing.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxInfoNewCollectionProcessing.jsp $
 * 
 * *****************  Version 6  *****************
 * User: Rahulp       Date: 1/15/03    Time: 4:03p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 5  *****************
 * User: Gauravg      Date: 11/27/02   Time: 5:10p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 4  *****************
 * User: Snehalb      Date: 11/25/02   Time: 3:42p
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
 * ***********************************************
 *
--%>

<%@include file="emxInfoCentralUtils.inc" %>
<%@ page import="java.net.*"%>

<%
    // request parameters
    String[] objectId = emxGetParameterValues(request, "emxTableRowId");
    String setName = emxGetParameter(request, "setName");
    String mode = emxGetParameter(request, "mode");
    String sCollectionName = emxGetParameter(request, "txtCollectionName");
    String startPage = emxGetParameter(request, "startPage");

try
{
    if(mode.equals("edit"))
    {
        //sCollectionName = com.matrixone.apps.domain.util.XSSUtil.decodeFromURL(sCollectionName);
    }

    if(mode.equals("create"))
    {
        // check to see if set name exists, if yes display an error message
        SetItr setItr = new SetItr(matrix.db.Set.getSets( context, true));
        while(setItr.next())
        {
            matrix.db.Set setObj = setItr.obj();
            if (setItr.obj().getName().equals(sCollectionName))
            {
                String sMessage = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.ErrorMsg.CollectionExists", request.getHeader("Accept-Language"));
             //   session.putValue("error.message", sMessage);
                for(int index=0; index<objectId.length; index++)
                {
                    request.setAttribute("emxTableRowId", objectId[index]);
                }
                %>
				<!--XSSOK-->
                <jsp:forward page ="emxInfoNewCollectionDialogFS.jsp"><jsp:param name="setName" value="<xss:encodeForHTMLAttribute><%=setName%></xss:encodeForHTMLAttribute>" /><jsp:param name="ErrorMsg" value="<%=sMessage%>" />
                </jsp:forward>
                <%
            }
        }
    }

    matrix.db.Set set = new matrix.db.Set(sCollectionName);
    set.open(context);
    //    set.getBusinessObjects(context);
    if(mode.equals("edit"))
    {
        BusinessObjectList bolist = set.getBusinessObjects(context);
        set.appendList(bolist);
        set.setBusinessObjects(context);
    }

    for (int i= 0; i < objectId.length; i++)
    {
        BusinessObject bo = new matrix.db.BusinessObject(objectId[i]);
        set.add(bo);
    }
    set.setBusinessObjects(context);
    set.close(context);

}
catch (MatrixException mex)
{

}
%>

<script language=Javascript>
    <%
      if(startPage == null || !(startPage.equals("search"))) {
      %>
        top.opener.top.modalDialog.releaseMouse();
    <%}%>
  top.close();
</script>
