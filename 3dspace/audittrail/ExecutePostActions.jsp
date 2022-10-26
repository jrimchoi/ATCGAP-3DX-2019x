<%@include file="../common/emxNavigatorInclude.inc"%>
<script type="text/javascript" language="javascript">

function showHistory(objectId,structuralHistory,mode,relId,targetLocation){

	var url="../common/emxIndentedTable.jsp?&program=ENOAuditTrails:getAuditTrailsHistoryTable&toolbar=AuditHistoryToolbar,AuditFilterToolbar&renderPDF=true&displayView=details";
	url+="&objectId="+objectId;
	url+="&structuralHistory="+structuralHistory;
	url+="&renderPDF=true&mode="+mode;
	url+="&relId="+relId;
	url +="&emxSuiteDirectory=audittrail&suiteKey=AuditTrail&SuiteDirectory=audittrail&StringResourceFileId=enoAuditTrailStringResource&portalMode=true&helpMarker=emxhelpaudithistory";
	if (structuralHistory.toLowerCase() === "false")
	{
		url+="&table=AuditTable&sortColumnName=none";
		url+="&header=enoAuditTrail.Header.History";
	}
	else
		url+="&table=AuditStructuralTable&sortColumnName=none&header=enoAuditTrail.Header.StructureHistory";
	
	if(targetLocation== "listHidden"){
		showModalDialog(url,250,250,true);
	}else{	
	this.location.href=url;
}

}

</script>
