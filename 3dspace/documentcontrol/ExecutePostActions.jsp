<%@include file="../common/emxNavigatorInclude.inc"%>
<%@page import="com.dassault_systemes.enovia.dcl.DCLConstants"%>
<%@page import="matrix.db.Context"%>
<%@page import="matrix.util.StringList"%>

<%

%>

<script type="text/javascript" language="javascript">

	function editDocumentDetails(strUrl,isFromRMB,isTrainingEnabled,strMessage)
	{
		//if(isTrainingEnabled == "Yes")
			//getTopWindow().document.getElementsByName('li_DOCOTraineeCategory')[0].style.display="";
		if(isTrainingEnabled == "No")
	{
			alert(strMessage);
			//alert(strAlertForTraineeRemoval);
			//getTopWindow().document.getElementsByName('li_DOCOTraineeCategory')[0].style.display="none";
		}
		if(isFromRMB)
		{
			var mycontentFrame = findFrame(getTopWindow(),"content");
			mycontentFrame.location.href=strUrl;
		}
		else
		{
			var contentFrame = findFrame(getTopWindow(), "content");
			getTopWindow().closeSlideInDialog();
			contentFrame.location.href=contentFrame.location.href;
		}
	}
	
	function disableSMEAndPeriodicIntevalField()
	{	
		hideSMEAndIntervalFields();
	}

	function addReferenceDocuments() {
			var contentFrame = findFrame(getTopWindow(),"DCLReferenceDocument");
			if(!contentFrame){
				this.parent.location.href=this.parent.location.href;
			}else{
			contentFrame.location.href = contentFrame.location.href;
			}
	}

	function removeReferenceDocuments() {
		this.parent.location.href=this.parent.location.href;
	}
	
	function copyExistingDocument(strCopiedDocument,strIsOneSearchEnabled) {
		var copiedDocuments = strCopiedDocument.split("\\|");
		if (copiedDocuments.length > 1) 
		{
			alert(copiedDocuments[1]);
		}
		if(("FALSE" == strIsOneSearchEnabled) || ("false" == strIsOneSearchEnabled))
		 {
			getTopWindow().opener.location.href="../common/emxTree.jsp?objectId="+copiedDocuments[0];
			getTopWindow().close();

	     }
		 else
		 {
				getTopWindow().parent.opencopyExistingDocumenter.parent.location.href = getTopWindow().parent.opener.parent.location.href;
		getTopWindow().close();
	}
	}
	
	function copySelectedDocument(strCopiedDocument) {
		var copiedDocuments = strCopiedDocument.split("\\|");
		if (copiedDocuments.length > 1) 
		{
			alert(copiedDocuments[1]);
		}
		document.location.href="../common/emxTree.jsp?objectId="+copiedDocuments[0];

	}
	
	function showDocumentEditView(strCopiedDocument,flag, strDocTemplatePolicy, strPolicy,isFromRMB, showTrainingEnabledEditable)
	{
		var submitURL="../common/emxForm.jsp?form=type_CONTROLLEDDOCUMENTSEDIT&mode=edit&formHeader=enoDocumentControl.Command.EditDetails&Export=False&postProcessURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:editDocumentDetails&preProcessJavaScript=disableOrEnableFormFields&suiteKey=DocumentControl&StringResourceFileId=enoDocumentControlStringResource&SuiteDirectory=documentcontrol&objectId="+
		strCopiedDocument+"&openerFrame=DCLDocumentProperties&parentOID="+strCopiedDocument+"&flag="+flag+"&showTrainingEnabledEditable="+showTrainingEnabledEditable;

		if (strDocTemplatePolicy == strPolicy) 
			submitURL = submitURL +"&HelpMarker=emxhelpdoctemplatepropsedit";
		
		else
			submitURL = submitURL +"&HelpMarker=emxhelpdocumentpropsedit";

		if (null != isFromRMB)
			submitURL = submitURL +"&isFromRMB="+isFromRMB;
		getTopWindow().showSlideInDialog(submitURL, true);

	}
	
	
	function getExistingChangeOrdersPreProcess(strInvalidDocumentMessage,strAddChange,strDocIds)
	{
		if (strInvalidDocumentMessage)
		{
			alert(strInvalidDocumentMessage);
			this.parent.location.href=this.parent.location.href;
		}
		else {
			if (strAddChange && strAddChange == 'CR') 
				var submitURL="../common/emxFullSearch.jsp?field=TYPES=type_ChangeRequest:CURRENT=policy_ChangeRequest.state_Create,policy_ChangeRequest.state_Evaluate&showInitialResults=false&table=AEFGeneralSearchResults&selection=single&showSavedQuery=True&searchCollectionEnabled=True&formInclusionList=Description&addChange=CR&submitURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:connectExistingChangeOrderToDocument";
			else if (strAddChange && strAddChange == 'CA') 
				var submitURL="../common/emxFullSearch.jsp?field=TYPES=type_ChangeAction:CURRENT=policy_ChangeAction.state_Prepare,policy_ChangeAction.state_InWork&showInitialResults=false&table=AEFGeneralSearchResults&selection=single&showSavedQuery=True&searchCollectionEnabled=True&formInclusionList=Description&addChange=CA&submitURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:connectExistingChangeOrderToDocument";

			else 
				var submitURL="../common/emxFullSearch.jsp?field=TYPES=type_ChangeOrder:CURRENT=policy_FormalChange.state_Propose,policy_FormalChange.state_Prepare,policy_FasttrackChange.state_Prepare&showInitialResults=false&table=AEFGeneralSearchResults&selection=single&showSavedQuery=True&searchCollectionEnabled=True&formInclusionList=Description&submitURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:connectExistingChangeOrderToDocument";
			
			submitURL = submitURL+"&appendedDocIds="+strDocIds+"&submitAction=doNothing&isFrom=false";
			showModalDialog(submitURL,250,250,true);
		}

	}
	
	function connectExistingChangeOrderToDocument(strMessage,strObjectId,strIsOneSearchEnabled)
	{
		if(strObjectId)
		{		
			alert(strMessage);
			if(("FALSE" == strIsOneSearchEnabled) || ("false" == strIsOneSearchEnabled))
			 {
				getTopWindow().opener.parent.location.href=getTopWindow().opener.parent.location.href;
				getTopWindow().close();


		     }
			else
			{
				 var frame = findFrame(getTopWindow(),"content");
				 frame.location.href = frame.location.href;
		}
		}
		
		else
		{
			alert(strMessage);
			if(("FALSE" == strIsOneSearchEnabled) || ("false" == strIsOneSearchEnabled))
			{
			var contentFrame=findFrame(getTopWindow().opener.getTopWindow(), "DCMyDocumentsTab");
			getTopWindow().close();
			contentFrame.emxEditableTable.refreshStructure();

		     }
			else
			{
		      	 getTopWindow().refreshTablePage();
		}
		}
	}
	
	function preProcessAddChangeOrder(strInvalidDocumentMessage,strCreateObjectType,strDocIds)
	{
		if (strInvalidDocumentMessage)
		{
			alert(strInvalidDocumentMessage);
			this.parent.location.href=this.parent.location.href;
		}
		else {
			if (strCreateObjectType && strCreateObjectType == 'CR') 
			{
				var submitURL="../common/emxCreate.jsp?form=type_CreateChangeRequest&header=EnterpriseChangeMgt.Command.CreateChangeRequest&type=type_ChangeRequest&nameField=autoname&createJPO=enoECMChangeRequest:createChangeRequest&typeChooser=true&suiteKey=EnterpriseChangeMgt&StringResourceFileId=emxEnterpriseChangeMgtStringResource&SuiteDirectory=enterprisechangemgt&emxSuiteDirectory=enterprisechangemgt&preProcessJavaScript=setRO&postProcessURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:connectChangeOrderToDocument&submitAction=doNothing&createObj=CR&emxTableRowId=";
			}
                        else if (strCreateObjectType && strCreateObjectType == 'CA') 
			{
				var submitURL="../common/emxCreate.jsp?form=type_CreateChangeActionSlidein&header=EnterpriseChangeMgt.Command.CreateChangeAction&type=type_ChangeAction&nameField=autoname&createJPO=enoECMChangeActionUX:createChangeAction&typeChooser=true&suiteKey=EnterpriseChangeMgt&StringResourceFileId=emxEnterpriseChangeMgtStringResource&SuiteDirectory=enterprisechangemgt&emxSuiteDirectory=enterprisechangemgt&postProcessURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:connectChangeOrderToDocument&submitAction=doNothing&createObj=CA&functionality=AddToNewCA&mode=create&emxTableRowId=";
			}

			else 
			{
				var submitURL="../common/emxCreate.jsp?form=type_CreateChangeOrderSlidein&header=EnterpriseChangeMgt.Command.CreateChange&type=type_ChangeOrder&nameField=autoname&createJPO=enoECMChangeOrder:createChange&CreateMode=CreateCO&typeChooser=true&suiteKey=EnterpriseChangeMgt&StringResourceFileId=emxEnterpriseChangeMgtStringResource&SuiteDirectory=enterprisechangemgt&emxSuiteDirectory=enterprisechangemgt&preProcessJavaScript=preProcessInCreateCO&postProcessURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:connectChangeOrderToDocument&targetRelName=relationship_ChangeAffectedItem&isFrom=false&submitAction=doNothing&emxTableRowId=";
			}
			submitURL = submitURL+strDocIds;
			getTopWindow().showSlideInDialog(submitURL,250,250,true);
		}
	}
	
	function connectChangeOrderToDocument(strMessage,strSelectedDocumentIds)
	{
		if(!strSelectedDocumentIds)
		{
			var contentFrame=findFrame(getTopWindow(),"DCLDocumentProperties");
			var frameName=findFrame(getTopWindow(),"detailsDisplay");
			
			getTopWindow().closeSlideInDialog();
			if(frameName)
				frameName.location.href=frameName.location.href;
			if(contentFrame)
			contentFrame.location.href=contentFrame.location.href;
			
		}
		else
		{
			var contentFrame=findFrame(getTopWindow(), "DCMyDocumentsTab");
			contentFrame.emxEditableTable.refreshStructure();		
		}
		
	}
	
	function addDocumenttodocumentFamily(strMessage,strClassificationRequiredText,strClassificationPath)
	{
		alert("In addDocumenttodocumentFamily");
		alert(strMessage+"\n"+strClassificationRequiredText+"\n"+strClassificationPath);
		getTopWindow().close();
	}
	
	function viewDetailsInRMB(strDocTemplatePolicy,strPolicy,strDocId)
	{
		var submitURL="../common/emxTree.jsp?mode=insert&objectId="+strDocId;
		if (strDocTemplatePolicy == strPolicy) {
			submitURL = submitURL + "&HelpMarker=emxhelpdoctemplatepropsedit";
		}
		else {
			submitURL = submitURL + "&HelpMarker=emxhelpdocumentpropsedit";
		}
		getTopWindow().showModalDialog(submitURL,250,250,true);
		
	}
	function parentRefresh(){
		getTopWindow().opener.parent.location.href=getTopWindow().opener.parent.location.href;
		getTopWindow().close();
	}
	
	function closeTopWindow(){
		getTopWindow().close();
		getTopWindow().opener.parent.location.href=getTopWindow().opener.parent.location.href;		
	}
	
	function closeOnlyTopWindow(){
		getTopWindow().close();
	}
	
	function parentLocationRefresh(){
		this.parent.location.href = this.parent.location.href;
	}
	
	function reloadParentLocation(){
		parent.location.reload();
	}
	
	function topWindowRefresh(){
		getTopWindow().opener.location.href=getTopWindow().opener.location.href;
	}
	
	function reloadParentWindow(){
		getTopWindow().opener.location.reload();
		getTopWindow().close();
	}
	
	function reloadParentWindowWithAlert(strMessage){
		alert(strMessage);
		if(getTopWindow().opener){
		getTopWindow().opener.parent.location.href=getTopWindow().opener.parent.location.href;
		getTopWindow().close();				
		}else{
		var frame=findFrame(getTopWindow(),"detailsDisplay");
		frame.document.location.href=frame.document.location.href;
		}		
					
	}
	
	function findFrameAndRefresh(){
		var frame=findFrame(getTopWindow(),"detailsDisplay");
		if(!frame){
			getTopWindow().parent.opener.parent.location.href = getTopWindow().parent.opener.parent.location.href; 
        }
		else{
		frame.document.location.href=frame.document.location.href;
	}
	
	}
	
	function refreshStructure(){
		this.parent.emxEditableTable.refreshStructure();		
	}
	
	function closeTopWindowWithAlert(strAlertMessage){
	alert(strAlertMessage);
    getTopWindow().close();
	}
	
	function refreshTablePageTopWindow(){
		getTopWindow().refreshTablePage();
	}
	
	function topWindowParentOpener(){
	       findFrameAndRefresh();
	       getTopWindow().closeWindow();
	}
	
	function findContentFrameAndRefresh(){
		var contentFrame = findFrame(getTopWindow(),"content");
		contentFrame.document.location.href=contentFrame.document.location.href;
	}
	
	function setContentFrameLocation(saObjectId){
		var contentFrame = findFrame(getTopWindow().opener.getTopWindow(), "content");
		if(contentFrame){
			contentFrame.document.location.href = "../common/emxTree.jsp?objectId=" + saObjectId;
			getTopWindow().close();
		}
	}
	
	function addExistingAttributeToAttributeGroup(){
		getTopWindow().opener.parent.location.href=getTopWindow().opener.parent.location.href;
		getTopWindow().close();
	}
	
	function emxFullSearchAddTraineeMembers(strOId, strRelId, strparentOID){
		var submitURL =	"../common/emxFullSearch.jsp?table=DOCOCandidateSearch&includeOIDprogram=ENODOCOTraineeUI:includePersonOID&field=TYPES=type_Person:CURRENT=policy_Person.state_Active&submitURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLAdminActions:addTraineeMembers&selection=multiple&sortColumnName=Type";
        submitURL =	submitURL + "&objectId=" + strOId;
		submitURL =	submitURL + "&relId=" + strRelId + "&parentOID="+ strparentOID;
		showModalDialog(submitURL,'300','350',true);
		}
	function preProcessAddTraineeMembersNoRowID(strPolicy, policy,strObjectId){
		if (strPolicy!=policy) {
			var submitURL ="../common/emxFullSearch.jsp?table=DOCOCandidateSearch&field=TYPES=type_Person,type_Organization,type_MemberList:CURRENT=policy_Person.state_Active,policy_Organization.state_Active,policy_MemberList.state_Active&submitURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLAdminActions:addTraineeMembers&selection=multiple&includeOIDprogram=ENODOCOTraineeUI:includePersonOID&sortColumnName=Type";
			submitURL =	submitURL + "&objectId=" + strObjectId;
			showModalDialog(submitURL,'300','350',true);			
		}
		else {
			var submitURL = "../common/emxFullSearch.jsp?table=DOCOCandidateSearch&field=TYPES=type_Organization,type_MemberList:CURRENT=policy_Organization.state_Active,policy_MemberList.state_Active&submitURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLAdminActions:addTraineeMembers&selection=multiple&includeOIDprogram=ENODOCOTraineeUI:includePersonOID&sortColumnName=Type";
			submitURL =	submitURL + "&objectId=" + strObjectId;
			showModalDialog(submitURL,'300','350',true);			
		}
	}
	
	function removeTraineeMembers(strEmxTableRowIds){
		var emxTableRowIds = strEmxTableRowIds;
		var TableRowIds = emxTableRowIds.split(";");
		this.parent.emxEditableTable.removeRowsSelected(TableRowIds);
		frameObject.refreshStructureWithOutSort();
	}
	
	function createDocumentByTemplate(strSelectedObjectId, strSelectedObjectName){
		var sURL = "../common/emxCreate.jsp?type=type_QualitySystemDocument&mode=create&createJPO=ENODCDocument:createDocument&reloadKey=Yes&suiteKey=DocumentControl&autoNameChecked=true&header=enoDocumentCommon.Label.CreateNewDocument&form=DCLCreateControlledDocument&submitAction=doNothing&postProcessURL=../documentcommon/enoDCExecute.jsp?dcAction=ENODCDocument:createDocumentPostProcess&helpMarker=emxhelpcreatequalitysysdoc&DCMode=createdocument&preProcessJavaScript=makeSMERequired&validateToken=false&templateId=";
		var sURL = sURL + strSelectedObjectId + "&templateName=" + strSelectedObjectName;
		getTopWindow().opener.location.href=sURL;
		getTopWindow().window.close();
	}
	
	function showDocumentsForMigration(sbType){
		var submitURL="../common/emxFullSearch.jsp?field=TYPES=";
		submitURL= submitURL + sbType +"&table=AEFGeneralSearchResults&includeOIDprogram=ENODCLMigrationUI:includeLatestRevisionDocumentsForMigration";
		submitURL= submitURL + "&selection=multiple&submitURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLMigrationUI:migrateData";
		showModalDialog(submitURL,250,250,true);
	}
	
	function preProcessAddImplementingOrganizationRep(strSuiteKey, strOrgId, strRole, strDocId, strRelId){
		
		var sbSearchURL = "../common/emxFullSearch.jsp?form=AEFSearchPersonForm&suiteKey="
				+  strSuiteKey + "&field=TYPES=type_Person:CURRENT=policy_Person.state_Active:MEMBER_ID=" + strOrgId;
		
		
		sbSearchURL = sbSearchURL + ":USERROLE=" + strRole;
		
		sbSearchURL = sbSearchURL + "&table=AEFPersonChooserDetails&selection=single&showSavedQuery=True";
		sbSearchURL = sbSearchURL + "&objectId=" + strDocId;
		sbSearchURL = sbSearchURL + "&orgRelId=" + strRelId;
		sbSearchURL = sbSearchURL + "&submitURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLEffectivityUIBase:addImplementingOrganizationRep&submitAction=refreshCaller&excludeOIDprogram=ENODCLEffectivityUI:excludeConnectedImplementingOrganizationRepresentative";

		showModalDialog(sbSearchURL, 600, 400, false);

	}
	
	function preProcessCreateDocumentFromTemplate(strType, objectId){
		var url =" ../common/emxCreate.jsp?type="+ strType;
		var url = url + "&createJPO=ENODCDocument:createDocument&form=DCLCreateDocumentFromTemplate&helpMarker=emxhelpcreatedocfromtemplate&preProcessJavaScript=makeSMERequired&submitAction=doNothing&autoNameChecked=true&header=enoDocumentControl.Command.CreateDocumentFromTemplate&DCMode=createdocument&suiteKey=DocumentControl&StringResourceFileId=enoDocumentControlStringResource&SuiteDirectory=documentcontrol&selTemplateId=";
		var url = url + objectId + "&postProcessURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLAdminActions:createDocumentFromTemplatePostProcess&callledFor=connectTemplatetoDocument";
		showModalDialog(url,350,350,true);
	}
	
	function getDisplayRowsAfterFiltering(oXML){
		var rowsToBeShown = null;
		var objectCount = 0;
		var nTotalRows = emxUICore.selectSingleNode(oXML, "/mxRoot/setting[@name = 'total-rows']");
		var singleRoot = emxUICore.selectSingleNode(oXML, "/mxRoot/rows//r[@id ='0']");
		if(singleRoot){
		   rowsToBeShown = emxUICore.selectNodes(oXML, "/mxRoot/rows//r[ (not(@filter) or @filter != 'true') and (@level = '0' or count(ancestor::r[not(@display) or @display = 'none']) = '0')]");
		}else{
		   rowsToBeShown = emxUICore.selectNodes(oXML, "/mxRoot/rows//r[ (not(@filter) or @filter != 'true') and ( count(ancestor::r[not(@display) or @display = 'none']) = '0')]");
		}
		objectCount = rowsToBeShown.length;
		emxUICore.setText(nTotalRows, objectCount);
		return rowsToBeShown;
		}
	
	function _getSetting(xml, basePath, name) {
		var nSetting = emxUICore.selectSingleNode(xml, basePath + "/setting[@name =" + name + "]");
		if (!nSetting) {
		   return null
		} else {
		   return emxUICore.getText(nSetting);
		}
		}
	
	function getRequestSetting(oXML, name) {
		return _getSetting(oXML, "/mxRoot/requestMap", name);
		}
	
	function exportData(oXML, strReportTitle){
		var rowGrouping = emxUICore.selectNodes(oXML,"/mxRoot/setting[@name='groupLevel']");
		var bGroupingRows = false;
		if(rowGrouping && rowGrouping.length >0){
		   bGroupingRows = true;
		}
		outputFormat = "CSV";
		var winName = "listHidden";
		var groupData = new Array(); 
		var groupRowIndex = new Array();
		var tempRowIds = new Array();
		var aDisplayRows = getDisplayRowsAfterFiltering(oXML);
		for(var i=0;i<aDisplayRows.length;i++){
		   var id = aDisplayRows[i].getAttribute("id");
		   if((id.indexOf('L') == -1) && (id.indexOf('cal') == -1)){
		      tempRowIds.push(id);
		    }
		   if((id.indexOf('L') != -1)){
		      if(isIE){
		           if(aDisplayRows[i].firstChild.text==" " || aDisplayRows[i].firstChild.text==""){
		              groupData.push("0x08");
		           }else{
		              groupData.push(aDisplayRows[i].firstChild.text);
		           }
		       }else{
		           if(aDisplayRows[i].firstChild.textContent=="" || aDisplayRows[i].firstChild.textContent==""){
		               groupData.push("0x08");
		           }else{
		              groupData.push(aDisplayRows[i].firstChild.textContent);
		            }
		       }
		       groupData.push(aDisplayRows[i].getAttribute('count'));
		       groupRowIndex.push(i);
		    }
		}
		var rowIds = tempRowIds.join("|");
		this.parent.document.emxTableForm.rowIds.value = rowIds;
		this.parent.document.emxTableForm.bGroupingRows.value = bGroupingRows;
		if(bGroupingRows){
		   this.parent.document.emxTableForm.groupData.value = groupData;
		   this.parent.document.emxTableForm.groupRowIndex.value = groupRowIndex;
		}
		var subHeader = getRequestSetting(oXML, 'subHeader');
		var strURL = "../documentcontrol/enoDCLReport.jsp?exportFormat=" + outputFormat + "&subHeader=" + subHeader+ "&sbMode=view&reportTitle="
				+ strReportTitle + "";
		this.parent.document.emxTableForm.target = winName;
		this.parent.document.emxTableForm.action = strURL;
		this.parent.document.emxTableForm.method = "post";
		addSecureToken(this.parent.document.emxTableForm);
		this.parent.document.emxTableForm.submit();
		outputFormat = null;
		}
	
	function addAssesmentReport(strReportTitle){	

		    try{
			var contentFrame = findFrame(getTopWindow(),"listHidden");
			var xmlRef = this.parent.oXML;
			exportData(xmlRef, strReportTitle);
			}catch(e){
			alert("ERROR: "+ e);
			}
	}
	
	function getSelectedFileIds(requiredText, emxTableRowId, strDocId, strParentOID, strHeader, strSubHeader)
	{
		
		var selectedIds = "";
		var emxTableRowId = "";
		var frameFilesTable = findFrame(getTopWindow(), 'frameFilesTable');
		if (frameFilesTable == null) {
			var frameFilesTable = findFrame(getTopWindow(), 'detailsDisplay');
		}
		if(frameFilesTable.emxEditableTable.getCheckedRows().length>1) {
			alert(requiredText);
						}
			    	else if (frameFilesTable.emxEditableTable.getCheckedRows().length<=1) {
			    		if (frameFilesTable.emxEditableTable.getCheckedRows().length==1) {
						selectedIds = selectedIds + frameFilesTable.emxEditableTable.getCheckedRows()[0].getAttribute("o");
						emxTableRowId=selectedIds;
					}
					else{
						emxTableRowId=emxTableRowId;
					}

			var submitURL ="../common/emxIndentedTable.jsp?table=DCLChangeBlockSummary&expandProgram=ENODCLChangeBlockUI:findVersionedFileBlock&selection=multiple&hideRootSelection=true&toolbar=DCLChangeBlockMenu&insertNewRow=true&connectionProgram=ENODCLChangeBlockUI:addRow&objectId="+ strDocId;
			submitURL = submitURL + "&emxTableRowId="+emxTableRowId;
			submitURL = submitURL +"&parentOID="+ strParentOID;
			submitURL = submitURL +"&suiteKey=DocumentControl&SuiteDirectory=documentcontrol&helpMarker=emxhelpchangeblock&postProcessJPO=ENODCLConfigureChangeOrderUI:postProcessRefreshTable&header=" + strHeader;
			submitURL = submitURL +"&subHeader="+strSubHeader;
			showModalDialog(submitURL,'300','350',true);
					}
	
	}
	
	function getChangeBlockRelIds(strAllowedStates, sbChangeBlockRelIds, strObjectId){
		var submitURL = "../common/emxFullSearch.jsp?field=TYPES=type_CONTROLLEDDOCUMENTS:POLICY=policy_ControlledDocuments:CURRENT=" + strAllowedStates;
		submitURL = submitURL + "&table=DCLDocumentsSearch&objectIds=";
		submitURL = submitURL +  sbChangeBlockRelIds;
		submitURL = submitURL + "&includeOIDprogram=ENODCLChangeBlockUI:includeDocumentsForCopyChangeBlocks&selection=multiple&submitURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLChangeBlockUI:copyChangeBlocks";
		submitURL = submitURL + "&objectId=" + strObjectId;
		showModalDialog(submitURL,'350','350',true);
		
	}
	
	function removeRowsSelected(sbActionTasksRowId){
		var emxTableRowIds = sbActionTasksRowId;
		var TableRowIds = emxTableRowIds.split(";");
		this.parent.emxEditableTable.removeRowsSelected(TableRowIds);
	}
	
	function addActionTask(strHeader, sbApprovalObj, strObjectId){
		var submitURL="../common/emxFullSearch.jsp?field=TYPES=type_Person,type_BusinessRole:CURRENT=policy_Person.state_Active,policy_BusinessRole.state_Active&table=DCLCOActionTaskSearchTable&selection=multiple&submitURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLConfigureChangeOrderUI:addActionTaskToApproval";
		submitURL = submitURL + "&emxSuiteDirectory=documentcontrol&suiteKey=DocumentControl&SuiteDirectory=documentcontrol&StringResourceFileId=enoDocumentControlStringResource&header=" + strHeader;
		if (sbApprovalObj.length() > 0)
			submitURL = submitURL + "&objectId=" + sbApprovalObj;
		submitURL = submitURL + "&parentOID=" + strObjectId;
		showModalDialog(submitURL,250,250,true);
	}
	
	function preProcessApprovalsAndEForm(strCurrentState, strObjectId){
		if (strCurrentState=="In Approval" || strCurrentState=="Complete" || strCurrentState=="Implemented") {
			var submitURL="../common/emxTable.jsp?program=emxLifecycle:getCurrentTaskSignaturesOnObject&table=AEFLifecycleTaskSignaturesSummary&toolbar=AEFLifecycleTasksToolbar&FilterFramePage=../common/emxLifecycleTasksSignaturesFilter.jsp&FilterFrameSize=40&sortColumnName=Name&objectBased=false&HelpMarker=emxhelplifecycletasks";
		}
		else {
			var submitURL="../common/emxIndentedTable.jsp?table=DCLCOApprovalTable&expandProgram=ENODCLConfigureChangeOrderUI:getRouteTemplateActionTasks&toolbar=DCLCOApprovalToolbar&selection=multiple&hideRootSelection=true";
		}
		submitURL = submitURL +"&objectId=" + strObjectId;
		this.location.href=submitURL;
	}
	
	function getCreateDocumentFromRefrenceDocumentUIScript()
	{		
		var chooserTypeActual = $("[name=btnTypeActual]");
		chooserTypeActual[0].onclick = function () { javascript:showChooser('../common/emxTypeChooser.jsp?type=type_Document&amp;SelectType=singleselect&amp;SelectAbstractTypes=false&amp;InclusionList=type_DOCUMENTS&amp;ReloadOpener=false&amp;ExclusionList=enoDocumentCommon.CreateDocuments.TypeExclusionList&amp;fieldNameActual=TypeActual&amp;fieldNameDisplay=TypeActualDisplay&amp;fieldNameOID=TypeActualOID&amp;suiteKey=DocumentCommon','600','600','true','','TypeActual') }
	}
	
	
	function preProcessCheckin( saObjectId,showFileTitle,showFileCategory,categoryList){
		var sURL="../components/emxCommonDocumentPreCheckin.jsp?objectAction=checkin&msfBypass=true&showFormat=true&frameName=detailsDisplay";
		sURL+="&objectId="+saObjectId+"&showFileTitle="+showFileTitle;
		if(categoryList!="" && categoryList != "null" && categoryList!=null && (showFileCategory=="true" || showFileCategory==true ))
			{
			sURL+="&showFileCategory=true&fileCategory="+categoryList;
			}
		showModalDialog(sURL,350,350,true);	
	}
	function checkInFile(strMessage, saObjectId, bRefreshTableContent,showFileCategory,categoryList){
		var sURL = "../components/emxCommonDocumentPreCheckin.jsp?objectId=" + saObjectId;
		sURL = sURL + "&showComments=true&showFormat=true&objectAction=checkin&appProcessPage=enoDCLPostCheckinProcess.jsp&appDir=documentcontrol";
		if(showFileCategory=="true" || showFileCategory==true )
			sURL+="&showFileTitle=true";
		if(categoryList!="" && categoryList != "null" && categoryList!=null &&  (showFileCategory=="true" || showFileCategory==true ))
			sURL+="&showFileCategory=true&fileCategory="+categoryList;
		if (bRefreshTableContent=="true") {
			sURL = sURL + "&refreshTableContent=true";
		}
		getTopWindow().location.href = sURL;
	}
	
	function checkCOEffectivityAttributes(arrObjectId){
		
		var submitURL="../common/emxForm.jsp?form=DCLConfigureEffectivity&mode=edit&formHeader=enoDocumentControl.Header.ConfigureEffectivity&objectId=";
		submitURL = submitURL + arrObjectId + "&preProcessJavaScript=enableOrDisableFields";
		submitURL = submitURL + "&HelpMarker=emxhelpdefinedoceffectivity&emxSuiteDirectory=documentcontrol&suiteKey=DocumentControl&SuiteDirectory=documentcontrol&StringResourceFileId=enoDocumentControlStringResource";
		submitURL = submitURL + "&submitAction=doNothing&postProcessURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLAdminActions:updateEffectiveDateOnDocument";
		showModalDialog(submitURL,350,350,true);		
	}
	
	function completeImplementation(objectId, relationshipId, strTimeZone){
		var submitURL="../common/emxForm.jsp?form=DCLCompleteImplementation&mode=edit&formHeader=enoDocumentControl.Header.CompleteImplementation&objectId=" + objectId;
		submitURL = submitURL + "&isSelfTargeted=true&submitAction=doNothing&cancelProcessURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLEffectivityUI:cancelPage"
		+ "&postProcessURL=../documentcontrol/enoDCLValidateUserProcess.jsp?action=ENODCLAdminActions:postProcessCompleteImplementation&verificationMode=implementation&relId="
		+ relationshipId + "&emxSuiteDirectory=documentcontrol&suiteKey=DocumentControl&SuiteDirectory=documentcontrol&StringResourceFileId=enoDocumentControlStringResource"
		+ "&timeZone=" + strTimeZone + "&HelpMarker=emxhelpcompleteimplementation";
		showModalDialog(submitURL,350,350,true);		
	}
	
	function getSelectedAttributes(strObjectId, strInterfaceName, strMessage){
		var selectedAttributes="";
		var dispalyAttributes = "";
		var frame = findFrame(getTopWindow(),"content");
		var selectedRows = emxUICore.selectNodes(frame.oXML, "/mxRoot/rows//r[@mandatory = 'Yes']");
		var frame = findFrame(getTopWindow(),"content");
		 if(selectedRows.length==0)
		{
			alert(strMessage);
			frame.setSubmitURLRequestCompleted();
		} 
		else{
			for (var i = 0; i < selectedRows.length; i++){
	            var levelId = selectedRows[i].getAttribute("id");
	            var mandatoryStatus = selectedRows[i].getAttribute("mandatoryStatus");
	            var selectedRangeValues = selectedRows[i].getAttribute("rangeValues");
	            var ranges = "";
	            if(selectedRangeValues != null){
	                var selectbox = selectedRangeValues.trim().split(",");
	                for (var j=0; j<selectbox.length; j++){
	                    ranges=ranges+ selectbox[j]+"#";
	                }
	                ranges = ranges.substring(0, ranges.length - 1);
	            }
	            var rowNode = emxUICore.selectSingleNode(frame.oXML, "/mxRoot/rows//r[@id = '" + levelId + "']");
	            var attributeName = rowNode.getAttribute("o");
	            if(mandatoryStatus=="Yes"){
	                dispalyAttributes+=attributeName + "|";
	                selectedAttributes+=attributeName + "@yes@" +ranges+ "|";
	            }
	            else {
	                dispalyAttributes+=attributeName+ "|";
	                selectedAttributes+=attributeName + "@no@"+ranges+"|";
	            }
	        }
			selectedAttributes = selectedAttributes.substring(0, selectedAttributes.length - 1);
			dispalyAttributes = dispalyAttributes.substring(0, dispalyAttributes.length - 1);
			if(strObjectId){
				parent.getTopWindow().location.href = "../common/emxCloseWindow.jsp";
				getTopWindow().opener.document.forms["editDataForm"].Attributes.value = selectedAttributes;
				getTopWindow().opener.document.forms["editDataForm"].AttributesDisplay.value = dispalyAttributes;
				getTopWindow().opener.document.forms["editDataForm"].AttributesOID.value = dispalyAttributes;
			}
			else{
				var sURL = "../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLTemplateAttributesGroupingUI:addExistingAttributeToAttributeGroup&validateToken=false&AGName=";
				sURL = sURL + strInterfaceName + "&objectId=" + strObjectId;
				sURL = sURL +"&attributes="+dispalyAttributes+ "&attributesInfo="+selectedAttributes;
				frame.document.location.href = sURL;
			}
		}
	}
	
	function affectedItemFrame(){
		var affectedItemFrame  = findFrame( getTopWindow().opener.getTopWindow() ,"ECMCOProperties");
		affectedItemFrame.location.href= affectedItemFrame.location.href;
		getTopWindow().close();
	}
	
	function contentFrameDCLTemplatesTab(){
		var contentFrame=findFrame(getTopWindow(), "DCLTemplatesTab");
		if(!contentFrame){
		                  var frame=findFrame(getTopWindow(),"portalDisplay");
		                  frame.document.location.href=frame.document.location.href;
		}
		else{
		    contentFrame.document.location.href=contentFrame.document.location.href;
		}
	}
	
	function deleteEFormTemplates(sbMessage, condition){
		if(sbMessage)
			alert(sbMessage);
		if(condition)
		{
			this.parent.location.href=this.parent.location.href;
		}
	}
	
	function preprocessCompleteTraining(strFormHeading, strObjId, tableId){
		var submitURL ="../common/emxForm.jsp?form=DOCOCompleteTraining&mode=edit&postProcessURL=../documentcontrol/enoDCLValidateUserProcess.jsp?action=ENODCLAdminActions:completeTraining&suiteKey=DocumentControl&StringResourceFileId=enoDocumentControlStringResource&SuiteDirectory=documentcontrol&HelpMarker=emxhelptrainingcomplete&verificationMode=training&formHeader=";
		submitURL = submitURL + strFormHeading + "&objectId=" +strObjId + "&relIds=" + tableId;
		//showSlideInDialog(submitURL,250,250,true);
		showModalDialog(submitURL,250,250,true);
	}
	
	function preProcessAddAtributeToAttributeGroup(agName, interfaceName){
		var href="../common/emxIndentedTable.jsp?program=ENODCLTemplateAttributesGroupingUI:getAttributeList&table=DCLAttributeGroupSearchAttributeTable&categoryTreeName=null&header=enoDocumentControl.Header.AttributeChooser.SelectAttribute&sortColumnName=Name&sortDirection=ascending&objectCompare=false&Export=false&toolbar=DCLAttributeAddExisting&expandLevelFilterMenu=false&PrinterFriendly=false&showClipboard=false&showPageURLIcon=false&submitLabel=emxFramework.Common.Done&cancelLabel=emxFramework.Common.Cancel&cancelButton=true&autoFilter=true&filter=false&submitURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLTemplateAttributesGroupingUI:getSelectedAttributes&selection=multiple&";
		href = href + agName + "=" + interfaceName + "&suiteKey=DocumentControl&StringResourceFileId=enoDocumentControlStringResource&SuiteDirectory=documentcontrol";
		showModalDialog(href,250,250,true);
    }
	
	function alertwithParentLocationRefresh(strMessage){
		alert(strMessage);
		this.parent.location.href=this.parent.location.href;
	}
	
	function alertWithTopWindowRefresh(strMessage){
		alert(strMessage);
		getTopWindow().location.href=getTopWindow().location.href;
	}
	
	function alertAndRefreshTreeDetailsPage(strMessage){
		alert(strMessage);
		getTopWindow().refreshTreeDetailsPage();
	}
	
	function alertMessage(strMessage)
	{	
		alert(strMessage);
	}

	function transferAssignments(strMessage)
	{	
		alert(strMessage);
	}
	function refreshTemplateLibraires(isOneSearchEnabled)
	{
		if(("FALSE" == isOneSearchEnabled) || ("false" == isOneSearchEnabled))
		 {
			getTopWindow().opener.location.href=getTopWindow().opener.location.href;
			getTopWindow().close();

	     }
		else
		{
			 var frame = findFrame(getTopWindow(),"detailsDisplay");
			 frame.location.href = frame.location.href;
		}
		
	}
	function refreshLibraires()
	{
		this.parent.location.href=this.parent.location.href;
		
	}
	function alertMessageAndCloseWindow(message,isOneSearchEnabled)
	{
		if(("FALSE" == isOneSearchEnabled) || ("false" == isOneSearchEnabled))
	{
		alert(message);
		getTopWindow().close();

	     }
		else
		{
			alert(message);
		}
	}
	function preProcessAddDocumentsToLibrary(objectid)
	{
		var submitURL="../common/emxFullSearch.jsp?field=TYPES=type_DocumentFamily:CURRENT=policy_ContainerRev2.state_Approved&table=LCClassificationList&submitURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentLibrary:addDocumentsToDocumentFamilyFromTable&selection=multiple";
		submitURL+="&documentIds=";
		submitURL+= objectid
		showModalDialog(submitURL,250,250,true);
		
	}
