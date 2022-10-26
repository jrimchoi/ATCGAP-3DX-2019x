var isGroup = false;

function showApply() {
    document.getElementById('submitLink').innerText = "Apply";
    document.getElementById('submitLink').href = "javascript:submitForm();";
    document.getElementById('submitImageLink').href = "javascript:submitForm();";
}

function writeToHiddenField(entireCascadeData) {
    document.getElementById('json').value = "";
    document.getElementById('json').value = JSON.stringify(entireCascadeData);
}

function generateToLevel(topDivName) {
    if ($("#" + topDivName).length > 0) {
        $("#" + topDivName).append("<div id='" + topDivName + "'  ></div>");
    }

    for (var i = 0; i < CascadeData.selectionLists.length; i++) {
        var SelectionListObject = CascadeData.selectionLists[i];
        var appendTo = $("#" + topDivName);
        generateTopControls(SelectionListObject, appendTo, "");

    }
    var filesToCheckin = "";
    var tmpArr = "";
    var fileCount = 0;
    if (uploadResponse != null && uploadResponse != "") {
        tmpArr = uploadResponse.split("@@");
        if (tmpArr.length > 0) {
            filesToCheckinArr = tmpArr[1];

            if (filesToCheckinArr != null && filesToCheckinArr != "") {
                var removeExtraAtTheEnd = filesToCheckinArr.split("</div>");
                if (removeExtraAtTheEnd != null && removeExtraAtTheEnd != "") {
                    filesToCheckin = removeExtraAtTheEnd[0];
                    if (filesToCheckin != null && filesToCheckin != "") {
                        var filesArr = filesToCheckin.split("$");
                        if (filesArr.length > 0) {
                            $("#droppedFileTable").append("<tr><td>Dropped Files:</td></tr><tr><td></td></tr>");
                            for (var x = 0; x < filesArr.length; x++) {
                                if (filesArr[x] != "") {
                                    var fileArr = filesArr[x].split("|");
                                    if (fileArr.length > 0) {
                                        var fileName = fileArr[0];
                                        $("#droppedFileTable").append("<tr><td>" + fileName + "</td></tr>");
                                    }
                                }

                            }
                        }

                    }
                }


            }
            CascadeData.filesToCheckin = filesToCheckin;
        }
    }
}

function generateTopControls(selectionListObject, appendTo, parentId) {
    var controltype;
    var listId;
    var alignment;
    var width;
    var height;
    var $newdiv;
    var divProperties;
    var divAlign;
    var description;
    var showHeader;
    var styleProp;
    var display;
    var casObj;
    var object;
    var defaultValue;

    object = selectionListObject;
    controltype = object.controlType;
    listId = object.listID;

    alignment = object.controlAlignmentDirection;
    description = object.description;
    showHeader = object.showHeader;
    width = object.controlWidth;
    height = object.controlHeight;

    if (object.defaultValue !== undefined) {
        defaultValue = object.defaultValue;
    }

    $newdiv = $("<div id='" + listId + "'  ></div>");

    if (parentId !== "") {
        if (alignment === "Horizontal") {
            $newdiv.css("display", "table-cell");
            $newdiv.css("padding", "3px 0px 5px");
        }
    }

    //DON't create new divs if it is a group control
    if (isGroup === true) {
        $newdiv = appendTo;
        listId = parentId;
    } else {
        appendTo.append($newdiv);
        //appendTo.append("<br/>");
        appendTo.append("<p style='margin-top: 7px;margin-bottom: 3px;></p>");
    }


    switch (controltype) {
        case "FreeTextBox":
            generateInputBox(listId, object, defaultValue, $newdiv, showHeader, description, height, width);
            break;
        case "ComboBox":
            generateCombo(listId, object, $newdiv, showHeader, description, width);
            break;
        case "RadioButtonList":
            generateRadioList(listId, object, $newdiv, showHeader, description);

            break;
        case "Group":
            generateGroup(listId, object, $newdiv, showHeader, description);
            break;
        case "ReadonlyTextBox":
            generateReadonlyTextBox(listId, object, $newdiv, showHeader, description, height, width);
            break;
        case "List":
            generateList(listId, object, $newdiv, showHeader, description, height, width);
            break;
        case "DatePicker":
            generateDatePicker(listId, object, $newdiv, showHeader, description, height, width);
            break;
    }

}

