<%--  DSCFindLikeDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  DSCFindLikeDialog.jsp   - This page allows the user to do advance search of any business type.
 
  static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/DSCFindLikeDialog.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>


<%@ include file	= "../emxUICommonAppInclude.inc"%>
<%@ include file	= "../emxUICommonHeaderBeginInclude.inc" %>
<%@include file		= "../teamcentral/emxTeamCommonUtilAppInclude.inc"%>
<%@ include file	= "../teamcentral/eServiceUtil.inc" %>
<%@include file		= "../common/emxUIConstantsInclude.inc"%>
<%@include file		= "DSCCommonUtils.inc"%>
<%@include file		= "DSCSearchUtils.inc"%>

<%@ page import="com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.beans.*"  %>

<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<%
		//String sTimeStampPassed = getParameter(paramList,request, "timeStamp");
		String sTimeStampPassed = request.getParameter("timeStamp");
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
%>
<%! 
    public String escapeJavascript(String msg)
    {       

        StringBuffer sbuf = new StringBuffer();

        char [] cArray = msg.toCharArray();

        for(int i=0; i<cArray.length; i++)
        {
            char c[] = new char[1];
            c[0] = cArray[i];

            if((new String(c)).equals("\'"))
            {
                sbuf.append("\\");
                sbuf.append(new String(c));
            }
            else if((new String(c)).equals("\\"))
            {
                sbuf.append("\\");
                sbuf.append(new String(c));
            }
            else if((new String(c)).equals("\""))
            {
                sbuf.append("\\");
                sbuf.append(new String(c));
            }
            else
            {
                sbuf.append(new String(c));
            }

        }

        return sbuf.toString();
    }    
    // DSC Changes
