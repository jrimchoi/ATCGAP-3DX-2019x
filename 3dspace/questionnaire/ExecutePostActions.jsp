<%@include file="../common/emxNavigatorInclude.inc"%>

<%@page import="com.matrixone.apps.domain.util.XSSUtil"%>
<script src="../common/scripts/jquery-latest.js"></script>

<script type="text/javascript" language="javascript">
//method to refresh structure after move up or move down operation
function refreshQuestionnaireView(rowId,frameName) {
	var rowIds = rowId.split("::");
	var viewFrame= findFrame(getTopWindow(), frameName);
	var i;
	var pIds = new Array();
	for(i = 0 ; i < rowIds.length ; i++) {
		var pId = viewFrame.emxEditableTable.getParentRowId(rowIds[i].split("|")[3]);
		//use seperate loop contains method to support ie < 9
		if(!(pIds.indexOf(pId) > -1)) {
			pIds.push(pId);
		}
	}
	for(i = 0 ; i < pIds.length ; i++) {
		var nRow = emxUICore.selectSingleNode(viewFrame.oXML, "/mxRoot/rows//r[@id = '" + pIds[i] + "']");
        nRow.setAttribute("expand", false);
        nRow.setAttribute("expandedLevels", null);
		viewFrame.emxEditableTable.expand([pIds[i]], "1");
	}
	for(i = 0 ; i < rowIds.length ; i++) {
		var nRow = emxUICore.selectSingleNode(viewFrame.oXML, "/mxRoot/rows//r[@r = '" + rowIds[i].split("|")[0] + "']");
		viewFrame.emxEditableTable.select([nRow.getAttribute("id")]);
	}
	viewFrame.rebuildView();
}
function alertMessage(msg) {
	alert(msg);			
}
function refreshChangeTemplateFrame()
{
	var frame=findFrame(getTopWindow(), "ECMMyChangeTemplates");
	frame.location.href=frame.location.href;
}
function preProcessCopyExistingQuestions(type,questionIds,action,mode,rowLevels)
{

	var submitURL="../common/emxIndentedTable.jsp?program=ENOQuestionUI:getAllQuestions&type="+type;
	//var submitURL="../common/emxFullSearch.jsp?field=TYPES="+type;
	submitURL +="&table=QuestionCopyTable&selection=multiple&includeOIDprogram=ENOQuestionUI:getAllRelatedQuestion";
	submitURL +="&expandProgram=ENOQuestionUI:getTableQuestionCopyExpand&direction=from&submitURL=../questionnaire/enoQuestionnaireExecute.jsp?questionAction=ENOQuestionnaireAdminActions:copyExistingQuestions";
	submitURL +="&emxSuiteDirectory=questionnaire&suiteKey=Questionnaire&SuiteDirectory=questionnaire&StringResourceFileId=enoQuestionnaireStringResource";
	submitURL +="&header=enoQuestionnaire.Header.CopyExistingQuestions&sortColumnName=none&questionIds="+questionIds+"&configKey="+action;
	submitURL += "&formInclusionList=QUES_DESCRIPTION,QUES_CHANGE_TEMPLATE";
	submitURL+="&mode="+mode;
	submitURL+="&rowLevels="+rowLevels;
	 showModalDialog(submitURL,250,250,true);
	//window.open(submitURL,"","height=250, width=250");
	
}
function preProcessCopyImpactTemplateExistingQuestions(type,questionIds,objectId)
{

	var submitURL="../common/emxFullSearch.jsp?field=TYPES="+type;
	submitURL +="&table=QuestionImpactQuestionnaireCopyTable&selection=multiple&includeOIDprogram=ENOQuestionUI:getAllImpactTemplateRelatedQuestion";
	submitURL +="&submitURL=../questionnaire/enoQuestionnaireExecute.jsp?questionAction=ENOQuestionUI:copyExistingImpactTemplateQuestionnaire";
	submitURL +="&emxSuiteDirectory=questionnaire&suiteKey=Questionnaire&SuiteDirectory=questionnaire&StringResourceFileId=enoQuestionnaireStringResource";
	submitURL +="&header=enoQuestionnaire.Header.CopyExistingQuestions&questionIds="+questionIds+"&sortColumnName=none"+"&objectId="+objectId;

	 showModalDialog(submitURL,250,250,true);
	
}

