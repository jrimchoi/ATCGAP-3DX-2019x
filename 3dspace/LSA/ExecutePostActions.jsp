<%@page import="com.matrixone.apps.domain.util.i18nNow"%>
<%
   final String STRING_RESOURCE = "LSACommonFrameworkStringResource";
   final String LANGUAGE = request.getHeader("Accept-Language");
   final i18nNow i18 = new i18nNow();
%>
<script type="text/javascript" language="javascript">
	function refreshTablePage() {
		getTopWindow().refreshTablePage();
	}

	function refreshRelatedItemsSBAfterAddingItem() {
		if(getTopWindow().getWindowOpener()) {
			getTopWindow().getWindowOpener().refreshTablePage();
			getTopWindow().closeWindow();
		}
	}	
    
    function refreshRelatedItemsSBAfterRemovingItem() {
        var detailsDisplayFrame = findFrame(getTopWindow(), "detailsDisplay");
        detailsDisplayFrame.location.href = detailsDisplayFrame.location.href;
    }
    
    function showSearchPageForRelatedItems(parentId) {
        var submitURL = encodeURI("../LPI/Execute.jsp?action=emxRelatedItemsUI:actionAddRelatedItems");
        var strURL = "../common/emxFullSearch.jsp?excludeOIDprogram=emxRelatedItemsUI:getRelatedItemsToExclude&table=AEFGeneralSearchResults&selection=multiple&relName=relationship_RelatedItems&hideToolbar=true&hideHeader=true&hideToolbar=true&direction=from&parentId="+parentId+"&submitAction=refreshCaller&submitURL="+submitURL;
        showModalDialog(strURL, 600, 700,true);
    }
    
    function setParentSBCellForResponsibleUserAndCloseSearch(formName,fieldDisplayName,fieldActualName,fieldDisplayValue,fieldActualValue) {
        var detailsDisplayFrame = findFrame(getTopWindow().getWindowOpener().getTopWindow(), "PLCProductMyDesk");
     /* var formObj = eval(detailsDisplayFrame + "." + formName); */
		var formObj = detailsDisplayFrame.document.forms[formName];
        if (formObj) {
            var fieldDisplay = formObj.elements[fieldDisplayName];
            var fieldActual  = formObj.elements[fieldActualName];
            
            if (fieldDisplay && fieldActual) {
                fieldDisplay.value = fieldDisplayValue;
                fieldActual.value = fieldActualValue;
            }
            else {
                throw ("Failed to get reference for fields '" + fieldDisplayName + "' and/or '" + fieldActualName + "'.");
            }
        }
        else {
            throw ("Failed to get reference for the form '" + formName + "'");
        }
        
        getTopWindow().close();
    }
    
    
    function alertSelectOnlyTasksForSyncDHFContents() {
        var message = "<%=i18.GetString(STRING_RESOURCE, LANGUAGE, "emxLPI.Command.LPISyncDHFContents.SelectOnlyTasks")%>";
        alert(message);
    }
    
    function alertSuccessfullySyncedDHFContents() {
        var message = "<%=i18.GetString(STRING_RESOURCE, LANGUAGE, "emxLPI.Command.LPISyncDHFContents.SuccessMessage")%>";
        alert(message);
    }
    
    function alertNonDHFTaskSelectedForSync(tasks) {
    	 var message = "<%=i18.GetString(STRING_RESOURCE, LANGUAGE, "emxLPI.Command.LPISyncDHFContents.NonDHFTasks")%>\n"+tasks+"\n<%=i18.GetString(STRING_RESOURCE, LANGUAGE, "emxLPI.Command.LPISyncDHFContents.ReviewSelection")%>\n";
         alert(message);
    }
    
    function alertNoDHFFolderForDHFTask(elements, tasks) {
    	 var message = elements+" <%=i18.GetString(STRING_RESOURCE, LANGUAGE, "emxLPI.Command.LPISyncDHFContents.NoDHFFolders")%>\n"+tasks+"\n<%=i18.GetString(STRING_RESOURCE, LANGUAGE, "emxLPI.Command.LPISyncDHFContents.ReviewSelection")%>\n";
         alert(message);
    }
    
    function alertNoDHFTaskAndNoDHFFolderForDHFTask(nonDHFTasks,elements,tasks) {
   	 var message = "<%=i18.GetString(STRING_RESOURCE, LANGUAGE, "emxLPI.Command.LPISyncDHFContents.NonDHFTasks")%>\n"+nonDHFTasks+"\n"+elements+" <%=i18.GetString(STRING_RESOURCE, LANGUAGE, "emxLPI.Command.LPISyncDHFContents.NoDHFFolders")%>\n"+tasks+"\n<%=i18.GetString(STRING_RESOURCE, LANGUAGE, "emxLPI.Command.LPISyncDHFContents.ReviewSelection")%>\n";
        alert(message);
   }
    
    function setQualityControlManagerRole(formName,fieldDisplayName,fieldActualName,roleRegisteredValue) {
       	var submitURL = encodeURI("../LPI/Execute.jsp?action=emxDHFClassificationUI:actionUpdateResponsibleUser&fieldNameDisplay="+fieldDisplayName+"&fieldNameActual="+fieldActualName+"&formName="+formName);
        var strURL = "../common/emxFullSearch.jsp?field=TYPES=type_Person:CURRENT=state_Active:USERROLE="+roleRegisteredValue+"&table=AEFGeneralSearchResults&showInitialResults=false&selection=single&submitAction=refreshCaller&hideHeader=true&mode=Chooser&submitURL="+submitURL;
        
        getTopWindow().location.href = strURL;
    }
    
    function addPatientToEvents(objectIds) {
    	window.parent.location.href="..common/emxCreate.jsp?form=CreatePatient&type=type_Patient&nameField=autoName&submitAction=refreshCaller&mode=create&relationship=relationship_ComplaintEventPatient&direction=To&targetLocation=slide&objectId="+objectIds;
    }
    
    function refreshRelatedItemsProducts() {
        var detailsDisplayFrame = findFrame(getTopWindow(), "LSACorrespondenceProducts");
        detailsDisplayFrame.location.href = detailsDisplayFrame.location.href;
        getTopWindow().close();
    }

</script>