%>
<%
	StringBuffer queryString	= new StringBuffer("");
    String sParameters			= "";
    String ResFileId			= "emxFrameworkStringResource";
    HashMap paramList = new HashMap();
    Hashtable stateTable = null;
    
	String STR_SEARCH_RESAVE_FORM_DATA  = UINavigatorUtil.getI18nString("emxFramework.GlobalSearch.ErrorMsg.ReSaveFormData", ResFileId, request.getHeader("Accept-Language"));

    String sTimeStamp = (String)request.getParameter("timeStamp");
    if (sTimeStamp == null) sTimeStamp = "";
    String sQueryName = (String)request.getParameter("queryName");
    String sReviseSearch = emxGetParameter(request, "reviseSearch");
    
    if (sReviseSearch == null || sReviseSearch.equals("null")) sReviseSearch = "";
    
	sQueryName = "";
    if (sReviseSearch != null && sReviseSearch.equals("true"))
    {
		if (null != sTimeStamp && 0 != sTimeStamp.length())
		{
			paramList = (HashMap)session.getAttribute("ParameterList"+sTimeStamp);
		
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

				   if(skey.equals("createdAfter"))
				   {
				      if(value != null && !value.equals("") && !value.equals("*"))
					   {
							value		 = MCADUrlUtil.hexDecode(value);
							createdAfter = value;
							queryString.append(value);
					   }
				   }
				   else if(skey.equals("createdBefore"))
				   {
				      if(value != null && !value.equals("") && !value.equals("*"))
					   {
							value		  = MCADUrlUtil.hexDecode(value);
							createdBefore = value;
							queryString.append(value);
					   }
				   }
				   else
				   {
						queryString.append(getSearchEncodedParamValue(skey, value));
				   }				   
				}
			}
		}

		Enumeration eNumParameters = emxGetParameterNames(request);
		while( eNumParameters.hasMoreElements())
		{
			String strParamName = (String)eNumParameters.nextElement();
			String strParamValue = emxGetParameter(request, strParamName);
		
			//do not pass url on
			if(!"url".equals(strParamName) && !"showAdvanced".equals(strParamName) && !"findType".equals(strParamName))
			{ 
				if(queryString.length() > 0)
				{
					queryString.append("&");
				}
				queryString.append(strParamName);
				queryString.append("=");
				String value = strParamValue;
				queryString.append(getSearchEncodedParamValue(strParamName, value));
                                //queryString.append(value);
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
			 // queryString.append(value);
		   }
		}
		
	}
	sParameters = queryString.toString();
	sParameters = com.matrixone.apps.domain.util.XSSUtil.decodeFromURL(sParameters);
    
	String isRevisionChecked = "";
	if(sReviseSearch != null && sReviseSearch.equals("true"))
	{
		sLatestRevisionOnly = getParameter(paramList, request, "latestRevisionOnly");
	}

	if (sLatestRevisionOnly == null || sLatestRevisionOnly.equals("null") || sLatestRevisionOnly.equals(""))
       sLatestRevisionOnly = "False";

	if(sLatestRevisionOnly != null && sLatestRevisionOnly.equalsIgnoreCase("true"))
	{
		isRevisionChecked = "checked";
	}

	String integrationName	= emxGetParameter(request, "integrationName");
	if (integrationName == null || integrationName.equals(""))
	{
	   integrationName = getDefaultIntegrationName(request, (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject"));
	}
%>
<script language="javascript" type="text/javascript" src="../common/scripts/emxUICalendar.js"></script>
<script language="JavaScript" src="../iefdesigncenter/emxInfoUIModal.js"></script> 
<script language="javascript" src="../iefdesigncenter/emxInfoCentralJavaScriptUtils.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script> <%--Required by emxUIActionbar.js below--%>
<script language="JavaScript" src="../common/scripts/emxUIActionbar.js" type="text/javascript"></script> <%--To show javascript error messages--%>
<script language="JavaScript" src="../common/scripts/emxJSValidationUtil.js" type="text/javascript"></script> <%--To show javascript error messages--%>
<script language="javascript" type="text/javascript" src="../common/scripts/emxUICalendar.js"></script>
<script language="JavaScript" src="../iefdesigncenter/emxInfoUISearch.js" type="text/javascript"></script> <%--To show javascript error messages--%>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>

<jsp:useBean id="emxMenuObject" class="com.matrixone.apps.framework.ui.UIMenu" scope="request"/>
<script language="JavaScript">
    //XSSOK
	var STR_SEARCH_RESAVE_FORM_DATA = "<%= STR_SEARCH_RESAVE_FORM_DATA %>";
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

	// Where clause should be excluded from the quote check
	function badCharExistInFormExcludeWhere(objForm, arrBadChars)
    {
	var badCharExists = false;
	
	//parse the elements one by one
	for (elementCount = 0; elementCount < objForm.elements.length; elementCount++) 
	{
		var element = objForm.elements[elementCount];
		var type = element.type;
		if (type == "text" || type == "textarea")
		{
			var value = element.value;
			if (element.name == 'txtWhereClause1' || element.name == 'txtWhereClauseHidden')
			    continue;
			for (var i=0; i < arrBadChars.length; i++) 
			{
				if (value.indexOf(arrBadChars[i]) > -1) 
				{
					element.focus();
					return true;
				}
			}
		}
	}

	  return false;
    }

	function doFindLike()
	{   
		//first check for bad characters
		var badCharArr = new Array("'","\"","#");
		var badCharExists = badCharExistInFormExcludeWhere(document.findLikeForm, badCharArr);
		if (badCharExists)
		{
			alert("<%=i18nNow.getI18nString("emxIEFDesignCenter.Common.SpecialCharacters", "emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"))%>");
			return;
		}

	    var strQueryLimit = parent.frames[2].document.bottomCommonForm.QueryLimit.value;
		document.findLikeForm.queryLimit.value = strQueryLimit;
	
		parent.frames["searchFoot"].isAbruptClose = false;
		document.findLikeForm.target='_parent';
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
		
		//XSSOK
		var integName			= "<%= integrationName%>";
		var tempCreatedBefore	= document.findLikeForm.createdBefore.value;
		var tempCreatedAfter	= document.findLikeForm.createdAfter.value;
		if(tempCreatedBefore != null && tempCreatedBefore != "" && tempCreatedBefore != "*")
		{
			document.findLikeForm.createdBefore.value = hexEncode(integName, tempCreatedBefore);
		}
		if(tempCreatedAfter != null && tempCreatedAfter != "" && tempCreatedAfter != "*")
		{
			document.findLikeForm.createdAfter.value = hexEncode(integName, tempCreatedAfter);
		}
		document.findLikeForm.action='emxInfoTable.jsp?program=DSCFindLike:getList&table=DSCDefault&findType=FindLike&timeStampAdvancedSearch=<%=XSSUtil.encodeForURL(context,sTimeStampPassed)%>';		
		document.findLikeForm.submit();
	}
	
	function doSearch()
	{
	   doFindLike();
	}
	function doGlobalSelect(objectId,
                        fullPath,
                        applyToChild )
        {
 
                document.findLikeForm.workspaceFolderId.value = objectId;
                document.findLikeForm.WorkspaceFolder.value = fullPath;
        }

	//specify the place to return the string AS A STRING...this cannot be an actual object reference or it will cause an error

	//define the variables required for showing the type chooser
	var strTxtType = "document.forms['findLikeForm'].selType";
	var txtType = null;

	var strTxtTypeDisp = "document.forms['findLikeForm'].txtType";
	var txtTypeDisp = null;

	//can abstracts be selected?
	var bAbstractSelect = true;
	var bMultiSelect = true;
	//define variables required for showing vault chooser
	var bVaultMultiSelect = true;
	var strTxtVault = "document.forms['findLikeForm'].txtVault";
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
<script language="JavaScript">
	function showTextSearch(whetherToShowTextSearch)
	{  
		var strDocumentURL = document.location.href;
        var urlArray = strDocumentURL.split('?');
		if (urlArray)
		{
		    document.findLikeForm.action = urlArray[0] + '?TextSearch=' + whetherToShowTextSearch + '&' +  urlArray[1];
		}
	    else
		{
		    document.findLikeForm.action = strDocumentURL;
		} 
		document.forms['findLikeForm'].TextSearch.value = whetherToShowTextSearch;
		document.findLikeForm.action = strDocumentURL;
		document.findLikeForm.target = "_self";
		document.findLikeForm.submit();
	}

    function checkBox()
	{
	        return true;
	}

        
	function showAdvanced(whetherToShowAdvanced)
	{
	        
		var strDocumentURL			= document.location.href;
		var currentTypeSelection	= document.forms['findLikeForm'].txtType.value;
		document.forms['findLikeForm'].Advanced.value = whetherToShowAdvanced;
                var urlArray = strDocumentURL.split('?');
		if (urlArray)
		{
		    document.findLikeForm.action = urlArray[0] + '?Advanced=' + whetherToShowAdvanced + '&' +  urlArray[1];
		}
		else
		{
		    document.findLikeForm.action = strDocumentURL;
        }
		document.findLikeForm.target = "_self";

		if(currentTypeSelection != null && currentTypeSelection != "" && currentTypeSelection != "null") 
		{
			document.forms['findLikeForm'].selType.value = currentTypeSelection;			
		}
		
		document.findLikeForm.submit();   
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

	function showVaultSelector() 
	{
		var strFeatures = "width=300,height=350,screenX=238,left=238,screenY=135,top=135,resizable=no,scrollbars=auto";
		txt_Vault = eval(strTxtVault);
		var url = "../iefdesigncenter/emxSelectVaultDialog.jsp";
		//var win = window.open(url, "VaultSelector", strFeatures);
		showModalDialog(url, 300, 350, true);
	}
  
	function doGlobalSelect(objectId,
					fullPath,
					applyToChild )
	{

			 document.findLikeForm.workspaceFolderId.value = objectId;
			 document.findLikeForm.WorkspaceFolder.value = fullPath;
	 }
	

	//Function to reload the page
	function reload()
	{
		var varType     = document.findLikeForm.ComboType[document.findLikeForm.ComboType.selectedIndex].value;
		var varRepType  = "";
		var iCount      = 0;
		for (i = 0; i < varType.length; i++) {
		  if (varType[i] == ' ') {
			varRepType += varType.substring(iCount,i) + "%20";
			iCount = i + 1 ;
		  }
		}
		varRepType += varType.substring(iCount,varType.length);
		document.location.href = "emxQuoteFindLikeDialog.jsp?ComboType=" + varRepType;
  }


	//Function to submit the page
	function compose() {
		document.findLikeForm.submit();
	}

	//Function to reset the page with default values.
	function clear()
	{
		for ( varCount = 0; varCount < document.findLikeForm.elements.length; varCount++) {
		  if (document.findLikeForm.elements[varCount].type == "text" && document.findLikeForm.elements[varCount].value != "")  {
			document.findLikeForm.elements[varCount].value = "";
		  }

		  if (document.findLikeForm.elements[varCount].type == "select-one" && document.findLikeForm.elements[varCount].selectedIndex != 0
			&& document.findLikeForm.elements[varCount].name != "ComboType") {
			document.findLikeForm.elements[varCount][0].selected = true;
		  }
		}
	}
function resetFormFields()
{
        pageControl = top.pageControl;
        rebuildForm();
		if  (document.forms[0].latestRevisionOnly.checked)
		{
		   document.forms[0].txt_Revision.disabled = true;
		   document.forms[0].comboDescriptor_Revision.disabled = true;
		   document.forms[0].comboDescriptor_Revision.selectedIndex = -1;
		   document.forms[0].txt_Revision.value = '*';
		   document.forms[0].latestRevisionOnly.value = 'True';
		}
		else
		{
		   document.forms[0].txt_Revision.disabled = false;
		   document.forms[0].comboDescriptor_Revision.disabled = false;
		   document.forms[0].latestRevisionOnly.value = 'False';
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
   }
   else
   {
      document.forms[0].txt_Revision.disabled = false;
	  document.forms[0].comboDescriptor_Revision.disabled = false;
	  document.forms[0].latestRevisionOnly.value = 'False';
   }
}
function goback()
{
   //XSSOK
   var reviseSearch = "<%=sReviseSearch%>";
   
   document.forms['CollapseFindLikeForm'].txtName.value				= document.forms['findLikeForm'].txt_Name.value;	
   document.forms['CollapseFindLikeForm'].txtType.value				= document.forms['findLikeForm'].txtType.value;
   document.forms['CollapseFindLikeForm'].txtRev.value				= document.forms['findLikeForm'].txt_Revision.value;
   document.forms['CollapseFindLikeForm'].state.value					= document.forms['findLikeForm'].state.value;
   document.forms['CollapseFindLikeForm'].displayowner.value			= document.forms['findLikeForm'].txt_Owner.value;
   document.forms['CollapseFindLikeForm'].keywords.value				= document.forms['findLikeForm'].txtKeyword.value;
   document.forms['CollapseFindLikeForm'].txtVault.value				= document.forms['findLikeForm'].txtVault.value;
   document.forms['CollapseFindLikeForm'].WorkspaceFolder.value		= document.forms['findLikeForm'].WorkspaceFolder.value;
   document.forms['CollapseFindLikeForm'].latestRevisionOnly.value	= document.forms['findLikeForm'].latestRevisionOnly.value;
   //XSSOK
   document.forms['CollapseFindLikeForm'].matchCase.value				= "<%=matchCase%>";
   
   //XSSOK
   var integName			= "<%= integrationName%>";
   var tempCreatedBefore	= document.forms['findLikeForm'].createdBefore.value;
   var tempCreatedAfter		= document.forms['findLikeForm'].createdAfter.value;
   if(tempCreatedBefore != null && tempCreatedBefore != "" && tempCreatedBefore != "*")
   {
		document.CollapseFindLikeForm.createdBefore.value = hexEncode(integName, tempCreatedBefore);
   }
   if(tempCreatedAfter != null && tempCreatedAfter != "" && tempCreatedAfter != "*")
   {
		document.CollapseFindLikeForm.createdAfter.value = hexEncode(integName, tempCreatedAfter);
   }

   if (reviseSearch && reviseSearch == 'true') 
   {
      parent.defaultSearch();
   }
   else
   {
      document.CollapseFindLikeForm.submit();
   }
}

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
       contentURL = '../iefdesigncenter/DSCFindLikeDialog.jsp?&findType=AdvancedFind';
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

function clearAll(fieldName) 
{
    if(fieldName =='createdAfter' ) 
	{
      document.findLikeForm.createdAfter.value = "";      
    } 
	else if(fieldName =='createdBefore') 
	{
      document.findLikeForm.createdBefore.value = "";      
    }
	
    return;
}

	
function loadFormFields(params)
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
					var idx = paramArray[i].indexOf('=');
					var paramName = '';
					var paramValue = '';
					if (idx >= 0)
					{
					   paramName = paramArray[i].substring(0, idx);
					   paramValue = paramArray[i].substr(idx+1);
					}
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
					if (paramName.indexOf('txtWhere') >= 0) continue;
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
window.onload=loadFormFields;
</script>
<%@include file = "../emxUICommonHeaderEndInclude.inc" %>

<%
  String languageStr = request.getHeader("Accept-Language");
  String sLink = getParameter(paramList,request,"page");

  // get the current suite properties.

  String sTypeValues = "";
  String sShowHidden = "FALSE";
  String sShowHiddenAttr = "FALSE";

  //To get the Business Type for search
  String sSearchType  = getParameter(paramList,request,"searchType");
  if (sSearchType == null) sSearchType = "";
  String sBizType = getParameter(paramList,request, "ComboType");
 
  String sBizTypeSymbolic = getParameter(paramList,request, "ComboTypeSymbolic");
  if (sBizTypeSymbolic == null || sBizTypeSymbolic.length() == 0)
      sBizTypeSymbolic = sBizType;
  else
      sBizType = sBizTypeSymbolic;

  String returnSearchFrameset = getParameter(paramList,request, "returnSearchFrameset");
  if (returnSearchFrameset != null)
      returnSearchFrameset = java.net.URLEncoder.encode(returnSearchFrameset);
  else
      returnSearchFrameset = "";
  Locale locale = (Locale)request.getLocale();
  // time zone to be used for the date fields
  String timeZone = (String)session.getAttribute("timeZone");
  String countryName = "";
  if (null != locale) {
     countryName = locale.getCountry();
  }
  String objectIconParam = getParameter(paramList,request, "objectIcon");
  String objectIcon = "";
  if ((objectIconParam == null) || ("".equals(objectIconParam))){
    String mappedTypeName = emxMenuObject.getTypeToTreeNameMapping(sBizType);
    if (mappedTypeName != null){
    HashMap menuMap = emxMenuObject.getMenu(context,mappedTypeName );
    objectIcon = emxMenuObject.getSetting(menuMap, "Image");
      if (objectIcon != null){
        objectIcon = UINavigatorUtil.parseImageURL(application, objectIcon , "" );
      }
    }
  }else{
    objectIcon =  "../common/images/" + objectIconParam;
  }


  //get name from symbolic name
  sBizType = Framework.getPropertyValue(session,sBizType);

  if (sBizType == null) {
    sBizType   = "";
  }
  boolean useTitle = false;
  //if(Framework.getPropertyValue(session, "type_Document").equals(sBizType)) {
  //  useTitle = true;
  //}

  String sTypeVal            = "";
  String sTruncVal           = "";


  int iCount = 0;
  BusinessTypeItr btItrObj = null;
  StringList sListType = new StringList();

  //If the TypeNames property value is not set then get all the business types
  if(sTypeValues == null || sTypeValues.trim().equals("")) {

    // Set the show hidden types flag value from the properties.
    boolean bShowHiddenTypes = false;
    if(sShowHidden != null) {
      if(sShowHidden.equals("TRUE")) {
        bShowHiddenTypes = true;
      }
    }

    //To get the business type list from the context
    BusinessTypeList btListObj = BusinessType.getBusinessTypes(context, bShowHiddenTypes);
    // To sort the business type in alphabetical order
    btListObj.sort();
    btItrObj   = new BusinessTypeItr(btListObj);
  }

  String sSelected           = "";
  String preTypeString = getParameter(paramList,request,"typeString");
  String typeString = i18nNow.getI18nString("emxTeamCentralStringResource",preTypeString,languageStr);
  
  // IEF
  
  /* IEF additions Start 
	Reasons: 
	1. To see whether integration is active.
	2. Add code to show a field called InstanceName.
  	*/

	MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
	Context _context							= integSessionData.getClonedContext(session);
	String instanceNameLable	= null;
	Vector iefFamilyTypes		= null;
	if(integSessionData != null)
	{
		iefFamilyTypes	  = integSessionData.getValidFamilyTypes(_context);
		instanceNameLable = integSessionData.getStringResource("mcadIntegration.Server.FieldName.InstanceName");
	}
	/* IEF additions End */
    
    //String strTypeList = "";
    //String integrationsTypeList = "";
    String sKeyPress = "";//" onkeypress=\"javascript:if((event.keyCode == 13) || (event.keyCode == 10) || (event.which == 13) || (event.which == 10)) doSearch()\"";
        
    try {
		
		//String appDirectory = (String)application.getAttribute("eServiceSuiteDesignerCentral.Directory");
		String suiteKey = getParameter(paramList,request, "suiteKey");

		if (sTimeStampPassed == null) sTimeStampPassed = "";
		String sSelType = getParameter(paramList,request, "selType");
		if(null == sSelType || "null".equalsIgnoreCase(sSelType) || sSelType.length() == 0) sSelType = "";

		String sTxtType = getParameter(paramList,request, "txtType");
		if(null == sTxtType || "null".equalsIgnoreCase(sTxtType) || sTxtType.length() == 0) sTxtType = "*";

		String sTxtName = getParameter(paramList,request, "txtName");
		if(null == sTxtName || "null".equalsIgnoreCase(sTxtName) || sTxtName.length() == 0) sTxtName = "*";

		String sTxtRev = getParameter(paramList,request, "txtRev");
		if(null == sTxtRev || "null".equalsIgnoreCase(sTxtRev) || sTxtRev.length() == 0) sTxtRev = "*";

		String sTxtOwner = getParameter(paramList,request, "txtOwner");
		if(null == sTxtOwner || "null".equalsIgnoreCase(sTxtOwner) || sTxtOwner.length() == 0) sTxtOwner = "*";

		String sTxtVault = getParameter(paramList,request, "txtVault");
		if(null == sTxtVault || "null".equalsIgnoreCase(sTxtVault) || sTxtVault.length() == 0) sTxtVault = "*";
		
		String sAdvanced = getParameter(paramList,request, "Advanced");
		if (sAdvanced == null) sAdvanced = "";
		String sTextSearch = getParameter(paramList,request, "TextSearch");
		if (sTextSearch == null) sTextSearch = "";
		String sTxtWorkspace = getParameter(paramList,request, "Workspace");
		String sFolderId = getParameter(paramList,request, "FolderId");
		if (sFolderId == null) sFolderId = "";
		if(sAdvanced == null) sAdvanced = "false";
		if(sTextSearch == null) sTextSearch = "false";
		
		String sTxtWhereClause = getParameter(paramList,request, "txtWhereClause1");
		String sTxtWhereClauseHidden = "*";
		if(null == sTxtWhereClause || "null".equalsIgnoreCase(sTxtWhereClause))
		{
			sTxtWhereClauseHidden = getParameter(paramList,request, "txtWhereClauseHidden");
			if(null == sTxtWhereClauseHidden || "null".equalsIgnoreCase(sTxtWhereClauseHidden) || sTxtWhereClauseHidden.length() == 0 || "*".equalsIgnoreCase(sTxtWhereClauseHidden)){
				sTxtWhereClauseHidden = "*";
				sTxtWhereClause = "*";
		        } 
		        else {
				//sTxtWhereClause = com.matrixone.apps.domain.util.XSSUtil.decodeFromURL(sTxtWhereClauseHidden);
				//sTxtWhereClauseHidden = java.net.URLEncoder.encode(sTxtWhereClause);				
				sTxtWhereClause = sTxtWhereClauseHidden.replace('^','"');
				sTxtWhereClause = sTxtWhereClause.replace('$','\'');
				sTxtWhereClauseHidden = sTxtWhereClause.replace('"','^');				
				sTxtWhereClauseHidden = sTxtWhereClauseHidden.replace('\'','$');	
			}
		} 
		else {				
			//sTxtWhereClauseHidden = java.net.URLEncoder.encode(sTxtWhereClause);				
			sTxtWhereClauseHidden = sTxtWhereClause.replace('"','^');				
			sTxtWhereClauseHidden = sTxtWhereClauseHidden.replace('\'','$');	
		}
		String sChkExpandBox = getParameter(paramList,request, "chkExpandBox");
		String sChkExpandBoxHidden = "";

		String sTxtPattern = getParameter(paramList,request, "txtPattern");
		String sTxtPatternHidden = "*";
		if(null == sTxtPattern || "null".equalsIgnoreCase(sTxtPattern))
		{
			sTxtPatternHidden = getParameter(paramList,request, "txtPatternHidden");
			if(null == sTxtPatternHidden || "null".equalsIgnoreCase(sTxtPatternHidden) || sTxtPatternHidden.length() == 0 || "*".equalsIgnoreCase(sTxtPatternHidden)){
				sTxtPatternHidden = "*";
				sTxtPattern = "*";
			}else{
				//sTxtPattern = com.matrixone.apps.domain.util.XSSUtil.decodeFromURL(sTxtPatternHidden);
				//sTxtPatternHidden = java.net.URLEncoder.encode(sTxtPattern);				
				sTxtPattern = sTxtPatternHidden.replace('^','"');
				sTxtPattern = sTxtPattern.replace('$','\'');
				sTxtPatternHidden = sTxtPattern.replace('"','^');				
				sTxtPatternHidden = sTxtPatternHidden.replace('\'','$');	
			}
		} 
		else 
		{				
			//sTxtPatternHidden = java.net.URLEncoder.encode(sTxtPattern);				
			sTxtPatternHidden = sTxtPattern.replace('"','^');				
			sTxtPatternHidden = sTxtPatternHidden.replace('\'','$');	
		}

		if(null == sChkExpandBox || "null".equalsIgnoreCase(sChkExpandBox)) 
		{
			sChkExpandBox = getParameter(paramList,request, "chkExpandBoxHidden");
			if("true".equals(sChkExpandBox)){
				sChkExpandBoxHidden = "true";
				sChkExpandBox = " checked=\"true\"";				
		        }
		        else{
                           sChkExpandBox="";
			   sChkExpandBoxHidden = "false";
			}
		}
		else if("true".equals(sChkExpandBox)||"on".equals(sChkExpandBox)){
			sChkExpandBoxHidden = "true";
			sChkExpandBox = " checked=\"true\"";
		}else{
			sChkExpandBox="";
		    sChkExpandBoxHidden = "false";
		}

		String[] sSelctedFormats = getParameterValues(paramList, request, "comboFormats");
		String comboFormat = "";		
		if(null != sSelctedFormats){
			for (int i=0;i<sSelctedFormats.length;i++)
			{
				comboFormat+= sSelctedFormats[i];
				if(i!=sSelctedFormats.length-1)
					comboFormat+=",";
			}			
		} else {
			comboFormat = getParameter(paramList,request, "comboFormatsHidden");		
			if(null == comboFormat || "null".equalsIgnoreCase(comboFormat) || comboFormat.length() == 0)
				comboFormat = "";
		}
		

		//get the types to be shown in type chooser from the current GCO
   	        String strTypeList = "type_CADDrawing,type_CADModel";
		//MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
		if(integSessionData != null) 
		{
			 strTypeList = integSessionData.getTypesForTypeChooser(_context);
		}
		
		String integrationsTypeList = "";
        // DSCINC 1200
		Query dotFinderQuery = new Query(".iefdesigncenterFinder");

		dotFinderQuery.open(context);
		integrationsTypeList = dotFinderQuery.getBusinessObjectType();
		if(txtType !=null )
			integrationsTypeList = txtType;
		dotFinderQuery.close(context);
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
					String realName	= PropertyUtil.getSchemaProperty(context, strType);

					if(integrationsTypeList.equals(""))
						integrationsTypeList = realName;
					else
						integrationsTypeList = integrationsTypeList + "," + realName;
				}
			}
		}
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
	iefFamilyTypes["<%= iefFamilyType %>"] = true;
<%
		}
	}
    stateTable = getTypeStates(context, strTypeList);
	if(!stateTable.containsKey("*"))
		stateTable.put("*","");
