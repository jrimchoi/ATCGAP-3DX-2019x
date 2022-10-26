<%@ page language="java" %>
<%
String Message = (String)request.getAttribute("Message");
Boolean setAlert = (Boolean)request.getAttribute("setAlert");

%>

<script language = "Javascript" src="../../common/scripts/emxUIConstants.js"></script>

<script language="Javascript">
var messgage= '<%= Message%>';
<%
if(setAlert){

%>
alert(messgage);
<%
}
%>
window.close();
</script>