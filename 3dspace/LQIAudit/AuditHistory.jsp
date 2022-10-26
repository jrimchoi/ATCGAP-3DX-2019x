<%--
   Copyright (c) 20014-2018 Dassault Systemes.
   All Rights Reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes,Inc.
   Copyright notice is precautionary only and does not evidence any
   actual or intended publication of such program

   $Rev: 296 $
   $Date: 2008-02-05 07:39:05 -0700 (Tue, 05 Feb 2008) $
--%>

<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@page import="com.dassault_systemes.enovia.lsa.Helper"%>
<%@page import="matrix.db.Context"%>
<%@page import="com.dassault_systemes.enovia.lsa.LSAException"%>

<%!
       private String getEncodedI18String(Context context, String key) throws LSAException {
              try {
                     return XSSUtil.encodeForJavaScript(context,Helper.getI18NString(context, Helper.StringResource.AUDIT, key));
              } catch (Exception e) {
                     throw new LSAException(e);
              }
       }
%> 
<%
  String initSource = emxGetParameter(request,"initSource");

  if (initSource == null){
    initSource = "";
  }
  String jsTreeID       = emxGetParameter(request,"jsTreeID");
  String suiteKey       = emxGetParameter(request,"suiteKey");
  String HistoryMode    = emxGetParameter(request,"HistoryMode");
  String header         = emxGetParameter(request,"header");
  String frmLanguage    = request.getHeader("Accept-Language");

  boolean eMsg = false;

  String objectId           = emxGetParameter(request,"objectId");
  String preFilter          = emxGetParameter(request,"preFilter");
  String showFilterAction   = emxGetParameter(request,"showFilterAction");
  String showFilterTextBox  = emxGetParameter(request,"showFilterTextBox");
  String categoryTreeName =  emxGetParameter(request, "categoryTreeName");
  String isStructure = emxGetParameter(request, "isStructure");
  // ----------------- Do Not Edit Above ------------------------------

  boolean isSuiteKey=false;
  String SuiteKey = emxGetParameter(request,"SuiteKey");
  Properties suiteProperties = null;
  String PropertyFileTypeList="";

  String PropertyFileError = Helper.getI18NString(context,Helper.StringResource.AUDIT,"LQIAudit.Message.ErrorLoadingPropertiesFile");

 if(preFilter != null && !preFilter.equalsIgnoreCase("null") && preFilter.length()>0)
 {
   Properties eMatrixProperties =(Properties)application.getAttribute("eMatrixProperties");
    if(eMatrixProperties==null)
      throw new Exception(PropertyFileError);

   if(SuiteKey != null && SuiteKey.length()>0 ) {
     String PropertyAliasName = eMatrixProperties.getProperty(SuiteKey + ".PropertyFileAlias");
     try
     {
       suiteProperties = (Properties)application.getAttribute(PropertyAliasName);
     }catch(Exception e){

     }

     if(suiteProperties==null)
          throw new Exception(PropertyFileError + PropertyAliasName);
     else
         isSuiteKey=true;  //Use to indicate that types will be picked up by specific application other than the framework.

     }

          if(isSuiteKey){
            PropertyFileTypeList=suiteProperties.getProperty(preFilter);
        }else{
            PropertyFileTypeList=eMatrixProperties.getProperty(preFilter);
        }

        if(PropertyFileTypeList==null)
          PropertyFileTypeList=preFilter;
   } else{

      PropertyFileTypeList=null;
   }


    String InvalidObjectMessage=Helper.getI18NString(context,Helper.StringResource.AEF,"emxFramework.History.InvalidObject");
    if(objectId == null  || objectId.equals(""))
        throw new Exception(InvalidObjectMessage);

    if(preFilter == null  || preFilter.equals(""))
       preFilter="*";

    if(showFilterAction == null  || showFilterAction.equals(""))
       showFilterAction="true";

    if(showFilterTextBox == null  || showFilterTextBox.equals(""))
       showFilterTextBox="true";

    if(HistoryMode == null  || HistoryMode.equals(""))
       HistoryMode="CurrentRevision";

    if(header == null  || header.equals(""))
      header="emxFramework.Common.History";

  String parsedHeader = UIForm.getFormHeaderString(context, pageContext, header, objectId, suiteKey, frmLanguage);
  //do not have to encode header anymore since move header into <div> element from header jsp
  //parsedHeader=java.net.URLEncoder.encode(parsedHeader);

  // Specify URL to come in middle of frameset
  String contentURL = "AuditHistoryDisplay.jsp";

  // add these parameters to each content URL, and any others the App needs
  contentURL += "?suiteKey=" + suiteKey + "&initSource=" + initSource + "&jsTreeID=" + jsTreeID;
  contentURL += "&objectId="+objectId;
  contentURL += "&HistoryMode="+HistoryMode;
  contentURL += "&header="+parsedHeader;
  contentURL += "&preFilter="+PropertyFileTypeList;
  contentURL += "&showFilterAction="+showFilterAction;
  contentURL += "&showFilterTextBox="+showFilterTextBox;

  // to allow defining it on the command
  String sHelpMarker = emxGetParameter(request,"HelpMarker");
  if (sHelpMarker == null || sHelpMarker.trim().length() == 0)
    sHelpMarker = "emxhelphistory";

  //String sRegDir="common";
  if (suiteKey != null && suiteKey.startsWith("eServiceSuite")) {
    suiteKey = suiteKey.substring(13);
  }

  String sRegDir = "common";
  if ((suiteKey != null) && (suiteKey.trim().length() > 0)) {
    sRegDir = UINavigatorUtil.getRegisteredDirectory(suiteKey);
  }

