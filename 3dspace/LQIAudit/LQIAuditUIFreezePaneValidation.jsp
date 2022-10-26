<jsp:include page="../common/scripts/emxUIFormHandler.js" />
<jsp:include page="../common/scripts/emxUIFreezePane.js" />
<%@include file="../common/emxNavigatorNoDocTypeInclude.inc"%>


function isBadChars()
	{
	    var fieldValue = arguments[0];
		<%
			/*XSS OK*/ String emxNameBadChars = EnoviaResourceBundle.getProperty(context, "emxFramework.Javascript.NameBadChars");
			emxNameBadChars = emxNameBadChars.trim();
		%>
	    var STR_NAME_BAD_CHARS = "<%= emxNameBadChars %>";
		var ARR_NAME_BAD_CHARS = "";
		if (STR_NAME_BAD_CHARS != "") 
		{    
		  ARR_NAME_BAD_CHARS = STR_NAME_BAD_CHARS.split(" ");   
		}
		var strBadChars  = "";
	    for (var i=0; i < ARR_NAME_BAD_CHARS.length; i++) 
        {
            if (fieldValue.indexOf(ARR_NAME_BAD_CHARS[i]) > -1) 
            {
            	strBadChars += ARR_NAME_BAD_CHARS[i] + " ";
            }
        }		
        if (strBadChars.length > 0) 
        {
        	alert("<framework:i18nScript localize="i18nId">LQIAudit.Common.InvalidCharacters</framework:i18nScript>" + " " + STR_NAME_BAD_CHARS);
        	return false;
        }                        
		return true;
	}


