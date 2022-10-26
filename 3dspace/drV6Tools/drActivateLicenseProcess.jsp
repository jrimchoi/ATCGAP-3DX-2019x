<%--
  drActivateLicenseProcess.jsp
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

<%@page import="matrix.db.Context"%>
<%@page import="com.designrule.licensing.drLicenseManager"%>
<%@page import="com.designrule.licensing.drLicenseObject"%>
<%@page import="com.designrule.licensing.drLicenseDetailsObject"%>

<%
try
{
	String licenseKeyXML = request.getParameter("LicenseKeyXML");
	drLicenseManager licenseManager = new drLicenseManager(context);
	drLicenseDetailsObject licenseDetailsObject = licenseManager.updateLicense(licenseKeyXML);
%>
	<html style="background:#FFFFFF;">
		<head>
			<title>License Details</title>
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
			</script>		
		</head>
		<body>		
			<div id="pageHeadDiv">
				<table>
					<tbody>
						<tr>
							<td class="page-title">
								<h2>License Details</h2>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div id="createLicenseRequestDiv" style="padding-top:40px;padding-bottom:40px;">
				<form nsubmit="return false;" method="post" name="activateLicenseRequestForm" id="activateLicenseRequestForm">
					<table>	
						<tr>
							<td class="label">3dxtools Build Version</td>
							<td class="field"><%=licenseDetailsObject.getLicensedBuildNumber()%></td>
						</tr>
						<tr>
							<td class="label">License Type</td>
							<td class="field"><%=licenseDetailsObject.getLicenseType().getText()%></td>
						</tr>
						<tr>
							<td class="label">Licensed Products</td>
							<td class="field"><%=licenseDetailsObject.getLicensedProducts()%></td>
						</tr>
						<tr>
							<td class="label">License Expiry Date</td>
							<td class="field"><%=licenseDetailsObject.getLicenseExpiryDate()%></td>
						</tr>
						<tr>
							<td class="label">Locations Count</td>
							<td class="field"><%=licenseDetailsObject.getLocationsCount()%></td>
						</tr>
						<tr>
							<td class="label">Active Users Count</td>
							<td class="field"><%=licenseDetailsObject.getActiveUsersCount()%></td>
						</tr>
						<tr>
							<td class="label">Environment Name</td>
							<td class="field"><%=licenseDetailsObject.getEnvironmentName()%></td>
						</tr>
						<tr>
							<td class="label">Environment Type</td>
							<td class="field"><%=licenseDetailsObject.getEnvironmentType()%></td>
						</tr>
						<tr>
							<td class="label">Customer Name</td>
							<td class="field"><%=licenseDetailsObject.getCustomerContactName()%></td>
						</tr>
						<tr>
							<td class="label" width="150">Customer Address</td>
							<td class="field"><pre><span class="inner-pre"><%=licenseDetailsObject.getCustomerAddress()%></span><pre></td>
						</tr>
						<tr>
							<td class="label">Customer Contact Name</td>
							<td class="field"><%=licenseDetailsObject.getCustomerContactName()%></td>
						</tr>
						<tr>
							<td class="label">Customer Contact Email Address(es)</td>
							<td class="field"><%=licenseDetailsObject.getCustomerContactEmailAddresses()%></td>
						</tr>
						<tr>
							<td class="label">VAR Name</td>
							<td class="field"><%=licenseDetailsObject.getVarName()%></input></td>
						</tr>
						<tr>
							<td class="label">VAR Contact Name</td>
							<td class="field"><%=licenseDetailsObject.getVarContactName()%></td>
						</tr>
						<tr>
							<td class="label">VAR Contact Email Address(s)</td>
							<td class="field"><%=licenseDetailsObject.getVarContactEmailAddresses()%></input></td>
						</tr>
						<tr>
							<td class="label">Request Notes</td>
							<td class="field"><pre><span class="inner-pre"><%=licenseDetailsObject.getRequestNotes()%></span><pre></td>
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