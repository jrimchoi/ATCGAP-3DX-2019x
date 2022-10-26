<%--  DSCCompareStructureComparisonDetailsReport.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  DSCCompareStructureComparisonReportDetailsReport.jsp   -    Print details of reports for comparing structure's of 2 assemblies

--%>

<html>
<head>
<%@ page import = "com.matrixone.apps.common.util.*,com.matrixone.MCADIntegration.utils.*,com.matrixone.apps.domain.util.PropertyUtil"%>
<%@include file = "emxInfoCentralUtils.inc"%>
<script language="JavaScript" src="../common/scripts/emxUIModal.js"></script>

<%
    String printerfriendly = emxGetParameter(request, "PrinterFriendly");
    String languageStr     = request.getHeader("Accept-Language");
    		
%>

<%
	if(printerfriendly==null)
	{
%>
        <script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script>
        <script type="text/javascript">
            addStyleSheet("emxUIDefault");
            addStyleSheet("emxUIList");
        </script>
<%
	} 
	else
	{
%>
        <link rel="stylesheet" href="../emxUITemp.css" type="text/css">
        <link rel="stylesheet" href="../emxUIPF.css" type="text/css">
<%
	}
%>

<%
	// Get default icon for type
	String defaultTypeIcon = JSPUtil.getCentralProperty(application, session, "type_Default", "LargeIcon");
	String sVaultName      = JSPUtil.getVault(context, session);
%>

<script language="javascript">
function myObject(FN,Type,Name,Rev,RefDes,Description,Qty,Qty2,ItemDiff,QtyDiff,KeyDiff,ObjId) 
{
	this.FN = FN;
	this.Type = Type;
	this.Name = Name;
	this.Rev = Rev;
	this.RefDes = RefDes;
	this.Description = Description;
	this.Qty = Qty;
	this.Qty2 = Qty2;
	this.ItemDiff = ItemDiff;
	this.QtyDiff = QtyDiff;
	this.KeyDiff = KeyDiff;
	this.ObjId = ObjId;
}

</script>
<%
	String tmpPageHeading         = i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.StructureComparisonReport", "emxIEFDesignCenterStringResource", languageStr);
	String sOwner                 = i18nNow.getI18nString("emxIEFDesignCenter.Common.Owner", "emxIEFDesignCenterStringResource", languageStr);
	String sCommonComponents      = i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.CommonComponents", "emxIEFDesignCenterStringResource", languageStr);
	String sPart1UniqueComponents = i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.Part1UniqueComponents", "emxIEFDesignCenterStringResource", languageStr);
	String sPart2UniqueComponents = i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.Part2UniqueComponents", "emxIEFDesignCenterStringResource", languageStr);

	String partIdOne	= emxGetParameter(request, "structure1Id");
	String partIdTwo	= emxGetParameter(request, "structure2Id");;
	String sCurrReport3 = emxGetParameter(request, "showp1unique") ;
	String sCurrReport4 = emxGetParameter(request, "showp2unique") ;
	String sCurrReport5 = emxGetParameter(request, "showcommon") ;
	String jsTreeID		= emxGetParameter(request, "jsTreeID");

	boolean isReport3 = true;
	boolean isReport4 = true;
	boolean isReport5 = true;

	if ("null".equalsIgnoreCase(sCurrReport3) || "".equalsIgnoreCase(sCurrReport3) || sCurrReport3 == null || ! sCurrReport3.equals("p1comp"))
	{
		isReport3 = false;
	}
	if ("null".equalsIgnoreCase(sCurrReport4) || "".equalsIgnoreCase(sCurrReport4) || sCurrReport4 == null || ! sCurrReport4.equals("p2comp"))
	{
		isReport4 = false;
	}
	if ("null".equalsIgnoreCase(sCurrReport5) || "".equalsIgnoreCase(sCurrReport5) || sCurrReport5 == null || ! sCurrReport5.equals("commoncomp"))
	{
		isReport5 = false;
	}

	BusinessObject busObj = new BusinessObject(partIdOne);
	busObj.open(context);

	String sObjectName        = busObj.getName();
	String sObjectTypeName    = busObj.getTypeName();
	String sObjectOwner       = busObj.getOwner(context).getName();
	String sObjectRevision    = busObj.getRevision();
	String sObjectDescription = busObj.getRevision();
	String actualTitleName	  = (String)PropertyUtil.getSchemaProperty(context,"attribute_Title");
	String sObjectTitle    	  = busObj.getAttributeValues(context, actualTitleName).getValue();
	busObj.close(context);

	String alias = FrameworkUtil.getAliasForAdmin(context, "type", sObjectTypeName, true);

	String typeIcon1="";
	if ((alias == null) || (alias.equals("")) || (alias.equals("null")))
	{    
		typeIcon1 = defaultTypeIcon;
	}
	else
	{
		//typeIcon1 = JSPUtil.getCentralProperty(application, session, alias, "SmallIcon");
		typeIcon1 = "iconSmallCADModel.gif";
	}

	BusinessObject busObj2 = new BusinessObject(partIdTwo);
	busObj2.open(context);

	String sObjectName2        = busObj2.getName();
	String sObjectTypeName2    = busObj2.getTypeName();
	String sObjectOwner2       = busObj2.getOwner(context).getName();
	String sObjectRevision2    = busObj2.getRevision();
	String sObjectDescription2 = busObj2.getRevision();
	String sObjectTitle2   	   = busObj2.getAttributeValues(context, actualTitleName).getValue();
	busObj2.close(context);

	alias = FrameworkUtil.getAliasForAdmin(context, "type",sObjectTypeName2, true);
	String typeIcon2="";
	if ((alias == null) || (alias.equals("")) || (alias.equals("null")))
	{
		typeIcon2 = defaultTypeIcon;
	}
	else
	{
		//typeIcon2 = JSPUtil.getCentralProperty(application, session, alias, "SmallIcon");
		typeIcon2 = "iconSmallCADModel.gif";
	}
