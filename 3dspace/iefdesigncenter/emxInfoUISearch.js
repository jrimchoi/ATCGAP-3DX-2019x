/*  emxInfoUISearch.js

   Copyright Dassault Systemes, 1992-2007. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

*/
/*!================================================================
 *  JavaScript Search Functions
 *  emxUISearch.js
 *  Requires: emxUIConstants.js
 *  Last Updated: 01-Dec-03, John M. Williams (JMW)
 *
 *  This file contains the code for the search.
 *
 *  static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxInfoUISearch.js 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
 *=================================================================
 */
//GLOBAL VARIABLES
var pageControl = new pageController();
var NAME = 0;
var VALUE = 1;
var CHECKED = 2;
var DISABLED = 3;

////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////   PageController Class    /////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

function pageController(){
        this.showingAdvanced = false;
        this.title = null;
        this.type = null;
        this.searchContentURL = "";
        this.savedSearchName = "";
        this.showErrMsg = false;
        this.doReload = false;
        this.doSubmit = false;
        this.arrFormVals = new Array();
        this.helpMarker = null;
        this.helpMarkerSuiteDir = null;
        this.queryLimit = null;
        this.pagination = null;
}
//showingAdvanced
pageController.prototype.setShowingAdvanced = function __setShowingAdvanced(bln){
        this.showingAdvanced = bln;
}
pageController.prototype.getShowingAdvanced = function __getShowingAdvanced(){
        return this.showingAdvanced;
}
//title
pageController.prototype.setTitle = function __setTitle(txt){
        this.title = txt;
}
pageController.prototype.getTitle = function __getTitle(){
        return this.title;
}
//type
pageController.prototype.setType = function __setType(txt){
        this.type = txt;
}
pageController.prototype.getType = function __getType(){
        return this.type;
}
//searchContentURL
pageController.prototype.setSearchContentURL = function __setSearchContentURL(txt){
        this.searchContentURL = txt;
}
pageController.prototype.getSearchContentURL = function __getSearchContentURL(){
        return this.searchContentURL;
}
//savedSearchName
pageController.prototype.setSavedSearchName = function __setSavedSearchName(txt){
        this.savedSearchName = txt;
}
pageController.prototype.getSavedSearchName = function __getSavedSearchName(){
        return this.savedSearchName;
}
pageController.prototype.clearSavedSearchName = function __clearSavedSearchName(){
        this.savedSearchName = "";
}
//showErrMsg
pageController.prototype.setShowErrMsg = function __setShowErrMsg(bln){
        this.showErrMsg = bln;
}

pageController.prototype.getShowErrMsg = function __getShowErrMsg(){
        return this.showErrMsg;
}
//doReload
pageController.prototype.setDoReload = function __setDoReload(bln){
        this.doReload = bln;
}

pageController.prototype.getDoReload = function __getDoReload(){
        return this.doReload;
}
//doSubmit
pageController.prototype.setDoSubmit = function __setDoSubmit(bln){
        this.doSubmit = bln;
}

pageController.prototype.getDoSubmit = function __getDoSubmit(){
        return this.doSubmit;
}
//arrFormVals
pageController.prototype.clearArrFormVals = function __clearArrFormVals(){
        this.arrFormVals.length = 0;
}

pageController.prototype.addToArrFormVals = function __addToArrFormVals(arrVal){
        this.arrFormVals[this.arrFormVals.length] = arrVal;
}

pageController.prototype.getArrFormValsLength = function __getArrFormValsLength(){
        return this.arrFormVals.length;
}
//This Method sets the window title
pageController.prototype.setWindowTitle = function __setWindowTitle(){
        top.document.title = STR_SEARCH_TITLE + this.title;
}
//This Method sets the searchHeader pageHeader text
pageController.prototype.setPageHeaderText = function __setPageHeaderText(){
        var searchHeader = findFrame(top,"searchHead");
        var heading = searchHeader.document.getElementById("pageHeader");
        if(heading)
            heading.innerHTML = STR_SEARCH_TITLE + this.title;
}
//This Method sets the helpMarker
pageController.prototype.setHelpMarker = function __setHelpMarker(str){
        this.helpMarker = str;
}
//This Method sets help marker suite directory
pageController.prototype.setHelpMarkerSuiteDir = function __setHelpMarkerSuiteDir(str){
        this.helpMarkerSuiteDir = str;
}
//This Method opens help
pageController.prototype.openHelp = function __openHelp(){
        openHelp(this.helpMarker,this.helpMarkerSuiteDir,STR_SEARCH_LANG);
}
//This Method sets the queryLimit
pageController.prototype.setQueryLimit = function __setQueryLimit(strNum){
        this.queryLimit = strNum;
}
//This Method gets the queryLimit
pageController.prototype.getQueryLimit = function __getQueryLimit(){
        return this.queryLimit;
}
//This Method sets the pagination
pageController.prototype.setPagination = function __setPagination(strNum){
        this.pagination = strNum;
}
//This Method gets the pagination
pageController.prototype.getPagination = function __getPagination(){
        return this.pagination;
}
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////End PageController Class////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

