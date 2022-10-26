<%--  DSCSaveQueryDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoSaveQueryDialog.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoSaveQueryDialog.jsp $
 * 
 * *****************  Version 5  *****************
 * User: Rahulp       Date: 12/03/02   Time: 6:23p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * ***********************************************
 *
 --%>
<html>
<%@include file= "emxInfoCentralUtils.inc"%>

<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>
<head>
<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css"><!--This is required for the font of the text-->
<link rel="stylesheet" href="../common/styles/emxUIDialog.css" type="text/css" ><!--This is required for the cell (td) back ground colour-->
<link rel="stylesheet" href="../common/styles/emxUIList.css" type="text/css" >

<script language="Javascript">

	//-- 12/17/2003         Start rajeshg   -->	
	//Function to check key pressed
	function cptKey(e) 
	{
		var pressedKey = ("undefined" == typeof (e)) ? event.keyCode : e.keyCode ;
		// for disabling backspace
		if (((pressedKey == 8) ||((pressedKey == 37) && (event.altKey)) || ((pressedKey == 39) && (event.altKey))) &&((event.srcElement.form == null) || (event.srcElement.isTextEdit == false)))
			return false;
		if( (pressedKey == 37 && event.altKey) || (pressedKey == 39 && event.altKey) && (event.srcElement.form == null || event.srcElement.isTextEdit == false))
			return false;

		if (pressedKey == "27") 
		{ 
			// ASCII code of the ESC key
			top.window.close();
		}
	}

	function submitThis( event )
	{
		if((event.keyCode == 13) || (event.keyCode == 10) || (event.which == 13) || (event.which == 10)) 
		{
				parent.frames[1].submit();
		}
	}

	document.onkeypress = cptKey ;
	//-- 12/17/2003         End  rajeshg   -->	
  function trim(str){
    while(str.length != 0 && str.substring(0,1) == ' '){
      str = str.substring(1);
    }
    while(str.length != 0 && str.substring(str.length -1) == ' '){
      str = str.substring(0, str.length -1);
    }
    return str;
  }
  //function submit the form
  function submit() {

    var queryName = trim(document.frmSaveQuery.txtQueryName.value);

      if(queryName ==null || queryName ==""){
        alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Search.YoumustenteraName</framework:i18nScript>");
        document.frmSaveQuery.txtQueryName.focus();
      } else{
        document.frmSaveQuery.action= "emxInfoSaveQuery.jsp"
        document.frmSaveQuery.submit();
		}
}
</script>
</head>
<body class="content">
<form name="frmSaveQuery" method="post" >
<%
boolean csrfEnabled = ENOCsrfGuard.isCSRFEnabled(context);
if(csrfEnabled)
{
  Map csrfTokenMap = ENOCsrfGuard.getCSRFTokenMap(context, session);
  String csrfTokenName = (String)csrfTokenMap .get(ENOCsrfGuard.CSRF_TOKEN_NAME);
  String csrfTokenValue = (String)csrfTokenMap.get(csrfTokenName);
%>
  <!--XSSOK-->
  <input type="hidden" name= "<%=ENOCsrfGuard.CSRF_TOKEN_NAME%>" value="<%=csrfTokenName%>" />
  <!--XSSOK-->
  <input type="hidden" name= "<%=csrfTokenName%>" value="<%=csrfTokenValue%>" />
<%
}
//System.out.println("CSRFINJECTION::DSCSaveQueryDialog.jsp::form::frmSaveQuery");
%>


<table border="0" cellspacing="2" cellpadding="3" width="100%" >
  <tr>
    <td class="label"><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.Name</framework:i18n></td>
    <td class="inputField"><input type="text" name="txtQueryName" size="25" onkeypress="javascript:submitThis(event);"></td>
  </tr>
</table>
</form>
</body>
</html>
