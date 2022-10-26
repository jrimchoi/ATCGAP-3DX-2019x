<%--
  drActivateLicense.jsp
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
<%@include file="../common/emxFormConstantsInclude.inc"%>

<html style="background:#FFFFFF;">
	<head>
		<title>Activate License</title>
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
		</style>	
		<script type="text/javascript">
			function submitData(createLicenseRequest) {
				var canProceed=true;
				$("form#activateLicenseForm :input").each(function(){
					var name = $(this).attr('displayName');
					var value = $(this).val();
					if(!value.trim()){
						alert(MUST_ENTER_VALID_VALUE+" "+name);
						canProceed = false;
						return false;
					}
				});

				if(canProceed){
					if (jsDblClick()) {
						var objform = document.forms['activateLicenseForm'];
						objform.action = "drActivateLicenseProcess.jsp";
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
							<h2>Activate License</h2>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div id="createLicenseRequestDiv" style="padding-top:40px;padding-bottom:40px;">
			<form nsubmit="return false;" method="post" name="activateLicenseForm" id="activateLicenseForm">
				<table>	
					<tr>
						<td class="labelRequired" width="150">License Key XML</td>
						<td class="inputField"><textarea id='LicenseKeyXML' name="LicenseKeyXML" displayName="License Key XML"></textarea></td>
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

<%@include file="../common/emxNavigatorBottomErrorInclude.inc"%>
