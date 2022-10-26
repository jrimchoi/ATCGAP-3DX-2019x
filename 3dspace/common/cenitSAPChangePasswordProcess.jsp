
<%@include file = "emxNavigatorInclude.inc"%>
<%@include file = "emxNavigatorTopErrorInclude.inc"%>
<%@include file = "../common/enoviaCSRFTokenValidation.inc"%>

<%@page import="matrix.db.MQLCommand"%>
<%@page import="matrix.util.MatrixException"%>


<%@page import="java.text.SimpleDateFormat"%>



<%@page import="de.cenit.ev6sap.adaptor.EV6SAPAdaptor"%>
<%@page import="de.cenit.ev6sap.adaptor.EV6SAPAdaptor.eDialogMode"%>
<%@page import="de.cenit.ev6sap.adaptor.EV6SAPAdaptor.eProgressInfo"%>
<%@page import="de.cenit.ev6sap.adaptor.Result"%>

<%@page import="de.cenit.ev6utils.crypt.Crypt"%>

<html>
<head>
<script src="scripts/emxUICore.js" type="text/javascript"></script>
<script language="javascript">
  function gotoPasswordFrameset()
    {
    document.password.target= "pwdHiddenFrame";
    document.password.action = "cenitSAPChangePassword.jsp";
    document.password.method = "post";
    document.password.submit();
    }

</script>
</head>


<%
  //String sChangePassword = i18nNow.getI18nString("emxFramework.Common.ChangePassword", "emxFrameworkStringResource", request.getHeader("Accept-Language"));
  String sapUser = emxGetParameter(request, "txtUserName");
 // String sNewPassword = emxGetParameter(request, "txtNewPassword");
 // String sConfirmPassword = emxGetParameter(request, "txtConfirmPassword");
  String sapPassword = emxGetParameter(request, "txtCurrentPassword");

  String sResponse = i18nNow.getI18nString("emxFramework.Login.PasswordChangedSuccessfully", "emxFrameworkStringResource", request.getHeader("Accept-Language"));
  boolean isProblem=false;
  
  sResponse = "just testing";
   isProblem=true;
  try
  {
	//  Framework.getMainContext(session).setPassword(sCurrentPassword, sNewPassword, sConfirmPassword);
	
	 String BusID ="0";
			String DialogMode = "0";
			String Mode = "Online";
			String Operation =  "SAPUserUpdateNew";
			String  Input = "";
			
			Hashtable paramMap = new Hashtable();
			HashMap contextMap = new HashMap();
			
			contextMap.put("SAPUSER", sapUser);
			contextMap.put("SAPPASSWORD", new Crypt().PWCrypt(sapPassword) );
			
			HashMap objectIDMap = new HashMap();
			HashMap additioalParameterMap = new HashMap();
			
			
			paramMap.put("context", contextMap);
			paramMap.put("objectID", objectIDMap);
			paramMap.put("additioalParameter", additioalParameterMap);
			paramMap.put("operation", Operation);

			
			
	
			SimpleDateFormat DF = new SimpleDateFormat("yyyyMMddHHmmss");
			String DateExtension = DF.format(new Date());
			String ProcessID = DateExtension+"_"+System.currentTimeMillis();
					
			
			EV6SAPAdaptor ev6sapAdaptor = new EV6SAPAdaptor();
			ev6sapAdaptor.setGlobalMap(paramMap);
			ev6sapAdaptor.setProcessID(ProcessID);
	eDialogMode DialogMode1 = eDialogMode.values()[Integer.parseInt(DialogMode)];
			
			Result res =  ev6sapAdaptor.execute("", Operation, context, BusID, DialogMode1, eProgressInfo.piNone, Input);
			
			if (res.Code == 0){
	sResponse = res.Message;
    isProblem=false;
}
else{
	 sResponse = res.Message;
    isProblem=true;
  }
   }
  catch(Exception me)
  {
    sResponse = me.toString();
    isProblem=true;
  }
%>

<%if(!isProblem){%>
<script language="Javascript">
//XSSOK
alert("<%=sResponse%>");
getTopWindow().closeWindow();
</script>

<%}else{

if(sResponse != null){
    sResponse=sResponse.trim();
}
%>
<script language="Javascript">
//XSSOK
alert("<%=sResponse%>");
</script>

<%}%>

