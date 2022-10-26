<%--  emxInfoTableAdminBody.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoTableAdminBody.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxInfoTableAdminBody.jsp $
 * 
 * *****************  Version 39  *****************
 * User: Shashikantk  Date: 2/07/03    Time: 5:40p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * ***********************************************
 *
--%>

<!-- IEF imports Start -->
<%@ page import = "matrix.db.*, matrix.util.*,com.matrixone.servlet.*,java.util.*" %>
<%@ page import = "com.matrixone.MCADIntegration.server.beans.*,com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.*" %>
<%@ page import = "com.matrixone.MCADIntegration.uicomponents.util.*" %>
<%@page import ="com.matrixone.apps.domain.util.*" %>

<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>
<!-- IEF imports End -->


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<html>
<%@include file="../emxTagLibInclude.inc"%>
<%@include file="emxInfoUtils.inc"%>
<%@include file = "emxInfoTableInclude.inc"%>
<%@ page import="com.matrixone.apps.domain.util.*" %>
<%@include file="emxInfoCentralUtils.inc"%>
<jsp:useBean id="emxNavErrorObject" class="com.matrixone.apps.domain.util.FrameworkException" scope="request"/>
<%@ include file="../emxUICommonHeaderBeginInclude.inc"%>
<!-- Function FUN080585 : Removal of Cue, Tips and Views -->
<jsp:useBean id="emxTableObject" class="com.matrixone.apps.framework.ui.UITable" scope="request"/>

