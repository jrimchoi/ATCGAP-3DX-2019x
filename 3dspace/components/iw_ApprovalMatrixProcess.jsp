<%--
  iw_ApprovalMatrixProcess.jsp

  Copyright (c) 2007 Integware, Inc.  All Rights Reserved.
  This program contains proprietary and trade secret information of
  Integware, Inc.
  Copyright notice is precautionary only and does not evidence any
  actual or intended publication of such program.

  $Rev: 658 $
  $Date: 2011-02-27 16:46:51 -0700 (Sun, 27 Feb 2011) $
--%>

<%@include file = "emxComponentsDesignTopInclude.inc"%>
<%@ include file = "../emxUICommonHeaderBeginInclude.inc" %>
<%@include file = "../emxUICommonHeaderEndInclude.inc" %>
<%@include file = "../common/enoviaCSRFTokenValidation.inc"%>
<%@page import="com.matrixone.apps.domain.util.XSSUtil"%>

<script language="javascript" src="../common/scripts/emxUICore.js"></script>
<%
  int iNumberOfApprovers = 1;
  HashMap tempMap = new HashMap();
  HashMap masterMap = new HashMap();
  String sTaskName = "";
  String UserList = emxGetParameter(request,"UserList");
  String sBusObjId = (String) emxGetParameter(request, "busId");
  String sNumberOfApprovers = emxGetParameter(request, "iNumberOfApprovers");
  String sStartImmediately = emxGetParameter(request, "startImmediately");

  String routeDescription       = (String) emxGetParameter(request,"routeDescription");
  String routeCompletionAction  = (String) emxGetParameter(request,"routeCompletionAction");
  String routeBasePurpose       = (String) emxGetParameter(request,"routeBasePurpose");
  String routeScope             = (String) emxGetParameter(request,"routeScope");

  masterMap.put("routeDescription",routeDescription);
  masterMap.put("routeCompletionAction",routeCompletionAction);
  masterMap.put("routeBasePurpose",routeBasePurpose);
  masterMap.put("routeScope",routeScope);

  masterMap.put("startImmediately", sStartImmediately);

  masterMap.put("sBusObjId",sBusObjId);

  //// COPIED FROM emxExecute.jsp ////
  HashMap paramMap = new HashMap();
  Enumeration enumeration = emxGetParameterNames(request);
  while ( enumeration.hasMoreElements() )
  {
    String name = (String)enumeration.nextElement();
    String value = emxGetParameter(request, name);

    if (name.startsWith("Map_"))
    {
      tempMap.put(name,value);
    }
  }

  iNumberOfApprovers = Integer.parseInt(sNumberOfApprovers);
  for (int i=1; i <= iNumberOfApprovers; i++)
  {
    HashMap taskMap = new HashMap();
    String[] keyArray = (String[])tempMap.keySet().toArray(new String[0]);
    for(int j =0; j < keyArray.length; j++)
    {
      if (keyArray[j].startsWith("Map_"+i+"_"))
      {
        // This is a terrible way to do this but it works so forget about it
        String sTaskAttrName = "";
        if ( i < 10 )
          sTaskAttrName = keyArray[j].substring(6);
        else if ( i < 100 )
          sTaskAttrName = keyArray[j].substring(7);
        else
          sTaskAttrName = keyArray[j].substring(8);

        String sTaskAttrValue = (String)tempMap.get(keyArray[j]);
        taskMap.put(sTaskAttrName, sTaskAttrValue);
      }
    }
    //The taskmap may be empty when a user added an adhoc user then removed
    //it later
    if (!taskMap.isEmpty())
      masterMap.put(Integer.toString(i),taskMap);
  }

  String[] args = JPO.packArgs(masterMap);

  //Call the JPO for processing
  int iRet = 0;
  String[] constructor = { "" };
  try
  {
    ContextUtil.startTransaction(context, true);
    DomainObject bo =  new DomainObject(sBusObjId);

    //  Set an environmental variable to bypass any check triggers that are 'listening' for this env variable.
    MQLCommand mqlComm = new MQLCommand();
    mqlComm.open(context);
    mqlComm.executeCommand(context,"set env global BYPASS_CHECK_TRIGGER TRUE");
    mqlComm.close(context);

    bo.promote(context);
    iRet = JPO.invoke(context, "IW_ApprovalMatrix", constructor, "createRoute", args);
    ContextUtil.commitTransaction(context);
  }
  catch(Exception mExp)
  {
    ContextUtil.abortTransaction(context);
    String errorMsg = mExp.toString();
    int intLastColon = errorMsg.lastIndexOf(":");
    errorMsg = errorMsg.substring(intLastColon+1);
    errorMsg = errorMsg.replace('\'', ' ');
    errorMsg = errorMsg.replace('\n', ' ');
    System.out.println("MatrixException: " + errorMsg);
%>
    <script language = "javascript" type = "text/javascript">
      alert("<%=XSSUtil.encodeForJavaScript(context, errorMsg)%>");
      window.history.back();
    </script>
<%
  }