//This function determines where the search will open.
function findSearchFrame(){
    //arguments[0] is the url of the search page
    //arguments[1] is the targetFrame name
    //arguments[2] is the page title
    //arguments[3] is the commandName
    //arguments[4] is the helpMarker parameter
    //arguments[5] is the helpMarker suiteDir parameter
    pageControl = new pageController();
    if(arguments.length){
    //debugger
        //determine if the search window is already open
        var targetFrame = findFrame(top,arguments[1]);
        
        //if open target frame
        if(targetFrame){
            targetFrame.location.href = arguments[0];
            
            //store content url
            pageControl.setSearchContentURL(arguments[0]);
                        
            //disable/enable actions menu items
            setSaveFunctionality((arguments[0].indexOf("emxSearchManage.jsp") == -1));
            
            //is there a title to set?
            if(arguments[2]){
                //store title
                pageControl.setTitle(arguments[2]);
                
                //set window Title
                pageControl.setWindowTitle();
                
                //set window Title
                pageControl.setPageHeaderText();
            }
            
            //is there a helpMarker to set?
            if(arguments[4]){
               //store the helpMarker
                pageControl.setHelpMarker(arguments[4]); 
            }
            
            //is there a helpMarker suiteDir to set?
            if(arguments[5]){
               //store the helpMarker
                pageControl.setHelpMarkerSuiteDir(arguments[5]); 
            }
        //else call showNonModal
        }else{
            showNonModalSearch("../common/emxSearch.jsp?defaultSearch=" + arguments[3]);
        }
    } 
}


//This function opens a reusable window
function showNonModalSearch(strURL){
        var objWindow = window.open(strURL, "NonModalSearchWindow","width=700,height=500,resizable=yes");
        registerChildWindows(objWindow, top);
        objWindow.focus();
}

//This function turns on or off save menu items
function setSaveFunctionality(bln){
    var headerFrame = findFrame(top,"searchHead");
    if (headerFrame.toolbars && headerFrame.toolbars.setListLinks) {
        headerFrame.toolbars.setListLinks(bln);
    }    

} 
//
// Following method encodes the URI using javascript encodeURI function if the character encoding is UTF8
//

//
// The save search name is encoded with the unicode values separated with . (dot)
// Ex. if the save search name is 'ABC' then the encoded name will be '65.66.67'
//
function encodeSaveSearchName(strSaveSearchName)
{
	if (strSaveSearchName == null || strSaveSearchName.length <= 0)
	{
		return strSaveSearchName;
	}

	var strEncodedSaveSearchName = "";
	for (var i = 0; i < strSaveSearchName.length; i++)
	{
		strEncodedSaveSearchName += strSaveSearchName.charCodeAt(i);
		if (i < (strSaveSearchName.length - 1))
		{
			strEncodedSaveSearchName += ".";
		}
	}

	return strEncodedSaveSearchName;
}

var isCharacterEncodingUTF8 = false;
function encodeURIIfCharacterEncodingUTF8 (strURI)
{
	var strResultURI = strURI;
	if (isCharacterEncodingUTF8)
	{
		strResultURI = encodeURI(strURI);
	}
	return strResultURI;
}

/////////////////// FORM FIELD STORAGE //////////////////////////////////   
//arrFormVals is an Array in the form of
//arrFormVals[i](String "field name", [Array (int,int)] or String "field value")
//where Array (int,int) is an array of selected indexes for select menus
//example
//arrFormVals[0] = new Array("field_1", new Array(1,2,4));

//also this array should maintain the same order of elements
//form[1] should equal arrFormVals[1]

