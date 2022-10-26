<%--  emxInfoRelationshipDetailsDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoRelationshipDetailsDialog.jsp $
  $Revision: 1.3.1.3.1.1$
  $Author: ds-kmahajan$

--%>

<%--
 *
 * $History: emxInfoRelationshipDetailsDialog.jsp $
 * 
 * *****************  Version 22  *****************
 * User: Rahulp       Date: 10/02/03   Time: 17:09
 * Updated in $/InfoCentral/src/infocentral
 *
 * ***********************************************
 *
--%>
<%@ page import="com.matrixone.MCADIntegration.uicomponents.beans.*" %>
<%@ page import="com.matrixone.MCADIntegration.server.beans.*" %>
<%@ page import="com.matrixone.MCADIntegration.utils.*" %>
<%@include file= "../common/emxNavigatorInclude.inc"%>
<%@include file="emxInfoUtils.inc"%>            
<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<%--Put IEF Menu Name in session--%>
<html>
<head>
<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIDefaultPF.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIList.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIForm.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIDialog.css" type="text/css" ><!--This is required for the cell (td) back ground colour-->
<link rel="stylesheet" href="../emxUITemp.css" type="text/css">
<!-- content begins here -->
<%
	boolean isConnectedToBaseline = false;
%>
<script language="JavaScript">

    //To check the Textfield for nonNumeric Charecters
    function isNumeric(varTextBox) 
    {
        var varNum = varTextBox.value;
        if(isNaN(varNum) == true) 
        {
            alert(      "<%=i18nStringNowLocal("emxIEFDesignCenter.Relationship.AlertMsgEnterNumericValue",request.getHeader("Accept-Language"))%>"
            );
            varTextBox.focus();
        }
    }
    function changeTextValue(comboName,fieldName){
    var editForm = document.editRelationshipAttributesForm;
    var comboValue;
    for (var i=0;i < editForm.elements.length;i++)
    {
                var xe = editForm.elements[i];
                if (xe.name==comboName)
                    comboValue=xe.options[xe.selectedIndex].value;
                    
    }
    for (var i=0;i < editForm.elements.length;i++)
           {
                var xe = editForm.elements[i];
                if (xe.name== fieldName)
                    xe.value = comboValue;
                    
           }
    }

    //Function to submit the variables
    function doneMethod() 
    {
	if(document.editRelationshipAttributesForm){
		var isConnected = document.editRelationshipAttributesForm.connectedToBaseline.value;
		if(isConnected == "true")
		{
			alert("<%=i18nStringNowLocal("emxIEFDesignCenter.Relationship.BaselinePresentOnParent",request.getHeader("Accept-Language"))%>");
		}
		else
		{			
			var actBarUrl = "emxInfoRelationshipDetails.jsp?integrationName=" + "<%=emxGetParameter(request, "integrationName")%>";
			document.editRelationshipAttributesForm.action = actBarUrl;
	        document.editRelationshipAttributesForm.submit();
		}
	} else {
	parent.window.close();
	}

    }

    //function to open the object details in a pop up
    function openObjectDetails( varObjectID , varTreeMenuName )
    {    
        var objDetailsURL = "../common/emxTree.jsp?objectId=" + varObjectID;		
        window.open( objDetailsURL,'','toolbar=no,status=no,scrollbars=yes, resizable=yes,location=no,menubar=no,directories=no,width=700,height=500');
    }   
