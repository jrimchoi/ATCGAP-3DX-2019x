<%--  
	drAddRouteSettingPreProcess.jsp
	Description - This JSP will call search or create form JSP and pass the select object ids.
--%>

<%@include file="../emxUICommonAppInclude.inc"%>
<%@include file="../components/emxComponentsCommonUtilAppInclude.inc"%>

<script language="javascript" src="../common/scripts/emxUICore.js"></script>
<script language="JavaScript" src="../common/scripts/emxUIModal.js"></script>
<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>

<%
String mode = emxGetParameter(request,"mode"); 
String selectedObjIds[] = emxGetParameterValues(request,"emxTableRowId");
String templateId = emxGetParameter(request,"objectId");    
StringBuilder routeNodeIds=new StringBuilder();
boolean onlyTaskSelected = true;
if(null!=selectedObjIds){
	int iTotal=selectedObjIds.length;
	StringList tableRowIds=new StringList();
	for(int count=0;count<iTotal;count++){
		tableRowIds=FrameworkUtil.split(selectedObjIds[count], "|");
		if(tableRowIds.size()>3){
			onlyTaskSelected = false ;
			break;
		}
		if(count>0){
			routeNodeIds.append("|");
		}
		routeNodeIds.append((String)tableRowIds.get(0));
    }
}	

if(onlyTaskSelected){
	String routeNodeIDs=routeNodeIds.toString();
	String contentURL = "";
	if("create".equalsIgnoreCase(mode)){
		contentURL="../common/emxCreate.jsp?vault=3dxtools&type=type_DRLToolsRouteSetting&form=drV6ToolsDRLToolsRouteSetting&typeChooser=true&objectId="+templateId+"&relId="+routeNodeIDs;
		contentURL+="&postProcessJPO=drRouteUtility:processRouteTemplateTask3dxtoolsSettings";
	}else if("connect".equalsIgnoreCase(mode)){
		contentURL="../common/emxFullSearch.jsp?selection=multiple&mode=connect&submitLabel=Connect&field=TYPES=type_DRLToolsRouteSetting&table=AEFGeneralSearchResults&relName=relationship_DRLToolsRouteSettingRelationship&excludeOIDprogram=drRouteUtility:excludeConnectedRouteSettingObjects&queryType1=Real Time&objectId="+templateId;
		contentURL+="&submitURL=../drV6Tools/drAddRouteSettingProcess.jsp?objectId="+templateId;
	}
	%>
	
	<html>
	<head></head>
	<body>
		<form name="addRouteSettingForm" method="post">
			<input type="hidden" name="selectedObjectIds" id="selectedObjectIds" value="" />
			<input type="hidden" name="objectId" id="objectId" value="" />
			<input type="hidden" name="parentWindow" id="parentWindow" value="" />
			
			<script language="Javascript">
				showModalDialog("../common/emxBlank.jsp","300","300","true"); 	          
				var objWindow =  getTopWindow().modalDialog.contentWindow;
				var formObj = document.forms['addRouteSettingForm'];
			    formObj.target=objWindow.name;
			    formObj.selectedObjectIds.value="<%=routeNodeIDs%>";
		        formObj.objectId.value = "<%=templateId%>";
		        formObj.parentWindow.value =objWindow.name;
				formObj.action="<%=contentURL%>";
				formObj.submit();
			</script>
		</form>
	</body>
	</html>
<%}else {%>
	<script language="Javascript">
		alert("Please select only tasks.");
	</script>
<%}%>