<%--
  iw_ApprovalMatrixJS.inc

  Copyright (c) 2007 Integware, Inc.  All Rights Reserved.
  This program contains proprietary and trade secret information of
  Integware, Inc.
  Copyright notice is precautionary only and does not evidence any
  actual or intended publication of such program.

  $Rev: 658 $
  $Date: 2011-02-27 16:46:51 -0700 (Sun, 27 Feb 2011) $
--%>
<%@ page import="com.matrixone.apps.domain.util.*"  %>
<%!
public static final String DELIMITER           = "|"; // Required by the included
public static final String DIALOG_DATA         = "dialog_data"; // Unique key used in URL
public static final String RESOURCE_BUNDLE = "LSACommonFrameworkStringResource";
%>

<%
	String languageString = request.getHeader("Accept-Language");
	i18nNow loc = new i18nNow();          
%>
<script language="javascript" type="text/javascript" src="emxDocumentUtilities.js"></script>
<script language="javascript" type="text/javascript" src="../emxUIPageUtility.js"></script>

<script language="javascript" type="text/javascript">

  // This is used so we don't double submit the form
  var alreadySubmitted = "false"
  var allowMultipleTasksToOneUser = "true"
  var allowSelectingYourselfAsApprover = "true"

  function cancelAssignment()
  {
    parent.window.close();
  }

  function submitForm(sUserName)
  {
    if (alreadySubmitted == "true") {
      alert("<%=loc.GetString(RESOURCE_BUNDLE,languageString,"LSACommonFramework.Message.ApprovalAlreadySentForCreation")%>"); //XSSOK
      return;
    }

    var username = sUserName;
    var userlist = "";
    var reqOptFulfilled = "false";
    var arraySize = document.GetUsers.elements.length;
    var selectElements = new Array(arraySize);
    var hiddenUserAndTextElements = new Array(arraySize);
    var textElements = new Array(arraySize);
    var selectCount = 0;
    var textCount = 0;
    var txtCount = 0;
    var type1;
    var type2;
    var element1;
    var element2;
    var elementName;

    // For items where there are a reasonable number of options
    // we general show a drop down select box to allow the user
    // to pick.  However when there is a large number of users,
    // like when allowing any user in the system, we use a input=hidden
    // field and a input=text field. There is a chooser that will populate
    // the value of the hidden and text fields.


    // Put the 'select' and 'hidden/text' elements into
    // seperate arrays to process
    for (var i=0; i < (document.GetUsers.elements.length); i++) {
      type1 = document.GetUsers.elements[i].type;
      elementName = document.GetUsers.elements[i].name;

      if( type1 == "select-one" || type1 == "select-multiple" ) {
        selectElements[selectCount++]=document.GetUsers.elements[i];
      }
      // We only look for hidden fields that have the string '_User'
      // in the name. There is an untested assumption that the hidden
      // field will be immediatly followed by the text field in the dom
      else if( type1 == "hidden" && elementName.indexOf("_User") != -1 ) {
        type2 = document.GetUsers.elements[i+1].type;
        if( type2 == "text" ) {
          hiddenUserAndTextElements[textCount++]= new Array( document.GetUsers.elements[i], document.GetUsers.elements[i+1] );
        }
      }  
      else if( type1 == "text" && (elementName.indexOf("Route Sequence") != -1 || elementName.indexOf("Due Date Offset") != -1)) 
      {
          textElements[txtCount++]= new Array( document.GetUsers.elements[i], document.GetUsers.elements[i+1] );
      } 

      // verify that if there are any optional approvers that they are completely 
      // filled in with all required fields
      
      // Bug 31535 - This check has been commented out to resolve blocker issues
      // where when there is more than 1 default Approval Task defined, promote
      // is blocked: 33427, 33401, 33428
      //if(!checkOptionalApproverRequiredFields(document.GetUsers.elements[i])){
  	  //   return;
      //}
       
    }

    //Process the 'select' elements
    for (var i=0; i<selectCount; i++) {
      element1 = selectElements[i];
      if (element1.name.indexOf("attribute[Title]") == -1) {
        if (!checkForEmptyValue(element1, element1)) {
          return;
        }
      }

      if(element1.value == username) {
        if (!checkForSelfSelected(element1, element1)) { return; }
      }

      if (!checkForNoOptions(element1)) { return; }

      if (allowMultipleTasksToOneUser == "false") {
        if (!checkForSameUserSelectedMoreThanOnce(element1, element1)) { return; }
      }

      if (element1.getAttribute("AMType") == "oneof") {
        //By default the value is "", if it is not then the user must
        //have changed it and the requirements have been meet
        if (element1.value != "") {
          reqOptFulfilled = "true";
        }
      }
    } // Process 'select' elements


    //Process the 'hidden/text' elements
    var tempArray;
    for (var i=0; i<textCount; i++) {
      tempArray = hiddenUserAndTextElements[i];
      element1 = tempArray[0]; //hidden field
      element2 = tempArray[1]; //text field

      //Look at the text field for the values. We shouldn't populate
      //the hidden value unless there is only one user or the user
      //has selected a value
      if (!checkForEmptyValue(element1, element2)) { return; }

      // Unlike the select list; for the Person chooser we don't have to worry
      // about the user being the only person in the list, because if they were
      // the only person a person chooser would not be displayed.
      if(element1.value == username && allowSelectingYourselfAsApprover == "false") {
        var group = element2.name;
        alert("<%=loc.GetString(RESOURCE_BUNDLE,languageString,"LSACommonFramework.Message.CanNotSelectSelfForGroup")%> " + group); //XSSOK
        element2.focus();
        return ;
      }

      if (allowMultipleTasksToOneUser == "false") {
        if (!checkForSameUserSelectedMoreThanOnce(element1, element2)) { return; }
      }

      if (element1.getAttribute("AMType") == "oneof") {
        if (element1.value != ""){
          reqOptFulfilled = "true";
        }
      }
    } // Process 'hidden/text' elements

    if (!checkForOptionalRequiredFields( reqOptFulfilled ))
    {
      return;
    }
    
    //Process the 'text' elements
    var tmpArray;
    for (var i=0; i<txtCount; i++) 
    {
      tmpArray = textElements[i];
      element1 = tmpArray[0]; //hidden field
      element2 = tmpArray[1]; //text field

      // Validate Route Sequence and Due Date Offset 
      if (!validateNumber(element1, element2)) 
      { 
      	return; 
      }
      
    } // Process 'hidden/text' elements
    

    // Set the alreadySubmitted variable to true so nobody can double click the submit button.
    alreadySubmitted = "true";
    // Turns on the clock to show processing
    turnOnProgress(true);
    document.GetUsers.submit();
  }

  // This function validates that all required fields of the optional approvers are filled in.
  // The elements for the optional approvers will start with 'Map_2_ or greater.
  function checkOptionalApproverRequiredFields(element){
   	if( (element.name.indexOf("attribute[Title]") != -1) || (element.name.indexOf("attribute[Route Instructions]") != -1) ||
           (element.name.indexOf("attribute[Route Sequence]") != -1) || (element.name.indexOf("attribute[Due Date Offset]") != -1) ){
    	// This is one of the elements we are interested in, but it may be for Map_1, which we dont want   
      	if( element.name.indexOf("Map_1_") == -1){ // We want to skip Map_1
      		if(trimString(element.value) == ""){
                        alert("<%=loc.GetString(RESOURCE_BUNDLE,languageString,"LSACommonFramework.Message.MustProvideAllFieldsForOptionalApprover")%>"); //XSSOK
      			return false;
      		}
      	}
  	}
  	return true;
  }


  function trimString(strString) 
  {
    strString = strString.replace(/^\s*/g, "");
    return strString.replace(/\s+$/g, "");
  }
  
  function validateNumber(element1,element2)
  {
   	// Validate Route Sequence 
   	var value=element1.value;
    var name=element1.name;
    if(name.indexOf("Route Sequence")!=-1)
    {
    	if(value == null || trimString(value)== "")
    	{
    		alert("<%=loc.GetString(RESOURCE_BUNDLE,languageString,"LSACommonFramework.Message.MustEnterTaskOrder")%>"); //XSSOK
    		element1.focus();
    		return false;
    	}
    	else if(!validateForInteger(value))
    	{
    		alert("<%=loc.GetString(RESOURCE_BUNDLE,languageString,"LSACommonFramework.Message.MustEnterValidTaskOrder")%>"); //XSSOK
    		element1.focus();
    		return false;
    	}
    }
    
    // Validate Days to Complete
   	var value=element2.value;
    var name=element2.name;
    if(name.indexOf("Due Date Offset")!=-1)
    {
    	if(value == null || trimString(value)== "")
    	{
    		alert("<%=loc.GetString(RESOURCE_BUNDLE,languageString,"LSACommonFramework.Message.MustEnterDueDateOffset")%>"); //XSSOK
    		element2.focus();
    		return false;
    	}
    	else if(!validateForInteger(value))
    	{
    		alert("<%=loc.GetString(RESOURCE_BUNDLE,languageString,"LSACommonFramework.Message.MustEnterValidDueDateOffset")%>"); //XSSOK
    		element2.focus();
    		return false;
    	}
    }
    return true;
  }
  
  function validateForInteger(value)
  {
  	if (parseFloat(value) < 1) 
        {
        	return false;
        }
    return true;	
  }
  function checkForEmptyValue(element1, element2)
  {
    if (element1.value == "" && element1.getAttribute("AMType")=="required") {
      var group = element2.getAttribute("AMLabel");
      alert("<%=loc.GetString(RESOURCE_BUNDLE,languageString,"LSACommonFramework.Message.MustSelectUserForGroup")%> "+ group); //XSSOK
      element2.focus();
      return false;
    }

    if (element1.value == "" && element1.getAttribute("AMType")=="adhoc") {
      var group = element2.name;
      alert("<%=loc.GetString(RESOURCE_BUNDLE,languageString,"LSACommonFramework.Message.MustSelectUserForOptionalApprover")%> "+ group); //XSSOK
      element2.focus();
      return false;
    }
    return true;
  }

  function checkForSelfSelected(element1, element2)
  {
    if (element1.options.length != 1 && allowSelectingYourselfAsApprover == "false") {
      var group = element2.name;
      alert("<%=loc.GetString(RESOURCE_BUNDLE,languageString,"LSACommonFramework.Message.CanNotSelectSelfForGroup")%> " + group); //XSSOK
      element2.focus();
      return false;
    }
    return true;
  }

  function checkForNoOptions(element1)
  {
    if(element1.options && element1.options.length == 0) {
      var group = element1.name;
      alert("<%=loc.GetString(RESOURCE_BUNDLE,languageString,"LSACommonFramework.Message.NoUsersDefinedForGroup")%> " + group + "\n<%=loc.GetString(RESOURCE_BUNDLE,languageString,"LSACommonFramework.Message.Details.Default")%>" ); //XSSOK
      return false;
    }
    return true;
  }

  function checkForSameUserSelectedMoreThanOnce(element1, element2)
  {
    if (element1.value != "" && element1.value != "not" && element1.value != "opt" && element1.value != "optional") {
      var user = element1.value;
      // Creates a new Regular Expression that will check if the string ends with doc
      var pattern = new RegExp(user);

      // To test the reg you do an .exec passing the string you want tested
      if ( userlist != "" && element1.approvaluser == "true" && pattern.test(userlist) ) {
        alert("<%=loc.GetString(RESOURCE_BUNDLE,languageString,"LSACommonFramework.Message.CanNotChooseSameUserTwice")%> "+ element2.value ); //XSSOK
        element2.focus();
        return false;
      }
      userlist+=element2.name + "," + element2.value + "|";
    }
    return true;
  }

  function checkForOptionalRequiredFields(reqOptFulfilled)
  {
    if (reqOptFulfilled == "false" && document.GetUsers.sHasOpts.value == "true") {
      alert("<%=loc.GetString(RESOURCE_BUNDLE,languageString,"LSACommonFramework.Message.MustSelectAtLeastOneUser")%>"); //XSSOK
      return false;
    }
    return true;
  }

  //Function used by the 'Submit' and 'Search' buttons of the Person Chooser results table page
  function searchPerson(roleOrGroup, roleOrGroupName, approverNumber, routeScope, objectId, newModalWindow)
  {
  /* XSSOK */
    var url = "../common/emxSearch.jsp?defaultSearch=IWApprovalMatrixPeopleChooserSearch&<%= ROLE_OR_GROUP %>="
                    + roleOrGroup + "&<%= ROLE_OR_GROUP_NAME %>=" + roleOrGroupName
                    + "&SubmitURL=../components/iw_ApprovalMatrixPeopleChooserProcess.jsp?<%= DIALOG_DATA %>="
                    + roleOrGroup + "<%= DELIMITER %>" + roleOrGroupName + "<%= DELIMITER %>" + approverNumber
                    + "&scope=" + routeScope
                    + "&objectId=" + objectId
                    + "&cachecombat=" + <%= System.currentTimeMillis() %>;

    if( newModalWindow ) {
      emxShowModalDialog(url, 775, 500);
    }
    else {
      getTopWindow().location.href=url;
    }
  }
</script>
