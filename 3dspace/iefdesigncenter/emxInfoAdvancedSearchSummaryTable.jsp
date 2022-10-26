<%--  emxInfoAdvancedSearchSummaryTable.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
    $Archive: /InfoCentral/src/infocentral/emxInfoAdvancedSearchSummaryTable.jsp $
    $Revision: 1.3.1.3$
    $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoAdvancedSearchSummaryTable.jsp $
 * 
 * *****************  Version 12  *****************
 * User: Rahulp       Date: 1/16/03    Time: 10:14p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 11  *****************
 * User: Rahulp       Date: 12/03/02   Time: 1:43p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 10  *****************
 * User: Rahulp       Date: 11/29/02   Time: 4:55p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 9  *****************
 * User: Snehalb      Date: 11/25/02   Time: 8:12p
 * Updated in $/InfoCentral/src/InfoCentral
 * added try-catch block for encode
 * 
 * *****************  Version 8  *****************
 * User: Mallikr      Date: 02/11/12   Time: 18:53
 * Updated in $/InfoCentral/src/InfoCentral
 * internationalization bug fixes
 * 
 * *****************  Version 7  *****************
 * User: Rahulp       Date: 11/08/02   Time: 12:45p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 6  *****************
 * User: Gauravg      Date: 11/07/02   Time: 3:41p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 5  *****************
 * User: Mallikr      Date: 10/30/02   Time: 3:32p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 4  *****************
 * User: Rahulp       Date: 10/29/02   Time: 12:51p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 3  *****************
 * User: Bhargava     Date: 5/10/02    Time: 2:20p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 1  *****************
 * User: Bhargava     Date: 9/25/02    Time: 2:50p
 * Created in $/InfoCentral/src/InfoCentral
 *
 * ***********************************************
 *
--%>
<%@include file="emxInfoCentralUtils.inc"%>
<%@ page import = "java.net.*, com.matrixone.MCADIntegration.utils.*" %>
<%
        String funcPageName = MCADGlobalConfigObject.PAGE_SEARCH_RESULTS; 
        // Loop through parameters and pass on to summary page
	    String sParam = "&header="+ "emxIEFDesignCenter.Header.SearchResults&funcPageName=" + funcPageName;


	    // for passing expand check to JSP
	    String expandCheck = "false";

	    // for append replace check 
	    String appendCheck = "false";

	    // for supporting multiple formats 
	    String comboFormat = "";

	    for(Enumeration searchParams = emxGetParameterNames(request);searchParams.hasMoreElements();)
	    {
		    String searchParam  = (String) searchParams.nextElement();
		    if(searchParam.equalsIgnoreCase("chkExpandBox"))
		    {
			    expandCheck = "true";
		    }

		    if(searchParam.equalsIgnoreCase("comboFormats"))
		    {
			    String[] selctedFormats = emxGetParameterValues(request, searchParam);
			    for (int i=0;i<selctedFormats.length;i++)
			    {
				    if(selctedFormats[i].equals("*")){
                     comboFormat="*";
				     break;
				    }
				    comboFormat+= selctedFormats[i];
				    if(i!=selctedFormats.length-1)
   				    comboFormat+=",";
				    
			    }
		    }

		    if(searchParam.equalsIgnoreCase("chkAppendReplace"))
		    {
			    String sAppendReplace = URLEncoder.encode(emxGetParameter(request, searchParam));
			    if(sAppendReplace.equalsIgnoreCase("append"))
			    {
				    appendCheck = "true";
			    }
		    }

		    String value = URLEncoder.encode(emxGetParameter(request, searchParam));
		    String param = "&" + searchParam + "=" + value;
		    sParam+=param;
	    }

	    comboFormat = "&comboFormat="+ URLEncoder.encode(comboFormat);
	    sParam+=comboFormat;

	    String sExpandCheck = "&expandCheckFlag="+ expandCheck;
	    sParam+=sExpandCheck;
	    String sAppendCheck = "&appendCheckFlag="+ appendCheck;
	    sParam+=sAppendCheck;
	    String sTopActionBarSearch = "&topActionbar=IEFSearchResultsTopActionBarActions";
	    //String sBottomActionBarSearch = "&bottomActionbar=IEFSearchResultsBottomActionBar";
	    String sPagination = "&pagination=10&selection=multiple&headerRepeat=10";
	    String sTargetLocation = "&targetLocation=popup";
	    

        //Use jsp:forward instead of sendRedirect for faser processing
	    String sFwdPage = "emxInfoTable.jsp?program=IEFAdvancedFind:getList&table=IEF_SearchDefault"+sParam+sTopActionBarSearch+sPagination+sTargetLocation+"&suiteKey="+sInfoCentralSuite;
%>

<html>
<head>
<script language="javascript">
function redirectToNewLocation()
{
window.location.replace("<%=XSSUtil.encodeForHTML(context,sFwdPage)%>");
}
</script>
</head>
<body onLoad="redirectToNewLocation()">
</body>
</html>
