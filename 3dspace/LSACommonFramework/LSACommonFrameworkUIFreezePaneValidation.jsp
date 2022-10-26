<%--
   Copyright (c) 2007 Integware, Inc.
   All Rights Reserved.
   This program contains proprietary and trade secret information of
   Integware, Inc.
   Copyright notice is precautionary only and does not evidence any
   actual or intended publication of such program

   $Rev$
   $Date$
--%>
<%@include file="../common/emxNavigatorInclude.inc"%>
<%@page import="matrix.util.*,com.matrixone.apps.framework.ui.*"%>
<%@page import="java.text.*"%>
<%@page import="com.matrixone.apps.domain.util.*"%>
<%@page import="com.dassault_systemes.enovia.lsa.Helper, com.dassault_systemes.enovia.lsa.LSAException"%>
<%@include file="../common/emxFormConstantsInclude.inc"%>
<%!
	private String getI18NString(Context context, Helper.StringResource stringResource, String key) throws LSAException {
		try {
			return XSSUtil.encodeForJavaScript(context, Helper.getI18NString(context, stringResource, key));
		} catch (Exception e) {
			throw new LSAException(e);
		}
	}

%>
<%
out.clear();
response.setContentType("text/javascript; charset=" + response.getCharacterEncoding());
String accLanguage  = request.getHeader("Accept-Language");
%>
    function validateName()
	{
	    var newValue = arguments[0];
	    var STR_NAME_BAD_CHARS = "@ , * ? [ ] # $ { } \\ \" < > | % ; :";
		var ARR_NAME_BAD_CHARS = "";
		if (STR_NAME_BAD_CHARS != "") 
		{    
		  ARR_NAME_BAD_CHARS = STR_NAME_BAD_CHARS.split(" ");   
		}
		var strBadChars = validateForBadChars(newValue,ARR_NAME_BAD_CHARS);		
        if (strBadChars.length > 0) 
        {
        	alert("<%=RESTRICTED_BAD_CHARS%>" + " " + STR_NAME_BAD_CHARS);
        	return false;
        }                        
		return true;	   
	}
	
	function validateDescription()
	{
	    var newValue = arguments[0];
	    var STR_DESCRIPTOIN_BAD_CHARS = "@ * ? [ ] # &";
	    var MUST_ENTER_VALID_INTERGER_VALUE = "<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.OnlyNumberOfChars") %>" + " "; //XSSOK
		var ARR_DESCRIPTION_BAD_CHARS = "";
		if (STR_DESCRIPTOIN_BAD_CHARS != "") 
		{    
		  ARR_DESCRIPTION_BAD_CHARS = STR_DESCRIPTOIN_BAD_CHARS.split(" ");   
		}
		if(newValue.length > 250)
        {
        	alert(MUST_ENTER_VALID_INTERGER_VALUE + "<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Common.Description") %>"); //XSSOK
        	return false;
        }
		var strBadChars = validateForBadChars(newValue,ARR_DESCRIPTION_BAD_CHARS);
        if (strBadChars.length > 0) 
        {
        	alert("<%=RESTRICTED_BAD_CHARS%>" + " " + STR_DESCRIPTOIN_BAD_CHARS);
        	return false;
        }                        
		return true;	
	}
	
	function validateDetailedInstructions()
	{
	    var newValue = arguments[0];
	    var STR_DESCRIPTOIN_BAD_CHARS = "@ * ? [ ] # &";
	    var MUST_ENTER_VALID_INTERGER_VALUE = "<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.OnlyNumberOfChars")%>" + " "; //XSSOK
		var ARR_DESCRIPTION_BAD_CHARS = "";
		if (STR_DESCRIPTOIN_BAD_CHARS != "") 
		{    
		  ARR_DESCRIPTION_BAD_CHARS = STR_DESCRIPTOIN_BAD_CHARS.split(" ");   
		}
		if(newValue.length > 250)
        {
        	alert(MUST_ENTER_VALID_INTERGER_VALUE + "<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Common.ActionItemDetailedInstructions")%>"); //XSSOK
        	return false;
        }
		var strBadChars = validateForBadChars(newValue,ARR_DESCRIPTION_BAD_CHARS);
        if (strBadChars.length > 0) 
        {
        	alert("<%=RESTRICTED_BAD_CHARS%>" + " " + STR_DESCRIPTOIN_BAD_CHARS);
        	return false;
        }                        
		return true;	
	}
	
	function validateNumbers()
	{
	    var newValue = arguments[0];
	    var STR_DESCRIPTOIN_BAD_CHARS = "@ , * ? [ ] # $ { } \\ \" < > | % ; :";
		var ARR_DESCRIPTION_BAD_CHARS = "";
		if (STR_DESCRIPTOIN_BAD_CHARS != "") 
		{    
		  ARR_DESCRIPTION_BAD_CHARS = STR_DESCRIPTOIN_BAD_CHARS.split(" ");   
		}
		var strBadChars = validateForBadChars(newValue,ARR_DESCRIPTION_BAD_CHARS);
        if (strBadChars.length > 0) 
        {
        	alert("<%=RESTRICTED_BAD_CHARS%>" + " " + STR_DESCRIPTOIN_BAD_CHARS);
        	return false;
        }                        
		return true;	
	}
	
	
	function validateForBadChars(fieldValue, arrBadChars)
	{
		var strBadChars = "";
	    for (var i=0; i < arrBadChars.length; i++) 
        {
            if (fieldValue.indexOf(arrBadChars[i]) > -1) 
            {
            	strBadChars += arrBadChars[i] + " ";
            }
        }
	    return strBadChars;
	}
	
	function checkForNoLetters()
	{
		var regEx = new RegExp(/[a-zA-Z]/);
		var val = arguments[0];
		if(regEx.test(val))
		{
			alert(val + ", <%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.NoLettersAllowed") %>"); //XSSOK
			return false;
		}
		return true;
	}

	// This function is used to check for only numbers 
	function checkForNumbers()
	{
		// \D matches any non-digit (short for [^0-9]).
		var regEx = new RegExp(/\D/);
		var val = arguments[0];
		if(regEx.test(val))
		{
			alert(val + ", <%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.OnlyNumbersAllowed") %>"); //XSSOK
			return false;
		}
		return true;
	}

	//This function is used to check for only letters
	function checkForLetters()
	{
		var regEx = new RegExp(/[^a-zA-Z]/);
		var val = arguments[0];
		if(regEx.test(val))
		{
			alert(val + ", <%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.OnlyLettersAllowed") %>"); //XSSOK
			return false;
		}
		return true;
	}

	//This function is used to check Contact First/Last Name
	function checkForNames()
	{
		var regEx = new RegExp(/[^a-zA-Z'-]/);
		var val = arguments[0];
		if(regEx.test(val))
		{
			alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.NameFieldCharacterAllowed") %>"); //XSSOK
			return false;
		}
		return true;
	}

	//validate Submission Issue Received Date field
	function validateReceivedDate()
	{
     	var selectedDateMS = arguments[0];
        // remove 12 hrs before testing the date chosen to account for Matrix setting
        // the time to 12:00 noon from the date picker
        var selectedDateMS_num = selectedDateMS - 43200000;

        var selectedDate = new Date(selectedDateMS_num);
        selectedDate.setHours(0);
        selectedDate.setMinutes(0);
        selectedDate.setSeconds(0);
        selectedDate.setMilliseconds(0);

        var now = new Date();
        now.setHours(0);
        now.setMinutes(0);
        now.setSeconds(0);
        now.setMilliseconds(0);

        var msSelectedDate = selectedDate.valueOf();
        var msNow = now.valueOf();
        if(msSelectedDate > msNow)
        {
            alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.DateHasToBePriorOrEqualToCurrentDate") %>"); //XSSOK
            return false;
        }
        return true;
    }
    
    function validateEmail() {
		var emailId = arguments[0];
		var regexp = (/^[A-Za-z0-9]([A-Za-z0-9_-]|(\.[A-Za-z0-9]))+@[A-Za-z0-9](([A-Za-z0-9]|(-[A-Za-z0-9]))+)\.([A-Za-z]{2,6})(\.([A-Za-z]{2}))?$/);
		var isValid = regexp.test(trim(emailId));	
		if (emailId.length != 0 && !isValid) {
			alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.InvalidEmailId") %>"); //XSSOK
			return false;
		}
		return true;
	}
	
	//This function is used to check Contact and Regulatory Reviewer First/Last Name
	function checkForNames()
	{
		var regEx = new RegExp(/[^a-zA-Z' -]/);
		var val = arguments[0];
		//trim the string
		val = val.replace(/^\s+|\s+$/g, '');
		if(regEx.test(val))
		{
			alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.NameFieldCharacterAllowed")%>"); //XSSOK
			this.focus();
			return false;
		}
		return true;
	}
	
	// This function is used to check if the field value contains letters
	function checkForNoLetters()
	{
		var regEx = new RegExp(/[a-zA-Z]/);
		var val = arguments[0];
		//trim the string
		val = val.replace(/^\s+|\s+$/g, '');
		if(regEx.test(val))
		{
			alert(val + ", <%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.NoLettersAllowed") %>"); //XSSOK
			//this.value="";
			this.focus();
			return false;
		}
		return true;
	}	

	// This function is used to check for only numbers 
	function checkForNumbers()
	{
		// \D matches any non-digit (short for [^0-9]).
		var regEx = new RegExp(/\D/);
		var val = arguments[0];
		//trim the string
		val = val.replace(/^\s+|\s+$/g, '');
		if(regEx.test(val))
		{
			alert(val + ", <%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.OnlyNumbersAllowed") %>"); //XSSOK
			//this.value="";
			this.focus();
			return false;
		}
		return true;
	}

	//This function is used to check for only letters
	function checkForLetters()
	{
		var regEx = new RegExp(/[^a-zA-Z]/);
		var val = arguments[0];
		//trim the string
		val = val.replace(/^\s+|\s+$/g, '');
		if(regEx.test(val))
		{
			alert(val + ", <%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.OnlyLettersAllowed") %>"); //XSSOK
			this.focus();
			return false;
		}
		return true;
	}	

	//This function is used to check Contact Zip field
	function checkForZipCode()
	{
		var regEx = new RegExp(/[^0-9-]/);
		var val = arguments[0];
		//trim the string
		val = val.replace(/^\s+|\s+$/g, '');
		if(regEx.test(val))
		{
			alert(val + ", <%=getI18NString(context, Helper.StringResource.LRA, "Regulatory.Message.ZipFieldCharacterAllowed") %>"); //XSSOK
			this.focus();
			return false;
		}
		return true;
	}
	
	/**
     * On change handler function to reload Languages field
     */
	function getLanguagesForCountry(){
		emxEditableTable.reloadCell("Languages");
		emxEditableTable.reloadCell("Language");
		return true;
	}
	
		//This function is used to check for only letters with spaces
	function checkForLettersWithSpaces()
	{
		var regEx = new RegExp(/[^a-zA-Z ]/);
		var val = arguments[0];
		//trim the string
		val = val.replace(/^\s+|\s+$/g, '');
		if(regEx.test(val))
		{
			alert(val + ", <%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.OnlyLettersAllowed") %>"); //XSSOK
			this.focus();
			return false;
		}
		return true;
	}	

function validateTime()
  {
  	var form = arguments[0];

    // regular expression to match required time format
    re = /^(\d{1,2}):(\d{2})\s?$/;

    if(form != '') {
      if(regs = form.match(re)) {
        if(regs[3]) {
          // 12-hour value between 1 and 12
          if(regs[1] < 1 || regs[1] > 12) {
            alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.InvalidValueForHours") %>"); //XSSOK
            return false;
          }
        } else {
          // 24-hour value between 0 and 23
          if(regs[1] > 23) {
            alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.InvalidValueForHours") %>"); //XSSOK
            return false;
          }
        }
        // minute value between 0 and 59
        if(regs[2] > 59) {
          alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.InvalidValueForMinutes") %>"); //XSSOK
          return false;
        }
      } else {
        alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.InvalidTimeFormat") %>"); //XSSOK
        return false;
      }
    }
    return true;
  }
  
  function correspondenceNameChangeWarning() 
  {
  	var form = arguments[0];
  	 if(form != '') {
  		alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.CorrespondenceNameAlert")%>"); //XSSOK
		return false;
	}
	return true;
  }
  
  function checkPhoneNumber()
	{
		var regExForNumber = /^[0-9+()]*$/;
		var newValue = arguments[0];
		var STR_NAME_BAD_CHARS = "@ , * ? [ ] # $ { } \\ \" < > | % ; :";
		var ARR_NAME_BAD_CHARS = STR_NAME_BAD_CHARS.split(" ");   
		var strBadChars = validateForBadChars(newValue,ARR_NAME_BAD_CHARS);	
		if (strBadChars.length > 0) 
        {
        	alert("<%=RESTRICTED_BAD_CHARS%>" + " " + STR_NAME_BAD_CHARS);
        	return false;
        }                        
		
		if(newValue.length > 0) {
			if(!regExForNumber.test(newValue))
			{
				alert(newValue + ", <%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.OnlyNumbersAllowed")%>"); //XSSOK
				return false;
			}
		
			if(newValue.length < 10 || newValue.length > 20)
			{
				alert(newValue + ", <%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.MobileNumberLength")%>"); //XSSOK
				return false;
			}
		}

		return true;
	}
	
	function checkPersonName()
	{
		//Handelling for A-Z,a-z,hyphen,apostrophe and Japanese characters.
		var regEx = new RegExp(/[^\u0041-\u005A\u0061-\u007A\u0027\u002D\u3000-\u303F\u3040-\u309F\u30A0-\u30FF\uFF00-\uFFEF\u4E00-\u9FAF\u2605-\u2606\u2190-\u2195\u203B]/);
		var newValue = arguments[0];
		
		var STR_NAME_BAD_CHARS = "@ , * ? [ ] # $ { } \\ \" < > | % ; :";
		var ARR_NAME_BAD_CHARS = STR_NAME_BAD_CHARS.split(" ");   
		
		var strBadChars = validateForBadChars(newValue,ARR_NAME_BAD_CHARS);	
		
		if (strBadChars.length > 0) 
        {
        	alert("<%=RESTRICTED_BAD_CHARS%>" + " " + STR_NAME_BAD_CHARS);
        	return false;
        }                        
		
		if(regEx.test(newValue))
		{
			alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.NameFieldCharacterAllowed") %>"); //XSSOK
			return false;
		}
		
		return true;
	}
	
	function reloadContactValues() {
		emxEditableTable.reloadCell("Correspondence Contact");
		}