function closeAndRefreshWindow()
{
	getTopWindow().parent.opener.parent.location.href=getTopWindow().parent.opener.parent.location.href;
	getTopWindow().close();
}

function closeAndRefreshWindowWithMarkup(strRowId)
{
	
	var frmQuestion=findFrame(getTopWindow().opener.getTopWindow(),"Questionnaire");
	if("" == frmQuestion || null == frmQuestion)
	{
		frmQuestion=findFrame(getTopWindow().opener.getTopWindow(),"QuestionConditionalAttribute");
	}
	frmQuestion.location.href=frmQuestion.location.href;
	// Code to dynamically refresh page after copy Existing but it doesnt work in IE
/*	var arrRows=strRowId.split("|");
	
	var frmQuestion=findFrame(getTopWindow().opener.getTopWindow(),"Questionnaire");
	for(var i=0;i<arrRows.length;i++)
	{
		var nRow = emxUICore.selectSingleNode(frmQuestion.oXML, "/mxRoot/rows//r[@id = '" + arrRows[i] + "']");
	
	    var expand = nRow.getAttribute("expand");
	    var expand = nRow.setAttribute("expand","true");
	
	    nRow.setAttribute("expand", false);
	    nRow.setAttribute("expandedLevels", null);
	    frmQuestion.emxEditableTable.select([nRow.id]);
	    frmQuestion.emxEditableTable.expand([nRow.id], "1",true);
}
	frmQuestion.emxEditableTable.unselect(["0"]);
	*/
	getTopWindow().close();
}

function addRowsDynamicallyInSB(xmlMessage, frameName) {
    var questionFrame = findFrame(getTopWindow().opener.getTopWindow(),frameName);
    if(questionFrame == null) {
    	questionFrame = findFrame(getTopWindow().opener.parent, frameName);
    	}
    else if(questionFrame == null) {
    	questionFrame = findFrame(getTopWindow().opener.opener.parent,frameName);
    }
    else if(questionFrame == null) {
    	questionFrame = findFrame(getTopWindow().opener.getTopWindow(),"detailsDisplay");
    }
    else if(questionFrame == null) {
    	questionFrame = findFrame(getTopWindow().opener.parent,"detailsDisplay");
    }
    questionFrame.emxEditableTable.addToSelected(xmlMessage);
    questionFrame.refreshStructureWithOutSort();
    getTopWindow().close();

    }

function printChildrenFrameStructure(objWindow, objThisFrame, strIndent,xmlMessage) {
    var strData = "";
    if (objWindow) {
        strData += "<br>" + strIndent;
        if (objWindow == objThisFrame) {
             strData += " * ";
        }
        strData += "[" + objWindow.name + "] [" + objWindow.location.href + "]";
			var objWindowName = objWindow.name;
              if(objWindowName.indexOf("Question")!= -1)
              {
				   objWindow.emxEditableTable.addToSelected(xmlMessage);
					objWindow.refreshStructureWithOutSort();
			}
              
        var objChildFrames = objWindow.frames;
        if (objChildFrames) {
            for (var i = 0; i < objChildFrames.length; i++) {
                var objChildWindow = objChildFrames[i];
                strData += printChildrenFrameStructure(objChildWindow, objThisFrame, strIndent + "....",xmlMessage);
    }
    }
    }
    return strData;
}
function printFrameStructure(xmlMessage) {
    var objThisFrame = window;
    var objTopFrame = getTopWindow().opener.parent;
    var strData = printChildrenFrameStructure(objTopFrame, objThisFrame, "....",xmlMessage);
}

