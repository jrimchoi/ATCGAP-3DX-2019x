<%@page import="com.matrixone.apps.domain.util.FrameworkUtil"%>
<%@page import="com.matrixone.apps.domain.util.EnoviaResourceBundle"%>
<%@page import="com.matrixone.apps.framework.ui.UIUtil"%>
<%@page import="com.matrixone.apps.domain.util.FrameworkException"%>
<%@page import="java.text.*,java.io.*, java.util.*, java.util.List, org.w3c.dom.Document"%>
<%@include file="../common/emxNavigatorInclude.inc"%>

<%
	String objectId = request.getParameter("objectId");
	context         = Framework.getFrameContext(session);
%>

<%!
	private final String getI18NString(Context context, String input){
	    return EnoviaResourceBundle.getProperty(context, "LQINCRStringResource", context.getLocale(), input);
	}

	private final String getI18NString(Context context, String stringResource, String input){
    	return EnoviaResourceBundle.getProperty(context, stringResource, context.getLocale(), input);
	}
	
%>

<!doctype html>
<html lang="en">
<head>
<meta http-equiv="cache-control" content="no-cache" />
<meta http-equiv="pragma" content="no-cache" />

<meta charset="utf-8">
<link rel="stylesheet" href="../plugins/libs/jqueryui/1.10.3/css/jquery-ui.css">
<link rel="stylesheet" href="../processsteps/css/override.css">
<link rel="stylesheet" href="../processsteps/css/ProcessGraph.css" />

<script src="../plugins/libs/jquery/2.0.3/jquery.js"></script>
<script src="../plugins/libs/jqueryui/1.10.3/js/jquery-ui.js"></script>
<script src="../common/scripts/emxUIConstants.js"></script>
<script src="../common/scripts/emxUICore.js"></script>
<script src="../common/scripts/emxUIModal.js"></script>
<script src="../webapps/c/UWA/js/UWA_W3C_Alone.js"></script>

<script>
	  function resizeIframe(){
		  var accHeight = $("#accordion1").height();
		  var frame = $('#referenceview', window.parent.document);
		  frame.height(accHeight);
	  }
	  
	  function setAccordionHeight(){
		  var accHeight = $("#accordion1").height();
		  var frame = $('#referenceview', window.parent.document);
		  frame.height(accHeight);
	  }
	  	
	  function getContentHeaderHTML(fromIssue, hasCAPA, hasChange){
		contentTable="<div><table><thead>";
		contentTable+="<th>"+"<%= getI18NString(context, "LQINCR.Common.Name")%>"+"</th>";
		contentTable+="<th>"+"<%= getI18NString(context, "LQINCR.Common.Type")%>"+"</th>";
		if(fromIssue === 'true')
		{
			contentTable+="<th>"+"<%=getI18NString(context, "NCR.ProcessSteps.Issue")%>"+"</th>";
		}
		contentTable+="<th>"+"<%= getI18NString(context, "NCR.ProcessSteps.NCRControls")%>"+"</th>";
		contentTable+="<th><img src=\"../common/images/iconSmallInvestigation.png\" border=\"0\" title=\""+"<%= getI18NString(context, "NCR.ProcessSteps.InvestigationStatus")%>"+"\"></th>";
		contentTable+="<th>"+"<%= getI18NString(context, "NCR.ProcessSteps.Originator")%>"+"</th>";
		if(hasCAPA === 'true')
		{
			contentTable+="<th>"+"<%= getI18NString(context, "LQINCR.NCRView.CAPA")%>"+"</th>";
		}
		if(hasChange === 'true')
		{
			contentTable+="<th>"+"<%= getI18NString(context, "LQINCR.Common.Change")%>"+"</th>";
		}
		contentTable+="</thead></div>";
		return contentTable;
	  }
	  
	  jQuery(document).ready(function () {

	  });
	  
	</script>

