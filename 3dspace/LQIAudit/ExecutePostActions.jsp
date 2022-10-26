<script type="text/javascript" language="javascript">

function showErrorMessage(message) {   
	alert(message);
	window.parent.location.href = window.parent.location.href; 
}

function refreshOpenerWindow()
{
	window.parent.location.href = window.parent.location.href;	
}


function refreshAuditReplyPropertiesPageAndHeader(){
	getTopWindow().RefreshHeader();
	var auditReplyFrame = findFrame(getTopWindow(), "QICAUDReplyProperties");
	auditReplyFrame.location.href = auditReplyFrame.location.href;
}

function refreshOpener() { 	
    getTopWindow().getWindowOpener().location.href = getTopWindow().getWindowOpener().location.href;
    getTopWindow().window.closeWindow();
}

function refreshTablePage() {
	getTopWindow().refreshTablePage();
}

function showObjectPropertiesPage(objectId){
	getTopWindow().location.href = "../common/emxTree.jsp?objectId=" +objectId;
}

function showErrorAndcloseTopWindow(message){
	 alert(message);
	 getTopWindow().window.closeWindow();
}

function showErrorMessageForRemovePersonFromAudit(message){
	 alert(message);
}

function showErrorAndRefreshOpener(message){
	 alert(message);
	 getTopWindow().getWindowOpener().location.href = getTopWindow().getWindowOpener().location.href;
	 getTopWindow().window.closeWindow();
}

function actionAddLeadAuditor(auditId) {
	var strURL = "../common/emxFullSearch.jsp?showInitialResults=true&table=QICAUDAuditPersonChooserDetails&selection=single&form=QICAUDAuditPersonChooserForm&submitURL=../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.audit.services.ui.AuditPeople:actionAddLeadAuditorToAudit&field=TYPES=type_Person:CURRENT=policy_Person.state_Active&memberType=Person&HelpMarker=emxhelpsearch&suiteKey=LQIAudit&objectId="+auditId;
	showModalDialog(strURL);
}

function actionRefreshAuditMemberFrameAndCloseTopWindow() {	
	 var auditMemberFrame = findFrame(getTopWindow().getWindowOpener().parent.parent,'detailsDisplay');
	 getTopWindow().closeWindow();
	 auditMemberFrame.location.href = auditMemberFrame.location.href;	
	}
	
function showErrorMsgAndRefreshAuditMemberFrame(errorMsg){
	 alert(errorMsg);
	 var auditMemberFrame = findFrame(window.parent.parent,'detailsDisplay');
	 auditMemberFrame.location.href = auditMemberFrame.location.href;	
}

function refreshAuditedItemsSBAfterAddingItem() {
	var auditedItemsFrame = findFrame(getTopWindow().getWindowOpener().getTopWindow(), "QICAUDCategoryAuditedItems");
    if(auditedItemsFrame==null || auditedItemsFrame =='undefined'){
    	auditedItemsFrame= findFrame(getTopWindow().getWindowOpener().getTopWindow(), "detailsDisplay");
    }
    if(auditedItemsFrame.editableTable){
    	auditedItemsFrame.editableTable.loadData();
    	auditedItemsFrame.RefreshTableHeaders();
    	auditedItemsFrame.rebuildView();
    }else{
    	auditedItemsFrame.location.href = auditedItemsFrame.location.href;
    }
    getTopWindow().closeWindow();
}

function refreshAuditedItemsSBAfterRemovingItem() {
    var auditedItemsFrame = findFrame(getTopWindow(), "QICAUDCategoryAuditedItems");
    if(auditedItemsFrame==null || auditedItemsFrame =='undefined'){
    	auditedItemsFrame= findFrame(getTopWindow(), "detailsDisplay");
	   }
    auditedItemsFrame.location.href = auditedItemsFrame.location.href;
}

function showSearchPageForAuditedItems(parentId) {
	var submitURL = encodeURI("../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.audit.services.ui.AuditAuditedItems:actionAddAuditedItems&suiteKey=LQIAudit");
   	var strURL = "../common/emxFullSearch.jsp?excludeOIDprogram=com.dassault_systemes.enovia.lsa.audit.services.ui.AuditAuditedItems:getAuditedItemsToExclude&table=AEFGeneralSearchResults&selection=multiple&relName=relationship_AuditedItems&hideToolbar=true&hideHeader=true&direction=from&addPreCondParam=false&showInitialResults=true&parentId="+parentId+"&submitAction=refreshCaller&submitURL="+submitURL;
    showModalDialog(strURL, 600, 700,true);
}

function showSearchPageForAuditRequests(parentId){
	var submitURL = encodeURI("../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.audit.services.ui.AuditAudit:actionAddAuditRequests&suiteKey=LQIAudit");
   	var strURL = "../common/emxFullSearch.jsp?field=TYPES=type_AuditRequest:CURRENT=policy_Request.state_ResultsReady&table=AEFGeneralSearchResults&excludeOIDprogram=com.dassault_systemes.enovia.lsa.audit.services.ui.AuditAudit:getExcludedAuditRequestIds&selection=multiple&hideToolbar=true&hideHeader=true&direction=from&showInitialResults=true&parentId="+parentId+"&submitAction=refreshCaller&submitURL="+submitURL;
    showModalDialog(strURL, 600, 700,true);
}

