<%-- gapSelectDocumentSignersDialog.jsp - This JSP displays the signers dialog page for selection.
	@author 	 : Mayuri sangde (ENGMASA)
	@date   	 : 08-Apr-2019
	@description : This page displays document signers for selection
--%>
<%@page import="com.matrixone.apps.common.RouteTemplate"%>
<%@page import="matrix.util.StringList"%>
<%@include file = "../emxUIFramesetUtil.inc"%>
<%@page import="com.matrixone.apps.framework.ui.*"%>
<%@page import="matrix.db.JPO"%>
<%@page import="com.matrixone.apps.domain.util.*"%>
<%@page import="java.util.*"%>
<%@page import="com.matrixone.apps.domain.DomainObject"%>
<jsp:useBean id="formBean" scope="session" class="com.matrixone.apps.common.util.FormBean"/>
<%!
	//public static 
%>
<%
String keyValue=emxGetParameter(request,"keyValue");
if(keyValue == null){
    keyValue = formBean.newFormKey(session);
}
formBean.processForm(session,request,"keyValue");
formBean.setElementValue("toAccessPage","");

session.removeAttribute("mpRTTaskUsers");
session.removeAttribute("taskDisplayMap");
session.removeAttribute("GAP_ERROR");


String strErr = null;
Boolean bSameDocuments = true;
String strUserGrp = (String) emxGetParameter(request, "UserGrp");
String strFirstTime = "true";

