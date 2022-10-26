
<%@include file="../common/emxNavigatorInclude.inc"%>
<%@page import="matrix.util.*,com.matrixone.apps.framework.ui.*"%>
<%@page import="java.text.*"%>
<%@page import="com.matrixone.apps.domain.util.*"%>
<%@page import="com.dassault_systemes.enovia.contacts.Helper"%>
<%@include file="../common/emxFormConstantsInclude.inc"%>
<%!
public static final String BUNDLE = "enoContactsStringResource";
%>
<%
out.clear();
response.setContentType("text/javascript; charset=" + response.getCharacterEncoding());
String accLanguage  = request.getHeader("Accept-Language");
String BAD_CHAR_ERROR_MSG = EnoviaResourceBundle.getFrameworkStringResourceProperty(context, "emxFramework.FormComponent.RestrictedBadChars", new Locale(request.getHeader("Accept-Language")));
%>
<script language="javascript">

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
			alert("<%=EnoviaResourceBundle.getProperty(context, "enoContactsStringResource", context.getLocale(), "enoContacts.Message.NameFieldCharacterAllowed") %>");
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
			alert("<%=EnoviaResourceBundle.getProperty(context, "enoContactsStringResource", context.getLocale(), "enoContacts.Message.NameFieldCharacterAllowed") %>");
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
			alert("<%=EnoviaResourceBundle.getProperty(context, "enoContactsStringResource", context.getLocale(), "enoContacts.Message.InvalidEmailId") %>");
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
	
		function onChangeContactType()
	{
		var ContactTypeValue = emxFormGetValue("ContactType").current.actual;
		var OutsourcingFacility = document.getElementById("OutsourcingFacilityId");
		if(OutsourcingFacility != null && OutsourcingFacility != "undefined"){
			var options = OutsourcingFacility.options;
	
			if(ContactTypeValue != "Manufacturer"){
				OutsourcingFacility.length=0;
				var notApplicable = "<%= EnoviaResourceBundle.getProperty(context, "LSACommonFrameworkStringResource", context.getLocale(), "LSACommonFramework.Contact.Attribute.OutsourcingFacility.Range.NotApplicable")%>";
				OutsourcingFacility[0]=new Option(notApplicable,'Not Applicable');
			}
			else 
			{
				OutsourcingFacility.length=0;
				var no = "<%= EnoviaResourceBundle.getProperty(context, "LSACommonFrameworkStringResource", context.getLocale(), "LSACommonFramework.Contact.Attribute.OutsourcingFacility.Range.No")%>";
				var yes = "<%= EnoviaResourceBundle.getProperty(context, "LSACommonFrameworkStringResource", context.getLocale(), "LSACommonFramework.Contact.Attribute.OutsourcingFacility.Range.Yes")%>";
				OutsourcingFacility[0]=new Option(no,'No');
				OutsourcingFacility[1]=new Option(yes,'Yes');
			}
		}
	}
	
	
	function checkNumber(feild) {
		var regExForNumber = /^[0-9+()]*$/;
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
		
		if(newValue.length > 0) {
			if(!regExForNumber.test(newValue)) {
				alert(newValue + ", <%=EnoviaResourceBundle.getProperty(context, "enoContactsStringResource", context.getLocale(), "enoContacts.Message.OnlyNumbersAllowed") %>");
				emxFormSetValue(feild, numberJSONVal.old.actual, numberJSONVal.old.display);
				return false;
			}
		
			if(newValue.length < 10 || newValue.length > 20){
				alert(newValue + ", <%=EnoviaResourceBundle.getProperty(context, "enoContactsStringResource", context.getLocale(), "enoContacts.Message.MobileNumberLength") %>");
				emxFormSetValue(feild, numberJSONVal.old.actual, numberJSONVal.old.display);
			  	return false;
			}
		}
		return true;
	}
</script>
