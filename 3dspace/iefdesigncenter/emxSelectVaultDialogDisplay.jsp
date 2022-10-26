<%--  emxSelectVaultDialogDisplay.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxSelectVaultDialogDisplay.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$
--%>

<%--

 *
 * $History: emxSelectVaultDialogDisplay.jsp $
 *
 * *****************  Version 8  *****************
 * User: Shashikantk  Date: 1/21/03    Time: 12:54p
 * Updated in $/InfoCentral/src/infocentral
 * Message to user in case nothing has been found
 *
 * *****************  Version 7  *****************
 * User: Shashikantk  Date: 1/11/03    Time: 2:50p
 * Updated in $/InfoCentral/src/infocentral
 *
 * *****************  Version 6  *****************
 * User: Shashikantk  Date: 12/11/02   Time: 5:13p
 * Updated in $/InfoCentral/src/infocentral
 * Made it as Modal dialog
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
 *
--%>
<%@page import = "com.matrixone.apps.common.Company" %>
<%@include file="emxInfoCentralUtils.inc"%>             <%--For context, request wrapper methods, i18n methods--%>
<html>
<head>
<link rel="stylesheet" href="../common/styles/emxUITree.css" type="text/css">
<script>
  var bMultiSelect = parent.opener.bVaultMultiSelect;
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
  var selectedVaults="";

  for(k=0;k<document.selectVault.elements.length;k++)
  {
    var obj = document.selectVault.elements[k];
    if(obj.type == varType && obj.checked == true )
    {
      if(selectedVaults != "")
        selectedVaults += ",";
      selectedVaults += obj.value;
    }
  }

  if(selectedVaults == "")
  {
    alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.SelectAnItem</framework:i18nScript>");
    return;
  }
  if(selectedVaults.substr(0,1) == "*")
    selectedVaults = "*";
  parent.opener.txt_Vault.value = selectedVaults;
  parent.window.close();
}

</script>
</head>
<!--<body onLoad="self.focus()" onBlur="self.focus()">-->
<body>

<form name="selectVault">
  <table width="100%" border="0">


<%!
    public VaultList sortVaultList(VaultList vList){
        Vault as[] = (Vault[])vList.toArray(new Vault[0]);
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

                as[i1 - k] = new matrix.db.Vault(s);
            }
        }

        VaultList arrList = new VaultList();
        for(int l=0; l<as.length;l++){
            arrList.add(as[l]);
        }
        return arrList;
    }
%>
<%
   // VaultList vlist = Vault.getVaults(context, true);

	String personCompanyId = PersonUtil.getUserCompanyId(context);
	String vaults 		   = new Company(personCompanyId).getAllVaults(context);
	StringList vaultList   = FrameworkUtil.split(vaults,",");
	VaultList vlist 	   = new VaultList();
		
	Iterator itr = vaultList.iterator();
	while(itr.hasNext())
	{
		String vaultName =(String) itr.next();
		vlist.addElement(new Vault(vaultName));
	}

    if(!vlist.isEmpty())
    {
 %>
    <script>
        if(bMultiSelect)
        {
          document.write("<tr>");
          document.write("<td width=\"5%\">");
          document.write("<input name=\"selectedVault\" type=checkbox value=\"*\">");
          document.write("<\/td>");
		  //XSSOK
          document.write("<td>  [<%=sAll%>]   <\/td>");
          document.write("<\/tr>");

        }
</script>
<%
    }

    vlist = sortVaultList(vlist);
    VaultItr vItr = new VaultItr(vlist);
    if(vItr.next()){
      vItr.reset();
        while(vItr.next())
        {
          String name = (vItr.obj()).getName().trim();
          //String name = vault.getName().trim();
%>
        <tr>
          <td width="5%">
          <script>
        if(bMultiSelect)
        {
		    //XSSOK
            document.write("<input name=\"selectedVault\" type=checkbox value=\"<%=name%>\">");
        }
        else
        {
		    //XSSOK
            document.write("<input name=\"selectedVault\" type=radio value=\"<%=name%>\">");
        }
        </script>
          </td>
          <td align="left"><%=name%></td>
        </tr>
<%
        } // End of while loop
    }else{
%>
        <tr bgcolor="#eeeeee">
          <td align=center><framework:i18n localize="i18nId">emxIEFDesignCenter.Chooser.NoItemsFound</framework:i18n></td>
        </tr>
<%
    }// End of if(vItr.next())
%>
  </table>
</form>
</body>
</html>
