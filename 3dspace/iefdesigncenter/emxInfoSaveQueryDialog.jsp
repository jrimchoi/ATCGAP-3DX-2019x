<%--  emxInfoSaveQueryDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoSaveQueryDialog.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxInfoSaveQueryDialog.jsp $
 * 
 * *****************  Version 5  *****************
 * User: Rahulp       Date: 12/03/02   Time: 6:23p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * ***********************************************
 *
 --%>
<html>
<%@include file= "emxInfoCentralUtils.inc"%>
<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<%
   // DSCINC 1200
   
    StringList searchList = null;
    String sTimeStamp = (String)request.getParameter("timeStamp");
    String sQueryType = (String)request.getParameter("queryType");
    if (null == sTimeStamp) sTimeStamp = "";
    if (null == sQueryType) sQueryType = "";
   
    try
    {
        ContextUtil.startTransaction(context, true);
    
        searchList = UISearch.getSearchObjects(context);
       

    } catch (Exception ex) {
        ContextUtil.abortTransaction(context);
        /*if (ex.toString() != null && (ex.toString().trim()).length() > 0)
              emxNavErrorObject.addMessage(ex.toString().trim());*/

    } finally {
        ContextUtil.commitTransaction(context);
    }

    Iterator searchIterator = searchList.iterator();
   // DSCINC 1200
 %>
<head>
<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css"><!--This is required for the font of the text-->
<link rel="stylesheet" href="../common/styles/emxUIDialog.css" type="text/css" ><!--This is required for the cell (td) back ground colour-->
<link rel="stylesheet" href="../common/styles/emxUIList.css" type="text/css" >
<script type="text/javascript" language="JavaScript" src="../common/scripts/emxUIConstants.js"></script>
<script type="text/javascript" language="JavaScript" src="emxInfoUISearch.js"></script>

<script language="Javascript">

	//-- 12/17/2003         Start rajeshg   -->	
	//Function to check key pressed
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

	function submitThis( event )
	{
		if((event.keyCode == 13) || (event.keyCode == 10) || (event.which == 13) || (event.which == 10)) 
		{
				parent.frames[1].submit();
		}
	}

	document.onkeypress = cptKey ;
	//-- 12/17/2003         End  rajeshg   -->	
  function trim(str){
    while(str.length != 0 && str.substring(0,1) == ' '){
      str = str.substring(1);
    }
    while(str.length != 0 && str.substring(str.length -1) == ' '){
      str = str.substring(0, str.length -1);
    }
    return str;
  }
  //function submit the form
  function saveName(queryName)
  {
      document.frmSaveQuery.txtQueryName.value = queryName;
  }
  function submit() {

    var queryName = trim(document.frmSaveQuery.txtQueryName.value);
    var queryType = trim(document.frmSaveQuery.txtQueryType.value);
    var searchContentFrame = findFrame(top.opener.top, 'listFoot');
    // comes from search page
    if (searchContentFrame == null)
    {
       searchContentFrame = findFrame(top.opener.top, 'searchContent');
       // Save as XML
       if (searchContentFrame != null)
       {
           searchContentFrame.saveSearch(queryName);
       }
    }
    else // comes from search result page
    {
        // set up the time stamp to retrieve the ParamList stored in HTTP session
        document.frmSaveQuery.timeStamp.value = searchContentFrame.document.forms[0].timeStamp.value;
    }
     
    if(queryName ==null || queryName ==""){
        var form = document.forms[0];
        for (var i = 0; form != null && i < form.elements.length; i++)
        {
            if (form.elements[i].name == 'savedSearchName' &&
               form.elements[i].checked)
               queryName = form.elements[i].value;
        } 

        if(queryName ==null || queryName =='') {
            alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Search.YoumustenteraName</framework:i18nScript>");
           document.frmSaveQuery.txtQueryName.focus();
        }
        else
        {
           document.frmSaveQuery.txtQueryName.value=queryName;
           document.frmSaveQuery.action= "emxInfoSaveQuery.jsp"
           document.frmSaveQuery.submit();
        }
        } else{
        document.frmSaveQuery.action= "emxInfoSaveQuery.jsp"
        document.frmSaveQuery.submit();
		}
}
</script>
</head>
<body class="content">
<form name="frmSaveQuery" method="post" >

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

<table border="0" cellspacing="2" cellpadding="3" width="100%" >
	<thead>
		<tr>
			<th width="5%" style="text-align:center">
			</th>
			<th>
			 <framework:i18n localize="i18nId">emxIEFDesignCenter.Common.Name</framework:i18n>
			</th>
		</tr>
	</thead>

  <tr>

    <td class="label"><!--<framework:i18n localize="i18nId">emxIEFDesignCenter.Common.Name</framework:i18n>-->&nbsp</td>
    <td class="inputField"><input type="text" name="txtQueryName" size="25" onkeypress="javascript:submitThis(event);"></td>
  </tr>
  <tr>
   <td><img src="../common/images/utilSpacer.gif" alt="" width="4"></td>
   <td><img src="../common/images/utilSpacer.gif" alt="" width="4"></td>
  </tr>
<%  
String rowClass = "odd";
int iCounter = 0;
while(searchIterator.hasNext()){ 
        String strVal = (String)searchIterator.next(); 
        if (strVal.startsWith(".emx"))
            continue;
        String queryName = strVal;
       // if (strVal.substring(0, 4).equals(".emx"))
       //    queryName = strVal.substring(4);
        
        if(strVal != null /*&& strVal.length() > 4 && strVal.substring(0,4).equals(".emx")*/){ 
                iCounter++; %>
        <script language="javascript">
          var strValue<%=iCounter%> ="<%= strVal %>";
        </script>                
               <tr class="<%= rowClass %>">
                  <td style="text-align: center; ">
                     <input type="radio" name="savedSearchName" id="savedSearchName" value="<%= queryName %>" onClick="saveName('<%=queryName%>')">
                  </td>
                  <td>
                     <table border="0">
                        <tr>
                           <td valign="top">
                              <img src="../common/images/iconSmallFile.gif" border="0" alt="File">
                           </td>
                           <td>
                              <span class="object"><%= queryName %></a></span>
                           </td>
                        </tr>
                     </table> 
               </tr>
<%
                rowClass = (rowClass == "odd") ? "even" : "odd";
        }
} 
if(iCounter == 0){
%>
                <tr class="<%= rowClass %>">
                  <td style="text-align: center; " colspan="4">
                     <framework:i18n localize="i18nId">emxIEFDesignCenter.Objects.Common.NoObjectsFound</framework:i18n>
                  </td>
               </tr>
<%
}
%>               
              <input type="hidden" name="txtQueryType" value="<%=sQueryType%>">
              <input type="hidden" name="timeStamp" value="">
</table>
</form>
</body>
</html>