function storeFormVals(){

    //reset array
    pageControl.clearArrFormVals();
    
    //loop through form and store values
    var myForm = arguments[0];
    var formLen = myForm.elements.length;
    for(var i = 0; i < formLen; i++){
        addFormValues(myForm[i]);
    }
}

function addFormValues(formfield){

    //select the appropriate data to save
    switch (formfield.type){
    
        //text fields
        //store value
        case "text" :
        case "textarea" :
        case "hidden" :
		    if (formfield.name.indexOf('txtWhere') >= 0)
			  pageControl.addToArrFormVals(new Array(formfield.name,encodeURIComponent(formfield.value),null,formfield.disabled));
			else
            pageControl.addToArrFormVals(new Array(formfield.name,encodeURIComponent(formfield.value),null,formfield.disabled));
        break;
        
        //radio or checkbox
        //store checked boolean
        case "radio" :
        case "checkbox" :
            pageControl.addToArrFormVals(new Array(formfield.name, formfield.value, formfield.checked));
        break;
        
        //select menus
        //store array of selected indexes
        case "select-multiple" :
        case "select-one" :
            var arrSelectValues = new Array();
            for(var i = 0; i < formfield.options.length; i++){
                if(formfield.options[i].selected == true){
                    arrSelectValues[arrSelectValues.length] = new Array(i,formfield.options[i].value);
                }
            }
                
            pageControl.addToArrFormVals(new Array(formfield.name,arrSelectValues));
        break;
        
        default :
            pageControl.addToArrFormVals(new Array(formfield.name,formfield.value));
        break;
        
    }
}
    
function rebuildForm(){

    //if doSubmit use hidden content frame
    //find the form
    var bodyFrame = null;
    if(pageControl.getDoSubmit()){
        bodyFrame = findFrame(top,"searchContent");
    }else{
        bodyFrame = findFrame(top,"searchContent");
    }
    if (bodyFrame == null || bodyFrame == 'undefined' 
        || bodyFrame.document == null || bodyFrame.document == 'undefined' 
        || bodyFrame.document.forms[0] == null || bodyFrame.document.forms[0] == 'undefined')
       return;

    var theForm = bodyFrame.document.forms[0];
    
    //for each item in arrFormVals array, based on type check for formfield and set value
    var arrLen = pageControl.getArrFormValsLength();
    if(arrLen != theForm.elements.length){
        pageControl.setShowErrMsg(true);
    }
    
    for(var i = 0; i < arrLen; i++){
        var foundElement = false;
        
        try{
            //get the formfield
            var formElement = bodyFrame.document.getElementsByName(pageControl.arrFormVals[i][NAME]);
            var formElementCount = formElement.length;
            var typeStr = '';
            for(var j = 0; j < formElementCount; j++){
                typeStr += formElement[j].type;
                switch (formElement[j].type){
                    
                    //text
                    case "text" :
                    case "textarea" :
                    case "hidden" :
                        foundElement = setText(formElement[j], pageControl.arrFormVals[i]);
                    break;
                    
                    //checked
                    case "radio" :
                    case "checkbox" :  
                        foundElement = setChecked(formElement[j], pageControl.arrFormVals[i]);
                    break;                  
                    
                    //select
                    case "select-multiple" :
                    case "select-one" :          
                        foundElement = setSelect(formElement[j], pageControl.arrFormVals[i])
                    break;
                    
                    default:
                        foundElement = true;
                    break;          
                }
                
                //if we found a match break out of loop
                if(foundElement){
                    break;
                }
               
                //if this is the last element and we didn't find
                //a match set Alert
                if(!foundElement && j == formElementCount-1){
                    pageControl.setShowErrMsg(true);
                }
            }
        }catch(e){
                pageControl.setShowErrMsg(true);
        }
    }
    
    if(pageControl.getShowErrMsg()){
        //alert(STR_SEARCH_RESAVE_FORM_DATA);
        pageControl.setShowErrMsg(false);
    }
}

function setText(formfield, val){
    if(formfield.name == val[NAME]){
	    if (formfield.name.indexOf('txtWhere') >= 0)
		   formfield.value = decodeURIComponent(val[VALUE]);
		else
        formfield.value = decodeURIComponent(val[VALUE]);
        formfield.disabled = val[DISABLED];
        return true;
    }
    return false;
}