function connectReferenceDocumentWithCategory(strObjectID,strSelectedIds)
	{
		var submitURL="../common/emxForm.jsp?form=DCLReferenceDocumentCategoryForm&mode=edit&postProcessURL=../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLAdminActions:connectReferenceDocument&validateToken=false&formHeader=enoDocumentControl.ReferenceDocumentCategorization&suiteKey=DocumentControl&StringResourceFileId=enoDocumentControlStringResource&SuiteDirectory=documentcontrol&objectId="+strObjectID+"&selectedIds="+strSelectedIds;
	getTopWindow().showSlideInDialog(submitURL, true);

	}
	
	function connectReferenceDocumentWithCategoryPostRefresh(strObjectID,strSelectedIds)
	{
			var contentFrame = findFrame(getTopWindow(), "DCLReferenceDocument");
			if(!contentFrame){
                contentFrame=findFrame(getTopWindow(),"content");
			}
			getTopWindow().closeSlideInDialog();
			contentFrame.location.href=contentFrame.location.href;


	}
	
	function refreshFileStructureView(rowId,frameName) 
	{
		var rowIds = rowId.split("::");
		var viewFrame= findFrame(getTopWindow(), frameName);
		//var i;
		//var pIds = new Array();
		//for(i = 0 ; i < rowIds.length ; i++) {
		//	var pId = viewFrame.emxEditableTable.getParentRowId(rowIds[i].split("|")[3]);
			//use seperate loop contains method to support ie < 9
		//	if(!(pIds.indexOf(pId) > -1)) {
		//		pIds.push(pId);
		///	}
		//}
		//for(i = 0 ; i < pIds.length ; i++) {
		//	var nRow = emxUICore.selectSingleNode(viewFrame.oXML, "/mxRoot/rows//r[@id = '" + pIds[i] + "']");
		//	nRow.setAttribute("expand", false);
		//	nRow.setAttribute("expandedLevels", null);
		//	viewFrame.emxEditableTable.expand([pIds[i]], "1");
		//}
		//for(i = 0 ; i < rowIds.length ; i++) {
		//	var nRow = emxUICore.selectSingleNode(viewFrame.oXML, "/mxRoot/rows//r[@o = '" + rowIds[i].split("|")[1] + "']");
	//		viewFrame.emxEditableTable.select([nRow.getAttribute("id")]);
	//	}
	//	viewFrame.rebuildView();
	viewFrame.location.href=viewFrame.location.href;

//this.parent.emxEditableTable.refreshStructure();
//this.parent.sortTable(2);
//this.parent.sortTable(2);
//this.parent.emxEditableTable.refreshStructure("FileSequence","decending");
//this.parent.emxEditableTable.refreshStructureWithOutSort();
//viewFrame.refreshStructureTree();

//this.parent.RefreshView();
//this.parent.rebuildView();
		//this.parent.reloadSBForSort("FileSequence","decending");
		//viewFrame.rebuildView();

	}
	
	</script>

