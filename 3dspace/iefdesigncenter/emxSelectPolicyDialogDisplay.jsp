<%--  emxSelectPolicyDialogDisplay.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxSelectPolicyDialogDisplay.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--

 *
 * $History: emxSelectPolicyDialogDisplay.jsp $
 * 
 * *****************  Version 11  *****************
 * User: Shashikantk  Date: 1/21/03    Time: 12:54p
 * Updated in $/InfoCentral/src/infocentral
 * Message to user in case nothing has been found
 * 
 * *****************  Version 10  *****************
 * User: Shashikantk  Date: 1/21/03    Time: 11:47a
 * Updated in $/InfoCentral/src/infocentral
 * Reference to person object is removed
 * 
 * *****************  Version 9  *****************
 * User: Shashikantk  Date: 1/16/03    Time: 4:12p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 8  *****************
 * User: Shashikantk  Date: 1/11/03    Time: 2:50p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 7  *****************
 * User: Shashikantk  Date: 12/11/02   Time: 5:14p
 * Updated in $/InfoCentral/src/infocentral
 * Made it as Modal dialog
 * 
 * *****************  Version 6  *****************
 * User: Shashikantk  Date: 11/26/02   Time: 3:09p
 * Updated in $/InfoCentral/src/InfoCentral
 * added code to get the sequence
 * 
 * *****************  Version 5  *****************
 * User: Shashikantk  Date: 11/23/02   Time: 6:56p
 * Updated in $/InfoCentral/src/InfoCentral
 * Code cleanup
 * 
 * *****************  Version 4  *****************
 * User: Shashikantk  Date: 11/21/02   Time: 6:56p
 * Updated in $/InfoCentral/src/InfoCentral
 * Removed the space between <%@include file and '='.
 * 
 * ***********************************************
 *
--%>
<%@include file="emxInfoCentralUtils.inc"%> 			<%--For context, request wrapper methods, i18n methods--%>
<html>
<head>
<link rel="stylesheet" href="../common/styles/emxUITree.css" type="text/css">
<script>
  var bMultiSelect = parent.opener.bPolicyMultiSelect;
  var varType = ""
  if(bMultiSelect)
    varType = "checkbox";
  else
    varType = "radio";  
<%
  String sAll = FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Common.All", request.getHeader("Accept-Language"));
%>

function submitForm()
{
  var selectedPolicys="";
  var associatedSequence = "";

  for(k=0;k<document.selectPolicy.elements.length;k++)
  {
    var obj = document.selectPolicy.elements[k];
    
    if(obj.type == varType && obj.checked == true )
    {
      if(selectedPolicys != "")
        selectedPolicys += ",";
      selectedPolicys += obj.value;

	  if(!bMultiSelect){
	    if(selectedPolicys.substr(0,1) != "*"){	    	
	  	  if(document.selectPolicy.elements[k].value == document.selectPolicy.elements[k+1].name) 
	  	  //Check the value of the field with the next hidden field's name to the value of the hidden field which is a sequence
	  	  	associatedSequence = document.selectPolicy.elements[k+1].value;
	    }
	  }
    }
  }
  
  if(selectedPolicys == "")
  {
    alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.SelectAnItem</framework:i18nScript>");
    return;
  }
  if(selectedPolicys.substr(0,1) == "*")
    selectedPolicys = "*";        
  
  parent.opener.txt_Sequence.value = associatedSequence;
  parent.opener.txt_Policy.value = selectedPolicys;
  parent.window.close();
}

</script>
</head>
<!--<body onLoad="self.focus()" onBlur="self.focus()">-->
<body>

<form name="selectPolicy">
  <table width="100%" border="0">

<script>
    if(bMultiSelect)
    {
      document.write("<tr>");
      document.write("<td width=\"5%\">");
      document.write("<input name=\"selectedPolicy\" type=checkbox value=\"*\">");
      document.write("<\/td>");
	  //XSSOK
      document.write("<td>  [<%=sAll%>]   <\/td>");
      document.write("<\/tr>");

    }
</script>
<%!
    public PolicyList sortPolicyList(PolicyList pList){		
		Policy as[] = (Policy[])pList.toArray(new Policy[0]);
		int i=0;
		int j= as.length -1;
        for(int k = (j - i) + 1; k > 1;)
        {
            if(k < 5)
                k = 1;
            else
                k = (5 * k - 1) / 11;
            for(int l = j - k; l >= i; l--)
            {
                String s = as[l].toString();
                int i1;
                for(i1 = l + k; i1 <= j && (s.toLowerCase()).compareTo((as[i1]).toString().toLowerCase()) > 0; i1 += k)
                    as[i1 - k] = as[i1];

                as[i1 - k] = new matrix.db.Policy(s);                
            }
        }
        
        PolicyList arrList = new PolicyList();
		for(int l=0; l<as.length;l++){
			arrList.add(as[l]);
		}
		return arrList;
    }
%>

<%
  String strType = emxGetParameter(request, "sType");
  String sVault = emxGetParameter(request, "sVault");
  Vault vault = context.getVault();
  if(null == sVault || "null".equalsIgnoreCase(sVault) || "".equals(sVault.trim())){  	
  	sVault = vault.getName();
  }

  //VaultItr vItr = new VaultItr(Vault.getVaults(context, true));
  BusinessType busType = new BusinessType(strType,vault);
  
  PolicyItr policyItrGeneric  = new PolicyItr(new PolicyList());
  
  busType.open(context);
  PolicyList policyList = busType.getPolicies(context);
  policyList = sortPolicyList(policyList);
  policyItrGeneric = new PolicyItr(policyList);
  busType.close(context);
  String sSequence = "";
  if(policyItrGeneric.next()){
	  policyItrGeneric.reset();
	  while(policyItrGeneric.next())
	  {
		String sPolicyName = (policyItrGeneric.obj()).getName().trim();
		if((policyItrGeneric.obj()).hasSequence(context)){
			sSequence = (policyItrGeneric.obj()).getSequence(context);
			//sSequence = sSequence.substring(0,1);
			if(sSequence!=null){
			StringTokenizer str = new StringTokenizer(sSequence,",");
			if(str.hasMoreTokens()){
			sSequence = str.nextToken();	
			}
			}
		}
%>
		<tr>
		  <td width="5%">
		  <script>
		if(bMultiSelect)
		{
		    //XSSOK
			document.write("<input name=\"selectedPolicy\" type=checkbox value=\"<%=sPolicyName%>\">");
			//XSSOK
			document.write("<input name=\"<%=sPolicyName%>\" type=hidden value=\"<%=sSequence%>\">");
		}
		else
		{
		    //XSSOK
			document.write("<input name=\"selectedPolicy\" type=radio value=\"<%=sPolicyName%>\">");
			//XSSOK
			document.write("<input name=\"<%=sPolicyName%>\" type=hidden value=\"<%=sSequence%>\">");
		}
		</script>
		  </td>
		  <td align="left"><%=sPolicyName%></td>
		</tr>
<%
	  }// End of while
 }else{
%>
	<tr bgcolor="#eeeeee">	  
	  <td align=center><framework:i18n localize="i18nId">emxIEFDesignCenter.Chooser.NoItemsFound</framework:i18n></td>
	</tr>
<% 
 }// End of if(policyItrGeneric.next())
%>
  </table>
</form>
</body>
</html>
<!-- content ends here -->
