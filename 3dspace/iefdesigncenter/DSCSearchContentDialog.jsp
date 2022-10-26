<%--  DSCSearchContentDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%-- DSCSearchContentDialog.jsp --


   static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/DSCSearchContentDialog.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>

<%@include file = "../emxUICommonAppInclude.inc"%>
<%@include file = "../teamcentral/emxTeamCommonUtilAppInclude.inc"%>
<%@include file = "../emxUICommonHeaderBeginInclude.inc" %>
<%@include file = "DSCCommonUtils.inc" %>
<%@include file = "../common/emxUIConstantsInclude.inc"%>
<%@ page import="com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.beans.*"  %>
<%@include file = "DSCSearchUtils.inc" %>



<%
    StringBuffer queryString			= new StringBuffer("");
    String sParameters					= "";
    String ResourceFileId				= "emxFrameworkStringResource";
    String sTimeStampPassed				= ""; 
	HashMap paramList					= new HashMap();
    Hashtable stateTable				= null;	
	ResourceBundle iefProperties		= PropertyResourceBundle.getBundle("ief");
	String allowWildCardsInECOSearch	= iefProperties.getString("mcadIntegration.AllowWildCardsInECOSearch").toLowerCase();	

    String STR_SEARCH_RESAVE_FORM_DATA  = UINavigatorUtil.getI18nString("emxFramework.GlobalSearch.ErrorMsg.ReSaveFormData", ResourceFileId, request.getHeader("Accept-Language"));

    String sTimeStamp					= (String)request.getParameter("timeStamp");
    boolean isECInstalled				= false;
	String  attrForECOBasedSearch       = "";
	boolean showECOFieldOnSearch        = false;
	MCADMxUtil util						= null;

	MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData)session.getAttribute("MCADIntegrationSessionDataObject");
	
	if(integSessionData != null)
	{
		util				  = new MCADMxUtil(context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
		isECInstalled		  = util.isMatrixAppInstalled(context,"X-BOMEngineering");
		attrForECOBasedSearch = iefProperties.getString("mcadIntegration.ECOAttributeName");
	}

	if(isECInstalled && attrForECOBasedSearch !=null && !attrForECOBasedSearch.equals(""))
		showECOFieldOnSearch  = true;

    String txtName = (String)request.getParameter("txtName");
	if(txtName == null || txtName.equals(""))
		txtName ="*";

     String txtType = (String)request.getParameter("txtType");
	if(txtType == null || txtType.equals(""))
		txtType ="*";

	String txtRev = (String)request.getParameter("txtRev");
	if(txtRev == null || txtRev.equals(""))
		txtRev ="*";

	String state = (String)request.getParameter("state");
	if(state == null || state.equals(""))
		state ="*";

	String displayowner = (String)request.getParameter("displayowner");
	if(displayowner == null || displayowner.equals(""))
		displayowner ="*";

	String keywords = (String)request.getParameter("keywords");
	if(keywords == null || keywords.equals(""))
		keywords ="*";

	String txtVault = (String)request.getParameter("txtVault");
	if(txtVault == null || txtVault.equals(""))
		txtVault ="*";

	String WorkspaceFolder = (String)request.getParameter("WorkspaceFolder");
	if(WorkspaceFolder == null || WorkspaceFolder.equals(""))
		WorkspaceFolder ="*";

	String createdAfter = (String)request.getParameter("createdAfter");
	if(createdAfter == null || createdAfter.equals(""))
		createdAfter ="";
	else
		createdAfter = MCADUrlUtil.hexDecode(createdAfter);

	String createdBefore = (String)request.getParameter("createdBefore");
	if(createdBefore == null || createdBefore.equals(""))
		createdBefore ="";
	else
		createdBefore = MCADUrlUtil.hexDecode(createdBefore);

	String sLatestRevisionOnly	= (String)request.getParameter("latestRevisionOnly");
	String matchCase			= (String)request.getParameter("matchCase");
	String sQueryName			= (String)request.getParameter("queryName");
    String sReviseSearch		= emxGetParameter(request, "reviseSearch");
    
	if (sReviseSearch == null || sReviseSearch.equals("null")) sReviseSearch = "";
		sQueryName = "";

    if (sReviseSearch != null && sReviseSearch.equals("true"))
    {
		if (null != sTimeStamp && 0 != sTimeStamp.length())
		{
			sTimeStampPassed	= sTimeStamp;
			paramList			= (HashMap)session.getAttribute("ParameterList"+sTimeStampPassed);

			if (paramList != null)
			{
			   java.util.Set paramSet	= paramList.keySet();
			   Iterator paramIterator	= paramSet.iterator();
			   String skey				= "";
			   
				while(paramIterator.hasNext())
				{
					
				   skey = (String)paramIterator.next();
				   if (null == skey || 0 == skey.length()) continue;

				   if ("url".equals(skey) || "LCO".equals(skey) || "showAdvanced".equals(skey) || "GCO".equals(skey) || "GCOTable".equals(skey) || "localeObj".equals(skey)) continue;
				   
				   if (queryString.length() > 0) 
				   {
					   queryString.append("&");
				   }

				   String value = (String)paramList.get(skey);

				   if(skey.equals("header"))
				   {
					  value =  FrameworkUtil.decodeURL(value,"UTF-8");
				      queryString.append(skey);
				      queryString.append("=");
				      queryString.append(value);
				   }
				   else if(skey.equals("createdAfter"))
				   {
				      if(value != null && !value.equals("") && !value.equals("*"))
					   {
							value		 = MCADUrlUtil.hexDecode(value);
							createdAfter = value;
							queryString.append(skey);
							queryString.append("=");
							queryString.append(value);
					   }
				   }
				   else if(skey.equals("createdBefore"))
				   {
				      if(value != null && !value.equals("") && !value.equals("*"))
					   {
							value		  = MCADUrlUtil.hexDecode(value);
							createdBefore = value;
							queryString.append(skey);
							queryString.append("=");
							queryString.append(value);
					   }
				   }
				   else
				   {
						queryString.append(skey);
						queryString.append("=");
						queryString.append(getSearchEncodedParamValue(skey, value));
				   }
				}
			}
		}

		Enumeration eNumParameters = emxGetParameterNames(request);
		while( eNumParameters.hasMoreElements())
		{
			String strParamName		= (String)eNumParameters.nextElement();
			String strParamValue	= emxGetParameter(request, strParamName);
		
			//do not pass url on
			if(!"url".equals(strParamName) && !"showAdvanced".equals(strParamName)){ 
				if(queryString.length() > 0){
					queryString.append("{}");
				}
				queryString.append(strParamName);
				queryString.append("=");
				String value = strParamValue;
				queryString.append(getSearchEncodedParamValue(strParamName, value));
			}
		}
    }
	else 
	{   
	    String searchParameters = emxGetParameter(request, "searchParameters");
		if (searchParameters == null) searchParameters = "";
		StringTokenizer tk = new StringTokenizer(searchParameters, "{}");
		while (tk.hasMoreTokens())
		{
		   String token = tk.nextToken();
		   if (token == null) continue;
		   int pos = token.indexOf("=");
		   if (pos >= 0)
		   {
		      String paramName = token.substring(0, pos);
			  String paramValue = token.substring(pos+1, token.length());
			  paramList.put(paramName, paramValue);
			  String value = paramValue;
			  if (queryString.length() > 0)
			     queryString.append("&");
			  queryString.append(paramName);
			  queryString.append("=");
			  queryString.append(getSearchEncodedParamValue(paramName, value));
		   }
		}
	}
	sParameters = queryString.toString();
    sParameters = com.matrixone.apps.domain.util.XSSUtil.decodeFromURL(sParameters);
    
	if(sReviseSearch != null && sReviseSearch.equals("true"))
	{
		sLatestRevisionOnly = getParameter(paramList, request, "latestRevisionOnly");
		matchCase			= getParameter(paramList, request, "matchCase");
	}

	if (sLatestRevisionOnly == null || sLatestRevisionOnly.equals("null") || sLatestRevisionOnly.equals(""))
       sLatestRevisionOnly = "False";	
	
	String isRevisionChecked	= "";
	String isMatchChecked		= "";

	if (matchCase == null || matchCase.equals("null") || matchCase.equals(""))
	{
       if(sReviseSearch == null || sReviseSearch.equals("") || sReviseSearch.equalsIgnoreCase("false"))
		{
		   matchCase		= "True";
		   isMatchChecked	= "checked";
		}
		else
		{
		   matchCase = "False";
		}
	}
	
	if(sLatestRevisionOnly != null && sLatestRevisionOnly.equalsIgnoreCase("true"))
	{
		isRevisionChecked = "checked";
	}
	
	if( matchCase != null && matchCase.equalsIgnoreCase("true"))
	{
		isMatchChecked = "checked";
	}
	
	String integrationName	= emxGetParameter(request, "integrationName");
	if (integrationName == null || integrationName.equals(""))
	{
	   integrationName = getDefaultIntegrationName(request, integSessionData);
	}
%>
<script language="javascript" type="text/javascript" src="../common/scripts/emxUICalendar.js"></script>
<script language="JavaScript" src="../iefdesigncenter/emxInfoUIModal.js"></script> 
<script language="javascript" src="../iefdesigncenter/emxInfoCentralJavaScriptUtils.js"></script>
<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script> <%--Required by emxUIActionbar.js below--%>
<script language="JavaScript" src="../common/scripts/emxUIActionbar.js" type="text/javascript"></script> <%--To show javascript error messages--%>
<script language="JavaScript" src="../common/scripts/emxJSValidationUtil.js" type="text/javascript"></script> <%--To show javascript error messages--%>
<script language="JavaScript" src="../iefdesigncenter/emxInfoUISearch.js" type="text/javascript"></script> <%--To show javascript error messages--%>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>

<script language="Javascript">
    //XSSOK
	var STR_SEARCH_RESAVE_FORM_DATA = "<%= STR_SEARCH_RESAVE_FORM_DATA %>";
			//Function to show vault chooser
	function showVaultSelector() 
	{
		var strFeatures = "width=300,height=350,screenX=238,left=238,screenY=135,top=135,resizable=no,scrollbars=auto";
		txt_Vault = eval(strTxtVault);
		var url = "../iefdesigncenter/emxSelectVaultDialog.jsp";
		//var win = window.open(url, "", strFeatures);
		showModalDialog(url, 300, 350, true);
	}

        function doFindLike()
	{
	   doSearch(true);
	}

	function doGlobalSelect(objectId,
							fullPath,
							applyToChild )
	{
	   document.ContentFindFile.workspaceFolderId.value = objectId;
	   document.ContentFindFile.WorkspaceFolder.value = fullPath;
	}

	function showTypeSelector (varType, varTopLevel, frmName, varName, multisel)
	{
		 var strFeatures = "width=450,height=350,resizable=yes";
		 if(multisel == "true")
			 multisel = "multiselect";
		 else
			 multisel = "singleselect";
		 var strURL="../common/emxTypeChooser.jsp?fieldNameActual="+varName+"&fieldNameDisplay=selType&formName="+frmName+"&ShowIcons=true&ObserveHidden=false&SelectType="+multisel+"&SelectAbstractTypes=true";
		 //var strURL="./emxTypeChooser.jsp?fieldNameActual="+varName+"&fieldNameDisplay=selType&formName="+frmName+"&ShowIcons=true&ObserveHidden=false&SelectType="+multisel+"&SelectAbstractTypes=true";
		 if(varType != "*")
			strURL = strURL + "&InclusionList=" + varType;
		  var win = window.open(strURL, "", strFeatures);
	}

	function doSearch(reSubmit)
	{

	    var strQueryLimit = parent.frames['searchFoot'].document.bottomCommonForm.QueryLimit.value;
		document.ContentFindFile.queryLimit.value = strQueryLimit;

		var badCharArr = new Array("'","\"","#");
		var badCharExists = badCharExistInForm(document.ContentFindFile, badCharArr);
		if (badCharExists)
		{
			alert("<%=i18nNow.getI18nString("emxIEFDesignCenter.Common.SpecialCharacters", "emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"))%>");
			return false;
		}
		//XSSOK
        if('<%=showECOFieldOnSearch%>' == 'true')
		{
			document.ContentFindFile.txtECO.value = trimWhitespace(document.ContentFindFile.txtECO.value);
			//XSSOK
			if('<%=allowWildCardsInECOSearch%>' == "false")
			{
				if (charExists(document.ContentFindFile.txtECO.value, '*') || charExists(document.ContentFindFile.txtECO.value, '?'))
				{
					<%String sErrMsg = i18nNow.getI18nString("emxIEFDesignCenter.Common.ECOSearch-SpecialCharacters", "emxIEFDesignCenterStringResource", request.getHeader("Accept-Language")); %>
					alert('<%=sErrMsg%>');
					document.ContentFindFile.txtECO.focus();
					return false;
				}
			}
		}
         
		var table = 'DSCDefault';
		
		//XSSOK
		if("<%=showECOFieldOnSearch%>" == 'true' && document.ContentFindFile.txtECO.value != '')
			table = 'DSCECOSearch';

		var url = 'DSCSearchSummaryTable.jsp?program=DSCAdvancedFind:getList&';
		url += 'table='+ table;
		url += '&topActionbar=DSCDefaultTopActionBar';
		parent.frames["searchFoot"].isAbruptClose = false;
		document.ContentFindFile.target='_parent';
		
		for (var i=0; i < document.ContentFindFile.chkAppendReplace.length; i++)
		{
			if (document.ContentFindFile.chkAppendReplace[i].checked)
			{
				var rad_val = document.ContentFindFile.chkAppendReplace[i].value;
				if(rad_val == "append")
				{
					 document.ContentFindFile.appendCheckFlag.value = "true";
				}
				else
				{
					 document.ContentFindFile.appendCheckFlag.value = "false";
				}
			}
		}
		//document.ContentFindFile.action='DSCSearchSummaryTable.jsp?program=DSCAdvancedFind:getList&table=DSCDefault&findType=AdvancedFind'; +'&timeStamp=' + '<%=sTimeStampPassed%>';;
		document.ContentFindFile.action='emxInfoTable.jsp?program=DSCAdvancedFind:getList&table=' + table + '&findType=AdvancedFind&timeStampAdvancedSearch=<%=XSSUtil.encodeForURL(context,sTimeStamp)%>';

		//XSSOK
		var integName			= "<%= integrationName%>";
		var tempCreatedBefore	= document.ContentFindFile.createdBefore.value;
		var tempCreatedAfter	= document.ContentFindFile.createdAfter.value;

		if(tempCreatedBefore != null && tempCreatedBefore != "" && tempCreatedBefore != "*")
		{
			document.ContentFindFile.createdBefore.value = hexEncode(integName, tempCreatedBefore);
		}
		if(tempCreatedAfter != null && tempCreatedAfter != "" && tempCreatedAfter != "*")
		{
			document.ContentFindFile.createdAfter.value = hexEncode(integName, tempCreatedAfter);
		}

		if(reSubmit == true)
			document.ContentFindFile.submit();

		if(tempCreatedBefore != null && tempCreatedBefore != "" && tempCreatedBefore != "*")
		{
			document.ContentFindFile.createdBefore.value = tempCreatedBefore;
		}
		if(tempCreatedAfter != null && tempCreatedAfter != "" && tempCreatedAfter != "*")
		{
			document.ContentFindFile.createdAfter.value = tempCreatedAfter;
		}

		return true;
	}

	//specify the place to return the string AS A STRING...this cannot be an actual object reference or it will cause an error

	//define the variables required for showing the type chooser
	var strTxtType = "document.forms['ContentFindFile'].selType";
	var txtType = null;

	var strTxtTypeDisp = "document.forms['ContentFindFile'].txtType";
	//var txtTypeDisp = null;

	//can abstracts be selected?
	var bAbstractSelect = true;
	var bMultiSelect = true;
	//define variables required for showing vault chooser
	var bVaultMultiSelect = true;
	var strTxtVault = "document.forms['ContentFindFile'].txtVault";
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
<script language="javascript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="javascript">
  function doSearch1() {
    // File Name can not have special characters
    var apostrophePosition  = document.ContentFindFile.name.value.indexOf("'");
    var DoublecodesPosition = document.ContentFindFile.name.value.indexOf("\"");
    var hashPosition        = document.ContentFindFile.name.value.indexOf("#");
    var dollarPosition      = document.ContentFindFile.name.value.indexOf("$");
    var atPosition          = document.ContentFindFile.name.value.indexOf("@");
    var andPosition         = document.ContentFindFile.name.value.indexOf("&");
    var percentPosition     = document.ContentFindFile.name.value.indexOf("%");

    var dateObject = new Date();
    currentTimeZoneOffsetInHours = dateObject.getTimezoneOffset()/60;
    document.ContentFindFile.timeZone.value = currentTimeZoneOffsetInHours;

    if( DoublecodesPosition != -1 || apostrophePosition != -1 || hashPosition != -1 || dollarPosition != -1 || atPosition != -1 || andPosition != -1  || percentPosition != -1) {
      alert ("<emxUtil:i18nScript localize="i18nId">emxTeamCentral.Common.AlertValidName</emxUtil:i18nScript>");
      document.ContentFindFile.name.focus();
    } else {
      startSearchProgressBar();  //kf
      document.ContentFindFile.submit();
    }
    return;
  }

  function closeWindow() {
    parent.window.close();
    return;
  }



  function selectVal(val) {

    if(val == "owner") 
	{
		showModalDialog('../teamcentral/emxTeamRouteWizardSelectPeopleDialogFS.jsp?callPage=Search',775,475);
		return;
    }
	else
	{
		var folderSearchURL = '../integrations/MCADFolderSearchDialogFS.jsp?formName=ContentFindFile&callPage=Search&showWorkspace=true&showApplyToChildren=false&showCollection=false';
		showTreeDialog(folderSearchURL);

		return;
    }
  }
 

function resetFormFields()
{
        pageControl = top.pageControl;
        pageControl.setShowErrMsg(false);
        rebuildForm();
		if  (document.forms[0].latestRevisionOnly.checked)
		{
		   document.forms[0].txtRev.disabled = true;
		   document.forms[0].txtRev.value = '*';
		}
		else
		{
		   document.forms[0].txtRev.disabled = false;
		}
}

function saveSearch(savedSearchName)
{
	   var appendParam = "true";
	   if(document.ContentFindFile.chkAppendReplace[0].checked)
		   appendParam = "false";

	   document.ContentFindFile.appendCheckFlag.value = appendParam;
       pageControl = top.pageControl;
       pageControl.setSavedSearchName(encodeURIIfCharacterEncodingUTF8(encodeSaveSearchName(savedSearchName)));
       var contentURL = parent.frames[1].location.href;
       var paramArray = contentURL.split('?');
       contentURL = '../iefdesigncenter/DSCSearchContentDialog.jsp?' + paramArray[1];
       pageControl.setSearchContentURL(encodeURIIfCharacterEncodingUTF8(contentURL));
       //build xml doc from formfields
       var xmlData = buildXMLfromForm();
       var url = "../iefdesigncenter/DSCSearchSaveProcessor.jsp";
       url += "?saveType=" + 'save';
		
       url += "&saveName=" + encodeURIIfCharacterEncodingUTF8(encodeSaveSearchName(savedSearchName));
	
       var oXMLHTTP = emxUICore.createHttpRequest();
       oXMLHTTP.open("post", url, false);
       oXMLHTTP.send(xmlData);
}

function loadFormFields()
{
	var params = document.ContentFindFile.reviseSearchParameters.value;
	document.ContentFindFile.reviseSearchParameters.value = '';
    pageControl = top.pageControl;
    turnOffProgress();

	if (null != params && 'undefined' != params && '' != params)
	{
        var paramArray = params.split('&');

        // stores the name/value pairs into the pageControl cache
        if (null != paramArray)
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

					if ((paramName == 'txtName') || (paramName == 'txtType') || (paramName == 'txtRev') || (paramName == 'displayowner') || (paramName == 'keywords') || (paramName == 'txtVault') || (paramName == 'WorkspaceFolder') ||(paramName.indexOf('txtWhere') >= 0))
					{
					    //XSSOK
						paramValue = hexDecode('<%=integrationName%>',paramValue);
					}

					top.pageControl.addToArrFormVals(new Array(paramName, paramValue, true, false));
				}
			}
		}
	}  
	
	//XSSOK
	if ("<%=sQueryName%>" != '')
	{
	    //XSSOK
	    top.pageControl.setSavedSearchName(encodeURIIfCharacterEncodingUTF8(encodeSaveSearchName("<%=sQueryName%>")));
	    top.importSavedSearchXML();
	}

	// waits for the Search dialog is completed loaded and then reset the form fields
	setTimeout("resetFormFields()", 1000);
	parent.frames['searchFoot'].document.bottomCommonForm.QueryLimit.disabled = false;
} 

