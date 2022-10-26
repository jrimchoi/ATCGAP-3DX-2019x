<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ page import="com.matrixone.servlet.Framework"%>
<%@ page import="com.matrixone.MCADIntegration.utils.MCADUrlUtil"%>
<%@ page import= "com.matrixone.apps.domain.util.*" %>
<%@ page import="java.util.*,java.io.*, java.net.*,com.matrixone.MCADIntegration.server.*,com.matrixone.MCADIntegration.server.beans.*, com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.utils.customTable.*"  %>
<%@ page import = "matrix.db.*, matrix.util.*,com.matrixone.servlet.*,com.matrixone.apps.framework.ui.*,com.matrixone.apps.domain.util.*, com.matrixone.apps.domain.*"%>
<%@ page import = "java.util.*,java.io.*,javax.servlet.*,javax.servlet.http.*"%>;
<%@ page import = "com.matrixone.apps.domain.util.CacheUtil"%>
<%@ page import = "java.io.*,javax.servlet.*,javax.servlet.http.*"%>;
<%@ page import = "com.matrixone.apps.common.*, com.matrixone.apps.domain.*, com.matrixone.apps.domain.util.*, matrix.util.*"%>
<%
MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData)session.getAttribute("MCADIntegrationSessionDataObject");
Context context = integSessionData.getClonedContext(session);
String sProjectFolder	=Request.getParameter(request,"projectSpaceType");

String sMode	=Request.getParameter(request,"mode");
if("DECCompareStructure".equals(sMode)){
	String sSelId	=Request.getParameter(request,"selectedOid");
	CacheUtil.setCacheObject(context, "DECCompStructUsrSelOid", sSelId);
}
else if("CheckAccessOnFolder".equals(sMode)){
	String sSelId	=Request.getParameter(request,"selectedOid");
	
	StringList slSelects = new StringList(1);
	slSelects.addElement("current.access[fromconnect]");

	DomainObject domainObject = DomainObject.newInstance(context, sSelId);
	
	Map mpObjInfo = domainObject.getInfo(context,slSelects);
	boolean writeAccess = false;

	if("true".equals(sProjectFolder)){
		String sFromconnAccess =  (String) mpObjInfo .get("current.access[fromconnect]");
		if("TRUE".equals(sFromconnAccess)){
		writeAccess=true;
		}
		else{
		writeAccess=false;
		}
	} else {
		//if it is kind of folder
		Access contextAccess	  = domainObject.getAccessMask(context);

		writeAccess = AccessUtil.hasAddAccess(contextAccess);
	}
	out.println(writeAccess);	

}
%>

<script language="JavaScript" src="scripts/IEFUIConstants.js" type="text/javascript"></script>
<script language="JavaScript" src="scripts/IEFUIModal.js" type="text/javascript"></script>
<script language="JavaScript" src="scripts/MCADUtilMethods.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
