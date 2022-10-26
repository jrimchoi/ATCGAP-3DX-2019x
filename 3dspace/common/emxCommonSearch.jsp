<%@page import="matrix.db.MQLCommand"%>
<%@ page import = "matrix.db.*,matrix.util.*,com.matrixone.servlet.Framework,java.util.*,java.io.*,com.matrixone.apps.domain.util.*,com.matrixone.apps.framework.ui.*" %>
<jsp:useBean id="indentedTableBean" class="com.matrixone.apps.framework.ui.UITableIndented" scope="session"/>
<%@include file = "emxNavigatorInclude.inc"%>

<%

 
 MQLCommand MQL = new MQLCommand();
 MQL.executeCommand(context, "list type *");
	String sTypeList = MQL.getResult();
	
	
		String[] lines = sTypeList.split("\\r?\\n");
		
        
	
  %>
  <html>
 <script language="javascript">
 
  function getValue(){
            	
				
            	var plmId = document.getElementById('send');
				
				var typevalue = document.frmMain.type.value;
				
				var name = document.frmMain.name.value;
				var title = document.frmMain.title.value;
				plmId = plmId+"&pName="+name+"&pTypeValue="+typevalue+"&pTitle="+title;
						
				
				top.content.location.href= plmId;
			
                
                
            }

           
  
 </script>
<body> 
<form name="frmMain" id="frmMain" method="post" action="javascript:getValue" target="_parent">
<a id="send" name="send" href="emxIndentedTable.jsp?table=AEFGeneralSearchResults&program=gap_Util:getObjectsOfSearchedType"></a>

<table>
  <tr>
  <!--//XSSOK-->
    <td class="Name">Name</td>
   	<td class="inputField" >
	<INPUT TYPE="TEXT" NAME="name"/>
          </td>
    </tr>
	    <tr><!--//XSSOK-->
      <td class="Title" >Title </td> 
      <td class="inputField" >
        <input type="text" name="title" size="20" />
      </td>	  
    </tr>
	<tr>
	 <td class="Type" >Type </td>
            
	<td class="inputField" >
          <select name = "type" >
		  <option value="Part">Part</option>
				<option value="gapGAPSpecification">gapGAPSpecification</option>
				<option value="Document">Document</option>
				<option value="SW Drawing">SW Drawing</option>
				<option value="gapAutoCAD">gapAutoCAD</option>
<%


							
				

        for (String line : lines) {
          
           %>
			
            <option value="<%=line%>" ><%=line%></option>
<%
         }
%>
        </select>
      </td>
	</tr>
	<tr>
	<td class = "inputField" >
          <!-- //XSSOK -->
          
          <input type="button" name="FieldButton" value="search" size="5" onClick="getValue()"/>
                </td>
    </tr>
    </table>
  
</form>
</body>
</html>

<%@include file = "../emxUICommonEndOfPageInclude.inc" %>

  