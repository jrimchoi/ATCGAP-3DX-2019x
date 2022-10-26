<%@page import="com.matrixone.apps.domain.util.FrameworkUtil"%>
<%@page import="com.matrixone.apps.domain.util.EnoviaResourceBundle"%>
<%@page import="com.matrixone.apps.domain.util.FrameworkException"%>
<%@page import="java.text.*,java.io.*, java.util.*, java.util.List, org.w3c.dom.Document"%>
<%@page import="com.matrixone.apps.domain.util.XSSUtil"%>
<%@include file = "../common/emxNavigatorInclude.inc"%>
<%

	String objectId = request.getParameter("objectId");
	context         = Framework.getFrameContext(session);
	
	String strFileContent=getI18NString(context, "enoDocumentControl.Label.FileContent");
%>

<!doctype html>
<html lang="en">
	<head>
	  <meta http-equiv="cache-control" content="no-cache" /> <!-- TBD: Does this impact performance?-->
	  <meta http-equiv="pragma" content="no-cache" />  <!-- TBD: Does this impact performance?-->

	  <meta charset="utf-8">
	  <link rel="stylesheet" href="../plugins/libs/jqueryui/1.10.3/css/jquery-ui.css">
   
      <script src="../plugins/libs/jquery/2.0.3/jquery.js"></script>
      <script src="../plugins/libs/jqueryui/1.10.3/js/jquery-ui.js"></script>
      <script src="../common/scripts/emxUIConstants.js"></script>
      <script src="../common/scripts/emxUICore.js"></script>
      <script src="../common/scripts/emxUIModal.js"></script>
      <script src="../webapps/c/UWA/js/UWA_W3C_Alone.js"></script>


<link rel="stylesheet" href="../webapps/ENOProcessStepsUX/ENOProcessStepsUX.css" /> 
	
     <link rel="stylesheet" href="../processsteps/css/override.css">  			  	  
    


<!-- Added below one for Drag and Drop functionality -->
<link rel="stylesheet" href="../common/styles/emxUIExtendedHeader.css"/>
<script src="../common/scripts/emxJSValidationUtil.js"></script>
<script src="../common/scripts/emxExtendedPageHeaderFreezePaneValidation.js"></script>
<script src="../processsteps/scripts/enoProcessStepsUtil.js"></script>

	  <script>
	  
	  function resizeIframe(){
		  var accHeight = $("#accordion1").height();
		  var frame = $('#referenceview', window.parent.document);
		  frame.height(accHeight + 15);
	  }
	  
	  function setAccordionHeight(){
		  var accHeight = $("#accordion1").height();
		  
		  var frame = $('#referenceview', window.parent.document);
		  frame.height(accHeight + 15);
	  }
	  	
	  jQuery(document).ready(function () {

	    });
	  
	  </script>
		
	</head>
	<body>

    <div id="accordion1">
    	<h3><a href="#" step="File Content" sequence="0" isactive="true" ><%=strFileContent%></a></h3>
    	<div id='accordianTable'></div>
    </div>

	<script>

	$(function() {
		$( "#accordion1" ).accordion({collapsible: true, active:0,  heightStyle: "content", create: function(event, ui){resizeIframe(this)}, activate: function(event, ui){resizeIframe(this)}});
	});
	
	var myAppsURL = "<%=FrameworkUtil.getMyAppsURL(context, request, response)%>";
	UWA.Data.request(myAppsURL+"/resources/dclProcessSteps/DCLProcessStepsService/getFileContentsData", {
    type:"json",
    method:"POST",
    data:"{\"objectId\":\"<%=objectId%>\",\"MCSURL\":\""+myAppsURL+"\"}",
    headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
    },
	onComplete : function(jsonObject) {

	    var json 		= 	jsonObject.data;
	    var jsonArray	=	JSON.parse(json);
	
	    var contentTable='<%=getHeaderHTML(context)%>';
	
	    for (var i=0;i<jsonArray.length;i++)
	    {
		    var proposedItemArray	=	jsonArray[i].FileContents;
		    
		    for (var j=0;j<proposedItemArray.length;j++)
		    {
		        contentTable+="<tr>";
		        
		        if(proposedItemArray[j]["attribute[Title]"]==null) {
		            contentTable+=getTableCell("", "10");
		        } else {
		            contentTable+=getTableCell(proposedItemArray[j]["attribute[Title]"], "10");//"<td width=\"10%\">"+proposedItemArray[j]["attribute[Title]"]+"</td>";
		        }
		            
		       contentTable+=getTableCell(proposedItemArray[j].type);
		       contentTable+=getTableCell(proposedItemArray[j].revision);
		       contentTable+=getTableCell(proposedItemArray[j].actionLink);
		       var commentStr=proposedItemArray[j].comments;
		       if(commentStr==null){
		    	   contentTable+=getTableCell("");
		       }
		       else{
		    	   contentTable+=getTableCell(proposedItemArray[j].comments);
		       }
		       contentTable+=getTableCell(proposedItemArray[j].owner);
		       contentTable+=getTableCell(proposedItemArray[j].modified);
		       contentTable+=getTableCell(proposedItemArray[j].size);
		       contentTable+= "</tr>";
		    }
	    }
	        
        var accordian 		= 	document.getElementById('accordianTable');
        accordian.innerHTML	=	contentTable;
        setAccordionHeight();
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

	private String getHeaderHTML(Context context){
	    StringBuilder contentTable=new StringBuilder();
	    contentTable.append("<div>");
	    contentTable.append("<table>");
	    contentTable.append("<thead>");
	    contentTable.append("<th width=\"10%\">"+XSSUtil.encodeForHTMLAttribute(context,getI18NString(context, "enoDocumentControl.Label.FileName"))+"</th>");
	    contentTable.append("<th>"+XSSUtil.encodeForHTMLAttribute(context,getI18NString(context, "enoDocumentControl.Label.Type"))+"</th>");
	    contentTable.append("<th>"+XSSUtil.encodeForHTMLAttribute(context,getI18NString(context, "enoDocumentControl.Label.Version"))+"</th>");
	    contentTable.append("<th>"+XSSUtil.encodeForHTMLAttribute(context,getI18NString(context, "enoDocumentControl.Label.Actions"))+"</th>");
	    contentTable.append("<th>"+XSSUtil.encodeForHTMLAttribute(context,getI18NString(context, "enoDocumentControl.Label.Comments"))+"</th>");
	    contentTable.append("<th>"+XSSUtil.encodeForHTMLAttribute(context,getI18NString(context, "enoDocumentControl.Label.Originator"))+"</th>");
	    contentTable.append("<th>"+XSSUtil.encodeForHTMLAttribute(context,getI18NString(context, "enoDocumentControl.Label.ModifiedDate"))+"</th>");
	    contentTable.append("<th>"+XSSUtil.encodeForHTMLAttribute(context,getI18NString(context, "enoDocumentControl.Label.FileSize"))+"</th>");
	    contentTable.append("</thead>");
	    contentTable.append("</div>");
	    return contentTable.toString();
	}

	private String getI18NString(Context context, String input){
	    return EnoviaResourceBundle.getProperty(context, "enoDocumentControlStringResource", context.getLocale(), input);
	}

%>
</body>
</html>
