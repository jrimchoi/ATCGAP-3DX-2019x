<%--  emxInfoCreateNewRevisionDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoCreateNewRevisionDialog.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoCreateNewRevisionDialog.jsp $
 * *****************  Version 23  *****************
 * User: Rajesh G  Date: 02/15/2004    Time: 8:44p
 * Updated in $/InfoCentral/src/infocentral
 * Changed For key pressed check Enter/Tab/Escape
 * ************************************************ * 
 * *****************  Version 22  *****************
 * User: Rahulp       Date: 12/11/02   Time: 1:27p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 21  *****************
 * User: Rahulp       Date: 12/09/02   Time: 5:37p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 20  *****************
 * User: Mallikr      Date: 11/22/02   Time: 5:57p
 * Updated in $/InfoCentral/src/InfoCentral
 * changed headers and added previous button
 * 
--%>

<%@ page import = "java.net.*" %>

<%@include file   ="emxInfoCentralUtils.inc"%> 			<%--For context, request wrapper methods, i18n methods--%>

<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css"><!--This is required for the font of the text-->
<link rel="stylesheet" href="../common/styles/emxUIDialog.css" type="text/css" ><!--This is required for the cell (td) back ground colour-->
<link rel="stylesheet" href="../common/styles/emxUIList.css" type="text/css" >
<link rel="stylesheet" href="../common/styles/emxUIForm.css" type="text/css">

<html>
<%
    
      String objectId= emxGetParameter(request, "objectId");
  	  String nextRevision= "";
      String policyDisplayName="";
	  String typeDisplayName="";
	  boolean revisionable =true;
	  String sName="";
      String oldVault="";
      String  exception = "";
	  try{
	  ContextUtil.startTransaction(context, false);
	  BusinessObject obj = new BusinessObject(objectId);
	  obj.open(context);
	  sName= obj.getName();
	  String sType= obj.getTypeName();
  	  String oldRevision= obj.getRevision();

	  Policy objPolicy = obj.getPolicy();
	  String strPolicyName=  objPolicy.getName();
	  oldVault = obj.getVault();
	  typeDisplayName=i18nNow.getTypeI18NString(sType ,request.getHeader("Accept-Language"));
	  StateList list = obj.getStates(context);
	  for ( int i = 0; i <list.size(); i++)
	  {
		State state =(State)list.get(i);
		if(state.isCurrent())
		{
          if(!state.isRevisionable()){
    		  exception= FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Error.NotRevisionable", request.getHeader("Accept-Language"));
			  revisionable =false;
		  }
		}
	  }
	  if(revisionable)
	  {
 
		//String command = "temp query  bus '"+ sType +"' '"+sName+"' "+"\""+oldRevision+"\"" + " select last dump |;";
		// 9/1/2004 Nagesh changed query
		// 9/1/2004 Nagesh changed query End 

	  MQLCommand mql = new MQLCommand();
      boolean ret = mql.executeCommand(context, "print bus $1 $2 $3 select $4 dump $5",sType,sName,oldRevision,"last","|");
	  String lastRevision="";
      if(ret)
	  {
		String objects = mql.getResult();
		StringTokenizer tokenizer = new StringTokenizer(objects , "|");
		int tokenCount = tokenizer.countTokens();
		int i =0 ;
		while(tokenizer.hasMoreTokens())
		{
			String token = tokenizer.nextToken();
			if(i==tokenCount-1)
				 lastRevision = token.trim();
		    i++;
		}
	  }
	  if(!lastRevision.equals(oldRevision))
	  {
      obj.close(context);
	  obj = new BusinessObject(sType,sName,lastRevision,"");
	  obj.open(context);
	  objectId = obj.getObjectId();
	  oldVault = obj.getVault();
	  }
	  Policy policy = obj.getPolicy();
	  policy.open(context);
	  if(policy.hasSequence()){
	  try{
      		nextRevision = obj.getNextSequence(context);
	  
		char[] htmlEncodedChar 	= {'&', '"', '<', '>', '\\', '\n'};
		String[] htmlEncodedStr = {"&amp;", "&quot;", "&lt;", "&gt;", "\\\\", "<br>"};

		StringBuffer strOut = new StringBuffer(nextRevision);

		//Browse all the special characters
		for (int i = 0; i < htmlEncodedChar.length; i++) 
		{
			int index = strOut.toString().indexOf(htmlEncodedChar[i]);
			while (index != -1) 
			{
				strOut.setCharAt(index, htmlEncodedStr[i].charAt(0));
				strOut.insert(index + 1, htmlEncodedStr[i].substring(1));
				//get next occurance
				index = index + htmlEncodedStr[i].length();
				index = strOut.toString().indexOf(htmlEncodedChar[i], index);
			}
		}
		nextRevision = strOut.toString();
	  
	  }
	  catch(Exception e)
	  {
	   String err = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Error.LoadSequence", request.getHeader("Accept-Language"));
       exception = err+" "+policy.getName();
      }
	  }
	  String sPolicy= policy.getName();
	  policyDisplayName=getPolicyI18NString(sPolicy ,request.getHeader("Accept-Language"));
	  policy.close(context);
	  obj.close(context);
	  }
	  ContextUtil.commitTransaction(context);
	}
	catch(Exception e)
	{
     ContextUtil.abortTransaction(context);
	 exception = e.toString().trim();
	}
    
%>
<head>
<script language="JavaScript">

