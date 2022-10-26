 <%--
  Copyright (c) 2014-2018 Dassault Systemes.
   All Rights Reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes,Inc.
   Copyright notice is precautionary only and does not evidence any
   actual or intended publication of such program

   $Rev: 68 $
   $Date: 2008-02-14 04:53:24 +0530 (Thu, 14 May 2008) $
--%>

<%--  ethNCRCentralFormValidation.jsp

   Comments:  Created from AuditFormValidation.jsp.
   In order to support internationalization of the alert messages,
   we had to use .jsp functionality.

 --%>
 <html>


<%@page import="matrix.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.matrixone.apps.domain.util.*"%>
<%@page import="com.dassault_systemes.enovia.lsa.Helper"%>
<%@page import ="com.matrixone.servlet.Framework"%>
<%@page import="matrix.db.Context"%>
<%@page import="com.dassault_systemes.enovia.lsa.LSAException"%>
<% 
matrix.db.Context context = Framework.getFrameContext(session); 
%>

<%!
       private String getEncodedI18String(Context context, String key) throws LSAException {
              try {
                     return XSSUtil.encodeForJavaScript(context,Helper.getI18NString(context, Helper.StringResource.AUDIT, key));
              } catch (Exception e) {
                     throw new LSAException(e);
              }
       }
%>
<script language="javascript">

var resultValue = "abc";

// function for loading newly created object into the content frame
function handleComplete(id)
{
  var url = "../common/emxTree.jsp?emxSuiteDirectory=LQIAudit&suiteKey=LQIAudit&objectId=" + id;
  getTopWindow().getWindowOpener().getTopWindow().content.location = url;
}

function handleCompleteConnect(id)
{
  var objDetailsTree = getTopWindow().getWindowOpener().getTopWindow().objDetailsTree;
  alert("got here");
  //var objDetailsTree = parent.window.getWindowOpener().getTopWindow().objDetailsTree;
  var objSelectedNode = objDetailsTree.getSelectedNode();
  var strNodeID = objSelectedNode.nodeID;

  var url = "../common/emxTree.jsp?mode=insert&objectId=" + id + "&jsTreeID=" + strNodeID;
  getTopWindow().getWindowOpener().getTopWindow().content.location = url;
}

function doSearch(){

    //get the form
    var theForm = document.forms[0];

    //set form target
    //theForm.target = "searchView";

    // If the page needs to do some pre-processing before displaying the results
    // Use the "searchHidden" frame for target
    theForm.target = "searchHidden";

    //validate()??
    if(validateForm(document.forms[0])){
        theForm.action = "emxSearchGeneralSavePreprocess.jsp";//"emxIndentedTable.jsp";
        theForm.submit();
    }

}
//Function To Activate and Inactivate Audit External Info field
function checkAuditType()
	{
         var fieldAuditType = document.getElementById("Audit Type");
		 var FieldValue=fieldAuditType.value;
	     var fieldSupplierLabel = document.getElementById("calc_Suppliers");
	     var fieldSupplierValue = document.getElementsByName("SuppliersDisplay")[0];
	     var fieldSupplierButton = document.getElementsByName("btnSuppliers")[0];	     
	    
	     if(FieldValue=="Supplier")
	     {
			  fieldSupplierLabel.style.display="";
			  fieldSupplierValue.style.display="";
			  fieldSupplierButton.style.display="";
	     }
		else
		{
			  fieldSupplierLabel.style.display="none";			 
			  fieldSupplierValue.style.display="none";
			  fieldSupplierButton.style.display="none";			 
	  	}

		//make the Audit External Infor field visible and nivisible
		var varField = document.getElementById("Audit External Info");
		if(FieldValue=="Other")
		{
			varField.style.visibility = "visible";
		}
		else
		{
			varField.style.visibility = "hidden";
		}
}


//Function for preprocessing Supplier and Audit Of fields
function checkAuditTypeAndIsReAudit()
	{
	checkAuditType();
	checkIsReAudit();
}

//Function To Activate and Inactivate Audit External Info field
function showFieldsBasedOnAuditType()
	{
         var fieldAuditType = document.getElementById("Audit Type");
		 if (fieldAuditType != null) {
			 var FieldValue=fieldAuditType.value;
			 var fieldSupplier = document.getElementById("calc_Suppliers");
			 if(FieldValue=="Supplier")
			 {
				  fieldSupplier.style.display="";
			 }
			else
			{
				  fieldSupplier.style.display="none";
			}

			//make the Audit External Infor field visible and nivisible
			var varField = document.getElementById("Audit External Info");
			if(FieldValue=="Other")
			{
				varField.style.visibility = "visible";
			}
			else
			{
				varField.style.visibility = "hidden";
			}
		}
}

//Function To Activate and Inactivate Audit ReAudit field
function checkIsReAudit()
	{
	var isReAudit = emxFormGetValue("AuditIsReAudit");
	if(isReAudit!=null && isReAudit.current.actual=="Yes")
	{
		emxFormDisableField("AuditReAudit",true);
		document.getElementById("calc_AuditReAudit").firstChild.className += " labelRequired";
		
	}else{
	  	emxFormDisableField("AuditReAudit", false);
	  	emxFormSetValue("AuditReAudit","","");
	  	var labelClass= document.getElementById("calc_AuditReAudit").firstChild.className;
	  	document.getElementById("calc_AuditReAudit").firstChild.className = labelClass.replace("labelRequired","");
	}
}

function checkIsAuditFollowUpThroughReAudit()
{
	var isReAudit = emxFormGetValue("AuditFollowUpThroughReAudit");
	if(isReAudit!=null && isReAudit.current.actual=="Yes")
	{
		emxFormDisableField("AuditReAudit",true);
		document.getElementById("calc_AuditReAudit").firstChild.className += " labelRequired";
	
	}else{
  		emxFormDisableField("AuditReAudit", false);
  		emxFormSetValue("AuditReAudit","","");
  		var labelClass= document.getElementById("calc_AuditReAudit").firstChild.className;
  		document.getElementById("calc_AuditReAudit").firstChild.className = labelClass.replace("labelRequired","");
	}
}

