<%--
  iwExecute.jsp

  Copyright (c) 2007 Integware, Inc.  All Rights Reserved.
  This program contains proprietary and trade secret information of
  Integware, Inc.
  Copyright notice is precautionary only and does not evidence any
  actual or intended publication of such program.

  $Rev: 822 $
  $Date: 2012-02-20 11:14:28 -0700 (Mon, 20 Feb 2012) $
--%>


<%@include file="emxNavigatorInclude.inc"%>
<%@include file="emxNavigatorTopErrorInclude.inc"%>
<%@include file="../common/enoviaCSRFTokenValidation.inc"%>
<%@page import="com.matrixone.apps.domain.util.*, com.matrixone.apps.domain.util.XSSUtil"%>

<!-- Bug 43058 - Start -->
<!--
  Note:  This script is included in "emxUIConstantsInclude.inc"  
<script language="JavaScript" src="../common/scripts/emxUIConstants.js" type="text/javascript"></script>
-->
<%@include file = "emxUIConstantsInclude.inc"%>
<!-- Bug 43058 - End -->
<%!
    public static String emxReplaceString(String string, String value, String replace) {
        int index = string.indexOf(value, 0);
        while (index != -1) {
            string = string.substring(0, index) + replace
                    + string.substring(index + value.length(), string.length());
            index = string.indexOf(value, index + replace.length());
        }

        return string;
    }
