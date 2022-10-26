<%--  ECHRemoveDeliverables.jsp   -  This page disconnects Deliverables from a Change Task
   Copyright (c) 199x-2003 MatrixOne, Inc.
   All Rights Reserved.
   This program contains proprietary and trade secret information of MatrixOne,
   Inc.  Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program
   static const char RCSID[] = $Id: /web/enterprisechange/ECHRemoveApplicableItems.jsp 1.2 Tue Dec 23 21:37:15 2008 GMT dmcelhinney Experimental$
--%>

<html>
	<head>
		<title>
		</title>

		<%@include file = "../common/emxNavigatorInclude.inc"%>
		<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
		<%@ page import="com.matrixone.apps.enterprisechange.ChangeTask"%>
	</head>

	<body>
		<%
		String jsTreeID = emxGetParameter(request,"jsTreeID");
		String objectId = emxGetParameter(request,"objectId");
		String suiteKey = emxGetParameter(request,"suiteKey");
		String checkBoxId[] = emxGetParameterValues(request,"emxTableRowId");
		String selectedId = "";
		String relId = "";
		String objId = "";
		String delRelIds[] = new String[checkBoxId.length];
		String delObjIds[] = new String[checkBoxId.length];
		StringList objIdList = new StringList();

		//if this is coming from tablecontrol, have to parse out relId|objectId
		for(int i=0; i<checkBoxId.length ;i++){
			selectedId = checkBoxId[i];
			StringTokenizer strTokens1 = new StringTokenizer(checkBoxId[i],"|");
			if(strTokens1.hasMoreTokens()){
				relId = strTokens1.nextToken();
				objId = strTokens1.nextToken();
			}
			delRelIds[i] = relId;
			delObjIds[i] = objId;
			objIdList.addElement(objId);
		}

		//JPO Call
		String[] init = new String[] {};
		HashMap paramMap = new HashMap();
		paramMap.put("objectId", objectId);
		paramMap.put("delRelIds", delRelIds);
		paramMap.put("delObjIds", objIdList);

		String[] methodargs = JPO.packArgs(paramMap);
		JPO.invoke(context, "emxChangeTask", init, "disconnectDeliverables", methodargs, null);
		%>
		<%--  Added for  IR-057312V6R2011x --%>
		<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
		<%--  End of  IR-057312V6R2011x --%>
		<script language="Javascript">
			var tree = getTopWindow().objDetailsTree;
			var isRootId = false;
			//alert(tree);
			if(tree){
				if(tree.root != null){
					var parentId = tree.root.id;
					var parentName = tree.root.name;
					<%
					int len = delObjIds.length;
					for(int i=0; i<len; i++){
						String RelId = delObjIds[i];
						%>
						var objId = "<%=XSSUtil.encodeForJavaScript(context,RelId)%>";
						tree.getSelectedNode().removeChild(objId);
						if(parentId==objId){
							isRootId = true;
						}
						<%
					}
					%>
				}
			}
			if(isRootId){
				var url =  "../common/emxTree.jsp?AppendParameters=true&objectId=" + parentId + "&suiteKey=<%=XSSUtil.encodeForURL(context,suiteKey)%>";
				var contentFrame = getTopWindow().findFrame(getTopWindow(), "content");
				if(contentFrame){
					contentFrame.location.replace(url);
				}else{
					if(getTopWindow().refreshTablePage){
						getTopWindow().refreshTablePage();
					}else{
						getTopWindow().location.href = getTopWindow().location.href;
					}
				}
			}else{
				parent.location.href = parent.location.href;
			}
		</script>
		<%@include file = "../emxUICommonEndOfPageInclude.inc" %>
	</body>
</html>
