<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="com.matrixone.fcs.common.TransportUtil"%>
<%@page import="matrix.util.StringList"%>
<%@include file = "../emxUICommonAppInclude.inc"%>
<%
	/*XSS OK*/ String strConfirmMessage = EnoviaResourceBundle.getProperty(context, "RiskMgmtStringResource", context.getLocale(),"RiskMgmt.Common.Delete.ConfirmMessage");
	String portalCommandName 	= (String)emxGetParameter(request, "portalCmdName");
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

function refreshOpenerAndMatrix() {
	var riskMatrixFrame           = findFrame(getTopWindow(),"RiskMgmtRiskMatrix");
    refreshOpenerWindow(); 
    riskMatrixFrame.location.href = riskMatrixFrame.location.href;	 
}

function setStructureBrowserCellValue(fieldName , actualValue, displayValue,objectId) {
	var targetWindow =  window.parent;
    if( targetWindow.name == "structure_browser") {
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
	
	targetWindow = window.parent;
	if( targetWindow.name == "structure_browser") {
		if(getTopWindow().getWindowOpener() != null) {
			getTopWindow().closeWindow();
		}
	}
}

function refreshRiskDetailSummaryTable() {
    var riskTableFrame           = findFrame(getTopWindow(),"RiskMgmtRiskTable");
    riskTableFrame.location.href = riskTableFrame.location.href;	 
}

function showErrorMessageAndRefresh(message) {   
	alert(message);
	var riskMatrixFrame           = findFrame(getTopWindow(),"RiskMgmtRiskMatrix");
    refreshOpenerWindow(); 
    riskMatrixFrame.location.href = riskMatrixFrame.location.href;	 
}

function refreshFrame(frameName){	
	 var frame           = findFrame(getTopWindow(),frameName);
	 if(frame==null || frame==""){			
		 frame=findFrame(getTopWindow(),"content");	//Added for launch window	
		}
	 frame.location.href = frame.location.href;
}

function removeRowFromSummaryTable(xmlMessage,frameName){	
	 var frame = findFrame(getTopWindow(),frameName);	
	 if(frame==null || frame==""){			
		 frame=findFrame(getTopWindow(),"content");	//Added for launch window	
		}	 
	 frame.removedeletedRows(xmlMessage);
}

function removeRowAndRefreshHazardMatrix(xmlMessage,frameName){	
	removeRowFromSummaryTable(xmlMessage,frameName);	
		
	var frameHazardRiskMatrix = findFrame(getTopWindow(),"RiskMgmtHazardRiskMatrix");	
	if(frameHazardRiskMatrix!=null && frameHazardRiskMatrix!=""){
		frameHazardRiskMatrix.location.href = frameHazardRiskMatrix.location.href;	
	}	
}

function addRowToSummaryTable(xmlMessage){
	var frameHazardSummaryFromDesignProject = findFrame(getTopWindow().getWindowOpener().getTopWindow(),"RiskMgmtHazardDetailsProductHazards");		
	if(frameHazardSummaryFromDesignProject==null || frameHazardSummaryFromDesignProject==""){			
		frameHazardSummaryFromDesignProject=findFrame(getTopWindow().getWindowOpener().getTopWindow(),"content"); //Added for launch window			
	}	
	frameHazardSummaryFromDesignProject.emxEditableTable.addToSelected(xmlMessage);
	frameHazardSummaryFromDesignProject.refreshStructureWithOutSort();
	getTopWindow().closeWindow();	
}

function addRowAndRefreshProductHazardsStructure(xmlMessage){
	var frameHazardSummaryFromDesignProject = findFrame(getTopWindow(),"RiskMgmtHazardDetailsProductHazards");	
	if(frameHazardSummaryFromDesignProject==null || frameHazardSummaryFromDesignProject==""){			
		frameHazardSummaryFromDesignProject=findFrame(getTopWindow(),"content"); //Added for launch window	
		}
	frameHazardSummaryFromDesignProject.emxEditableTable.addToSelected(xmlMessage);
	frameHazardSummaryFromDesignProject.refreshStructureWithOutSort();
}

function showErrorMessage(message){
	alert(message);
}

function createHazard(productId,productLevel,frameName) {	
	var submitURL = "../common/emxCreate.jsp?nameField=autoName&form=type_CreateHazard&type=type_Hazard&policy=policy_ManagedRisk&formHeader=RiskMgmt.Common.CreateHazard&mode=edit&createJPO=com.dassault_systemes.enovia.riskmgmt.ui.Hazard:createHazard&showApply=true&showPageURLIcon=false&suiteKey=RiskMgmt&HelpMarker=emxhelphazardcreate&productId="+productId+"&postProcessURL=../RiskMgmt/Execute.jsp?action=com.dassault_systemes.enovia.riskmgmt.ui.Hazard:createHazardPostProcess&suiteKey=RiskMgmt&frameName="+frameName+"&productLevel="+productLevel;
	getTopWindow().showSlideInDialog(submitURL, "true");
}

function createHazardFromTemplate(productId,productLevel) {	
	var submitURL = "../common/emxFullSearch.jsp?field=TYPES=type_HazardTemplate:CURRENT=policy_HazardTemplate.state_Active&selection=multiple&table=RiskMgmtHazardTemplateSummary&showInitialResults=true&submitURL=../RiskMgmt/Execute.jsp?action=com.dassault_systemes.enovia.riskmgmt.ui.Hazard:createHazardsFromTemplate&suiteKey=RiskMgmt&productId="+productId+"&productLevel="+productLevel;
	showModalDialog(submitURL, 600, 700,true);
}

function actionChangeHazardOwner(hazardIds,parentObjectId,objectId) {
	var submitURL = "../common/emxForm.jsp?form=RiskMgmtHazardChangeOwnership&formHeader=RiskMgmt.Common.ChangeOwnership.Header&submitAction=doNothing&mode=edit&parentOID="+parentObjectId+"&objectId="+objectId+"&postProcessURL=../RiskMgmt/Execute.jsp?action=com.dassault_systemes.enovia.riskmgmt.ui.HazardSummary:actionChangeHazardOwner&suiteKey=RiskMgmt&hazardIds="+hazardIds+"&projectId="+objectId;
	getTopWindow().showSlideInDialog(submitURL, "true");
}

function refreshHazardFrames(){	
	var parentWindowlocation= getTopWindow().getWindowOpener().parent.location.href;	
	var topWindowLocation= getTopWindow().getWindowOpener().location.href;	
	
	if(parentWindowlocation.indexOf("portal=RiskMgmtHazardControlPortal") >= 0 || topWindowLocation.indexOf("portal=RiskMgmtHazardControlPortal") >= 0){		
		var frameHazardSummaryFromProduct = findFrame(getTopWindow().getWindowOpener().getTopWindow(),"RiskMgmtHazardDetails");		
		if(frameHazardSummaryFromProduct==null || frameHazardSummaryFromProduct==""){			
			frameHazardSummaryFromProduct=findFrame(getTopWindow().getWindowOpener().getTopWindow(),"content"); //Added for launch window			
			}
		frameHazardSummaryFromProduct.emxEditableTable.refreshStructureWithOutSort();
		
		var frameHazardRiskMatrix = findFrame(getTopWindow().getWindowOpener().getTopWindow(),"RiskMgmtHazardRiskMatrix");		
		if(frameHazardRiskMatrix!=null && frameHazardRiskMatrix!=""){
			frameHazardRiskMatrix.location.href = frameHazardRiskMatrix.location.href;	
		}						
	}else if(parentWindowlocation.indexOf("portal=RiskMgmtHazardPowerViewPortal") >= 0){		
		var frameHazardSummaryFromHazardPowerView = findFrame(getTopWindow(),"RiskMgmtHazardDetailsNewHazards");		
		if(frameHazardSummaryFromHazardPowerView==null || frameHazardSummaryFromHazardPowerView==""){
			frameHazardSummaryFromHazardPowerView=findFrame(getTopWindow().getWindowOpener().getTopWindow(),"RiskMgmtHazardDetailsNewHazards");			
		}		
		frameHazardSummaryFromHazardPowerView.emxEditableTable.refreshStructureWithOutSort();					
	}else if(topWindowLocation.indexOf("portalCmdName=RiskMgmtHazardDetailsProductHazards") >= 0){
		var frameHazardSummaryFromDesignProject = findFrame(getTopWindow().getWindowOpener().getTopWindow(),"RiskMgmtHazardDetailsProductHazards");		
		if(frameHazardSummaryFromDesignProject==null || frameHazardSummaryFromDesignProject==""){			
			frameHazardSummaryFromDesignProject=findFrame(getTopWindow().getWindowOpener().getTopWindow(),"content"); //Added for launch window			
			}
		frameHazardSummaryFromDesignProject.emxEditableTable.refreshStructureWithOutSort();
	}else if(!(topWindowLocation==null || topWindowLocation=="")){
		getTopWindow().getWindowOpener().location.href=getTopWindow().getWindowOpener().location.href;		
	}	
}

function refreshFrameOnProcessAction(){
	refreshHazardFrames();
	window.parent.closeWindow();
}

function refreshTableFrameOnProcessAction(){
	refreshHazardFrames();
	getTopWindow().closeWindow();
}

function actionShowReport(productId,hazardSelectionError) {
	if(hazardSelectionError!=null){
		showErrorMessage(hazardSelectionError);
	}
	var strURL = "../common/emxIndentedTable.jsp?program=com.dassault_systemes.enovia.riskmgmt.ui.HazardResidualRiskDisclosureReport:getTableRiskMgmtHazardResidualRiskReportData&table=RiskMgmtHazardResidualRiskReport&header=RiskMgmt.Header.ResidualRiskReport&massPromoteDemote=false&expandProgram=com.dassault_systemes.enovia.riskmgmt.ui.HazardResidualRiskDisclosureReport:getTableRiskMgmtHazardResidualRiskReportReductionOptionsData&suiteKey=RiskMgmt&selection=multiple&HelpMarker=emxhelpresidualriskdisclosurerpt&objectId="+productId;
	showNonModalDialog(strURL, 600, 700,true);
}

function refreshHazardFramesAndCloseTopWindow(){
	var frameHazardRiskMatrix = findFrame(getTopWindow().getWindowOpener().getTopWindow(),"RiskMgmtHazardRiskMatrix");	
	if(frameHazardRiskMatrix!=null && frameHazardRiskMatrix!=""){
		frameHazardRiskMatrix.location.href = frameHazardRiskMatrix.location.href;	
	}
	
	var frameHazardSummaryFromProduct = findFrame(getTopWindow().getWindowOpener().getTopWindow(),"RiskMgmtHazardDetails");	
	if(frameHazardSummaryFromProduct==null || frameHazardSummaryFromProduct==""){			
		frameHazardSummaryFromProduct=findFrame(getTopWindow().getWindowOpener().getTopWindow(),"content"); //Added for launch window			
		}
	getTopWindow().closeWindow();
	frameHazardSummaryFromProduct.location.href=frameHazardSummaryFromProduct.location.href;	
}

function actionPreDeleteHazard(hazardIds,rowIds){	
	var confirmMessage = "<%=strConfirmMessage%>";
	if(confirm(confirmMessage)==true){		
		var parameters = new Object();
	    parameters.suiteKey="RiskMgmt";
	    parameters.hazardIds=hazardIds;
	    parameters.rowIds=rowIds;
	    parameters.frameName="<%=portalCommandName%>";	   
	    modifyAndSubmitForwardForm(parameters, null, "../RiskMgmt/Execute.jsp?action=com.dassault_systemes.enovia.riskmgmt.ui.HazardSummary:actionDeleteHazards");	
	}
}

function actionPreDeleteHazardTemplate(hazardTemplateIds,rowIds){	
	var confirmMessage = "<%=strConfirmMessage%>";
	if(confirm(confirmMessage)==true){		
		var parameters = new Object();
	    parameters.suiteKey="RiskMgmt";
	    parameters.hazardTemplateIds=hazardTemplateIds;
	    parameters.rowIds=rowIds;
	    parameters.frameName="<%=portalCommandName%>";	   
	    modifyAndSubmitForwardForm(parameters, null, "../RiskMgmt/Execute.jsp?action=com.dassault_systemes.enovia.riskmgmt.ui.HazardTemplateSummary:actionDeleteHazardTemplates");	
	}
}

function refreshStructureWithOutSort(frameName){
	var frame = findFrame(getTopWindow(),frameName);
	if(frame==null || frame==""){			
		 frame=findFrame(getTopWindow(),"content");	//Added for launch window	
		}
	frame.refreshStructureWithOutSort();	
}
</script>
