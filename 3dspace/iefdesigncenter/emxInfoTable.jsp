<%--  emxInfoTable.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoTable.jsp $
--%>

<%--
 *
 * $History: emxInfoTable.jsp $
 *
 * *****************  Version 50  *****************
 * User: Rahulp       Date: 31/01/03   Time: 17:43
 * Updated in $/InfoCentral/src/infocentral
 *
 * ***********************************************
 *
--%>



<!-- IEF imports Start -->
<%@ page import = "com.matrixone.MCADIntegration.server.beans.*, com.matrixone.MCADIntegration.utils.*, com.matrixone.MCADIntegration.server.*" %>
<!-- IEF imports End -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">


<html>

<%@include file="emxInfoCentralUtils.inc"%>
<%@include file="../emxTagLibInclude.inc"%>
<%@include file = "emxInfoTableInclude.inc"%>
<%@include file="../emxUICommonHeaderBeginInclude.inc"%>

<jsp:useBean id="emxNavErrorObject" class="com.matrixone.apps.domain.util.FrameworkException" scope="request"/>
<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script> <%--Required for findFrame() function--%>
<script language="JavaScript" src="emxInfoUIModal.js"></script>
<script language="JavaScript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>

 <%@include file = "../common/enoviaCSRFTokenValidation.inc"%>
<%!
public static MapList unionMapList( MapList firstMapList , MapList anotherMapList )
{

	MapList  union = new MapList();
	// if both maplists are empty return empty maplist
	if ( ( (firstMapList == null || firstMapList.size() == 0 ) ) &&
		( (anotherMapList == null || anotherMapList.size() == 0 ) ) )
		 return union;
	// if first maplist is empty, return second maplist as it is
	if (firstMapList == null || firstMapList.size() == 0 )
		return anotherMapList;
	// if second  maplist is empty, return second maplist as it is
	if (anotherMapList == null || anotherMapList.size() == 0 )
		return firstMapList;

	// Iterate through both the map-lists & construct the union in the second maplist
	union.addAll( anotherMapList );
	for( int i = 0 ; i < firstMapList.size() ; i++ )
	{
		HashMap curMap = (HashMap) firstMapList.get(i);
		String objectId = (String) curMap.get("id");
		if( !belongsTo( objectId , union ) )
               {
			union.add( curMap );

	       }

        }
	return union;
}
%>

<%!
public static boolean belongsTo( String objectId , MapList union )

{
	for( int i = 0 ; i < union.size() ; i++ )
	{
		HashMap curMap = (HashMap) getHashMap(union.get(i));
		String curObjectId = (String) curMap.get("id");
		if( curObjectId.equalsIgnoreCase( objectId ) )
		{
		   return true;
		}
	}
	return false;
}

public boolean isInstanceNameMatchedWithPattern(String instanceName, String instanceNamePattern, boolean isSystemCaseSensitive)
{
	boolean isInstanceNamePatternMatched = false;

	if(!instanceNamePattern.equals("*"))
	{
		StringTokenizer instanceNamePatternElements = new StringTokenizer(instanceNamePattern, ",");
		while(instanceNamePatternElements.hasMoreTokens())
		{
			String instanceNamePatternElement = instanceNamePatternElements.nextToken();
			if(isMatches(instanceName, instanceNamePatternElement, isSystemCaseSensitive))
			{
				isInstanceNamePatternMatched = true;
				break;
			}
		}
	}
	else
	{
		isInstanceNamePatternMatched = true;
	}

	return isInstanceNamePatternMatched;
}

public boolean isMatches(String instanceName, String instanceNamePattern, boolean isSystemCaseSensitive)
{
	int currentIndex = 0;

	if(!isSystemCaseSensitive)
	{
		instanceName		= instanceName.toLowerCase();
		instanceNamePattern = instanceNamePattern.toLowerCase();
	}

    for(int n = 0; n < instanceNamePattern.length(); n++)
    {
        char patternChar = instanceNamePattern.charAt(n);
        if(patternChar == '*')
        {
			//if last char is *
            if(n == instanceNamePattern.length()-1)//last char is *
                return true;

			//if consequtive char is *
            if(instanceNamePattern.charAt(n+1) == '*')
                continue;

			int matchedIndex = instanceName.indexOf(instanceNamePattern.charAt(++n), currentIndex);

            if(matchedIndex < 0)
                return false;
            else
                currentIndex = matchedIndex + 1;
        }
        else if(patternChar == '?')
			currentIndex ++;
        else if(instanceName.length() > currentIndex && patternChar == instanceName.charAt(currentIndex))
	        currentIndex ++;
        else
			return false;
    }

    if(currentIndex < instanceName.length())
        return false;

    return true;
}