function refreshAndRemoveSelectedRows(strRemoveRowId,strRefreshRowIds)
{
	removeSelectedRows(strRemoveRowId);
	var arrRows=strRefreshRowIds.split("|");
	
	var frmQuestion=findFrame(getTopWindow(),"Questionnaire");
	for(var i=0;i<arrRows.length;i++)
	{
		var nRow = emxUICore.selectSingleNode(frmQuestion.oXML, "/mxRoot/rows//r[@id = '" + arrRows[i] + "']");
	   
	    var expand = nRow.getAttribute("expand");
	    var expand = nRow.setAttribute("expand","true");
	    
	    nRow.setAttribute("expand", false);
	    nRow.setAttribute("expandedLevels", null);
	    frmQuestion.emxEditableTable.select([nRow.id]);
	    frmQuestion.emxEditableTable.expand([nRow.id], "1",true);
	}
}
function removeSelectedRows(tableRowIds)
{
	var TableRowIds = tableRowIds.split(";");
    this.parent.emxEditableTable.removeRowsSelected(TableRowIds);
    this.parent.emxEditableTable.refreshStructureWithOutSort();
}
function refreshStructureBrowser()
{
	this.parent.emxEditableTable.refreshStructure();
}
function refreshParentLocation()
{
	this.parent.location.href=this.parent.location.href;
}
function refreshFrame(framename)
{
	var frame=findFrame(getTopWindow(), framename);
	frame.location.href=frame.location.href;
}

function preProcessAssignRelatedObjects(type,policy,questionIds,action,includeOIDProgram,excludeOIDProgram,mode,rowLevel)
{
	var submitURL="../common/emxIndentedTable.jsp?program=ENOQuestionUI:getObjectsToAssign&type="+type+"&policy="+policy+"&table="
	//var submitURL="../common/emxFullSearch.jsp?field=TYPES="+type+":CURRENT="+policy+"&table=";
	submitURL += "QuestionAssignTable&emxSuiteDirectory=questionnaire&suiteKey=Questionnaire&SuiteDirectory=questionnaire&StringResourceFileId=enoQuestionnaireStringResource&selection=multiple&submitURL=../questionnaire/enoQuestionnaireExecute.jsp?questionAction=ENOQuestionnaireAdminActions:assignObjectsToQuestions&header=enoQuestionnaire.Header.AssignObjects";
	submitURL += "&questionIds=";
	submitURL += questionIds;
	submitURL+= "&QuestionAction="+action;
	submitURL += "&excludeOIDprogram="+excludeOIDProgram;

	submitURL += "&includeOIDprogram="+includeOIDProgram;
	submitURL += "&mode="+mode;
	submitURL += "&rowLevel="+rowLevel;
	showModalDialog(submitURL,250,250,true);
	//window.open(submitURL,"","height=250, width=250");
}
function preProcessGetConfigureQuestion(action,objectId)
{
	var submitURL = "../common/emxIndentedTable.jsp?table=QuestionConfigureTable1&selection=multiple&expandProgram=ENOQuestionUI:getConfigureQuestions&editLink=true&toolbar=QuestionConfigureToolbar&onReset=refreshPage&hideRootSelection=true&massUpdate=false&sortColumnName=none&configKey=";
	submitURL += action + "&insertNewRow=false&applyURL=javascript:saveAndCloseWindow&objectId="+objectId;
	submitURL += "&emxSuiteDirectory=questionnaire&suiteKey=Questionnaire&SuiteDirectory=questionnaire&StringResourceFileId=enoQuestionnaireStringResource&header=enoQuestionnaire.Header.ConfgureQuestion&modeKey=configureQuestions";
	showModalDialog(submitURL,250,250,true);
}
function alertMessageAndRefreshAfterSubmit(message)
{
	
	var frame=findFrame(getTopWindow(),"QuestionSubmitResponse");
	frame.location.href=frame.location.href;
}

function doPromoteDemote(aResult1,aResult2){
	var spanParent=getTopWindow().document.getElementById("extendedHeaderStatus");

	for(var i=0;i<spanParent.children.length;i++)
	{
		if(spanParent.children[i].tagName=="A" && spanParent.children[i].getAttribute("title").toLowerCase()==aResult2)
{
			var strHref=spanParent.children[i].href;
			spanParent.children[i].href="../common/emxExtendedPageHeaderAction.jsp?action="+aResult2+"&objectId="+aResult1;
			var currentFrame=findFrame(getTopWindow(),"Questionnaire");
			currentFrame.location.href=currentFrame.location.href;
			spanParent.children[i].click();
			break;
		}
	}
}