function onContactTypeChange()
{
	var currentCell = emxEditableTable.getCurrentCell();
	var rowId = currentCell.rowID;
	var contactType = emxEditableTable.getCellValueByRowId(rowId,"Contact Type");
	var contactTypeValue = contactType.value.current.actual;
	var contactTypeOldValue = contactType.value.old.actual;
	emxEditableTable.reloadCell("Outsourcing Facility");
	var DISPLAY_VALUE_NO = "<%=getI18NString(context, Helper.StringResource.AEF, "emxFramework.Range.Outsourcing_Facility.No") %>"; //XSSOK
	var DISPLAY_VALUE_NOT_APPLICABLE = "<%=getI18NString(context, Helper.StringResource.AEF, "emxFramework.Range.Outsourcing_Facility.Not_Applicable") %>"; //XSSOK
	if(contactTypeValue == "Manufacturer")
	{
		emxEditableTable.setCellValueByRowId(rowId, "Outsourcing Facility", "No", DISPLAY_VALUE_NO, true);
	}
	else if(contactTypeValue != "Manufacturer")
	{
		emxEditableTable.setCellValueByRowId(rowId, "Outsourcing Facility", "Not Applicable", DISPLAY_VALUE_NOT_APPLICABLE, true);
	}
}

function onFocusOfOutsourcingFacility(){
	emxEditableTable.reloadCell("Outsourcing Facility");
}

