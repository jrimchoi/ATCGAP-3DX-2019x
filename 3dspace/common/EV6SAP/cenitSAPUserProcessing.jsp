<%--  cenitSAPPreferencesProcessing.jsp
--%>


<%@page import="matrix.db.MQLCommand"%>
<%@page import="matrix.util.MatrixException"%>


<%@page import="java.text.SimpleDateFormat"%>



<%@page import="de.cenit.ev6sap.adaptor.EV6SAPAdaptor"%>
<%@page import="de.cenit.ev6sap.adaptor.EV6SAPAdaptor.eDialogMode"%>
<%@page import="de.cenit.ev6sap.adaptor.EV6SAPAdaptor.eProgressInfo"%>
<%@page import="de.cenit.ev6sap.adaptor.Result"%>

<%@page import="de.cenit.ev6utils.crypt.Crypt"%>


<%@include file = "../emxNavigatorInclude.inc"%>
<%@include file = "../emxNavigatorTopErrorInclude.inc"%>
<%@include file = "../enoviaCSRFTokenValidation.inc"%>




<%
     String sapUser = emxGetParameter(request, "sapUser");
	 String sapPassword = emxGetParameter(request, "sapPassword");



try {		
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
	 %>
			<script language="Javascript">
				var alertMsg = "Sucess <%=res.Message%>";
				alert(alertMsg);
			</script>
<%

}
else{
	  %>
			<script language="Javascript">
				var alertMsg = " Error <%=res.Message%>";
				alert(alertMsg);
			</script>
<%

}


		} catch (RuntimeException e) {
			%>
			<script language="Javascript">
				var alertMsg = " Runtime Exception:  <%=e.getMessage()%>";
				alert(alertMsg);
			</script>
<%
			e.printStackTrace();
			//return new Result(1, "Runtime Exception: " + e.getMessage(), "");
		} catch (Exception e) {
		%>	<script language="Javascript">
				var alertMsg = " Exception:  <%=e.getMessage()%>";
				alert(alertMsg);
			</script>
			<%
			e.printStackTrace();
		//	return new Result(1, "Exception: " + e.getMessage(), "");
		}




%>

						

<%@include file = "../emxNavigatorBottomErrorInclude.inc"%>