function onSelectLatestRevision(checked)
{
   
   if(checked != null && checked != 'undefined' 
      && checked)
   {
      document.forms[0].txtRev.value = '*';
	  document.forms[0].txtRev.disabled = true;
	  document.forms[0].latestRevisionOnly.value = 'True';
   }
   else
   {
      document.forms[0].txtRev.disabled = false;
	  document.forms[0].latestRevisionOnly.value = 'False';
   }
}

function onSelectMatchCase(checked)
{
   if(checked != null && checked != 'undefined' && checked)
   {
      document.forms[0].matchCase.value = "True";
   }
   else
   {
      document.forms[0].matchCase.value = "False";
   }
}

function clearAll(fieldName) 
{
    if(fieldName =='createdAfter' ) 
	{
      document.ContentFindFile.createdAfter.value = "";      
    } 
	else if(fieldName =='createdBefore') 
	{
      document.ContentFindFile.createdBefore.value = "";      
    }
    return;
}

window.onload=loadFormFields;
</script>
<%
 /* IEF additions Start 
	Reasons: 
	1. To see whether integration is active.
	2. Add code to show a field called InstanceName.
  	*/

	Context _context							= integSessionData.getClonedContext(session);
	String instanceNameLable			= null;
	Vector iefFamilyTypes				= null;	

	if(integSessionData != null)
	{
		iefFamilyTypes		= integSessionData.getValidFamilyTypes(_context);
		instanceNameLable	= integSessionData.getStringResource("mcadIntegration.Server.FieldName.InstanceName");
	}
	
	Locale locale = (Locale)request.getLocale();
	/* IEF additions End */
    String languageStr = request.getHeader("Accept-Language");
    String strTypeList = "";
    String integrationsTypeList = "";
    String sKeyPress = "";// " onkeypress=\"javascript:if((event.keyCode == 13) || (event.keyCode == 10) || (event.which == 13) || (event.which == 10)) doSearch()\"";
    try
    {
	  // For append replace time stamp 
	  sTimeStampPassed = emxGetParameter(request, "timeStamp");
          //  String suiteKey = emxGetParameter(request, "suiteKey");

   	  strTypeList = "type_CADDrawing,type_CADModel";
	  if(integSessionData != null) 
	  {
		strTypeList = integSessionData.getTypesForTypeChooser(_context);
	  }
	  
      // DSCINC 1200
	  Query dotFinderQuery = new Query(".iefdesigncenterFinder");

	  dotFinderQuery.open(_context);
	  integrationsTypeList = dotFinderQuery.getBusinessObjectType();
	  dotFinderQuery.close(_context);

      if(integrationsTypeList.equals("") || integrationsTypeList.equals("*") || integrationsTypeList == null)
	  {
		integrationsTypeList = "";
	      StringTokenizer typeTokens	= new StringTokenizer(strTypeList, ",");
	      while (typeTokens.hasMoreTokens())
          {
			String strType = typeTokens.nextToken().trim();
            strType = strType.trim();         
		    if (strType != null && strType.length()>0 && strType.equals("*") == false)
            {
				String realName	= PropertyUtil.getSchemaProperty( _context, strType);

				if(integrationsTypeList.equals(""))
					integrationsTypeList = realName;
				else
					integrationsTypeList = integrationsTypeList + "," + realName;
		    }
	      }
        }
    }
    catch (Exception e)
    {
       System.out.println(e.toString());
    }

    stateTable = getTypeStates(context, strTypeList);
	if(!stateTable.containsKey("*"))
		stateTable.put("*","");
