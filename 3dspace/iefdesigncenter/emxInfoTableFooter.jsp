<%--  emxInfoTableFooter.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoTableFooter.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoTableFooter.jsp $
 * 
 * *****************  Version 19  *****************
 * User: Shashikantk  Date: 1/28/03    Time: 3:33p
 * Updated in $/InfoCentral/src/infocentral
 * Changes made to fit the pagination bar and the close button and link
 * properly in Japanese.
 * 
 * *****************  Version 18  *****************
 * User: Shashikantk  Date: 1/17/03    Time: 12:19a
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 17  *****************
 * User: Snehalb      Date: 1/16/03    Time: 11:18p
 * Updated in $/InfoCentral/src/infocentral
 * Increased the size to accomodate the jap pagination
 * 
 * *****************  Version 16  *****************
 * User: Rahulp       Date: 1/15/03    Time: 12:19p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 15  *****************
 * User: Shashikantk  Date: 12/13/02   Time: 8:42p
 * Updated in $/InfoCentral/src/infocentral
 * Close button implemented
 * 
 * *****************  Version 14  *****************
 * User: Priteshb     Date: 12/12/02   Time: 12:24p
 * Updated in $/InfoCentral/src/infocentral
 * UI changes, addition of close button.
 * 
 * *****************  Version 13  *****************
 * User: Priteshb     Date: 11/22/02   Time: 4:30p
 * Updated in $/InfoCentral/src/InfoCentral
 * pagination modification for Unix environment
 * 
 * *****************  Version 12  *****************
 * User: Mallikr      Date: 11/19/02   Time: 6:48p
 * Updated in $/InfoCentral/src/InfoCentral
 * defect fixes
 * 
 * *****************  Version 11  *****************
 *
--%>

<%@ page import= "com.matrixone.MCADIntegration.server.beans.*,com.matrixone.MCADIntegration.utils.*,				 com.matrixone.MCADIntegration.server.*" %>

<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<%

MCADIntegrationSessionData intSessionData = (MCADIntegrationSessionData) session.getAttribute(MCADServerSettings.MCAD_INTEGRATION_SESSION_DATA_OBJECT);

MCADServerResourceBundle srvResourceBundle	= intSessionData.getResourceBundle();
String replaceDesignIsLocked				= srvResourceBundle.getString("mcadIntegration.Server.Message.ReplaceDesignIsLocked");
String replaceDesignCannotSelect			= srvResourceBundle.getString("mcadIntegration.Server.Message.ReplaceDesignCannotSelect");
String replaceDesignChooseType				= srvResourceBundle.getString("mcadIntegration.Server.Message.ReplaceDesignChooseType");
String replaceDesignSameRevVer				= srvResourceBundle.getString("mcadIntegration.Server.Message.ReplaceDesignSameRevVer");
%>

