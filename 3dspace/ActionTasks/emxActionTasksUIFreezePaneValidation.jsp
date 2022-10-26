<%@include file="../common/emxNavigatorNoDocTypeInclude.inc"%>
<%@page import="com.dassault_systemes.enovia.actiontasks.Helper"%>
function validatePastDate()
{
	var userEnteredDate = arguments[0];
	if (userEnteredDate != null && userEnteredDate != "") {
		var formFieldDateMS_num = userEnteredDate - 43200000;
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