<script language="JavaScript">
var browser = navigator.userAgent.toLowerCase();
  function cptKey(e) 
  {
	var pressedKey = ("undefined" == typeof (e)) ? event.keyCode : e.keyCode ;
	if(browser.indexOf("msie") > -1)
	{
		if(((pressedKey == 8) ||((pressedKey == 37) && (event.altKey)) || ((pressedKey == 39) && (event.altKey))) &&((event.srcElement.form == null) || (event.srcElement.isTextEdit == false)))
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

function showAlert(message)
{
	alert(message);
}

</script>

<%	
    Hashtable rowDataTable = new Hashtable();
	Vector rowData         = null;    
	
	// Related to collection
    Vector userRoleList		= (Vector)session.getValue("emxRoleList");
	String sQueryName		= emxGetSessionParameter(request, "queryName");
	String setName			= emxGetSessionParameter(request, "setName");
    String sTarget			=  emxGetSessionParameter(request, "targetLocation");      
	String displayMode		= emxGetSessionParameter(request, "displayMode");
	String pagination		= emxGetSessionParameter(request, "pagination");
	String topActionbar		= emxGetSessionParameter(request, "topActionbar");
	String bottomActionbar	= emxGetSessionParameter(request, "bottomActionbar");
	String objectId			= emxGetSessionParameter(request, "objectId");
	String relId			= emxGetSessionParameter(request, "relId");
	String sortColumnName	= emxGetSessionParameter(request, "sortColumnName");
	String sortDirection	= emxGetSessionParameter(request, "sortDirection");
	String tableName		= emxGetSessionParameter(request, "table");
	String relationship		= emxGetSessionParameter(request, "relationship"); //required for where used level filter
	String end				= emxGetSessionParameter(request, "end"); //required for where used level filter
	String sIntegrationName			= emxGetSessionParameter(request,"integrationName");		
	if(tableName == null || "".equals(tableName))
    {
		MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData)session.getAttribute("MCADIntegrationSessionDataObject");
	    Context context1                            = integSessionData.getClonedContext(session);
	    MCADMxUtil util                             = new MCADMxUtil(context1, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
		IEFConfigUIUtil iefConfigUIUtil             = new IEFConfigUIUtil(context1, integSessionData, sIntegrationName);
        
		String funcPageName		= emxGetSessionParameter(request, "funcPageName");
		tableName				=  integSessionData.getStringResource("mcadIntegration.Server.FieldName.DefaultTableName");
        tableName				=  iefConfigUIUtil.getFilteredMatrixTableName(tableName, true);
    }
	
	String inquiry                = emxGetSessionParameter(request, "inquiry");
	String sPage                  = emxGetSessionParameter(request, "page");
	String header                 = emxGetSessionParameter(request, "header");
	String jsTreeID               = emxGetSessionParameter(request, "jsTreeID");
	String selection              = emxGetSessionParameter(request, "selection");
	String suiteDir               = emxGetSessionParameter(request, "suiteDirectory");
	String timeStamp              = emxGetSessionParameter(request, "timeStamp");
	String reSortKey              = emxGetSessionParameter(request, "reSortKey");
	String sPFmode                = emxGetSessionParameter(request, "PFmode");
	String sHeaderRepeat          = emxGetSessionParameter(request, "headerRepeat");
	String suiteKey               = emxGetSessionParameter(request, "suiteKey");
	String sRelDirection          = emxGetSessionParameter(request,"RelDirection");
	String sRelationName          = emxGetSessionParameter(request,"RelationName");
	String instanceName           = emxGetSessionParameter(request,"instanceName");
	String IsAdminTable           = emxGetSessionParameter(request,"IsAdminTable");
	String sFooterRefreshRequired = emxGetSessionParameter(request, "footerRefreshRequired");
	String sTimeZone                = (String)session.getAttribute("timeZone");

	
	String sTableFilter				= Request.getParameter(request,"TableFilter");
	String sProgram					= emxGetSessionParameter(request,"program");
	String sRefresh					= emxGetSessionParameter(request,"refresh");
    String sShowIntegrationOption	= emxGetParameter(request, "showIntegrationOption");
	String acceptLanguage			= request.getHeader("Accept-Language");
	String sQueryLimit				= emxGetSessionParameter(request,"queryLimit");
	String errorMessage				= "";
	int noOfItemsPerPage			= 0;
	
	MCADServerResourceBundle serverResourceBundle = new MCADServerResourceBundle(acceptLanguage);

	if (null == sTableFilter) sTableFilter = "";
	if (null == sProgram) sProgram = "";

	try
	{
		ContextUtil.startTransaction(context, false);

		// Refresh the Http Session Data Set when requested
		if (null != sRefresh && sRefresh.equalsIgnoreCase("true") && null != sProgram)
		{
			String jpoProgram = sProgram.substring(0, sProgram.indexOf(":") );
			String jpoMethod = sProgram.substring(sProgram.indexOf(":")+1 );
			Enumeration enumParamNames = emxGetParameterNames(request);
			HashMap paramMap			= (HashMap)session.getAttribute("ParameterList" + timeStamp);
		
			String timeZone = (String)session.getAttribute("timeZone");
			paramMap.put("timeZone",timeZone);
	
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
					paramValue = (String)emxGetParameter(request, paramName);
				}
		   
				if (paramValue != null && paramValue.trim().length() > 0 )
					paramMap.put(paramName, paramValue);
			}
		
			paramMap.put("languageStr", request.getHeader("Accept-Language") );
			paramMap.put("localeObj", request.getLocale());

			if(sIntegrationName != null && sIntegrationName.length() != 0 && !sIntegrationName.equalsIgnoreCase("null"))
			{
				MCADIntegrationSessionData integSessionData	= (MCADIntegrationSessionData) session.getAttribute(MCADServerSettings.MCAD_INTEGRATION_SESSION_DATA_OBJECT);

				MCADGlobalConfigObject globalConfigObject = integSessionData.getGlobalConfigObject(sIntegrationName,integSessionData.getClonedContext(session));

				HashMap globalConfigObjectTable = new HashMap();

				globalConfigObjectTable = (HashMap)integSessionData.getIntegrationNameGCOTable(integSessionData.getClonedContext(session));

				paramMap.put("GCOTable", globalConfigObjectTable);
				paramMap.put("GCO", globalConfigObject);
				paramMap.put("LCO", (Object)integSessionData.getLocalConfigObject());
			}
			// Put the filter name and value pairs into the paramMap
			String[] intArgs = new String[]{};
		
			if (sTableFilter != null)
			{
				StringTokenizer filterTokenizer = new StringTokenizer(sTableFilter, "|");
				while (filterTokenizer.hasMoreTokens())
				{
					String token = filterTokenizer.nextToken();
					 if (null == token || 0 == token.length()) continue;
					int pos = token.indexOf('=');
					if (pos > 0)
					{
						String name = token.substring(0, pos);
						String value = token.substring(pos+1, token.length());

						 paramMap.put(name, value);
					}
				}
			}
			// refresh the HTTP session BusObjList 
			try
			{  
				MapList relBusObjList = (MapList)JPO.invoke(context, jpoProgram, intArgs, jpoMethod, JPO.packArgs(paramMap), MapList.class); 
				
				session.removeAttribute("BusObjList" + timeStamp);
				session.setAttribute("BusObjList" + timeStamp, relBusObjList); 

				for (int i = 0; i < relBusObjList.size(); i++)
				{
				   Map objDetails = (Map)relBusObjList.get(i);
				   String id = (String)objDetails.get("id");
				   String level = (String)objDetails.get("level");
				}              
			}
			catch (MatrixException me)
			{
			   me.printStackTrace();
			}
		}

		HashMap paramMap = (HashMap)session.getAttribute("ParameterList" + timeStamp);
		//##
		HashMap instanceMap = (HashMap)session.getAttribute("InstanceList" + timeStamp);
		//#

		// Get business object list from session
		MapList relBusObjList = (MapList)session.getAttribute("BusObjList" + timeStamp);
		// business object list for current page
		MapList relBusObjPageList = new MapList();
		HashMap tableMap = new HashMap();
		MapList columns = new MapList();
		int noOfColumns = 0;
		RelationshipWithSelectList rwsl = null;
		BusinessObjectWithSelectList bwsl = null;
                // Function FUN080585 : Removal of Cue, Tips and Views
		String selectType = "";
		String selectString = "";
		if (sortDirection == null)
			sortDirection = "ascending";
		if (reSortKey != null && reSortKey.length() > 0)
			sortColumnName = reSortKey;
		if(sortColumnName==null)
		 sortColumnName="";


    tableMap = emxTableObject.getTable(context, tableName);
    if (tableMap == null) {
        errorMessage = "Unable to get Table configuration for " + tableName;

    } else {
        columns = emxTableObject.getColumns(context, tableName, userRoleList);
        if (columns == null || columns.size() == 0 )
            errorMessage = "Unable to get Table configuration for " + tableName;
        else
            noOfColumns = columns.size();
    }
    // else {

    if (relBusObjList != null && relBusObjList.size() > 0 && columns != null && columns.size() > 0 )
    {
        if (sortColumnName != null && sortColumnName.trim().length() > 0 && (!(sortColumnName.equals("null"))) )
        {
//            sortColumnName = com.matrixone.apps.domain.util.XSSUtil.decodeFromURL(sortColumnName);

            HashMap sortColumMap = new HashMap();
            if ( columns != null && columns.size() > 0 )
            {
                for (int i=0; i < noOfColumns; i++)
                {
                    HashMap columnMap = (HashMap)columns.get(i);
                    String columnName = emxTableObject.getName(columnMap);
                    if (columnName != null && columnName.equalsIgnoreCase(sortColumnName) )
                    {
                        sortColumMap = columnMap;
                        break;
                    }
                }
            }

            // long time2Check = System.currentTimeMillis();
            // sort the list based on the sort column key
            if (sortColumMap != null)
			{
				/* IEF additions Start */
				MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute(MCADServerSettings.MCAD_INTEGRATION_SESSION_DATA_OBJECT);
			
				if(integSessionData != null)
				{
					HashMap globalConfigObjectTable = new HashMap();
					
					globalConfigObjectTable = (HashMap)integSessionData.getIntegrationNameGCOTable(integSessionData.getClonedContext(session));

					paramMap.put("GCOTable", globalConfigObjectTable);
					paramMap.put("LCO", (Object)integSessionData.getLocalConfigObject());
					paramMap.put("LocaleLanguage", integSessionData.getLanguageName());
				}
				/* IEF additions End */

                relBusObjList = sortObjects(context, relBusObjList, sortColumMap, sortDirection, paramMap);

				session.removeAttribute("BusObjList" + timeStamp);
				session.setAttribute("BusObjList" + timeStamp, relBusObjList);
			}
        }
    }
    boolean columnSpan = false;

	if (pagination == null || pagination.trim().length() == 0 || pagination.equals("null") )
	{
	    pagination = UINavigatorUtil.getSystemProperty(application, "emxFramework.PaginationRange");
	    if (pagination == null)
            pagination = "10";
    } else if ( pagination.equals("0") ) {
        pagination = "0";
        displayMode = "singlePage";
    }

    noOfItemsPerPage = Integer.parseInt(pagination);

    String columnName[]          = new String[noOfColumns];
    String selectTypes[]         = new String[noOfColumns];
    String selectStrings[]       = new String[noOfColumns];
    String programs[]            = new String[noOfColumns];
    String functions[]           = new String[noOfColumns];
    String columnHeaders[]       = new String[noOfColumns];
    String selectURLs[]          = new String[noOfColumns];
    String targetLocations[]     = new String[noOfColumns];
    String windowWidth[]         = new String[noOfColumns];
    String windowHeight[]        = new String[noOfColumns];
    String showTypeIcon[]        = new String[noOfColumns];
    String showAltIcon[]         = new String[noOfColumns];
    String columnIcons[]         = new String[noOfColumns];
    String programNames[]        = new String[noOfColumns];
    String functionNames[]       = new String[noOfColumns];
    String format[]              = new String[noOfColumns];
    String alternateOIDSelect[]  = new String[noOfColumns];
    String alternateTypeSelect[] = new String[noOfColumns];
    String popupModal[]          = new String[noOfColumns];
    String adminType[]           = new String[noOfColumns];


    // if selectType is program - get column result by invoking the specified JPO
    Vector programResult[] = new Vector[noOfColumns];

    // if selectType is checkbox - get column result by invoking the specified JPO
    Vector checkboxAccess[] = new Vector[noOfColumns];

    // format to be used for the date columns
    String DateFrm = (new Integer(java.text.DateFormat.MEDIUM)).toString();

    // re initialize the variables.
    selectType   = "";
    selectString = "";

    tableMap          = new HashMap();
	HashMap columnMap = new HashMap();

    String programName  = "";
    String functionName = "";

    boolean typeSelectExist = false;
    boolean checkBoxDefined = false;

    String checkboxProgramName = "";
    String checkboxFunctionName = "";

    if ( columns != null && columns.size() > 0 )
    {
        for (int i=0; i < noOfColumns; i++)
        {
            columnMap = (HashMap)columns.get(i);

            // Get column details
            columnName[i] = emxTableObject.getName(columnMap);
            columnHeaders[i] = emxTableObject.getLabel(columnMap);
            // String columnAlt = emxTableObject.getAlt(columnMap);
            selectURLs[i] = emxTableObject.getHRef(columnMap);

            String columnIcon           = "";
            String sAlternateOIDselect  = "";
            String sAlternateTypeSelect = "";

            String columnType   = emxTableObject.getSetting(columnMap, "Column Type");
            String columnSelect = emxTableObject.getBusinessObjectSelect(columnMap);

            if (columnType != null && columnType.length() > 0 )
            {
                if (columnType.equalsIgnoreCase("program") )
                {
                    columnSelect = emxTableObject.getSetting(columnMap, "program");
                    if (columnSelect != null && columnSelect.trim().length() > 0)
                    {
                        programName  = emxTableObject.getSetting(columnMap, "program");
                        functionName = emxTableObject.getSetting(columnMap, "function");
                        programs[i]  = programName;
                        functions[i] = functionName;
                    }
                } else if (columnType.equalsIgnoreCase("programHTMLOutput") )
                {
                    columnSelect = emxTableObject.getSetting(columnMap, "program");
                    if (columnSelect != null && columnSelect.trim().length() > 0)
                    {
                        programName  = emxTableObject.getSetting(columnMap, "program");
                        functionName = emxTableObject.getSetting(columnMap, "function");
                        programs[i]  = programName;
                        functions[i] = functionName;
                    }
                } else if (columnType.equalsIgnoreCase("icon") ) {
                    columnIcon = emxTableObject.getSetting(columnMap, "Column Icon");

                    if (columnIcon != null && columnIcon.trim().length() > 0)
                    {
                        columnSelect   = "";
                        columnIcons[i] = columnIcon;
                    }
                } else if (columnType.equalsIgnoreCase("checkbox") ) {
                    checkboxProgramName  = emxTableObject.getSetting(columnMap, "program");
                    checkboxFunctionName = emxTableObject.getSetting(columnMap, "function");
                    checkBoxDefined      = true;
                }
            } else {

                if (columnSelect != null && columnSelect.trim().length() > 0)
                {
                    columnType = "businessobject";
                    if ( columnSelect.indexOf("$") >=0 )
                        columnSelect = UIExpression.substituteValues(context, columnSelect);
                } else {
                    columnSelect = emxTableObject.getRelationshipSelect(columnMap);
                    if (columnSelect != null && columnSelect.trim().length() > 0)
                    {
                        columnType = "relationship";
                        if ( columnSelect.indexOf("$") >=0 )
                            columnSelect = UIExpression.substituteValues(context, columnSelect);
                    }
                }
            }
            // Get the Alternate OID and Type expressions and parse them
            sAlternateOIDselect = emxTableObject.getSetting(columnMap, "Alternate OID expression");
            sAlternateTypeSelect = emxTableObject.getSetting(columnMap, "Alternate Type expression");

            if (sAlternateOIDselect != null && sAlternateOIDselect.length() > 0 && sAlternateOIDselect.indexOf("$") >=0)
            {
                sAlternateOIDselect = UIExpression.substituteValues(context, sAlternateOIDselect);
                if (sAlternateTypeSelect != null && sAlternateTypeSelect.length() > 0 && sAlternateTypeSelect.indexOf("$") >=0)
                    sAlternateTypeSelect = UIExpression.substituteValues(context, sAlternateTypeSelect);
            }


            // Check if "TYPE" select is added
            if (columnSelect != null && columnSelect.equalsIgnoreCase("type") )
                typeSelectExist = true;

            selectTypes[i]         = columnType;
            selectStrings[i]       = columnSelect;
            alternateOIDSelect[i]  = sAlternateOIDselect;
            alternateTypeSelect[i] = sAlternateTypeSelect;

            targetLocations[i] = emxTableObject.getSetting(columnMap, "Target Location");
            windowWidth[i]     = emxTableObject.getSetting(columnMap, "Window Width");
            windowHeight[i]    = emxTableObject.getSetting(columnMap, "Window Height");

            String registeredSuite  = emxTableObject.getSetting(columnMap, "Registered Suite");
            String sPrinterFriendly = emxTableObject.getSetting(columnMap, "Printer Friendly");

            showTypeIcon[i] = emxTableObject.getSetting(columnMap, "Show Type Icon");
            showAltIcon[i]  = emxTableObject.getSetting(columnMap, "Show Alternate Icon");
            format[i]       = emxTableObject.getSetting(columnMap, "format");
            popupModal[i]   = emxTableObject.getSetting(columnMap, "Popup Modal");
            adminType[i]    = emxTableObject.getSetting(columnMap, "Admin Type");

            suiteDir = "";
            String StringResFileId = "";

            if (registeredSuite != null && registeredSuite.length() != 0) {
            	suiteDir = UINavigatorUtil.getRegisteredDirectory(application, registeredSuite);
            	StringResFileId = UINavigatorUtil.getStringResourceFileId(application, registeredSuite);
            }

            if (columnHeaders[i] != null && columnHeaders[i].length() > 0)
                columnHeaders[i] = UINavigatorUtil.getI18nString(columnHeaders[i], StringResFileId , request.getHeader("Accept-Language"));

            if (columnHeaders[i] == null || columnHeaders[i].length() == 0)
                columnHeaders[i] = "&nbsp;";

            if (selectURLs[i] != null && selectURLs[i].length() != 0)
            {
                selectURLs[i] = UINavigatorUtil.parseHREF(context, selectURLs[i], registeredSuite);

                if (selectURLs[i].indexOf('?') == -1)
                    selectURLs[i] += "?emxSuiteDirectory=" + suiteDir;
                else
                    selectURLs[i] += "&emxSuiteDirectory=" + suiteDir;

                selectURLs[i] = UINavigatorUtil.encodeURL(selectURLs[i]);
            }

            if (popupModal[i] == null || popupModal[i].length() == 0)
                popupModal[i] = "false";

            if (targetLocations[i] == null || targetLocations[i].length() == 0)
                targetLocations[i] = "content";

            if (targetLocations[i] != null && targetLocations[i].equalsIgnoreCase("popup"))
            {
                if (windowWidth[i] == null || windowWidth[i].length() == 0 )
                    windowWidth[i] = "700";

                if (windowHeight[i] == null || windowHeight[i].length() == 0 )
                    windowHeight[i] = "600";
            }

            programNames[i] = programName;
            functionNames[i] = functionName;
        }
		if(columnHeaders!= null && columnHeaders.length > 0)
		{
			rowDataTable = new Hashtable(columnHeaders.length);
			session.setAttribute("ColHeading"+ timeStamp, columnHeaders);
		}
    }

    if (selection == null || selection.trim().length() == 0 || selection.equals("null") )
        selection = "none";

    if (relBusObjList != null && relBusObjList.size() > 0)
    {
        if (noOfItemsPerPage == 0)
            noOfItemsPerPage = relBusObjList.size();
        
        Integer iCurrentIndex = (Integer)session.getAttribute("CurrentIndex" + timeStamp);
        if (null == iCurrentIndex)
        {
           session.setAttribute("CurrentIndex" + timeStamp, new Integer(0));
        }        
        
        int currentIndex = ((Integer)session.getAttribute("CurrentIndex" + timeStamp)).intValue();

        if ( sPage == null || sPage.trim().length() == 0 || sPage.equals("null") )
          sPage = "1";
		if ( (sPFmode == null || !sPFmode.equals("true")) && !"current".equals(sPage))
        {
		 	if (sPage != null && sPage.equals("next")) {
          	currentIndex += noOfItemsPerPage;
			} else if (sPage != null && sPage.equals("previous")) {
          	currentIndex -= noOfItemsPerPage;
        	} else if (sPage != null && Integer.parseInt(sPage) >= 1) {
          	int pageNo = Integer.parseInt(sPage);
          	currentIndex = (pageNo - 1) * noOfItemsPerPage;
        	} else {
          	currentIndex = 0;
        	}
        }

		Integer currentIndexObj = new Integer(currentIndex);
		session.setAttribute("CurrentIndex" + timeStamp, currentIndexObj);

        int lastPageIndex;
        if (displayMode != null && displayMode.compareTo("multiPage") == 0)
        {
            // currentIndex = 0;
            lastPageIndex = currentIndex + noOfItemsPerPage;
        } else if (displayMode != null && displayMode.compareTo("singlePage") == 0)
        {
            currentIndex = 0;
            lastPageIndex = currentIndex + relBusObjList.size();
        } else {
            lastPageIndex = currentIndex + noOfItemsPerPage;
        }

        for (int i = currentIndex; i < lastPageIndex; i++)
        {
            if (i >= relBusObjList.size())
                break;
            relBusObjPageList.add(relBusObjList.get(i));
        }

        // Get the program column results
        for (int i = 0; i < noOfColumns; i++)
        {
            if ( selectTypes[i].compareTo("program") == 0 || selectTypes[i].compareTo("programHTMLOutput") == 0 )
            {
                HashMap programMap = new HashMap();
                programMap.put("objectList", relBusObjPageList);
                programMap.put("paramList", paramMap);
                //##
                programMap.put("InstanceList", instanceMap);
                //#
                if (programNames[i] != null && functionNames[i] != null)
                {
					/* IEF additions Start */
					MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute(MCADServerSettings.MCAD_INTEGRATION_SESSION_DATA_OBJECT);
					
					if(integSessionData != null)
					{
						HashMap globalConfigObjectTable = new HashMap();

						globalConfigObjectTable = (HashMap)integSessionData.getIntegrationNameGCOTable(integSessionData.getClonedContext(session));

						programMap.put("GCOTable", globalConfigObjectTable);
						programMap.put("LCO", (Object)integSessionData.getLocalConfigObject());
						programMap.put("LocaleLanguage", integSessionData.getLanguageName());
					}
					/* IEF additions End */

                    Vector columnResult = new Vector();
                    String[] methodargs = JPO.packArgs(programMap);
                    try {
                        columnResult = (Vector)JPO.invoke(context, programNames[i], null, functionNames[i], methodargs, Vector.class);
                    } catch (MatrixException me) {
//                        emxNavErrorObject.addMessage("Unable to invoke Method : " + functionNames[i] + " in JPO : " + programNames[i]);
//                        if (me.toString() != null && (me.toString().trim()).length() > 0)
//                            emxNavErrorObject.addMessage(me.toString());
						columnResult.add("");
                    }
                    programResult[i] = columnResult;
                }
            }

            if (selectTypes[i].compareTo("checkbox") == 0)
            {
                HashMap programMap = new HashMap();
                programMap.put("objectList", relBusObjPageList);
                programMap.put("paramList", paramMap);

                if (checkboxProgramName != null && checkboxFunctionName != null)
                {
                    Vector columnResult = new Vector();
                    String[] methodargs = JPO.packArgs(programMap);
                    try {
                        columnResult = (Vector)JPO.invoke(context, checkboxProgramName, null, checkboxFunctionName, methodargs, Vector.class);
                    } catch (MatrixException me) {
//                        emxNavErrorObject.addMessage("Unable to invoke Method : " + functionNames[i] + " in JPO : " + programNames[i]);
//                        if (me.toString() != null && (me.toString().trim()).length() > 0)
//                            emxNavErrorObject.addMessage(me.toString().trim());
						columnResult.add("");
                    }
                    checkboxAccess[i] = columnResult;
                }
            }
        }

        // Form a set of business objects in the database
        // and execute select command on the set
        StringList sl_bus = new StringList();
        StringList sl_rel = new StringList();
        int noOfSelects_bus = 0;
        int noOfSelects_rel = 0;
        for (int i = 0; i < noOfColumns; i++)
        {
            if (selectTypes[i].compareTo("businessobject") == 0)
            {
                sl_bus.addElement(selectStrings[i]);
                noOfSelects_bus++;

                if (alternateOIDSelect[i] != null && alternateOIDSelect[i].length() > 0)
                {
                    sl_bus.addElement(alternateOIDSelect[i]);
                    noOfSelects_bus++;
                }
                if (alternateTypeSelect[i] != null && alternateTypeSelect[i].length() > 0)
                {
                    sl_bus.addElement(alternateTypeSelect[i]);
                    noOfSelects_bus++;
                }

                // If the admin Type is state, add "policy" in the select
                if (adminType[i] != null && adminType[i].equals("State"))
                {
                    // add policy if not already added
                    if ( !(sl_bus.contains("policy")) )
                    {
                        sl_bus.addElement("policy");
                        noOfSelects_bus++;
                    }
                }
            }
            else if (selectTypes[i].compareTo("relationship") == 0)
            {
                sl_rel.addElement(selectStrings[i]);
                noOfSelects_rel++;
            }
        }

        // Add select "type" if it is not in the current select list.
        if ( !(typeSelectExist) )
            sl_bus.addElement("type");

		//CueTip-Start
		String bol_array[] = null;
		String rel_array[] = null;
		//CueTip-End
        if (noOfSelects_bus != 0)
        {
			bol_array = new String[relBusObjPageList.size()];
			
            for (int i = 0; i < relBusObjPageList.size(); i++)
            {
                HashMap elementMap = (HashMap)getHashMap(relBusObjPageList.get(i));
                bol_array[i] = (String)elementMap.get("id");
            }
			bwsl = BusinessObjectWithSelect.getSelectBusinessObjectData(context, bol_array, sl_bus);
        }

        if (noOfSelects_rel != 0)
        {
            rel_array = new String[relBusObjPageList.size()];

            for (int i = 0; i < relBusObjPageList.size(); i++)
            {
                HashMap elementMap = (HashMap)getHashMap(relBusObjPageList.get(i));
                rel_array[i] = (String)elementMap.get("id[connection]");
            }
            
			try
			{
				rwsl = Relationship.getSelectRelationshipData(context, rel_array, sl_rel);
			}
			catch(Exception ex)
			{
				//Do Nothing: If relId is not present display the column with blank value
			}
        }
        // Function FUN080585 : Removal of Cue, Tips and Views
    } // end of if null check for relBusObjList
%>

<head>
<title>Table View</title>
	<link rel="stylesheet" href="../common/styles/emxUIMenu.css" type="text/css" />
		<link rel="stylesheet" href="../common/styles/emxUIActionbar.css" type="text/css" />
<%
if ( sPFmode != null && sPFmode.equals("true") )
{
%>
	<link rel="stylesheet" href="../common/styles/emxUIDefaultPF.css" type="text/css">
	<link rel="stylesheet" href="../common/styles/emxUIListPF.css" type="text/css">
<%
}   else {
%>
	<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css">
	<link rel="stylesheet" href="../common/styles/emxUIList.css" type="text/css">
<%
}
%>
	<%@include file = "emxInfoUIConstantsInclude.inc"%>
	<script language="JavaScript" src="emxInfoUIModal.js" type="text/javascript"></script>
	<!-- IEF additions Start -->
	<script language="JavaScript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
	<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
	<!-- IEF additions End   -->
</head>

<body onLoad="removeProgressBar()">
<link rel="stylesheet" href="../integrations/styles/emxIEFCommonUI.css" type="text/css">
<form name=emxTableForm method="post">

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
//System.out.println("CSRFINJECTION");
%>


<%
	// Show the header if the mode is "PrinterFriendly"
	if ( sPFmode != null && sPFmode.equals("true") )
	{
		header = parseTableHeader(application, context, header, objectId, suiteKey, request.getHeader("Accept-Language"));
		String userName = (new com.matrixone.servlet.FrameworkServlet().getFrameContext(session)).getUser();
		java.util.Date currentDateObj = new java.util.Date(System.currentTimeMillis());
		String currentTime = currentDateObj.toString();

%>
		<hr noshade>
		<table border="0" width="100%" cellspacing="2" cellpadding="4">
		<tr>
        <td class="pageHeader" width="60%"><%=header%></td>
        <td width="1%"><img src="../common/images/utilSpacer.gif" width="1" height="28" alt=""></td>
        <td width="39%" align="right"></td>
        <td nowrap>
            <table>
            <tr><td nowrap=""><%=userName%></td></tr>
            <tr><td nowrap=""><%=currentTime%></td></tr>
            </table>
        </td>
		</tr>
		</table>
		<hr noshade>

<%
	} //end if sPF Mode

    if (columns != null && columns.size() > 0 )
    {
        if ( sPFmode != null && sPFmode.equals("true") )
        {
%>
			<table border="0" width="100%">
			<tr>
			<td><img src="../common/images/utilSpacer.gif" border="0" width="5" height="30" alt=""></td>
			</tr>
			</table>
			<table border="0" cellpadding="5" cellspacing="0" width="100%">
<%
        } else {
%>
			<table border="0" cellpadding="3" cellspacing="2" width="100%">
<%
        }
%>
<tr>
<%
		// show Check box or radio only if a checkbox column is not defined explicitly
		if ( !(checkBoxDefined) )
		{
			if ( sPFmode != null && sPFmode.equals("true") )
			{
%>
                <!-- <th></th> -->
<%			} else {

				if (selection.compareTo("single") == 0  )
				{
%>
					<th class=sorted width="5%">&nbsp;</th>
<%
				} else if (selection.compareTo("multiple") == 0)
				{
%>
					<th class=sorted width="5%" style="text-align:center"><input type="checkbox" name="chkList" onclick="checkAll()"></th>
<%
				}
			}
		}
		for (int i = 0; i < noOfColumns; i++)
		{
			String hrefTag = "";

			if (selectTypes[i].compareTo("checkbox") == 0)
			{
				if ( sPFmode != null && sPFmode.equals("true") )
				{
%>
					<th></th>
<%				} else {
%>
					<th class=sorted width="5%" style="text-align:center"><input type="checkbox" name="chkList" onclick="checkAll()"></th>
<%
				}
			} else 
			{
				if (sortColumnName == null || !(sortColumnName.equalsIgnoreCase(columnName[i])) || ( sPFmode != null && sPFmode.equals("true") ) )
                {

					if ( sPFmode != null && sPFmode.equals("true") )
                    {
%>                    <th><%=columnHeaders[i]%>
<%
                    } else {
                        if(columnHeaders[i] == "&nbsp;")
                           {
%>                           <th class=sorted><a href="javascript:reloadTable('<%=columnName[i]%>')"></a><%= columnHeaders[i] %>
<%
                           }
                        else
                           {
%>                           <th class=sorted><a href="javascript:reloadTable('<%=columnName[i]%>')"> <%= columnHeaders[i] %> </a>
<%
                    }
                    }
				} else {
					String sortImage = "";
					String nextSortDirection = "";
					if (sortDirection.compareTo("ascending") == 0)
					{
						nextSortDirection = "descending";
						sortImage = "../common/images/utilSortArrowUp.gif";
					} else {
						nextSortDirection = "ascending";
						sortImage = "../common/images/utilSortArrowDown.gif";
					}
%>
					<th class=sorted><table border="0" cellspacing="0" cellpadding="0"><tr><th>
					<a href="javascript:reloadTable('<%=columnName[i]%>', '<%=nextSortDirection%>')"> <%= columnHeaders[i] %> </a>
					</th><td><img src="<%=sortImage%>" align="absmiddle" border="0" /></td></tr></table>
<%
				}
			}
%>
			</th>
<%
		}
%>
		</tr>
<%
	}

    if (relBusObjPageList == null || relBusObjPageList.size() == 0 )
    {
        int totalColumns = noOfColumns + 1;
%>
		<tr class=even> <td class="error" colspan="<%=totalColumns%>" align=center><%= i18nStringNowLocal("emxIEFDesignCenter.Objects.Common.NoObjectsFound", request.getHeader("Accept-Language"))%></td> </tr>
<%
    } else if (columns == null || columns.size() == 0) {
%>
		<table border="0" cellpadding="3" cellspacing="2" width="100%">
		<tr class=even> <td class="error" align=center>Unable to get Table Columns</td> </tr>
		</table>
<%
    } else {

		// variables used for printing every other row shaded
		int iOddEven = 1;
		String sRowClass = "odd";
                // Function FUN080585 : Removal of Cue, Tips and Views
		String href = "";
		int headerRepeatCount = 14;

		if( ( sHeaderRepeat != null) && !("null".equals(sHeaderRepeat)) && (sHeaderRepeat.trim().length() > 0) )
			headerRepeatCount = Integer.parseInt(sHeaderRepeat);
		if(relBusObjPageList!= null && relBusObjPageList.size() > 0)
			session.setAttribute("PageBusObjList" + timeStamp, relBusObjPageList);


		for (int i = 0; i < relBusObjPageList.size(); i++)
		{
			rowData = new Vector();
			iOddEven = i;
			// String element[] = (String[])relBusObjPageList.get(i);
			HashMap elementMap = (HashMap)getHashMap(relBusObjPageList.get(i));
			// String elementOID = (String)elementMap.get("objectId");
			String elementOID = (String)elementMap.get("id");
			// String elementRELID = (String)elementMap.get("relId");
			String elementRELID = (String)elementMap.get("id[connection]");

			boolean readAccess = true;
			// elementOID = "#DENIED!" when  no read access for elementOID
			if(elementOID.equals("#DENIED!"))
				readAccess=false;
			else{
            String access="read";
            BusinessObject bObj = new BusinessObject(elementOID);
         	readAccess = FrameworkUtil.hasAccess(context,bObj,access);
			}
			
			String checkboxName = "emxTableRowId";
			String sValue = (String)elementMap.get("rowid");

			String isDerivedOutputPage = (String)elementMap.get("isDerivedOutputPage");

			if(sValue==null || sValue.equals(""))
			{
			if (elementRELID == null || elementRELID.trim().length() == 0)
				sValue = elementOID;
			else
				sValue = elementRELID + "|" + elementOID;
			}

			if ((iOddEven%2) == 0)
				sRowClass = "even";
			else
				sRowClass = "odd";
                        // Function FUN080585 : Removal of Cue, Tips and Views
			if ( (i != 0) && (headerRepeatCount != 0) && (i % headerRepeatCount == 0) )
			{
%>
				<tr>
<%
				if (selection.compareTo("single") == 0 || selection.compareTo("multiple") == 0)
				{
%>
					<th class="sub" width="5%">&nbsp;</th>
<%
				}

				for (int k = 0; k < noOfColumns; k++)
				{
          			String sColumName = columnName[k];
					if (sortColumnName == null || (sortColumnName.compareTo(sColumName) != 0))
					{
%>						<th class="sub"><%=columnHeaders[k]%><%

					}
					else
					{
%>						<th class="subSorted"><%
						String sortImage = "";
						if (sortDirection.compareTo("ascending") == 0)
							sortImage = "../common/images/utilSortArrowUp.gif";
						else
							sortImage = "../common/images/utilSortArrowDown.gif";

%>						<%=columnHeaders[k]%>
						<img src="<%=sortImage%>" align="absmiddle" border="0" />
<%
					}
%>					</th><%
				}
%>				</tr><%
			}

%>			<tr class="<%=sRowClass%>"><%
			// Show default Check box column, only if a checkbox column is explicitly not defined
			if ( !(checkBoxDefined) )
			{
				if ( sPFmode != null && sPFmode.equals("true") )
				{
%>
					<!-- <th></th> -->
<%				} else {
				// If this is a derived output page then enable the check box even if the elementid is same as that of the 
				// Objectid this is done to allow download of derived outobject files even if we derived output object is not created
				if((isDerivedOutputPage!=null || !elementOID.equals(objectId)) && readAccess)
				{
				
					if (selection.compareTo("multiple") == 0) {
%>
						<td class="node"  style="text-align: center"><input type="checkbox" name="<%=checkboxName%>" value="<%=sValue%>" onclick="doCheckboxClick(this);doSelectAllCheck(this)" ></td>
<%
					} else if (selection.compareTo("single") == 0) {
%>
                        <td class="node" style="text-align: center"><input type="radio" name="<%=checkboxName%>" value="<%=sValue%>" onclick="doRadioClick(this)" ></input></td>
<%
					}
				}
				else if(selection.compareTo("multiple") ==0 || selection.compareTo("single") == 0){
				%>
					<td class="node" style="text-align: center"><img src="images/iconCheckoffdisabled.gif"></td>

				<%

				}
			  }
			}

			for (int j = 0; j < noOfColumns; j++)
			{
				String objectIcon = "";
				String colType = "";
				String colFormat = "";
				boolean showIcon = false;

				String passOID = elementOID;

				StringList passOIDList = new StringList();
				if (alternateOIDSelect[j] != null && alternateOIDSelect[j].length() > 0)
				{
					passOIDList = (StringList)(bwsl.getElement(i).getSelectDataList(alternateOIDSelect[j]));
					if (passOIDList != null)
						passOID = (String)(passOIDList.firstElement());
				}

				String typeName = "";
				if (showTypeIcon[j] != null && showTypeIcon[j].equals("true") )
				{
					typeName = (String)elementMap.get("type");
					if(typeName==null && bwsl!=null)
						typeName = bwsl.getElement(i).getSelectData("type");
					showIcon = true;
				} else if (showAltIcon[j] != null && showAltIcon[j].equals("true") ) {
					if (alternateTypeSelect[j] != null)
					{
						typeName = bwsl.getElement(i).getSelectData(alternateTypeSelect[j]);
						showIcon = true;
					}
				}

				if (showIcon && typeName != null && typeName.trim().length() > 0)
				{
					objectIcon = UINavigatorUtil.getTypeIconProperty(context, application, typeName);
					if (objectIcon == null || objectIcon.length() == 0 )
						objectIcon = "../common/images/iconSmallDefault.gif";
					else
						objectIcon = "../common/images/" + objectIcon;
				}

				if (selectURLs[j] != null && selectURLs[j].length() > 0)
				{
					if (selectURLs[j].indexOf('?') == -1)
						href = selectURLs[j] + "?relId=" + elementRELID + "&parentOID=" + objectId + "&jsTreeID=" + jsTreeID;
					else
						href = selectURLs[j] + "&relId=" + elementRELID + "&parentOID=" + objectId  + "&jsTreeID=" + jsTreeID;
				} else {
					href = "";
				}

				colType = selectTypes[j];
				colFormat = (String)format[j];

				String columnValue = null;

				// if (selectTypes[j].compareTo("businessobject") == 0)
				if (colType.equals("businessobject") || colType.equals("relationship") || colType.equals("program") )
				{

					columnValue = "";
					StringList colValueList = new StringList();
					// String columnValue = bwsl.getElement(i).getSelectData(selectStrings[j]);
					if (colType.equals("businessobject") )
					{
						colValueList = (StringList)(bwsl.getElement(i).getSelectDataList(selectStrings[j]));

						if (colValueList != null )
							columnValue = (String)(colValueList.firstElement());

						if (colValueList != null && adminType[j] != null)
						{						
							//These temp1,temp2,temp3 variables are required because if 
							//the following function "getAdminI18NStringList()" return a key then these
							//variables replaces that key with the actual (english) value of the type
							//The scope of these variables is limited to this "else" condition only.
							StringList temp1 = null;
							String temp2 = null;
							String temp3 = null;
							if (adminType[j].equals("State") )
							{
								StringList policyList = (StringList)(bwsl.getElement(i).getSelectDataList("policy"));
								colValueList = UINavigatorUtil.getStateI18NStringList(policyList, colValueList, adminType[j]);
							} else if (adminType[j].startsWith("attribute_") ){
								String attributeName = Framework.getPropertyValue(session, adminType[j]);
								colValueList = UINavigatorUtil.getAttrRangeI18NStringList(attributeName, colValueList, langStr);
							} else {
								
								temp1 = colValueList;
								temp2 = adminType[j] + "." + colValueList.toString();
								colValueList = UINavigatorUtil.getAdminI18NStringList(adminType[j], colValueList, langStr);
								temp3 = colValueList.toString();
								if(temp3.indexOf(temp2) != 0){
									colValueList = temp1;
								}								
							}
						}

					} else if (colType.equals("relationship") ) {
						if(rwsl != null){
							RelationshipWithSelect rws = (RelationshipWithSelect)rwsl.elementAt(i);
							Hashtable columnInfo = rws.getRelationshipData();

							try {
								columnValue = (String)columnInfo.get(selectStrings[j]);
								colValueList.add(columnValue);
							} catch (Exception ex) {
								colValueList = (StringList)columnInfo.get(selectStrings[j]);
								if (colValueList != null)
									columnValue = (String)(colValueList.firstElement());
							}
						}
						else{
							columnValue = "";
							colValueList.add(columnValue);
						}
					} else if ( colType.equals("program") ) {
						// columnValue = programResult[j].get(i).toString();

						try {
							columnValue = (String)programResult[j].get(i);
							colValueList.add(columnValue);
						} catch (Exception ex) {
							colValueList = (StringList)programResult[j].get(i);
							if (colValueList != null)
								columnValue = (String)(colValueList.firstElement());
						}
					}

					if (colValueList == null)
						colValueList = new StringList();


					if (columnValue == null || columnValue.length() == 0)
					{
						if ( colFormat != null && colFormat.equals("date") )
							columnValue = "";
						else
							columnValue = "";
					}

					if (href == null || href.length() == 0 || ( sPFmode != null && sPFmode.equals("true") ))
					{
						if (colFormat != null && colFormat.equals("date"))
						{

%>
							<td class="listCell" nowrap><table border="0"><tr>
<%
							if (showIcon)
							{
%>
							<td class="node" valign="top"><img border="0" src="<%=objectIcon%>"></td>
<%
							}
%>
							<td class="node" ><framework:lzDate localize="i18nId" tz='<%=(String)session.getValue("timeZone")%>' format='<%=DateFrm %>' ><%= MCADUtil.escapeStringForHTML(columnValue) %></framework:lzDate></a></td>
							</tr></table></td>
<%
						} else {
%>
							<td class="node" nowrap><table border="0">
<%
							for (int noColValues = 0; noColValues < colValueList.size(); noColValues++)
							{
								columnValue = (String)colValueList.get(noColValues);

								if(!readAccess ){
								if(selectStrings[j].equals("type")|| selectStrings[j].equals("name")||selectStrings[j].equals("revision")){
									if(colType.equals("businessobject"))
									columnValue= (String)elementMap.get(selectStrings[j]);
									else if (!selectStrings[j].equals("revision")&& colType.equals("relationship")){
									columnValue= (String)elementMap.get("rel_"+selectStrings[j]);
									if(columnValue==null)
										columnValue="";

									}

									if(selectStrings[j].equals("type") && colType.equals("businessobject"))
										columnValue = i18nNow.getMXI18NString(columnValue.trim(), "", request.getHeader("Accept-Language"),"Type");
								    else if((selectStrings[j].equals("type") ||selectStrings[j].equals("name"))&&colType.equals("relationship"))
										columnValue = i18nNow.getMXI18NString(columnValue.trim(),"",request.getHeader("Accept-Language"),"Relationship");
								}
								else
									columnValue = i18nStringNowLocal("emxIEFDesignCenter.Common.NoReadAcess", request.getHeader("Accept-Language"));
								}
								if("".equals(columnValue))
									columnValue = "";								
							  %>
								<tr>
<%
								if (showIcon)
								{
%>
								<td valign="top"><img border="0" src="<%=objectIcon%>"></td>
<%
								}
//sCueClass
// Function FUN080585 : Removal of Cue, Tips and Views
%>
							<td><%=MCADUtil.escapeStringForHTML(columnValue)%></a></td>
							</tr>
<%
							}
%>
								</table></td>
<%
						}
					}
					else
					{
%>
						<td class="node" nowrap><table border="0">
<%
						for (int noColValues = 0; noColValues < colValueList.size(); noColValues++)
						{
							columnValue = (String)colValueList.get(noColValues);
							if(!readAccess){
							if((selectStrings[j].equals("type")|| selectStrings[j].equals("name")||selectStrings[j].equals("revision"))){
									columnValue= (String)elementMap.get(selectStrings[j]);
									if(selectStrings[j].equals("type"))
										columnValue = i18nNow.getMXI18NString(columnValue.trim(), "", request.getHeader("Accept-Language"),"Type");
								}
							else
								columnValue = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Common.NoReadAcess", request.getHeader("Accept-Language"));
							}
														
							if (passOIDList != null && passOIDList.size() > 0)
								passOID = (String)passOIDList.get(noColValues);

							String colItemHref = "";
							colItemHref = href + "&objectId=" + passOID;
%>
							<tr>
<%
							if (showIcon)
	                        {
		                        if(readAccess ){
		                     // Function FUN080585 : Removal of Cue, Tips and Views
%>
								<td valign="top" ><a href="JavaScript:emxTableColumnLinkClick('<%=colItemHref%>', '<%=windowWidth[j]%>', '<%=windowHeight[j]%>', '<%=popupModal[j]%>', '<%=targetLocations[j]%>')"><img border="0" src="<%=objectIcon%>"></a></td>								
<%
								}else{
%>
								<td valign="top"><img border="0" src="<%=objectIcon%>" ></td>
<%
								}
                            }
//sCueClass -- Tip also// Function FUN080585 : Removal of Cue, Tips and Views
							if(readAccess ){
%>
								<td ><a href="JavaScript:emxTableColumnLinkClick('<%=colItemHref%>', '<%=windowWidth[j]%>', '<%=windowHeight[j]%>', '<%=popupModal[j]%>', '<%=targetLocations[j]%>')" class="object" ><%=MCADUtil.escapeStringForHTML(columnValue)%></a></td>
								</tr>
<%								
							}else{
//sCueClass-- Tip also
%>
								<td class="node" ><%=MCADUtil.escapeStringForHTML(columnValue)%></td>
								</tr>
<%
							}
							
						}
%>
						</table></td>
<%
					}
				}
				else if (colType.compareTo("programHTMLOutput") == 0)
				{
				      
					columnValue = "";
					if(i <= (programResult[j].size()-1))
					{
						columnValue = programResult[j].get(i).toString();
					}	
					if (columnValue == null || columnValue.length() == 0)
						columnValue = "";
					if (colFormat.equals("date")) {	
					    columnValue = programResult[j].get(i).toString();				 
%>
                    <td class="node"><framework:lzDate displaydate="true" displaytime="true" localize="i18nId" tz='<%=(String)session.getValue("timeZone")%>' format='<%=DateFrm %>' ><%=MCADUtil.escapeStringForHTML(columnValue)%></framework:lzDate></td>
<%
					}
					else {
%>
					<td class="node"><%= columnValue%> </td>
<%                                     
                                        }
				}
				else if (colType.compareTo("icon") == 0)
				{
					columnValue = columnIcons[j];

					if (columnValue == null || columnValue.length() == 0)
						columnValue = "";

					if (href == null || href.length() == 0 || ( sPFmode != null && sPFmode.equals("true") ) )
					{
%>
						<td class="listCell" style="text-align: center"><img border="0" src="<%=columnValue%>"></td>
<%
					}
					else
					{
						String colItemHref = href + "&objectId=" + passOID;
						
						if(readAccess){
//sCueClass// Function FUN080585 : Removal of Cue, Tips and Views
%>
								<td class="listCell" style="text-align: center"><a href="javascript:emxTableColumnLinkClick('<%=colItemHref%>', '<%=windowWidth[j]%>', '<%=windowHeight[j]%>', '<%=popupModal[j]%>', '<%=targetLocations[j]%>')"><img border="0" src="<%=columnValue%>"></a></td>
<%
						}else{

%>
						<td class="listCell" style="text-align: center"><img border="0" src="<%=columnValue%>"></td>
<%
						}
					}
				} 
				else if (colType.compareTo("checkbox") == 0)
				{
					columnValue = checkboxAccess[j].get(i).toString();

					if ( sPFmode != null && sPFmode.equals("true") )
					{
%>
						<!-- <th></th> -->
<%
					} else {
						if (columnValue == null || columnValue.length() == 0)
							columnValue = "true";

						if (selection.compareTo("multiple") == 0)
						{
							if (columnValue != null && columnValue.equals("true") )
							{

%>
							<td style="text-align: center"><input type="checkbox" name="<%=checkboxName%>" value="<%=sValue%>" onclick="doCheckboxClick(this);doSelectAllCheck(this)" ></td>
<%
							} else {

%>
								<td style="text-align: center"><img src="../common/images/utilCheckOffDisabled.gif">&nbsp;</td>
<%
							}
						} else if (selection.compareTo("single") == 0) {
							if (columnValue != null && columnValue.equals("true") )
							{

%>
								<td style="text-align: center"><input type="radio" name="<%=checkboxName%>" value="<%=sValue%>"></td>
<%
							} else {

%>
								<td style="text-align: center"><img src="../common/images/utilRadioOffDisabled.gif">&nbsp;</td>
<%
							}
						}
					}
				}
				if (colType.compareTo("icon") != 0)
					rowData.addElement(columnValue);
			}
%>
		</td>
		</tr>
<%

	String keyName ="";
	if (elementRELID == null || elementRELID.trim().length() == 0 || elementRELID.equals("null"))
		keyName = elementOID;
	else
		keyName = elementOID + "|" + elementRELID;

	if(rowDataTable!=null)
		rowDataTable.put(keyName,rowData);
	}
	if(rowDataTable!=null)
	   session.setAttribute("DataTable"+ timeStamp, rowDataTable);
	} // end of reBusObjList null check
%>
</table>

<%

//~~~~~~~~~Set Workspace Tables to inactive mode~~~~~~~~~~~~~~
	MQLCommand mqlCmd = new MQLCommand();	
	mqlCmd.open(context);
	mqlCmd.executeCommand(context, "list table user $1",context.getUser());
	String sCommandResult = mqlCmd.getResult();	
	
	if(null != sCommandResult || !"null".equalsIgnoreCase(sCommandResult) || !"".equals(sCommandResult)){		
		StringTokenizer stringtokenizer = new StringTokenizer(sCommandResult, "\n"); 
		while(stringtokenizer.hasMoreTokens()){			
			String sTempTableName = stringtokenizer.nextToken().toString().trim();		
			mqlCmd.executeCommand(context, "modify table $1 $2;",sTempTableName,"inactive");
		}
	}//	End of if(!"".equals(sCommandResult))
	mqlCmd.close(context);

//~~~~~~~~~~~~~~~~~~~~~~~End~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ContextUtil.commitTransaction(context);
} catch (Exception ex) {
    ContextUtil.abortTransaction(context);

    if(ex.toString()!=null && (ex.toString().trim()).length()>0)
        errorMessage = ex.toString().trim();

}
%>

