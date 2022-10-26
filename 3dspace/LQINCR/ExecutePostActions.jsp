<%@page import="matrix.util.StringList"%>
<%@include file = "../emxUICommonAppInclude.inc"%>
<%@page import="com.dassault_systemes.enovia.lsa.Helper, com.dassault_systemes.enovia.lsa.ncr.NCRException"%>

<%!
	private String getI18NString(Context context, String key) throws NCRException {
		try {
			return XSSUtil.encodeForJavaScript(context, Helper.getI18NString(context, Helper.StringResource.NCR, key));
		} catch (Exception e) {
			throw new NCRException(e);
		}
	}
%> 

<script type="text/javascript" language="javascript">

function actionRefreshNCR(){
	var contentFrame = findFrame(getTopWindow(), "detailsDisplay");
	if(contentFrame==null||contentFrame==undefined)
	{
		contentFrame = findFrame(getTopWindow(), "content");
	}
	contentFrame.location.href = contentFrame.location.href;
}

function actionShowAlertMessage(errorMessage)
{
	alert(errorMessage);
}

function actionRefreshMyNCRWorkQueue() {
	getTopWindow().refreshTablePage();
}

function alertForTransferComplaintOwnership() {
	var message = "<%=getI18NString(context, "LQINCR.NCR.TransferComplaintOwnership")%>";	//XSSOK
	alert(message);
    getTopWindow().window.closeWindow();
}

function alertForTransferOwnershipUnassignedFilter() {
	var message = "<%=getI18NString(context, "LQINCR.NCR.FirstAccept")%>";	//XSSOK
    alert(message);
    getTopWindow().window.closeWindow();
}

function alertForTransferOwnershipNotOwner() {
	var message = "<%=getI18NString(context, "LQINCR.NCR.NotOwner")%>";	//XSSOK
    alert(message);
    getTopWindow().window.closeWindow();
}

function actionRefreshProductControl(){
	var contentFrame = findFrame(getTopWindow(), "detailsDisplay");
	if(contentFrame==null||contentFrame==undefined)
	{
		contentFrame = findFrame(getTopWindow(), "content");
	}
	contentFrame.location.href = contentFrame.location.href;
}

function actionRefreshProductControlSB() {
	getTopWindow().refreshTablePage();
}

function alertForWrongTypeSelection() {
	var message = "<%=getI18NString(context, "LQINCR.ProductControl.CanNotSelect")%>";	//XSSOK
    alert(message);
}

function showHTMLReport(strHTML) {
	var html = document.documentElement;
	var newHead = document.createElement("head");
	var newTitle = document.createElement("title");
	newTitle.appendChild(document.createTextNode("Summary Report"));
	html.replaceChild(newHead, html.childNodes[0]);
	window.document.write(strHTML);
}

function getRangeFormPQCNCRCreateFieldProduct(strSearch){
	var parameters = new Object();
	parameters.field="TYPES="+strSearch;
	parameters.table="AEFGeneralSearchResults";
	parameters.submitAction="refreshCaller";
	parameters.selection="multiple";
	parameters.showInitialResults="true";
	parameters.submitURL="../common/AEFSearchUtil.jsp";	
	modifyAndSubmitForwardForm(parameters, null,"../common/emxFullSearch.jsp");
}

function getRangeFormPQCNCRCreateFieldProductError(msg){
	alert(msg);
	getTopWindow().getTopWindow().closeWindow();
}

function actionCommandPQCNCRImpactedItemsAdd(strSearch, objectId){
	var parameters = new Object();
	parameters.field="TYPES="+strSearch;
	parameters.table="AEFGeneralSearchResults";
	parameters.submitAction="refreshCaller";
	parameters.selection="multiple";
	parameters.objectId=objectId;
	parameters.parentOID=objectId;
	parameters.suiteKey="LQINCR";
	parameters.excludeOIDprogram="com.dassault_systemes.enovia.lsa.ncr.services.ui.NCRProductControl:getCommandPQCNCRImpactedItemsAddExclude";
	parameters.submitURL="../LSA/Execute.jsp?executeAction=com.dassault_systemes.enovia.lsa.ncr.services.ui.NCRProductControl:actionCommandPQCNCRImpactedItemsAdd&suiteKey=LQINCR";	
	showSearchDialog(parameters);
}
function refreshOpenerWindow() {
    window.parent.location.href = window.parent.location.href;
}
function refreshOpenerWindowWithMessage(msg) {
	alert(msg);
    window.parent.location.href = window.parent.location.href;
}
function refreshActionCommandPQCNCRImpactedItemsAdd2(){
	debugger;
	var frameWindow = getTopWindow();
	if(getTopWindow().getWindowOpener() && typeof getTopWindow().getWindowOpener()['getTopWindow'] === 'function')
	{
		frameWindow = getTopWindow().getWindowOpener().getTopWindow();
	}
	var dialog  = findFrame(frameWindow, "PQCNCRImpactedItems");
	if(dialog == null || dialog == undefined)
	{
		dialog  = findFrame(frameWindow, "detailsDisplay");
	}
	if(dialog == null || dialog == undefined)
	{
		dialog  = findFrame(frameWindow, "content");
	}
	dialog.location.href = dialog.location.href;
    getTopWindow().getTopWindow().closeWindow();
}

function refreshParentOpenerWindow(){
	getTopWindow().getWindowOpener().location.href = getTopWindow().getWindowOpener().location.href;
	getTopWindow().getTopWindow().closeWindow();
}

</script>
