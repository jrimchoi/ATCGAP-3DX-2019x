<%--  emxCollectionsEditProcess.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxCollectionsEditProcess.jsp  - To edit Collections

   static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxCollectionsEditProcess.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>
<%@ page import = "com.matrixone.MCADIntegration.utils.*" %>

<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>

<%@include file = "../common/enoviaCSRFTokenValidation.inc"%>
<!-- Import the java packages -->

<%
  String objectName = emxGetParameter(request,"objectName");
  objectName = MCADUrlUtil.hexDecode(objectName);
  
  String newSetName = emxGetParameter(request, "collectionName");
  String description = emxGetParameter(request, "description");
  String nameChanged = emxGetParameter(request, "nameChanged");
  String jsTreeID = emxGetParameter(request,"jsTreeID");
  String suiteKey = emxGetParameter(request,"suiteKey");
  String reloadURL = "";

  String charSet = request.getCharacterEncoding();
  if(charSet == null || charSet.equals(""))
	charSet = "UTF-8";

  try {
       if(nameChanged.equalsIgnoreCase("true")){
           boolean setExists = SetUtil.exists(context, newSetName);
           if (setExists)
           {
              reloadURL = "../common/emxTree.jsp?AppendParameters=true&mode=replace&treeMenu=AEFCollectionsMenu&treeLabel=" + FrameworkUtil.encodeNonAlphaNumeric(objectName, charSet)+ "&jsTreeID=" + jsTreeID + "&suiteKey=" + suiteKey + "&objectName="+newSetName;
 %>
             <script language="Javascript">
             var alertMsg = "<emxUtil:i18n localize="i18nId">emxFramework.Collections.CollectionError</emxUtil:i18n>";
             alertMsg += " ";
			 //XSSOK
             alertMsg += "<%=newSetName%>";
             alertMsg += " ";
             alertMsg += "<emxUtil:i18n localize="i18nId">emxFramework.Collections.AlreadyExists</emxUtil:i18n>";
             alert(alertMsg);
             parent.location.href=parent.location.href;
             </script>
 <%
           }
           else
           {
                matrix.db.Set newSet = SetUtil.rename(context, objectName, newSetName);
                String output = MqlUtil.mqlCommand(context, "modify set $1 property $2 value $3",newSetName,"description",description);

                reloadURL = "../common/emxTree.jsp?AppendParameters=true&mode=replace&treeMenu=AEFCollectionsMenu&treeLabel=" + newSetName + "&jsTreeID=" + jsTreeID + "&suiteKey=" + suiteKey;
           }
       }else{
            String output = MqlUtil.mqlCommand(context, "modify set $1 property $2 value $3",newSetName,"description",description);
            reloadURL = "../common/emxTree.jsp?AppendParameters=true&mode=replace&treeMenu=AEFCollectionsMenu&treeLabel=" + newSetName + "&jsTreeID=" + jsTreeID + "&suiteKey=" + suiteKey;
       }
  }
  catch(Exception e)
  {
    throw e;
  }

%>
<script language="javascript" src="../common/scripts/emxUIConstants.js"></script> 
<script language="Javascript">
<%
    if("true".equals(nameChanged))
    {
        reloadURL = "../common/emxTree.jsp?AppendParameters=true&mode=replace&treeMenu=IEFCollectionsMenu&treeLabel=" + java.net.URLEncoder.encode(FrameworkUtil.encodeURL(newSetName,charSet)) + "&jsTreeID=" + jsTreeID + "&suiteKey=" + suiteKey + "&setName=" + MCADUrlUtil.hexEncode(newSetName);
        
%>		
        var treeDisplayFrame = findFrame(top.opener.top, "treeContent");
        if(treeDisplayFrame != null){
		    //XSSOK
            treeDisplayFrame.document.location.href = "<%=reloadURL%>";
        }else{
		    //XSSOK
            top.opener.top.document.location.href = "<%=reloadURL%>";
        }

<%
    }
    else
    {
%>
        var treeDisplayFrame = findFrame(top.opener.top, "treeContent");
        if(treeDisplayFrame != null){
            top.opener.document.location.href = top.opener.document.location.href;
        }else{
            top.opener.top.document.location.href = top.opener.top.document.location.href;
        }

<%
    }
%>
  top.close();
</script>

<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
