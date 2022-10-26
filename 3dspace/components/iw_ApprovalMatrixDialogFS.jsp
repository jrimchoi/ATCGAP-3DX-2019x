<%--
  iw_ApprovalMatrixDialogFS.jsp

  Copyright (c) 2007 Integware, Inc.  All Rights Reserved.
  This program contains proprietary and trade secret information of
  Integware, Inc.
  Copyright notice is precautionary only and does not evidence any
  actual or intended publication of such program.

  $Rev: 658 $
  $Date: 2011-02-27 16:46:51 -0700 (Sun, 27 Feb 2011) $
--%>

<%@include file="../emxUIFramesetUtil.inc"%>
<%@include file="emxComponentsFramesetUtil.inc"%>
<%@page import="com.dassault_systemes.enovia.lsa.Helper"%>
<%@page import="com.matrixone.apps.domain.util.EnoviaResourceBundle"%>
<%@page import="com.matrixone.apps.domain.util.EnoviaResourceBundle"%>

<%

  final String BUNDLE = "LSACommonFrameworkStringResource";
  framesetObject fs = new framesetObject();

  fs.setDirectory(appDirectory);

  String initSource = emxGetParameter(request,"initSource");
  if (initSource == null){
    initSource = "";
  }
  String sObjectId       = emxGetParameter(request,"objectId");

  // Specify URL to come in middle of frameset
  String contentURL = "iw_ApprovalMatrixDialog.jsp";

  //Get all passed parameters and values and create a url parameter string
  StringBuffer sbURLParameters = new StringBuffer();
  Enumeration eNumParameters = emxGetParameterNames(request);
  while( eNumParameters.hasMoreElements() ) {
    String strParamName = (String)eNumParameters.nextElement();
    String strParamValue = emxGetParameter( request,  strParamName);
    sbURLParameters.append("&" + strParamName + "=" + strParamValue);
  }
  sbURLParameters.deleteCharAt(0);

  // add these parameters to each content URL
  contentURL += "?" + sbURLParameters + "&initSource=" + initSource ;

  // Page Heading
  String Header = "";
  String PageHeading = emxGetParameter(request,"heading");
  String suiteKey = emxGetParameter(request, "suiteKey");
  String frmLanguage = request.getHeader("Accept-Language");
  if (PageHeading==null || PageHeading.trim().length()==0)
  {
    DomainObject thisObj = new DomainObject(sObjectId);
    String thisObjName = thisObj.getInfo(context, thisObj.SELECT_NAME);
    Header = Helper.getI18NString(context,Helper.StringResource.LSA,"emxFramework.ApprovalMatrix.selectApprovers")+ thisObjName;
  }
  else
  {
  	//Changed this because it is also being translated in with fs.initFrameset. Fix for japanese. 
    //Header = UIForm.getFormHeaderString(context, pageContext, PageHeading, sObjectId, suiteKey, frmLanguage);
    Header = PageHeading;
  }

  // Marker to pass into Help Pages
  // icon launches new window with help frameset inside
  String HelpMarker = "LA24";
  String stringResourceFile = "";
  try {

	  stringResourceFile = EnoviaResourceBundle.getProperty(context, suiteKey + ".StringResourceFileId");
  	if(stringResourceFile == null || stringResourceFile.equals("")) {
  		stringResourceFile = "LSACommonFrameworkStringResource";
  	}
  }catch(Exception e) {
  	stringResourceFile = "LSACommonFrameworkStringResource";
  }
  
  fs.initFrameset(Header,
                  HelpMarker,
                  contentURL,
                  false,
                  true,
                  false,
                  false);


  fs.setDirectory("lsacommonframework");
  
  fs.setStringResourceFile("LSACommonFrameworkStringResource");

  /* 04/2006 Approval Matrix People Chooser start:  Just added parameter to 'submitForm' JS function */
  fs.createFooterLink("emxFramework.Lifecycle.Done",
                      "submitForm('"+context.getUser()+"')",
                      "role_GlobalUser",
                      false,
                      true,
                      "emxUIButtonDone.gif",
                      0);
   /* 04/2006 Approval Matrix People Chooser end */

  fs.createFooterLink("emxFramework.Lifecycle.Cancel",
                      "parent.window.close()",
                      "role_GlobalUser",
                      false,
                      true,
                      "emxUIButtonCancel.gif",
                      0);


  // ----------------- Do Not Edit Below ------------------------------

  fs.writePage(out);
%>
