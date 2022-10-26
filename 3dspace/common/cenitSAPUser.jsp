<%-- cenitSAPPreferences.jsp
--%>

<%@include file = "../emxNavigatorInclude.inc"%>


<%@page import="matrix.db.MQLCommand"%>
<%@page import="matrix.util.MatrixException"%>


<HTML>
<%@include file = "../emxNavigatorTopErrorInclude.inc"%>

  <HEAD>
    <TITLE></TITLE>
    <META http-equiv="imagetoolbar" content="no" />
    <META http-equiv="pragma" content="no-cache" />
    <SCRIPT language="JavaScript" src="scripts/emxUIConstants.js"
    type="text/javascript">
    </SCRIPT>
    <script language="JavaScript" src="scripts/emxUICore.js"></script>
    <SCRIPT language="JavaScript" src="scripts/emxUIModal.js"
          type="text/javascript">
    </SCRIPT>
    <SCRIPT language="JavaScript" src="scripts/emxUIPopups.js"
          type="text/javascript">
    </SCRIPT>
    <SCRIPT type="text/javascript">
      addStyleSheet("emxUIDefault");
      addStyleSheet("emxUIForm");

      function doLoad() {
        if (document.forms[0].elements.length > 0) {
          var objElement = document.forms[0].elements[0];

          if (objElement.focus) objElement.focus();
          if (objElement.select) objElement.select();
        }
      }
    </SCRIPT>
	
	 <script language="JavaScript" type="text/javascript">
  function validationRoutine(){
    var theForm = document.forms[0];
    var theField = theForm["sapUser"];
    if(!isNaN(theField.value)){
        alert("<emxUtil:i18nScript localize="i18nId">emxFramework.FormComponent.MustEnterAValidNumericValueFor</emxUtil:i18nScript> <emxUtil:i18n localize="i18nId">emxFramework.PaginationPreference.Items</emxUtil:i18n>");
        return false;
    }
    return true;
  }

  </script>
	
	
  </HEAD>
  <BODY onload="doLoad(), turnOffProgress()">
    <FORM id="CenitSAPUser" method="post" action="cenitSAPUserProcessing.jsp">
      <TABLE border="0" cellpadding="5" cellspacing="2"
             width="100%">
			 
			 <%
    try
    {
    MQLCommand MQL = new MQLCommand();
	MQL.executeCommand(context, "print context select user dump");
	String user = MQL.getResult();
	MQL.executeCommand(context, "print bus Person "+user+ " - select  attribute[cenitSAPUser].value dump");
     
	String sapUser =  MQL.getResult();
	
	MQL.executeCommand(context, "print bus Person "+user+ " - select  attribute[cenitSAPPassword].value dump");
	String sapPassword =  MQL.getResult();
	
%>
	 
        <TR>
          <TD width="150" class="label">
            SAP User
          </TD>
         <td class='tdinput'><input type='text' id="sapUser" name="sapUser"  value="<%=sapUser%>"/> </td>
        </TR>
		  <TR>
          <TD width="150" class="label">
            SAP Password
          </TD>
          <td class='tdinput'><input type='password' id="sapPassword" name="sapPassword"  value="<%=sapPassword%>"/> </td>
        </TR>
<%
     
    }
    catch (Exception ex)
    {
       
    }
   
%>		
		
		
		
      </TABLE>
    </FORM>
  </BODY>

<%@include file = "../emxNavigatorBottomErrorInclude.inc"%>

</HTML>