function getResponsibleRoleOnForm(role){
	 getTopWindow().opener.document.getElementsByName("ResponsibleRoleDisplay")[0].value=role; 
     getTopWindow().opener.document.getElementsByName("ResponsibleRole")[0].value=role; 
     getTopWindow().opener.document.getElementsByName("ResponsibleRoleOID")[0].value=role; 
     getTopWindow().close(); 
	
}

function closeAndRefreshWindowAfterAddAssignee()
{
	var frame=findFrame(getTopWindow().opener.getTopWindow(),"detailsDisplay");
	frame.location.reload();
	getTopWindow().close();
}

function refreshFormAfterRemoveAssignee()
{
	var frame=getTopWindow().findFrame(getTopWindow(),"detailsDisplay");
	frame.location.reload();
}

function getResponsibleRoleOnTable(role,strfieldNameDisplay,strfieldNameActual){
	 targetWindow = findFrame(getTopWindow().opener.getTopWindow(), "QuestionMyDeskeFormTemplates");
	 targetWindow.document.getElementsByName(strfieldNameDisplay)[0].value=role; 
     targetWindow.document.getElementsByName(strfieldNameActual)[0].value=role; 
    getTopWindow().close(); 
	
}
function refreshParent()
{
	this.parent.location.href=this.parent.location.href;
	}
function revise(revisionId){
	var frame=findFrame(getTopWindow(),"detailsDisplay");
			frame.document.location.href="../common/emxTree.jsp?&objectId="+revisionId;
}
function closeTopWindowAndRefresh(){
	getTopWindow().opener.location.href=getTopWindow().opener.location.href;
	getTopWindow().close();
}
function filterAttribute(strDoFilter,strnameMatches,strTypeFilter,strParentOID,sTableName){
	parent.resetParameter("questionAction",strDoFilter);
	parent.resetParameter("QuestionAttributeNameMatches",strnameMatches);
		
	parent.resetParameter("QuestionAttributeType", strTypeFilter);

	parent.resetParameter("parentOID",strParentOID);
	parent.resetParameter("submitLabel","emxFramework.Common.Done");
	parent.resetParameter("cancelLabel","emxFramework.Common.Cancel");
	parent.refreshSBTable(sTableName,"Name","ascending");
	
}

function redirectSubmitConfiguredQuestions(objectId,key)
{
	var submitUrl="../questionnaire/enoQuestionnaireExecute.jsp?questionAction=ENOQuestionnaireAdminActions:submitConfiguredResponse&validateToken=false&objectId="+objectId+"&configKey="+key;
	var hiddenFrame=findFrame(getTopWindow(),"hiddenFrame");
	
	var mainFrame=findFrame(getTopWindow(),"QuestionSubmitResponse");
	var submitButton=mainFrame.document.getElementById("QuestionSubmit");
	if(submitButton)
	{
		submitButton.setAttribute('style','visibility:hidden');
	}
	
	if(getTopWindow().getWindowOpener()!=null){
	 var frameDisplay=findFrame(getTopWindow().getWindowOpener().getTopWindow(),"detailsDisplay");
     
     if(frameDisplay!=null)
     	{
     	var accordian=frameDisplay.document.getElementById("accordianTasks");
     	if(accordian!=null)
     		frameDisplay.location.href=frameDisplay.location.href;
     	}
     }
	
	hiddenFrame.location.href=submitUrl;
}

function alertErrorMessageSubmitQuestion(msg) {

	var mainFrame=findFrame(getTopWindow(),"QuestionSubmitResponse");
	var submitButton=mainFrame.document.getElementById("QuestionSubmit");
	
	if(submitButton)
	{
		submitButton.setAttribute('style','visibility:visible');
	}
	alert(msg);	
}

function refreshFrameAfterImport()
{
	
	var frame=findFrame(getTopWindow().opener.getTopWindow(),"Questionnaire");
	if(!frame)
		frame=findFrame(getTopWindow().opener.getTopWindow(),"detailsDisplay");
	getTopWindow().close();
	frame.location.href=frame.location.href;
}

