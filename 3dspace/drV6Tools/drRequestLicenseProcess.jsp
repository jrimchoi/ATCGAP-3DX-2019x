<%--
  drRequestLicenseProcess.jsp
  Copyright (c) 1993-2015 Dassault Systemes.
  All Rights Reserved.
  This program contains proprietary and trade secret information of
  Dassault Systemes.
  Copyright notice is precautionary only and does not evidence any actual
  or intended publication of such program
--%>

<%@include file="../common/emxNavigatorTopErrorInclude.inc"%>
<%@include file="../common/emxCompCommonUtilAppInclude.inc"%>
<%@include file="../emxUICommonAppInclude.inc"%>
<%@page import="matrix.db.Context"%>
<%@page import="com.designrule.licensing.drLicenseManager"%>

<%
try{
	HashMap requestMap = UINavigatorUtil.getRequestParameterMap(request);
	drLicenseManager licenseManager = new drLicenseManager(context);
	String requestXML = licenseManager.getRequestXML(requestMap);
	String requestXMLForMail = requestXML.replace(" ", "%20");
	requestXMLForMail = requestXMLForMail.replace("\n", "%0A");
%>
	<html style="background:#FFFFFF;">
		<head>
			<title>License Key Request</title>
			<script src="../common/scripts/jquery-latest.js"></script>
			<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
			<link rel="stylesheet" href="../common/styles/emxUIDefault.css" />
			<link rel="stylesheet" href="../common/styles/emxUIProperties.css" />
			<link rel="stylesheet" href="../common/styles/emxUIForm.css" />
			<link rel="stylesheet" href="../common/styles/emxUIList.css" />
			<style>
				div#divPageFoot,
				div#pageHeadDiv {
				    position:fixed;
				}
				.inner-pre {
				    color: #2a2a2a;
				    font-family: Arial,Helvetica,sans-serif;
				    font-kerning: normal;
				    font-size: 15px;
				    line-height: 18px;
				    text-rendering: optimizelegibility;
				}
			</style>
			<script type="text/javascript">
				function closeAssignWindow(){
					if (typeof window !== 'undefined' && window.closeWindow) {
						if(window.closeWindow()){
							window.closeWindow();
						}
					}else{
						top.close();
					}
				}
				
				function copyXML(element) {
					var text = $(element).clone().find('br').prepend('\r\n').end().text();
					element = $('<textarea>').appendTo('body').val(text).select();
					document.execCommand('copy');
					element.remove();
					alert("Request XML copied successfully");
				} 
			</script>		
		</head>
		<body>		
			<div id="pageHeadDiv">
				<table>
					<tbody>
						<tr>
							<td class="page-title">
								<h2>License Key Request</h2>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div id="createLicenseRequestDiv" style="padding-top:40px;padding-bottom:40px;">
				<form nsubmit="return false;" method="post" name="createRouteForm" id="createRouteForm">
					<table>	
						<tr>
							<td class="label">Please copy and mail the below text to drlTools@designrule.co.uk</td>
						</tr>
						<tr>
							<td class="field"><pre><span id="requestXML" class="inner-pre"><xss:encodeForHTML><%=requestXML%></xss:encodeForHTML></span></pre></td>
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
												<td><a onclick="copyXML('#requestXML')" href="javascript:void(0)"><button class="btn-default" type="button">Copy to clipboard</button></a></td>							
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
<%
}catch(Exception ex){
    if (ex.toString() != null && (ex.toString().trim()).length() > 0){
        emxNavErrorObject.addMessage(ex.toString().trim());
    }
}
%>

<%@include file="../common/emxNavigatorBottomErrorInclude.inc"%>