function generateDatePicker(ControlId, SelectionListObject, appendTo, showHeader, description, height, width) {
    var options;
    var $select;
    var $option;
    var anOption;
    var calculatedValue;
    var selectedValue;
    var name;
    var listSettings;
    var displayDateFormat;
    var jqueryDisplayDateFormat;
	
    name = "list" + ControlId;
    listSettings = SelectionListObject.listSettings;

    if (listSettings !== undefined) {
        displayDateFormat = listSettings.drlDisplayDateFormat;
        if (displayDateFormat !== undefined) {
            jqueryDisplayDateFormat = displayDateFormat.replace("yyyy", "yy")
        }
    }


    // check to display label
    if (showHeader === true) {
        //appendTo.append("<span style='font-weight: bold;font-size: 8pt;margin-top: 20px;margin-bottom: 10px;'>"+ description +"</span><br/>");
        appendTo.append("<p style='margin-top: 7px;margin-bottom: 3px;font-weight: bold;font-size: 8pt'>" + description + "</p>");
    }


    var $datePicker = $("<input id='" + name + "'></input>");
    $datePicker = $('<input>').attr({
        type: 'text',
        name: '' + name + '',
        id: '' + name + '',
        readonly: 'true'
    });
    appendTo.append($datePicker);

    $(function() {
        $datePicker.datepicker({
            showOn: "button",
            buttonImage: "../drV6Tools/cascade/images/calendar.gif",
            buttonImageOnly: true,
            dateFormat: jqueryDisplayDateFormat,
            buttonText: "Please select date",
            onSelect: function() {
                if ($('#' + name).val() === "") {
                    return false;
                } else {
                    var selectedValue;

                    selectedValue = ControlId + "|" + $('#' + name).val() + ":" + $('#' + name).val();
                    UpdateList(selectedValue);
                }
            }

        });
    });
}

function generateControls(selectionListObject, appendTo, parentId) {
    var controltype;
    var listId;
    var alignment;
    var width;
    var height;
    var $newdiv;
    var divProperties;
    var divAlign;
    var description;
    var showHeader;
    var styleProp;
    var display;
    var casObj;
    var object;

    for (var i = 0; i < selectionListObject.dependantSelectionLists.length; i++) {
        dependentListObject = selectionListObject.dependantSelectionLists[i];
        // generate dependent control
        //generateControls(dependentListObject,$newdiv1,parentId);  
        object = dependentListObject;
        controltype = object.controlType;
        listId = object.listID;


        alignment = object.controlAlignmentDirection;
        description = object.description;
        showHeader = object.showHeader;
        width = object.controlWidth;
        height = object.controlHeight;

        $newdiv = $("<div id='" + listId + "'  ></div>");

        if (parentId !== "") {
            if (alignment === "Horizontal") {
                $newdiv.css("display", "table-cell");
                $newdiv.css("padding", "3px 0px 5px");
            }
        }

        //DON't create new divs if it is a group control
        if (isGroup === true) {
            $newdiv = appendTo;
            listId = parentId;
        } else {
            appendTo.append($newdiv);
            //appendTo.append("<br/>"); // if gap between control is less then uncomment this break
        }


        switch (controltype) {
            case "FreeTextBox":
                var descDefaultValue;
                if (selectionListObject.calculatedValues !== undefined) {
                    if (selectionListObject.calculatedValues.description !== undefined) {
                        descDefaultValue = selectionListObject.calculatedValues.description;
                    }

                }

                generateInputBox(listId, object, descDefaultValue, $newdiv, showHeader, description, height, width);
                break;
            case "ComboBox":
                generateCombo(listId, object, $newdiv, showHeader, description, width);
                break;
            case "RadioButtonList":
                generateRadioList(listId, object, $newdiv, showHeader, description);
                break;
            case "Group":
                generateGroup(listId, object, $newdiv, showHeader, description);
                break;
            case "ReadonlyTextBox":
                generateReadonlyTextBox(listId, object, $newdiv, showHeader, description, height, width);
                break;
            case "DatePicker":
                generateDatePicker(listId, object, $newdiv, showHeader, description, height, width);
                break;
            case "List":
                generateList(listId, object, $newdiv, showHeader, description, height, width);
                break;

        }

    }
}