<html>
<%@include file = "emxInfoTableInclude.inc"%>
<%@include file="../emxTagLibInclude.inc"%>
<%@ page import="com.matrixone.apps.domain.util.*,com.matrixone.MCADIntegration.server.beans.*" %>
<%@include file="emxInfoCentralUtils.inc"%>
<script language="JavaScript" src="../integrations/scripts/MCADUtilMethods.js"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
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
</script>
<%
    String sTarget      =  emxGetSessionParameter(request, "targetLocation");
    String topActionbar = emxGetSessionParameter(request, "topActionbar");
    String bottomActionbar = emxGetSessionParameter(request, "bottomActionbar");
    String timeStamp = emxGetParameter(request, "timeStamp");
    String reload = emxGetSessionParameter(request, "reload");
    String inquiry = emxGetSessionParameter(request, "inquiry");
    String tableName = emxGetSessionParameter(request, "table");
    String jsTreeID = emxGetSessionParameter(request, "jsTreeID");
    String objectId = emxGetSessionParameter(request, "objectId");
    String relId = emxGetSessionParameter(request, "relId");
    String sortColumnName = emxGetSessionParameter(request, "sortColumnName");
    String sortDirection = emxGetSessionParameter(request, "sortDirection");
    String selection = emxGetSessionParameter(request, "selection");
    String pagination = emxGetSessionParameter(request, "pagination");
    String sPage = emxGetParameter(request, "page");
    String sHeaderRepeat = emxGetSessionParameter(request, "headerRepeat");
    String sCurrLang=request.getHeader("Accept-Language");
    String sPageText = UINavigatorUtil.getI18nString("emxIEFDesignCenter.TableComponent.Page", "emxIEFDesignCenterStringResource", sCurrLang);
    String sOf   = UINavigatorUtil.getI18nString("emxIEFDesignCenter.TableComponent.Of", "emxIEFDesignCenterStringResource", sCurrLang);
    String sPaginationOff = UINavigatorUtil.getI18nString("emxIEFDesignCenter.TableComponent.PaginationOff", "emxIEFDesignCenterStringResource", sCurrLang);
    String sPaginationOn = UINavigatorUtil.getI18nString("emxIEFDesignCenter.TableComponent.PaginationOn", "emxIEFDesignCenterStringResource", sCurrLang);
    String sNextPage = UINavigatorUtil.getI18nString("emxIEFDesignCenter.TableComponent.NextPage", "emxIEFDesignCenterStringResource", sCurrLang);
    String sPreviousPage = UINavigatorUtil.getI18nString("emxIEFDesignCenter.TableComponent.PreviousPage", "emxIEFDesignCenterStringResource", sCurrLang);
	String sWSTableName = emxGetSessionParameter(request, "WSTable");
	String sIsAdminTable = emxGetSessionParameter(request, "IsAdminTable");
    String sRelDirection =emxGetSessionParameter(request,"sRelDirection");
    String sRelationName=emxGetSessionParameter(request,"sRelationName");
	String sQueryLimit = emxGetSessionParameter(request,"queryLimit");
	String strCancel = "";
	String operationButtonImage ="";
	strCancel = UINavigatorUtil.getI18nString("emxIEFDesignCenter.Common.Close","emxIEFDesignCenterStringResource",sCurrLang);
    operationButtonImage ="../iefdesigncenter/images/emxUIButtonCancel.gif";
	String integrationName="";	
   
	HashMap paramMap = (HashMap)session.getAttribute("ParameterList" + timeStamp);

    int currentIndex = 0;

    if (session.getAttribute("CurrentIndex" + timeStamp) != null)
        currentIndex = ((Integer)session.getAttribute("CurrentIndex" + timeStamp)).intValue();

    String displayMode = "";


    if (sPage != null && sPage.equals("1"))
        currentIndex = 0;

    MapList bol = (MapList)session.getAttribute("BusObjList" + timeStamp);

	if (pagination == null || pagination.trim().length() == 0 || pagination.equals("null") || pagination.equals("0") )
        pagination = "15";

    displayMode = emxGetParameter(request, "displayMode");

    int noOfItemsPerPage = Integer.parseInt(pagination);
	if (noOfItemsPerPage == 0)
    {
        if (bol != null)
            noOfItemsPerPage = bol.size();
    }
%>
<head>
<title>Action Bar</title>
<meta http-equiv="imagetoolbar" content="no">
<% 
    if(sTarget != null && !sTarget.equals("") && !"null".equals(sTarget))
    {
       if(sTarget.equals("content") &&  !sTarget.equals(""))	
       {
       	
%>
		<link rel="stylesheet" type="text/css" href="../common/styles/emxUIDefault.css" />
		<link rel="stylesheet" type="text/css" href="../common/styles/emxUIList.css" />
		
	
<%       	
       }
       else
       {
%>
		<link rel="stylesheet" type="text/css" href="../common/styles/emxUIDefault.css" />
		<link rel="stylesheet" type="text/css" href="../common/styles/emxUIList.css" />
		<link rel="stylesheet" type="text/css" href="../common/styles/emxUISearch.css" />
	       
<%	
       }
    	
    	
    }
    else
    {
%>    	
  		<link rel="stylesheet" type="text/css" href="../common/styles/emxUIDefault.css" />
		<link rel="stylesheet" type="text/css" href="../common/styles/emxUIList.css" />
		
<%    	
    }
    
   
%>	