function setChecked(formfield, val)
{
    if(formfield.name == val[NAME] && (formfield.value == val[VALUE] || formfield.value == unescape(val[VALUE])))
	{
	   // alert('formfield = ' + formfield.name + ' value = ' + unescape(val[VALUE]));
       // formfield.checked = val[CHECKED];
	   if (formfield.type == 'radio')
			formfield.checked = val[CHECKED];
	   else 
	   {
	       if (val[VALUE] && val[VALUE] == 'True' || val[VALUE] == 'true')
              formfield.checked = true;	
		   else
		      formfield.checked = false;
       }		   
       return true;
    }
    return false;
}

function setSelect(formfield, arrOpts){

    if(formfield.name == arrOpts[NAME]){
        //clear current selections
        var formfieldOptsLen = formfield.options.length;
        for(var i = 0; i < formfieldOptsLen; i++){
            formfield.options[i].selected = false;
        }
        //reset
        var arrOptsLen = arrOpts[VALUE].length;
       /* for(var i = 0; i < arrOptsLen; i++){
            if(formfield.options[arrOpts[VALUE][i][0]].value == arrOpts[VALUE][i][1] || formfield.options[arrOpts[VALUE][i][0]].value == unescape(arrOpts[VALUE][i][1])){
                formfield.options[arrOpts[VALUE][i][0]].selected = true;
            }else{
                return false;
            }
        }*/
        for (var i = 0;  i < formfield.options.length; i++) {

            var value = arrOpts[1];
            var str = '' + arrOpts[VALUE][0];
            var arr = str.split(',');
            var selectedPos = '';
            if (arr && arr != 'undefined' && 'null' != arr) 
                selectedPos = arr[0];
            if (selectedPos && selectedPos != 'undefined' 
                && selectedPos != 'null' && selectedPos != '' &&
                selectedPos.match(/^\d+$/))
            {
               var indx = eval(selectedPos);
               formfield.options[indx].selected = true;
               break;
            }
            else if (formfield.options[i].value == arrOpts[1])
            {
               formfield.options[i].selected = true;
               break;
            }
        }
        return true;
    }
    return false;
}
///////////////////////////////////////////////////////////////////

function reviseSearch(){
//debugger
    //if doSubmit use hidden content frame
    var searchViewFrame = null;
    if(pageControl.getDoSubmit()){
        searchViewFrame = findFrame(top,"searchContent");
    }else{
        searchViewFrame = findFrame(top,"searchView");
    }
    //querystring
    var querystring = escape(pageControl.getSearchContentURL());
    // get searchViewUrl
    var searchViewUrl = "../common/emxSearchView.jsp?url=" + querystring;
    
    //if hidden submit use only the
    if(pageControl.getDoSubmit()){
        searchViewUrl = pageControl.getSearchContentURL();
    }  
    pageControl.setDoReload(true);
    searchViewFrame.location.href = searchViewUrl;
    
    //NOTE add footer values
} 

function loadSearchFormFields(){
    setTimeout("checkReloadFlag()",500);
}

function checkReloadFlag(){
    if(pageControl.getDoReload())
        rebuildForm();
        
    if(pageControl.getDoSubmit()){
        //find the form
        var bodyFrame = findFrame(top,"searchContent");
        bodyFrame.doSearch();
    }
        
        
    pageControl.setDoSubmit(false);    
    pageControl.setDoReload(false);
}

function getAdvancedSearch(bln, objDiv){
    
    //get type
    var emxType = pageControl.getType();
   
    if(emxType == null || emxType == ""){
        //alert(STR_SEARCH_SELECT_TYPE);
        return false;
    }
    
    if(!pageControl.getShowingAdvanced() || bln){
        var url = "../common/emxSearchGetAdvanced.jsp?type=" + emxType;
        var myXMLHTTPRequest = emxUICore.createHttpRequest();
        myXMLHTTPRequest.open("GET", url, false);
        myXMLHTTPRequest.send(null);
        
        //write back to div
        objDiv.innerHTML = myXMLHTTPRequest.responseText;
    }  
    return true;      
}

///////////////////// Save Search Functions //////////////////////////////////
//save and save as
function processSaveSearch(){
    if(pageControl.getSavedSearchName() == ""){
        showModalDialog("../common/emxSearchSaveDialog.jsp", 400, 200,true);
    }else{
        saveSearch(pageControl.getSavedSearchName(), "update");
    }
}  
  
function processSaveAsSearch(){
        showModalDialog("../common/emxSearchSaveAsDialog.jsp", 400, 325,true);
}    

