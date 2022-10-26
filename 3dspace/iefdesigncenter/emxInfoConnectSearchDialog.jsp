<%--  emxInfoConnectSearchDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%-- emxInfoConnectSearchDialog.jsp - This file supports connect search functionality.



  static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxInfoConnectSearchDialog.jsp 1.3.1.4 Thu Jun 26 16:19:42 2008 GMT ds-ymore Experimental$
--%>

<%@include file= "emxInfoCentralUtils.inc"%>
<%@include file= "DSCSearchUtils.inc"%>
<%@include file= "../emxJSValidation.inc"%>
<%@include file= "../emxUICommonHeaderBeginInclude.inc"%>
<%@page import= "java.net.*" %>
<%@page import= "matrix.db.*,com.matrixone.MCADIntegration.server.beans.*,java.util.*,com.matrixone.MCADIntegration.utils.*" %>
<script language="JavaScript" src="emxInfoUIModal.js"></script> 
<script language="javascript" src="emxInfoCentralJavaScriptUtils.js"></script>
<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script> <%--Required by emxUIActionbar.js below--%>
<script language="JavaScript" src="../common/scripts/emxUIActionbar.js" type="text/javascript"></script> <%--To show javascript error messages--%>
<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICore.js"></script>
<%
String I18NResourceBundle = "emxIEFDesignCenterStringResource";
String acceptLanguage = request.getHeader("Accept-Language");
%>
<script language="Javascript">      
	
   function previousPage(isTemplateType) 
   {
        var form = document.frmConnectSearch;
        if(form == null)
			form = document.typeList;        

        var objectId = form.objectId.value;

        var relationshipName	 = form.sRelationName.value;
        var relDirection		 = form.sRelDirection.value;
		
		window.top.location.href = 
            "emxInfoObjectConnectWizardFS.jsp?parentOID=" + objectId
            + "&relationshipName=" + relationshipName
            + "&sRelDirection=" + relDirection
			+ "&isTemplateType=" + isTemplateType
			+ "&HelpMarker=emxHelpInfoObjectConnectWizard1FS";
        return;
    }
      
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
    } //end of function doSearch() 

  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // specify the place to return the string AS A STRING...
    // this cannot be an actual object reference or it will cause an error
    // define varaibles required for showing type chooser
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
			// ASCII code of the ESC key
			top.window.close();
		}
	}
// Add a handler
if(browser.indexOf("msie") > -1){
   document.onkeydown = cptKey ;
}else if(browser.indexOf("mozilla") > -1 || browser.indexOf("netscape") > -1){
	document.onkeypress = cptKey ;
}
</script>

