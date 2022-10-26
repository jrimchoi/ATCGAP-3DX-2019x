<%@page import="com.dassault_systemes.enovia.lsa.qic.QICException"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="com.matrixone.fcs.common.TransportUtil"%>
<%@page import="matrix.util.StringList"%>
<%@page import="com.dassault_systemes.enovia.lsa.Helper"%>
<%@include file = "../emxUICommonAppInclude.inc"%>
<%!
       private String getEncodedI18String(Context context, String key) throws QICException {
              try {
                     return XSSUtil.encodeForJavaScript(context,Helper.getI18NString(context, Helper.StringResource.QIC, key));
              } catch (Exception e) {
                     throw new QICException(e);
              }
       }
%> 

<script type="text/javascript" language="javascript">


function refreshOpenerWindow()
{
	window.parent.location.href = window.parent.location.href;	
}

function refreshOpener() { 	
    getTopWindow().getWindowOpener().location.href = getTopWindow().getWindowOpener().location.href;
    getTopWindow().window.closeWindow();
}

function refreshTablePage() {
	getTopWindow().refreshTablePage();
}

function showErrorMessage(message) {   
	alert(message);
	window.parent.location.href = window.parent.location.href; 
}

function showErrorMessageAndCloseParentWindow(message) {   
	alert(message);
	getTopWindow().window.closeWindow();
}


function actionRefreshCAPARequestWorkQueue() {
var CPRSummaryFrame1 = findFrame(getTopWindow(), "QICCPRSummaryDisplay");
CPRSummaryFrame1.location.href = CPRSummaryFrame1.location.href;
}

function actionRefreshAfterFullSearch() {
	getTopWindow().window.closeWindow();
	getTopWindow().getWindowOpener().location.href = getTopWindow().getWindowOpener().location.href;
}

function actionRefreshCAPARequest() {
	var contentFrame = findFrame(getTopWindow(), "content");
	contentFrame.location.href = contentFrame.location.href;
}

function alertForCAPARequestChangeOwnerAllStateNotUnique() {
	/*XSS OK*/ var message = "<%=getEncodedI18String(context,"QIC.CAPARequest.ChangeOwner.AllCAPARequestStateNotUniqueError")%>";
    alert(message);
    getTopWindow().window.closeWindow();
}

function alertForAllDataSourcesTypeNotUnique() {
	/*XSS OK*/ var message = "<%=getEncodedI18String(context,"QIC.DataSource.AllObjectsNotOfUniqueTypeError")%>";
    alert(message);
    getTopWindow().window.closeWindow();
}

function alertForAcceptCAPARequestsUserNotQualityManager() {
	/*XSS OK*/ var message = "<%=getEncodedI18String(context,"QIC.CAPARequest.Accept.LoggedInUserNotQualityMangerError")%>";
    alert(message);
    getTopWindow().window.closeWindow();
}

function actionCommandQICCPRSummaryAssociateCAPA(CAPARequestIds) {
	var strURL =  "../common/emxFullSearch.jsp?field=TYPES=type_CAPAProject:CURRENT=policy_ProjectSpace.state_Create,policy_ProjectSpace.state_Assign,policy_ProjectSpace.state_Active,policy_ProjectSpace.state_Review&table=QICCAPAChooserDetails&excludeOIDprogram=com.dassault_systemes.enovia.lsa.qic.services.ui.CAPARequest:getExcludedCAPAOIDCAPARequest&selection=single&submitAction=refreshCaller&submitURL=../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.qic.services.ui.Admin:actionAssociateCAPARequestsToCAPA&CAPARequestIds="+CAPARequestIds+"&suiteKey=LQICAPA&targetLocation=popup&formInclusionList=QIC_CAPA_TYPE,NAME,QIC_CAPA_SEVERITY,QIC_CAPA_PHASE,QIC_CAPA_DUE_DATE,QIC_CAPA_COMPLETION_DATE,QIC_CAPA_PROGRAM&HelpMarker=emxhelpREQassociate";
	showModalDialog(strURL);
}

function actionCommandQICCPRSummaryCreateCAPA(CAPARequestIds) {
	var submitURL = "../common/emxCreate.jsp?nameField=autoName&form=QICCreateCAPA&type=type_CAPAProject&policy=policy_ProjectSpace&mode=edit&formHeader=QIC.CAPA.Command.Label&createJPO=com.dassault_systemes.enovia.lsa.qic.services.ui.CAPA:createCAPA&preProcessJavaScript=hideCopyOptionsForCopyFromExistingCAPA&submitAction=treeContent&selection=multiple&CAPARequestIds="+CAPARequestIds+"&targetLocation=slidein&suiteKey=LQICAPA&HelpMarker=emxhelpCAPAcreate";
	getTopWindow().showSlideInDialog(submitURL, "true");
}

