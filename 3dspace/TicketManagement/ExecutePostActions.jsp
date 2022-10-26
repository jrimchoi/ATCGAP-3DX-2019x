<%@page import="matrix.util.StringList"%>
<%@include file = "../emxUICommonAppInclude.inc"%>
<%@page import="com.dassault_systemes.enovia.lsa.Helper,com.dassault_systemes.enovia.lsa.ticket.TicketException"%>

<%!
	private String getI18NString(Context context, String key) throws TicketException {
		try {
			return XSSUtil.encodeForJavaScript(context, Helper.getI18NString(context, Helper.StringResource.TicketMgmt, key));
		} catch (Exception e) {
			throw new TicketException(e);
		}
	}
%> 

<script type="text/javascript" language="javascript">

function actionRefreshComplaintTicket() {
	var contentFrame = findFrame(getTopWindow(), "content");
	contentFrame.location.href = contentFrame.location.href;
}

function actionRefreshComplaintTicketProperties() {
	var contentFrame = findFrame(getTopWindow(), "PQCComplaintPropertiesChannel");
	contentFrame.location.href = contentFrame.location.href;
}

function actionRefreshComplaintPropertiesForInvalid()
{
	
	var contentFrame = findFrame(getTopWindow(), "content");
	contentFrame.location.href = contentFrame.location.href;
	getTopWindow().closeShortcutDialog();
}

function actionShowAlertMessage(errorMessage)
{
	alert(errorMessage);
}

function actionRefreshMyComplaintTicketWorkQueue() {
	getTopWindow().refreshTablePage();
}

function alertForWrongTypeSelection() {
	var message = "<%=getI18NString(context,"TicketMgmt.Message.Error.CanNotSelect")%>"; //XSSOK
    alert(message);
}

function alertForTransferComplaintOwnership() {
	var message = "<%=getI18NString(context, "TicketMgmt.Message.Error.TransferComplaintOwnership")%>"; //XSSOK
	alert(message);
    getTopWindow().window.closeWindow();
}

function alertForTransferOwnershipUnassignedFilter() {
	var message = "<%=getI18NString(context, "TicketMgmt.Message.Error.FirstAccept")%>"; //XSSOK
    alert(message);
    getTopWindow().window.closeWindow();
}

function alertForTransferOwnershipNotOwner() {
	var message = "<%=getI18NString(context, "TicketMgmt.Message.Error.NotOwner")%>"; //XSSOK
    alert(message);
    getTopWindow().window.closeWindow();
}

function actionAddAssigneesToComplaintTickets(cptIds) {
	var parameters = new Object();
	parameters.field="TYPES=type_Person:CURRENT=policy_Person.state_Active:ROLE=role_ComplaintInvestigator,role_QualityManager";
	parameters.excludeOIDprogram="com.dassault_systemes.enovia.lsa.ticket.services.ui.ComplaintTicket:excludeAssigneesConnectedToComplaintTickets";
	parameters.table="AEFPersonChooserDetails";
	parameters.showInitialResults="true";
	parameters.submitURL="../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.ticket.services.ui.ComplaintTicket:actionAddExistingAssigneesToComplaintTicket";
	parameters.suiteKey="TicketManagement";
	parameters.selection="multiple";
	parameters.cptIds=cptIds;
	
	showSearchDialog(parameters);
}

function actionRemoveAssignee() {
	getTopWindow().refreshTablePage();
}

function refreshOpener() { 	
    getTopWindow().getWindowOpener().location.href = getTopWindow().getWindowOpener().location.href;
    getTopWindow().window.closeWindow();
}
function addExistingProductEvaluation(strDerivedEventIds,strParentEventIds)
{
	var parameters = new Object();
	parameters.field="TYPES=type_ComplaintProductEvaluation:CURRENT=policy_ComplaintProductEvaluation.state_Complete";
	parameters.table="LPQProductEvaluationSearchTable";
	parameters.showInitialResults="true";
	parameters.submitAction="refreshCaller";
	parameters.submitURL="../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.complaint.services.ui.MyComplaintsWorkQueue:actionAddExistingEvaluation";
	parameters.suiteKey="Complaints";
	parameters.selection="single";
	parameters.derivedEventIds=strDerivedEventIds;
	parameters.parentEventIds=strParentEventIds;
		debugger;
	showSearchDialog(parameters);
}
function alertForConnectedProductEvaluation(){
	alert("<%=getI18NString(context,"LPQ.Complaint.Message.Error.ConnectedProductEvaluation")%>"); //XSSOK
}

function submitAddProductEvaluation() {
	getTopWindow().window.closeWindow();
	var contentFrame = findFrame(getTopWindow(), "content");
	contentFrame.location.href = contentFrame.location.href;
}

function actionRefreshComplaintProductEvaluationForm()
{
	var contentFrame = findFrame(getTopWindow(), "detailsDisplay");
	if(contentFrame==null||contentFrame==undefined)
	{
		contentFrame = findFrame(getTopWindow(), "content");
	}
	contentFrame.location.href = contentFrame.location.href;	
}

function actionRefreshComplaintProductEvaluationTable()
{	
	 getTopWindow().refreshTablePage();
}


function actionAddExistingAssigneesToComplaintTicket()
{	
	debugger;
	var frameName = getTopWindow().openerFindFrame(getTopWindow(),"PQCCPTMyComplaints")  || getTopWindow().openerFindFrame(getTopWindow(),"PQCESRMyEquipmentServiceRequests")  || 
	 getTopWindow().openerFindFrame(getTopWindow(),"PQCINQMyInquiries")  || getTopWindow().openerFindFrame(getTopWindow(),"PQCNCRMyNCRDisp")  || '';
	
	var contentFrame = getTopWindow().openerFindFrame(getTopWindow(),	"PQCCPTMyComplaints");
	if(!contentFrame.hasOwnProperty("refreshSBTable")){
		contentFrame=null;
	}
	if(contentFrame == null || contentFrame == undefined )
	{
		contentFrame = getTopWindow().openerFindFrame(getTopWindow(),	"PQCESRMyEquipmentServiceRequests");
	}
	if(!contentFrame.hasOwnProperty("refreshSBTable")){
		contentFrame=null;
	}
	if(contentFrame == null || contentFrame == undefined)
	{
		contentFrame = getTopWindow().openerFindFrame(getTopWindow(),	"PQCINQMyInquiries");
	}
	if(!contentFrame.hasOwnProperty("refreshSBTable")){
		contentFrame=null;
	}
	if(contentFrame == null || contentFrame == undefined)
	{
		contentFrame = getTopWindow().openerFindFrame(getTopWindow(),	"PQCNCRMyNCRDisp");
	}
	if(!contentFrame.hasOwnProperty("refreshSBTable")){
		contentFrame=null;
	}
	contentFrame.refreshSBTable();
	getTopWindow().window.closeWindow();
}

function actionRefreshMyTicketsWorkQueueAfterCreate(frame, command, value){
	var frame = getTopWindow().openerFindFrame(getTopWindow(),	frame);
	var href = frame.location.href;
	
	var regex = new RegExp("&"+command+"[^&]*");
	while(href.match(regex)){
		href = href.replace(regex, "");
	}
	
	if(value==null||value=="null"||value==""){
		frame.location.href = href;
	}else{
		frame.location.href = href+"&"+command+"="+value;
	}
}
</script>