function auditFindingEditPreProcess()
{
	var isReAudit = emxFormGetValue("AuditFollowUpThroughReAudit");
	if(isReAudit!=null && isReAudit.current.actual=="Yes")
	{
		emxFormDisableField("AuditReAudit",true);
		document.getElementById("calc_AuditReAudit").firstChild.className += " labelRequired";
	
	}else{
  		emxFormDisableField("AuditReAudit", false);
  		emxFormSetValue("AuditReAudit","","");
  		var labelClass= document.getElementById("calc_AuditReAudit").firstChild.className;
  		document.getElementById("calc_AuditReAudit").firstChild.className = labelClass.replace("labelRequired","");
	}
	
	var fieldAuditFollowUpRequired = document.getElementById("AuditFollowUpRequiredId").value;	 
	  //var fieldAuditFollowUpRequired = emxFormGetValue("Audit Follow-Up Required");
				
	 //var FieldValue = fieldAuditFollowUpRequired.current.actual;
	 if(fieldAuditFollowUpRequired!=null && fieldAuditFollowUpRequired=="Yes")
	 {
		emxFormSetValue("AuditNoFollowUpRationale","","");
			
	    emxFormDisableField("AuditNoFollowUpRationale",false);
	    emxFormDisableField("AuditPlannedFollowUpDate",true);
	    emxFormDisableField("AuditResolutionAssignedTo",true);
	    emxFormDisableField("AuditFollowUpThroughReAudit",true);
	    emxFormDisableField("AuditReAudit", true);
	    
	    document.getElementById("calc_AuditPlannedFollowUpDate").firstChild.className += " labelRequired";
		document.getElementById("calc_AuditResolutionAssignedTo").cells[0].className += " labelRequired";
		document.getElementById("calc_AuditFollowUpThroughReAudit").firstChild.className += " labelRequired";
	    
		var labelClass = document.getElementById("calc_AuditNoFollowUpRationale").firstChild.className;
		document.getElementById("calc_AuditNoFollowUpRationale").firstChild.className = labelClass.replace("labelRequired","");
	  	
	 }
	else
	{
		emxFormSetValue("AuditFollowUpThroughReAuditId","","");
	    emxFormSetValue("AuditPlannedFollowUpDate","","");
	    emxFormSetValue("AuditFollowUpThroughReAudit","","");
	    emxFormSetValue("AuditReAudit","","");
	    emxFormSetValue("AuditResolutionAssignedTo","","");
	    
	   	emxFormDisableField("AuditNoFollowUpRationale",true);				    
	   	emxFormDisableField("AuditPlannedFollowUpDate",false);				    
	   	emxFormDisableField("AuditFollowUpThroughReAudit",false);				    
	   	emxFormDisableField("AuditResolutionAssignedTo",false);
	   	emxFormDisableField("AuditReAudit", false);
	   
	   	document.getElementById("calc_AuditNoFollowUpRationale").firstChild.className += " labelRequired";
	   
		var labelClass;
	    
	  	labelClass = document.getElementById("calc_AuditPlannedFollowUpDate").firstChild.className;
	    document.getElementById("calc_AuditPlannedFollowUpDate").firstChild.className = labelClass.replace("labelRequired","");
	    
	    labelClass = document.getElementById("calc_AuditResolutionAssignedTo").cells[0].className;
	    document.getElementById("calc_AuditResolutionAssignedTo").cells[0].className = labelClass.replace("labelRequired","");
	    
	    labelClass = document.getElementById("calc_AuditFollowUpThroughReAudit").firstChild.className;
	    document.getElementById("calc_AuditFollowUpThroughReAudit").firstChild.className = labelClass.replace("labelRequired","");
	    
	}

}

function auditFindigReAuditFieldCheck(){
	var auditReAudit = emxFormGetValue("AuditReAudit");
	var isReAudit = emxFormGetValue("AuditFollowUpThroughReAudit");
	if(isReAudit!=null && isReAudit.current.actual=="Yes" && (null==auditReAudit.current.actual || ""==auditReAudit.current.actual || undefined==auditReAudit.current.actual))
	{
		/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.ReAuditOf")%>");
		 return false;		
	}
	return true;
}

//function to check if 'Reaudit Of' field is not blank if 'Is ReAudit' is set to yes
function auditReAuditFieldCheck(){
	var auditReAudit = emxFormGetValue("AuditReAudit");
	var isReAudit = emxFormGetValue("AuditIsReAudit");
	if(isReAudit!=null && isReAudit.current.actual=="Yes" && (null==auditReAudit.current.actual || ""==auditReAudit.current.actual || undefined==auditReAudit.current.actual))
	{
		/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.ReAuditOf")%>");
		 return false;		
	}
	return true;
}

// Validate the Template Name is less than 125 characters
// and is unique
function checkTemplateName() {
	if(confirmFieldLimit125(this.value.length) == true) {
		if(checkDuplicateTemplateName(this.value) == true) {
			return true;
		}
	}
	this.focus();
	return false;
}

// Validate Audit Template Name is unique
function checkDuplicateTemplateName(templateName) {
    var pageParams = getTopWindow().location.search;
    if (pageParams == "") {
            pageParams = "?";
        }
        else {
            pageParams += "&";
    }
    // Build URL and include the parameters we need to pass
    var url = "../common/iwCSAjaxController.jsp" + pageParams + "listProgramName=" + escape("com.dassault_systemes.enovia.lsa.audit.services.ui.AuditAuditTemplate:checkDuplicateTemplateNameFieldAjax");
    url += "&" + escape("templateName") + "=" + escape(templateName);
    
    // Create the appropriate request based on 
    // browser being used
    if (window.XMLHttpRequest) {
       	request = new XMLHttpRequest();
    }
    else if (window.ActiveXObject) {
       	request = new ActiveXObject("Microsoft.XMLHTTP");
    }

    // Make the synchrounous call. The 'false' makes 
    // this synchronous
    request.open("GET", url, false);
    request.send(null);
    var resText = request.responseText.split("ajaxResponse");       
    var jsObject = eval("(" + resText[1] + ")");
    var result = jsObject.result;
    // Parse the return value to see if the
    // validation passed
    if (result[0].value == "false") {
   	/*XSS OK*/ 	alert("'" + templateName + "'" + " " + "<%=getEncodedI18String(context,"LQIAudit.Message.NameNotUnique")%>");
    return false;
    } else {
       	return true;
    }
}

//Function to check Audit Template Name Length
function confirmFieldLimit125(numChars)
{
    if (numChars > 125)
	{
    	/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.AuditTemplateFieldLength")%>");
       this.focus();
       return false;
    }
	return true;
}


//should not be here but can be shifted later to new seperate js file