%>
</head>
<body>
<link rel="stylesheet" href="../integrations/styles/emxIEFCommonUI.css" type="text/css">
<table border="0" cellspacing="0" cellpadding="0" width="100%">
  <tr>
    <td class="pageBorder"><img src="../common/images/utilSpacer.gif" width="1" height="1" alt=""></td>
  </tr>
</table>

<table border="0" width="100%" cellspacing="2" cellpadding="4">
  <tr>
    <!--XSSOK-->
    <td class="pageHeader" width="99%"><%=sObjectName%>&nbsp;<%=sObjectRevision%>: <%=tmpPageHeading%></td>
	<!--XSSOK-->
    <td nowrap valign="middle"><%=sOwner%>:<%=PersonUtil.getFullName(context,sObjectOwner)%></td>
  </tr>
</table>


<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tr>
<td class="pageBorder"><img src="../common/images/utilSpacer.gif" width="1" height="1" alt=""></td>
</tr>
<tr><td>&nbsp;</td></tr>
</table>

     <table width="100%" border="0">
        <tr>
          <td align="center">
            <table border="0">
              <tr>
                <td><%= i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.Part1", "emxIEFDesignCenterStringResource", languageStr) %>:</td>
                <!--XSSOK-->
                <td><img src="../common/images/<%=typeIcon1%>"></td>
                <td><%=i18nNow.getTypeI18NString(sObjectTypeName,languageStr)%><br>
				  <!--XSSOK-->
                  <span class="object"><%=sObjectName%></span><br>
				  <!--XSSOK-->
                  <%=sObjectRevision%><br> 
				  <!--XSSOK-->
                  <%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Title", "emxIEFDesignCenterStringResource", languageStr) %> :&nbsp;<%= MCADUtil.escapeStringForHTML(sObjectTitle) %><td> 
              </tr>
            </table>
          </td>
          <td align="center">
            <table border="0">
              <tr>
                <td><%= i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.Part2", "emxIEFDesignCenterStringResource", languageStr) %>:</td>
                <!--XSSOK-->
                <td><img src="../common/images/<%=typeIcon2%>"></td>
                <td><%=i18nNow.getTypeI18NString(sObjectTypeName2,languageStr)%><br>
				  <!--XSSOK-->
                  <span class="object"><%=sObjectName2%></span><br>
				  <!--XSSOK-->
                  <%=sObjectRevision2%><br>
				  <!--XSSOK-->
                  <%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Title", "emxIEFDesignCenterStringResource", languageStr) %> :&nbsp;<%=MCADUtil.escapeStringForHTML(sObjectTitle2)%><td>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>

