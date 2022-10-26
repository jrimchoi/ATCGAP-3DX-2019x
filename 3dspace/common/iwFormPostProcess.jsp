<%--
  iwFormPostProcess.jsp

  Copyright (c) 2007 Integware, Inc.  All Rights Reserved.
  This program contains proprietary and trade secret information of
  Integware, Inc.
  Copyright notice is precautionary only and does not evidence any
  actual or intended publication of such program.

  $Rev: 846 $
  $Date: 2012-03-23 12:36:57 -0600 (Fri, 23 Mar 2012) $
--%>

<%@ include file="emxNavigatorInclude.inc" %>
<%@ include file="emxNavigatorTopErrorInclude.inc" %>
<%@page import="com.matrixone.apps.domain.util.XSSUtil"%>


<jsp:useBean id="formEditBean" class="com.matrixone.apps.framework.ui.UIForm" scope="session"/>

<%
    String processJPO = emxGetParameter(request, "processJPO");
    String timeStamp = emxGetParameter(request, "timeStamp");
    String suiteKey = emxGetParameter(request, "suiteKey");
    String complete = emxGetParameter(request, "complete");
    String targetLocation = emxGetParameter(request, "targetLocation");


    if (complete!=null && complete.indexOf("javascript:") >= 0)
        complete = complete.substring(11, complete.length());


    if (processJPO != null && !"".equals(processJPO) && processJPO.indexOf(":") > 0) {
        HashMap programMap = new HashMap(6);
        HashMap paramMap = new HashMap(6);

        Enumeration paramNames = request.getParameterNames();

        while (paramNames.hasMoreElements()) {
            String paramName = (String) paramNames.nextElement();
            String[] paramValues = emxGetParameterValues(request, paramName);

            if (paramValues.length <= 1) // this is a string value
                paramMap.put(paramName, emxGetParameter(request, paramName));
            else                         // this is an array
                paramMap.put(paramName, paramValues);
        }

        //Added EditAction paramter
        paramMap.put("EditAction", "done");
        programMap.put("requestMap", UINavigatorUtil.getRequestParameterMap(pageContext));
        programMap.put("paramMap", paramMap);
        HashMap formMap = formEditBean.getFormData(timeStamp);
        programMap.put("formMap", formMap);

        String[] methodargs = JPO.packArgs(programMap);
        String strJPOName = processJPO.substring(0, processJPO.indexOf(":"));
        String strMethodName = processJPO.substring(processJPO.indexOf(":") + 1, processJPO.length());

        HashMap returnMap = null;
        String message = null;
        String action = null;
        String callback = null;
        String objectId = null;
        try {
          context = (matrix.db.Context) request.getAttribute("context");
            returnMap = (HashMap) JPO.invoke(context, strJPOName, null, strMethodName, methodargs, HashMap.class);
        } catch (Exception exJPO) {
            emxNavErrorObject.addMessage(exJPO.toString().trim());
        }
        if (returnMap != null && returnMap.size() > 0) {
            message  = (String) returnMap.get("Message");
            action   = (String) returnMap.get("Action");
            callback = (String) returnMap.get("callback");

            if (callback != null && !"".equals(callback))
            {
              if (callback.indexOf("javascript:") >= 0)
                callback = callback.substring(11, callback.length());

              complete = callback;
            }

            if (message != null && !"".equals(message)) {
                String suiteDir = "";
                String registeredSuite = suiteKey;

                if (suiteKey != null && suiteKey.startsWith("eServiceSuite"))
                    registeredSuite = suiteKey.substring("eServiceSuite".length());

                String stringResFileId = UINavigatorUtil.getStringResourceFileId(context, registeredSuite);
                if (stringResFileId == null || stringResFileId.length() == 0)
                    stringResFileId = "emxFrameworkStringResource";

                String alertMessage = i18nNow.getI18nString(message, stringResFileId, request.getHeader("Accept-Language"));
                if ((alertMessage == null) || ("".equals(alertMessage))) {
                    alertMessage = message;
                }

                alertMessage = FrameworkUtil.findAndReplace(alertMessage, "\n", "\\n");
                alertMessage = FrameworkUtil.findAndReplace(alertMessage, "\r", "\\r");

%>
<script language="javascript" type="text/javaScript">
    alert("<%=XSSUtil.encodeForJavaScript(context, alertMessage)%>");
</script>
<%
        }

        objectId = (String) returnMap.get("objectId");
    }
%>

    <%if (objectId!=null){%>
        <script language="javascript" type="text/javaScript">
            <%if (complete!=null && !complete.equals("")) {
                 // if the form was used to create a new object then substitute the object id
                complete = complete.replaceAll("\\$<id>", objectId); %>
        		<%= XSSUtil.encodeForJavaScript(context, complete) %>
            <%} else {%>
            	var url = '../common/emxTree.jsp?objectId=<%=XSSUtil.encodeForJavaScript(context, objectId)%>';
            	<%if("slidein".equalsIgnoreCase(targetLocation)){%>
					var contentFrame = getFormContentFrame();
					if(contentFrame){
    					contentFrame.location.replace(url);
					}
					getTopWindow().getWindowOpener().getTopWindow().content.location.replace(url);
				<%} else {%>
                	getTopWindow().getWindowOpener().getTopWindow().content.location.replace(url);
				<%}%>
            <%}%>
         
            <%if("slidein".equalsIgnoreCase(targetLocation)){%>
					getTopWindow().closeSlideInDialog();
				<%} else {%>
 					//The following line is critical to stop javascript processing in the emxFormEditProcess.jsp page
            		document.location="about:blank";
            		getTopWindow().close();
				<%}%>
          
        		</script>
    		<%} else {
        			if (complete!=null && !complete.equals("")) {%>
          				<script language="javascript" type="text/javaScript">
            			<%= XSSUtil.encodeForJavaScript(context, complete) %>
          				</script>
        			<%}
      			}

              // Bug 43261 - Start - Need ability to abort transaction
              if  (action != null && action.equalsIgnoreCase("stop")) {
                  ContextUtil.abortTransaction(context);
                  %>
                  <script language="javascript" type="text/javaScript">
                      //The following line is critical to stop javascript processing in the emxFormEditProcess.jsp page
                      document.location="about:blank";
		              getTopWindow().close();
		          </script>
		          <%
              }
              // Bug 43261 - End 
    	} else {
        	if (complete!=null && !complete.equals("")) {%>
          	<script language="javascript" type="text/javaScript">
            	<%= XSSUtil.encodeForJavaScript(context, complete) %>
          	</script>
        <%}
    }%>

