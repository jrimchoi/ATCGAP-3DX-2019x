<%@page import="matrix.util.StringList"%>
<%@include file = "../emxUICommonAppInclude.inc"%>
<%@page import="com.dassault_systemes.enovia.lsa.Helper, com.dassault_systemes.enovia.lsa.esrinquiry.ESRInquiryException"%>

<%!
	private String getI18NString(Context context, String key) throws ESRInquiryException {
		try {
			return XSSUtil.encodeForJavaScript(context, Helper.getI18NString(context, Helper.StringResource.COLS, key));
		} catch (Exception e) {
			throw new ESRInquiryException(e);
		}
	}
%> 

<script type="text/javascript" language="javascript">

function addStandardXMLCodes(objectId,strCodes,CodeDisplay,CodeActual)
{
	var displayElem=getTopWindow().getWindowOpener().document.getElementsByName(CodeDisplay);
	var actualElem=getTopWindow().getWindowOpener().document.getElementsByName(CodeActual);
	var oidElem=getTopWindow().getWindowOpener().document.getElementsByName(CodeActual.concat("OID"));
	actualElem[0].value=strCodes;
	displayElem[0].value=strCodes;
	oidElem[0].value=strCodes;
	getTopWindow().window.closeWindow();
}

function actionCompleteReturn() {
	var PQCReturnSummaryFrame = findFrame(getTopWindow(), "PQCReturnSummary");
	PQCReturnSummaryFrame.location.href = PQCReturnSummaryFrame.location.href;
}

function actionCompleteFulfillment() {
	var PQCFulfillmentSummaryFrame = findFrame(getTopWindow(), "PQCFulfillmentSummary");
	PQCFulfillmentSummaryFrame.location.href = PQCFulfillmentSummaryFrame.location.href;
}

function actionCompletePropertyReturn() {
	var PQCReturnSummaryFrame = findFrame(getTopWindow().getWindowOpener().parent, "PQCReturnSummary");
	PQCReturnSummaryFrame.location.href = PQCReturnSummaryFrame.location.href;
	var contentFrame = findFrame(getTopWindow(), "content");
	contentFrame.location.href = contentFrame.location.href;
}
function actionCompletePropertyFulfillment() {
	var PQCFulfillmentSummaryFrame = findFrame(getTopWindow().getWindowOpener().parent, "PQCFulfillmentSummary");
	PQCFulfillmentSummaryFrame.location.href = PQCFulfillmentSummaryFrame.location.href;
	var contentFrame = findFrame(getTopWindow(), "content");
	contentFrame.location.href = contentFrame.location.href;
}

function setFormType_PQCFulfillmentCreateFieldNewContactLink(objectID,objectName) {
	var targetWindow = null;
	targetWindow=getTopWindow().getWindowOpener();
	targetWindow.document.forms[0]["CustomerDetailExistingDisplay"].value=objectName;
	targetWindow.document.forms[0]["CustomerDetailExisting"].value=objectName;
	targetWindow.document.forms[0]["CustomerDetailExistingOID"].value =objectID;
}
	/**
	 * Alerts for Primary event selection
	 */
function alertForMoreEventSelection() {
		var message ="<%=getI18NString(context, "FTComplaints.Message.SetPrimaryEventSelection")%>"; //XSSOK
    alert(message);
}

/**
 * Alerts for already Primary event selection
 */
function alertForAlreadyPrimaryEventSelection() {
	var message = "<%=getI18NString(context, "FTComplaints.Message.AlreadyPrimaryEventSelection")%>"; //XSSOK
    alert(message);
}
/**
 * Alerts for wrong selection
 */
function alertForWrongTypeSelection() {
	var message = "<%=getI18NString(context,"PQC.Complaint.Message.Error.CanNotSelect")%>"; //XSSOK
    alert(message);
}
function alertForPrimaryEventSelection() {
	var message = "<%=getI18NString(context,"PQC.Event.Delete.CannotDeletePrimaryEvent")%>"; //XSSOK
    alert(message);
}

function refreshOpenerWindow()
{
    window.parent.location.href = window.parent.location.href;
}

function alertProductNotSelected()
{
	var message = "<%=getI18NString(context,"PQC.Message.PleaseSelectAEvent")%>"; //XSSOK
    alert(message);
	getTopWindow().window.closeWindow();
}

function addProductModelToEventPostAction()
{
	var PQCCPTEventDisplayFrame = findFrame(getTopWindow().getWindowOpener().parent, "PQCCPTEventDisplay");
	PQCCPTEventDisplayFrame.location.href = PQCCPTEventDisplayFrame.location.href;
	getTopWindow().window.closeWindow();
}
  