</script>
<%@include file = "../common/emxUIConstantsInclude.inc"%>
<script language="JavaScript" src="../common/scripts/emxUICalendar.js"></script>
<script language="JavaScript" src="../common/scripts/emxUIModal.js"></script>
</head>
<%!
	public boolean checkLicense(Context context, MCADIntegrationSessionData integSessionData, String integrationName) throws Exception{
	boolean bRet = false;
	
	try
	{
		Hashtable parametersTable = new Hashtable();
		parametersTable.put("IntegrationName",integrationName);
		
		//if no license is available for user then checkLicenseForDesignerCentral() throws exception
		IEFLicenseUtil.checkLicenseForDesignerCentral(context, parametersTable, integSessionData);
		bRet=true;
	}
	catch(Exception e)
	{
	bRet=false;
		throw e;
	}
	return bRet;
 }
 
  public String replaceString(String str,String replace,String newString){
      while(str.indexOf(replace)!=-1){
          int index =str.indexOf(replace);
          String restStr=str.substring(index+replace.length());
          str=str.substring(0,index)+newString+restStr;
      }
      return str;
  }

  private float getQuantityAttributeValue(Context _context, String fromBusId, String toBusId,MCADGlobalConfigObject _globalConfig, String relName) throws Exception
  {
	  float  quantity = 0.0F;
	  String quantityAttrActualName    = MCADMxUtil.getActualNameForAEFData(_context, "attribute_Quantity");
	  
	  String childIdBusSelect          = new StringBuffer("from[").append(relName).append("].to.id").toString();
	  String quantityAttrBusSelect     = new StringBuffer("from[").append(relName).append("].attribute[").append(quantityAttrActualName).append("]").toString();
	  
	  StringList busSelectionList      = new StringList();
      busSelectionList.add(childIdBusSelect);
      busSelectionList.add(quantityAttrBusSelect);
      
      BusinessObjectWithSelectList busWithSelectionListLtd = BusinessObject.getSelectBusinessObjectData(_context, new String[]{fromBusId}, busSelectionList);
      BusinessObjectWithSelect buss     = busWithSelectionListLtd.getElement(0);
      StringList objectIdList           = buss.getSelectDataList(childIdBusSelect);
      StringList quantityList           = buss.getSelectDataList(quantityAttrBusSelect);
      
      for(int i = 0 ; i < objectIdList.size() ; i++) 
      {
      	String objectId = (String)objectIdList.get(i);
      	if(toBusId.equals(objectId)) 
      	{
      		String quantityAsString = (String)quantityList.get(i);
      		if(quantityAsString != null && !quantityAsString.equals("")) 
      		{
      			quantity = quantity + Float.valueOf(quantityAsString); 			
      		}
      	}
      }
	  return quantity;
  }
%>

