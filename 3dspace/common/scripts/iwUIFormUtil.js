/*
 * iwUIFormUtil.js
 *
 * Copyright (c) 2007 Integware, Inc.  All Rights Reserved.
 * This program contains proprietary and trade secret information of
 * Integware, Inc.
 * Copyright notice is precautionary only and does not evidence any
 * actual or intended publication of such program.
 *
 * $Rev: 658 $
 * $Date: 2011-02-27 16:46:51 -0700 (Sun, 27 Feb 2011) $
 */

//=================================================================
// JavaScript FormUtil
//
// Copyright (c) 1992-2002 MatrixOne, Inc.
// All Rights Reserved.
// This program contains proprietary and trade secret information of MatrixOne,Inc.
// Copyright notice is precautionary only
// and does not evidence any actual or intended publication of such program
//=================================================================
// FormUtil
//-----------------------------------------------------------------
// Works in Netscape 4.x and IE 5.0+
//=================================================================
//get date to start with
todayDate = new Date();
thismonth = todayDate.getMonth() + 1;
thisday = todayDate.getDate();
thisyear = todayDate.getYear();

// initialize the fieldObjs array
var fieldObjs = new Array(0);

// incorrect year is obtained in netscape (add 1900 if below 500)
if (thisyear < 500) {
	thisyear = thisyear + 1900;
}

function changeDate(m, d, y, formName, dateField) {
	// DATE FORMAT MM/DD/YYYY
	formattedDate = m + "/" + d + "/" + y;

	// Get the Form and Field objects and assing the date value.
	var formObject = document.forms[0];
	var fieldObject = formObject.elements[dateField];
	var fieldDisplayObject = formObject.elements[dateField + "Display"];
	fieldObject.value = formattedDate;
	fieldDisplayObject.value = formattedDate;


}

function openWindow(strURL) {
	window.open(strURL);
}

function emxFormLinkClick(url, target, modality, winWidth, winHeight) {
	if (winWidth == null || winWidth == "")
		winWidth = "600";
	if (winHeight == null || winHeight == "")
		winHeight = "500";

	var isModal = false;

	if (modality != null && modality != "" && modality == "true")
		isModal = true;

	if (target && target == 'popup') {
		if (isModal)
			showModalDialog(url, winWidth, winHeight, true);
		else
			showNonModalDialog(url, winWidth, winHeight, true);

	} else {
		var targetFrame = getTopWindow().findFrame(getTopWindow(), target);

		if (targetFrame) {
			targetFrame.location.href = url;
		} else {
			if (isModal)
				showModalDialog(url, winWidth, winHeight, true);
			else
				showNonModalDialog(url, winWidth, winHeight, true);
		}
	}
}




// Method to keep the focus on the first editable element
function doLoad() {
	if (document.forms[0].elements.length > 0) {
		var objElement = document.forms[0].elements[0];

		if (objElement.focus) {
			if (objElement.type == "text" || objElement.type == "textarea"
					|| objElement.type == "select-one")
				objElement.focus();

		}
		// if (objElement.select)
		// objElement.select();
	}
}

function assignValidateMethod(fieldName, methodName) {
	var bValid = true;

	if (isIE) {
		eval("try \
            { \
                var test ="
				+ methodName
				+ ".toString(); \
                handleMethodAssign(true, fieldName, methodName); \
            } catch(e) { \
                handleMethodAssign(false, fieldName, methodName); \
            }");
	} else {
		window.onerror = function() {
			handleMethodAssign(false, fieldName, methodName);
			window.onerror = null;
			return false;
		};
		handleMethodAssign(true, fieldName, methodName);
	}
}


function handleMethodAssign(bValid, fieldName, methodName) {
	if (bValid)
		eval("document.forms[0]['" + fieldName + "'].customValidate="
				+ methodName);
	else
		alert(VALIDATION_METHOD_UNDEFINED + methodName);
}


function validateForBadCharacters(fieldName) {
	eval("document.forms[0]['" + fieldName + "'].badcharValidate="
			+ "isBadChars");
}

function validateForBadNameCharacters(fieldName) {
	eval("document.forms[0]['" + fieldName + "'].badnamecharValidate="
			+ "isBadNameChars");
}