function generateList(ControlId, SelectionListObject, appendTo, showHeader, description, height, width) {
    var options;
    var $select;
    var $option;
    var anOption;
    var calculatedValue;
    var selectedValue;
    var name;

    options = SelectionListObject.options;
    name = "list" + ControlId;

    if (height === 0 || height === "0") {
        height = "5";
    }

    if (width === 0 || width === "0") {
        width = "300";
    }

    // check to display label
    if (showHeader === true) {
        //appendTo.append("<br/><span style='font-weight: bold;font-size: 8pt;margin-top: 20px;margin-bottom: 10px;'>"+ description +"</span><br/>");
        appendTo.append("<p style='margin-top: 7px;margin-bottom: 3px;font-weight: bold;font-size: 8pt'>" + description + "</p>");
    }

    $select = $("<select id='" + name + "' style='width:" + width + "' size= '" + height + "'></select>");
    appendTo.append($select);

    if (options !== undefined) {

        for (var j = 0; j < options.length; j++) {
            $select.append("<option></option>");
            $option = $select.find("option:last");
            anOption = options[j];
            calculatedValue = SelectionListObject.listID + "|" + anOption.displayValue + ":" + anOption.internalValue;

            $option.text(anOption.displayValue);
            $option.attr("value", calculatedValue);
        }
        //	if(j === options.length-1 ){
        //	  $option.attr("selected", "selected");	
        //	}	
        // Now add the change event
        $select.change(function() {
            selectedValue = $(this).val();
            getSelectedValue(selectedValue, ControlId);
        });

    } else {
        $select.append("<option></option>");
        $option = $select.find("option:last");
        $option.text("No records found");
        $option.attr("value", "");
    }

}

function generateReadonlyTextBox(ControlId, SelectionListObject, appendTo, showHeader, description, height, width) {
    var name;
    var $textArea;
    var rows;
    var cols;

    if (height === 0 || height === "0") {
        rows = "1";
    } else {
        rows = height;
    }


    if (width === 0 || width === "0") {
        cols = "55";
    } else {
        cols = width;
    }


    name = "txt" + ControlId;
    appendTo.append("<p style='margin-top: 20px;margin-bottom: 10px;'><span style='font-weight: bold;font-size: 8pt'>" + description + "</span></p><br/>");
    $textArea = $('<textarea>').attr({
        rows: '' + rows + '',
        cols: '' + cols + '',
        name: '' + name + '',
        disabled: 'disabled',
        id: '' + name + ''
    });
    appendTo.append($textArea);
}

function generateGroup(parentId, SelectionListObject, appendTo, showHeader, description) {
    /*var name;
 var $groupDiv;
 var groupListId; 

  
groupListId = SelectionListObject.listID;
 name = "group" + groupListId;*/

    // check to display label
    isGroup = true; //used by group controls for not creating new div
    if (showHeader === true) {
        // appendTo.append("<span style='font-weight: bold;font-size: 8pt;margin-top: 20px;margin-bottom: 10px;'>"+ description +"</span><br/>");
        appendTo.append("<p style='margin-top: 7px;margin-bottom: 3px;font-weight: bold;font-size: 8pt'>" + description + "</p>");
    }
    generateDependentControls(SelectionListObject, parentId);
    isGroup = false;
}

function generateCombo(ControlId, SelectionListObject, appendTo, showHeader, description, width) {
    var options;
    var $select;
    var $option;
    var anOption;
    var calculatedValue;
    var selectedValue;
    var name;

    options = SelectionListObject.options;
    name = "combo" + ControlId;

    if (width === 0 || width === "0") {
        width = "300";
    }

    // check to display label
    if (showHeader === true) {
        //appendTo.append("<span style='font-weight: bold;font-size: 8pt;margin-top: 20px;margin-bottom: 10px;'>"+ description +"</span><br/>");
        appendTo.append("<p style='margin-top: 7px;margin-bottom: 3px;font-weight: bold;font-size: 8pt'>" + description + "</p>");
    }

    width = width + "px";
    $select = $("<select id='" + name + "' style='width:" + width + "'></select>");
    appendTo.append($select);

    if (options !== undefined) {


        for (var j = 0; j < options.length; j++) {
            $select.append("<option></option>");
            $option = $select.find("option:last");
            anOption = options[j];
            calculatedValue = SelectionListObject.listID + "|" + anOption.displayValue + ":" + anOption.internalValue;

            $option.text(anOption.displayValue);
            $option.attr("value", calculatedValue);

        }
        $select.append("<option selected></option>");

        // Now add the change event
        $select.change(function() {
            selectedValue = $(this).val();

            getSelectedValue(selectedValue, ControlId);
        });
    }
}