%>
</script>
<!-- IEF additions End -->


<form name="findLikeForm" method="post" onSubmit="doSearch();return false" >

<%
boolean csrfEnabled = ENOCsrfGuard.isCSRFEnabled(context);
if(csrfEnabled)
{
  Map csrfTokenMap = ENOCsrfGuard.getCSRFTokenMap(context, session);
  String csrfTokenName = (String)csrfTokenMap .get(ENOCsrfGuard.CSRF_TOKEN_NAME);
  String csrfTokenValue = (String)csrfTokenMap.get(csrfTokenName);
%>
  <input type="hidden" name= "<%=ENOCsrfGuard.CSRF_TOKEN_NAME%>" value="<%=csrfTokenName%>" />
  <input type="hidden" name= "<%=csrfTokenName%>" value="<%=csrfTokenValue%>" />
<%
}
//System.out.println("CSRFINJECTION::DSCFindLikeDialog.jsp::form:findLikeForm");
%>


<input type="hidden" name="ComboTypeSymbolic" value="<%=sBizTypeSymbolic%>">
<input type="hidden" name="ComboType" value="<%=sBizType%>">
<input type="hidden" name="TypeString" value="<%=preTypeString%>">
<input type="hidden" name="returnSearchFrameset" value="<%=returnSearchFrameset%>">
<input type="hidden" name="page" value="<%=sLink%>">
<input type="hidden" name="searchType" value="<%=sSearchType%>">
<!-- IEF additions Start -->
<input type=hidden name="txtWhereClause" value="">
<input type=hidden name="Advanced" value="<%=sAdvanced%>">
<input type=hidden name="selType" value="<%=sSelType%>">
<input type=hidden name="findType" value="FindLike">
<input type=hidden name="timeStampAdvancedSearch" value="<%=sTimeStampPassed%>">
<input type=hidden name="timeStamp" value="<%=sTimeStampPassed%>">
<input type=hidden name="queryLimit" value="">
<input type=hidden name="countryName" value="<%=countryName%>">
<input type=hidden name="TextSearch" value="<%=sTextSearch%>">
<input type=hidden name="txtWhereClauseHidden" value="<%=sTxtWhereClauseHidden%>">
<input type=hidden name="chkExpandBoxHidden" value="<%=sChkExpandBoxHidden%>">
<input type=hidden name="txtPatternHidden" value="<%=sTxtPatternHidden%>">
<input type=hidden name="comboFormatsHidden" value="<%=comboFormat%>">
<input type=hidden name="folderId" value="<%=sFolderId%>">
<input type=hidden name="txtRev" value="*">
<input type=hidden name="header" value="emxIEFDesignCenter.Header.SearchResults">
<input type=hidden name="languageStr" value="<%=request.getHeader("Accept-Language")%>">
<input type=hidden name="timeZone" value="<%=timeZone%>">
<input type=hidden name="findType" value="FindLike">
<input type=hidden name="searchID" value="__DesignerCentral__">
<input type=hidden name="suiteKey" value="DesignerCentral">
<input type=hidden name="SuiteDirectory" value="iefdesigncenter">
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
<input type=hidden name="program" value="DSCFindLike:getList">
<input type=hidden name="reviseSearchParameters" value="<%=sParameters%>">
<!-- IEF additions End -->

