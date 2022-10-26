<%--  emxInfoUploadExternalFileDialogFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
    $Archive: /InfoCentral/src/infocentral/emxInfoUploadExternalFileDialogFS.jsp $
    $Revision: 1.3.1.3$
    $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxInfoUploadExternalFileDialogFS.jsp $
 *
 * *****************  Version 14  *****************
 * User: Rahulp       Date: 11/29/02   Time: 12:13p
 * Updated in $/InfoCentral/src/infocentral
 *
 * *****************  Version 13  *****************
 * User: Rahulp       Date: 11/29/02   Time: 11:01a
 * Updated in $/InfoCentral/src/infocentral
 *
 * *****************  Version 11  *****************
 * User: Snehalb      Date: 11/25/02   Time: 5:12p
 * Updated in $/InfoCentral/src/InfoCentral
 *
 * ***********************************************
 *
--%>

<%@include file = "emxInfoCentralUtils.inc"%>
<%@include file="../emxUICommonHeaderBeginInclude.inc"%>

<%
    String objectId = emxGetParameter(request,"parentOID");
    String initSource = emxGetParameter(request,"initSource");
    String jsTreeID = emxGetParameter(request,"jsTreeID");
    String suiteKey = emxGetParameter(request,"suiteKey");
    boolean bNextRevFound = false;
    try{
		BusinessObject boGeneric = new BusinessObject(objectId);
		boGeneric.open(context);
		BusinessObject boNextRevision = boGeneric.getNextRevision(context);

		if(boNextRevision.toString().trim().equals(".."))
			bNextRevFound = false;
		else
			bNextRevFound = true;

    	boGeneric.close(context);
    }catch(Exception e){
    	System.out.println("Exception in emxInfoUploadExternalFileDialogFS.jsp --> " + e.getMessage());
    }

    //Added to support eFCS (Formerly FTA)
    String param = fileSite+"../components/emxComponentsCheckinDialogFS.jsp?objectId="+objectId+"&showAction=true&showFormat=true";

	//Removed to support the above
	//String param = fileSite+"emxInfoCheckinDialogFS.jsp?parentOID="+objectId+"&hostSite="+hostSite+"&fileSite="+fileSite+"&initSource="+initSource+"&jsTreeID="+jsTreeID+"&suiteKey="+suiteKey;
	param = com.matrixone.apps.domain.util.FrameworkUtil.encodeURLParamValues(param);
%>
<script Language="JavaScript">
    function showCheckin()
    {
	    //XSSOK
		var url ="<%=param%>";
	    //  showCheckinDialog('<%=param%>','<%=appDirectory%>','<%=fileSite%>');
		//XSSOK
	    if(<%=bNextRevFound%>){
	    	if(confirm ("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.FileCheckin.HigherRevWarning</framework:i18nScript>"))
				emxShowModalDialog(url,600, 475,false);
		}else{
			emxShowModalDialog(url,600, 475,false);
		}
    }
</script>
<body onload = "showCheckin()">
</body>