%>

<!-- IEF additions Start -->
<script language="Javascript">
	var iefFamilyTypes = new Array();
<%
	if(integSessionData != null && iefFamilyTypes != null && iefFamilyTypes.size() > 0)
	{
		for(int i=0; i < iefFamilyTypes.size(); i++)
		{
			String iefFamilyType = (String)iefFamilyTypes.elementAt(i);
%>
	iefFamilyTypes['<%= iefFamilyType %>'] = true;
<%
		}
	}
%>
</script>
<!-- IEF additions End -->
<%@include file = "../emxUICommonHeaderEndInclude.inc" %>

<!--<form name="ContentFindFile" id="ContentFindFile" method="post" onSubmit="doSearch()" target="_parent" action="../iefdesigncenter/emxInfoSearchSummaryTable.jsp">-->
<form name="ContentFindFile" id="ContentFindFile" method="post" onSubmit="return doSearch(false)" target="_parent"  action="../iefdesigncenter/emxInfoSearchSummaryTable.jsp">



<table border="0" cellpadding="5" cellspacing="2" width="100%">
  <tr>
    <td class="label"><%=i18nNow.getBasicI18NString("Type",  languageStr)%></td>
    <td class="inputField">
       <input type=text value="<%=integrationsTypeList%>" size="16" name="txtType" readonly="readonly" <%=sKeyPress%>>
       <input type=button name="selType" value="..." onClick="showTypeSelector('<%=strTypeList%>','true', 'ContentFindFile', 'txtType', 'true')";>
    </td>
  </tr>
  <tr>
    <td width="150" class="label"><emxUtil:i18n localize="i18nId">emxTeamCentral.FindFiles.Name</emxUtil:i18n></td>
    <td class="inputField">
      <input type="text" name="txtName" id="name" value="<%=txtName%>">&nbsp;&nbsp;<input type="checkbox" name="matchCase" value="<%=matchCase%>" id="matchCase" onClick="onSelectMatchCase(document.forms[0].matchCase.checked); return true;" <%=isMatchChecked%>>&nbsp;<emxUtil:i18n localize="i18nId">emxTeamCentral.FindFiles.MatchCase</emxUtil:i18n>
    </td>
  </tr>
  <tr>
    <td class="label"><%=i18nNow.getBasicI18NString("Revision",  languageStr)%></td>
    <td class="inputField"><input type="text" name="txtRev" size="16" value="<%=txtRev%>" <%=sKeyPress%>>&nbsp;&nbsp;<input type="checkbox" name="latestRevisionOnly" value="<%=sLatestRevisionOnly%>" id="latestRevisionOnly" onClick="onSelectLatestRevision(document.forms[0].latestRevisionOnly.checked); return true;" <%=isRevisionChecked%>>&nbsp;<%=i18nNow.getI18nString("emxIEFDesignCenter.Common.LatestRevOnly", "emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"))%></td>
  </tr>
  <tr>
  <td width="150" class="label"><%=i18nNow.getI18nString("emxIEFDesignCenter.Common.State", "emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"))%></td>
    <td class="inputField">
    <select name="state" id="state">
      <option selected value="<%=state%>"><%=state%></option>
