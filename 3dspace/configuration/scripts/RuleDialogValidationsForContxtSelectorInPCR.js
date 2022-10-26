
//RuleDialogValidationsForContxtSelectorInPCR.js
//Includes all the operations to be performed on Rule Dilaog Page..which may vary depending upon the Type of rule.
/*Functions included:
 * 
 */

function selectorTable(){
     var vSuitekey = "<%=SuiteKey%>";
     var vSelected = document.getElementById('product').selectedIndex;
     var vProductName=document.getElementById('product').options[vSelected].text;
     var vProductId = document.getElementById('product').options[vSelected].value;
     var target = document.getElementById("divSourceList");
     
     optionResponse = "<iframe name=\"InclusionRuleSourceList\" id=\"InclusionRuleSourceList\" height=\"180%\" width=\"200%\"></iframe>";
     target.innerHTML = optionResponse;
     
     
     var vURL = "../configuration/RuleDialogPreProcessUtil.jsp?mode=SBRootNodeInfo&rootNodeID="+vProductId;
     var vRes = emxUICore.getData(vURL);
    
     var iIndex = vRes.indexOf("type=");
     var iLastIndex = vRes.indexOf(",");
     var type = vRes.substring(iIndex+"type=".length , iLastIndex );

     vRes = vRes.substring(iLastIndex+1 , vRes.length );
     iIndex = vRes.indexOf("isOfTypeFeatures=");
     iLastIndex = vRes.indexOf(",");
     var isOfTypeFeatures = vRes.substring(iIndex+"isOfTypeFeatures=".length , iLastIndex ).trim();

     vRes = vRes.substring(iLastIndex+1 , vRes.length );
     iIndex = vRes.indexOf("isOfTypePV=");
     iLastIndex = vRes.indexOf(",");
     var isOfTypePV = vRes.substring(iIndex+"isOfTypePV=".length , iLastIndex ).trim();

     vRes = vRes.substring(iLastIndex+1 , vRes.length );
     iIndex = vRes.indexOf("isOfInvalidState=");
     iLastIndex = vRes.indexOf(",");
     var isOfInvalidState = vRes.substring(iIndex+"isOfInvalidState=".length , iLastIndex ).trim();
    
     vRes = vRes.substring(iLastIndex+1 , vRes.length );
     iIndex = vRes.indexOf("isRootNodeProduct=");
     iLastIndex = vRes.indexOf(";");
     var isRootNodePRD = vRes.substring(iIndex+"isRootNodeProduct=".length , iLastIndex );
     
     //TO DO : Need to work on this code snippet
     var expandProgram = "";
     var  vFilterToolbar = "";
     if(type=='Model'){
    	 expandProgram="&expandProgram=emxBooleanCompatibility:getValidProductsForPCR";
    	 vFilterToolbar = "FTRProductCustomFilterToolbarModelForRuleDialog";
     }else{
    	 expandProgram="&expandProgram=LogicalFeature:getProductsAsLogicalFeatures";
    	 vFilterToolbar = "FTRProductCustomFilterToolbarForRuleDialog";
     }
     
     
     vURL  = "../common/emxIndentedTable.jsp?table=FTRRuleFeatureSelectorTable&selection=multiple";
     vURL = vURL + "&objectId=";
     vURL = vURL + vProductId;
     vURL = vURL + "&toolbar=";
     vURL = vURL + vFilterToolbar;
     vURL = vURL +expandProgram;
     //vURL = vURL + "&direction=from"
     //vURL = vURL + "&relationship=relationship_LogicalFeatures"
     vURL = vURL + "&type=type_Products"
     vURL = vURL + "&hideHeader=true";
     vURL = vURL + "&PrinterFriendly=false";
     vURL = vURL + "&objectCompare=false";
     vURL = vURL + "&customize=false";
     vURL = vURL + "&export=false";
     vURL = vURL + "&showClipboard=false";
     vURL = vURL + "&multiColumnSort=false";
     vURL = vURL + "&showPageURLIcon=false";
     vURL = vURL + "&displayView=details";
     vURL = vURL + "&HelpMarker=false";
     vURL = vURL + "&autoFilter=false";
     vURL = vURL + "&massPromoteDemote=false";
     vURL = vURL + "&triggerValidation=false";
     var mx_iframeStructureListEl = document.getElementById("InclusionRuleSourceList");
     //Set the URL in the iframe
     mx_iframeStructureListEl.src = vURL;     
     //For onload event, the page doesnt get refreshed, hence set the location href of the content window
     mx_iframeStructureListEl.contentWindow.location.href = vURL;
  }
  
  
   function selectorTableFilter()
 {
	 var vSuitekey = "<%=SuiteKey%>";
     var vRelationshipType;
     var vSelected = document.getElementById('product').selectedIndex;
     var vProductName=document.getElementById('product').options[vSelected].text;
     var vProductId = document.getElementById('product').options[vSelected].value;
 	
     var vURL = "../configuration/RuleDialogPreProcessUtil.jsp?mode=SBRootNodeInfo&rootNodeID="+vProductId;
     var vRes = emxUICore.getData(vURL);
    
     var iIndex = vRes.indexOf("type=");
     var iLastIndex = vRes.indexOf(",");
     var type = vRes.substring(iIndex+"type=".length , iLastIndex );

     vRes = vRes.substring(iLastIndex+1 , vRes.length );
     iIndex = vRes.indexOf("isOfTypeFeatures=");
     iLastIndex = vRes.indexOf(",");
     var isOfTypeFeatures = vRes.substring(iIndex+"isOfTypeFeatures=".length , iLastIndex ).trim();

     vRes = vRes.substring(iLastIndex+1 , vRes.length );
     iIndex = vRes.indexOf("isOfTypePV=");
     iLastIndex = vRes.indexOf(",");
     var isOfTypePV = vRes.substring(iIndex+"isOfTypePV=".length , iLastIndex ).trim();

     vRes = vRes.substring(iLastIndex+1 , vRes.length );
     iIndex = vRes.indexOf("isOfInvalidState=");
     iLastIndex = vRes.indexOf(",");
     var isOfInvalidState = vRes.substring(iIndex+"isOfInvalidState=".length , iLastIndex ).trim();
    
     vRes = vRes.substring(iLastIndex+1 , vRes.length );
     iIndex = vRes.indexOf("isRootNodeProduct=");
     iLastIndex = vRes.indexOf(";");
     var isRootNodePRD = vRes.substring(iIndex+"isRootNodeProduct=".length , iLastIndex );
     var expandProgram = "";
     var  vFilterToolbar = "";
     if(type=='Model'){
    	 expandProgram="&expandProgram=emxBooleanCompatibility:getValidProductsForPCR";
    	 vFilterToolbar = "FTRProductCustomFilterToolbarModelForRuleDialog";
     }else{
    	 expandProgram="&expandProgram=LogicalFeature:getProductsAsLogicalFeatures";
    	 vFilterToolbar = "FTRProductCustomFilterToolbarForRuleDialog";
     }
     //TO DO : Need to work on this code snippet
     
     
     vURL  = "../common/emxIndentedTable.jsp?table=FTRRuleFeatureSelectorTable&selection=multiple";
     vURL = vURL + "&objectId=";
     vURL = vURL + vProductId;
     vURL = vURL + "&parentOID=";
     vURL = vURL + vProductId;
     vURL = vURL + "&toolbar=";
     vURL = vURL + vFilterToolbar;
     vURL = vURL +expandProgram;
     //vURL = vURL + "&direction=from"
     //if(type=='Model')
    //	 vURL = vURL + "&relationship=relationship_Products"
     //else    	 
      //   vURL = vURL + "&relationship=relationship_LogicalFeatures"
     vURL = vURL + "&type=type_Products"
     vURL = vURL + "&hideHeader=true";
     vURL = vURL + "&PrinterFriendly=false";
     vURL = vURL + "&objectCompare=false";
     vURL = vURL + "&customize=false";
     vURL = vURL + "&export=false";
     vURL = vURL + "&showClipboard=false";
     vURL = vURL + "&multiColumnSort=false"; 
     vURL = vURL + "&showPageURLIcon=false";
     vURL = vURL + "&displayView=details";
     vURL = vURL + "&HelpMarker=false";
     vURL = vURL + "&autoFilter=false";
     vURL = vURL + "&massPromoteDemote=false";
     vURL = vURL + "&triggerValidation=false";
     var mx_iframeStructureListEl = document.getElementById("InclusionRuleSourceList");

     //Set the URL in the iframe
     mx_iframeStructureListEl.src = vURL;     
     //For onload event, the page doesnt get refreshed, hence set the location href of the content window
     mx_iframeStructureListEl.contentWindow.location.href = vURL;
 }
 

