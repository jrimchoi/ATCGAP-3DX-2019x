/*
 * iwWizard.jsp
 *
 * Copyright (c) 2007 Integware, Inc.  All Rights Reserved.
 * This program contains proprietary and trade secret information of
 * Integware, Inc.
 * Copyright notice is precautionary only and does not evidence any
 * actual or intended publication of such program.
 *
 * $Rev: 127 $
 * $Date: 2008-10-15 16:23:17 -0600 (Wed, 15 Oct 2008) $
 */

<%@page import="matrix.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.matrixone.apps.domain.util.*"%>
<%@include file="../../emxI18NMethods.inc"%>

<%!
	public String BUNDLE = "LSACommonFrameworkStringResource";
%>

// pathStack holds active div and all previously visited divs as a stack
var pathStack = new Array(); // stack used for backing up during wizard
var pathIndex = 0;
pathStack[0] = "Start"; // the starting div

var result = ""; // the result
var divIdToShow = ""; // used to hold div for next step of wizard
var isInProcess = false; // used for idempotent create

function wizBacktrack()
{
  // hide all divs except previous step to show
  var divArray = wizardContent.document.getElementsByTagName("div");
  for (var i = 0; i < divArray.length; i++)
  {
    //divArray[i].style.top = "-5000px";
	divArray[i].style.display = "none";
	divArray[i].style.position = "absolute";
  }
  // show div for previous step
  if (pathIndex > 0)
  {
    divIdToShow = pathStack[--pathIndex];
  }

  wizardContent.document.getElementById(divIdToShow).style.display = "block";
  //wizardContent.document.getElementById(divIdToShow).style.top = "0px";

  // set no result value
  result = "";
  drawButtons(divIdToShow);
}

function wizAdvance()
{
  var currentDiv;

  // find currently displayed div
  var divArray = wizardContent.document.getElementsByTagName("div");
  for (var i = 0; i < divArray.length; i++)
  {
	if (divArray[i].style.display == "block")
    {
      currentDiv = divArray[i];
    }
    /*if (divArray[i].style.top == "0px")
    {
      currentDiv = divArray[i];
    }*/
  }

  // get div to show for next step and possibly result to create
  var selectionRequired = currentDiv.getAttribute("selectionRequired");

  if (!selectionRequired.toLowerCase().match("true"))
  {
    divIdToShow = currentDiv.getAttribute("defaultNextStep");
    result = currentDiv.getAttribute("defaultresult");
  }

  // but option may be selected even if not required, so we check no matter what
  // (this only applies to radio buttons)
  var inputArray = currentDiv.getElementsByTagName("input");
  var nextStep = "";
  for (var i = 0; i < inputArray.length; i++)
  {
    if (inputArray[i].checked)
    {
    nextStep = inputArray[i].getAttribute("nextStep");
      if (nextStep != null && nextStep != "")
        divIdToShow = nextStep;

      if (inputArray[i].getAttribute("result") != null && inputArray[i].getAttribute("result") != "")
        result = inputArray[i].getAttribute("result");

      break;
    }
  }

  // check to make sure all required fields are filled in
  var currentFieldsArray = currentDiv.getElementsByTagName("*");

  for (var i = 0; i < currentFieldsArray.length; i++)
  {
    // input may be text, radio or checkbox
    var currType = currentFieldsArray[i].type;

    if (currType == "text" || currType == "textarea" || currType == "select-one" || currType == "radio") {
      var reqd = currentFieldsArray[i].required;
      
      if (reqd==undefined) {
      	reqd=false;
      }

      if (reqd != null && reqd) {
        var val = currentFieldsArray[i].value;

        if (val.search(/\w+/) < 0) {
          //alert("Please complete all required fields to continue.");
          alert("<%=getI18NString(BUNDLE,"LSACommonFramework.Message.CompleteAllRequiredFields",request.getHeader("Accept-Language"))%>"); //XSSOK
          return;
        }
      }
    }
  }

  if (divIdToShow == currentDiv.id)
  {
    //alert("Please make a selection to continue.");
    alert("<%=getI18NString(BUNDLE,"LSACommonFramework.Message.PleaseMakeASelectionToContinue",request.getHeader("Accept-Language"))%>"); //XSSOK
    return;
  }

  // make sure there is a div to show, otherwise do nothing
  if (divIdToShow != null && divIdToShow != "")
  {
    // hide all divs
    var divArray = wizardContent.document.getElementsByTagName("div");
    for (var i = 0; i < divArray.length; i++)
    {
      //divArray[i].style.top = "-5000px";
	  divArray[i].style.display = "none";
	  divArray[i].style.position = "absolute";
    }

    // show next step in wizard
	wizardContent.document.getElementById(divIdToShow).style.display = "block";
    //wizardContent.document.getElementById(divIdToShow).style.top = "0px";
    pathStack[++pathIndex] = divIdToShow;
  }

  drawButtons(divIdToShow);
}

