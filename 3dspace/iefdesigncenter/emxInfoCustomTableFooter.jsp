<%--  emxInfoCustomTableFooter.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--

$Archive: /InfoCentral/src/infocentral/emxInfoCustomTableFooter.jsp $
$Revision: 1.3.1.3$
$Author: ds-mbalakrishnan$

Name of the File :emxInfoCustomTableFooter.jsp

Description : This jsp page sets the footer for Custom Table

--%>

<%--
*
* $History: emxInfoCustomTableFooter.jsp $
 * ******************  Version 20  *****************
 * User: Rajesh G  Date: 02/15/04    Time: 7:00p
 * Updated in $/InfoCentral/src/infocentral
 * To enable the esc key and key board support
 * 
 * *****************  Version 19  *****************
 * User: Shashikantk  Date: 1/28/03    Time: 3:33p
 * Updated in $/InfoCentral/src/infocentral
 * Changes made to fit the pagination bar and the close button and link
 * properly in Japanese.
 * 
 * *****************  Version 18  *****************
 * User: Shashikantk  Date: 1/17/03    Time: 12:15a
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 16  *****************
 * User: Shashikantk  Date: 12/13/02   Time: 8:42p
 * Updated in $/InfoCentral/src/infocentral
 * Close button implemented
 * 
 * *****************  Version 15  *****************
 * User: Gauravg      Date: 12/12/02   Time: 5:57p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 14  *****************
 * User: Rahulp       Date: 12/05/02   Time: 2:02p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 13  *****************
 * User: Mallikr      Date: 11/26/02   Time: 2:04p
 * Updated in $/InfoCentral/src/InfoCentral
 * code cleanup for indentation
 * 
 * *****************  Version 12  *****************
 * User: Gauravg      Date: 11/25/02   Time: 4:11p
 * Updated in $/InfoCentral/src/InfoCentral
 * For indentattion
* 
* *****************  Version 11  *****************
* User: Rahulp       Date: 11/22/02   Time: 8:07p
* Updated in $/InfoCentral/src/InfoCentral
* 
* *****************  Version 5  *****************
* User: Rahulp       Date: 10/07/02   Time: 7:19p
* Updated in $/InfoCentral/src/InfoCentral
* 
* *****************  Version 4  *****************
* User: Snehalb      Date: 10/04/02   Time: 7:21p
* Updated in $/InfoCentral/src/InfoCentral
* renamed bol as boList
* 
* *****************  Version 3  *****************
* User: Gauravg      Date: 10/02/02   Time: 6:49p
* Updated in $/InfoCentral/src/InfoCentral
* 
* *****************  Version 2  *****************
* User: Gauravg      Date: 9/30/02    Time: 5:56p
* Updated in $/InfoCentral/src/InfoCentral
*
*
***********************************************
--%>

<html>

<!-- 12/17/2003        start    rajeshg   -->
<script language="JavaScript">
// Main function
  function cptKey(e) 
  {
    var pressedKey = ("undefined" == typeof (e)) ? event.keyCode : e.keyCode ;
		// for disabling backspace
		if (((pressedKey == 8) ||((pressedKey == 37) && (event.altKey)) || ((pressedKey == 39) && (event.altKey))) &&((event.srcElement.form == null) || (event.srcElement.isTextEdit == false)))
			return false;
		if( (pressedKey == 37 && event.altKey) || (pressedKey == 39 && event.altKey) && (event.srcElement.form == null || event.srcElement.isTextEdit == false))
			return false;
	
    if (pressedKey == "27") 
    { 
       // ASCII code of the ESC key
       top.window.close();
    }
    
  }
  
// Add a handler
document.onkeypress = cptKey ;

</script>
<!-- 12/17/2003        End    rajeshg  -->



