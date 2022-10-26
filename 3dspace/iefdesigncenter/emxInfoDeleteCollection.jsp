<%--  emxInfoDeleteCollection.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoDeleteCollection.jsp $
  $Revision: 1.3.1.4$
  $Author: ds-hbhatia$



<%--
 *
 * $History: emxInfoDeleteCollection.jsp $
 * 
 * *****************  Version 12  *****************
 * User: Rahulp       Date: 1/15/03    Time: 4:03p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 11  *****************
 * User: Gauravg      Date: 12/11/02   Time: 8:55p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 10  *****************
 * User: Gauravg      Date: 12/11/02   Time: 5:55p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 9  *****************
 * User: Gauravg      Date: 11/29/02   Time: 9:59a
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 8  *****************
 * User: Gauravg      Date: 11/28/02   Time: 9:34p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 7  *****************
 * User: Gauravg      Date: 11/27/02   Time: 9:12p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 6  *****************
 * User: Gauravg      Date: 11/27/02   Time: 5:12p
 * Updated in $/InfoCentral/src/infocentral
 * Debugging
 * 
 * *****************  Version 5  *****************
 * User: Mallikr      Date: 11/26/02   Time: 2:27p
 * Updated in $/InfoCentral/src/InfoCentral
 * code cleanup
 * 
 * *****************  Version 4  *****************
 *
--%>

<%@include file= "emxInfoCentralUtils.inc"%>
<jsp:useBean id="indentedTableBean" class="com.matrixone.apps.framework.ui.UITableIndented" scope="session"/>
<%
	//get the selected collection names from the request
	String timeStamp   = emxGetParameter(request, "timeStamp");
	HashMap requestMap = (HashMap) indentedTableBean.getTableData(timeStamp);
	
	MapList ObjectList		= (MapList) requestMap.get("ObjectList");
    TreeMap IndexedObjectList	= (TreeMap) requestMap.get("IndexedObjectList");
	String[] objectIds		= emxGetParameterValues(request, "emxTableRowId");
	
	ArrayList selectedObjectInfo    = new ArrayList(objectIds.length);
	ArrayList selectedObjectRowId   = new ArrayList(objectIds.length);

	for(int i=0; i < objectIds.length; i++)
	{
		String objectRowInfo = 	 objectIds[i];
		selectedObjectRowId.add(objectRowInfo.substring(objectRowInfo.lastIndexOf("|") + 1 ));
	} 
	
	for(int i=0; i < ObjectList.size(); i++)
	{
		HashMap objList = (HashMap)ObjectList.get(i);
		String rowInfo  = (String)objList.get("id[level]");
		
		if(selectedObjectRowId.contains(rowInfo))
			selectedObjectInfo.add(rowInfo);
	}	

	String setName[] = new String[selectedObjectInfo.size()];

	for(int index=0; index < selectedObjectInfo.size(); index++)
	{
		String idLevel	    = (String) selectedObjectInfo.get(index);
		HashMap details     = (HashMap) IndexedObjectList.get(idLevel); 
		setName[index]		=  (String) details.get("CollectionName");
	}

	String sRedirectPage = null;
    try
    {     
    	sRedirectPage = Framework.getCurrentPage(session);
		// remove collection objects
        if (setName.length>0) 
        {
            matrix.db.Set delSet  = null;
            for (int i=0;i<setName.length;i++) 
            {
                delSet = new matrix.db.Set(setName[i]);
                delSet.open(context);
                delSet.remove(context);
                delSet.close(context);
            }
        }
    }
    catch(Exception e)
    {
      String sError = e.getMessage();
	  sError = sError.replace('\n',' ');
	  sError = sError.replace('\r',' ');
	  session.setAttribute("error.message", sError);
	
%>
	<script language="JavaScript">
	    //XSSOK
	    alert("<%=sError%>");
		parent.window.close();
	</script>
<%	
    }
%>
	<script language="JavaScript">
		parent.location.href = parent.location.href;
	</script>