function actionChangeCAPARequestsOwner(CAPARequestIds,parentObjectId) {
	var submitURL = "../common/emxForm.jsp?form=QICCPRChangeOwnership&formHeader=QIC.Common.ChangeOwnership.Header&submitAction=doNothing&mode=edit&parentOID="+parentObjectId+"&postProcessURL=../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.qic.services.ui.MyCAPARequestWorkQueue:actionChangeCAPARequestsOwner&suiteKey=LQICAPA&HelpMarker=emxhelpREQtransfer&CAPARequestIds="+CAPARequestIds;
	getTopWindow().showSlideInDialog(submitURL, "true");
}

function actionSubmitCAPARequests(CAPARequestIds) {
	var submitURL = "../common/emxForm.jsp?form=QICCPRSubmit&formHeader=QIC.Command.QICCPRSummarySubmit.Label&mode=edit&postProcessURL=../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.qic.services.ui.MyCAPARequestWorkQueue:actionSubmitCAPARequests&suiteKey=LQICAPA&&HelpMarker=emxhelpREQsubmit&CAPARequestIds="+CAPARequestIds;
	getTopWindow().showSlideInDialog(submitURL, "true");
}

function actionNeedsInfoForCAPARequests(CAPARequestIds) {
	var submitURL = "../common/emxForm.jsp?form=QICCPRNeedsInformation&formHeader=QIC.Command.QICCPRSummaryNeedsInformation.Label&mode=edit&postProcessURL=../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.qic.services.ui.MyCAPARequestWorkQueue:actionNeedsInfoForCAPARequests&suiteKey=LQICAPA&HelpMarker=emxhelpREQinformation&CAPARequestIds="+CAPARequestIds;
	getTopWindow().showSlideInDialog(submitURL, "true");
}

function actionSetDuplicateCAPARequests(CAPARequestIds) {
	 var strURL = "../common/emxFullSearch.jsp?field=TYPES=type_CAPARequest&table=QICRelatedCAPASummary&excludeOIDprogram=com.dassault_systemes.enovia.lsa.qic.services.ui.CAPARequest:getExcludedMasterCAPARequestOIDCAPARequest&showInitialResults=true&selection=single&submitAction=refreshCaller&submitURL=../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.qic.services.ui.MyCAPARequestWorkQueue:actionSetDuplicateCAPARequests&suiteKey=LQICAPA&HelpMarker=emxhelpREQduplicate&CAPARequestIds="+CAPARequestIds;
	 showModalDialog(strURL);
}

function createAndConnectCAPARequest(DataSourceIds) {
	var submitURL = "../common/emxCreate.jsp?nameField=autoName&form=type_CreateCAPARequest&type=type_CAPARequest&policy=policy_CAPARequest&formHeader=QIC.Form.type_CreateCAPARequest.Header&mode=edit&createJPO=com.dassault_systemes.enovia.lsa.qic.services.ui.Admin:createAndConnectCAPARequest&submitAction=treeContent&showApply=true&HelpMarker=emxhelpREQcreate&suiteKey=LQICAPA&DataSourceIds="+DataSourceIds;
	getTopWindow().showSlideInDialog(submitURL, "true");
}

function actionAddExistingDataSourceToExistingCAPA(DataSourceIds) {
	var strURL = "../common/emxFullSearch.jsp?field=TYPES=type_CAPAProject,type_CAPARequest&table=QICRelatedCAPASummary&form=QICRelatedCAPASearch&selection=multiple&excludeOIDprogram=com.dassault_systemes.enovia.lsa.qic.services.ui.CAPAIntegration:getExcludedCAPAOIDDataSource&submitURL=../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.qic.services.ui.Admin:actionAddDataSourceToExistingCAPA&suiteKey=LQICAPA&HelpMarker=emxhelpREQassociate&DataSourceIds="+DataSourceIds;
	showModalDialog(strURL);
}

