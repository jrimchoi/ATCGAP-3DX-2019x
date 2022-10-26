<%--  emxInfoObjectDetailsDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxInfoObjectDetailsDialog.jsp   - This Page Displays the Basics and Attributes of a Business Object
  $Archive: /InfoCentral/src/infocentral/emxInfoObjectDetailsDialog.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxInfoObjectDetailsDialog.jsp $

 *****************  Version 49  *****************
 * User: Rajesh G Date: 12/19/03    Time: 7:00p
 * Updated in $/InfoCentral/src/infocentral
 * To enable the esc key and key board support
  ************************************************ 
 * 
 * *****************  Version 48  *****************
 * User: Rahulp       Date: 1/22/03    Time: 4:02p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * ***********************************************
--%>

<%@include file="emxInfoCentralUtils.inc"%>          <%--For context, request wrapper methods, i18n methods--%>

<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script> <%--Required by emxUIActionbar.js below--%>
<script language="JavaScript" src="../common/scripts/emxUIActionbar.js" type="text/javascript"></script> <%--To show javascript error messages--%>

<%@ page import="com.matrixone.apps.domain.DomainObject"%><%--This class is required to show the Vault name--%>
<!-- IEF additions Start -->

<script language="JavaScript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
<!-- IEF additions End   -->

  