%>
<html>
  <head>
    <title><%=/*XSS OK*/getEncodedI18String(context,"LQIAudit.Command.History")%></title>
    <script language="javascript" type="text/javascript" src="../common/scripts/emxUIConstants.js"></script>
    <%@include file = "../emxStyleDefaultInclude.inc"%>
            <script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script>
        <script language="JavaScript" src="../common/scripts/emxUICore.js"></script>
        <script language="JavaScript" src="../common/scripts/emxUICoreMenu.js"></script>
        <script language="JavaScript" src="../common/scripts/emxUIToolbar.js"></script>

    <script src="../common/scripts/emxNavigatorHelp.js" type="text/javascript"></script>
    <script src="../common/scripts/iwPrinterUtils.js" type="text/javascript"></script>
    <script type="text/javascript">
    addStyleSheet("emxUIDOMLayout");
    addStyleSheet("emxUIToolbar");
    addStyleSheet("emxUIMenu");
    </script>
    

    <style type="text/css">
		div#divPageBody {
		  top:68px;
		  bottom:0px;
		}
    </style>
  </head>

  <div id="pageHeadDiv">
		   <table>
		<tr>
		    <td class="page-title">
		      <h2><%=XSSUtil.encodeForJavaScript(context,parsedHeader)%></h2>
		      </td>
		</tr>
		</table>
		<script language="JavaScript" src="../common/emxToolbarJavaScript.jsp?export=false&isStructure=<%=XSSUtil.encodeForJavaScript(context,isStructure)%>&categoryTreeName=<%=XSSUtil.encodeForJavaScript(context,categoryTreeName) %>&objectId=<%=XSSUtil.encodeForJavaScript(context,objectId) %>&HelpMarker=<%=XSSUtil.encodeForJavaScript(context,sHelpMarker)%>&suiteKey=<%=XSSUtil.encodeForJavaScript(context,suiteKey)%>" type="text/javascript"></script>
		<div id="divToolbarContainer" class="toolbar-container">
		    <div class="toolbar-frame" id="divToolbar">
		    </div>
  		</div>
  </div>
  <input type="hidden" name="objectId" value="<%=XSSUtil.encodeForJavaScript(context,objectId)%>">
  <div id="divPageBody">
                <iframe src="<%=XSSUtil.encodeForJavaScript(context,contentURL)%>" name="objectHistoryFrame" id="objectHistoryFrame" height="100%" width="100%" frameborder="0" ></iframe>
     </div>

</html>
