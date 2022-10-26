<%--
  drInitiateRoute.jsp
  Copyright (c) 1993-2015 Dassault Systemes.
  All Rights Reserved.
  This program contains proprietary and trade secret information of
  Dassault Systemes.
  Copyright notice is precautionary only and does not evidence any actual
  or intended publication of such program
--%>

<%-- Common Includes --%>
<%@include file="../common/emxNavigatorTopErrorInclude.inc"%>
<%@include file="../common/emxCompCommonUtilAppInclude.inc"%>
<%@include file="../emxUICommonAppInclude.inc"%>
<%@include file="../common/enoviaCSRFTokenValidation.inc"%>

<%@page import="com.matrixone.apps.domain.util.XSSUtil"%>
<%@page import="matrix.db.Context"%>
<%@page import="com.designrule.drv6tools.common.drContext"%>
<%@page import="com.designrule.drv6tools.route.drRouteUtil"%>
<%@page import="com.designrule.drv6tools.route.drInitiateRouteResult"%>
<%@page import="com.designrule.drv6tools.common.drBusinessObject"%>
<%@page import="com.designrule.drv6tools.common.drBusinessObjects"%>

<%!
public StringList getObjectIds(Context context,String [] memberIds) throws Exception
{
    StringList strList = new StringList();
    StringList objectIdList = new StringList();
    String oid = "";    
    if(memberIds != null && memberIds.length > 0) 
    {   
       for(int i = 0; i < memberIds.length ; i++) 
       {                     
          if(memberIds[i].indexOf("|") != -1)
          {
             strList = FrameworkUtil.split(memberIds[i], "|");
             if (strList.size() == 3)
             {
                 oid = (String)strList.get(0);
             }else
             {
                 oid = (String)strList.get(1);
             }         
          }else
          {
             oid = memberIds[i];
          }
           objectIdList.add(oid);                  
        }      
     }   
    return objectIdList;
}
%>

<%
String objectId = request.getParameter("objectId");
String[] arrTableRowIds = emxGetParameterValues(request, "emxTableRowId");
String initiateRouteActivityName = request.getParameter("drToolsKey");
StringList memberIDs = getObjectIds(context,arrTableRowIds);
java.util.Set set = new java.util.HashSet(memberIDs);	
String idsSelected  = "";
java.util.Iterator itr = set.iterator();
while(itr.hasNext())
{
    String id = (String)itr.next();
    idsSelected += id;   
    if(itr.hasNext())
        idsSelected += ",";
}
if(idsSelected==null || idsSelected.isEmpty() ==true){
	idsSelected=objectId;
}
HashMap requestMap 	= UINavigatorUtil.getRequestParameterMap(pageContext);
requestMap.put("emxTableRowId", idsSelected);
drRouteUtil routeUtil=new drRouteUtil(context);
String initialteRouteActivityID=routeUtil.getInitialteRouteActivityID(initiateRouteActivityName);
requestMap.put("initialteRouteActivityID", initialteRouteActivityID);
drInitiateRouteResult initiateRouteResult=routeUtil.getInitiateRoute(JPO.packArgs(requestMap));
boolean isOneRoutePerObject = initiateRouteResult.isOneRoutePerObject();
boolean isAutoStart = initiateRouteResult.isAutoStart();