<%
    Iterator itr = stateTable.keySet().iterator();
    String strState = "";
	while(itr.hasNext())
    {
        strState = (String)itr.next();
		if(!strState.equals(state))
		{
%>
             <option value= "<%=strState%>"><%=strState%></option>
<%
		}
    }      
%>    
    </select>
    </td>
  </tr>
  <tr>
    <td width="150" class="label"><emxUtil:i18n localize="i18nId">emxTeamCentral.FindFiles.Owner</emxUtil:i18n></td>
    <td class="inputField"><input type="text" name="displayowner" id="displayowner" value="<%=displayowner%>"><input type="button" value="..." name="btn" id="btn" onclick=selectVal("owner")>&nbsp;</td>
    <input type="hidden" name="owner" id="owner" >
  </tr>
<%
    //get property for turning on the keyword search
    String keywordSearch = FrameworkProperties.getProperty(context,"emxTeamCentral.KeywordSearch");
    if("ON".equalsIgnoreCase(keywordSearch))
    {
%>
      <tr>
        <td width="150" class="label"><emxUtil:i18n localize="i18nId">emxTeamCentral.FindFiles.Keywords</emxUtil:i18n></td>
        <td class="inputField"><input type="text" name="keywords" id="keywords" value="<%=keywords%>"></td>
      </tr>
<%
    }
