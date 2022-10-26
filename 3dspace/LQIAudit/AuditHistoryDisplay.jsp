<%--
   Copyright (c) 2014-2018 Dassault Systemes.
   All Rights Reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes,Inc.
   Copyright notice is precautionary only and does not evidence any
   actual or intended publication of such program

   $Rev: 296 $
   $Date: 2008-02-05 07:39:05 -0700 (Tue, 05 Feb 2008) $
--%>

<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<%@page import="com.matrixone.apps.domain.*, com.matrixone.apps.domain.util.*"%>
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
String sTypeAuditReply = PropertyUtil.getSchemaProperty("type_AuditReply");
String sTypeAuditFindingActionTask = PropertyUtil.getSchemaProperty("type_AuditFindingActionTask");
String sRelationshipAuditRequest = PropertyUtil.getSchemaProperty("relationship_AuditRequest");
String sRelationshipAuditRequestReply = PropertyUtil.getSchemaProperty("relationship_AuditRequestReply");
String sRelationshipAuditFinding = PropertyUtil.getSchemaProperty("relationship_AuditFinding");
String sRelationshipAuditReportSummary = PropertyUtil.getSchemaProperty("relationship_AuditReportSummary");
String sRelationshipAuditAction = PropertyUtil.getSchemaProperty("relationship_ActionItem");
String sAttributeTitle = PropertyUtil.getSchemaProperty("attribute_Title");
String sAttributeActionItemName = PropertyUtil.getSchemaProperty("attribute_ActionItemName");

String objectId = emxGetParameter(request, "objectId");

String sNone = Helper.getI18NString(context,Helper.StringResource.AUDIT,"LQIAudit.Common.None");

DomainObject passedObj = DomainObject.newInstance(context, objectId);
String AuditNumber = passedObj.getInfo(context, DomainConstants.SELECT_NAME);

Enumeration en = request.getParameterNames();
String urlParams = "";
int count = 0;
while (en.hasMoreElements())
{
    String name  = (String) en.nextElement();
    String value = request.getParameter(name);

    if (count == 0)
        urlParams += "?";
    else
        urlParams += "&";

    urlParams += name + "=" + value;
    count++;
}
%>
<h3><%=XSSUtil.encodeForJavaScript(context,AuditNumber)%> <%=/*XSS OK*/getEncodedI18String(context,"LQIAudit.Command.History")%></h3>
<jsp:include page = "AuditHistorySummary.jsp" flush="true">
    <jsp:param name="objectId" value="<%=XSSUtil.encodeForJavaScript(context,objectId)%>"/>
</jsp:include>

<%
StringList objSelects = new StringList(); // object selects
  objSelects.addElement(DomainConstants.SELECT_ID);
  objSelects.addElement(DomainConstants.SELECT_NAME);
  objSelects.addElement(DomainConstants.SELECT_TYPE);// used for filter the useless type
  objSelects.addElement("attribute[" + sAttributeTitle + "]");
  objSelects.addElement("attribute[" + sAttributeActionItemName + "]");
StringList relSelects = new StringList(); // relationship selects
  relSelects.addElement(DomainConstants.SELECT_RELATIONSHIP_ID);
%>

<hr>
<h3><%=/*XSS OK*/getEncodedI18String(context,"LQIAudit.Header.AuditRequestHistory")%>
<%
// include the history for the Audit Request
MapList relList1 = passedObj.getRelatedObjects(context, sRelationshipAuditRequest, "*", objSelects, relSelects, false, true, (short) 1, "", "");

if (relList1.size() <= 0)
    out.write("<p>"+sNone+"</p>");

for (int i = 0; i < relList1.size(); i++) {
    String objId = ((String) ((Map) relList1.get(i)).get(DomainConstants.SELECT_ID)).trim();
    String objName = ((String) ((Map) relList1.get(i)).get(DomainConstants.SELECT_NAME)).trim();
    String title = ((String) ((Map) relList1.get(i)).get("attribute[" + sAttributeTitle + "]")).trim();
%>
<p><%=XSSUtil.encodeForJavaScript(context,objName)%>: <%=XSSUtil.encodeForJavaScript(context,title) %></p>
<jsp:include page = "AuditHistorySummary.jsp" flush="true">
    <jsp:param name="objectId" value="<%=XSSUtil.encodeForJavaScript(context,objId)%>"/>
</jsp:include>
<%
}
%>

<hr>
<h3><%=/*XSS OK*/getEncodedI18String(context,"LQIAudit.Header.AuditReplyHistory")%></h3>
<%
// include the history for the Audit Reply, specify the Type of Objects is Audit Reply
String rels = sRelationshipAuditRequest + "," + sRelationshipAuditRequestReply;
MapList relList2 = new MapList();
MapList temp2 = passedObj.getRelatedObjects(context, rels, "*", objSelects, relSelects, false, true, (short) 2, "", "");
for(int i=0;i<temp2.size();i++)
{
	if(((String)((Hashtable)temp2.get(i)).get(DomainConstants.SELECT_TYPE)).equals(sTypeAuditReply))
	{
		relList2.add(temp2.get(i));
	}
}
if (relList2.size() <= 0)
    out.write("<p>"+sNone+"</p>");