<table border="0" cellpadding="5" width="100%" >
  
  <tr>
    <td class="label"><%=i18nNow.getBasicI18NString("Type",  languageStr)%></td>
    <td class="inputField">
       <input type=text value="<%=integrationsTypeList%>" size="16" name="txtType" readonly="readonly" <%=sKeyPress%>>
       <input type=button name="btnTypeSelector" value="..." onClick="showTypeSelector('<%=strTypeList%>','true', 'findLikeForm', 'txtType', 'true')";>
    </td>
  </tr>
<%
    //get property for turning on the keyword search
    String keywordSearch = FrameworkProperties.getProperty(context,"emxTeamCentral.KeywordSearch");
    if("ON".equalsIgnoreCase(keywordSearch))
    {
%>
      <tr>
        <td width="150" class="label"><emxUtil:i18n localize="i18nId">emxTeamCentral.FindFiles.Keywords</emxUtil:i18n></td>
        <td class="inputField"><input type="text" name="txtKeyword" id="txtKeyword" value="<%=keywords%>"></td>
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
    <td width="150" class="label"><emxUtil:i18n localize="i18nId">emxTeamCentral.FindFiles.WorkspaceFolder</emxUtil:i18n></td>
    <td class="inputField">
    <input type="text"  value="<%=WorkspaceFolder%>" name="WorkspaceFolder" id="WorkspaceFolder">
    <input type="button" name="butClear" id="" value="..." onclick=selectVal("folder")>&nbsp;</td>
    <input type=hidden name=workspaceFolderId value="">

  </tr>
  <tr>
    <td  class="label"><%=i18nNow.getI18nString("emxTeamCentralStringResource","emxTeamCentral.FindLike.CreatedAfter",languageStr)%></td>
    <td class="inputField" width="380">
      <input type = "text" readonly="readonly" name = "createdAfter" value="<%=createdAfter%>" size="15" >
      <a href="javascript:showCalendar('findLikeForm','createdAfter',document.findLikeForm.createdAfter.value)"><img src="../common/images/iconSmallCalendar.gif" border=0></a>
	  <a href="javascript:clearAll('createdAfter')"><emxUtil:i18n	  localize="i18nId">emxTeamCentral.common.Clear</emxUtil:i18n></a>
    </td>
  </tr>
  <tr>
    <td  class="label"><%=i18nNow.getI18nString("emxTeamCentralStringResource","emxTeamCentral.FindLike.CreatedBefore",languageStr)%></td>
    <td class="inputField" width="380">
      <input type = "text" readonly="readonly" name = "createdBefore" value="<%=createdBefore%>" size="15" >
      <a href="javascript:showCalendar('findLikeForm','createdBefore',document.findLikeForm.createdBefore.value)"><img src="../common/images/iconSmallCalendar.gif" border=0></a>
	  <a href="javascript:clearAll('createdBefore')"><emxUtil:i18n	  localize="i18nId">emxTeamCentral.common.Clear</emxUtil:i18n></a>
    </td>
  </tr>
  <%
    if((null == sAdvanced) || 
       ("null".equalsIgnoreCase(sAdvanced)) || 
       ("".equalsIgnoreCase(sAdvanced)) || 
       ("false".equalsIgnoreCase(sAdvanced))){
  %>
    <tr>
	   <td><a href="javascript:showAdvanced('true')"><%=i18nNow.getI18nString("emxIEFDesignCenter.Common.AdvancedSearch", "emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"))%>&nbsp;<img src="images/iconDescend.gif" border="0"></a></td>
    </tr>
  <%
  }else if("true".equalsIgnoreCase(sAdvanced)){
  %>
    <tr>
    	<td><a href="javascript:showAdvanced('false')"><%=i18nNow.getI18nString("emxIEFDesignCenter.Common.AdvancedSearch", "emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"))%>&nbsp;<img src="images/iconAscend.gif" border="0"></a></td>
    </tr>
    <tr>
     <td id="whereCaption" name="whereCaption" class="label"><%=i18nNow.getI18nString("emxIEFDesignCenter.Common.WhereClause", "emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"))%></td>
     <td id="whereText" name="whereText"  class="inputField"><textarea  name="txtWhereClause1" columns="70" rows="4"><%=com.matrixone.apps.domain.util.XSSUtil.decodeFromURL(sTxtWhereClause)%></textarea></td>
    </tr>
    <tr>
     <td id="expandCaption" name="expandCaption" class="label"><%=i18nNow.getI18nString("emxIEFDesignCenter.Search.Expand", "emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"))%></td>
     <td id="expandCheck" name="expandCheck" class="inputField"><input type="checkbox" name="chkExpandBox" <%=sChkExpandBox%> onclick="javaScript:checkBox();" ></td>
    </tr>
  <%
  }
  %>
  <%
    if((null == sTextSearch) || 
       ("null".equalsIgnoreCase(sTextSearch)) || 
       ("".equalsIgnoreCase(sTextSearch)) || 
       ("false".equalsIgnoreCase(sTextSearch))){
  %>
    <tr>
     <td><a href="javascript:showTextSearch('true')"><%=i18nNow.getI18nString("emxIEFDesignCenter.Search.TextSearch", "emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"))%>&nbsp;<img src="images/iconDescend.gif" border="0"></a></td>
    </tr>
  <%
  }else if("true".equalsIgnoreCase(sTextSearch)){
  %>
    <tr>
     <td><a href="javascript:showTextSearch('false')"><%=i18nNow.getI18nString("emxIEFDesignCenter.Search.TextSearch", "emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"))%>&nbsp;<img src="images/iconAscend.gif" border="0"></a></td>
    </tr>
    <tr>
     <td id="patternCaption" name="patternCaption" class="label"><%=i18nNow.getI18nString("emxIEFDesignCenter.Search.TextPattern", "emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"))%></td>
     <td id="patternText" name="patternText"  class="inputField">
	  <textarea  name="txtPattern" columns="70" rows="4"><%=sTxtPattern%></textarea></td>
    </tr>
    <tr>
      <td id="formatCaption" name="formatCaption" class="label"><%=i18nNow.getI18nString("emxIEFDesignCenter.Common.Format", "emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"))%></td>
       <td id="formatText" name="formatText" class="field" <%=sKeyPress%>>
       	<table border="0" cellspacing="2" cellpadding="0" width="100%" >
       	  <tr><td>
       	   <select multiple name="comboFormats" size=5>
            <%
		String sFormatNameSelected = "";
            	if(comboFormat.indexOf("*") > -1) sFormatNameSelected = " selected";
            %>
            <option value="*" <%=sFormatNameSelected%>>*</option>
            <%
                 String sFormatName = "";
                 FormatItr formatItr   = new FormatItr(matrix.db.Format.getFormats(context));
                 //iterate through and list all the formats
                 while (formatItr.next()) {
                      sFormatName = (formatItr.obj()).getName();
                      String displayName =getFormatI18NString(sFormatName,request.getHeader("Accept-Language"));
                      sFormatNameSelected = "";
                      if(comboFormat.indexOf(sFormatName) > -1) sFormatNameSelected = " selected";
            %>
                       <option value= "<%=sFormatName%>" <%=sFormatNameSelected%>><%=displayName%></option>
            
            <%
                 }
            %>
            </select>
            </td>
            <td>
			(<%=i18nNow.getI18nString("emxIEFDesignCenter.Common.AdvancedSearchFormatTip", "emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"))%>)
	    </td>
	  </tr>
       	</table>
  <% } %>