<%
boolean doesUserHaveLicense = false;
    try 
    {
		MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
		MCADMxUtil _util							= new MCADMxUtil(context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
		String quantityAttrActualName        	    = MCADMxUtil.getActualNameForAEFData(context, "attribute_Quantity");

		double tz = (new Double((String)session.getValue("timeZone"))).doubleValue();
        String sRelId         = emxGetParameter(request, "relId");
        String sBusId         = emxGetParameter(request, "objectId");
        String sRowColor      = "odd";
        int iModifyAccess = 1;
        boolean bModifyAccess = false;
        //Open the relationship object
        Relationship relGeneric = new Relationship(sRelId);
        relGeneric.open(context);

        String sRelType       = relGeneric.getTypeName();
        //Get the details of the BO at the 'From' end
        BusinessObject boFrom = relGeneric.getFrom();
        boFrom.open(context);

        String sFromId        = boFrom.getObjectId();
		String sActualFromId  = sFromId;
        String sFromMenuName  = "";//getINFMenuName( request, context, sFromId );
        String sFromType      = boFrom.getTypeName();
        String sFromName      = boFrom.getName();
        String sFromRev       = boFrom.getRevision();
        bModifyAccess		  = boFrom.checkAccess(context, (short)iModifyAccess);
        
		String integrationName				   = _util.getIntegrationName(context, sFromId);
		doesUserHaveLicense = checkLicense(context,integSessionData, integrationName);
		
		
		IEFBaselineHelper baseLineHelper	   = new IEFBaselineHelper(context,integSessionData,integrationName);
		MCADGlobalConfigObject _globalConfig   = integSessionData.getGlobalConfigObject(integrationName,integSessionData.getClonedContext(session));

		isConnectedToBaseline	= baseLineHelper.isBaselineRelationshipExistsForId(context, sFromId);			
		
		boFrom.close(context);
        //Get the details of the BO at the 'To' end
        BusinessObject boTo   = relGeneric.getTo();
        boTo.open(context);
        String sToId          = boTo.getObjectId();		
        String sToMenuName    = "";//getINFMenuName( request, context, sToId );
        String sToType        = boTo.getTypeName();
        String sToName        = boTo.getName();
        String sToRev         = boTo.getRevision();  
        boTo.close(context);

        float  quantity          = 1.0F; 
        	
  	    if(!_globalConfig.isExpandedSubComponent())
  	    	quantity = getQuantityAttributeValue(context, sFromId, sToId, _globalConfig,sRelType);
        
        //Get the attributes on the relationship
        AttributeList attrListGeneric = relGeneric.getAttributes(context);
        relGeneric.close(context);

        int iAttrListSize = attrListGeneric.size();
        //Get the relationship cardinality, fromTypes, toTypes and uponRevision attributes
        RelationshipType relTypeGeneric = new RelationshipType(sRelType);
        relTypeGeneric.open(context);

        int iFromCardinality  = relTypeGeneric.getFromCardinality();
        int iToCardinality    = relTypeGeneric.getToCardinality();
        String sFromTypes     = null;
        String sToTypes       = null;
        if (relTypeGeneric.getFromAllTypesAllowed() == true)
            sFromTypes = "[All]";
        else
        {
            BusinessTypeList btListFromTypes = relTypeGeneric.getFromTypes(context);
            sFromTypes					     = btListFromTypes.toString();
        }
        if (relTypeGeneric.getToAllTypesAllowed() == true)
            sToTypes = "[All]";
        else
        {
            BusinessTypeList btListToTypes =  relTypeGeneric.getToTypes(context);
            sToTypes					   = btListToTypes.toString();
        }
        int iFromRelUponRev    = relTypeGeneric.getFromUponRevision();
        int iToRelUponRev      = relTypeGeneric.getToUponRevision();
        String sFromMeaning    = relTypeGeneric.getFromMeaning();
        String sToMeaning      = relTypeGeneric.getToMeaning();
             
        String sFromMeaningStr = "";
        String sToMeaningStr = "";
       
        String temp1 = "";
        
        StringTokenizer sFromMeaningTokenizer = new StringTokenizer(sFromMeaning, ",");
        StringTokenizer sToMeaningTokenizer = new StringTokenizer(sToMeaning, ",");
         while(sFromMeaningTokenizer.hasMoreTokens())
        {
            temp1   = MCADMxUtil.getNLSName(context, "Type", sFromMeaningTokenizer.nextToken(), "", "", request.getHeader("Accept-Language"));
            if((sFromMeaningTokenizer.countTokens())>0)
            {
                temp1 = temp1 +", ";
            }
            sFromMeaningStr = sFromMeaningStr + temp1;
 
        }
        while(sToMeaningTokenizer.hasMoreTokens())
        {
            temp1   = MCADMxUtil.getNLSName(context, "Type", sToMeaningTokenizer.nextToken(), "", "", request.getHeader("Accept-Language"));
            if((sToMeaningTokenizer.countTokens())>0)
            {
            	temp1 = temp1 +", ";
            }
            sToMeaningStr = sToMeaningStr + temp1;
 
        }
        
   
        String sFormTypeString = sFromTypes.substring(1,sFromTypes.length()-1);
        String temp			   = "";
        String convert		   = "";
        String sFormTypeStringResult	= "" ;
        StringTokenizer stringtokenizer = new StringTokenizer(sFormTypeString, ",");
        while(stringtokenizer.hasMoreTokens())
        {
            temp	= stringtokenizer.nextToken();
            temp	= temp.trim();
            convert =i18nNow.getMXI18NString(temp,"",request.getHeader("Accept-Language"),"Type");
            sFormTypeStringResult = sFormTypeStringResult +", " + convert;
        }
        if(sFormTypeStringResult.length()!=0)
            sFormTypeStringResult = sFormTypeStringResult.substring(1);
        else 
            sFormTypeStringResult = sFromType;

        String sFromRelUponrev =((iFromRelUponRev == 0) ?"None" : ((iFromRelUponRev == 1)?"Float":"Replicate"));
        String sToTypeString   = sToTypes.substring(1,sToTypes.length()-1);
        String tempTo		   = "";
        String convertTo	   = "";
        String sToTypeStringResult = "";
        StringTokenizer stringtokenizerTo = new StringTokenizer(sToTypeString, ",");
        while(stringtokenizerTo.hasMoreTokens())
        {
            tempTo = stringtokenizerTo.nextToken();
            tempTo = tempTo.trim();
            convertTo =i18nNow.getMXI18NString(tempTo,"",request.getHeader("Accept-Language"),"Type");
            sToTypeStringResult = sToTypeStringResult +", " + convertTo;
        }
        if(sToTypeStringResult.length()!=0)
            sToTypeStringResult = sToTypeStringResult.substring(1);
        else
            sToTypeStringResult = sToType ;
        String sToRelUponrev  = ((iToRelUponRev == 0) ?"None" : ((iToRelUponRev == 1)?"Float":"Replicate"));
        relTypeGeneric.close(context);
    //--Cue-Tip-Start------ 
       String sCueClassName = emxGetParameter(request,"strCueClassName");
       String sObjeTip = emxGetParameter(request,"strObjTip");   
       String sCueStyle = emxGetParameter(request,"strCueClassStyle");   
       if(sCueStyle!=null){
       sCueStyle= sCueStyle.replace('$', '>');
       sCueStyle= sCueStyle.replace('@', '<');
       sCueStyle= sCueStyle.replace('+', ' ');
       }
    //--Cue-Tip-End------ 

%>

<body class="content">
<form name="editRelationshipAttributesForm" method="post" onSubmit="return false">

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


    <input type="hidden" name="relId" value="<xss:encodeForHTMLAttribute><%=sRelId%></xss:encodeForHTMLAttribute>">
    <input type="hidden" name="objectId" value="<xss:encodeForHTMLAttribute><%=sBusId%></xss:encodeForHTMLAttribute>">
    <input type="hidden" name="tableName" value="">
    <input type="hidden" name="isAdminTable" value="false">
    <!--Cue-Tip-Start-->
    <input type=hidden name="strCueClassName" value="<xss:encodeForHTMLAttribute><%=sCueClassName%></xss:encodeForHTMLAttribute>">
    <input type=hidden name="strObjTip" value="<xss:encodeForHTMLAttribute><%=sObjeTip%></xss:encodeForHTMLAttribute>">
	<!--XSSOK-->
    <input type=hidden name="strCueClassStyle" value="<%=sCueStyle%>">
	<!--XSSOK-->
	<input type=hidden name="connectedToBaseline" value="<%=isConnectedToBaseline%>">
    <!--Cue-Tip-End-->

    <table border="0" cellspacing="0" cellpadding="0" width="100%">
    <tr><td><img src="images/utilSpace.gif" width="1" height="20"></td></tr>
    <tr>
      <td><img src="images/utilSpace.gif" width="1" height="1"></td>
    </tr>
    </table>
    <table border="0" width="100%" cellpadding="4">
        <tr>
        <td class="pageSubheader">
            
			<!--XSSOK-->
            <%=MCADMxUtil.getNLSName(context, "Relationship", sRelType, "", "", request.getHeader("Accept-Language"))%>&nbsp;&nbsp;           <%=i18nStringNowLocal("emxIEFDesignCenter.Common.From",request.getHeader("Accept-Language"))%>  
            &nbsp;
            <a href="javascript:openObjectDetails('<%=XSSUtil.encodeForJavaScript(context,sActualFromId)%>' , '<%=XSSUtil.encodeForJavaScript(context,sFromMenuName)%>');">
			<!--XSSOK-->
            <%=MCADMxUtil.getNLSName(context, "Type", sFromType, "", "", request.getHeader("Accept-Language"))%>&nbsp;<%=sFromName%>&nbsp;<%=sFromRev%>
            </a>
            &nbsp;<%=i18nStringNowLocal("emxIEFDesignCenter.Common.To",request.getHeader("Accept-Language"))%>
            &nbsp;          
            <a href="javascript:openObjectDetails('<%=XSSUtil.encodeForJavaScript(context,sToId)%>' , '<%=XSSUtil.encodeForJavaScript(context,sToMenuName)%>');">
			<!--XSSOK-->
            <%=MCADMxUtil.getNLSName(context, "Type", sToType, "", "", request.getHeader("Accept-Language"))%>&nbsp;<%=sToName%>&nbsp;<%=sToRev%>
            </a>
        </td>
    </tr>
    </table>
  
    <table border="0" width="710" cellpadding="0" cellspacing="0" class="formBG">
        <tr><td colspan="2">&nbsp;</td></tr>
        <tr>
        <td width="10"><img src="images/utilSpace.gif" width="10" height="1"></td>
        <td>
        <!-- Begin form field table -->
        <table border="0" width="700">
            <tr>
                <td colspan="3" class="pageSubheader">
				<!--XSSOK-->
            <%=i18nStringNowLocal("emxIEFDesignCenter.Common.From",request.getHeader("Accept-Language"))%>&nbsp;&nbsp;
			    <!--XSSOK-->
                <%=MCADMxUtil.getNLSName(context, "Type", sFromType, "", "", request.getHeader("Accept-Language"))%>&nbsp;
				<!--XSSOK-->
                <%=sFromName%>&nbsp;<%=sFromRev%></td>
            </tr>
            <tr>
                <td colspan="3"><img src="images/utilSpace.gif" width="1" height="1"></td>
            </tr>
            <tr>
                <td class="label" width="25%"><%=i18nStringNowLocal("emxIEFDesignCenter.Relationship.Meaning",request.getHeader("Accept-Language"))%>   
                </td>
				<!--XSSOK-->
                <td class="field" colspan="2"><%=sFromMeaningStr%>&nbsp;</td>
            </tr>
            <tr>
                <td class="label" width="25%">
                    <%=i18nStringNowLocal("emxIEFDesignCenter.Relationship.Types",request.getHeader("Accept-Language"))%>       
                </td>
				<!--XSSOK-->
                <td class="field" colspan="2"><%=sFormTypeStringResult%>&nbsp;</td>
            </tr>
            <tr>
                <td class="label" width="25%">  
<%=i18nStringNowLocal("emxIEFDesignCenter.Relationship.Cardinality",                        request.getHeader("Accept-Language"))%>                         
                </td>
<%
        if (iFromCardinality == 0) 
        {
%>
                <td class="field" colspan="2">      <%=i18nStringNowLocal("emxIEFDesignCenter.Relationship.One",    request.getHeader("Accept-Language"))%>
    </td>
<%
        } 
        else 
        {
%>
                <td class="field" colspan="2">            <%=i18nStringNowLocal("emxIEFDesignCenter.Relationship.Many", request.getHeader("Accept-Language"))%> </td>
<%
        }
%>
            </tr>
            <tr>
                <td class="label" width="25%">  <%=i18nStringNowLocal("emxIEFDesignCenter.Relationship.UponRevision",   request.getHeader("Accept-Language"))%> </td>
				<!--XSSOK-->
                <td class="field" colspan="2"><%=sFromRelUponrev%></td>
            </tr>
            <tr>
            <td colspan="3" >&nbsp;</td>
            </tr>
            <tr>
                <td class="pageSubheader" colspan="3">
				<!--XSSOK-->
    <%=i18nStringNowLocal("emxIEFDesignCenter.Common.To",request.getHeader("Accept-Language"))%>
    &nbsp;&nbsp;
	<!--XSSOK-->
	<%=MCADMxUtil.getNLSName(context, "Type", sToType, "", "", request.getHeader("Accept-Language")) %>&nbsp;
	            <!--XSSOK-->
                <%=sToName%>&nbsp;<%=sToRev%></td>
            </tr>
            <tr>
                <td  colspan="3"><img src="images/utilSpace.gif" width="1" height="1"></td>
            </tr>
            <tr>
                <td class="label" width="25%">      
    <%=i18nStringNowLocal("emxIEFDesignCenter.Relationship.Meaning",request.getHeader("Accept-Language"))%>
                    
                </td>
				<!--XSSOK-->
                <td class="field" colspan="2"><%=sToMeaningStr%>&nbsp;</td>
            </tr>
            <tr>
                <td class="label" width="25%">                  <%=i18nStringNowLocal("emxIEFDesignCenter.Relationship.Types",request.getHeader("Accept-Language"))%>
                    </td>
			    <!--XSSOK-->
                <td class="field" colspan="2"><%=sToTypeStringResult%>&nbsp;</td>
            </tr>
            <tr>
                <td class="label" width="25%">              <%=i18nStringNowLocal("emxIEFDesignCenter.Relationship.Cardinality",request.getHeader("Accept-Language"))%>
                    </td>
<%
        if (iToCardinality == 0) 
        {
%>
                <td class="field" colspan="2">
<%=i18nStringNowLocal("emxIEFDesignCenter.Relationship.One",request.getHeader("Accept-Language"))%>
    </td>
<%
        } 
        else 
        {
%>
                <td class="field" colspan="2">
<%=i18nStringNowLocal("emxIEFDesignCenter.Relationship.Many",request.getHeader("Accept-Language"))%>    
</td>
<%
        }
%>
            </tr>
            <tr>
                <td class="label" width="25%">
<%=i18nStringNowLocal("emxIEFDesignCenter.Relationship.UponRevision",request.getHeader("Accept-Language"))%>
</td>
                <!--XSSOK-->
                <td class="field" colspan="2"><%=sToRelUponrev%></td>
            </tr>
            <tr>
                <td colspan="3" >&nbsp;</td>
            </tr>
            <tr>
                <td class="pageSubheader" colspan="3">
<%=i18nStringNowLocal("emxIEFDesignCenter.Common.Attributes",request.getHeader("Accept-Language"))%>

</td>
            </tr>
            <tr>
                <td colspan="3"><img src="images/utilSpace.gif" width="1" height="1"></td>
            </tr>

<%
        if (iAttrListSize == 0) 
        {
%>
            <tr>
                <td colspan="3" class="errorMessage">       <%=i18nStringNowLocal("emxIEFDesignCenter.Relationship.NoAttributesDefined",request.getHeader("Accept-Language"))%>
    
    </td>
            </tr>
<%
        } 
        else 
        {   
            
            AttributeItr attrItrGeneric   = new AttributeItr(attrListGeneric);
            String sAttrName      = null;
            String sAttrValue     = null;
            String sAttrDataType  = null;
            String sAttValue      = "";
        
            String ATTR_RELMODSTATUSINMATRIX  = MCADMxUtil.getActualNameForAEFData(context, "attribute_RelationshipModificationStatusinMatrix"); //IR-642818
                   
            while (attrItrGeneric.next()) 
            {
                Attribute attrGeneric    = attrItrGeneric.obj();
                sAttrName     = attrGeneric.getName();
                sAttrValue    = attrGeneric.getValue();
                sAttrValue = replaceString(sAttrValue,"\"", "&quot;");
                if(sAttrName!=null && !sAttrName.equals("")){
                AttributeType attrTypeGeneric = attrGeneric.getAttributeType();
                attrTypeGeneric.open(context);
                sAttrDataType = attrTypeGeneric.getDataType();
                attrTypeGeneric.close(context);
                if (sRowColor.equals("odd")) 
                {
                    sRowColor  = "even";
                } else 
                {
                    sRowColor  = "odd";
                }
%>
                    <!--XSSOK-->
                    <tr class="<%=sRowColor%>">
					<!-- IR-642818 -->
<%					
					boolean isRelModStaMatrixAttr = sAttrName.equalsIgnoreCase(ATTR_RELMODSTATUSINMATRIX);
					if(!isRelModStaMatrixAttr){
					%>
                    <td class="label" width="25%" valign="top"><%=i18nNow.getMXI18NString(sAttrName, "", request.getHeader("Accept-Language"),"Attribute")%></td>
					<%				    
					}  
					%>

<%
                if (attrGeneric.hasChoices()) 
                {
                    if(bModifyAccess) 
                    {
%>                         
                        <td class="field" align="left"  >
						<!--XSSOK-->
                        <select name="<%=sAttrName+"_combo"%>" onChange="changeTextValue('<%=sAttrName+"_combo"%>','<%=sAttrName%>')" >
<%
  
                        StringItr sItrGeneric = new StringItr(attrGeneric.getChoices());
                        String sCurrentAttrValue = null;
                        String  sValue = "";
                        while (sItrGeneric.next()) 
                        {
                            sValue = sItrGeneric.obj();
                            String selected="";
                            if((sAttrDataType.equals("real") || sAttrDataType.equals("integer"))&& !sAttrValue.equals("")){
                             double f1 = new Double(sAttrValue).doubleValue();
                             double f2 = new Double(sValue).doubleValue();
                             if(f1==f2)
                               selected="selected";
                            }
                            else{
                            if(sValue.equals(sAttrValue))
                                selected="selected";;
                            }
%>  
                            <!--XSSOK-->
                            <option <%=selected%>  value="<%=sValue%>"  >
                            <%=i18nNow.getMXI18NString(sValue,sAttrName, request.getHeader("Accept-Language"),"Range")%></option>
<%  
                            
                        }
%>
                            </select>
<%
                        String sAttrTxtValue = "";
                        //if it is timestamp type then display calendar chooser
                        if (sAttrDataType.equals("timestamp")) 
                        {
//                          sAttrValue
                            sAttValue = sAttrValue;
                            //To get the value of the text field
                        //  if (emxGetParameter(request, sAttrName)!= null) 
                        //    {
                        //      sAttValue = emxGetParameter(request, sAttrName);
                        //  }
%>
                            <a href="javascript:showCalendar('editRelationshipAttributesForm','<%=XSSUtil.encodeForJavaScript(context,sAttrName)%>','');"><img src="images/iconCalendarSmall.gif" border=0></a>
<%       
                        }  
%>
    </td>
<%
                    } //end of if(bModifyAccess) 
                    else 
                    {
%>
                            <td class="field" colspan="2"><%=i18nNow.getMXI18NString(sAttrValue,sAttrName, request.getHeader("Accept-Language"),"Range")%> &nbsp;</td>
<%                  }
                } 
                else if (sAttrDataType.equals("real") 
                    || sAttrDataType.equals("integer")) 
                {
                   if(sAttrName.equalsIgnoreCase(quantityAttrActualName)) 
                    {
%>
                       <!--XSSOK-->
                	   <td class="field" colspan="2"  ><%=quantity%><input type="hidden" name="<%=sAttrName%>" value="<%=quantity%>"> &nbsp;</td>
<%                  }
                    else if(!bModifyAccess)
                    {
%>
                      <!--XSSOK-->
                      <td class="field" colspan="2" ><%=sAttrValue%><input type="hidden" name="<%=sAttrName%>" value="<%=sAttrValue%>"> &nbsp;</td>
<%                  } 
                    else 
                    {
%>
                            <!--XSSOK-->
                            <td class="field" colspan="2" ><input type="text" name="<%=sAttrName%>" value="<%=sAttrValue%>" onBlur=isNumeric(this)></td>
<%                  }

                } 
                else if (sAttrDataType.equals("timestamp")) 
                {
                    sAttValue = sAttrValue;
                    //To get the text value
                //  if(emxGetParameter(request, sAttrName)!= null) 
              //      {
                //      sAttValue = emxGetParameter(request, sAttrName);
                //  }
                    if(bModifyAccess) 
                    {
%>
                            <!--XSSOK-->
                            <td class="field" colspan="2"><input type="text" name="<%=sAttrName%>" value="<%=com.matrixone.apps.domain.util.eMatrixDateFormat.getFormattedDisplayDate(sAttValue, tz, request.getLocale())%>" >&nbsp;&nbsp;<a href="javascript:showCalendar('editRelationshipAttributesForm','<%=XSSUtil.encodeForJavaScript(context,sAttrName)%>','');"><img src="images/iconCalendarSmall.gif" border=0></a></td>
<%                  } 
                    else 
                    {
%>
                            <!--XSSOK-->
                            <td class="field" colspan="2"><%=com.matrixone.apps.domain.util.eMatrixDateFormat.getFormattedDisplayDate(sAttValue, tz, request.getLocale())%> &nbsp;</td>
<%                  }

                }
                 else if (sAttrDataType.equals("boolean")) 
                {
                    sAttValue = sAttrValue;
                    String selted ="";
                    if ( sAttValue.equalsIgnoreCase("FALSE"))
                       selted="selected";
                    if(bModifyAccess) 
                    {
					String attrExcludeFromBOM		= MCADMxUtil.getActualNameForAEFData(context, "attribute_IEF-ExcludeFromBOM");
%>
                            <td class="field" colspan="2">
							<!--XSSOK-->
							<%
							if(sAttrName.equalsIgnoreCase(attrExcludeFromBOM))
							{
							%>
                            <!--XSSOK-->
							<input type="text" name="<%=sAttrName%>" value = "<%=sAttValue%>" hidden>
                            <select name="<%=sAttrName%>" disabled>
							<%
							}
							else
							{
							%>
							<!--XSSOK-->
                            <select name="<%=sAttrName%>" >
							<%
							}
							%>
                            <option   value="TRUE"  >TRUE</option>
							<!--XSSOK-->
                            <option <%=selted%>  value="FALSE"  >FALSE</option>
                            </td>
<%                  } 
                    else 
                    {
%>
                            <!--XSSOK-->
                            <td class="field" colspan="2"><%=sAttValue%> &nbsp;</td>
<%                  }

                } 
                else if (attrGeneric.isMultiLine()) 
                {
                    if(bModifyAccess) 
                    {
%>
                        <!--XSSOK-->
<%
						if(isRelModStaMatrixAttr){ //IR-642818
						%>
							<input type="text" name="<%=sAttrName%>" value = "<%=sAttValue%>" hidden>
						<%							
						}
						else
						{
						%> 
                        <td class="field" colspan="2"><textarea name="<%=sAttrName%>" rows="5" cols="40" wrap><%=sAttrValue%></textarea></td>                  
<%						}
                    } 
                    else 
                    {
%>
                        <!--XSSOK-->
						<%                         
						if(isRelModStaMatrixAttr){ //IR-642818
						%>
							<input type="text" name="<%=sAttrName%>" value = "<%=sAttValue%>" hidden>
						<%							
						}
						else
						{
						%> 
                        <td class="field" colspan="2"><%=sAttrValue%> &nbsp;</td> 
<%                  }
                } 
                } 
                else 
                {
                    if(bModifyAccess) 
                    {
%>
                            <!--XSSOK-->
                            <td class="field" colspan="2"><input type="text" name="<%=sAttrName%>" value="<%=sAttrValue%>"  ></td>
<%
                    } 
                    else 
                    {
%>                          <!--XSSOK-->
                            <td class="field" colspan="2"><%=sAttrValue%> &nbsp;</td>
<%                  }
                }
%>
                    </tr>
<%
            }
            }//end of while (attrItrGeneric.next()) 
        }
%>
            </table>
            <!-- End form field table -->
            </td>
        </tr>
        <tr>
            <td colspan="3" >&nbsp;</td>
        </tr>
    </table>
    &nbsp;
    <table border="0" cellpadding="0" cellspacing="0" width="100%" >
    <tr>
    <td align="right">
    <table border="0">
    <tr>
<%
    } 
    catch (Exception e) 
    {
        String msg = e.getMessage();
        msg= msg.replace('\n',' ');
        msg= msg.replace('\r',' ');
		
		String sBusPref = i18nStringNowLocal("emxIEFDesignCenter.Common.BusinessObject",request.getHeader("Accept-Language"));
		if(!doesUserHaveLicense){
			sBusPref = "";
		}
%>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class="errorMessage">
<%=sBusPref%>
    <!--XSSOK-->
    <%=msg%></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    </table>
<%
        return;
    }
%>
    </tr>
    </table>
    </td>
    </tr>
    </table>

</form>
</body>

</html>
<!-- content ends here -->

