<%-- emxComponentsCheckout.jsp
   Copyright (c) 1992-2008 Dassault Systemes.
   All Rights Reserved.
   This program contains proprietary and trade secret information of MatrixOne,
   Inc.  Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program
--%>

<%@include file="../common/emxNavigatorInclude.inc"%>
<%@ include file="../integrations/MCADTopErrorInclude.inc" %>
<%@ page import="com.matrixone.MCADIntegration.utils.*"%>

<html>
<body>
      <form name="wrapper" method="post" action="../components/emxComponentsCheckout.jsp" >

        <table>
		<%
		  String objectId = emxGetParameter(request, "objectId");
		  String action   = emxGetParameter(request,"action");
		  String refreshStr = emxGetParameter(request,"refresh");
		  String strFileFormat = emxGetParameter(request,"format");
		  String strFileName   = emxGetParameter(request,"fileName");
		  strFileName = MCADUrlUtil.hexDecode(strFileName);   

		%>
          <input type="hidden" name="objectId" value="<xss:encodeForHTMLAttribute><%=objectId%></xss:encodeForHTMLAttribute>" >
		  <!--XSSOK-->
          <input type="hidden" name="fileName" value="<%=strFileName%>" >
          <input type="hidden" name="format" value="<xss:encodeForHTMLAttribute><%=strFileFormat%></xss:encodeForHTMLAttribute>" >
          <input type="hidden" name="action" value="<xss:encodeForHTMLAttribute><%=action%></xss:encodeForHTMLAttribute>" >
          <input type="hidden" name="refresh" value="false" >
        </table>
      </form>
      <script language="javascript">
        document.wrapper.submit();
      </script>
</body>
</html>