</table>

<%
  if ((!sBizType.equals(""))) {

    String sTxtKeyword      = getParameter(paramList,request, "txtKeyword");
    String sTxtFormat       = getParameter(paramList,request, "txtFormat");
    String sFormat          = getParameter(paramList,request, "comboFormat");

    if (sFormat == null){
      sFormat = "*";
    }
    if (sTxtFormat == null){
      sTxtFormat = "";
    }
    if (sTxtKeyword == null){
      sTxtKeyword = "";
    }


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

    String sMatrixIncludesTrans     = i18nNow.getI18nString("emxTeamCentralStringResource","emxTeamCentral.FindLike.Includes",languageStr);
    String sMatrixIsExactlyTrans    = i18nNow.getI18nString("emxTeamCentralStringResource","emxTeamCentral.FindLike.IsExactly",languageStr);
    String sMatrixIsNotTrans        = i18nNow.getI18nString("emxTeamCentralStringResource","emxTeamCentral.FindLike.IsNot",languageStr);
    String sMatrixMatchesTrans      = i18nNow.getI18nString("emxTeamCentralStringResource","emxTeamCentral.FindLike.Matches",languageStr);
    String sMatrixBeginsWithTrans   = i18nNow.getI18nString("emxTeamCentralStringResource","emxTeamCentral.FindLike.BeginsWith", languageStr);
    String sMatrixEndsWithTrans     = i18nNow.getI18nString("emxTeamCentralStringResource","emxTeamCentral.FindLike.EndsWith",languageStr);
    String sMatrixEqualsTrans       = i18nNow.getI18nString("emxTeamCentralStringResource","emxTeamCentral.FindLike.Equals",languageStr);
    String sMatrixDoesNotEqualTrans = i18nNow.getI18nString("emxTeamCentralStringResource","emxTeamCentral.FindLike.DoesNotEqual",languageStr);
    String sMatrixIsBetweenTrans    = i18nNow.getI18nString("emxTeamCentralStringResource","emxTeamCentral.FindLike.IsBetween",languageStr);
    String sMatrixIsAtMostTrans     = i18nNow.getI18nString("emxTeamCentralStringResource","emxTeamCentral.FindLike.IsAtMost",languageStr);
    String sMatrixIsAtLeastTrans    = i18nNow.getI18nString("emxTeamCentralStringResource","emxTeamCentral.FindLike.IsAtLeast",languageStr);
    String sMatrixIsMoreThanTrans   = i18nNow.getI18nString("emxTeamCentralStringResource","emxTeamCentral.FindLike.IsMoreThan",languageStr);
    String sMatrixIsLessThanTrans   = i18nNow.getI18nString("emxTeamCentralStringResource","emxTeamCentral.FindLike.IsLessThan",languageStr);
    String sMatrixIsOnTrans         = i18nNow.getI18nString("emxTeamCentralStringResource","emxTeamCentral.FindLike.IsOn",languageStr);
    String sMatrixIsOnOrBeforeTrans = i18nNow.getI18nString("emxTeamCentralStringResource","emxTeamCentral.FindLike.IsOnOrBefore",languageStr);
    String sMatrixIsOnOrAfterTrans  = i18nNow.getI18nString("emxTeamCentralStringResource","emxTeamCentral.FindLike.IsOnOrAfter",languageStr);

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
    Enumeration eNumObj     = emxGetParameterNames(request);
    Vector  vectParamName   = new Vector();
    String sParam           = "";
    if(eNumObj!=null) {
      while (eNumObj.hasMoreElements()) {
        sParam = (String)eNumObj.nextElement();
        vectParamName.add(sParam);
      }
    }
    //To store the Attribute's name,data type and the value.
    Vector vectHolder             = new Vector();
    //To store the Attribute's choices.
    StringList sListAttribute     = null;

    StringBuffer sbStrInclude     = null;
    StringBuffer sbRealInclude    = null;
    StringBuffer sbTimeInclude    = null;
    StringBuffer sbBooleanInclude = null;



    //To find the max length of the options.
    for (int i = 0; i < (sArrayOperator.length)-1; i++) {
      for (int j = i+1;j<sArrayOperator.length; j++) {
        if (sArrayOperator[i].length() < sArrayOperator[j].length()) {
          iMax = sArrayOperator[j].length();
        }
      }
    }

    //To Create fill space to equalize all drop downs for descriptors
    //and add 12 because &nbsp not = to constant #
    iMax = iMax+20;
    while (iIndex != iMax) {
      sFiller += "&nbsp;";
      iIndex++;
    }

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


    if(sShowHiddenAttr == null )  {
      sShowHiddenAttr ="";
    } else if(sShowHiddenAttr.equals("null")) {
      sShowHiddenAttr ="";
    }

    while (attrItrObj.next()) {
      sListAttribute    = new StringList();

      Attribute attrObj = attrItrObj.obj();
      //Store name of the attribute in vector if Attribute is not hidden
      sName             = attrObj.getName();
      if(sShowHiddenAttr.equals("TRUE") || !isAttributeHidden(session, sName)) {
        vectHolder.addElement(sName);
        //To get the attribute choices
        if (attrObj.hasChoices()) {
          sListAttribute  = attrObj.getChoices();
          vectHolder.addElement(sListAttribute);
        } else {
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

    //Get states for the Business Type and add it to the vector
    StringList sListStates = flLikeObj.getStates();

    //To get the list of persons role and Groups
    StringList sListUser      = new StringList();
    StringList sListOwner     = new StringList();

    PersonList personListObj  = matrix.db.Person.getPersons(context, true);
    PersonItr personItrObj    = new PersonItr(personListObj);
    while (personItrObj.next()) {
      sListUser.addElement(personItrObj.obj().toString());
      sListOwner.addElement(personItrObj.obj().toString());
    }
    GroupList groupListObj    = Group.getGroups(context, true);
    GroupItr groupItrObj      = new GroupItr(groupListObj);
    while (groupItrObj.next()) {
      sListUser.addElement(groupItrObj.obj().toString());
      sListOwner.addElement(groupItrObj.obj().toString());
    }
    RoleList roleListObj      = Role.getRoles(context, true);
    RoleItr roleItrObj        = new RoleItr(roleListObj);

    while (roleItrObj.next()) {
      sListOwner.addElement(roleItrObj.obj().toString());
    }

    sListUser.sort();
    sListOwner.sort();

    //To add the Policy basics in the vector to search
    StringList sListPolicy = flLikeObj.getPolicies();
    String objectPolicy = (String)sListPolicy.elementAt(0);

    // get all the vaults into an iterator.
    VaultItr vaultItrObj     = new VaultItr(Vault.getVaults(context, true));
    StringList sListVault    = new StringList();
    while (vaultItrObj.next()) {
      sListVault.addElement((vaultItrObj.obj()).getName());
    }

    //  Create Drop downs for Data types of the Attribute
    sOption             = "<option name=blank value=\"*\">"+sFiller+"</option><option name='";

    //To set options for string data type
    sbStrInclude    = new StringBuffer(sOption);
    sbStrInclude.append(sMatrixBeginsWith + "' value='" + sMatrixBeginsWith + "'>" + sMatrixBeginsWithTrans + " </option>");
    sbStrInclude.append("<option name='" + sMatrixEndsWith + "' value='" + sMatrixEndsWith + "'>" + sMatrixEndsWithTrans + " </option>");
    sbStrInclude.append("<option name='" + sMatrixIncludes + "' value='" + sMatrixIncludes + "'>" + sMatrixIncludesTrans + " </option>");
    sbStrInclude.append("<option name='" + sMatrixIsExactly + "' value='" + sMatrixIsExactly + "'>" + sMatrixIsExactlyTrans + " </option>");
    sbStrInclude.append("<option name='" + sMatrixIsNot + "' value='" + sMatrixIsNot + "'>" + sMatrixIsNotTrans + " </option>");
    sbStrInclude.append("<option name='" + sMatrixMatches + "' value='" + sMatrixMatches + "'>" + sMatrixMatchesTrans + " </option>");

    //To set options for numeric data type
    sbRealInclude   = new StringBuffer(sOption);
    sbRealInclude.append(sMatrixIsAtLeast + "' value='" + sMatrixIsAtLeast + "'>" + sMatrixIsAtLeastTrans + "</option>");
    sbRealInclude.append("<option name='" + sMatrixIsAtMost + "' value='" + sMatrixIsAtMost + "'>" + sMatrixIsAtMostTrans + "</option>");
    sbRealInclude.append("<option name='" + sMatrixDoesNotEqual + "' value='" + sMatrixDoesNotEqual + "'>" + sMatrixDoesNotEqualTrans + "</option>");
    sbRealInclude.append("<option name='" + sMatrixEquals + "' value='" + sMatrixEquals + "'>" + sMatrixEqualsTrans + "</option>");
    sbRealInclude.append("<option name='" + sMatrixIsBetween + "' value='" + sMatrixIsBetween + "'>" + sMatrixIsBetweenTrans + "</option>");
    sbRealInclude.append("<option name='" + sMatrixIsLessThan + "' value='" + sMatrixIsLessThan + "'>" + sMatrixIsLessThanTrans + "</option>");
    sbRealInclude.append("<option name='" + sMatrixIsMoreThan + "' value='" + sMatrixIsMoreThan + "'>" + sMatrixIsMoreThanTrans + "</option>");
    sbRealInclude.append("<option name='" + sMatrixMatches + "' value='" + sMatrixMatches + "'>" + sMatrixMatchesTrans + " </option>");

    //To set options for date/time data type
    sbTimeInclude   = new StringBuffer(sOption);
    sbTimeInclude.append(sMatrixIsOn + "' value='" + sMatrixIsOn + "'>" + sMatrixIsOnTrans + "</option>");
    sbTimeInclude.append("<option name='" + sMatrixIsOnOrBefore + "' value='" + sMatrixIsOnOrBefore + "'>" + sMatrixIsOnOrBeforeTrans + "</option>");
    sbTimeInclude.append("<option name='" + sMatrixIsOnOrAfter + "' value='" + sMatrixIsOnOrAfter + "'>" + sMatrixIsOnOrAfterTrans + "</option>");


    //To set options for boolean data type
    sbBooleanInclude    = new StringBuffer(sOption);
    sbBooleanInclude.append(sMatrixIsExactly + "' value='" + sMatrixIsExactly + "'>" + sMatrixIsExactlyTrans + " </option>");
    sbBooleanInclude.append("<option name='" + sMatrixIsNot + "' value='" + sMatrixIsNot + "'>" + sMatrixIsNotTrans + " </option>");


%>
    &nbsp;
    <table width="100%" cellpadding="3" cellspacing="2" border="0">
      <tr>
        <th ><%=i18nNow.getI18nString("emxTeamCentralStringResource","emxTeamCentral.FindLike.Field",languageStr)%></th>
        <th><%=i18nNow.getI18nString("emxTeamCentralStringResource","emxTeamCentral.FindLike.Operator",languageStr)%></th>
        <th><%=i18nNow.getI18nString("emxTeamCentralStringResource","emxTeamCentral.FindLike.Value",languageStr)%></th>
      </tr>
<%
    if(!useTitle) {
%>
    <tr  class="even" >
      <td  ><%=i18nNow.getBasicI18NString("Name",  sLanguage)%></td>
      <td   ><select name="comboDescriptor_Name">
      <%=sbStrInclude.toString()%></select></td>
      <td   ><input type="text" name="txt_Name"  value="<%=txtName%>"></td>
    </tr>
<%
    }
%>
    <tr  class="odd" >
      <td ><%=i18nNow.getBasicI18NString("Description",  sLanguage)%></td>
      <td   ><select name="comboDescriptor_Description">
      <%=sbStrInclude.toString()%></select></td>
      <td   ><input type="text" name="txt_Description"  value=""></td>
    </tr>
    <tr  class="even" >
      <td ><%=i18nNow.getBasicI18NString("Revision",  sLanguage)%></td>
      <td  ><select name="comboDescriptor_Revision">
      <%=sbStrInclude.toString()%></select></td>
      <td  ><input type="text" name="txt_Revision"  value="<%=txtRev%>">
	  &nbsp;&nbsp;<input type="checkbox" name="latestRevisionOnly" value="<%=sLatestRevisionOnly%>" id="latestRevisionOnly" onClick="onSelectLatestRevision(document.forms[0].latestRevisionOnly.checked); return true;" <%=isRevisionChecked%> >&nbsp;<%=i18nNow.getI18nString("emxIEFDesignCenter.Common.LatestRevOnly", "emxIEFDesignCenterStringResource", request.getHeader("Accept-Language"))%>
	  </td>
    </tr>
    <tr  class="odd" >
      <td  ><%=i18nNow.getBasicI18NString("Owner",  sLanguage)%></td>
      <td  ><select name="comboDescriptor_Owner">
      <%=sbStrInclude.toString()%></select></td>
      <td  ><input type="text" name="txt_Owner"  value="<%=displayowner%>"></td>
    </tr>
<%
    //show Current option only if there are more than 1 state
    if(sListStates.size() > 1)
    {
%>
    <tr  class="even" >
      <td ><%=i18nNow.getBasicI18NString("Current",  sLanguage)%></td>
      <td ><select name="comboDescriptor_Current">
      <%=sbStrInclude.toString()%></select></td>
      <td ><select name="Current">
      <option value=""></option>
<%
       for (int i=0;i<sListStates.size();i++){
%>
       <option value="<%=(String)sListStates.elementAt(i)%>"><%=i18nNow.getStateI18NString(objectPolicy,(String)sListStates.elementAt(i),sLanguage)%></option>

<%
       }
%>
      </select></td>
    </tr>
<%
    }
    String sAttName    = "";
    String sAttType    = "";
    String rowClass = "odd";

    for (iIndex = 0; iIndex < vectHolder.size(); iIndex = iIndex+3) {
      sAttName = (String) vectHolder.elementAt(iIndex);
      String sCombovalue  = "comboDescriptor_"+sAttName;
      String sTxtvalue    = "txt_"+sAttName;
      String sTxtOrgVal   = "";
      String sComboOrgval = "";
      String sOrgVal      = "";

      if (vectParamName.contains(sTxtvalue)) {
        sTxtOrgVal=getParameter(paramList,request, sTxtvalue);
      }
      if (vectParamName.contains(sCombovalue)) {
        sComboOrgval=getParameter(paramList,request, sCombovalue);
      }
      if (vectParamName.contains(sAttName)) {
        sOrgVal=getParameter(paramList,request, sAttName);
      }

      String i18nAttName = "";
      //if type is Document, dont show Title, instead show Title
      if(sAttName.equals(Framework.getPropertyValue(session, "attribute_Title")) && (useTitle)) {
        i18nAttName = i18nNow.getBasicI18NString("Name", sLanguage);
      } else {
        i18nAttName = i18nNow.getAttributeI18NString(sAttName, sLanguage);
      }
%>
      <tr class="<%=rowClass%>" >
        <td ><%=i18nAttName%>&nbsp;</td>
<%
  String sComboName  = "comboDescriptor_"+sAttName;
  String sAttDisplay = "";
  sAttType = (String)vectHolder.elementAt(iIndex+2);
  if (sAttType.equals("timestamp")) {
    sAttDisplay = sAttName.replace(' ','_');
    sComboName  = "comboDescriptor_"+sAttDisplay;
  }

%>
        <td  align="left"><select name="<%=sComboName%>" size="1">
<%

      if (sAttType.equals("string")) {
        if (sComboOrgval.length() > 2) {
          StringBuffer sbSelect = new StringBuffer(sbStrInclude.toString());
          int ilength           = sbSelect.toString().indexOf(sComboOrgval);
          int iClength          = sComboOrgval.length();
          int iActlen           = ilength + 10+2*iClength;

          sbSelect.insert(iActlen," selected");
%>
          <%=sbSelect%></select></td>
<%
         } else {
%>
          <%=sbStrInclude%></select></td>
<%      }
      } else if ((sAttType.equals("real")) || (sAttType.equals("integer")) ) {
        if (sComboOrgval.length() > 2) {
          StringBuffer sbSelect = new StringBuffer(sbRealInclude.toString());
          int ilength           = sbSelect.toString().indexOf(sComboOrgval);
          int iClength          = sComboOrgval.length();
          int iActlen           = ilength + 10+2*iClength;

          sbSelect.insert(iActlen," selected");

%>
          <%=sbSelect%></select></td>
<%
        } else {
%>
          <%=sbRealInclude%></select></td>
<%
        }
      } else if (sAttType.equals("timestamp")) {
        String sAttValue = "";
        if (sComboOrgval.length() > 2) {
          StringBuffer sbSelect = new StringBuffer(sbTimeInclude.toString());
          int ilength           = sbSelect.toString().indexOf(sComboOrgval);
          int iClength          = sComboOrgval.length();
          int iActlen           = ilength + 10+2*iClength;

          sbSelect.insert(iActlen," selected");

%>
          <%=sbSelect%></select></td>
<%
        } else {

%>
          <%=sbTimeInclude%></select></td>
<%
        }

        if (getParameter(paramList,request, sAttName)!= null) {
          sAttValue = getParameter(paramList,request, sAttName);
        }

%>
        <td  nowrap align="left"  class="field" ><input type="text"  name="<%=sAttDisplay%>"   value="<%=sAttValue%>" >&nbsp;&nbsp;<a href="javascript:showCalendar('findLikeForm','<%=sAttDisplay%>','<%=sAttValue%>');"><img src="../common/images/iconSmallCalendar.gif" border=0></a></td>
<%
      } else if (sAttType.equals("boolean")) {
        if (sComboOrgval.length() > 2) {
          StringBuffer sbSelect = new StringBuffer(sbBooleanInclude.toString());
          int ilength           = sbSelect.toString().indexOf(sComboOrgval);
          int iClength          = sComboOrgval.length();
          int iActlen           = ilength + 10+2*iClength;

          sbSelect.insert(iActlen," selected");

%>
          <%=sbSelect%></select></td>
<%
        } else {
%>
          <%=sbBooleanInclude%></select></td>
<%
        }


      }

      //To get the attribute value's  choices
      StringList sListAttrVal = (StringList)(vectHolder.elementAt(iIndex+1));
      if ((sListAttrVal != null) && (sListAttrVal.size() != 0)) {
        StringItr sItrObj     = new StringItr(sListAttrVal);
%>
      <td>
        <select name="<%=sAttName%>"  size="1"><option name="" value="">
<%
        while (sItrObj.next()) {
          String sSelect  = "";
          String sTempStr = sItrObj.obj();
          String sRange  = i18nNow.getRangeI18NString( sAttName,sTempStr,request.getHeader("Accept-Language"));
          if (sTempStr.equals(sOrgVal)) {
            sSelect = "selected";
          }
%>
          <option value="<%=sTempStr%>" <%=sSelect%> ><%=sRange%></option>
<%
        }
%>
        </select>
      </td>
<%
      } else {

        if (!sAttType.equals("timestamp")) {
%>
          <td align="left"  ><input type="text"  name="txt_<%=sAttName%>"   value="<%=sTxtOrgVal%>"></td>
<%
        }
      }
%>
    </tr>
<%
      //swap row class
      if (rowClass.equals("odd")){
        rowClass = "even";
      }else{
        rowClass = "odd";
      }
    }
%>
  <!--   <tr class="<%=rowClass%>" >
      <td ><emxUtil:i18n localize="i18nId" >emxTeamCentral.FindLike.Keyword</emxUtil:i18n></td>
      <td colspan="2"><input type="text" name="txtKeyword"  value="<%=sTxtKeyword%>"></td>
    </tr>
    -->
<%
  String showAssociatedObjects = FrameworkProperties.getProperty(context,"eServiceSupplierCentral.RelatedObjects.Use");


  if (showAssociatedObjects != null && !"".equals(showAssociatedObjects) && "true".equalsIgnoreCase(showAssociatedObjects)){
    //swap row class again
    if (rowClass.equals("odd")){
      rowClass = "even";
    }else{
      rowClass = "odd";
    }

%>
    <tr>
      <th colspan="3" align="center" ><emxUtil:i18n localize="i18nId" >emxTeamCentral.FindLike.AssociatedObjects</emxUtil:i18n></th>
    </tr>
<%
  //this code approaches 2k limit on url's. We need a better way to post data. Possibly a form that gets 'Posted'
  String appprop = FrameworkProperties.getProperty(context,"eServiceSupplierCentral.RelatedObjects." + sBizTypeSymbolic);
  
    if (appprop != null && !"".equals(appprop) && !"null".equals(appprop)){
      StringTokenizer st = new StringTokenizer(appprop,",");
      String symbolicType = "";
      String assocSymbolicType = "";
      while (st.hasMoreTokens()) {
        symbolicType = st.nextToken().trim();
        assocSymbolicType = symbolicType;
        //get framework representation of string
        symbolicType = Framework.getPropertyValue(session,symbolicType);
        //test if not null or "", if so may be an incorrectly entered type or unknown type
        if (symbolicType != null && !"".equals(symbolicType) && !"null".equals(symbolicType)){
          //get translated version of string
          symbolicType = i18nNow.getTypeI18NString(symbolicType,languageStr);
%>
        <tr class="<%=rowClass%>" >
          <td ><%=symbolicType%></td>
          <td ><emxUtil:i18n localize="i18nId" >emxTeamCentral.FindLike.Name</emxUtil:i18n></td>
          <td  ><select name="comboDescriptorName_<%=assocSymbolicType%>"><%=sbStrInclude.toString()%></select></td>
          <td  ><input type="text" name="assocTypeName_<%=assocSymbolicType%>"  value=""></td>
        </tr>
<%
        if (rowClass.equals("odd")){
          rowClass = "even";
        }else{
          rowClass = "odd";
        }
%>
        <tr class="<%=rowClass%>" >
          <td ><%=symbolicType%></td>
          <td ><emxUtil:i18n localize="i18nId" >emxTeamCentral.FindLike.Description</emxUtil:i18n></td>
          <td ><select name="comboDescriptorDes_<%=assocSymbolicType%>"><%=sbStrInclude.toString()%></select></td>
          <td ><input type="text" name="assocTypeDes_<%=assocSymbolicType%>"  value=""></td>
        </tr>
<%
        }
        if (rowClass.equals("odd")){
          rowClass = "even";
        }else{
          rowClass = "odd";
        }
      }
    }
  }
%>

<%--   --%>
    <tr>
      <td colspan=4 align=center>
        <input type=radio name="andOrParam" value="and" checked><emxUtil:i18n localize="i18nId">emxTeamCentral.FindLike.And</emxUtil:i18n>
        <input type=radio name="andOrParam" value="or" ><emxUtil:i18n localize="i18nId">emxTeamCentral.FindLike.Or</emxUtil:i18n>
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
   <tr>
     <td><input type=hidden name="QueryLimit" value="100"></td>
     <td>&nbsp;</td>
     <td>&nbsp;</td>
     <td>&nbsp;</td>
   </tr>
  </table>
<%
  }
%>

<input type="image" height="1" width="1" border="0" />
</form>

<form name="CollapseFindLikeForm" id="CollapseFindLikeForm" method="post" action="../iefdesigncenter/DSCSearchContentDialog.jsp">

<%
boolean csrfEnabled1 = ENOCsrfGuard.isCSRFEnabled(context);
if(csrfEnabled)
{
  Map csrfTokenMap1 = ENOCsrfGuard.getCSRFTokenMap(context, session);
  String csrfTokenName1 = (String)csrfTokenMap1 .get(ENOCsrfGuard.CSRF_TOKEN_NAME);
  String csrfTokenValue1 = (String)csrfTokenMap1.get(csrfTokenName1);
%>
  <input type="hidden" name= "<%=ENOCsrfGuard.CSRF_TOKEN_NAME%>" value="<%=csrfTokenName1%>" />
  <input type="hidden" name= "<%=csrfTokenName1%>" value="<%=csrfTokenValue1%>" />
<%
}
//System.out.println("CSRFINJECTION::DSCFindLikeDialog.jsp:form::CollapseFindLikeForm");
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
<input type=hidden name="latestRevisionOnly" value="">
<input type=hidden name="matchCase" value="">

</form>

&nbsp;<a href="javascript:goback()" ><img src="../common/images/utilSearchMinus.gif" border="0" align="absmiddle" ></a>&nbsp;<a href="javascript:goback()" ><%=i18nNow.getI18nString("emxIEFDesignCenterStringResource","emxIEFDesignCenter.FindLike.Less",request.getHeader("Accept-Language"))%></a>&nbsp;
<%
  } catch (Exception e) {
    String sError = e.getMessage();
%>
	<script language="JavaScript">		
		showError("<%=sError%>");
		window.parent.close();
	</script>
<%
    return;
  }

%>
<!-- content ends here -->
<%@include file = "../emxUICommonEndOfPageInclude.inc" %>

<%!

  //Helper Method to check wether the Attribue is hidden.
  static public boolean isAttributeHidden(HttpSession session, String sAttrName) {

     //matrix.db.Context context = Framework.getContext(session);
     matrix.db.Context context = null;
     try{
       context = Framework.getFrameContext(session);
     }catch(Exception e)
     {
     }

     matrix.db.MQLCommand mqlCmd = new MQLCommand();
     String sResult ="";
     try {
        mqlCmd.open(context);
        mqlCmd.executeCommand(context, "print attribute $1 select $2 dump $3",sAttrName,"hidden","|");
        sResult = mqlCmd.getResult();
        mqlCmd.close(context);
      } catch(Exception exp) {
      }

      if(sResult.trim().equalsIgnoreCase("TRUE")) {
        return true;
      } else {
        return false;
      }
  }
%>


<!-- /////////////////////////  -->
