<%--  DSCSearchManage.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%-- 

   static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/DSCSearchManage.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>
<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<%@include file = "emxInfoUtils.inc"%> 	
<%@page import ="com.matrixone.apps.domain.util.*" %>

<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>


<% 
    StringList searchList = null;
    String sTimeStamp = (String)Request.getParameter(request,"timeStamp");
    if (null == sTimeStamp) sTimeStamp = "";
try
{
    ContextUtil.startTransaction(context, true);
    
  searchList = UISearch.getSearchObjects(context);


} catch (Exception ex) {
    ContextUtil.abortTransaction(context);
    if (ex.toString() != null && (ex.toString().trim()).length() > 0)
        emxNavErrorObject.addMessage(ex.toString().trim());

} finally {
    ContextUtil.commitTransaction(context);
}

  Iterator searchIterator = searchList.iterator();
  String I18NResourceBundle = "emxIEFDesignCenterStringResource";
  String acceptLanguage = request.getHeader("Accept-Language");
 %>

<html>
   <head>
        <title>Search Manage</title>
        <script type="text/javascript" language="JavaScript" src="../common/scripts/emxUIConstants.js"></script>
        <script type="text/javascript" language="JavaScript" src="../common/scripts/emxUIModal.js"></script>
        <script type="text/javascript" language="JavaScript" src="../common/scripts/emxUIPopups.js"></script>
        <script type="text/javascript" language="JavaScript" src="../common/scripts/emxUICore.js"></script>
        <script type="text/javascript" language="JavaScript" src="../common/scripts/emxUICoreMenu.js"></script>
         <script type="text/javascript" language="JavaScript" src="../iefdesigncenter/emxInfoUISearch.js"></script>
        <script type="text/javascript">
            addStyleSheet("emxUIDefault");
            addStyleSheet("emxUIList");
            addStyleSheet("emxUIMenu");
            <%--  These i18n strings must come before emxUISearchUtils.js --%>
            //i18n strings
            var ConfirmDelete = "<emxUtil:i18nScript localize="i18nId">emxFramework.GlobalSearch.ErrorMsg.ConfirmDelete</emxUtil:i18nScript> \"";
            
            function doSearch(str){
                
                if(typeof str == "string"){
                setSaveName(str);
                }
                
        if(trimWhitespace(top.pageControl.getSavedSearchName()).length==0){
          alert(top.STR_SEARCH_EMPTY_OPTION);
          turnOffProgress();
          return;
        }        
                //set doSubmit =true
                top.pageControl.setDoSubmit(true);
                //get saved search
                top.importSavedSearchXML();
                turnOffProgress();
            }
            
      function trimWhitespace(strString) 
	  {
        if(strString == null || strString == 'undefined') {
          return '';
        } else {
          strString = strString.replace(/^[\s\u3000]*/g, "");
          return strString.replace(/[\s\u3000]+$/g, "");
        }
      }
      
      function doLocalEdit(queryName)
      {
	    
         pageControl = top.pageControl;
         if (null != pageControl)
         {
            top.pageControl.setSavedSearchName(encodeURIIfCharacterEncodingUTF8(encodeSaveSearchName(queryName)));
            var xmlDoc = top.getSavedSearchXML();
         }
         
         xmlDoc = trimWhitespace(xmlDoc);
         if (xmlDoc == null || xmlDoc == '')
         {
             parent.frames["searchContent"].document.location.href = "../iefdesigncenter/DSCModifyQueryDialog.jsp?Advanced=true&TextSearch=true&queryName=" + queryName;
         }
         else
         {
             if (xmlDoc.indexOf('__DesignerCentral__') >= 0)
             {
			     var timeStamp = '<%=XSSUtil.encodeForJavaScript(context,sTimeStamp)%>';
				 var timeStampAdvancedSearch = '<%=XSSUtil.encodeForJavaScript(context,sTimeStamp)%>';
                 top.pageControl.setDoSubmit(true);
                 top.importSavedSearchXML();
                 turnOffProgress();
				
                 url = top.pageControl.getSearchContentURL();
                 if (url == null || url == 'null' || url == 'undefined' || url == '')
                 {
                     return;
                 }
                 var arr = url.split('?');
				
                 if (arr)
                 {
                     var paramArray = arr[1].split('&');
                     var params = '';
                     var findType = '';
                     if (null != paramArray && top && top.pageControl)
		     {
			  for (var i = 0; i < paramArray.length; i++)
			  {
							       var paramName = '';
					               var paramValue = '';
								   var idx = paramArray[i].indexOf('=');
			
					               if (idx >= 0)
				{
					                  paramName = paramArray[i].substring(0, idx);
					                  paramValue = paramArray[i].substr(idx+1);
					               }
								   
					if (paramName == null || paramName == '') 
						continue;
					               if (paramName == 'timeStamp')
					               {
					                   timeStamp = paramValue;
					               }
				                   if (paramName = 'timeStampAdvancedSearch') 
					               {
					                   timeStampAdvancedSearch = paramValue;
				}
			 }

			 if (findType == 'DSCFindLike')
			 {
			      url = arr[0];
			      
			      url += '?';
			      url += params;
			 }
		    }
                 }
			
				 var arrLen = top.pageControl.getArrFormValsLength();
				 var findType = 'AdvanceFind';
				 
				 var queryLimit = '100';
				 var parameters = '';
				 var txtType = '';
				 for(var i = 0; i < arrLen; i++)
				 {
		             var param = top.pageControl.arrFormVals[i][0] + '=' + top.pageControl.arrFormVals[i][1];
					 var paramName = top.pageControl.arrFormVals[i][0];
			         var value = '' + top.pageControl.arrFormVals[i][1];
			         var paramValue = top.pageControl.arrFormVals[i][1];
			         var arr = value.split(',');
                     if (arr && arr != 'undefined' && 'null' != arr && arr.length > 1) 
			         {
                         paramValue = arr[1];
			         }
					 if (paramName == 'findType')
					    findType = paramValue;
					 if (paramName == 'queryLimit')
					    queryLimit = paramValue;
					 if (paramName == 'txtType')
					    txtType = paramValue;
					 if (i > 0) parameters += '{}';
		             parameters += param;
			     }
				 if (findType == 'AdvancedFind')
				    url = '../iefdesigncenter/DSCSearchContentDialog.jsp?';
				 else if (findType == 'FindLike')
				    url = '../iefdesigncenter/DSCFindLikeDialog.jsp?';
				 else if (findType == 'DSCFindLike')
				    url = '../iefdesigncenter/emxInfoFindLikeDialog.jsp?';
				 else
				    url = '../iefdesigncenter/DSCSearchContentDialog.jsp?';
				 url += 'timeStamp=' + timeStamp;
                 url += '&timeStampAdvancedSearch=' + timeStamp;	
                 url += '&queryName=' + queryName;			 
                 var strQueryLimit = parent.frames[2].document.bottomCommonForm.QueryLimit.value;
	         document.emxTableForm.queryLimit.value = strQueryLimit;
				 document.emxTableForm.searchParameters.value = parameters;
                 document.emxTableForm.target='_self';
                 document.emxTableForm.action = url + '&queryName=' + queryName + '&queryLimit=' + queryLimit;
                 parent.frames["searchFoot"].isAbruptClose = false;
                 document.emxTableForm.submit();
             }
             else
             {
                 top.pageControl.setSavedSearchName(queryName);
                 parent.frames[1].document.location.href = "../iefdesigncenter/DSCModifyQueryDialog.jsp?Advanced=true&TextSearch=true&queryName=" + queryName;
             }
         }
      }
      
      function setSavedSearchParameters(queryName)
	  {
	     var parameters			= '';
	     var arrLen = top.pageControl.getArrFormValsLength();

         //add a timestamp to prevent caching
         var timestamp = (new Date()).getTime();
      
         // load the xml file
         for(var i = 0; i < arrLen; i++)
		 {
		    var paramName = top.pageControl.arrFormVals[i][0];
			var paramValue = top.pageControl.arrFormVals[i][1];

			if (paramValue != null && paramValue != 'undefined') /* &&
			    top.pageControl.arrFormVals[i][0].indexOf('txtWhere') >= 0)*/
			    paramValue = decodeURIComponent(paramValue);
			
		    var value = ''+ paramValue;
			if (value != null && value != 'undefined')
			{
			    var arr = value.split(',');
                if (arr && arr != 'undefined' && 'null' != arr && arr.length > 1 && paramName != "txtType" && paramName != "txtVault") 
			    {
                    paramValue = arr[1];
			    }
			}
			var param = paramName + '=' + paramValue;

			if (i > 0) parameters += '{}';
		    parameters += param;
		 }

		 if (queryName)
		 {
		    parameters += '{}queryName=' + queryName;
		 }
		 
		 document.emxTableForm.action = "../iefdesigncenter/DSCSearchExecuteSavedSearch.jsp?timeStampAdvancedSearch=" + "<%=XSSUtil.encodeForURL(context,sTimeStamp)%>";
		 document.emxTableForm.searchParameters.value = parameters;
		 document.emxTableForm.submit();
	  }
   
      function doSearch()
      {
          var strQueryLimit = parent.frames[2].document.bottomCommonForm.QueryLimit.value;
	  document.emxTableForm.queryLimit.value = strQueryLimit;
	  var form = document.forms[0];
	  var queryName = '';
	  for (i = 0; form != null && i < form.elements.length; i++)
          {
               if (form.elements[i].name == 'savedSearchName' &&
                   form.elements[i].checked)
                   queryName = form.elements[i].value;
          } 
		  
	  var url = 'DSCSearchSummaryTable.jsp?page=current';
	  parent.frames["searchFoot"].isAbruptClose = false;
	  document.emxTableForm.target='_parent';
	  document.emxTableForm.action='DSCSearchSummaryTable.jsp?findType=queryFind' +'&timeStamp=' + '<%=XSSUtil.encodeForURL(context,sTimeStamp)%>' + "&queryName=" + queryName;

	  if (null != queryName && 'undefined' != queryName)
	  {
		     top.pageControl.setSavedSearchName(encodeURIIfCharacterEncodingUTF8(encodeSaveSearchName(queryName)));
	         top.importSavedSearchXML();
		     setSavedSearchParameters(queryName);
	  }
      }
      
      function doLocalSearch(queryName)
      {
         
         if (queryName.indexOf('.emx') >= 0)
         {
            doSearch(queryName.substring(4));
         }
         else
         {
            doSearch(queryName);           
         }
      }
      function doLocalDelete(queryName)
      {
         
         if (queryName.indexOf('.emx') >= 0)
         {
            doDelete(queryName.substring(4));
         }
         else
         {
            document.emxTableForm.action='emxInfoDeleteQuery.jsp?emxTableRowId=' + queryName + '&suiteKey=DesignerCentral';
            parent.frames["searchFoot"].isAbruptClose = false;
			if (null != queryName && 'undefined' != queryName)
			{
			   document.emxTableForm.submit();
			}
         }
      }
            
	 function validateSavedSearchQuery()
	 {
		var querySelected = false;
		// Loop through all the radio buttons
		for (counter = 0; counter < document.emxTableForm.savedSearchName.length; counter++)
		{
			// If a radio button has been selected it will return true
			if (document.emxTableForm.savedSearchName[counter].checked)
				querySelected = true; 
		}
		if(!querySelected && document.emxTableForm.savedSearchName.length == null && document.emxTableForm.savedSearchName.checked == true)
		{
			querySelected = true; 
		}

		if (!querySelected)
		{
		<%
			String msg = i18nStringNowUtilLocal("emxIEFDesignCenter.Common.PleaseMakeASelection",I18NResourceBundle,acceptLanguage);
		%>
			// If there were no selections made display an alert box 
			alert("<%=msg%>");
			return false;
		}
		else
			return true;
	 }

	 function disableQueryLimit()
	 {
		 parent.frames['searchFoot'].document.bottomCommonForm.QueryLimit.disabled = true;
	 }
        </script>
       <!-- <script type="text/javascript" language="JavaScript" src="../common/scripts/emxUISearchUtils.js"></script> -->
   </head>
   <body onload="turnOffProgress(); top.setSaveFunctionality(false); disableQueryLimit()">
      <form method="post" name="emxTableForm" onsubmit="doSearch(); return false">

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
//System.out.println("CSRFINJECTION::DSCSearchManage.jsp::form::emxTableForm");
%>

         <table border="0" cellpadding="3" width="100%" id="tblMain" cellspacing="2">
            <thead>
               <tr>
                  <th width="5%" style="text-align:center">
                  </th>
                  <th>
                     <emxUtil:i18n localize="i18nId">emxFramework.GlobalSearch.Name</emxUtil:i18n>
                  </th>
                  <!-- <th style="text-align:center">
                     <emxUtil:i18n localize="i18nId">emxFramework.GlobalSearch.Edit</emxUtil:i18n>
                  </th> -->
                  <th style="text-align:center">
                     <emxUtil:i18n localize="i18nId">emxFramework.GlobalSearch.Delete</emxUtil:i18n>
                  </th>
               </tr>
            </thead>
            <tbody>