<%
	String objectId		= null;
    try
    {
	    String languageStr = request.getHeader("Accept-Language");
	    String appDirectory = (String) application.getAttribute("eServiceSuiteDesignerCentral.Directory");

	    if( (lStr == null ) || ( "".equals(lStr) ) ) 
        {
		    lStr = "en";
	    }
	    String program = "IEFListTypesToConnect";
	    String method = "getList";
	    StringList typeList = null;
	    
//bug fix 277294[support linguistic character in Type] -start
		String sRelName		= null;
		String sObjType		= null;
		String sRelDirection = null;
		Properties connectObjprop = (Properties)session.getAttribute("connectObjprop_KEY");
		if(connectObjprop != null){
			sRelName		= connectObjprop.getProperty("sRelName");
			sObjType		= connectObjprop.getProperty("sObjType");
			objectId		= connectObjprop.getProperty("objectId");
			sRelDirection   = connectObjprop.getProperty("sRelDirection");

		}else{
			sRelName		= emxGetParameter(request, "sRelationName");
			sObjType		= emxGetParameter(request, "sObjType");
			objectId		= emxGetParameter(request, "objectId");
			sRelDirection	= emxGetParameter(request, "sRelDirection");
		}
		
		session.setAttribute("sRelNameRelDirection",sRelName +"|"+sRelDirection);
//bug fix 277294[support linguistic character in Type] -end

		String headerKey = null;
		// rajeshg - changed for custom relationship addition- 01/09/04
		String sConnect = null;
		sConnect = (String)session.getAttribute("DirectConnect");
		if ( "true".equals(sConnect) )
			headerKey = "emxIEFDesignCenter.Common.SelectDirectConnect";
		else
			headerKey = "emxIEFDesignCenter.Common.SelectConnect";
		// end

	    Enumeration enumParamNames = emxGetParameterNames(request);
	    HashMap paramMap = new HashMap();

	    while (enumParamNames.hasMoreElements()) 
        {
		    String paramName = (String) enumParamNames.nextElement();
		    String paramValue = (String) emxGetParameter(request, paramName);

		    if (paramValue != null && paramValue.trim().length() > 0)
			    paramMap.put(paramName, paramValue);
	    }
		paramMap.put("sRelationName", sRelName);//bug fix 277294
		paramMap.put("sObjType", sObjType);//bug fix 277294

	    paramMap.put("languageStr", request.getHeader("Accept-Language"));
	    String[] intArgs = new String[] {};
	    typeList = (StringList) JPO.invoke(context, program, intArgs, method, JPO.packArgs(paramMap), StringList.class);
		
		String integrationName	= emxGetParameter(request, "integrationName");
		if (integrationName == null || integrationName.equals(""))
		{
			integrationName = getDefaultIntegrationName(request, (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject"));
		}
		try
		{
			MCADIntegrationSessionData integSessionData   = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
			MCADGlobalConfigObject globalConfigObject = integSessionData.getGlobalConfigObject(integrationName,context);
			HashMap globalConfigObjectTable			  = (HashMap)integSessionData.getIntegrationNameGCOTable(context);	
			
			session.setAttribute("GCOTable", globalConfigObjectTable);
			session.setAttribute("GCO", globalConfigObject);				
			session.setAttribute("LCO", (Object)integSessionData.getLocalConfigObject());
		}
		catch(Exception e)
		{
			
		}
%>
<%@include file = "../emxUICommonHeaderEndInclude.inc"%>


<body class="content" onload="document.frmConnectSearch.txtType.focus()"> 

<form name="frmConnectSearch" action="../common/emxTable.jsp?expandCheckFlag=true" target="_parent" method="post" >


<input type=hidden  name=objectId value="<%=XSSUtil.encodeForHTML(context,objectId)%>" >
<input type=hidden  name=sRelationName value="<%=XSSUtil.encodeForHTML(context,sRelName)%>" >
<input type=hidden  name=sRelDirection value="<%=XSSUtil.encodeForHTML(context,sRelDirection)%>" >
<input type=hidden  name=program value="IEFAdvancedFind:getList" >
<input type=hidden  name=table value="DSCDefault" >
<input type=hidden  name=bottomActionbar value="IEFObjectConnectObjectBottomActionBar">
<!--XSSOK-->
<input type=hidden  name=header value="<%=headerKey%>" >
<input type=hidden  name=selection value="multiple">
<input type=hidden  name=pagination value="10">
<input type=hidden  name=headerRepeat value="10">
<input type=hidden name="queryLimit" value="">
<input type=hidden name="targetLocation" value="popup">
<input type=hidden name="suiteKey" value="<%=sInfoCentralSuite%>">
<input type=hidden name="selType" value="">
<input type=hidden name="HelpMarker" value="emxHelpInfoObjectConnectWizard3FS">
<input type=hidden name="integrationName" value="<%=XSSUtil.encodeForHTML(context,integrationName)%>">
<input type=hidden name="jpoAppServerParamList" value="session:GCOTable,session:GCO,session:LCO">

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
        if( strTypeList.startsWith(",") )
        {
            strTypeList = strTypeList.substring(1);
        }
		strTypeList= strTypeList.replace(' ','+');
		//strTypeList = java.net.URLEncoder.encode(strTypeList);//bug fix: 277294
%>
    <td class="inputField">
      <input type=text value="" readonly size="16" name="txtType" <%=sKeyPress%>>
	  <!--XSSOK-->
      <input type=button name="btnTypeSelector" id="idBTNTypeSelector" value="..." onClick="showTypeSelector('<%=strTypeList%>', 'true', 'frmConnectSearch', 'txtType', 'true');">
      <input type=hidden value="" size="16" name="selType">
     </td>
    </tr>
  <tr>
    <td class="label"><%=i18nNow.getBasicI18NString("Name",  languageStr)%>
		  </td>
    <td class="inputField"><input type="text" name="txtName" size="16" value="*" <%=sKeyPress%>></td>
  </tr>
  <tr>
    <td class="label"><%=i18nNow.getBasicI18NString("Revision",  languageStr)%>
		</td>
    <td class="inputField"><input type="text" name="txtRev" size="16" value="*" <%=sKeyPress%>></td>
  </tr>
  
  <tr>
    <td class="label"><%=i18nNow.getBasicI18NString("Owner",  languageStr)%>
	  </td>
    <td class="inputField"><input type="text" name="txtOwner" size="16" value="*" <%=sKeyPress%>></td>
  </tr>
  <tr>
    <td class="label"><%=i18nNow.getBasicI18NString("Vault",  languageStr)%>
		</td>
    <td class="inputField">
      <input type=text value="*" size="16" name="txtVault" <%=sKeyPress%>>
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
%>
    <script language="JavaScript">
	    //XSSOK
        showError("<%=sError%>");
        parent.window.location ="emxInfoObjectConnectWizardFS.jsp?parentOID=<%=XSSUtil.encodeForURL(context,objectId)%>";
    </script>
<%    
    }
%>
<%@include file= "../emxUICommonEndOfPageInclude.inc"%>
</body>
