 <%-- ECMCommonRefresh.jsp -  This is an common ECM jsp file for refreshing the pages.
   Copyright (c) 1992-2018 Dassault Systemes.
   All Rights Reserved.
--%>

<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<%@ page import = "matrix.db.*,matrix.util.*,java.util.*"%>
<%@include file = "../common/emxNavigatorInclude.inc"%>

<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
<script language="javascript" src="../common/scripts/emxUICore.js"></script>
<script language="JavaScript" src="../common/scripts/emxUIModal.js"></script>
<script language="JavaScript" src="../emxUIFilterUtility.js"></script>
<script language="JavaScript" src="../common/scripts/emxUICommonHeaderBeginJavaScriptInclude.js"></script>
<script language="JavaScript" src="../common/scripts/emxUISlideIn.js"></script>
<script language="Javascript" src="../common/scripts/emxUIUtility.js"></script>

<%

	String tableRowId       = emxGetParameter(request, "tableRowId");
    String commandName      = emxGetParameter(request, "commandName");
    String refreshStructure = emxGetParameter(request, "refreshStructure");
    String objectId	    = emxGetParameter(request, "objectId");
    String functionality    = emxGetParameter(request, "functionality");
    boolean sHas = false;
    
    if(!UIUtil.isNullOrEmpty(refreshStructure)) {
    	sHas = true;
    }
    
   
%>

<script language="Javascript">
    //XSSOK
	var sCommanName = "<%=commandName%>"; 
	//XSSOK
	var functionality = "<%=functionality%>";
	
	//XSSOK
	
	if (<%=sHas%>) {
		var frameObject = findFrame(getTopWindow(), sCommanName);
			if(frameObject != null) {
			frameObject.location.href = frameObject.location.href;
		} 
	}
	if(functionality == "editCOFromRMB" || functionality == "editCRFromRMB" || functionality == "editCAFromRMB") {
		var frameObject = findFrame(getTopWindow(), getTopWindow().commandName["targetFrameToRefresh"]);
		getTopWindow().commandName["targetFrameToRefresh"] = "";
		
		var varObjectId = "<%=XSSUtil.encodeForJavaScript(context,objectId)%>";
		var rowsToRefresh = emxUICore.selectNodes(frameObject.oXML, "/mxRoot/rows//r[@o = '" + varObjectId + "']");
		
		for (var i = 0; i < rowsToRefresh.length; i++) {
			frameObject.emxEditableTable.refreshRowByRowId(rowsToRefresh[i].getAttribute("id"));
		}		
	}
		if (getTopWindow().location.href.indexOf("targetLocation=popup") == -1) {
				getTopWindow().closeSlideInDialog();
			}else{
			var mycontentFrame  = findFrame(getTopWindow(),"detailsDisplay");
			getTopWindow().RefreshHeader();
			getTopWindow().deletePageCache();
			var reloadURL = mycontentFrame.location.href;
			mycontentFrame.location.href =  reloadURL;		
				}
	
</script>
<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>


