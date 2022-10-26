<%--  emxInfoViewer.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoViewer.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoViewer.jsp $
 * 
 * *****************  Version 9  *****************
 * User: Rahulp       Date: 1/24/03    Time: 6:45p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 8  *****************
 * User: Rahulp       Date: 1/24/03    Time: 2:11p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 7  *****************
 * User: Rahulp       Date: 1/20/03    Time: 6:33p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 6  *****************
 * User: Rahulp       Date: 1/20/03    Time: 4:56p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 5  *****************
 * User: Rahulp       Date: 1/16/03    Time: 10:33a
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 4  *****************
 * User: Rahulp       Date: 1/15/03    Time: 1:25p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 3  *****************
 * User: Snehalb      Date: 11/25/02   Time: 5:15p
 * Updated in $/InfoCentral/src/InfoCentral
 *
 * ***********************************************
 *
--%>

<%@include file="emxInfoCentralUtils.inc"%>
<%@include file="../emxUICommonHeaderBeginInclude.inc"%>
<%@ page import = "com.matrixone.apps.domain.util.*"%>
<%@ page import="com.matrixone.apps.domain.DomainObject,com.matrixone.MCADIntegration.utils.MCADUrlUtil"%>

<%
    String sUrl		= emxGetParameter(request,"url");
    sUrl			= getRealURL(sUrl);
    String id		= emxGetParameter(request,"id");
    String sFile	= emxGetParameter(request,"file");
    String sFormat	= emxGetParameter(request,"format");
    String mid		= emxGetParameter(request, "mid");
		
    String param = sUrl + "?";

	if (null != sFile && sFile.length() > 0) 
	{
		sFile = MCADUrlUtil.hexDecode(sFile);
	}
%>

<script Language="JavaScript">

function openFileWindow(param)
{
	document.viewerForm.submit();
   
     return;
}

</script>

<body onLoad='javascript:openFileWindow("<%=XSSUtil.encodeForJavaScript(context,param)%>")'>

<form name="viewerForm" action="<%=XSSUtil.encodeForHTML(context,sUrl)%>" method="post"">
<% if (null != mid && mid.length() > 0) { %> <input type="hidden"
	name="mid" value="<%=mid%>" /> <% } %> <% if (null != id && id.length() > 0) { %>
<input type="hidden" name="id" value="<%=XSSUtil.encodeForHTML(context,id)%>" /> <% } %> <% if (null != sFile && sFile.length() > 0) { %>
<input type="hidden" name="filename" value="<%=sFile%>" /> <% } %> <% if (null != sFormat && sFormat.length() > 0) { %>
<input type="hidden" name="format" value="<%=XSSUtil.encodeForHTML(context,sFormat)%>" /> <% } %>
<input type="hidden" name="action" value="view"/>
</form>

</body>
<%!
  // ----------------------------------------------
  // BEGIN Integration Modification (DDELUCA: 11/28/02)
  // J2EE or non-J2EE servlet URL
  // if we are within a J2EE or non-J2EE environment.
  // It uses similar logic as FrameworkServlet.getRealURL(string)
  // ---------------------------------------------------------------------

    static public String getRealURL(String url)
    {
        String PROXY_SERVER_LOOKUP = "ematrix.proxy.server";
        String WEB_APP_LOOKUP = "ematrix.web.app";
        String WEB_APP_NAME = "ematrix.page.path";

        StringBuffer buf = new StringBuffer();
        if (Framework.getPropertyBoolean(WEB_APP_LOOKUP, false))
        {
            String proxy = Framework.getPropertyValue(PROXY_SERVER_LOOKUP);
            if (proxy != null){
               buf.append(proxy);
            }

            String webAppName = Framework.getPropertyValue(WEB_APP_NAME);
            if (webAppName != null){
               buf.append(webAppName);
            }
        }

        if (url != null){
           buf.append(url);
        }
        return buf.toString();
     }

%>
