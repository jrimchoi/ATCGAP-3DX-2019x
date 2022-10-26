<%--  DSCModifyQuery.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
    $Archive: /InfoCentral/src/infocentral/emxInfoAdvancedSearchSummaryTable.jsp $
--%>

<%--
 *
 * $History: emxInfoAdvancedSearchSummaryTable.jsp $
 * 
 * *****************  Version 12  *****************
 * User: Rahulp       Date: 1/16/03    Time: 10:14p
 * Updated in $/InfoCentral/src/infocentral
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

	    String formats = "&comboFormat="+ URLEncoder.encode(comboFormat);
	    sParam+=formats;

	    String sExpandCheck = "&expandCheckFlag="+ expandCheck;
	    sParam+=sExpandCheck;
	    String sAppendCheck = "&appendCheckFlag="+ appendCheck;
	    sParam+=sAppendCheck;
	    String sTopActionBarSearch = "&topActionbar=DSCSearchResultTopActionBar";
	    //String sBottomActionBarSearch = "&bottomActionbar=IEFSearchResultsBottomActionBar";
	    String sPagination = "&pagination=10&selection=multiple&headerRepeat=10";
	    String sTargetLocation = "&targetLocation=popup";
	    
        //Use jsp:forward instead of sendRedirect for faser processing
	    String sFwdPage = "emxInfoSavedQueryResults.jsp?program=IEFFilterQuery:getList&table=DSCDefault"+sParam+sTopActionBarSearch+sPagination+sTargetLocation+"&suiteKey="+sInfoCentralSuite;
//System.out.println("+++ DSCModifyQuery.jsp: sFwdPage = " + sFwdPage); 
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
