<%@include file="../common/emxNavigatorInclude.inc"%>
<%@page import="com.dassault_systemes.enovia.lsa.Helper"%>
<%@page import="matrix.db.Context"%>
<%@page import="matrix.util.StringList"%>
<%@page import="com.dassault_systemes.enovia.lsa.LSAException"%>
<%@page import="com.matrixone.apps.domain.util.XSSUtil"%>

<%!
   private String getString(Context context, String key) throws LSAException {
		try {
			return XSSUtil.encodeForJavaScript(context, Helper.getI18NString(context, Helper.StringResource.LSA, key));
		} catch (Exception e) {
			throw new LSAException(e);
		}
	}
   
%>
<script type="text/javascript" language="javascript">

	function refreshRelatedItemsSBAfterAddingItem() {
		var relatedItemsFrame = findFrame(getTopWindow().getWindowOpener().getTopWindow(), "LSACategoryRelatedItems");
		if(relatedItemsFrame==null || relatedItemsFrame =='undefined'){
	   		relatedItemsFrame= findFrame(getTopWindow().getWindowOpener().getTopWindow(), "detailsDisplay");
		}
		if(relatedItemsFrame==null || relatedItemsFrame =='undefined'){
	   		relatedItemsFrame= findFrame(getTopWindow().getWindowOpener().getTopWindow(), "content");
		}
		if(relatedItemsFrame.editableTable){
		    relatedItemsFrame.editableTable.loadData();
		    relatedItemsFrame.RefreshTableHeaders();
	    	relatedItemsFrame.rebuildView();
		}else{
	    	relatedItemsFrame.location.href = relatedItemsFrame.location.href;
		}
		getTopWindow().closeWindow();
	}	
	
	function refreshRelatedItemsSBAfterRemovingItem() {
	    var relatedItemsFrame = findFrame(getTopWindow(), "LSACategoryRelatedItems");
	    if(relatedItemsFrame==null || relatedItemsFrame =='undefined'){
			   relatedItemsFrame= findFrame(getTopWindow(), "detailsDisplay");
		}
	    if(relatedItemsFrame==null || relatedItemsFrame =='undefined'){
		   	relatedItemsFrame= findFrame(getTopWindow(), "content");
		}
	    relatedItemsFrame.location.href = relatedItemsFrame.location.href;
	}	
	function showSearchPageForRelatedItems(parentId) {
		var submitURL = encodeURI("../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.services.ui.RelatedItems:actionAddRelatedItems&suiteKey=LSACommonFramework");
	   	var strURL = "../common/emxFullSearch.jsp?excludeOIDprogram=com.dassault_systemes.enovia.lsa.services.ui.RelatedItems:getRelatedItemsToExclude&table=AEFGeneralSearchResults&selection=multiple&relName=relationship_RelatedItems&hideToolbar=true&hideHeader=true&direction=from&showInitialResults=true&parentId="+parentId+"&submitAction=refreshCaller&addPreCondParam=false&submitURL="+submitURL;
	    showModalDialog(strURL, 600, 700,true);
	}	
    function addPatientToEvents(objectIds) {
    	window.parent.location.href="..common/emxCreate.jsp?form=CreatePatient&type=type_Patient&nameField=autoName&submitAction=refreshCaller&mode=create&relationship=relationship_ComplaintEventPatient&direction=To&targetLocation=slide&objectId="+objectIds;
    }
    
	/**
	 * Alerts for Contacts
	 */
	function alertContactsSuccessfullyDeleted() {
		var message = "<%=getString(context, "LSACommonFramework.Message.ContactsSuccessfullyDeleted")%>"; //XSSOK
        alert(message);
        window.parent.location.href = window.parent.location.href;
	}
	
	function alertObjectsSuccessfullyDeleted() {
		var message = "<%=getString(context, "LSACommonFramework.Message.SuccessfullyDeleted")%>"; //XSSOK
        alert(message);
        window.parent.location.href = window.parent.location.href;
	}
	function removeAndRefreshPage() {
    	window.parent.location.href = window.parent.location.href;
	}

	function addAndRefreshPage() {
		
		var detailsDisplayFrame = findFrame(getTopWindow(), "LSAContacts");
		if (detailsDisplayFrame == null) {
			detailsDisplayFrame = findFrame(getTopWindow().getWindowOpener().getTopWindow(), "LSAContacts");
		}

		if (detailsDisplayFrame == null) {
			detailsDisplayFrame = findFrame(getTopWindow().getWindowOpener().getTopWindow(), "detailsDisplay");
		}
		detailsDisplayFrame.location.href = detailsDisplayFrame.location.href;
		if(getTopWindow().opener) {
			getTopWindow().close();
		}		
	}
	 
	function setStructureBrowserCellValue(fieldName , actualValue, displayValue) {
        var targetWindow = null;
        if(getTopWindow().getWindowOpener() == null) {
            	targetWindow = window.parent;
        } else {
            targetWindow = getTopWindow().getWindowOpener();
        }
        var fieldNameDisplay = fieldName.split("_")[0];
        fieldNameDisplay = fieldNameDisplay+"Display";
        
    	var vfieldNameActual = targetWindow.document.forms[0][fieldName];
		var vfieldNameDisplay = targetWindow.document.forms[0][fieldNameDisplay];
		var vfieldNameOID = targetWindow.document.forms[0][fieldName + "OID"];

		if (vfieldNameActual==null && vfieldNameDisplay==null) {
			vfieldNameActual=targetWindow.document.getElementById(fieldName);
			vfieldNameDisplay=targetWindow.document.getElementById(fieldNameDisplay);
			vfieldNameOID=targetWindow.document.getElementById(fieldName + "OID");
		}

		if (vfieldNameActual==null && vfieldNameDisplay==null) {
			vfieldNameActual=targetWindow.document.getElementsByName(fieldName)[0];
			vfieldNameDisplay=targetWindow.document.getElementsByName(fieldNameDisplay)[0];
			vfieldNameOID=targetWindow.document.getElementsByName(fieldName + "OID")[0];
		}

		/*
		   FIX IR-088125V6R2012 
		   In IE8, for some use-cases, getElementsByName doesn't work when 
		   accessing URL with its full name. Below code address the issue.
		 */
		if (vfieldNameActual==null && vfieldNameDisplay==null) {
		     var elem = targetWindow.document.getElementsByTagName("input");
		     var att;
		     var iarr;
		     for(i = 0,iarr = 0; i < elem.length; i++) {
		        att = elem[i].getAttribute("name");
		        if(fieldNameDisplay == att) {
		            vfieldNameDisplay = elem[i];
		            iarr++;
		        }
		        if(fieldName == att) {
		            vfieldNameActual = elem[i];
		            iarr++;
		        }
		        if(iarr == 2) {
		            break;
		        }
		    }
		}

		vfieldNameDisplay.value = displayValue;
		vfieldNameActual.value = actualValue;

		if(vfieldNameOID != null) {
			vfieldNameOID.value = actualValue;
		} 

		if(getTopWindow().getWindowOpener()) {
			getTopWindow().closeWindow();
		}
    }
	
	function showHTMLReport(strHTML,pdfPath,htmlPath,emailSubject,strObjectId) {
		var html = document.documentElement;
		var newHead = document.createElement("head");
		var newTitle = document.createElement("title");
		newTitle.appendChild(document.createTextNode("Summary Report"));
		html.replaceChild(newHead, html.childNodes[0]);
		window.document.write(strHTML);
		<%
		String servletPath = request.getContextPath();
		%>
		var form = document.createElement("form");
		form.setAttribute("name", "pdfReportForm");
	    form.setAttribute("method", "POST");
	    var contextPath = "<%=servletPath%>";
		form.setAttribute("action", contextPath+"/SummaryReportServlet");
		
	    var input = createHiddenInputElement(pdfPath,"pdfReport");
		form.appendChild(input);
		input = createHiddenInputElement(htmlPath,"htmlReport");
		form.appendChild(input);
		input = createHiddenInputElement("-","ReportType");
	    form.appendChild(input);
	    input = createHiddenInputElement(contextPath,"contextPath");
	    form.appendChild(input);
	    input = createHiddenInputElement(emailSubject,"EmailSubject");
	    form.appendChild(input);
	    input = createHiddenInputElement(strObjectId,"ObjectId");
	    form.appendChild(input);
		document.body.appendChild(form);
		
		
	}
	function createHiddenInputElement(value,id){
		 var input = document.createElement("input");
			input.setAttribute("id", id);
			input.setAttribute("name", id);
			input.setAttribute("type", "hidden");
			input.setAttribute("value", value);
			return input;
	}
	 
	 function addRelatedItems(typeList,includeOIDprogram,excludeOIDprogram, objectId) {
		 	var url = "../common/emxFullSearch.jsp?";
		 	if(typeList != null && typeList != "") {
		 		url += "field=TYPES=" + typeList;
		 	}
		 	if(excludeOIDprogram != null && excludeOIDprogram != "") {
		 		url += "&excludeOIDprogram="+excludeOIDprogram;
		 	}
		 	if(includeOIDprogram != null && includeOIDprogram != "") {
		 		url += "&includeOIDprogram="+includeOIDprogram;
		 	}
		 	url += "&table=AEFGeneralSearchResults&selection=multiple&showSavedQuery=True&searchCollectionEnabled=True&submitURL=../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.services.ui.Correspondence:connectCorrespondenceRelatedContextObject&suiteKey=LSACommonFramework&selection=none&mode=AddExisting&showInitialResults=true&objectId="+objectId;
			window.parent.location.href= url;
		}

    function refreshFrame(framename) {
        var detailsDisplayFrame= findFrame(getTopWindow(), framename);
        if(detailsDisplayFrame==null)
            var detailsDisplayFrame = findFrame(getTopWindow(), "detailsDisplay");
        if(detailsDisplayFrame==null)
            window.parent.location.href = window.parent.location.href;
        else
            detailsDisplayFrame.location.href = detailsDisplayFrame.location.href;
    }

	function setCellForPartAndCloseSearch(formName, fieldDisplayName,fieldActualName, fieldDisplayValue, fieldActualValue) {
		var formObj = null, closeSearch = false;
		var frameObj = findFrame(getTopWindow(),'LSAProductProperties');
		if(frameObj == null || frameObj == undefined)
		{
			frameObj = findFrame(getTopWindow().getWindowOpener().getTopWindow(),'LSAProductProperties');
			closeSearch=true;
		}

		formObj = frameObj.document.forms[0];

		if (formObj != null) {
			var fieldDisplay = formObj.elements[fieldDisplayName];
			var fieldActual = formObj.elements[fieldActualName];

			if (fieldDisplay && fieldActual) {
				fieldDisplay.value = fieldDisplayValue;
				fieldActual.value = fieldActualValue;
			}
		}
		if(closeSearch == true)
		{
			getTopWindow().closeWindow();
		}
		
	}


</script>
