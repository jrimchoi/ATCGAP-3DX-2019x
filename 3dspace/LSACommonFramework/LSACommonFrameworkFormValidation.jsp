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

<%@page import="matrix.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.matrixone.apps.domain.util.*, com.matrixone.apps.domain.util.XSSUtil"%>
<%@page import="com.dassault_systemes.enovia.lsa.Helper, com.dassault_systemes.enovia.lsa.LSAException"%>
<%@include file="../common/emxNavigatorInclude.inc"%>

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
// emxCreate.jsp validation does not work if you use the script tags

out.clear();
response.setContentType("text/javascript; charset=" + response.getCharacterEncoding());
String accLanguage  = request.getHeader("Accept-Language");
String BAD_CHAR_ERROR_MSG = EnoviaResourceBundle.getFrameworkStringResourceProperty(context, "emxFramework.FormComponent.RestrictedBadChars", new Locale(request.getHeader("Accept-Language")));

String referer = request.getHeader("Referer");

if (referer.indexOf("emxCreate.jsp") < 0) {
%>
<script language="javascript">
<%
}
%>

function validateActionItemDueDate()
{
	var objCount = document.getElementsByName("objCount")[0].value;
	var current = new Date();
	var currentMSValue = current.getTime();
	for(var i=0; i<objCount; i++)
	{
		var currentRow = document.getElementsByName("Due Date"+i+"_msvalue")[0];
		//user selects a past date
		if(currentRow.value.length > 0 && currentRow.value < currentMSValue)
		{
			alert("<%=getI18NString(context, Helper.StringResource.LSA, "emxFramework.ActionTask.ErrorMsg.NoPastDate")%>"); //XSSOK
			return false;
		}
		//compare with previous task
		if(i>0)
		{
			var currentTaskSequence = document.getElementsByName("Task Sequence"+i)[0];
			//counter : track the task which is to be compared with
			var counter = i-1;
			while(counter>=0)
			{
				var taskSequenceToCompare = document.getElementsByName("Task Sequence"+counter)[0];
				//current task sequence is greater than previous task, 
				//in this case, make sure later task date is greater than previous task date
				if(currentTaskSequence.value > taskSequenceToCompare.value)
				{
					var compareRow = document.getElementsByName("Due Date"+counter+"_msvalue")[0];
					if(currentRow.value.length > 0 && currentRow.value < compareRow.value)
					{
						alert("<%=getI18NString(context, Helper.StringResource.LSA, "emxFramework.ActionTask.ErrorMsg.NotInOrder")%>"); //XSSOK
						return false;
					}
				}
				counter--;
			}
		}
	}
	
	return true;
}

function validateStatus()
{
	//password field is programHTMLOutput hence explicitly validated for empty field during form submit
	if(document.getElementById("calc_Password"))
	{
		var vPassword = document.getElementsByName("Password")[0].value;
		if(vPassword.length < 1)
		{
			alert("<%=getI18NString(context, Helper.StringResource.AEF, "emxFramework.FormComponent.MustEnterAValidValueFor") + " " + getI18NString(context, Helper.StringResource.AEF, "emxFramework.Login.Password")%>"); //XSSOK
			document.getElementsByName("Password")[0].focus();
			return false;
		}
	}
	
	var vStatus = "FALSE";
	if(document.getElementById("statusid"))
	{
		vStatus = document.getElementById("statusid").value;	
	}
	else
	{
		return true;
	}

	if("FALSE"==vStatus)
	{
		alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Error.UserCredentials.Invalid")%>"); //XSSOK
		return false;
	}
	return true;
}

