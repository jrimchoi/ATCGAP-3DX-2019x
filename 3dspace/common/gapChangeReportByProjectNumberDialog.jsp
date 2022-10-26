<%@ include file = "../emxUICommonAppInclude.inc"%>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.Integer" %>
<%@ page import="com.dassault_systemes.vplmposadministrationui.uiutil.AdminUtilities"%>
<%@include file = "../common/emxPLMOnlineIncludeStylesScript.inc"%>
<%@include file = "../common/emxPLMOnlineAdminAttributesCalculation.jsp"%>

<%--
    Document   : gapChangeReportByProjectNumberDialog.jsp
    Author     : TBIAPRA
--%>
 <%
	final String EMXENTERPRISECHANGEMGT_STRING_RESOURCE = "emxEnterpriseChangeMgtStringResource";
	final String strLanguage = request.getHeader("Accept-Language");
	 String sHeader= EnoviaResourceBundle.getProperty(context,EMXENTERPRISECHANGEMGT_STRING_RESOURCE,new Locale(strLanguage),"EnterpriseChangeMgt.Label.gapChangesBasedonProjectNumber");
        String Search = getNLS("Search");
		String strPersonId =PersonUtil.getPersonObjectID(context);
		String strPersonName =context.getUser();
%>
<html>
    <head>
    	
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script language="javascript" src="../common/scripts/jquery-latest.js"></script>
		<script language="javascript" src="../common/scripts/emxUICore.js"></script>
		<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
		<script language="javascript" src="../common/scripts/emxUIModal.js"></script>
		<script language="JavaScript" src="scripts/emxUICoreMenu.js"></script>
	<script language="JavaScript" src="scripts/emxUIActionbar.js"></script>
	<script language="JavaScript" src="scripts/emxUIToolbar.js"></script>
	<script language="javascript" src="scripts/emxNavigatorHelp.js"></script>
	
	<script language="javascript" src="../common/scripts/emxUIObjMgr.js"></script>
	<script language="JavaScript" src="../common/scripts/jquery-latest.js" type="text/javascript"></script>
	<script language="JavaScript" src="../common/scripts/jshashtable/jshashtable.js" type="text/javascript"></script>
	<script language="JavaScript" src="../common/scripts/jquery-numberformatter/jquery-numberformatter.js" type="text/javascript"></script>
	<script language="JavaScript" src="../common/scripts/emxUITableUtil.js" type="text/javascript"></script>
	<script language="javascript" src="../common/scripts/emxUIFormUtil.js" type="text/javascript"></script>
	<script language="JavaScript" src="../common/scripts/emxUIPopups.js" type="text/javascript"></script>
	<script language="javascript" src="scripts/emxUICalendar.js"></script>
	<script language="javascript" src="scripts/emxQuery.js"></script>
    <script type="text/javascript" src="../webapps/AmdLoader/AmdLoader.js"></script>
    <script type="text/javascript">window.dsDefaultWebappsBaseUrl = "../webapps/";</script>
    <script type="text/javascript" src="../webapps/WebappsUtils/WebappsUtils.js"></script>
    <script type="text/javascript" src="../webapps/c/UWA/js/UWA_W3C_Alone.js"></script>
