<%--
  iwCSAjaxController.jsp

  Copyright (c) 2007 Integware, Inc.  All Rights Reserved.
  This program contains proprietary and trade secret information of
  Integware, Inc.
  Copyright notice is precautionary only and does not evidence any
  actual or intended publication of such program.

  $Rev: 658 $
  $Date: 2011-02-27 16:46:51 -0700 (Sun, 27 Feb 2011) $
--%>

<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>

<%
String listProgramName = emxGetParameter(request, "listProgramName");
String languageStr = request.getHeader("Accept-Language");

HashMap paramMap = new HashMap();
paramMap.put("languageStr", lStr);
paramMap.put("displayCodeType", "JavaScript");

Enumeration enum1 = request.getParameterNames();

while (enum1.hasMoreElements()) {
    String name  = (String) enum1.nextElement();
    String[] value = emxGetParameterValues(request,name);

    if(value.length <= 1) // This is a string value
        paramMap.put(name,emxGetParameter(request, name));
    else
        paramMap.put(name, value);
}

HashMap programMap = new HashMap();
programMap.put("paramMap", paramMap);
String[] methodArgs = JPO.packArgs(programMap);


// Get the values for the child menu based on this parent menu's selected value
// Note: there are two different supported ways of doing this:
// 1. Custom JPO: the listProgramName is a JPO program and method we call to get the values
// 2. Default JPO: the listProgramName is a program object whose Code body holds the values, and we call a
//    utility JPO program and method to that knows how to read the values out of the Code body of the program
HashMap optionMap = new HashMap();
int colonIndex = listProgramName.indexOf(":");
// We know it's a Custom JPO if it has ":"
if (colonIndex > -1) {
    String programName = listProgramName.substring(0, colonIndex);
    String programMethod = listProgramName.substring(colonIndex + 1, listProgramName.length());
    optionMap = (HashMap) JPO.invoke(context, programName, null, programMethod, methodArgs, HashMap.class);
// Else it's just the name of the program that contains the CSL choices
}

// create the JSON object to return
String options = "";

java.util.Set keySet = optionMap.keySet();
Iterator keyIter = keySet.iterator();

int count = 0;
while(keyIter.hasNext()) {
    String key = (String) keyIter.next(); // key is English
    String text = (String) optionMap.get(key); // text is localized key

    if (count > 0) options += ", ";

    options += "{\"text\": \"" + key + "\", \"value\": \"" + text + "\"}";
    count++;
}

response.setContentType("application/json; charset=utf-8");
response.setHeader("Expires", "Mon, 26 Jul 1997 05:00:00 GMT"); // intentionally expired
response.setHeader("Cache-Control", "no-cache");

String responseText =  "ajaxResponse{\"result\": [" + options + "]}ajaxResponse";
PrintWriter writer = response.getWriter();
writer.write(responseText);
writer.close();
%>