function validateUserCredentials()
{
	var vUserName = "";
	var vPassword = "";
	if(document.getElementById("calc_UserName"))
	{
		vUserName = document.getElementById("UserName").value;
	}
	if(document.getElementById("calc_Password"))
	{
		vPassword = document.getElementsByName("Password")[0].value;
	}
	
	var url = "../common/iwCSAjaxController.jsp" + "?" + "listProgramName=" + "com.dassault_systemes.enovia.lsa.services.ui.CredentialsValidation:validateUserCredentials";
	url += "&" + "UserName"+"="+vUserName +"&"+ "Password"+"="+vPassword;
	
	if (window.XMLHttpRequest) {
        request = new XMLHttpRequest();
    }
    else if (window.ActiveXObject) {
        request = new ActiveXObject("Microsoft.XMLHTTP");
    }
	request.open("GET", url, true);
	request.send(null);
	request.onreadystatechange = function ()
	{
		if (request.readyState == 4) {
			if (request.status == 200) {
				var resText = request.responseText.split("ajaxResponse");
	            var jsObject = eval("(" + resText[1] + ")");
	            var result = jsObject.result;
	            var formObj = document.forms[0];
	            if(document.getElementById("statusid"))
	            {
	            	formObj.removeChild(document.getElementById("statusid"));
	            }
	            var inputElement = document.createElement("input");
            	inputElement.setAttribute("type", "hidden");
	    		inputElement.setAttribute("name", "status");
	    		inputElement.setAttribute("id", "statusid");
	    		inputElement.setAttribute("value", result[0].value);
	    		formObj.appendChild(inputElement);
			}
		}
	};
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
        	alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.InvalidValueForHours")%>"); //XSSOK
          return false;
        }
      } else {
        // 24-hour value between 0 and 23
        if(regs[1] > 23) {
        	alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.InvalidValueForHours")%>"); //XSSOK
          return false;
        }
      }
      // minute value between 0 and 59
      if(regs[2] > 59) {
    	  alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.InvalidValueForMinutes")%>"); //XSSOK
        return false;
      }
    } else {
    	alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.InvalidTimeFormat")%>"); //XSSOK
      return false;
    }
  }
  return true;
}


function checkFirstName() {
	return checkPersonName("FirstName");
		
}

function checkMiddleName() {
	return checkPersonName("MiddleName");
}

function checkLastName() {
	return checkPersonName("LastName");
}

function checkPersonName(fieldName) {
		var fieldNameJSONVal = emxFormGetValue(fieldName);
		var fieldValue = fieldNameJSONVal.current.actual;
		//Handelling for A-Z,a-z,hyphen,apostrophe and Japanese characters.
		// IR-436553-3DEXPERIENCER2015x added \u0020-\u00A0 for white spaces
		var regEx = new RegExp(/[^\u0041-\u005A\u0061-\u007A\u0027\u002D\u3000-\u303F\u0020-\u00A0\u3040-\u309F\u30A0-\u30FF\uFF00-\uFFEF\u4E00-\u9FAF\u2605-\u2606\u2190-\u2195\u203B]/);
		var STR_NAME_BAD_CHARS = "@ , * ? [ ] # $ { } \\ \" < > | % ; :";
		var ARR_NAME_BAD_CHARS = STR_NAME_BAD_CHARS.split(" ");   
		
		var strBadChars = validateForBadChars(fieldValue,ARR_NAME_BAD_CHARS);	
		
		if (strBadChars.length > 0) 
        {
        	alert("<%=BAD_CHAR_ERROR_MSG%>" + " " + STR_NAME_BAD_CHARS);
        	emxFormSetValue(fieldName, fieldNameJSONVal.old.actual, fieldNameJSONVal.old.display);
        	return false;
        }                        
		
		if(regEx.test(fieldValue))
		{
			alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.NameFieldCharacterAllowed")%>"); //XSSOK
			emxFormSetValue(fieldName, fieldNameJSONVal.old.actual, fieldNameJSONVal.old.display);
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
	function validateBusinessAgencyName() {
		var businessAgencyName = "BusinessorAgency";
		var businessAgencyJSONVal = emxFormGetValue(businessAgencyName);
		var newValue = businessAgencyJSONVal.current.actual;
		
	    var STR_NAME_BAD_CHARS = "@ , * ? [ ] # $ { } \\ \" < > | % ; :";
		var ARR_NAME_BAD_CHARS = "";
		if (STR_NAME_BAD_CHARS != "") 
		{    
		  ARR_NAME_BAD_CHARS = STR_NAME_BAD_CHARS.split(" ");   
		}
		var strBadChars = validateForBadChars(newValue,ARR_NAME_BAD_CHARS);		
        if (strBadChars.length > 0) 
        {
        	alert("<%=BAD_CHAR_ERROR_MSG%>" + " " + STR_NAME_BAD_CHARS);
        	emxFormSetValue(businessAgencyName, businessAgencyJSONVal.old.actual, businessAgencyJSONVal.old.display);
        	return false;
        }                        
		return true;	   
	}
		function checkForNames() {
		var regEx = new RegExp(/[^a-zA-Z'-]/);
		var val = arguments[0];
		if(regEx.test(val))
		{
			alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.NameFieldCharacterAllowed")%>"); //XSSOK
			return false;
		}
		return true;
	}
	function validateEmail() {
		var emailAddress = "EmailAddress";
		var emailAddressJSONVal = emxFormGetValue(emailAddress);
		var emailId = emailAddressJSONVal.current.actual;
		
		var regexp = (/^[A-Za-z0-9]([A-Za-z0-9_-]|(\.[A-Za-z0-9]))+@[A-Za-z0-9](([A-Za-z0-9]|(-[A-Za-z0-9]))+)\.([A-Za-z]{2,6})(\.([A-Za-z]{2}))?$/);
		var isValid = regexp.test(trim(emailId));	
		if (emailId.length != 0 && !isValid) {
			alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.InvalidEmailId")%>"); //XSSOK
			emxFormSetValue(emailAddress, emailAddressJSONVal.old.actual, emailAddressJSONVal.old.display);
			return false;
		}
		return true;
	}
	
	
	function checkCellPhoneNumber() {
		return checkNumber("Mobile");	
	}

	function checkHomePhoneNumber() {
		return checkNumber("Home");
	}

	function checkWorkPhoneNumber() {
		return checkNumber("Work");
	}

	function checkFaxNumber() {
		return checkNumber("Fax");
	}
	
	function checkNumber(feild) {
		var regExForNumber = new RegExp(/^\d$/);
		var numberJSONVal = emxFormGetValue(feild);
		var newValue = numberJSONVal.current.actual;
		var STR_NAME_BAD_CHARS = "@ , * ? [ ] # $ { } \\ \" < > | % ; :";
		var ARR_NAME_BAD_CHARS = STR_NAME_BAD_CHARS.split(" ");   
		var strBadChars = validateForBadChars(newValue,ARR_NAME_BAD_CHARS);
		
		if (strBadChars.length > 0) 
        {
        	alert("<%=BAD_CHAR_ERROR_MSG%>" + " " + STR_NAME_BAD_CHARS);
        	emxFormSetValue(feild, numberJSONVal.old.actual, numberJSONVal.old.display);
        	return false;
        }                        
		
		if(newValue!="Unknown" && newValue.length > 0) {
			if(regExForNumber.test(newValue)) {
				alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.OnlyNumbersAllowed")%>"); //XSSOK
				emxFormSetValue(feild, numberJSONVal.old.actual, numberJSONVal.old.display);
				return false;
			}
		
			if(newValue.length < 10 || newValue.length > 20){
				alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.MobileNumberLength")%>"); //XSSOK
				emxFormSetValue(feild, numberJSONVal.old.actual, numberJSONVal.old.display);
			  	return false;
			}
		}
		return true;
	}
