<%@ include file = "../emxUICommonAppInclude.inc"%>
<%@ page errorPage = "emxNavigatorErrorPage.jsp"%>
<%@ page import = "com.designrule.drv6tools.common.drContext, com.designrule.drv6tools.debug.drLogger, com.designrule.drv6tools.Operations, com.designrule.drv6tools.eFunctionType, com.designrule.drv6tools.Result,com.matrixone.apps.domain.DomainObject"%>
<%@ page import = "java.io.FileInputStream" %>
<%@ page import = "java.io.BufferedInputStream" %>
<%@ page import = "java.io.File" %>
<%@ page import = "java.io.IOException" %>
<%@ page import = "java.util.Map" %>
<%@ page import = "java.util.Map" %>
<%@ page import = "java.net.URLEncoder" %>
<%@ page import = "org.apache.log4j.Logger" %>
<script language = "Javascript" src="../common/scripts/emxUIConstants.js"></script>
<%
    Logger log = drLogger.getLogger(drContext.class);
	boolean sentToFCS = false;
	String runOnFCS = emxGetParameter(request, "runOnFCS");
	if(runOnFCS != null && runOnFCS.equalsIgnoreCase("true") ) {
		log.debug("JSP - runOnFCS set to true. Checking for users remote FCS");
		drContext drcontext = new drContext(context);
		String fcsURL = drcontext.getCurrentUserFCSURL();
		if(fcsURL != null && !fcsURL.isEmpty()) {
			log.debug("JSP - Users remote FCS URL = " + fcsURL);
			StringBuilder drFcsURL = new StringBuilder(fcsURL);
			drFcsURL.append("/drV6Tools/drV6ToolsFCS.jsp?");
			String queryString = request.getQueryString();
			drFcsURL.append(queryString);
			String url = request.getRequestURL().toString();
			log.trace("JSP - RequestURL " + url);
			String hostname = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";
			log.trace("JSP - hostname " + hostname);
			drFcsURL.append("&mxhost=");
			drFcsURL.append(URLEncoder.encode(hostname, "UTF-8"));
			String sessionId = session.getId();
			log.trace("JSP - sessionId " + sessionId);
			drFcsURL.append("&mxsessionId=");
			drFcsURL.append(URLEncoder.encode(sessionId, "UTF-8"));
			String user = context.getUser();
			log.trace("JSP - user " + user);
			drFcsURL.append("&mxuser=");
			drFcsURL.append(URLEncoder.encode(user, "UTF-8"));
			String password = context.getPassword();
			log.trace("JSP - password " + password);
			drFcsURL.append("&mxpassword=");
			if(password != null && !password.isEmpty()) {
				drFcsURL.append(URLEncoder.encode(password, "UTF-8"));
			}
			String role = context.getRole();
			log.trace("JSP - role " + role);
			drFcsURL.append("&mxrole=");
			if(role != null && !role.isEmpty()) {
				drFcsURL.append(URLEncoder.encode(role, "UTF-8"));
			}
			if(context.getLocale() != null) {
				String language = context.getLocale().getLanguage();
				log.trace("JSP - language " + language);
				drFcsURL.append("&mxlanguage=");
				if(language != null && !language.isEmpty()) {
					drFcsURL.append(URLEncoder.encode(language, "UTF-8"));
				}
			}
			String vault = context.getVault().getName();
			log.trace("JSP - vault " + vault);
			drFcsURL.append("&mxvault=");
			if(vault != null && !vault.isEmpty()) {
				drFcsURL.append(URLEncoder.encode(vault, "UTF-8"));
			}
			String sendToDRFCSURL = drFcsURL.toString();
			log.debug("JSP - Sending redirect to: " + sendToDRFCSURL);
			response.sendRedirect(sendToDRFCSURL);
			sentToFCS = true;
		}
	} 

	
	if(sentToFCS == false)
	{
		log.debug("Running drV6Tools on MCS");
	    String operation = emxGetParameter(request, "operation");
	    String objectId = emxGetParameter(request, "objectId");
	    String tableRowIdList[] = emxGetParameterValues(request, "emxTableRowId");
	    String drtoolsKey = emxGetParameter(request, "drtoolsKey");
		if(drtoolsKey == null || drtoolsKey.isEmpty()) {
			drtoolsKey = emxGetParameter(request, "drToolsKey");
		}
		//System.out.println("~~~~~~~~~~~~~~~~~~~tableRowIdList :: "+tableRowIdList);
		
		
		String drtoolsSilent = emxGetParameter(request, "drtoolsSilent");
	    Map<String, String[]> parameterMap = request.getParameterMap();
	    
	    String tableRowIds = null;
	    if (tableRowIdList != null) {
	            tableRowIds = "";
	            for (int i = 0; i < tableRowIdList.length; i++)
	                    tableRowIds += "," + tableRowIdList[i];
	            tableRowIds = tableRowIds.substring(1);
	    }
	    
    	log.trace("JSP - drToolsKey = " + drtoolsKey);
        log.trace("JSP - operation = " + operation);
        log.trace("JSP - objectId = " + objectId);
        log.trace("JSP - tableRowIds = " + tableRowIds);
	    
	    Operations op = new Operations();
		//START : Add client timeZone offset value to params
		Map<String, String[]> parameterUpdateMap = new HashMap<String, String[]>();
		String timeZone = (String)session.getValue("timeZone");
		String[] timeZoneValue = {timeZone};
		parameterUpdateMap.put("timeZone",timeZoneValue);
		parameterUpdateMap.putAll(parameterMap);
		//System.out.println("~~~~~~~~~~~~~~~~~~~11111111111parameterUpdateMap :: "+parameterUpdateMap);
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
	String strFileName = r.fileName;
	
	// read Part name and revision
	if (strFileName.endsWith(".zip") && objectId!=null && !"".equals(objectId))
	{
		DomainObject doPart = DomainObject.newInstance(context, objectId);
		strFileName = doPart.getInfo(context, DomainObject.SELECT_NAME)+".zip";
	}
	else if (strFileName.endsWith(".zip"))
	{
		strFileName = "GAP_PDFs.zip";
	}
	
	            outputStream = response.getOutputStream();
	
	            fileObj = new File(r.filePath);
				//	System.out.println("~~~~~~~~~~~~~~~~~~~r.filePath1111 :: "+r.filesAndFoldersForCleanup);
	            if (fileObj.exists()) {
	                //set response headers
	                response.setContentType(r.contentType);
	
	                 response.addHeader(					
	                        "Content-Disposition", "attachment; filename=\"" + strFileName + "\"");
	
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
		try {
			if (op != null && r != null) {
				op.cleanUpTempFilesAndFolders(r);
			}
		} catch (Exception e) {
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

		log.trace("JSP - message = " + message);
		log.trace("JSP - mode = " + mode);	
	    
		if(r.code == 1 && "RunDRToolsServerCommandCheckTrigger".equalsIgnoreCase(operation)){
			%>	
				<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
				<script language="javascript" src="../common/scripts/emxUICore.js"></script>
				<script language="javascript" src="../common/scripts/emxUIModal.js"></script>
				<script type="text/javascript">
					showNonModalDialog("../drV6Tools/drErrorReportDialog.jsp");
				</script>
			<%	return;
		}
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
<%	
	}
%>