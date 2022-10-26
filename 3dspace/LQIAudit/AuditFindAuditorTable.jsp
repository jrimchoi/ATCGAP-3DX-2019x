<html>
<%-- Add all imports here --%>

<%-- Add all common includes here --%>
<%@include file = "../emxUICommonAppInclude.inc"%>
<%@include file = "../emxUICommonHeaderBeginInclude.inc" %>
<%@page import="com.dassault_systemes.enovia.lsa.Helper"%>
<%@page import="matrix.db.Context"%>
<%@page import="com.dassault_systemes.enovia.lsa.LSAException"%>
<%!
       private String getEncodedI18String(Context context, String key) throws LSAException {
              try {
                     return XSSUtil.encodeForJavaScript(context,Helper.getI18NString(context, Helper.StringResource.AUDIT, key));
              } catch (Exception e) {
                     throw new LSAException(e);
              }
       }
%> 
<body>
<form name = "Auditor" method = "post" >
<%@include file = "../common/enoviaCSRFTokenInjection.inc"%>
<%
    Map csrfTokenMap = ENOCsrfGuard.getCSRFTokenMap(context, session);
	HashMap requestMap = UINavigatorUtil.getRequestParameterMap(request);
	if (false) { // For development and troublechooting
			for(Iterator itr = requestMap.keySet().iterator(); itr.hasNext();) {
				String key = (String) itr.next();

			}
		}

		String isPopup = emxGetParameter(request, "isPopup");
		String portalMode = emxGetParameter(request, "portalMode");
		String form = emxGetParameter(request, "form");
		String objectId = emxGetParameter(request, "objectId");
		String type = emxGetParameter(request, "Type");
		String parentOID =  emxGetParameter(request, "parentOID");
		String SearchAuditor =  emxGetParameter(request, "SearchAuditor");
		String fieldName =  emxGetParameter(request, "fieldName");

		HashMap programMap = new HashMap();
		programMap.put("requestMap",requestMap);
		programMap.put("isPopup",isPopup);
		programMap.put("portalMode",portalMode);
		programMap.put("objectId",objectId);
		programMap.put("type",type);
		programMap.put("parentOID",parentOID);
		programMap.put("SearchAuditor",SearchAuditor);
		String[] methodargs = JPO.packArgs(programMap);
		String mAuditorList = (String) JPO.invoke(context, "com.dassault_systemes.enovia.lsa.audit.services.ui.AuditAudit", null, "getAuditor", methodargs,String.class);

	 
	 	String csrfTokenName = (String)csrfTokenMap.get(ENOCsrfGuard.CSRF_TOKEN_NAME);
	 	String csrfTokenValue = (String)csrfTokenMap.get(csrfTokenName);
	 

		%>
		<input type="hidden" name="requestMap" value="<%=/*XSS OK*/requestMap%>">
		<input type="hidden" name="objectId" value="<%=XSSUtil.encodeForJavaScript(context,objectId)%>">
		<input type="hidden" name="parentOID" value="<%=XSSUtil.encodeForJavaScript(context,parentOID)%>">
		<input type="hidden" name="fromDirection" value="">
		<input type="hidden" name="toDirection" value="">
		<input type="hidden" name="table" value="QICAUDAuditAuditor">
		<input type="hidden" name="header" value="<%=/*XSS OK*/getEncodedI18String(context,"LQIAudit.Common.Person")%>">
		<input type="hidden" name="sortColumnName" value="Name">
		<input type="hidden" name="sortDirection" value="ascending">
		<input type="hidden" name="CancelButton" value="true">
		<input type="hidden" name="fieldName" value="<%=XSSUtil.encodeForJavaScript(context,fieldName)%>">
		<input type="hidden" name="SearchAuditor" value="<%=XSSUtil.encodeForJavaScript(context,SearchAuditor)%>">
		<input type="hidden" name= "<%=ENOCsrfGuard.CSRF_TOKEN_NAME%>" value="<%=XSSUtil.encodeForJavaScript(context,csrfTokenName)%>">
 	    <input type="hidden" name= "<%=csrfTokenName%>" value="<%=XSSUtil.encodeForJavaScript(context,csrfTokenValue)%>">
		
			<script type="text/javascript">
				//var fieldname = document.Auditor.fieldName.value;
				var fieldname = '<%=XSSUtil.encodeForJavaScript(context,fieldName)%>';
				var submitURL = "../LQIAudit/AuditAuditorProcess.jsp?fieldName="+fieldname;
				document.Auditor.action = "../common/emxTable.jsp?program=com.dassault_systemes.enovia.lsa.audit.services.ui.AuditAudit:getAuditorNew&selection=single&SubmitURL="+submitURL;
				//document.Auditor.action = "../common/emxFullSearch.jsp?includeOIDprogram=com.dassault_systemes.enovia.lsa.audit.services.ui.AuditAudit:getAuditorNew&selection=single&SubmitURL=AuditAuditorProcess.jsp?fieldName="+fieldname;
				document.Auditor.target = "_parent";
				document.Auditor.submit();
			</script>

</form>
</body>
</html>
