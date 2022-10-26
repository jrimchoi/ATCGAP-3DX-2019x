
<script type="text/javascript" language="javascript">

function reloadSnapshotRevisionOnSnapshotChange() {
	emxFormReloadField("Snapshot2Rev");
	return true;
}

function reloadRevisionOnNameChange() {
	emxFormReloadField("Snapshot2");
	return true;
}
function preProcessSnapshotRevisionLoad() {
	var snapshot2Id = emxFormGetValue("Snapshot2").current.actual;
	var queryString="&ajaxMode=true&suiteKey=Snapshot&objectId2="+snapshot2Id; //XSSOK
    var response = emxUICore.getDataPost("../Snapshot/Execute.jsp?action=com.dassault_systemes.enovia.snapshot.services.ui.Snapshot:getFormSnapshotCompareFieldSnapshotRev2",queryString);
	var jsObject = eval('(' + response + ')');
    var result = jsObject.result;
    var snapshot2Rev = result[0].value;
    document.editDataForm.Snapshot2Rev.value = snapshot2Rev;
}
</script>