if(initiateRouteResult.isNoRouteFound()){%>
	<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
	<script type="text/javascript">
		alert("<%=initiateRouteResult.getNoRouteFoundMessage()%>");
		if (typeof window !== 'undefined' && window.closeWindow) {
			if(window.closeWindow()){
				window.closeWindow();
			}else{
				getTopWindow().closeSlideInDialog();
			}
		}else{
			getTopWindow().closeSlideInDialog();
		}
	</script>
<%}else{%>

<html style="background:#FFFFFF;">
	<head>
		<title><%=initiateRouteResult.getCreateFormHeaderText()%></title>
		<script src="../common/scripts/jquery-latest.js"></script>
		<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
		<link rel="stylesheet" href="../common/styles/emxUIDefault.css" />
		<link rel="stylesheet" href="../common/styles/emxUIProperties.css" />
		<link rel="stylesheet" href="../common/styles/emxUIForm.css" />
		<link rel="stylesheet" href="../common/styles/emxUIList.css" />

		<script type="text/javascript">
			function submitData(createRoute) {
				var templateName = $('#routeTemplate option:selected').text();
				var templateId = $('#routeTemplate option:selected').val();
				var routeDescription = $('textarea#routeDescription').val();
				var objform = document.forms['createRouteForm'];
				objform.action = "drInitiateRouteAssign.jsp?templateName="+templateName+"&templateId="+templateId+"&routeDescription="+routeDescription;
				objform.submit();
			}

			function closeAssignWindow(){
				if (typeof window !== 'undefined' && window.closeWindow) {
					if(window.closeWindow()){
						window.closeWindow();
					}else{
						getTopWindow().closeSlideInDialog();
					}
				}else{
					getTopWindow().closeSlideInDialog();
				}
			}			
		</script>		
	</head>
	<body>		
		<div id="pageHeadDiv">
			<table>
				<tbody>
					<tr>
						<td class="page-title">
							<h2><%=initiateRouteResult.getCreateFormHeaderText()%></h2>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div id="createRouteDiv">
			<form nsubmit="return false;" method="post" name="createRouteForm" id="createRouteForm">
			<input type="hidden" value ='<xss:encodeForHTMLAttribute><%=idsSelected%></xss:encodeForHTMLAttribute>' name ="emxTableRowId" id = "emxTableRowId" />
			<input type="hidden" value ='<xss:encodeForHTMLAttribute><%=objectId%></xss:encodeForHTMLAttribute>' name ="objectId" id = "objectId" />
			<input type="hidden" value ='<xss:encodeForHTMLAttribute><%=initiateRouteResult.getCreateFormTemplateLabelText()%></xss:encodeForHTMLAttribute>' name ="CreateFormTemplateLabelText" id = "CreateFormTemplateLabelText" />
			<input type="hidden" value ='<xss:encodeForHTMLAttribute><%=initiateRouteResult.getCreateFormHeaderText()%></xss:encodeForHTMLAttribute>' name ="CreateFormHeaderText" id = "CreateFormHeaderText" />
			<input type="hidden" value ='<xss:encodeForHTMLAttribute><%=isOneRoutePerObject%></xss:encodeForHTMLAttribute>' name ="isOneRoutePerObject" id = "isOneRoutePerObject" />
			<input type="hidden" value ='<xss:encodeForHTMLAttribute><%=isAutoStart%></xss:encodeForHTMLAttribute>' name ="isAutoStart" id = "isAutoStart" />
			<input type="hidden" value ='<xss:encodeForHTMLAttribute><%=initialteRouteActivityID%></xss:encodeForHTMLAttribute>' name ="initialteRouteActivityID" id = "initialteRouteActivityID" />
				<table>	
					<tr>
						<td class="labelRequired" width="150"><%=initiateRouteResult.getCreateFormTemplateLabelText()%></td>
						<td class="field">
							<select name="action" size="1" id="routeTemplate" name="routeTemplate" style="width: 100%;">
							<%for(drBusinessObject routeTemplate : initiateRouteResult.getRouteTemplates()){ %>
								<option value="<%=routeTemplate.getObjectID()%>" ><%=routeTemplate.getName()%></option>
							<%} %>    
							</select>
						</td>
					</tr>	
					<tr>
						<td class="label" width="150">Route Description</td>
						<td class="inputField"><textarea id='routeDescription' name="routeDescription" cols="40" rows="5"></textarea></td>
					</tr>									
				</table>
			</form>
		</div>	
		<div id="divPageFoot">
			<div id="divDialogButtons">
				<table>
					<tbody>
						<tr>
							<td class="buttons">
								<table>
									<tbody>
										<tr>								
											<td><a onclick="submitData(false)" href="javascript:void(0)"><img border="0" alt="Create" src="../common/images/buttonDialogDone.gif"></a> </td>
											<td><a onclick="submitData(false)" href="javascript:void(0)"><button class="btn-default" type="button">Create</button></a></td>					
											<td><a onclick="closeAssignWindow()" href="javascript:void(0)"><img border="0" alt="Close" src="../common/images/buttonDialogCancel.gif"></a> </td>
											<td><a onclick="closeAssignWindow()" href="javascript:void(0)"><button class="btn-default" type="button">Close</button></a></td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>		
	</body>
</html>
<%}%>
<%@include file="../common/emxNavigatorBottomErrorInclude.inc"%>