<%  
String rowClass = "odd";
int iCounter = 0;
while(searchIterator.hasNext()){ 
        String strVal = (String)searchIterator.next(); 
        if (strVal.startsWith(".emx"))
           continue;
        String queryName = strVal;
		//if (strVal.substring(0, 4).equals(".emx"))
        //   queryName = strVal.substring(4);
        
        if(strVal != null /*&& strVal.length() > 4 && strVal.substring(0,4).equals(".emx")*/){ 
                iCounter++; %>
        <script language="javascript">
          var strValue<%=iCounter%> ="<%= strVal %>";
        </script>                
               <tr class="<%= rowClass %>">
                  <td style="text-align: center; ">
                     <input type="radio" name="savedSearchName" id="savedSearchName" value="<%= queryName %>">
                  </td>
                  <td>
                     <table border="0">
                        <tr>
                           <td valign="top">
                              <img src="../common/images/iconSmallFile.gif" border="0" alt="File">
                           </td>
                           <td>
                              <span class="object"><a href="javascript:doLocalEdit(strValue<%=iCounter%>)"><%= queryName %></a></span>
                           </td>
                        </tr>
                     </table>
                  </td>
                  <!-- <td style="text-align: center; ">
                     <a href="javascript:doLocalEdit(strValue<%=iCounter%>)"><img src="../common/images/iconActionEdit.gif" alt="Edit this Saved Query" border="0"></a> 
                  </td>-->
                  <td style="text-align: center; ">
                     <a href="javascript:doLocalDelete(strValue<%=iCounter%>)"><img src="../common/images/buttonChannelClose.gif" alt="Delete this Saved Query" border="0"></a> 
                  </td>
               </tr>
<%
                rowClass = (rowClass == "odd") ? "even" : "odd";
        }
} 
if(iCounter == 0){
%>
                <tr class="<%= rowClass %>">
                  <td style="text-align: center; " colspan="4">
                     <framework:i18n localize="i18nId">emxIEFDesignCenter.Objects.Common.NoObjectsFound</framework:i18n>
                  </td>
               </tr>
<%
}
%>               
            </tbody>
            <input type=hidden name="findType" value="queryFind">
            <input type=hidden name="queryLimit" value="100">
            <input type=hidden name="program" value="IEFFilterQuery:getList">
            <input type=hidden name="table" value="DSCDefault">
            <input type="hidden" name="pagination" value="10">
			<input type="hidden" name="headerRepeat" value="10">
			<input type="hidden" name="sortColumnName" value="name">
			<input type="hidden" name="sortDirection" value="ascending">
			<input type="hidden" name="selection" value="multiple">
			<input type="hidden" name="topActionbar" value="DSCSearchResultTopActionBar">
			<input type="hidden" name="header" value="Designer">
			<input type="hidden" name="WSTable" value="">
			<input type="hidden" name="objectId" value="">
			<input type="hidden" name="parentOID" value="">
			<input type="hidden" name="targetLocation" value="popup">
			<input type="hidden" name="suiteKey" value="DesignerCentral">
			<input type="hidden" name="searchParameters" value="">
			<% 
                String sErrorMsg = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Error.SearchFailed",request.getHeader("Accept-Language"));
                sErrorMsg = XSSUtil.encodeForURL(sErrorMsg);
            %>
            <input type=hidden name="pagination" value="10">
            <input type=hidden name="expandCheckFlag" value="true">
            <input type=hidden name="appendCheckFlag" value="false">
         </table>
         <input type="image" height="1" width="1" border="0" name="inputImage" src="../common/images/utilSpacer.gif" hidefocus="hidefocus" style="-moz-user-focus: none"/>
      </form>
      <iframe src="emxBlank.jsp" width="0" height="0" scrolling="no" frameborder="0" name="searchManageHidden" id="searchManageHidden"></iframe>
      <%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
   </body>
</html>

