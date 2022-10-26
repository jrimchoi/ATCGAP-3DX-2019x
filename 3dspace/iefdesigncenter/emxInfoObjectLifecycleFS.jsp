<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file = "emxInfoUtils.inc"%>
<%@include file = "../emxTagLibInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<%@ page import="matrix.db.BusinessObject"%>

<%@ page import="com.matrixone.MCADIntegration.server.beans.*,com.matrixone.apps.domain.util.*"  %>
<%@ page import="com.matrixone.MCADIntegration.utils.*" %>
	<html>
<head>
	<title>Table Header</title>
	<link rel="stylesheet" type="text/css" href="../common/styles/emxUIMenu.css" >
	<link rel="stylesheet" type="text/css" href="../common/styles/emxUIDefault.css" />
	<link rel="stylesheet" type="text/css" href="../common/styles/emxUIToolbar.css"  />

	<%@include file = "emxInfoUIConstantsInclude.inc"%>
		<script language="javascript" type="text/javascript" src="../integrations/scripts/IEFHelpInclude.js"></script>
		<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICore.js"></script>
        <script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICoreMenu.js"></script>
        <script language="JavaScript" type="text/javascript" src="../common/scripts/emxUIToolbar.js"></script>
		<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUIConstants.js"></script>
		<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUIModal.js"></script>

</head>

<%

 MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData)session.getAttribute("MCADIntegrationSessionDataObject");

 MCADMxUtil util								= new MCADMxUtil(context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
  
  String appendParams = emxGetQueryString(request);
  
//  String objectLifecycleHeaderURL = "emxInfoObjectLifecycleHeader.jsp?" + appendParams;

  String objectLifecycleBodyURL = "emxInfoObjectLifecycleDialog.jsp?" + appendParams;
  
  %>  
       
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
		var sQueryString = "<%=XSSUtil.encodeForJavaScript(context,appendParams)%>";
		var strFeatures = "scrollbars=yes,toolbar=yes,location=no,resizable=yes";
		var url = "emxInfoObjectLifecycleDialog.jsp?" + sQueryString;
		printDialog = window.open(url, "PF" + (new Date()).getTime(), strFeatures);

	}
</script>

<%
	String header = emxGetParameter(request, "header");
	String sHelpMarker = emxGetParameter(request, "HelpMarker");
    String suiteKey = emxGetParameter(request, "suiteKey");
    String sActionBarName = emxGetParameter(request, "topActionbar");
    String tipPage = emxGetParameter(request, "TipPage");
    String printerFriendly = emxGetParameter(request, "PrinterFriendly");
	String objectId = Request.getParameter(request,"objectId");
	String timeStamp = emxGetParameter(request, "timeStamp");

    //Open the current BusinessObject


    BusinessObject boGeneric = new BusinessObject(objectId);
    boGeneric.open(context);

    //Get the TNR of the BusinessObject
    String sType = boGeneric.getTypeName();
    String sName = boGeneric.getName();
    String sRevision = boGeneric.getRevision();
    String sObjectId = boGeneric.getObjectId();
    sType         = util.getNLSName(context, "Type", boGeneric.getTypeName(), "", "", request.getHeader("Accept-Language"));

	if(null == session.getAttribute("pageheader"))
	{
        header = parseTableHeader(application, context, header, objectId, suiteKey, request.getHeader("Accept-Language"));
		session.setAttribute("pageheader", header);
	}else{
        header = (String)session.getAttribute("pageheader");
	}

	String sRevText = i18nStringNowLocal("emxIEFDesignCenter.Common.Rev", request.getHeader("Accept-Language"));
	header =sType+"  "+ sName + "  " + sRevText + " " + sRevision + ":" + header;
    String suiteDir = "";
    String registeredSuite = "";

    if ( ( suiteKey != null ) && ( suiteKey.startsWith("eServiceSuite") ) )
    {
        registeredSuite = suiteKey.substring(13);

        if ( (registeredSuite != null) && (registeredSuite.trim().length() > 0 ) )
            suiteDir = UINavigatorUtil.getRegisteredDirectory(application, registeredSuite);
    }

%>

<body onload="turnOffProgress();">
    <div id="pageHeadDiv"  frameborder="0"  style="position:top:0;	right:0;bottom:5;	left:0;;">
    	<table border="0" cellspacing="1" cellpadding="0" width="100%" >
			<tr>
				<td width="99%">

					<table border="0" width="100%" cellspacing="0" cellpadding="0">
						<tr>
							<td width="1%" nowrap><span class="pageHeader">&nbsp;<%=XSSUtil.encodeForHTML(context,header)%></span></td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;<img src="../common/images/utilProgressSummary.gif" width="34" height="1" name="imgProgress"></td>
							<td width="1%"><img src="images/utilSpacer.gif" width="1" height="1" border="0" alt="" vspace="6"></td>	<td align="right" class="filter">&nbsp;</td>
						</tr>
					</table>
				<!-- Use this code to enable AEF style toolbar -->
					<jsp:include page = "../common/emxToolbar.jsp" flush="true">
						<jsp:param name="toolbar" value="<%=XSSUtil.encodeForURL(context, sActionBarName)%>"/>
						<jsp:param name="objectId" value="<%=XSSUtil.encodeForURL(context, objectId)%>"/>
						<jsp:param name="parentOID" value="<%=XSSUtil.encodeForURL(context, objectId)%>"/>
						<jsp:param name="timeStamp" value="<%=XSSUtil.encodeForURL(context, timeStamp)%>"/>
						<jsp:param name="header" value="<%=XSSUtil.encodeForURL(context, header)%>"/>
						<jsp:param name="PrinterFriendly" value="<%=XSSUtil.encodeForURL(context, printerFriendly)%>"/>
						<jsp:param name="helpMarker" value="<%=XSSUtil.encodeForURL(context, sHelpMarker)%>"/>
						<jsp:param name="suiteKey" value="<%=XSSUtil.encodeForURL(context, suiteKey)%>"/>
						<jsp:param name="tipPage" value="<%=XSSUtil.encodeForURL(context, tipPage)%>"/>
						<jsp:param name="export" value="false"/>
					</jsp:include>
			</td>
			<td><img src="../common/images/utilSpacer.gif" alt="" width="4"></td>
		</tr>
	</table>
</div>
      <div id='pageBodyDiv'>
		<iframe name='Lifecycle' id='bodyframeid' src='<%=XSSUtil.encodeForHTML(context,objectLifecycleBodyURL)%>' width="100%" frameborder="0" style="position:relative;"></iframe>
      </div>
      <div id='pageFootDiv'>
		  <iframe name="pagesignature" id='footerframe' src="emxBlank.jsp" width="100%" frameborder="0" style="position:relative;"></iframe>
      </div>
</body>
</html>