<%@include file = "emxInfoUIConstantsInclude.inc"%>
<script language="JavaScript" src="emxInfoUIModal.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUIActionbar.js" type="text/javascript"></script>
<script language="JavaScript">

   // function navigatePage (page, displayMode)
   function navigatePage (page , displayMode)
   {
	    // if there is filter, the wait clock in frames[1] instead of frames[0]
	    if (parent.frames[0].name=='listFilter')
		   parent.frames[1].document.forms.tableHeaderForm.imgProgress.src = "../common/images/utilProgressSummary.gif";
		else
			parent.frames[0].document.forms.tableHeaderForm.imgProgress.src = "../common/images/utilProgressSummary.gif";

		//decide between the admin table body & WS table body
		//XSSOK
		if(<%=sIsAdminTable != null && sIsAdminTable.compareToIgnoreCase("true") == 0%>)
	    {
			var pageUrl = "emxInfoTableAdminBody.jsp?page=" + page + "&displayMode=" + displayMode;		   
	    }			
		else
	    {
			var pageUrl = "emxInfoTableWSBody.jsp?page=" + page + "&displayMode=" + displayMode;
		}

        parent.listDisplay.document.emxTableForm.action = pageUrl;
        parent.listDisplay.document.emxTableForm.target = "listDisplay";
        parent.listDisplay.document.emxTableForm.submit();

   }

    function getUserSelectedRow()
   {
	   var objForm = parent.frames['listDisplay'].document.forms['emxTableForm'];
       var objectId = "";
	   if (objForm && objForm.emxTableRowId)
       {
          if (objForm.emxTableRowId[0])
          {
              for (var i = 0; i < objForm.emxTableRowId.length; i++)
              {
                if(objForm.emxTableRowId[i].checked == true)
                {
                   objectId = objForm.emxTableRowId[i].value;
                }
              }
          } 
		  else
		  {
			 if(objForm.emxTableRowId.checked == true)
			 {
                objectId = objForm.emxTableRowId.value;
			 }
          }
      }
	  return objectId;
   }
   function getSelectedRow()
   {
	   var objForm = parent.frames['listDisplay'].document.forms['emxTableForm'];
       var objectId ="";
		if (objForm && objForm.emxTableRowId)
       {
          if (objForm.emxTableRowId[0])
          {
              for (var i = 0; i < objForm.emxTableRowId.length; i++)
              {
                if(objForm.emxTableRowId[i].checked == true)
                {
                   objectId = objForm.emxTableRowId[i].value;
                }
              }
          } 
		  else
		  {
             objectId = objForm.emxTableRowId.value;
          }
      }
	  return objectId;

   }

    function getUsrSelectedRow()
   {
	   var objForm = parent.frames['listDisplay'].document.forms['emxTableForm'];
       var objectId ="";
		if (objForm && objForm.emxTableRowId)
       {
          if (objForm.emxTableRowId[0])
          {
              for (var i = 0; i < objForm.emxTableRowId.length; i++)
              {
                if(objForm.emxTableRowId[i].checked == true)
                {
                   objectId = objForm.emxTableRowId[i].value;
                }
              }
          } 
		  else
		  {
         	 if(objForm.emxTableRowId.checked == true)
			 {
                objectId = objForm.emxTableRowId.value;
			 }
          }
      }
	  return objectId;

   }	

	function selectObjectForReplace()
	{
		var id				= getUserSelectedRow();
		var lockStatus		= top.opener.isLocked(id);
		var lockStatusArray	= lockStatus.split('|');

		var isLocked		= lockStatusArray[0];
		var locker			= lockStatusArray[1];

		if(isLocked != "false")
		{
			var message = top.opener.setSelectedObjIdForReplace(id);
			
			if(message == null || message == "")
				parent.window.close();
			else
				alert(message);
		}
		else
		    <!--XSSOK-->
			alert("<%=replaceDesignIsLocked%>" + locker + ' ' + "<%=replaceDesignCannotSelect%>");
	}

   function closeWindow() 
   {	   
	  parent.window.close();
   }

</script>

</head>
<body>
<form name=footerForm method="post">

<%
boolean csrfEnabled = ENOCsrfGuard.isCSRFEnabled(context);
if(csrfEnabled)
{
  Map csrfTokenMap = ENOCsrfGuard.getCSRFTokenMap(context, session);
  String csrfTokenName = (String)csrfTokenMap .get(ENOCsrfGuard.CSRF_TOKEN_NAME);
  String csrfTokenValue = (String)csrfTokenMap.get(csrfTokenName);
%>
  <!--XSSOK-->
  <input type="hidden" name= "<%=ENOCsrfGuard.CSRF_TOKEN_NAME%>" value="<%=csrfTokenName%>" />
  <!--XSSOK-->
  <input type="hidden" name= "<%=csrfTokenName%>" value="<%=csrfTokenValue%>" />
<%
}
//System.out.println("CSRFINJECTION");
%>