public HashMap unionInstMap(HashMap oldInstHashMap, HashMap instHashMap)
{
	//If both maplists are empty return empty maplist
	if ( ( (oldInstHashMap == null || oldInstHashMap.size() == 0 ) ) &&
		( (instHashMap == null || instHashMap.size() == 0 ) ) )
		 return new HashMap();

	//If first maplist is empty, return second maplist as it is
	if (oldInstHashMap == null || oldInstHashMap.size() == 0 )
		return instHashMap;

	//If second  maplist is empty, return second maplist as it is
	if (instHashMap == null || instHashMap.size() == 0 )
		return oldInstHashMap;

    Iterator iteratorElement = instHashMap.keySet().iterator();
    while(iteratorElement.hasNext())
    {
        String id = (String)iteratorElement.next();
        if(oldInstHashMap.containsKey(id))
        {
            String unionInstances=(String)oldInstHashMap.get(id);

            String newInsts=(String)instHashMap.get(id);
            StringTokenizer strTok = new StringTokenizer(newInsts, "|");
	        while(strTok.hasMoreTokens())
            {
                String newInst = strTok.nextToken();
                if(unionInstances.indexOf("|" + newInst + "|") < 0)
                    unionInstances += newInst + "|";
            }

            oldInstHashMap.put(id, unionInstances);
        }
        else
            oldInstHashMap.put(id, instHashMap.get(id));
    }

    return oldInstHashMap;
}

%>

<%
String acceptLanguage		= request.getHeader("Accept-Language");

MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute(MCADServerSettings.MCAD_INTEGRATION_SESSION_DATA_OBJECT);

String errorMessage			 = "";

MCADServerResourceBundle serverResourceBundle = new MCADServerResourceBundle(acceptLanguage);
Context IEFContext							  = null;
MCADMxUtil util								  = null;
IEFConfigUIUtil iefConfigUIUtil               = null;

if(integSessionData == null)
	errorMessage		= serverResourceBundle.getString("mcadIntegration.Server.Message.ServerFailedToRespondSessionTimedOut");
else
{
	IEFContext                          = integSessionData.getClonedContext(session);
	util								= new MCADMxUtil(IEFContext, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());

}

String newSearch			 = "false";
String objectId              = emxGetParameter(request, "objectId");
String pagination            = emxGetParameter(request, "pagination");
String inquiryList           = emxGetParameter(request, "inquiry");
String programList           = emxGetParameter(request, "program");
String selectedFilter        = emxGetParameter(request, "selectedFilter");
String relatedPage           = emxGetParameter(request, "RelatedPage");
String relationFilterProgram = emxGetParameter(request, "relationFilterProgram");
String sRelDirection         = emxGetParameter(request, "sRelDirection");
String sRelationName         = emxGetParameter(request, "sRelationName");
String header                = emxGetParameter(request, "header");
String relId                 = emxGetParameter(request, "relId");
String sHelpMarker           = emxGetParameter(request, "HelpMarker");
String suiteKey              = emxGetParameter(request, "suiteKey");
String inquiryLabel          = emxGetParameter(request, "inquiryLabel");
String programLabel          = emxGetParameter(request, "programLabel");
String sActionBarName        = emxGetParameter(request, "topActionbar");
String tipPage               = emxGetParameter(request, "TipPage");
String printerFriendly       = emxGetParameter(request, "PrinterFriendly");
String sTableName            = emxGetParameter(request, "WSTable");
String sWorkSpaceFilterName  = emxGetParameter(request, "WorkSpaceFilter");
String isTemplateType		 = emxGetParameter(request, "isTemplateType");
String summarySelection      = emxGetParameter(request, "selection");
String sortColumnName        = emxGetParameter(request, "sortColumnName");
String displayMode           = emxGetParameter(request, "displayMode");
String bottomActionbar       = emxGetParameter(request, "bottomActionbar");
String sortDirection         = emxGetParameter(request, "sortDirection");
String tableName             = emxGetParameter(request, "table");
String sPage                 = emxGetParameter(request, "page");
String jsTreeID              = emxGetParameter(request, "jsTreeID");
String selection             = emxGetParameter(request, "selection");
String helpMarker            = emxGetParameter(request, "HelpMarker");
String suiteDir              = emxGetParameter(request, "suiteDirectory");
String reSortKey             = emxGetParameter(request, "reSortKey");
String sPFmode               = emxGetParameter(request, "PFmode");
String sTarget               = emxGetParameter(request, "targetLocation");
String sHeaderRepeat         = emxGetParameter(request, "headerRepeat");
String toFrom                = emxGetParameter(request, "toFrom");
String relationshipName      = emxGetParameter(request, "relationshipName");
String sQueryLimit           = emxGetParameter(request, "queryLimit");
String sBackPage             = emxGetParameter(request, "backPage");
String funcPageName          = emxGetParameter(request, "funcPageName");
String selectedTable         = emxGetParameter(request, "selectedTable");
String isAdminTable          = emxGetParameter(request, "IsAdminTable");
String tableForDefault       = emxGetParameter(request, "tableForDefault");
String integrationName       = emxGetParameter(request, "integrationName");
String sShowWSTable			 = emxGetParameter(request, "showWSTable");
String sQueryName			 = emxGetParameter(request, "queryName");
String portalMode			 = emxGetParameter(request, "portalMode");
String showAllTables		 = emxGetParameter(request, "showAllTables");


