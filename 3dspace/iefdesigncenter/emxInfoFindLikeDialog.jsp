<%--  emxInfoFindLikeDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoFindLikeDialog.jsp $
--%>

<%--
 *
 * $History: emxInfoFindLikeDialog.jsp $
 * $History: emxInfoAdvancedSearchDialog.jsp $
 ******************  Version 48  *****************
 * User: Rajesh G  Date: 18/12/03    Time: 3:39p
 * Updated in $/InfoCentral/src/infocentral
 * To enable the esc key and key board support
 * 
 * *****************  Version 46  *****************
 * User: Rahulp       Date: 28/01/03   Time: 17:23
 * Updated in $/InfoCentral/src/infocentral
 * 
 * ************************************************
 --%>

<%@ page import="com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.beans.*"  %>


<%@include file="emxInfoCentralUtils.inc"%>
<%@ include file  = "../emxJSValidation.inc"%>
<%@include file="../emxUICommonHeaderBeginInclude.inc" %>
<%@ page import="com.matrixone.apps.domain.util.FrameworkUtil, java.net.*"  %>



<%@include file = "../emxUICommonHeaderEndInclude.inc" %>
<script language="JavaScript" src="emxInfoUIModal.js"></script> 
<script language="javascript" src="../common/scripts/emxJSValidationUtil.js"></script>

<%@include file = "../common/emxUIConstantsInclude.inc"%>
<script language="javascript" type="text/javascript" src="../common/scripts/emxUICalendar.js"></script>

<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script> <%--Required by emxUIActionbar.js below--%>
<script language="JavaScript" src="../common/scripts/emxUIActionbar.js" type="text/javascript"></script> <%--To show javascript error messages--%>

