/*
 * iwContextSensitiveListAjax.js
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

var request; // the XMLHttpRequest

/*
 * Description: This is the main function that makes the Ajax call to populate the child menu
 *              when a selection is made in a parent menu.  This menu is intended to be called
 *              by a javascript onChange event defined for the calling (parent) menu.
 *
 * Params:
 *        menuNameArray: an array that contains the names of the context-sensitive list menu
 *                       names for a single set of context sensitive lists
 *        parentIndex: the index in the menuNameArray of the menu where the selection is being made
 *        listProgramName: This parameter can take two different forms:
 *                         1. "progName:methodName", which specifies a custom JPO that will return the values
 *                            for the child list to be populated.  The values will be in the form of a TreeMap
 *                            where the keys are the localized values and the values are the database (English) values
 *                         2. "progName", which specifies a program object whose Code body has the entire set of
 *                            context sensitive values. A utility JPO method is then called to read this
 *                            program and return the values for the child list.
 *        addBlankOption: if true then a blank entry will be added to the select list options (at the getTopWindow()),
 *                        if false then a blank entry will not be added to the select list options
 */
function getChildChoicesAjax(menuNameArray, parentIndex, listProgramName, addBlankOption) {
    var pageParams = getTopWindow().location.search;

    if (pageParams == "") {
        pageParams = "?";
    }
    else {
        pageParams += "&";
    }

    var url = "../common/iwCSAjaxController.jsp" + pageParams + "listProgramName=" + escape(listProgramName) + "&parentIndex=" + escape(parentIndex);

    // get the index of the first child
    // javascript has to be persuaded (*) to treat parentIndex as a number so it does an add (1), not a concat (01) below
    parentIndex = parentIndex * 1;
    var childIndex = parentIndex + 1;

    // Get the element name the hard way, so we don't have to change the interface to pass "this"
    var thisElement = document.getElementById(menuNameArray[childIndex]);
    // And add it to the URL
    url += "&fieldName="+escape(thisElement.name)

    // always clear all the child menus
    for (var i = childIndex; i < menuNameArray.length; i++) {
        var menu = document.getElementById(menuNameArray[i]);
        menu.value = "";
        menu.options.length = 0;
    }

    // make sure the list has not been blanked out, which would cause
    // incorrect values to be returned if lower lists were populated
    var parentMenuValue = document.getElementById(menuNameArray[parentIndex]).value;

    if (parentMenuValue != null && parentMenuValue != "") {
        // let the user know that something is happening
        for (var i = childIndex; i < menuNameArray.length; i++) {
            document.getElementById(menuNameArray[i]).disabled = true;
        }
        // get all parent and ancestor information
        var parentValues = "";
        for (var i = 0; i < menuNameArray.length; i++) {
            var menuName = menuNameArray[i];
            var menuValue = document.getElementById(menuName).value;
            url += "&" + escape(menuName) + "=" + escape(menuValue);
            parentValues += escape(menuValue)+"|";
        }
        url+="&parentValues="+parentValues;

        if (window.XMLHttpRequest) {
            request = new XMLHttpRequest();
        }
        else if (window.ActiveXObject) {
            request = new ActiveXObject("Microsoft.XMLHTTP");
        }
        
        request.open("GET", url, true);
        request.onreadystatechange = function () { callback(request, menuNameArray, parentIndex, addBlankOption); }
        request.send(null);
    }
}

/*
 * Description: This is the callback function specified in the Ajax call above.  It processes
 *              the response to create select options in the child menu (the first menu after parentIndex
 *              in the menuNameArray).
 *
 * Params:
 *        request: the Ajax XMLHttpRequest object
 *        menuNameArray: an array that contains the names of the context-sensitive list menu
 *                       names for a single set of context sensitive lists
 *        parentIndex: the index in the menuNameArray of the menu where the selection is being made
 *        addBlankOption: if true then a blank entry will be added to the select list options (at the getTopWindow()),
 *                        if false then a blank entry will not be added to the select list options
 */

function callback(request, menuNameArray, parentIndex, addBlankOption) {
    if (request.readyState == 4) {
        if (request.status == 200) {
            // javascript has to be persuaded (*) to treat parentIndex as a number so it does an add (1), not a concat (01) below
            parentIndex = parentIndex * 1;
            var childIndex = parentIndex + 1;

            var jsObject;
            // handle the response js object and use to create select options
            try {
            	var resText = request.responseText.split("ajaxResponse");
            	 jsObject = eval("(" + resText[1] + ")");

            } catch(e) {
                alert("Internal Error: Failed to eval JSON text: "+ "( " + responseText + " )");
            }

            var result = jsObject.result;
            var childField = document.getElementById(menuNameArray[childIndex]);

            // let the user know that processing is complete
            for (var i = childIndex; i < menuNameArray.length; i++) {
                document.getElementById(menuNameArray[i]).disabled = false;
            }

            var optionCount = 0; // used to make sure option[0] is not skipped if !addBlankOption
            if (addBlankOption)
                childField.options[optionCount++] = new Option("", "", false, false);

            for (var i = 0; i < result.length; i++)
                childField.options[optionCount++] = new Option(result[i].text, result[i].value);
        }

        request = null;
    }
}
