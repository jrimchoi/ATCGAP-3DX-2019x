<%@include file="../common/emxNavigatorNoDocTypeInclude.inc"%>
<%@page import="com.dassault_systemes.enovia.snapshot.services.Helper"%>
<%@page import="matrix.db.Context"%>
<%@page import="com.matrixone.servlet.Framework"%>
<%@page import="com.dassault_systemes.enovia.snapshot.services.SnapshotException"%>

<script language="javascript" src="../common/scripts/emxUICore.js"></script>
<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script>

<%!
	private String getI18NString(Context context, String key) throws SnapshotException {
		try {
			return XSSUtil.encodeForJavaScript(context, key);
		} catch (Exception e) {
			throw new SnapshotException(e);
		}
	}
%> 

<script type="text/javascript" language="javascript">
function submitCompareURLOnFrame(strURL, reportFrame) {
	var resultTargetFrame = getTopWindow().parent.findFrame(getTopWindow(), reportFrame);
	resultTargetFrame.location.href=strURL;
	turnOffProgress();
}

function getObjectAliasTypeToOpenSearch(objectId, snapshot, objectType, snapshotId) {
	var parameters = new Object();
	parameters.field="TYPES="+objectType;
	parameters.table="AEFGeneralSearchResults";
	parameters.showInitialResults="true";
	parameters.submitURL="../Snapshot/Execute.jsp?executeAction=com.dassault_systemes.enovia.snapshot.services.ui.Snapshot:setFormSnapshotcompareFieldName2";
	parameters.selection="single";
	parameters.includeOIDprogram="com.dassault_systemes.enovia.snapshot.services.ui.Snapshot:getIcludeOIDForSnapshot";
	parameters.snapshot=snapshot;
	parameters.suiteKey="Snapshot";
	parameters.snapshotPRT=objectId;
	parameters.snapshotId=snapshotId;
	
	showSearchDialog(parameters);
}

function setFormSnapshotcompareFieldName2(fieldDisplayValue, fieldActualValue, revValue, snapshotsInfo) {
	var formFrame = getTopWindow().opener.opener;
	var formObj = formFrame.document.forms["editDataForm"];
    if (formObj) {
        var fieldDisplay = formObj.elements["Name2Display"];
        var fieldActual  = formObj.elements["Name2"];
        var revision2  = formObj.elements["Revision2"];
        var snapshot2  = formObj.elements["Snapshot2"];
        var snapshot2Rev  = formObj.elements["Snapshot2Rev"];
        
        if (fieldDisplay && fieldActual && revision2 && snapshotsInfo) {
            fieldDisplay.value = fieldDisplayValue;
            fieldActual.value = fieldActualValue;
            revision2.value = revValue;
            var snapshotArray = JSON.parse(snapshotsInfo);
            var snapshotOptions = [];
            
            for ( var i = 0; i < snapshotArray.length; i++) {
        		var snapshotId = snapshotArray[i].snapshotId;
        		var snapshotName = snapshotArray[i].snapshotName;
        		snapshotOptions.push("<option value=" + snapshotId + "\>" + snapshotName + "</option>");
        		
        		if(snapshot2Rev != null && snapshot2Rev !='undefined'){
        		snapshot2Rev.value = snapshotArray[0].snapshotRev;
        		}
        	}
            snapshot2.innerHTML = snapshotOptions.join('\n');
        }
    }
    getTopWindow().opener.close();
    getTopWindow().close();
}

function openURLToViewSnapshotStructure(appName, objectId, table,suiteKey) {
	var strURL = "../common/emxIndentedTable.jsp?expandProgram=com.dassault_systemes.enovia.snapshot.services.ui.Snapshot:actionPerformView&HelpMarker=emxhelpsnapshotproperties&suiteKey="+suiteKey+"&snapshotView=true&mode=view&displayView=details&expandLevelFilter=false&emxExpandFilter=All&toolbar=LESDMRBaselineStructurePageToolbar,LESDMRBaseLineCustomFilterMenu&header=Snapshot.Structure.Header&objectId="+objectId+"&appName="+appName+"&table="+table;
	var resultTargetFrame = findFrame(getTopWindow(), "detailsDisplay");
	resultTargetFrame.location.href=strURL;
}

</script>

