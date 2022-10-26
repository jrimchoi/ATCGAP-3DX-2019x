<%--
  iw_ApprovalMatrixDialog.jsp

  Copyright (c) 2007 Integware, Inc.  All Rights Reserved.
  This program contains proprietary and trade secret information of
  Integware, Inc.
  Copyright notice is precautionary only and does not evidence any
  actual or intended publication of such program.

  $Rev: 658 $
  $Date: 2011-02-27 16:46:51 -0700 (Sun, 27 Feb 2011) $
--%>
<html>

<head>
<title></title>

<%@include file = "emxComponentsDesignTopInclude.inc"%>
<%@include file = "emxComponentsVisiblePageInclude.inc"%>
<%@include file = "../emxUICommonHeaderBeginInclude.inc" %>
<%@include file = "../common/emxUIConstantsInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>

<link rel="stylesheet" href="../common/styles/iwCommonStyles.css" type="text/css">

<script language="javascript" src="../common/scripts/emxUICalendar.js"></script>
<script language="javascript" src="../common/scripts/emxUIFormUtil.js"></script>
<script language="javascript" src="../common/scripts/emxQuery.js"></script>
<script language="javascript" src="../common/scripts/emxTypeAhead.js"></script>
<script language="javascript" src="../common/scripts/emxUIJson.js"></script>

<%@include file = "../emxJSValidation.inc" %>
<%@include file = "../emxUICommonHeaderEndInclude.inc" %>

<%!
  public static final String ROLE                = "Role"; // Range value of "Approval User" attribute
  public static final String GROUP               = "Group"; // Range value of "Approval User" attribute
  public static final String ROLE_OR_GROUP       = "role_or_group"; // Unique key for map
  public static final String ROLE_OR_GROUP_NAME  = "role_or_group_name"; // Unique key for map
  public static final String BUNDLE 			 = "LSACommonFrameworkStringResource";

	//This method returns localized labels for the Group, Role, or name of the approver on the Select Approvers screen.	
	//It is a 2013 hot fix to fix labels not showing up for new groups users add to system.  Uses emxFramework.properties
	//for localized strings instead of undocumented property emxFramework.ApprovalMatrixRTUser.
	public String getRouteUserLabel(Map mRequiredTask, String sGroupUnderScore, String frmLanguage, String sApprovalUser){
		  //Keeping for legacy code
		  String sRTUserLabel = getI18NString(BUNDLE,"emxFramework.ApprovalMatrixRTUser."+sGroupUnderScore, frmLanguage);
		  //Route User = Attribute
		  if( (sRTUserLabel == null || sRTUserLabel == "") && sApprovalUser.equals("Attribute") ){
			  String sApprovalName = (String)mRequiredTask.get("attribute[Approval Name]");
			  if(sApprovalName.equals("owner")){
				  sRTUserLabel = getI18NString("emxFrameworkStringResource", "emxFramework.Basic.Owner", frmLanguage);
			  }
			  else if(sApprovalName.equals("description")){
				  sRTUserLabel = getI18NString("emxFrameworkStringResource", "emxFramework.Attribute.Description", frmLanguage);
			  }
			  else{
				  sRTUserLabel = getI18NString("emxFrameworkStringResource", "emxFramework.Attribute."+sApprovalName, frmLanguage);
			  }
		  }
		  //Route User = Person
		  else if ( (sRTUserLabel == null || sRTUserLabel == "") && sApprovalUser.equals("Person") ){
			  sRTUserLabel = getI18NString("emxFrameworkStringResource", "emxFramework.Type.Person", frmLanguage);
		  }
		  //Route User = Group or Role
		  else if ( sRTUserLabel == null || sRTUserLabel == "" ){
			  //builds string emxFramework.Group or emxFramework.Role to retrieve localization property from emxFrameworkStringResource. 
			  sRTUserLabel = getI18NString("emxFrameworkStringResource", "emxFramework."+sApprovalUser+"."+sGroupUnderScore, frmLanguage);
			  if(sRTUserLabel == null || sRTUserLabel == "")
				  sRTUserLabel = "emxFramework."+sApprovalUser+"."+sGroupUnderScore;
		  } 
		  if ( sRTUserLabel == null || sRTUserLabel == "" ){
			  sRTUserLabel = "";
		  }		
		return sRTUserLabel;
	}
%>
<%

  String sOId               = emxGetParameter(request,"objectId");
  String jsTreeID           = emxGetParameter(request,"jsTreeID");
  String processChildren    = emxGetParameter(request,"processChildren");
  String suiteKey           = emxGetParameter(request, "suiteKey");
  String frmLanguage        = request.getHeader("Accept-Language");

//If editableSequence set to false, all sequence fields are not editable.
//If editableSequence is not set or anything beside false, the sequence is editable
  String editableSequence       = emxGetParameter(request,"editableSequence");

