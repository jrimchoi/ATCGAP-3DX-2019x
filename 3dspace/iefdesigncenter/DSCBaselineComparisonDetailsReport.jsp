<%--  DSCBaselineComparisonDetailsReport.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  DSCBaselineComparisonDetailsReport.jsp   -    Print details of reports for comparing Baseline's 

--%>

<html>
<head>
<%@ page import = "com.matrixone.apps.common.util.*"%>
<%@include file = "emxInfoCentralUtils.inc"%>
<%@page import ="com.matrixone.MCADIntegration.server.beans.*,com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.*" %>
<%!
  private HashMap getBaseLineObjIdQuantityMap(String baselineId, HashMap BaselineCompareMap)
  {
	HashMap  objIDQuantityMap = new HashMap();
	if(BaselineCompareMap != null && BaselineCompareMap.size() > 0)
	{
		Vector baselineStructureDetails1	=  (Vector)BaselineCompareMap.get(baselineId);
		
		if(baselineStructureDetails1 != null)
		{
			for (int i = 0 ;i < baselineStructureDetails1.size() ;i++)
			{
				Hashtable structDetailsTable = (Hashtable)baselineStructureDetails1.get(i);						
				String busId     = (String)structDetailsTable.get("id");					
				String quantity  = (String)structDetailsTable.get("quantity");
				objIDQuantityMap.put(busId,quantity);
			}	
		}
	}	
	return objIDQuantityMap;
  }
%>
<script language="JavaScript" src="../common/scripts/emxUIModal.js"></script>

<%
    String printerfriendly = emxGetParameter(request, "PrinterFriendly");
    String languageStr     = request.getHeader("Accept-Language");
%>

 <script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script>
 <script type="text/javascript">
          addStyleSheet("emxUIDefault");
          addStyleSheet("emxUIList");
 </script>

