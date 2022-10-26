<%--  emxInfoModifyQueryDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxInfoAdvancedSearchDialog.jsp  -   Form page for Advanced Search
  $Archive: /InfoCentral/src/infocentral/emxInfoAdvancedSearchDialog.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoAdvancedSearchDialog.jsp $
 * 
 * *****************  Version 31  *****************
 * User: Shashikantk  Date: 1/11/03    Time: 3:39p
 * Updated in $/InfoCentral/src/infocentral
 * The popup windows (choosers) are now opened by a function
 * showModalDialog() from common/scripts/emxUIModal.js
 * 
 * *****************  Version 30  *****************
 * User: Snehalb      Date: 1/10/03    Time: 11:36a
 * Updated in $/InfoCentral/src/infocentral
 * changing form method from get to post
 * 
 * *****************  Version 29  *****************
 * User: Shashikantk  Date: 12/12/02   Time: 5:55p
 * Updated in $/InfoCentral/src/infocentral
 * Alerts for error if any
 * 
 * *****************  Version 28  *****************
 * User: Shashikantk  Date: 12/12/02   Time: 2:58p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 27  *****************
 * User: Shashikantk  Date: 12/12/02   Time: 2:21p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 26  *****************
 * User: Rahulp       Date: 12/02/02   Time: 6:47p
 * Updated in $/InfoCentral/src/infocentral
 * ************************************************
 *
--%>

<%@ page import="com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.beans.*"  %>

<%@include file= "emxInfoCentralUtils.inc"%>
<%@include file= "../emxJSValidation.inc"%>
<%@include file= "../emxUICommonHeaderBeginInclude.inc"%>
<script language="JavaScript" src="emxInfoUIModal.js"></script> 
<script language="javascript" src="emxInfoCentralJavaScriptUtils.js"></script>
<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script> <%--Required by emxUIActionbar.js below--%>
<script language="JavaScript" src="../common/scripts/emxUIActionbar.js" type="text/javascript"></script> <%--To show javascript error messages--%>
<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICore.js"></script>


<script language="Javascript">

	// Function for more option on search to be shown .
	// needs to be checked if this approach would work with Netscape.

    function checkBox(){
   document.forms['frmPowerSearch'].chkExpandBoxHidden.value=document.forms['frmPowerSearch'].chkExpandBox.checked;
	}

	function showTextSearch(whetherToShowTextSearch)
	{  
        document.forms['frmPowerSearch'].TextSearch.value = whetherToShowTextSearch;
    	document.frmPowerSearch.action = "emxInfoModifyQueryDialog.jsp";
		document.frmPowerSearch.target = "_self";
		document.frmPowerSearch.submit();
	}

	function showAdvanced(whetherToShowAdvanced){
		document.forms['frmPowerSearch'].Advanced.value=whetherToShowAdvanced;
    	document.frmPowerSearch.action = "emxInfoModifyQueryDialog.jsp";
		document.frmPowerSearch.target = "_self";
		document.frmPowerSearch.submit();   
	}

	function doSearch() {
		var strQueryLimit = parent.frames[3].document.bottomCommonForm.QueryLimit.value;
		document.frmPowerSearch.queryLimit.value = strQueryLimit;
		document.frmPowerSearch.txtName.value = trimWhitespace(document.frmPowerSearch.txtName.value);
		if (charExists(document.frmPowerSearch.txtName.value, '"')){
			alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.SpecialCharacters</framework:i18nScript>");
			document.frmPowerSearch.txtName.focus();
			return;
		}
		document.frmPowerSearch.txtRev.value = trimWhitespace(document.frmPowerSearch.txtRev.value);
		if (charExists(document.frmPowerSearch.txtRev.value, '"')){
			alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.SpecialCharacters</framework:i18nScript>");
			document.frmPowerSearch.txtRev.focus();
			return;
		}

		document.frmPowerSearch.txtOwner.value = trimWhitespace(document.frmPowerSearch.txtOwner.value);
		if (charExists(document.frmPowerSearch.txtOwner.value, '"')){
			alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.SpecialCharacters</framework:i18nScript>");
			document.frmPowerSearch.txtOwner.focus();
			return;
		}
		document.frmPowerSearch.submit();
	}

	
	//specify the place to return the string AS A STRING...this cannot be an actual object reference or it will cause an error
	var strTxtType = "document.forms['frmPowerSearch'].selType";
	var txtType = null;
	var strTxtTypeDisp = "document.forms['frmPowerSearch'].txtType";
	var txtTypeDisp = null;
	//can abstracts be selected?
	var bAbstractSelect = false;
	var bMultiSelect = true;

	//Define variables required for showing vault chooser
	var bVaultMultiSelect = true;
	var strTxtVault = "document.forms['frmPowerSearch'].txtVault";
	var txt_Vault = null;