function validateForRestrictedBadCharacters(fieldName) {
	eval("document.forms[0]['" + fieldName + "'].badrestrictedValidate="
			+ "isBadRestrictedChars");
}



function validateNumericField(fieldName) {
	eval("document.forms[0]['" + fieldName + "'].numericValidate="
			+ "isNumeric");
}

function validateIntegerField(fieldName) {
	eval("document.forms[0]['" + fieldName + "'].integerValidate="
			+ "isValidInteger");
}

function validateRequiredField(fieldName) {
	eval("document.forms[0]['" + fieldName + "'].requiredValidate="
			+ "isZeroLength");
}

function validateDateField(fieldName) {
	eval("document.forms[0]['" + fieldName + "'].dateValidate=" + "isValidDate");
}

function basicClear(fieldName) {
	var formElement = eval("document.forms[0]['" + fieldName + "']");

	if (formElement) {
		if (formElement.length > 1) {
			for ( var i = 0; i < formElement.length - 1; i++) {
				formElement[i].value = "";
			}
		} else {
			formElement.value = "";
		}
	}

	formElement = eval("document.forms[0]['" + fieldName + "Display']");

	if (formElement) {
		if (formElement.length > 1) {
			for ( var i = 0; i < formElement.length - 1; i++) {
				formElement[i].value = "";
			}
		} else {
			formElement.value = "";
		}
	}

	formElement = eval("document.forms[0]['" + fieldName + "OID']");

	if (formElement) {
		if (formElement.length > 1) {
			for ( var i = 0; i < formElement.length - 1; i++) {
				formElement[i].value = "";
			}
		} else {
			formElement.value = "";
		}
	}


}



function isBadChars() {
	var isBadChar = checkForBadChars(this);
	if (isBadChar.length > 0) {
		alert(BAD_CHARS + isBadChar);
		return false;
	}
	return true;
}

function isBadNameChars() {
	var isBadNameChar = checkForNameBadCharsList(this);
	if (isBadNameChar.length > 0) {
		alert(BAD_NAME_CHARS + isBadNameChar);
		return false;
	}
	return true;
}

function isBadRestrictedChars() {
	var isBadResChar = checkForRestrictedBadChars(this);
	if (isBadResChar.length > 0) {
		alert(RESTRICTED_BAD_CHARS + isBadResChar);
		return false;
	}
	return true;
}


// following javascript if there are any integer or real fields
function isNumeric() {
	var varValue = this.value;
	if (isNaN(varValue)) {
		alert(MUST_ENTER_VALID_NUMERIC_VALUE + this.fieldLabel);
		this.focus();
		return false;
	} else {
		return true;
	}
}

function isValidInteger() {
	var index;
	var iValue = this.value;
	for (index = 0; index < iValue.length; index++) {
		var digit = iValue.charAt(index);
		if (((digit < "0") || (digit > "9"))) {
			alert(MUST_ENTER_VALID_INTERGER_VALUE + this.fieldLabel);
			return false;
		}
	}
	return true;
}

// Handles both whitespaces around the text entered and 'Enter Key'(CRLF)
function trimString(strString) {
	strString = strString.replace(/^\s*/g, "");
	return strString.replace(/\s+$/g, "");
}
// following javascript if there are any valid entry in fields
function isZeroLength() {
	var sField = this.fieldLabel;
	var sFieldValue = "";
	if (sField == null || sField == "null") {
		sField = this.name;
	}

	if (this.type == "select-one") {
		sFieldValue = this.options[this.selectedIndex].value;
	} else {
		this.value = trimString(this.value);
		sFieldValue = this.value;
	}

	if (sFieldValue.length > 0) {
		return true;
	} else {
		alert(MUST_ENTER_VALID_VALUE + " " + sField);
		if (this.focus) {
			if (this.type == "text" || this.type == "textarea"
					|| this.type == "select-one")
				this.focus();
		}
		return false;
	}
}

