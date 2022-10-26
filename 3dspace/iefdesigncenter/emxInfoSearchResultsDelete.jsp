<%--  emxInfoSearchResultsDelete.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoSearchResultsDelete.jsp $
  $Revision: 1.3.1.7.1.1$
  $Author: ds-unamagiri$


--%>

<%--
 *
 * $History: emxInfoSearchResultsDelete.jsp $
 * 
 * *****************  Version 12  *****************
 * User: Rahulp       Date: 1/15/03    Time: 12:19p
 * Updated in $/InfoCentral/src/infocentral
 * ***********************************************
 *
--%>

<%@include file="emxInfoCentralUtils.inc"%>
<%@include file="../emxUICommonHeaderBeginInclude.inc"%>
<%@include file="../common/emxNavigatorTopErrorInclude.inc"%>
<%-- To enable MQL notice--%>

<%@ page import = "com.matrixone.MCADIntegration.server.*" %>
<%@ page import = "com.matrixone.MCADIntegration.server.beans.*" %>
<%@ page import = "com.matrixone.MCADIntegration.utils.*" %>
<%@ page import = "com.matrixone.apps.domain.util.*" %>
<%@ page import = "matrix.util.*" %>
<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<%@include file = "../common/enoviaCSRFTokenValidation.inc"%>
<jsp:useBean id="domObj" class="com.matrixone.apps.domain.DomainObject"
	scope="page" />

