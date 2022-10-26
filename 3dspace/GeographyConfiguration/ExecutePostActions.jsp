<%@include file="../common/emxNavigatorInclude.inc"%>
<%@page import="matrix.db.Context"%>
<%@page import="matrix.util.StringList"%>
<%@page import="com.dassault_systemes.enovia.geographyconfiguration.Helper"%>
<%@page import="com.dassault_systemes.enovia.geographyconfiguration.GeographyConfigurationException"%>
<%!
/**
	 *  This method is to return the String resource property for the specified key
	 *
	 * @param context Enovia context Object
	 * @param key Key for the string resource lookup
	 * @return keyValue the value for the key in the string resource file
	 */
	private String getString(Context context, String key) throws GeographyConfigurationException {
		try {
			return Helper.getI18NString(context, key);
		}
		catch (Exception e) {
			throw new GeographyConfigurationException(e);
		}
	}
%>

<script type="text/javascript" language="javascript">
	/**
	 * Alerts for Geography configuration and support
	 */
	function alertPleaseSelectRegionsOnly () {
/*XSSOK*/	alert("<%=getString(context, "GeographyConfiguration.Message.PleaseSelectRegionsOnly")%>");
	}

	function alertPleaseSelectCountriesOnly() {
/*XSSOK*/	alert("<%=getString(context, "GeographyConfiguration.Message.PleaseSelectCountriesOnly")%>");
	}

	function alertPleaseSelectAtLeastOneRegion() {
/*XSSOK*/   alert("<%=getString(context, "GeographyConfiguration.Message.PleaseSelectAtLeastOneRegion")%>");
	}
	
	function alertPleaseSelectAtLeastOneCountry() {
/*XSSOK*/	alert("<%=getString(context, "GeographyConfiguration.Message.PleaseSelectAtLeastOneCountry")%>");
	}

	function alertPleaseSelectLanguagesOnly() {
/*XSSOK*/	alert("<%=getString(context, "GeographyConfiguration.Message.PleaseSelectLanguagesOnly")%>");
	}

	function alertPleaseSelectAtLeastOneLanguage() {
/*XSSOK*/		alert("<%=getString(context, "GeographyConfiguration.Message.PleaseSelectAtLeastOneLanguage")%>");
	}

	function alertPleaseSelectCountriesOrLanguagesOnly() {
/*XSSOK*/		alert("<%=getString(context, "GeographyConfiguration.Message.PleaseSelectCountriesOrLanguagesOnly")%>");
	}

	function alertPleaseSelectAtLeastOneRegionCountry(){
/*XSSOK*/		alert("<%=getString(context, "GeographyConfiguration.Message.PleaseSelectAtLeastOneRegionOrCountry")%>");
	}
	
	function alertCountryAlreadyAddedToRegion(){
/*XSSOK*/		alert("<%=getString(context, "GeographyConfiguration.Message.CountryAlreadyAddedToRegion")%>");
	}
	
	function alertLanguageAlreadyAddedToRegion(){
/*XSSOK*/		alert("<%=getString(context, "GeographyConfiguration.Message.LanguageAlreadyAddedToRegion")%>");
	}
	
	function alertLanguageAlreadyAddedToCountry(){
/*XSSOK*/		alert("<%=getString(context, "GeographyConfiguration.Message.LanguageAlreadyAddedToCountry")%>");
	}

	function alertRegionAlreadyExists(){
/*XSSOK*/		alert("<%=getString(context, "GeographyConfiguration.Message.RegionAlreadyExists")%>");
	}

	/**
     * Function to obtain Region ids for Regions frame, for adding Countries to them using Execute.jsp elements, adding a new input element
     */
	function getRegionsForCountries() {
		var frameObject = findFrame(window.parent.parent,"GEORegions");
		var emxTableRowIds = frameObject.getCheckedCheckboxes();
		var formObj = document.forwardForm;
		for (var emxTableRowId in emxTableRowIds) {
			var inputElement = document.createElement("input");
			inputElement.setAttribute("type", "hidden");
			inputElement.setAttribute("name", "emxTableRowId_Region");
			inputElement.setAttribute("value", emxTableRowId);
			formObj.appendChild(inputElement);
		}
		formObj.elements["action"].value = "com.dassault_systemes.enovia.geographyconfiguration.ui.Country:actionDoAddCountryToRegion";
		formObj.submit();
	}

	/**
     * Function to obtain Region/Country ids for Regions/Countries frame, for adding Languages to them using Execute.jsp elements, adding new input elements
     */
	function getRegionsCountriesForLanguages() {
		var frameObject = findFrame(window.parent.parent,"GEORegions");
		var emxTableRegionRowIds = frameObject.getCheckedCheckboxes();
		var frameObject = findFrame(window.parent.parent,"GEOCountries");
		var emxTableCountryRowIds = frameObject.getCheckedCheckboxes();
		var formObj = document.forwardForm;
		for (var emxTableRowId in emxTableRegionRowIds) {
			var inputElement = document.createElement("input");
			inputElement.setAttribute("type", "hidden");
			inputElement.setAttribute("name", "emxTableRowId_Region");
			inputElement.setAttribute("value", emxTableRowId);
			formObj.appendChild(inputElement);
		}
		for (var emxTableRowId in emxTableCountryRowIds) {
			var inputElement = document.createElement("input");
			inputElement.setAttribute("type", "hidden");
			inputElement.setAttribute("name", "emxTableRowId_Country");
			inputElement.setAttribute("value", emxTableRowId);
			formObj.appendChild(inputElement);
		}
		formObj.elements["action"].value = "com.dassault_systemes.enovia.geographyconfiguration.ui.Language:actionDoAddLanguageToSelected";
		formObj.submit();
	}

    /**
     * Function to add Structure Browser rows in Regions frame in UI 
     */
	function addRowsUnderRegionsInStructureBrowser(xmlMessage) {
		var regionsFrame = findFrame(getTopWindow(),"GEORegions");
    	regionsFrame.emxEditableTable.addToSelected(xmlMessage);
    	regionsFrame.refreshStructureWithOutSort();
	}

    /**
     * Function to add Structure Browser rows in Countries frame in UI 
     */
    function addRowsUnderCountriesInStructureBrowser(xmlMessage) {
    	var countriesFrame = findFrame(getTopWindow(),"GEOCountries");
    	countriesFrame.emxEditableTable.addToSelected(xmlMessage);
    	countriesFrame.refreshStructureWithOutSort();
    }

    /**
     * Function to remove Structure Browser rows in Regions frame in UI 
     */
    function removeRowsUnderRegionsFromStructureBrowser(strEmxTableRowIds) {
    	var emxTableRowIds = strEmxTableRowIds.split(";");
    	var topFrame = findFrame(getTopWindow(),"GEORegions");
		topFrame.emxEditableTable.removeRowsSelected(emxTableRowIds);
		topFrame.refreshStructureWithOutSort();
    }

    /**
     * Function to remove Structure Browser rows in Countries frame in UI 
     */
    function removeRowsUnderCountriesFromStructureBrowser(strEmxTableRowIds) {
    	var emxTableRowIds = strEmxTableRowIds.split(";");
    	var topFrame = findFrame(getTopWindow(),"GEOCountries");
		topFrame.emxEditableTable.removeRowsSelected(emxTableRowIds);
		topFrame.refreshStructureWithOutSort();
    }

    /**
      * Alerts for Geography configuration and support
   */
    function alertPleaseSelectLocalLanguageOnly (){
/*XSSOK*/	alert("<%=getString(context, "GeographyConfiguration.Message.PleaseSelectLocalLanguagesOnly")%>");
    }

    /**
    * Function to remove Structure Browser rows in Language frame in UI 
    */
   function removeRowsUnderLocalLanguagesFromStructureBrowser(strEmxTableRowIds) {
   	var emxTableRowIds = strEmxTableRowIds.split(";");
   	var topFrame = findFrame(getTopWindow(),"GEOLanguages");
   	topFrame.emxEditableTable.removeRowsSelected(emxTableRowIds);
   	topFrame.refreshStructureWithOutSort();
   }
    
   function refreshOpenerAndCloseToWindow() { 	
	    getTopWindow().getWindowOpener().location.href = getTopWindow().getWindowOpener().location.href;
	    getTopWindow().window.closeWindow();
	}
   
   function refreshOpenerWindow()
   {
   		window.parent.location.href = window.parent.location.href;	
   }
   function removeObjectAndRefresh()
   {
	   this.parent.location.href=this.parent.location.href;
   }
   function refreshProductDocumentPage()
   {
		var detailsDisplayFrame = findFrame(getTopWindow().getWindowOpener().getTopWindow(), "GEODocumentCountry");
	    detailsDisplayFrame.location.href = detailsDisplayFrame.location.href;
	    var detailsDisplayFrame1 = findFrame(getTopWindow().getWindowOpener().getTopWindow(), "GEODocumentProducts");
	    detailsDisplayFrame1.location.href = detailsDisplayFrame1.location.href;
		getTopWindow().closeWindow();
	}
	</script>
