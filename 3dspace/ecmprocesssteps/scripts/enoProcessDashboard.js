function executeOperation(objectId, operationName, reloadPage)
{
	debugger;
        var accordion 		= document.getElementById('accordianTasks');
	var rootObjectId	= accordion.getAttribute('rootObjectId');
	var mycontentFrame = findFrame(getTopWindow(),"ENOLSAChangeProcess");
	var url=mycontentFrame.location.href;

	$.urlParam = function(name){
		var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(url);
		if(results!=null)
			return results[1] || 0;
		else
			return "";
}

	var selectedId=$.urlParam('selectedProposedItem');
	var selectedAffectedItems=$.urlParam('selectedAffectedItems');
	jQuery.ajax({
		url: './enoLSAChangeProcessActions.jsp?objectId=' + objectId + '&rootobjectId=' + rootObjectId + '&operationName=' + operationName ,
		async: false,
		cache: false,
	});
	
	getTopWindow().RefreshHeader();
	if(reloadPage == 'true') {
		getTopWindow().deletePageCache();
		getTopWindow().findFrame(getTopWindow(),"detailsDisplay").location.href = getTopWindow().findFrame(getTopWindow(),"detailsDisplay").location.href+ '&selectedProposedItem=' + selectedId+ '&selectedAffectedItems=' + selectedAffectedItems
	}
}

function acceptTask(sAcceptURL){
	
	submitWithCSRF(sAcceptURL, findFrame(getTopWindow(),'listHidden'));
	getTopWindow().findFrame(getTopWindow(),"detailsDisplay").location.href = getTopWindow().findFrame(getTopWindow(),"detailsDisplay").location.href;
}
function showTooltip(objectName,objectId)
{
	var tooltip= document.getElementById(objectName);
	tooltip.style.visibility= 'visible';
	if(objectId!='')
	{
		var basicToolTip= document.getElementById(objectId);
		if(basicToolTip)
			basicToolTip.style.visibility= 'hidden';
		showRoute(objectId);
	}
}

function hideTooltip(objectName,objectId)
{
	var tooltip= document.getElementById(objectName);
	tooltip.style.visibility= 'hidden';
	if(objectId!='')
	{
		var basicToolTip= document.getElementById(objectId);
		if(basicToolTip)
			basicToolTip.style.visibility= 'hidden';
	}
}

function showRoute(objectId)
{
	var queryString = "&objectId="+objectId+"&suiteKey=DocumentControl";
	var response=emxUICore.getDataPost("../questionnaire/enoQuestionnaireExecute.jsp?questionAction=ENODCLDocumentUI:getApproversImage",queryString);
	var imgDiv= document.getElementById(objectId+'Images');
	imgDiv.innerHTML=response;
}

function openTreePage(objectId)
{
	var submitURL="../common/emxTree.jsp?mode=insert&objectId="+objectId;
	getTopWindow().showModalDialog(submitURL,250,250,true);
}

function openHistoryPage(objectId){
	var submitUrl="../audittrail/Execute.jsp?executeAction=ENOAuditTrails:preProcessHistory&structuralHistory=false&mode=";
	submitUrl+="&objectId="+objectId;
	getTopWindow().showModalDialog(submitUrl,250,250,true);
}

function openConditionsPage(objectId)
{
	var url='../questionnaire/enoQuestionnaireExecute.jsp?questionAction=ENOQuestionUI:getPromoteBlockingConditionsHTML&validateToken=false&mqlNoticeMode=true&objectId='+objectId;
	var doc=emxUICore.getDataPost(url);
	var promoteBlock=document.getElementById(objectId+'Blocking');

	promoteBlock.innerHTML= doc.substring(1);
	promoteBlock.style.visibility= 'visible';
}

function openLifecycle(objectId)
{
	var submitUrl="../common/emxLifecycle.jsp?toolbar=AEFLifecycleMenuToolBar&header=emxFramework.Lifecycle.LifeCyclePageHeading&export=false";
	submitUrl+="&mode=advanced&objectId="+objectId;
	showModalDialog(submitUrl,250,250,true);
}

function openEditPage(objectId,type)
{
	var submitURL="";
	if(type=='Change Order')
	{
		submitURL+="../common/emxForm.jsp?form=type_ChangeOrderSlidein&formHeader=EnterpriseChangeMgt.Heading.EditCO&HelpMarker=emxhelpchangeorderedit&mode=edit&submitAction=doNothing&preProcessJavaScript=preProcessInEditCO&postProcessJPO=enoECMChangeOrder:coPostProcessJPO&type=type_ChangeOrder&postProcessURL=../enterprisechangemgt/ECMCommonRefresh.jsp?functionality=editCOFromRMB";
		submitURL+="&objectId="+objectId+"&parentOID="+objectId;
		submitURL +="&emxSuiteDirectory=enterprisechangemgt&suiteKey=EnterpriseChangeMgt&SuiteDirectory=enterprisechangemgt&StringResourceFileId=emxEnterpriseChangeMgtStringResource";
	}
	if(type=='Change Action')
	{
		submitURL+="../common/emxForm.jsp?form=type_ChangeActionSlidein&formHeader=EnterpriseChangeMgt.Heading.EditCA&HelpMarker=emxhelpchangeactionedit&mode=edit&submitAction=doNothing&type=type_ChangeAction&postProcessURL=../enterprisechangemgt/ECMCommonRefresh.jsp?functionality=editCAFromRMB";
		submitURL+="&objectId="+objectId+"&parentOID="+objectId;
		submitURL +="&emxSuiteDirectory=enterprisechangemgt&suiteKey=EnterpriseChangeMgt&SuiteDirectory=enterprisechangemgt&StringResourceFileId=emxEnterpriseChangeMgtStringResource";
	}
	if(type=='Quality System Document')
	{
		submitURL+="../documentcontrol/enoDCLExecute.jsp?dclAction=ENODCLDocumentUI:showDocumentEditView&validateToken=false";
		submitURL+="&objectId="+objectId+"&parentOID="+objectId;
		submitURL +="&emxSuiteDirectory=enterprisechangemgt&suiteKey=EnterpriseChangeMgt&SuiteDirectory=enterprisechangemgt&StringResourceFileId=emxEnterpriseChangeMgtStringResource";
	}
	getTopWindow().showSlideInDialog(submitURL, true);
	var contentFrame=findFrame(getTopWindow(), "DCMyDocumentsTab");
	contentFrame.emxEditableTable.refreshStructureWithOutSort();
}

function openViewPage(objectId)
{
	var submitURL="../common/emxTree.jsp?mode=insert&objectId="+objectId;
	submitURL = submitURL + "&HelpMarker=emxhelpchangeorderedit";
	getTopWindow().showModalDialog(submitURL,250,250,true);
}

function openViewPageDiv(objectId)
{
	var queryString = "&objectId="+objectId+"&suiteKey=DocumentControl";
	var response=emxUICore.getDataPost("../questionnaire/enoQuestionnaireExecute.jsp?questionAction=ENODCLDocumentUI:getBasicProperties",queryString);
	var divView= document.getElementById(objectId);
	divView.innerHTML=response;
	divView.style.visibility= 'visible';
}

if(!String.prototype.format) {
	  String.prototype.format = function() {
	    var args = arguments;
	    return this.replace(/{(\d+)}/g, function(match, number) { 
	      return typeof args[number] != 'undefined'
	        ? args[number]
	        : match
	      ;
	    });
	  };
}
