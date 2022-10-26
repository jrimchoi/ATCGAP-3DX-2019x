<%--  DSCSearchDialogFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoSearchDialogFS.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxInfoSearchDialogFS.jsp $
 ******************  Version 48  *****************
 * User: Rajesh G  Date: 02/15/04    Time: 3:39p
 * Updated in $/InfoCentral/src/infocentral
 * To enable the esc key and key board support
 * 
 * *****************  Version 16  *****************
 * User: Rahulp       Date: 4/02/03    Time: 12:45
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 15  *****************
 * User: Snehalb      Date: 12/13/02   Time: 2:55p
 * Updated in $/InfoCentral/src/infocentral
 * passing help marker as request parameter to pages ahead
 * 
 * *****************  Version 14  *****************
 * User: Sameeru      Date: 02/11/26   Time: 1:11p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 13  *****************
 * User: Mallikr      Date: 11/26/02   Time: 12:41p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 12  *****************
 * User: Mallikr      Date: 11/22/02   Time: 8:32p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 11  *****************
 * User: Sameeru      Date: 02/11/15   Time: 5:19p
 * Updated in $/InfoCentral/src/InfoCentral
 * Correcting Header
 * 
 * ***********************************************
 *
--%>
<%@ page import="com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.*"  %>
<%@ include file = "DSCAppletUtils.inc" %>
<%
  String timestampvalue						  = emxGetParameter(request,"timeStamp");
  String ecoSearchFlag						  = emxGetParameter(request,"ECOSearch");
  String featureName						  = MCADGlobalConfigObject.FEATURE_SEARCH;
  MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData)session.getAttribute("MCADIntegrationSessionDataObject");
  if(integSessionData.isNonIntegrationUser())
  {
	  String errorPage	= "/integrations/emxAppletTimeOutErrorPage.jsp?featureName="+featureName;
%>
	  <jsp:forward page="<%=XSSUtil.encodeForHTML(integSessionData.getClonedContext(session),errorPage)%>" />              
<%
  }
%>
<script language="JavaScript">
	//-- 02/15/2004         Start rajeshg   -->	
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
	//-- 02/15/2004         End  rajeshg   -->
	
function defaultSearch()
{
   if (top.pageControl) top.pageControl.clearArrFormVals();
   var contentURL = '../iefdesigncenter/DSCSearchContentDialog.jsp?findType=AdvancedFind&reviseSearch=false&timeStamp=<%=XSSUtil.encodeForURL(integSessionData.getClonedContext(session),timestampvalue)%>&ecoSearch=<%=XSSUtil.encodeForURL(integSessionData.getClonedContext(session),ecoSearchFlag)%>';
   
   var searchPageFrame = findFrame(top,"searchContent");
   
   if (searchPageFrame == null)
      return false;
   var form = searchPageFrame.document.forms[0];
   /*for (i = 0; form != null && i < form.elements.length; i++)
   {
       contentURL += '&' + form.elements[i].name;
       contentURL += '=' + form.elements[i].value;
   } */
   
   searchPageFrame.location.href=contentURL;
}

function advancedSearch()
{
   if (top.pageControl) top.pageControl.clearArrFormVals();
   var contentURL = '../iefdesigncenter/DSCFindLikeDialog.jsp?findType=FindLike&reviseSearch=false&timeStamp=<%=XSSUtil.encodeForURL(integSessionData.getClonedContext(session),timestampvalue)%>&ecoSearch=<%=XSSUtil.encodeForURL(integSessionData.getClonedContext(session),ecoSearchFlag)%>';
   
   contentURL +='&ComboType=type_Document&typeString=emxTeamCentral.FindLike.Common.Document&objectIcon=iconSmallDocument.gif&page=&searchType=&returnSearchFrameset=';
   
   var searchPageFrame = findFrame(top,"searchContent");
   
   if (searchPageFrame == null)
      return false;
      
   var form = searchPageFrame.document.forms[0];

   searchPageFrame.location.href=contentURL;
}