function saveSearch(strName, strSaveType){
    //check that the url is the same in both the pageController and bodyFrame
    //if not then reset
    top.validateURL();
    
    //set Saved Search Name
    pageControl.setSavedSearchName(strName);
    
    //build xml doc from formfields
    var xmlData = buildXMLfromForm();
    var url = "../common/emxSearchSaveProcessor.jsp";
        url += "?saveType=" + strSaveType;
        url += "&saveName=" + strName;

    var oXMLHTTP = emxUICore.createHttpRequest();
    oXMLHTTP.open("post", url, false);
    oXMLHTTP.send(xmlData);
    
    //run tests then...
    return oXMLHTTP.responseText;
}  

function deleteSearch(strName, strSaveType){
    var xmlData = "<root/>"        
    var url = "../common/emxSearchSaveProcessor.jsp";
        url += "?saveType=" + strSaveType;
        url += "&saveName=" + strName;
           
    var oXMLHTTP = emxUICore.createHttpRequest();
    oXMLHTTP.open("post", url, false);
    oXMLHTTP.send(xmlData);
    return oXMLHTTP.responseText;
}

function buildXMLfromForm(){
    var NAME = 0;
    var VALUE = 1;
    var CHECKED = 2;
    var contentFrame = findFrame(top, "searchContent");
    var theForm = contentFrame.document.forms[0];

    //save formData
    storeFormVals(theForm);

    var xmlData = emxUICore.createXMLDOM();
    xmlData.loadXML("<root/>");
    
    //root
    var root = xmlData.documentElement;
    
    //command
    var command = xmlData.createElement("command");
    root.appendChild(command);
    //jsp
    var jsp = xmlData.createElement("jsp");
    root.appendChild(jsp);
    //params
        //for each
    for (var e in pageControl){
        if(!(typeof pageControl[e] == "function" || typeof pageControl[e] == "object")){
        	var param = xmlData.createElement("param");
            param.setAttribute("name", e);
            var tn = xmlData.createTextNode(""+pageControl[e]);
            param.appendChild(tn);
            root.appendChild(param);
        }
    }
        
    
    
    //formdata node
    var formData = xmlData.createElement("formData");
    root.appendChild(formData);
    
    //for each arrFormArray
    
    var arrLen = pageControl.getArrFormValsLength();
    for (var i = 0; i < arrLen; i++){
        	var formfield = xmlData.createElement("formfield");
            formfield.setAttribute("name", pageControl.arrFormVals[i][NAME]);
            //boolean value?
            if(typeof pageControl.arrFormVals[i][CHECKED] == "boolean"){
                formfield.setAttribute("type", "boolean");
                formfield.setAttribute("checked", pageControl.arrFormVals[i][CHECKED]);
            }else if(typeof pageControl.arrFormVals[i][DISABLED] == "boolean"){
                formfield.setAttribute("type", "string");
                formfield.setAttribute("disabled", (pageControl.arrFormVals[i][DISABLED])?"true":"false");
            }else{
                formfield.setAttribute("type", (typeof pageControl.arrFormVals[i][VALUE]));
            }
            
            //string value
            if(typeof pageControl.arrFormVals[i][VALUE] == "string"){
                    
                //boolean value (checkbox?)
                if(typeof pageControl.arrFormVals[i][CHECKED] == "boolean"){
                    var tn = xmlData.createTextNode(encodeURI(pageControl.arrFormVals[i][VALUE]));
                    formfield.appendChild(tn);
                }else{
                    var tn = xmlData.createTextNode(encodeURI(pageControl.arrFormVals[i][VALUE]));
                    formfield.appendChild(tn);
                }
            }
            
            //object (array) values
            if(typeof pageControl.arrFormVals[i][VALUE] == "object"){
                var objLen = pageControl.arrFormVals[i][VALUE].length;
                for(var j = 0; j < objLen; j++){
                    var valNode = xmlData.createElement("value");
                    var tmpStr = pageControl.arrFormVals[i][VALUE][j][0] + ",\"" + encodeURI(pageControl.arrFormVals[i][VALUE][j][1]) + "\"";
                    var tn = xmlData.createTextNode(tmpStr);
                    valNode.appendChild(tn);
                    formfield.appendChild(valNode);
                }
                
            }
            
            
            //add to formdata
            formData.appendChild(formfield);
    }

    return xmlData.xml;
}