function getSelectedValue(selectedValue, controlId) {
    var dependentDivId;

    dependentDivId = "#" + "dependent" + controlId;
    if ($(dependentDivId).length > 0) {
        $(dependentDivId).remove();
    }
    //submit the data and get updated list   
    UpdateList(selectedValue);

}

function generateRadioList(ControlId, SelectionListObject, appendTo, showHeader, description) {

    var radioList;
    var name;
    var aRadio;
    var radioDesc;
    var calculatedValue;
    var $radio;
    var selectedValue;


    radioList = SelectionListObject.options;
    name = "radio" + ControlId;

    if (showHeader === true) {
        appendTo.append("<p style='margin-top: 10px;margin-bottom: 3px;font-weight: bold;font-size: 8pt'>" + description + "</p>");
    }
    if (radioList !== undefined) {
        for (var j = 0; j < radioList.length; j++) {

            aRadio = radioList[j];
            radioDesc = radioList[j].displayValue;
            calculatedValue = ControlId + "|" + aRadio.displayValue + ":" + aRadio.internalValue;
            $radio = $('<input>').attr({
                type: 'radio',
                name: '' + name + ''
            });
            $radio.attr("value", calculatedValue);
            appendTo.append($radio);
            appendTo.append("<span>" + radioDesc + "</span>");
            appendTo.append("<br/>");
            // Now add the change event
            //Need call in loop otherwise event doesn't apply to all radios
            $radio.click(function() {
                selectedValue = $(this).val();

                getRadioSelectedValue(selectedValue, ControlId);
            });

        }

    }
}


function getRadioSelectedValue(selectedValue, parentId) {
    var dependentDivId;

    dependentDivId = "#" + "dependent" + parentId;

    if ($(dependentDivId).length > 0) {
        $(dependentDivId).remove();
    }

    //submit the data and get updated list
    UpdateList(selectedValue);
}

function generateInputBox(ControlId, SelectionListObject, defaultValue, appendTo, showHeader, description, height, width) {
    var name;
    var $textInput;
    var rows;
    var cols;


    if (height === 0 || height === "0") {

        rows = "1";
    } else {

        rows = height;
    }

    if (width === 0 || width === "0") {
        cols = "55";
    } else {
        cols = width;

    }

    name = "txt" + ControlId;

    //appendTo.append("<span style='font-weight: bold;margin-top: 20px;margin-bottom: 10px;'>"+ description +"</span><br/>");   
    appendTo.append("<p style='margin-top: 7px;margin-bottom: 3px;font-weight: bold;font-size: 8pt'>" + description + "</p>");

    if (rows === "1" || rows === 1) {
        $textInput = $('<input>').attr({
            type: 'text',
            name: '' + name + '',
            id: '' + name + ''
        });
    } else {

        $textInput = $('<textarea>').attr({
            rows: '' + rows + '',
            cols: '' + cols + '',
            name: '' + name + '',
            id: '' + name + ''
        });
    }


    $textInput.val(defaultValue);

    appendTo.append($textInput);


    $textInput.focus(function() {

        document.getElementById('submitLink').innerText = "Recalculate";
        document.getElementById('submitLink').href = "javascript:showApply();";
        document.getElementById('submitImageLink').href = "javascript:showApply();";

    });



    $textInput.blur(function() {


        var selectedValue;
        var res = restrictColonCharacter($('#' + name).val());
        if (res) {
            selectedValue = ControlId + "|" + $('#' + name).val() + ":" + $('#' + name).val();

            UpdateList(selectedValue);

        }




    });


}

function restrictColonCharacter(enteredtxt) {
    if (enteredtxt !== "") {
        if (enteredtxt.indexOf(':') > -1) {
            alert("Error: Restricted character colon(:) found.Please remove it .");
            return false;
        } else {
            return true;
        }
    }
}

function UpdateList(selectedValue) {
    renderUpdateList(selectedValue, CascadeData.selectionLists);
}