<%
	// check if compare failed and print error message
	String mqlError = (String) session.getValue("Error");
	if((mqlError !=null) && (!mqlError.equalsIgnoreCase("null")) && !(mqlError.equals(""))) 
	{
%>
    <table width="95%" cellpadding="0", cellspacing="0">
    <tr class="odd">
      <td width="100%"><%= i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.Errorincomparison", "emxIEFDesignCenterStringResource", languageStr) %>: </td>
    </tr>
    <tr>
	  <!--XSSOK-->
      <td><font color=red><%=mqlError%> </font></td>
    </tr>
    </table>
<%
		session.removeAttribute("emxEngrCompareEBOMType1");
		session.removeAttribute("emxEngrCompareEBOMPart1");
		session.removeAttribute("emxEngrCompareEBOMRev1");
		session.removeAttribute("emxEngrCompareEBOMType2");
		session.removeAttribute("emxEngrCompareEBOMPart2");
		session.removeAttribute("emxEngrCompareEBOMRev2");

		session.removeAttribute("emxUnique1");
		session.removeAttribute("emxUnique2");
		session.removeAttribute("emxCommon");
	} 
	else 
	{
		StringTokenizer sTok = null;
		// variables used for printing every other row shaded
		int iOddEven = 1;
		String sRowClass = "odd";

		// Get hashtables for Reports
		Hashtable commonPrintReport  = (Hashtable)session.getValue("emxCommon");
		Hashtable unique1PrintReport = (Hashtable)session.getValue("emxUnique1");
		Hashtable unique2PrintReport = (Hashtable)session.getValue("emxUnique2");

		if (isReport3)  
		{
    %>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tr>
<td>&nbsp;</td>
</tr>
</table>

<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tr>
<td class="pageBorder"><img src="../common/images/utilSpacer.gif" width="1" height="1" alt=""></td>
</tr>
</table>
<table border="0"><tr><td class="pageHeader"><%=sPart1UniqueComponents%></td></tr></table>&nbsp;
        <table width="100%" border="0" cellpadding="8", cellspacing="2">
        <tr>
          <th width="10%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Type", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
          <th width="20%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Name", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
          <th width="20%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Title", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
          <th width="5%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Rev", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
          <th width="30%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Description", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
          <th width="15%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.Quantity", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
        </tr>

<%
			if(unique1PrintReport != null && !unique1PrintReport.isEmpty()) 
			{
				Enumeration eKeys = unique1PrintReport.keys();
				while (eKeys.hasMoreElements())  
				{
					//Determine whether row should be shaded or not
					if ((iOddEven%2) == 0) 
						sRowClass = "even";
					else  
						sRowClass = "odd";

					iOddEven++;
					String sKey = eKeys.nextElement().toString();
					
					// get values from hashtable to print
					String sValue = (String) unique1PrintReport.get(sKey);
					sTok = new StringTokenizer(sKey+MCADAppletServletProtocol.IEF_SEPERATOR_ONE+sValue,MCADAppletServletProtocol.IEF_SEPERATOR_ONE,false);
					// extract information for printing - description, quantity
					String sType = sTok.nextToken();

					alias = FrameworkUtil.getAliasForAdmin(context, "type",sType, true);
					String typeIcon4="";
					if ((alias == null) || (alias.equals("")) || (alias.equals("null")))
					{
						typeIcon4 = defaultTypeIcon;
					}
					else
					{
						//typeIcon4 = JSPUtil.getCentralProperty(application, session, alias, "SmallIcon");
						typeIcon4 = "iconSmallCADModel.gif";
					}

					String sName = sTok.nextToken();
					String sRev = sTok.nextToken();
					String sDescription = sTok.nextToken();
					String sQty = sTok.nextToken();
					String sTitle 		= sTok.nextToken();
%>
          <!--XSSOK-->
          <tr class="<%=sRowClass%>">
            <td width="10%" class=node> <%=i18nNow.getTypeI18NString(sType,languageStr)%>&nbsp </td>
			<!--XSSOK-->
            <td width="20%" class=node> <table cellspacing="1" cellpadding="1"><tr><td><img src="../common/images/<%=typeIcon4%>" border="0"/></td><td><%=sName%></td></tr></table></td>
			<!--XSSOK-->
            <td width="20%" class=node> <%=MCADUtil.escapeStringForHTML(sTitle)%>&nbsp </td>
            <td width="5%" class=node> <xss:encodeForHTML><%=sRev%></xss:encodeForHTML>&nbsp </td>
            <td width="30%" class=node> <xss:encodeForHTML><%=sDescription%></xss:encodeForHTML>&nbsp </td>
            <td width="15%" class=node> <xss:encodeForHTML><%=sQty%></xss:encodeForHTML>&nbsp </td>
          </tr>
<%
				}
%>
        </table>
<%
			} 
			else 
			{
%>
       </table>
       <table align = "center" width = "100%" border= "0" cellpadding="0", cellspacing="0">
	      <!--XSSOK-->
          <tr class="<%=sRowClass%>">
            <td align=center><%= i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.Nouniqueitemsforpart1todisplay", "emxIEFDesignCenterStringResource", languageStr) %></td>
          </tr>
        </table>
<%
			}
		}
		

		if (isReport4) 
		{
%>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tr>
<td>&nbsp;</td>
</tr>
</table>

<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tr>
<td class="pageBorder"><img src="../common/images/utilSpacer.gif" width="1" height="1" alt=""></td>
</tr>
</table>
<table border="0"><tr><td class="pageHeader"><%=sPart2UniqueComponents%></td></tr></table>&nbsp;

       <table width="100%" border="0" cellpadding="8", cellspacing="2">
        <tr>

          <th width="10%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Type", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
          <th width="20%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Name", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
          <th width="20%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Title", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
          <th width="5%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Rev", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
          <th width="30%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Description", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
          <th width="15%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.Quantity", "emxIEFDesignCenterStringResource", languageStr) %></b></th>

        </tr>

<%
        // if compare hashtable is not empty extract information and print table
			if(unique2PrintReport != null && !unique2PrintReport.isEmpty()) 
			{
				Enumeration eKeys = unique2PrintReport.keys();
				while (eKeys.hasMoreElements())
				{
					// determine whether row should be shaded or not
					if ((iOddEven%2) == 0)
						sRowClass = "even";
					else
						sRowClass = "odd";

					iOddEven++;
					String sKey = eKeys.nextElement().toString();
					// get values from hashtable to print
					String sValue = (String) unique2PrintReport.get(sKey);
					sTok = new StringTokenizer(sKey+MCADAppletServletProtocol.IEF_SEPERATOR_ONE+sValue,MCADAppletServletProtocol.IEF_SEPERATOR_ONE,false);
					// extract information for printing - description, quantity
					String sType = sTok.nextToken();

					alias = FrameworkUtil.getAliasForAdmin(context, "type",sType, true);
					String typeIcon5="";
					if ((alias == null) || (alias.equals("")) || (alias.equals("null")))
					{
						typeIcon5 = defaultTypeIcon;
					}
					else
					{
						//typeIcon5 = JSPUtil.getCentralProperty(application, session, alias, "SmallIcon");
						typeIcon5 = "iconSmallCADModel.gif";
					}
					
					String sName = sTok.nextToken();
					String sRev = sTok.nextToken();
					String sDescription = sTok.nextToken();
					String sQty1 = sTok.nextToken();
					String sTitle 		= sTok.nextToken();
%>
            <!--XSSOK-->
            <tr class="<%=sRowClass%>">
              <td width="10%" class=node> <%=i18nNow.getTypeI18NString(sType,languageStr)%>&nbsp </td>
			  <!--XSSOK-->
              <td width="20%" class=node> <table cellspacing="1" cellpadding="1"><tr><td><img src="../common/images/<%=typeIcon5%>" border="0"/>
			  </td><td><xss:encodeForHTML><%=sName%></xss:encodeForHTML></td></tr></table></td>
			  <!--XSSOK-->
			  <td width="20%" class=node> <%=MCADUtil.escapeStringForHTML(sTitle)%>&nbsp </td>
              <td width="5%" class=node> <xss:encodeForHTML><%=sRev%>></xss:encodeForHTML>&nbsp </td>
              <td width="30%" class=node> <xss:encodeForHTML><%=sDescription%></xss:encodeForHTML>&nbsp </td>
              <td width="15%" class=node> <xss:encodeForHTML><%=sQty1%></xss:encodeForHTML>&nbsp </td>
            </tr>
<%
				}
%>
          </table>
<%
         // end of if for table empty
			} 
			else 
			{
%>
          </table>
          <table align = "center" width = "100%" border="0" cellpadding="0", cellspacing="0">
		    <!--XSSOK-->
            <tr class="<%=sRowClass%>">
              <td align=center><%= i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.Nouniqueitemsforpart2todisplay", "emxIEFDesignCenterStringResource", languageStr) %></td>
            </tr>
          </table>
<%
			}
		}

		if (isReport5) 
		{
%>

<table border="0" cellspacing="0" cellpadding="0" width="100%">
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>

<table border="0" cellspacing="0" cellpadding="0" width="100%">
  <tr>
    <td class="pageBorder"><img src="../common/images/utilSpacer.gif" width="1" height="1" alt=""></td>
  </tr>
</table>
<table border="0"><tr><td class="pageHeader"><%=sCommonComponents%></td></tr></table>&nbsp;

    <table width="100%" border="0" cellpadding="1", cellspacing="2">
    <tr>
      <th rowspan="2" width="10%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Type", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
      <th rowspan="2" width="20%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Name", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
      <th rowspan="2" width="20%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Title", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
      <th rowspan="2" width="5%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Rev", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
      <th rowspan="2" width="30%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Description", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
      <th colspan="2" width="15%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.Quantity", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
    </tr>
    <tr>
      <th align="center" nowrap class=sorted><%= i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.Part1", "emxIEFDesignCenterStringResource", languageStr) %></th>
      <th align="center" nowrap class=sorted><%= i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.Part2 ", "emxIEFDesignCenterStringResource", languageStr) %></th>
    </tr>

<%
			if(commonPrintReport != null && !commonPrintReport.isEmpty()) 
			{
				Enumeration eKeys = commonPrintReport.keys();
				while (eKeys.hasMoreElements())  
				{
					// determine whether row should be shaded or not
					if ((iOddEven%2) == 0)
						sRowClass = "even";
					else
						sRowClass = "odd";
	
					iOddEven++;
					String sKey = eKeys.nextElement().toString();
					// get values from hashtable to print
					String sValue = (String) commonPrintReport.get(sKey);
					sTok = new StringTokenizer(sKey+MCADAppletServletProtocol.IEF_SEPERATOR_ONE+sValue,MCADAppletServletProtocol.IEF_SEPERATOR_ONE,false);

					// extract information for printing - description, quantity
					String sType = sTok.nextToken();

					alias = FrameworkUtil.getAliasForAdmin(context, "type",sType, true);
					String typeIcon6="";
					if ((alias == null) || (alias.equals("")) || (alias.equals("null")))
					{
						typeIcon6 = defaultTypeIcon;
					}
					else
					{
						//typeIcon6 = JSPUtil.getCentralProperty(application, session, alias, "SmallIcon");
						typeIcon6 = "../common/images/iconSmallCADModel.gif";
					}
					
					String sName = sTok.nextToken();
					String sRev = sTok.nextToken();
					String sDescription = sTok.nextToken();
					String sQty = sTok.nextToken();
					String sTitle 		= sTok.nextToken();
					String sQty2 = sTok.nextToken();

%>
              <!--XSSOK-->
              <tr class="<%=sRowClass%>">
                <td width="10%" class=node> <%=i18nNow.getTypeI18NString(sType,languageStr)%>&nbsp </td>
                <td width="20%" class=node>&nbsp
                  <table cellspacing="1" cellpadding="1">
                    <tr>
					  <!--XSSOK-->
                      <td><img src="../common/images/<%=typeIcon6%>" border="0"/></td>
                      <td><xss:encodeForHTML><%=sName%></xss:encodeForHTML></td>
                    </tr>
                  </table>&nbsp
                </td>
				<!--XSSOK-->
                <td width="20%" class=node><%=MCADUtil.escapeStringForHTML(sTitle)%> &nbsp </td>
                <td width="5%" class=node> <xss:encodeForHTML><%=sRev%></xss:encodeForHTML>&nbsp </td>
                <td width="30%" class=node> <xss:encodeForHTML><%=sDescription%></xss:encodeForHTML>&nbsp </td>
                <td width="10%" class=node> <xss:encodeForHTML><%=sQty%></xss:encodeForHTML>&nbsp </td>
                <td width="10%" class=node> <xss:encodeForHTML><%=sQty2%></xss:encodeForHTML>&nbsp </td>
              </tr>
<%
				}
%>
          </table>
<%
			}
			else 
			{
%>
            </table>
            <table align = "center" width = "100%" border="0" cellpadding="0", cellspacing="0">
			  <!--XSSOK-->
              <tr class="<%=sRowClass%>">
                <td align=center><%= i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.Nocommonitemsfortodisplay", "emxIEFDesignCenterStringResource", languageStr) %></td>
              </tr>
             </table>
<%
			}
		}
	}
%>
<br>
<br>
</body>
</html>