function buildXML(){
    var NAME = 0;
    var VALUE = 1;
    var CHECKED = 2;
    var contentFrame = findFrame(top, "searchContent");
    //var theForm = contentFrame.document.forms[0];

    //save formData
    //storeFormVals(theForm);

    var xmlData = emxUICore.createXMLDOM();
    xmlData.loadXML("<root/>");
    
    //root
    var root = xmlData.documentElement;
    
    //command
    var command = xmlData.createElement("command");
    root.appendChild(command);
    //jsp
    var jsp = xmlData.createElement("jsp");
    root.appendChild(jsp);
    //params
        //for each
    for (var e in pageControl){
        if(!(typeof pageControl[e] == "function" || typeof pageControl[e] == "object")){
        	var param = xmlData.createElement("param");
            param.setAttribute("name", e);
            var tn = xmlData.createTextNode(""+pageControl[e]);
            param.appendChild(tn);
            root.appendChild(param);
        }
    }
        
    
    
    //formdata node
    var formData = xmlData.createElement("formData");
    root.appendChild(formData);
    
    //for each arrFormArray
    
    var arrLen = pageControl.getArrFormValsLength();
    for (var i = 0; i < arrLen; i++){
        	var formfield = xmlData.createElement("formfield");
            formfield.setAttribute("name", pageControl.arrFormVals[i][NAME]);
            //boolean value?
            if(typeof pageControl.arrFormVals[i][CHECKED] == "boolean"){
                formfield.setAttribute("type", "boolean");
                formfield.setAttribute("checked", pageControl.arrFormVals[i][CHECKED]);
            }else if(typeof pageControl.arrFormVals[i][DISABLED] == "boolean"){
                formfield.setAttribute("type", "string");
                formfield.setAttribute("disabled", (pageControl.arrFormVals[i][DISABLED])?"true":"false");
            }else{
                formfield.setAttribute("type", (typeof pageControl.arrFormVals[i][VALUE]));
            }
            
            //string value
            if(typeof pageControl.arrFormVals[i][VALUE] == "string"){
                    
                //boolean value (checkbox?)
                if(typeof pageControl.arrFormVals[i][CHECKED] == "boolean"){
                    var tn = xmlData.createTextNode(encodeURI(pageControl.arrFormVals[i][VALUE]));
                    formfield.appendChild(tn);
                }else{
				    var tn = null;
				    if (formfield.name.indexOf('txtWhere') >= 0)
                       tn = xmlData.createTextNode(encodeURIComponent(pageControl.arrFormVals[i][VALUE]));
					else
					   tn = xmlData.createTextNode(pageControl.arrFormVals[i][VALUE]);
                    formfield.appendChild(tn);
                }
            }
            
            //object (array) values
            if(typeof pageControl.arrFormVals[i][VALUE] == "object"){
                var objLen = pageControl.arrFormVals[i][VALUE].length;
                for(var j = 0; j < objLen; j++){
                    var valNode = xmlData.createElement("value");
                    var tmpStr = pageControl.arrFormVals[i][VALUE][j][0] + ",\"" + encodeURI(pageControl.arrFormVals[i][VALUE][j][1]) + "\"";
                    var tn = xmlData.createTextNode(tmpStr);
                    valNode.appendChild(tn);
                    formfield.appendChild(valNode);
                }
                
            }
            
            
            //add to formdata
            formData.appendChild(formfield);
    }

    return xmlData.xml;
}

function getSavedSearchXML(){
    
    //get searchName
    var strName = pageControl.getSavedSearchName();//escape???
    if(trimWhitespace(strName).length == 0){
        //alert(STR_SEARCH_EMPTY_NAME);
        return;
    }
    var result = "";
    
    //get xml data
    var url = "../iefdesigncenter/DSCSearchGetSavedSearch.jsp";
        url += "?saveName=" + strName;
        
    //add a timestamp to prevent caching
    var timestamp = (new Date()).getTime();
        url += "&timestamp=" + timestamp;
        
    // load the xml file
    var myXMLHTTPRequest = emxUICore.createHttpRequest();
    myXMLHTTPRequest.open("GET", url, false);
    myXMLHTTPRequest.send(null);
 
    return decodeURI(myXMLHTTPRequest.responseText);
}

