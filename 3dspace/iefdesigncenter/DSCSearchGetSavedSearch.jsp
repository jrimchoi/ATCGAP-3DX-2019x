<%--  DSCSearchGetSavedSearch.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<% response.setContentType("text/xml; charset=UTF-8"); %><?xml version="1.0" encoding="UTF-8"?>

<%-- 

   static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/DSCSearchGetSavedSearch.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>
<%@ page import="com.matrixone.jdom.*,
                 com.matrixone.jdom.Document,
                 com.matrixone.jdom.input.*,
                 com.matrixone.jdom.output.*" %>
<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>

<%!
	public static String decodeSaveSearchName(String strEncodedSaveSearchName) throws Exception
	{
		StringTokenizer st = new StringTokenizer(strEncodedSaveSearchName,".");
		StringBuffer strbufDecodedSaveSearchName = new StringBuffer(16);
		while(st.hasMoreTokens())
		{
			String strToken = st.nextToken();
			char ch = (char)Integer.parseInt(strToken);
			strbufDecodedSaveSearchName.append(ch);
		}
		return strbufDecodedSaveSearchName.toString();
	}
%>

<%
String characterEncoding = request.getCharacterEncoding();
if (characterEncoding == null || characterEncoding.length() == 0)
   characterEncoding = "UTF8";
String saveName = emxGetParameter(request,"saveName");
saveName = decodeSaveSearchName(saveName);

String str = "";
XMLOutputter outputter = new XMLOutputter();

try
{

	String userAgent = request.getHeader("User-Agent");
	boolean isIE = userAgent.indexOf("MSIE") > 0;

	boolean isUTF8Encoding = "UTF-8".equalsIgnoreCase(characterEncoding) ||
		                     "UTF8".equalsIgnoreCase(characterEncoding);


	if (!isIE && !isUTF8Encoding)
	{
		//only if encoding not UTF-8 and non IE browser
		saveName = FrameworkUtil.decodeURL(saveName, characterEncoding); 
	}
       

	ContextUtil.startTransaction(context, true);

	String searchData = UISearch.getSearchData(context, saveName);
	 
    str = FrameworkUtil.decodeURL(searchData, "UTF-8");
	//str = com.matrixone.apps.domain.util.XSSUtil.decodeFromURL(str);

%><% out.clear(); %><%= str %><%  

} catch (Exception ex) {
    ContextUtil.abortTransaction(context);
    if (ex.toString() != null && (ex.toString().trim()).length() > 0)
        emxNavErrorObject.addMessage(ex.toString().trim());
%><%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%><%  
} finally {
    ContextUtil.commitTransaction(context);
}
%>
