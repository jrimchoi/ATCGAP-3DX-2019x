
<%--  enoQuestionnaireCreateFormValidation.jsp

  Copyright (c) 1992-2018 Dassault Systemes.
  All Rights Reserved.
  This program contains proprietary and trade secret information of MatrixOne,
  Inc.  Copyright notice is precautionary only
  and does not evidence any actual or intended publication of such program

   static const char RCSID[] = "$Id: emxJSValidation.jsp.rca 1.1.5.4 Wed Oct 22 15:48:43 2008 przemek Experimental przemek $";
--%>
<%@include file = "../common/emxNavigatorInclude.inc"%>
<%
String strAlertDate = EnoviaResourceBundle.getProperty(context, "enoQuestionnaireStringResource", context.getLocale(), "enoQuestionnaire.Alert.Msg.DueDateCannotBePriorToday");
String strAlertNumberAllowed = EnoviaResourceBundle.getProperty(context, "enoQuestionnaireStringResource", context.getLocale(), "enoQuestionnaire.Alert.Msg.OnlyNumbersAllowed");
out.clear();
response.setContentType("text/javascript; charset=" + response.getCharacterEncoding());
%>

	function refreshPage()
	{
		getTopWindow().location.href=getTopWindow().location.href;
	}
	function addNewRowOnChange()
	{
               var rtnObject =emxEditableTable.getCurrentCell();
               var responseValue = arguments[0];
                var xmlMessage = "<mxRoot><action fromRMB=\"\"><![CDATA[remove]]></action>";
               var strRowId = rtnObject.rowID;
               var getChildItems = emxEditableTable.getChildrenRowIds(strRowId); 
                for (var item1 in getChildItems)
               {                   
                      if(!isNaN(item1))
                     {
                            var rowId = strRowId+","+item1;
                            xmlMessage += "<item id=\""+rowId+"\"/>";
                     }
               } 
                xmlMessage += "</mxRoot>";
               if(getChildItems)
               removedeletedRows(xmlMessage);
               var queryString = "&emxTableRowId="+rtnObject.objectid+"&responseValue="+responseValue+""+"&ajaxMode=xml"+"&suiteKey=Questionnaire";
               var arrRowId=new Array(strRowId);
               emxEditableTable.select(arrRowId);
               
                var nRow = emxUICore.selectSingleNode(oXML, "/mxRoot/rows//r[@id = '" + strRowId + "']");
               var expand = nRow.setAttribute("expand","true");
               var response = emxUICore.getDataPost("../questionnaire/enoQuestionnaireExecute.jsp?questionAction=ENOQuestionUI:findQuestionOnChange",queryString);
               emxEditableTable.addToSelected(response);
              
               var checkedItems = getCheckedCheckboxes();
               for (var item in checkedItems)
               { 
                       strRowId = (item.substring(item.lastIndexOf("|")+1,item.length));
                      nRow = emxUICore.selectSingleNode(oXML, "/mxRoot/rows//r[@id = '" + strRowId + "']");
                      var arrItem=new Array(nRow);
                      unRegisterSelectedRows(arrItem);
               }
	}
	function refreshContentPage(){
	var frame=findFrame(getTopWindow(), "content");
	return "";
	}
	function saveAndCloseWindow(){
		emxEditableTable.performXMLDataPost();
		turnOffProgress();
			var frame=findFrame(getTopWindow(), "detailsDisplay");
			if(frame)
	frame.location.href=frame.location.href;
			else
			{
				frame=findFrame(getTopWindow(), "QuestionSubmitResponse"); 
				if(frame)
					frame.location.href=frame.location.href;
			}
	}

	function refreshAfterInsertRows(){
		var isNewRows =emxUICore.selectNodes(oXML, "/mxRoot/rows//r[@status='new']");
		emxEditableTable.performXMLDataPost();
		turnOffProgress();
		var currentFrame=findFrame(getTopWindow(),"Questionnaire");
		if(isNewRows.length>0 & isDataModified()==0)
		{
			var selectedRow=currentFrame.emxEditableTable.getCheckedRows()[0];
			if(!selectedRow)
				selectedRow=emxUICore.selectSingleNode(oXML, "/mxRoot/rows//r[@id = '" + 0 + "']");
				
	        selectedRow.setAttribute("expand", false);
	        selectedRow.setAttribute("expandedLevels", "");
			currentFrame.emxEditableTable.expand([selectedRow.id], "1",true);
			
		}
		if(isDataModified()==0){
		currentFrame.emxEditableTable.refreshStructureWithOutSort();
		}
	}
	function refreshAfterInsertRowsConditionalQuestionnaire(){
		var isNewRows =emxUICore.selectNodes(oXML, "/mxRoot/rows//r[@status='new']");
		emxEditableTable.performXMLDataPost();
		turnOffProgress();
		var currentFrame=findFrame(getTopWindow(),"QuestionConditionalAttribute");
		if(isNewRows.length>0 & isDataModified()==0)
		{
			var selectedRow=currentFrame.emxEditableTable.getCheckedRows()[0];
			if(!selectedRow)
				selectedRow=emxUICore.selectSingleNode(oXML, "/mxRoot/rows//r[@id = '" + 0 + "']");
				
	        selectedRow.setAttribute("expand", false);
	        selectedRow.setAttribute("expandedLevels", "");
			currentFrame.emxEditableTable.expand([selectedRow.id], "1",true);
			
		}
		if(isDataModified()==0){
		currentFrame.emxEditableTable.refreshStructureWithOutSort();
		}
	}
	function refreshAfterInsertRowsForEForm(){
		var isNewRows =emxUICore.selectNodes(oXML, "/mxRoot/rows//r[@status='new']");
		emxEditableTable.performXMLDataPost();
		turnOffProgress();
		var currentFrame=findFrame(getTopWindow(),"detailsDisplay");
		var selectedRow=currentFrame.emxEditableTable.getCheckedRows()[0];


		if(isNewRows.length>0 & isDataModified()==0)
		{
			var selectedRow=currentFrame.emxEditableTable.getCheckedRows()[0];
			if(!selectedRow)
				selectedRow=emxUICore.selectSingleNode(oXML, "/mxRoot/rows//r[@id = '" + 0 + "']");
				
	        selectedRow.setAttribute("expand", false);
	        selectedRow.setAttribute("expandedLevels", "");
			currentFrame.emxEditableTable.expand([selectedRow.id], "1",true);
			
		}
		if(isDataModified()==0){
		currentFrame.emxEditableTable.refreshStructureWithOutSort();
		}
	}
	function enableQuestionInputValues()
	{
	var currentCell = emxEditableTable.getCurrentCell();
	var currentCellValue = currentCell.value.current.actual;
    var rowId = currentCell.rowID;

	
if(currentCellValue == 'Textbox' || currentCellValue == 'TextArea')
{
    emxEditableTable.setCellEditableByRowId(rowId,"ResponseRangeValues",false,true);
    emxEditableTable.setCellValueByRowId(rowId,"ResponseRangeValues","","",true);
  }
  else
    emxEditableTable.setCellEditableByRowId(rowId,"ResponseRangeValues",true,true);


	}