<%
	
	String funcPageName = MCADGlobalConfigObject.PAGE_SEARCH_RESULTS;
	String featureName	= MCADGlobalConfigObject.FEATURE_DELETE;
	
	// get the list of Ids seleccted for deletion
    String[] objectId	= emxGetParameterValues(request,"emxTableRowId");
    String suiteKey		= emxGetParameter(request,"suiteKey");  
    String sQueryLimit	= emxGetParameter(request,"queryLimit");
	String isPortal		= emxGetParameter(request,"isPortal");
	String relName		= emxGetParameter(request,"relationship");
	String sError       = "";
	
	String instanceName = emxGetParameter(request, "instanceName");
	
	if(instanceName != null && !instanceName.equals(""))
		instanceName = MCADUrlUtil.hexDecode(instanceName);
	else
		instanceName = "";

	String targetLocation = emxGetParameter(request,"targetLocation");
	if(targetLocation == null || "".equals(targetLocation))
	targetLocation = "popup";
	StringBuffer paramBuffer = new StringBuffer();
	int j = 0;
	Enumeration enumParamNames = emxGetParameterNames(request);
	while(enumParamNames.hasMoreElements())
	{
		String paramName = (String) enumParamNames.nextElement();
		String paramValue = null;
		if(request.getMethod().equals("POST"))
	    {
			paramValue = (String)emxGetParameter(request, paramName);
	    }
		if (paramValue != null && paramValue.trim().length() > 0 )
		{
			if (j > 0)
			{
			   paramBuffer.append("&");
            }
		    paramBuffer.append(paramName);
		    paramBuffer.append("=");
		    paramBuffer.append(paramValue);
		}
		j++;
	}

	if(objectId != null )
    {
		for(int i=0; i < objectId.length; i++)
		{
			//emxTableRowId value is obtained in the format relID|objectid Or ObjectId. Need to parse the value
			StringList sList = FrameworkUtil.split(objectId[i],"|");

			if(sList.size() == 1 || sList.size() == 2)
				objectId[i] = (String)sList.get(0);

			//Structure Browser value is obtained in the format relID|objectID|parentID|additionalInformation
			else if(sList.size() == 3)
				objectId[i] = (String)sList.get(0);
				
			else if(sList.size() == 4)
				objectId[i] = (String)sList.get(1);
		}
		Context _context = null;
		MCADMxUtil util = null;
	    try
		{
			MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
			
			if(integSessionData != null) 
			{
				_context = integSessionData.getClonedContext(session);
			
				util = new MCADMxUtil(_context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
			}
	   				
				util.setRPEVariablesForIEFOperation(_context,MCADServerSettings.ISDECDelete);
			
				util.deleteDocuments(_context, integSessionData, objectId, false);
				StringList slDeletedList = new StringList();
				for(int iCnt=0; iCnt < objectId.length; iCnt++)
				{						
					
					slDeletedList.addElement(objectId[iCnt]);
				}
				
				String recentlyAccessListEncoded = CacheUtil.getCacheString(context, "RECENTLY_ACCESSED_PARTS");
		        if( null != recentlyAccessListEncoded && !"".equals(recentlyAccessListEncoded))
	        	{	
				String recentlyAccessList				= MCADUrlUtil.decode(recentlyAccessListEncoded); 
				
				
	         	if(null!=recentlyAccessList && !"".equals(recentlyAccessList))
		        {
				
				MapList	mpRecentlyAccessedList			= (MapList) MCADUtil.covertToObject(recentlyAccessList,true,true);				
				
				StringList slPositionsToClear = new StringList();
				for(int p=0;p<mpRecentlyAccessedList.size();p++){
					Map mpEach = (Map) mpRecentlyAccessedList.get(p);
					String sId = (String) mpEach.get("id");
					if(slDeletedList.contains(sId)){
						slPositionsToClear.addElement(Integer.toString(p));
					}
				}
				MapList mpUpdatedRecentlyAccessList = new MapList();
				for(int k=0;k<mpRecentlyAccessedList.size();k++){
					Map mpEach = (Map) mpRecentlyAccessedList.get(k);
					if(!slPositionsToClear.contains(k)){
						mpUpdatedRecentlyAccessList.add(mpEach);
					}
				}
				
				
				String sUpdatedList						= MCADUtil.covertToString(mpUpdatedRecentlyAccessList,true,true);
			    
				sUpdatedList								= MCADUrlUtil.encode(sUpdatedList); 
			        CacheUtil.setCacheObject(context, "RECENTLY_ACCESSED_PARTS", sUpdatedList);
			}
		}
	      
		}
		catch(Exception e)
		{
			// MQL notice enable change start 2/2/2004
			sError = e.getMessage();
			sError = sError.replace('\n',' ');
			sError = sError.replace('\r',' ');
			if(sError.indexOf("Message:") >=0)
			{
   				sError = sError.substring(sError.indexOf("Message:")+8);
   				if(sError.indexOf("Severity:") >=0)
   					sError = sError.substring(0,sError.indexOf("Severity:"));
            }
			// MQL notice enable change end 2/2/2004
%>
 <script language="JavaScript">
            //XSSOK
			alert("<%=sError%>");
</script>		
<%
        }
	finally{

		util.unsetRPEVariablesForIEFOperation(_context,MCADServerSettings.ISDECDelete);
	}
	}
%>
<%@include file="../common/emxNavigatorBottomErrorInclude.inc"%>
<!-- enable MQL notice change -->

<head>
<script language="JavaScript">
    var progressBarCheck = 1;

  function removeProgressBar(){
    progressBarCheck++;
    if (progressBarCheck < 10){
      if (parent.frames[0] && parent.frames[0].document.imgProgress){
        parent.frames[0].document.imgProgress.src = "../common/images/utilSpacer.gif";
      }else{
        setTimeout("removeProgressBar()",500);
      }
    }
    if (parent.frames[1] && parent.frames[1].document.imgProgress){
        parent.frames[1].document.imgProgress.src = "../common/images/utilSpacer.gif";
    }else{
        setTimeout("removeProgressBar()",500);
    }
    return true;
  }

   function reloadURL(params)
   {	   	   
				var href = parent.location.href;
		
		if(href.indexOf("DSCRecentlyAccessedParts:getRecentlyAccessedBusObjectsList") != -1)
		{			
			var regExp		= /integrationName=.*&/;
			var paramArray	= regExp.exec(href);

			if(paramArray != null && paramArray.length > 0)
		    {
				var integrationName		= paramArray[0].substring(paramArray[0].indexOf("=")+1, paramArray[0].length-1);
				
				if(integrationName!=null && integrationName!="")
					parent.location.href	= "../integrations/MCADRecentlyAccessedPartsFS.jsp?integrationName=" + integrationName;
		    }
		}
		else
           parent.location.href = parent.location.href;
   }
		
</script>
<script language="javascript" src="../integrations/scripts/MCADUtilMethods.js"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
</head>
<body>
<form name="frmDeleteResults"  action="emxInfoTable.jsp" method="post" target="_parent">


<input type="hidden" name="header" value="emxIEFDesignCenter.Header.SearchResults">
<input type="hidden" name="topActionbar" value="DSCSearchResultTopActionBar">
<input type="hidden" name="bottomActionbar" value="">
<input type="hidden" name="pagination" value="10">
<input type="hidden" name="selection" value="multiple">
<input type="hidden" name="program" value="IEFFilterQuery:getList">
<input type="hidden" name="table" value="DSCDefault">
<input type="hidden" name="queryName" value=".finder">
<input type="hidden" name="queryLimit" value="<%=sQueryLimit%>">
<input type="hidden" name="suiteKey" value="<%=suiteKey%>">
<input type="hidden" name="targetLocation" value="popup">
<input type="hidden" name="sortDirection" value="descending">
<input type="hidden" name="txtInstanceName" value="<%=instanceName%>">
<input type="hidden" name="funcPageName" value="<%=funcPageName%>">

</form>

<script language="Javascript">
if(parent.window.opener)
{
  var tree = parent.window.opener.top;	
  var sTargetFrame = findFrame(tree, "content");
  var sTargetFrameLocation;
  if(sTargetFrame){
  	sTargetFrameLocation = sTargetFrame.location.href;	  	
  }else{
	//check if the content frame exists 	
	if(parent.window.opener.parent.frames[1].frames[1]){
		sTargetFrame = parent.window.opener.parent.frames[1].frames[1];
		sTargetFrameLocation = sTargetFrame.location.href;		
	}
  }

  if ((sTargetFrame != null)  && (sTargetFrameLocation.indexOf("emxTree.jsp?") != -1)) {    
<%
if(objectId !=null && objectId.length > 0){
	for(int i=0;i<objectId.length;i++) {
%>
      if((sTargetFrameLocation.indexOf("<%=objectId[i].trim()%>") != -1)){      	
        //sTargetFrame was showing the details of this object, so refresh that content page
      	sTargetFrame.document.location.href = "../common/emxNavigatorDefaultContentPage.jsp";
      } // End of if
<%
    } // End of for loop
}
%>
  } // End of if
	else
	{	
		targetFrame = top.findFrame(top,"searchContent");

		if(targetFrame)
		{
			targetFrame.refreshSearchResultPage();
		}
		else
		{			
			if(top.FullSearch && typeof top.FullSearch != "undefined")
			{				
				top.FullSearch.setFieldValues();
				top.FullSearch.submitForm();
			}
			else if(typeof parent.parent != "undefined")
			{				
				parent.parent.location.href = parent.parent.location.href;
			}
		}
	}

} 
else
{	
   // the action comes from menu item for Portal view so there is no dialog displayed
   var targetFrame = top.findFrame(top, "listDisplay");
   if(targetFrame)
	{
//	   var objForm = targetFrame.document.forms['emxTableForm'];
//	   var commandName = (objForm && objForm.commandName) ? objForm.commandName.value : "";
	   refreshMyWorkSpace();
	}
	else
	{
		targetFrame = top.findFrame(top,"searchContent");

		if(targetFrame)
		{
			targetFrame.refreshSearchResultPage();
		}
		else
		{
		var contentWindow = getTopWindow().findFrame(getTopWindow(),"windowShadeFrame").FullSearch;
		if(contentWindow && typeof contentWindow != "undefined")
			{
		        contentWindow.setFieldValues();
		        contentWindow.submitForm();
			}
			else
			{
				var appletReturnHiddenFrame = top.findFrame(top, "appletReturnHiddenFrame");
				if(appletReturnHiddenFrame)
				{
					parent.parent.location.href = parent.parent.location.href;
				} 
				else {
					parent.parent.location.href = parent.parent.location.href;
				}
			}
		}
	}

} 

function refreshMyWorkSpace()
{
   	 var currentTableURL = parent.location.href; 	 

	 //if there is workspace tree on the left side.	
	 if((parent.parent != null) && (findFrame(parent.parent, "detailsDisplay") != null)  && (findFrame(parent.parent, "wsmTree") != null))
	 {
	    var parentLocationURL = parent.parent.location.href;
	    var initialFolderId   = "";
	    try
	    {
	    	initialFolderId   = getParameterFromURL(currentTableURL, "objectId");
	    	parentLocationURL = addParameterToURL(parentLocationURL, "initialFolderId", initialFolderId)
		 	parent.parent.location.href = parentLocationURL;
	    }
	    catch(e)
	    {
			alert(e);
	    }
	 }
    else
    {
	   parent.location.href = currentTableURL;
    }	   	
}

</script>
</body>
</html>
