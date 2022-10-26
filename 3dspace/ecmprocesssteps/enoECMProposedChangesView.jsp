<%@page import="com.matrixone.apps.domain.util.FrameworkUtil"%>
<%@page import="com.matrixone.apps.domain.util.EnoviaResourceBundle"%>
<%@page import="com.matrixone.apps.domain.DomainObject"%>
<%@page import="com.matrixone.apps.framework.ui.UIUtil"%>
<%@page import="com.matrixone.apps.domain.util.FrameworkException"%>
<%@page import="java.text.*,java.io.*, java.util.*, java.util.List, org.w3c.dom.Document"%>
<%@page import="com.dassault_systemes.enovia.processsteps.services.ProcessStepsConstants"%>
<%@include file = "../common/emxNavigatorInclude.inc"%>
<%

	String objectId = request.getParameter("objectId");
	context         = Framework.getFrameContext(session);
	String currentState=DomainObject.newInstance(context,objectId).getInfo(context,DomainObject.SELECT_CURRENT);
	
    String selectedAffectedItems    = request.getParameter("selectedAffectedItems");
	String selectedProposedItem		= request.getParameter("selectedProposedItem");
	if(UIUtil.isNotNullAndNotEmpty(selectedAffectedItems) && UIUtil.isNotNullAndNotEmpty(selectedProposedItem)&&!selectedAffectedItems.contains(selectedProposedItem)){
		selectedAffectedItems+='|'+selectedProposedItem;
	}
	else if (UIUtil.isNotNullAndNotEmpty(selectedProposedItem)&&!selectedAffectedItems.contains(selectedProposedItem)){
		selectedAffectedItems=selectedProposedItem;
	}
%>

<!doctype html>
<html lang="en">
	<style>
.accordian-div {
height: 80px;
overflow-y: scroll;
}

