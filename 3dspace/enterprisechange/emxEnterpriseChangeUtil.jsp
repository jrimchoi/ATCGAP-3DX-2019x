<%-- emxEnterpriseChangeUtil.jsp

    Copyright (c) 1992-2018 Enovia Dassault Systemes.All Rights Reserved.
    This program contains proprietary and trade secret information of MatrixOne,Inc.
    Copyright notice is precautionary only and does not evidence any actual
    or intended publication of such program

    static const char RCSID[] =$Id: /web/enterprisechange/emxEnterpriseChangeUtil.jsp 1.1 Fri Oct 1 16:45:25 2010 GMT ds-panem Experimental$
--%>

<html>
	<head>
		<title>
		</title>
		<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
		<%@include file = "../components/emxComponentsCommonInclude.inc" %>
		<%@include file = "../emxUICommonAppInclude.inc"%>

		<%@page import="com.matrixone.apps.domain.DomainConstants"%>
		<%@page import="com.matrixone.apps.domain.DomainObject"%>
		<%@page import="com.matrixone.apps.domain.DomainRelationship"%>
		<%@page import="com.matrixone.apps.enterprisechange.EnterpriseChangeConstants"%>
		<%@page import="com.matrixone.apps.productline.ProductLineUtil"%>
		<%@page import="com.matrixone.apps.domain.util.FrameworkUtil"%>
		<%@page import="com.matrixone.apps.domain.util.MessageUtil"%>
		<%@page import="com.matrixone.apps.common.util.FormBean"%>

		<!--emxUIConstants.js is included to call the findFrame() method to get a frame-->
		<jsp:useBean id="tableBean" class="com.matrixone.apps.framework.ui.UITable" scope="session"/>
		<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICore.js"></script>
		<script language="Javascript" src="../common/scripts/emxUIConstants.js"></script>
		<script language="Javascript" src="../common/scripts/emxUIUtility.js"></script>
		<script language="javascript" src="../common/scripts/emxUIModal.js"></script>
	</head>

	<body>
		<%
		String objectId  = emxGetParameter(request, "objectId");
		String relId  = emxGetParameter(request, "relId");
		String strLanguage = context.getSession().getLanguage();
		String strContext = emxGetParameter(request,"context");
		String strMode = "";
		String jsTreeID = emxGetParameter(request, "jsTreeID");
		String uiType = emxGetParameter(request, "uiType");
		boolean bIsError=false;


			try{
				strMode = emxGetParameter(request, "mode");

				if(strMode.equalsIgnoreCase("")){
					%>
					<script language="javascript">
						getTopWindow().getWindowOpener().location.href = getTopWindow().getWindowOpener().location.href;
						//getTopWindow().location.href = "../common/emxCloseWindow.jsp";
						getTopWindow().close();
					</script>
					<%
				}

				else if (strMode.equalsIgnoreCase("connectChangeTaskImpactedObjects")){
					try{
						DomainObject parentObject = DomainObject.newInstance(context, objectId);

						String strIsTo = "true";
						String strRelationshipName = EnterpriseChangeConstants.RELATIONSHIP_IMPACTED_OBJECT;

						String emxTableRowIds[] = emxGetParameterValues(request, "emxTableRowId");
						String strTableRowId = "";
						StringList slEmxTableRowId = new StringList();

						// From autonomy search the emxTableRowIds are submitted as
						// <object id>|<parent id>|1,0
						if(emxTableRowIds != null) {
							for (int i = 0; i < emxTableRowIds.length; i++) {
								strTableRowId = emxTableRowIds[i];
								slEmxTableRowId = FrameworkUtil.split(strTableRowId, "|");
								if (slEmxTableRowId.size() > 0) {
									strTableRowId = (String)slEmxTableRowId.get(0);

									if ("false".equalsIgnoreCase(strIsTo)) {
										com.matrixone.apps.domain.DomainRelationship.connect(context,
											DomainObject.newInstance(context, strTableRowId),
											strRelationshipName,
											parentObject);
									}else {
										com.matrixone.apps.domain.DomainRelationship.connect(context,
											parentObject,
											strRelationshipName,
											DomainObject.newInstance(context, strTableRowId));
									}
								}
							}
						}
						%>
						<script language="javascript">
							getTopWindow().getWindowOpener().location.href = getTopWindow().getWindowOpener().location.href;
							//getTopWindow().location.href = "../common/emxCloseWindow.jsp";
							getTopWindow().close();
						</script>
						<%
					}catch(Exception e){
						bIsError=true;
						session.putValue("error.message", e.toString());
					}
				}
				
				else if (strMode.equalsIgnoreCase("connectChangeTaskApplicabilityContexts")) {
					try {
						String[] strRowId = emxGetParameterValues(request, "emxTableRowId");
						boolean preserve = false;
						for (int i=0;i<strRowId.length;i++){
							String selObjId = strRowId[i].split("[|]")[1];
							DomainRelationship.connect(context, 
													objectId, 
													EnterpriseChangeConstants.RELATIONSHIP_IMPACTED_OBJECT, 
													selObjId, 
													preserve);
						}
						%>
						<script language="javascript" type="text/javaScript">
							getTopWindow().getWindowOpener().location.href = getTopWindow().getWindowOpener().location.href;
							//getTopWindow().location.href = "../common/emxCloseWindow.jsp";
							getTopWindow().close();
						</script>
						<%
					} catch (Exception e) {
				        session.putValue("error.message", e.getMessage());
				        throw e;
					}
				}
				
				else if (strMode.equalsIgnoreCase("removeChangeTaskApplicabilityContexts")) {
					try {
						HashMap programMap = new HashMap();
						programMap.put("objectId", objectId);
						programMap.put("emxTableRowId", emxGetParameterValues(request, "emxTableRowId"));
						programMap.put("strLanguage", strLanguage);
						
						String warningMessage = (String) JPO.invoke(context, "emxChangeTask", null, "removeChangeTaskApplicabilityContexts", JPO.packArgs(programMap), String.class);						
						%>
						<script language="javascript">
							<%if (warningMessage!=null && !warningMessage.isEmpty()) {%>
							//XSSOK
								alert("<%=warningMessage%>");
							<%}%>
							parent.location.href = parent.location.href;
						</script>
						<%
					} catch (Exception e) {
				        session.putValue("error.message", e.getMessage());
				        throw e;
					}
				}

				else if(strMode.equalsIgnoreCase("connectModelRelatedChangeProjects")){
					try	{
						HashMap programMap = new HashMap();
						programMap.put("objectId", objectId);
						programMap.put("direction", "from");
						programMap.put("relName", EnterpriseChangeConstants.RELATIONSHIP_RELATED_PROJECTS);
						programMap.put("uiType", emxGetParameter(request, "uiType"));
						programMap.put("emxTableRowId", emxGetParameterValues(request, "emxTableRowId"));

						String strTableRowId = "";
						StringList slEmxTableRowId = new StringList();

						String[] methodargs =JPO.packArgs(programMap);
						JPO.invoke(context, "emxChangeProject", null, "connectModelRelatedChangeProjects", methodargs);

						%>
						<script language="javascript">
							getTopWindow().getWindowOpener().location.href = getTopWindow().getWindowOpener().location.href;
							//getTopWindow().location.href = "../common/emxCloseWindow.jsp";
							getTopWindow().close();
						</script>
						<%
					}catch(Exception e){
						bIsError=true;
						session.putValue("error.message", e.toString());
					}
				}

				else if (strMode.equalsIgnoreCase("remove")){
					try{
						HashMap programMap = new HashMap();
						String[] oids = emxGetParameterValues(request, "emxTableRowId");
						Map objectMap = UIUtil.parseRelAndObjectIds(context, oids, false);
						oids = (String[])objectMap.get("objectIds");
						String[] relIds = (String[])objectMap.get("relIds");
						String action = emxGetParameter(request, "action");
						DomainRelationship.disconnect(context, relIds, false);

						%>
						<script language="javascript">
							parent.location.href = parent.location.href;
						</script>
						<%
					}catch(Exception e){
						bIsError=true;
						session.putValue("error.message", e.toString());
					}
				}
				
				else if (strMode.equalsIgnoreCase("searchUtil")) {
					String targetTag = emxGetParameter(request, "targetTag");
					if (targetTag!=null && !targetTag.isEmpty()) {
						if (targetTag.equalsIgnoreCase("select")) {
							String selectName = emxGetParameter(request, "selectName");
							String emxTableRowIds[] = emxGetParameterValues(request,"emxTableRowId");
							if (emxTableRowIds!=null && emxTableRowIds.length>0) {
								String applicabilityContextsHiddenNewValue = "";
								for (int i=0;i<emxTableRowIds.length;i++) {
									String emxTableRowId = emxTableRowIds[i];
									if (emxTableRowId!=null && !emxTableRowId.isEmpty()) {
										// For most webform choosers, default to the object id/name...
							            String emxTableRowObjId = emxTableRowId.split("[|]")[1];
							            DomainObject emxTableRowDom = new DomainObject(emxTableRowObjId);
							            String emxTableRowObjName = emxTableRowDom.getInfo(context, DomainConstants.SELECT_NAME);
							            if (applicabilityContextsHiddenNewValue!=null && !applicabilityContextsHiddenNewValue.isEmpty()) {
							            	applicabilityContextsHiddenNewValue += ",";
							            }
							            applicabilityContextsHiddenNewValue += emxTableRowObjId;
							            %>
										<script language="javascript" type="text/javaScript">
											var selectTag = getTopWindow().getWindowOpener().document.getElementsByName("<%=XSSUtil.encodeForJavaScript(context,selectName)%>");
											var option = getTopWindow().getWindowOpener().document.createElement("option");
											option.value = "<%=XSSUtil.encodeForJavaScript(context,emxTableRowObjId)%>";
											option.text = "<%=XSSUtil.encodeForJavaScript(context,emxTableRowObjName)%>";
											selectTag[0].add(option);
										</script>
										<%
									}
								}

								if (applicabilityContextsHiddenNewValue!=null && !applicabilityContextsHiddenNewValue.isEmpty()) {
									%>
									<script language="javascript" type="text/javaScript">
									var applicabilityContextsHidden = getTopWindow().getWindowOpener().document.getElementById("ApplicabilityContextsHidden");
									var applicabilityContextsHiddenValue = applicabilityContextsHidden.value;
									if (applicabilityContextsHiddenValue!="") {
										applicabilityContextsHiddenValue += ",";
									}
									applicabilityContextsHiddenValue += "<%=XSSUtil.encodeForJavaScript(context,applicabilityContextsHiddenNewValue)%>";
									applicabilityContextsHidden.value = applicabilityContextsHiddenValue;
									
									</script>
									<%
								}
							}
						}
					} else {
						throw new Exception("Target Tag is null or empty");
					}
		            
					%>
					<script language="javascript" type="text/javaScript">
						window.getTopWindow().close();
					</script>
					<%
					
				}

			}catch(Exception e){
					bIsError=true;
					session.putValue("error.message", e.toString());
			}
		%>
		<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
	</body>
</html>