function modifyPromoteDemoteHeader(){
		var frames=document.getElementsByName("magicalframe");
		frames[0].removeAttribute("onload");
		var parentNode=frames[0].parentNode;
		parentNode.removeChild(frames[0]);

		var disp=parentNode.style.display;
		parentNode.style.display= 'none';
		parentNode.style.display = disp;

		var spanParent=getTopWindow().document.getElementById("extendedHeaderStatus");
		if(spanParent){
			for(var i=0;i< spanParent.children.length;i++)
			{
				if(spanParent.children[i].tagName=="A" && (spanParent.children[i].getAttribute("title")=="Promote" ||spanParent.children[i].getAttribute("title")=="Demote"))
				{
					var strHref=spanParent.children[i].href;
					spanParent.children[i].href="../questionnaire/enoQuestionnaireExecute.jsp?questionAction=ENOQuestionUIBase:doPromoteDemote&"+strHref.substring(strHref.lastIndexOf("action"))+"&validateToken=false";
				}
			}
		}
	}
	
	function modifyToolbar()
	{
		var frames=document.getElementsByName("magicalframe");
		frames[0].removeAttribute("onload");
		var parentNode=frames[0].parentNode;
		parentNode.removeChild(frames[0]);
		
		var questionnaireFrame=findFrame(getTopWindow(),"QuestionSubmitResponse");
		var toolbarChildren=questionnaireFrame.document.emxTableForm.children['pageHeadDiv'].children['divToolbarContainer'].children['divToolbar'].getElementsByTagName('td');
			
		for(var i=0;i< toolbarChildren.length;i++)
		{
				if(toolbarChildren[i].getAttribute("title")=="Remove inserted row(s)")
					toolbarChildren[i].parentNode.removeChild(toolbarChildren[i]);
		}
	}
		function getTemplateDetails()
	{		
			var templateId=document.getElementsByName("eFormOID")[0].value;
			var URL = "../questionnaire/enoQuestionnaireExecute.jsp?questionAction=ENOImpactQuestionnaire:getTemplateDetails&templateOID="+templateId;
			var responseText = emxUICore.getDataPost(URL);
			var responseArray = responseText.split('|');
			document.emxCreateForm.ResponsibleOrganization.value=responseArray[1];
			document.emxCreateForm.ResponsibleRole.value=responseArray[0];
			
			document.emxCreateForm.eFormRequirement.value=responseArray[2];
   	}
   		function validateEFormTableDueDate()
	{
		var vDueDate_msvalue = arguments[0];
	    var currentCell = emxEditableTable.getCurrentCell();
        var rowId = currentCell.rowID;
        var vDueDateCell = emxEditableTable.getCellValueByRowId(rowId,"DueDate");
		var vDueDateValue = vDueDateCell.value.current.actual;
		var vDueDate = new Date();
	    vDueDate.setTime(vDueDate_msvalue);
	    		
	    vDueDate.setHours(0,0,0,0); 
	    var todayDate = new Date();
	    todayDate.setHours(0,0,0,0); 
	    if(vDueDate=="")
		{
			 return true;
		}
		else
		{
   			if(parseInt(vDueDate.getTime()) < parseInt(todayDate.getTime()))
   			{
   			
  				return false;
    		}
    	}
	 return true;
	}
	
	function validateEFormDueDate()
	{
		var vDueDateValue = document.getElementById("Due Date").value;
		var vDueDate_msvalue = document.getElementsByName("Due Date_msvalue")[0];
		var vDueDate = new Date();
		vDueDate.setTime(vDueDate_msvalue.value);
		vDueDate.setHours(0,0,0,0); 
		var todayDate = new Date();
		todayDate.setHours(0,0,0,0); 
		if(vDueDateValue=="")
		{
			 return true;
		}
		else
		{
			if(parseInt(vDueDate.getTime()) < parseInt(todayDate.getTime()))
			{
				alert("<%=strAlertDate%>");
				return false;
    		}
    	}
	
	 return true;
	}
	
	function insertRowQuickAction(levelId)
	{
		editMode();
		//var nRow=emxUICore.selectSingleNode(oXML, "/mxRoot/rows//r[@id = '" +levelId  + "']");
		var selectedRows=getSelectedRowObjects();
		//alert(selectedRows.length);
		emxEditableTable.unselect(new Array(selectedRows));
		var arrRowId=new Array(levelId);
		emxEditableTable.select(arrRowId);
		//alert(''+nRow);
		emxEditableTable.createNewChildRow();
		//emxEditableTable.unselect(arrRowId);
	}
	function reloadColumn(){
	emxEditableTable.reloadCell('Response');
	}
