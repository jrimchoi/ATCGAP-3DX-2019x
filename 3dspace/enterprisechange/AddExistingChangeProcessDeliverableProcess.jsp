<%--
  AddExistingChangeProcessDeliverableProcess.jsp
  Copyright (c) 1993-2018 Dassault Systemes.
  All Rights Reserved.
  This program contains proprietary and trade secret information of
  Dassault Systemes.
  Copyright notice is precautionary only and does not evidence any actual
  or intended publication of such program
  static const char RCSID[] = $Id: /web/enterprisechange/AddExistingChangeProcessDeliverableProcess.jsp 1.1 Fri Dec 19 16:45:25 2008 GMT ds-panem Experimental$
--%>

<html>
	<head>
		<title>
		</title>

		<%-- Common Includes --%>
		<%-- Common Includes --%>
		<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
		<%@include file = "../emxUICommonAppInclude.inc"%>

		<%@page import="java.util.StringTokenizer"%>

		<%@page import="matrix.util.StringList"%>

		<%@page import="com.matrixone.apps.enterprisechange.ChangeTask"%>
		<%@page import="com.matrixone.apps.domain.util.EnoviaResourceBundle"%>
		
		<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICore.js"></script>
	</head>

	<body>
		<%
		boolean bIsError = false;
		try{
			String strObjId = emxGetParameter(request, "objectId");
			String delType = emxGetParameter(request, "delType");

			//get the selected Objects from the Full Search Results page
			String strContextObjectId[] = emxGetParameterValues(request,"emxTableRowId");
			String sLanguage = request.getHeader("Accept-Language");
			//If the selection is empty given an alert to user
			String selectItem = EnoviaResourceBundle.getProperty(context,"EnterpriseChange","emxEnterpriseChange.Pdcm.PleaseSelectAnItem", sLanguage);
			if(strContextObjectId==null){%>
				<script language="javascript" type="text/javaScript">
					alert("<xss:encodeForJavaScript><%=selectItem%></xss:encodeForJavaScript>");
				</script>
			<%}
			//If the selection are made in Search results page then
			else{
				ChangeTask changeTask = new ChangeTask(strObjId);
				StringList objectsToConnect = new StringList();

				for (int i=0;i<strContextObjectId.length;i++) {
					StringTokenizer strTokenizer = new StringTokenizer(strContextObjectId[i] ,"|");
					for (int j=0;j<strTokenizer.countTokens();j++) {
						Object objectToConnect = strTokenizer.nextElement();
						if (objectToConnect!=null) {
							String objectToConnectId = objectToConnect.toString();
							if (objectToConnectId!=null && !objectToConnectId.isEmpty()) {
								objectsToConnect.addElement(objectToConnectId);
							}
						}
						break;
					}
				}

				String warningMessage = "";
				if (delType.equalsIgnoreCase("Change")) {
					warningMessage = changeTask.connectChangeDeliverables(context, objectsToConnect);
				} else if (delType.equalsIgnoreCase("Deliverable")) {
					warningMessage = changeTask.connectDeliverables(context, objectsToConnect);
				}
				if (warningMessage!=null && !warningMessage.isEmpty()) {
					%>
    				<script language="javascript" type="text/javaScript">
    				//XSSOK
    				alert("<%=warningMessage%>");
    				</script>
    				<%
				}

				%>
				<script language="javascript" type="text/javaScript">					
					var deliverableFrame = getTopWindow().openerFindFrame(getTopWindow(), "PMCDeliverable");
					deliverableFrame.location.href = deliverableFrame.location.href;
					//getTopWindow().location.href = "../common/emxCloseWindow.jsp";
					getTopWindow().closeWindow();
				</script>
				<%
			}

		}catch(Exception e){
			bIsError=true;
			session.putValue("error.message", e.getMessage());
			//Added for IR-049387V6R2011x
			%>
			<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
			<%
			//End of IR-049387V6R2011x
		}// End of main Try-catck block
		%>
		<%--
		<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
		--%>
	</body>
</html>