// Method to remove the objectId param fromURL
function removeObjectIDParam(strURL) {
	if (strURL) {
		var arrURLParts = strURL.split("?");
		var strQueryString = arrURLParts[1];
		strQueryString = strQueryString.replace(new RegExp(
				"(objectId=\[\\d\\.]*\\&?)"), "");
		// strQueryString = strQueryString.replace(new
		// RegExp("(relId=\[\\d\\.]*\\&?)"), "");
		if (strQueryString.lastIndexOf("&") == strQueryString.length - 1) {
			strQueryString = strQueryString.substring(0,
					strQueryString.length - 1);
		}
		arrURLParts[1] = strQueryString;
		return arrURLParts.join("?");
	} else {
		return "";
	}

}

function isValidDate() {
	// var thisDate=new Date(this.value);
	// if (thisDate.valueOf() > 0)
	// {
	// return true;
	// }else {
	// return false;
	// }
}

// add a field object to the array to be validated later
function saveFieldObj(fieldobj) {
	fieldObjs[fieldObjs.length] = fieldobj;
}

function saveFieldObjByName(fieldName) {
	saveFieldObj(document.getElementById(fieldName));
}

// validate the field
function validateField(fieldObject) {

	if (fieldObject) {
		// Validate using validateForBadCharacters methods if defined
		if (fieldObject.badcharValidate) {
			if (!(fieldObject.badcharValidate())) {
				return false;
			}
		}

		// Validate using validateForBadNameCharacters methods if defined
		if (fieldObject.badnamecharValidate) {
			if (!(fieldObject.badnamecharValidate())) {
				return false;
			}
		}

		// Validate using custom validation methods if defined
		if (fieldObject.customValidate) {
			if (!(fieldObject.customValidate())) {
				return false;
			}
		}

		// Validate using validateForRestrictedBadCharacters methods if defined
		if (fieldObject.badrestrictedValidate) {
			if (!(fieldObject.badrestrictedValidate())) {
				return false;
			}
		}

		// Validate numeric fields
		if (fieldObject.numericValidate) {
			if (!(fieldObject.numericValidate())) {
				return false;
			}
		}

		// Validate Integer fields
		if (fieldObject.integerValidate) {
			if (!(fieldObject.integerValidate())) {
				return false;
			}
		}

		// Validate required fields
		if (fieldObject.requiredValidate) {
			if (!(fieldObject.requiredValidate())) {
				return false;
			}
		}

		// Validate date fields
		if (fieldObject.dateValidate) {
			if (!(fieldObject.dateValidate())) {
				return false;
			}
		}
	}

	return true;
}

function validateForm(fromEditableTable) {
	// The "editDatForm" will be inside the frame "searchPane", if
	// "emxFormEditDisplay.jsp" is used in the context of "emxCommonSearch.jsp".
	// The "editDatForm" will be inside the frame "formEditDisplay", if
	// "emxFormEditDisplay.jsp" is used in the context of "emxForm.jsp".
	var targetDoc = null;
	/*
	 * if (parent.formEditDisplay) { targetDoc =
	 * parent.formEditDisplay.document; } else if (parent.searchPane) {
	 * targetDoc = parent.searchPane.document; } else { return true; }
	 */

	if (parent.document.location.href.indexOf("emxform.jsp" >= 0)) {
		targetDoc = document;
	} else if (document.location.href.indexOf("emxform.jsp" >= 0)) {
		targetDoc = document;
	} else if (parent.searchPane) {
		targetDoc = parent.searchPane.document;
	} else if (parent.searchContent) {
		targetDoc = parent.searchContent.document;
	} else {
		return true;
	}

	// Only validate on modified fields on the Editable Table
	if (fromEditableTable) {
		for (n = 0; n < fieldObjs.length; n++) {
			if (fieldObjs[n] == null || fieldObjs[n] == "undefined"
					|| fieldObjs[n] == "null" || fieldObjs[n] == "") {
				break;
			} else {
				if (!validateField(fieldObjs[n])) {
					return false;
				}
				;
			}
		}
	} else {
		for (i = 0; i < targetDoc.forms[0].elements.length; i++) {
			if (!validateField(targetDoc.forms[0].elements[i])) {
				return false;
			}
			;
		}
	}

	return true;

}

var canSubmit = true;
function setFormSubmitAction(submitaction)
{
	canSubmit = submitaction;
}