//If startImmediately set to true, option is show and defaulted to Yes
//If startImmediately set to false, option is show and defaulted to no
//If startImmediately is not set, the option is not shown
  String sStartImmediately      = emxGetParameter(request,"startImmediately");

  String routeDescription       = emxGetParameter(request,"description");
  String routeCompletionAction  = emxGetParameter(request,"completionAction");
  String routeBasePurpose       = emxGetParameter(request,"basePurpose");
  String routeScope             = emxGetParameter(request,"scope");

  if (routeDescription==null || routeDescription.trim().length()==0)
    routeDescription = "";
  else
    routeDescription = UIForm.getFormHeaderString(context, pageContext, routeDescription, sOId, suiteKey, frmLanguage);

  if (routeScope==null || routeScope.trim().length()==0)
    routeScope = "Organization";

//If allowAdHoc set to true, AdHoc section is shown
//if allowAdHoc is not set or not 'true', the section is not shown
  String sAllowAdHoc            = emxGetParameter(request,"allowAdHoc");
  String[] reqArgs          = { sOId,"IWRequiredApprovalMatrixGroups",processChildren,routeScope };
  String[] reqOptArgs       = { sOId,"IWReqOptApprovalMatrixGroups",processChildren,routeScope };
  String[] optArgs          = { sOId,"IWOptionalApprovalMatrixGroups",processChildren,routeScope };
  String[] constructor      = { "" };
  Boolean usePersonChooser;         // Determines if drop-down or chooser will be offered
  String sApprovalUser;             // Value of 'Approval User' attribute for a given task
  StringList roleOrGroupList;       // List of "Role" or "Group" values paired with the roleOrGroupNameList list
  StringList roleOrGroupNameList;   // List containing roles and/or groups, paired with the roleOrGroupList list
  Hashtable  roleOrGroupTable;      // Container for the role and group lists passed to the JPO


  // Perform a trail promote of the object to make sure that
  // all dependancies are satified. This will surface any unmet
  // requirements upfront instead of after the user fills out
  // the AM screen and hits complete.
try
{
    context.start(true);

    //  Set an environmental variable to bypass any check triggers that are 'listening' for this env variable.
    MQLCommand mqlComm = new MQLCommand();
    mqlComm.open(context);
    mqlComm.executeCommand(context,"set env global BYPASS_CHECK_TRIGGER TRUE");
    mqlComm.close(context);

    BusinessObject busPromote = new BusinessObject(sOId);
    busPromote.promote(context);
}
catch (Exception e)
{
    emxNavErrorObject.addMessage(e.getMessage());
%>
<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>

<script language = "javascript" type = "text/javascript">
      document.location="about:blank";
      parent.close();
</script>
<%
}
finally
{
    context.abort();
}


  //Get type name to display at top of content frame
  DomainObject thisObj = new DomainObject(sOId);
  String thisObjType = thisObj.getInfo(context, DomainConstants.SELECT_TYPE);

  // Get the Hashmap return of Users/Groups/Roles that need to sign on this object
  // The return HashMap has the group name as the Key and a StringList of groupmembers
  // The is three total calls, one each to get the 'required, one of, and optional'
  HashMap mRequiredTasks = new HashMap();
  HashMap mReqOptTasks = new HashMap();
  HashMap mOptTasks = new HashMap();
  int iTotalTasksPossible = 0;

  try
  {
    mRequiredTasks = (HashMap)JPO.invoke(context, "IW_ApprovalMatrix", constructor, "getApprovalMatrixGroupsRoles", reqArgs, HashMap.class);
    mReqOptTasks   = (HashMap)JPO.invoke(context, "IW_ApprovalMatrix", constructor, "getApprovalMatrixGroupsRoles", reqOptArgs, HashMap.class);
    mOptTasks      = (HashMap)JPO.invoke(context, "IW_ApprovalMatrix", constructor, "getApprovalMatrixGroupsRoles", optArgs, HashMap.class);
    iTotalTasksPossible = mRequiredTasks.size() + mReqOptTasks.size() + mOptTasks.size();

  }
  catch(MatrixException mExp)
  {
    String msg = mExp.getMessage();
    msg = msg.trim();
    msg = msg.replace('\n',' ');
    msg = msg.replace('\r',' ');
    %>
    <script language="javascript">
      alert("<%=msg%>"); //alert the user //XSSOK
    </script>
    <%
  }

  // Must have at least one Required, one 'One of the following' or one Optional Approval Task defined
  if ( iTotalTasksPossible == 0)
  {
%>
    <script language="Javascript" >
      alert("<%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.ErrorMsg.noApprovalTaskDefined",BUNDLE,frmLanguage)%>").replace("'","&#39;");
    </script>
    
</head>
<body>
<%
  }

  //This is used for the javascript check to see if it needs to enforce that
  //a 'one of' task is selected
  String sHasOpts = "true";
  if (mReqOptTasks.isEmpty())
  {
    sHasOpts = "false";
  }
%>

<form name = "GetUsers" method="post" onSubmit="return CheckInput();" action="iw_ApprovalMatrixProcess.jsp" target="_parent">
<input type="hidden" name="UserList" value="">
<!-- XSSOK -->
<input type="hidden" name="busId" value="<%=sOId%>">
<!-- XSSOK -->
<input type="hidden" name="jsTreeID" value="<%=jsTreeID%>">
<!-- XSSOK -->
<input type="hidden" name="sHasOpts" value="<%=sHasOpts%>">
<!-- XSSOK -->
<input type="hidden" name="routeDescription" value="<%=routeDescription%>">
<!-- XSSOK -->
<input type="hidden" name="routeCompletionAction" value="<%=routeCompletionAction%>">
<!-- XSSOK -->
<input type="hidden" name="routeBasePurpose" value="<%=routeBasePurpose%>">
<!-- XSSOK -->
<input type="hidden" name="routeScope" value="<%=routeScope%>">