%>
  <tr>
    <td class="label"><%=i18nNow.getBasicI18NString("Vault",  languageStr)%></td>
    <td class="inputField">
       <input type=text value="<%=txtVault%>" size="16" name="txtVault" <%=sKeyPress%>>
      <input type=button value="..." onClick=showVaultSelector()>
    </td>
  </tr> 
  <tr>
    <td width="150" class="label"><emxUtil:i18n localize="i18nId">emxTeamCentral.FindFiles.WorkspaceFolder</emxUtil:i18n></td>
    <td class="inputField">
    <input type="text"  value="<%=WorkspaceFolder%>" name="WorkspaceFolder" id="WorkspaceFolder">
    <input type="button" name="butClear" id="" value="..." onclick=selectVal("folder")>&nbsp;</td>
    <input type=hidden name=workspaceFolderId value="">
  </tr>
<%
	if(showECOFieldOnSearch)
	{
%>
  <tr>
	<td class="label"><%=i18nNow.getBasicI18NString("ECO",  languageStr)%></td>
	<% String sECO = ""; %>
	<td class="inputField"><input type="text" name="txtECO" size="16" value="<%=sECO%>" ></td>
  </tr>
<%
	}
%>
  <tr>
    <td width="150" class="label"><emxUtil:i18n localize="i18nId">emxTeamCentral.FindFiles.CreatedAfter</emxUtil:i18n></td>
    <td class="inputField">
      <input type="text" readonly="readonly"  size="20" value="<%=createdAfter%>" name="createdAfter" id="createdAfter">
      <img src="images/utilSpace.gif" width="1" height="1" border="0">
      &nbsp;&nbsp;
      <a href="javascript:showCalendar('ContentFindFile','createdAfter',document.ContentFindFile.createdAfter.value)" >
      <img src="../common/images/iconSmallCalendar.gif" border="0" align="absmiddle" alt=""></a>
	  <a href="javascript:clearAll('createdAfter')"><emxUtil:i18n	  localize="i18nId">emxTeamCentral.common.Clear</emxUtil:i18n></a>
    </td>
  </tr>
  <tr>
    <td width="150" class="label"><emxUtil:i18n localize="i18nId">emxTeamCentral.FindFiles.CreatedBefore</emxUtil:i18n></td>
    <td class="inputField"><input type="text" readonly="readonly"  size="20" value="<%=createdBefore%>" name="createdBefore" id="createdBefore" >
      <img src="images/utilSpace.gif" width="1" height="1" border="0">
      &nbsp;&nbsp;
      <a href="javascript:showCalendar('ContentFindFile','createdBefore',document.ContentFindFile.createdBefore.value)" >
      <img src="../common/images/iconSmallCalendar.gif" border="0" align="absmiddle" alt=""></a>
	  <a href="javascript:clearAll('createdBefore')"><emxUtil:i18n	  localize="i18nId">emxTeamCentral.common.Clear</emxUtil:i18n></a>
    </td>
  </tr>
 </table>
 <table>
   <tr>
    <td ><input type="radio" name="chkAppendReplace" value="replace" checked ></td>
    <td ><%=i18nNow.getI18nString("emxIEFDesignCenter.Search.ReplaceObjects", "emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"))%></td>
    <td ><input type="radio" name="chkAppendReplace" value="append" ></td>
    <td ><%=i18nNow.getI18nString("emxIEFDesignCenter.Search.AppendObjects", "emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"))%></td>
   </tr> 
  </table>
    <input type=hidden name="findType" value="AdvancedFind">
    <input type=hidden name="table" value="TMCFilesSearchResult">
    <input type=hidden name="Style" value="dialog">
    <input type=hidden name="program" value="DSCAdvancedFind:getList">
    <input type=hidden name="toolbar" value="AEFSearchResultToolbar">
    <input type=hidden name="header" value="emxIEFDesignCenter.ObjectSearchResults.SearchResults">
    <input type=hidden name="selection" value="multiple">
    <input type=hidden name="queryLimit" value="100">
    <input type=hidden name="pagination" value="10">
    <input type=hidden name="listMode" value="search">
    <input type=hidden name="CancelButton" value="true">
    <input type=hidden name="CancelLabel" value="emxTeamCentral.Button.Close">
    <input type=hidden name="HelpMarker" value="emxhelpsearchresults">
    <input type=hidden name="timeZone" value="">
    <input type=hidden name="StringResourceFileId" value="emxTeamCentralStringResource">
    <input type=hidden name="suiteKey" value="DesignerCentral">
    <input type=hidden name="SuiteDirectory" value="iefdesigncenter">
    <input type=hidden name="Target Location" value="content">
    <input type=hidden name="selType" value="">
    <input type=hidden name="locale" value="<%=locale.toString()%>">
    <input type=hidden name="searchID" value="__DesignerCentral__">
    <input type=hidden name="queryName" value="<%=sQueryName%>">

	<input type=hidden name="integrationName" value="<%=integrationName%>">