if(integSessionData !=null && integrationName==null && (isTemplateType==null || isTemplateType.equalsIgnoreCase("false")))
{
	integrationName = util.getIntegrationName(IEFContext, objectId);
}

iefConfigUIUtil						= new IEFConfigUIUtil(IEFContext, integSessionData, integrationName);

String findType              = emxGetParameter(request, "findType");
if (null == findType)
{
   findType = "";
}

if (funcPageName == null)
{
   funcPageName = "";
}

if((selectedTable==null || "".equals(selectedTable.trim())) && integrationName!=null && !integrationName.equals(""))
{
	String defaultTable     = iefConfigUIUtil.getDefaultCustomTableName(integrationName, funcPageName, integSessionData);
	tableForDefault         = tableName;

	if(defaultTable.equals("Default") || defaultTable.equals(integSessionData.getStringResource("emxIEFDesignCenter.Common.Default")))
	{
		isAdminTable = "true";
	}
	else
	{
		boolean isSystemTable = iefConfigUIUtil.isSystemTable(IEFContext, defaultTable);
		isAdminTable		  = iefConfigUIUtil.isSystemTable(IEFContext, defaultTable) + "";
		tableName		      = iefConfigUIUtil.getFilteredMatrixTableName(defaultTable, isSystemTable);
		selectedTable		  = tableName;
	}
}
else if(selectedTable != null)
{
	tableName = selectedTable;
}

if((integrationName == null || integrationName.equals("")))
{
	tableForDefault = tableName;
	isAdminTable = "true";
}

String sFilterFramePage			= emxGetParameter(request, "FilterFramePage");
String sFilterFrameSize			= emxGetParameter(request, "FilterFrameSize");
String sShowIntegrationOption	= emxGetParameter(request, "showIntegrationOption");

/* IEF additions Start */
String instanceName = emxGetParameter(request,"txtInstanceName");
/* IEF additions End */

// timeStamp to handle the business objectList

String timeStamp = Long.toString(System.currentTimeMillis());

String sBackButtonURL = "emxInfoSearchDialogFS.jsp?backPage=" + sBackPage ;



HashMap requestParamMap = new HashMap();
Enumeration enumParamNames = emxGetParameterNames(request);
while(enumParamNames.hasMoreElements())
{
	String paramValue =null;
	String paramName = (String) enumParamNames.nextElement();

	if (paramName.equals("setName"))
	{
		paramValue = emxGetParameter(request, paramName);
		if(paramValue != null && !"null".equals(paramValue) && !request.getMethod().equals("POST"))
			paramValue= MCADUrlUtil.hexDecode(paramValue);
	}
	else
	{
		paramValue = emxGetParameter(request, paramName);
	}

	if (paramValue != null && paramValue.trim().length() > 0 )
		requestParamMap.put(paramName, paramValue);
}
requestParamMap.put("languageStr", request.getHeader("Accept-Language") );
requestParamMap.put("fileSite",fileSite);

