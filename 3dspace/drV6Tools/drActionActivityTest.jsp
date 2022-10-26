<%--
  drActionActivityTest.jsp
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

<%
String actionActivityId = emxGetParameter(request,"objectId"); 
%>

<html style="background:#FFFFFF;">
	<head>
		<title>Test Actions</title>
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
		
			function clear() {
			   if(document.runTestForm.StartObject.value !=null) {
					document.runTestForm.StartObject.value="";
					document.runTestForm.StartObjectOID.value="";
			   }
			   return;
			}

			function showSearchWindow() {
				  var strURL="../common/emxFullSearch.jsp?table=AEFGeneralSearchResults&queryType1=Real Time&selection=single&fieldNameActual=StartObject&fieldNameDisplay=StartObject&mode=Chooser&HelpMarker=emxhelpfullsearch&showInitialResults=false&submitURL=../common/AEFSearchUtil.jsp&displayView=details";
				  showModalDialog(strURL, 500, 500);
			}
		
			function submitData(runTest) {
				var canProceed=true;
				$("form#runTestForm :input:not([type=hidden])").each(function(){
					var name = $(this).attr('displayName');
					var value = $(this).val();

					if(!value.trim() && name != 'Environment Variables'){
						alert(MUST_ENTER_VALID_VALUE+" "+name);
						canProceed = false;
						return false;
					}
				});

				if(canProceed){
					if (jsDblClick()) {
						var objform = document.forms['runTestForm'];
						objform.action = "drActionActivityTestProcess.jsp";
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
							<h2>Test Form</h2>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div id="runTestDiv" style="padding-top:40px;padding-bottom:40px;">
			<form nsubmit="return false;" method="post" name="runTestForm" id="runTestForm">
				<table>	
					<tr>						
						<td class="labelRequired" width="150"><label for="StartObject">Start Object</label></td>
						<td class="field">
						<input type="text" name="StartObjectOID" displayName="Start Object" value="" size="20" />
						<input type="hidden" name="StartObject" value="" size="20" />
						<input type="button" name="" id="" value="..." onClick="javascript:showSearchWindow()" />
						<a href="JavaScript:clear();" >Clear</a>
						</td>
					</tr>
					<tr>
						<td class="label" width="150">Environment Variables</td>
						<td class="inputField"><textarea id='EnvironmentVariables' name="EnvironmentVariables" displayName="Environment Variables"></textarea></td>
					</tr>
				</table>
				<input type="hidden" name="ActionActivityId" id="ActionActivityId" value="<%=actionActivityId%>" size="20" />
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
											<td><a onclick="submitData(false)" href="javascript:void(0)"><button class="btn-default" type="button">Run Test</button></a></td>					
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
