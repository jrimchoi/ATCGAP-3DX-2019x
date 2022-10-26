<%--  iw_emxRouteStart.jsp  --  Promote Route Object
  Copyright (c) 1992-2018 Dassault Systemes.
  All Rights Reserved.
  This program contains proprietary and trade secret information of MatrixOne,Inc.
  Copyright notice is precautionary only and does not evidence any actual or intended publication of such program

  static const char RCSID[] = $Id: iw_emxRouteStart.jsp.rca 1.22 Wed Oct 22 16:17:57 2008 przemek Experimental przemek $
 --%>

<%@include file = "../emxUICommonAppInclude.inc"%>
<%@include file = "emxRouteInclude.inc"%>
<%@page import="com.dassault_systemes.enovia.lsa.Helper, com.matrixone.apps.domain.util.XSSUtil"%>
<%@include file = "../common/enoviaCSRFTokenValidation.inc"%>
<% 
  Route boRoute = (Route)DomainObject.newInstance(context,DomainConstants.TYPE_ROUTE);
  DomainObject route = DomainObject.newInstance(context);

  // for push subscription if route started from Route Properties page
  String fromPage         = emxGetParameter(request, "fromPage");

  String attrDueDateOffset      = PropertyUtil.getSchemaProperty(context, "attribute_DueDateOffset");
  String attrDueDateOffsetFrom  = PropertyUtil.getSchemaProperty(context, "attribute_DateOffsetFrom");
  String attrAssigneeDueDate    = PropertyUtil.getSchemaProperty(context, "attribute_AssigneeSetDueDate");
  
  String OFFSET_FROM_ROUTE_START_DATE  = "Route Start Date";
  String OFFSET_FROM_TASK_CREATE_DATE  = "Task Create Date";

  String dateAlertMsg = Helper.getI18NString(context,Helper.StringResource.CBS,"emxComponents.RouteDetails.AssigneeDueDateAlert");
  String taskAlertMsg = Helper.getI18NString(context,Helper.StringResource.CBS,"emxComponents.RouteDetails.TaskAttrMessage");
  String memberAlertMsg = Helper.getI18NString(context,Helper.StringResource.CBS,"emxComponents.Routes.PersonMessage");
  
  String selDueDateOffset       = "attribute["+attrDueDateOffset+"]";;
  String selDueDateOffsetFrom   = "attribute["+attrDueDateOffsetFrom+"]";
  String selAssigneeDueDate     = "attribute["+attrAssigneeDueDate+"]";
  String selRouteNodeRelId      = DomainObject.SELECT_RELATIONSHIP_ID;
  String selSequence            = "attribute["+DomainObject.ATTRIBUTE_ROUTE_SEQUENCE+"]";
  StringBuffer sWhereExp              = new StringBuffer(100);
  boolean bIsRouteStartable = true;
  boolean bHasMembers = true;
  boolean bDateEmpty = false;
  boolean bOrderFlag = false;

  StringList relSelects = new StringList();
  String routeId = "";
  
  // Get route Id's from table or details page.
  String[] routeIds = emxGetParameterValues(request, "chkItem");
  if (routeIds == null)
  {
    routeIds = ComponentsUIUtil.getSplitTableRowIds(request.getParameterValues("emxTableRowId"));
  }
  
  if (routeIds.length == 0)
  {
     routeId = emxGetParameter(request, "routeId");
     routeIds = new String[1];
     routeIds[0] = routeId;
  }
  
  for(int count=0; count < routeIds.length; count++)
  {
    boRoute.setId(routeIds[count]);
    route.setId(routeIds[count]);
  
    relSelects.addElement(selDueDateOffset);
    relSelects.addElement(selDueDateOffsetFrom);
    relSelects.addElement(selRouteNodeRelId);
    relSelects.addElement(selSequence);
    relSelects.addElement(selAssigneeDueDate);
    relSelects.addElement(boRoute.SELECT_TITLE);
    relSelects.addElement(boRoute.SELECT_SCHEDULED_COMPLETION_DATE);
    relSelects.addElement(selSequence);
  
    MapList ml = boRoute.getRouteMembers(context, new StringList(), relSelects, false);
  
    if (ml.size() == 0)
    {
      bHasMembers = false;
      break;
    }
    else
    {
      Iterator memberItr = ml.iterator();
      while(memberItr.hasNext())
      {
        Map memberMap = (Map)memberItr.next();
        if (memberMap != null)
        {
          String strOrder = (String)memberMap.get(selSequence);
          String strScheduledCompletionDate = (String)memberMap.get(boRoute.SELECT_SCHEDULED_COMPLETION_DATE);
          String strDueDateOffset = (String)memberMap.get(selDueDateOffset);
          String strAssigneeSetDueDate = (String)memberMap.get(selAssigneeDueDate);
          
          if ((strOrder  == null) || ("".equals(strOrder)))
          {
              bOrderFlag = true;
              break;
          }
          
          if ((strScheduledCompletionDate.equals(""))  &&
              (strDueDateOffset.equals(""))            &&
              (strAssigneeSetDueDate.equals("No")))
          {
              bDateEmpty = true;
              break;
          }
        }
      }
    }
  }
  
  if (!bHasMembers)
  {
      bIsRouteStartable = false;
%>
<script type="text/javascript">
      alert ("<%=XSSUtil.encodeForJavaScript(context, memberAlertMsg)%>");
</script>
<%      
  }
  else if (bDateEmpty)
  {
      bIsRouteStartable = false;
%>
<!--
<script type="text/javascript">
      alert ("<%=XSSUtil.encodeForJavaScript(context, dateAlertMsg)%>");
</script>
-->
<%
  }
  else if (bOrderFlag)
  {
      bIsRouteStartable = false;
%>
<script type="text/javascript">
      alert ("<%=XSSUtil.encodeForJavaScript(context, taskAlertMsg)%>");
</script>
<%
  }
  
  if (bIsRouteStartable)
  {
    for(int count=0; count < routeIds.length; count++)
    {

      boRoute.setId(routeIds[count]);
      route.setId(routeIds[count]);      

      String sAttrRestartUponTaskRejection = PropertyUtil.getSchemaProperty(context, "attribute_RestartUponTaskRejection" );
      StringList boSelectList = new StringList(2);
      boSelectList.addElement(boRoute.SELECT_ROUTE_STATUS);
      boSelectList.addElement(boRoute.getAttributeSelect(sAttrRestartUponTaskRejection));
      Map routeInfo = boRoute.getInfo(context, boSelectList);
      String routeStatus  = (String)routeInfo.get(boRoute.SELECT_ROUTE_STATUS);
      String routeRestartOnTaskReject = (String)routeInfo.get(boRoute.getAttributeSelect(sAttrRestartUponTaskRejection));
      if ((fromPage != null) && (!fromPage.equals("routeProperties")))
      {
        //set the RPE Variable
        if("Not Started".equals(routeStatus) || "Stopped".equals(routeStatus))
        {
          String treeMenu = JSPUtil.getApplicationProperty(context,application,"eServiceComponents.treeMenu.InboxTask");
          if(treeMenu != null && !"".equals(treeMenu))
          {
            MQLCommand mql = new MQLCommand();
            mql.open(context);
            mql.executeCommand(context, "set env global $1 $2","MX_TREE_MENU" ,treeMenu);
    
            mql.close(context);
          }
        }
      }

       try
       {
          if("Not Started".equals(routeStatus))
          {
            boRoute.open(context);
            // where clause filters to all route tasks with due offset from this Route Start

            sWhereExp.setLength(0);
            sWhereExp.append("("+selDueDateOffset+ " !~~ \"\")");
            //sWhereExp.append(" && (" +selDueDateOffsetFrom + " ~~ \""+OFFSET_FROM_TASK_CREATE_DATE+"\")");
            //sWhereExp.append( " || ("+selDueDateOffset+ " !~~ \"\")");
            sWhereExp.append( " && (" +selDueDateOffsetFrom + " ~~ \""+OFFSET_FROM_ROUTE_START_DATE+"\")");
            sWhereExp.append(" || ("+selSequence + " == \"1\")");

            MapList routeFirstOrderOffsetList = Route.getFirstOrderOffsetTasks(context, route, relSelects, sWhereExp.toString());
            // set Scheduled Due Date attribute for all delta offset ORDER 1 Route Nodes offset From Task create which is same as Route start
		   //End for Bug 339313

            Route.setDueDatesFromOffset(context, session, routeFirstOrderOffsetList);
      
            boRoute.promote(context);

            // for Push Subscription
            //SubscriptionManager subscriptionMgr = boRoute.getSubscriptionManager();
            // try
            // {
            //  subscriptionMgr.publishEvent(context, boRoute.EVENT_ROUTE_STARTED, routeIds[count]);
            //}catch(Exception ex1){}
          
            boRoute.close(context);
          }
          else if("Stopped".equals(routeStatus))
          {
              // Bug 347265 : Modified code to implement complete restart of the route (using Resume Process in Route Enhancements)
              // in case route is stopped due to rejection and restart on task reject is true.
              // Initially this was not checked because there was no other reason why route was stopped. Now the route can be stopped 
              // manually.
              boolean isNormalResumeReqd = false;
              if (Route.isRouteStoppedDueToRejection(context, routeIds[count])) {
                  // This route should be restarted
                  boRoute.resume(context);
              }
              else {
				  // This route can be resumed
              MQLCommand command = new MQLCommand();
              command.open(context);
              command.executeCommand(context,"execute program $1 $2","eServicecommonResumeRoute.tcl",routeIds[count]);
              command.close(context);
            }
			boRoute.sendNotificationToTaskAssignees(context, "Resumed");//send Notification To Task Assignees
          }
          InboxTask.setTaskTitle(context, routeIds[count]);
       }
       catch (Exception ex )
       {
%>
        <%@include file = "emxMQLNotice.inc" %>
<%
        session.putValue("error.message", Helper.getI18NString(context,Helper.StringResource.CBS,"emxComponents.MyRouteSummary.ErrorMessage"));

       }
    }
  }
  %>
<html>
<body>
<script language="javascript">
  parent.location.href = parent.location.href;
</script>
</body>
</html>