function enableNoOfDays(){
		var currentCell = emxEditableTable.getCurrentCell();
		var currentCellValue = currentCell.value.current.actual;
    	var rowId = currentCell.rowID;
		if(currentCellValue == 'Assignee Set Due Date')
		{
    		emxEditableTable.setCellEditableByRowId(rowId,"DueDateOffset",false,true);
    		emxEditableTable.setCellValueByRowId(rowId,"DueDateOffset","","",true);
  		}
		 else
    		emxEditableTable.setCellEditableByRowId(rowId,"DueDateOffset",true,true);

}
function reloadResponseValue()
{
emxEditableTable.reloadCell('Response');
}

function checkForNumbers()
	{
		// \D matches any non-digit (short for [^0-9]).
		var regEx = new RegExp(/\D/);
		var val = arguments[0];
		if(regEx.test(val))
		{
			alert(val + ", <%=strAlertNumberAllowed%>");
			return false;
		}
		return true;
	}
function disableActionTaskNoOfDays(objectId)
	 {
	
		var startValue=document.getElementsByName(objectId+'StartValue')[0].value;
		var noOfDays=document.getElementsByName(objectId+'Days')[0];
	
		if(startValue!='Assignee Set Due Date')
		{
			noOfDays.disabled=false;
		}
		else
		{
			noOfDays.disabled=true;
		}
	 }
	 