//		var numOfAuditors= "+ String.valueOf(iNextNum)+";
//		var AuditorArray = new Array("+sInitialArrayString+");

		var numOfAuditors= 0;
		var AuditorArray = new Array();
		var olddiv ;
		function handleEnter()
		{
			if (window.event && window.event.keyCode == 13)
			{
				addAuditorMultiple();
				return false;
			}
		}

		function updateAttrString(addOrRemove,auditorName,fieldName)
		{
			var Old_val = document.getElementById("ARR_"+fieldName);
			var new_value = Old_val.value;
			//new_value = new_value.replace("~",",");

			AuditorArray = new_value.split("~");

			var sFormattedString = "";

			if (addOrRemove == "add")
			{
				var iLength = AuditorArray.length;
				AuditorArray[iLength]= auditorName;
			}
			else if (addOrRemove == "remove")
			{
				for (i=0; i < AuditorArray.length; i++)
				{

					if (AuditorArray[i] == auditorName)
					{
						AuditorArray[i]="";
					}
				}
			}
			
			for (i=0; i < AuditorArray.length; i++)
			{
				if (AuditorArray[i] != "")
				{
					sFormattedString += "~" +AuditorArray[i];
				}
			}
			if (sFormattedString.length > 0)
			{
				sFormattedString = sFormattedString.substring(1);
			}
			//assign old value whatever array has current
			Old_val.value = sFormattedString;

			var formattedAuditors = document.getElementsByName("Final_"+fieldName)[0];
			formattedAuditors.value=sFormattedString;

			//Clearing the field value
			var auditorInputDisplay = document.getElementById("display_"+fieldName);
			auditorInputDisplay.value="";
		}

                // this function is used for removing the Auditor , lead auditor or auditee
		function removeAuditor(divToRemoveName,fieldName, displayName, auditorIsOnRequest, auditorIsOnFinding)
		{
			if(auditorIsOnRequest=="true")
			{
				/*XSS OK*/ alert(displayName+ " <%=getEncodedI18String(context,"LQIAudit.Message.IsAssignedToRequest")%>");
				return;
			}
			
			if(auditorIsOnFinding=="true")
			{
				/*XSS OK*/ alert(displayName+ " <%=getEncodedI18String(context,"LQIAudit.Message.IsAssignedToFinding")%>");
				return;
			}
			//when Audit is in Active state, one Auditee must remain
			if(fieldName=="Audit Auditees")
			{
				var auditeeCount = document.getElementById("CountAuditees");
				var typeName = document.getElementById("Type_"+fieldName);
				var stateName = document.getElementById("State_"+fieldName);
				if(typeName.value=="Audit" && stateName.value=="Active" && auditeeCount != null && auditeeCount.value==1 )
				{
					/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.BlockDeleteAlAuditeelMessage")%>");
					return ;
				}
				else
				{
					auditeeCount.value = eval(auditeeCount.value) - 1;
				}
			}

			var divToRemove = document.getElementById(divToRemoveName);
			//Set the inner html to blank to remove all the input fields
			//var collChildren = divToRemove.children ;//does not work for firefox
			//childNodes hold all text data instead of only node, 2nd element is the only useful data
			var collChildren = divToRemove.childNodes[1];
			updateAttrString("remove",collChildren.name,fieldName);
			divToRemove.innerHTML= "";
			//divToRemove.removeNode();//does not work for firefox
			divToRemove.parentNode.removeChild(divToRemove);
			//enabled the add button if the single selection is allowed
			if(fieldName == "Audit Resolution Assigned To" || fieldName == "Audit Lead Auditor" || fieldName == "Audit Responder" || fieldName == "Audit Verified By" )
			{
				var varButton =  document.getElementById("Add_"+fieldName);
				varButton.disabled = false;				
			}
			//comment out the following code to avoid dulplicate html element being created 
			//when calling function addAuditorMultiple()
			//var count = document.getElementById("count_"+fieldName);
			//count.value = eval(count.value) - 1;
		}


		function addAuditorMultiple(fieldName)
		{
			var count = document.getElementById("count_"+fieldName);
			numOfAuditors = eval(count.value);
			//var auditorInput = document.getElementById("auditorInput");
			var auditorInput = document.getElementById(fieldName);
			var auditorInputDisplay = document.getElementById("display_"+fieldName);

			var sAuditorValue = auditorInput.value;
	
			if(sAuditorValue =="")
			{
				sAuditorValue = auditorInputDisplay.value;
			}

			var sAuditorValueDisplay = auditorInputDisplay.value;

			if(fieldName =="SUB_Audit Sub-System")
			{
				if (sAuditorValueDisplay=="")
				{
					/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.Enterthevalue")%>");
					auditorInputDisplay.focus();
					return;
				}

				sAuditorValue = sAuditorValueDisplay;
			}else
			{
				if (sAuditorValueDisplay=="")
				{
					/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.EnterAuditorName")%>");
					auditorInputDisplay.focus();
					return;
				}
				sAuditorValue = auditorInputDisplay.value;
			}

			var anchorDiv = document.getElementById("anchorDiv_"+fieldName);
			var divIdName = "Auditor_"+numOfAuditors+"_Div_"+fieldName;
			var newdiv = document.createElement("DIV");
			newdiv.setAttribute("id",divIdName);
			//var auditorInput = document.getElementById("auditorInput");
			//var auditorInput = document.getElementById(fieldName);
			//var sAuditorValue = auditorInput.value;
			var sHTML = '&nbsp;';
			sHTML += '<img src="images/iconSmallPerson.gif" alt="" name="'+sAuditorValue+'"/>';
			sHTML += '&nbsp;'+ sAuditorValueDisplay;
			/*XSS OK*/ sHTML += '&nbsp;<a href="javascript:;" onclick="removeAuditor(\''+divIdName+'\',\''+fieldName+'\');">' + "<%=getEncodedI18String(context,"LQIAudit.Button.Remove")%>" + '</a>';
			newdiv.innerHTML = sHTML;

			anchorDiv.appendChild(newdiv);
			updateAttrString("add",sAuditorValue,fieldName);

			numOfAuditors++;
			auditorInput.value="";
			count.value = numOfAuditors;
			//update CountAuditees field value for adding Audit Auditee
			if(fieldName=="Audit Auditees")
			{
				var auditeeCount = document.getElementById("CountAuditees");
				auditeeCount.value = eval(auditeeCount.value) + 1;
			}
			auditorInputDisplay.focus();
		}


		function addAuditorSingle(fieldName)
		{
			var count = document.getElementById("count_"+fieldName);
			var varCount = count.value;

			if(count.value >= 2 )
			{
				/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.OneAuditorAllowed")%>");
				return;
			}
			var numOfAuditors = 1;
			var auditorInput = document.getElementById(fieldName);
			var auditorInputDisplay = document.getElementById("display_"+fieldName);
			var sAuditorValue = auditorInput.value;
			var sAuditorValueDisplay = auditorInputDisplay.value;

			if(sAuditorValue =="")
			{
				sAuditorValue = auditorInputDisplay.value;
			}

			if (sAuditorValueDisplay=="")
			{
				/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.EnterAuditorName")%>");
				//sAuditorValueDisplay.focus();
				return;
			}

			var anchorDiv = document.getElementById("anchorDiv_"+fieldName);
			var divIdName = "Auditor_"+numOfAuditors+"_Div_"+fieldName;
			var newdiv = document.createElement("DIV");
			newdiv.setAttribute("id",divIdName);

			var sHTML = '&nbsp;';
			sHTML += '<img src="images/iconSmallPerson.gif" alt="" name="'+sAuditorValue+'"/>';
			sHTML += '&nbsp;'+ sAuditorValueDisplay;
			sHTML += '&nbsp;<a href="javascript:;" onclick="removeAuditor(\''+divIdName+'\',\''+fieldName+'\');">Remove</a>';
			newdiv.innerHTML = sHTML;
			anchorDiv.appendChild(newdiv);
			
			var formattedAuditors = document.getElementsByName("Final_"+fieldName)[0];
			formattedAuditors.value = sAuditorValue;
			varCount = eval(varCount)+1;
			count.value = varCount;
			auditorInputDisplay.focus();
			//disabled the add button if the single selection is allowed
			if(fieldName == "Audit Resolution Assigned To" || fieldName == "Audit Lead Auditor" || fieldName == "Audit Responder" || fieldName == "Audit Verified By" )
			{
				var varButton =  document.getElementById("Add_"+fieldName);
				varButton.disabled = true;
			}
			auditorInputDisplay.value="";
		}

		/* ***************************************
		 * Start Here
		 * added for Searching the auditors Name on click on Find Auditor Link
		 */
		function FindAuditor(fieldName)
		{
			var auditorInput = document.getElementById("display_"+fieldName);
			var sAuditorValue = auditorInput.value;
			if(fieldName =="SUB_Audit Sub-System")
			{
				/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.Enterthevalue")%>");
				auditorInput.focus();
				return;
			}
			else if (sAuditorValue=="")
			{
				/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.EnterValueFindAttendee")%>");
				auditorInput.focus();
				return;
			}
			document.editDataForm.action ="../LQIAudit/AuditFindAuditorTable.jsp?SearchAuditor="+sAuditorValue+"&fieldName="+fieldName+"";
			 //Adding properties for new window
			var aWindow = window.open('','TargetProperties','resizable=yes,width=400,height=400');
            // set the target to the blank window
			document.editDataForm.target="TargetProperties";
			document.editDataForm.submit();
		}


		//Function To Activate and Inactivate Audit object select field
		function showAuditChooser(fieldName)
		{
			 var fieldAuditReaudit = document.getElementById(fieldName);
			 var FieldValue=fieldAuditReaudit.value;
			 var fieldbtnAudit = document.getElementById("btnAudits");
			 if(FieldValue=="Yes")
			 {
				  fieldbtnAudit.disabled = false;
			 }
			else
			{
				  fieldbtnAudit.disabled = true;
			}
		}

		function setLabelsAsMandOrNonMand(labelName, mand){
			var labels = document.getElementsByTagName("label");
			var noOfLabels = labels.length;	
			for (var index = 0; index < noOfLabels; index++) {
				var label = labels[index];		
				if((label.htmlFor == labelName) && (mand == true)) {
					label.className = 'labelRequired';
				}
				if((label.htmlFor == labelName) && (mand == false)){
					label.className = 'label';
				}					
			}	
		 }
		 
		function disableField(fieldId, clearValue) {
		    
		    document.getElementById(fieldId).disabled=true;
		    document.getElementById(fieldId).value='';
		}

		function enableField(fieldId) {
		    
		    document.getElementById(fieldId).disabled=false;
		}

	//Function To Activate and Deactivate Audit No Follow-Up Rationale fields
	function checkFollowUpRequired()
		{
			 var fieldAuditFollowUpRequired = document.getElementById("AuditFollowUpRequiredId").value;	 
			  //var fieldAuditFollowUpRequired = emxFormGetValue("Audit Follow-Up Required");
						
			 //var FieldValue = fieldAuditFollowUpRequired.current.actual;
			 if(fieldAuditFollowUpRequired!=null && fieldAuditFollowUpRequired=="Yes")
			 {
				emxFormSetValue("AuditNoFollowUpRationale","","");
					
			    emxFormDisableField("AuditNoFollowUpRationale",false);
			    emxFormDisableField("AuditPlannedFollowUpDate",true);
			    emxFormDisableField("AuditResolutionAssignedTo",true);
			    emxFormDisableField("AuditFollowUpThroughReAudit",true);
			    emxFormDisableField("AuditReAudit", true);
			    
			    document.getElementById("calc_AuditPlannedFollowUpDate").firstChild.className += " labelRequired";
				document.getElementById("calc_AuditResolutionAssignedTo").cells[0].className += " labelRequired";
				document.getElementById("calc_AuditFollowUpThroughReAudit").firstChild.className += " labelRequired";
			    
				var labelClass = document.getElementById("calc_AuditNoFollowUpRationale").firstChild.className;
				document.getElementById("calc_AuditNoFollowUpRationale").firstChild.className = labelClass.replace("labelRequired","");
			  	
			 }
			else
			{
				emxFormSetValue("AuditFollowUpThroughReAuditId","","");
			    emxFormSetValue("AuditPlannedFollowUpDate","","");
			    emxFormSetValue("AuditFollowUpThroughReAudit","","");
			    emxFormSetValue("AuditReAudit","","");
			    emxFormSetValue("AuditResolutionAssignedTo","","");
			    
			    
			   	emxFormDisableField("AuditNoFollowUpRationale",true);				    
			   	emxFormDisableField("AuditPlannedFollowUpDate",false);				    
			   	emxFormDisableField("AuditFollowUpThroughReAudit",false);				    
			   	emxFormDisableField("AuditResolutionAssignedTo",false);
			   	emxFormDisableField("AuditReAudit", false);
			   	
			   	var label_AuditNoFollowUpRationale = document.getElementById("calc_AuditNoFollowUpRationale").firstChild.className;
			   	if(!label_AuditNoFollowUpRationale.includes("labelRequired")){
			   		document.getElementById("calc_AuditNoFollowUpRationale").firstChild.className += " labelRequired";   
			   	}
			   	
			   
				var labelClass;
			    
			  	labelClass = document.getElementById("calc_AuditPlannedFollowUpDate").firstChild.className;
			    document.getElementById("calc_AuditPlannedFollowUpDate").firstChild.className = labelClass.replace("labelRequired","");
			    
			    labelClass = document.getElementById("calc_AuditResolutionAssignedTo").cells[0].className;
			    document.getElementById("calc_AuditResolutionAssignedTo").cells[0].className = labelClass.replace("labelRequired","");
			    
			    labelClass = document.getElementById("calc_AuditFollowUpThroughReAudit").firstChild.className;
			    document.getElementById("calc_AuditFollowUpThroughReAudit").firstChild.className = labelClass.replace("labelRequired","");
			    
			}
		}

	function addRegulatoryRequirement()
	{
		  var countField = document.getElementById("count");

		  var count = eval(countField.value);

		  //increment counter
		  count = eval(count) + 1;
		  var anchorDiv = document.getElementById("Audit Regulatory Requirements");
		  var divIdName = "RR_"+count+"_Div";

		  var newdiv = document.createElement("DIV");
		  newdiv.setAttribute("id", divIdName);

		  var sAdHoc = '';
		  sAdHoc += '<table width="100%">';
		  sAdHoc += '<tr>';

		  sAdHoc += '<td class="inputfield">';

		  sAdHoc += '<select name="Type' + count ;
		  sAdHoc +=	 '" >';
		  sAdHoc +='<option value ="" >  </option>';
		  sAdHoc +='<option value ="Policy" > Policy </option>';
		  sAdHoc +='<option value ="Procedure" > Procedure </option>';
		  sAdHoc +='<option value ="Standard" > Standard </option>';
		  sAdHoc +='<option value ="Law or Regulation" > Law or Regulation </option>';
		  sAdHoc +='<option value ="Contractual Requirement" > Contractual Requirement </option>';
		  sAdHoc +='<option value ="Codes of Conduct" > Codes of Conduct </option>';
		  sAdHoc +='<option value ="Other" > Other </option>';

		  sAdHoc += '</select>';
		  sAdHoc += '</td>';

		  sAdHoc += '<td class="inputfield">';
		  sAdHoc += '<input type="text" width = 33%  name="Name' + count ;
		  sAdHoc += '" value="">';
		  sAdHoc += '</td>';

		  sAdHoc += '<td class="inputfield">';
		  sAdHoc += '<input type="text" width = 33% name="Reference' + count ;
		  sAdHoc += '" value="">';
		  sAdHoc += '</td>';
		  /*XSS OK*/ sAdHoc += '<td class="labelRequired"><input type=button  value="<%=getEncodedI18String(context,"LQIAudit.Button.Remove")%>"';
		  sAdHoc += 'OnClick="removeDiv(\''+divIdName+'\');">';
		  sAdHoc += '</td>';
		  sAdHoc += '</tr></table>';

		  newdiv.innerHTML = sAdHoc;
		  anchorDiv.appendChild(newdiv);

		  countField.value = count;
	}

	function removeDiv(divToRemoveName)
	{
		var divToRemove = document.getElementById(divToRemoveName);
		//Set the inner html to blank to remove all the input fields
		divToRemove.innerHTML= "";
		//divToRemove.removeNode(); //not working for firefox
		divToRemove.parentNode.removeChild(divToRemove);
	}

	//Method to check blank values for "Audit Regulatory Requirements" field
	function regulatoryFieldCheck()
	{
		var boo = true;
		var countField = document.getElementById("count");
		var count = eval(countField.value);
		for(var i=1; i<=count; i++)
		{
			//check whether the div is removed, if removed, do nothing.
			if(document.getElementsByName("Name"+i)[0] == undefined)
			{
			}
			else
			{
				var varRegulatoryName = document.getElementsByName("Name"+i)[0];
				var varRegulatoryRefernece = document.getElementsByName("Reference"+i)[0];
				var varRegulatoryType = document.getElementsByName("Type"+i)[0];
				
				var FieldNameTypeValue = varRegulatoryType.value;
				var FieldNameValue = varRegulatoryName.value;
				var FieldNamerefernceValue = varRegulatoryRefernece.value;
				//Give the alert messages if the Required fields are blank
		    	if(FieldNameTypeValue=="")
			 	{
		    		/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.TypeRegulatoryRequirements")%>");
					varRegulatoryType.focus();
					//return;
					boo = false;
					break;
			 	}
			 	else if(FieldNameValue=="")
			 	{
			 		/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.NameRegulatoryRequirements")%>");
					varRegulatoryName.focus();
					//return;
					boo = false;
					break;
			 	}
			 	else if(FieldNamerefernceValue=="")
			 	{
			 		/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.ReferenceRegulatoryRequirements")%>");
					varRegulatoryRefernece.focus();
					//return;
					boo = false;
					break;
			 	}
			}
		}
		return boo;
	}