<% 
	String sErrorMsg = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Error.SearchFailed",request.getHeader("Accept-Language"));
   //sErrorMsg = URLEncoder.encode(sErrorMsg);
%>
<input type=hidden name="topActionbar" value="DSCSearchResultTopActionBar">
<input type=hidden name="pagination" value="10">
<input type=hidden name="selection" value="multiple">
<input type=hidden name="headerRepeat" value="10">
<input type=hidden name="targetLocation" value="popup">
<input type=hidden name="sortColumnName" value="name">
<input type=hidden name="Sortdirection" value="ascending">
<input type=hidden name="table" value="DSCDefault">
<input type=hidden name="errorMessage" value="<%=sErrorMsg%>">
<input type=hidden name="expandCheckFlag" value="true">
<input type=hidden name="appendCheckFlag" value="false">
<input type=hidden name="reviseSearchParameters" value="<%=sParameters%>">
<%  
    if (null != sTimeStampPassed) {%>
    <input type=hidden name="timeStamp" value="<%=sTimeStampPassed%>">
    <input type=hidden name="timeStampAdvancedSearch" value="<%=sTimeStampPassed%>">
<%  
    } %>
    <input type="image" height="1" width="1" border="0" />
</form>

<%
  //find like params
  String objectSymbolicName = "type_Document";
  String objectI18NString = "emxTeamCentral.FindLike.Common.Document";
  String objectIcon = "iconSmallDocument.gif";

  String sLinkname		= emxGetParameter(request,"page");
  String sSearchType    = emxGetParameter(request,"searchType");

  if(sLinkname == null){
	sLinkname = "";
  } 
  if(sSearchType == null){
	sSearchType = "";
  }  
 
