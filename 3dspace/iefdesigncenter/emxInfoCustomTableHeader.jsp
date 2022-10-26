<%--  emxInfoCustomTableHeader.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  
  $Archive: /InfoCentral/src/infocentral/emxInfoCustomTableHeader.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$
  
  Name of the File : emxInfoCustomTableHeader.jsp
  
  Description : This file sets the Header for Table page.

--%>

<%--
 * $History: emxInfoCustomTableHeader.jsp $
 * 
 * *****************  Version 36  *****************
 * User: Rahulp       Date: 1/15/03    Time: 1:25p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 35  *****************
 * User: Gauravg      Date: 12/16/02   Time: 6:37p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 34  *****************
 * User: Shashikantk  Date: 12/12/02   Time: 3:11p
 * Updated in $/InfoCentral/src/infocentral
 * Header frame made smaller
 * 
 * *****************  Version 33  *****************
 * User: Shashikantk  Date: 12/12/02   Time: 3:00p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 32  *****************
 * User: Shashikantk  Date: 12/11/02   Time: 7:29p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * ************************************************
 --%>
 
<script language="JavaScript">
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
  
// Add a handler
document.onkeypress = cptKey ;

</script>
<%@include file = "emxInfoCustomTableInclude.inc" %>

<%
    String header			= emxGetParameter(request, "custHeader");
    String sHelpMarker		= emxGetParameter(request, "HelpMarker");
    String suiteKey			= emxGetParameter(request, "suiteKey");
    String programList		= emxGetParameter(request, "custProgram");
    String sActionBarName	= emxGetParameter(request, "custTopActionbar");
    String tipPage			= emxGetParameter(request, "TipPage");
    String printerFriendly	= emxGetParameter(request, "PrinterFriendly");
    String objectId			= emxGetParameter(request, "objectId");
    String sTarget			= emxGetParameter(request, "custTargetLocation");
	String timeStamp		= emxGetParameter(request, "timeStamp");
	String portalMode		= emxGetParameter(request, "portalMode");

	if(portalMode == null || portalMode.equals("") || !portalMode.equalsIgnoreCase("true"))
		portalMode = "false";
       
    if (header != null)
        header = parseTableHeader(application, context, header, objectId, suiteKey, request.getHeader("Accept-Language"));
    

	// always check for "null" string . 
    if( ( objectId != null ) && !("null".equals(objectId)) && ( ! ( objectId.trim().equals("") ) ) )
	{
		try
		{
	    BusinessObject bus = new BusinessObject(objectId);
        bus.open(context);
        String sRevText = i18nNow.getI18nString("emxIEFDesignCenter.Common.Rev",null,request.getHeader("Accept-Language"));
        header = bus.getTypeName()+"  "+ bus.getName()+
			"  " + sRevText + " " +bus.getRevision()+ ":" + header;
        bus.close(context);
	}    
		catch(MatrixException ex)
		{
			System.out.println("MatrixException = " +ex );
		}
	}    

    String suiteDir = "";
    String registeredSuite = "";

    if ( suiteKey != null && suiteKey.startsWith("eServiceSuite") )
    {
        registeredSuite = suiteKey.substring(13);

        if ( (registeredSuite != null) && (registeredSuite.trim().length() > 0 ) )
            suiteDir = UINavigatorUtil.getRegisteredDirectory(application, registeredSuite);
    }

%>
<html>
<head>
	<title>Table Header</title>
		<link rel="stylesheet" type="text/css" href="../common/styles/emxUIList.css" />
	<link rel="stylesheet" type="text/css" href="../common/styles/emxUIMenu.css"  />
		<link rel="stylesheet" type="text/css" href="../common/styles/emxUIDefault.css" />
	<link rel="stylesheet" type="text/css" href="../common/styles/emxUIToolbar.css"  />
    
	<%@include file= "emxInfoUIConstantsInclude.inc"%>
	<script language="javascript" type="text/javascript" src="../integrations/scripts/IEFHelpInclude.js"></script>
		<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICore.js"></script>
        <script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICoreMenu.js"></script>
        <script language="JavaScript" type="text/javascript" src="../common/scripts/emxUIToolbar.js"></script>
		<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUIConstants.js"></script>
		<%@include file = "../emxStyleDefaultInclude.inc"%>
	        <script language="JavaScript" type="text/javascript">
            addStyleSheet("emxUIToolbar");
            addStyleSheet("emxUIMenu");
        </script>

</head>
<body >
<form name="tableHeaderForm" method="post">
<table border="0" cellspacing="2" cellpadding="0" width="100%">
<tr>
<td width="99%">
<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tr>
<td class="pageBorder"><img src="../common/images/utilSpacer.gif" width="1" height="1" alt=""></td>
</tr>
</table>
<table border="0" width="100%" cellspacing="0" cellpadding="0">
<tr>
							<td width="1%" nowrap><span class="pageHeader">&nbsp;<%=header%></span></td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;<img src="../common/images/utilProgressSummary.gif" width="34" height="28" name="imgProgress"></td>
							<td width="1%"><img src="images/utilSpacer.gif" width="1" height="32" border="0" alt="" vspace="6"></td>							
							<td align="right" class="filter">&nbsp;</td>
</tr>
</table>

	<!-- Use this code to enable AEF style toolbar -->
			<jsp:include page = "../common/emxToolbar.jsp" flush="true">
			<jsp:param name="toolbar" value="<%=sActionBarName%>"/>
			<jsp:param name="objectId" value="<%=objectId%>"/>
			<jsp:param name="parentOID" value="<%=objectId%>"/>
			<jsp:param name="timeStamp" value="<%=timeStamp%>"/>
			<jsp:param name="header" value="<%=header%>"/>
			<jsp:param name="PrinterFriendly" value="<%=printerFriendly%>"/>
			<jsp:param name="helpMarker" value="<%=sHelpMarker%>"/>
			<jsp:param name="suiteKey" value="<%=suiteKey%>"/>
			<jsp:param name="tipPage" value="<%=tipPage%>"/>
			<jsp:param name="export" value="false"/>
			<jsp:param name="portalMode" value="<%=portalMode%>"/>
 </jsp:include>
</td>
  <td><img src="../common/images/utilSpacer.gif" alt="" width="4"></td>
</tr>
</table>
<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
</form>
</body>
</html>