function complaintInvestigationForm(objectId)
{
		var url = "../common/emxForm.jsp?form=PQCCPTComplaintInvestigation&formHeader=FTComplaints.Investigation.Header&toolbar=PQCCPTComplaintInvestigationToolbar&editLink=true&mode=view&preProcessJPO=com.dassault_systemes.enovia.lsa.complaint.services.ui.ComplaintInvestigation:preProcessCheckAccessOnFields&postProcessJPO=com.dassault_systemes.enovia.lsa.complaint.services.ui.ComplaintInvestigation:updateFormPQCCPTComplaintInvestigationDetails&suiteKey=Complaints&objectId="+objectId;
		var contentFrame = findFrame(getTopWindow(), "PQCCPTInvestigation");
		contentFrame.location.href = url;
}
function complaintInvestigationPromote()
{
	var contentFrame = findFrame(getTopWindow(), "content");
	contentFrame.location.href = contentFrame.location.href;
}

function refreshOpener() { 	
    getTopWindow().getWindowOpener().location.href = getTopWindow().getWindowOpener().location.href;
    getTopWindow().window.closeWindow();
}

function alertForCompleteInvestigation() {
	var message = "<%=getI18NString(context, "PQC.Complaint.Message.Error.CompleteInvestigation")%>"; //XSSOK
    alert(message);
}



/**
 *Function to submit the edit URL for Complaint properties
 *Argument 1 : arrFlag containing Complaint object Id,isOwnerStatus,isOriginatorStatus,hasQMRoleStatus,hasCIRoleStatus
 */
function submitComplaintProperties(complaintId,flag1,flag2,flag3,flag4,flag5){
	var flag =[flag1,flag2,flag3,flag4,flag5];
	var url ="../common/emxForm.jsp?mode=edit&form=type_ComplaintEdit&toolbar=PQCCPTBasicInfoToolbar&suiteKey=Complaints&HelpMarker=editComplaintProperties&preProcessJPO=com.dassault_systemes.enovia.lsa.complaint.services.ui.Complaint:preProcessCheckAccessOnComplaintPropertyFields&isSelfTargeted=true&objectId="+complaintId+"&flag="+flag;
	var contentFrame = findFrame(getTopWindow(), "PQCCPTPropertiesPage");
	contentFrame.location.href = url;	
}
function actionShowAlertMessage(errorMessage)
{
	alert(errorMessage);
}

function actionRefreshMyEquipmentServiceRequest() {
	getTopWindow().refreshTablePage();
}

function actionRefreshMyInquiry() {
	getTopWindow().refreshTablePage();
}

function actionRefreshMyComplaint() {
	getTopWindow().refreshTablePage();
}

function openComplaintTicketPowerView(objectId) {
	var url = "../common/emxTree.jsp?objectId="+objectId;
	var contentFrame = findFrame(getTopWindow(), "content");
	contentFrame.location.href = url;
}

function alertForDeleteRootEvent() {
	var message = "<%=getI18NString(context, "PQC.Event.Delete.CannotDeleteRootEvent")%>"; //XSSOK
    alert(message);
}

function showContactNameFormtype_CreateContact(strFieldName, strDisplayValue, strActualValue) {
	var pathname=getTopWindow().location.pathname;
	var doc = null;
	var flag = false;
	if(-1!=pathname.search("emxCreate.jsp")){
		doc = getTopWindow().document;
	}else{
		flag = true;
		doc = getTopWindow().getWindowOpener().document
	}
	var contactFieldNameActual = doc.forms[0][strFieldName];
	var contactFieldNameDisplay = doc.forms[0][strFieldName+"Display"];
	var contactFieldNameOID = doc.forms[0][strFieldName+"OID"];
	contactFieldNameDisplay.value = strDisplayValue;
	contactFieldNameActual.value = strActualValue;
	contactFieldNameOID.value = strActualValue;
	if(flag){
		getTopWindow().closeWindow();
	}
}
function showContactNameFormtype_CreateContact1(strFieldName, strDisplayValue, strActualValue) {
	var contactFieldNameActual = getTopWindow().document.forms[0][strFieldName];
	var contactFieldNameDisplay = getTopWindow().document.forms[0][strFieldName+"Display"];
	var contactFieldNameOID = getTopWindow().document.forms[0][strFieldName+"OID"];
	contactFieldNameDisplay.value = strDisplayValue;
	contactFieldNameActual.value = strActualValue;
	contactFieldNameOID.value = strActualValue;
}
	</script>