requestParamMap.put("timeStamp",timeStamp);


// Added on 15/1/2004
String enableReviseSearch = (String)session.getAttribute("ReviseSearch");
if("true".equals(enableReviseSearch))
{
	session.setAttribute("ParameterBackButton", requestParamMap);
	session.removeAttribute("ReviseSearch");
}
// End of add on 15/1/2004
session.setAttribute("ParameterList" + timeStamp, requestParamMap);
String appendFlag = "";

// Collect all the parameters passed-in and forward them to all frames.

String encodedInstanceName = "";
if(instanceName != null && !instanceName.equals(""))
	encodedInstanceName = MCADUrlUtil.hexEncode(instanceName);

String appendParams = "timeStamp=" + timeStamp + "&page=" + sPage + "&displayMode=" + displayMode + "&sortDirection=" + sortDirection + "&sortColumnName=" + sortColumnName + "&instanceName=" + encodedInstanceName + "&funcPageName=" + funcPageName + "&tableForDefault=" + tableForDefault + "&integrationName=" + integrationName + "&selectedTable=" + selectedTable + "&isTemplateType=" + isTemplateType;
appendParams += "&showIntegrationOption=" + sShowIntegrationOption + "&showWSTable=" + sShowWSTable;

if (sQueryName != null && !sQueryName.equals(""))
   appendParams += "&queryName=" + sQueryName;

//decide what to show whether admin table or workspace table
String tableBodyURL;
if(("true").equals(isAdminTable)) //show admin table
{
	appendParams = appendParams + "&IsAdminTable=true" + "&table=" + tableName;
	tableBodyURL = FrameworkUtil.encodeURLParamValues("emxInfoTableAdminBody.jsp?" + appendParams);
}
else // show workspace table
{
	appendParams = appendParams + "&WSTable=" + tableName;
	tableBodyURL = FrameworkUtil.encodeURLParamValues("emxInfoTableWSBody.jsp?" + appendParams);
}

if (null != sRelationName)
{
   appendParams = appendParams + "&sRelationName=" + sRelationName;
}
if (null != sFilterFramePage)
{
   appendParams = appendParams + "&FilterFramePage=" + sFilterFramePage;
}

if (null != sShowIntegrationOption)
{
   appendParams = appendParams + "&showIntegrationOption=" + sShowIntegrationOption;
}

if (null != sFilterFramePage)
{
   appendParams = appendParams + "&FilterFramePage=" + sFilterFramePage;
   if (sFilterFramePage.indexOf("?") < 0)
      sFilterFramePage += "?" + "objectId=" + objectId;
   else
      sFilterFramePage += "&objectId=" + objectId;
}

if(null != portalMode)
{
	appendParams = appendParams + "&portalMode=" + portalMode;
}

if(null != showAllTables)
{
	appendParams = appendParams + "&showAllTables=" + showAllTables;
}

