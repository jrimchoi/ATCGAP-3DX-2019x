<%--  emxInfoObjectConnectWizardDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoObjectConnectWizardDialog.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

    This page displays objects and relationships to connect

--%>

<%--
 *
 * $History: emxInfoObjectConnectWizardDialog.jsp $
 * *****************  Version 15  *****************
 * User: Rajesh G  Date: 12/18/2003    Time: 8:44p
 * Updated in $/InfoCentral/src/infocentral
 * Changed For key pressed check Enter/Tab/Escape
 * ************************************************ *  * 
 * 
 * *****************  Version 14  *****************
 * User: Rahulp       Date: 1/15/03    Time: 1:25p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 13  *****************
 * User: Shashikantk  Date: 12/11/02   Time: 8:19p
 * Updated in $/InfoCentral/src/infocentral
 * "From" and "To" on one line
 * 
 * *****************  Version 12  *****************
 * User: Rahulp       Date: 12/04/02   Time: 7:19p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 11  *****************
 * User: Rahulp       Date: 11/29/02   Time: 4:56p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 9  *****************
 * User: Mallikr      Date: 11/26/02   Time: 1:40p
 * Updated in $/InfoCentral/src/InfoCentral
 * 
 * *****************  Version 8  *****************
 * User: Snehalb      Date: 11/23/02   Time: 5:02p
 * Updated in $/InfoCentral/src/InfoCentral
 * cleaned up code for indentation, added file header
 *
 * ***********************************************
 *
--%>

<%@ page import = "com.matrixone.MCADIntegration.server.beans.*, com.matrixone.MCADIntegration.utils.*" %>
<%@include file="emxInfoCentralUtils.inc"%> 			<%--For context, request wrapper methods, i18n methods--%>
<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css"><!--This is required for the font of the text-->
<link rel="stylesheet" href="../common/styles/emxUIDialog.css" type="text/css" ><!--This is required for the cell (td) back ground colour-->
<link rel="stylesheet" href="../common/styles/emxUIForm.css" type="text/css">

<%@include file="emxInfoVisiblePageInclude.inc"%>

<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<%
    String relationshipName = emxGetParameter(request,"relationshipName");
	String objectId			= emxGetParameter(request, "objectId");
    String sRelDirection	= emxGetParameter(request, "sRelDirection");
	String isTemplateType	= (String)session.getAttribute("isTemplateType");

	MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
	MCADMxUtil util                             = new MCADMxUtil(context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());

	Vector assemblyLikeRelNames					= new Vector();
	String integrationName						= util.getIntegrationName(context, objectId);
	MCADGlobalConfigObject globalConfigObject   = integSessionData.getGlobalConfigObject(integrationName,context);
	if(globalConfigObject != null)
	{
		Hashtable mxRels  = new Hashtable(10);
		String inRelClass = "AssemblyLike";

		globalConfigObject.getMxRelNameDirnTableForClass(mxRels, inRelClass);

		if(mxRels != null)
		{
			Enumeration assemblyLikeRelNamesEnum = mxRels.keys();
			while(assemblyLikeRelNamesEnum.hasMoreElements())
				assemblyLikeRelNames.addElement((String)assemblyLikeRelNamesEnum.nextElement());
		}
	}
	
    String sRelName=null;
    BusinessObject  boObject  = null;
    boObject  = new BusinessObject(objectId);
    boObject.open(context);
    String sBustype= null;
    BusinessType btConnObj = boObject.getBusinessType(context);
    boObject.close(context);
    btConnObj.open(context);
    sBustype = btConnObj.getName();
    boolean to=true;
    boolean from=false;
    String fromChecked="checked";
    String toChecked="";

	if( ( sRelDirection != null ) && ( sRelDirection.equals("to") ) ) 
    {
        to =false;
	    from=true;
	    fromChecked="";
	    toChecked="checked";
    }
    if( ( sRelDirection != null ) && ( sRelDirection.equals("from") ) )
    {
        to =true;
	    from=false;
  	    fromChecked="checked";
	    toChecked="";
    }
	String access="ToConnect";
    BusinessObject bObj = new BusinessObject(objectId);
	boolean hasToAccess = FrameworkUtil.hasAccess(context,bObj,access);	
	String sMsgKey= "emxIEFDesignCenter.Common.No" + access;
	String sErrorToMsg= FrameworkUtil.i18nStringNow(sMsgKey, request.getHeader("Accept-Language"));
	String hasToAccessStr=new Boolean(hasToAccess).toString();
	access="FromConnect";
	boolean hasFromAccess = FrameworkUtil.hasAccess(context,bObj,access);	
	sMsgKey= "emxIEFDesignCenter.Common.No" + access;
	String sErrorFromMsg= FrameworkUtil.i18nStringNow(sMsgKey, request.getHeader("Accept-Language"));
	String hasFromAccessStr=new Boolean(hasFromAccess).toString();