</style>
	<head>
	  <meta http-equiv="cache-control" content="no-cache" /> <!-- TBD: Does this impact performance?-->
	  <meta http-equiv="pragma" content="no-cache" />  <!-- TBD: Does this impact performance?-->

	  <meta charset="utf-8">
	  <link rel="stylesheet" href="../plugins/libs/jqueryui/1.10.3/css/jquery-ui.css">
      <link rel="stylesheet" href="../processsteps/css/override.css">
      
      
      <script src="../plugins/libs/jquery/2.0.3/jquery.js"></script>
      <script src="../plugins/libs/jqueryui/1.10.3/js/jquery-ui.js"></script>
      <script src="../common/scripts/emxUIConstants.js"></script>
      <script src="../common/scripts/emxUICore.js"></script>
      <script src="../common/scripts/emxUIModal.js"></script>
      <script src="../webapps/c/UWA/js/UWA_W3C_Alone.js"></script>

	  <script>
	  function resizeIframe2()
	  {
		  var accHeight = $("#accordion2").height();
		  var frame = $('#referenceview', window.parent.document);
		//  frame.height(accHeight + 45);
	  }
	  
	  function resizeIframe(){
		  var accHeight = $("#accordion1").height();
		  var frame = $('#referenceview', window.parent.document);
		  //frame.height(accHeight + 15);
	  }
	  
	  function setAccordionHeight(){
		  var accHeight = $("#accordion1").height();
		  
		  var frame = $('#referenceview', window.parent.document);
		  //frame.height(accHeight + 15);
	  }
	  	
	  jQuery(document).ready(function () {

	  });
	   function setAccordionHeight2()
	  {
		  var accHeight = $("#accordion2").height();
		  console.log("accordion2 height..." + accHeight);
	  
		  var frame = $('#referenceview', window.parent.document);
		  //frame.height(accHeight + 45);
	  }
	</script>
		
	</head>
	<body>

    <div id="accordion1">
    	<h3><a href="#" step="Proposed Changes" sequence="0" isactive="true" >Proposed Changes</a></h3>
    	<div id='accordianTable'></div>
    </div>

	<script>

	


	$(function() {
		$( "#accordion1" ).accordion({collapsible: true, active:0,  heightStyle: "content", create: function(event, ui){resizeIframe(this)}, activate: function(event, ui){resizeIframe(this)}});
	});
		</script>
	
	<script>
	var myAppsURL = "<%=FrameworkUtil.getMyAppsURL(context, request, response)%>";
    UWA.Data.request(myAppsURL+"/resources/ecmProcessSteps/ECMProcessStepsService/getProposedChangesData", {
        type:"json",
        method:"POST",
        data:"{\"objectId\":\"<%=objectId%>\"}",
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
        },
    onComplete : function(jsonObject) {

    	var json 			= jsonObject.data;
        var jsonArray		= JSON.parse(json);
        var contentTable	= '<%=getChangeContentHeaderHTML(context)%>';

        for (var i=0;i<jsonArray.length;i++) {
                
        		var proposedItemArray = jsonArray[i].ProposedItems;
        		
                if(proposedItemArray.length>1)
                    contentTable	= '<%=getChangeContentHeaderHTMLWithFilter(context)%>';
                    
                var initialSelectedObj	= jsonArray[i].<%=ProcessStepsConstants.SELECTED_PROPOSED_ITEMS%>;
                for (var j=0;j<proposedItemArray.length;j++)
                {
                        contentTable				+= "<tr>";
                        var selectedAffectedItems	= '<%=selectedAffectedItems%>';
                        
                        if(proposedItemArray.length>1)
                        { 
                            contentTable+="<td width=\"2%\"><input type=checkbox checked id='"+proposedItemArray[j].id+"'onclick=\"applyProposedChangeFilter(this,'<%=objectId%>','"+proposedItemArray[j].id+"','"+initialSelectedObj+"')\"></input></td>";
                        }
                        
                        if(proposedItemArray[j]["attribute[Title]"]==null)
                            contentTable+="<td width=\"10%\"></td>";
                        else
                            contentTable+="<td width=\"10%\">"+proposedItemArray[j]["attribute[Title]"]+"</td>";
                            
                        contentTable+="<td>"+proposedItemArray[j].type+"</td>";
                        contentTable+="<td>"+proposedItemArray[j].name+"</td>";
                        contentTable+="<td>"+proposedItemArray[j].current+"</td>";
                        contentTable+="<td>"+proposedItemArray[j].revision+"</td>";
                        if(proposedItemArray[j].action==null||proposedItemArray[j].action=="null")
                            contentTable+="<td></td>";
                        else    
                            contentTable+="<td>"+proposedItemArray[j].action+"</td>";
                        if(proposedItemArray[j].changeInfo==null||proposedItemArray[j].changeInfo=="null")
                            contentTable+="<td></td>";
                        else
                            contentTable+="<td>"+proposedItemArray[j].changeInfo+"</td>";
                        contentTable+=" </tr>";
                }
        }
        $("#accordianTable").html(contentTable);
        
        setAccordionHeight();
    }
    });
    
    /*function selectAffectedItem( objectID, selectedId,initialSelectionObjId ) {
        
        var mycontentFrame 	= findFrame(getTopWindow(),"PROSProcessSteps");
    	
    	if(!mycontentFrame)
    		mycontentFrame  = findFrame(getTopWindow(),"detailsDisplay");
    	
    	var url				= mycontentFrame.location.href;
    	
        var url	= mycontentFrame.location.href;
        var a	= url.split("?");
        
        var selectedProposedItem	= selectedId;
        var selectedAffectedItems	= '<%=selectedAffectedItems%>';
        var checkboxSelected 		= document.getElementById(selectedId);
        
        var initialCheckboxSelected = document.getElementById(initialSelectionObjId);
        
        if(initialCheckboxSelected.checked){
            if(selectedAffectedItems!="" && selectedAffectedItems!="null" && selectedAffectedItems.indexOf(initialSelectionObjId)<0)
                selectedAffectedItems+="|"+selectedProposedItem;
            else if(selectedAffectedItems=="" || selectedAffectedItems=="null" )
                selectedAffectedItems=initialSelectionObjId;
        }
        
        if(checkboxSelected.checked){
            if(selectedAffectedItems!="" && selectedAffectedItems!="null")
                selectedAffectedItems+="|"+selectedProposedItem;
            else
                selectedAffectedItems="";
            mycontentFrame.location.href=a[0]+"?objectId="+objectID+"&selectedProposedItem="+selectedProposedItem+"&selectedAffectedItems="+selectedAffectedItems;
        }
        else{
            var newSelectedItem="";
            if(selectedAffectedItems!="" && selectedAffectedItems!="null")
            {
                var arrselectedAffectedItems=selectedAffectedItems.split('|');
                if(arrselectedAffectedItems.indexOf(selectedId)>=0)
                {
                    var index = arrselectedAffectedItems.indexOf(selectedId);
                    if (index > -1) {
                        var array=arrselectedAffectedItems.splice(index, 1);
                        for(var i=0;i<arrselectedAffectedItems.length;i++)
                        {
                            newSelectedItem=arrselectedAffectedItems[i]+"|";
                        }
                        if(newSelectedItem.length>1)
                            newSelectedItem = newSelectedItem.substring(0, newSelectedItem.length-1);
                    }
                }
            }
            if(newSelectedItem=="")
                newSelectedItem="doNothing";
              mycontentFrame.location.href=a[0]+"?objectId="+objectID+"&selectedAffectedItems="+newSelectedItem;
        }
    }*/
    
    function applyProposedChangeFilter(selectedCheckbox, objectID, selectedId, initialSelectionObjId)
    {    	
    	var propChgFilterItmsStr	= "";
    	var checkedElements			= $('input:checked');
    	
    	if(checkedElements.length===0) {
    		
    		alert('<%=getI18NString(context, "enoECMProcessSteps.ProcessSteps.Message.CannotDeselectAllProposedChanges")%>');
    		selectedCheckbox.checked = true;
    	} else {
    	
	    	checkedElements.each(function (i) {
	    		
	    		propChgFilterItmsStr += $(this).attr('id');
	    		
	    		if(i < checkedElements.length-1)
	    			propChgFilterItmsStr += "|";
	    	});
	    	
			/* var mycontentFrame 	= findFrame(getTopWindow(),"PROSProcessSteps");
	    	
	    	if(!mycontentFrame)
	    		mycontentFrame  = findFrame(getTopWindow(),"detailsDisplay");
	    	
	    	mycontentFrame.loadProcessSteps(objectID, propChgFilterItmsStr); */
	    	
	    	
	    	  require(['DS/PlatformAPI/PlatformAPI',
				          'DS/ENOProcessStepsUX/scripts/ProcessSteps'],
						 function(PlatformAPI, ProcessSteps) {
							 window.enoviaProcessStepsWidget = {

								mySecurityContext 	: "",
								myRole 				: "",
								collabspace 		: "",
								tenant				: "",
								proxy				: "passport",
								getSecurityContext	: function () {
									return this.mySecurityContext;
								},
								getTenant			: function () {
									return this.tenant;
								},
								getProxy			: function () {
									return this.proxy;
	        		    },
	        		                   
							};

	                var myAppsURL = "<%=FrameworkUtil.getMyAppsURL(context, request, response)%>";
	                    	
							var curTenant = "";
							<%
								if(!FrameworkUtil.isOnPremise(context)) {
							%>
								curTenant = "<%=XSSUtil.encodeForJavaScript(context, context.getTenant())%>";
								enoviaProcessStepsWidget.tenant = curTenant;
							<%
										}
							%>
	        		              		                
							 var divForProcessSteps=document.getElementById("accordianTasks");
		                     divForProcessSteps.innerHTML="";
							var content = ProcessSteps.loadProcessSteps(myAppsURL, 'passport', curTenant, '', objId, propChgFilterItmsStr,'');

	            });

    	}
    }
	
	if(!String.prototype.format) {
		  String.prototype.format = function() {
		    var args = arguments;
		    return this.replace(/{(\d+)}/g, function(match, number) { 
		      return typeof args[number] != 'undefined'
		        ? args[number]
		        : match
		      ;
		    });
		  };
	}
	
	function getTableCell(cellValue, width)
	{
		if(width) {
			
			return "<td width=\"{0}%\">{1}</td>".format(width, cellValue);
		} else {
			
			return "<td>{0}</td>".format(cellValue);
		}
	}
	
