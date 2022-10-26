<%--  DSCCompareStructureWizardDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%-- emxInfoConnectSearchDialog.jsp - This file supports connect search functionality.


  static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/DSCCompareStructureWizardDialog.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>

<%@include file= "emxInfoCentralUtils.inc"%>
<%@include file= "../emxJSValidation.inc"%>
<%@include file= "../emxUICommonHeaderBeginInclude.inc"%>
<%@page import= "java.net.*" %>
<script language="JavaScript" src="emxInfoUIModal.js"></script>
<script language="javascript" src="emxInfoCentralJavaScriptUtils.js"></script>
<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script> <%--Required by emxUIActionbar.js below--%>
<script language="JavaScript" src="../common/scripts/emxUIActionbar.js" type="text/javascript"></script> <%--To show javascript error messages--%>
<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICore.js"></script>

<script language="Javascript">

    function doSearch()
    {
		var strQueryLimit = parent.document.bottomCommonForm.QueryLimit.value;
        document.frmConnectSearch.queryLimit.value = strQueryLimit;

        document.frmConnectSearch.txtType.value = trimWhitespace(document.frmConnectSearch.txtType.value);
        if (document.frmConnectSearch.txtType.value ==  '')
        {
            alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Error.ChooseType</framework:i18nScript>");
           // document.frmConnectSearch.btnTypeSelector.focus();
 		   document.frmConnectSearch.txtType.focus();
           return;
        }

        if (charExists(document.frmConnectSearch.txtName.value, '"') )
        {
            alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.SpecialCharacters</framework:i18nScript>");
            document.frmConnectSearch.txtName.focus();
            return;
        }

        document.frmConnectSearch.txtRev.value = trimWhitespace(document.frmConnectSearch.txtRev.value);
        if (charExists(document.frmConnectSearch.txtRev.value, '"'))
        {
            alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.SpecialCharacters</framework:i18nScript>");
            document.frmConnectSearch.txtRev.focus();
            return;
        }

        document.frmConnectSearch.txtType.value = trimWhitespace(document.frmConnectSearch.txtType.value);
        if (charExists(document.frmConnectSearch.txtType.value, '"'))
        {
            alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.SpecialCharacters</framework:i18nScript>");
            document.frmConnectSearch.txtType.focus();
            return;
        }

        document.frmConnectSearch.txtOwner.value = trimWhitespace(document.frmConnectSearch.txtOwner.value);
        if (charExists(document.frmConnectSearch.txtOwner.value, '"'))
        {
            alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.SpecialCharacters</framework:i18nScript>");
            document.frmConnectSearch.txtOwner.focus();
            return;
        }

        document.frmConnectSearch.txtVault.value = trimWhitespace(document.frmConnectSearch.txtVault.value);
        if (charExists(document.frmConnectSearch.txtVault.value, '"'))
        {
            alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.SpecialCharacters</framework:i18nScript>");
            document.frmConnectSearch.txtVault.focus();
            return;
        }
        document.frmConnectSearch.submit();
    }

    var strTxtType = "document.forms['frmConnectSearch'].selType";
    var txtType = null;

    var strTxtTypeDisp = "document.forms['frmConnectSearch'].txtType";
    var txtTypeDisp = null;

    //Query : can abstracts be selected?
    var bAbstractSelect = true;
    var bMultiSelect = true;

    //define varaibles required for showing vault chooser
    var bVaultMultiSelect = true;
    var strTxtVault = "document.forms['frmConnectSearch'].txtVault";
    var txt_Vault = null;

	var browser = navigator.userAgent.toLowerCase();
	function cptKey(e)
	{
		var pressedKey = ("undefined" == typeof (e)) ? event.keyCode : e.keyCode ;
		if(browser.indexOf("msie") > -1)
		{
			if (((pressedKey == 8) ||((pressedKey == 37) && (event.altKey)) || ((pressedKey == 39) && (event.altKey))) &&((event.srcElement.form == null) || (event.srcElement.isTextEdit == false)))
				return false;
			if( (pressedKey == 37 && event.altKey) || (pressedKey == 39 && event.altKey) && (event.srcElement.form == null || event.srcElement.isTextEdit == false))
				return false;
		}
		else if(browser.indexOf("mozilla") > -1 || browser.indexOf("netscape") > -1)
		{
			var targetType =""+ e.target.type;
			if(targetType.indexOf("undefined") > -1)
			{
				if( pressedKey == 8 || pressedKey == 37 )
					return false;
			}
		}

		if (pressedKey == "27")
		{
			top.window.close();
		}
	}

	if(browser.indexOf("msie") > -1)
	{
	   document.onkeydown = cptKey ;
	}
	else if(browser.indexOf("mozilla") > -1 || browser.indexOf("netscape") > -1)
	{
		document.onkeypress = cptKey ;
	}
</script>