%>
<form name="ExpandFindLikeForm" id="ExpandFindLikeForm" method="post" action="../iefdesigncenter/DSCFindLikeDialog.jsp">

<%
boolean csrfEnabled1 = ENOCsrfGuard.isCSRFEnabled(context);
if(csrfEnabled1)
{
  Map csrfTokenMap1 = ENOCsrfGuard.getCSRFTokenMap(context, session);
  String csrfTokenName1 = (String)csrfTokenMap1.get(ENOCsrfGuard.CSRF_TOKEN_NAME);
  String csrfTokenValue1 = (String)csrfTokenMap1.get(csrfTokenName1);
%>
  <input type="hidden" name= "<%=ENOCsrfGuard.CSRF_TOKEN_NAME%>" value="<%=csrfTokenName1%>" />
  <input type="hidden" name= "<%=csrfTokenName1%>" value="<%=csrfTokenValue1%>" />
<%
}
//System.out.println("CSRFINJECTION::DSCSearchContentDialog.jsp::form::ExpandFindLikeForm");
%>

<input type=hidden name="txtName" value="">
<input type=hidden name="txtType" value="">
<input type=hidden name="txtRev" value="">
<input type=hidden name="state" value="">
<input type=hidden name="displayowner" value="">
<input type=hidden name="keywords" value="">
<input type=hidden name="txtVault" value="">
<input type=hidden name="WorkspaceFolder" value="">
<input type=hidden name="createdAfter" value="">
<input type=hidden name="createdBefore" value="">
<input type=hidden name="returnSearchFrameset" value="">
<input type=hidden name="latestRevisionOnly" value="">
<input type=hidden name="matchCase" value="">


