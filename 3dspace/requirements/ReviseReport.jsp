<%--
  ReviseReport.jsp

  Performs the action that creates an incident.

  Copyright (c) 2009-2018 Dassault Systemes.
  All Rights Reserved.
  This program contains proprietary and trade secret information of MatrixOne,
  Inc.  Copyright notice is precautionary only
  and does not evidence any actual or intended publication of such program

  static const char RCSID[] = ;

 --%>
 <%--
    	@quickreview KIE1 ZUD 15:02:24 : HL TSK447636 - TRM [Widgetization] Web app accessed as a 3D Dashboard widget.
    --%>
<%-- Common Includes --%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<%@include file = "emxProductCommonInclude.inc" %>
<%@include file = "../emxUICommonAppInclude.inc"%>
<%@include file = "../emxUICommonHeaderBeginInclude.inc" %>
<%@include file = "../emxTagLibInclude.inc"%>
<%@page import = "java.util.List"%>
<%@page import = "com.matrixone.apps.domain.DomainConstants"%>

<script src="../common/scripts/emxUICore.js" type="text/javascript"></script>
<script language="Javascript" src="../common/scripts/emxUIConstants.js"></script>
<script language="javascript" src="../common/scripts/emxUIUtility.js"></script>
<script type="text/javascript" language="JavaScript">
        //addStyleSheet("emxUIDefault");
        //addStyleSheet("emxUIList");
        //addStyleSheet("emxUISearch");

function popupObjectDialog(oid)
{
    showNonModalDialog("../common/emxTree.jsp?emxSuiteDirectory=common&suiteKey=Framework&relId=&parentOID=null&jsTreeID=null&objectId=" + oid, 900, 600,true )
}        

<%
    try
    {
        String key = emxGetParameter(request, "key"); 
        if(key != null){ 
            Map updateResult = (Map)session.getAttribute(key);
            if(updateResult != null){
                int totalObjects = ((Integer)updateResult.get("totalObjects")).intValue();
                int failedObjects = ((Integer)updateResult.get("failedObject")).intValue();

%>
	function refreshParentAndClose()
	{
	//KIE1 ZUD TSK447636 
	    var openerwin = getTopWindow().getWindowOpener();
	    getTopWindow().closeWindow();
	  
	}

</script>
<style type="text/css">
ul {
    /* list-style: none;  */
    margin-left: 0px; 
    padding-left: 0px;
}
li {
    margin-left: 40px;
    padding-left: 0px; 
}
</style>
</head>
<body onunload="refreshParentAndClose()">
<%
                
                String suiteKey = emxGetParameter(request, "suiteKey");
                String strStringResourceFile = UINavigatorUtil.getStringResourceFileId(context,suiteKey);
                String[] arrFormatMessageArgs = new String[2];
                arrFormatMessageArgs[0] = failedObjects + "";
                arrFormatMessageArgs[1] = totalObjects + "";
%>
<xss:encodeForHTML><%=MessageUtil.getMessage(context, null, "emxRequirements.UpdateRevision.Error.UpdateSelectedFail",arrFormatMessageArgs, null, context.getLocale(), strStringResourceFile)%></xss:encodeForHTML>
                            
<%
              
                List exceptionObjects = (List)updateResult.get("reserveCheck");
                if(exceptionObjects.size() > 0){
                     boolean messageShown = false;
                    for(int i = 0; i < exceptionObjects.size(); i++){
                        arrFormatMessageArgs = new String[2];
                        Map values = (Map)exceptionObjects.get(i);
                      
                        String ids = (String) values.get("id");
                        String names = (String) values.get("name");
                        String revisions = (String) values.get("revision");
                        String errorMsg = (String) values.get("errorMsg1");
                        if(errorMsg == null) continue;
                        if(!messageShown) {messageShown = true;
                        %>
                       <p/><ul><emxUtil:i18nScript localize="i18nId">emxRequirements.Revise.Error.LastRevision</emxUtil:i18nScript><br/>
                        <%
                        }
                       
                        for(int j=0; j<ids.length(); j++){
                            arrFormatMessageArgs[0] = "<a href=\"javascript:popupObjectDialog('" + ids + 
                            "')\">  " + names + " " + 
                            revisions + "</a>";
                        }
%>
<li><xss:encodeForHTML><%=MessageUtil.getMessage(context, null, "emxRequirements.Revise.Error.Exception",arrFormatMessageArgs, null, context.getLocale(), strStringResourceFile)%></xss:encodeForHTML>
</li>

   
<%
                   } // End of 1st For Loop
%>
</ul>
<%  
messageShown= false;
for(int i = 0; i < exceptionObjects.size(); i++){
    arrFormatMessageArgs = new String[2];
    Map values = (Map)exceptionObjects.get(i);
    
    String ids = (String) values.get("id");
    String names = (String) values.get("name");
    String revisions = (String) values.get("revision");
    String errorMsg = (String) values.get("errorMsg2");
    if(errorMsg == null) continue;
    if(!messageShown) {messageShown = true;
    %>
   <p/><ul><emxUtil:i18nScript localize="i18nId">emxRequirements.Revise.Error.NotInReleaseState</emxUtil:i18nScript><br/>
    <%
    }
   	    for(int j=0; j<ids.length(); j++){
		        arrFormatMessageArgs[0] = "<a href=\"javascript:popupObjectDialog('" + ids + 
		        "')\">  " + names + " " + 
		        revisions + "</a>";
		    }
%>
<li><%=MessageUtil.getMessage(context, null, "emxRequirements.Revise.Error.Exception",
        arrFormatMessageArgs, null, context.getLocale(), strStringResourceFile)%>
</li>
<%
   }  // End of 2nd For Loop
%>
    </ul>
<%                  
                }    // End of IF Condition
                session.removeAttribute(key);
            }
        }else{
        
        }
    }
    catch (Exception exp)
    {
        exp.printStackTrace(System.out);
        session.putValue("error.message", exp.getMessage());
        //throw exp;
    }
%>
</body>
<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>

<%@page import="java.util.StringTokenizer"%>
<%@page import="matrix.util.StringList"%>
<%@page import="com.matrixone.apps.domain.util.FrameworkUtil"%>
<%@page import="com.matrixone.apps.domain.util.MessageUtil"%></html>
