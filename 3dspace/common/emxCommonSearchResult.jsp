<%@page import="matrix.db.MQLCommand"%>
<%@ page import = "matrix.db.*,matrix.util.*,com.matrixone.servlet.Framework,java.util.*,java.io.*,com.matrixone.apps.domain.util.*,com.matrixone.apps.framework.ui.*" %>
<jsp:useBean id="indentedTableBean" class="com.matrixone.apps.framework.ui.UITableIndented" scope="session"/>
<%@include file = "emxNavigatorInclude.inc"%>

<%

 System.out.println("Inside emxCommonSearchResult.jsp");
  System.out.println(request.getParameter("pName")); 
  System.out.println(request.getParameter("pTypeValue")); 
  System.out.println(request.getParameter("pTitle")); 
 /*MQLCommand MQL = new MQLCommand();
 MQL.executeCommand(context, "list type *");
	String sTypeList = MQL.getResult();
	//System.out.println("Inside emxCommonSearch.jsp sTypeList>>>>>>>>>>>>>>>>"+sTypeList);
	
		String[] lines = sTypeList.split("\\r?\\n");*/
        
	
  %>
<html>
<form name="frmMain" method="post" action="emxCommonSearchResult.jsp" target="_parent" onsubmit="submitForm(); return false">
<table>
  <tr>
   	<td class="inputField" >
	<INPUT TYPE="hidden" NAME="pName"/>
	<INPUT TYPE="hidden" NAME="pTypeValue"/>
	<INPUT TYPE="hidden" NAME="pTitle"/>
          </td>
    </tr>
	    

    </table>
 
</form>
</html>

<%@include file = "../emxUICommonEndOfPageInclude.inc" %>

  