function findLike()
{
   if (top.pageControl) top.pageControl.clearArrFormVals();
   var contentURL = '../iefdesigncenter/emxInfoFindLikeDialog.jsp?findType=DSCFindLike&reviseSearch=false&timeStamp=<%=XSSUtil.encodeForURL(integSessionData.getClonedContext(session),timestampvalue)%>&';
   
   contentURL +='typeString=emxTeamCentral.FindLike.Common.Document&objectIcon=iconSmallDocument.gif&page=&searchType=&returnSearchFrameset=&ComboType=&ComboDisplayType=';
   
   var searchPageFrame = findFrame(top,"searchContent");
   
   if (searchPageFrame == null)
      return false;
      
   var form = searchPageFrame.document.forms[0];
   
   searchPageFrame.location.href=contentURL;
}

function searchSavedQueries()
{
   var contentURL = './../iefdesigncenter/DSCSearchManage.jsp?header=emxIEFDesignCenter.Common.SavedQueries&program=IEFListSavedQueriesByUser&selection=single&sortColumnName=Name&sortDirection=ascending&sortType=string&pagination=5&targetLocation=content&suiteKey=IEFDesignCenter&savedQueries=true&timeStamp=<%=XSSUtil.encodeForURL(integSessionData.getClonedContext(session),timestampvalue)%>';
   
   contentURL +='&ComboType=type_Document&typeString=emxTeamCentral.FindLike.Common.Document&objectIcon=iconSmallDocument.gif&page=&searchType=&returnSearchFrameset=';
   var searchPageFrame = findFrame(top,"searchContent");
   
   searchPageFrame.location.href=contentURL;
}

</script>
<%@include file= "emxInfoCentralUtils.inc"%>


<%! 
//Method to get default search
public static Map getDefaultSearchMap(String searchName, MapList toolbarItems){
    Map defaultSearchMap = null;
    boolean getFirstCommand = (searchName == null || searchName.trim().length() == 0);
    try{
        for (int i = 0; i < toolbarItems.size(); i++){
            
            HashMap child = (HashMap) toolbarItems.get(i);
    
            if (UIToolbar.isSeparator(child)){
                continue;
            } else if (UIToolbar.isMenu(child)){
                MapList children = UIToolbar.getChildren(child);
                defaultSearchMap = getDefaultSearchMap(searchName, children);
                if(defaultSearchMap != null){
                    break;
                }
            } else {
                if (UIToolbar.isCommand(child)){
                    if (getFirstCommand || searchName.equals(UIToolbar.getName(child))){
                        defaultSearchMap = child;
                        break;
                    }
                }
            }
        }
    }catch(Exception e){
        return null;
    }

    return defaultSearchMap;
}
%>

