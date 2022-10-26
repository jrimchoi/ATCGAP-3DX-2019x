<%@page import="com.matrixone.apps.domain.DomainObject"%>
<%@page import="com.matrixone.apps.domain.util.PropertyUtil"%>
<jsp:include page="../common/scripts/emxUIFormHandler.js" />
<jsp:include page="../common/scripts/emxUICore.js" />
<%@page import ="com.matrixone.servlet.Framework"%>
<% matrix.db.Context context = Framework.getFrameContext(session); %>

var postResponse = function(response) {
    var jsObject = eval(response);
	var versionDocPolicy = "";
    $.each(jsObject.result, function(index,obj) {
    	if(obj.text=="versionDocPolicy") {
    		versionDocPolicy = obj.value;
    	}
    });
    
    var policyList = versionDocPolicy.split(",");
    var displayRows = emxUICore.selectNodes(window.oXML, "/mxRoot/rows//r");
	for(var i=0; i < displayRows.length; i++) {
		var rowID = displayRows[i];
		var id = rowID.getAttribute("id");
		var policy = window.emxEditableTable.getCellValueByRowId(id, "policy");
		var policyVal = policy.value.current.actual;
		rowID.setAttribute("checked", "checked");
		if(policyList.indexOf(policyVal)<0) {
			rowID.setAttribute("disableSelection", "true");	
		}
	}
}

function ajaxCall(requestType, requestUrl, requestData, requestCallBackFn) {
	var ajaxRequest = $.ajax({
   		url : requestUrl,
        type : requestType,
        data : requestData
     });
     ajaxRequest.done(requestCallBackFn);
}


function checkSelection() {
	var frame = this;
	var package = emxUICore.selectSingleNode(this.oXML, "/mxRoot/requestMap/setting[@name='RequestValuesMap']/items/item[@name='package']/items/value");
	var strPackage = "";
	if(package) {
        strPackage = isIE ? package.text : package.textContent;
	}
	var parameters = "Package="+strPackage;
	ajaxCall('POST','../DownloadPackage/Execute.jsp?executeAction=com.dassault_systemes.enovia.downloadpackage.ui.DownloadPackage:getVersionDocPolicyList&ajaxMode=true', parameters, postResponse);
}