String tableHeaderURL = FrameworkUtil.encodeURLParamValues("emxInfoTableHeader.jsp?" + appendParams);
MapList relBusObjList            = new MapList();
HashMap objectIDInstancesListMap = new HashMap();
//populate the business object list
//TBD: If only the view is changed the object list should not be populated from the database again
try {
	ContextUtil.startTransaction(context, false);
    // Get the list of enquiries and label
    if (inquiryList != null && inquiryList.trim().length() > 0 )
    {
        String inquiry = "";
        if (inquiryList.indexOf(",") > 0 )
            inquiry = inquiryList.substring(0, inquiryList.indexOf(","));
        else
            inquiry = inquiryList;

		if(selectedFilter != null && selectedFilter.length() > 0 && selectedFilter.indexOf("::") != -1){
			selectedFilter = selectedFilter.substring(selectedFilter.indexOf("::")+2);
		}
        // If the "selectedFilter" is passed in use that value
        if (selectedFilter != null && selectedFilter.length() > 0)
            inquiry = selectedFilter;
        // long time2Check = System.currentTimeMillis();
		// evaluate inquiry
		relBusObjList = UIInquiry.evaluateInquiry(session, inquiry, objectId);
    } else if (programList != null && programList.length() > 0 ) {

        String program      = "";
        String method       = "";
        String programParam = "";

        if (programList.indexOf(",") > 0 )
            programParam = programList.substring(0, programList.indexOf(","));
        else
            programParam = programList;
			if(selectedFilter != null && selectedFilter.length() > 0 && selectedFilter.indexOf("::") != -1){
				selectedFilter = selectedFilter.substring(selectedFilter.indexOf("::")+2);
			}
        // If the "selectedProgram" is passed in, use that value
        if (selectedFilter != null && selectedFilter.length() > 0)
            programParam = selectedFilter;

        if (programParam != null && programParam.indexOf(":") > 0)
        {
            program = programParam.substring(0, programParam.indexOf(":") );
            method = programParam.substring(programParam.indexOf(":")+1 );
            // Build the parameter/value HashMap for use with Program JPO
            enumParamNames = emxGetParameterNames(request);
            HashMap paramMap = new HashMap();
            while(enumParamNames.hasMoreElements())
			{
                String paramName = (String) enumParamNames.nextElement();
				String paramValue = null;
                if(request.getMethod().equals("POST"))
				{
					paramValue = (String)emxGetParameter(request, paramName);

				}
                else
				{
					if(paramName.equals("setName"))
					{
						paramValue = emxGetParameter(request, paramName);
						if(paramValue != null && !"null".equals(paramValue))
							paramValue= MCADUrlUtil.hexDecode(paramValue);
					}
					else
					{
						paramValue = (String)emxGetParameter(request, paramName);
					}
				}

                if (paramValue != null && paramValue.trim().length() > 0 )
                    paramMap.put(paramName, paramValue);

            }

            paramMap.put("languageStr", request.getHeader("Accept-Language") );

			paramMap.put("timeZone", session.getAttribute("timeZone"));
			paramMap.put("localeObj", request.getLocale());

			/* IEF additions Start */
			if(integrationName != null && integrationName.length() != 0 && !integrationName.equalsIgnoreCase("null"))
			{
				MCADGlobalConfigObject globalConfigObject = integSessionData.getGlobalConfigObject(integrationName,IEFContext);

				HashMap globalConfigObjectTable			  = new HashMap();

				globalConfigObjectTable = (HashMap)integSessionData.getIntegrationNameGCOTable(IEFContext);

				paramMap.put("GCOTable", globalConfigObjectTable);
				paramMap.put("GCO", globalConfigObject);
	    		paramMap.put("LCO", (Object)integSessionData.getLocalConfigObject());

				if(funcPageName.equals("RecentlyAccessedParts"))
				{
					MCADRecentlyAccessedPartsHelper helper = new  MCADRecentlyAccessedPartsHelper(integSessionData);
					MapList mResultList					   = helper.getRecentlyAccessedBusObjectList(IEFContext, MCADRecentlyAccessedPartsHelper.ALL,globalConfigObject);

					paramMap.put("RECENTLY_ACCESSED_PARTS", mResultList);
				}
			}
			/* IEF additions End */

            String[] intArgs = new String[]{};
            try
			{
				if(errorMessage == null || errorMessage.equals(""))
				{
					relBusObjList = (MapList)JPO.invoke(context, program, intArgs, method, JPO.packArgs(paramMap), MapList.class);
				}
            }
			catch (MatrixException me)
			{
                errorMessage = me.toString();
				StringTokenizer st = new StringTokenizer(errorMessage, "\n");
                StringBuffer sbuf = new StringBuffer();
                while(st.hasMoreTokens())
                {
                    String token =st.nextToken();
                    String temp=token.substring(token.lastIndexOf(":")+1);

                    if(sbuf.toString().indexOf(temp)== -1)
                    {
                        sbuf.append(temp);
                        sbuf.append("\n");
                    }
                }
				errorMessage = sbuf.toString();
            }
        }
    }

	// additions for append / replace implementation
	HashMap updInstHashMap = new HashMap();
	MapList combinedMapList = new MapList();
	appendFlag = emxGetParameter(request, "appendCheckFlag");
	if ( appendFlag != null && appendFlag.equalsIgnoreCase("true"))
	{

		// get time stamp passed
		String timeStampValue = emxGetParameter(request, "timeStampAdvancedSearch");

		// get bo list corresponding to this time stamp

		if( !("".equals(timeStampValue)) && !("null".equalsIgnoreCase(timeStampValue)))
		{

			MapList oldMapList = (MapList)session.getAttribute("BusObjList" + timeStampValue);
			HashMap oldInstHashMap = (HashMap)session.getAttribute("InstanceList" + timeStampValue);

			// take the map list latest after it is set in this JSP
			combinedMapList = unionMapList(oldMapList,relBusObjList);
			updInstHashMap  = unionInstMap(oldInstHashMap, objectIDInstancesListMap);
		}
		else
		{
			combinedMapList = relBusObjList;
			updInstHashMap =   objectIDInstancesListMap;
		}
	}
	else
	{
		// no combining is required just pass the earlier list
		combinedMapList = relBusObjList;
		updInstHashMap =   objectIDInstancesListMap;
	}

    // clear earlier list corresponding to older timestamp, if one exists
    // get time stamp passed
    String earlierTimeStampValue = emxGetParameter(request, "timeStampAdvancedSearch");
    if( !("".equals(earlierTimeStampValue) )
        && !("null".equalsIgnoreCase(earlierTimeStampValue) ) )
	{
		//re move the old map list from session .
		session.removeAttribute("BusObjList" + earlierTimeStampValue);
		session.removeAttribute("InstanceList" + earlierTimeStampValue);
	}

    if (combinedMapList != null && combinedMapList.size() > 0)
    {
        int noOfItemsPerPage = 0;

        if (pagination != null)
        {
            noOfItemsPerPage = Integer.parseInt(pagination);
            if (noOfItemsPerPage == 0)
                noOfItemsPerPage = relBusObjList.size();
        }

        Integer currentIndex = new Integer((noOfItemsPerPage));
        session.setAttribute("BusObjList" + timeStamp, combinedMapList);
        //##
        session.setAttribute("InstanceList" + timeStamp, updInstHashMap);
        //#
		session.setAttribute("CurrentIndex" + timeStamp, currentIndex);
    }

	ContextUtil.commitTransaction(context);
} catch (Exception ex) {
    ContextUtil.abortTransaction(context);
    if (ex.toString() != null && (ex.toString().trim()).length() > 0)
        errorMessage = ex.getMessage().trim();

}