function createAuditRequestFromAuditRequestTemplate() {	
	var submitURL = "../common/emxFullSearch.jsp?field=TYPES=type_AuditRequestTemplate:CURRENT=policy_AuditRequestTemplate.state_Active&selection=single&table=AEFGeneralSearchResults&hideToolbar=true&hideHeader=true&submitAction=refreshCaller&showInitialResults=true&submitURL=../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.audit.services.ui.AuditRequest:actionCreateAuditRequestFromAuditRequestTemplate&suiteKey=LQIAudit";
	showModalDialog(submitURL, 600, 700,true);
}

function connectAuditToAuditRequest(AuditRequestIds) {	
	var submitURL = "../common/emxFullSearch.jsp?field=TYPES=type_Audit:CURRENT=policy_Audit.state_Plan,policy_Audit.state_Active,policy_Audit.state_Finalization,policy_Audit.state_Resolution&selection=single&table=AEFGeneralSearchResults&hideToolbar=true&hideHeader=true&submitAction=refreshCaller&showInitialResults=true&submitURL=../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.audit.services.ui.AuditRequest:actionAssociateAuditToAuditRequest&AuditRequestIds="+AuditRequestIds+"&suiteKey=LQIAudit";
	showModalDialog(submitURL, 600, 700,true);
}

function connectAuditToContextAuditRequest(AuditRequestIds) {	
	var submitURL = "../common/emxFullSearch.jsp?field=TYPES=type_Audit:CURRENT=policy_Audit.state_Plan,policy_Audit.state_Active,policy_Audit.state_Finalization,policy_Audit.state_Resolution&selection=single&table=AEFGeneralSearchResults&hideToolbar=true&hideHeader=true&submitAction=refreshCaller&showInitialResults=true&submitURL=../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.audit.services.ui.AuditRequest:actionAssociateAuditToContextAuditRequestObject&AuditRequestIds="+AuditRequestIds+"&suiteKey=LQIAudit";
	showModalDialog(submitURL, 600, 700,true);
}

function refreshAuditRequestsSummaryTable() {
    var auditedItemsFrame = findFrame(getTopWindow().getWindowOpener().getTopWindow(), "QICAUDAuditRequests");
    if(auditedItemsFrame==null || auditedItemsFrame =='undefined'){
    	auditedItemsFrame= findFrame(getTopWindow().getWindowOpener().getTopWindow(), "detailsDisplay");
    }
    if(auditedItemsFrame.editableTable){
    	auditedItemsFrame.editableTable.loadData();
    	auditedItemsFrame.RefreshTableHeaders();
    	auditedItemsFrame.rebuildView();
  	}
	getTopWindow().closeWindow();	
}

function refreshAuditRequestsPropertiesForm() {
    var auditedItemsFrame = findFrame(getTopWindow().getWindowOpener().getTopWindow(), "QICAUDRequestProperties");
    if(auditedItemsFrame==null || auditedItemsFrame =='undefined'){
    	auditedItemsFrame= findFrame(getTopWindow().getWindowOpener().getTopWindow(), "detailsDisplay");
    }
    auditedItemsFrame.location.href = auditedItemsFrame.location.href;
	getTopWindow().closeWindow();		
}

function refreshAuditRequestPageAfterAdding() {
    var auditedItemsFrame = findFrame(getTopWindow().getWindowOpener().getTopWindow(), "QICAUDConnectedRequests");
    if(auditedItemsFrame==null || auditedItemsFrame =='undefined'){
    	auditedItemsFrame= findFrame(getTopWindow().getWindowOpener().getTopWindow(), "detailsDisplay");
    }
    if(auditedItemsFrame.editableTable){
    	auditedItemsFrame.editableTable.loadData();
    	auditedItemsFrame.RefreshTableHeaders();
    	auditedItemsFrame.rebuildView();
  	}
	getTopWindow().closeWindow();
}

function refreshAuditRequestsSBAfterRemovingItem() {
    var auditRequestFrame = findFrame(getTopWindow(), "QICAUDConnectedRequests");
    if(auditRequestFrame==null || auditRequestFrame =='undefined'){
    	auditRequestFrame= findFrame(getTopWindow(), "detailsDisplay");	
   	}
    auditRequestFrame.location.href = auditRequestFrame.location.href;
}

function ShowCreateAuditFromAuditRequestSlideInForm(requestObjectIds){
	var submitURL = "../common/emxCreate.jsp?nameField=autoName&mode=edit&type=type_Audit&nameField=None&policy=policy_Audit&form=QICAUDAuditCreate&header=LQIAudit.AuditButton.CreateAudit&HelpMarker=emxhelpAUDcreate&createJPO=com.dassault_systemes.enovia.lsa.audit.services.ui.AuditAudit:createAutoNamed&submitAction=treeContent&findMxLink=false&preProcessJavaScript=createAuditFromAuditRequestPreProcess&suiteKey=LQIAudit&requestObjectIds="+requestObjectIds;
	getTopWindow().showSlideInDialog(submitURL,true);
}

function showCreateAuditFromContextAuditRequestForm(requestObjectId){
	var submitURL = "../common/emxCreate.jsp?nameField=autoName&mode=edit&type=type_Audit&nameField=None&policy=policy_Audit&form=QICAUDAuditCreate&header=LQIAudit.AuditButton.CreateAudit&HelpMarker=emxhelpAUDcreate&createJPO=com.dassault_systemes.enovia.lsa.audit.services.ui.AuditAudit:createAutoNamed&submitAction=refreshCaller&findMxLink=false&preProcessJavaScript=createAuditFromContextAuditRequestPreProcess&suiteKey=LQIAudit&requestObjectIds="+requestObjectId;		
	getTopWindow().showSlideInDialog(submitURL,true);
}
</script>

