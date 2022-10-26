<%--  emxInfoNavigateToggleExpand.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoNavigateToggleExpand.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoNavigateToggleExpand.jsp $
 * 
 * *****************  Version 4  *****************
 * User: Rahulp       Date: 12/20/02   Time: 4:53p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 3  *****************
 * User: Mallikr      Date: 10/24/02   Time: 12:20p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 2  *****************
 * User: Mallikr      Date: 10/24/02   Time: 10:17a
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 1  *****************
 * User: Mallikr      Date: 10/09/02   Time: 6:17p
 * Created in $/InfoCentral/src/InfoCentral
 *
 * ***********************************************
 *
--%>


<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file = "emxInfoTableInclude.inc"%>
<%@include file = "emxInfoTreeTableUtil.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>

<%@ page import="com.matrixone.MCADIntegration.uicomponents.util.*"%>


<html>
<head>
	<title></title>
</head>
<body onload="toggleExpandOnServer()">

</body>
<script language="javascript">

function toggleExpandOnServer() {

<%
    //Get the request parameters
	String curSelID = emxGetParameter(request,"CurrentSelID");
	String prevSelID = emxGetParameter(request,"PreviousSelID");

	String sTimeStamp = emxGetParameter(request, "TimeStamp");
  
    //Get the Map List from the session and add all the nodes to the list
    MapList mapNavigateList = (MapList)(session.getValue("IEF_INFNavigateMap"+ sTimeStamp));
    
	IEF_INFNavigateMap curSelNode = IEF_INFNavigateMap.getNavigateMapByNodeID(mapNavigateList, curSelID);
	curSelNode.toggleExpand();

	//If the previous selection and cur selection is not the same the set the cur selection to true and previous selection to false
	if( prevSelID != null && 0 != curSelID.compareToIgnoreCase( prevSelID ) )
	{
		IEF_INFNavigateMap prevSelNode = IEF_INFNavigateMap.getNavigateMapByNodeID(mapNavigateList, prevSelID);
		
		if( prevSelNode != null)
			prevSelNode.setSelectedStatus(false);
		curSelNode.setSelectedStatus(true);
	}
	else //no previous selection
	{
		curSelNode.setSelectedStatus(true);
	}
%>


}

</script>

<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
</html>