function wizCancel()
{
  result = "";
  getTopWindow().close();
}

function hideDivs()
{
  // hide all divs except starting div
  var divArray = wizardContent.document.getElementsByTagName("div");

  for (var i = 0; i < divArray.length; i++)
  {
    divArray[i].style.display = "none";
    divArray[i].style.position = "absolute";
    //divArray[i].style.top = "-5000px";
  }

  wizardContent.document.getElementById("Start").style.display = "block";
  //wizardContent.document.getElementById("Start").style.top = "0px";

  drawButtons("Start");
}

function wizFinish()
{
  if (isInProcess == true) {
    return false;
  }

  isInProcess = true;

  //Allow wizard specific validation selected by wizard name
  var returnValue = true;
  try {
    var sToEval = "do" + sWizardName + "Validation()";//sWizardName ia a javascript var set in iwWizardFS.jsp by getting wizard name param from command url
    returnValue = eval(sToEval);
  } catch(eval_ex) {
    //Continue as the method is not required to exist; it will only run if it does exist
  }
  
 if (returnValue == true)
  {
	try {
    	returnValue = eval(sCustValidation);//sCustValidation ia a javascript var set in iwWizardFS.jsp by getting custWizValidation param from command url
   	    if (returnValue == null) //nothing to evaluate
   	    	returnValue = true;
  	} catch(eval_ex) {
      //Continue as the method is not required to exist; it will only run if it does exist
  	}
  }
  
  if (returnValue == true)
  {
    var theForm = wizardContent.document.formWizard;

    theForm.result.value = result;
    wizardHead.document.getElementById("progressIcon").style.visibility = "visible";

    // append the form field names in a nice packaged param
    var fieldNames = new Array();
    var fieldIndex = 0;
    var fieldsAdded = "";

    for (var i = 0; i < theForm.length; i++) {
        var fieldName = theForm.elements[i].name;

        if (fieldName != "emxTableRowId" && fieldName != "result" && fieldsAdded.indexOf(fieldName) < 0) {
            fieldsAdded = fieldsAdded + "~" + fieldName;
            fieldNames[fieldIndex++] = fieldName;
        }
    }

    for (var i = 0; i < fieldNames.length; i++) {
        var element = wizardContent.document.createElement("input");
        element.type = "hidden";
        element.name = "wizardFieldNames";
        element.id = "wizardFieldNames";
        element.value = fieldNames[i];
        theForm.appendChild(element);
    }

    theForm.submit();
  }

  isInProcess = returnValue;
}

function handleError(errMsg)
{
  wizardHead.document.getElementById("progressIcon").style.visibility = "hidden";
  //alert("An error has occurred. Please notify your system administrator for assistance.\n\nError: " + errMsg);
  alert("<%=getI18NString(BUNDLE,"LSACommonFramework.Message.AnErrorhasOccurred",request.getHeader("Accept-Language"))%>" + "\n\n" + "<%=getI18NString(BUNDLE,"emxFramework.IWWizard.ErrorMsg.Error",request.getHeader("Accept-Language"))%>" + " " + errMsg); //XSSOK
}

/**
* @author Eric Rank 2006-09-27
* This method is called advancing, and back tracking
* It performs 3 different tests.
* 1. if the startStep attribute value is true, it is a start step
*    and therefore the back button is hidden
* 2. if the finishStep attribute value is true, it is a finish step
*    and therefore the done button is displayed
* 3. if the div identified by the id has a defaultNextStep or contains options with a nextStep attribute,
*    there is a next step, so the next button is displayed.
*/
function drawButtons(id){
    var div = wizardContent.document.getElementById(id);
    var startStep = false;
    var finishStep = false;
    if(div){
        startStep = div.getAttribute("startStep").search(/^true$/i) > -1;
        finishStep = div.getAttribute("finishStep").search(/^true$/i) > -1;
    }


    //is it a start step?
    if(startStep){
        wizardFoot.btnBack.disable();

    }else{
        wizardFoot.btnBack.enable();

    }

    //is it a finish step?
    if(finishStep){
        wizardFoot.btnDone.enable();
    }else{
        wizardFoot.btnDone.disable();
    }

    //is there a next step?
    var hasNextStep = false;
    if(div){
        var defaultNextStep = "";
        defaultNextStep = div.getAttribute("defaultNextStep");
        if(defaultNextStep){
            hasNextStep = true;
        }else{
            //check to see if the selected option has a step
            var inputArray = div.getElementsByTagName("input");
            for (var i = 0; i < inputArray.length; i++){
                var nextStep = inputArray[i].getAttribute("nextStep")
                if(nextStep){
                    hasNextStep = true;
                    break;
                }
            }
        }
    }

    //If this div has a next step, show the next step
    if(hasNextStep){
        wizardFoot.btnNext.enable();
    }else{
        wizardFoot.btnNext.disable();
    }
}
