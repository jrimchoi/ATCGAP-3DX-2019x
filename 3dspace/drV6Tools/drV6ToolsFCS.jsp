<%@ page errorPage = "emxNavigatorErrorPage.jsp"%>
<%@ page import = "com.designrule.drv6tools.common.drContext, com.designrule.drv6tools.debug.drLogger, com.designrule.drv6tools.Operations, com.designrule.drv6tools.eFunctionType, com.designrule.drv6tools.Result"%>
<%@ page import = "java.io.FileInputStream" %>
<%@ page import = "java.io.BufferedInputStream" %>
<%@ page import = "java.io.File" %>
<%@ page import = "java.io.IOException" %>
<%@ page import = "java.util.Map" %>
<%@ page import = "java.util.HashMap" %>
<%@ page import = "java.net.URLEncoder" %>
<%@ page import = "matrix.db.Context" %>
<%@ page import = "java.util.Locale" %>
<%@ page import = "org.apache.log4j.Logger" %>
<script language = "Javascript" src="../common/scripts/emxUIConstants.js"></script>
<%
	Logger log = drLogger.getLogger(drContext.class);
	log.debug("JSP - Running drV6Tools on FCS");
	String hostname = request.getParameter("mxhost");
	log.debug("JSP - hostname = " + hostname);
	String sessionId = request.getParameter("mxsessionId");
	log.debug("JSP - sessionId = " + sessionId);
	String user = request.getParameter("mxuser");
	log.debug("JSP - user = " + user);
	String password = request.getParameter("mxpassword");
	String role = request.getParameter("mxrole");
	String language = request.getParameter("mxlanguage");
	String vault = request.getParameter("mxvault");

	Context context = new Context(hostname);
	context.setUser(user);
	context.setPassword(password);
	context.setRole(role);
	context.setVault(vault);
	context.setLocale(new Locale(language));
	context.setCookies("JSESSIONID=" + sessionId);
	context.connect();

    String operation = request.getParameter("operation");
    String objectId = request.getParameter("objectId");
    String tableRowIdList[] = request.getParameterValues("emxTableRowId");
    String drtoolsKey = request.getParameter("drtoolsKey");
	if(drtoolsKey == null || drtoolsKey.isEmpty()) {
		drtoolsKey = request.getParameter("drToolsKey");
	}
	String drtoolsSilent = request.getParameter("drtoolsSilent");
    Map<String, String[]> parameterMap = request.getParameterMap();
    
    String tableRowIds = null;
    if (tableRowIdList != null) {
            tableRowIds = "";
            for (int i = 0; i < tableRowIdList.length; i++)
                    tableRowIds += "," + tableRowIdList[i];
            tableRowIds = tableRowIds.substring(1);
    }
    
	log.debug("JSP - drToolsKey = " + drtoolsKey);
    log.debug("JSP - operation = " + operation);
    log.debug("JSP - objectId = " + objectId);
    log.debug("JSP - tableRowIds = " + tableRowIds);
    
    Operations op = new Operations();
	//START : Add client timeZone offset value to params
	Map<String, String[]> parameterUpdateMap = new HashMap<String, String[]>();
	String timeZone = (String)session.getValue("timeZone");
	String[] timeZoneValue = {timeZone};
	parameterUpdateMap.put("timeZone",timeZoneValue);
	parameterUpdateMap.putAll(parameterMap);
	//END : Add client timeZone offset value to params
    Result r = op.exec(context, objectId, tableRowIds, operation, false, eFunctionType.server, drtoolsKey, parameterUpdateMap);
    String mode = r.type.toString();
	String postProcessTargetFrame = r.targetFrame;
	String postProcessURL = r.postProcessURL;
    if(mode != null && mode.equals("file")) {
        BufferedInputStream buffer = null;
        ServletOutputStream outputStream = null;
        File fileObj = null;
        try {

            outputStream = response.getOutputStream();

            fileObj = new File(r.filePath);
            if (fileObj.exists()) {
                //set response headers
                response.setContentType(r.contentType);

                response.addHeader(
                        "Content-Disposition", "attachment; filename=" + r.fileName);

                response.setContentLength((int) fileObj.length());

                FileInputStream input = new FileInputStream(fileObj);
                buffer = new BufferedInputStream(input);
                int readBytes = 0;

                //read from the file; write to the ServletOutputStream
                while ((readBytes = buffer.read()) != -1) {
                    outputStream.write(readBytes);
                }
            } else {
                throw new Exception("Failed to find file at " + fileObj.getPath());
            }

        } catch (IOException ioe) {

            throw new Exception(ioe.getMessage());

        } finally {

            //close the input/output streams
            if (outputStream != null) {
                outputStream.close();
				outputStream.flush();
            }
			out.clear();
	        out = pageContext.pushBody();
				
            if (buffer != null) {
                buffer.close();
            }
            try {
                if (fileObj != null && fileObj.exists()) {
                    fileObj.delete();
                }
            } catch (Exception e) {
            }
        }
    }
    String message = "";
	if(drtoolsSilent == null || !drtoolsSilent.equalsIgnoreCase("true")) {
                if(operation == null) {
                    operation = "";
                }
		if (! r.message.isEmpty())
				message = r.message;
		else if (! r.output.isEmpty())
				message = r.output;
		else if (r.code != 0)
				message = "Error during operation " + operation;
		else
				message = "Operation " + operation + " ended successfully";
		message = message.replace("\n", "\\n");
		if (r.code == 0)
				message = "Notice:\\n\\n" + message;
		else
				message = "Error:\\n\\n" + message;
		message = message.replace("\"", "\\\"");
	}
	
	log.debug("JSP - message = " + message);
	log.debug("JSP - mode = " + mode);	
%>
<script language="Javascript">
    var message = "<%=message%>";
    if (message != "") alert(message);
    var mode = "<%=mode%>";
    if (mode == "refresh") {
        var content = findFrame(top, "detailsDisplay");
        if (content == null) content = findFrame(top, "content");
        if (content != null) content.document.location.href = content.document.location.href;
    } else if (mode == "forward") {
        var content = findFrame(top, "detailsDisplay");
        if (content == null) content = findFrame(top, "<%=postProcessTargetFrame%>");
        if (content != null) content.document.location.href = "<%=postProcessURL%>";	
	}
</script>