<%
  String subHeading = emxGetParameter(request,"subHeading");

  if (subHeading==null || subHeading.trim().length()==0)
    subHeading="";

  String finalSubHeading = "";
  if (subHeading.trim().length()==0)
    finalSubHeading ="<p>"+ i18nNow.getI18nString("emxFramework.ApprovalMatrix.selectUser",BUNDLE,frmLanguage).replace("'","&#39;") +  i18nNow.getTypeI18NString(thisObjType,frmLanguage).replace("'","&#39;")+ "</p>";
  else
    finalSubHeading = "<p>" + UIForm.getFormHeaderString(context, pageContext, subHeading, sOId, suiteKey, frmLanguage) + "</p>";
%>
<!-- XSSOK -->
<%=finalSubHeading%>
<table id="UserSelection" border="0" cellpadding="1" cellspacing="1" width="100%">
<%

  //Display delayed start option if passed via url param
  //Display with Yes checked if sStartImmediately is true
  //Display with No checked if sStartImmediately is false
  //Don's display anything if the parameter is not passed
  String sStartImmediatelyHTML = "";
  if ("true".equalsIgnoreCase(sStartImmediately))
  {
  %>
  	<tr>
      	<td class="labelRequired">&nbsp;<%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.startApprovalLabel",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%></td>
    	<td class="inputField" colspan=2 >&nbsp;<input type=radio name=startImmediately value=Yes checked="checked"><%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.radioButtonYes",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%><input type=radio name=startImmediately value=No><%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.radioButtonNo",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%></td>
    </tr>
  <%  
  }
  else if ("false".equalsIgnoreCase(sStartImmediately))
  {
  %>
  	<tr>
      	<td class="labelRequired">&nbsp;<%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.startApprovalLabel",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%></td>
  		<td class="inputField" colspan=2 >&nbsp;<input type=radio name=startImmediately value=Yes><%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.radioButtonYes",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%><input type=radio name=startImmediately value=No checked="checked"><%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.radioButtonNo",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%></td>
  	</tr>
  <%
    
  }

%>

    </tr>
<%

///////////////////////////////////
///////// REQUIRED GROUPS /////////
///////////////////////////////////

//Get the keys, which are all the groups required for signing
String[] keyArray = (String[])mRequiredTasks.keySet().toArray(new String[mRequiredTasks.keySet().size()]);
//this was done to sort by sequence
java.util.Arrays.sort(keyArray);

Map mRequiredTask;
String sTaskOID;
String sGroup = null;
StringList slGroupMembers;
String sOrder;
String sMember = null;
String sOnlyUserString;
String sOnlyUser;
String sOnlyUserFullName;
String sOnlyUserOID;
int iNumberOfApprovers = 0;

// Create the Form for user selection
%>
<tr>
  <td class="labelRequired" colspan="2">&nbsp;<%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.requiredLabel",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%></td>
  <td class="labelRequired" >&nbsp;<%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.taskOrderLabel",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%></td>
</tr>
<%

