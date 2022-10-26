/*  emxInfoCentralJavaScriptUtils.js

   Copyright Dassault Systemes, 1992-2007. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

*/

//
// Java script Utility functions across the info central application
  


//Function to clear any field
function clearField(formName,fieldName,idName) 
{
	var operand = "document." + formName + "." + fieldName+".value = \"\";";
	eval (operand);
	if(idName != null){
		var operand1 = "document." + formName + "." + idName+".value = \"\";";
		eval (operand1);
	}	
	return;
}

//Function to show the type selector
//this depends on some variables that are defined at the place this is used.
//ex: txtType, txtTypeDisp etc needs to be defined in the jsp where the type selector is used
function showTypeSelector (varType, varTopLevel, frmName, varName, multisel) {
         var strFeatures = "width=450,height=350,resizable=yes";
		 if(multisel == "true")
			 multisel = "multiselect";
		 else
			 multisel = "singleselect";
         var strURL="../common/emxTypeChooser.jsp?fieldNameActual="+varName+"&fieldNameDisplay=selType&formName="+frmName+"&ShowIcons=true&ObserveHidden=false&SelectType="+multisel+"&SelectAbstractTypes=true";
		 if(varType != "*")
			strURL = strURL + "&InclusionList=" + varType;
          var win = window.open(strURL, "", strFeatures);
  }

function showModalAEFTypeSelector (varType, varTopLevel, frmName, varName, hiddenVarName, multisel, reload) {
         var strFeatures = "width=450,height=350,resizable=yes";
		 if(multisel == "true")
			 multisel = "multiselect";
		 else
			 multisel = "singleselect";
         var strURL="../common/emxTypeChooser.jsp?fieldNameActual="+varName+"&fieldNameDisplay="+hiddenVarName+"&formName="+frmName+"&ShowIcons=true&ObserveHidden=false&SelectType="+multisel+"&SelectAbstractTypes=true&ReloadOpener="+reload;
		 if(varType != "*")
			strURL = strURL + "&InclusionList=" + varType;
		 showModalDialog(strURL, 450, 350, true);
}

//Function to show vault chooser
function showVaultSelector() 
{
	var strFeatures = "width=300,height=350,screenX=238,left=238,screenY=135,top=135,resizable=no,scrollbars=auto";
	txt_Vault = eval(strTxtVault);
	var url = "emxSelectVaultDialog.jsp";
	//var win = window.open(url, "VaultSelector", strFeatures);
	showModalDialog(url, 300, 350, true);
}

//function to show person chooser
function showUserSelector()
{	
	var strFeatures = "width=570,height=520,screenX=238,left=238,screenY=135,top=135,resizable=no,scrollbars=auto";
	txtUserField = eval(strTxtPeople);
	var url = "emxInfoSearchFrameSet.jsp?ActionBarName=IEFPeopleSearchActionBar";
	//var win = window.open(url, "PeopleSelector", strFeatures);
	showModalDialog(url, 530, 480, true);
}

function showPolicySelector(varTypeValue, varvaultValue)
{	
	var strFeatures = "width=300,height=350,screenX=238,left=238,screenY=135,top=135,resizable=no,scrollbars=auto";
	txt_Policy = eval(strTxtPolicy);
	txt_Sequence = eval(strTxtSequence);
	//var url = "emxSelectPolicyDialog.jsp?sType=" + escape(varTypeValue) + "&sVault=" + escape(varvaultValue);
      var isIE = navigator.userAgent.toLowerCase().indexOf("msie") > -1;	
      if(!isIE){
      varTypeValue=escape(varTypeValue);
      varvaultValue=escape(varvaultValue);
      }
      else{
	while(varTypeValue.indexOf(" ")!=-1){
	varTypeValue = varTypeValue.replace(' ','+');
	}
	while(varvaultValue.indexOf(" ")!=-1){
	varvaultValue = varvaultValue.replace(' ','+');
	}
      }
	var url = "emxSelectPolicyDialog.jsp?sType=" + varTypeValue + "&sVault=" + varvaultValue;
	//var win = window.open(url, "PolicySelector", strFeatures);
	showModalDialog(url, 300, 350, true);
}

//Function FUN080585 : Removal of Cue, Tips and Views

function showAlt(th,e,text){
	if (text != 'none' || text != '')
	{
		if (document.layers )
		{
			document.tooltip.document.write('<layer bgColor="#ffffc0" style="border:1px solid black;font-family: verdana, helvetica, arial, sans-serif; font-size: 8pt;color:#000000"><font face=arial size=2>'+text+'</font></layer>');
			document.tooltip.document.close();
			document.tooltip.left=e.pageX+5;
			document.tooltip.top=e.pageY+5;
			document.tooltip.visibility="show";
		}
	}
	return;
}

function hideAlt(){
	if (document.layers){		
		document.tooltip.visibility="hidden";
	}
	return;
}


//--------------------------------------------------------------
// Transfer focus on to next form element
// Usage:
// <INPUT type="text" name=text2 onFocus='transferFocusToNextElement(this);'>
// Author: Surojit Banerjee.
// Date: 20th May 2003
//--------------------------------------------------------------
function transferFocusToNextElement(inputElement)
{
    //
    inputElement.blur();

    //get handle to elements form
    var inputElementsForm = inputElement.form;

    //iterate over all form elements
    for (var i=0; i < inputElementsForm.length; i++ )
    {
	//holds final element index to put focus on
	index = 0;

	//temp variable to compute element index to put focus on
	c = 0;

	//passed elements matched iterating value
	if (inputElement.name == inputElementsForm.elements[i].name)
	{
	    //initialize temp variable to i
	    c = i;

	    //iterate the further elements to eliminate
	    //any hidden elements
	    while(1==1)
	    {
		c = c + 1;

		//if transfer focus from the last form element reset
		//counter to 0 i.e trnasfer focus to the first form element
		if(c == (inputElementsForm.length-1))
		{
		    c = 0;
		}
		if(inputElementsForm[c].type == "hidden")
		{
		    continue;
		}
		else
		{
		    //final element index value
		    index = c;
		    break;
		}
	    }

	    //if reached the final element reset the index to
	    //0th form element trnasfer focus to the first form element
	    if(index == (inputElementsForm.length-1))
	    {
		index = 0;
	    }

	    inputElementsForm[index].focus();
	    break;
	}
    }
}

function badCharExistInForm(objForm, arrBadChars)
{
	var badCharExists = false;
	
	//parse the elements one by one
	for (elementCount = 0; elementCount < objForm.elements.length; elementCount++) 
	{
		var element = objForm.elements[elementCount];
		var type = element.type;
		if (type == "text" || type == "textarea")
		{
			var value = element.value;
			for (var i=0; i < arrBadChars.length; i++) 
			{
				if (value.indexOf(arrBadChars[i]) > -1) 
				{
					element.focus();
					return true;
				}
			}
		}
	}

	return badCharExists;
}
