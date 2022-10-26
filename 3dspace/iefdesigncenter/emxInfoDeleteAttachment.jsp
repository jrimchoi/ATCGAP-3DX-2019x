<%--  emxInfoDeleteAttachment.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoDeleteAttachment.jsp $
  $Revision: 1.3.1.4$
  $Author: ds-hbhatia$


--%>

<%--
 *
 * $History: emxInfoDeleteAttachment.jsp $
 * 
 * *****************  Version 12  *****************
 * User: Rahulp       Date: 12/09/02   Time: 5:37p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 11  *****************
 * User: Mallikr      Date: 11/26/02   Time: 2:19p
 * Updated in $/InfoCentral/src/InfoCentral
 *
 * ***********************************************
 *
--%>

<%@ page import = "matrix.db.*" %>
<%@include file= "emxInfoCentralUtils.inc"%>
<jsp:useBean id="indentedTableBean" class="com.matrixone.apps.framework.ui.UITableIndented" scope="session"/>
<%
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

	//get the request parameters
	String objectId = emxGetParameter(request, "objectId");

	BusinessObject busObject = new BusinessObject(objectId);
	StringList exceptionList = new StringList();
    
	//get the object details
	busObject.open(context);

	String objName = busObject.getName();
	String objType = busObject.getTypeName();
	String objRev  = busObject.getRevision();

	String sDelimiter="||";
	busObject.close(context);
	
	//get the IDs of the selected revisions
		
	for(int index=0; index < selectedObjectInfo.size(); index++)
	{
		String idLevel	    = (String) selectedObjectInfo.get(index);
		HashMap details     = (HashMap) IndexedObjectList.get(idLevel); 
				
		String sFileFormat  = (String)details.get("Format");
		String sFileName    = (String)details.get("FileName");	  
		
		if (sFileFormat != null)
		{
			//form the mql string
			
                        //delete the revision
			try{
				ContextUtil.startTransaction(context, true);
				MqlUtil.mqlCommand(context, "delete bus $1 $2 $3 $4 $5 $6 $7",objType,objName,objRev,"format",sFileFormat,"file",sFileName);
				ContextUtil.commitTransaction(context);
			}
			catch(Exception exception)
			{
				ContextUtil.abortTransaction(context);
				exceptionList.add(exception.toString().trim());
			}
		}//end of if
	} //end of for                   

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
	   parent.location.href=parent.location.href;
</script>   