<input type=hidden name="ComboType" value="<%=objectSymbolicName%>">
<input type=hidden name="typeString" value="<%=objectI18NString%>">
<input type=hidden name="objectIcon" value="<%=objectIcon%>">
<input type=hidden name="searchType" value="<%=sSearchType%>">
<input type=hidden name="page" value="<%=sLinkname%>">

</form>
<script language="Javascript" >
  function goToFindLike(){

    var loc = top.location.href;

	document.forms['ExpandFindLikeForm'].txtName.value				= document.forms['ContentFindFile'].txtName.value;	
	document.forms['ExpandFindLikeForm'].txtType.value				= document.forms['ContentFindFile'].txtType.value;
	document.forms['ExpandFindLikeForm'].txtRev.value				= document.forms['ContentFindFile'].txtRev.value;
	document.forms['ExpandFindLikeForm'].state.value				= document.forms['ContentFindFile'].state.value;
	document.forms['ExpandFindLikeForm'].displayowner.value		    = document.forms['ContentFindFile'].displayowner.value;
	document.forms['ExpandFindLikeForm'].keywords.value				= document.forms['ContentFindFile'].keywords.value;
	document.forms['ExpandFindLikeForm'].txtVault.value				= document.forms['ContentFindFile'].txtVault.value;
	document.forms['ExpandFindLikeForm'].WorkspaceFolder.value		= document.forms['ContentFindFile'].WorkspaceFolder.value;
	document.forms['ExpandFindLikeForm'].latestRevisionOnly.value	= document.forms['ContentFindFile'].latestRevisionOnly.value;
	document.forms['ExpandFindLikeForm'].matchCase.value			= document.forms['ContentFindFile'].matchCase.value;
	document.forms['ExpandFindLikeForm'].returnSearchFrameset.value = escape(loc);

	var integName = "<%= integrationName%>";
	var tempCreatedBefore	= document.ContentFindFile.createdBefore.value;
	var tempCreatedAfter	= document.ContentFindFile.createdAfter.value;
	if(tempCreatedBefore != null && tempCreatedBefore != "" && tempCreatedBefore != "*")
	{
		document.ExpandFindLikeForm.createdBefore.value = hexEncode(integName, tempCreatedBefore);
	}
	if(tempCreatedAfter != null && tempCreatedAfter != "" && tempCreatedAfter != "*")
	{
		document.ExpandFindLikeForm.createdAfter.value = hexEncode(integName, tempCreatedAfter);
	}

	document.ExpandFindLikeForm.submit();	
  }

</script>
&nbsp;<a href="javascript:goToFindLike()" ><img src="../common/images/utilSearchPlus.gif" border="0" align="absmiddle" ></a>&nbsp;<a href="javascript:goToFindLike()" ><%=i18nNow.getI18nString("emxTeamCentralStringResource","emxTeamCentral.FindLike.More",request.getHeader("Accept-Language"))%></a>&nbsp;
<%@include file = "../emxUICommonEndOfPageInclude.inc" %>