<%
    try
    {
	    String languageStr = request.getHeader("Accept-Language");
		String I18NResourceBundle	= "emxIEFDesignCenterStringResource";
	    String appDirectory = (String) application.getAttribute("eServiceSuiteDesignerCentral.Directory");

	    if( (lStr == null ) || ( "".equals(lStr) ) )
        {
		    lStr = "en";
	    }

		String objectId		= emxGetParameter(request, "objectId");
		String timeStamp	= emxGetParameter(request, "timeStamp");
		String headerKey	= i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.SelectCompare", I18NResourceBundle, languageStr);

	    Enumeration enumParamNames = emxGetParameterNames(request);
	    HashMap paramMap = new HashMap();

	    while (enumParamNames.hasMoreElements())
        {
		    String paramName = (String) enumParamNames.nextElement();
		    String paramValue = (String) emxGetParameter(request, paramName);

		    if (paramValue != null && paramValue.trim().length() > 0)
			    paramMap.put(paramName, paramValue);
	    }

	    paramMap.put("languageStr", request.getHeader("Accept-Language"));
	    String[] intArgs = new String[] {};
	    StringList typeList = (StringList) JPO.invoke(context, "IEFListTypesToCompare", intArgs, "getList", JPO.packArgs(paramMap), StringList.class);
%>
<%@include file = "../emxUICommonHeaderEndInclude.inc"%>
<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>
<body class="content" onload="document.frmConnectSearch.txtType.focus()">

<form name="frmConnectSearch" action="emxInfoTable.jsp?expandCheckFlag=true" target="_parent" method="post" >

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
//System.out.println("CSRFINJECTION::DSCCOmpareStructureWizardDialog");
%>

<input type=hidden  name=objectId value="<%=XSSUtil.encodeForHTML(context, objectId)%>" >
<input type=hidden  name=sRelationName value="" >
<input type=hidden  name=sRelDirection value="" >
<input type=hidden  name=program value="IEFAdvancedFind:getList" >
<input type=hidden  name=table value="DSCDefaultForCompare" >
<input type=hidden  name=topActionbar value="DSCCompareStructureTopActionBarActions">
<input type=hidden  name=header value="<%=XSSUtil.encodeForHTML(context, headerKey)%>" >
<input type=hidden  name=selection value="single">
<input type=hidden  name=pagination value="10">
<input type=hidden  name=headerRepeat value="10">
<input type=hidden name="queryLimit" value="">
<input type=hidden name="targetLocation" value="popup">
<input type=hidden name="suiteKey" value="<%=XSSUtil.encodeForHTML(context, sInfoCentralSuite)%>">
<input type=hidden name="HelpMarker" value="emxhelpdsccomparestructure">


<table border="0" cellspacing="2" cellpadding="3" width="100%" >
  <tr>
    <td class="label"><%=i18nNow.getBasicI18NString("Type",  languageStr)%>
	</td>
<%
        String strTypeList = "";
        for(int i = 0 ; i<typeList.size(); i++)
        {
            String typeName =(String )typeList.get(i);
            strTypeList += "," +  typeName.trim();
        }
        strTypeList = strTypeList.trim();
        if( strTypeList.startsWith(","))
        {
            strTypeList = strTypeList.substring(1);
        }

		String defaultTypeValue = strTypeList;
		strTypeList= strTypeList.replace(' ', '+');

		String defaultNameValue		= "*";
		String defaultRevValue		= "*";
		String defaultOwnerValue	= "*";
		String defaultVaultValue	= "*";

		if(timeStamp!=null && !timeStamp.equals(""))
		{
			HashMap requestParamMap = (HashMap)session.getAttribute("ParameterList" + timeStamp);

			defaultTypeValue	= (String)requestParamMap.get("txtType");
			defaultNameValue	= (String)requestParamMap.get("txtName");
			defaultRevValue		= (String)requestParamMap.get("txtRev");
			defaultOwnerValue	= (String)requestParamMap.get("txtOwner");
			defaultVaultValue	= (String)requestParamMap.get("txtVault");
		}
%>

    <td class="inputField">
      <input type=text value="<%=XSSUtil.encodeForHTML(context, defaultTypeValue)  %>" size="16" name="txtType" <%=sKeyPress%> readonly>
      <input type=button name="btnTypeSelector" id="idBTNTypeSelector" value="..." onClick="showTypeSelector('<xss:encodeForHTML><%=strTypeList%></xss:encodeForHTML>', 'true', 'frmConnectSearch', 'txtType', 'true');">
      <input type=hidden value="" name="selType">
     </td>
    </tr>
  <tr>
    <td class="label"><%=i18nNow.getBasicI18NString("Name",  languageStr)%>
		  </td>
<!--XSSOK-->
    <td class="inputField"><input type="text" name="txtName" size="16" value="<%= defaultNameValue %>" <%=sKeyPress%>></td>
  </tr>
  <tr>
    <td class="label"><%=i18nNow.getBasicI18NString("Revision",  languageStr)%>
		</td>
<!--XSSOK-->
    <td class="inputField"><input type="text" name="txtRev" size="16" value="<%= defaultRevValue %>" <%=sKeyPress%>></td>
  </tr>

  <tr>
    <td class="label"><%=i18nNow.getBasicI18NString("Owner",  languageStr)%>
	  </td>
<!--XSSOK-->
    <td class="inputField"><input type="text" name="txtOwner" size="16" value="<%= defaultOwnerValue %>" <%=sKeyPress%>></td>
  </tr>
  <tr>
    <td class="label"><%=i18nNow.getBasicI18NString("Vault",  languageStr)%>
		</td>
    <td class="inputField">
<!--XSSOK-->
      <input type=text value="<%= defaultVaultValue %>" size="16" name="txtVault" <%=sKeyPress%>>
      <input type=button value="..." onClick=showVaultSelector()>
    </td>
  </tr>
</table>
</form>
<%
    }
    catch (Exception ex )
    {
		String sError = ex.toString();
		sError = sError.replace('\n',' ');
		sError = sError.replace('\r',' ');
		sError=sError.substring(sError.lastIndexOf(":")+1);
    }
%>
<%@include file= "../emxUICommonEndOfPageInclude.inc"%>
</body>