//Function To Activate and Deactivate Audit Previous Finding Reference fields
	function checkRepeatFinding()
		{

			 var fieldAuditRepeatFinding = document.getElementById("Audit Repeat Finding");
			 var FieldValue = fieldAuditRepeatFinding.value;
			 var fieldAuditPreFindingRef = document.getElementsByName("Audit Previous Finding Reference")[0];
			 if(FieldValue=="No")
			 {
				  fieldAuditPreFindingRef.disabled = true;
			 }
			else
			{
				  fieldAuditPreFindingRef.disabled = false;

			}

		}

	function checkForDecimal(fieldName)
	{
		var varField = document.getElementsByName(fieldName)[0];
		var sQueryLimit = varField.value;

		if (!isNaN(sQueryLimit))
		{
			if(sQueryLimit.indexOf(".") != -1) {
				/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.NoDecimalValue")%>");
				varField.value="";
				varField.focus();
				return false;
			}
		}
		else
		{
			/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.OnlyNumericValue")%>");
			varField.value="";
			varField.focus();
			return false;
		}
		return true;
	}

	//Method to check blank values for "Scope" field
	function findingScopeFieldCheck()
	{
		var varCount = document.getElementById("SUB_Count");
		var varCountNo=varCount.value;
		var varScope;
		var varBlank=false;
		var ScopeArray = new Array();
		//Getting the Scope values
		for( h=1;h<=varCountNo;h++)
		{
		  varScope = document.getElementById("Audit Sub-System"+h);
		  ScopeArray[h]=varScope;

		}
		//Give the alert messages if the Required fields are blank
		for( j=1;j<ScopeArray.length;j++)
		{
		    if(ScopeArray[j].checked)
			 {
				varBlank=true;
			 }
		}
		//check for additional scope entered by user for Audit
		var additionalFinalScope = document.getElementsByName("Final_SUB_Audit Sub-System")[0];
		if(additionalFinalScope != undefined)
		{
			if(additionalFinalScope.value != "")
			{
				varBlank=true;
			}
		}

		if(varBlank==false)
		{
			/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.ScopevalueMessage")%>");
			 return false;
		}
		return true;
	}