function actionAddChildCause(ParentCauseId,check) {
	if(check == 'true'){
		/* XSS OK */var copyTask = confirm("<%=getEncodedI18String(context,"LQICAPA.Message.TaskFloatToChildRootCause")%>");
		if (copyTask == true) {
			var submitURL = "../common/emxCreate.jsp?nameField=autoName&form=type_CreateDefectCause&type=type_DefectCause&policy=policy_CauseAnalysis&formHeader=QIC.Form.type_CreateDefectCause.Header&mode=edit&preProcessJavaScript=preProcessCreateDefectCause&createJPO=com.dassault_systemes.enovia.lsa.qic.services.ui.Admin:actionCreateAndConnectChildCause&submitAction=doNothing&postProcessURL=../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.qic.services.ui.CAPARootCauseAnalysis:actionPostAddChildCause&showPageURLIcon=false&findMxLink=false&showApply=true&suiteKey=LQICAPA&HelpMarker=emxhelpCAUSEcreate&ParentCauseId="+ParentCauseId;
			getTopWindow().showSlideInDialog(submitURL, "true");
		}
	}else{
		var submitURL = "../common/emxCreate.jsp?nameField=autoName&form=type_CreateDefectCause&type=type_DefectCause&policy=policy_CauseAnalysis&formHeader=QIC.Form.type_CreateDefectCause.Header&mode=edit&preProcessJavaScript=preProcessCreateDefectCause&createJPO=com.dassault_systemes.enovia.lsa.qic.services.ui.Admin:actionCreateAndConnectChildCause&submitAction=doNothing&postProcessURL=../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.qic.services.ui.CAPARootCauseAnalysis:actionPostAddChildCause&showPageURLIcon=false&findMxLink=false&showApply=true&suiteKey=LQICAPA&HelpMarker=emxhelpCAUSEcreate&ParentCauseId="+ParentCauseId;
		getTopWindow().showSlideInDialog(submitURL, "true");
	}
}

function alertForAddChildCauseOperationFailed() {
	/*XSS OK*/ var message = "<%=getEncodedI18String(context,"QIC.CAPARootCauseAnalysis.OnlyOwnerCanAddChildCauseError")%>";
    alert(message);
}

function alertForAddChildCause() {
	/*XSS OK*/ var message = "<%=getEncodedI18String(context,"QIC.CAPARootCauseAnalysis.CanNotConnectChildCauseIfParentCauseIsAddressedError")%>";
    alert(message);
}

function actionChangeCauseOwner(CauseIds) {
	var submitURL = "../common/emxForm.jsp?form=QICRCAChangeOwnership&formHeader=QIC.Common.ChangeOwnership.Header&mode=edit&postProcessURL=../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.qic.services.ui.CAPARootCauseAnalysis:actionChangeCauseOwner&suiteKey=LQICAPA&parentOID="+CauseIds+"&CauseIds="+CauseIds;
	getTopWindow().showSlideInDialog(submitURL, "true");
}

function actionRefreshCauseWorkQueue() {
	var RCASummaryFrame = findFrame(getTopWindow(), "QICRCASummaryDisplay");
	RCASummaryFrame.location.href = RCASummaryFrame.location.href;
}

function actionAppendQuestionObjectIDs(TemplateId) {
	getTopWindow().location.href = "../common/emxTableEdit.jsp?program=com.dassault_systemes.enovia.lsa.qic.services.ui.CAPA:getTableQICCreateCAPAColumnQuestions&table=QICCAPAQuestionTable&header=QIC.Table.QICCAPAQuestionTable.TemplateQuestions.Header&StringResourceFileId=LQICAPAStringResource&postProcessURL=../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.qic.services.ui.CAPA:addAnswer&suiteKey=LQICAPA&submitAction=refreshCaller&findMxLink=false&massUpdate=false&templateId="+TemplateId;
}

function actionExtractQuestionAnswers(answerString) {
	var QICCreateCAPA = getTopWindow().getWindowOpener();
	var vTemplateQuestion = QICCreateCAPA.document.getElementsByName("TemplateQuestionDisplay")[0];
	vTemplateQuestion.value=answerString;
}

function actionCommandQICCAPADataSourcesAddExisting(searchTypes, capaId) {
	var strURL = "../common/emxFullSearch.jsp?field=TYPES="+searchTypes+"&table=QICDataSourcesChooserDetails&selection=multiple&submitAction=refreshCaller&excludeOIDprogram=com.dassault_systemes.enovia.lsa.qic.services.ui.CAPA:getExcludedDataSourceOIDCAPA&submitURL=../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.qic.services.ui.Admin:actionAddExistingDataSourcesToCAPA&StringResourceFileId=LQICAPAStringResource&suiteKey=LQICAPA&objectId="+capaId;
	showModalDialog(strURL);
}

