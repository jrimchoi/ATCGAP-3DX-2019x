<jsp:include page="../common/scripts/emxUIFormHandler.js" />
<%@include file="../common/emxNavigatorNoDocTypeInclude.inc"%>
<%@page import="com.dassault_systemes.enovia.lsa.Helper"%>

function updateSeverityInUI()
{
	var currentCell = emxEditableTable.getCurrentCell();
	var currentSev = currentCell.value.current.actual;
	var oldDisplayValue = currentCell.value.old.actual?currentCell.value.old.actual:currentCell.value.old.display;
	var rowID = currentCell.rowID;
	var colName=currentCell.columnName;
	var currentHref = "<img border=\"0\" align=\"middle\" src=\"../common/images/iconStatusComplaint" + currentSev + ".png\" />";
	var strHTML= "<c><span>" + currentHref + "</span></c>";
	var objHTML = emxUICore.createXMLDOM();
    objHTML.loadXML(strHTML);
    objHTML.documentElement.setAttribute("d", oldDisplayValue);
    objHTML.documentElement.setAttribute("a", oldDisplayValue);
    
	var cached = emxUICore.selectNodes(oXML,"/mxRoot/rows//r[(@status='changed')]");
	for(var i = 0; i < cached.length; i++){
		cached[i].removeAttribute('status');
		for(k=0;k<cached[i].childNodes.length;k++){
			if(cached[i].childNodes[k].tagName == 'c' && cached[i].childNodes[k].getAttribute('edited') == 'true' ){
				cached[i].childNodes[k].setAttribute('d',oldDisplayValue);
			}
		}
	}
	emxEditableTable.setCellHTMLValueByRowId(rowID,colName,objHTML.documentElement.outerHTML,true, false);
}