function renderUpdateList(selectedValue, CascadeSelectionLists) {
    var list;

    if (CascadeSelectionLists !== undefined) {
        for (var i = 0; i < CascadeSelectionLists.length; i++) {
            list = CascadeSelectionLists[i];
            if (performCheckIdInUpdateList(selectedValue, CascadeSelectionLists, list, i) === true) {
                break;
            }
        }
    }
}

function performCheckIdInUpdateList(selectedValue, CascadeSelectionLists, list, listCurrentIndx) {
    var listID;
    var displayValue = "";
    var internalValue = "";
    var jsonCascadeBeanString;
    var selValue;

    if (selectedValue !== "") {
        selValue = selectedValue;
        var tmpArr = selValue.split(":");

        if (tmpArr.length > 0) {
            var tmpDisplayValue = tmpArr[0];
            internalValue = tmpArr[1];

            if (tmpDisplayValue !== "") {
                var tmpDisplayNameArr = tmpDisplayValue.split("|");

                if (tmpDisplayNameArr.length > 0) {
                    listID = tmpDisplayNameArr[0];
                    displayValue = tmpDisplayNameArr[1];

                }
            }
        }

    }

    if (CascadeData !== "") {
        jsonCascadeBeanString = JSON.stringify(CascadeData);
    }

    if (listID == list.listID) {
        processing = true; // for delaying submit if submit and blur called together
        $.blockUI({
            message: null
        });
        drCascadeAjaxUtils.updateList(listID, displayValue, internalValue, jsonCascadeBeanString, function(ret, success) {
            if (success) {
                processing = false; // for delaying submit if submit and blur called together
                try {
                    showApply();
                    var updatedCascadeData = ret.replace(/\\/g, "\\")
                    updatedCascadeObject = JSON.parse(updatedCascadeData);

                    if (updatedCascadeObject.errorOccured == true) {
                        alert("Error occured: " + updatedCascadeObject.errorMessage);
                        throw new Error("Error occured: " + updatedCascadeObject.errorMessage);
                    }
                    //check if selectionComplete is set to true
                    checkSelectionComplete(updatedCascadeObject);
                    //set properties on whole cascase bean
                    setPropertiesGlobalCascadeObject(updatedCascadeObject);
                    //remove old data of listid   
                    CascadeSelectionLists.splice(listCurrentIndx, 1);
                    CascadeSelectionLists.splice(listCurrentIndx, 0, updatedCascadeObject.updateList);
                    writeToHiddenField(CascadeData);
                    if (list.hasOwnProperty('drivesDependantLists')) {
                        if (list.drivesDependantLists === true) {
                            //if the list drives dependant lists, remove and refresh the dependant controls
                            removeDependentControls(listID);
                            generateDependentControls(updatedCascadeObject.updateList, listID);
                        }
                    }

                    return true;
                } catch (Ex) {
                    $.unblockUI();
                    return [Ex, false];
                }
            }
        });

        $.unblockUI(); // unblock ui after ajax call
    } else {
        // id not found.hence calling render
        if (renderUpdateList(selectedValue, list.dependantSelectionLists) === true)
            return true;
    }

}

function checkSelectionComplete(object) {
    if (object.selectionComplete === true) {
        CascadeData.selectionComplete = object.selectionComplete;
    }
}

function setPropertiesGlobalCascadeObject(object) {
    CascadeData.selectionComplete = object.selectionComplete;
    CascadeData.fullCalculatedValues = object.fullCalculatedDisplayValues;
    CascadeData.fullCalculatedDisplayValues = object.fullCalculatedDisplayValues;
    CascadeData.finalSelectionOK = object.finalSelectionOK;
    CascadeData.listCounter = object.listCounter;
}

function updatePropertiesForNoDependent(selectedValue, object) {
    var displayValue = "";
    var internalValue = "";
    var tmpArr;
    var tmpDisplayValue;
    var tmpDisplayNameArr;

    object.selectionChanged = true;

    // calculating selectedOption
    if (selectedValue !== "") {

        tmpArr = selectedValue.split(":");
        if (tmpArr.length > 0) {
            tmpDisplayValue = tmpArr[0];
            internalValue = tmpArr[1];

            if (tmpDisplayValue !== "") {
                tmpDisplayNameArr = tmpDisplayValue.split("|");

                if (tmpDisplayNameArr.length > 0) {

                    displayValue = tmpDisplayNameArr[1];

                }
            }
        }
    }

    if (object.hasOwnProperty('selectedOption')) {
        object.selectedOption.displayValue = displayValue;
        object.selectedOption.internalValue = internalValue;
    } else {
        object.selectedOption = {};
        object.selectedOption = {
            "displayValue": "" + displayValue + "",
            "internalValue": "" + internalValue + ""
        };
    }
    setPropertiesGlobalCascadeObject(object);
}