<%
  // ----------------- Do Not Edit Above ------------------------------
  String sHelpMarker = emxGetParameter(request, "HelpMarker");

  String command       = emxGetParameter(request, "command");
  String sReviseSearch = emxGetParameter(request, "reviseSearch");
  if(sReviseSearch == null || sReviseSearch.equals("null") || sReviseSearch.equals(""))
	sReviseSearch ="";
  if(timestampvalue == null || timestampvalue.equals("null") || timestampvalue.equals(""))
	timestampvalue ="";

  String timeStampParam = "?timeStamp=" + timestampvalue;
  String timeStampParamForSavedQueries = "&timeStampAdvancedSearch=" + timestampvalue;

  String suiteKey = "IEFDesignCenter";
  
  String searchTitle = emxGetParameter(request, "searchTitle");
  String findType = emxGetParameter(request, "findType");
  if ( null == findType )
  {
      findType = "AdvancedFind";
  }

  // Search message - Internationalized
  String searchMessage = "emxIEFDesignCenter.Common.Search";

  // create a search frameset object
  searchFramesetObject fs = new searchFramesetObject();


  // Search Heading - Internationalized
  String searchHeading = "emxFramework.Suites.Display.IEF";

  fs.setDirectory(appDirectory);
  fs.setStringResourceFile("emxIEFDesignCenterStringResource");
  fs.setHelpMarker( sHelpMarker );

  // Setup query limit
  //
  String sQueryLimit = getInfoCentralProperty(application, session, "eServiceInfoCentral", "QueryLimit");
  
  
  if (sQueryLimit == null || sQueryLimit.equals("null") || sQueryLimit.equals(""))
    sQueryLimit = "";
  else {
    Integer integerLimit = new Integer(sQueryLimit);
    int intLimit = integerLimit.intValue();
    fs.setQueryLimit(intLimit);
  }
  
  //
  String roleList = "role_GlobalUser";


  // Get list of searchLinks from properties
  //
  StringList searchLinks = getInfoCentralProperties(application, session, "eServiceInfoCentral", "SearchLinks");
  String linkEntry;
  String linkText;
  String displayString;
  String contentURL;

  // Populate left side of search dialog from properties
 
    //Get requestParameters for searchContent
    StringBuffer queryString = new StringBuffer("");

    Enumeration eNumParameters = emxGetParameterNames(request);
    int paramCounter = 0;
    while( eNumParameters.hasMoreElements() ) {
        String strParamName = (String)eNumParameters.nextElement();
        String strParamValue = emxGetParameter(request, strParamName);
        
        //do not pass url on
        if(!"url".equals(strParamName) && !"showAdvanced".equals(strParamName)){ 
            if(paramCounter > 0){
                queryString.append("&");
            }
            paramCounter++;
            queryString.append(strParamName);
            queryString.append("=");
            queryString.append(strParamValue);
        }
    }
    
    
    if (null != sQueryLimit)
    {
       queryString.append("&QueryLimit=");
       queryString.append(sQueryLimit);
    }

String url = "";
String title = "";
String helpMarker = "";
String helpMarkerSuiteDir = "";
String showAdvanced = emxGetParameter(request, "showAdvanced");
String defaultSearch = emxGetParameter(request, "defaultSearch");
String searchToolbar = emxGetParameter(request, "toolbar");
helpMarker = emxGetParameter(request, "helpMarker");

if (searchToolbar == null || searchToolbar.trim().length() == 0)
{
	searchToolbar = PropertyUtil.getSchemaProperty(context, "menu_DSCSearchTopActionBar");
	queryString.append("&toolbar=");
    queryString.append("DSCSearchTopActionBar");
}

String errMsg = UINavigatorUtil.getI18nString("emxFramework.GlobalSearch.ErrorMsg.NoDefaultSearch",
                                                  "emxFrameworkStringResource", request.getHeader("Accept-Language"));


try{
        ContextUtil.startTransaction(context, false);
        
        
        Vector userRoleList = PersonUtil.getAssignments(context);
        HashMap paramMap = UINavigatorUtil.getRequestParameterMap(request);
        HashMap toolbar = UIToolbar.getToolbar(context,
                                              searchToolbar,
                                              userRoleList,
                                              null,
                                              paramMap,
                                              lStr);
        
        if (toolbar != null){
                MapList children = UIToolbar.getChildren(toolbar);   
                Map searchMap = getDefaultSearchMap(defaultSearch, children);
               
                if (searchMap == null){
                        //throw error
                       // emxNavErrorObject.addMessage("emxSearch: " + errMsg);
                        searchMap = getDefaultSearchMap(null, children);
                }
                if (searchMap != null){
                        url = UIToolbar.getHRef(searchMap,paramMap);
                        title = UIToolbar.getLabel(searchMap);
                        if(helpMarker == null || "".equals(helpMarker)){
                        helpMarker = UIToolbar.getSetting(searchMap, "Help Marker");
                        }
                        String regSuite = UIToolbar.getSetting(searchMap, "Registered Suite");
                        if (regSuite != null)
                        {
                            helpMarkerSuiteDir = UINavigatorUtil.getRegisteredDirectory(regSuite);
                        }
                }
         
                if (url == null || url.trim().length() == 0){
                    //throw error
                    //emxNavErrorObject.addMessage("emxSearch: " + errMsg);
                    url = "../common/emxBlank.jsp";
                }
        }  
        
        if(url != null && queryString.length() > 1){
            url += (url.indexOf("?") == -1 ? "?" : "&") + queryString.toString();
        }
        
        if(showAdvanced == null || "".equals(showAdvanced)){
                showAdvanced = "false";
        }
        
        if(title == null || "".equals(title)){
                title = "";
        }
        
        if (searchTitle != null)
        {
           title = searchTitle;
        }
        
        if(helpMarker == null || "".equals(helpMarker)){
                helpMarker = "";
        }
        
        if(helpMarkerSuiteDir == null || "".equals(helpMarkerSuiteDir)){
                helpMarkerSuiteDir = "common";
        }


}catch (Exception ex){
        ContextUtil.abortTransaction(context);
        
        if(ex.toString() != null && (ex.toString().trim()).length()>0){
                //emxNavErrorObject.addMessage("emxSearch:" + ex.toString().trim());
        }
}
finally{
        ContextUtil.commitTransaction(context);
}