</script>


<div id="accordion2" style="display:none">
    	<h3><a href="#" step="Realized Changes" sequence="0" isactive="true" >Realized Changes</a></h3>
    	<div id='accordianTable2'></div>
    </div>

<script>
$(function() {
		$( "#accordion2" ).accordion({collapsible: true, active:0,  heightStyle: "content", create: function(event, ui){resizeIframe2(this)}, activate: function(event, ui){resizeIframe(this)}});
	});

var myAppsURL = "<%=FrameworkUtil.getMyAppsURL(context, request, response)%>";
UWA.Data.request(myAppsURL+"/resources/ecmProcessSteps/ECMProcessStepsService/getRealizedChangesData", {
        type:"json",
        method:"POST",
        data:"{\"objectId\":\"<%=objectId%>\"}",
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
        },
    onComplete : function(jsonObject) {
debugger;
    	var json 			= jsonObject.data;
        var jsonArray		= JSON.parse(json);
        var contentTable	= '<%=getChangeContentHeaderHTML(context)%>';

        for (var i=0;i<jsonArray.length;i++) {
                
        		var proposedItemArray = jsonArray[i].RealizedItems;
        		
                if(proposedItemArray.length>1)
                    contentTable	= '<%=getChangeContentHeaderHTMLWithFilter(context)%>';
                    
                var initialSelectedObj	= jsonArray[i].<%=ProcessStepsConstants.SELECTED_PROPOSED_ITEMS%>;
                for (var j=0;j<proposedItemArray.length;j++)
                {
                        contentTable				+= "<tr>";
                        var selectedAffectedItems	= '<%=selectedAffectedItems%>';
                        
                        if(proposedItemArray.length>1)
                        { 
                            contentTable+="<td width=\"2%\"><input type=checkbox checked id='"+proposedItemArray[j].id+"'onclick=\"applyProposedChangeFilter(this,'<%=objectId%>','"+proposedItemArray[j].id+"','"+initialSelectedObj+"')\"></input></td>";
                        }
                        
                        if(proposedItemArray[j]["attribute[Title]"]==null)
                            contentTable+="<td width=\"10%\"></td>";
                        else
                            contentTable+="<td width=\"10%\">"+proposedItemArray[j]["attribute[Title]"]+"</td>";
                            
                        contentTable+="<td>"+proposedItemArray[j].type+"</td>";
                        contentTable+="<td>"+proposedItemArray[j].name+"</td>";
                        contentTable+="<td>"+proposedItemArray[j].current+"</td>";
                        contentTable+="<td>"+proposedItemArray[j].revision+"</td>";
                        if(proposedItemArray[j].action==null||proposedItemArray[j].action=="null")
                            contentTable+="<td></td>";
                        else    
                            contentTable+="<td>"+proposedItemArray[j].action+"</td>";
                        if(proposedItemArray[j].changeInfo==null||proposedItemArray[j].changeInfo=="null")
                            contentTable+="<td></td>";
                        else
                            contentTable+="<td>"+proposedItemArray[j].changeInfo+"</td>";
                        contentTable+=" </tr>";
                }
				if(proposedItemArray.length>0)
				{
					var scc2=document.getElementById("accordion2");
					scc2.style.display="block";
					$(function() {
							$( "#accordion1" ).accordion({collapsible: true, active:"none",  heightStyle: "content", create: function(event, ui){resizeIframe(this)}, activate: function(event, ui){resizeIframe(this)}});
						});
				}
        }
		
		
	
        $("#accordianTable2").html(contentTable);
        setAccordionHeight2();
    }
    });


