<%--  
	drAddRouteSettingProcess.jsp
	Description - This JSP will connect Route Setting object with route node relationship.
--%>

<%@include file="../emxUICommonAppInclude.inc"%>
<%@include file="../components/emxComponentsCommonUtilAppInclude.inc"%>

<script language="javascript" src="../common/scripts/emxUICore.js"></script>
<script language="JavaScript" src="../common/scripts/emxUIModal.js"></script>
<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>

<%
String selectedObjIds[] = emxGetParameterValues(request,"emxTableRowId");
String mode = emxGetParameter(request,"mode");    
StringBuilder routeSettingIds=new StringBuilder();
boolean onlyTaskSelected = true;
if(null!=selectedObjIds){
	int iTotal=selectedObjIds.length;
	StringList tableRowIds=new StringList();
	for(int count=0;count<iTotal;count++){
		tableRowIds=FrameworkUtil.split(selectedObjIds[count], "|");
		if(count>0){
			routeSettingIds.append("|");
		}		
		routeSettingIds.append((String)tableRowIds.get(0));
    }
}
String routeSettingIDs=routeSettingIds.toString();
HashMap hmRequestMap = UINavigatorUtil.getRequestParameterMap(request);
hmRequestMap.put("RouteSettingIDs", routeSettingIDs);

Boolean bIsRefresh=Boolean.valueOf(false);
if(mode!=null && mode.isEmpty() == false ){
	bIsRefresh = (Boolean) JPO.invoke(context,"drRouteUtility", null,"connectRouteSettingObjects",JPO.packArgs(hmRequestMap), Boolean.class);
}

if(bIsRefresh.booleanValue()){%>
	<script language="Javascript">
		var parentWindow=parent.getTopWindow();
		var detailsDisplay=parentWindow.findFrame(getTopWindow().opener.top,"drV6ToolsTemplateTask3dxtoolsSettings");
		if (typeof window !== 'undefined' && window.closeWindow) {
			if(window.closeWindow()){
				window.closeWindow();
			}else{
				getTopWindow().closeSlideInDialog();
			}
		}else{
			getTopWindow().window.close();
		}
		detailsDisplay.location.href = detailsDisplay.location.href;
	</script>
<%}%>
