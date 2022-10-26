<%--  emxInfoObjectCheckAccesses.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--emxInfoObjectCheckAccesses.jsp : This jsp checks user accesses at object level.

  $Archive: $
  $Revision: 1.3.1.4$
  $Author: ds-hbhatia$

--%>


<html>
<title>Access Check</title>
<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css">
<body>
<%@ page import="com.matrixone.MCADIntegration.server.MCADServerResourceBundle, com.matrixone.MCADIntegration.server.beans.MCADIntegrationSessionData, com.matrixone.MCADIntegration.server.beans.MCADMxUtil, com.matrixone.MCADIntegration.server.MCADServerSettings, com.matrixone.MCADIntegration.utils.MCADGlobalConfigObject"  %>
<%@include file="emxInfoCentralUtils.inc" %>


<%

 String sActionMap = (String) emxGetParameter(request, "action"); 
 String sAccessMap = (String) emxGetParameter(request, "access"); 
 String sActionPage = (String) emxGetParameter(request, "actionURL");
 String sActionURL = sActionPage;
 String sTargetLocation = (String) emxGetParameter(request, "targetLocation");
 String sBusObjId = (String)emxGetParameter(request, "parentOID");
 String sActionBarName = emxGetParameter(request, "topActionbar");
 String sMsgKey = "";
 String sErrorMsg = "";
  boolean hasAccess = true;
 if(sBusObjId == null ||"null".equals(sBusObjId))
 {
   sBusObjId = (String) emxGetParameter(request, "objectId");
 }
 if(sBusObjId!=null) sBusObjId=sBusObjId.trim();
 
 if(sActionURL != null && !sActionURL.equals("null"))
 {
		request.setAttribute("parentOID", sBusObjId);
		request.setAttribute("topActionbar", sActionBarName);
 }

  String objType = "";
  BusinessObject bObj = new BusinessObject(sBusObjId);
  bObj.open(context);
  objType = bObj.getTypeName();
  bObj.close(context); 

 if (sAccessMap != null && sAccessMap.trim().length() > 0)
 {
	  String acceptLanguage	= request.getHeader("Accept-Language");
	  MCADServerResourceBundle resourceBundle = new MCADServerResourceBundle(acceptLanguage);
	  
	  MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute(MCADServerSettings.MCAD_INTEGRATION_SESSION_DATA_OBJECT);    
	  MCADMxUtil util = new MCADMxUtil(context, integSessionData.getLogger(), resourceBundle, integSessionData.getGlobalCache());
	  String integrationName = util.getIntegrationName(context, sBusObjId);
	  MCADGlobalConfigObject globalConfigObject = integSessionData.getGlobalConfigObject(integrationName,context);
	  
      try{
		  StringTokenizer tokenAccess = new StringTokenizer(sAccessMap, ",");
		  StringList listAccessMap = null;      
		  while (tokenAccess.hasMoreTokens())
		  {
			  listAccessMap = new StringList();
			  String strAccess =tokenAccess.nextToken().trim();
			  listAccessMap.addElement(strAccess);
			
			  boolean isReviseAction = false;
			  if(sActionMap != null && sActionMap.trim().length() > 0){
				   String[] valArr = sActionMap.trim().split(",");
				   for(int i=0;i < valArr.length;i++){
					   if("Revise".equals(valArr[i])){
						   isReviseAction = true;
						   break;
					   }
				   }
			   }
			  if(isReviseAction && globalConfigObject.isFeatureForTypeRestricted(objType ,strAccess)){							
					
					Hashtable errorDetails = new Hashtable(1);
					errorDetails.put("TYPE_NAME", objType);
					
					//Handling Revise Acess
					if(strAccess.equals("Revise")){					
						sErrorMsg = resourceBundle.getString("mcadIntegration.Server.Message.ReviseNotValidForRestrictedType",errorDetails);
					}else{
						sErrorMsg = resourceBundle.getString("mcadIntegration.Server.Message.InvalidTypeForOperation",errorDetails);
					}
				hasAccess = false;
					break;
			  }else{
			  hasAccess = FrameworkUtil.hasAccess(context,bObj,listAccessMap);          
			  //Error message based on NoAccess key
			  if(!hasAccess){
			  sMsgKey = "emxIEFDesignCenter.Common.No" + strAccess;
			  sErrorMsg += i18nStringNow(sMsgKey, request.getHeader("Accept-Language")) + ", ";
			  }
			  else{
					break;
			  }
		  }
		  }
		  if(!("".equals(sErrorMsg))){
			sErrorMsg = sErrorMsg.trim();
			//sErrorMsg = sErrorMsg.substring(0,sErrorMsg.length() - 1);
			sErrorMsg=sErrorMsg.replace('\n',' ');
			sErrorMsg=sErrorMsg.replace('\r',' ');
		  }
      }catch(Exception e){        
      	//System.out.println("Exception in emxInfoObjectCheckAccesses.jsp ="+e.getMessage());
      }
 }
 if(hasAccess)
  {  	
%>
    <!--XSSOK CAUSED REG-->
    <jsp:forward page="<%=sActionURL%>" />
<%    	
  }
  else
  {
%>
       <script>
	   //XSSOK
       alert("<%=sErrorMsg%>");     
		parent.window.close(); //close the pop up window
       </script>
<%
  } 	
  	 
%>
</body>
</html>