<%
	
	MCADIntegrationSessionData integSessionData		= (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
	MCADServerResourceBundle serverResourceBundle	= new MCADServerResourceBundle(request.getHeader("Accept-Language"));

	String baseLineId1 = emxGetParameter(request, "baseLineId1");
	String baseLineId2 = emxGetParameter(request, "baseLineId2");
	
	java.util.List UniqueBusIds1	 = new ArrayList();
	java.util.List UniqueBusIds2	 = new ArrayList();
	java.util.List CommonIdList 	 = null;
	HashMap allStructureMap			 = new HashMap();
	String baseLine1Name			 = "";
	String baseLine2Name			 = "";
	String topLevel1Name			 = "";
	String topLevel2Name			 = "";

	BusinessObject baseLine1 = new BusinessObject(baseLineId1);		
	BusinessObject baseLine2 = new BusinessObject(baseLineId2);

	HashMap BaselineCompareMap = null;
	HashMap baseLine1ObjIdQuantityMap = null;
	HashMap baseLine2ObjIdQuantityMap = null;
	
	String sObjectTitle1    		= "";
	String sObjectTitle2    		= "";
	
	if(integSessionData != null)
	{
		Context iefContext		= integSessionData.getClonedContext(session);
		MCADMxUtil util			= new MCADMxUtil(iefContext, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
		
		baseLine1.open(iefContext);
		baseLine1Name	   = baseLine1.getName();
		Attribute tnrAttr1 = baseLine1.getAttributeValues(iefContext, "RootNodeDetails"); 
		topLevel1Name	   = tnrAttr1.getValue();
		baseLine1.close(iefContext);
		String busObjId        = null;

		if(null != topLevel1Name && !"".equals(topLevel1Name) && topLevel1Name.indexOf("|") == -1){
			BusinessObject borootId = new BusinessObject(topLevel1Name);
			borootId.open(iefContext);
			busObjId = borootId.getObjectId(iefContext);
			borootId.close(context);
		} else {
		Enumeration tnrInfo    = MCADUtil.getTokensFromString(topLevel1Name,"|");
		BusinessObject busObj  = new BusinessObject((String)tnrInfo.nextElement(), (String)tnrInfo.nextElement(), (String)tnrInfo.nextElement(),"");
			busObjId        = busObj.getObjectId(iefContext); 
		}

		
		String integrationName = util.getIntegrationName(iefContext, busObjId);
		sObjectTitle1   	   = util.getAttributeForBO(iefContext, busObjId, MCADMxUtil.getActualNameForAEFData(iefContext, "attribute_Title"));	
		
		baseLine2.open(iefContext);
		baseLine2Name	   = baseLine2.getName();
		Attribute tnrAttr2 = baseLine2.getAttributeValues(iefContext, "RootNodeDetails"); 
		topLevel2Name	   = tnrAttr2.getValue();
		baseLine2.close(iefContext);
		String busObjId2        = null;
		if(null != topLevel2Name && !"".equals(topLevel2Name) && topLevel2Name.indexOf("|") == -1){
			BusinessObject borootId = new BusinessObject(topLevel2Name);
			borootId.open(iefContext);
			busObjId2 = borootId.getObjectId(iefContext);
			borootId.close(context);
		} else {
			Enumeration tnrInfo    = MCADUtil.getTokensFromString(topLevel2Name,"|");
			BusinessObject busObj  = new BusinessObject((String)tnrInfo.nextElement(), (String)tnrInfo.nextElement(), (String)tnrInfo.nextElement(),"");
			busObjId2        = busObj.getObjectId(iefContext); 
		}



/*		Enumeration tnr2Info    = MCADUtil.getTokensFromString(topLevel2Name,"|");
		BusinessObject busObj2  = new BusinessObject((String)tnr2Info.nextElement(), (String)tnr2Info.nextElement(), (String)tnr2Info.nextElement(),"");
		String busObjId2        = busObj2.getObjectId(iefContext); */

		sObjectTitle2    	    = util.getAttributeForBO(iefContext, busObjId2, MCADMxUtil.getActualNameForAEFData(iefContext, "attribute_Title"));
		
		MCADGlobalConfigObject globalConfigObject =  integSessionData.getGlobalConfigObject(integrationName,iefContext);
		
		IEFBaselineHelper baseLineHelper		  =  new IEFBaselineHelper(iefContext,integSessionData,integrationName);

		/*get all related id for baseline*/
		String [] baseLineBusIdList = new String [2];
		baseLineBusIdList[0] = baseLineId1;
		baseLineBusIdList[1] = baseLineId2;		
		
		BaselineCompareMap = baseLineHelper.getBaselineStructureDetailsMap(context,baseLineBusIdList);
		
		baseLine1ObjIdQuantityMap = getBaseLineObjIdQuantityMap(baseLineId1,BaselineCompareMap);
		baseLine2ObjIdQuantityMap = getBaseLineObjIdQuantityMap(baseLineId2,BaselineCompareMap);
		
		if(BaselineCompareMap != null && BaselineCompareMap.size() > 0)
		{
			Vector baselineStructureDetails1	=  (Vector)BaselineCompareMap.get(baseLineBusIdList[0]);
			java.util.List busIdList1			= new ArrayList();
			java.util.List busIdList2			= new ArrayList();
			
			if(baselineStructureDetails1 != null)
			{
				for (int i = 0 ;i < baselineStructureDetails1.size() ;i++)
				{
					Hashtable structDetailsTable = (Hashtable)baselineStructureDetails1.get(i);						
					String busId = (String)structDetailsTable.get("id");					
					allStructureMap.put(busId,structDetailsTable);
					busIdList1.add(busId);
				}
			}
		
			Vector baselineStructureDetails2 =  (Vector)BaselineCompareMap.get(baseLineBusIdList[1]);		
			if(baselineStructureDetails2 != null)
			{
				for (int i = 0 ;i < baselineStructureDetails2.size() ;i++)
				{
					Hashtable structDetailsTable = (Hashtable)baselineStructureDetails2.get(i);	
					String busId = (String)structDetailsTable.get("id");
					allStructureMap.put(busId,structDetailsTable);					
					busIdList2.add(busId);
				}
			}
			CommonIdList  = new ArrayList(busIdList1);
			CommonIdList.retainAll(busIdList2);			

			if(busIdList1 != null)
			{
				for(int i = 0; i < busIdList1.size(); i++)
				{
					String busId = (String)busIdList1.get(i);
					if(!CommonIdList.contains(busId))
					{
						UniqueBusIds1.add(busId);
					}
				}
			}
			if(busIdList2 != null)
			{
				for(int i = 0; i < busIdList2.size(); i++)
				{
					String busId = (String)busIdList2.get(i);
					if(!CommonIdList.contains(busId))
					{
						UniqueBusIds2.add(busId);
					}
				}
			}
		}
 	}
	String tmpPageHeading         = i18nNow.getI18nString("emxIEFDesignCenter.BaselineStructure.ComparisonReport", "emxIEFDesignCenterStringResource", languageStr);
	String sCommonComponents      = i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.CommonComponents", "emxIEFDesignCenterStringResource", languageStr);
	String sPart1UniqueComponents = i18nNow.getI18nString("emxIEFDesignCenter.CompareBaseline.Baseline1UniqueComponent", "emxIEFDesignCenterStringResource", languageStr);
	String sPart2UniqueComponents = i18nNow.getI18nString("emxIEFDesignCenter.CompareBaseline.Baseline2UniqueComponent", "emxIEFDesignCenterStringResource", languageStr);

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
    <td class="pageHeader" width="99%">&nbsp;<%=tmpPageHeading%></td>
  </tr>
</table>


<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tr>
<td class="pageBorder"><img src="../common/images/utilSpacer.gif" width="1" height="1" alt=""></td>
</tr>
<tr><td>&nbsp;</td></tr>
</table>
<%
	StringTokenizer token = new StringTokenizer(topLevel1Name,"|");
	String typeTopNode	  = "";
	String nameTopNode	  = "";
	String revTopNode	  = "";

	if(token.hasMoreTokens())
		typeTopNode = (String)token.nextToken();	
	if(token.hasMoreTokens())
		nameTopNode = (String)token.nextToken();
	if(token.hasMoreTokens())
		revTopNode = (String)token.nextToken();

	String typeIcon = "../common/images/iconSmallCADModel.gif";
	
%>	
 
	 <table width="100%" border="0">
        <tr>
          <td align="left">
            <table border ="0" cellspacing="2" cellpadding="1">
              <tr>
                <td><B><%= i18nNow.getI18nString("emxIEFDesignCenter.BaselineStructure.Baseline1", "emxIEFDesignCenterStringResource", languageStr) %>      :</B></td>				 
                <td><%=baseLine1Name%><br></td>                
              </tr>
			  <tr>
			  </tr>
			  <tr>
				  <td><B><%= i18nNow.getI18nString("emxIEFDesignCenter.BaselineStructure.TopNode", "emxIEFDesignCenterStringResource", languageStr) %>:</B><br></td>
				  <td><img src="../images/<%=typeIcon%>"></td>
				  <td><%=typeTopNode%></td>				 
			</tr>
			<tr>				 
				 <td ></td>
				 				 <td ></td>
				  <td><%=nameTopNode%></td>				
			  </tr>
			  <tr>
			   <td></td>
			   				 <td ></td>
			    <td><%=revTopNode%></td>
			  </tr>
			  <tr>				 
				<td ></td>
				<td ></td>
				<td><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Title", "emxIEFDesignCenterStringResource", languageStr) %> :&nbsp;<%= MCADUtil.escapeStringForHTML(sObjectTitle1) %></td>				
			  </tr>
            </table>
          </td>

  <%
		 token = new StringTokenizer(topLevel2Name,"|");
		 typeTopNode = "";
		 nameTopNode = "";
		 revTopNode = "";
		
		if(token.hasMoreTokens())
			typeTopNode = (String)token.nextToken();
		if(token.hasMoreTokens())
			nameTopNode = (String)token.nextToken();
		if(token.hasMoreTokens())
			revTopNode = (String)token.nextToken();

%>
          <td align="center">
           <table border ="0" cellspacing="2" cellpadding="1">
              <tr>
                <td><B><%= i18nNow.getI18nString("emxIEFDesignCenter.BaselineStructure.Baseline2", "emxIEFDesignCenterStringResource", languageStr) %>:</B></td>				 
                <td><%=baseLine2Name%><br></td>                
              </tr>
			  <tr>
			  </tr>
			  <tr>
				  <td><B><%= i18nNow.getI18nString("emxIEFDesignCenter.BaselineStructure.TopNode", "emxIEFDesignCenterStringResource", languageStr) %>:</B><br></td>
				  <td><img src="../images/<%=typeIcon%>"></td>
				  <td><%=typeTopNode%></td>				 
			</tr>
			<tr>				 
				 <td ></td>
				  <td ></td>
				  <td><%=nameTopNode%></td>				
			  </tr>
			  <tr>
			    <td></td>
			   	<td></td>
			    <td><%=revTopNode%></td>
			  </tr>
			  <tr>
			    <td></td>
			   	<td></td>
			    <td><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Title", "emxIEFDesignCenterStringResource", languageStr) %> :&nbsp;<%=MCADUtil.escapeStringForHTML(sObjectTitle2) %></td>
			  </tr>
            </table>
          </td>
        </tr>
      </table>
<%
		int iOddEven = 1;
		String sRowClass = "odd";
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
        <table width="100%" border="0" cellpadding="0", cellspacing="0">
        <tr>
          <th width="10%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Type", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
          <th width="20%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Name", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
          <th width="20%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Title", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
          <th width="5%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Revisions", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
          <th width="30%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Description", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
          <th width="15%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.Quantity", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
        </tr>

<%
	if(UniqueBusIds1!= null && UniqueBusIds1.size() > 0)
	{
		for(int j = 0 ; j < UniqueBusIds1.size() ; j++)
		{
			//Determine whether row should be shaded or not
			if ((iOddEven%2) == 0) 
				sRowClass = "even";
			else  
				sRowClass = "odd";

			iOddEven++;
			String busId			= (String)UniqueBusIds1.get(j);
			Hashtable objectTable	= (Hashtable)allStructureMap.get(busId);
			
			String type			= (String)objectTable.get("type");
			String sName		= (String)objectTable.get("name");
			String sRev			= (String)objectTable.get("revision");
			String sDescription = (String)objectTable.get("description");
			String sQty			= (String)objectTable.get("quantity");
			String sTitle		= (String)objectTable.get("title");
%>
          <tr class="<%=sRowClass%>">
            <td width="10%" class=node> <%=type%>&nbsp </td>
              <td width="20%" class=node> <table cellspacing="1" cellpadding="1"><tr><td></td><td><%=sName%></td></tr></table></td>
              <td width="20%" class=node> <%=MCADUtil.escapeStringForHTML(sTitle)%>&nbsp </td>
              <td width="5%" class=node> <%=sRev%>&nbsp </td>
              <td width="30%" class=node> <%=sDescription%>&nbsp </td>
              <td width="15%" class=node> <%=sQty%>&nbsp </td>
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
          <tr class="<%=sRowClass%>">
            <td align=center><%= i18nNow.getI18nString("emxIEFDesignCenter.CompareBaseline.Nouniqueitemsforbaseline1todisplay", "emxIEFDesignCenterStringResource", languageStr) %></td>
          </tr>
        </table>
<%
	}
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

       <table width="100%" border="0" cellpadding="0", cellspacing="0">
        <tr>

          <th width="10%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Type", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
          <th width="20%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Name", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
          <th width="20%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Title", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
          <th width="5%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Revisions", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
          <th width="30%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Description", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
          <th width="15%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.Quantity", "emxIEFDesignCenterStringResource", languageStr) %></b></th>

        </tr>

<%
        // if compare hashtable is not empty extract information and print table
		if(UniqueBusIds2!= null && UniqueBusIds2.size() > 0)  
		{				
			for(int j = 0 ; j < UniqueBusIds2.size() ; j++)
			{
				//Determine whether row should be shaded or not
				if ((iOddEven%2) == 0) 
					sRowClass = "even";
				else  
					sRowClass = "odd";

				iOddEven++;
				String busId			= (String)UniqueBusIds2.get(j);
				Hashtable objectTable	= (Hashtable)allStructureMap.get(busId);
				
				String type			= (String)objectTable.get("type");
				String sName		= (String)objectTable.get("name");
				String sRev			= (String)objectTable.get("revision");
				String sDescription =  (String)objectTable.get("description");
				String sQty			= (String)objectTable.get("quantity");
				String sTitle		= (String)objectTable.get("title");
					
%>
          <tr class="<%=sRowClass%>">
            <td width="10%" class=node> <%=type%>&nbsp </td>
              <td width="20%" class=node> <table cellspacing="1" cellpadding="1"><tr><td></td><td><%=sName%></td></tr></table></td>
              <td width="20%" class=node> <%=MCADUtil.escapeStringForHTML(sTitle)%>&nbsp </td>
              <td width="5%" class=node> <%=sRev%>&nbsp </td>
              <td width="30%" class=node> <%=sDescription%>&nbsp </td>
              <td width="15%" class=node> <%=sQty%>&nbsp </td>
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
			<tr class="<%=sRowClass%>">
			  <td align=center><%= i18nNow.getI18nString("emxIEFDesignCenter.CompareBaseline.Nouniqueitemsforbaseline2todisplay", "emxIEFDesignCenterStringResource", languageStr) %></td>
			</tr>
		  </table>
<%
		}
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

    <table width="100%" border="0" cellpadding="0", cellspacing="0">
    <tr>
      <th rowspan="2" width="10%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Type", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
      <th rowspan="2" width="20%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Name", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
      <th rowspan="2" width="20%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Title", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
      <th rowspan="2" width="5%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Revisions", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
      <th rowspan="2" width="30%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.Common.Description", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
      <th colspan="2" width="15%" class=sorted><b><%= i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.Quantity", "emxIEFDesignCenterStringResource", languageStr) %></b></th>
    </tr>
    <tr>
      <th align="center" nowrap class=sorted><%= i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.Part1", "emxIEFDesignCenterStringResource", languageStr) %></th>
      <th align="center" nowrap class=sorted><%= i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.Part2 ", "emxIEFDesignCenterStringResource", languageStr) %></th>
    </tr>

<%	
		if(CommonIdList != null && CommonIdList.size() > 0) 
		{				
			for(int j=0 ;j <CommonIdList.size() ;j++)
			{
				// determine whether row should be shaded or not
				if ((iOddEven%2) == 0)
					sRowClass = "even";
				else
					sRowClass = "odd";

				iOddEven++;

				String busId			= (String)CommonIdList.get(j);
				Hashtable objectTable	= (Hashtable)allStructureMap.get(busId);

				String type			= (String)objectTable.get("type");
				String sName		= (String)objectTable.get("name");
				String sRev			= (String)objectTable.get("revision");
				String sDescription =  (String)objectTable.get("description");
				String sTitle		= (String)objectTable.get("title");
				String sQty			= (String)baseLine1ObjIdQuantityMap.get(busId);
				String sQty2		= (String)baseLine2ObjIdQuantityMap.get(busId);

%>
              <tr class="<%=sRowClass%>">
                <td width="10%" class=node> <%=type%>&nbsp </td>
                <td width="20%" class=node>&nbsp
                  <table cellspacing="1" cellpadding="1">
                    <tr>
                      <td></td>
                      <td><%=sName%></td>
                    </tr>
                  </table>&nbsp
                </td>
                <td width="20%" class=node> <%=MCADUtil.escapeStringForHTML(sTitle)%>&nbsp </td>
                <td width="5%" class=node> <%=sRev%>&nbsp </td>
                <td width="30%" class=node> <%=sDescription%>&nbsp </td>
                <td width="10%" class=node> <%=sQty%>&nbsp </td>
                <td width="10%" class=node> <%=sQty2%>&nbsp </td>
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
		  <tr class="<%=sRowClass%>">
			<td align=center><%= i18nNow.getI18nString("emxIEFDesignCenter.CompareStructure.Nocommonitemsfortodisplay", "emxIEFDesignCenterStringResource", languageStr) %></td>
		  </tr>
		 </table>
<%
	}

%>
<br>
<br>
</body>
</html>
