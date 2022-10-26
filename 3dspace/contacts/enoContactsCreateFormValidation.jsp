
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
%>	
function checkPersonName()
	{
		//Handelling for A-Z,a-z,hyphen,apostrophe and Japanese characters.
		// IR-436553-3DEXPERIENCER2015x added \u0020-\u00A0 for white spaces
		var regEx = new RegExp(/[^\u0041-\u005A\u0061-\u007A\u0027\u002D\u3000-\u303F\u0020-\u00A0\u3040-\u309F\u30A0-\u30FF\uFF00-\uFFEF\u4E00-\u9FAF\u2605-\u2606\u2190-\u2195\u203B]/);
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
			alert("<%=EnoviaResourceBundle.getProperty(context, "enoContactsStringResource", context.getLocale(), "enoContacts.Message.NameFieldCharacterAllowed") %>");
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
		function checkForNames()
	{
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
		var emailId = arguments[0];
		var regexp = (/^[A-Za-z0-9]([A-Za-z0-9_-]|(\.[A-Za-z0-9]))+@[A-Za-z0-9](([A-Za-z0-9]|(-[A-Za-z0-9]))+)\.([A-Za-z]{2,6})(\.([A-Za-z]{2}))?$/);
		var isValid = regexp.test(trim(emailId));	
		if (emailId.length != 0 && !isValid) {
			alert("<%=EnoviaResourceBundle.getProperty(context, "enoContactsStringResource", context.getLocale(), "enoContacts.Message.InvalidEmailId") %>");
			return false;
		}
		return true;
	}
	 function checkPhoneNumber()
	{
		var regExForNumber = new RegExp(/^\d$/);
		
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
			if(regExForNumber.test(newValue)) {
				alert(newValue + ", <%=EnoviaResourceBundle.getProperty(context, "enoContactsStringResource", context.getLocale(), "enoContacts.Message.OnlyNumbersAllowed") %>");
				return false;
			}
		
			if(newValue.length < 10 || newValue.length > 20){
				alert(newValue + ", <%=EnoviaResourceBundle.getProperty(context, "enoContactsStringResource", context.getLocale(), "enoContacts.Message.MobileNumberLength") %>");
			  	return false;
			}
		}
		
		return true;
	}
	
	
	function reloadContactValues() {
		emxEditableTable.reloadCell("Correspondence Contact");
		}
	function checkForLettersWithSpaces()
	{
		var regEx = new RegExp(/[^a-zA-Z ]/);
		var val = arguments[0];
		//trim the string
		val = val.replace(/^\s+|\s+$/g, '');
		if(regEx.test(val))
		{
			alert(val + ", <%=EnoviaResourceBundle.getProperty(context, "enoContactsStringResource", context.getLocale(), "enoContacts.Message.OnlyLettersAllowed") %>");
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
			alert(val + ", <%=EnoviaResourceBundle.getProperty(context, "enoContactsStringResource", context.getLocale(), "enoContacts.Message.ZipFieldCharacterAllowed") %>");
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
		if(regEx.test(val))
		{
			alert(val + ", <%=EnoviaResourceBundle.getProperty(context, "enoContactsStringResource", context.getLocale(), "enoContacts.Message.OnlyLettersAllowed") %>");
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
			alert(val + ", <%=EnoviaResourceBundle.getProperty(context, "enoContactsStringResource", context.getLocale(), "enoContacts.Message.NoLettersAllowed") %>");
			//this.value="";
			this.focus();
			return false;
		}
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
			alert(val + ", <%=EnoviaResourceBundle.getProperty(context, "enoContactsStringResource", context.getLocale(), "enoContacts.Message.OnlyLettersAllowed") %>");
			this.focus();
			return false;
		}
		return true;
	}	
	
	