%>
<script language="Javascript">

    function submitForm()
    {
	   //XSSOK
	   var hasToAccessStr="<%=hasToAccessStr%>";
	   //XSSOK
       var hasFromAccessStr="<%=hasFromAccessStr%>";
	   //XSSOK
	   var toFrom = "<%=fromChecked%>";
	   if((toFrom=="checked" && hasFromAccessStr=="true")|| (toFrom=="" && hasToAccessStr=="true")){
       document.emxInfoCreateObjectConnectWizardDialog.target="_parent";
       document.emxInfoCreateObjectConnectWizardDialog.action="emxInfoConnectSearchDialogFS.jsp";
       document.emxInfoCreateObjectConnectWizardDialog.submit(); 
	   }
	   else {
	   if(toFrom=="checked")
	        //XSSOK
		    alert("<%=sErrorFromMsg%>");
	   else 
	        //XSSOK
			alert("<%=sErrorToMsg%>");
	   }      

    }
    function closeWindow()
    {
        parent.window.close();
    }

    function reLoad()
    {
		document.emxInfoCreateObjectConnectWizardDialog.target="_self";
        document.emxInfoCreateObjectConnectWizardDialog.action="emxInfoObjectConnectWizardDialog.jsp";
        document.emxInfoCreateObjectConnectWizardDialog.submit(); 
    }
	function load(){

     alert("<%=XSSUtil.encodeForJavaScript(integSessionData.getClonedContext(session),relationshipName)%>");
	}
var browser = navigator.userAgent.toLowerCase();
	function cptKey(e) 
	{
		var pressedKey = ("undefined" == typeof (e)) ? event.keyCode : e.keyCode ;
	if(browser.indexOf("msie") > -1)
	{
		if (((pressedKey == 8) ||((pressedKey == 37) && (event.altKey)) || ((pressedKey == 39) && (event.altKey))) &&((event.srcElement.form == null) || (event.srcElement.isTextEdit == false)))
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
		if (pressedKey == "13") 
		{
			submitForm();
		}
	}
// Add a handler
if(browser.indexOf("msie") > -1){
   document.onkeydown = cptKey ;
}else if(browser.indexOf("mozilla") > -1 || browser.indexOf("netscape") > -1){
	document.onkeypress = cptKey ;	
}

</script>

<body class="content" onload="document.emxInfoCreateObjectConnectWizardDialog.sRelName.focus()">
<form name="emxInfoCreateObjectConnectWizardDialog"  method ="post" >

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
//System.out.println("CSRFINJECTION::emxInfoObjectConnectWizardDialog.jsp");
%>

  <input type="hidden" name="objectId" value="<%=XSSUtil.encodeForHTMLAttribute(integSessionData.getClonedContext(session),objectId)%>">
  <!--XSSOK-->
  <input type="hidden" name="sObjType" value="<%=sBustype%>">
  <table border="0" width="100%" cellpadding="5" cellspacing="2" >
     <tr >
     <td class="label" width="25%">
         <framework:i18n localize="i18nId">emxIEFDesignCenter.Common.Direction</framework:i18n>
     </td>
     <td class="inputField">
	    <!--XSSOK-->
        <framework:i18n localize="i18nId">emxIEFDesignCenter.Common.From</framework:i18n><input type="radio" name="sRelDirection" value ="from" <%=fromChecked%> onclick="reLoad()">
        &nbsp;
		<!--XSSOK-->
		<framework:i18n localize="i18nId" >emxIEFDesignCenter.Common.To</framework:i18n><input type="radio" name="sRelDirection" value ="to" <%=toChecked%> onclick="reLoad()">
				 </td>
			 </tr>
    <tr >
      <td nowrap class="label"><framework:i18n localize="i18nId" >emxIEFDesignCenter.Common.Relationship</framework:i18n></td>
      <td nowrap class="inputField">
        <select name="sRelName" >
<%   
    RelationshipTypeList relTypeListObj = btConnObj.getRelationshipTypes(context,to,from,true);
    btConnObj.close(context);
    relTypeListObj.sort();
	
    RelationshipTypeItr relTypeItrObj = new RelationshipTypeItr(relTypeListObj);
	while(relTypeItrObj.next()) 
    {
	    RelationshipType  relTypeObj = (RelationshipType) relTypeItrObj.obj();
	    relTypeObj.open(context);
	    sRelName = relTypeObj.getName();
	    String displayRelName = getRelationshipNameI18NString(sRelName,request.getHeader("Accept-Language"));
  	    relTypeObj.close(context);
        String selected = "";
        if((relationshipName != null) && (relationshipName.equals(sRelName)))
            selected="selected";
		if(isTemplateType != null && isTemplateType.equalsIgnoreCase("true") && assemblyLikeRelNames.size()>0)
		{
			if(assemblyLikeRelNames.contains(sRelName))
			{
%>
                <!--XSSOK-->
				<option value = "<%=sRelName%>" <%=selected%> ><%=displayRelName%></option>
<%
			}
		}
		else
		{
%>
            <!--XSSOK-->
			<option value = "<%=sRelName%>" <%=selected%> ><%=displayRelName%></option>		
<%
		}
	}
%>
      </select>
      </td>
      </tr>
  </table>
</form>
</body>
<html>