<!-- 12/19/2003        start    rajeshg   -->
<script language="JavaScript">
// Main function
  function cptKey(e) 
  {
    var pressedKey = ("undefined" == typeof (e)) ? event.keyCode : e.keyCode ;
	// for disabling backspace
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
  	var submitAction = "submit";
// Add a handler
document.onkeypress = cptKey ;
//-- 12/19/2003         End  rajeshg   -->	

</script>
<!-- content begins here -->
<head>
<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIList.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIForm.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIMenu.css" type="text/css">

<% 
    String sPFmode = emxGetParameter(request,"PFmode");
%>

<%
    if(null == emxGetParameter(request, "hasModify") || (sPFmode != null && "true".equalsIgnoreCase(sPFmode)))
    {   
        //Read Mode and Printer friendly pages
%>    
        <link rel="stylesheet" href="../common/styles/emxUIProperties.css" type="text/css" ><!--This is required for the cell (td) back ground colour-->
        <link rel="stylesheet" href="../common/styles/emxUIDefaultPF.css" type="text/css">
        <link rel="stylesheet" href="../common/styles/emxUIListPF.css" type="text/css">

<%
    }else{  
        //Edit mode
%>
        <link rel="stylesheet" href="../common/styles/emxUIDialog.css" type="text/css" ><!--This is required for the cell (td) back ground colour-->
<%
    }
%>
<link rel="stylesheet" href="../emxUITemp.css" type="text/css">

<!-- content begins here -->
<%
    try {
        String appendParams = emxGetQueryString(request); 
		appendParams = com.matrixone.apps.domain.util.FrameworkUtil.encodeURL(appendParams);
        String sBusId = emxGetParameter(request, "objectId");       

        //Open the current BusinessObject
        BusinessObject boGeneric = new BusinessObject(sBusId);
        boGeneric.open(context);

        //Get the TNR of the BusinessObject
        String sType = boGeneric.getTypeName();
        String sName = boGeneric.getName();
        String sRevision = boGeneric.getRevision();
        String sVault = boGeneric.getVault();
        
        //Check if the user has edit access
        int iModifyAccess = 1;
        int iReadaccess = 0;
        
        boolean bHasRead = boGeneric.checkAccess(context, (short)iReadaccess);    
        String modifyAccess = emxGetParameter(request, "hasModify");
        boolean bHasModify;

        if(null == modifyAccess)
        {   //Read mode used in object details page
            bHasModify = false;
        }
        else{
            bHasModify = boGeneric.checkAccess(context, (short)iModifyAccess);
        }
        String editURL = "emxInfoObjectDetails.jsp?objectId="+sBusId+"&hasModify="+bHasModify;// + appendParams;

        String sLabelColor;
        String sCellColor;
    
    	if(sPFmode != null && "true".equalsIgnoreCase(sPFmode)){
            sLabelColor = "class=\"listCell\"";
            sCellColor = "class=\"listCell\"";
        }else{
            sLabelColor = "class=\"label\" width=\"25%\"";
            sCellColor = "class=\"field\"";
        }

//----------------To find out who locked the object--------------------------------------

        boolean bLocked = boGeneric.isLocked(context);

        // flag set true if the logged in user is the object locker.
        boolean bIsUserLocked = false;

        String sLocker = null;

        if (bLocked) {
            sLocker = boGeneric.getLocker(context).getName();
            if(sLocker.equals(context.getUser())) {
                bIsUserLocked = true;
            }
        }else{
            sLocker = "";
        }

//---------------------------------------------------------------------------------------
%>
<script language="JavaScript">
    
<%
	String attrModelType = com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_ModelType");
	String attrDesignatedUser = com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_DesignatedUser");
%>

	function changeDisplayValue(inputName)
	{
		var Unassigned =  "<%=i18nStringNowLocal("emxIEFDesignCenter.Common.Unassigned", request.getHeader("Accept-Language"))%>";
		var defaultVal = "Unassigned";

		var inputElement = document.editAttributesForm.elements[inputName]; 
		
		if(inputElement != null && inputElement != "undefined" && inputElement.value == Unassigned)
		{
			inputElement.value = defaultVal;
		}
	}

    
    function submit()
	{
    	if(validateForm())
		{
		    //XSSOK
			changeDisplayValue("<%=attrModelType%>");
			//XSSOK
			changeDisplayValue("<%=attrDesignatedUser%>");
       		document.editAttributesForm.submit();
    }
    }
	
	function validateForm(){
	   var bContinue = true;
	   for (var i=0;i < document.editAttributesForm.elements.length;i++)
	   {
			var xe = document.editAttributesForm.elements[i];
			var fieldName = xe.name
			
			if (fieldName.indexOf("_numeric") != -1){
				xe = document.editAttributesForm.elements[i-1];
				if(!isNumeric(xe)) {					
					bContinue = false;
					break;
				}
			}
	   }
	   return bContinue;
	}
	
    function doEditDetails(){
<%
        if((bLocked)){
            //Meaning of the above condition 
            //The object is locked and can not be edited.
%>
            var message = "<framework:i18nScript localize="i18nId">emxIEFDesignCenter.ObjectDetails.ErrLockedMsg</framework:i18nScript>";
            alert(message);
<%
        }else{
%>
           var windowParams = "width=550,height=570,screenX=228,left=228,screenY=125,top=125,toolbar=no,resizable=no,menubar=no,location=no,statusbar=yes,center=yes"  //XSSOK  
           window.open ("emxInfoObjectCheckAccesses.jsp?access=Modify&actionURL=emxInfoObjectEditDetailsDialogFS.jsp&targetLocation=popup&"+ "<%=appendParams%>", "EditDetails", windowParams);
          
<%
        }
%>  
    }
  
	function changeTextValue(comboName,fieldName){
		var editForm = document.editAttributesForm;
		var comboValue;
		for (var i=0;i < editForm.elements.length;i++)
		{
					var xe = editForm.elements[i];
					if (xe.name==comboName)
						comboValue=xe.options[xe.selectedIndex].value;
						
		}
     	for (var i=0;i < editForm.elements.length;i++)
		   {
				var xe = editForm.elements[i];
				if (xe.name== fieldName)
					xe.value = comboValue;
					
		   }
	}
  
</script>
</head>
<%
    if(null == emxGetParameter(request, "hasModify"))
    {   
        //Read Mode
%>    
<body class="content">
<%
	}else{ //Edit mode
%>
	<body class="content" onLoad="javascript:window.focus();">
<%
	}
%>
<form name="editAttributesForm" method="post" action="<%=XSSUtil.encodeForHTML(context,editURL)%>" id="idForm" onSubmit="return false">


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
    // Show the objectname if the mode is "PrinterFriendly"
	if ( sPFmode != null && sPFmode.equals("true") )
	{
    	String userName = (new com.matrixone.servlet.FrameworkServlet().getFrameContext(session)).getUser();
    	java.util.Date currentDateObj = new java.util.Date(System.currentTimeMillis());
    	String currentTime = currentDateObj.toString();
%>
		    <hr noshade>
    		<table border="0" width="100%" cellspacing="2" cellpadding="4">
    		 <tr>
			    <!--XSSOK-->
        		<td class="pageHeader" width="60%"><%=sName%></td>
        		<td width="1%"><img src="images/utilSpacer.gif" width="1" height="28" alt=""></td>
        		<td width="39%" align="right"></td>
        		<td nowrap>
            		<table>
					    <!--XSSOK-->
            			<tr><td nowrap=""><%=userName%></td></tr>
						<!--XSSOK-->
            			<tr><td nowrap=""><%=currentTime%></td></tr>
            		</table>
        		</td>
    		 </tr>
    		</table>
    		<hr noshade>
<%
	}
%>

<input type="hidden" name="busId" value="<xss:encodeForHTMLAttribute><%=sBusId%></xss:encodeForHTMLAttribute>">
<table border="0" width="100%" cellpadding="5" cellspacing="2">

<%
        if(bHasRead) {
        	//If the user has the read access
            //get the BusinessObject basics
            BusinessObjectBasics boBasics = boGeneric.getBasics(context);
            String sOwner                 = boBasics.getOwner();
            String sPolicy                = boBasics.getPolicy();
            String sOriginated            = boBasics.getCreated();
            String sModified              = boBasics.getModified();
            String sDescription           = boBasics.getDescription().trim();
        
            //Get the current state of the businessobject
            State stateCurrent            = getCurrentState(context,session,boGeneric);
            String sCurrentState = "";
            if(stateCurrent != null)
                sCurrentState = stateCurrent.getName();
%>
<!--XSSOK-->
<input type="hidden" name="orgBODescription" value="<%=sDescription%>">
<!-- Begin form field table -->
        <tr>
		  <!--XSSOK-->
          <td <%=sLabelColor%>><%=i18nNow. getMXI18NString("Type", "", request.getHeader("Accept-Language"),"Basic")%>&nbsp;&nbsp;</td>
		  <!--XSSOK-->
          <td <%=sCellColor%>><%=i18nNow. getMXI18NString(sType.trim(), "", request.getHeader("Accept-Language"),"Type")%>&nbsp;</td>
        </tr>
        <tr>
		  <!--XSSOK-->
          <td <%=sLabelColor%>><%=i18nNow. getMXI18NString("Vault", "", request.getHeader("Accept-Language"),"Basic")%>&nbsp;&nbsp;</td>
		  <!--XSSOK-->
          <td <%=sCellColor%>><%=i18nNow. getMXI18NString(sVault.trim(), "", request.getHeader("Accept-Language"),"Vault")%>&nbsp;</td>
        </tr>
        <tr>
		  <!--XSSOK-->
          <td <%=sLabelColor%>><%=i18nNow. getMXI18NString("Policy", "", request.getHeader("Accept-Language"),"Basic")%>&nbsp;&nbsp;</td>
		  <!--XSSOK-->
          <td <%=sCellColor%>><%=i18nNow. getMXI18NString(sPolicy.trim(), "", request.getHeader("Accept-Language"),"Policy")%>&nbsp;</td>
        </tr>
        <tr>
		  <!--XSSOK-->
          <td <%=sLabelColor%>><%=i18nNow. getMXI18NString("Owner", "", request.getHeader("Accept-Language"),"Basic")%>&nbsp;&nbsp;</td>
		  <!--XSSOK-->
          <td <%=sCellColor%>><%=sOwner%>&nbsp;</td>
        </tr>
<%      
        //Locked by nobody or the logged in person then don't show
        if(bLocked)
        {
%>        
        <tr>
		  <!--XSSOK-->
          <td <%=sLabelColor%>><img src="images/iconFrozen.gif" border="0">&nbsp;&nbsp;<framework:i18n localize="i18nId">emxIEFDesignCenter.Common.LockedBy</framework:i18n></td>
		  <!--XSSOK-->
          <td <%=sCellColor%>><%=sLocker%></td>
        </tr>
<%
        }
//Bug Fix ID:279264 start 
request.setAttribute("form","editAttributesForm");
java.util.Properties eMxProperties = null;
String dateFormat = "2";
String DateFrm = "";
String displayTime = "false";
try {
	eMxProperties = ServletUtil.getPropertiesFromBundle("emxSystem",application);

	//set the filter pattern for parameters in the Request bean
	if (eMxProperties!=null)
	{
		DateFrm		= eMxProperties.getProperty("emxFramework.DateTime.DisplayFormat");
		displayTime = eMxProperties.getProperty("emxFramework.DateTime.DisplayTime");
	}
	else
	{
		DateFrm		= (String)FrameworkProperties.getProperty("emxFramework.DateTime.DisplayFormat");
		displayTime = (String)FrameworkProperties.getProperty("emxFramework.DateTime.DisplayTime");
	}

	if("SHORT".equals(DateFrm))
		dateFormat = (new Integer(java.text.DateFormat.SHORT)).toString();
	if("MEDIUM".equals(DateFrm))
		dateFormat = (new Integer(java.text.DateFormat.MEDIUM)).toString();
	if("LONG".equals(DateFrm))
		dateFormat = (new Integer(java.text.DateFormat.LONG)).toString();
	if("FULL".equals(DateFrm))
		dateFormat = (new Integer(java.text.DateFormat.FULL)).toString();

}catch(Exception e){
		 System.out.println("Initailization Exception: " + e);
		 eMxProperties = null;
}
//Bug Fix ID:279264 End
%>        
        <tr>
		  <!--XSSOK-->
          <td <%=sLabelColor%>><%=i18nNow. getMXI18NString("Originated", "", request.getHeader("Accept-Language"),"Basic")%>&nbsp;&nbsp;</td>
		  <!--XSSOK-->
          <td <%=sCellColor%>><framework:lzDate displaydate="true" displaytime="<%=displayTime%>" localize="i18nId" tz='<%=(String)session.getValue("timeZone")%>' format='<%=dateFormat%>' ><%=sOriginated%></framework:lzDate>&nbsp;&nbsp;</td>
        </tr>
        <tr>
		  <!--XSSOK-->
          <td <%=sLabelColor%>><%=i18nNow. getMXI18NString("Modified", "", request.getHeader("Accept-Language"),"Basic")%>&nbsp;&nbsp;</td>
		  <!--XSSOK-->
          <td <%=sCellColor%>><framework:lzDate displaydate="true" displaytime="<%=displayTime%>" localize="i18nId" tz='<%=(String)session.getValue("timeZone")%>' format="<%=dateFormat%>" ><%=sModified%></framework:lzDate>&nbsp;&nbsp;</td>
        </tr>
        <tr>
		  <!--XSSOK-->
          <td <%=sLabelColor%>><%=i18nNow. getMXI18NString("Current", "", request.getHeader("Accept-Language"),"Basic")%>&nbsp;&nbsp;</td>
		  <!--XSSOK-->
          <td <%=sCellColor%>><%=sCurrentState%>&nbsp;&nbsp;</td>
        </tr>
        <tr>
		  <!--XSSOK-->
          <td valign="top" <%=sLabelColor%>><%=i18nNow. getMXI18NString("Description", "", request.getHeader("Accept-Language"),"Basic")%></td>
<%
        if (bHasModify){
        //Edit mode
		String desc = emxGetParameter(request, "txtDescription");
		if((desc == null) || ("null".equals(desc)))
			desc = sDescription;
%>
            <!--XSSOK-->
            <td valign="top" <%=sCellColor%>><textarea name="txtDescription" rows="5" cols="36" wrap><%= desc %></textarea></td>
<%
        }else{
		//Read mode
        	if(sDescription.length() == 0)
            	sDescription = "&nbsp;";            
%>
            <!--XSSOK-->
            <td wrap <%=sCellColor%> valign="top"><%=replaceCarriageReturns(sDescription)%></td>
<%
        }
%>
        </tr>
<%@include file="emxInfoObjectDisplayAttributes.inc"%> <%--For displaying the attributes--%>
      <!-- End form field table -->
<%
        } else {
%>
    <tr>
    <td class="errorMessage">
    <framework:i18n localize="i18nId">emxIEFDesignCenter.ObjectDetails.NoAccesMsg</framework:i18n>
    </td></tr>    
<%
        } // End of if(bHasRead)
%>    
</table>
</form>
<%
    boGeneric.close(context);
    } 
    catch (MatrixException e) 
    {
        String sError = e.getMessage();
%>
    <script language=javascript>
	   //XSSOK
       showError("<%=sError%>");
    </script>
<%
        return;
    }
%>

</body>
</html>
<!-- content ends here -->
