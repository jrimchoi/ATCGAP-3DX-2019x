<%--  DSCSearchSummaryTable.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoSearchSummaryTable.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxInfoSearchSummaryTable.jsp $
 * 
 * *****************  Version 16  *****************
 * User: Rahulp       Date: 12/03/02   Time: 1:43p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 15  *****************
 * User: Rahulp       Date: 11/29/02   Time: 4:55p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 14  *****************
 * User: Sameeru      Date: 02/11/15   Time: 5:16p
 * Updated in $/InfoCentral/src/InfoCentral
 * Correcting Header Display
 * 
 * *****************  Version 13  *****************
 * User: Mallikr      Date: 02/11/12   Time: 18:53
 * Updated in $/InfoCentral/src/InfoCentral
 * internationalization bug fixes
 * 
 * *****************  Version 12  *****************
 * User: Gauravg      Date: 11/07/02   Time: 3:41p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 11  *****************
 * User: Mallikr      Date: 10/30/02   Time: 3:32p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 10  *****************
 * User: Rahulp       Date: 10/29/02   Time: 12:51p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 9  *****************
 * User: Bhargava     Date: 3/29/02    Time: 12:09p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 8  *****************
 * User: Bhargava     Date: 10/21/02   Time: 4:18p
 * Updated in $/InfoCentral/src/InfoCentral
 * web sphere related fix
 * 
 * *****************  Version 7  *****************
 * User: Bhargava     Date: 5/10/02    Time: 2:20p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 6  *****************
 * User: Bhargava     Date: 10/03/02   Time: 9:54a
 * Updated in $/InfoCentral/src/InfoCentral
 * append / replace functionality 
 * 
 * *****************  Version 4  *****************
 * User: Bhargava     Date: 9/24/02    Time: 4:06p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 3  *****************
 * User: Bhargava     Date: 9/24/02    Time: 12:22p
 * Updated in $/InfoCentral/src/InfoCentral
 *
 * ***********************************************
 *
--%>

<%@ page import = "java.net.*" %>
<%@include file = "../emxUICommonAppInclude.inc"%>
<%@include file = "../teamcentral/emxTeamCommonUtilAppInclude.inc"%>
<%@include file = "../emxUICommonHeaderBeginInclude.inc" %>
<%@include file = "DSCCommonUtils.inc" %>
<%@ include file = "DSCAppletUtils.inc"%>
<%@include file = "../common/emxUIConstantsInclude.inc"%>
<%@ page import="com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.beans.*"  %>
<script language="javascript" type="text/javascript" src="../common/scripts/emxUICalendar.js"></script>
<script language="JavaScript" src="../iefdesigncenter/emxInfoUIModal.js"></script> 
<script language="javascript" src="../iefdesigncenter/emxInfoCentralJavaScriptUtils.js"></script>
<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script> <%--Required by emxUIActionbar.js below--%>
<script language="JavaScript" src="../common/scripts/emxUIActionbar.js" type="text/javascript"></script> <%--To show javascript error messages--%>
<script language="JavaScript" src="../common/scripts/emxJSValidationUtil.js" type="text/javascript"></script> <%--To show javascript error messages--%>
<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICore.js"></script>


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
%>
<%
  
// Loop through parameters and pass on to summary page

	String sParam = "&header=emxIEFDesignCenter.Header.SearchResults&suiteKey=DesignerCentral";
  	//String sParam = "";//"&header=emxIEFDesignCenter.Header.SearchResults"; 
	// for append replace check 
	String appendCheck = "false";

	//--Replace Get the operation type and the selection(radio button)
	String replaceOperation = emxGetParameter(request,"replaceOperationType");
	String selectionType    = emxGetParameter(request,"selection");
	
	for(Enumeration searchParams = emxGetParameterNames(request);searchParams.hasMoreElements();)
	{
		String searchParam  = (String) searchParams.nextElement();
		if(searchParam.equalsIgnoreCase("chkAppendReplace"))
		{
			String sAppendReplace = URLEncoder.encode(emxGetParameter(request, searchParam));
			if(sAppendReplace.equalsIgnoreCase("append"))
			{
				appendCheck = "true";
			}
		}
		String value = emxGetParameter(request, searchParam);
		String param = "";
		//--Replace Get the operation type and the selection(radio button)
        if(replaceOperation!=null && !replaceOperation.equals("") && searchParam.equals("selection"))
		{
			param = "&" + searchParam + "=" + "single";
		}
		else
		{
		   param = "&" + searchParam + "=" + value;
		}
		if (value != null && !("".equals(value.trim()) || "*".equals(value.trim())) )
			sParam+=param;
	}
	String sExpandCheck = "&expandCheckFlag=true";
	sParam+=sExpandCheck;
	String sAppendCheck = "&"+"appendCheckFlag="+ appendCheck;
	sParam+=sAppendCheck;
	String sTopActionBarSearch = "&topActionbar=DSCSearchResultTopActionBar";
		//Replace--Check for the operation of replace.
	
	String sPagination = "";
	if(replaceOperation!=null && !replaceOperation.equals(""))
	{
		//The radio button will be show instead of check boxes on the search results page.
		String replaceOperationParam = "&replaceOperationType=" + replaceOperation;
		sPagination = "&pagination=10&headerRepeat=10";
		String selParam = "&selection=single";
		sPagination+=selParam;
		sPagination+=replaceOperationParam;
	}
	else
	{
	   sPagination = "&pagination=10&selection=multiple&headerRepeat=10";
	}
	
	String sTargetLocation = "&targetLocation=popup";
	String sErrorMsg = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Error.SearchFailed",request.getHeader("Accept-Language"));
	sErrorMsg = "&errorMessage=" + URLEncoder.encode(sErrorMsg);
	String sdefualtsort= "&sortColumnName=name&Sortdirection=ascending";
	sParam = escapeJavascript(sParam);
	//redirect to the search results page ( displayed using emxInfoTable.jsp )
	//User jsp:forward instead of sendRedirect for faser processing
	//Replace--Get the current major id + its minors
	String currObjMajorId = emxGetParameter(request,"currObjMajorId");
	String sFwdPage = "../iefdesigncenter/emxInfoTable.jsp?table=DSCDefault"+sParam+sTopActionBarSearch+sPagination+sTargetLocation+sErrorMsg+sdefualtsort;
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