function redirectExportToDownloadServlet(timestamp,csrfTokenName,csrfToken)
{
	<%
	String servletPath = request.getContextPath();
	%>
	var form = document.createElement("form");
	form.setAttribute("name", "downloadForm");
    form.setAttribute("method", "POST");
    var contextPath = "<%=servletPath%>";
	form.setAttribute("action", contextPath+"/questionnaire/enoQuestionnaireExport.jsp");
	
    input = document.createElement("input");
	input.setAttribute("id", "timestamp");
	input.setAttribute("name", "timestamp");
	input.setAttribute("type", "hidden");
	input.setAttribute("value", timestamp);
    form.appendChild(input);
    
    input = document.createElement("input");
	input.setAttribute("id", csrfTokenName);
	input.setAttribute("name", csrfTokenName);
	input.setAttribute("type", "hidden");
	input.setAttribute("value", csrfToken);
    form.appendChild(input);
	document.body.appendChild(form);
	
	form.submit();
}

function refreshAfterPromoteDemote(success,msg,OID)
{	
	var frame=findFrame(getTopWindow(),"detailsDisplay");
	var frmName="detailsDisplay";
	
	if(!frame)
	{
		frame=findFrame(getTopWindow(),"ECMCRProperties");	
		frmName="ECMCRProperties";
	}
	
	if(success==='true')
		refreshWholeTree(OID, "", "", "", "", "", false,frmName);
	else if(msg)
		alert(msg);
}

function refreshAfterPromoteDemoteForFloatView(frameName,objId)
{	
	var frame;
	if(frameName){
		frame=findFrame(getTopWindow(),frameName);
		frame.document.getElementById("divLifeCycle").setAttribute("style","display:none");
		frame.emxEditableTable.refreshStructureWithOutSort();
	}
}

function preProcessAddConditionalAttribute(questionIds,action,mode,isFromParent){
	var submitURL="../common/emxIndentedTable.jsp?table=QuestionConditionalAttributeList&program=ENOQuestionUI:getConditionalAttributeList&selection=multiple&submitURL=../questionnaire/enoQuestionnaireExecute.jsp?questionAction=ENOQuestionUI:createConditionalQuestions&header=enoQuestionnaire.Header.AddAttribute";
	submitURL += "&questionIds=";
	submitURL += questionIds;
	submitURL+= "&questionAction="+action;
	submitURL += "&mode="+mode;
	submitURL += "&isFromParent="+isFromParent;
	submitURL +="&emxSuiteDirectory=questionnaire&suiteKey=Questionnaire&SuiteDirectory=questionnaire&StringResourceFileId=enoQuestionnaireStringResource";
	showModalDialog(submitURL,250,250,true);
}
function preProcessAddActionTask(objectId,parentId)
{
	var submitURL="../common/emxFullSearch.jsp?field=TYPES=type_Person,type_BusinessRole:CURRENT=policy_Person.state_Active,policy_BusinessRole.state_Active&table=QuestionCOActionTaskSearchTable&selection=multiple&submitURL=../questionnaire/enoQuestionnaireExecute.jsp?questionAction=ENOConfigureApprovalUI:addActionTaskToApproval";
 	submitURL+="&excludeOIDprogram=ENOConfigureApprovalUIBase:excludeActionTask";
	submitURL+="&emxSuiteDirectory=questionnaire&suiteKey=Questionnaire&SuiteDirectory=questionnaire&StringResourceFileId=enoQuestionnaireStringResource&header=enoQuestionnaire.Header.AddActionTask";
	submitURL+="&objectId="+objectId;
	submitURL+="&parentOID="+parentId;
	getTopWindow().location.href=submitURL;
}
function preProcessApprovals(objectId,coTable)
{
	var submitURL="";
	if(coTable=='false')
		submitURL="../common/emxTable.jsp?program=emxLifecycle:getCurrentTaskSignaturesOnObject&table=AEFLifecycleTaskSignaturesSummary&toolbar=AEFLifecycleTasksToolbar&FilterFramePage=../common/emxLifecycleTasksSignaturesFilter.jsp&FilterFrameSize=40&sortColumnName=Name&objectBased=false&HelpMarker=emxhelplifecycletasks";
	else
		submitURL="../common/emxIndentedTable.jsp?table=QuestionCOApprovalTable&editLink=true&expandProgram=ENOConfigureApprovalUI:getRouteTemplateActionTasks&toolbar=QuestionCOApprovalToolbar&selection=multiple&hideRootSelection=true";
	submitURL+="&objectId="+objectId;
	submitURL+="&emxSuiteDirectory=questionnaire&suiteKey=Questionnaire&SuiteDirectory=questionnaire&StringResourceFileId=enoQuestionnaireStringResource";
	this.location.href=submitURL;
}
function removeActionTasks(objectIds)
{
	var emxTableRowIds = objectIds;
	
	var TableRowIds = emxTableRowIds.split(";");
	this.parent.emxEditableTable.removeRowsSelected(TableRowIds);
}
function setFullSearchSubmitProgressVariable(strError){
	alert(strError);
	var isFTS = getTopWindow().location.href.indexOf("common/emxFullSearch.jsp") != -1;
	if(isFTS) {
		findFrame(getTopWindow(),"structure_browser").setSubmitURLRequestCompleted();
	 }
	else{
		isFTS = getTopWindow().opener.location.href.indexOf("common/emxFullSearch.jsp") != -1;
		if(isFTS)
			findFrame(getTopWindow().opener,"structure_browser").setSubmitURLRequestCompleted();
	}

}
function refresWindow() 
{
	var frame=findFrame(getTopWindow().opener.parent,"QuestionCOApprovals");
	if(frame)
		frame.location.href=frame.location.href;
	else	
	getTopWindow().opener.parent.location.href=getTopWindow().opener.parent.location.href;
	getTopWindow().close();
	
}

