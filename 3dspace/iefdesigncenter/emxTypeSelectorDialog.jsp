<%--  emxTypeSelectorDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
    $Archive: /InfoCentral/src/infocentral/emxTypeSelectorDialog.jsp $
    $Revision: 1.3.1.3$
    $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxTypeSelectorDialog.jsp $
 * 
 * *****************  Version 15  *****************
 * User: Rahulp       Date: 1/16/03    Time: 8:43p
 * Updated in $/InfoCentral/src/infocentral
 * 
 ************************************************
 *
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<%@include file="emxInfoCentralUtils.inc"%> 			<%--For context, request wrapper methods, i18n methods--%>
<html>
<head>
  <title>Search</title>
  <script language="javascript" src="emxInfoTypeBrowser.js"></script>

<script>
    //get the data from the opener
    var bAbstractSelect = opener.bAbstractSelect, bMultiSelect = opener.bMultiSelect;
    var bReload = opener.bReload;
    var arrTypes = opener.arrTypes, txtType = opener.txtType, txtTypeDisp = opener.txtTypeDisp;
    //var arrTypes = opener.arrTypes, txtTypeDisp = opener.txtTypeDisp;

    //create type browser object
    var tb = new jsTypeBrowser(bAbstractSelect, bMultiSelect);
</script>

</head>
<%
    String appendParam = emxGetQueryString(request);  
	appendParam = FrameworkUtil.encodeURLParamValues("emxTypeTreeHeader.jsp?" + appendParam);
%>
<frameset rows="75,*,60" frameborder="no" framespacing="2" >
  <!--XSSOK-->
  <frame src="<%=appendParam%>" marginwidth="0" marginheight="0" scrolling="no" />
  <frame src="emxBlank.jsp" name="treeDisplay" marginwidth="4" marginheight="1" />
  <frame src="emxTypeSelectorForm.jsp" marginwidth="0" marginheight="0" noresize="noresize" scrolling="no" />
</frameset>
</html>