</script>

<%!
   public ArrayList parseFormat(String str){

      String formatString="";
      String whereString=str;
      int beginIndex =str.lastIndexOf("((format");
      if(beginIndex!=-1){
      String restStr =str.substring(beginIndex);
      int lastIndex=restStr.indexOf("))")+2;
      //if(beginIndex+lastIndex==str.length())
      {
      whereString=str.substring(0,beginIndex);
      int ii=str.lastIndexOf("&&");
      if(ii>-1)
      whereString =whereString.substring(0,ii);
      int endIndex =restStr.indexOf("))");
      String formatStr=restStr.substring(1,endIndex);
      StringTokenizer strTk1 = new StringTokenizer(formatStr,"||");
      while(strTk1.hasMoreTokens()){
      String formats =strTk1.nextToken();
      StringTokenizer strTk2 =  new StringTokenizer(formats,"==");
      String token = strTk2.nextToken();
      String format =strTk2.nextToken();
      format=format.replace('"',' ');
      formatString+=format.trim()+",";
      }
      }
      if(formatString.length()>1)
      formatString=formatString.substring(0,formatString.length()-1);
      }
      ArrayList list = new ArrayList();
      if(whereString!=null)
      whereString=whereString.trim();
      list.add(whereString);
      list.add(formatString);
      return list;
      }
%>

