<%--  emxInfoObjectInstanceHeader.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoObjectLifecycleHeader.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$
  
  Name of the File : emxInfoObjectLifecycleHeader.jsp
  
  Description :  Header page for Object Life cycle

--%>


<%--
 *
 * $History: emxInfoObjectLifecycleHeader.jsp $
 * 
 * *****************  Version 17  *****************
 * User: Rahulp       Date: 1/15/03    Time: 1:25p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * ***********************************************
 *
--%>
<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file = "emxInfoUtils.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<%@ page import="matrix.db.BusinessObject,com.matrixone.MCADIntegration.server.beans.*"%>
<%!
static public String parseTableHeader(ServletContext application, Context context, String header, String objectId, String suiteKey, String langStr)
{

    String registeredSuite = "";
    String suiteDir = "";
    String stringResFileId = "";

    try {

        if ( suiteKey != null && suiteKey.startsWith("eServiceSuite") )
            registeredSuite = suiteKey.substring(13);
        else if( suiteKey != null)
             registeredSuite = suiteKey;
    

        if ( (registeredSuite != null) && (registeredSuite.trim().length() > 0 ) )
        {
          suiteDir = UINavigatorUtil.getRegisteredDirectory(application, registeredSuite);
          stringResFileId = UINavigatorUtil.getStringResourceFileId(application, registeredSuite);
        }

        if( header != null && header.trim().length() > 0 )
        {
            // Get the label from string resource, if it does not contain macros.
            header = UINavigatorUtil.getI18nString(header, stringResFileId , langStr);

            // Then if the label contain macros, parse them
            if (header.indexOf("$") >= 0 )
            {
                if (objectId != null && objectId.length() > 0 )
                {
                    header = UIExpression.substituteValues(context, header, objectId);
                } else {
                    header = UIExpression.substituteValues(context, header);
                }
            }
        }
    } catch (Exception ex) {
        System.out.println("emxTable:parseTableHeader - error : " + ex.toString() );
        return header;
    }

    return header;
}

%>
<script language="javascript">
	function openPrinterFriendlyPage()
	{
	    //XSSOK
		var sQueryString = "<%=emxGetQueryString(request)%>";
		var strFeatures = "scrollbars=yes,toolbar=yes,location=no,resizable=yes";
		var url = "emxInfoObjectLifecycleDialog.jsp?" + sQueryString;
		printDialog = window.open(url, "PF" + (new Date()).getTime(), strFeatures);

	}
</script>

<%	
	String header = emxGetParameter(request, "header");
	String sHelpMarker = emxGetParameter(request, "HelpMarker");
    String suiteKey = emxGetParameter(request, "suiteKey");
    String sActionBarName = "IEFObjectInstancesTopActionBarActions";
    String tipPage = emxGetParameter(request, "TipPage");
    String printerFriendly = emxGetParameter(request, "PrinterFriendly");
	String objectId = emxGetParameter(request, "objectId");
	String timeStamp = emxGetParameter(request, "timeStamp");

	MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
	String propertiesHeading = integSessionData.getStringResource("mcadIntegration.Server.Title.Properties");
%>
<html>
<head>
	<title>Table Header</title>
	<link rel="stylesheet" type="text/css" href="../common/styles/emxUIMenu.css"  />
	<link rel="stylesheet" type="text/css" href="../common/styles/emxUIDefault.css" />
	<link rel="stylesheet" type="text/css" href="../common/styles/emxUIToolbar.css"  />
	
	<%@include file = "emxInfoUIConstantsInclude.inc"%>
		<script language="javascript" type="text/javascript" src="emxInfoHelpInclude.js"></script>
		<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICore.js"></script>
        <script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICoreMenu.js"></script>
        <script language="JavaScript" type="text/javascript" src="../common/scripts/emxUIToolbar.js"></script>
		<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUIConstants.js"></script>
		<%@include file = "../emxStyleDefaultInclude.inc"%>
	        <script language="JavaScript" type="text/javascript">
            addStyleSheet("emxUIToolbar");
            addStyleSheet("emxUIMenu");
        </script>
<style type=text/css > body { background-color: #DDDECB; }</style>
</head>
    <body>
<table border="0" cellspacing="2" cellpadding="0" width="100%">
<tr>
<td width="99%">

<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td class="pageBorder"><img src="../integrations/images/utilSpace.gif" width="1" height="0" alt=""></td>
	</tr>
</table>

<table border="0" width="100%" cellspacing="0" cellpadding="0">
	<tr>
			<td width="1%" nowrap><span class="pageHeader">&nbsp;<%=propertiesHeading%></span></td>							
			<td width="1%"><img src="images/utilSpacer.gif" width="1" height="32" border="0" alt="" vspace="6"></td>	<td align="right" class="filter">&nbsp;</td>
	</tr>
</table>

<table border="0" cellspacing="0" cellpadding="0" width="100%">
		<tr>
			<td class="pageBorder"><img src="../integrations/images/utilSpace.gif" width="1" height="1"></td>
		</tr>
</table>
	<!-- Use this code to enable AEF style toolbar -->
		<jsp:include page = "../common/emxToolbar.jsp" flush="true">
			<jsp:param name="toolbar" value="<%=sActionBarName%>"/>
			<jsp:param name="objectId" value="<%=objectId%>"/>
			<jsp:param name="parentOID" value="<%=objectId%>"/>
			<jsp:param name="timeStamp" value="<%=timeStamp%>"/>
			<jsp:param name="header" value="<%=header%>"/>
			<jsp:param name="PrinterFriendly" value="false"/>
			<jsp:param name="helpMarker" value="<%=sHelpMarker%>"/>
			<jsp:param name="suiteKey" value="<%=suiteKey%>"/>
			<jsp:param name="tipPage" value="<%=tipPage%>"/>
			<jsp:param name="export" value="false"/>
		</jsp:include> 
</td>
  <td><img src="../common/images/utilSpacer.gif" alt="" width="4"></td>
</tr>
</table>
<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
</body>
</html>
