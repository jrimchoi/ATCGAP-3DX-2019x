<%-- iwCAPACreateDisplay.jsp

   Copyright (c) 2007 Integware, Inc.
   All Rights Reserved.
   This program contains proprietary and trade secret information of
   Integware, Inc.
   Copyright notice is precautionary only and does not evidence any
   actual or intended publication of such program

   $Rev: 334 $
   $Date: 2008-02-19 17:19:46 -0700 (Tue, 19 Feb 2008) $
--%>

<%@include file = "../emxUIFramesetUtil.inc" %>
<%@page import="matrix.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.matrixone.apps.domain.util.*"%>
<%@page import="com.matrixone.apps.domain.util.EnoviaResourceBundle"%>


<%
	String function = emxGetParameter(request,"function");
	String program = emxGetParameter(request,"program");
	String HelpMarker  = emxGetParameter(request,"HelpMarker");
	String objectId    = emxGetParameter(request,"objectId");
   
	String BUNDLE      = "LSACommonFrameworkStringResource";
	String languageStr = request.getHeader("Accept-Language");
   
	HashMap paramMap = new HashMap();
	paramMap.put("objectId", objectId);
  
	StringList typeList = (StringList)JPO.invoke(context, program, null, function, JPO.packArgs(paramMap), StringList.class);
	String errorMsg =  EnoviaResourceBundle.getProperty(context,BUNDLE,context.getLocale(),"LSACommonFramework.Message.NoTypesConfigured"); 
  
	StringBuffer types = new StringBuffer("TYPES=");
	StringBuffer currentExclusions = new StringBuffer();
	 
	Iterator itrType = typeList.iterator();
	int i=0; 
	while(itrType.hasNext()) {	
		String type = (String)itrType.next();
		if("".equalsIgnoreCase(type)) {
			continue;
  		}  		
		if(i==0) {
			types.append(type);
		} else {
			types.append("," + type);
		}
		
		String args = type;
		HashMap programMap = new HashMap();
		programMap.put("type", type);
  		String currentExclusion = (String)JPO.invoke(context, "iwBPIBase", null, "getCurrentListForType", JPO.packArgs(programMap), String.class);
  		if(currentExclusion.length() > 0) {
  			if(currentExclusions.length() == 0) {
				currentExclusions.append(":CURRENT!=" + currentExclusion);
			} else {
				currentExclusions.append("," + currentExclusion);
			}
		}
		i++;
	}
  
	//types = new StringBuffer("TYPES=type_Complaint,type_Audit:CURRENT!=policy_Audit.state_Plan,policy_Audit.state_Active");
	String contentURL = "../common/emxFullSearch.jsp";  
		contentURL += "?field=" + types + currentExclusions;
		contentURL += "&table=AEFGeneralSearchResults" +
     				"&selection=multiple" +
     				"&submitAction=refreshCaller" +
     				"&HelpMarker=" + HelpMarker +
     				"&submitURL=iwExecute.jsp?program=iwBPI:connect" +
     				"&mode=Chooser" +
     				"&chooserType=FormChooser";
		contentURL += "&objectId=" + objectId;
       
	if(typeList.size() == 0) {
     %>
     <script language="javascript">
     alert("<%= errorMsg%>");
     getTopWindow().close();
     </script>
     <%
    } else {
		response.sendRedirect(contentURL);
	}
  	//fs.writePage(out);
%>

