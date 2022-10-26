<%--  emxInfoSaveQuery.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoSaveQuery.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxInfoSaveQuery.jsp $
 * 
 * *****************  Version 5  *****************
 * User: Rahulp       Date: 12/09/02   Time: 5:37p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 4  *****************
 * User: Rahulp       Date: 12/03/02   Time: 6:22p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 3  *****************
 * User: Mallikr      Date: 11/23/02   Time: 5:42p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 2  *****************
 * User: Mallikr      Date: 11/23/02   Time: 5:40p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 1  *****************
 * User: Bhargava     Date: 9/24/02    Time: 5:41p
 * Created in $/InfoCentral/src/InfoCentral
 *
 * ***********************************************
 *
--%>
<%@include file = "../common/emxUIConstantsInclude.inc"%>
<%@include file= "emxInfoCentralUtils.inc"%>
<%@include file		= "DSCSearchUtils.inc"%>

<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<%
	String sTimeStamp = (String)request.getParameter("timeStamp");
	String integrationName	= emxGetParameter(request, "integrationName");
	if (integrationName == null || integrationName.equals(""))
	{
	   integrationName = getDefaultIntegrationName(request, (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject"));
	}

	// Get the Parameter List saved in emxInfoTable of the same time stamp 
	// for the last search submit
	HashMap paramList = (HashMap)session.getAttribute("ParameterList"+sTimeStamp);
	StringBuffer queryString = new StringBuffer();
	String sParameters = "";
	String queryName = "";
	if (paramList != null)
	{
		java.util.Set paramSet = paramList.keySet();
		Iterator paramIterator = paramSet.iterator();
		String skey = "";
		while(paramIterator.hasNext())
		{
			skey = (String)paramIterator.next();
			if (null == skey || 0 == skey.length()) continue;
			if ("url".equals(skey) || "LCO".equals(skey)
			   || "showAdvanced".equals(skey)) continue;
			if (queryString.length() > 0) {
				queryString.append("|");
			}
			queryString.append(skey);
			queryString.append("=");
	
			String value = (String)paramList.get(skey);
			if (skey.startsWith("txtWhere")) 
			{
			   value = escapeJavascript(value);
			   value = MCADUrlUtil.hexEncode(value);
			}   

			queryString.append(value);
		}
	}
	sParameters = queryString.toString();
    StringList exceptionList = new StringList();
	matrix.db.Query query = new matrix.db.Query(".finder");
	try
	{
		ContextUtil.startTransaction(context, true);
		queryName = emxGetParameter(request, "txtQueryName");
		query.open(context);
		query.setName(queryName);
		query.update(context);
		ContextUtil.commitTransaction(context);
	}
	catch(Exception ex)
	{
        ContextUtil.abortTransaction(context);
		exceptionList.add(ex.toString().trim());
	}
	finally{
		query.close(context);
	}
	
 for (int k =0 ;k<exceptionList.size();k++)
 {
 String exceptionMsg=((String)(exceptionList.get(k))).trim();
 exceptionMsg = exceptionMsg.replace('\n',' ');
%>
 <script language="JavaScript">
    //XSSOK
    alert("<%=exceptionMsg%>");
</script>		
<%
 }
%>
<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script> 
<script language="JavaScript" src="../iefdesigncenter/emxInfoUISearch.js" type="text/javascript"></script>
<script language="javascript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
<script language="JavaScript">

function saveQuerySearch(findType, comboDisplayType)
{
    //XSSOK
	var savedSearchName = "<%= queryName %>";
	pageControl = top.pageControl;
	pageControl.setSavedSearchName(encodeURIIfCharacterEncodingUTF8(encodeSaveSearchName(savedSearchName)));
	var contentURL = '';
	if (findType == 'AdvancedFind')
	  contentURL = '../iefdesigncenter/DSCSearchContentDialog.jsp';
    else if (findType == 'DSCFindLike') {
		contentURL = '../iefdesigncenter/emxInfoFindLikeDialog.jsp';
		if (comboDisplayType != null && comboDisplayType != 'undefined' && comboDisplayType != '' && comboDisplayType != 'null')
	     contentURL += '?ComboType=' + comboDisplayType + '&ComboDisplayType=' + comboDisplayType + '&reviseSearch=true&findType=DSCFindLike';
	}
	else
	  contentURL = '../iefdesigncenter/DSCFindLikeDialog.jsp'
	//XSSOK
	if ("<%=sParameters%>" != '')
	  //XSSOK
	  contentURL += '?' + "<%=sParameters%>";

	pageControl.setSearchContentURL(encodeURIIfCharacterEncodingUTF8(contentURL));
	//build xml doc from formfields

	var xmlData = buildXML();
	var url = "../iefdesigncenter/DSCSearchSaveProcessor.jsp";
	url += "?saveType=" + 'save';

	url += "&saveName=" + encodeURIIfCharacterEncodingUTF8(encodeSaveSearchName(savedSearchName));


	var oXMLHTTP = emxUICore.createHttpRequest();
	oXMLHTTP.open("post", url, false);
	oXMLHTTP.send(xmlData);
}

function loadQueryFormFields(params)
{
	// turnOffProgress();
	//var params = '<%=sParameters%>';
	var params = document.forms[0].searchParameters.value;

	if (null != params && 'undefined' != params && '' != params)
	{
		var paramArray = params.split('|');
		var findType = 'AdvancedSearch';
        var comboDisplayType = '';
		top.pageControl = new pageController();
		// stores the name/value pairs into the pageControl cache
		if (null != paramArray && top && top.pageControl)
		{
			for (var i = 0; i < paramArray.length; i++)
			{
				var paramNameValueArray = paramArray[i].split('=');
			
				if (paramNameValueArray)
				{
					var paramName = paramNameValueArray[0];
					var paramValue = paramNameValueArray[1];
					if (paramName == null || paramName == '') 
						continue;
					if (paramName == 'findType')
					   findType = paramValue;
                    if (paramName == 'txtBusType')
					   comboDisplayType = paramValue;

					if (paramName.indexOf('txtWhere') >= 0)
					{
					    //XSSOK
						paramValue = hexDecode('<%=integrationName%>',paramValue);
					} 
					
					top.pageControl.addToArrFormVals(new Array(paramName, paramValue, true, false));
				}
			}
		}

		if (findType != null && findType != '')
		 {
			 if (findType == 'AdvancedFind' || findType == 'FindLike' || findType == 'AdvancedSearch' || findType == 'DSCFindLike')
             {
				saveQuerySearch(findType, comboDisplayType);
             }
		 }
	}
	// waits for the Search dialog is completed loaded and then reset the form fields
}
 
//loadQueryFormFields();
//parent.window.close();
</script>  
<html>
<body onload="loadQueryFormFields(); parent.window.close(); return true;">
<form>

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
//System.out.println("CSRFINJECTION");
%>

<!--XSSOK-->
<input type="hidden" name="searchParameters" value="<%=sParameters%>">
</form>
</body>
</html>
