<%--  SLWFolderMigrationSelector.jsp

   Copyright Dassault Systemes, 1992-2007. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>

<%@ include file="../MCADTopInclude.inc"%>
<%@ include file="../MCADTopErrorInclude.inc"%>

<%@ page import="com.matrixone.apps.domain.util.*"%>
<%
	String currentObjectId	= Request.getParameter(request,"objectId");
    String folderId	        = Request.getParameter(request,"folderObjectId");
    String timeStamp        = (String) emxGetParameter(request,"timeStamp");
%>

<%!
	private void getObjectStatusMap(MapList objectDataList, Map<String,String> objectIdStatusMap)
	{
		Iterator iter = objectDataList.iterator();
		while(iter.hasNext())
		{
			HashMap objectData = (HashMap)iter.next();
			String id          = (String)objectData.get("id");
			String status      = (String)objectData.get("status");

			if(id != null && status != null && !objectIdStatusMap.containsKey(id))
			{
				objectIdStatusMap.put(id, status);

				MapList childObjectDataList = (MapList)objectData.get("children");

				if(childObjectDataList != null)
				{
					getObjectStatusMap(childObjectDataList, objectIdStatusMap);
				}
			}
		}
	}
%>
<jsp:useBean id="indentedTableBean" class="com.matrixone.apps.framework.ui.UITableIndented" scope="session" />
<%
    HashMap tableDataMap   = (HashMap)indentedTableBean.getTableData(timeStamp);
    MapList objectDataList = (MapList)tableDataMap.get("ObjectList");

    StringBuilder idsToAdd = new StringBuilder();
    String errorMsg        = "";

    try
	{
		MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData)session.getAttribute("MCADIntegrationSessionDataObject");

		if(integSessionData != null)
		{
			Context context = integSessionData.getClonedContext(session);
	
			Map<String, String> objectIdStatusMap = new HashMap<String, String>();
			getObjectStatusMap(objectDataList, objectIdStatusMap);
			//System.out.println("objectStatusMap: " + objectIdStatusMap);

			java.util.Set<String> idsSet = objectIdStatusMap.keySet();
			Iterator<String> iter = idsSet.iterator();
			while(iter.hasNext())
			{
				String id     = iter.next();
				String status = objectIdStatusMap.get(id);
				
				if(status.equals("selectable"))
				{
					idsToAdd.append(id).append("|");
				}
				else if(status.equals("error"))
				{
					errorMsg = "Cannot proceed as some items are invalid for addition to folder. Please review all errors in the Status column.";
					break;
				}
			}
		}
		else
		{
			String acceptLanguage							= request.getHeader("Accept-Language");
			MCADServerResourceBundle serverResourceBundle	= new MCADServerResourceBundle(acceptLanguage);

			String message	= serverResourceBundle.getString("mcadIntegration.Server.Message.ServerFailedToRespondSessionTimedOut");
		}
	}
    catch(Exception exception)
	{
		System.out.println("exception: " + exception.getMessage());
		exception.printStackTrace();
	}
%>

<html>
<head>
<script type="text/javascript">
	function validateAndSubmit()
    {
		// var isAllSelected = parent.document.getElementsByName('chkList')[0].checked;
		// if(isAllSelected==false)
		// {
		// 	alert("Please select all before submit");
		// }
		// else
		// {
		// 	document.forms.DoAdd.submit();
		// }
		if('<%=errorMsg%>'=="")
		{
			document.forms.DoAdd.submit();
		}
		else
		{
			alert('<%=errorMsg%>');
		}
	}
    </script>
</head>
<body onload='validateAndSubmit()'>
<form name="DoAdd" action="./SLWDoFolderAddition.jsp" method="post">
<input type="hidden" name="folderId" value='<%=folderId%>' />
<input type="hidden" name="idsToAdd" value='<%=idsToAdd.toString()%>' />
</form>
</body>
</html>