<script language="javascript" src="emxInfoCentralJavaScriptUtils.js"></script>
<script language="JavaScript" src="../iefdesigncenter/emxInfoUISearch.js"></script>
<script language="javascript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
<%@ page import="com.matrixone.apps.domain.util.FrameworkUtil, java.net.*"  %>
<%@include file		= "DSCSearchUtils.inc"%>
<%
	String sParameters			= "";
	HashMap paramList           = new HashMap();
	StringBuffer queryString	= new StringBuffer("");
	String sQueryName = "";
	String sReviseSearch = emxGetParameter(request, "reviseSearch");
	String sWorkspaceFolder = "";
	String sWorkspaceFolderId = "";
	String sTimeStampPassed = "";
    sTimeStampPassed = emxGetParameter(request, "timeStamp");
	if (sReviseSearch == null || sReviseSearch.equals("null")) sReviseSearch = "";
	
	try 
	{
		sQueryName = (String)request.getParameter("queryName");
    
	    sQueryName = "";
	   
	    // Process Revise Search	
	    if (sReviseSearch != null && sReviseSearch.equals("true"))
	    {
		   if (sTimeStampPassed == null) sTimeStampPassed = "";
	 
           if (null != sTimeStampPassed && 0 != sTimeStampPassed.length())
		   {
			  paramList = (HashMap)session.getAttribute("ParameterList"+sTimeStampPassed);
	
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
					   queryString.append("&");
				   }
				  
				   queryString.append(skey);
				   queryString.append("=");
				   String value = (String)paramList.get(skey);
				   //queryString.append(value);
				   queryString.append(getSearchEncodedParamValue(skey, value));
				}
				sWorkspaceFolder = (String)paramList.get("WorkspaceFolder");
				sWorkspaceFolderId = (String)paramList.get("workspaceFolderId");
				if (sWorkspaceFolder == null || sWorkspaceFolder.equals("*")) sWorkspaceFolder = "";
		if (sWorkspaceFolderId == null) sWorkspaceFolderId = "";
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
			      if (queryString.length() > 0) {
				     queryString.append("&");
			      }
			      queryString.append(paramName);
			      queryString.append("=");
			      String value = paramValue;
				      //queryString.append(value);
					  queryString.append(getSearchEncodedParamValue(paramName, value));
		          }
		   }
	   }
	   String sLatestRevisionOnly = getParameter(paramList, request, "latestRevisionOnly");
	   if (sLatestRevisionOnly == null || sLatestRevisionOnly.equals("null"))
          sLatestRevisionOnly = "False";
	   // 17/12/2003        start   nagesh  
    	String sBackPage = getParameter(paramList,request, "backPage");
		String sNewPage = getParameter(paramList,request, "newPage");
				
		HashMap localHashMap = (HashMap)session.getAttribute("ParameterBackButton");
		
		String txtBusType="";

		if(null == sNewPage || "null".equalsIgnoreCase(sNewPage) || sNewPage.length() == 0)
		{
			localHashMap = (HashMap)session.getAttribute("ParameterBackButton");
		}

		if (localHashMap == null)
		    localHashMap = new HashMap();
        
		session.removeValue("ParameterBackButton");
		// 18/12/2003        End    nagesh

		// Added on 15/1/2004 for issue id 56124
		session.setAttribute("ReviseSearch","true");
		//End of add on 15/1/2004

		String estimatedCost = Framework.getPropertyValue (session, "attribute_EstimatedCost");
		String languageStr = request.getHeader("Accept-Language");
		String appDirectory = (String)application.getAttribute("eServiceSuiteIEFDesignCenter.Directory");

		// For append replace time stamp 
		
		// get the current suite properties.
		String sTypeValues = "";
		String sShowHidden = "FALSE";
		String sShowHiddenAttr = "FALSE";

		//To get the Business Type for search
		String sBizType = getParameter(paramList,request, "ComboType");
		String sBizDisplayType = getParameter(paramList,request, "ComboDisplayType");
        String sTextBusType = getParameter(paramList, request, "txtBusType");
		if (sBizType == null || sBizType.equals("")) 
		{
		   sBizType = sTextBusType;
		   sBizDisplayType = sTextBusType;
		}

		// 17/12/2003        start    nagesh 
		// Store the value in the  Business type, coming from the back page
		if(localHashMap != null && (localHashMap.size() > 0)) 
	    {
			String sTxtBusType =(String)localHashMap.get("txtBusType");
			if (sTxtBusType != null && sTxtBusType.length() > 0)
			{
				sBizType = sTxtBusType;
			}
		}
	    // 01/10/2003        End    nagesh 
    	String sTypeVal            = "";
		String sTruncVal           = "";
		int iCount = 0;
		BusinessTypeItr btItrObj = null;
		StringList sListType = new StringList();

		//If the TypeNames property value is not set then get all the business types
		if(sTypeValues == null || sTypeValues.trim().equals("")) 
		{
			// Set the show hidden types flag value from the properties.
			boolean bShowHiddenTypes = false;
			if(sShowHidden != null) {
				if(sShowHidden.equals("TRUE")) 
				{
					bShowHiddenTypes = true;
				}
			}
			//To get the business type list from the context
			BusinessTypeList btListObj = BusinessType.getBusinessTypes(context, bShowHiddenTypes);
			// To sort the business type in alphabetical order
			btListObj.sort();
			btItrObj   = new BusinessTypeItr(btListObj);
		}

		String headerString = "emxIEFDesignCenter.Header.SearchResults";

        /* IEF additions Start 
		Reasons: 
		1. To see whether integration is active.
		2. To add code to show Instance related attributes.
		*/

		MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
		Vector iefInstanceAttributeNames	= null;
		String instanceAttributesHeading	= null;
		if(integSessionData != null && sBizType != null)
		{
			iefInstanceAttributeNames = integSessionData.getMappedInstanceAttibutesForFamilyType(integSessionData.getClonedContext(session), sBizType);
			instanceAttributesHeading = integSessionData.getStringResourceWithHtmlSpaces("mcadIntegration.Server.Heading.InstanceRelatedAttributes");
		}	
	sParameters = queryString.toString();
	sParameters = com.matrixone.apps.domain.util.XSSUtil.decodeFromURL(sParameters);
	String integrationName	= emxGetParameter(request, "integrationName");
	if (integrationName == null || integrationName.equals(""))
	{
	   integrationName = getDefaultIntegrationName(request, (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject"));
	}
%>

<script language="JavaScript">
         
  
	function isBooleanVal(field){
		var sFieldVal = field.value;
		var sTrue = "<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.True</framework:i18nScript>";
		var sFalse = "<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.False</framework:i18nScript>";
		var bContinue = true;
		
		if(trimWhitespace(sFieldVal) != ''){
			if((sFieldVal.toLowerCase() != sTrue.toLowerCase()) && (sFieldVal.toLowerCase() != sFalse.toLowerCase()) && 
				(sFieldVal.toLowerCase() != "true") && (sFieldVal.toLowerCase() != "false")){
				alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.EnterBoolean</framework:i18nScript>");
				field.focus();
				bContinue = false;
			}
		}
		return bContinue;
	}
    function resetFormFields()
	{
        pageControl = top.pageControl;
        rebuildForm();
		if (document.forms[0] && document.forms[0].latestRevisionOnly)
		{
		   if  (document.forms[0].latestRevisionOnly.checked)
		   {
		       document.forms[0].txt_Revision.disabled = true;
			   document.forms[0].comboDescriptor_Revision.disabled = true;
			   document.forms[0].comboDescriptor_Revision.selectedIndex = -1;
		       document.forms[0].txt_Revision.value = '*';
			   document.forms[0].latestRevisionOnly.value = 'True';
			   document.forms[0].latestRevisionOnly.checked = true;
		   }
		   else
		   {
		       document.forms[0].txt_Revision.disabled = false;
			   document.forms[0].comboDescriptor_Revision.disabled = false;
			   document.forms[0].latestRevisionOnly.value = 'False';
			   document.forms[0].latestRevisionOnly.value = false;
			}
		}
	}

    function onSelectLatestRevision(checked)
    {
   
       if(checked != null && checked != 'undefined' 
          && checked)
       {
	       document.forms[0].txt_Revision.disabled = true;
		   document.forms[0].comboDescriptor_Revision.disabled = true;
		   document.forms[0].comboDescriptor_Revision.selectedIndex = -1;
	       document.forms[0].txt_Revision.value = '*';
		   document.forms[0].latestRevisionOnly.value = 'True';
		   document.forms[0].latestRevisionOnly.checked = true;
	}
       else
       {
           document.forms[0].txt_Revision.disabled = false;
		   document.forms[0].comboDescriptor_Revision.disabled = false;
		   document.forms[0].latestRevisionOnly.value = 'False';
		   document.forms[0].latestRevisionOnly.value = false;
       }
   }

	function doFindLike()
	{
	   doSearch();
	}
	
	function doSearch()
	{
		var varType     = document.findLikeForm.txtBusType.value;
		if(varType==""){
		<%
			String errMsg= FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Error.ChooseType", request.getHeader("Accept-Language"));
		%>
			alert("<%=errMsg%>");
			return;
		}
		//check for bad characters
		var badCharArr = new Array("'","\"","#");
		var badCharExists = badCharExistInForm(document.findLikeForm, badCharArr)
		if (badCharExists)
		{
			alert("<%=i18nNow.getI18nString("emxIEFDesignCenter.Common.SpecialCharacters", "emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"))%>");
			return;
		}

		var strQueryLimit = parent.frames[2].document.bottomCommonForm.QueryLimit.value;
		document.findLikeForm.queryLimit.value = strQueryLimit;
		document.findLikeForm.method="post";
		document.findLikeForm.target="_parent" ;
		document.findLikeForm.action="emxInfoFindLikeSummaryTable.jsp";
		for (var i=0; i < document.findLikeForm.chkAppendReplace.length; i++)
		{
			if (document.findLikeForm.chkAppendReplace[i].checked)
			{
				var rad_val = document.findLikeForm.chkAppendReplace[i].value;
				if(rad_val == "append")
				{
					 document.findLikeForm.appendCheckFlag.value = "true";
				}
				else
				{
					 document.findLikeForm.appendCheckFlag.value = "false";
				}
			}
		}
		
		document.findLikeForm.comboFormat.value="";
		for (var ii=0; ii < document.findLikeForm.comboFormats.length; ii++)
		{
			if(document.findLikeForm.comboFormats[ii].selected)
			{
				if(document.findLikeForm.comboFormats[ii].value=="*")
                {
					document.findLikeForm.comboFormat.value="*";
					break;
				}

				document.findLikeForm.comboFormat.value+=document.findLikeForm.comboFormats[ii].value+",";
			}
		}
   		document.findLikeForm.action='emxInfoTable.jsp?program=DSCFindLike:getList&table=DSCDefault&findType=DSCFindLike&timeStamp='+ "<%=XSSUtil.encodeForURL(context,sTimeStampPassed)%>"+'&timeStampAdvancedSearch='+"<%=XSSUtil.encodeForURL(context,sTimeStampPassed)%>";
		// IEF Changes Start
		setInstanceSearchCriteria();
		// IEF Changes End
   		
       // if(validateForm())
	   document.findLikeForm.submit();
	}


	function validateForm(){
		var bContinue = true;
		for (var i=0;i < document.findLikeForm.elements.length;i++)
		{
			var xe = document.findLikeForm.elements[i];
			var fieldName = xe.name

			if(fieldName.indexOf("_boolean") != -1){
				xe = document.findLikeForm.elements[i-1];
				if(!isBooleanVal(xe)){					
					bContinue = false;
					break;
				}
			}
		}
		return bContinue;
	}


    //Function to reload the page
    function reload() 
    {  	/*
        var varType     = document.findLikeForm.txt_Type.value;
        var varDisplayType     = document.findLikeForm.txtBusType.value;	
        var timestamp="<%=sTimeStampPassed%>";        
        var isIE = navigator.userAgent.toLowerCase().indexOf("msie") > -1;	
        if(!isIE){
        	varType = escape(varType);
		varDisplayType = escape(varDisplayType);
	  }
        document.location.href = "emxInfoFindLikeDialog.jsp?ComboType=" 
            + varType+"&ComboDisplayType=" 
            + varDisplayType+"&timeStamp="+ timestamp+ "&backPage=" + "<%=sBackPage%>";
*/
        var timestamp="<%=XSSUtil.encodeForJavaScript(context,sTimeStampPassed)%>";
        document.findLikeForm.ComboType.value=document.findLikeForm.txt_Type.value
        document.findLikeForm.ComboDisplayType.value=document.findLikeForm.txtBusType.value
        document.findLikeForm.action="emxInfoFindLikeDialog.jsp?timeStamp="+ timestamp;
        document.findLikeForm.method="post";
        document.findLikeForm.submit();
    }
     // Designer Central Find Like Fix #39557
    function doGlobalSelect(objectId, fullPath, applyToChild )
	{
		document.findLikeForm.workspaceFolderId.value = objectId;
		document.findLikeForm.WorkspaceFolder.value = fullPath;
	}
    function selectVal(val)
	{
		if(val == "owner")
		{
		  showModalDialog('emxTeamRouteWizardSelectPeopleDialogFS.jsp?callPage=Search',775,475);
		  return;
		} 
		else
		{
		  //emxShowModalDialog('emxTeamGenericSelectFolderDialogFS.jsp?formName=findLikeForm&callPage=Search',575,575);
          showTreeDialog('../integrations/MCADFolderSearchDialogFS.jsp?formName=findLikeForm&callPage=Search&showWorkspace=true&showApplyToChildren=false&showCollection=false');
		  return;
		}
	}
    //Function to reset the page with default values.
    function clear() 
    {
        for ( varCount = 0; varCount < document.findLikeForm.elements.length; varCount++) 
        {
            if (document.findLikeForm.elements[varCount].type == "text" && document.findLikeForm.elements[varCount].value != "")  
            {
                document.findLikeForm.elements[varCount].value = "";
            }

            if ( ( document.findLikeForm.elements[varCount].type == "select-one" )
                && ( document.findLikeForm.elements[varCount].selectedIndex != 0 )
                && ( document.findLikeForm.elements[varCount].name != "ComboType") )
            {
                document.findLikeForm.elements[varCount][0].selected = true;
            }
        }
    }

	//-- 12/17/2003         Start rajeshg   -->	
	//Function to check key pressed
	function cptKey(e) 
	{
		var pressedKey = ("undefined" == typeof (e)) ? event.keyCode : e.keyCode ;
		// for disabling backspace
		if (((pressedKey == 8) ||((pressedKey == 37) && (event.altKey)) || ((pressedKey == 39) && (event.altKey))) &&((event.srcElement.form == null) || (event.srcElement.isTextEdit == false)))
			return false;
		if( (pressedKey == 37 && event.altKey) || (pressedKey == 39 && event.altKey) && (event.srcElement.form == null || event.srcElement.isTextEdit == false))
			return false;

		if (pressedKey == "27") 
		{ 
			// ASCII code of the ESC key
			top.window.close();
		}
	}
	document.onkeypress = cptKey ;
	//-- 12/17/2003         End  rajeshg   -->

</script>

<script language="JavaScript">
  
	//specify the names of the types you want to show in the selector
	//specify the place to return the string AS A STRING...this cannot be an actual object reference or it will cause an error
	var strTxtType = "document.forms['findLikeForm'].txt_Type";
	var txtType = null;

	var strTxtTypeDisp = "document.forms['findLikeForm'].txtBusType";
	var txtTypeDisp = null;

	//can abstracts be selected?
	var bAbstractSelect = true;
	var bMultiSelect = false;
	var bReload = true;

function saveSearch(savedSearchName)
{
	var appendParam = "true";
	if(document.findLikeForm.chkAppendReplace[0].checked)
		appendParam = "false";

	document.findLikeForm.appendCheckFlag.value = appendParam;

	pageControl = top.pageControl;
	pageControl.setSavedSearchName(savedSearchName);
	var contentURL = parent.frames[1].location.href;
	var paramArray = contentURL.split('?');
	contentURL = '../iefdesigncenter/emxInfoFindLikeDialog.jsp?ComboDisplayType' + document.findLikeForm.txtBusType.value + '&findType=DSCFindLike' + '&ComboType=' + document.findLikeForm.txtBusType.value + '&' + paramArray[1];
	pageControl.setSearchContentURL(contentURL);
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
	var params = document.findLikeForm.reviseSearchParameters.value;
	document.findLikeForm.reviseSearchParameters.value = '';
	pageControl = top.pageControl;
	turnOffProgress();
	if (null != params && 'undefined' != params && '' != params)
	{
		var paramArray = params.split('&');
		if (null != paramArray)
		{
			// stores the name/value pairs into the pageControl cache
			if (null != paramArray)
			{
				for (var i = 0; i < paramArray.length; i++)
				{
					var paramNameValueArray = paramArray[i].split('=');
					var paramName = paramNameValueArray[0];
					var paramValue = paramNameValueArray[1];
					if (paramName == null || paramName == '') 
						continue;
					if ((paramName == 'txtName') || (paramName == 'txtType') || 
					    (paramName == 'txtRev') || (paramName == 'displayowner') 
						|| (paramName == 'keywords') || (paramName == 'txtVault') || 
						(paramName == 'WorkspaceFolder') ||
						(paramName.indexOf('txtWhere') >= 0))
					{
					    //XSSOK
						paramValue = hexDecode('<%=integrationName%>',paramValue);
					}
					pageControl.addToArrFormVals(new Array(paramName, paramValue, true, false));
				}
			}
		}
	 }   
    //XSSOK	 
	if ("<%=sQueryName%>" != '')
	{
	    pageControl = top.pageControl;
		//XSSOK
	    top.pageControl.setSavedSearchName(encodeURIIfCharacterEncodingUTF8(encodeSaveSearchName("<%=sQueryName%>")));
	    top.importSavedSearchXML();
	}
     
	// waits for the Search dialog is completed loaded and then reset the form fields
	setTimeout("resetFormFields()", 1000);
	parent.frames['searchFoot'].document.bottomCommonForm.QueryLimit.disabled = false;
} 

</script>
<body class="content" onload="document.findLikeForm.txtBusType.focus();loadFormFields();">
<form name="findLikeForm" id="idForm" onSubmit="return false">



<%
	if ("null".equals(sBizType) || sBizType == null || "".equals(sBizType)) 
    {
	    sBizType = "";
%>
		<input type="hidden" name="txt_Type" value="*">
<%
	}
    else
    {
%>
		<input type="hidden" name="txt_Type" value="<xss:encodeForHTMLAttribute><%=sBizType%></xss:encodeForHTMLAttribute>">
<%
	}
%>


<%

		//get the types to be shown in type chooser from the current GCO
   	    String strTypeList = "type_CADDrawing,type_CADModel";
		//MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");

		if(integSessionData != null) 
		{
			 strTypeList = integSessionData.getTypesForTypeChooser(integSessionData.getClonedContext(session));
		}

%>
<input type="hidden" name="comboDescriptor_Type" value="IsExactly">
<input type=hidden  name="queryLimit" value="">
<!-- adding hidden types for action bars such as top/bottom -->
<input type=hidden  name="program" value="DSCFindLike:getList">
<input type=hidden name="searchID" value="__DesignerCentral__">
<input type=hidden  name=table value="DSCDefault" >
<input type=hidden  name="topActionbar" value="DSCSearchResultTopActionBar">
<input type=hidden  name="bottomActionbar" value="">
<input type=hidden  name="pagination" value="10">
<input type=hidden  name="selection" value="multiple">
<!--XSSOK-->
<input type=hidden  name ="header"  value="<%=headerString%>" >
<input type=hidden  name="selType" value="<xss:encodeForHTMLAttribute><%=sBizType%></xss:encodeForHTMLAttribute>">
<input type=hidden  name="timeStamp" value="<xss:encodeForHTMLAttribute><%=sTimeStampPassed%></xss:encodeForHTMLAttribute>">
<input type=hidden  name="timeStampAdvancedSearch" value="<xss:encodeForHTMLAttribute><%=sTimeStampPassed%></xss:encodeForHTMLAttribute>">
<input type=hidden  name="targetLocation" value="popup">
<input type=hidden  name="comboFormat" value="">
<input type=hidden  name=headerRepeat value=10>
<input type=hidden  name="suiteKey" value="<%=sInfoCentralSuite%>">
<input type=hidden  name="findType" value="DSCFindLike">
<input type=hidden  name="reviseSearch" value="<xss:encodeForHTMLAttribute><%=sReviseSearch%></xss:encodeForHTMLAttribute>">
<input type=hidden  name="ComboType" value="">
<input type=hidden  name="ComboDisplayType" value="">
<input type=hidden name="program" value="DSCFindLike:getList">
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
<!--XSSOK-->
<input type=hidden name="errorMessage" value="<%=sErrorMsg%>">
<input type=hidden name="expandCheckFlag" value="true">
<input type=hidden name="appendCheckFlag" value="false">
<!--XSSOK-->
<input type=hidden name="reviseSearchParameters" value="<%=sParameters%>">

<!-- 01/10/2003         Start nagesh   -->
<input type=hidden name="backPage" value="<xss:encodeForHTMLAttribute><%=sBackPage%></xss:encodeForHTMLAttribute>"> 
<!-- 01/10/2003         End nagesh   -->



<table border="0" cellpadding="5" width="100%" >
	<tr>
	<td class="label"><%=i18nNow.getBasicI18NString("Type",  languageStr)%>
	</td>
	<td class="inputField">

	<input type=text readonly="readonly" value ="<xss:encodeForHTMLAttribute><%=sBizType%></xss:encodeForHTMLAttribute>" size="16" name="txtBusType" >
	<!--XSSOK-->
	<input type=button name="btnTypeSelector" id="idBTNTypeSelector" value="..." onClick="showModalAEFTypeSelector('<%=strTypeList%>', 'true', 'findLikeForm', 'txt_Type', 'txtBusType', 'false', 'true');if (top.pageControl) top.pageControl.clearArrFormVals();">
  
	</td>
	</tr>
<%
	if (sBizType!=null && !sBizType.equals("") && !sBizType.equals("null")) 
	{
%>
 <tr>
    <td width="150" class="label"><%=i18nNow.getI18nString("emxTeamCentral.FindFiles.WorkspaceFolder", "emxTeamCentralStringResource", request.getHeader("Accept-Language"))%><!--<emxUtil:i18n localize="i18nId">emxTeamCentral.FindFiles.WorkspaceFolder</emxUtil:i18n>--></td>
    <td class="inputField">
    <input type="text"  name="WorkspaceFolder" id="WorkspaceFolder" value="<xss:encodeForHTMLAttribute><%=sWorkspaceFolder%></xss:encodeForHTMLAttribute>">
    <input type="button" name="butClear" id="" value="..." onclick=selectVal("folder")>&nbsp;</td>
    <input type=hidden name=workspaceFolderId value="<xss:encodeForHTMLAttribute><%=sWorkspaceFolderId%></xss:encodeForHTMLAttribute>">
  </tr>
<% } %>
</table>
<%
	if (sBizType!=null && !sBizType.equals("") && !sBizType.equals("null")) 
	{
		String sTxtKeyword      = (String)localHashMap.get("txtKeyword");
		String sTxtFormat       = (String)localHashMap.get("txtFormat");
		String sFormat          = (String)localHashMap.get("comboFormat");

		if (sFormat == null)
		  sFormat = "*";
		if (sTxtFormat == null)
		  sTxtFormat = "";
		if (sTxtKeyword == null)
		  sTxtKeyword = "";


		// Translated string operators
		String sMatrixIncludes     = "Includes";
		String sMatrixIsExactly    = "IsExactly";
		String sMatrixIsNot        = "IsNot";
		String sMatrixMatches      = "Matches";
		String sMatrixBeginsWith   = "BeginsWith";
		String sMatrixEndsWith     = "EndsWith";
		String sMatrixEquals       = "Equals";
		String sMatrixDoesNotEqual = "DoesNotEqual";
		String sMatrixIsBetween    = "IsBetween";
		String sMatrixIsAtMost     = "IsAtMost";
		String sMatrixIsAtLeast    = "IsAtLeast";
		String sMatrixIsMoreThan   = "IsMoreThan";
		String sMatrixIsLessThan   = "IsLessThan";
		String sMatrixIsOn         = "IsOn";
		String sMatrixIsOnOrBefore = "IsOnOrBefore";
		String sMatrixIsOnOrAfter  = "IsOnOrAfter";
		//String sMatrixIsInBetween  = "InBetween";

		String sMatrixIncludesTrans     = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.FindLike.Includes",languageStr);
		String sMatrixIsExactlyTrans    = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.FindLike.IsExactly",languageStr);
		String sMatrixIsNotTrans        = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.FindLike.IsNot",languageStr);
		String sMatrixMatchesTrans      = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.FindLike.Matches",languageStr);
		String sMatrixBeginsWithTrans   = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.FindLike.BeginsWith", languageStr);
		String sMatrixEndsWithTrans     = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.FindLike.EndsWith",languageStr);
		String sMatrixEqualsTrans       = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.FindLike.Equals",languageStr);
		String sMatrixDoesNotEqualTrans = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.FindLike.DoesNotEqual",languageStr);
		String sMatrixIsBetweenTrans    = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.FindLike.IsBetween",languageStr);
		String sMatrixIsAtMostTrans     = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.FindLike.IsAtMost",languageStr);
		String sMatrixIsAtLeastTrans    = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.FindLike.IsAtLeast",languageStr);
		String sMatrixIsMoreThanTrans   = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.FindLike.IsMoreThan",languageStr);
		String sMatrixIsLessThanTrans   = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.FindLike.IsLessThan",languageStr);
		String sMatrixIsOnTrans         = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.FindLike.IsOn",languageStr);
		String sMatrixIsOnOrBeforeTrans = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.FindLike.IsOnOrBefore",languageStr);
		String sMatrixIsOnOrAfterTrans  = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.FindLike.IsOnOrAfter",languageStr);
		//String sMatrixIsInBetweenAfterTrans = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.FindLike.IsBetween",languageStr);

		String sOption             = "";
		String sFiller             = "";

		//Array to find the max length of the options
		String sArrayOperator []   = { sMatrixIncludes,sMatrixIsExactly,sMatrixIsNot,sMatrixMatches,
                                   sMatrixBeginsWith,sMatrixEndsWith,sMatrixEquals,sMatrixDoesNotEqual,
                                   sMatrixIsBetween,sMatrixIsAtMost,sMatrixIsAtLeast,sMatrixIsMoreThan,
                                   sMatrixIsLessThan,sMatrixIsOn,sMatrixIsOnOrBefore,sMatrixIsOnOrAfter};
		int iMax    = 0;
		int iIndex  = 0;
		//To get the parameters passed
		
		// 18/12/2003        start    nagesh 
				
		// The varaible SOptionSelected is used to check  wheather user is coming from back button
		String SOptionSelected="false";
		Iterator iNumObj;
		Enumeration eNumObj;
		Vector  vectParamName   = new Vector();
		String sParam           = "";
		if(localHashMap != null && (localHashMap.size() > 0)) 
	    {
			SOptionSelected="true";
			iNumObj = localHashMap.keySet().iterator();
			while (iNumObj.hasNext()) 
			{
				sParam = (String)iNumObj.next();
				vectParamName.add(sParam);
			}
		}
		else
        {
			eNumObj = emxGetParameterNames(request);
		if(eNumObj!=null) 
        {
		  while (eNumObj.hasMoreElements()) 
          {
			sParam = (String)eNumObj.nextElement();
			vectParamName.add(sParam);
		  }
		}
		 }
         
		 // 18/12/2003        End    nagesh 
		
		//To store the Attribute's name,data type and the value.
		Vector vectHolder             = new Vector();
		
		//To store the Attribute's choices.
		StringList sListAttribute     = null;

		StringBuffer sbStrInclude     = null;
		StringBuffer sbRealInclude    = null;
		StringBuffer sbTimeInclude    = null;
		StringBuffer sbBooleanInclude = null;



		//To find the max length of the options.
		for (int i = 0; i < (sArrayOperator.length)-1; i++) 
        {
		  for (int j = i+1;j<sArrayOperator.length; j++) 
          {
			if (sArrayOperator[i].length() < sArrayOperator[j].length()) 
            {
			  iMax = sArrayOperator[j].length();
			}
		  }
		}

		//To Create fill space to equalize all drop downs for descriptors
		//and add 12 because &nbsp not = to constant #
		iMax = iMax+20;
		while (iIndex != iMax) 
        {
		  sFiller += "&nbsp;";
		  iIndex++;
		}
		// 24/12/2003 start nagesh
		String strSearchType="ExcludeAttributeType_"+sBizType;

		//26/12/2003 Added by nagesh
		//this code is used to remove spaces from Type name if any
		String strTypeName="";
		StringTokenizer stkTypeName=new StringTokenizer(sBizType," ");
		while(stkTypeName.hasMoreElements())
		{
			strTypeName+=stkTypeName.nextElement();
		}
			
		strSearchType="ExcludeAttributeType_"+strTypeName;
		//26/12/2003 End of Added by nagesh
		
		StringList excludeTypes = getInfoCentralProperties(application, session, "emxInfoCentral", strSearchType);
		// 24/12/2003 end nagesh
		BusinessType btType              = new BusinessType(sBizType,context.getVault());
		btType.open(context, false);
		//To get the Find Like information of the business type selected

		matrix.db.FindLikeInfo flLikeObj = btType.getFindLikeInfo(context);
		btType.close(context);
		//To get the attribute list of the business type
		AttributeList attrListObj        = flLikeObj.getAttributes();
		AttributeItr attrItrObj          = new AttributeItr(attrListObj);

		String sName      = "";
		String sDataType  = "";


		if(sShowHiddenAttr == null )  
        {
		  sShowHiddenAttr ="";
		} 
        else if(sShowHiddenAttr.equals("null")) 
        {
		  sShowHiddenAttr ="";
		}

		while (attrItrObj.next()) 
        {
		  sListAttribute    = new StringList();
		  Attribute attrObj = attrItrObj.obj();
		  
		  //Store name of the attribute in vector if Attribute is not hidden
		  sName             = attrObj.getName();
		  if( ( sShowHiddenAttr.equals("TRUE") ) || 
            ( !FrameworkUtil.isAttributeHidden(context, sName)) ) 
          {
			  //26/12/2003 Nagesh added for subset attribute search
			 if(excludeTypes == null || (!excludeTypes.contains(sName)) )
			  {
			vectHolder.addElement(sName);
			//To get the attribute choices
			if (attrObj.hasChoices()) 
            {
			  sListAttribute  = attrObj.getChoices();
			  vectHolder.addElement(sListAttribute);
			} 
            else 
            {
			  vectHolder.addElement(sListAttribute);
			}
			
            //To get the Data type of the attribute
			AttributeType attrTypeObj = attrObj.getAttributeType();
			attrTypeObj.open(context);
			sDataType                 = attrTypeObj.getDataType();
			attrTypeObj.close(context);
			//Store datatype in vector
			vectHolder.addElement(sDataType);
		  }
		  }

		}

		////// 24/12/2003 start change nagesh

       StringList excludeBasics = getInfoCentralProperties(application, session, "emxInfoCentral", "ExcludeBasicAttributes");

		//Get states for the Business Type and add it to the vector
		StringList sListStates = flLikeObj.getStates();
		if(excludeBasics == null || (!excludeBasics.contains("Current")) )
		{
		vectHolder.addElement("Current");
		vectHolder.addElement(sListStates);
		vectHolder.addElement("string");
		}

		// To add the Modified basics in the vector to search
		if(excludeBasics == null || (!excludeBasics.contains("Modified")) )
		{
		vectHolder.addElement("Modified");
		vectHolder.addElement(null);
		vectHolder.addElement("timestamp");
		}


		// To add the Modified basics in the vector to search
		if(excludeBasics == null || (!excludeBasics.contains("Originated")) )
		{
		vectHolder.addElement("Originated");
		vectHolder.addElement(null);
		vectHolder.addElement("timestamp");
		}

		//To get the list of persons role and Groups
		StringList sListUser      = new StringList();
		StringList sListOwner     = new StringList();

		PersonList personListObj  = Person.getPersons(context, true);
		PersonItr personItrObj    = new PersonItr(personListObj);
		while (personItrObj.next()) 
        {
		  sListUser.addElement(personItrObj.obj().toString());
		  sListOwner.addElement(personItrObj.obj().toString());
		}
		GroupList groupListObj    = Group.getGroups(context, true);
		GroupItr groupItrObj      = new GroupItr(groupListObj);
		while (groupItrObj.next()) 
        {
		  sListUser.addElement(groupItrObj.obj().toString());
		  sListOwner.addElement(groupItrObj.obj().toString());
		}
		RoleList roleListObj      = Role.getRoles(context, true);
		RoleItr roleItrObj        = new RoleItr(roleListObj);

		while (roleItrObj.next()) 
        {
		  sListOwner.addElement(roleItrObj.obj().toString());
		}

		sListUser.sort();
		sListOwner.sort();
		//To add the owner basic in the vector to search
		if(excludeBasics == null || (!excludeBasics.contains("Owner")) )
		{
		vectHolder.addElement("Owner");
		vectHolder.addElement(sListOwner);
		vectHolder.addElement("string");
		}
		//To add the Grantee basic in the vector to search
		if(excludeBasics == null || (!excludeBasics.contains("Grantee")) )
		{
		vectHolder.addElement("Grantee");
		vectHolder.addElement(sListUser);
		vectHolder.addElement("string");
		}
		
		//To add the Grantor basic in the vector to search
		if(excludeBasics == null || (!excludeBasics.contains("Grantor")) )
		{
		vectHolder.addElement("Grantor");
		vectHolder.addElement(sListUser);
		vectHolder.addElement("string");
		}

		//To add the Policy basics in the vector to search
		StringList sListPolicy = flLikeObj.getPolicies();

		if(excludeBasics == null || (!excludeBasics.contains("Policy")) )
		{
		vectHolder.addElement("Policy");
		vectHolder.addElement(sListPolicy);
		vectHolder.addElement("string");
		}
		
		//To add the Revision basics in the vector to search
		if(excludeBasics == null || (!excludeBasics.contains("Revision")) )
		{
		vectHolder.addElement("Revision");
		vectHolder.addElement(null);
		vectHolder.addElement("string");
		}

		// get all the vaults into an iterator.
		VaultItr vaultItrObj     = new VaultItr(Vault.getVaults(context, true));
		StringList sListVault    = new StringList();
		while (vaultItrObj.next()) 
        {
		  sListVault.addElement((vaultItrObj.obj()).getName());
		}

		//To add the Vault basics in the vector to search
		if(excludeBasics == null || (!excludeBasics.contains("Vault")) )
		{
		vectHolder.addElement("Vault");
		vectHolder.addElement(sListVault);
		vectHolder.addElement("string");
		}

		//  Create Drop downs for Data types of the Attribute
		sOption             = "<option name=blank value=\"*\">"+sFiller+"</option><option name='";

		//To set options for string data type
		sbStrInclude    = new StringBuffer(sOption);
		sbStrInclude.append(sMatrixBeginsWith + "' value='" + sMatrixBeginsWith + "'>" + sMatrixBeginsWithTrans + " </option>");
		sbStrInclude.append("<option name='" + sMatrixEndsWith + "' value='" + sMatrixEndsWith + "'>" + sMatrixEndsWithTrans + " </option>");
		sbStrInclude.append("<option name='" + sMatrixIncludes + "' value='" + sMatrixIncludes + "'>" + sMatrixIncludesTrans + " </option>");
		
		// 17/12/2003        start    nagesh
		/*************************
		// To see the default value once user log in 
		if (SOptionSelected.equalsIgnoreCase("true"))
		{
			sbStrInclude.append("<option   name='" + sMatrixIncludes + "' value='" + sMatrixIncludes + "'>" + sMatrixIncludesTrans + " </option>");
		}
		else
		{
			sbStrInclude.append("<option name='" + sMatrixIncludes + "' value='" + sMatrixIncludes + "'>" + sMatrixIncludesTrans + " </option>");
		}
		// 17/12/2003        End    nagesh 
		***************************/
		sbStrInclude.append("<option name='" + sMatrixIsExactly + "' value='" + sMatrixIsExactly + "'>" + sMatrixIsExactlyTrans + " </option>");
		sbStrInclude.append("<option name='" + sMatrixIsNot + "' value='" + sMatrixIsNot + "'>" + sMatrixIsNotTrans + " </option>");
		sbStrInclude.append("<option name='" + sMatrixMatches + "' value='" + sMatrixMatches + "'>" + sMatrixMatchesTrans + " </option>");

		//To set options for numeric data type
		sbRealInclude   = new StringBuffer(sOption);
		sbRealInclude.append(sMatrixIsAtLeast + "' value='" + sMatrixIsAtLeast + "'>" + sMatrixIsAtLeastTrans + "</option>");
		sbRealInclude.append("<option name='" + sMatrixIsAtMost + "' value='" + sMatrixIsAtMost + "'>" + sMatrixIsAtMostTrans + "</option>");
		sbRealInclude.append("<option name='" + sMatrixDoesNotEqual + "' value='" + sMatrixDoesNotEqual + "'>" + sMatrixDoesNotEqualTrans + "</option>");
		sbRealInclude.append("<option name='" + sMatrixEquals + "' value='" + sMatrixEquals + "'>" + sMatrixEqualsTrans + "</option>");
		sbRealInclude.append("<option name='" + sMatrixIsBetween + "' value='" + sMatrixIsBetween +  "'>" + sMatrixIsBetweenTrans + "</option>");
		sbRealInclude.append("<option name='" + sMatrixIsLessThan + "' value='" + sMatrixIsLessThan + "'>" + sMatrixIsLessThanTrans + "</option>");
		sbRealInclude.append("<option name='" + sMatrixIsMoreThan + "' value='" + sMatrixIsMoreThan + "'>" + sMatrixIsMoreThanTrans + "</option>");

		//To set options for date/time data type
		sbTimeInclude   = new StringBuffer(sOption);
		sbTimeInclude.append(sMatrixIsOn + "' value='" + sMatrixIsOn + "'>" + sMatrixIsOnTrans + "</option>");
		
		sbTimeInclude.append("<option name='" + sMatrixIsOnOrBefore + "' value='" + sMatrixIsOnOrBefore + "'>" + sMatrixIsOnOrBeforeTrans + "</option>");

		sbTimeInclude.append("<option name='" + sMatrixIsOnOrAfter + "' value='" + sMatrixIsOnOrAfter + "'>" + sMatrixIsOnOrAfterTrans + "</option>");

		sbTimeInclude.append("<option name='" + sMatrixIsBetween + "' value='" + sMatrixIsBetween + "'>" + sMatrixIsBetweenTrans + "</option>");


		//To set options for boolean data type
		sbBooleanInclude    = new StringBuffer(sOption);
		sbBooleanInclude.append(sMatrixIsExactly + "' value='" + sMatrixIsExactly + "'>" + sMatrixIsExactlyTrans + " </option>");

		sbBooleanInclude.append("<option name='" + sMatrixIsNot + "' value='" + sMatrixIsNot + "'>" + sMatrixIsNotTrans + " </option>");

%>
		<%
		// added by nagesh on 18/12/2003
		String strNameValue="";
		String strDescValue="";
		
		strNameValue=(String)localHashMap.get("txt_Name");
		if(null == strNameValue || "null".equalsIgnoreCase(strNameValue) || strNameValue.length() == 0) strNameValue= "";
		
		strDescValue=(String)localHashMap.get("txt_Description");
		if(null == strDescValue || "null".equalsIgnoreCase(strDescValue) || strDescValue.length() == 0) strDescValue = "";
		
		String strNameCombo=(String)localHashMap.get("comboDescriptor_Name");
		String strDescCombo=(String)localHashMap.get("comboDescriptor_Description");
		//End of  added by nagesh on 18/12/2003
		%>
		
		<table width="100%" cellpadding="3" cellspacing="2" border="0">
		<tr>
		    <!--XSSOK-->
			<th><%=FrameworkUtil.i18nStringNow("emxIEFDesignCenter.FindLike.Field",languageStr)%></th>
			<!--XSSOK-->
			<th><%=FrameworkUtil.i18nStringNow("emxIEFDesignCenter.FindLike.Operator",languageStr)%></th>
			<!--XSSOK-->
			<th><%=FrameworkUtil.i18nStringNow("emxIEFDesignCenter.FindLike.EnterValue",languageStr)%></th>
			<!--XSSOK-->
			<th><%=FrameworkUtil.i18nStringNow("emxIEFDesignCenter.FindLike.SelectValue",languageStr)%></th>
		</tr>
		<%
		if(excludeBasics == null || (!excludeBasics.contains("Name")) )
		{
		%>

		<tr>
			<td class="label" ><%=i18nNow.getBasicI18NString("Name",  languageStr)%></td>
			<td class="field"  ><select name="comboDescriptor_Name">
			
		<%
			// added by nagesh on 18/12/2003
		    if (strNameCombo !=null && !"null".equals(strNameCombo) &&
            !"".equals(strNameCombo) && strNameCombo.length() > 2) 
            {
                StringBuffer sbSelect = new StringBuffer(sbStrInclude.toString());
                int ilength           = sbSelect.toString().indexOf(strNameCombo);
                int iClength          = strNameCombo.length();
                int iActlen           = ilength + 10+2*iClength;

                sbSelect.insert(iActlen," selected");
        %>
		    <!--XSSOK-->
    		<%=sbSelect%></select></td>
         <%
		    } 
            else 
            {
         %>
		    <!--XSSOK-->
			<%=sbStrInclude%></select></td>
          <%
			//End of  added by nagesh on 18/12/2003	 
		   }
		 %>
		
		
		<td class="field"><input type="text" name="txt_Name"  value ="<xss:encodeForHTMLAttribute><%=strNameValue%></xss:encodeForHTMLAttribute>" ></td>
			<td class="field">&nbsp;</td>
		</tr>
		<%
			}
		%>
		
		<%
		if(excludeBasics == null || (!excludeBasics.contains("Description")) )
		{
		%>

		<tr>
			<td class="label"><%=i18nNow.getBasicI18NString("Description",  languageStr)%></td>
			<td class="field"  ><select name="comboDescriptor_Description">
			
		<%
		    //added by nagesh on 18/12/2003	 
			if (strDescCombo !=null && !"null".equals(strDescCombo) &&
            !"".equals(strDescCombo) && strDescCombo.length() > 2) 
            {
                StringBuffer sbSelect = new StringBuffer(sbStrInclude.toString());
                int ilength           = sbSelect.toString().indexOf(strDescCombo);
                int iClength          = strDescCombo.length();
                int iActlen           = ilength + 10+2*iClength;

                sbSelect.insert(iActlen," selected");
        %>
		    <!--XSSOK-->
    		<%=sbSelect%></select></td>
         <%
		    } 
            else 
            {
         %>
		    <!--XSSOK-->
			<%=sbStrInclude%></select></td>
          <%
			 }
			//End of  added by nagesh on 18/12/2003	 
		  %>



			<td class="field"><input type="text" name="txt_Description"  value="<xss:encodeForHTMLAttribute><%=strDescValue%></xss:encodeForHTMLAttribute>" ></td>
			<td class="field">&nbsp;</td>
		</tr>
		<%
			}
		%>
   
<%
		String sAttName    = "";
		String sAttType    = "";
		for (iIndex = 0; iIndex < vectHolder.size(); iIndex = iIndex+3) 
		{
			sAttName = (String) vectHolder.elementAt(iIndex);
			String sCombovalue  = "comboDescriptor_"+sAttName;
			String sTxtvalue    = "txt_"+sAttName;
			String sTxtOrgVal   = "";
			String sComboOrgval = "";
			String sOrgVal      = "";
		   // 17/12/2003        start    nagesh 
           //  To read the variable from the hashmap  

			if (vectParamName.contains(sTxtvalue)) 
            {
				sTxtOrgVal=(String)localHashMap.get(sTxtvalue);
				if(null == sTxtOrgVal || "null".equalsIgnoreCase(sTxtOrgVal) || sTxtOrgVal.length() == 0) sTxtOrgVal = "";

			}
			if (vectParamName.contains(sCombovalue)) 
            {
				sComboOrgval=(String)localHashMap.get(sCombovalue);
			}
			if (vectParamName.contains(sAttName)) 
            {
				sOrgVal=(String)localHashMap.get(sAttName);
			}
		   // 17/12/2003        End    nagesh 

%>
			<tr>
<%
		  if (sAttName.equals("Modified") 
                || sAttName.equals("Originated") 
                || sAttName.equals("Vault")
                || sAttName.equals("Policy")
                || sAttName.equals("Owner")
                || sAttName.equals("Grantor")
                || sAttName.equals("Grantee")
                || sAttName.equals("Revision")
                || sAttName.equals("Current"))
             
			{
%>
				<td class="label"><%=i18nNow.getBasicI18NString( sAttName,  languageStr)%>&nbsp;</td>
<%
			}
			else
			{
%>
				<td class="label"><%=i18nNow.getAttributeI18NString( sAttName,  languageStr)%>&nbsp;</td>
<%			}
	sAttType = (String)vectHolder.elementAt(iIndex+2);
%>
	<input type=hidden name="<%=XSSUtil.encodeForHTML(context,sAttName)%>_type" value ="<xss:encodeForHTMLAttribute><%=sAttType%></xss:encodeForHTMLAttribute>" >
	<td class="field" align="left"><select name="comboDescriptor_<%=XSSUtil.encodeForHTML(context,sAttName)%>" size="1">
<%
       // 17/12/2003        start    nagesh 
        if (sAttType !=null && !"null".equals(sAttType) &&
        !"".equals(sAttType) && sAttType.equals("string")) 
			{

            if (sComboOrgval !=null && !"null".equals(sComboOrgval) &&
            !"".equals(sComboOrgval) && sComboOrgval.length() > 2) 
                {
                // 17/12/2003        End    nagesh 
				    StringBuffer sbSelect = new StringBuffer(sbStrInclude.toString());
				    int ilength           = sbSelect.toString().indexOf(sComboOrgval);
				    int iClength          = sComboOrgval.length();
				    int iActlen           = ilength + 10+2*iClength;

				    sbSelect.insert(iActlen," selected");
%>
                <!--XSSOK-->
				<%=sbSelect%></select></td>
<%
			    } 
                else 
                {
%>
                <!--XSSOK-->
				<%=sbStrInclude%></select></td>
<%			    }
			} 
        // 17/12/2003        start    nagesh 
        else if (sAttType !=null && !"null".equals(sAttType) &&
        !"".equals(sAttType) && ((sAttType.equals("real")) || (sAttType.equals("integer"))) )
			{
            if (sComboOrgval !=null && !"null".equals(sComboOrgval) &&
            !"".equals(sComboOrgval) && sComboOrgval.length() > 2) 
            // 17/12/2003        End    nagesh 
                {
				    StringBuffer sbSelect = new StringBuffer(sbRealInclude.toString());
				    int ilength           = sbSelect.toString().indexOf(sComboOrgval);
				    int iClength          = sComboOrgval.length();
				    int iActlen           = ilength + 10+2*iClength;
				    sbSelect.insert(iActlen," selected");
%>
                <!--XSSOK-->
				<%=sbSelect%></select></td>
<%
			    } 
                else 
                {
%>
                <!--XSSOK-->
				<%=sbRealInclude%></select></td>
<%
			    }
			} 
			// 17/12/2003        start    nagesh 
        else if (sAttType !=null && !"null".equals(sAttType) &&
        !"".equals(sAttType) && sAttType.equals("timestamp")) 
            {
				String sAttValue = "";
            if (sComboOrgval !=null && !"null".equals(sComboOrgval) &&
            !"".equals(sComboOrgval) && sComboOrgval.length() > 2) 
                {
                // 17/12/2003        End    nagesh 
					StringBuffer sbSelect = new StringBuffer(sbTimeInclude.toString());
					int ilength           = sbSelect.toString().indexOf(sComboOrgval);
					int iClength          = sComboOrgval.length();
					int iActlen           = ilength + 10+2*iClength;

					sbSelect.insert(iActlen," selected");

%>
                    <!--XSSOK-->
					<%=sbSelect%></select></td>
<%
			    } 
                else 
                {
%>
                <!--XSSOK-->
				<%=sbTimeInclude%></select></td>
<%
			    }
			    if (getParameter(paramList,request, sAttName)!= null) 
                {
			        sAttValue = getParameter(paramList,request, sAttName);
			    }
          
      	// 18/12/2003        End    nagesh   
	  // 18/12/2003        start    nagesh 

	       String  startSAttr="";
		   String endSAttr="";


        if (!("null".equals((String)localHashMap.get("txt_"+sAttName+"_start")))) 
        {
			 startSAttr = (String)localHashMap.get("txt_"+sAttName+"_start");
	 	     if(null == startSAttr || "null".equalsIgnoreCase(startSAttr) || startSAttr.length() == 0)startSAttr=""; 
		}

        if (!("null".equals((String)localHashMap.get("txt_"+sAttName+"_end")))) 
        {
			endSAttr = (String)localHashMap.get("txt_"+sAttName+"_end");
			if(null == endSAttr || "null".equalsIgnoreCase(endSAttr) || endSAttr.length() == 0)endSAttr="";
		}

	// 18/12/2003        End    nagesh 
%>
	<!-- 17/12/2003         Start nagesh   -->	
<!-- Changed the  variable  value to display on back button ,remove blur function , put readonly in text  -->		
	<td  nowrap align="left"  class="field" ><input readonly="readonly" type="text"  name="txt_<%=XSSUtil.encodeForHTML(context,sAttName)%>_start"   value="<xss:encodeForHTMLAttribute><%=startSAttr%></xss:encodeForHTMLAttribute>" >&nbsp;&nbsp;<a href="javascript:showCalendar('findLikeForm','txt_<%=XSSUtil.encodeForJavaScript(context,sAttName)%>_start','');"><img src="../common/images/iconSmallCalendar.gif" border=0></a>
			<br>
			<input readonly="readonly" type="text"  name="txt_<%=XSSUtil.encodeForHTML(context,sAttName)%>_end"   value="<xss:encodeForHTMLAttribute><%=endSAttr%></xss:encodeForHTMLAttribute>" >&nbsp;&nbsp;<a href="javascript:showCalendar('findLikeForm','txt_<%=XSSUtil.encodeForJavaScript(context,sAttName)%>_end','');"><img src="../common/images/iconSmallCalendar.gif" border=0></a>
			</td>	
		 <!-- 17/12/2003         End nagesh   -->
		
<%
		    } 
            // 17/12/2003        start    nagesh
            else if ( sAttType !=null && !"null".equals(sAttType) &&
					!"".equals(sAttType) &&sAttType.equals("boolean")) 
		    {
			    if (sComboOrgval !=null && !"null".equals(sComboOrgval) &&
					!"".equals(sComboOrgval) && sComboOrgval.length() > 2) 
                {
				 // 17/12/2003        End    nagesh
				    StringBuffer sbSelect = new StringBuffer(sbBooleanInclude.toString());
				    int ilength           = sbSelect.toString().indexOf(sComboOrgval);
				    int iClength          = sComboOrgval.length();
				    int iActlen           = ilength + 10+2*iClength;

				    sbSelect.insert(iActlen," selected");

%>
                <!--XSSOK-->
				<%=sbSelect%></select></td>
<%
			    } 
                else 
                {
%>
            <!--XSSOK-->
			<%=sbBooleanInclude%></select></td>
<%
			    }
		    }

		    if (!sAttType.equals("timestamp")) 
            {
            	if(sAttType.equalsIgnoreCase("boolean")){
%>
			<td align="left"  class="field">
				<input type="text"  name="txt_<%=XSSUtil.encodeForHTML(context,sAttName)%>"   value="<xss:encodeForHTMLAttribute><%=sTxtOrgVal%></xss:encodeForHTMLAttribute>" >
				<input type="hidden"  name="<%=XSSUtil.encodeForHTML(context,sAttName)%>_boolean">
			</td>
<%
				}else{
%>
			
<%
    if(sAttType.equalsIgnoreCase("real") || sAttType.equalsIgnoreCase("integer"))
	{
	
	     //added by nagesh on 18/12/2003
		   String  startSAttr="";
		   String endSAttr="";


        if (!("null".equals((String)localHashMap.get("txt_"+sAttName+"_start")))) 
        {
			 startSAttr = (String)localHashMap.get("txt_"+sAttName+"_start");
 	 	     if(null == startSAttr || "null".equalsIgnoreCase(startSAttr) || startSAttr.length() == 0)startSAttr=""; 
		}

        if (!("null".equals((String)localHashMap.get("txt_"+sAttName+"_end")))) 
        {
			endSAttr = (String)localHashMap.get("txt_"+sAttName+"_end");
           if(null == endSAttr || "null".equalsIgnoreCase(endSAttr) || endSAttr.length() == 0)endSAttr=""; 
		}
		//End of added by nagesh on 18/12/2003
%>
    		<td align="left"  class="field" ><input type="text"  name="txt_<%=XSSUtil.encodeForHTML(context,sAttName)%>_start"   value="<xss:encodeForHTMLAttribute><%=startSAttr%></xss:encodeForHTMLAttribute>" >
			<br><input type="text"  name="txt_<%=XSSUtil.encodeForHTML(context,sAttName)%>_end" value="<xss:encodeForHTMLAttribute><%=endSAttr%></xss:encodeForHTMLAttribute>"   ></td>

<% }
   else
   {
%>
	<td align="left"  class="field" ><input type="text"  name="txt_<%=XSSUtil.encodeForHTML(context,sAttName)%>"   value="<xss:encodeForHTMLAttribute><%=sTxtOrgVal%></xss:encodeForHTMLAttribute>" ></td>

<%
}
				}
		    } 
            if (sAttName.equals("Revision"))
			{
%>
                <td>&nbsp;&nbsp;<input type="checkbox" name="latestRevisionOnly" value="<xss:encodeForHTMLAttribute><%=sLatestRevisionOnly%></xss:encodeForHTMLAttribute>" id="latestRevisionOnly" onClick="onSelectLatestRevision(document.forms[0].latestRevisionOnly.checked); return true;">&nbsp;<%=i18nNow.getI18nString("emxIEFDesignCenter.Common.LatestRevOnly", "emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"))%></td>
<%
			}
       //   if (!sAttType.equals("timestamp")) 
            {
%>	
	   
		<td  class="field" >
<%
		//To get the attribute value's  choices
		        StringList sListAttrVal = null;
		        if (sAttType.equalsIgnoreCase("boolean")) 
                {
                	sListAttrVal = null;
			    }
		        else 
                {
			        sListAttrVal  = (StringList)(vectHolder.elementAt(iIndex+1));
		        }

		        if ((sListAttrVal != null) && (sListAttrVal.size() != 0)) 
		        {
			        StringItr sItrObj     = new StringItr(sListAttrVal);
%>
			<select name="<%=XSSUtil.encodeForHTML(context,sAttName)%>"  size="1"><option name="" value="">
<%
		        // 17/12/2003        start    nagesh
				// if the user is coming first time, it will show the default value 
				String sflag="true";
		        // 17/12/2003        End    nagesh 

			        while (sItrObj.next()) 
                    {
				        String sSelect  = "";
				        String sTempStr = sItrObj.obj();
				        if (sTempStr.equals(sOrgVal)) 
                        {
					        sSelect = "selected";
				        }
				        if(sAttName.equals(estimatedCost))
                        {
%>
                <!--XSSOK-->
				<option selected value="<%=sTempStr%>" <%=sSelect%> ><%=sTempStr%></option>
<%				        }
                        else
                        {
					// 17/12/2003        Start    nagesh 
					// In the option write selected
					if (sflag.equals("true"))
					{
						//to show the default value put add "selected" in the option below
				%>							
                    <!--XSSOK-->				
					<option  value="<%=sTempStr%>" <%=sSelect%> ><%= i18nNow.getRangeI18NString(sAttName, sTempStr.trim(), languageStr)%></option>

				<%			
					sflag="false";
					}else 
						{
%>
                    <!--XSSOK-->
					<option value="<%=sTempStr%>" <%=sSelect%> ><%= i18nNow.getRangeI18NString(sAttName, sTempStr.trim(), languageStr)%></option>
<%				   
			        }

				 } //else loop
			    } //while loop close here
				   // 17/12/2003        End    nagesh 

%>
			</select>
<%
		        } 
                else 
                {
%>
			&nbsp;
<%
		        }
%>
		</td> 
<%          }
%>
		</tr>
<%
		}
%>
	    <tr height="10">&nbsp;</tr>
		<%
		if(excludeBasics == null || (!excludeBasics.contains("Keyword")) )
		{
		%>
		<tr>
		<td class="label"><framework:i18n localize="i18nId" >emxIEFDesignCenter.Common.Keyword</framework:i18n></td>
		<!--XSSOK-->
		<td class="field" colspan=3><input type="text" name="txtKeyword"  value="<%=sTxtKeyword%>" ></td>
		</tr>
		<%
		}
		%>

		<%
		if(excludeBasics == null || (!excludeBasics.contains("Format")) )
		{
		%>

		<tr>
			<td class="label"><framework:i18n localize="i18nId" >emxIEFDesignCenter.Common.Format</framework:i18n></td>
			<!--XSSOK-->
			<td  class="field" ><input type="text" name="txtFormat"  value="<%=sTxtFormat%>" ></td>
			<td class="field" colspan=2>
			<select multiple  name="comboFormats" >
			<option  selected value="*">*</option>
<%
			String sFormatName = "";
			FormatItr formatItr   = new FormatItr(Format.getFormats(context));
	        //iterate through and list all the formats
			while (formatItr.next()) 
            {
				sFormatName = (formatItr.obj()).getName();
				String displayName =getFormatI18NString(sFormatName,request.getHeader("Accept-Language"));
%>
                <!--XSSOK-->
				<option value= "<%=sFormatName%>" ><%=displayName%></option>
<%
			}
%>
        </select>
       </td>
     </tr>
	<%
		}
	%>
     
	<!-- IEF Changes Start -->
<%
	if(iefInstanceAttributeNames != null && iefInstanceAttributeNames.size() > 0)
	{
%>
    <!--XSSOK-->
	<tr><td colspan="4" class="label"><%= instanceAttributesHeading %></td></tr>
<%
		for(int i=0; i<iefInstanceAttributeNames.size(); i++)
		{
			String instanceAttributeName = (String)iefInstanceAttributeNames.elementAt(i);
%>
	<tr>
	   <!--XSSOK-->
       <td class="label" ><%=instanceAttributeName%></td>
	   <!--XSSOK-->
       <td class="field"  ><select name="instanceComboDescriptor_<%= instanceAttributeName %>">
       <option name=blank value="*">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option><option name='BeginsWith' value='BeginsWith'>Begins with </option><option name='EndsWith' value='EndsWith'>Ends with </option><option name='Includes' value='Includes'>Includes </option><option name='IsExactly' value='IsExactly'>Is exactly </option></select></td>
	   <!--XSSOK-->
       <td class="field" colspan=2 ><input type="text" name="instance_<%= instanceAttributeName %>"  value=""></td>
    </tr>
<%
		}
	}
%>
  <!-- IEF Changes End -->
	</table>


	<table>
	<tr>
<%
     // 02/10/2003        start    nagesh 
     String sAppendReplace= (String)localHashMap.get("chkAppendReplace");
     if(null == sAppendReplace || "null".equalsIgnoreCase(sAppendReplace) || sAppendReplace.length() == 0) 
		   sAppendReplace = "replace";
	if(sAppendReplace.equals("replace"))
	{
 %>
		<td ><input type="radio" name="chkAppendReplace" value="replace" checked ></td>
		<td ><framework:i18n localize="i18nId">emxIEFDesignCenter.Search.ReplaceObjects</framework:i18n></td>
		<td ><input type="radio" name="chkAppendReplace" value="append" ></td>
    <td ><framework:i18n localize="i18nId">emxIEFDesignCenter.Search.AppendObjects</framework:i18n></td>
 <%
	}
  else
	{
 %>
    <td ><input type="radio" name="chkAppendReplace" value="replace"  ></td>
    <td ><framework:i18n localize="i18nId">emxIEFDesignCenter.Search.ReplaceObjects</framework:i18n></td>
	<td ><input type="radio" name="chkAppendReplace" value="append" checked ></td>
		<td ><framework:i18n localize="i18nId">emxIEFDesignCenter.Search.AppendObjects</framework:i18n></td>
<%
	}
 // 02/10/2003        End    nagesh 
%>

	</tr> 
	</table>
<%
	}
	
%>
</form>
</body>
<%
  } catch (Exception e) {
    String sError = e.getMessage();
%>
	<script language="JavaScript">		
        //XSSOK	
		showError("<%=sError%>");
		window.parent.close();
	</script>
<%
    return;
  }

%>

<!-- content ends here -->
<%@include file= "../emxUICommonEndOfPageInclude.inc" %>
