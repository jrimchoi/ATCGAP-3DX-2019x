<%@include file = "../emxContentTypeInclude.inc"%>
<%@include file="../common/scripts/emxJSValidationUtil.js"%>
<%@include file="../common/emxNavigatorNoDocTypeInclude.inc"%>
<%@page import="com.dassault_systemes.enovia.actiontasks.Helper"%>
function disableFieldAssigneeChoice() 
{
	
	var btnAssignee = document.getElementsByName("btnAssignee")[0];
	var objectId = document.getElementsByName("objectId")[0].value;
	var vAssigneeChoice  = document.getElementsByName("AssigneeChoice");
	for (var i = 0; i < vAssigneeChoice.length; i++) {       
            	if (vAssigneeChoice[i].value.toLowerCase() == "complaint member") {
            		vAssigneeChoice[i].checked = true;
					callAjaxForPhysicalId(objectId);
          		 break;
            }
           
    }
}

function callAjaxForPhysicalId(objectId){
var url = "../ActionTasks/iwCSAjaxController.jsp" + "?" + "listProgramName=" + "com.dassault_systemes.enovia.actiontasks.ui.ActionTasks:preProcessSetPhysicalid&objectId="+objectId;
	if (window.XMLHttpRequest) {
        request = new XMLHttpRequest();
    }
    else if (window.ActiveXObject) {
        request = new ActiveXObject("Microsoft.XMLHTTP");
    }
	request.open("GET", url, true);
	request.onreadystatechange = function () { setPhysicalId(request); }
	request.send(null);
}

function setPhysicalId(request)
{
	if (request.readyState == 4) {
        if (request.status == 200) {
            // handle the response js object
            var resText = request.responseText.split("ajaxResponse");
            var jsObject = eval("(" + resText[1] + ")");
            var result = jsObject.result;
            var vPhysicalId = result[0].value;
            var btnAssignee  =document.getElementsByName("btnAssignee")[0];
            btnAssignee.onclick = function () {
            			javascript:showFullSearchChooserInForm('../common/emxFullSearch.jsp?field=TYPES=type_Person:CURRENT=policy_Person.state_Active:PQC_COMPLAINT_RELATED_ASSIGNEE='+vPhysicalId+'&table=AEFPersonChooserDetails&selection=multiple&submitURL=../common/AEFSearchUtil.jsp&fieldNameActual=Assignee&fieldNameDisplay=AssigneeDisplay&fieldNameOID=AssigneeOID&suiteKey=&showInitialResults=true','Assignee');
          		  		return false; 
          		};
		}
        request = null;
    }
}

function setFieldAssigneeChoice() 
{
	var btnAssignee = document.getElementsByName("btnAssignee")[0];
	var objectId = document.getElementsByName("objectId")[0].value;
	var vAssigneeChoice  = document.getElementsByName("AssigneeChoice");;
	for (var i = 0; i < vAssigneeChoice.length; i++) {       
        if (vAssigneeChoice[i].checked) {
            	if (vAssigneeChoice[i].value.toLowerCase() == "complaint member") {
            		callAjaxForPhysicalId(objectId);
            }else{
            	btnAssignee.onclick = function () {
            		javascript:showFullSearchChooserInForm('../common/emxFullSearch.jsp?field=TYPES=type_Person:CURRENT=policy_Person.state_Active&table=AEFPersonChooserDetails&selection=multiple&submitURL=../common/AEFSearchUtil.jsp&fieldNameActual=Assignee&fieldNameDisplay=AssigneeDisplay&fieldNameOID=AssigneeOID&suiteKey=&showInitialResults=true','Assignee');
          		  	return false; 
          		};
            }
            break;
        }
    }
	var vAssigneeDisplay = document.getElementsByName("AssigneeDisplay")[0];
	var vAssignee  = document.getElementsByName("Assignee")[0];
	var vAssigneeOID = document.getElementsByName("AssigneeOID")[0];
	vAssigneeDisplay.value="";
	vAssignee.value="";
	vAssigneeOID.value="";
}

function validatePastDate()
{
    if (this.value != null && this.value != "") {
     var formFieldDateMS = document.getElementsByName(this.name + "_msvalue")[0].value;
        var formFieldDateMS_num = formFieldDateMS - 43200000;
        var formDate = new Date(formFieldDateMS_num);
        formDate.setHours(0);
        formDate.setMinutes(0);
        formDate.setSeconds(0);
        formDate.setMilliseconds(0);

        var now = new Date();
        now.setHours(0);
        now.setMinutes(0);
        now.setSeconds(0);
        now.setMilliseconds(0);

        var msForm = formDate.valueOf();
        var msNow = now.valueOf();
        if(msForm < msNow)
        {
            alert("<%=Helper.getI18NString(context, "ActionTasks.Common.DateCannotBeInPast")%>");
            return false;
        }
    }

    return true;
}

  function isBadNameChars() 
  {
     var isBadNameChar=checkForNameBadCharsList(this);
     if( isBadNameChar.length > 0 )
     {
      	alert(BAD_NAME_CHARS + isBadNameChar);
     	return false;
     }
     return true;
  }