function doCancel()
{

	// parent.formEditDisplay.document.editDataForm.target = "formEditHidden";
    var timeStamp = parent.formEditDisplay.document.editDataForm.timeStamp.value;
	// var url = "emxFormEditCancelProcess.jsp?timeStamp=" + timeStamp;
	// parent.formEditDisplay.document.editDataForm.action = url;
	// parent.formEditDisplay.document.editDataForm.submit();
	// purgeEditFormData(timeStamp);
	getTopWindow().close()
}


// Function to cleanup form
function cleanUpFormData2(timeStamp)
{
	if (isNS4)
		window.stop();

	document.location.href = 'emxFormCleanupData.jsp?timeStamp=' + timeStamp;
}



// Printer Friendly window variable.
var printDialog = null;

    function openPrinterFriendlyPage()
    {
	var strURL = "";
	currentURL = parent.frames[1].document.location.href;
	if (currentURL.indexOf("?") == -1)
		strURL = currentURL + "?PFmode=true";
	else
		strURL = currentURL + "&PFmode=true";

	// make sure that there isn't a window already open
	if (!printDialog || printDialog.closed) {

		var strFeatures = "scrollbars=yes,toolbar=yes,location=no,resizable=yes";
		printDialog = window.open(strURL, "PF" + (new Date()).getTime(),
				strFeatures);

		// set focus to the dialog
		printDialog.focus();

	} else {
          //if there is already a window open, just bring it to the forefront (NCZ, 6/4/01)
      if (printDialog) printDialog.focus();
	}

}

function openRenderPDFPage() {
	var strURL = "";
	currentURL = parent.frames[1].document.location.href;
	if (currentURL.indexOf("?") == -1)
		strURL = "emxRenderPDFDisplay.jsp";
	else
		strURL = "emxRenderPDFDisplay.jsp"
				+ currentURL.substring(currentURL.indexOf("?"));

	var intWidth = "500";
	var intHeight = "500";

	showNonModalDialog(strURL, intWidth, intHeight, true);

}

function openTipPageWindow(strURL) {
	window.open(strURL);
}


var canTableFormSubmit = true;
function setTableFormSubmitAction(submitaction) {
	canTableFormSubmit = submitaction;
}

function tableEditsaveChanges() {
	if (canTableFormSubmit) {
		setTableFormSubmitAction(false);
		if (validateForm(true)) {
			var target = "formEditHidden";
                var theForm = parent.formEditDisplay.document.forms["editDataForm"];
			theForm.target = target;
			parent.document.forms["massUpdateForm"].clearEditObjList.value = "false";
			theForm.action = "emxTableEditProcess.jsp";
			theForm.submit();
		} else {
			setTableFormSubmitAction(true);
		}
	} else {
		return;
	}
}


  function openFormExportPage(pageHeader)
    {

	var url = "emxFormExport.jsp";
     parent.formViewDisplay.document.frmFormView.target= "formViewHidden";
     parent.formViewDisplay.document.frmFormView.action = url;
	// parent.formViewDisplay.document.frmFormView.parseHeader.value=pageHeader;
     parent.formViewDisplay.document.frmFormView.submit();
}

    function exportData(timeStamp)
    {
	openFormExportPage("");
}

function exportToExcelHTML(tStamp, objectId, relId, form, pageHeader) {
	var strURL = "emxFormViewDisplay.jsp?timeStamp" + tStamp + "&relId="
			+ relId + "&objectId=" + objectId + "&form=" + form
			+ "&parsedHeader=" + escape(pageHeader) + "&reportFormat=ExcelHTML";
	var strFeatures = "location=no,menubar=yes,titlebar=yes,width=700,height=500,resizable=yes,scrollbars=auto";
	window.open(strURL, "ExportForm", strFeatures);
}


function shiftFocus(strForm, objInput) {

	var objForm = document.forms[strForm];

	for ( var i = 0; i < objForm.elements.length; i++) {
		if (objInput == objForm.elements[i]) {
			if (objForm.elements[i + 1]) {
				objForm.elements[i + 1].focus();
				return;
			} // End: if (objForm.elements[i+1])
		} // End: if (objInput == objForm.elements[i])
	} // End: for (var i=0; i < objForm.elements.length; i++)

} // End: function shiftFocus(strForm, objInput)

