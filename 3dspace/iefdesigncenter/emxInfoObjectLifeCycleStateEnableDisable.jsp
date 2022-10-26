<%--  emxInfoObjectLifeCycleStateEnableDisable.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoObjectLifeCycleStateEnableDisable.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--

 *
 * $History: emxInfoObjectLifeCycleStateEnableDisable.jsp $
 * ***********************************************
 *
--%>
<%@include file="emxInfoCentralUtils.inc"%>             <%--For context, request wrapper methods, i18n methods--%>

<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>
<html>
<head>
<link rel="stylesheet" href="../common/styles/emxUITree.css" type="text/css">
<script>
  //var bMultiSelect = parent.opener.bVaultMultiSelect;
  var bMultiSelect = true;
  var varType = ""
  if(bMultiSelect)
    varType = "checkbox";
  else
    varType = "radio";

<%
    String sObjectId = emxGetParameter(request, "parentOID");
    String sCmd = emxGetParameter(request, "cmd");
//  String sAll = i18nStringNow("emxIEFDesignCenter.Common.All", request.getHeader("Accept-Language"));
%>

function submitForm()
{
  var selectedStates="";

  for(k=0;k<document.selectState.elements.length;k++)
  {
    var obj = document.selectState.elements[k];
    if(obj.type == varType && obj.checked == true )
    {
      if(selectedStates != "")
        selectedStates += ",";
      selectedStates += obj.value;
    }
  }

  if(selectedStates == "")
  {
    alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.SelectAnItem</framework:i18nScript>");
    return;
  }
  if(selectedStates.substr(0,1) == "*")
    selectedStates = "*";

  //parent.opener.txt_Vault.value = selectedStates;
  document.selectState.method = "post";
  document.selectState.action = "emxInfoObjectLifeCycleStateEnableDisableProcess.jsp?sObjectId=<%=XSSUtil.encodeForURL(context,sObjectId)%>&cmd=<%=XSSUtil.encodeForURL(context,sCmd)%>&selectedStateNames="+selectedStates;
  document.selectState.submit();
}

</script>
</head>
<body>

<form name="selectState">


<%
boolean csrfEnabled = ENOCsrfGuard.isCSRFEnabled(context);
if(csrfEnabled)
{
  Map csrfTokenMap = ENOCsrfGuard.getCSRFTokenMap(context, session);
  String csrfTokenName = (String)csrfTokenMap .get(ENOCsrfGuard.CSRF_TOKEN_NAME);
  String csrfTokenValue = (String)csrfTokenMap.get(csrfTokenName);
%>
  <!--XSSOK-->
  <input type="hidden" name= "<%=ENOCsrfGuard.CSRF_TOKEN_NAME%>" value="<%=csrfTokenName%>" />
  <!--XSSOK-->
  <input type="hidden" name= "<%=csrfTokenName%>" value="<%=csrfTokenValue%>" />
<%
}
//System.out.println("CSRFINJECTION");
%>

  <table width="100%" border="0">

<script>
    if(bMultiSelect)
    {
      //document.write("<tr>");
      //document.write("<td width=\"5%\">");
      //document.write("<input name=\"selectedVault\" type=checkbox value=\"*\">");
      //document.write("<\/td>");
      //document.write("<td>  [<%//=sAll%>]   <\/td>");
      //document.write("<\/tr>");

    }
</script>
<%
    String sResult = "";
    String sStateName = "";
    int  statesDrawn =0;
    
	String sPolicy="";
	String languageStr = "";
	try
	{
		// Added by nagesh on 12/1/2004
		BusinessObject BO = new BusinessObject(sObjectId);
		BO.open(context);
		sPolicy = BO.getPolicy(context).getName();
		languageStr = request.getHeader("Accept-Language");
		//End of add nagesh on 12/1/2004

        MQLCommand mqlcommand = new MQLCommand();
        mqlcommand.open(context);
        mqlcommand.executeCommand(context, "print bus $1 select state dump",sObjectId);
        sResult = mqlcommand.getResult();
        mqlcommand.close(context);
    }catch(Exception e){
    }

        StringTokenizer stringtokenizer = new StringTokenizer(sResult, ",");

        while(stringtokenizer.hasMoreTokens())
        {
            String sEnableDisableResult="";
            sStateName=stringtokenizer.nextToken().toString().trim();
            MQLCommand mqlcommand = new MQLCommand();
            mqlcommand.open(context);
            mqlcommand.executeCommand(context, "print bus $1 select $2 dump $3",sObjectId,"state["+sStateName+"].enabled","|");
            sEnableDisableResult = mqlcommand.getResult();
            mqlcommand.close(context);

            if((sCmd.equalsIgnoreCase("Enable")&& sEnableDisableResult.trim().equalsIgnoreCase("FALSE"))||(sCmd.equalsIgnoreCase("Disable")&& sEnableDisableResult.trim().equalsIgnoreCase("TRUE")))
                {
                    statesDrawn=statesDrawn+1;
%>
        <tr>
          <td width="5%">
          <script>
        if(bMultiSelect)
        {
		    //XSSOK
            document.write("<input name=\"selectedState\" type=checkbox value=\"<%=sStateName%>\">");
        }
        else
        {
		    //XSSOK
            document.write("<input name=\"selectedState\" type=radio value=\"<%=sStateName%>\">");
        }
        </script>
          </td>
          <td align="left"><%=i18nNow.getStateI18NString(sPolicy,sStateName,languageStr)%>&nbsp;</td>
        </tr>
<%
        } // End of while loop
      }
    if (statesDrawn==0)
    {
%>
        <tr bgcolor="#eeeeee">
          <td align=center><framework:i18n localize="i18nId">emxIEFDesignCenter.Chooser.NoItemsFound</framework:i18n></td>
        </tr>
<%
    }
%>
  </table>
</form>
</body>
</html>