%>
<head>
<script language="javascript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
<script language="JavaScript">


function newSearch()
{

	<%
        newSearch="true";
	%>

	var targetFrame = top.findFrame(top, "content");
   // The variable newpage help to show the default value in search page
	if (!targetFrame)
		window.top.location.href = "emxInfoSearchDialogFS.jsp?timestamp=<%=timeStamp%>&newPage='true'";

	if (targetFrame)
		targetFrame.location.href = "emxInfoSearchDialogFS.jsp?timestamp=<%=timeStamp%>&newPage='true'";

}

// 17/12/2003        start    nagesh
function backSearch()
{
	var targetFrame = top.findFrame(top, "content");
	if (!targetFrame)
		window.top.location.href ="<%=sBackButtonURL%>&timestamp=<%=timeStamp%>";

	if (targetFrame)
		targetFrame.location.href ="<%=sBackButtonURL%>&timestamp=<%=timeStamp%>";
}
// 17/12/2003        End    nagesh



function sessionCleanup(timeStamp)
{
	//call the cleanup session page which deletes object list from the session

	//opening a hidden window to ensure that cleanup session will always gets called
	var newSearch = "<%=newSearch%>";

	if(newSearch!= "null" && newSearch =="false")
	{
		var url = "emxInfoTableCleanupSession.jsp?timeStamp=" + timeStamp;
		var winparams = "width=1,height=1,screenX=1500,screenY=1500,top=1500,left=1500,resizable=no";
		var win = window.open(url,"",winparams);
	}
}