function importSavedSearchXML(frameName){
    //get searchName
    var strName = pageControl.getSavedSearchName();//escape???
    if(trimWhitespace(strName).length == 0){
        //alert(STR_SEARCH_EMPTY_NAME);
        return;
    }
    var result = "";
    
    //get xml data
    var url = "../iefdesigncenter/DSCSearchGetSavedSearch.jsp";
        url += "?saveName=" + strName;
        
    //add a timestamp to prevent caching
    var timestamp = (new Date()).getTime();
        url += "&timestamp=" + timestamp;
        
    // load the xml file
    var myXMLHTTPRequest = emxUICore.createHttpRequest();
    myXMLHTTPRequest.open("GET", url, false);
    myXMLHTTPRequest.send(null);
    //alert('import XML' + myXMLHTTPRequest.responseText);
    //load xml into DOM
	var responseText = decodeURI(myXMLHTTPRequest.responseText);
	var xmlDoc = emxUICore.createXMLDOM();
    xmlDoc.loadXML(responseText);
	
    //alert('xmlDoc : ' + xmlDoc);
    
    //test for valid xml???
	var hiddenFrameName = "searchHidden";
	if (frameName) hiddenFrameName = frameName;
    if (isIE) {
            //if (xmlDoc.parseError != 0) {
                    findFrame(top,hiddenFrameName).document.write(responseText);
            //        return;
            //} 
    } else {
           // if (xmlDoc.documentElement.tagName == "parsererror") {
                    findFrame(top,hiddenFrameName).document.write(responseText);
            //        return;
            //} 
    } 
    

    //store doSubmit
    var localDoSubmit = pageControl.getDoSubmit();
    //create new pageController
    pageControl = new pageController();
    
    //reset doSubmit
    pageControl.setDoSubmit(localDoSubmit);
            
    //extract and set pageControl values
    evalTransform(myXMLHTTPRequest, xmlDoc, "../common/emxSearchSetParams.xsl");
    
    //extract and set arrFormVals
    evalTransform(myXMLHTTPRequest, xmlDoc, "../common/emxSearchSetFormArray.xsl");   
    
    //alert('importSavedSearchXML: ' + myXMLHTTPRequest.responseText);
    //load the saved search
    //reviseSearch();
}

function createXSLTProcessor() {
    if (!isIE){
            return new XSLTProcessor();
    }
}

function evalTransform(oHTTPReq ,oXML, strXSLFile){
    //get the xslt file
    oHTTPReq.open("GET", strXSLFile, false);
    oHTTPReq.send(null);
    
    //create DOM
    var xslStylesheet = emxUICore.createXMLDOM();
    
    //load stylesheet
    xslStylesheet.loadXML(oHTTPReq.responseText);
    
    //create the xslt processor
    var xsltProcessor = createXSLTProcessor();
    
    //transform and evaluate
    if(isIE){
            result = oXML.transformNode(xslStylesheet);
            eval(result);
    }else{
            xsltProcessor.importStylesheet(xslStylesheet);
            result = xsltProcessor.transformToDocument(oXML);
            eval(result.documentElement.childNodes[0].nodeValue);
    }
}


function validateURL(){
    //check that the bodyFrame url is the same as the pageController url
    //if different set the pageController url to bodyFrame url
    var bodyFrame = findFrame(top,"searchContent");
    var bodyFrameURL = bodyFrame.document.location.href;
    var pageControlURL = pageControl.getSearchContentURL();
    if(!compareURLs(pageControlURL,bodyFrameURL)){
        var tmpURL = getRelativeURL(bodyFrameURL);
        if(tmpURL != pageControlURL){
            pageControl.setSearchContentURL(tmpURL);
        }
    }
}

            
function compareURLs(a,b){
    //if there is no ../ in url just return true
    //we don't want to handle this case
    if(a.indexOf("../") == -1){
        return true;
    }
    var url_1 = a.substring(3);     //a holds a relative url "../appName/file.jsp?param=x"
    var iStart = b.indexOf(url_1)   //b holds a full url "http://host/app..."
    if(iStart > -1){
        return (b.substring(iStart) == url_1);
    }
    return false;
}


function getRelativeURL(strURL){
    var url = pageControl.getSearchContentURL();
    var appDir = url.substring(3,url.indexOf("/",3))
    var iStart = strURL.indexOf(appDir);
    if(iStart > -1){
        return "../" + strURL.substring(iStart);
    }
    return url;
}
