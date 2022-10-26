<%@include file="../common/emxNavigatorInclude.inc"%>
<script type="text/javascript" language="javascript">

function navigateToServlet(zipName,url) {
	var parameters = new Object();
	parameters.zipFileName = zipName;
	var newURL = url.concat("/myDownloadPackage");
	modifyAndSubmitForwardForm(parameters,null, newURL, null);
}

function openRenderPDFDialog(strURL){
	showDialog(strURL,true);
}

function alertMessage(message){
	alert(message);
}
function openControlledPrintForm(docId,strProgramMethodName){
	var url = "../common/emxForm.jsp?form=ControlledPrintForm&mode=edit&formHeader=enoControlledPrinting.Header.Print";
	url +="&objectId="+docId;
	url+="&FileProgram="+strProgramMethodName;
	url +="&postProcessURL=../controlledPrinting/Execute.jsp?executeAction=ENOControlledPrint:actionOpenRenderPDFDialog&submitAction=doNothing";
	url+="&showRMB=false&suiteKey=ControlledPrinting&StringResourceFileId=enoControlledPrintingStringResource&SuiteDirectory=controlledprinting";
	getTopWindow().showSlideInDialog(url,true);

}
function openGeneratePDFForm(docId)
{

	var url = "../common/emxForm.jsp?form=ManualPDFForm&mode=edit&formHeader=Generate PDF";
	url +="&objectId="+docId;
	url +="&postProcessURL=../controlledPrinting/Execute.jsp?executeAction=ENOControlledPrint:generatePDF&submitAction=doNothing";
	url+="&showRMB=false&suiteKey=ControlledPrinting&StringResourceFileId=enoControlledPrintingStringResource&SuiteDirectory=controlledprinting";
	getTopWindow().showSlideInDialog(url,true);
}
function submitSearchFilter(printNumber,printDate_from,PrintDate_To,printRecipient,issuedBy,RecallValue,Source)
{
	var frame=getTopWindow().findFrame(getTopWindow(),"content");
	var url = "../common/emxIndentedTable.jsp?table=ControlledPrintSummaryTable&program=ENOControlledPrint:getFilterPrint&toolbar=ControlledPrintToolbarFilter&selection=multiple&header=enoControlledPrinting.Label.ControlledPrintReport&suiteKey=ControlledPrinting&StringResourceFileId=enoControlledPrintingStringResource&SuiteDirectory=controlledprinting";
	url +="&showRMB=false&Print_Number="+printNumber+"&Print_Date_from="+printDate_from+"&Print_Date_to="+PrintDate_To+"&Print_Recipient="+printRecipient+"&Issued_By="+issuedBy+"&RecallStatus="+RecallValue+"&Source="+Source;
	frame.location.href=url;
}

function refreshPage(message){
	alert(message);
	getTopWindow().opener.location.href=getTopWindow().opener.location.href;
	getTopWindow().close();
}
function refreshPrintPage(message){
	alert(message);
	var frame=getTopWindow().findFrame(getTopWindow(),"detailsDisplay");
	if(null!=frame){
	frame.location.href=frame.location.href;
	}else{
		var contentFrame=getTopWindow().findFrame(getTopWindow(),"content");
		contentFrame.location.href=contentFrame.location.href;
	}
}

function closePopup(message){
	alert(message);
	getTopWindow().close();
}

function refreshPage(){
	var detailsFrame=getTopWindow().findFrame(getTopWindow(),"detailsDisplay");
detailsFrame.location.href=detailsFrame.location.href;

}


function alertAndRefresh(message){
	alert(message);
	getTopWindow().location.href=getTopWindow().location.href;
}

function alertAndRefreshAcknowledgeRecall(message, rowIDString){	
    alert(message);
   
    var url = "../common/emxForm.jsp?form=ControlledPrintAcknowledgeForm&mode=edit&formHeader=enoControlledPrinting.Label.Authenticate&postProcessURL=../controlledPrinting/Execute.jsp?executeAction=ENOControlledPrint:acknowledgeControlledPrintRecalling&submitAction=doNothing&suiteKey=ControlledPrinting&StringResourceFileId=enoControlledPrintingStringResource&SuiteDirectory=controlledprinting";
    url = url + "&rowIdss="+rowIDString;    
    
    var frame=getTopWindow().findFrame(getTopWindow(),"content"); 
    frame.location.href = url;	
}

function acknowledgeRecall(strRelId, strObjectId){
	var url = "../common/emxForm.jsp?form=ControlledPrintAcknowledgeForm&mode=edit&formHeader=enoControlledPrinting.Label.Authenticate";
	url +="&objectId="+strObjectId;
	url+="&relId="+strRelId;
	url +="&postProcessURL=../controlledPrinting/Execute.jsp?executeAction=ENOControlledPrint:submitRecalledControlledPrint&submitAction=doNothing";
	url+="&suiteKey=ControlledPrinting&StringResourceFileId=enoControlledPrintingStringResource&SuiteDirectory=controlledprinting";
	getTopWindow().location.href=url;
	
}
function setFormFieldValue(fieldName , actualValue, displayValue) {
    var targetWindow = null;
    if(top.opener == null) {
        	targetWindow = window.parent;
    } else {
        targetWindow = getTopWindow().opener;
    }
    
	var vfieldNameActual = targetWindow.document.forms[0][fieldName];
	var vfieldNameDisplay = targetWindow.document.forms[0][fieldName + "Display"];
	var vfieldNameOID = targetWindow.document.forms[0][fieldName + "OID"];

	if (vfieldNameActual==null && vfieldNameDisplay==null) {
		vfieldNameActual=targetWindow.document.getElementById(fieldName);
		vfieldNameDisplay=targetWindow.document.getElementById(fieldName + "Display");
		vfieldNameOID=targetWindow.document.getElementById(fieldName + "OID");
	}

	if (vfieldNameActual==null && vfieldNameDisplay==null) {
		vfieldNameActual=targetWindow.document.getElementsByName(fieldName)[0];
		vfieldNameDisplay=targetWindow.document.getElementsByName(fieldName + "Display")[0];
		vfieldNameOID=targetWindow.document.getElementsByName(fieldName + "OID")[0];
	}
		
	if (vfieldNameActual==null && vfieldNameDisplay==null) {
		vfieldNameActual=findFrame(getTopWindow(),"slideInFrame").document.getElementsByName(fieldName)[0];
		vfieldNameDisplay=findFrame(getTopWindow(),"slideInFrame").document.getElementsByName(fieldName + "Display")[0];
		vfieldNameOID=findFrame(getTopWindow(),"slideInFrame").document.getElementsByName(fieldName + "OID")[0];
	}
	
	
	
	/*
	   FIX IR-088125V6R2012 
	   In IE8, for some use-cases, getElementsByName doesn't work when 
	   accessing URL with its full name. Below code address the issue.
	 */
	if (vfieldNameActual==null && vfieldNameDisplay==null) {
	     var elem = targetWindow.document.getElementsByTagName("input");
	     var att;
	     var iarr;
	     for(i = 0,iarr = 0; i < elem.length; i++) {
	        att = elem[i].getAttribute("name");
	        if(fieldName + "Display" == att) {
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

	var vTopWindowURL = getTopWindow().location.href;
	if(vTopWindowURL.includes("emxFullSearch")) {
		//chooser opened for selecting recepient
        getTopWindow().location.href = "../common/emxCloseWindow.jsp";
    	} 
	
}
function alertAndRefreshTreeDetailsPage(strMessage){
	alert(strMessage);
	getTopWindow().refreshTreeDetailsPage();
}

</script>

