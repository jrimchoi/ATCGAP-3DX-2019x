<%@include file="../common/emxNavigatorInclude.inc"%>
<%@page import="matrix.db.Context"%>
<%@page import="matrix.util.StringList"%>
<%@page import="com.dassault_systemes.enovia.downloadpackage.DownloadPackageException"%>
<%@page import="com.dassault_systemes.enovia.downloadpackage.Helper"%>
<%!
/**
	 *  This method is to return the String resource property for the specified key
	 *
	 * @param context Enovia context Object
	 * @param key Key for the string resource lookup
	 * @return keyValue the value for the key in the string resource file
	 */
	private String getString(Context context, String key) throws DownloadPackageException {
		try {
			return Helper.getI18NString(context, key);
		}
		catch (Exception e) {
			throw new DownloadPackageException(e);
		}
	}
%>

<script type="text/javascript" language="javascript">
	function navigateToServlet(zipName,url) {
		var parameters = new Object();
		parameters.zipFileName = zipName;
		var newURL = url.concat("/myDownloadPackage");
		//TODO search for DownloadPackageHiddenForm object, so that zip path can be sent as post parameter rather than get
		modifyAndSubmitForwardForm(parameters,null, newURL, null);
	}
	
	function getNewNameForDownload(objectRowId) {
		var frame = findFrame(getTopWindow().parent,"content");
		var displayRows = frame.aDisplayRows;
		for(var i=0;i < displayRows.length; i++) {
			var displayRow = displayRows[i];
			displayRow.setAttribute("disableSelection", false);
		}
		var parameters = new Object();
		parameters.action = "com.dassault_systemes.enovia.downloadpackage.ui.DownloadPackage:actionDownloadPackage";
		
		modifyAndSubmitForwardForm(parameters, null, "../DownloadPackage/Execute.jsp");
	}
	
	function getDisabledCheckboxesId(objectId,imgData,zipStructure,saveASPDF,table,lang,timeZone,packageName) {
		var frame = this.parent;
		var displayRows = emxUICore.selectNodes(frame.oXML, "/mxRoot/rows//r");
		var newObjIdAndNewName = new String();
		var sameNameFileArray = new Array();
		var duplicateFileName = false;
		
		for(var i=0;i < displayRows.length; i++) {
			var displayRow = displayRows[i];
			var isChecked = displayRow.getAttribute("checked");
			var rowId = displayRow.getAttribute("id");
			var oId = displayRow.getAttribute("o");
			var newName = frame.emxEditableTable.getCellValueByRowId(rowId, "NewName");
			var newEmxTableRowId = oId + "@";
			var parentId = displayRow.getAttribute("p");
			if(parentId) {
				newEmxTableRowId += parentId;
			}
			newEmxTableRowId += "@" + rowId;
			if(isChecked=="checked") {
				var isDisabled = displayRow.getAttribute("disableSelection");
				if(newObjIdAndNewName.length!=0) {
					newObjIdAndNewName += "|";
				}
				newObjIdAndNewName += newEmxTableRowId;
				if(!isDisabled) {
					var name = frame.emxEditableTable.getCellValueByRowId(rowId, "Name");
					var fileActualName = name.value.current.actual;
					if(!duplicateFileName) {
						if(sameNameFileArray.indexOf(fileActualName) != -1) {
							duplicateFileName = true;
							break;
						}
						sameNameFileArray.push(fileActualName);
					}
					newObjIdAndNewName += '@';
					newObjIdAndNewName += fileActualName;
				}
				newObjIdAndNewName += "=";
				newObjIdAndNewName += newName.value.current.actual;
			}
			
		}
		if(duplicateFileName) {
			alert("<%=getString(context,
			"DownloadPackage.Error.Message.SameNameFiles")%>");
			return;
		}
		var mainPageListHidden = findFrame(getTopWindow().getWindowOpener(),"listHidden");
	    var mainPageHTML = mainPageListHidden.document.body.innerHTML;
	    var formOpenHTML = "<form id=\"downloadHiddenForm\" name=\"downloadHiddenForm\" action=\"../DownloadPackage/Execute.jsp\" method=\"POST\">";

	    var parameters = new Object();
	    parameters.newEmxTableRowId = newObjIdAndNewName;
	    parameters.objectId = objectId;
	    parameters.executeAction = "com.dassault_systemes.enovia.downloadpackage.ui.DownloadPackage:actionDownloadPackage";
	    parameters.DownloadPackageZipStructure = zipStructure;
	    parameters.DownloadPackageSaveAsPDF = saveASPDF;
	    parameters.validateToken = false;
	    parameters.ImageData = imgData;
	    parameters.table = table;
	    parameters.lang = lang;
	    parameters.timeZone = timeZone;
	    parameters.Package = packageName;
	    
	    var fullFormHTML = createInputHTMLAndAttachToForm(formOpenHTML, parameters);
	    mainPageListHidden.document.body.innerHTML = fullFormHTML;
	    
	    var downloadHiddenForm = mainPageListHidden.document.getElementById("downloadHiddenForm");
	    downloadHiddenForm.submit();
		alert("<%=getString(context,
		"DownloadPackage.Message.DoNotCloseWindow")%>");
		getTopWindow().close();
	}
	
	function createInputHTMLAndAttachToForm (formHTML, newParameters) {
		var inpuHTML = new String();
		for(var parameterName in newParameters) {
			inpuHTML += "<input type=\"hidden\" name=\"" + parameterName +"\" value=\"" + newParameters[parameterName] + "\" />";
		}
		formHTML += inpuHTML;
		formHTML += "</form>";
		return formHTML;
	}
	
	function createInputElemntsAndAttachToForm(formObj, newParameters) {
		for(var parameterName in newParameters) {
			var inputElement = document.createElement("input");
			inputElement.setAttribute("type", "hidden");
			inputElement.setAttribute("name", parameterName);
			inputElement.setAttribute("value", newParameters[parameterName]);
			formObj.appendChild(inputElement);
		}
	}
	
	function formDownloadPackageURL(selectedId) {
	    var parameters = new Object();
	    parameters.expandProgram = "com.dassault_systemes.enovia.downloadpackage.ui.DownloadPackage:actionGetEntirePackagingData";
	    parameters.table = "DownloadPackageTable";
	    parameters.mode = "edit";
	    parameters.submitURL = "../DownloadPackage/Execute.jsp?executeAction=com.dassault_systemes.enovia.downloadpackage.ui.DownloadPackage:actionGetDisabledCheckboxesId";
	    parameters.suiteKey = "DownloadPackage";
	    parameters.submitLabel = "DownloadPackage.Submit.Label";
	    parameters.editLink = true;
	    parameters.preProcessJavaScript = "checkSelection";
	    parameters.selection = "multiple";
	    parameters.toolbar = "DownloadPackageToolbar";
		parameters.validateToken = false;
		parameters.showClipboard = false;
		parameters.autoFilter = false;
		parameters.massUpdate = false;
		parameters.HelpMarker = "emxhelpdownloadpackage";
		
	    if(selectedId && selectedId.length!=0) {
	    	parameters.selectedID = selectedId;	    	
	    }
	    
	    var excludeParameters = new Array("suiteKey");
	    modifyAndSubmitForwardForm(parameters,excludeParameters, "../common/emxIndentedTable.jsp");
	}
	
	function errorMessageForNoObjectId() {
		alert("no object is selected and no objectId is found");
	}
	
	function messageForNoFiles() {
		alert("<%=getString(context,"DownloadPackage.Message.NoFilesForDownload")%>"); //XSSOK
	}
</script>