<%
try {
		String languageStr = request.getHeader("Accept-Language");
		String appDirectory = (String)application.getAttribute("eServiceSuiteIEFDesignCenter.Directory");
		String suiteKey = emxGetParameter(request, "suiteKey");
		String queryName = emxGetParameter(request, "emxTableRowId");
		String sTimeStampPassed = emxGetParameter(request, "timeStampAdvancedSearch");
		String sSelType = emxGetParameter(request, "selType");
		String sTxtType = emxGetParameter(request, "txtType");
		String sTxtName = emxGetParameter(request, "txtName");
		String sTxtRev = emxGetParameter(request, "txtRev");
		String sTxtOwner = emxGetParameter(request, "txtOwner");
		String sTxtVault = emxGetParameter(request, "txtVault");
		String sTxtWhereClause = emxGetParameter(request, "txtWhereClause");
		String sTxtPattern = emxGetParameter(request, "txtPattern");
		String sTxtFormat = emxGetParameter(request, "txtFormat");
		String advanced   = emxGetParameter(request, "Advanced");
		String textSearch   = emxGetParameter(request, "TextSearch");
		String sChkExpandBox = emxGetParameter(request, "chkExpandBox");
		String comboFormat = "";
		matrix.db.Query newQuery = null;
		if(queryName!=null && !queryName.equals("null")){
		newQuery = new matrix.db.Query(queryName);
        newQuery.open(context);
		sTxtType    = newQuery.getBusinessObjectType();
		sTxtName    = newQuery.getBusinessObjectName();
		sTxtRev     = newQuery.getBusinessObjectRevision();
		sTxtOwner   = newQuery.getOwnerPattern();
		sTxtVault   = newQuery.getVaultPattern();
		sTxtPattern = newQuery.getSearchText();
		sTxtFormat  = newQuery.getSearchFormat();
		sTxtWhereClause= newQuery.getWhereExpression();
        ArrayList list = parseFormat(sTxtWhereClause);
        sTxtWhereClause = (String)list.get(0);
		comboFormat = (String)list.get(1);
		if(!sTxtFormat.equals("*"))
          comboFormat+=","+sTxtFormat;
		sChkExpandBox = new Boolean(newQuery.getExpandTypes()).toString();
		}
		if(queryName==null || queryName.equals("null"))
			queryName = emxGetParameter(request, "queryName");
    	
    	if(null == sSelType || "null".equalsIgnoreCase(sSelType) || sSelType.length() == 0) sSelType = "";
		if(null == sTxtType || "null".equalsIgnoreCase(sTxtType) || sTxtType.length() == 0) sTxtType = "*";
		if(null == sTxtName || "null".equalsIgnoreCase(sTxtName) || sTxtName.length() == 0) sTxtName = "*";
		if(null == sTxtRev || "null".equalsIgnoreCase(sTxtRev) || sTxtRev.length() == 0) sTxtRev = "*";
		if(null == sTxtOwner || "null".equalsIgnoreCase(sTxtOwner) || sTxtOwner.length() == 0) sTxtOwner = "*";
		if(null == sTxtVault || "null".equalsIgnoreCase(sTxtVault) || sTxtVault.length() == 0) sTxtVault = "*";
		String sTxtWhereClauseHidden = "*";
		if(null == sTxtWhereClause || "null".equalsIgnoreCase(sTxtWhereClause) )
		{
			sTxtWhereClauseHidden = emxGetParameter(request, "txtWhereClauseHidden");
			if(null == sTxtWhereClauseHidden || "null".equalsIgnoreCase(sTxtWhereClauseHidden) || sTxtWhereClauseHidden.length() == 0 || "*".equalsIgnoreCase(sTxtWhereClauseHidden)){
				sTxtWhereClauseHidden = "*";
				sTxtWhereClause = "*";
			}else{

				sTxtWhereClause = sTxtWhereClauseHidden.replace('^','"');
				sTxtWhereClause = sTxtWhereClause.replace('$','\'');
				sTxtWhereClauseHidden = sTxtWhereClause.replace('"','^');				
				sTxtWhereClauseHidden = sTxtWhereClauseHidden.replace('\'','$');				
			}

		}else{				
			sTxtWhereClauseHidden = sTxtWhereClause.replace('"','^');				
			sTxtWhereClauseHidden = sTxtWhereClauseHidden.replace('\'','$');				
		}
		String sChkExpandBoxHidden = null;
		if(null == sChkExpandBox || "null".equalsIgnoreCase(sChkExpandBox)) 
		{
			sChkExpandBox = emxGetParameter(request, "chkExpandBoxHidden");
			if("true".equals(sChkExpandBox)){
				sChkExpandBoxHidden = "true";
				sChkExpandBox = " checked=\"true\"";				
			}
			else{
               sChkExpandBox="";
			   sChkExpandBoxHidden = "false";
			}
		}
		else if("true".equals(sChkExpandBox)||"on".equals(sChkExpandBox)){
			sChkExpandBoxHidden = "true";
			sChkExpandBox = " checked=\"true\"";
		}else{
			sChkExpandBox="";
		    sChkExpandBoxHidden = "false";
		}

		String sTxtPatternHidden = "*";
		if(null == sTxtPattern || "null".equalsIgnoreCase(sTxtPattern))
		{
			sTxtPatternHidden = emxGetParameter(request, "txtPatternHidden");
			if(null == sTxtPatternHidden || "null".equalsIgnoreCase(sTxtPatternHidden) || sTxtPatternHidden.length() == 0 || "*".equalsIgnoreCase(sTxtPatternHidden)){
				sTxtPatternHidden = "*";
				sTxtPattern = "*";
			}else{
				sTxtPattern = sTxtPatternHidden.replace('^','"');
				sTxtPattern = sTxtPattern.replace('$','\'');
				sTxtPatternHidden = sTxtPattern.replace('"','^');				
				sTxtPatternHidden = sTxtPatternHidden.replace('\'','$');	
			}
		}else{				
			sTxtPatternHidden = sTxtPattern.replace('"','^');				
			sTxtPatternHidden = sTxtPatternHidden.replace('\'','$');	
		}
		
		if(null == comboFormat || "null".equalsIgnoreCase(comboFormat)||comboFormat.equals("")){
		String[] sSelctedFormats = emxGetParameterValues(request, "comboFormats");
		if(null != sSelctedFormats){
			for (int i=0;i<sSelctedFormats.length;i++)
			{
				comboFormat+= sSelctedFormats[i];
				if(i!=sSelctedFormats.length-1)
					comboFormat+=",";
			}			
		}else{
			comboFormat = emxGetParameter(request, "comboFormatsHidden");		
			if(null == comboFormat || "null".equalsIgnoreCase(comboFormat) || comboFormat.length() == 0)
				comboFormat = "";
		}
		
		}

		//get the types to be shown in type chooser from the current GCO
   	    String strTypeList = "type_CADDrawing,type_CADModel";
		MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
		if(integSessionData != null) 
		{
			 strTypeList = integSessionData.getTypesForTypeChooser(integSessionData.getClonedContext(session));
		}

%>
<%@include file = "../emxUICommonHeaderEndInclude.inc"%>


<form name="frmPowerSearch" id="idForm" method="post" action="emxInfoModifyQuery.jsp" target="_parent" onSubmit="return false">


<input type=hidden name="selType" value="<xss:encodeForHTMLAttribute><%=sSelType%></xss:encodeForHTMLAttribute>">
<input type=hidden name="timeStampAdvancedSearch" value="<xss:encodeForHTMLAttribute><%=sTimeStampPassed%></xss:encodeForHTMLAttribute>">
<input type=hidden name="queryLimit" value="">
<input type=hidden name="Advanced" value="<xss:encodeForHTMLAttribute><%=advanced%></xss:encodeForHTMLAttribute>">
<input type=hidden name="TextSearch" value="<xss:encodeForHTMLAttribute><%=textSearch%></xss:encodeForHTMLAttribute>">
<input type=hidden name="queryName" value="<xss:encodeForHTMLAttribute><%=queryName%></xss:encodeForHTMLAttribute>">
<!--XSSOK-->
<input type=hidden name="txtWhereClauseHidden" value="<%=sTxtWhereClauseHidden%>">
<!--XSSOK-->
<input type=hidden name="chkExpandBoxHidden" value="<%=sChkExpandBoxHidden%>">
<!--XSSOK-->
<input type=hidden name="txtPatternHidden" value="<%=sTxtPatternHidden%>">
<!--XSSOK-->
<input type=hidden name="comboFormatsHidden" value="<%=comboFormat%>">
<input type=hidden name="selType" value="">

<table border="0" cellspacing="2" cellpadding="3" width="100%" >
  <tr>
    <td class="label"><%=i18nNow.getBasicI18NString("Type",  languageStr)%>
	</td>
    <td class="inputField">
      <input type=text value="<xss:encodeForHTMLAttribute><%=sTxtType%></xss:encodeForHTMLAttribute>" size="16" name="txtType" <%=sKeyPress%>>
	  <!--XSSOK-->
      <input type=button value="..." onClick="showTypeSelector('<%=strTypeList%>', 'true', 'frmPowerSearch', 'txtType', 'true');">
    </td>
  </tr>
  <tr>
    <td class="label"><%=i18nNow.getBasicI18NString("Name",  languageStr)%></td>
    <td class="inputField"><input type="text" name="txtName" size="16" value="<xss:encodeForHTMLAttribute><%=sTxtName%></xss:encodeForHTMLAttribute>" <%=sKeyPress%>></td>
  </tr>
  <tr>
    <td class="label"><%=i18nNow.getBasicI18NString("Revision",  languageStr)%>
		</td>
    <td class="inputField"><input type="text" name="txtRev" size="16" value="<xss:encodeForHTMLAttribute><%=sTxtRev%></xss:encodeForHTMLAttribute>" <%=sKeyPress%>></td>
  </tr>
   <tr>
    <td class="label"><%=i18nNow.getBasicI18NString("Owner",  languageStr)%>
		</td>
    <td class="inputField"><input type="text" name="txtOwner" size="16" value="<xss:encodeForHTMLAttribute><%=sTxtOwner%></xss:encodeForHTMLAttribute>" <%=sKeyPress%>></td>
  </tr>
  <tr>
   <td class="label">
		<%=i18nNow.getBasicI18NString("Vault",  languageStr)%>
		</td>
     <td class="inputField"><input type=text  name="txtVault" size="16" value="<xss:encodeForHTMLAttribute><%=sTxtVault%></xss:encodeForHTMLAttribute>" <%=sKeyPress%>>&nbsp;<input class="button" type="button" size = "200" value="..." alt="..." onClick="javascript:showVaultSelector();"></td>
  </tr>
  <%
    if((null == advanced) || 
       ("null".equalsIgnoreCase(advanced)) || 
       ("".equalsIgnoreCase(advanced)) || 
       ("false".equalsIgnoreCase(advanced))){
  %>
    <tr>
	   <td><a href="javascript:showAdvanced('true')"><framework:i18n localize="i18nId">emxIEFDesignCenter.Search.AdvancedSearch</framework:i18n>&nbsp;<img src="images/iconDescend.gif" border="0"></a></td>
    </tr>
  <%
  }else if("true".equalsIgnoreCase(advanced)){
  %>
    <tr>
    	<td><a href="javascript:showAdvanced('false')"><framework:i18n localize="i18nId">emxIEFDesignCenter.Search.AdvancedSearch </framework:i18n>&nbsp;<img src="images/iconAscend.gif" border="0"></a></td>
    </tr>
    <tr>
     <td id="whereCaption" name="whereCaption" class="label"><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.WhereClause</framework:i18n></td>
	 <!--XSSOK-->
     <td id="whereText" name="whereText"  class="inputField"><textarea  name="txtWhereClause" columns="70" rows="4"><%=sTxtWhereClause%></textarea></td>
    </tr>
    <tr>
     <td id="expandCaption" name="expandCaption" class="label"><framework:i18n localize="i18nId">emxIEFDesignCenter.Search.Expand</framework:i18n></td>
	 <!--XSSOK-->
     <td id="expandCheck" name="expandCheck" class="inputField" ><input type="checkbox" name="chkExpandBox" <%=sChkExpandBox%> onclick="javaScript:checkBox();"></td>
    </tr>
  <%
  }
  %>

  <%
    if((null == textSearch) || 
       ("null".equalsIgnoreCase(textSearch)) || 
       ("".equalsIgnoreCase(textSearch)) || 
       ("false".equalsIgnoreCase(textSearch))){
  %>
    <tr>
     <td><a href="javascript:showTextSearch('true')"><framework:i18n localize="i18nId">emxIEFDesignCenter.Search.TextSearch</framework:i18n>&nbsp;<img src="images/iconDescend.gif" border="0"></a></td>
    </tr>
  <%
  }else if("true".equalsIgnoreCase(textSearch)){
  %>
    <tr>
     <td><a href="javascript:showTextSearch('false')"><framework:i18n localize="i18nId">emxIEFDesignCenter.Search.TextSearch</framework:i18n>&nbsp;<img src="images/iconAscend.gif" border="0"></a></td>
    </tr>
    <tr>
     <td id="patternCaption" name="patternCaption" class="label"><framework:i18n localize="i18nId">emxIEFDesignCenter.Search.TextPattern</framework:i18n></td>
     <td id="patternText" name="patternText"  class="inputField">
	  <!--XSSOK-->
  	  <textarea  name="txtPattern" columns="70" rows="4"><%=sTxtPattern%></textarea></td>
    </tr>
    <tr>
      <td id="formatCaption" name="formatCaption" class="label"><framework:i18n localize="i18nId" >emxIEFDesignCenter.Common.Format</framework:i18n></td>
       <td id="formatText" name="formatText" class="field" <%=sKeyPress%>>
       	<table border="0" cellspacing="2" cellpadding="0" width="100%" >
       	<tr><td>
            <select multiple name="comboFormats" size=5>
            <%
				String sFormatNameSelected = "";
            	if(comboFormat.indexOf("*") > -1) sFormatNameSelected = " selected";
            %>
                <option value="*" <%=sFormatNameSelected%>>*</option>
            <%
                    String sFormatName = "";
                    FormatItr formatItr   = new FormatItr(Format.getFormats(context));
                    //iterate through and list all the formats
                    while (formatItr.next()) {
                      sFormatName = (formatItr.obj()).getName();
                      String displayName =getFormatI18NString(sFormatName,request.getHeader("Accept-Language"));
                      sFormatNameSelected = "";
                      if(comboFormat.indexOf(sFormatName) > -1) sFormatNameSelected = " selected";
            %>
                      <option value= "<%=sFormatName%>" <%=sFormatNameSelected%>><%=displayName%></option>
            <%
                    }
            %>
                    </select>
         </td><td>
			(<framework:i18n localize="i18nId" >emxIEFDesignCenter.Common.AdvancedSearchFormatTip</framework:i18n>)
		 </td></tr></table>
       </td>       
    </tr>
  <%
  }
  %>
 </table>
 <table>
 <tr>
    <td ><input type="radio" name="chkAppendReplace" value="replace" checked ></td>
    <td ><framework:i18n localize="i18nId">emxIEFDesignCenter.Search.ReplaceObjects</framework:i18n></td>
    <td ><input type="radio" name="chkAppendReplace" value="append" ></td>
    <td ><framework:i18n localize="i18nId">emxIEFDesignCenter.Search.AppendObjects</framework:i18n></td>
  </tr> 
</table>
</form>
<%
  } catch (Exception e) {
    String sError = e.getMessage();
%>
	<script language="JavaScript">		
	    //XSSOK
		showError("<%=sError%>");
		window.parent.close();
	</script>
<%
    return;
  }
%>

<%@include file = "../emxUICommonEndOfPageInclude.inc"%>

