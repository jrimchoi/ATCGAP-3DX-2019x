<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<%@ page import="com.matrixone.apps.framework.ui.UIUtil"%>
<%@ page import = "java.util.*" %>
<%@ page import = "matrix.db.*" %>
<script language = "Javascript" src="../common/scripts/emxUIConstants.js"></script>
<%
String sErrorMsg = null;

try
{
  String tableRowId[] = emxGetParameterValues(request, "emxTableRowId");
  String sConvertTo = (String)emxGetParameter(request, "typeToChange");
  String sConnectRel = (String)emxGetParameter(request, "connectRelName");
  String sDisonnectRel = (String)emxGetParameter(request, "disconnectRelName");
  String sPolicy = (String)emxGetParameter(request, "policy");
  String objectId = (String) emxGetParameter(request, "objectId");

    Map programMap = new HashMap();
	programMap.put("emxTableRowId", tableRowId);
    programMap.put("objectId", objectId);
	programMap.put("typeToChange", sConvertTo);
	programMap.put("connectRelName", sConnectRel);
	programMap.put("disconnectRelName", sDisonnectRel);
	programMap.put("policy", sPolicy);
	String[] methodargs =JPO.packArgs(programMap);
	sErrorMsg = (String)JPO.invoke(context, "gap_SmarTeamMigration", methodargs, "convertTypeTo", methodargs, String.class);   
	
  }
catch (Exception ex)
{
	sErrorMsg = ex.getMessage();    
}
if (UIUtil.isNotNullAndNotEmpty(sErrorMsg))
	{
		%>
		<script>
		alert("<%=sErrorMsg%>");
		</script>
		<%		
	}
%>
<script language="JavaScript" src="../common/scripts/emxUIConstants.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
<script language="Javascript" >
if(getTopWindow().getWindowOpener() && getTopWindow().getWindowOpener().getTopWindow().RefreshHeader){
    getTopWindow().getWindowOpener().getTopWindow().RefreshHeader();
}else if(getTopWindow().RefreshHeader){
  	 getTopWindow().RefreshHeader();
	}
  parent.document.location.href = parent.document.location.href;
</script>