// Loop through all the required groups and present them
for(int i =0; i < keyArray.length; i++)
{
  iNumberOfApprovers++;
  mRequiredTask = (Map)mRequiredTasks.get(keyArray[i]);

  sTaskOID = (String)mRequiredTask.get("id");
  sGroup = (String)mRequiredTask.get("attribute[Route Task User]");
  String sGroupUnderScore = sGroup.trim().replaceAll(" ","_");
  slGroupMembers = (StringList)mRequiredTask.get("User List");
  sOrder = (String)mRequiredTask.get("attribute[Route Sequence]");

  //If there is only one user selectable mark it as such so that we can
  //pre-populate the select list
  sOnlyUserString = "";
  sOnlyUser="";
  sOnlyUserFullName="";
  sOnlyUserOID="";

  if (slGroupMembers.size() == 1)
  {
    sOnlyUserString = (String)slGroupMembers.get(0);
    //sOnlyUserString consists of last name, first name (username).  Get the username to use as the option value.
    if (sOnlyUserString.indexOf("(") >= 0 && sOnlyUserString.indexOf(")") > 0)
    {
      sOnlyUser = sOnlyUserString.substring(sOnlyUserString.indexOf("(") + 1, sOnlyUserString.indexOf(")"));
      sOnlyUserFullName = sOnlyUserString.substring(0, sOnlyUserString.indexOf("(") - 1);
      sOnlyUserOID = Person.getPerson(context, sOnlyUser).getId(context);
    }
  }

  // Remove unnecessary items from the map
  mRequiredTask.remove("id");
  mRequiredTask.remove("type");
  mRequiredTask.remove("name");
  mRequiredTask.remove("level");
  mRequiredTask.remove("relationship");
  mRequiredTask.remove("User List");
  mRequiredTask.remove("attribute[Approval Required]");
  mRequiredTask.remove("attribute[Route Sequence]");


  // This is to pass along all (non-displayed) additional attributes so they can be set by the processing page
  String[] innerKeyArray = (String[])mRequiredTask.keySet().toArray(new String[0]);
  for(int l =0; l < innerKeyArray.length; l++)
  {
%>
	<!-- XSSOK -->
  <input type="hidden" name="Map_<%=iNumberOfApprovers%>_<%=innerKeyArray[l]%>" value="<%=(String)mRequiredTask.get(innerKeyArray[l])%>">
<%
  }
  sApprovalUser = (String)mRequiredTask.get("attribute[Approval User]");
%>
  <tr>
  <!-- XSSOK -->
    <td class="labelRequiredNowrap" width="25%">&nbsp;<%=getRouteUserLabel(mRequiredTask, sGroupUnderScore, frmLanguage, sApprovalUser)%></td>
    <td class="inputField">


<%
      /* 04/2006 Approval Matrix People Chooser start */
      roleOrGroupList      = new StringList();
      roleOrGroupNameList  = new StringList();
      roleOrGroupTable     = new Hashtable();

      roleOrGroupList.add(sApprovalUser);
      roleOrGroupNameList.add(sGroup);
      roleOrGroupTable.put(ROLE_OR_GROUP, roleOrGroupList);
      roleOrGroupTable.put(ROLE_OR_GROUP_NAME, roleOrGroupNameList);
%>

          <%--
          Disabled - Used for type ahead
          <input type="hidden" value="" name="Map_<%=iNumberOfApprovers%>_UserfieldValue">
          <input type="text" name="Map_<%=iNumberOfApprovers%>_UserDisplay" onfocus="storePreviousValue(this)" onblur="updateHiddenValue(this)" size="30" maxlength="" value="<%= sOnlyUser %>">
          --%>
          
           <%--The hidden field that has AMType="required" must be followed by a text field to be picked up by the checkForEmptyValue() --%>
          <input type="hidden" value="<%=sOnlyUser%>" name="Map_<%=iNumberOfApprovers%>_User" />
          <input type="hidden" value="<%=sOnlyUserOID%>" name="Map_<%=iNumberOfApprovers%>_UserOID" AMType="required" />
          <input type="text" name="Map_<%=iNumberOfApprovers%>_UserDisplay" readonly size="30" maxlength="" value="<%=sOnlyUserFullName%>" AMLabel="<%=i18nNow.getI18nString("emxFramework.ApprovalMatrixRTUser."+sGroupUnderScore,BUNDLE,request.getHeader("Accept-Language"))%>" />
<%
	if (slGroupMembers.size() == 1) {
%>
		  <input type="button" value="..." name="chooser" disabled />
<%
	} else {
%>
		  <input type="button" value="..." name="chooser" onclick="javascript:showFullSearchChooserInForm('../common/emxFullSearch.jsp?chooserType=FormChooser&amp;submitURL=../common/AEFSearchUtil.jsp&amp;table=IWApprovalMatrixPersonChooserResults&amp;fieldNameDisplay=Map_<%=iNumberOfApprovers%>_UserDisplay&amp;selection=single&amp;mode=Chooser&amp;field=TYPES=type_Person&amp;submitAction=refreshCaller&amp;fieldNameOID=Map_<%=iNumberOfApprovers%>_UserOID&amp;HelpMarker=emxhelpfullsearch&amp;fieldNameActual=Map_<%=iNumberOfApprovers%>_User&amp;includeOIDprogram=IW_ApprovalMatrix_PersonChooser:includeAMAssignees&amp;<%=ROLE_OR_GROUP%>=<%=sApprovalUser%>&amp;<%=ROLE_OR_GROUP_NAME%>=<%=sGroup%>&amp;scope=<%=routeScope%>&amp;objectId=<%=sOId%>&amp;formInclusionList=NAME,FIRSTNAME,LASTNAME','Map_<%=iNumberOfApprovers%>_User')" />
<%	
	}
%>          
	</td>
    <td class="inputField">
<%
      if ("false".equalsIgnoreCase(editableSequence)){
%>
          <input type="text" name="Map_<%=iNumberOfApprovers%>_attribute[Route Sequence]" id="<%=sTaskOID%>" value="<%= sOrder%>" readonly size="1" onfocus="this.blur()" />
<%
      }
      else
      {
%>
      <input type="hidden" id="<%=sTaskOID%>" name="Map_<%=iNumberOfApprovers%>_attribute[Route Sequence]" value="<%=sOrder%>">
      <select name="<%=sOrder%>" onchange="document.getElementById('<%=sTaskOID%>').value=this.value;">
<%
        //Create option list of users
        for(int k = 0; k < iTotalTasksPossible; k++)
        {
          int iNumInSequence = k+1;
          int iOrder = Integer.parseInt(sOrder);
          String strSelected = "";
          if(iOrder == iNumInSequence) strSelected = "selected";
%>        <option value="<%=iNumInSequence%>" <%=strSelected%>><%=iNumInSequence%></option>
<%
        }
      }
%>
      </select>
    </td>
  </tr>
<%
} //End mRequiredTasks keys for loop


//////////////////////////////////////
////// REQUIRED/OPTIONAL GROUPS //////
//////////////////////////////////////


