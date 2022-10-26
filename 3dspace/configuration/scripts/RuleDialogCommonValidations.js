
//RuleDialogCommonValidations.js
//Includes all the operations to be performed on Rule Dilaog Page..which may vary depending upon the Type of rule.
/*Functions included:
 * insertFeatureOptions
 * remove
 * removeFeature
 * removeFeatureOption
 * createNamedElement
 * submitRule
 * fnValidate
 */


function insertFeatureOptions(textArea)
{
	//Checks whether the feature option checkbox is selected or not
    
	if(textArea == 'left')
	{
		var featureOptionDetails = document.LEform.leftExpCheckBox.checked;
		var passComparisonParam = getTopWindow().document.getElementById('i_ForComparisonOperator').contentWindow.document.CompOperform.comparisonOperator.value;
	}
	if(textArea == 'right')
	{
		var featureOptionDetails = document.REform.rightExpCheckBox.checked;
	}
    
    var sourceFrame = getTopWindow().document.getElementById('i_ForContextSelector').contentWindow.document.getElementById('InclusionRuleSourceList').contentWindow.document;
    
    var checkedItems = new Array;
    var vchkItems = sourceFrame.forms[0].emxTableRowId;	
    
    //If only one element is selected
    if(vchkItems.length)
    {
    	checkedItems= sourceFrame.forms[0].emxTableRowId;	
    } 
    else
    {
    	checkedItems.push(sourceFrame.forms[0].emxTableRowId);
    }
    
    for(var ri = 0 ; ri < checkedItems.length ; ri++)
    {
    	var rowId = checkedItems[ri].value;
        var rowLevelArr = rowId.split("|");

        var checkedRelIds = rowLevelArr[0];
    	var checkedObjectIds = rowLevelArr[1];
    	var checkedParentIds = rowLevelArr[2];
    	
    	var vURL = "../configuration/RuleDialogPreProcessUtil.jsp?mode=format&checkedRelIds="+checkedRelIds+"&checkedParentIds="+checkedParentIds+"&checkedObjectIds="+checkedObjectIds+"&featureOptionDetails="+featureOptionDetails;
        var vRes = emxUICore.getData(vURL);
        var expression = vRes.split("-@ActualDisplay@-");
        var actualString = expression[0];
        var displayString = expression[1];
        
        if(textArea == 'left')
    	{
        	addOption(document.LEform.LeftExpression, displayString, actualString);
    	}
    	if(textArea == 'right')
    	{
    		addOption(document.REform.RightExpression, displayString, actualString);
    	}
       
    }
}

//Function to remove the feature options
function remove(textArea)
{
	if(textArea == 'left')
	{
	 Exp = document.LEform.LeftExpression ;
	}
	if(textArea == 'right')
	{
	 Exp = document.REform.RightExpression ;
	}
	
	ind = Exp.selectedIndex;
   	if (ind == -1)
   	{
   	  //alert('"<%=i18nStringNowUtil("emxProduct.Alert.SelectFeature", bundle,acceptLanguage)%>"');
   		alert(ERROR_MESSAGE_FOR_FEATURE_SELECTION);
	  return 0;
	}
   	
	if(ind!=-1)
	{
		var expValue = Exp.options[ind].value;
		var expText = Exp.options[ind].text;
	
		if (ind != -1)
		{
		  for(i=Exp.length-1; i>=0; i--)
		  {
		    if(Exp.options[i].selected)
			{
				Exp.options[i] = null;
			} 
		  }
	    }
	}
	
	if (Exp.length > 0)
	{
     Exp.selectedIndex = ind == 0 ? 0 : ind - 1;
    }
}// end of method

function removeFeature(textArea)
{
	if(textArea == 'left')
	{
	 Exp = document.LEform.LeftExpression ;
	}
	if(textArea == 'right')
	{
	 Exp = document.REform.RightExpression ;
	}
	
	ind = Exp.selectedIndex;

	if (ind == -1)
	{
	 // alert('"<%=i18nStringNowUtil("emxProduct.Alert.SelectFeature", bundle,acceptLanguage)%>"');
	 alert(ERROR_MESSAGE_FOR_FEATURE_SELECTION);
	}
	else
	{	
	 var expValue		= Exp.options[ind].value;
	 var expText			= Exp.options[ind].text;
	 
	 var vRuleClassification = Exp.options[ind].attributes[1].value;
	 var vFeatureType = Exp.options[ind].attributes[2].value;

	 var indexColon		= expText.indexOf('~');

	 var featureString	= expText.substring(0,indexColon);
	 var OptionString	= expText.substring(indexColon+1);

	 var indexColon1		= expValue.indexOf('~');
	 var OptionStringID	= expValue.substring(indexColon1+1);
	 var featureStringID = expValue.substring(0,indexColon1);

	 if(indexColon != -1)
	 {
  	  var exp1 =featureString ;
	  var exp2 =OptionString ;

	  for(var i=0; i<Exp.length; i++)
	  {
		if(Exp.options[i].selected)
		{
		  Exp.options[i] = new Option(OptionString,OptionStringID);
		  Exp.options[i].setAttribute("ruleclassification",vRuleClassification);
		  Exp.options[i].setAttribute("featuretype",vFeatureType);
		}				
      } //end of for
	 } 
		
	 if(indexColon == -1)
	 {
    	for(var i=0; i<Exp.length; i++)
    	{
		  if(Exp.options[i].selected)
		  {
			 Exp.options[i] = null;
          } 
		}
     }
	}
 } // end of method



  // Function to remove selected option 
function removeFeatureOption(textArea)
{
  if(textArea == 'left')
  {
	Exp = document.LEform.LeftExpression ;
  }
  if(textArea == 'right')
  {
	Exp = document.REform.RightExpression ;
  }

  ind =Exp.selectedIndex;

  if (ind == -1)
  {
 	 //alert('"<%=i18nStringNowUtil("emxProduct.Alert.SelectOption", bundle,acceptLanguage)%>"');
 	alert(ERROR_MESSAGE_FOR_SELECT_OPTION);
 	
  }
  else
  {
	var expValue		= Exp.options[ind].value;
	var expText			= Exp.options[ind].text;
	
	var vRuleClassification = Exp.options[ind].attributes[1].value;
	var vFeatureType = Exp.options[ind].attributes[2].value;
	
	var indexColon		= expText.indexOf('~');
	var featureString	= expText.substring(0,indexColon);

	var OptionString	= expText.substring(indexColon+1);
	var indexColon1		= expValue.indexOf('~');
	var OptionStringID	= expValue.substring(indexColon1+1);
	var featureStringID = expValue.substring(0,indexColon1);
	
	if(indexColon != -1)
	{
		var exp1 =featureString ;
		var exp2 =OptionString ;

		for(var i=0; i<Exp.length; i++)
		{
		  if(Exp.options[i].selected)
          {
			 Exp.options[i] = new Option(exp1,featureStringID);
			 Exp.options[i].setAttribute("ruleclassification",vRuleClassification);
			 Exp.options[i].setAttribute("featuretype",vFeatureType);
		  }				
		} 
	}
	if(indexColon == -1)
	{
		//alert('"<%=i18nStringNowUtil("emxProduct.Alert.OptionSelection", bundle,acceptLanguage)%>"'); 
		alert(ERROR_MESSAGE_FOR_OPTION_SELECTION);
	}
  }
} // end of method

