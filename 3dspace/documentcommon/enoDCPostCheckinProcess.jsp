<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@page import="com.dassault_systemes.enovia.documentcommon.DCConstants"%>
<%
String strObjectId = emxGetParameter(request, DCConstants.OBJECTID);
%>
<script language="Javascript" src="../common/scripts/emxUIConstants.js"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
<script language="Javascript">
	var contentFrame = findFrame(getTopWindow().opener.getTopWindow(), "content");
	if(contentFrame)
    {
    	contentFrame.document.location.href = "../common/emxTree.jsp?objectId=<%=XSSUtil.encodeForURL(context, strObjectId)%>";
    }
    getTopWindow().close();
</script>
<%

%>