function onChangeContactType()
{
		var ContactTypeValue = emxFormGetValue("ContactType").current.actual;
		var OutsourcingFacility = document.getElementById("OutsourcingFacilityId");
		var options = OutsourcingFacility.options;
		if(ContactTypeValue != "Manufacturer" && OutsourcingFacility.options.length>1)
		{
			OutsourcingFacility.length=0;
			var notApplicable = "<%= getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Contact.Attribute.OutsourcingFacility.Range.NotApplicable")%>";
			OutsourcingFacility[0]=new Option(notApplicable,notApplicable);
			
		}else if (ContactTypeValue == "Manufacturer" && OutsourcingFacility.options.length==1){
			OutsourcingFacility.length=0;
			var no = "<%= getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Contact.Attribute.OutsourcingFacility.Range.No")%>";
			var yes = "<%= getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Contact.Attribute.OutsourcingFacility.Range.Yes")%>";
			OutsourcingFacility[0]=new Option(no,no);
			OutsourcingFacility[1]=new Option(yes,yes);
		}
		return true;
}
function validateCorrespondenceTime()
{
	var form = document.getElementById("Correspondence Time").value;
	re = /^(\d{1,2}):(\d{2})\s?$/;
	
	  if(form != '') {
	    if(regs = form.match(re)) {
	      if(regs[3]) {
	        // 12-hour value between 1 and 12
	        if(regs[1] < 1 || regs[1] > 12) {
	        	alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.InvalidValueForHours")%>"); //XSSOK
	          return false;
	        }
	      } else {
	        // 24-hour value between 0 and 23
	        if(regs[1] > 23) {
	        	alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.InvalidValueForHours")%>"); //XSSOK
	          return false;
	        }
	      }
	      // minute value between 0 and 59
	      if(regs[2] > 59) {
	    	  alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.InvalidValueForMinutes")%>"); //XSSOK
	        return false;
	      }
	    } else {
	    	alert("<%=getI18NString(context, Helper.StringResource.LSA, "LSACommonFramework.Message.InvalidTimeFormat")%>"); //XSSOK
	      return false;
	    }
	  }
	  return true;
}

<%
// emxCreate.jsp validation does not work if you use the script tags
if (referer.indexOf("emxCreate.jsp") < 0) {
%>
</script>
<%
}
%>



