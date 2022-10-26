<%@page import="com.matrixone.apps.domain.DomainConstants"%>
<%@page import="com.matrixone.apps.domain.DomainObject"%>
<%@ include file = "../emxUICommonAppInclude.inc"%>
<%@ page errorPage = "emxNavigatorErrorPage.jsp"%>
<%@ page import = "com.designrule.drv6tools.common.drContext, com.designrule.drv6tools.Operations, com.designrule.drv6tools.eFunctionType, com.designrule.drv6tools.Result"%>
<%@ page import = "java.io.File" %>
<%@ page import = "java.io.IOException" %>
<%@ page import = "java.util.Map" %>
<%@ page import = "java.net.URLEncoder" %>
<%@ page import = "com.designrule.drv6tools.debug.drLoggerUtil"%>
<%@ page import = "org.apache.log4j.Logger" %>
<script language="javascript" src="../common/scripts/emxUICore.js"></script>
<%
	String currentUser = (String)context.getUser();
    drLoggerUtil.initLogger(request);
	ArrayList arrFileFilter=new ArrayList(Arrays.asList("ALL","DEBUG","ERROR","FATAL","INFO","TRACE","WARN","OFF"));
	int filterCount=arrFileFilter.size();
	boolean debugEnabled= drLoggerUtil.checkExistingLogConfiguration();

	drLoggerUtil logUtil=drLoggerUtil.getLogUtil();
	String logLevelSelected = logUtil.getLogLevel();
	String users = logUtil.getLogUsers();
	String filePath = logUtil.getLogFilePath();
%>
<!DOCTYPE html>
<html>
<head>
<title>drV6Tools Debugging</title>
	<script type="text/javascript" src="../drV6Tools/common/js/jquery-1.9.1.js"></script>
	<link rel="stylesheet" type="text/css" href="../common/styles/emxUIDefault.css" />                  
</head>
<script>
 $(document).ready(function() {
	 $.ajax({
         url : "../drV6Tools/drV6ToolsLogFile.log",
         dataType: "text",
         success : function (data) {
        	 $('#debugOptions').val("<%=logLevelSelected%>");
        	 $('.container').empty();
        	 var lines = data.split("\n");
        	    $.each(lines, function(n, elem) {
        	       $('.container').append('<div>' + elem + '</div>');
        	    });
        	 var objDiv = $('.container');
        	 if (objDiv.length > 0){
        	      objDiv[0].scrollTop = objDiv[0].scrollHeight;
        	 }       	 
         }
     });
	}); 
 </script>                
</head>
<body onload="onLoadPage()" style="height: 100%; width: 100%">
	<div style="float: left; height: 5%; width: 98%; border-changeUserPreference: solid; border-width: 2px; margin: 10px; position: relative;">
	<%
	if(debugEnabled){
	%>
	<input type="checkbox" id="debug" name="debug" value="true" onchange="enableDebigging()" checked style="position: relative;">&nbsp; <label>Enable Debug </label>
	<%
	}else{
	%>
	<input type="checkbox" id="debug" name="debug" value="true" onchange="enableDebigging()" style="position: relative;">&nbsp; <label> Enable Debug </label>
	<%
	}
	%>
	&nbsp;&nbsp;
	<label>Debug Level:</label>
	<select id="debugOptions" style="position: relative;">
	<%
	for(int debugCounter=0;debugCounter <filterCount; debugCounter++){
	%>
		<option><%=arrFileFilter.get(debugCounter)%></option>
	<%
	}
	%>
	</select>
	&nbsp;&nbsp;
	<input type="radio" name="all" value="true" id="all" onchange="changeUserPreferenceForAll()" style="position: relative;">&nbsp; <label>All Users</label>
	
	&nbsp;&nbsp;
  	<input type="radio" name="user" value="true" id="user" onchange="changeUserPreferenceForUsers()" style="position: relative;">&nbsp; <label> User List: </label>
  	<input type="text" name="userlist" id="userList" style="position: relative;">
  	&nbsp;&nbsp;
  	<input type="button" name="Submit" id="Submit" value="Submit" onclick="submitPage();" style="position: relative;">
	</div>
	<br>
	<div id="log" style="height: 80%; width: 92%; padding-left: 2%; padding-right: 2%; margin: 2%; border: solid; overflow: auto;" class="container">
	</div>
	&nbsp;
	<input type="button" name="Refresh" id="Refresh" value="Refresh" onclick="refreshPage();" style="position: relative;">
	&nbsp;
	<input type="button" name="ClearLog" id="ClearLog" value="Clear Log" onclick="clearLog();" style="position: relative;">
	<br>
</body>

