<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="com.matrixone.fcs.common.TransportUtil"%>
<%@page import="matrix.util.StringList"%>
<%@include file = "../emxUICommonAppInclude.inc"%>

<script type="text/javascript" language="javascript">

function compareSnapshotsStructure(sParentId, sChildId) {
	var	contentURL = "../common/emxIndentedTable.jsp?table=PMCWhatIfCompareViewTable&viewMode=true&showRMB=false&expandProgram=emxWhatIf:getExperimentWBSSubtasks&reportType=Complete_Summary_Report&IsStructureCompare=TRUE&expandLevel=0&connectionProgram=emxWhatIf:updateMasterProject&resequenceRelationship=relationship_Subtask&refreshTableContent=true&objectId=";
 	contentURL += sChildId +","+ sParentId;
 	contentURL += "&ParentobjectId="+sParentId+"&objectId1="+sChildId+"&objectId2="+sParentId;
 	contentURL += "&compareBy=Name,Dependency,ConstraintType,Constraint Date,PhaseEstimatedDuration,PhaseEstimatedStartDate,PhaseEstimatedEndDate,PhaseActualDuration,PhaseActualStartDate,PhaseActualEndDate,Description&objectCompare=false&showClipboard=false&customize=false&rowGrouping=false&inlineIcons=false&displayView=details&syncEntireRow=true&SortDirection=ascending&SortColumnName=dupId&matchBasedOn=TaskId&selection=none&editRootNode=false&emxSuiteDirectory=programcentral&suiteKey=ProgramCentral&hideRootSelection=true";
 	
 	var url = contentURL;
	var topFrame = findFrame(getTopWindow(), "PMCWhatIfExperimentStructure");
	topFrame.location.href = url;
}

function refreshOpenerWindow()
{
	window.parent.location.href = window.parent.location.href;
}

function refreshopenerWindowAndStructureTab()
{
	var topFrame = findFrame(getTopWindow(), "PMCWhatIfExperimentStructure");
	topFrame.location.href = "../programcentral/emxProgramCentralWhatIfAnalysis.jsp?mode=Blank";
	window.parent.location.href = window.parent.location.href;
}

function showErrorMessage(message) {   
	alert(message);	
}

</script>
