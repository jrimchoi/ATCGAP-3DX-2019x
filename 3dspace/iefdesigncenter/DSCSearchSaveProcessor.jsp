<%--  DSCSearchSaveProcessor.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%@ page buffer="100kb" autoFlush="false"%>
<%-- 

   static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/DSCSearchSaveProcessor.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>
<%@ page import="com.matrixone.jdom.*,
                 com.matrixone.jdom.Document,
                 com.matrixone.jdom.input.*,
                 com.matrixone.jdom.output.*,
				 com.matrixone.apps.domain.util.*" %>

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
//get request parameters
String saveType = emxGetParameter(request,"saveType");
String saveName = emxGetParameter(request,"saveName");

//
// Search name will come as the unicode values separated by . (dot)
// so form the saved search name from it.
//
saveName = decodeSaveSearchName(saveName);

SAXBuilder builder = new SAXBuilder();
XMLOutputter outputter = new XMLOutputter();
StringWriter sw = new StringWriter();

//close window or refresh?
boolean bCloseWindow = false;
boolean bRefreshWindow = false;

try
{
	//create DOM with incoming XML stream
	Document doc = builder.build(new java.io.BufferedInputStream(request.getInputStream()));
        String characterEncoding = request.getCharacterEncoding();
	// 10.5 SP3 does not set the encoding when creating the HTTP connection
	if (characterEncoding == null || characterEncoding.length() == 0)
	   characterEncoding = "UTF8";
	//string writer to hold XML string
	outputter.output(doc, sw);
	String userAgent = request.getHeader("User-Agent");
	boolean isIE = userAgent.indexOf("MSIE") > 0;

	boolean isUTF8Encoding = "UTF-8".equalsIgnoreCase(characterEncoding) || "UTF8".equalsIgnoreCase(characterEncoding);

	if (!isIE && !isUTF8Encoding)
	{
		//only if encoding not UTF-8 and non IE browser
		saveName = FrameworkUtil.decodeURL(saveName,characterEncoding); 
	}
	
	
		boolean isAlreadyExist = false;
		String strLanguage         = request.getHeader("Accept-Langugae");
		String strAlreadyExistsMessage = i18nNow.getI18nString("emxFrameworkStringResource", 	
												   "emxFramework.SavedSearch.AlreadyExistsMsg",
												   strLanguage);

	
	

	//perform save, update or delete based on saveType

    ContextUtil.startTransaction(context, true);
    
    String strResult  = MqlUtil.mqlCommand(context, "list query $1 select $2",saveName,"id");
    if (strResult != null && strResult.length() > 0)
    {
	isAlreadyExist = true;
    }
    if (isAlreadyExist == true)
       saveType = "update";
    if(saveType.equals("save")){		
    	UISearch.saveSearch(context, saveName, FrameworkUtil.encodeURL(sw.toString(), "UTF-8"));
    }else if(saveType.equals("update")){
        UISearch.updateSearch(context, saveName, FrameworkUtil.encodeURL(sw.toString(), "UTF-8"));
    }else if(saveType.equals("delete")){
        UISearch.deleteSearch(context, saveName);
        bRefreshWindow = true;
    }else{
    //do something
    }

//if not refreshing the window then close it
bCloseWindow = !bRefreshWindow;

} catch (Exception ex) {
    ContextUtil.abortTransaction(context);

	if (ex.toString() != null && (ex.toString().trim()).length() > 0)
	{
            	emxNavErrorObject.addMessage(ex.getMessage());
				
	}
	
} finally {
    ContextUtil.commitTransaction(context);
}

//clear the output buffer
out.clear(); %>

<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
<% if(bRefreshWindow){ %>
<script language="javascript">
var contentWindow = top.findFrame(top, "searchContent");
contentWindow.document.location.href = contentWindow.document.location.href;
</script>
<% }else if(bCloseWindow){ %>
<script language="javascript">
top.close();
</script>
<% }else{ %>
<script language="javascript">
top.opener.pageControl.clearSavedSearchName();
top.turnOffProgress();
</script>
<% } %>