//Get the keys, which are all the groups required for signing
String[] reqOptKeyArray = (String[])mReqOptTasks.keySet().toArray(new String[mReqOptTasks.keySet().size()]);
//this was done to sort by sequence number
java.util.Arrays.sort(reqOptKeyArray);

Map mReqOptTask;
String sReqOptTaskOID;
String sReqOptGroup;
StringList slReqOptGroupMembers;
String sReqOptOrder;
String sOnlyReqOptUserString;
String sReqOptMember = null;

// Create the Form for user selection
if ( reqOptKeyArray.length > 0 )
{
  %>
   <tr>
    <td class="labelRequired" colspan="3">&nbsp;<%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.selectOneLabel",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%></td>
  </tr>
  <%
}

// Loop through all the optional groups and present them
for(int i = 0; i < reqOptKeyArray.length; i++)
{
  iNumberOfApprovers++;

  mReqOptTask = (Map)mReqOptTasks.get(reqOptKeyArray[i]);

  sReqOptTaskOID = (String)mReqOptTask.get("id");
  sReqOptGroup = (String)mReqOptTask.get("attribute[Route Task User]");
  slReqOptGroupMembers = (StringList)mReqOptTask.get("User List");
  sReqOptOrder = (String)mReqOptTask.get("attribute[Route Sequence]");

  if (slReqOptGroupMembers.size() == 1)
  {
    sOnlyReqOptUserString = (String)slReqOptGroupMembers.get(0);
  }


  // Remove unnecessary items from the map
  mReqOptTask.remove("id");
  mReqOptTask.remove("type");
  mReqOptTask.remove("name");
  mReqOptTask.remove("level");
  mReqOptTask.remove("relationship");
  mReqOptTask.remove("User List");
  mReqOptTask.remove("attribute[Approval Required]");
  mReqOptTask.remove("attribute[Route Sequence]");


  // This is to pass along all (non-displayed) additional attributes so they can be set by the processing page
  String[] innerReqOptKeyArray = (String[])mReqOptTask.keySet().toArray(new String[mReqOptTask.keySet().size()]);
  for(int l =0; l < innerReqOptKeyArray.length; l++)
  {
    %><input type="hidden" name="Map_<%=iNumberOfApprovers%>_<%=(String)innerReqOptKeyArray[l]%>" value="<%=(String)mReqOptTask.get(innerReqOptKeyArray[l])%>"><%
  }

%>
  <tr>
    <td class="labelRequiredNowrap" width="25%">&nbsp;<%=sReqOptGroup%></td>
    <td class="inputField">
<%
      /* 04/2006 Approval Matrix People Chooser start */
      sApprovalUser        = (String)mReqOptTask.get("attribute[Approval User]");
      roleOrGroupList      = new StringList();
      roleOrGroupNameList  = new StringList();
      roleOrGroupTable     = new Hashtable();

      roleOrGroupList.add(sApprovalUser);
      roleOrGroupNameList.add(sReqOptGroup);
      roleOrGroupTable.put(ROLE_OR_GROUP, roleOrGroupList);
      roleOrGroupTable.put(ROLE_OR_GROUP_NAME, roleOrGroupNameList);

      /* Show a drop-down or a text box and chooser? */
      if( sApprovalUser.equals(ROLE) || sApprovalUser.equals(GROUP) )
      {
          usePersonChooser = (Boolean)JPO.invoke(context, "IW_ApprovalMatrix_PersonChooser", constructor, "showPersonChooser", JPO.packArgs(roleOrGroupTable), Boolean.class);
      }
      else
      {
          usePersonChooser = new Boolean(false);
      }

      if(usePersonChooser.booleanValue())
      {
%>
          <input type="hidden"  approvaluser="true" id="Map_<%=iNumberOfApprovers%>_User" name="Map_<%=iNumberOfApprovers%>_User" AMType="oneof" value="">
          <input type="text" optional="true" name="<%=sReqOptGroup%>" id="<%=sReqOptGroup%>" value="" readonly onfocus="this.blur()" />
          <input type="button" name="chooser" value="..." onclick="javascript: searchPerson('<%=sApprovalUser%>', '<%=sReqOptGroup%>', 'Map_<%=iNumberOfApprovers%>_User', '<%=routeScope%>', '<%=sOId%>', 1)" />
<%
      }
      else
      {
%>
      <input type="hidden" id="Map_<%=iNumberOfApprovers%>_User" name="Map_<%=iNumberOfApprovers%>_User" value="">
      <select name="<%=sReqOptGroup%>" AMType="oneof" onchange="document.getElementById('Map_<%=iNumberOfApprovers%>_User').value=this.value">

      <option default value=""><%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.selectLabel",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%> 
<%

        for(int j =0; j < slReqOptGroupMembers.size(); j++)
        {
          String sMemberString = (String) slReqOptGroupMembers.get(j);
          //sMemberString consists of last name, first name (username).  Get the username to use as the option value.
          if (sMemberString.indexOf("(") >= 0 && sMemberString.indexOf(")") > 0)
          {
            sReqOptMember = sMemberString.substring(sMemberString.indexOf("(") + 1, sMemberString.indexOf(")"));
          }
%>
         <option value="<%=sReqOptMember%>"> <%=sMemberString%>
<%
        }
%>
      </select>
<%
      } // End else if( usePersonChooser.booleanValue())
%>
    </td>
    <td class="inputField">
<%
      if ("false".equalsIgnoreCase(editableSequence)){
%>
          <input type="text" name="Map_<%=iNumberOfApprovers%>_attribute[Route Sequence]" id="<%=sReqOptTaskOID%>" value="<%= sReqOptOrder%>" readonly size="1" onfocus="this.blur()" />
<%
      }
      else
      {
%>

      <input type="hidden" id="<%=sReqOptTaskOID%>" name="Map_<%=iNumberOfApprovers%>_attribute[Route Sequence]" value="<%=sReqOptOrder%>">
      <select name="<%=sReqOptOrder%>" onchange=document.getElementById("<%=sReqOptTaskOID%>").value=this.value;>

<%
        String strSelected;
        //Create option list of users
        for(int k = 0; k < iTotalTasksPossible; k++)
        {
          int iNumInSequence = k+1;
          int iOrder = Integer.parseInt(sReqOptOrder);
          strSelected = "";
          if(iOrder == iNumInSequence) strSelected = "selected";
%>
        <option value="<%=iNumInSequence%>" <%=strSelected%>><%=iNumInSequence%></option>
<%
        }
        }//end else
%>
      </select>
    </td>
  </tr>
<%
} //End for