function generateDependentControls(selectionListObject, parentId) {
    var depenedentDivContainerId;
    var $newdiv1;
    var dependentListObject;


    if (isGroup) {
        depenedentDivContainerId = "dependentGroup" + parentId;
    } else {
        depenedentDivContainerId = "dependent" + parentId;
    }
    $newdiv1 = $("<div id='" + depenedentDivContainerId + "'></div>");
    if (selectionListObject.dependantSelectionLists.length > 0) {

        $("#" + parentId).append($newdiv1);
    }
    // added new
    generateControls(selectionListObject, $newdiv1, parentId);

}

function removeDependentControls(dependentId) {
    if ($('#' + "dependent" + dependentId).length > 0) {
        $('#' + "dependent" + dependentId).remove();
    }
}

function disableElements(el) {
    for (var i = 0; i < el.length; i++) {
        el[i].disabled = true;
        disableElements(el[i].children);
    }
}

function enableElements(el) {
    for (var i = 0; i < el.length; i++) {
        el[i].disabled = false;
        enableElements(el[i].children);
    }
}

function manageGUI() {
    var showsidePanelText = true;
    if ($("#tdHeaderInfo").length > 0) {
        $("#tdHeaderInfo").append("<h2 id='ph'>" + CascadeData.header + "</h2>");
        $("#tdHeaderInfo").append("<h3 id='sph'>" + CascadeData.subHeader + "</h3>");
    }
    if ($("#tdHeaderInfo").length > 0) {
        document.getElementById("sidepanel").innerHTML = CascadeData.sidePanelText;
    }

    showsidePanelText = CascadeData.showSidePanelText;
    if (showsidePanelText == "FALSE") {
        document.getElementById("sidepanel").style.display = 'none';
    }
}

function validateForm() {
    var errorSummary = "";
    var controltype;

    for (var i = 0; i < CascadeData.selectionLists.length; i++) {
        var selectionListObject = CascadeData.selectionLists[i];
        errorSummary = validateSelectionObject(selectionListObject, errorSummary);
    }
    return errorSummary;
}

function getValidationExpression(selectionListObject) {

    var validationExpression = "";

    if (selectionListObject.listSettings !== undefined) {
        if (selectionListObject.listSettings.drlValidationExpression !== undefined) {
            validationExpression = selectionListObject.listSettings.drlValidationExpression;
        }
    }
    return validationExpression;
}

function validateControlByRegularExp(selObject) {
    var errormsg = "";
    var strRegExpression = getValidationExpression(selObject);
    var selObjectValue = selObject.selectedOption.displayValue;
    var failureMsg = selObject.listSettings.drlFailureMessage;
    if (strRegExpression != "") {
        var pattern = strRegExpression.replace(new RegExp("/", "gm"), "");
        var regExpr = new RegExp(pattern);
        if (!regExpr.test(selObjectValue)) {
            errormsg = selObject.description + "-" + failureMsg + ".";

        }
    }
    return errormsg;
}

function validateSelectionObject(selectionListObject, errSummary) {
    var controltype;
    controltype = selectionListObject.controlType;
    if (controltype == "FreeTextBox" || controltype == "ReadonlyTextBox") {
        var validationResult = validateControlByRegularExp(selectionListObject);
        if (validationResult != "") {
            if (errSummary != "") {

                errSummary = errSummary + "\n" + validationResult;
            } else {
                errSummary = validationResult;
            }
        }
    }
    if (selectionListObject.dependantSelectionLists != null) {
        if (selectionListObject.dependantSelectionLists.length > 0) {
            for (var i = 0; i < selectionListObject.dependantSelectionLists.length; i++) {
                var dependentListObject = selectionListObject.dependantSelectionLists[i];
                errSummary = validateSelectionObject(dependentListObject, errSummary);
            }
        }
    }
    return errSummary;
}