%>
<%
    String programParam = emxGetParameter(request, "program");
    String completeParam = emxGetParameter(request, "complete");
    String errorParam = emxGetParameter(request, "error");
    String showProgressParam = emxGetParameter(request, "showProgress");
    String closeWindow = emxGetParameter(request, "close"); // close window that this script runs in?
    String suiteKey = emxGetParameter(request, "suiteKey");

    String action = "CONTINUE"; // Default Action is Continue - Commits transaction
    String message = "";

    // Note: I investigated where this is used and found the only place the 
    // 'showProgress' parameter is used is in the command 'LDMRECOPromoteSelected'
    // I wanted to understand is this is needed, but am unable to run LDMR at this point
    // due to all the changes in 2012. Will need to come back at a later date and 
    // re evaluate this, once LDMR is working again.
    if (showProgressParam != null && showProgressParam.equalsIgnoreCase("true")) {
%>
<script>
    turnOnProgress();
</script>
<%
        out.flush();
    } // end of if showProgress

    // include the form validation files
    StringList incFileList = UIForm.getJSValidationFileList(context, suiteKey);
    String fileTok = "";
    for (StringItr keyItr = new StringItr(incFileList); keyItr.next();) {
        fileTok = keyItr.obj();
        if (fileTok.endsWith(".jsp")) {
%>
<jsp:include page="<%= XSSUtil.encodeForJavaScript(context, fileTok) %>" flush="true" />
<%
        } else if (fileTok.endsWith(".js")) {
%>
<script language="javascript" src="<%= XSSUtil.encodeForJavaScript(context, fileTok) %>"></script>
<%
        }
    }

    try {
        // get the program and method to execute.
        String program = "";
        String method = "";
        int pos = programParam.indexOf(":");
        if (pos == -1) {
            program = programParam;
            method = "mxMain";
        } else {
            program = programParam.substring(0, pos);
            method = programParam.substring(pos + 1);
        }

        HashMap paramMap = new HashMap();
        HashMap requestMap = new HashMap(request.getParameterMap());
        Enumeration enumTokens = emxGetParameterNames(request);

        while (enumTokens.hasMoreElements()) {
            String name = (String) enumTokens.nextElement();
            String[] value = emxGetParameterValues(request, name);
            if (!name.equals("emxTableRowId") && value.length <= 1) {
                // Put the single String value into the map
                paramMap.put(name, emxGetParameter(request, name));
            }
            else {
                // Put the table row ids into the map as a String[]
                paramMap.put(name, value);
            }
        }
        // Add the language string for localization
        paramMap.put("languageStr", request.getHeader("Accept-Language"));
        // Add locale string for date format
        paramMap.put("localeObj", request.getLocale().toString());
		
        String[] args = JPO.packArgs(paramMap);

        ContextUtil.startTransaction(context, true);
        HashMap returnMap = new HashMap();

        try {
            returnMap = (HashMap) JPO.invoke(context, program, null, method, args, HashMap.class);
        } catch (Exception exJPO) {
            throw new FrameworkException(exJPO.toString());
        }

        if (returnMap != null && returnMap.size() > 0) {
            String callback = (String) returnMap.get("callback");
            if (completeParam == null || completeParam.equals("")) {
                completeParam = callback;
            }

            message = (String) returnMap.get("Message");
            String returnAction = (String) returnMap.get("Action");

            if (returnAction != null && !returnAction.equals("")) {
                action = returnAction;
            }

            if (message != null && !"".equals(message)) {
                String suiteDir = "";
                String registeredSuite = suiteKey;

                if (suiteKey != null && suiteKey.startsWith("eServiceSuite")) {
                    registeredSuite = suiteKey.substring("eServiceSuite".length());
                }

                String stringResFileId = UINavigatorUtil.getStringResourceFileId(context, registeredSuite);
                if (stringResFileId == null || stringResFileId.length() == 0) {
                    stringResFileId = "emxFrameworkStringResource";
                }

                String alertMessage = i18nNow.getI18nString(message, stringResFileId, request
                        .getHeader("Accept-Language"));
                if ((alertMessage == null) || ("".equals(alertMessage))) {
                    alertMessage = message;
                }

                alertMessage = FrameworkUtil.findAndReplace(alertMessage, "\n", "\\n");
                alertMessage = FrameworkUtil.findAndReplace(alertMessage, "\r", "\\r");
%>
<script language="javascript" type="text/javaScript">
    alert("<%= XSSUtil.encodeForJavaScript(context, alertMessage) %>");
</script>
<%
            } // end if message != null

            // Replace $<id> token in JS call with returned object id
            String returnObjectId = (String) returnMap.get("objectId");
            if (returnObjectId != null && completeParam != null) {
            	returnObjectId = "\'" + returnObjectId + "\'";
                completeParam = emxReplaceString(completeParam, "$<id>", returnObjectId);
            }
        }

        // Get the table ids
        String[] tableIds = emxGetParameterValues(request, "emxTableRowId");
        if (tableIds != null) {
            Map objectMap = UIUtil.parseRelAndObjectIds(context, tableIds, false);
            tableIds = (String[]) objectMap.get("objectIds");

            // Iterate over the table ids, building a pipe-delimited string
            String tableIdString = "";
            for (int i = 0; i < tableIds.length; i++) {
                if (i > 0) {
                    tableIdString += "|";
                }
                tableIdString += tableIds[i];
            }

            // Replace $<tableIds> token in JS call with submitted table object ids
            if (completeParam != null) {
                completeParam = emxReplaceString(completeParam, "$<tableIds>", tableIdString);
            }
        }
    }
    catch (Exception ex) {
        ex.printStackTrace();
        ContextUtil.abortTransaction(context);
    }
    finally {
        if (action != null && action.equalsIgnoreCase("continue")) {
            // If the object Vault is changed the new BusId to be passed
            ContextUtil.commitTransaction(context);
            if (completeParam != null && completeParam.startsWith("javascript:")) {
                out.println("<script language=\"javascript\">");
                out.println(completeParam.substring(completeParam.indexOf("javascript:") + 11) + ";");
            }

            if (closeWindow != null && closeWindow.equalsIgnoreCase("true")) {
                out.println("getTopWindow().close();");
            }

            out.println("</script>");
        } else {
            ContextUtil.abortTransaction(context);

            if (errorParam != null && errorParam.startsWith("javascript:")) {
                out.println("<script language=\"javascript\">"
                        + errorParam.substring(errorParam.indexOf("javascript:") + 11) + ";</script>");
            }
        }
    }
%>

<%@include file="emxNavigatorBottomErrorInclude.inc"%>