function actionCommandQICCPRDataSourcesAddExisting(searchTypes, capaId) {
	 var strURL = "../common/emxFullSearch.jsp?field=TYPES="+searchTypes+"&table=QICDataSourcesChooserDetails&selection=multiple&excludeOIDprogram=com.dassault_systemes.enovia.lsa.qic.services.ui.CAPARequest:getExcludedDataSourceOIDCAPARequest&submitURL=../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.qic.services.ui.Admin:actionAddExistingDataSourcesToCAPARequest&suiteKey=LQICAPA&objectId="+capaId;
	 showModalDialog(strURL); 
}

function actionRefreshCAPARootCause() {
	var contentFrame = findFrame(getTopWindow(), "content");
	contentFrame.location.href = contentFrame.location.href;
}

function alertCAPATemplateClonedSuccessfully(message) {   
	alert(message);
	window.parent.location.href = window.parent.location.href; 
}

function setStructureBrowserCellValue(fieldName , actualValue, displayValue,objectId) {
    var targetWindow = null;
    if(getTopWindow().getWindowOpener() == null) {
        targetWindow = window.parent;
    } else {
        targetWindow = getTopWindow().getWindowOpener();
    }
    var fieldNameDisplay = fieldName.split("_")[0];
    
	var vfieldNameActual = targetWindow.document.forms[0][fieldName];
	var vfieldNameDisplay = targetWindow.document.forms[0][fieldNameDisplay];
	var vfieldNameOID = targetWindow.document.forms[0][fieldName + "OID"];

	if (vfieldNameActual==null && vfieldNameDisplay==null) {
		vfieldNameActual=targetWindow.document.getElementById(fieldName);
		vfieldNameDisplay=targetWindow.document.getElementById(fieldNameDisplay);
		vfieldNameOID=targetWindow.document.getElementById(fieldName + "OID");
	}

	if (vfieldNameActual==null && vfieldNameDisplay==null) {
		vfieldNameActual=targetWindow.document.getElementsByName(fieldName)[0];
		vfieldNameDisplay=targetWindow.document.getElementsByName(fieldNameDisplay)[0];
		vfieldNameOID=targetWindow.document.getElementsByName(fieldName + "OID")[0];
	}
	if (vfieldNameActual==null && vfieldNameDisplay==null) {
	     var elem = targetWindow.document.getElementsByTagName("input");
	     var att;
	     var iarr;
	     for(i = 0,iarr = 0; i < elem.length; i++) {
	        att = elem[i].getAttribute("name");
	        if(fieldNameDisplay == att) {
	            vfieldNameDisplay = elem[i];
	            iarr++;
	        }
	        if(fieldName == att) {
	            vfieldNameActual = elem[i];
	            iarr++;
	        }
	        if(iarr == 2) {
	            break;
	        }
	    }
	}
	vfieldNameDisplay.value = displayValue;
	vfieldNameActual.value = actualValue;

	if(vfieldNameOID != null) {
		vfieldNameOID.value = actualValue;
	} 

	if(getTopWindow().getWindowOpener() != null) {
		getTopWindow().closeWindow();
	} 
}

function actionRefreshDataSourceFrameAndCloseTopWindow(frameName) {
	var frame = findFrame(getTopWindow().getWindowOpener().parent.parent,frameName);
    if(frame==null || frame =='undefined'){
    	frame= findFrame(getTopWindow().getWindowOpener().getTopWindow(), "detailsDisplay");
    }
    if(frame==null || frame =='undefined'){
    	frame= findFrame(getTopWindow().getWindowOpener().getTopWindow(), "content");
    }
    if(frame.editableTable){
    	frame.editableTable.loadData();
    	frame.RefreshTableHeaders();
    	frame.rebuildView();
    }else{
    	frame.location.href = frame.location.href;
    }
    getTopWindow().closeWindow();
}
	
function actionRefreshCPRSummaryFrameAndCloseTopWindow(frameName) {	
	 var summaryViewFrame = findFrame(getTopWindow().getWindowOpener().parent.parent,frameName);
	 getTopWindow().closeWindow();
	 summaryViewFrame.location.href = summaryViewFrame.location.href;
	}


</script>