function reDirect(){
	
	//XSSOK
    var ex = "<%=exception%>";
    if(ex!=""){
    alert(ex);
	parent.window.close();
	}
}

function next(){
	var vault = trim(document.newRevision.txtVault.value);
	if(vault=="")
	{
	<%
     String errMsg= FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Error.ChooseVault", request.getHeader("Accept-Language"));
	%>
    alert("<%=errMsg%>");
    return;
	}
	document.newRevision.txtRevision.value = trim(document.newRevision.txtRevision.value);
	if(document.newRevision.txtRevision.value=="")
	{
	<%
     errMsg= i18nStringNow("emxIEFDesignCenter.Error.InValidRevision", request.getHeader("Accept-Language"));
	%>
    alert("<%=errMsg%>");
    return;
	}
    document.newRevision.submit();
  }
 function closeWindow(){

   parent.window.close();
}


  // This Function Checks for the length of the Data that has
  // been entered and trims the leading and trailing spaces.
  function trim (textBox) {
      while (textBox.charAt(textBox.length-1) == ' ' || textBox.charAt(textBox.length-1) == "\r" || textBox.charAt(textBox.length-1) == "\n" )
        textBox = textBox.substring(0,textBox.length - 1);
      while (textBox.charAt(0) == ' ' || textBox.charAt(0) == "\r" || textBox.charAt(0) == "\n")
        textBox = textBox.substring(1,textBox.length);
        return textBox;
  }

// Integration  of vault chooser
    var bVaultMultiSelect = false;
    var strTxtVault = "document.forms['newRevision'].txtVault";
    var txt_Vault = null;
    function showVaultSelector() {

    var strFeatures = "width=300,height=350,screenX=238,left=238,screenY=135,top=135,resizable=no,scrollbars=auto";
    txt_Vault = eval(strTxtVault);
    var win = window.open("emxSelectVaultDialog.jsp", "VaultSelector", strFeatures);
   // showModalDialog('emxSelectVaultDialog.jsp', 300, 350);
  }
	  
	//-- 02/15/2004         Start rajeshg   -->	
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
	document.onkeypress = cptKey ;
	//-- 02/15/2004         End  rajeshg   -->	

</script>
</head>

<body class="content" onload ="reDirect();">

<table border="0" cellpadding="0" cellspacing="0"  width="1%" align="center">
		<tr><td class="requiredNotice" align="center" nowrap ><framework:i18n localize="i18nId" >emxIEFDesignCenter.Common.FieldsInRed</framework:i18n></td></tr>
</table>
	
<form name="newRevision" id="idForm" action="emxInfoRevisionAttributeFS.jsp" target="_parent" method="post">

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
//System.out.println("CSRFINJECTION::emxInfoCreateNewRevisionDialog.jsp::form::newRevision");
%>


  <input type="hidden" name="objectId" value="<%=XSSUtil.encodeForHTMLAttribute( context ,objectId)%>">
   <table align ="left" class="formBG" width="100%" cellpadding="3" border="0" cellspacing="2">
     <tr >
     <td nowrap class="label">
	 	 <%=i18nNow.getBasicI18NString("Type",  request.getHeader("Accept-Language"))%>
		 &nbsp;&nbsp;
     </td>
     <td nowrap class="inputField">
         <%=typeDisplayName%>
     <td>
     </tr>

    <tr >
     <td nowrap class="label">
	 	 <%=i18nNow.getBasicI18NString("Name",  request.getHeader("Accept-Language"))%>
		 &nbsp;&nbsp;
     </td>
     <td nowrap class="inputField">
         <%=XSSUtil.encodeForHTML(context,sName)%>
     <td>
     </tr>

	 <tr >
     <td nowrap class="labelRequired">
	 	 <%=i18nNow.getBasicI18NString("Revision",  request.getHeader("Accept-Language"))%>
		 &nbsp;&nbsp;
     </td>
     <td nowrap class="inputField">
         <input type="text" name="txtRevision" value ="<%=XSSUtil.encodeForHTML(context,nextRevision)%>" onkeypress="javascript:if((event.keyCode == 13) || (event.keyCode == 10) || (event.which == 13) || (event.which == 10)) parent.frames[1].next()">
     <td>
     </tr>

    <tr >
      <td nowrap class="label">
 	 <%=i18nNow.getBasicI18NString("Vault",  request.getHeader("Accept-Language"))%>
	  </td>
      <!-- Integrating vault chooser -->
	  <td nowrap class="inputField">
	  	  <input type=text  value="<%=XSSUtil.encodeForHTML(context,oldVault)%>"  name="txtVault"  onChange="JavaScript:ClearSearch()" readonly="readonly" onkeypress="javascript:if((event.keyCode == 13) || (event.keyCode == 10) || (event.which == 13) || (event.which == 10)) parent.frames[1].next()">
          <input type=button value="..." onClick=showVaultSelector()>
	  <!-- Integration of vault chooser ends here -->
      </td>
      </tr>

	  <tr >
     <td nowrap class="label">
		 	 <%=i18nNow.getBasicI18NString("Policy",  request.getHeader("Accept-Language"))%>
		 &nbsp;&nbsp;
     </td>
     <td nowrap class="inputField">
	     <!--XSSOK-->
         <%=policyDisplayName%>
     <td>
     </tr>

  </table>&nbsp;
</form>
</body>
</html>