<%@ page import="com.matrixone.MCADIntegration.uicomponents.util.*" %>
<%@ page import="com.matrixone.MCADIntegration.uicomponents.beans.*" %>
<%@include file = "emxInfoCustomTableInclude.inc"%>
<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<%
String sTarget = emxGetParameter(request, "custTargetLocation");
String topActionbar = emxGetParameter(request, "custTopActionbar");
String bottomActionbar = emxGetParameter(request, "custBottomActionbar");
String timeStamp = emxGetParameter(request, "timeStamp");
String reload = emxGetParameter(request, "reload");
String jsTreeID = emxGetParameter(request, "jsTreeID");
String objectId = emxGetParameter(request, "objectId");
String relId = emxGetParameter(request, "relId");
String sortColumnName = emxGetParameter(request, "custSortColumnName");
String sortDirection = emxGetParameter(request, "custSortDirection");
String selection = emxGetParameter(request, "custSelection");
String pagination = emxGetParameter(request, "custPagination");
String sPage = emxGetParameter(request, "custPageNo");
String sHeaderRepeat = emxGetParameter(request, "custHeaderRepeat");
String sCurrLang=request.getHeader("Accept-Language");
String sPageText = UINavigatorUtil.getI18nString("emxIEFDesignCenter.TableComponent.Page", "emxIEFDesignCenterStringResource", sCurrLang);
String sOf   = UINavigatorUtil.getI18nString("emxIEFDesignCenter.TableComponent.Of", "emxIEFDesignCenterStringResource", sCurrLang);
String sPaginationOff = UINavigatorUtil.getI18nString("emxIEFDesignCenter.TableComponent.PaginationOff", "emxIEFDesignCenterStringResource", sCurrLang);
String sPaginationOn = UINavigatorUtil.getI18nString("emxIEFDesignCenter.TableComponent.PaginationOn", "emxIEFDesignCenterStringResource", sCurrLang);
String sNextPage = UINavigatorUtil.getI18nString("emxIEFDesignCenter.TableComponent.NextPage", "emxIEFDesignCenterStringResource", sCurrLang);
String sPreviousPage = UINavigatorUtil.getI18nString("emxIEFDesignCenter.TableComponent.PreviousPage", "emxIEFDesignCenterStringResource", sCurrLang);
String strCancel = UINavigatorUtil.getI18nString("emxIEFDesignCenter.Common.Close","emxIEFDesignCenterStringResource",sCurrLang);
int currentIndex = 0;

if (session.getAttribute("CurrentIndex" + timeStamp) != null)
currentIndex = ((Integer)session.getAttribute("CurrentIndex" + timeStamp)).intValue();

String displayMode = "";

if (sPage != null && sPage.equals("1"))
currentIndex = 0;

IEF_CustomMapList boList = (IEF_CustomMapList)session.getAttribute("TableData" + timeStamp);

if (pagination == null || pagination.trim().length() == 0 || pagination.equals("null") )
	pagination = "15";

displayMode = emxGetParameter(request, "custDisplayMode");

int noOfItemsPerPage = Integer.parseInt(pagination);

if (noOfItemsPerPage == 0 && boList != null)
{
    noOfItemsPerPage = boList.size();
}

%>
<head>

<title>Action Bar</title>

<meta http-equiv="imagetoolbar" content="no">
<%
if(sTarget != null &&  !sTarget.equals(""))
{
	if(sTarget.equals("content"))	
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
	
} //end of if( sTarget ...)
else
{
%>    	
	<link rel="stylesheet" type="text/css" href="../common/styles/emxUIDefault.css" />
	<link rel="stylesheet" type="text/css" href="../common/styles/emxUIList.css" />
		
<%    	
}

%>    

<%@include file= "emxInfoUIConstantsInclude.inc"%>

<script language="JavaScript" src="emxInfoUIModal.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUIActionbar.js" type="text/javascript"></script>
<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICore.js"></script>

<script language="JavaScript">

  var progressBarCheck = 1;

  function removeProgressBar(){
    progressBarCheck++;
    if (progressBarCheck < 10){
      if( parent.frames[0] && parent.frames[0].document.progress){
        parent.frames[0].document.progress.src = "../common/images/utilSpacer.gif";
      }else{
        setTimeout("removeProgressBar()",500);
      }
    }
    return true;
  }

// function navigatePage (page, displayMode)
function navigatePage (page , displayMode)
{
	var pageUrl = "emxInfoCustomTableBody.jsp?custPageNo=" + page + "&custDisplayMode=" + displayMode;
	parent.listDisplay.document.emxTableForm.action = pageUrl;
	parent.listDisplay.document.emxTableForm.target = "listDisplay";
	parent.listDisplay.document.emxTableForm.submit();
}

</script>

</head>
<body onLoad="removeProgressBar()">
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
//System.out.println("CSRFINJECTION::emxInfoCustomTableFooter.jsp::form::footerForm");
%>

<table border="0" cellspacing="2" cellpadding="0" width="100%">
<tr>
<td class="pageBorder"><img src="../common/images/utilSpacer.gif" width="1" height="1" alt=""></td>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tr>
<td width="99%"></td>
</tr>
</table>
<%
int noOfPages = 1;
int currentPage = 0;

