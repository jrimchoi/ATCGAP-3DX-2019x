<%--  gapConnectBookmarkProcessSpecCreate.jsp -  This is an intermediate jsp to invoke webform
   Copyright (c) 1992-2018 Dassault Systemes.
   All Rights Reserved.
--%>

<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file="../components/emxSearchInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>

<%@page import="java.util.HashMap"%>
<%@page import="com.matrixone.apps.common.Search"%>
<%@page import="com.matrixone.apps.domain.util.FrameworkException"%>
<%@page import="com.matrixone.apps.domain.util.i18nNow"%>
<%@page import ="com.matrixone.apps.domain.util.EnoviaResourceBundle"%>
<%@page import="com.matrixone.apps.domain.DomainObject"%>

<%!
public String getBookmarkName(Context context, String sObjectId) throws Exception {	
	String sBookmarkName = "";
	DomainObject doObject = new DomainObject(sObjectId);
	sBookmarkName = (String) doObject.getInfo(context, "to["+DomainObject.RELATIONSHIP_WORKSPACE_VAULTS+"].from."+DomainConstants.SELECT_NAME);
	if(UIUtil.isNullOrEmpty(sBookmarkName)) {
		String sBookmarkVaultId = (String) doObject.getInfo(context, "to["+DomainObject.RELATIONSHIP_SUBVAULTS+"].from."+DomainConstants.SELECT_ID);
		return getBookmarkName(context, sBookmarkVaultId);
	}
	return sBookmarkName;
}
%>

<%
try {
		
	String objectId = (String)emxGetParameter(request,"objectId");
	//String strFrameName = (String)emxGetParameter(request,Search.REQ_PARAM_FRAME_NAME);
	String strFrameName = "slideInFrame";
	//String strFormName = (String)emxGetParameter(request,Search.REQ_PARAM_FORM_NAME);
	String strFormName = "emxCreateForm";
	String strFieldNameDisplay = (String)emxGetParameter(request,Search.REQ_PARAM_FIELD_NAME_DISPLAY);
	String strFieldNameActual = (String)emxGetParameter(request,Search.REQ_PARAM_FIELD_NAME_ACTUAL);
	String strTableRowId[] = emxGetParameterValues(request,"emxTableRowId");
	String strAttrFieldName = "gapProjectNumber";

	String error = "false";
	String strRetMsg = "";
	String selectedId = "";
	String selectedName = "";
	String selectedWorkspaceName = "";
	
	if (strTableRowId == null) {
		i18nNow i18nInstance = new i18nNow();
		String strLang = request.getHeader("Accept-Language");
		//Tenant changes
		strRetMsg = EnoviaResourceBundle.getProperty(context,"emxComponentsStringResource",context.getLocale(),"emxComponents.Search.Error.24"); 
		error = "true";
	}
	else {
  		String srcDestRelName = (String)emxGetParameter(request,"srcDestRelName");
		String isTo = (String)emxGetParameter(request,"isTo");
		String doConnect = (String)emxGetParameter(request,"doConnect");
		String doReConnect = (String)emxGetParameter(request,"doReConnect");
		String addProgram = (String)emxGetParameter(request,"addProgram");
		String[] emxTableRowId = new String[strTableRowId.length];
	
		boolean sExists = false;
		
		for (int i=0;i<strTableRowId.length;i++) {
			StringTokenizer strTokens = new StringTokenizer(strTableRowId[i], "|");
			if(strTokens.hasMoreTokens()) {
				selectedId = strTokens.nextToken();
			}
		}
				
		Search search = new Search();
		selectedName = search.getObjectName(context,selectedId);
		selectedWorkspaceName = (String) getBookmarkName(context, selectedId);
	}
%>
<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
<script language="javascript">
  function setAndRefresh() {
		var error= "<xss:encodeForJavaScript><%=error%></xss:encodeForJavaScript>";
		if(error == "true") {
			alert("<xss:encodeForJavaScript><%=strRetMsg%></xss:encodeForJavaScript>");
		} else {
			var txtTypeDisplay;
			var txtTypeActual;			
			//var txtAttrTypeDisplay;
			//var txtAttrTypeActual;
			
			//XSSOK
			var targetFrame = findFrame(getTopWindow().getWindowOpener(), "<%=strFrameName%>");
			var formName = "<xss:encodeForJavaScript><%=strFormName%></xss:encodeForJavaScript>";
			
			var fieldDisplay = "<xss:encodeForJavaScript><%=strFieldNameDisplay%></xss:encodeForJavaScript>";
			var fieldActual = "<xss:encodeForJavaScript><%=strFieldNameActual%></xss:encodeForJavaScript>";
			
			//var fieldAttrActual = "<xss:encodeForJavaScript><%=strAttrFieldName%></xss:encodeForJavaScript>";
			
			var elementCount;
			for(var i = 0; i<getTopWindow().getWindowOpener().document.forms.length; i++) {
		
				if(getTopWindow().getWindowOpener().document.forms[i].name == formName) {
					elementCount = i;
				}
			}
			//alert("i==="+i);
			if( targetFrame != null) {
				txtTypeDisplay = targetFrame.document.forms[0].elements[fieldDisplay];
				txtTypeActual = targetFrame.document.forms[0].elements[fieldActual];
				
				//txtAttrTypeActual = targetFrame.document.forms[0].elements[fieldAttrActual];
			} else {
				txtTypeDisplay = getTopWindow().getWindowOpener().document.forms[elementCount].elements[fieldDisplay];
				txtTypeActual = getTopWindow().getWindowOpener().document.forms[elementCount].elements[fieldActual];
				
				//txtAttrTypeActual = getTopWindow().getWindowOpener().document.forms[elementCount].elements[fieldAttrActual];
			}
		

			//XSSOK
		    //txtTypeDisplay.value = "<%=selectedName%>";
		    txtTypeDisplay.value = "<%=selectedWorkspaceName%>";
			txtTypeActual.value = "<%=selectedId%>";
			
			//txtAttrTypeActual.value = "<%=selectedWorkspaceName%>";
			//txtAttrTypeActual.readOnly = true;
			getTopWindow().closeWindow();
		}
   }

</script>

<html>
<body onload=setAndRefresh()>
</body>
</html>

<%
} // End of try
catch(Exception ex) {
   session.putValue("error.message", ex.getMessage());
 } // End of catch
%>

<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