//Method to check required value for  Follow-Up Required field
	function followUpRequiedCases()
		{
			 var fieldAuditFollowUpRequired = emxFormGetValue("AuditFollowUpRequired");
			 var fieldAuditPlannedDate = emxFormGetValue("AuditPlannedFollowUpDate");
			 var fieldAdtResolutionAssigned = emxFormGetValue("AuditResolutionAssignedTo");
			 var fieldAdtFollowUpReAudit = emxFormGetValue("AuditFollowUpThroughReAudit");
			 var fieldAdtNoFollowupRationale = emxFormGetValue("AuditNoFollowUpRationale");

			 if(fieldAuditFollowUpRequired.current.actual=="Yes")
			 {
				 //Give the alert messages if the Required fields are blank
				 if(fieldAuditPlannedDate.current.actual=="")
				 {
					 /*XSS OK*/ alert("<%=Helper.getI18NString(context,Helper.StringResource.AUDIT,"LQIAudit.Message.PlannedFollowUpDate")%>");
					 var auditPlannedFollowUpDate = document.getElementById("AuditPlannedFollowUpDate");
					 auditPlannedFollowUpDate.focus();
					 return false;
				 }
				 else if(fieldAdtResolutionAssigned.current.actual=="" || fieldAdtResolutionAssigned.current.actual==" ")
				 {
					 /*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.ResolutionAssignedTo")%>");
					 var auditFollowUpThroughReAuditId = document.getElementById("AuditFollowUpThroughReAuditId");
					 auditFollowUpThroughReAuditId.focus();
					 return false;
				 }
				 else if(fieldAdtFollowUpReAudit.current.actual=="")
				 {
					 /*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.FollowUpThroughReAudit")%>");
					 var fieldAdtFollowUpReAudit = document.getElementById("AuditFollowUpThroughReAuditId");
					 fieldAdtFollowUpReAudit.focus();
					 return false;
				 }
				 return true;
			}
			else
			{

				  if(fieldAdtNoFollowupRationale.current.actual=="")
			      {
					  /*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.NoFollowUpRationale")%>");
					  var auditNoFollowUpRationale = document.getElementById("AuditNoFollowUpRationale");
					  auditNoFollowUpRationale.focus();
					  return false;
			      }
			      return true;
		    }
		}

	//Function To Check Planned start Date must be greater than or equal to current date
	function validatePlannedStartDate()
		{
			var m_names = new Array("January", "February", "March",
                                   "April", "May", "June", "July", "August", "September",
                                    "October", "November", "December");
			var d = new Date();
            var curr_date = d.getDate();
            var curr_month = d.getMonth();
            var curr_year = d.getFullYear();
			//Making the current date.
			var date_Today=m_names[curr_month] + " " +curr_date + "," + curr_year;

			var fieldAuditPlannedStartDate = document.getElementById("Audit Planned Start Date");
			var StartDateValue = fieldAuditPlannedStartDate.value;
            var startDate = new Date(StartDateValue);
            var currentDate= new Date(date_Today);

			if(startDate<currentDate)
			{
				/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.PlannedStartDateValue")%>");
				fieldAuditPlannedStartDate.focus();
				return;
			}
			return true;
		}

	//Function To Check Planned End date Greater than Planned Start date
	function validatePlannedDateToEndDate()
		{
			var endDateFeild = document.getElementById("Audit Planned End Date");
			var endDateValue = endDateFeild.value;
	 	 	var endDate_msvalue = document.getElementsByName("Audit Planned End Date_msvalue")[0];
			var startDate_msvalue = document.getElementsByName("Audit Planned Start Date_msvalue")[0];
			var endDate = new Date();
			endDate.setTime(endDate_msvalue.value);
			endDate.setHours(0,0,0,0); 
            var startDate= new Date();
            startDate.setTime(startDate_msvalue.value);
            startDate.setHours(0,0,0,0); 
			if(endDateValue=="")
			{
				 return true;
			}
			else if(startDate>endDate)
			 {
				 /*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.PlannedEndDateValue")%>");
				 endDateFeild.focus();
				return false;
			 } 
			 return true;
	    }

	  //Function To Audit Repeat Finding value and manipulate Previous Finding Reference values
	  function checkRepeatFindingValue()
		{
			 var fieldAuditrepeatFinding = document.getElementById("Audit Repeat Finding");
			 var FieldValue = fieldAuditrepeatFinding.value;
			 var fieldAuditPreviousFindingRefrence = document.getElementsByName("Audit Previous Finding Reference")[0];
			 if(FieldValue=="Yes")
			 {
			     var FindingreferenceValueValue = fieldAuditPreviousFindingRefrence.value;
			  	 if(FindingreferenceValueValue=="")
			     {
			  		/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.PreviousFindingReferenceYes")%>");
					 fieldAuditPreviousFindingRefrence.focus();
					 return;
			     }
			 }
			 else
			{
					  fieldAuditPreviousFindingRefrence.disabled = true;
			}
			return true;
		}

	
	//method to check Supplier's name field
	function supplierNameFieldSpecialCharacterCheck()
	{
		var varName = document.getElementsByName("name")[0];
		var varNameValue=varName.value;
		var varLength=varNameValue.length;
		var flag=false;
		
		for(var i=0; i<varLength; i++)
		{
			if(varNameValue.charAt(i)=='\'')
				{
					flag=true;
					break;
				}
		}
		
		
		if(flag==true)
		{
			/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.supplierNameSpecialCharacter")%>");
			return false;
		}
		return true;
	}
	
	function checkSupplier() {
		var auditType = document.getElementsByName("Audit Type")[0];
		if(auditType.value == "Supplier") {
			var supplier = document.getElementsByName("SuppliersDisplay")[0];
			if(supplier.value.length == 0) {
				/*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.SupplierRequired")%>");
				supplier.focus();
				return false;
			}
		}
		return true;	
		}

	

	/* 
	 * This gets called from the form QICAUDAuditCreate
	 * when the audit template is selected or changed
	 */
	function auditTemplateChangeHandler() {
		
		var templateOID = document.getElementsByName("AuditTemplateOID")[0];
		if(templateOID.value==""){
			// The user removed the template so clear all values
			setValuesFromTemplate("","","","","","","","","");
			return;
		}else{
			// Make AJAX call to get the data we need
			var result = getAuditTemplateData(templateOID);	
			
			// Pull the various fields out of the data returned from the
			// AJAX call
    		var description = getResultValue(result,"description");
    		var auditType = getResultValue(result,"auditType");
    		var scope = getResultValue(result,"scope");
    		var auditExternalInfo = getResultValue(result,"auditExternalInfo");
    		var connectedLocation = getResultValue(result,"connectedLocation");
    		var connectedLocationID = getResultValue(result,"connectedLocationID");
    		var connectedSupplier = getResultValue(result,"connectedSupplier");
    		var connectedSupplierID = getResultValue(result,"connectedSupplierID");
    		var connectedAuditedItemsName = getResultValue(result,"connectedAuditedItemsName");
    		var connectAuditedItemsIds = getResultValue(result,"connectAuditedItemsIds");
    		
    		// Set all values
    		setValuesFromTemplate(description,auditType,scope,auditExternalInfo,connectedLocation,connectedLocationID,connectedSupplier,connectedSupplierID,connectedAuditedItemsName,connectAuditedItemsIds);
		}
   }
   
   /**
    * Called from auditTemplateChangeHandler() to either set
    * or clear various values related to the selected Audit Template
    */
   function setValuesFromTemplate(description,auditType,scope,auditExternalInfo,connectedLocation,connectedLocationID,connectedSupplier,connectedSupplierID,connectedAuditedItemsName,connectAuditedItemsIds) {
   		emxFormSetValue("description",description,description);
  
   		//set the value of Audit Type
   		var AuditType = document.getElementById("Audit Type");
		var AuditExternalInfo = document.getElementById("Audit External Info");
		AuditType.value=auditType;
	
		if("Other" == auditType)
		{
			var AuditExternalInfo = document.getElementById("Audit External Info");
			AuditExternalInfo.style.visibility = "visible";
			AuditExternalInfo.value = auditExternalInfo;
		}
	
		emxFormSetValue("Suppliers",connectedSupplierID,connectedSupplier);
		emxFormSetValue("Audit Location",connectedLocationID,connectedLocation);
		emxFormSetValue("Audit Device",connectAuditedItemsIds,connectedAuditedItemsName);
		emxFormReloadField('Audit Device');

		checkAuditType();

		var scopeArray = new Array();
		//setting the value of Scope or SubSystem
		var subCount = document.getElementById("SUB_Count");
		var new_value = scope;

		scopeArray = new_value.split(",");
		var varScope = "";
		var bFlag = true;
		var sFormattedString = "";
		var SubSystem;
		
		// First clear all checkboxes so we start with a clean slate
		
		// clear any custom scopes that may have been added    
        while(true){
        	var customScope = document.getElementsByName("customScope")[0];
            if(customScope!=undefined){
					customScope.parentNode.removeChild(customScope);
			}else{
				break;
			}
        }
			
		//iterate through the available scopes from template and check the appropriate ones
		for (i=0; i < scopeArray.length; i++)
		{
			varScope = scopeArray[i] ; 
			for(var j=1; j <= subCount.value; j++) 
			{		
				var AuditSubSystem = "Audit Sub-System"+j;
				SubSystem = document.getElementById(AuditSubSystem);
				//if available, mark it as checked.
				if( varScope == SubSystem.value )
				{
					SubSystem.checked = "checked";
					bFlag = false;
					//if found break the loop;
					break;
				}
			}
		
			//if not found in the checked item list, means its a custom added scope.
			if(bFlag && varScope != "" && varScope.length > 0)
			{
				//create DIV HTML Text and add 
				var fieldName = "SUB_Audit Sub-System" ;
				var count = document.getElementById("count_"+fieldName);
				numOfAuditors = eval(count.value);
				var anchorDiv = document.getElementById("anchorDiv_"+fieldName);
				var divIdName = "Auditor_"+numOfAuditors+"_Div_"+fieldName;
				var newdiv = document.createElement("DIV");
				newdiv.setAttribute("id",divIdName);
				newdiv.setAttribute("name", "customScope");
		
				var sHTML = '&nbsp;';
				sHTML += '<img src="images/iconSmallPerson.gif" alt="" name="'+varScope+'"/>';
				sHTML += '&nbsp;'+ varScope;
				sHTML += '&nbsp;<a href="javascript:;" onclick="removeAuditor(\''+divIdName+'\',\''+fieldName+'\');">Remove</a>';
				newdiv.innerHTML = sHTML;
				anchorDiv.appendChild(newdiv);
				
				numOfAuditors++;
				count.value = numOfAuditors;
				
				//format if there are multiple values
				if(sFormattedString == ""){
					sFormattedString = varScope ;
				}else{
					sFormattedString = sFormattedString + "," + varScope ;
				}
			}
			bFlag = true;
		}
		
		//update final variable to hold the values for saving purpose
		if(sFormattedString != null && sFormattedString != "" && sFormattedString.length > 0)
		{
			var formattedAuditors = document.getElementsByName("Final_"+fieldName)[0];
			formattedAuditors.value = sFormattedString;
			//assign value to have old value updated to the field.
			var varOldVal = document.getElementById("ARR_"+fieldName);
			varOldVal.value = sFormattedString;
		}
	}
	
	// Helper routine to find a parameter in a map.
	function getResultValue(result,key){
		for(var i = 0; i < result.length; i++) {
			if(result[i].text==key){
				return result[i].value;
			}
    	}
    	// did not find it so return nothing.
    	return "";
	}
	
	function auditRequestTemplateChangeHandler(){
		var templateOID = document.getElementsByName("AuditRequestTemplateOID")[0].defaultValue;
		
		if(templateOID==""){
			// The user removed the template so clear all values
    		setValuesFromAuditRequestTemplate("","","");
			return;
		}else{
			// Make AJAX call to get the data we need
			var result = getAuditRequestTemplateData(templateOID);	
			
			// Pull the various fields out of the data returned from the
			// AJAX call
    		var description = getResultValue(result,"description");
    		var scope = getResultValue(result,"scope");
    		var auditFunctionArea = getResultValue(result,"Audit Functional Area");
    		// Set all values
    		setValuesFromAuditRequestTemplate(description,scope,auditFunctionArea);
		}
	}
	
	function getAuditRequestTemplateData(auditRequestTemplateId){
		var queryString="&ajaxMode=true&suiteKey=LQIAudit&auditRequestTemplateId="+auditRequestTemplateId; //XSSOK
		var response = emxUICore.getDataPost("../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.audit.services.ui.AuditRequestTemplate:getAuditRequestsTemplateInformationAjax",queryString);
		var jsObject = eval('(' + response + ')');
	    var result = jsObject.result;
		return result;
		
	}
	
	function setValuesFromAuditRequestTemplate(description,scope,auditFunctionArea){
   		emxFormSetValue("description",description,description);
   		
   		var Scope = document.getElementById("Audit Sub-SystemId");
   		Scope.value=scope;
   		
   		var AuditFunctionArea = document.getElementById("Audit Functional AreaId");
   		AuditFunctionArea.value = auditFunctionArea;
	}
	
	
	function createAuditFromContextAuditRequestPreProcess(){
		checkAuditTypeAndIsReAudit();
		
		var contextRequestId = emxUICore.getContextId(false);
	    var requestObjectIds = new Array();
	    requestObjectIds.push(contextRequestId);
		var result = getAuditRequestsData(requestObjectIds);
		var description = getResultValue(result,"description");
		var scope = getResultValue(result,"scope");
		setValuesFromAuditRequest(description,scope);
	}
	
	function createAuditFromAuditRequestPreProcess(){
		checkAuditTypeAndIsReAudit();
		
	    var sourceFrame = findFrame(getTopWindow(), "QICAUDAuditRequests");
	    var checkedItem = sourceFrame.getCheckedCheckboxes();
	    var requestObjectIds = new Array();
		for (var e in checkedItem){
			var aId = e.split("|");
			var objId  = aId[1];
			requestObjectIds.push(objId);
		}
		var result = getAuditRequestsData(requestObjectIds);
		var description = getResultValue(result,"description");
		var scope = getResultValue(result,"scope");
		setValuesFromAuditRequest(description,scope);
	}
	
	function setValuesFromAuditRequest(description,scope){
   		emxFormSetValue("description",description,description);
   		
   		var scopeArray = new Array();
		//setting the value of Scope or SubSystem
		var subCount = document.getElementById("SUB_Count");
		var new_value = scope;

		scopeArray = new_value.split(",");
		var varScope = "";
		var bFlag = true;
		var sFormattedString = "";
		var SubSystem;
		
		// First clear all checkboxes so we start with a clean slate
		
		// clear any custom scopes that may have been added    
        while(true){
        	var customScope = document.getElementsByName("customScope")[0];
            if(customScope!=undefined){
					customScope.parentNode.removeChild(customScope);
			}else{
				break;
			}
        }
			
		//iterate through the available scopes from template and check the appropriate ones
		for (i=0; i < scopeArray.length; i++)
		{
			varScope = scopeArray[i] ; 
			for(var j=1; j <= subCount.value; j++) 
			{		
				var AuditSubSystem = "Audit Sub-System"+j;
				SubSystem = document.getElementById(AuditSubSystem);
				//if available, mark it as checked.
				if( varScope == SubSystem.value )
				{
					SubSystem.checked = "checked";
					bFlag = false;
					//if found break the loop;
					break;
				}
			}
		
			//if not found in the checked item list, means its a custom added scope.
			if(bFlag && varScope != "" && varScope.length > 0)
			{
				//create DIV HTML Text and add 
				var fieldName = "SUB_Audit Sub-System" ;
				var count = document.getElementById("count_"+fieldName);
				numOfAuditors = eval(count.value);
				var anchorDiv = document.getElementById("anchorDiv_"+fieldName);
				var divIdName = "Auditor_"+numOfAuditors+"_Div_"+fieldName;
				var newdiv = document.createElement("DIV");
				newdiv.setAttribute("id",divIdName);
				newdiv.setAttribute("name", "customScope");
		
				var sHTML = '&nbsp;';
				sHTML += '<img src="images/iconSmallPerson.gif" alt="" name="'+varScope+'"/>';
				sHTML += '&nbsp;'+ varScope;
				sHTML += '&nbsp;<a href="javascript:;" onclick="removeAuditor(\''+divIdName+'\',\''+fieldName+'\');">Remove</a>';
				newdiv.innerHTML = sHTML;
				anchorDiv.appendChild(newdiv);
				
				numOfAuditors++;
				count.value = numOfAuditors;
				
				//format if there are multiple values
				if(sFormattedString == ""){
					sFormattedString = varScope ;
				}else{
					sFormattedString = sFormattedString + "," + varScope ;
				}
			}
			bFlag = true;
		}

	}
	
	function getAuditRequestsData(requestObjectIds){
		var queryString="&ajaxMode=true&suiteKey=LQIAudit&requestObjectIds="+requestObjectIds; //XSSOK
		var response = emxUICore.getDataPost("../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.audit.services.ui.AuditRequest:getAuditRequestsInformationAjax",queryString);
		var jsObject = eval('(' + response + ')');
	    var result = jsObject.result;
		return result;
	}
	
	// routine to make a AJAX style call to com.dassault_systemes.enovia.lsa.audit.services.ui.AuditAuditTemplate.getTemplateInformationAjax()
	// template parameters. 
	function getAuditTemplateData(templateOID){
		var queryString="&ajaxMode=true&suiteKey=LQIAudit&templateOID="+templateOID.defaultValue; //XSSOK
		var response = emxUICore.getDataPost("../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.audit.services.ui.AuditAuditTemplate:getTemplateInformationAjax",queryString);
		var jsObject = eval('(' + response + ')');
	    var result = jsObject.result;
		return result;
	}
	
	function validateFieldDateVerified() 
	{
		var dateVerifiedStr=document.getElementById("Audit Date Verified").value;
		var dateVerified_msvalue = document.getElementsByName("Audit Date Verified_msvalue")[0];
		var dateVerified = new Date();
		dateVerified.setTime(dateVerified_msvalue.value);
		dateVerified.setHours(0,0,0,0); 
		var todayDate = new Date();
 		todayDate.setHours(0,0,0,0); 
 		if(dateVerifiedStr=="")
		{
			 return true;
		}
 		else if (dateVerified>todayDate)
	      { 
			 /*XSS OK*/ alert("<%=getEncodedI18String(context,"LQIAudit.Message.InvalidDate.DateVerified")%>");
	        return false;
	      }
		 return true;
	}
	
</script>
</html>