<script language="javascript" src="scripts/emxTypeAhead.js"></script>
	<script type="text/javascript" src="scripts/emxUIFormHandler.js"></script>	
        <link rel="stylesheet" type="text/css" href="../common/styles/emxUIForm.css" />
        <script>
			document.onkeypress = keyPress;

			function keyPress(e){
			  var x = e || window.event;
			  var key = (x.keyCode || x.which);
			  if(key == 13 || key == 3){
				  getValue();
			  }
			}
			
			function getValue() {
				var plmId = document.getElementById('send');
				var vRelatedToMeId = document.getElementById("RelatedToMe");
				var vRelatedToMe = true;
				var vProjectNumber = document.forms["submitForm"].gapProjectNumber.value;
				
				vProjectNumber = vProjectNumber.replace("|", ",");
				var vErr = "";
				if (vProjectNumber.trim()=="")
					vErr = "<%=EnoviaResourceBundle.getProperty(context,EMXENTERPRISECHANGEMGT_STRING_RESOURCE,new Locale(strLanguage),"EnterpriseChangeMgt.warning.ProjectNumber")%>"
				
				if (vProjectNumber.includes("*"))
					vErr = "<%=EnoviaResourceBundle.getProperty(context,EMXENTERPRISECHANGEMGT_STRING_RESOURCE,new Locale(strLanguage),"EnterpriseChangeMgt.wildcardwarning.ProjectNumber")%>"
				
				var vHeader = "<%=EnoviaResourceBundle.getProperty(context,EMXENTERPRISECHANGEMGT_STRING_RESOURCE,new Locale(strLanguage),"EnterpriseChangeMgt.Label.gapChangesBasedonProjectNumber")%>"
				vHeader = vHeader + " : " + vProjectNumber
				
				if (vRelatedToMeId.checked == true){
					vRelatedToMe = true;
					vHeader = vHeader + " | Related to me"
				} else {
					vRelatedToMe = false;
				}
								
				if (vErr=="" && vErr!=null) {	
					var target = plmId.href;
					// ENGMASA : added below code to decide display/not display contents : START
					var vShowContent = document.getElementById("ShowContents");
					  //alert("vShowContent : "+vShowContent);
					  if (vShowContent.checked == true){
						  target = target + "&table=gapChangeSummary";
					  } else
					  {
						  target = target + "&table=gapChangeSummaryWithoutContent";
					  }
					// ENGMASA : added below code to decide display/not display contents : END
					// replace pipe to comma
					//vProjectNumber = vProjectNumber.split("|").join(",");
					//target = target + "&header="+vHeader+"&field=TYPES=type_ChangeAction,typeChangeOrder:gapProjectNumber="+vProjectNumber;
					target = target + "&header="+vHeader+"&gapProjectNumber="+vProjectNumber+"&RelatedToMe="+vRelatedToMe;
					/*if (vRelatedToMeId.checked == true){
						target = target + ":OWNER="+"<%=strPersonName%>";
					}
					
					target = target + "&selection=multiple&fullTextSearch=true";*/
					parent.document.getElementById("frameCol").cols="20,80";
					parent.Topos.location.href=target;
				} else
					alert(vErr)
			}

			function submitQueryRSC() {
				parent.document.getElementById("frameCol").cols="20,80";
				parent.Topos.location.href="emxIndentedTable.jsp?table=gapChangeSummary&program=gap_Util:getChanges";
			}
			
			function isNumberKey(evt){
				var charCode = (evt.which) ? evt.which : evt.keyCode
				if (charCode ==44 || charCode==42)
					return true;
				else if (charCode > 31 && (charCode != 46 &&(charCode < 48 || charCode > 57)))
					return false;
				return true;
			}
  function showWorkspaceSearch()
  {
    var strURL="../common/emxFullSearch.jsp?hideHeader=true&amp;field=TYPES=type_Project:CURRENT=policy_Project.state_Active&amp;selection=multiple&amp;searchOnInit=false&amp;fieldNameActual=gapProjectNumber&amp;suiteKey=Framework&amp;HelpMarker=emxhelpfullsearch&amp;fieldNameOID=gapProjectNumberOID&amp;table=ENCAddExistingGeneralSearchResults&amp;fieldNameDisplay=gapProjectNumberDisplay&amp;&amp;submitURL=AEFSearchUtil.jsp";
    var win = showModalDialog(strURL, 650, 550, true);
  }
        </script>
    </head>
    <body>
	
	<form action="javascript:getValue" name="submitForm" id="submitForm " target="_parent">

		 <!--<a id="send" name="send" href="emxIndentedTable.jsp?&program=emxAEFFullSearch:search"></a>-->
		 <a id="send" name="send" href="emxIndentedTable.jsp?program=gap_Util:getChanges"></a>
          	
	<div id="searchPage">
			<jsp:include page = "../common/emxFormEditDisplay.jsp" flush="true">
  				<jsp:param name="form" value="gapDownloadReportByJobCACO"/>
				<jsp:param name="objectId" value="<%=strPersonId%>"/>
  			</jsp:include>
  		</div>
         
         
        </form>
        <script>addFooter("javascript:getValue()","images/buttonDialogApply.gif","<%=Search%>","<%=Search%>");</script>
       
     </body>
</html>

