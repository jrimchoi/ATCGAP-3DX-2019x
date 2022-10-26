<%@page import="com.matrixone.apps.domain.util.FrameworkUtil"%>
<%@page import="com.matrixone.apps.framework.ui.UIUtil"%>
<%@page import="com.matrixone.apps.domain.util.FrameworkException"%>
<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@page import="java.text.*,java.io.*, java.util.*, java.util.List, org.w3c.dom.Document"%>
<%@page import="com.dassault_systemes.enovia.processsteps.services.ProcessStepsConstants"%>
<%@page import="com.dassault_systemes.enovia.processsteps.services.impl.ProcessSteps"%>
<%@page import="com.dassault_systemes.enovia.processsteps.services.Step"%>
<%@page import="com.dassault_systemes.enovia.processsteps.services.Task"%>
<%@page import="com.matrixone.apps.domain.util.eMatrixDateFormat"%>
<%

String errorMessage			= null;
boolean initialPageLoad		= false;
try{

	String languageStr 		= request.getHeader("Accept-Language");
	String inputStep 		= request.getParameter("step");
	String inputSequence 	= request.getParameter("sequence");
	String objectId			= request.getParameter("objectId");
	String rootObjectId		= request.getParameter("rootobjectId");
	String operationName	= request.getParameter("operationName");
	String queryStr 		= request.getQueryString();
	String isActiveStep 	= request.getParameter("isactive");
	String isElapsedStep 	= request.getParameter("iselapsed");
	String inputStepState	= request.getParameter("state");
	String inputStepPolicy	= request.getParameter("policy");
	Locale locale 			= request.getLocale();

	String selectedAffectedItems	= request.getParameter("selectedAffectedItems");
	String selectedProposedItem	= request.getParameter("selectedProposedItem");
	if(UIUtil.isNotNullAndNotEmpty(selectedAffectedItems) && UIUtil.isNotNullAndNotEmpty(selectedProposedItem)&&!selectedAffectedItems.contains(selectedProposedItem)){
		selectedAffectedItems+='|'+selectedProposedItem;
	}
	else if (UIUtil.isNotNullAndNotEmpty(selectedProposedItem)&&!selectedAffectedItems.contains(selectedProposedItem)){
		selectedAffectedItems=selectedProposedItem;
	}

	String activeStep		= "1";
	context 		= Framework.getFrameContext(session);
	initialPageLoad = isNullOrEmpty(inputSequence) ? true : false;
	ProcessSteps processSteps = new ProcessSteps();

	if(initialPageLoad) {
%>
		<!doctype html>
		<html lang="en">
		<head>
		  <meta http-equiv="cache-control" content="no-cache" /> <!-- To be removed in production code-->
		  <meta http-equiv="pragma" content="no-cache" />  <!-- To be removed in production code -->

		  <meta charset="utf-8">
		  <link rel="stylesheet" href="../plugins/libs/jqueryui/1.10.3/css/jquery-ui.css">
		  <link rel="stylesheet" href="./css/override.css"/>
		  <script src="../plugins/libs/jquery/2.0.3/jquery.js"></script>
		  <script src="../plugins/libs/jqueryui/1.10.3/js/jquery-ui.js"></script>
		  <script src="../common/scripts/emxUIConstants.js"></script>
		  <script src="../common/scripts/emxUICore.js"></script>
		  <script src="../common/scripts/emxUIModal.js"></script>
		  <script src="scripts/enoProcessDashboard.js"></script>
		  <script src="../webapps/c/UWA/js/UWA_W3C_Alone.js"></script>
		</head>
		<body>
<%
		Map<String,Document> processXMLMap	= new HashMap<String,Document>();

		List<Step> processStepsList = processSteps.getProcessSteps(context, new String[]{objectId}, null, null, null, processXMLMap,selectedAffectedItems);

		 if(isNullOrEmpty(rootObjectId)) {

			 rootObjectId = objectId;
		 }
		 boolean activeStepFound 	= false;
		 String activeObjId			= "";
%>

<!-- Change start for Proposed Changes -->
		<div id="accordion1" class="first">
		<h3><a href="#" step="Proposed Changes" sequence="0" isactive="true" >Proposed Change Items</a></h3>
		<div id='accordiantable'></div>
		</div>
<script type="text/javascript">
var myAppsURL = "<%=FrameworkUtil.getMyAppsURL(context, request, response)%>";
UWA.Data.request(myAppsURL+"/resources/ecmProcessSteps/ECMProcessStepsService/getProposedChangesData", {
	type:"json",
	method:"POST",
	data:"{objectId:\"<%=objectId%>\"}",
	headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
    },
onComplete : function(jsonObject){
	var json = jsonObject.data;
	var jsonArray=JSON.parse(json);


	var contentTable='<%=getChangeContentHeaderHTML()%>';

	for (var i=0;i<jsonArray.length;i++)
	{
			var proposedItemArray=jsonArray[i].ProposedItems;

			if(proposedItemArray.length>1)
				contentTable='<%=getChangeContentHeaderHTMLWithFilter()%>';
			var initialSelectedObj=jsonArray[i].<%=ProcessStepsConstants.SELECTED_PROPOSED_ITEMS%>;
			for (var j=0;j<proposedItemArray.length;j++)
			{
					contentTable+="<tr>";

					var selectedAffectedItems='<%=selectedAffectedItems%>';

				   	if((selectedAffectedItems!=null && selectedAffectedItems!="" && selectedAffectedItems.indexOf(proposedItemArray[j].id)>=0) && proposedItemArray.length>1)
				   	{
				   			contentTable+="<td width=\"2%\"><input type=checkbox checked id='"+proposedItemArray[j].id+"'  onclick=\"selectAffectedItem('<%=objectId%>','"+proposedItemArray[j].id+"','"+initialSelectedObj+"')\"></input></td>";

				  	}
				   	else if((selectedAffectedItems=="null" || selectedAffectedItems=="") && j==0 && selectedAffectedItems!="doNothing" && proposedItemArray.length>1)
				   	{
				   		contentTable+="<td width=\"2%\"><input type=checkbox checked id='"+proposedItemArray[j].id+"'  onclick=\"selectAffectedItem('<%=objectId%>','"+proposedItemArray[j].id+"','"+initialSelectedObj+"')\"></input></td>";
				   	}
				   	else if(proposedItemArray.length>1)
				   	{
				   			contentTable+="<td width=\"2%\"><input type=checkbox id='"+proposedItemArray[j].id+"'onclick=\"selectAffectedItem('<%=objectId%>','"+proposedItemArray[j].id+"','"+initialSelectedObj+"')\"></input></td>";
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

		var accordian =document.getElementById('accordiantable');
		accordian.innerHTML=contentTable;

}
});

function selectAffectedItem( objectID, selectedId,initialSelectionObjId ){
	var mycontentFrame = findFrame(getTopWindow(),"ENOLSAChangeProcess");
	var url=mycontentFrame.location.href;
	var a=url.split("?");

	var selectedProposedItem=selectedId;
	var selectedAffectedItems='<%=selectedAffectedItems%>';

    var checkboxSelected = document.getElementById(selectedId);

    var initialCheckboxSelected = document.getElementById(initialSelectionObjId);
    if(initialCheckboxSelected.checked)
    {
    	if(selectedAffectedItems!="" && selectedAffectedItems!="null" && selectedAffectedItems.indexOf(initialSelectionObjId)<0)
    		selectedAffectedItems+="|"+selectedProposedItem;
    	else if(selectedAffectedItems=="" || selectedAffectedItems=="null" )
    		selectedAffectedItems=initialSelectionObjId;
    }

	if(checkboxSelected.checked)
{
		if(selectedAffectedItems!="" && selectedAffectedItems!="null")
			selectedAffectedItems+="|"+selectedProposedItem;
		else
			selectedAffectedItems="";
	 	mycontentFrame.location.href=a[0]+"?objectId="+objectID+"&selectedProposedItem="+selectedProposedItem+"&selectedAffectedItems="+selectedAffectedItems;
	}
    else
    {

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
		  mycontentFrame.location.href=a[0]+"?objectId="+objectID+"&selectedAffectedItems="+newSelectedItem;;
    }
}

</script>

		<div style="padding:1px;"></div>
		<!-- Change end for Proposed Changes -->
		<div id="accordion" rootobjectId="<%=rootObjectId%>">

<%		for(int i=0; i< processStepsList.size(); ++i) {

			Step processStep 							= processStepsList.get(i);
			String stepSequence 					= processStep.getSequenceNumber();
			String stepTitle 							=	processStep.getTitle();
			String stepNumber 						= "<span class=\"circle\">" + String.valueOf(i+1) + "</span>";
			String expandIcon							= "<span class=\"circle\">" + String.valueOf(i+1) + "</span>";
			String[] stepObjectIds 				= processStep.getObjectIds();
			String stepState 							= processStep.getState();
			boolean isCurrentStepActive		= processStep.isActiveStep(context);
			boolean isCurrentStepElapsed 	= processStep.isElapsedStep(context);
			String processPolicy					= processStep.getStepXMLPolicySymName();

			String stepTitleImage			= "";
			if(isCurrentStepElapsed) {

				stepTitleImage = "<img src=\"../common/images/iconSmallProcessComplete.png\" width=\"16px\" height=\"15px\" alt=\"\"/>";
			}

			if(!activeStepFound && isCurrentStepActive) {
				activeStepFound = true;
				activeStep		= String.valueOf(i);
				activeObjId		= processStep.getObjectIds()[0];//.get(ProcessStepsConstants.ACTIVEOBJECTID);
			} else if(i==processStepsList.size()-1 && !activeStepFound) { //The last step is set to active, if no active step found
				isCurrentStepActive 	= true;
				activeStepFound 		= true;
				activeStep				= String.valueOf(i);
				activeObjId 			= processStep.getObjectIds()[0];//stepInfo.get(ProcessStepsConstants.OBJECTID);
			}

			if(activeStepFound && isCurrentStepActive) {

				processStep 				= processSteps.getTasksForStep(context, stepObjectIds, stepSequence, processPolicy, "",stepState, processXMLMap.get(processPolicy),selectedAffectedItems);
				List<Task> stepTasks		= processStep.getStepTasks();

				if(processStep.isCompleted()) {

					stepTitleImage = "<img src=\"../common/images/iconSmallProcessComplete.png\" width=\"16px\" height=\"15px\" alt=\"\"/>";
				}

%>
				<h3 class="current"><a href="./enoLSAChangeProcessDashboard.jsp" step="<%=stepTitle%>" sequence="<%=stepSequence%>" objectId="<%=getDelimitedStringFromList(Arrays.asList(stepObjectIds), "|")%>" policy="<%=processPolicy%>" state="<%=stepState%>" isactive="<%=String.valueOf(isCurrentStepActive)%>" iselapsed="<%=String.valueOf(isCurrentStepElapsed)%>" selectedAffectedItems="<%=selectedAffectedItems%>" ><%=stepNumber%> <%=stepTitle%> <%=stepTitleImage%></a></h3>
				<div>

				<div>
					<table>

					<%=getHeaderHTML()%>

<%
					Iterator<Task> iter = stepTasks.iterator();
					while(iter.hasNext()) {
					Task processTask 	= iter.next();
%>
					  	<tr>
							<td width="2%"><%=getStatusIconTag(processTask.getStatus(), true, false,processTask.getTaskActionType())%></td>
							<td><%=processTask.getTitle()%>&nbsp;&nbsp;<%=getDueDateTag(context, processTask, (new Double((String)session.getValue("timeZone"))).doubleValue(), request.getLocale())%></td>
							<td><%=processTask.getTaskActionType()%></td>
							<td><%=processTask.getRole()%></td>
							<td><%=processTask.getOwner()%></td>
							<td><%=getActionHref(context, processTask, locale,session)%></td>
							<td><%=getViewHref(context, processTask, locale, session)%></td>
					  	</tr>
<%
				}	%>
					</table>
				</div>
				</div>

<% 			} else {
				stepNumber 				= "<span class=\"grey-circle\">" + String.valueOf(i+1) + "</span>";
%>
				<h3><a href="./enoLSAChangeProcessDashboard.jsp" step="<%=stepTitle%>" sequence="<%=stepSequence%>" objectId="<%=getDelimitedStringFromList(Arrays.asList(stepObjectIds), "|")%>" policy="<%=processPolicy%>" state="<%=stepState%>" isactive="<%=String.valueOf(isCurrentStepActive)%>" iselapsed="<%=String.valueOf(isCurrentStepElapsed)%>" selectedAffectedItems="<%=selectedAffectedItems%>" ><%=stepNumber%> <%=stepTitle%> <%=stepTitleImage%> </a></h3>
				<div>
				<p>Loading...please wait</p>
				</div>
<%			} %>

<%		}%>

		</div>
		<script>
		var already_loaded = new Object();  // used to track which accordions have already been loaded

		$(function() {
			$( "#accordion" ).accordion({
				collapsible: true,
				active: <%=activeStep%>,
				//heightStyle: 'fill', // http://jqueryui.com/accordion/#fillspace  -- Just sets the height of the accordion to the height of it's parent container.  We need a way to change the height of the parent to that of the newly added content.
				heightStyle: "content",
				activate: function (e, ui) {
					// only fire when the accordion is opening..
					if(ui.newHeader.length>0){
						// only retrieve the remote content once..
						if(! already_loaded[ui.newHeader[0].id]==1){
							var srcObj 		= $(ui.newHeader[0]).children('a');
							var url 		= srcObj.attr('href');
							var sequence 	= srcObj.attr('sequence');
							var objectId 	= srcObj.attr('objectId');
							var isactive 	= srcObj.attr('isactive');
							var state		= srcObj.attr('state');
							var isactive	= srcObj.attr('iselapsed');
							var policy		= srcObj.attr('policy');
							var selectedAffectedItems		= srcObj.attr('selectedAffectedItems');

							$.post(url, {sequence:srcObj.attr('sequence'), objectId:srcObj.attr('objectId'), isactive:srcObj.attr('isactive'), iselapsed:srcObj.attr('iselapsed'), state: srcObj.attr('state'), selectedAffectedItems:srcObj.attr('selectedAffectedItems'), policy:srcObj.attr('policy') }, function (data) {
								$(ui.newHeader[0]).next().html(data);
								$( "#accordion" ).accordion( "option", "heightStyle", "content" );
								already_loaded[ui.newHeader[0].id]=1; // keep track of the loaded accordions
							});
						}
					}
				}

			});
		$( "#accordion1" ).accordion({collapsible: true, active:0, 	heightStyle: "content"});
		});
		<!-- $( "#accordion" ).accordion(); -->

		</script>

<% } else {

		String[] objectIds 		= objectId.split("\\|");
		Step processStep 		= processSteps.getTasksForStep(context, objectIds, inputSequence, inputStepPolicy,"", inputStepState, null,selectedAffectedItems);

		List<Task> processTasks	= processStep.getStepTasks();
%>
		<div>
		<table>
		<%=getHeaderHTML()%>
<%
		Iterator<Task> iter = processTasks.iterator();
		while(iter.hasNext()) {
			Task processTask	= iter.next();
%>
		  <tr>
			<td width="2%"><%=getStatusIconTag(processTask.getStatus(), processStep.isActiveStep(context), processStep.isElapsedStep(context),processTask.getTaskActionType())%></td>
			<td><%=processTask.getTitle()%>&nbsp;&nbsp;<%=getDueDateTag(context, processTask, (new Double((String)session.getValue("timeZone"))).doubleValue(), request.getLocale())%></td>
			<td><%=processTask.getTaskActionType()%></td>
			<td><%=processTask.getRole()%></td>
			<td><%=processTask.getOwner()%></td>
			<td><%=getActionHref(context, processTask, locale,session)%></td>
			<td><%=getViewHref(context, processTask, locale, session)%></td>
		  </tr>
<%
			}%>
		</table>
		</div>
<%	}
	 context.clearClientTasks();
}catch(Exception e){
	errorMessage = "Failed to load process dashboard, error:" + e.getMessage();
	e.printStackTrace();
%>
	<%=errorMessage%>
<%}

if(initialPageLoad) {
%>

</body>
</html>
<iframe name="formViewHidden" style="width:0; height:0; border:0; border:none; visibility:0" id="formViewHidden">
<html><head></head><body></body></html>
</iframe>
<%} %>


<%!
private boolean isNullOrEmpty(String input)
{
	if(input == null || input.equals("") || input.equals("null")) return true;
	return false;
}

private String getDueDateTag(Context context, Task processTask, double clientTZOffset, Locale locale) throws Exception
{
	String dueDateTag 		= "";
	String dueDate 			= processTask.getDueDate();
	String dueDatePrefix 	= processTask.getDueDatePrefix();

	if(!isNullOrEmpty(dueDate)) {

		int iDateFormat 		= eMatrixDateFormat.getEMatrixDisplayDateFormat();
		String formattedDate 	= eMatrixDateFormat.getFormattedDisplayDateTime(context, dueDate, false, iDateFormat, clientTZOffset, locale);
		int interval 			= Integer.valueOf(EnoviaResourceBundle.getProperty(context,"enoCRAddOns.ChangeProcessDashboard.DateWarningIntervalInDays"));

		Date date 				= new Date(dueDate);

		long dateMilliSecs 		= date.getTime();
		long currentMilliSecs 	= System.currentTimeMillis();

		long diff = dateMilliSecs - currentMilliSecs;

		String className = "active-box";

		if(diff < 0)
			className = "overdue-box";
		else if(diff <= interval*24*60*60*1000)
			className = "warning-box";

		if(!isNullOrEmpty(dueDatePrefix))
			formattedDate = new StringBuilder(dueDatePrefix).append(":").append(formattedDate).toString();

		dueDateTag = String.format("<div class=\"%s\">%s</div>", className, formattedDate);
	}
	return dueDateTag;
}

private String getStatusIconTag(String taskStatus, boolean isActiveStep, boolean isElapsedStep,String taskType)
{
	String statusIconTag = "";

	if(taskType.equals(ProcessStepsConstants.OPTIONAL)){

		if(taskStatus.equals(ProcessStepsConstants.STATUS_OK)) {
			statusIconTag = "<img src=\"../common/images/iconSmallProcessComplete.png\" width=\"16px\" height=\"15px\" alt=\"\">";
		} else {
			statusIconTag = "<img src=\"images/info.png\" width=\"16px\" height=\"16px\" alt=\"\">";//"<span style=\"font-size:20px;color:#3797BD\">&#x1F6C8;</span>";//"<img src=\"../common/images/iconStatusMandatory.gif\" width=\"16px\" height=\"15px\" alt=\"\">";
		}
	} else if(isElapsedStep) {

		statusIconTag = "<img src=\"../common/images/iconSmallProcessComplete.png\" width=\"16px\" height=\"15px\" alt=\"\">";
	} else if(isActiveStep) {

		if(taskStatus.equals(ProcessStepsConstants.STATUS_OK)) {
			statusIconTag = "<img src=\"../common/images/iconSmallProcessComplete.png\" width=\"16px\" height=\"15px\" alt=\"\">";
		} else if(taskStatus.equals(ProcessStepsConstants.STATUS_WIP)) {
			statusIconTag = "<img src=\"../common/images/iconSmallProcessInProgress.png\" width=\"16px\" height=\"15px\" alt=\"\">";
		} else if(taskStatus.equals(ProcessStepsConstants.STATUS_NA)) {
			statusIconTag = "<img src=\"../common/images/emxUiTreeViewZoomControlSmallCir.png\" width=\"16px\" height=\"15px\" alt=\"\">";
		} else if(taskStatus.equals(ProcessStepsConstants.STATUS_KO)) {
			statusIconTag = "<img src=\"../common/images/iconStatusError.gif\" width=\"16px\" height=\"15px\" alt=\"\">";
		}
	} else {

		statusIconTag = "<img src=\"../common/images/emxUiTreeViewZoomControlSmallCir.png\" width=\"16px\" height=\"15px\" alt=\"\">";
	}
	return statusIconTag;
}

private String getHeaderHTML()
{
	return "<thead><tr><th width=\"2%\"></th><th>Task</th><th>Task Type</th><th>Role</th><th>Owner</th><th>Actions</th><th>Related Data</th></tr></thead>"; //TODO: I18N
}

private String getChangeContentHeaderHTML()
{
	StringBuilder contentTable=new StringBuilder();
	contentTable.append("<div>");
	contentTable.append("<table>");
	contentTable.append("<thead>");
	contentTable.append("<th width=\"10%\">Title</th>");
	contentTable.append("<th>Type</th>");
	contentTable.append("<th>Name</th>");
	contentTable.append("<th>State</th>");
	contentTable.append("<th>Rev</th>");
	contentTable.append("<th>Actions</th>");
	contentTable.append("<th>Change Information</th>");
	contentTable.append("</thead>");
	contentTable.append("</div>");
	return contentTable.toString(); //TODO: I18N
}

private String getChangeContentHeaderHTMLWithFilter()
{
	StringBuilder contentTable=new StringBuilder();
	contentTable.append("<div>");
	contentTable.append("<table>");
	contentTable.append("<thead>");
	contentTable.append("<th width=\"10%\"><img src=\"../common/images/iconActionFilter.gif\" width=\"16px\" height=\"15px\" title=\"Filter\"/></th>");
	contentTable.append("<th width=\"10%\">Title</th>");
	contentTable.append("<th>Type</th>");
	contentTable.append("<th>Name</th>");
	contentTable.append("<th>State</th>");
	contentTable.append("<th>Rev</th>");
	contentTable.append("<th>Actions</th>");
	contentTable.append("<th>Change Information</th>");
	contentTable.append("</thead>");
	contentTable.append("</div>");
	return contentTable.toString(); //TODO: I18N
}

private String getActionHref(Context context,Task processTask, Locale locale,HttpSession session) throws Exception
{
	String outputHref		= "";
	String actionHref		= processTask.getActionHref();
	String actionCommand	= processTask.getActionCommand();
	String taskType			= processTask.getTaskType();
	String actionObjectId	= processTask.getActionObjectId();
	String actionLabel	    = processTask.getActionLabel();
	String actionImage	    = processTask.getActionImage();
	String access			= processTask.hasAccess();

	if(!isNullOrEmpty(actionHref) && taskType.equals(ProcessStepsConstants.ROUTETASK)) {

		if(actionHref.startsWith("command")) {

			StringBuilder actions 	= new StringBuilder();
			String[] commands 		= actionHref.split("\\|");
			String commandsDoNothing 		= ProcessStepsConstants.HREF_TASK_ACTION_DONOTHING;

			for(int i=0; i<commands.length; ++i) {

				String strAction=getCommandHref(context, commands[i], actionObjectId, locale, null, actionLabel, actionImage,session);
				if(commandsDoNothing.contains(commands[i])){
					strAction=strAction.replace("refreshCaller", "doNothing");
				}
				actions.append(strAction);
			}

				outputHref = actions.toString();
		} else {

			boolean hasAccess = isNullOrEmpty(access) ? true : access.equalsIgnoreCase("true");

			if(hasAccess) {

				outputHref = actionHref;

			}
		}

	} else if(!isNullOrEmpty(actionHref)) {

		if(actionHref.startsWith("command")) {

			outputHref		= getCommandHref(context, actionHref, actionObjectId, locale, null, actionLabel, actionImage,session);

		} else {

			boolean hasAccess = isNullOrEmpty(access) ? true : access.equalsIgnoreCase("true");

			if(hasAccess) {

				outputHref = replaceActionParams(actionHref, actionObjectId, null);

				if(!isNullOrEmpty(outputHref) ) {

					String href = outputHref.indexOf("TargetLocation=slidein") != -1 ? String.format("javascript:getTopWindow().showSlideInDialog('%s', true)", outputHref) : "javascript:showNonModalDialog('" + outputHref + "', '930', '650', 'true')";

					outputHref = String.format("<a href=\"%s\">%s</a>", href, getActionLabel(context, processTask));
				}
			}
		}
	} else if(!isNullOrEmpty(actionCommand)) {

		if(actionCommand.startsWith("command")) {

			outputHref = getCommandHref(context, actionCommand, actionObjectId, locale, null, actionLabel, actionImage,session);

		} else {

			outputHref = String.format("<a onclick=\"javascript:executeOperation('%s','%s', 'true')\" href='javascript:void(0)'>%s</a>", actionObjectId, actionCommand, getActionLabel(context, processTask)+"jj");
		}
	}
	return outputHref;
}

private String getCommandHref(Context context, String symCommandName, String objectId, Locale locale, String targetLocation, String actionLabel, String actionImage,HttpSession session) throws Exception
{
	String commandHref  = "";

	String commandName 	= PropertyUtil.getSchemaProperty(symCommandName);

	Command command 	= new Command(context, commandName);
	String actionLink	= command.getHref();

	String accessProgram 	= MqlUtil.mqlCommand(context, String.format("print command '%s' select setting[Access Program].value dump", commandName));
	String accessFunction 	= MqlUtil.mqlCommand(context, String.format("print command '%s' select setting[Access Function].value dump", commandName));

	boolean hasAccess = true;
	if(!isNullOrEmpty(accessProgram) && !isNullOrEmpty(accessFunction)) {

		HashMap requestMap = new HashMap();
		requestMap.put("objectId", objectId);

		HashMap programMap = new HashMap();
		programMap.put("requestMap", requestMap);
		programMap.put("objectId", objectId); //Some JPOs expect direct objectId without requestMap

		String[] args 	= JPO.packArgs(programMap);
		Boolean access 	= JPO.invoke(context, accessProgram, args, accessFunction, args, Boolean.class);
		hasAccess 		= access.booleanValue();
	}

	if(hasAccess) {

		String suiteKey = MqlUtil.mqlCommand(context, String.format("print command '%s' select setting[Registered Suite].value dump", commandName));

		if(isNullOrEmpty(targetLocation)) {
			targetLocation 	= MqlUtil.mqlCommand(context, String.format("print command '%s' select setting[Target Location].value dump", commandName));
		}

		if (!isNullOrEmpty(suiteKey) && !actionLink.startsWith("javascript")) {
			String strSuite="&suiteKey=" + suiteKey;
			if(actionLink.indexOf("?")==-1){
				 strSuite="?suiteKey=" + suiteKey;
			}
			actionLink = actionLink +strSuite ;
		}

		String tooltip = null;
		if(!isNullOrEmpty(actionLabel)) {

			tooltip = actionLabel;
		} else {

			tooltip = isNullOrEmpty(command.getAlt()) ? command.getLabel() : command.getAlt();
		}

		actionLink = replaceActionParams(actionLink, objectId, suiteKey);

		actionLink = FrameworkUtil.encodeURL(actionLink, "UTF-8");

		if(UIUtil.isNotNullAndNotEmpty(actionLink)&& !actionLink.startsWith("javascript")){
			actionLink=UIUtil.addSecureTokeninURL(context, session, actionLink);
		}

		if(isNullOrEmpty(actionImage)) {

			actionImage = MqlUtil.mqlCommand(context, String.format("print command '%s' select setting[Image].value dump", commandName));
		}

		String stringResourceFile 	= FrameworkProperties.getProperty("eServiceSuite" + suiteKey + ".StringResourceFileId");
		tooltip 					= EnoviaResourceBundle.getProperty(context,stringResourceFile,locale,tooltip);

		if (!isNullOrEmpty(actionImage)) {
			actionLabel = String.format("<img src=\"%s\" width=\"23px\" height=\"23px\" title=\"%s\"/>", replaceActionParams(actionImage, null, suiteKey), tooltip);
		} else {

			actionLabel = EnoviaResourceBundle.getProperty(context,stringResourceFile,locale,command.getLabel());
		}

		if(targetLocation.equalsIgnoreCase("content") || targetLocation.equalsIgnoreCase("popup") || targetLocation.equals("")) { //Force content to pop-up.

			commandHref = String.format("<a href=\"javascript:showNonModalDialog('%s', '930', '650', 'true')\" title='%s'>%s</a>", actionLink, tooltip, actionLabel);


		} else if(!targetLocation.equalsIgnoreCase("slidein")) {
			if(actionLink.contains("javascript:"))
			{
				actionLink = FrameworkUtil.decodeURL(actionLink, "UTF-8");
				commandHref = String.format("<a onclick=\"%s\" title='%s' target='%s' href='javascript:void(0)'>%s</a>",actionLink,  tooltip, targetLocation, actionLabel);
			}
			else
				commandHref = String.format("<a href=\"%s\" title='%s' target='%s'>%s</a>",actionLink,  tooltip, targetLocation, actionLabel);
		} else {

			commandHref = String.format("<a href=\"javascript:getTopWindow().showSlideInDialog('%s', 'true')\" title='%s'>%s</a>", actionLink, tooltip, actionLabel);
		}
	}
	return commandHref;
}

	private String getCommandURL(Context context, String symCommandName) throws Exception {
		String commandName = PropertyUtil.getSchemaProperty(symCommandName);
		Command command = new Command(context, commandName);
		String outputHref = command.getHref();

		String suiteKey = MqlUtil.mqlCommand(context,
				String.format("print command '%s' select setting[Registered Suite].value dump", commandName));

		if (!isNullOrEmpty(suiteKey))
			outputHref = outputHref + "&suiteKey=" + suiteKey;
		return outputHref;
	}

	private String replaceActionParams(String input, String objectId, String suiteKey) throws Exception {
		Map<String, String> replaceParams = new HashMap<String, String>();
		replaceParams.put("${COMMON_DIR}", "../common");
		replaceParams.put("${COMPONENTS_DIR}", "../components");
		replaceParams.put("mode=view", "mode=edit");

		if(input.indexOf("${OBJECTID}") != -1 && !isNullOrEmpty(objectId)) {

			replaceParams.put("${OBJECTID}", objectId);
		}

		String suiteDir = null;

		if (!isNullOrEmpty(suiteKey)) {

			suiteDir = FrameworkProperties.getProperty("eServiceSuite" + suiteKey + ".Directory");

			replaceParams.put("${SUITE_DIR}", "../" + suiteDir);
		}

		boolean appendObjId = isNullOrEmpty(objectId)  || input.startsWith("javascript")? false : true;
		if (input.indexOf("objectId=") != -1 && !isNullOrEmpty(objectId)) {
			replaceParams.put("objectId=", "objectId=" + objectId);
			appendObjId = false;
		}

		for (String param : replaceParams.keySet()) {

			input = input.replace(param, replaceParams.get(param));
		}

		if (appendObjId) {

			input = input + "&" + ProcessStepsConstants.OBJECTID + "=" + objectId+ "&" + ProcessStepsConstants.EMXTABLEROWID + "=" + "|" +objectId + "||";
		}
		return input;
	}

	private String getActionLabel(Context context, Task processTask) throws Exception {
		String outputLabel 		= "";
		String actionLabel 		= processTask.getActionLabel();
		String actionImage 		= processTask.getActionImage();
		String taskType			= processTask.getTaskType();

		if (!isNullOrEmpty(actionLabel) && taskType.equals(ProcessStepsConstants.ROUTETASK)) {

			String commandName 	= PropertyUtil.getSchemaProperty(processTask.getActionHref());
			String image 		= MqlUtil.mqlCommand(context, String.format("print command '%s' select setting[Image].value dump", commandName));
			outputLabel 		= replaceActionParams(image, null, null);
		}
		else if(!isNullOrEmpty(actionImage)) {
			outputLabel = String.format("<img src=\"%s\" width=\"23px\" height=\"23px\" title=\"%s\"/>", replaceActionParams(actionImage, null, null), actionLabel);
		} else if (!isNullOrEmpty(actionLabel)) {

			outputLabel = String.format("<button class=\"next\" type=\"button\">%s</button>", actionLabel);
		}
		return outputLabel;
	}

	private String getViewHref(Context context, Task processTask, Locale locale, HttpSession session) throws Exception {
		String outputHref 	= "";
		String viewHref 	= processTask.getViewHref();
		String taskType		= processTask.getTaskType();
		String viewObjectId = processTask.getViewObjectId();
		String viewLabel	= processTask.getViewLabel();
		String access		= processTask.hasAccess();

		if (!isNullOrEmpty(viewHref) && taskType.equals(ProcessStepsConstants.ROUTETASK)) {

			outputHref = String.format("<a href=\"javascript:showNonModalDialog('%s', '930', '650', 'true')\">%s</a>", viewHref, viewLabel);
		} else if (!isNullOrEmpty(viewHref)) {

			if(viewHref.startsWith("command_")) {

				outputHref = getCommandHref(context, viewHref, viewObjectId, locale, "popup", viewLabel, null, session);
			} else {

				boolean hasAccess = isNullOrEmpty(access) ? true : access.equalsIgnoreCase("true");

				if(hasAccess) {

					outputHref = replaceActionParams(viewHref, viewObjectId, null);

					if(!isNullOrEmpty(outputHref) ) {

						String href = "javascript:showNonModalDialog('" + outputHref + "', '930', '650', 'true')";

						outputHref = String.format("<a href=\"%s\">%s</a>", href, getViewLabel(context, processTask));
					}
				}
			}
		} else {

			outputHref = String.format("<a href=\"javascript:showNonModalDialog('../common/emxTree.jsp?relId=&parentOID=&jsTreeID=&suiteKey=Framework&emxSuiteDirectory=common&objectId=%s&targetLocation=popup', '930', '650', 'true')\">%s</a>", viewObjectId, getViewLabel(context, processTask)); //TODO: hard-coded suite key, need to read from XML
		}

		return outputHref;
	}

	private String getViewLabel(Context context, Task processTask) throws FrameworkException {
		String outputLabel 		= "";
		String viewLabel 		= processTask.getViewLabel();
		String viewObjectId 	= processTask.getViewObjectId();

		if (!isNullOrEmpty(viewLabel) && !isNullOrEmpty(viewObjectId)) {

			DomainObject domObj = DomainObject.newInstance(context, viewObjectId);
			String strTypeSymName = FrameworkUtil.getAliasForAdmin(context, "type", domObj.getInfo(context, DomainConstants.SELECT_TYPE), true);
			String typeIcon;
			try
			{
				typeIcon = EnoviaResourceBundle.getProperty(context,"emxFramework.smallIcon." + strTypeSymName);
			}catch(FrameworkException e){
				typeIcon = EnoviaResourceBundle.getProperty(context,"emxFramework.smallIcon.defaultType");
			}

			outputLabel = "<img src = '../common/images/" +typeIcon+" '/>"+viewLabel;
		}
		return outputLabel;
	}

	public String getDelimitedStringFromList(List elementsList, String delimitString)
	{
		StringBuilder delimitedStringBuffer = new StringBuilder();

		if(elementsList != null)
		{
			Iterator elementsIterator  = elementsList.iterator();
			while(elementsIterator.hasNext())
			{
				String elementString = (String)elementsIterator.next();

				if(elementsIterator.hasNext())
				{
					delimitedStringBuffer.append(elementString);
					delimitedStringBuffer.append(delimitString);
				}
				else
					delimitedStringBuffer.append(elementString);
			}
		}
		return delimitedStringBuffer.toString();
	}

	public String getToolbarHeader()
	{
		String toolbarCmds = "<div class=\"icon-command\"><img src=\"../common/images/iconSmallReport.gif\"/></div>";
		return toolbarCmds;
	}

	%>
