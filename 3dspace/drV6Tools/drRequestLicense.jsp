<%--
  drRequestLicense.jsp
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
<%@include file="../common/emxFormConstantsInclude.inc"%>

<%@page import="matrix.db.Context"%>
<%@page import="com.designrule.licensing.drLicenseManager"%>
<%@page import="com.designrule.licensing.drLicenseObject"%>
<%@page import="com.designrule.licensing.drLicenseDetailsObject"%>

<%
try
{
	drLicenseManager licenseManager = new drLicenseManager(context);
	drLicenseDetailsObject licenseDetailsObject = licenseManager.getLicenseDetailsObject();
%>
	<html style="background:#FFFFFF;">
		<head>
			<title>License Key Request</title>
			<script src="../common/scripts/jquery-latest.js"></script>
			<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
			<script language="JavaScript" src="../common/scripts/emxAdminUtils.js" type="text/javascript"></script>
			<link rel="stylesheet" href="../common/styles/emxUIDefault.css" />
			<link rel="stylesheet" href="../common/styles/emxUIProperties.css" />
			<link rel="stylesheet" href="../common/styles/emxUIForm.css" />
			<link rel="stylesheet" href="../common/styles/emxUIList.css" />
			<style>
				div#divPageFoot,
				div#pageHeadDiv {
				    position:fixed;
				}
				input {
    				width: calc(100% - 20px);
				}
			</style>	
			<script type="text/javascript">
				function submitData(createLicenseRequest) {
					var canProceed=true;
					$("form#createLicenseRequestForm :input").each(function(){
						var displayName = $(this).attr('displayName');
						var name = $(this).attr('name');
						var value = $(this).val();
						if(!value.trim() && "RequestNotes" !=  name){
							alert(MUST_ENTER_VALID_VALUE+" "+displayName);
							canProceed = false;
							return false;
						}
					});
	
					if(canProceed){
						if (jsDblClick()) {
							var objform = document.forms['createLicenseRequestForm'];
							objform.action = "drRequestLicenseProcess.jsp";
							objform.submit();
						}else{
							alert("Your previous request is in process, please wait...");
						}
					}
				}
	
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
								<h2>License Key Request</h2>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div id="createLicenseRequestDiv" style="padding-top:40px;padding-bottom:40px;">
				<form nsubmit="return false;" method="post" name="createLicenseRequestForm" id="createLicenseRequestForm">
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
							<td class="labelRequired">Environment Name</td>
							<td class="inputField"><input type="text" id='EnvironmentName' name="EnvironmentName" displayName="Environment Name" value="<%=licenseDetailsObject.getEnvironmentName()%>"></input></td>
						</tr>
						<tr>
							<td class="labelRequired">Environment Type</td>
							<td class="inputField">
								<select size="1" id="EnvironmentType" name="EnvironmentType" displayName="Environment Type">
								<%
								HashMap environmentTypeRanges = licenseManager.getEnvironmentTypes();
								StringList actualEnvTypeValues = (StringList)environmentTypeRanges.get("field_choices");
								StringList displayEnvTypeValues = (StringList)environmentTypeRanges.get("field_display_choices");
								String environmentType = "";
								for(int count=0;count<actualEnvTypeValues.size();count++){ 
									environmentType = (String)actualEnvTypeValues.get(count);
									if(environmentType.equals(licenseDetailsObject.getEnvironmentType())){%>
										<option selected value="<%=actualEnvTypeValues.get(count)%>" ><%=displayEnvTypeValues.get(count)%></option>
									<%}else{%>
										<option value="<%=actualEnvTypeValues.get(count)%>" ><%=displayEnvTypeValues.get(count)%></option>
									<%}%>
								<%}%>
								</select>
							</td>
						</tr>
						<tr>
							<td class="labelRequired">Customer Name</td>
							<td class="inputField"><input type="text" id='CustomerName' name="CustomerName" displayName="Customer Name" value="<%=licenseDetailsObject.getCustomerName()%>"></input></td>
						</tr>
						<tr>
							<td class="labelRequired" width="150">Customer Address</td>
							<td class="inputField"><textarea id='CustomerAddress' name="CustomerAddress" displayName="Customer Address"><%=licenseDetailsObject.getCustomerAddress()%></textarea></td>
						</tr>
						<tr>
							<td class="labelRequired">Customer Contact Name</td>
							<td class="inputField"><input type="text" id='CustomerContactName' name="CustomerContactName" displayName="Customer Contact Name" value="<%=licenseDetailsObject.getCustomerContactName()%>"></input></td>
						</tr>
						<tr>
							<td class="labelRequired">Customer Contact Email Address(es)</td>
							<td class="inputField"><input type="text" id='CustomerContactEmailAddresses' name="CustomerContactEmailAddresses" name="CustomerContactEmailAddresses" displayName="Customer Contact Email Addresses" value="<%=licenseDetailsObject.getCustomerContactEmailAddresses()%>"></input></td>
						</tr>
						<tr>
							<td class="labelRequired">VAR Name</td>
							<td class="inputField"><input type="text" id='VARName' name="VARName" displayName="VAR Name" value="<%=licenseDetailsObject.getVarName()%>"></input></td>
						</tr>
						<tr>
							<td class="labelRequired">VAR Contact Name</td>
							<td class="inputField"><input type="text" id='VARContactName' name="VARContactName" displayName="VAR Contact Name" value="<%=licenseDetailsObject.getVarContactName()%>"></input></td>
						</tr>
						<tr>
							<td class="labelRequired">VAR Contact Email Address(s)</td>
							<td class="inputField"><input type="text" id='VARContactEmailAddresses' name="VARContactEmailAddresses" displayName="VAR Contact Email Addresses" value="<%=licenseDetailsObject.getVarContactEmailAddresses()%>"></input></td>
						</tr>
						<tr>
							<td class="label">Request Notes</td>
							<td class="inputField"><textarea id='RequestNotes' name="RequestNotes" displayName="Request Notes"><%=licenseDetailsObject.getRequestNotes()%></textarea></td>
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
												<td><a onclick="submitData(false)" href="javascript:void(0)"><button class="btn-default" type="button">Submit</button></a></td>					
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