/////////////////////////////
////// OPTIONAL GROUPS //////
/////////////////////////////

//Get the keys, which are all the groups required for signing
String[] optKeyArray = (String[])mOptTasks.keySet().toArray(new String[0]);
//this was done to sort by sequence
java.util.Arrays.sort(optKeyArray);

Map mOptTask = null;
String sOptTaskOID = null;
String sOptGroup = null;
StringList slOptGroupMembers = null;
String sOptOrder = null;
String sOnlyOptUser = "";
String sOnlyOptUserString = "";
String sOnlyOptUserFullName = "";
String sOptMember = null;

// Create the Form for user selection
if ( optKeyArray.length > 0 )
{
  %>
  <tr>
    <td class="label" colspan="3">&nbsp;<%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.optionalReviewers",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%></td>
  </tr>
  <%
}

// Loop through all the optional groups and present them
for(int i =0; i < optKeyArray.length; i++)
{
  iNumberOfApprovers++;
  mOptTask = (Map)mOptTasks.get(optKeyArray[i]);

  sOptTaskOID = (String)mOptTask.get("id");
  sOptGroup = (String)mOptTask.get("attribute[Route Task User]");
  String sGroupUnderScore = sOptGroup.trim().replace(" ", "_");
  slOptGroupMembers = (StringList)mOptTask.get("User List");
  sOptOrder = (String)mOptTask.get("attribute[Route Sequence]");

  if (slOptGroupMembers.size() == 1)
  {
    sOnlyOptUserString = (String)slOptGroupMembers.get(0);
    //sOnlyOptUserString consists of last name, first name (username).  Get the username to use as the option value.
    if (sOnlyOptUserString.indexOf("(") >= 0 && sOnlyOptUserString.indexOf(")") > 0)
    {
      sOnlyOptUser = sOnlyOptUserString.substring(sOnlyOptUserString.indexOf("(") + 1, sOnlyOptUserString.indexOf(")"));
    }
  }

  // Remove unnecessary items from the map
  mOptTask.remove("id");
  mOptTask.remove("type");
  mOptTask.remove("name");
  mOptTask.remove("level");
  mOptTask.remove("relationship");
  mOptTask.remove("User List");
  mOptTask.remove("attribute[Approval Required]");
  mOptTask.remove("attribute[Route Sequence]");


  // This is to pass along all (non-displayed) additional attributes so they can be set by the processing page
  String[] innerOptKeyArray = (String[])mOptTask.keySet().toArray(new String[0]);
  for(int l =0; l < innerOptKeyArray.length; l++)
  {


    %><input type="hidden" name="Map_<%=iNumberOfApprovers%>_<%=innerOptKeyArray[l]%>" value="<%=(String)mOptTask.get(innerOptKeyArray[l])%>"><%
  }
  sApprovalUser = (String)mOptTask.get("attribute[Approval User]");
%>
  <tr>
    <td class="labelNowrap" width="25%">&nbsp;<%=getRouteUserLabel(mOptTask, sGroupUnderScore, frmLanguage, sApprovalUser)%></td>
    <td class="inputField">
<%
      roleOrGroupList      = new StringList();
      roleOrGroupNameList  = new StringList();
      roleOrGroupTable     = new Hashtable();

      roleOrGroupList.add(sApprovalUser);
      roleOrGroupNameList.add(sOptGroup);
      roleOrGroupTable.put(ROLE_OR_GROUP, roleOrGroupList);
      roleOrGroupTable.put(ROLE_OR_GROUP_NAME, roleOrGroupNameList);

      /* Show a drop-down or a text box and chooser? */
      if( sApprovalUser.equals(ROLE) || sApprovalUser.equals(GROUP) )
      {
          usePersonChooser = (Boolean)JPO.invoke(context, "IW_ApprovalMatrix_PersonChooser", constructor, "showPersonChooser", JPO.packArgs(roleOrGroupTable), Boolean.class);
      }
      else
      {
          usePersonChooser = new Boolean(false);
      }

      if(usePersonChooser.booleanValue())
      {
%>
          <input type="hidden" id="Map_<%=iNumberOfApprovers%>_User" name="Map_<%=iNumberOfApprovers%>_User" AMType="optional" value="">
          <input type="text" name="<%=sOptGroup%>" id="<%=sGroup%>" value="OPTIONAL" readonly onfocus="this.blur()" />
          <input type="button" name="chooser" value="..." onclick="javascript: searchPerson('<%=sApprovalUser%>', '<%=sOptGroup%>', 'Map_<%=iNumberOfApprovers%>_User', '<%=routeScope%>', '<%=sOId%>', 1)" />
<%
      }
      else
      {
%>
      <input type="hidden" id="Map_<%=iNumberOfApprovers%>_User" name="Map_<%=iNumberOfApprovers%>_User" value="">
      <select name="<%=sOptGroup%>" AMType="optional" onchange="document.getElementById('Map_<%=iNumberOfApprovers%>_User').value=this.value;">

      <option default value=""><%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.optionalLabel",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%> 
<%

        for(int j =0; j < slOptGroupMembers.size(); j++)
        {
          String sMemberString = (String) slOptGroupMembers.get(j);
          //sMemberString consists of last name, first name (username).  Get the username to use as the option value.
          if (sMemberString.indexOf("(") >= 0 && sMemberString.indexOf(")") > 0)
          {
            sOptMember = sMemberString.substring(sMemberString.indexOf("(") + 1, sMemberString.indexOf(")"));
          }
%>
        <option value="<%=sOptMember%>"><%=sMemberString%></option>
<%
        }
%>
      </select>
    </td>
    <%
          } // End else if( usePersonChooser.booleanValue())
    %>

    <td class="inputField">
<%
      if ("false".equalsIgnoreCase(editableSequence)){
%>
          <input type="text" name="Map_<%=iNumberOfApprovers%>_attribute[Route Sequence]" id="<%=sOptTaskOID%>" value="<%= sOptOrder%>" readonly size="1" onfocus="this.blur()" />
<%
      }
      else
      {
%>
      <input type="hidden" id="<%=sOptTaskOID%>" name="Map_<%=iNumberOfApprovers%>_attribute[Route Sequence]" value="<%=sOptOrder%>">
      <select name="<%=sOptOrder%>" onchange=document.getElementById("<%=sOptTaskOID%>").value=this.value;>
<%
        //Create option list of users
        for(int k = 0; k < iTotalTasksPossible; k++)
        {
          int iNumInSequence = k+1;
          int iOrder = Integer.parseInt(sOptOrder);
          String strSelected = "";
          if(iOrder == iNumInSequence) strSelected = "selected";
%>        <option value="<%=iNumInSequence%>" <%=strSelected%>><%=iNumInSequence%></option>
<%
        }
        }//end else
%>
      </select>
    </td>
  </tr>
<%
} //End for


