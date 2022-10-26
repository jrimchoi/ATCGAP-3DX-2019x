<%--  emxInfoRevisionAttributeDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoRevisionAttributeDialog.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoRevisionAttributeDialog.jsp $
 * *****************  Version 11  *****************
 * User: Rajesh G  Date: 12/18/2003    Time: 8:44p
 * Updated in $/InfoCentral/src/infocentral
 * Changed For key pressed check Enter/Tab/Escape
 * ************************************************ *  * 
 * *****************  Version 10  *****************
 * User: Rahulp       Date: 1/13/03    Time: 8:39p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 9  *****************
 * User: Snehalb      Date: 11/25/02   Time: 4:09p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 8  *****************
 * User: Mallikr      Date: 11/22/02   Time: 5:57p
 * Updated in $/InfoCentral/src/InfoCentral
 * changed headers and added previous button
 * 
--%>
<%@include file   ="emxInfoCentralUtils.inc"%> 			<%--For context, request wrapper methods, i18n methods--%>

<%@ page import="com.matrixone.apps.domain.DomainObject" %>

<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css"><!--This is required for the font of the text-->
<link rel="stylesheet" href="../common/styles/emxUIDialog.css" type="text/css" ><!--This is required for the cell (td) back ground colour-->
<link rel="stylesheet" href="../common/styles/emxUIList.css" type="text/css" >

<%@include file="emxInfoCalendarInclude.inc"%>		<%--Calendar control--%>

<html>
<head>
<script language="JavaScript">

<%
	String attrModelType = com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_ModelType");
	String attrDesignatedUser = com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_DesignatedUser");
%>
	function changeDisplayValue(inputName)
	{
		var Unassigned =  "<%=i18nStringNowLocal("emxIEFDesignCenter.Common.Unassigned", request.getHeader("Accept-Language"))%>";
		var defaultVal = "Unassigned";
		var inputElement = document.RevisionAttribute.elements[inputName + "_dummy"];
		var hiddenElement = document.RevisionAttribute.elements[inputName];

		if(hiddenElement != null && hiddenElement != "undefined" && inputElement.value == Unassigned)
		{
			hiddenElement.value = defaultVal;
		}
	}

    function done()
    {
	    //XSSOK
		changeDisplayValue("<%=attrModelType%>");
		//XSSOK
		changeDisplayValue("<%=attrDesignatedUser%>");

        document.RevisionAttribute.txtRevision.value = trim(document.RevisionAttribute.txtRevision.value);
        document.RevisionAttribute.submit();
    }
    
    function closeWindow()
    {
        parent.window.close();
    }

    function previous()
    {
        document.RevisionAttribute.action = "emxInfoCreateNewRevisionDialogFS.jsp";
        document.RevisionAttribute.target = "_parent";
        document.RevisionAttribute.submit();
    }

    // This Function Checks for the length of the Data that has
    // been entered and trims the leading and trailing spaces.
    function trim (textBox) 
    {
        while (textBox.charAt(textBox.length-1) == ' ' 
            || textBox.charAt(textBox.length-1) == "\r" 
            || textBox.charAt(textBox.length-1) == "\n" )
            textBox = textBox.substring(0,textBox.length - 1);
    
        while (textBox.charAt(0) == ' ' 
            || textBox.charAt(0) == "\r" 
            || textBox.charAt(0) == "\n")
            textBox = textBox.substring(1,textBox.length);
        return textBox;
    }

	function changeTextValue(comboName,fieldName){
	var editForm = document.RevisionAttribute;
	var comboValue;
	for (var i=0;i < editForm.elements.length;i++)
	{
				var xe = editForm.elements[i];
				if (xe.name==comboName)
					comboValue=xe.options[xe.selectedIndex].value;
					
	}
	for (var i=0;i < editForm.elements.length;i++)
		   {
				var xe = editForm.elements[i];
				if (xe.name== fieldName)
					xe.value = comboValue;
					
		   }
	}
	

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

	var submitAction = "done";
	document.onkeypress = cptKey ;
	//-- 12/17/2003         End  rajeshg   -->	


</script>
</head>

<%
    String sRevision         = emxGetParameter(request, "txtRevision");
    String sVault            = emxGetParameter(request, "txtVault") ;
    String objectId            = emxGetParameter(request, "objectId");
    //  Construct busiess object
    BusinessObject boGeneric = new BusinessObject(objectId);
    boGeneric.open(context);
%>

<body class="content" onload="document.RevisionAttribute.txtDescription.focus()">
<form name="RevisionAttribute" id="idForm"  action="emxInfoNewRevision.jsp" target="_self" >
  <input type="hidden" name="objectId" value="<%=XSSUtil.encodeForHTMLAttribute( context ,objectId )%>">
  <input type="hidden" name="parentOID" value="<%=XSSUtil.encodeForHTMLAttribute( context ,objectId )%>">
  <input type="hidden" name="txtRevision" value="<%=XSSUtil.encodeForHTMLAttribute( context ,sRevision )%>">
  <input type="hidden" name="txtVault" value="<%=XSSUtil.encodeForHTMLAttribute( context ,sVault )%>">

  <table border="0" width="100%" cellpadding="5" cellspacing="2">

<tr>
 <td valign="top" class="label" width="%25">
<%=i18nNow.getBasicI18NString("Description",  request.getHeader("Accept-Language"))%>
 </td>
<%
	String desc = "";
	desc = emxGetParameter(request, "txtDescription");
	if(desc == null || "null".equals(desc) )
		desc=boGeneric.getDescription();
%>
<td valign="top" class="field" ><textarea name="txtDescription" rows="5" cols="36" wrap><%=XSSUtil.encodeForHTML( context ,desc )%></textarea></td>
</tr>
<% 
request.setAttribute("form","RevisionAttribute");
%>
<%@include file="emxInfoObjectDisplayAttributes.inc"%>

<%
	boGeneric.close(context);
%>
</table>
</form>
</body>
</html>