<script>
function onLoadPage(){
	if(<%=debugEnabled%>){
		if("All" == "<%=users%>"){
			document.getElementById("userList").value = "";
			document.getElementById("userList").disabled = true;
			document.getElementById("user").checked = false;
			document.getElementById("user").disabled = false;
			document.getElementById("all").checked = true;	
			document.getElementById("all").disabled = false;
		}else{
			document.getElementById("userList").value = '<%=users%>';
			document.getElementById("userList").disabled = false;
			document.getElementById("user").checked = true;
			document.getElementById("user").disabled = false;
			document.getElementById("all").checked = false;	
			document.getElementById("all").disabled = false;
		}
	}else{
		document.getElementById("debugOptions").disabled = true;
		document.getElementById("userList").value 	= "";
		document.getElementById("userList").disabled = true;
		document.getElementById("user").checked = false;
		document.getElementById("user").disabled = true;
		document.getElementById("all").checked = false;	
		document.getElementById("all").disabled = true;
	}
}
function enableDebigging(val){
	if(document.getElementById("debug").checked){
		document.getElementById("debugOptions").disabled = false;
		document.getElementById("userList").value = "";
		document.getElementById("userList").disabled = true;
		document.getElementById("user").checked = false;
		document.getElementById("all").checked = false;
		document.getElementById("user").disabled = false;
		document.getElementById("all").disabled = false;
		
	}else{
		document.getElementById("debugOptions").disabled = true;
		document.getElementById("userList").value = "";
		document.getElementById("userList").disabled = true;
		document.getElementById("user").checked = false;
		document.getElementById("all").checked = false;	
		document.getElementById("user").disabled = true;
		document.getElementById("all").disabled = true;
	}
}

function changeUserPreferenceForAll(val) {
	document.getElementById("user").checked = false;
	document.getElementById("userList").value = "";
	document.getElementById("userList").disabled = true;
	document.getElementById("Submit").disabled = false;
}

function changeUserPreferenceForUsers(val) {
	document.getElementById("all").checked = false;
	document.getElementById("userList").disabled = false;
	document.getElementById("userList").value = "<%=currentUser%>,";	
}

function submitPage()
{	
	var enableDebug = document.getElementById("debug").checked;
	var alluser = document.getElementById("all").checked;
	var debugLevel = document.getElementById("debugOptions").value;
	var selectedusers = document.getElementById("userList").value;
	var users = document.getElementById("user").checked;
	
	if(enableDebug){
		if((users && (null == selectedusers || "" == selectedusers))){
			alert("Please select users");
			return;
		}else if(!alluser && !users){
			alert("Please select users");
			return;
		}
	}	
	
    $.post("../drV6Tools/drV6ToolsLoggerPostProcess.jsp",
    		{
		    	debugLevel: debugLevel,
		    	alluser: alluser,
		    	userList: selectedusers,
		    	enableDebug: enableDebug
    	    },
    	    function(data, status){
    	    	var objDiv = document.getElementById("log");
    	    	objDiv.scrollTop = objDiv.scrollHeight;
    	    	if(enableDebug){
    	    		if(alluser){
    	    			alert("Debugging enabled for all users");
    	    		}else{
    	    			alert("Debugging enabled for following users: "+selectedusers);
    	    		}	
    	    	}else{
    	    		alert("Debugging disabled for all users");
    	    	}
    	    });
}

function refreshPage(){
	 $.ajax({
         url : "../drV6Tools/drV6ToolsLoggerLogData.jsp",
         dataType: "text",
		 cache : false,
         success : function (data) {
        	 $('.container').empty();
        	 var lines = data.split("\n");
        	    $.each(lines, function(n, elem) {
        	       $('.container').append('<div>' + elem + '</div>');
        	    });
        	 var objDiv = $('.container');
        	 if (objDiv.length > 0){
        	      objDiv[0].scrollTop = objDiv[0].scrollHeight;
        	 }       	 
         }
     });
	var objDiv = document.getElementById("log");
	objDiv.scrollTop = objDiv.scrollHeight;
}

function clearLog(){
	var enableDebug = document.getElementById("debug").checked;
	var alluser = document.getElementById("all").checked;
	var debigLevel = document.getElementById("debugOptions").value;
	var selectedusers = document.getElementById("userList").value;

    $.post("../drV6Tools/drV6ToolsLoggerPostProcess.jsp",
    		{
		    	debugLevel: debigLevel,
		    	alluser: alluser,
		    	userList: selectedusers,
		    	action: "clear",
		    	enableDebug: enableDebug
    	    },
    	    function(data, status){
    	    	$('.container').empty();
    	    });
}
</script>
</html>