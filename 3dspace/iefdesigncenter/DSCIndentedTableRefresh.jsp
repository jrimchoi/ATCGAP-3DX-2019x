<%--  DSCIndentedTableRefresh.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%@page import = "com.matrixone.apps.domain.util.*" %>
<%@page import="com.matrixone.servlet.Framework"%>
<%@page import="matrix.db.Context"%>

<%
   Context context= Framework.getMainContext(session);
	String sortColumnName	= Request.getParameter(request,"sortColumnName");
	String sortDirection	= Request.getParameter(request,"sortDirection");
	String refreshFrameName	= Request.getParameter(request,"refreshFrame");
%>

<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script> <%--Required by emxUIActionbar.js below and required for findFrame() function--%>

<script language="javascript" >
	var targetFrame = findFrame(top, "<%=XSSUtil.encodeForJavaScript(context,refreshFrameName)%>");
	if(targetFrame)
	{			
		var searchHiddenForm	= null;
		var searchForm			= null;

		if(null != targetFrame.parent && typeof targetFrame.parent != "undefined")
		{
			searchHiddenForm	= targetFrame.parent.document.forms['full_search_hidden'];
			searchForm			= targetFrame.parent.document.forms['full_search'];
		}

		if(null != searchHiddenForm && typeof searchHiddenForm != "undefined" && null != searchHiddenForm.action && searchHiddenForm.action != "")
			searchHiddenForm.submit();
			
		else if(null != searchForm && typeof searchForm != "undefined" && null != searchForm.action && searchForm.action != "")
			searchForm.submit();
			
		else
		    parent.location.href = parent.location.href;
	}
</script>