<%
	int noOfPages = 1;
	int currentPage = 0;

	if (bol != null)
	{
		noOfPages = bol.size() / noOfItemsPerPage;
		if ((bol.size() % noOfItemsPerPage) !=0)
			noOfPages++;
	}

	currentPage = currentIndex / noOfItemsPerPage;
	
	if( noOfPages > 1) //display the pagination control only if the no of pages > 1
	{

          String leftPgImage = "../common/images/utilPaginationLeft.gif";
          String rightPgImage = "../common/images/utilPaginationRight.gif";
          String bgPgImage = "../common/images/utilPaginationBG.gif";
          String trClass = "";
          String userAgent = request.getHeader("User-Agent"); 

          //display differently for Unix
          if (( userAgent.toLowerCase().indexOf("sunos") > -1 || userAgent.toLowerCase().indexOf("x11") > -1 )){
            leftPgImage = "../common/images/utilSpacer.gif";
            rightPgImage = "../common/images/utilSpacer.gif";
            bgPgImage = "../common/images/utilSpacer.gif";
            trClass = " class=\"even\"";
          }

%>
        <table border="0" cellspacing="2" cellpadding="0" width="100%">
        <tr>
        <td class="pageBorder"><img src="../common/images/utilSpacer.gif" width="1" height="1" alt=""></td>
        </tr>
        </table>

        <table border="0" cellspacing="2" cellpadding="0" width="100%">
        <tr>
        <td width="90%">

        <table border="0" width="100%" cellspacing="0" cellpadding="3">
        <tr>
        <td width="55%"><img src="../common/images/utilSpacer.gif" border="0" width="5" height="20" alt=""></td>
        <td width="1%"><img src="../common/images/utilSpacer.gif" width="1" height="28" alt=""></td>
        <td align="right">
		<!--XSSOK-->
        <table border="0" cellspacing="0" cellpadding="0" background= <%=bgPgImage%> >
		<!--XSSOK-->
        <tr <%=trClass%>>
		<!--XSSOK-->
        <td><img src=<%=leftPgImage%>></td>
        <td><img src="../common/images/utilSpacer.gif" width="6" height="1"></td>
<%

            if (displayMode == null || displayMode.length() == 0 || displayMode.equals("null") )
                displayMode = "multiPage";

            if (displayMode.equals("multiPage"))
            {
                if (currentIndex != 0)
                {
%>
                <!--XSSOK-->
                <td><a href="javascript:navigatePage('previous' , '')"><img src="images/buttonPrevPage.gif" border="0" alt="<%=sPreviousPage%>" width="16" height="16"></a></td>
<%
            }
            else
            {
%>
                <!--XSSOK-->
                <td><img src="images/buttonPrevPageDisabled.gif" border="0" alt="<%=sPreviousPage%>" width="16" height="16"></td>
<%
            }
     

%>
            <td><img src="../common/images/utilSpacer.gif" width="7"></td>
			<!--XSSOK-->
            <td><%=sPageText%>&#160;</td>
            <td><select name="menu1" class="pagination" onchange="javascript:navigatePage(document.footerForm.menu1.selectedIndex + 1 , '')">
<%
            for (int i = 0; i < noOfPages; i++)
            {
                if (currentPage == i)
                {
%>
                    <option class="pagination" selected><%=i+1%></option>
<%
                }
                else
                {
%>
                    <option class="pagination"><%=i+1%></option>
<%
                }
            }
%>
            </select></td>
			<!--XSSOK-->
            <td nowrap>&#160;<%=sOf%> <%=noOfPages%></td>
            <td><img src="../common/images/utilSpacer.gif" width="9" height="8"></td>
<%
            if ( bol != null && bol.size() > (currentIndex + noOfItemsPerPage))
            {
%>
                <!--XSSOK-->
                <td><a href="javascript:navigatePage( 'next' , '')"><img src="../common/images/buttonNextPage.gif" border="0" alt="<%=sNextPage%>" width="16" height="16"></a></td>
<%
            }
            else
            {
%>
                <!--XSSOK-->
                <td><img src="../common/images/buttonNextPageDisabled.gif" border="0" alt="<%=sNextPage%>" width="16" height="16"></a></td>
<%
            }
%>
            <td><img src="../common/images/utilSpacer.gif" width="9" height="8"></td>
            <td nowrap="nowrap">
			<!--XSSOK-->
            <img src="../common/images/buttonMultiPageDown.gif" border="0" alt="<%=sPaginationOn%>"><a href="javascript:navigatePage( document.footerForm.menu1.selectedIndex + 1 , 'singlePage')"><img src="../common/images/buttonSinglePageUp.gif" border="0" alt="<%=sPaginationOff%>"></a>
            </td>

<%
        } else {
%>
            <td nowrap="nowrap">
			<!--XSSOK-->
            <a href="javascript:navigatePage(document.footerForm.page.value , 'multiPage')"><img src="../common/images/buttonMultiPageUp.gif" border="0" alt="<%=sPaginationOn%>"></a><img src="../common/images/buttonSinglePageDown.gif" border="0" alt="<%=sPaginationOff%>">
            </td>
<%
        }
%>
        </td>
        <td><img src="../common/images/utilSpacer.gif" width="6" height="1"></td>
		<!--XSSOK-->
        <td><img src=<%=rightPgImage%>></td>
        </tr>
        </table>
        </td>
        </tr>
        </table>
        </td>
<%
        if(sTarget!= null && sTarget.equals("popup"))
		{
%>
        <!--XSSOK-->
        <td align="right"><a href="javascript:closeWindow()"><img src="<%=operationButtonImage%>" border="0"></a>&nbsp</td>
		<!--XSSOK-->
		<td align="left" valign="middle"><a href="javascript:closeWindow()"><%=strCancel%></a></td>
<% 
	    } else {
%>
        <td><img src="../common/images/utilSpacer.gif" alt="" width="4"></td>
<%
	    }
%>
 
        </tr>
        </table>
<%
    } //end of if ( noOfPages > 1)
    else{
%>
	<table border="0" cellspacing="2" cellpadding="0" align="right">
	<tr>
	
<%
      if(sTarget!= null && sTarget.equals("popup"))
	  {
%>
        <!--XSSOK-->
        <td align="right" valign="bottom"><a href="javascript:closeWindow()"><img src="<%=operationButtonImage%>" border="0"></a>&nbsp</td>
		<!--XSSOK-->
		<td align="left" valign="middle"><a href="javascript:closeWindow()"><%=strCancel%></a></td>
<% 
	  } else {
%>
        <td><img src="../common/images/utilSpacer.gif" alt="" width="4"></td>
<%
	  }
%>	
	</tr>
	</table>
<%
    }