String searchViewURL = "DSCSearchView.jsp";

if(queryString != null && queryString.length() > 1){
    searchViewURL += "?" + queryString.toString();
    
}

String headerURL = "../common/emxSearchHeader.jsp";
String footerURL = "DSCSearchFooterPage.jsp";
if (showAdvanced.equals("true"))
{
    contentURL = "DSCFindLikeDialog.jsp?1=1";
}
else
{
    contentURL = "DSCSearchContentDialog.jsp?1=1";
}
HashMap paramList = (HashMap)session.getAttribute("ParameterList"+timestampvalue);

if (paramList != null)
{
    findType = (String)paramList.get("findType");
    if (findType != null && findType.equals("DSCFindLike"))
        contentURL = "emxInfoFindLikeDialog.jsp?1=1";
    else if (findType != null && findType.equals("FindLike"))
        contentURL = "DSCFindLikeDialog.jsp?1=1";
}

String sFromSavedSearch = emxGetParameter(request, "fromSavedSearch");

if (sFromSavedSearch != null && sFromSavedSearch.equals("true"))
{
   contentURL = "./../iefdesigncenter/DSCSearchManage.jsp?header=emxIEFDesignCenter.Common.SavedQueries&program=IEFListSavedQueriesByUser&selection=single&sortColumnName=Name&sortDirection=ascending&sortType=string&pagination=5&targetLocation=content&suiteKey=IEFDesignCenter&savedQueries=true";
   contentURL +="&ComboType=type_Document&typeString=emxTeamCentral.FindLike.Common.Document&objectIcon=iconSmallDocument.gif&page=&searchType=&returnSearchFrameset=";
}

if (sReviseSearch != null && sReviseSearch.equals("true"))
	queryString.append("&reviseSearch=" + sReviseSearch);

queryString.append("&timeStamp=" + timestampvalue);
queryString.append("&timeStampAdvancedSearch=" + timestampvalue);
queryString.append("&ecoSearch=" + ecoSearchFlag);

if(queryString.length() > 1)
{
	headerURL += "?" + queryString.toString();
	footerURL += "?" + queryString.toString();
	contentURL += "&" + queryString.toString();
	contentURL = escapeJavascript(contentURL);
}
		final String langOnlineStr = langStr;
%>

