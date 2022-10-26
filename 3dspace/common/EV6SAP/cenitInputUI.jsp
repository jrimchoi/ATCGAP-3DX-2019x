<%@ page language="java" %>
<%@ page import = "matrix.db.Context" %>
<%@ page import = "java.util.*" %>
<%@ page import = "matrix.util.StringList" %>
<%@ page import = "de.cenit.ev6sap.adaptor.EV6SAP" %>
<%@ page import = "java.util.Iterator" %>
<%@ page import = "java.util.Map.Entry" %>


<% 


Hashtable<String, String> attributeLine = new Hashtable<String, String>();
Hashtable<String, String> attributeType = new Hashtable<String, String>();
String strTitle = (String)request.getAttribute("Title");
attributeLine = (Hashtable)request.getAttribute("attributeLine");
attributeType = (Hashtable)request.getAttribute("attributeType");

Object ev6sap= request.getAttribute("ev6sap");
session.setAttribute("ev6sap",ev6sap);
session.setAttribute("attributeLine",attributeLine);
Iterator<Entry<String, String>> I = attributeLine.entrySet().iterator();

%>


<HTML>
 <HEAD>
   <TITLE><%= strTitle %></TITLE>
<script type="text/javascript">


</script> 

  </HEAD>
    <style type="text/css">
body
{
background-image:url('gradiant.png');


margin-right:200px;
}
</style>
 <BODY bgcolor=#D3D3D3>

  <form name=ev6sap1 method="get" action="../../SERVLETACTION" onSubmit="return checkform(this)">

  <center>
  <h1><%= strTitle %> </h1><br>
  <table border=1>
  <%
   while (I.hasNext()) {

    Entry<String, String> E = I.next();
	String Key = (String) E.getKey();			

    String Value = (String) E.getValue();
	 String AttributeType  = "" + attributeType.get(Key);;

  %>
  <tr>
  <td>
  <%= Key %>
   </td>
  <td>
  <%
  if("Password".equalsIgnoreCase(AttributeType)){

  %>
  <input type="Password" name="<%= Key %>" value="<%= Value %>">
  <%
  }else{
  %>
  <input type="text" name="<%= Key %>" value="<%= Value %>">
  <%
  }
  
  %>
  
  </td>
  </tr>
  
	<%
	}
  
 %>   

  <tr>
  <td align=center><input type="reset" name="reset" value="Refresh"></td>
  <td align=center><input type="submit" name="Submit" value="Submit" ></td>
  
  <table>
  </center>
  </form>
 </BODY>
</HTML>