%>
<!--
The following was adapted from emxFormEditProcess.jsp.
-->
  <script language=javascript type="text/javascript">
//    debugger;
//    var frame=findFrame(getTopWindow().getWindowOpener().getTopWindow(),"content");
//    frame.treeContent.detailsDisplay.location.reload();
//   setTimeout("window.close()", 1000);
<%
String portalMode = emxGetParameter(request, "portalMode");
boolean isPortal = (portalMode != null && "true".equalsIgnoreCase(portalMode));
if (!isPortal)
{
%>
    var contextTree = null;
    var objNode = null;

    if (findFrame(getTopWindow().getWindowOpener().getTopWindow(), "treeDisplay"))
    {
        contextTree = getTopWindow().getWindowOpener().getTopWindow().objDetailsTree;
        if(contextTree)
        {
            contextTree.doNavigate = true;
            objNode = contextTree.findNodeByObjectID("<%=XSSUtil.encodeForJavaScript(context, sBusObjId)%>");
        }
    }

    //Remove the duplicate object id parameters and append the one got from request
    var formUrl = getTopWindow().getWindowOpener().parent.document.location.href;
    var newURL = formUrl;
    if(newURL.indexOf("objectId") < 0)
    {
        newURL += (newURL.indexOf('?') > -1 ? '&' : '?') + "objectId=<%=XSSUtil.encodeForJavaScript(context, sBusObjId)%>";
    }

    if (getTopWindow().getWindowOpener() != null && !getTopWindow().opener.closed)
    {
        if (getTopWindow().getWindowOpener() && getTopWindow().getWindowOpener().getTopWindow().modalDialog)
        {
            if(!(getTopWindow().getWindowOpener().getTopWindow().modalDialog.contentWindow.closed))
            {
                getTopWindow().getWindowOpener().getTopWindow().modalDialog.releaseMouse();
            }
        }
    }

    var arrURLParts = newURL.split("?");

    if(objNode)
    {
        var formOpener = getTopWindow().getWindowOpener().document.location.href;
        var pMode = formOpener.indexOf("portalMode=true");
        if((formOpener.indexOf("emxForm.jsp")>-1 || formOpener.indexOf("emxTable.jsp") >-1 ||  formOpener.indexOf("emxIndentedTable.jsp") >-1) && (pMode > -1))
        {
            getTopWindow().getWindowOpener().document.location.href = formOpener;
        }
        else
        {

            var formOpenerParent = getTopWindow().getWindowOpener().parent.document.location.href;
            pMode = formOpenerParent.indexOf("portalMode=true");
            if((formOpenerParent.indexOf("emxForm.jsp")>-1 || formOpenerParent.indexOf("emxTable.jsp") >-1 ||  formOpenerParent.indexOf("emxIndentedTable.jsp") >-1) && (pMode > -1))
            {
                getTopWindow().getWindowOpener().parent.document.location.href = formOpenerParent;
            }
            else
            {
                contextTree.refresh();
            }
        }

    }
    else
    {
      if(getTopWindow().getWindowOpener().parent)
      {
          var openerURL="";
          var isIndentedTablePage=false;

          if(getTopWindow().getWindowOpener().document.location.href.indexOf("emxIndentedTable.jsp")>-1)
          {
              openerURL = getTopWindow().getWindowOpener().document.location.href;
              isIndentedTablePage=true;
          }
          else
          {
              openerURL = getTopWindow().getWindowOpener().parent.document.location.href;
          }

          if(openerURL.indexOf("emxTable.jsp") >= 0)
          {
            	//var reloadURL = getTopWindow().getWindowOpener().parent.frames[1].document.location.href;
		        //reloadURL += "&clearValuesMap=true";
		        getTopWindow().getWindowOpener().parent.frames[1].document.location.href// = reloadURL;
          }
          else
          {
              if(isIndentedTablePage)
              {
                  getTopWindow().getWindowOpener().document.location.href = openerURL;
              }
              else
              {
                  getTopWindow().getWindowOpener().parent.document.location.href = newURL;
              }
          }
      }
    }
    getTopWindow().close();
    getTopWindow().getWindowOpener().parent.location.reload();
<%
} // End if (!isPortal)
%>
</script>
<!--
The following was adapted from emxFormEditProcess.jsp. End
-->
