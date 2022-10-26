<%--  emxInfoDeleteQuery.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoDeleteQuery.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxInfoDeleteQuery.jsp $
 * 
 * *****************  Version 12  *****************
 * User: Snehalb      Date: 1/13/03    Time: 1:15p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 11  *****************
 * User: Rahulp       Date: 12/09/02   Time: 5:37p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 10  *****************
 * User: Rahulp       Date: 02/11/28   Time: 17:14
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 9  *****************
 * User: Rahulp       Date: 02/11/27   Time: 13:37
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 8  *****************
 * User: Rahulp       Date: 02/11/27   Time: 12:58
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 7  *****************
 * User: Gauravg      Date: 11/22/02   Time: 6:18p
 * Updated in $/InfoCentral/src/InfoCentral
 * Removing error no 400
 * 
 * *****************  Version 6  *****************
 * User: Sameeru      Date: 02/11/15   Time: 5:21p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 5  *****************
 * User: Rahulp       Date: 11/13/02   Time: 2:52p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 4  *****************
 * User: Gauravg      Date: 11/07/02   Time: 3:41p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 3  *****************
 * User: Rahulp       Date: 11/06/02   Time: 5:14p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 2  *****************
 * User: Mallikr      Date: 10/31/02   Time: 7:52p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 1  *****************
 * User: Bhargava     Date: 10/31/02   Time: 7:47p
 * Created in $/InfoCentral/src/InfoCentral
 * adding in
 *
 * ***********************************************
 *
--%>

<%@include file = "emxInfoCentralUtils.inc"%>
<%
 String queryName = emxGetParameter(request, "emxTableRowId");
 StringList exceptionList = new StringList();
// exceptionList.add(queryName);
 String suiteKey = emxGetParameter(request, "suiteKey");
 
 if(queryName != null && !"".equals(queryName) && !"null".equals(queryName) && !".finder".equals(queryName))
 {
 try
 {
	matrix.db.Query query = null;
	query = new matrix.db.Query(queryName);
	query.open(context);
	query.remove(context);
	query.close(context);
}
catch(Exception e)
{
  exceptionList.add(e.toString().trim());
}
}
if(".finder".equals(queryName)){
 String errMsg= FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Error.DeleteQuery.Finder", request.getHeader("Accept-Language"));
 exceptionList.add(errMsg);
}

for (int k =0 ;k<exceptionList.size();k++)
{
	 String exceptionMsg=((String)(exceptionList.get(k))).trim();
	 exceptionMsg = exceptionMsg.replace('\n',' ');
%>
   <script language="JavaScript">
                //XSSOK
				alert("<%=exceptionMsg%>");
	</script>		
<%
}
%>
<script language="JavaScript">
	   //parent.location.href=parent.location.href;
           // DSCINC 1200
	   parent.frames[1].document.location.href = "../iefdesigncenter/DSCSearchManage.jsp";
	   // DSCINC 1200
</script>  