String strCurrentSelection = DomainObject.EMPTY_STRING;
Map	 mpTaskDisplay    = (Map)session.getAttribute("taskDisplayMap");
  String suiteKey    =  (String) emxGetParameter(request, "suiteKey");
  String strObjectId    =  (String) emxGetParameter(request, "objectId");
  String strChangeLocation    =  (String) emxGetParameter(request, "ChangeLocation");
  if (UIUtil.isNullOrEmpty(strUserGrp))
  {
  	HashMap programMp = new HashMap();		
  	programMp.put("objectId", strObjectId);
      
      String[] strArgs1  = JPO.packArgs(programMp);
      
      strUserGrp = (String) JPO.invoke(context, "gapRTWorkspace", null, "getCAUserLocation", strArgs1, String.class);
  }

		//	System.out.println("appDirectory ::: "+appDirectory);
  framesetObject fs = new framesetObject();
  MapList mlResultList = new MapList();
   // if not chnage in location
	if (UIUtil.isNotNullAndNotEmpty(strObjectId) && UIUtil.isNullOrEmpty(strChangeLocation))
	{
		// get affected Items connected to CA
		HashMap programMap = new HashMap();		
		programMap.put("objectId", strObjectId);
	    
	    String[] strArgs  = JPO.packArgs(programMap);
	   
		try {
			//System.out.println("calling doc ");
		    Map mpDocMap = (Map)  JPO.invoke(context, "gapRTWorkspace", null, "getDocumentCodeAndRevision", strArgs, Map.class);
		    //System.out.println("mpDocMap : "+mpDocMap);
		    bSameDocuments = (Boolean) mpDocMap.get("DOC_CODE_MATCH");
		    if (bSameDocuments){
				String strDocumentCode = (String) mpDocMap.get("gapDocCode");
				String strDocRev = (String) mpDocMap.get("gapDocRev");
				// get matching RT
				programMap = new HashMap();		
				programMap.put("objectId", strObjectId);
				programMap.put("gapDocCode", strDocumentCode);
				programMap.put("gapDocRev", strDocRev);
			    String[] strArgs1  = JPO.packArgs(programMap);
			    Map mpRTMap = (Map)  JPO.invoke(context, "gapRTWorkspace", null, "getMatchingRouteTemplate", strArgs1, Map.class);
			    //System.out.println("returnmpRTMap????????????? :"+mpRTMap);
			    if (mpRTMap==null || mpRTMap.isEmpty())
			    {//System.out.println("return?????????????");
			    strErr = "Route Template does not exists for document code : "+strDocumentCode+". Please contact your system admin.";
			    session.setAttribute("GAP_ERROR",strErr);
			    	
			    }
			    else{
			    	String strRTId = (String) mpRTMap.get(DomainObject.SELECT_ID);
			    	String strRTName = (String) mpRTMap.get(DomainObject.SELECT_NAME);
				// get task list for display 
					programMap = new HashMap();		
					programMap.put("routeTemplateId", strRTId);
					programMap.put("routeTemplateName", strRTName);
				    String[] strArgs2  = JPO.packArgs(programMap);
				    mpTaskDisplay    = (Map) JPO.invoke(context, "gapRTWorkspace", null, "getTaskListForDisplay", strArgs2, Map.class);
				   // System.out.println("mpTaskDisplay : "+mpTaskDisplay);
				    session.setAttribute("mpRTTaskUsers", mpTaskDisplay);
			}
		    }
		    else
		    {
		    	strErr = (String)mpDocMap.get("ERROR_MSG");
		    	//strErr = "Please select Documents with same document code!!";
		    	session.setAttribute("GAP_ERROR",strErr);
		    }
		}catch (Exception exJPO) {
			exJPO.printStackTrace();
		   throw (new FrameworkException(exJPO.toString()));
		}
	}
   // if location changed
   else {
	   strCurrentSelection = (String) emxGetParameter(request, "currentSelection");
	   if (UIUtil.isNotNullAndNotEmpty(strCurrentSelection))
	   {
		   // update display map with selections
		   Map mpCurrentRTMap = (Map) session.getAttribute("mpRTTaskUsers");
		   
		   Map programMap = new HashMap();		
			programMap.put("mpCurrentRTMap", mpCurrentRTMap);
			programMap.put("currentSelection", strCurrentSelection);
		    String[] strArgs1  = JPO.packArgs(programMap);
		    Map mpUpdatedRTMap    = (Map) JPO.invoke(context, "gapRTWorkspace", null, "updateSelectedAssignees", strArgs1, Map.class);
		  
		   session.setAttribute("mpRTTaskUsers", mpUpdatedRTMap);
	   }
   }

  // Specify URL to come in middle of frameset
    StringBuffer contentURL = new StringBuffer();
    contentURL.append("gapSelectDocumentSignersDialog.jsp");
    contentURL.append("?objectId=");
    contentURL.append(strObjectId);
    contentURL.append("&suiteKey=");
    contentURL.append(suiteKey);
    contentURL.append("&UserGrp=").append(strUserGrp).append("&ChangeLocation=").append(strChangeLocation).append("&currentSelection=").append(strCurrentSelection);
   
	//contentURL.append("&taskDisplayMap=").append(mpTaskDisplay.);
    fs.setStringResourceFile("emxEngineeringCentralStringResource");
    // Page Heading - Internationalized
    String PageHeading = "Select signers";
    // Marker to pass into Help Pages
    // icon launches new window with help frameset inside
    String HelpMarker= "";
    fs.initFrameset(PageHeading,HelpMarker,contentURL.toString(),false,true,true,false);

   fs.createCommonLink("emxEngineeringCentral.Button.Save",
                      "submitForm()",
                      "role_GlobalUser",
                      false,
                      true,
                      "common/images/buttonDialogNext.gif",
                      false,
                      3);

   fs.createCommonLink("emxEngineeringCentral.Button.Cancel",
                      "closeWindow()",
                      "role_GlobalUser",
                      false,
                      true,
                      "common/images/buttonDialogCancel.gif",
                      false,
                      3);
    fs.removeDialogWarning();
    fs.writePage(out);
%>
<script type="text/javascript">
//var vbSameDocuments = <%=bSameDocuments%>
//if (vbSameDocuments == false || vbSameDocuments=="false")
//	alert("Please select Documents with same document code!!");
</script>