%>
	

<input type="hidden" name="topActionBar" value="<xss:encodeForHTMLAttribute><%=topActionbar%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="bottomActionBar" value="<xss:encodeForHTMLAttribute><%=bottomActionbar%></xss:encodeForHTMLAttribute>">
<!--XSSOK-->
<input type="hidden" name="pagination" value="<%=noOfItemsPerPage%>">
<input type="hidden" name="jsTreeID" value="<xss:encodeForHTMLAttribute><%=jsTreeID%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="sortColumnName" value="<xss:encodeForHTMLAttribute><%=sortColumnName%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="reSortKey" value="<xss:encodeForHTMLAttribute><%=sortColumnName%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="inquiry" value="<xss:encodeForHTMLAttribute><%=inquiry%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="table" value="<xss:encodeForHTMLAttribute><%=tableName%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="page" value="<xss:encodeForHTMLAttribute><%=sPage%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="selection" value="<xss:encodeForHTMLAttribute><%=selection%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="timeStamp" value="<xss:encodeForHTMLAttribute><%=timeStamp%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="displayMode" value="<xss:encodeForHTMLAttribute><%=displayMode%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="headerRepeat" value="<xss:encodeForHTMLAttribute><%=sHeaderRepeat%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="objectId" value="<xss:encodeForHTMLAttribute><%=objectId%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="parentOID" value="<xss:encodeForHTMLAttribute><%=objectId%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="WSTable" value="<xss:encodeForHTMLAttribute><%=sWSTableName%></xss:encodeForHTMLAttribute>">
</form>

<script language="JavaScript">

// This variable positions the action item list from the top os the frame
var actionItemTopPos = 10;
var actionItemLeftPos = 10;
var visibleLinks = 2;

</script>

<%
  if ( !(bottomActionbar == null) && !(bottomActionbar.equals("")) && !(bottomActionbar.equalsIgnoreCase("null")) )
  {
%>
<jsp:include page = "emxInfoActionBar.jsp" flush="true">
    <jsp:param name="parentOID" value="<xss:encodeForHTMLAttribute><%=objectId%></xss:encodeForHTMLAttribute>"/>
    <jsp:param name="actionBarName" value="<xss:encodeForHTMLAttribute><%=bottomActionbar%></xss:encodeForHTMLAttribute>"/>
    <jsp:param name="queryLimit" value="<xss:encodeForHTMLAttribute><%=sQueryLimit%></xss:encodeForHTMLAttribute>"/>
    <jsp:param name="timeStamp" value="<xss:encodeForHTMLAttribute><%=timeStamp%></xss:encodeForHTMLAttribute>"/>
   
    
</jsp:include>
<%
  }
%>

</body>
</html>
