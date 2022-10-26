<%--ECHPropagateApplicabilityProcess.jsp
  Copyright (c) 2007-2008 MatrixOne, Inc.
  All Rights Reserved.
  This program contains proprietary and trade secret information of MatrixOne,
  Inc.  Copyright notice is precautionary only
  and does not evidence any actual or intended publication of such program
  static const char RCSID[] = "$Id: /web/enterprisechange/ECHPropagateApplicabilityProcess.jsp 1.2 Tue Dec 23 21:37:15 2008 GMT dmcelhinney Experimental$";
  --%>


<%@page import="com.matrixone.apps.domain.DomainObject"%>
<%@page import="com.matrixone.apps.domain.DomainConstants"%>
<%@page import="matrix.util.StringList"%>
<%@page import="com.matrixone.apps.enterprisechange.EnterpriseChangeConstants"%>
<%@page import="com.matrixone.apps.domain.util.MapList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.matrixone.apps.domain.util.XSSUtil"%>

<%@page import="com.matrixone.apps.domain.util.EnoviaResourceBundle"%>
<html>
	<head>
		<title>
		</title>

		<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
		<%@include file = "../emxUICommonAppInclude.inc"%>
<script language="Javascript" src="../common/scripts/emxUIConstants.js"></script>
<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICore.js"></script>
<script language="Javascript" src="../common/scripts/emxUIModal.js"></script>
	</head>

	<body>
		<%
		String errorMsg = "";
		Map mapErrorMsg = new HashMap();
		StringList slNoPropagateOjects = new StringList();
		StringList slPropagateOjects = new StringList();
		String suiteKey = emxGetParameter(request,"suiteKey");
		String strLanguage = request.getHeader("Accept-Language");
		try{
						
			String changeTaskId = emxGetParameter(request,"objectId");
			DomainObject domObjID = new DomainObject(changeTaskId);
			String strType = domObjID.getInfo(context,DomainConstants.SELECT_TYPE);
			
			Map mapObjectID = new HashMap();
			String[] init = new String[] {}; 
            HashMap paramMap = new HashMap();
			//added to fix IR-188077V6R2014
			if(!mxType.isOfParentType(context,strType,EnterpriseChangeConstants.TYPE_DECISION)){

			StringList slchangeTaskId = new StringList();
			slchangeTaskId.add(changeTaskId);
			mapObjectID.put("slobjectId",slchangeTaskId);
			paramMap.put("objectId", mapObjectID);
			}
								
			String[] methodargs = JPO.packArgs(paramMap);
			Boolean bPropagate = true;
			MapList changeTaskList = null;
			MapList mlErrorMsg = new MapList();
	        String strErrMsg = "";
	        boolean bException = false;
	         
	         String SELECT_CHANGE_TASK = "from["+EnterpriseChangeConstants.RELATIONSHIP_DECISION_APPLIES_TO + "].to.id";
	         
	         try{
	        	 context.start(true);
	       //added to fix IR-188077V6R2014
	         if(mxType.isOfParentType(context,strType,EnterpriseChangeConstants.TYPE_DECISION)){
	        	 paramMap.put("objectId", changeTaskId);
	        	 JPO.invoke(context, "emxApplicabilityDecision", init, "promoteDecisiontoReleaseState", methodargs, String.class);
	         }
	         

				 mlErrorMsg = (MapList)JPO.invoke(context, "emxApplicabilityDecision", init, "propagateApplicabilityForOpenness", methodargs, MapList.class);
				
				context.commit();
	         }
	         catch(Exception ex){
	        	 context.abort();
	        	 bPropagate = false;
	        	 bException = true;
			}
	         
			MapList mlResultrMsg = new MapList();
			if(mlErrorMsg.size() != 0 ){
			for(Iterator iterator = mlErrorMsg.iterator(); iterator.hasNext();){
					mapErrorMsg = (Map)iterator.next();
				    boolean isPropagationAllowed = (Boolean)mapErrorMsg.get("isPropagationAllowed");
				    strErrMsg = (String)mapErrorMsg.get("strErrMsg");
				    if(!isPropagationAllowed){
				    	bPropagate = false;   
				    }
				}
			}
			
			 StringList slchangeTaskId = new StringList();
			//added to fix IR-188077V6R2014
			 if(mxType.isOfParentType(context,strType,EnterpriseChangeConstants.TYPE_DECISION)){
			 StringList selectStmts = new StringList(DomainConstants.SELECT_ID);
             String RANGE_YES = EnoviaResourceBundle.getProperty(context,"Framework","emxFramework.Range.Track_Applicability.Yes","en");
             String whereclause = "(attribute[" + EnterpriseChangeConstants.ATTRIBUTE_APPLICABILITY_PROPAGATED + "]" + "== \"" + RANGE_YES + "\")" ;
             changeTaskList = domObjID.getRelatedObjects(context,
                     EnterpriseChangeConstants.RELATIONSHIP_DECISION_APPLIES_TO,   // relationship pattern
                     EnterpriseChangeConstants.TYPE_CHANGE_TASK,                   // object pattern
                     selectStmts,                        // object selects
                     null,                               // relationship selects
                     false,                              // to direction
                     true,                               // from direction
                     (short) 1,                          // recursion level
                     whereclause,                               // object where clause
                     null,                              // relationship where clause
                     0);
             
             DomainObject domTemp = null ;
             for(Iterator iterator = changeTaskList.iterator(); iterator.hasNext();){
                 Map map = (Map) iterator.next();
                 changeTaskId = (String)map.get(DomainConstants.SELECT_ID);
                 domTemp = new DomainObject(changeTaskId);
                 slchangeTaskId.add(changeTaskId);
			 }
             changeTaskId = slchangeTaskId.toString();
             
            
             StringList selectStmts1 = new StringList(1);
             selectStmts1.addElement(DomainConstants.SELECT_ID);
             selectStmts1.addElement(DomainConstants.SELECT_NAME);
             selectStmts1.addElement(DomainConstants.SELECT_CURRENT);
             String strDeliverableTypes = EnterpriseChangeConstants.TYPE_ENGINEERING_CHANGE;
             MapList mapList = domTemp.getRelatedObjects(context, EnterpriseChangeConstants.RELATIONSHIP_TASK_DELIVERABLE, strDeliverableTypes,
            		 selectStmts1, null, false, true, (short)1, null, null, 0);
             
             if(!mapList.isEmpty()){
                 for(Iterator iterator = mapList.iterator(); iterator.hasNext();){
                     Map map = (Map) iterator.next();
                    String changeId = (String)map.get(DomainConstants.SELECT_ID);

                     DomainObject changeObj = DomainObject.newInstance(context, changeId);
                     String strChangeObjectType = changeObj.getInfo(context, DomainConstants.SELECT_TYPE);
                     String changeObjectName = changeObj.getInfo(context, DomainConstants.SELECT_NAME);
                     String changeState = (String)map.get(DomainConstants.SELECT_CURRENT);
                     
	                     if(!bException && (changeState.equals(EnterpriseChangeConstants.STATE_ENGINEERING_CHANGE_SUBMIT) || changeState.equals(EnterpriseChangeConstants.STATE_ENGINEERING_CHANGE_EVALUATE))){
                    	 bPropagate = true;
                     }else{
                    	 bPropagate = false;
                     }
                 }
             }
			 }
			 else{
				 slchangeTaskId.add(changeTaskId);
				 changeTaskId = slchangeTaskId.toString(); 
			 }
			
              String headerMessage ="";
            if((null == strErrMsg || "null".equals(strErrMsg) || "".equals(strErrMsg)) && bPropagate){ 
             	headerMessage = "emxEnterpriseChange.Report.PropagationSuccessfull";
            }else{
            	headerMessage = "emxEnterpriseChange.Report.PropagationFailure";
            	bException = true;
            }
             
			 
			%>
			 <script language="javascript" type="text/javaScript">
			
			   var vURL = "../common/emxIndentedTable.jsp?program=emxApplicabilityDecision:propagateApplicabilityReportDisplay&suiteKey=<%=XSSUtil.encodeForURL(context,suiteKey)%>&header=<%=XSSUtil.encodeForURL(context,headerMessage)%>&table=PropagateApplicabilityTable&editLink=false&PrinterFriendly=false&multiColumnSort=false&Export=false&customize=false&changeTaskIds=<%=XSSUtil.encodeForURL(context,changeTaskId)%>&bPropagate=<%=XSSUtil.encodeForJavaScript(context,String.valueOf(bPropagate))%>&bException=<%=XSSUtil.encodeForJavaScript(context,String.valueOf(bException))%>&cancelLabel=emxFramework.Common.Close";
	             getTopWindow().showModalDialog(vURL,0,0,"true","Medium");
	             <%
	             if(mxType.isOfParentType(context,strType,EnterpriseChangeConstants.TYPE_DECISION)){
	            	%>
	            	var parentContentFrame = findFrame(parent, "content");
	            	parentContentFrame.location.href = parentContentFrame.location.href;
	            	<%
	             }else{
	             %>
	             parent.location.href = parent.location.href ;
	             <%
	             }
	             %>
	             
              </script>
			<%
			//}
		}catch(Exception e){
			e.printStackTrace();
			session.putValue("error.message",e.getMessage());
		}
		%>

		<%@include file = "../components/emxComponentsVisiblePageInclude.inc"%>
		
	</body>
</html>
