<%-- gapSelectDocumentSignersDialog.jsp - This JSP displays the signers dialog page for selection.
	@author 	 : Mayuri Sangde (ENGMASA)
	@date   	 : 08-Apr-2019
	@description : This page displays document signers for selection
--%>


<%@page import="com.matrixone.apps.domain.util.PropertyUtil"%>
<%@page import="com.matrixone.apps.domain.util.PersonUtil"%>
<%@page import="com.matrixone.apps.framework.ui.UIUtil"%>
<%@page import="java.util.HashMap"%>
<%@page import="matrix.db.JPO"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Vector"%>
<%@page import="com.matrixone.apps.domain.util.FrameworkUtil"%>
<%@page import="matrix.util.StringList"%>
<%@page import="java.util.Locale"%>
<%@page import="com.matrixone.apps.domain.util.EnoviaResourceBundle"%>
<%@page import="java.util.Map"%>
<%@page import="com.matrixone.apps.domain.util.MapList"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.matrixone.apps.domain.DomainObject"%>
<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<%@include file = "../businessmetrics/emxMetricsConstantsInclude.inc"%>
<jsp:useBean id="formBean" scope="session" class="com.matrixone.apps.common.util.FormBean"/>
<%
String strErr = (String) session.getAttribute("GAP_ERROR");
if (UIUtil.isNotNullAndNotEmpty(strErr))
{
	session.removeAttribute("mpRTTaskUsers");
	session.removeAttribute("taskDisplayMap");
	session.removeAttribute("GAP_ERROR");
	%>
	<html>
	<body>
	<script type="text/javascript">
	alert("<%=strErr%>");
	 parent.window.closeWindow();
	</script>
	
	</body>
	</html>
	<%
}
else{	
String suiteKey    =  (String) emxGetParameter(request, "suiteKey");
String strObjectId    =  (String) emxGetParameter(request, "objectId");
Map mpRTTaskUsers    = (Map) session.getAttribute("mpRTTaskUsers");
Map mpTaskDisplay    = new HashMap();
String strUserGrp    =  (String) emxGetParameter(request, "UserGrp");//System.out.println("1......Dialog.."+strUserGrp);
String strChangeLocation    =  (String) emxGetParameter(request, "ChangeLocation");//System.out.println("1......Dialog..");
String strCurrentSelection = (String) emxGetParameter(request, "currentSel");//System.out.println("1......Dialog..");

Locale strLocale = new Locale(context.getSession().getLanguage());
String strLocations =  EnoviaResourceBundle.getProperty(context, "emxTeamCentralStringResource", strLocale, "emxTeamCentral.GAPLocations");
Map mpSelectionMap = new HashMap();
StringList slLocations = FrameworkUtil.split(strLocations, ",");
// sort locations
Collections.sort(slLocations);
String strClearSelection = (String) emxGetParameter(request, "clearSelection");
//System.out.println("strUserGrp >>> "+strUserGrp + "  strCurrentSelection111 >> "+strCurrentSelection +" >>> "+strClearSelection +" mpTaskDisplay from Dial : "+mpTaskDisplay );
if (UIUtil.isNullOrEmpty(strClearSelection))
	strClearSelection = DomainObject.EMPTY_STRING;
if ("true".equals(strClearSelection))
{
	  //strCurrentSelection = DomainObject.EMPTY_STRING;
	DomainObject doObject = DomainObject.newInstance(context, strObjectId);
	doObject.setAttributeValue(context, PropertyUtil.getSchemaProperty(context, "attribute_gapSigners"), DomainObject.EMPTY_STRING);
	//strCurrentSelection = DomainObject.EMPTY_STRING;
	strChangeLocation = DomainObject.EMPTY_STRING;
	// clear all adsignee
	 // update display map with selections
	/*   Map mpCurrentRTMap = (Map) session.getAttribute("mpRTTaskUsers");
	   
	   Map programMap = new HashMap();		
		programMap.put("mpCurrentRTMap", mpCurrentRTMap);
		programMap.put("curentSelection", strCurrentSelection);
		programMap.put("clearSelection", strClearSelection);
	    String[] strArgs1  = JPO.packArgs(programMap);
	    Map mpUpdatedRTMap    = (Map) JPO.invoke(context, "gapRTWorkspace", null, "updateSelectedAssignees", strArgs1, Map.class);
	  
	   session.setAttribute("mpRTTaskUsers", mpUpdatedRTMap);*/
}
if (UIUtil.isNullOrEmpty(strCurrentSelection))
{
	// read value from change attribute
	DomainObject doObject = DomainObject.newInstance(context, strObjectId);
	strCurrentSelection = doObject.getAttributeValue(context, PropertyUtil.getSchemaProperty(context, "attribute_gapSigners"));
}
if (UIUtil.isNotNullAndNotEmpty(strCurrentSelection))
{
	   // update display map with selections
	   Map mpCurrentRTMap = (Map) session.getAttribute("mpRTTaskUsers");
	   
	   Map programMap = new HashMap();		
		programMap.put("mpCurrentRTMap", mpCurrentRTMap);
		programMap.put("currentSelection", strCurrentSelection);
		programMap.put("objectId", strObjectId);
	    String[] strArgs1  = JPO.packArgs(programMap);
	    Map mpUpdatedRTMap    = (Map) JPO.invoke(context, "gapRTWorkspace", null, "updateSelectedAssignees", strArgs1, Map.class);
	   // System.out.println("b4 : "+mpRTTaskUsers);
	    //System.out.println("af : "+mpUpdatedRTMap);
	    mpRTTaskUsers = mpUpdatedRTMap;
	   session.setAttribute("mpRTTaskUsers", mpUpdatedRTMap);
}
try {
	HashMap programMap = new HashMap();		
	programMap.put("UserGrp", strUserGrp);
	programMap.put("currentDispMap", mpRTTaskUsers);
    
    String[] strArgs  = JPO.packArgs(programMap);
    mpTaskDisplay = (Map) JPO.invoke(context, "gapRTWorkspace", null, "formatDisplayMap", strArgs, Map.class);
    // update to session
    session.setAttribute("taskDisplayMap", mpTaskDisplay);
}catch (Exception exJPO) {
	exJPO.printStackTrace();
   throw exJPO;
}
Map mpCurrentSelection = (HashMap) mpTaskDisplay.get("TASK_CURRET_SELECTION");
//System.out.println("mpTaskDisplay........."+mpTaskDisplay);
//System.out.println("1........."+mpCurrentSelection);
%>
<html>
<head>
<style type="text/css">

.tooltip {
  position: relative;
  display: inline-block;
  border-bottom: 1px dotted black;
}

.tooltip .tooltiptext {
  visibility: hidden;
  width: 120px;
  background-color: black;
  color: #fff;
  text-align: center;
  border-radius: 6px;
  padding: 5px 0;
  font-size: xx-small;
  /* Position the tooltip */
  position: absolute;
  z-index: 1;
}

.tooltip:hover .tooltiptext {
  visibility: visible;
}
</style>
<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script>
<script language="JavaScript" src="emxMetricsDashboard.js"></script>
<script type="text/javascript" src="../common/scripts/jquery-latest.js"></script>
<script language="Javascript" type="text/javascript">
var vCurrentSelection = new Array();
// add current selections to javascript object
<%
	Iterator itr = mpCurrentSelection.entrySet().iterator(); 
	
	while(itr.hasNext()) 
	{ 
	     Map.Entry entry = (Map.Entry)itr.next(); 
	     String strKey = (String) entry.getKey();
	     String strVal = (String) entry.getValue();
	     %>
	     vCurrentSelection["<%=strKey%>"]= "<%=strVal%>";	     	   
	     <%
	}
	
%>
$(document).ready(function(){
	  $("#filterSearch").on("keyup", function() {
	    var value = $(this).val().toLowerCase();
	    $("#signersRow tr").filter(function() {
	        $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
	      });
	  });
	});
	var vTaskList = [];
  // function to close window
  function closeWindow() {
	  parent.window.closeWindow();
  }
  function clearSelection(){
	  turnOnProgress();
	  // populate current selection
	  populateCurrentSelection();
	  var vCurrentSelect = document.getElementById('currentSel').value;
	  if (vCurrentSelect=="")
		  alert("No value selected");
	  else{
			// clear selection
			  clearTaskAssignee();
	  
		  	  var vSelectedGroup = document.DocumentSigners.gapLocation.value;
			var vURL = "gapSelectDocumentSignersDialog.jsp?objectId=<%=strObjectId%>&suiteKey=<%=suiteKey%>&UserGrp="+vSelectedGroup+"&clearSelection=true";
			
		  document.DocumentSigners.action = vURL;
		  document.DocumentSigners.submit();
	  }
	  turnOffProgress();
  }
  function changeSelectionText(myRadio, vUserDispName) {
	    var vId = myRadio.id;
	    var vSpanId= "span~"+vId;
	   
	    document.getElementById(vSpanId).textContent = vUserDispName;	   
	}
  function submitForm() {
	  turnOnProgress();
	// populate all signers
  	  populateCurrentSelection();
	// check if all signers selected
	var vRes = checkIfAllSignersSelected();
	var vCurrentSelect = document.getElementById('currentSel').value;
	//alert("vRes : "+vRes+" v : "+vCurrentSelect);
	if (vRes==false || vRes=="false")
		{
		turnOffProgress();
		} 
	else {
		var vURL = "gapSelectDocumentSignersProcess.jsp?objectId=<%=strObjectId%>&suiteKey=<%=suiteKey%>";
    	
		  document.DocumentSigners.action = vURL;
		 // alert("???"+document.DocumentSigners.action);
		  document.DocumentSigners.submit();
		  
	}
  }
  function clearTaskAssignee()
  {
	  var vSelectedSigners = "";
	  var arrayLength = vTaskList.length;
	  	for (var i = 0; i < arrayLength; i++) {
	  		var vTaskTitle = vTaskList[i];
	  		//alert("clearing >>  "+vTaskTitle +" value >> "+vCurrentSelection[vTaskTitle]);
	  		vCurrentSelection[vTaskTitle] = "";	  	
	  		//alert("clearing done >>  "+vTaskTitle +" value >> "+vCurrentSelection[vTaskTitle]);
	  		if(i>0)
	    		vSelectedSigners = vSelectedSigners + ",";
  		    vSelectedSigners = vSelectedSigners + vTaskTitle + "^";
	  	}
	  	var vCurrentSelect = document.getElementById('currentSel');
	  	vCurrentSelect.value = vSelectedSigners;
  }
  function checkIfAllSignersSelected()
  {
	  var arrayLength = vTaskList.length;
	  	for (var i = 0; i < arrayLength; i++) {
	  		var vTaskTitle = vTaskList[i];
	  		var vSigner = vCurrentSelection[vTaskTitle];
	  		if (vSigner)
	  			{continue;}
	  		else {
	  			var vArrTask = vTaskTitle.split("~");
	  			var vTask = vArrTask[1];
	  			var vErr = "Please select signer for task "+vTask+".";
	  			alert(vErr);
	  			return "false";
	  		}
	  	}
	  	return "true";
  }
  function populateCurrentSelection() {
	  var vSelectedSigners = "";
	  var arrayLength = vTaskList.length;
  	for (var i = 0; i < arrayLength; i++) {
  		var vTaskTitle = vTaskList[i];
  		//alert("looking for : "+vTaskTitle);
  		var vRadioName = "input[name='"+vTaskTitle+"']:checked";
  		var radioValue = $(vRadioName).val();
  		var vKey = vTaskTitle;
  		if(i>0)
	    		vSelectedSigners = vSelectedSigners + ",";
  		vSelectedSigners = vSelectedSigners + vTaskTitle + "^";
  		
  	    if(radioValue){    	    	
  	    	vSelectedSigners = vSelectedSigners + radioValue;
  	    	vCurrentSelection[vKey]=radioValue;
  	    } else {	    	
  	    	radioValue = vCurrentSelection[vKey];
  	    	//alert(vKey+" ==> "+radioValue);
  	    	if (radioValue)
  	    		vSelectedSigners = vSelectedSigners + radioValue; 	
  	    }
  	}
  	var vCurrentSelect = document.getElementById('currentSel');
  	vCurrentSelect.value = vSelectedSigners;
  }
  function changGAPLocation() {
	  var vSelectedSigners = "";
	  	  var vSelectedGroup = document.DocumentSigners.gapLocation.value;
	  	 // populate current selection
	  	populateCurrentSelection();
    	var vURL = "gapSelectDocumentSignersDialog.jsp?objectId=<%=strObjectId%>&suiteKey=<%=suiteKey%>&UserGrp="+vSelectedGroup+"&ChangeLocation=true";
    	
	  document.DocumentSigners.action = vURL;
	  document.DocumentSigners.submit();
  }
</script>
<script type="text/javascript">
	addStyleSheet("emxUIDefault");
	addStyleSheet("emxUIList");
</script>

</head>
<body>
<form name="DocumentSigners" method="post"  onSubmit="javascript:submitForm();">
<input id="currentSel" name="currentSel" type="hidden">
 	 <table>
	  <tr>
	  <td class="heading1" width="2%" nowrap >Select Signers</td>
	  </tr>	
	  </table><table>  
	  <tr>
		<td>
		<input id="filterSearch" type="text" placeholder="Search..">
		</td>
		<td class="inputField"><input id="btn_clearSelection" name="btn_clearSelection" type="button" value="Clear signers" onclick="javascript:clearSelection()" /></td>
	  </tr>
	<tr>
	<td class="inputField">
		     <select name="gapLocation" onchange="changGAPLocation()">
		     <%
		     	String strLocation = null;
		     	String strSelected = null;
		     	for (int i=0; i< slLocations.size(); i++)
		     	{
		     		strLocation = (String) slLocations.get(i);
		     		strLocation = strLocation.trim();
		     		strSelected = DomainObject.EMPTY_STRING;
		     		// if same location make default selected
		     		if (strUserGrp.equals(strLocation))
		     			strSelected = "selected=\"selected\"";
		            %>
		                  <option value="<%=strLocation%>" <%=strSelected%>><%=strLocation%> </option>
		            <%
		     	}
		     %>
		     </select>
	</td>
	</tr>
	</table>
	<table style="table-layout: fixed; width: 100%">
		<div>
 		<% 		
 			// read labels
 			StringList slLabels = (StringList) mpTaskDisplay.get("TASK_LABEL");
 		Map Task_Data = (Map) mpTaskDisplay.get("TASK_DATA");
 		    String strTempLabel = null;
 		String strKey=null;
 		String stTablePosition = "float: left;";
 		String strTableName = null;
 		String strSpanName = null;
 		String strIsSelected = null;
 		String strTaskAssignee = null;
 		Map mpAssigneeMap = null;
 			for (int y=0; y<slLabels.size(); y++)
 			{
 				strKey = (String) slLabels.get(y);
 				 StringList slTemp = FrameworkUtil.split(strKey, "~");
 				strTempLabel = (String) slTemp.get(1);
 				Map mpMap = (Map) Task_Data.get(strKey);
 				strTableName = "tb"+strKey;
 				strSpanName = "span~"+strKey;
 				strTaskAssignee = "No Value";
 				// get assignee map
 				mpAssigneeMap = (Map) mpRTTaskUsers.get(strKey);
 				if (mpAssigneeMap!=null)
 				{
 					strTaskAssignee = (String) mpAssigneeMap.get("TASK_ASSIGNEE");
 					if (UIUtil.isNullOrEmpty(strTaskAssignee))
 						strTaskAssignee = "No Value";
 					else
 					{
 						// read full name
 						StringBuffer sbDisp = new StringBuffer();
 						sbDisp.setLength(0);
 						 sbDisp.append(PersonUtil.getFullName(context, strTaskAssignee)).append(" (").append(strTaskAssignee).append(")");
 						strTaskAssignee = sbDisp.toString();
 					}
 				}
 					
 		%>
 		<script>
 		vTaskList.push("<%=strKey%>");
 		</script>
 		<td style="height: auto; vertical-align: top;">
 		<div class="tooltip">
 		
 			<table id="<%=strTableName%>" class="list" cellpadding="0" cellspacing="0" style="table-layout: fixed; width: 100%">
 			
 			<tr>	
 			<span id="<%=strSpanName%>" class="tooltiptext"><%=strTaskAssignee %></span>		
		  		<th>
					<%=strTempLabel %>
				</th>
				</tr><tbody id="signersRow">
				<%
				//stTablePosition = "float: left;";
					 MapList mlMembers = (MapList) mpMap.get("MEMBERS_LIST");
					 // if no members found then display no person found
					 if (mlMembers==null || mlMembers.size()<=0)
					 {
					%>
					<tr>
					<td class="even">No Persons Found</td>
					</tr>
					<% 
					 }
		          Iterator itrMembers = mlMembers.iterator();
		          Map mp = null;
		          String strName = null;
		          String strUserName = null;
		          int iIndex = 0;
		          String strClass = "even";
		          String strSelId = null;
		          String strSelectedAssignee =  DomainObject.EMPTY_STRING;
		          while (itrMembers.hasNext())
		          {
		        	  mp = (Map) itrMembers.next();
		        	  strSelectedAssignee =  DomainObject.EMPTY_STRING;
		        	  strName = (String) mp.get(DomainObject.SELECT_NAME);
		        	  strUserName = (String) mp.get(DomainObject.SELECT_ID);
		        	  strIsSelected = (String) mp.get("SELECTED_MEMBER");
		        	  if ("true".equals(strIsSelected))
		        	  {
		        		  strSelectedAssignee =  "checked=\"checked\"";
		        	  }
		        	  strSelId = strKey;
		        	  if (iIndex % 2 == 0)
		        		  strClass = "even";
		        	  else
		        		  strClass = "odd";
		        	  iIndex++;
		        	  %>
		        	  <tr class='<%=strClass%>'>
		        	  <td><input type="radio" name="<%=strSelId%>" id="<%=strSelId%>" value="<%=strUserName%>" <%=strSelectedAssignee%>  onclick="changeSelectionText(this,'<%=strName%>');"/><%=strName%></td>
		        	  </tr>
		        	  <%
		          }
				%></tbody>
				</table></div>
				</td>
		<%
 			}// end for
		%>
</div></table>
</form>
</body>
</html>
<%}%>