function processSubmit() {

    var closeWindow = false;

    var errorMsg = validateForm();
    if (errorMsg != "") {
        alert(errorMsg);
    } else {
        if (CascadeData.selectionComplete === true) {

            $("#action").val('complete');

            // code added for mode forward ,no page required.
            var mode = CascadeData.mode;
            if (mode !== undefined) {
                mode = mode.toLowerCase();
                if (mode === "forward") {
                    var frameName = getParameterByName("frameName");
                    if (isEmpty(frameName)) {
                        frameName = "hiddenFrame";
                    }
                    document.forms[0].target = frameName;
                    closeWindow = true;
                }

            }

            $.blockUI();
            document.forms[0].submit();
            if (closeWindow == true) {
                //code before the pause
                setTimeout(function() {
                    closeMe();
                }, 2000);
            }
        } else {
            alert("Incomplete selection");
        }
    }
}

function rangeSubmit(calculatedFieldValue) {
    try {

        if (calculatedFieldValue.indexOf("^") != -1) {
            var nameValuePairs = calculatedFieldValue.split("^");
            if (nameValuePairs.length > 0) {
                for (var i = 0; i < nameValuePairs.length; i++) {
                    var nameValue = nameValuePairs[i].split("=");
                    if (nameValue.length > 0) {
                        updateFormField(nameValue);
                    }

                }
            }
        } else {

            var nameValue = calculatedFieldValue.split("=");
            updateFormField(nameValue);
        }
        if (fieldsExists == false) {
            throw new Error("Failed to update " + calculatedFieldValue + ".");
        }
    } catch (err) {
        alert("Fields doesn't exists on Form." + "Error details : " + err.message);
    }

}

function updateFormField(nameValue) {
    try {
        var attributeName = nameValue[0];
        var attributeValue = nameValue[1];
        // replace single quote with escape character

        attributeName = attributeName;
        attributeValue = attributeValue.replace(/'/g, "\\'");


        var attributeFieldValue = attributeName + "fieldValue";
        var attributeNameDisplay = attributeName + "Display";

        if (opener.document.forms[0]['' + attributeName + ''] !== undefined) {
            var fieldType = top.opener.document.forms[0]['' + attributeName + ''].type;


            if (fieldType == "text" || fieldType == "hidden" || fieldType == "textarea") {

                var setString = "top.opener.document.forms[0]['" + attributeName + "'].value='" + attributeValue + "';";
                eval(setString);

            } else if (fieldType == "select-one") {
                var anoption = top.opener.document.createElement('option');
                anoption.innerText = attributeValue;
                anoption.value = attributeValue;
                top.opener.document.forms[0]['' + attributeName + ''].options.add(anoption);


            }
            if (top.opener.document.forms[0]['' + attributeNameDisplay + ''] !== undefined) {
                var setStringDisplay = "top.opener.document.forms[0]['" + attributeNameDisplay + "'].value='" + attributeValue + "';";
                eval(setStringDisplay);
            }

            if (top.opener.document.forms[0]['' + attributeFieldValue + ''] !== undefined) {
                var setStringHidden = "top.opener.document.forms[0]['" + attributeFieldValue + "'].value='" + attributeValue + "';";
                eval(setStringHidden);
            }

            fieldsExists = true;
        }
    } catch (err) {

    }

}


function getcalculatedValue() {
    if (CascadeData.fullCalculatedValues !== "undefined") {

        var outputString = '';
        var i = 0;
        for (var prop in CascadeData.fullCalculatedValues) {
            if (i == 0) {
                outputString = outputString + prop + '=' + CascadeData.fullCalculatedValues['' + prop + '']
            } else {
                outputString = outputString + '\01' + prop + '=' + CascadeData.fullCalculatedValues['' + prop + ''];
            }

            i = i + 1;

        }

        return outputString;

    }
}

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function closeMe() {
    var targetLocation;
    targetLocation = getParameterByName("targetLocation");
    if (targetLocation == "") {
        targetLocation = getParameterByName(".targetLocation");
    }

    if (targetLocation === "slidein") {
        top.closeSlideInDialog();
    } else if (targetLocation === "card") {
        parent.tvc.inlineFrame.close();
    } else if (targetLocation === "sidepanel") {
        parent.tvc.inlineFrame.close();
    } else {
        if (top.opener) {
            top.close();
        }
    }

}

function isEmpty(val) {
    return (val === undefined || val == null || val.length <= 0) ? true : false;
}
