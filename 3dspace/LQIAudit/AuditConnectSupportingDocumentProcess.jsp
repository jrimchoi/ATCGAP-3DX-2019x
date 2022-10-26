<%@ page import = "matrix.db.*, matrix.util.* , com.matrixone.servlet.*, java.util.*,
                   java.io.BufferedReader, java.io.StringReader" %>

<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<%@include file = "../common/eServiceUtil.inc"%>
<%@include file = "../common/emxFormUtil.inc"%>
<html>

<%
	response.setHeader("Content-Type", "text/html; charset=UTF-8");
    response.setContentType("text/html; charset=UTF-8");
		
	//Context context = Framework.getContext(session);
	String xml = "";
	String filter = "";
	String strValue="";
	boolean bhasProject=false;
	boolean returnVal=false; 

	if (context != null)
	{
		HashMap requestMap = UINavigatorUtil.getRequestParameterMap(request);
		if (false) { // For development and troublechooting
			for(Iterator itr = requestMap.keySet().iterator(); itr.hasNext();) {
				String key = (String) itr.next();
				}
		}
		
		String form = emxGetParameter(request, "form");
		String strObjectId1 = emxGetParameter(request,"objectId");
		//String objectId = emxGetParameter(request,"objectId");
		String[] objectId = request.getParameterValues("emxTableRowId");
		String type = emxGetParameter(request, "type");
		//String name = emxGetParameter(request, "Name");
		String parentOID =  emxGetParameter(request, "parentOID");
		HashMap programMap = new HashMap();
		programMap.put("requestMap",requestMap);
		programMap.put("objectId",objectId);
		programMap.put("type",type);
		programMap.put("parentOID",parentOID);
	
		String[] methodargs = JPO.packArgs(programMap);
							
		HashMap returnMapNew = (HashMap)JPO.invoke(context, "com.dassault_systemes.enovia.lsa.audit.services.trigger.AuditUtils", null,"connectSupportingDocument", methodargs, HashMap.class);
			
		Iterator iterator = returnMapNew.values().iterator();
		
		
		while(iterator.hasNext() )
		{
			strValue+=(String) iterator.next()+",";
			returnVal=true;
     	}

	}//if(context)
%>
<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
<script language=javascript>
<%if(returnVal==true){%>
                alert("<%=XSSUtil.encodeForJavaScript(context,strValue)%>These objects are already Connected");
                <%}%>
                parent.window.getWindowOpener().parent.document.location.href=parent.window.getWindowOpener().parent.document.location.href;
		getTopWindow().window.closeWindow();
				
</script>
</html>
