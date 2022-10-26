<%@include file="../common/emxNavigatorInclude.inc"%>
<script type="text/javascript" language="javascript">
	function alertContactsSuccessfulAction(message) {
		alert(message);
		window.parent.location.href = window.parent.location.href;
	}

	function removeSelectedRows(tableRowIds, msg) {
		alert(msg);
		var TableRowIds = tableRowIds.split(";");
		alert('' + TableRowIds.length);
		alert('' + TableRowIds);
		this.parent.emxEditableTable.removeRowsSelected(TableRowIds);
		this.parent.emxEditableTable.refreshStructureWithOutSort();
	}

	function addAndRefreshPage() {
		debugger;
		var detailsDisplayFrame = findFrame(getTopWindow(), "Contacts");
		if (detailsDisplayFrame == null) {
			detailsDisplayFrame = findFrame(getTopWindow().getWindowOpener().getTopWindow(), "Contacts");
		}
		if (detailsDisplayFrame == null) {
			detailsDisplayFrame = findFrame(getTopWindow().getWindowOpener().getTopWindow(), "detailsDisplay");
		}
		if (detailsDisplayFrame == null) {
			detailsDisplayFrame = findFrame(getTopWindow().getWindowOpener().getTopWindow(), "content");
		}
		detailsDisplayFrame.location.href = detailsDisplayFrame.location.href;
		if(getTopWindow().getWindowOpener()) {
			getTopWindow().closeWindow();
		}
	}
	function refreshPropertiesForm(objectId) {
		var detailsDisplayFrame = findFrame(getTopWindow(), "detailsDisplay");
		alert(detailsDisplayFrame.location.href);

		detailsDisplayFrame.location.href = "../common/emxForm.jsp?form=type_Contacts&toolbar=ContactEditToolbar&mode=view&StringResourceFileId=enoContactsStringResource&SuiteDirectory=contacts&emxSuiteDirectory=contacts&objectId="
				+ objectId + "&suiteKey=Contacts";
	}

	function removeAndRefreshPage() {
		var detailsDisplayFrame = findFrame(getTopWindow(), "Contacts");
		if (detailsDisplayFrame == null) {
			detailsDisplayFrame = findFrame(getTopWindow(), "detailsDisplay");
		}
		if (detailsDisplayFrame == null) {
			detailsDisplayFrame = findFrame(getTopWindow(), "content");
		}
		detailsDisplayFrame.location.href = detailsDisplayFrame.location.href;
	}
</script>
