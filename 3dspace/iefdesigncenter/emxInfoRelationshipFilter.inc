<%--  emxInfoRelationshipFilter.inc

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/InfoCentral/emxInfoRelationshipFilter.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoRelationshipFilter.jsp $
 * 
 * *****************  Version 3  *****************
 * User: Mallikr      Date: 11/26/02   Time: 5:57p
 * Updated in $/InfoCentral/src/InfoCentral
 * added header
 *
 * ***********************************************
 *
--%>

<%
	String toFrom		= emxGetSessionParameter(request,"toFrom");
	String relationshipName = emxGetSessionParameter(request,"relationshipName");
	String isTemplateType	= emxGetSessionParameter(request, "isTemplateType");

	Vector assemblyLikeRelNames	= new Vector();
		
	String integName							= util.getIntegrationName(integSessionData.getClonedContext(session),objectId);
	MCADGlobalConfigObject globalConfigObject = integSessionData.getGlobalConfigObject(integName,integSessionData.getClonedContext(session));

	if(globalConfigObject != null)
	{
		Hashtable mxRels  = new Hashtable(10);
		String inRelClass = "AssemblyLike";

		globalConfigObject.getMxRelNameDirnTableForClass(mxRels, inRelClass);

		if(mxRels != null)
		{
			Enumeration assemblyLikeRelNamesEnum = mxRels.keys();
			while(assemblyLikeRelNamesEnum.hasMoreElements())
				assemblyLikeRelNames.addElement((String)assemblyLikeRelNamesEnum.nextElement());
		}
	}
	
	if(toFrom==null|| toFrom.equals("null"))
		toFrom="*";
	
	String tochecked="";
	String fromchecked="";
	
	if(toFrom.equals("to"))
		tochecked="checked";
	
	if(toFrom.equals("from"))
		fromchecked="checked";
	
	if(toFrom.equals("*"))
	{ 
		tochecked="checked";
		fromchecked="checked";
	}
%>
    <table border="0" width="100%" cellspacing="0" cellpadding="0">
    <tr>
    <td align="left">&nbsp;</td>
	<!--XSSOK-->
    <td width="2%" nowrap><input type="checkbox" name="toDirection"  <%=tochecked%> ></td>
	<!--XSSOK-->
    <td width="25%"nowrap>&nbsp;<%=FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Common.To", request.getHeader("Accept-Language"))%></td>
	<!--XSSOK-->
    <td width="2%" nowrap><input type="checkbox" name="fromDirection"  <%=fromchecked%> ></td>
	<!--XSSOK-->
    <td width="25%"nowrap>&nbsp;<%=FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Common.From", request.getHeader("Accept-Language"))%></td>
    <td nowrap><framework:i18n localize="i18nId" >emxIEFDesignCenter.Common.Relationship</framework:i18n>&nbsp;</td>
    <td class="filter"nowrap >
    <select name="relationshipName" >
	<!--XSSOK-->
    <option value ="All" ><%=FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Common.All", request.getHeader("Accept-Language"))%></option>
 <%
          String sRelName = null;
	  BusinessObject  boObject  = null;
	  boObject  = new BusinessObject(objectId);
	  boObject.open(context);
	  String sBustype = null;
	  StringList displayRelNameList = new StringList();
	  Hashtable dispVsActualName    = new Hashtable();
	  BusinessType btConnObj              = boObject.getBusinessType(context);
	  sBustype = btConnObj.getName();
	  btConnObj.open(context);
	  RelationshipTypeList relTypeListObj = btConnObj.getRelationshipTypes(context,true,true,true);
	  btConnObj.close(context);
	  	  			
	  RelationshipTypeItr  relTypeItrObj  = new RelationshipTypeItr(relTypeListObj);
	  while(relTypeItrObj.next())
	  {
		  RelationshipType  relTypeObj      = (RelationshipType) relTypeItrObj.obj();
		  relTypeObj.open(context);
		  sRelName = relTypeObj.getName() ;
		  String displayRelName = i18nNow.getMXI18NString(sRelName,"",request.getHeader("Accept-Language"),"Relationship");
		  displayRelNameList.addElement(displayRelName);
		  dispVsActualName.put(displayRelName, sRelName);
		  displayRelNameList.sort();
		  relTypeObj.close(context); 
	  }

	  Iterator displayRelNameListItr = displayRelNameList.iterator();
	  while(displayRelNameListItr.hasNext())
	  {
		  String displayRelName = (String)displayRelNameListItr.next();
		  sRelName              = (String) dispVsActualName.get(displayRelName);
		  String selected       = "";
		  if(relationshipName!=null && relationshipName.equals(sRelName))
			selected="selected";
		  if(isTemplateType != null && isTemplateType.equalsIgnoreCase("true") && assemblyLikeRelNames.size()>0)
		  {
			if(assemblyLikeRelNames.contains(sRelName))
			{
%>
				<option value = "<%=sRelName%>"  <%=selected%> ><%=displayRelName%></option>
<%
			}
		  }
		  else
		  {
%>
			<option value = "<%=sRelName%>"  <%=selected%> ><%=displayRelName%></option>		
<%
		  }

          }
%>
      </select>
      </td>

    <td align="right">
      <table border="0">
        <tr>
		  <!--XSSOK-->
          <td nowrap><a href="javascript:refreshForConfigTable()" ><img src="images/iconFilter.gif" border="0" alt="<%=FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Common.Refresh", request.getHeader("Accept-Language"))%>"></a></td>
		  <!--XSSOK-->
          <td nowrap ><a href="javascript:refreshForConfigTable()" ><%=FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Common.Refresh", request.getHeader("Accept-Language"))%></a></td>
        </tr>
      </table>
    </td>
    <tr>
    </table>