<input type="hidden" name="sRelationName" value="<xss:encodeForHTMLAttribute><%=emxGetSessionParameter(request,"sRelationName")%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="timeStamp" value="<xss:encodeForHTMLAttribute><%=timeStamp%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="displayMode" value="<xss:encodeForHTMLAttribute><%=displayMode%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="page" value="<xss:encodeForHTMLAttribute><%=sPage%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="reSortKey" value="<xss:encodeForHTMLAttribute><%=sortColumnName%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="setName" value="<xss:encodeForHTMLAttribute><%=setName%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="selection" value="<xss:encodeForHTMLAttribute><%=selection%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="pagination" value="<%=noOfItemsPerPage%>">
<input type="hidden" name="list" value="<xss:encodeForHTMLAttribute><%=inquiry%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="table" value="<xss:encodeForHTMLAttribute><%=tableName%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="sortColumnName" value="<xss:encodeForHTMLAttribute><%=sortColumnName%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="sortDirection" value="<xss:encodeForHTMLAttribute><%=sortDirection%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="header" value="<xss:encodeForHTMLAttribute><%=header%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="objectId" value="<xss:encodeForHTMLAttribute><%=objectId%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="jsTreeID" value="<xss:encodeForHTMLAttribute><%=jsTreeID%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="bottomActionbar" value="<xss:encodeForHTMLAttribute><%=bottomActionbar%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="headerRepeat" value="<xss:encodeForHTMLAttribute><%=sHeaderRepeat%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="parentOID" value="<xss:encodeForHTMLAttribute><%=objectId%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="RelDirection" value="<xss:encodeForHTMLAttribute><%=sRelDirection%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="RelationName" value="<xss:encodeForHTMLAttribute><%=sRelationName%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="relationship" value="<xss:encodeForHTMLAttribute><%=relationship%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="end" value="<xss:encodeForHTMLAttribute><%=end%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="WSTable" value="">
<input type="hidden" name="suiteKey" value="<xss:encodeForHTMLAttribute><%=suiteKey%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="targetLocation" value="<xss:encodeForHTMLAttribute><%=sTarget%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="queryLimit" value="<xss:encodeForHTMLAttribute><%=sQueryLimit%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="topActionbar" value="<xss:encodeForHTMLAttribute><%=topActionbar%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="instanceName" value="<xss:encodeForHTMLAttribute><%=instanceName%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="relId" value="<xss:encodeForHTMLAttribute><%=relId%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="IsAdminTable" value="<xss:encodeForHTMLAttribute><%=IsAdminTable%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="integrationName" value="<xss:encodeForHTMLAttribute><%=emxGetSessionParameter(request, "integrationName")%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="tableFilter" value="">
<input type="hidden" name="program" value="<xss:encodeForHTMLAttribute><%=sProgram%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="showIntegrationOption" value="<xss:encodeForHTMLAttribute><%=sShowIntegrationOption%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="queryName" value="<xss:encodeForHTMLAttribute><%=sQueryName%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="timeZone" value="<xss:encodeForHTMLAttribute><%=sTimeZone%></xss:encodeForHTMLAttribute>">
</form>