for (int i = 0; i < relList2.size(); i++) {
    String objId = ((String) ((Map) relList2.get(i)).get(DomainConstants.SELECT_ID)).trim();
    String objName = ((String) ((Map) relList2.get(i)).get(DomainConstants.SELECT_NAME)).trim();
    String title = ((String) ((Map) relList2.get(i)).get("attribute[" + sAttributeTitle + "]")).trim();
%>
<p><%=XSSUtil.encodeForJavaScript(context,objName)%>: <%=XSSUtil.encodeForJavaScript(context,title) %></p>
<jsp:include page = "AuditHistorySummary.jsp" flush="true">
    <jsp:param name="objectId" value="<%=XSSUtil.encodeForJavaScript(context,objId)%>"/>
</jsp:include>
<%
}
%>

<hr>
<h3><%=/*XSS OK*/getEncodedI18String(context,"LQIAudit.Header.AuditFindingHistory")%></h3>
<%
// include the history for the Audit Finding
MapList relList3 = passedObj.getRelatedObjects(context, sRelationshipAuditFinding, "*", objSelects, relSelects, false, true, (short) 1, "", "");

if (relList3.size() <= 0)
    out.write("<p>"+sNone+"</p>");

for (int i = 0; i < relList3.size(); i++) {
    String objId = ((String) ((Map) relList3.get(i)).get(DomainConstants.SELECT_ID)).trim();
    String objName = ((String) ((Map) relList3.get(i)).get(DomainConstants.SELECT_NAME)).trim();
    String title = ((String) ((Map) relList3.get(i)).get("attribute[" + sAttributeTitle + "]")).trim();
%>
<p><%= XSSUtil.encodeForJavaScript(context,objName) %>: <%= XSSUtil.encodeForJavaScript(context,title) %></p>
<jsp:include page = "AuditHistorySummary.jsp" flush="true">
    <jsp:param name="objectId" value="<%=XSSUtil.encodeForJavaScript(context,objId)%>"/>
</jsp:include>
<%
}
%>

<hr>
<h3><%=/*XSS OK*/getEncodedI18String(context,"LQIAudit.Header.AuditSummaryReportHistory")%></h3>
<%
// include the history for the Audit Summary Report
MapList relList4 = passedObj.getRelatedObjects(context, sRelationshipAuditReportSummary, "*", objSelects, relSelects, false, true, (short) 1, "", "");

if (relList4.size() <= 0)
    out.write("<p>"+sNone+"</p>");

for (int i = 0; i < relList4.size(); i++) {
    String objId = ((String) ((Map) relList4.get(i)).get(DomainConstants.SELECT_ID)).trim();
    String objName = ((String) ((Map) relList4.get(i)).get(DomainConstants.SELECT_NAME)).trim();
    String title = ((String) ((Map) relList4.get(i)).get("attribute[" + sAttributeTitle + "]")).trim();
%>
<p><%=XSSUtil.encodeForJavaScript(context,objName) %>: <%=XSSUtil.encodeForJavaScript(context,title) %></p>
<jsp:include page = "AuditHistorySummary.jsp" flush="true">
    <jsp:param name="objectId" value="<%=XSSUtil.encodeForJavaScript(context,objId)%>"/>
</jsp:include>
<%
}
%>

<hr>
<h3><%=/*XSS OK*/getEncodedI18String(context,"LQIAudit.Header.AuditActionTaskHistory")%></h3>
<%
// include the history for the Audit Action Task
MapList relList5 = passedObj.getRelatedObjects(context, sRelationshipAuditAction, "*", objSelects, relSelects, false, true, (short)1, "", "");

if (relList5.size() <= 0)
    out.write("<p>"+sNone+"</p>");

for (int i = 0; i < relList5.size(); i++) {
    String objId = ((String) ((Map) relList5.get(i)).get(DomainConstants.SELECT_ID)).trim();
    String objName = ((String) ((Map) relList5.get(i)).get(DomainConstants.SELECT_NAME)).trim();
    String actionItemName = ((String) ((Map) relList5.get(i)).get("attribute[" + sAttributeActionItemName + "]")).trim();
%>
<p><%= XSSUtil.encodeForJavaScript(context,actionItemName) %></p>
<jsp:include page = "AuditHistorySummary.jsp" flush="true">
    <jsp:param name="objectId" value="<%=XSSUtil.encodeForJavaScript(context,objId)%>"/>
</jsp:include>
<%
}
%>

<hr>
<h3><%=/*XSS OK*/getEncodedI18String(context,"LQIAudit.Header.AuditFindingActionTaskHistory")%></h3>
<%
// include the history for the Audit Finding Action Task
String rels6 = sRelationshipAuditFinding + "," + sRelationshipAuditAction;
MapList temp6 = passedObj.getRelatedObjects(context, rels6, "*", objSelects, relSelects, false, true, (short)2, "", "");
MapList relList6 = new MapList();
for(int i=0;i<temp6.size();i++)
{
	if(((String)((Hashtable)temp6.get(i)).get(DomainConstants.SELECT_TYPE)).equals(sTypeAuditFindingActionTask))
	{
		relList6.add(temp6.get(i));
	}
}
if (relList6.size() <= 0)
    out.write("<p>"+sNone+"</p>");

for (int i = 0; i < relList6.size(); i++) {
    String objId = ((String) ((Map) relList6.get(i)).get(DomainConstants.SELECT_ID)).trim();
    String objName = ((String) ((Map) relList6.get(i)).get(DomainConstants.SELECT_NAME)).trim();
    String actionItemName = ((String) ((Map) relList6.get(i)).get("attribute[" + sAttributeActionItemName + "]")).trim();
%>
<p><%=XSSUtil.encodeForJavaScript(context,actionItemName) %></p>
<jsp:include page = "AuditHistorySummary.jsp" flush="true">
    <jsp:param name="objectId" value="<%=XSSUtil.encodeForJavaScript(context,objId)%>"/>
</jsp:include>
<%
}
%>

