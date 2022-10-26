<%@page import="com.matrixone.apps.domain.util.FrameworkUtil"%>
<%@page import="com.matrixone.apps.domain.util.EnoviaResourceBundle"%>
<%@page import="com.matrixone.apps.framework.ui.UIUtil"%>
<%@page import="com.matrixone.apps.domain.util.FrameworkException"%>
<%@page import="java.text.*,java.io.*, java.util.*, java.util.List, org.w3c.dom.Document"%>
<%@page import="com.dassault_systemes.enovia.processsteps.services.ProcessStepsConstants"%>
<%@page import="com.dassault_systemes.enovia.lsa.qic.QICConstants"%>
<%@page import="com.matrixone.apps.domain.util.XSSUtil"%>
<%@include file = "../common/emxNavigatorInclude.inc"%>
<%

	String objectId = request.getParameter("objectId");
	context         = Framework.getFrameContext(session);	
	//final String RELATIONSHIP_INPUT_REQUEST = PropertyUtil.getSchemaProperty(context, QICConstants.SYMBOLIC_RELATIONSHIP_INPUT_REQUEST);
	//String relatedCAPA=DomainObject.newInstance(context,objectId).getInfo(context,"to[" + RELATIONSHIP_INPUT_REQUEST + "].from.id");
	
%>

<!doctype html>
<html lang="en">
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
<style>
.accordian-div {
	height: 85px;
	overflow-y: scroll;
}

td {
    vertical-align: top;
}

</style>
	  <script>
	  
	  function resizeIframe(){
		  var accHeight = $("#accordion1").height();
		  var frame = $('#referenceview', window.parent.document);
		  frame.height(accHeight + 150);
	  }
	  
	  function accordionHeight(){
		  var accHeight = $("#accordion1").height();
		  
		  var frame = $('#referenceview', window.parent.document);
		  frame.height(accHeight + 150);
	  }
	  
	  function resizeIframe2()
	  {
		  var accHeight = $("#accordion2").height();
		  var frame = $('#referenceview', window.parent.document);
		 frame.height(accHeight + 150);
	  }
	  
	  function accordionHeight2()
	  {
		  var accHeight = $("#accordion2").height();
		  console.log("accordion2 height..." + accHeight);
		  
		  var frame = $('#referenceview', window.parent.document);
		  frame.height(accHeight + 150);
	  }
	  	
	  jQuery(document).ready(function () {

	  });
	  
	</script>
		
	</head>

	<body>

    <div id="accordion1">    	
    	<h3><a href="#" step="Impacted Items" sequence="0" isactive="true" ><%=getI18NString(context, "QIC.ProcessSteps.CAPA.ReferenceView.ImpactedItems")%></a></h3>
    	<div id='accordiantable'></div>
    </div>

	<script>

 // Trigger resize handler

	$(function() {
		$( "#accordion1" ).accordion({collapsible: true, active:0, autoHeight:"true", heightStyle: "content", create: function(event, ui){resizeIframe(this)}, activate: function(event, ui){resizeIframe(this)}});
	});
 
	var myAppsURL = "<%=FrameworkUtil.getMyAppsURL(context, request, response)%>";
	console.log("-- Calling getCAPAImpactedItems service --");
	UWA.Data.request(myAppsURL+"/resources/CAPADashboard/CAPADashboardDataService/getCAPAImpactedItems", {
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
        var contentTable='<%=getImpactedItemsHeaderHTML(context)%>';

        for (var i=0;i<jsonArray.length;i++) {
                debugger;               
        		var impactedItemsArray = jsonArray[i].ImpactedItems;  
        		
                for (var j=0;j<impactedItemsArray.length;j++)
                {
                	contentTable+= "<tr>"; 
                	contentTable+=getTableCell(impactedItemsArray[j].objectLink,"13");
                	contentTable+=getTableCell(impactedItemsArray[j].i18Type,"13");
                	contentTable+=getTableCell(impactedItemsArray[j].i18Current,"13");
                	contentTable+=getTableCell(impactedItemsArray[j].revision,"13");                	
                	contentTable+=getTableCell(impactedItemsArray[j].change,"20");
                	contentTable+=getTableCell(impactedItemsArray[j].description);
                	                	
               		contentTable+=" </tr>"
                }
        }  
        
        var accordian 		= 	document.getElementById('accordiantable');
	    accordian.innerHTML	=	contentTable;
	    accordionHeight();       
    }
    });	
	
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