</script>


<%!

	private String getChangeContentHeaderHTML(Context context)	{
	    StringBuilder contentTable=new StringBuilder();
	    contentTable.append("<div>");
	    contentTable.append("<table>");
	    contentTable.append("<thead>");
	    contentTable.append("<th width=\"10%\">"+getI18NString(context, "enoECMProcessSteps.Label.Title")+"</th>");
	    contentTable.append("<th>"+getI18NString(context, "enoECMProcessSteps.Label.Type")+"</th>");
	    contentTable.append("<th>"+getI18NString(context, "enoECMProcessSteps.Label.Name")+"</th>");
	    contentTable.append("<th>"+getI18NString(context, "enoECMProcessSteps.Label.State")+"</th>");
	    contentTable.append("<th>"+getI18NString(context, "enoECMProcessSteps.Label.Revision")+"</th>");
	    contentTable.append("<th>"+getI18NString(context, "enoECMProcessSteps.Label.Actions")+"</th>");
	    contentTable.append("<th>"+getI18NString(context, "enoECMProcessSteps.Label.ChangeInformation")+"</th>");
	    contentTable.append("</thead>");
	    contentTable.append("</div>");
	    return contentTable.toString(); //TODO: I18N
	}

	private String getChangeContentHeaderHTMLWithFilter(Context context){
	    StringBuilder contentTable=new StringBuilder();
	    contentTable.append("<div>");
	    contentTable.append("<table>");
	    contentTable.append("<thead>");
		contentTable.append("<th width=\"10%\"><img src=\"../common/images/iconActionFilter.gif\" width=\"16px\" height=\"15px\" title=\""+getI18NString(context, "enoECMProcessSteps.Label.Filter")+"\"/></th>");
		contentTable.append("<th width=\"10%\">"+getI18NString(context, "enoECMProcessSteps.Label.Title")+"</th>");
	    contentTable.append("<th>"+getI18NString(context, "enoECMProcessSteps.Label.Type")+"</th>");
		contentTable.append("<th>"+getI18NString(context, "enoECMProcessSteps.Label.Name")+"</th>");
		contentTable.append("<th>"+getI18NString(context, "enoECMProcessSteps.Label.State")+"</th>");
		contentTable.append("<th>"+getI18NString(context, "enoECMProcessSteps.Label.Revision")+"</th>");
	    contentTable.append("<th>"+getI18NString(context, "enoECMProcessSteps.Label.Actions")+"</th>");
		contentTable.append("<th>"+getI18NString(context, "enoECMProcessSteps.Label.ChangeInformation")+"</th>");
	    contentTable.append("</thead>");
	    contentTable.append("</div>");
	    return contentTable.toString();
	}

	private String getI18NString(Context context, String input){
	    return EnoviaResourceBundle.getProperty(context, "enoECMProcessStepsStringResource", context.getLocale(), input);
	}

%>
</body>
</html>
