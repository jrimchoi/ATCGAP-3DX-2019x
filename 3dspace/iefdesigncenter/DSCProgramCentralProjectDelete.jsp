<%-- DSCProgramCentralProjectDelete.jsp

  Copyright (c) 1992-2012 Dassault Systemes.
  All Rights Reserved.
  This program contains proprietary and trade secret information of MatrixOne,
  Inc.  Copyright notice is precautionary only  and does not evidence any actual or intended publication of such program
  
--%>
<%@ page import="com.matrixone.apps.domain.util.*" %>
<%@ include file="emxInfoCentralUtils.inc"%>
<%
    String strInvokedFrom   = emxGetParameter(request,"invokedFrom");

	String[] projects  		= emxGetParameterValues(request,"emxTableRowId");
	String[] emxTableRowId 	= new String[projects.length];

	if(strInvokedFrom != null && "StructureBrowser".equals(strInvokedFrom))
	{
	  for (int i=0;i<projects.length;i++)
	  {
	  	  StringList sList  = FrameworkUtil.split(projects[i],"|");
		  String relId = "";
		  String objId = "";
		  String  pId  = "";
		  String rowId = "";
		  
		  if(sList.size() == 1 || sList.size() == 2)
			  objId	= (String)sList.get(0);		  
		
		  else if(sList.size() == 3)
			  objId = (String)sList.get(0);
		  
		  else if(sList.size() == 4)
		  {
			  relId		= (String)sList.get(0);
			  objId	  	= (String)sList.get(1);
			  pId		= (String)sList.get(2);
			  rowId 	= (String)sList.get(3);
		  }
		  if(objId != null)
	      	emxTableRowId[i] = relId+"|"+objId+"|"+pId+"|"+rowId;
	  }
	}
   
	if(projects == null)
   	{
    	projects = emxGetParameterValues(request,"selectedIds");
   	}
	

	String queryString = "";
	Enumeration enumParamNames = emxGetParameterNames(request);
	while(enumParamNames.hasMoreElements()) 
	{
		String paramName  = (String) enumParamNames.nextElement();
		String paramValue = "";
		paramValue = (String)emxGetParameter(request, paramName);
		if(paramName.equals("emxTableRowId"))
		{	
			for(int i = 0; i < emxTableRowId.length; i++)
				queryString += paramName+ "=" +emxTableRowId[i]+"&";
		}
		else 
			queryString += paramName+ "="+paramValue+"&";
    }

    if((null != queryString) && !("null".equalsIgnoreCase(queryString)) && (queryString.trim().length() != 0))
    	queryString = queryString.substring(0,queryString.length()-1);
    
    queryString = "../programcentral/emxProgramCentralProjectDeleteProcess.jsp?"+queryString;
%>
<html>
<head>
<script type="text/javascript">
	
	window.location.replace("<%=XSSUtil.encodeForHTML(context,queryString)%>");
</script>
</head>
</html>