if (boList != null)
{
    noOfPages = boList.size() / noOfItemsPerPage;
    if ((boList.size() % noOfItemsPerPage) !=0)
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
	if (( userAgent.toLowerCase().indexOf("sunos") > -1 ||    userAgent.toLowerCase().indexOf("x11") > -1 )){
		leftPgImage = "../common/images/utilSpacer.gif";
		rightPgImage = "../common/images/utilSpacer.gif";
		bgPgImage = "../common/images/utilSpacer.gif";
		trClass = " class=\"even\"";
	}

%> 
	<table border="0" cellspacing="2" cellpadding="0" width="100%">
	<tr>
	<td width="85%">

	<table border="0" width="100%" cellspacing="0" cellpadding="4">
	<tr>
	<td width="45%"><img src="../common/images/utilSpacer.gif" border="0" width="5" height="20" alt=""></td>
	<td width="1%"><img src="../common/images/utilSpacer.gif" width="1" height="28" alt=""></td>
	<td align="right">
	<!--XSSOK-->
	<table border="0" cellspacing="0" cellpadding="0" background=<%=bgPgImage%>>
	<!--XSSOK-->
	<tr  <%=trClass%>>
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
			<td><a href="javascript:navigatePage('previous' , '')"><img src="../common/images/buttonPrevPage.gif" border="0" alt="<%=sPreviousPage%>" width="16" height="16"></a></td>
<%
		}
		else
		{
%>
            <!--XSSOK-->
			<td><img src="../common/images/buttonPrevPageDisabled.gif" border="0" alt="<%=sPreviousPage%>" width="16" height="16"></td>
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
<%			}
			else
			{
%>
				<option class="pagination"><%=i+1%></option>
<%			}
		} //end for
%>
		</select></td>
		<!--XSSOK-->
		<td nowrap>&#160;<%=sOf%> <%=noOfPages%></td>
		<td><img src="../common/images/utilSpacer.gif" width="9" height="8"></td>
<%
		if ( boList != null && boList.size() > (currentIndex + noOfItemsPerPage))
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
	} //end of if display is multi page 
	else {
%>
		<td nowrap="nowrap">
		<!--XSSOK-->
		<a href="javascript:navigatePage(document.footerForm.custPageNo.value , 'multiPage')"><img src="../common/images/buttonMultiPageUp.gif" border="0" alt="<%=sPaginationOn%>"></a><img src="../common/images/buttonSinglePageDown.gif" border="0" alt="<%=sPaginationOff%>">
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
        <td align="right"><a href="javascript:parent.window.close()"><img src="../emxUIButtonCancel.gif" border="0"></a></td>
		<!--XSSOK-->
		<td align="left" valign="middle"><a href="javascript:parent.window.close()"><%=strCancel%></a></td>
<%
    }else {
%>
        <td><img src="../common/images/utilSpacer.gif" alt="" width="4"></td>
<%
	}
%>
	</tr>
	</table>

<%
} //End of if(noOfPages >1)  
else{
%>
	<table border="0" cellspacing="2" cellpadding="0" align="right">
	<tr>
	
<%
      if(sTarget!= null && sTarget.equals("popup"))
	  {
%>
        <td align="right" valign="bottom"><a href="javascript:parent.window.close()"><img src="../emxUIButtonCancel.gif" border="0"></a></td>
		<!--XSSOK-->
		<td align="left" valign="middle"><a href="javascript:parent.window.close()"><%=strCancel%></a></td>
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

<input type="hidden" name="custTopActionBar" value="<xss:encodeForHTMLAttribute><%=topActionbar%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="custBottomActionBar" value="<xss:encodeForHTMLAttribute><%=bottomActionbar%></xss:encodeForHTMLAttribute>">
<!--XSSOK-->
<input type="hidden" name="custPagination" value="<%=noOfItemsPerPage%>">
<input type="hidden" name="jsTreeID" value="<xss:encodeForHTMLAttribute><%=jsTreeID%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="custSortColumnName" value="<xss:encodeForHTMLAttribute><%=sortColumnName%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="custReSortKey" value="<xss:encodeForHTMLAttribute><%=sortColumnName%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="custPageNo" value="<xss:encodeForHTMLAttribute><%=sPage%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="custSelection" value="<xss:encodeForHTMLAttribute><%=selection%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="timeStamp" value="<xss:encodeForHTMLAttribute><%=timeStamp%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="custDisplayMode" value="<xss:encodeForHTMLAttribute><%=displayMode%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="custHeaderRepeat" value="<xss:encodeForHTMLAttribute><%=sHeaderRepeat%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="objectId" value="<xss:encodeForHTMLAttribute><%=objectId%></xss:encodeForHTMLAttribute>">
<input type="hidden" name="parentOID" value="<xss:encodeForHTMLAttribute><%=objectId%></xss:encodeForHTMLAttribute>">
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
<jsp:param name="actionBarName" value="<%=XSSUtil.encodeForHTML(context,bottomActionbar)%>"/>
</jsp:include>
<%
}
%>

</body>
</html>