<%
	String appName = application.getInitParameter("ematrix.page.path");
	if(appName == null ) 
		appName = "";
	String previewServletPath = appName + "/servlet/MCADBrowserServlet";
%>
<form name="previewForm" action="<%=previewServletPath%>" method="post">

<%
boolean csrfEnabled1 = ENOCsrfGuard.isCSRFEnabled(context);
if(csrfEnabled1)
{
  Map csrfTokenMap1 = ENOCsrfGuard.getCSRFTokenMap(context, session);
  String csrfTokenName1 = (String)csrfTokenMap1 .get(ENOCsrfGuard.CSRF_TOKEN_NAME);
  String csrfTokenValue1 = (String)csrfTokenMap1.get(csrfTokenName1);
%>
  <input type="hidden" name= "<%=ENOCsrfGuard.CSRF_TOKEN_NAME%>" value="<%=csrfTokenName1%>" />
  <input type="hidden" name= "<%=csrfTokenName1%>" value="<%=csrfTokenValue1%>" />
<%
}
//System.out.println("CSRFINJECTION");
%>

        <input type="hidden" name="FileName" value="">
        <input type="hidden" name="FormatName" value="">
        <input type="hidden" name="BusObjectId" value="">
        <input type="hidden" name="Command" value="GetPreviewFile">