function reviseSearch()
{
    var curHref					= parent.window.location.href;
    var array					= curHref.split('?');
    var params					= '';
    var listContentFrame		= findFrame(top, "listDisplay");
    var timeStamp				= '';
	var timeStampAdvancedSearch = '';
    var integrationName			= '';
	var queryName				= '';

    if (listContentFrame != null)
    {
        timeStamp = listContentFrame.document.emxTableForm.timeStamp.value;
		integrationName = listContentFrame.document.emxTableForm.integrationName.value;
	}
    if (array)
    {
       params = array[1];
    }

    var contentURL = './DSCSearchDialogFS.jsp?reviseSearch=true&objectCompare=false&findType='+"<%=findType%>";
    contentURL += '&toolbar=DSCSearchTopActionBar&integrationName=' + integrationName;
    var paramArray = null;

	// revise Searches
	if (params && params != 'undefined')
	{
	    paramArray = params.split('&');

		if (null != paramArray)
		{
			 var tempParams = '';
			 for (var i = 0; i < paramArray.length; i++)
			 {
			   var paramNameValueArray = paramArray[i].split('=');

			   if (paramNameValueArray)
			   {
					var paramName = paramNameValueArray[0];
					var paramValue = paramNameValueArray[1];
					if (paramName == null || paramName == '')
						continue;
					if (paramName == 'timeStamp' && timeStamp != null && timeStamp != '')//update timeStamp
					{
						paramValue = timeStamp;
					}
					if (paramName == 'timeStampAdvancedSearch' && timeStamp != null && timeStamp != '')//update timeStampAdvancedSearch
					{
						paramValue = timeStamp;
					}
			   }
			}
		}
	}// if params is not null
	if (listContentFrame.document.emxTableForm.queryName)
	{
		queryName = listContentFrame.document.emxTableForm.queryName.value;
	}

	if (queryName != null && queryName != 'null' && queryName != 'undefined' && queryName != '')
	{
	       contentURL += '&queryName=' + queryName + '&fromSavedSearch=true';
    }

	contentURL += '&timeStamp=' + timeStamp;
	contentURL += '&timeStampAdvancedSearch=' + timeStamp;

    var listFootFrame = findFrame(top, "listFoot");
    if (listFootFrame)
    {
       listFootFrame.document.footerForm.action = contentURL;
       listFootFrame.document.footerForm.target = '_parent';
       listFootFrame.document.footerForm.submit();
    }
}
function deleteSelected(queryString)
{
	var framelistDisplay = top.findFrame(this,"listDisplay");
	framelistDisplay.document.emxTableForm.action = "./emxInfoSearchResultsDelete.jsp?" + queryString;
	framelistDisplay.document.emxTableForm.target = 'hiddenTableFrame';
	framelistDisplay.document.emxTableForm.submit();

}

</script>
<%
String headerHeight="90";
if((relatedPage!=null&&relatedPage.equals("true")))
	   headerHeight ="115";

String frameRows = headerHeight + ",*,50,0,0";
/*
if (null != sFilterFramePage)
   frameRows = headerHeight + "," + sFilterFrameSize + ",*,50,0,0";
 */
if (null != sFilterFramePage)
   frameRows = sFilterFrameSize + "," + headerHeight + ",*,50,0,0";
%>

<title><xss:encodeForHTML><%=header%></xss:encodeForHTML></title>
<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
</head>
<%
	if ("".equals(errorMessage.trim()))
	{
%>

<!--XSSOK-->
<frameset rows="<%=frameRows%>" framespacing="0" frameborder="no" border="0" onunload="sessionCleanup('<%=timeStamp%>')" >
<%
   if (null != sFilterFramePage && sFilterFramePage.length() > 0) { %>
     <frame name="listFilter" src="<%=sFilterFramePage%>" noresize="noresize" marginheight="0" marginwidth="10" border="0" scrolling="no" />
<% }
 %>
    <frame name="listHead" src="<%=tableHeaderURL%>" noresize="noresize" marginheight="0" marginwidth="10" border="0" scrolling="no" />
    <frame name="listDisplay" src="<%=tableBodyURL%>" noresize="noresize" marginheight="10" marginwidth="10" />
	<frame name="listFoot" src="emxBlank.jsp" noresize="noresize" marginheight="0" marginwidth="10" border="0" scrolling="no" />
	<frame name="hiddenTableFrame" id="hiddenTableFrame" noresize src="emxBlank.jsp" scrolling="no" marginheight="0" marginwidth="0" frameborder="0" />
	<frame name="listHidden" src="emxBlank.jsp" noresize="noresize" marginheight="0" marginwidth="0" border="0" scrolling="no"  />
	</frameset>
<%
	}
	else {
%>
	<body>
	  <link rel="stylesheet" href="../../emxUITemp.css" type="text/css">
	  &nbsp;
      <table width="90%" border=0  cellspacing=0 cellpadding=3  class="formBG" align="center" >
        <tr >
		  <!--XSSOK-->
          <td class="errorHeader"><%=serverResourceBundle.getString("mcadIntegration.Server.Heading.Error")%></td>
        </tr>
        <tr align="center">
		<!--XSSOK-->
          <td class="errorMessage" align="center"><%=errorMessage%></td>
        </tr>
      </table>
	</body>
<%
	}
%>

</frameset>
</html>