function setStructuredBrowserSubmitProgressVariable(strError)
{
	alert(strError);
	var content=findFrame(getTopWindow(),"content");
	content.setSubmitURLRequestCompleted();
}

function refreshContentPage(oID)
{
	refreshWholeTree(oID, "", "", "", "", "", false,"ChangeLifecycle");
}


function refreshWholeTree(oID, documentDropRelationship, documentCommand, showStatesInHeader, sMCSURL, imageDropRelationship, headerOnly,frmName){
	var url = "../common/emxExtendedPageHeaderAction.jsp?action=refreshHeader&objectId="+oID+"&documentDropRelationship="
				+documentDropRelationship+"&documentCommand="+documentCommand+"&showStatesInHeader="+showStatesInHeader
				+"&imageDropRelationship="+imageDropRelationship+"&MCSURL="+sMCSURL;

	$.ajax({
	    url : url,
	    cache: false
	}).success( function(text){
			if (text.indexOf("EXCEPTION")!=-1) 
			{
				var wndContent = getTopWindow().findFrame(getTopWindow(), "detailsDisplay");
				if (wndContent) 
				{
					var tempURL ="../common/emxTreeNoDisplay.jsp";						
					wndContent.location.href = tempURL;
				}
			}
			else 
			{
				getTopWindow().document.getElementById("ExtpageHeadDiv").innerHTML=text;
				if(frmName)
				{
					var frame=findFrame(getTopWindow(),frmName);
					if(frame) 
						frame.location.href=frame.location.href
				}
			}
	});
}

function removeReferenceDocuments() {
		this.parent.location.href=this.parent.location.href;
	}
	
	function addReferenceDocuments() {
			var contentFrame = findFrame(getTopWindow().opener.getTopWindow(),"portalDisplay");
			contentFrame.location.href = contentFrame.location.href;
		getTopWindow().close();
	}

		function preProcessAddReferenceDocuments(strSuiteKey,strDocId){
		
		var sbSearchURL = "../common/emxFullSearch.jsp?field=TYPES=type_DOCUMENTS:IS_VERSION_OBJECT=False&table=IssueSearchDocumentTable&selection=multiple&suiteKey=Components&StringResourceFileId=emxComponentsStringResource&SuiteDirectory=components&HelpMarker=emxhelpsearch&submitURL=../questionnaire/enoQuestionnaireExecute.jsp?questionAction=ENOQuestionnaireAdminActions:addReferenceDocuments&srcDestRelName=relationship_ReferenceDocument&isTo=true";
		
		
		sbSearchURL = sbSearchURL + "&objectId=" + strDocId;
		showModalDialog(sbSearchURL, 600, 400, false);

	}
	
	</script>