</form>

<script language="JavaScript">
if("<%=sFooterRefreshRequired%>" == null || !<%="false".equals(sFooterRefreshRequired)%>)
{
	if (document.emxTableForm)
	{
		var actBarUrl = "emxInfoTableFooter.jsp?displayMode=" + "<%=XSSUtil.encodeForURL(context,displayMode)%>&IsAdminTable=true&RelDirection=<%=XSSUtil.encodeForURL(context,sRelDirection)%>&RelationName=<%=XSSUtil.encodeForURL(context,sRelationName)%>";
		document.emxTableForm.action = actBarUrl;
		document.emxTableForm.target = "listFoot";
		document.emxTableForm.submit();
	}
}
</script>
<%
	if (!"".equals(errorMessage.trim()))
	{
%>
	<link rel="stylesheet" href="../emxUITemp.css" type="text/css">
	&nbsp;
      <table width="90%" border=0  cellspacing=0 cellpadding=3  class="formBG" align="center" >
        <tr >
          <td class="errorHeader"><%=serverResourceBundle.getString("mcadIntegration.Server.Heading.Error")%></td>
        </tr>
        <tr align="center">
          <td class="errorMessage" align="center"><%=errorMessage%></td>
        </tr>
      </table>
<%
	}
%>

</body>
<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
</html>

