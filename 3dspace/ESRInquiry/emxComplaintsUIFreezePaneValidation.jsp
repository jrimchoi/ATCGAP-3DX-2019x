<jsp:include page="../common/scripts/emxUIFormHandler.js" />
<%@include file="../common/emxNavigatorNoDocTypeInclude.inc"%>
<%@page import="com.dassault_systemes.enovia.lsa.Helper"%>
function validateRMANumberForReturnTable()
{
	var tableColRMANumber = arguments[0];
	var currentCell = emxEditableTable.getCurrentCell();
	var rowId = currentCell.rowID;
	var productReturned = emxEditableTable.getCellValueByRowId(rowId,"ProductReturned");
	var productReturnedActual = productReturned.value.current.actual;
	if (productReturnedActual.toLowerCase() == "yes") {
	    if (tableColRMANumber == null || tableColRMANumber == "") {
	        alert("<%=Helper.getI18NString(context,Helper.StringResource.COLS,"PQC.ReturnFulfillment.RMANumer.ErrorMessage")%>");
	        return false;
	   	}
    }else if (productReturnedActual.toLowerCase() == "no") {
	        alert("<%=Helper.getI18NString(context,Helper.StringResource.COLS,"PQC.ReturnFulfillment.RMANumerIfProductReturnedIsNo.ErrorMessage")%>");
	        return false;
    }
	return true;
}

function validateReceivedDate()
{
	var tableColRMANumber = arguments[0];
	var currentCell = emxEditableTable.getCurrentCell();
	var rowId = currentCell.rowID;
	var productReturned = emxEditableTable.getCellValueByRowId(rowId,"ProductReturned");
	var productReturnedActual = productReturned.value.current.actual;
	if (productReturnedActual.toLowerCase() == "no") {
	 alert("<%=Helper.getI18NString(context,Helper.StringResource.COLS,"PQC.ReturnFulfillment.ReceivedDateIfProductReturnedIsNo.ErrorMessage")%>");
	        return false;
	}
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
        if(msForm > msNow)
        {
            alert("<%=Helper.getI18NString(context,Helper.StringResource.COLS,"FTComplaints.Common.DateCannotBeGreaterThanToday")%>");
            return false;
        }
    }
	return true;
}

function validateFutureDate()
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
        if(msForm > msNow)
        {
            alert("<%=Helper.getI18NString(context,Helper.StringResource.COLS,"FTComplaints.Common.DateCannotBeGreaterThanToday")%>");
            return false;
        }
    }
    return true;
}
function validateAmountForFulfillmentTable()
{
	var tableColAmountNumber = arguments[0];
	var currentCell = emxEditableTable.getCurrentCell();
	var rowId = currentCell.rowID;
	var type = emxEditableTable.getCellValueByRowId(rowId,"Type");
	var typeActual = type.value.current.actual;
	var message = "<%=Helper.getI18NString(context,Helper.StringResource.COLS,"PQC.ReturnFulfillment.Amount.ErrorMessage")%>";
	if (typeActual.toLowerCase() == "cheque" || typeActual.toLowerCase() == "coupon") {
	    if (tableColAmountNumber.indexOf("0.0") == 0 || tableColAmountNumber=="") {
	        return message;
	   	}
    }
	return "";
}
function onChangeTableFulfillmentSummaryFieldFulfillmentType()
{
	var fulfillmentType = arguments[0];
	var message = "<%=Helper.getI18NString(context,Helper.StringResource.COLS,"PQC.ReturnFulfillment.Amount.ErrorMessage")%>";
	if (fulfillmentType.toLowerCase() == "cheque" || fulfillmentType.toLowerCase() == "coupon") {
		var currentCell = emxEditableTable.getCurrentCell();
		var rowId = currentCell.rowID;
		var amount = emxEditableTable.getCellValueByRowId(rowId,"Amount");
		var amountActual = amount.value.current.actual;
	    if (amountActual.indexOf("0.0") == 0 || amountActual=="") {
	        return message;
	   	}
	}
	return "";
}
