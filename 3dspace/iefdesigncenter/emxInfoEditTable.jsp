<%--  emxInfoEditTable.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoEditTable.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoEditTable.jsp $
 * 
 * *****************  Version 20  *****************
 * User: Rahulp       Date: 1/22/03    Time: 5:44p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * ***********************************************
 *
--%>

<%@ page import = "java.net.*" %>
<%@ page import = "com.matrixone.apps.domain.DomainRelationship" %>
<%@ page import = "com.matrixone.apps.domain.DomainObject" %>
<%@include file= "../common/emxNavigatorInclude.inc"%>
<%@include file= "emxInfoTableInclude.inc" %>
<%@include file= "emxInfoTreeTableUtil.inc"%>
<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script> <%--To get findFrame() function and required by emxUIActionbar.js below--%>
<script language="JavaScript" src="../common/scripts/emxUIActionbar.js" type="text/javascript"></script>

<!-- content begins here -->
<html>
<head>
<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIList.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIForm.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIDialog.css" type="text/css" ><!--This is required for the cell (td) back ground colour-->
<link rel="stylesheet" href="../emxUITemp.css" type="text/css">
</head>
<body class="content" >
<%@include file  ="emxInfoCalendarInclude.inc"%>		
<script language="JavaScript">
function findBusNode(parentNode,busId,nodes){
	if (parentNode.hasChildNodes) {
			for (var i=0; i < parentNode.childNodes.length; i++)
		    {
				var node = parentNode.childNodes[i];
				if(node.id==busId){
					nodes[nodes.length]=node;
				}
				findBusNode(node,busId,nodes);
			}
	}
}

function findRelNode(parentNode,relId,nodes){
	if (parentNode.hasChildNodes) {
			for (var i=0; i < parentNode.childNodes.length; i++)
		    {
				var node = parentNode.childNodes[i];
				if(node.relId==relId ){
					nodes[nodes.length]=node;
				}
				findRelNode(node,relId,nodes);
			}
	}
}

function loadNode(parentNode,nodeId,nodeName){

	if (parentNode.hasChildNodes) {
			for (var i=0; i < parentNode.childNodes.length; i++)
		    {
	
				var node = parentNode.childNodes[i];
				if(node.nodeID==nodeId){
					node.name=nodeName;
					return ;
				}
				else
				   loadNode(node,nodeId,nodeName);

		  }
     }
}

</script>
<%
   String busId=emxGetParameter(request,"busId");
   String relId =emxGetParameter(request,"relId");
   String isDescription =emxGetParameter(request,"isDescription");   
   if(isDescription!=null)
   isDescription=isDescription.trim();
   String reqBusId=busId.replace('.','a');
   String attributeName =emxGetParameter(request,busId+"name");
   String attributeValue =emxGetParameter(request,reqBusId+attributeName);
   if(attributeValue!=null)
     attributeValue = attributeValue.trim();
   if(attributeValue==null || attributeValue.equals(""))
   attributeValue =emxGetParameter(request,reqBusId+attributeName+"_combo");
   if(attributeValue==null)
   attributeValue="";
   String oldAttributeValue  = emxGetParameter(request,"oldAttributeValue").trim();
   if(!attributeValue.equals(oldAttributeValue)){
   if("dateFieldTimeStamp".equals(attributeValue))
	attributeValue=emxGetParameter(request,reqBusId+attributeName+"_date");
   String  isBusAttri = emxGetParameter(request,"isBusAttri");
   String nagivator  = emxGetParameter(request,"navigator");
   String tableName =emxGetParameter(request,"tableName");
   // Function FUN080585 : Removal of Cue, Tips and Views
   Attribute attribute = null;
   boolean  found = "true".equals(isBusAttri);
   String exceptionMsg ="";
   DomainObject  obj =  new DomainObject(busId);
   try{
	if(attributeName.equals("description") && "true".equals(isDescription)){
	 isBusAttri="true";
     obj.open(context,true);
     obj.setDescription(attributeValue);
	 obj.update(context);
	}
	else{
    if(busId!=null && !busId.equals("null") && found ){	
	  obj.setAttributeValue(context,attributeName, attributeValue);
	}
    if(relId!=null && !relId.equals("null")&&!found){
         DomainRelationship.setAttributeValue(context,relId,attributeName,attributeValue);		
    }
	}
	}
	catch(Exception e)
	{
      exceptionMsg = e.toString().trim();
	  exceptionMsg = exceptionMsg.replace('\n',' ');
	 }
	 finally{
      obj.close(context);
	 }
%>
<script language="JavaScript">
<%
  if(!exceptionMsg.equals("")){
%>
 //XSSOK
 alert("<%=exceptionMsg%>");
<%
  }else{
  if("true".equals(nagivator)){
    Vector vectorColList = null;
	//if null, user may have no tables defined, or tables defined with none selected
	try
	{
		vectorColList = openTable(context, tableName);
	}
	catch(MatrixException ex)
	{
		vectorColList = new Vector();
	}
	
	// Function FUN080585 : Removal of Cue, Tips and Views

	String sTableValues = "<td ><img src=images/utilSpace.gif width=6 height=15 >&nbsp;</td>"+getNavigatorTableData(busId,relId,tableName,context,vectorColList,request);
	String rootValue = "<td ><img src=images/utilSpace.gif width=6 height=15 >&nbsp;</td>"+getNavigatorTableData(busId,null,tableName,context,vectorColList, request);
%>
var table = parent.window.opener.table;
var tree  = parent.window.opener.tree;
if(table!=null && tree!=null){
var nodes = new Array;
//XSSOK
var relID = '<%=relId%>';
//XSSOK
var busID = '<%=busId%>';
//XSSOK
var isbus ="<%=isBusAttri%>";
if(isbus=="true"){
if(tree.root.id==busID){
//XSSOK
table.root.name="<%=rootValue%>";
}
findBusNode(tree.root,busID,nodes);
}
else{
findRelNode(tree.root,relID,nodes);
}
//alert(nodes.length);
for( var i =0; i<nodes.length; i++){
var nodeId = nodes[i].nodeID;
//XSSOK
loadNode(table.root,nodeId,"<%=sTableValues%>");
}
table.refresh();
}
<%
}
else{
%>
   var sTargetFrame = findFrame(parent.window.opener.parent, "listDisplay");
   if(sTargetFrame){
	   if(parent.window.opener){
		 parent.window.opener.document.emxTableForm.action="emxInfoTableWSBody.jsp";
		 parent.window.opener.document.emxTableForm.target="listDisplay";
		 parent.window.opener.document.emxTableForm.page.value='current';
		 parent.window.opener.document.emxTableForm.submit();
   }
}
<%
}
}
%>
</script>
<%
}
%>
<script language="JavaScript">
   parent.window.close();
</script>