<div id="accordion2">
		<h3><a href="#" step="Data Sources" sequence="0" isactive="true" ><%=getI18NString(context, "QIC.ProcessSteps.CAPA.ReferenceView.DataSources")%></a></h3>    	
    	<div id='accordiantable2'></div>
    </div>
	<script>

	$(function() {
		$( "#accordion2" ).accordion({collapsible: true, active:0,  heightStyle: "content", create: function(event, ui){resizeIframe2(this)}, activate: function(event, ui){resizeIframe(this)}});
	});
	
	var myAppsURL = "<%=FrameworkUtil.getMyAppsURL(context, request, response)%>";
    UWA.Data.request(myAppsURL+"/resources/CAPADashboard/CAPADashboardDataService/getCAPADataSources", {
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
        var contentTable='<%=getHeaderHTML(context)%>';

        for (var i=0;i<jsonArray.length;i++) {
                debugger;               
        		var dataSourceArray = jsonArray[i].DataSources;  
        		
                for (var j=0;j<dataSourceArray.length;j++)
                {
                	contentTable+= "<tr>";
                	contentTable+=getTableCell(dataSourceArray[j].objectLink,"13");
                	contentTable+=getTableCell(dataSourceArray[j].i18Type,"13");
                	contentTable+=getTableCell(dataSourceArray[j].i18Current,"13");
                	contentTable+=getTableCell(dataSourceArray[j].owner,"13");
                	contentTable+=getTableCell(dataSourceArray[j].caparequest,"20");
                	contentTable+=getTableCell(dataSourceArray[j].description); 
                	                	
               		contentTable+=" </tr>"
                }
        }  
        
        var accordian 		= 	document.getElementById('accordiantable2');
	    accordian.innerHTML	=	contentTable;
	    accordionHeight2();       
    }
    });	
    
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

<%!

	private String getImpactedItemsHeaderHTML(Context context)
	{
		 StringBuilder contentTable=new StringBuilder();
		  contentTable.append("<div class=\"accordian-div\">");
		    contentTable.append("<table>");
		    contentTable.append("<thead>");
		    contentTable.append("<th>"+XSSUtil.encodeForHTMLAttribute(context,getI18NString(context, "QIC.Common.Name"))+"</th>");
		    contentTable.append("<th>"+XSSUtil.encodeForHTMLAttribute(context,getI18NString(context, "QIC.Common.Type"))+"</th>");
		    contentTable.append("<th>"+XSSUtil.encodeForHTMLAttribute(context,getI18NString(context, "LQICAPA.Common.Status"))+"</th>");
		    contentTable.append("<th>"+XSSUtil.encodeForHTMLAttribute(context,getI18NString(context, "QIC.Common.Revision"))+"</th>");
		    contentTable.append("<th>"+XSSUtil.encodeForHTMLAttribute(context,getI18NString(context, "QIC.ProcessSteps.CAPA.RelatedChange"))+"</th>");
		    contentTable.append("<th>"+XSSUtil.encodeForHTMLAttribute(context,getI18NString(context, "QIC.Common.Description"))+"</th>");
		    contentTable.append("</thead>");
		    contentTable.append("</div>");
		    return contentTable.toString(); //TODO: I18N
	}	

	private String getHeaderHTML(Context context)	{
		 StringBuilder contentTable=new StringBuilder();
		  contentTable.append("<div class=\"accordian-div\">");
		    contentTable.append("<table>");
		    contentTable.append("<thead>");
		    contentTable.append("<th>"+XSSUtil.encodeForHTMLAttribute(context,getI18NString(context, "QIC.Common.Name"))+"</th>");
		    contentTable.append("<th>"+XSSUtil.encodeForHTMLAttribute(context,getI18NString(context, "QIC.Common.Type"))+"</th>");
		    contentTable.append("<th>"+XSSUtil.encodeForHTMLAttribute(context,getI18NString(context, "LQICAPA.Common.Status"))+"</th>"); 
		    contentTable.append("<th>"+XSSUtil.encodeForHTMLAttribute(context,getI18NString(context, "QIC.Common.Owner"))+"</th>");	
		    contentTable.append("<th>"+XSSUtil.encodeForHTMLAttribute(context,getI18NString(context, "QIC.ProcessSteps.CAPA.RelatedRequest"))+"</th>");
		    contentTable.append("<th>"+XSSUtil.encodeForHTMLAttribute(context,getI18NString(context, "QIC.Common.Description"))+"</th>");	
		    
		    contentTable.append("</thead>");
		    contentTable.append("</div>");
		    return contentTable.toString(); //TODO: I18N
	}

	private String getI18NString(Context context, String input){
	    return EnoviaResourceBundle.getProperty(context, "LQICAPAStringResource", context.getLocale(), input);
	}
	

%>
</body>
</html>