</head>
<body>

	<div id="accordion1" style="height:130px">
		<h3>
			<a href="#" step="Impacted Item Details" sequence="0" isactive="true"><%=getI18NString(context, "NCR.ProcessSteps.ImpactedItems")%></a>
		</h3>
		<div id="accordianTable" style="height:70%"></div>
	</div>

	<script>
	$(function() {
		$( "#accordion1" ).accordion({collapsible: true, active:0,  heightStyle: "content", create: function(event, ui){resizeIframe(this)}, activate: function(event, ui){resizeIframe(this)}});
	});

	var myAppsURL = "<%=FrameworkUtil.getMyAppsURL(context, request, response)%>";

	var impObjectIdSel = "id";
	var productNameSel = "attribute[Marketing Name]";
	var impTitleSel = "attribute[Title]";
	var impObjectNameSel = "name";
	var impTypeSel = "type";
	var impStatusSel ="current";
	var impOriginatorSel = "attribute[Originator]";
    var url =myAppsURL+"/resources/nonconformance/NCRServices/getImpactedItemsInfo?objectId=<%=objectId%>";

	var jsonData =  {
        type:"json",
        method:"GET",
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
        },
		onComplete : function(jsonObject) {
			var jsonArray = [];
			var ncResultantClosureTypeSel = "to[Impacted Item].from[NCR].attribute[NC Closure Type]";
			var invResultantStatusSel = "to[Impacted Item].from[NCR].from[Complaint Investigation].to.current";
			var issueResultantNameSel = "to[Impacted Item].from[NCR].to[Resolved To].from.name";
			var issueResultantIdSel = "to[Impacted Item].from[NCR].to[Resolved To].from.id";
			jsonObject.forEach(function(item){jsonArray.push(item);});
			var fromIssue = 'false', hasCAPA = 'false', hasChange = 'false';
            var invStatus='';
			if(jsonArray.length >= 1)
			{
				var acc1 = $("#accordion1");
				acc1[0].setAttribute('style','height:100px')
				var dataSourceQueryString =myAppsURL+"/resources/nonconformance/NCRServices/getConnectedDataSource?objectId=<%=objectId%>";
			    var dataSourceResponse = emxUICore.getData(dataSourceQueryString);
			    var jsDSObject = JSON.parse(dataSourceResponse);
			    var isCAPADSCounted=false,isChangeDSCounted=false;
			    for(var dscount=0;dscount<jsDSObject.length;dscount++)
			    	{
			    	if(!isCAPADSCounted&&jsDSObject[dscount].type.toString().contains("CAPA"))
			    	{
			    		isCAPADSCounted=true;
			    	}
			    	if(!isChangeDSCounted&&jsDSObject[dscount].type.toString().contains("Change"))
		    		{
			    		isChangeDSCounted=true;
		    		}
			    	if(isChangeDSCounted&&isCAPADSCounted)
			    		{
			    		break;
			    		}
			    	}
			   
				if(jsonArray[0][issueResultantIdSel] != null || jsonArray[0][issueResultantIdSel] != undefined)
				{
					fromIssue = 'true';
				}

				if(jsonArray[0][ncResultantClosureTypeSel] == 'CAPA')
				{
					hasCAPA = 'true';
				}
				else if(jsonArray[0][ncResultantClosureTypeSel] == 'Change')
				{
					hasChange = 'true';
			}
				invStatus = jsonArray[0][invResultantStatusSel];
			}
			var invComplete = "<%= getI18NString(context, "LQINCR.Investigation.InvestigationComplete")%>";

			if(isCAPADSCounted)
				hasCAPA = 'true';
			if(isChangeDSCounted)
				hasChange = 'true';
			
			var contentTable	= getContentHeaderHTML(fromIssue, hasCAPA, hasChange);
			var typeIcon = {};

			for (var i=0;i<jsonArray.length;i++) {
				contentTable += "<tr>";

				var displayText = "", impType = jsonArray[i][impTypeSel], impLink = "", impObjId = jsonArray[i][impObjectIdSel];
				if(jsonArray[i][productNameSel]!=null && jsonArray[i][productNameSel]!="")
				{
					displayText = jsonArray[i][productNameSel];
				}
				else if(jsonArray[i][impTitleSel]!=null && jsonArray[i][impTitleSel]!="")
				{
					displayText = jsonArray[i][impTitleSel];
				}
				else if(jsonArray[i][impObjectNameSel]!=null && jsonArray[i][impObjectNameSel]!="")
				{
					displayText = jsonArray[i][impObjectNameSel];
				}				
				var queryString="&ajaxMode=true&suiteKey=LQINCR&objectIds="+impObjId+"&displayText="+displayText+"&parentObjectId="+"<%=objectId%>"; //XSSOK
				var response = emxUICore.getDataPost("../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.ncr.services.ui.NCRProcessSteps:getObjectLinkIcon",queryString);
				var jsObject = eval('(' + response + ')');
				contentTable+="<td width=\"20%\">"+jsObject.result[0].value+"</td>";
				
				
				if(impType == null || impType == "")
					contentTable+="<td width=\"15%\"></td>";
				else
					contentTable+="<td width=\"15%\">"+impType+"</td>";

	if(fromIssue === 'true')
				{
					var queryString="&ajaxMode=true&suiteKey=LQINCR&objectIds="+jsonArray[0][issueResultantIdSel]+"&displayText="+jsonArray[0][issueResultantNameSel]+"&parentObjectId="+"<%=objectId%>"; //XSSOK
					var response = emxUICore.getDataPost("../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.ncr.services.ui.NCRProcessSteps:getObjectLinkIcon",queryString);
					var jsObject = eval('(' + response + ')');
					contentTable+="<td width=\"15%\">"+jsObject.result[0].value+"</td>";
				}
				var prdCtrlQueryString="../resources/nonconformance/NCRServices/getProductControlInfo?objectId=<%=objectId%>&impactedItemID="+impObjId;
				var prdCtrlResponse = emxUICore.getData(prdCtrlQueryString);
				var jsPCObject = JSON.parse(prdCtrlResponse);
				var pcObjIds = '', pcDisplayText = '',prdControlLink = '';
				if(jsPCObject)
				{					
					$.each(jsPCObject, function(key,val)
					{
						pcObjIds = pcObjIds + ',' + val.id;
						pcDisplayText = pcDisplayText + ',' + val.name;
					});
					var queryString="&ajaxMode=true&suiteKey=LQINCR&objectIds="+pcObjIds.slice(1)+"&displayText="+pcDisplayText.slice(1)+"&parentObjectId="+"<%=objectId%>"; //XSSOK
					var response = emxUICore.getDataPost("../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.ncr.services.ui.NCRProcessSteps:getObjectLinkIcon",queryString);
					var jsPCObjectLink = eval('(' + response + ')');
					var pcResult = jsPCObjectLink.result;
				    for(var j=0;j<pcResult.length;j++)
				    {
			    		if(prdControlLink == '')
				    	{
				    		prdControlLink=pcResult[j].value;
				    	}
				    	else
			    		{
				    		prdControlLink += "<br>"+pcResult[j].value;
				    }
				}
				}
				contentTable+="<td width=\"15%\">"+prdControlLink+"</td>";
				
				var invStatusSel = "to[Impacted Item].from[NCR|id==<%=objectId%>].from[Complaint Investigation].to.current";
				var notStarted = "<%= getI18NString(context, "NCR.ProcessSteps.NotStarted")%>";
				
				
				if(invStatus == null || invStatus == ""|| invStatus == undefined)
					contentTable+="<td width=\"5%\">"+notStarted+"</td>";
					else if(invStatus == 'Complete')
							contentTable+="<td width=\"5%\" ><img src=\"../common/images/iconStatusInvestigationComplete.png\" title=\"" + invComplete + "\" alt=\"" + invComplete + "\"></td>";
						else 
							contentTable+="<td width=\"5%\" ><img src=\"../common/images/iconSmallInvestigation.png\" title=\"" + invStatus + "\" alt=\"" + invStatus + "\"></td>";	
	
				
				if(jsonArray[i][impOriginatorSel] == null || jsonArray[i][impOriginatorSel] == "")
					contentTable+="<td width=\"10%\"></td>";
				else
					contentTable+="<td width=\"10%\">"+jsonArray[i][impOriginatorSel]+"</td>";

				if(hasCAPA === 'true')
				{
				

				    
					
					var dsObjIds = '', dsDisplayText = '',dataSourceLink = '';
					if(jsDSObject!=null&&jsDSObject.length!=0)
					{				
						$.each(jsDSObject, function(key,val)
						{  
						
						if(val.type.toString().contains("CAPA"))
							{
							dsObjIds = dsObjIds + ',' + val.id;
							dsDisplayText = dsDisplayText + ',' + val.name;
							}
						});
						
						if(dsObjIds!=''){
						var queryString="&ajaxMode=true&suiteKey=LQINCR&objectIds="+dsObjIds.slice(1)+"&displayText="+dsDisplayText.slice(1)+"&parentObjectId="+"<%=objectId%>"; //XSSOK
							var response = emxUICore
									.getDataPost(
											"../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.ncr.services.ui.NCRProcessSteps:getObjectLinkIcon",
											queryString);
						var jsDSObjectLink = eval('(' + response + ')');
						var dsResult = jsDSObjectLink.result;
						for (var j = 0; j < dsResult.length; j++) {
							if(dataSourceLink == '')
					    	{
								dataSourceLink = dsResult[j].value;
					    	}
					    	else
				    		{
					    		dataSourceLink += "<br>"+dsResult[j].value;
				    		}
						}
						}
					}

					contentTable += "<td width=\"15%\">" + dataSourceLink
							+ "</td>";

				
					}
			
				dsObjIds = '', dsDisplayText = '',dataSourceLink = '';
					if(hasChange === 'true')
				{
				var dsObjIds = '', dsDisplayText = '',dataSourceLink = '';
					if(jsDSObject!=null&&jsDSObject.length!=0)
					{				
						$.each(jsDSObject, function(key,val)
				{					
						if(val.type.toString().contains("Change"))
					{
						dsObjIds = dsObjIds + ',' + val.id;
						dsDisplayText = dsDisplayText + ',' + val.name;
						}
					});
						
						if(dsObjIds!='')
						{
					var queryString="&ajaxMode=true&suiteKey=LQINCR&objectIds="+dsObjIds.slice(1)+"&displayText="+dsDisplayText.slice(1)+"&parentObjectId="+"<%=objectId%>"; //XSSOK
						var response = emxUICore
								.getDataPost(
										"../LSA/Execute.jsp?action=com.dassault_systemes.enovia.lsa.ncr.services.ui.NCRProcessSteps:getObjectLinkIcon",
										queryString);
						var jsDSObjectLink = eval('(' + response + ')');
						var dsResult = jsDSObjectLink.result;
						for (var j = 0; j < dsResult.length; j++) {
							if(dataSourceLink == '')
					    	{
								dataSourceLink = dsResult[j].value;
					    	}
					    	else
				    		{
					    		dataSourceLink += "<br>"+dsResult[j].value;
				    		}
						}
						}
					}
					contentTable += "<td width=\"15%\">" + dataSourceLink
							+ "</td>";

					contentTable += " </tr>";
				}
				}
				$("#accordianTable").html(contentTable);

				setAccordionHeight();
			},
			onFailure : function(error) {
				alert(error);
			}
		};
		UWA.Data.request(url, jsonData);
	</script>


</body>
</html>