<html>
    <head>
        <title>Search</title>
        <script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
        <script language="javascript" src="../common/scripts/emxUICore.js"></script>
        <script language="javascript" src="../common/scripts/emxUIModal.js"></script>
        <script language="javascript" src="../common/scripts/emxUIPopups.js"></script>
        <script language="javascript" src="../common/scripts/emxNavigatorHelp.js"></script>
        <script language="javascript" src="../common/scripts/emxJSValidationUtil.js"></script>
		
        <%@ include file="../common/emxSearchConstantsInclude.inc"%>
        <script language="JavaScript" src="../iefdesigncenter/emxInfoUISearch.js"></script>
        <script language="JavaScript">
            //pageControl.setSearchContentURL(encodeURIIfCharacterEncodingUTF8("<%= url %>"));
            pageControl.setHelpMarker("<%= XSSUtil.encodeForJavaScript(context,helpMarker) %>");
            pageControl.setShowingAdvanced(<%= XSSUtil.encodeForJavaScript(context,showAdvanced) %>);
			//XSSOK
            pageControl.setTitle("<%= title %>");
			//XSSOK
            pageControl.setHelpMarkerSuiteDir("<%= helpMarkerSuiteDir %>");
        </script>
        <script>
        function loadContentFrame()
		{
            var searchPageURL = top.pageControl.getSearchContentURL();
            var searchPageFrame = findFrame(this,"searchContent");
            searchPageFrame.location.href = searchPageURL;
        }

		var Limit			= "";
		var Results			= "";
		var QueryTo			= null;
		var QueryResults	= null;
		var framelistFoot = null;
		function loadContent()
		{
			framelistFoot = findFrame(parent,"listFoot");
			if(framelistFoot.document.forms['bottomCommonForm'])
			{
			
			var DesignerSearch    = framelistFoot.document.forms['bottomCommonForm'].DesignerSearch.value;
			var CollectionsSearch = framelistFoot.document.forms['bottomCommonForm'].CollectionsSearch.value;
			if(CollectionsSearch == "true")
			{
				var children = framelistFoot.document.all.length;
				//Change the footer 
				for( i=0;i<children;i++)
				{
					
					if(framelistFoot.document.all[i].name=="FindLink")
					{
						var FindLnk = framelistFoot.document.all[i];
						//FindLnk.textContent = "Done";
						FindLnk.innerHTML ="Done";
						
					}
                    if(framelistFoot.document.all[i].name=="FindImage")
					{
						var FindImage = framelistFoot.document.all[i];
						FindImage.src = "../iefdesigncenter/images/emxUIButtonDone.gif";
						//Hide the text box
						var QueryLimit = framelistFoot.document.forms['bottomCommonForm'].QueryLimit;
						framelistFoot.document.forms['bottomCommonForm'].QueryLimit.style.display="none";
						
					}
					if(framelistFoot.document.all[i].innerHTML=="Limit to")
					{
						QueryTo = framelistFoot.document.all[i];
						Limit = QueryTo.innerHTML;
						QueryTo.innerHTML = "";
					}
					if(framelistFoot.document.all[i].innerHTML=="Results")
					{
						QueryResults = framelistFoot.document.all[i];
						Results = QueryResults.innerHTML;
						QueryResults.innerHTML ="";
					}
				}

				return;
			}
			if(DesignerSearch == "true")
			{
				var children = framelistFoot.document.all.length;
				//Change the footer 
				for( i=0;i<children;i++)
				{
					if(framelistFoot.document.all[i].name=="FindLink")
					{
						var FindLnk = framelistFoot.document.all[i];
						//FindLnk.textContent = "Find";
						FindLnk.innerHTML="Find";
						
					}
                    if(framelistFoot.document.all[i].name=="FindImage")
					{
						var FindImage = framelistFoot.document.all[i];
						FindImage.src = "../iefdesigncenter/images/emxUIButtonNext.gif";
						var QueryLimit = framelistFoot.document.forms['bottomCommonForm'].QueryLimit;
						framelistFoot.document.forms['bottomCommonForm'].QueryLimit.style.display="";
					}
					if(Limit=="Limit to" && QueryTo!=null)
					{
						QueryTo.innerHTML = Limit;
						Limit="";
					}
					if(Results=="Results" && QueryResults!=null)
					{
						QueryResults.innerHTML = Results;
						Results="";
					}
				}
				
				return;
			}
		}
	}
    </script>
    </head>
    <frameset rows="85,*,45,0" framespacing="0" frameborder="no" border="0"> 
          <frame src="<%= headerURL %>" name="searchHead" noresize scrolling="no" marginwidth="10" marginheight="10" frameborder="no">
          <frame src="<%=contentURL%>" name="searchContent" marginwidth="8" marginheight="8" frameborder="no">
          <frame src="<%= footerURL %>" name="searchFoot" noresize scrolling="no" frameborder="no" marginheight="8" marginwidth="8">
          <frame src="emxBlank.jsp" name="searchHidden" id="searchHidden" frameborder="0" scrolling="no"> 
    </frameset>
    <noframes></noframes>
</html>