//Check to see if we should allow the AdHoc section
if ("true".equalsIgnoreCase(sAllowAdHoc)){
%>
  <tr>
    <td class="label" colspan=3><INPUT TYPE=button  VALUE="<%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.adHocApproverLabel",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%>" OnClick="addAdHocApprover();"></td>
  </tr>
  <tr>
    <td class="label" colspan=3><%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.optionalApproverLabel",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%></td>
  </tr>
  <tr>
    <td class="inputfield" colspan=3><div width="100%" id="anchorDiv"></div></td>
  </tr>
<%} //end if sAllowAdHoc
%>

  <input type="hidden" id="iNumberOfApprovers" name="iNumberOfApprovers" value="<%=iNumberOfApprovers%>">
</table>

</form>
</body>
<!-- 04/2006 Approval Matrix People Chooser start: Extracted JS to separate file. -->
<%@include file = "iw_ApprovalMatrixJS.inc"%>


<script language="javascript">

var AdHocUserNum=0;

function addAdHocApprover()
{
  if (document.body.clientWidth < '840' && document.body.clientHeight < '450'){
    getTopWindow().window.resizeTo(850,633);
  }
  var anchorDiv = document.getElementById("anchorDiv");
  var numOfApprovers = document.getElementById("iNumberOfApprovers");
  var currentNum = numOfApprovers.value;
  currentNum++;
  AdHocUserNum++;
  numOfApprovers.value = currentNum;
  var divIdName = "AH_"+currentNum+"_Div";
  var newdiv = document.createElement("DIV");
  newdiv.setAttribute("id",divIdName);
  var sAdHoc = '';
  sAdHoc += '<table width="100%">';
  sAdHoc += '<tr>';

  sAdHoc += '<td class="labelRequired">';
  sAdHoc += '<%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.taskTitleLabel",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%>';
  sAdHoc += '</td>';

  sAdHoc += '<td class="inputfield">';
  sAdHoc += "<input  type='text'  size='40'  name='Map_"+currentNum+"_attribute[Title]' id='Map_"+currentNum+"_attribute[Title]' value='<%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.adhocTaskLabel",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%>' >";
  sAdHoc += '</td>';

  sAdHoc += '<td class="labelRequired" colspan=2>';
  sAdHoc += '<input type="hidden" id="Map_'+currentNum+'_User" name="Map_'+currentNum+'_User" AMType="adhoc" value="" />';
  sAdHoc += '<%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.approverLabel",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%>' +AdHocUserNum;
  sAdHoc += '</td>';

  sAdHoc += '<td class="inputfield" colspan=2>';
  sAdHoc += '<nobr>';
  sAdHoc += '<input type="text" READONLY name="<%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.approverLabel",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%>'+AdHocUserNum+'" id="Adhoc'+currentNum+'_UserDisplay" value="" readonly="readonly">';
  sAdHoc += '<input type="button" value="..." onclick="javascript:showChooser(\'../components/emxCommonSearch.jsp?formName=GetUsers&frameName=pageContent&fieldNameActual=Map_'+currentNum+'_User&fieldNameDisplay=Adhoc'+currentNum+'_UserDisplay&searchmode=PersonChooser&suiteKey=Components&searchmenu=IWApprovalMatrixFindPeopleMenu&searchcommand=IWApprovalMatrixFindPeople\',\'700\',\'500\')"> ';
  sAdHoc += '</nobr>';
  sAdHoc += '</td>';

  sAdHoc += '<td class="labelRequired"><input type=button  value="<%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.removeLabel",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%>" OnClick="removeDiv(\''+divIdName+'\');">';
  sAdHoc += '</td>';
  sAdHoc += '</tr>';
  sAdHoc += '<tr>';

  sAdHoc += '<td class="labelRequired" border=0>';
  sAdHoc += '<%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.taskInstructionsLabel",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%>';
  sAdHoc += '</td>';

  sAdHoc += '<td class="inputfield">';
  sAdHoc += '<input type="hidden" id="Map_'+currentNum+'_attribute[Route Instructions]" name="Map_'+currentNum+'_attribute[Route Instructions]" value="<%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.approveContentLabel",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%>" />';
  sAdHoc += '<textarea class="AM_textarea" onchange=\'javascript:document.getElementById("Map_'+currentNum+'_attribute[Route Instructions]").value=this.value;\'><%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.approveContentLabel",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%></textarea>';
  sAdHoc += '</td>';

  sAdHoc += '<td class="labelRequired">';
  sAdHoc += '<%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.taskOrderLabel",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%>';
  sAdHoc += '</td>';

  sAdHoc += '<td class="inputfield">';
  sAdHoc += '<input type="text" size="1" name="Map_'+currentNum+'_attribute[Route Sequence]" id="Map_'+currentNum+'attribute[Route Sequence]" value="1">';
  sAdHoc += '</td>';

  sAdHoc += '<td class="labelRequired">';
  sAdHoc += '<%=i18nNow.getI18nString("emxFramework.ApprovalMatrix.daysCompleteLabel",BUNDLE,request.getHeader("Accept-Language")).replace("'","&#39;")%>';
  sAdHoc += '</td>';

  sAdHoc += '<td class="inputfield">';
  sAdHoc += '<input type="text" size="1" name="Map_'+currentNum+'_attribute[Due Date Offset]" value="5" />';
  sAdHoc += '</td>';


  sAdHoc += '<input type="hidden" name="Map_'+currentNum+'_attribute[Task Requirement]" value="Mandatory" />';
  sAdHoc += '<input type="hidden" name="Map_'+currentNum+'_attribute[Review Task]" value="No" />';
  sAdHoc += '<input type="hidden" name="Map_'+currentNum+'_attribute[Route Action]" value="Approve" />';
  sAdHoc += '<input type="hidden" name="Map_'+currentNum+'_attribute[Date Offset From]" value="Task Create Date" />';
  sAdHoc += '<input type="hidden" name="Map_'+currentNum+'_attribute[Comments]" value="" />';
  sAdHoc += '<input type="hidden" name="Map_'+currentNum+'_attribute[Assignee Set Due Date]" value="No" />';
  sAdHoc += '<input type="hidden" name="Map_'+currentNum+'_attribute[Approval User]" value="Attribute" />';
  sAdHoc += '<input type="hidden" name="Map_'+currentNum+'_attribute[Allow Delegation]" value="TRUE" />';
  sAdHoc += '<input type="hidden" name="Map_'+currentNum+'_attribute[Review Comments Needed]" value="No" />';
  sAdHoc += '<input type="hidden" name="Map_'+currentNum+'_attribute[Route Task User Company]" value="" />';
  sAdHoc += '<input type="hidden" name="Map_'+currentNum+'_attribute[Route Task User]" value="AdHoc" />';
  sAdHoc += '<input type="hidden" name="Map_'+currentNum+'_attribute[Approval Name]" value="AdHoc" />';
  sAdHoc += '</tr></table>';
  newdiv.innerHTML = sAdHoc;
  anchorDiv.appendChild(newdiv);
}


function removeDiv(divToRemoveName)
{
  var divToRemove = document.getElementById(divToRemoveName);
  //Set the inner html to blank to remove all the input fields
  divToRemove.innerHTML= "";
  divToRemove.parentNode.removeChild(divToRemove);

}


</script>

<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
<%@include file = "emxComponentsDesignBottomInclude.inc"%>
<%@include file = "../emxUICommonEndOfPageInclude.inc"%>

</html>

