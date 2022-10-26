<%--  emxInfoObjectDisplayAttributes.inc

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxInfoObjectDisplayAttributes.inc   - This Page Displays the Attributes of a Business Object
  $Archive: /InfoCentral/src/infocentral/emxInfoObjectDisplayAttributes.inc $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxInfoObjectDisplayAttributes.inc $
 * *****************  Version 33  *****************
 * User: Rajesh G  Date: 02/15/2004    Time: 8:44p
 * Updated in $/InfoCentral/src/infocentral
 * Changed For key pressed check Enter/Tab/Escape
 * ************************************************ *  * 
 * 
 * *****************  Version 32  *****************
 * User: Shashikantk  Date: 1/21/03    Time: 8:44p
 * Updated in $/InfoCentral/src/infocentral
 * ************************************************
 *
--%>
<%--
    This JSP requires following two things in a querystring
        1) ObjectId [e.g emxGetParameter(request, "objectId")] - to create a BusinessObject
        2) hasModify [e.g emxGetParameter(request, "hasModify")] - to show the attributes in edit mode or read mode
--%>
<!-- content begins here --> 
<%!
matrix.util.StringList internalAttributeList=new StringList();
  public String replaceString(String str,String replace,String newString){
      while(str.indexOf(replace)!=-1){
          int index =str.indexOf(replace);
          String restStr=str.substring(index+replace.length());
          str=str.substring(0,index)+newString+restStr;
      }
      return str;
  }
  

      // Call this method to internationalize variables.
      // i18nStringNow("stringid", request.getHeader("Accept-Language"));
    static public String i18nStringNowLocal(String text, String languageStr) 
    {
        String returnString = text;
          com.matrixone.apps.domain.util.i18nNow  infoLoc = new com.matrixone.apps.domain.util.i18nNow();
        String I18NreturnString = infoLoc.GetString("emxIEFDesignCenterStringResource ", languageStr, text);
          if ((!"".equals(I18NreturnString)) && (I18NreturnString != null)){
                  returnString = I18NreturnString.trim();
              }
          return returnString;
    }

    public String checkAttributeForRule(Context context, String sAttributeName){
      String sReturnString="";
      matrix.db.MQLCommand mqlCommand = new MQLCommand();
      String sCommand = "print attribute '" + sAttributeName + "'";
      String sResult ="";
      try 
      {
          mqlCommand.open(context);
          mqlCommand.executeCommand(context, sCommand);
          sResult = mqlCommand.getResult();
          mqlCommand.close(context);
      } 
      catch(Exception me) 
      {
          String sErrorMsg = "print attribute failed: " + me;
          System.out.println("Exception in emxInfoObjectDisplayAttributes.inc in checkAttributeForRule() :: " + sErrorMsg);
      } // End of try-catch
      
      StringTokenizer strTk = new StringTokenizer(sResult,"\n");
      String sVal = "";
      while(strTk.hasMoreTokens()){
         sVal = strTk.nextToken().toString().trim();         
         if((null != sVal) && !("null".equalsIgnoreCase(sVal)) && (sVal.length() !=0)){
            if(sVal.startsWith("rule ")){
                sVal = sVal.substring(sVal.indexOf("rule") + 5);                
                sReturnString = getRuleAccess(context,sVal);                
                break;
            } // End of if(sVal.startsWith("rule "))
         }//End of if
      }// End of while    
      return sReturnString;
  }// End of function
  
  public String getRuleAccess(Context context,String sRuleName){
      String sReturnString="";
      matrix.db.MQLCommand mqlCommand = new MQLCommand();
      String sCommand = "print rule '" + sRuleName + "'";
      String sResult ="";
      boolean bUserReadAccess=true; boolean bUserModifyAccess=true; boolean bUserShowAccess=true; boolean bUserNoneAccess=true;
      boolean bPublicReadAccess=true; boolean bPublicModifyAccess=true; boolean bPublicShowAccess=true; boolean bPublicNoneAccess=true;
      boolean bOwnerReadAccess=true; boolean bOwnerModifyAccess=true; boolean bOwnerShowAccess=true; boolean bOwnerNoneAccess=true;
      
      try 
      {
          mqlCommand.open(context);
          mqlCommand.executeCommand(context, sCommand);
          sResult = mqlCommand.getResult();
          mqlCommand.close(context);
      } 
      catch(Exception me) 
      {
          String sErrorMsg = "print rule failed: " + me;
          System.out.println("Exception in emxInfoObjectDisplayAttributes.inc in getRuleAccess() :: " + sErrorMsg);
      } // End of try-catch
      
      StringTokenizer strTk = new StringTokenizer(sResult,"\n");
      String sVal = "";
      while(strTk.hasMoreTokens()){
         sVal = strTk.nextToken().toString().trim();         
         if((null != sVal) && !("null".equalsIgnoreCase(sVal)) && (sVal.length() !=0)){
            if(sVal.startsWith("user ")){
                if(sVal.indexOf(context.getUser()) >= 0){
                    if(sVal.indexOf("read") >= 0) bUserReadAccess = true; else bUserReadAccess = false;
                    if(sVal.indexOf("modify") >= 0) bUserModifyAccess = true; else bUserModifyAccess = false;
                    if(sVal.indexOf("show") >= 0) bUserShowAccess = true; else bUserShowAccess = false;
                    if(sVal.indexOf("none") >= 0) bUserNoneAccess = true; else bUserNoneAccess = false;
                    break;
                }               
            } // End of if(sVal.startsWith("rule "))
         }//End of if
      }// End of while
      try 
      {
          sCommand = "print rule '" + sRuleName + "' select publicaccess dump";       
          sResult = "";
          mqlCommand.open(context);
          mqlCommand.executeCommand(context, sCommand);
          sResult = mqlCommand.getResult();
          if(sResult.indexOf("read") >= 0) bPublicReadAccess = true; else bPublicReadAccess = false;
          if(sResult.indexOf("modify") >= 0) bPublicModifyAccess = true; else bPublicModifyAccess = false;
          if(sResult.indexOf("show") >= 0) bPublicShowAccess = true; else bPublicShowAccess = false;
          if(sResult.indexOf("none") >= 0) bPublicNoneAccess = true; else bPublicNoneAccess = false;          
          sResult = "";
          sCommand = "print rule '" + sRuleName + "' select owneraccess dump";
          mqlCommand.executeCommand(context, sCommand);
          sResult = mqlCommand.getResult();
          
          if(sResult.indexOf("read") >= 0) bOwnerReadAccess = true; else bOwnerReadAccess = false;
          if(sResult.indexOf("modify") >= 0) bOwnerModifyAccess = true; else bOwnerModifyAccess = false;
          if(sResult.indexOf("show") >= 0) bOwnerShowAccess = true; else bOwnerShowAccess = false;
          if(sResult.indexOf("none") >= 0) bOwnerNoneAccess = true; else bOwnerNoneAccess = false;
          mqlCommand.close(context);
      } 
      catch(Exception me) 
      {
          String sErrorMsg = "print rule failed: " + me;
          System.out.println("Exception in getRuleAccess() :: " + sErrorMsg);
      } // End of try-catch

      boolean bRead = true; boolean bModify = true; boolean bShow = true;
      if(bOwnerReadAccess || bPublicReadAccess || bUserReadAccess) bRead=true; else bRead=false;
      
      if(bOwnerModifyAccess || bPublicModifyAccess || bUserModifyAccess) bModify=true; else bModify=false;
      
      if(bOwnerShowAccess || bPublicShowAccess || bUserShowAccess) bShow=true; else bShow=false;
      
      if(bRead==false && bModify==true) sReturnString = "alert"; else sReturnString = " READONLY onFocus=\"this.blur()\" ";
      if(bRead==true && bModify==true && bShow==true) sReturnString = "";
      return sReturnString;
  }
 public boolean isAttributeEditable(String attrName){
  
  if(internalAttributeList.contains(attrName)){
  return true;
  }
 return false;
 
 }
%>


<%
    try
    {
        String strCellColor;
        String strLabelColor;
	String revModeAttrActualName    = com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_IEF-ObjectBasedConfigurationRevisionMode");
        String sObjId = emxGetParameter(request, "objectId");
    
internalAttributeList.addElement(com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_IEF-ObjectBasedConfigurationRevisionMode"));
       	internalAttributeList.addElement(com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_IEF-FileMessageDigest"));   
       	internalAttributeList.addElement(com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_MCADInteg-InstanceNames"));   
        internalAttributeList.addElement(com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_MCADInteg-InstanceSpecificAttributes"));   
    	internalAttributeList.addElement(com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_CADType"));
       	internalAttributeList.addElement(com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_IEF-FileSource"));
      internalAttributeList.addElement(com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_NewlyCreatedinMatrix"));
      internalAttributeList.addElement(com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_ModifiedinMatrix"));
      internalAttributeList.addElement(com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_MCADLabel"));
      internalAttributeList.addElement(com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_IEF-ConnectedECO"));
      internalAttributeList.addElement(com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_IEF-Specification"));
      internalAttributeList.addElement(com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_RenamedFrom"));
      internalAttributeList.addElement(com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_IEF-EBOMSync-PartTypeAttribute"));
      internalAttributeList.addElement(com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_Originator"));
      internalAttributeList.addElement(com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_IEF-UUID"));
      internalAttributeList.addElement(com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_Title"));
      internalAttributeList.addElement(com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_Source"));
      internalAttributeList.addElement(com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_ModifiedCADAttributes"));
      internalAttributeList.addElement(com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_IEF-ExcludeFromBOM"));
    
    
        BusinessObject boGenericForAttributes = new BusinessObject(sObjId);

	String strForm = (String)request.getAttribute("form");
        //Check if the user has edit access
        int iModifyAccessAttr = 1;
        boolean bHasModifyAttributes;
        String sModifyAccess = emxGetParameter(request, "hasModify");
    
        if(null == sModifyAccess)
        {   
            //Read mode used in object details page
            bHasModifyAttributes = false;
            strLabelColor = "class=\"label\" width=\"25%\"";
            strCellColor = "class=\"field\"";               
        }
        else
        {
            // May be an edit mode
            bHasModifyAttributes = boGenericForAttributes.checkAccess(context, (short)iModifyAccessAttr);
            strLabelColor = "class=\"label\" width=\"25%\"";
            strCellColor = "class=\"field\"";               
        }
        
        if(null != emxGetParameter(request,"PFmode") && "true".equalsIgnoreCase(emxGetParameter(request,"PFmode")))
        {
            //Printer friendly mode
             strLabelColor = "class=\"listCell\"";
             strCellColor = "class=\"listCell\"";
         }
%>
<script language="JavaScript" src="emxInfoUIModal.js"></script>
<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICore.js"></script>
<script language="JavaScript" src="emxInfoCentralJavaScriptUtils.js"></script>
<script language="javascript" src="../common/scripts/emxJSValidationUtil.js"></script>

<%@include file = "../common/emxUIConstantsInclude.inc"%>
<script language="javascript" type="text/javascript" src="../common/scripts/emxUICalendar.js"></script>
<%@include file="emxInfoCalendarInclude.inc"%>

<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIList.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIForm.css" type="text/css">
<%
        if(null == sModifyAccess)
        {   
            //Read Mode
%>    
            <link rel="stylesheet" href="../common/styles/emxUIProperties.css" type="text/css" ><!--This is required for the cell (td) back ground colour-->
            <link rel="stylesheet" href="../common/styles/emxUIDefaultPF.css" type="text/css">
            <link rel="stylesheet" href="../common/styles/emxUIListPF.css" type="text/css">
<%
        }
        else
        {  
            //Edit mode
%>
            <link rel="stylesheet" href="../common/styles/emxUIDialog.css" type="text/css" ><!--This is required for the cell (td) back ground colour-->
<%
        }
%>
        <link rel="stylesheet" href="../emxUITemp.css" type="text/css">

<script language="JavaScript">
      //Validate the Textfield, If nonnumeric Charecters are entered then
      //throw an alert message
      function isNumeric(textBox)
      {
        var bContinue = true;
        var varValue = textBox.value;
        if (isNaN(varValue) == true) 
        {
          alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.ObjectDetails.AlertMsg1</framework:i18nScript>");          
          textBox.focus();
          bContinue = false;
        }
        return bContinue;
      }


    function isBooleanVal(field){
        var sFieldVal = field.value;
        var sTrue = "<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.Attribute.True</framework:i18nScript>";
        var sFalse = "<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.Attribute.False</framework:i18nScript>";
        var bContinue = true;
        if(trimWhitespace(sFieldVal) != ''){
            if((sFieldVal.toLowerCase() != sTrue.toLowerCase()) && (sFieldVal.toLowerCase() != sFalse.toLowerCase()) && 
                (sFieldVal.toLowerCase() != "true") && (sFieldVal.toLowerCase() != "false")){
                alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.EnterBoolean</framework:i18nScript>");             
                field.focus();
                bContinue = false;
            }
        }
        return bContinue;
    }

        var strTxtPeople = null;
        var txtUserField = null;

        function setFieldAndShowUserSelector(fieldName)
        {   
           for (var i=0;i < document.all.idForm.elements.length;i++)
           {
                var xe = document.all.idForm.elements[i];
                if (xe.name == fieldName)
                {
                    strTxtPeople = xe;
                    break;
                }
           }       
        
           showUserSelector();
        }
    
		function submitThis( event , formMethod  )
		{
			if((event.keyCode == 13) || (event.keyCode == 10) || (event.which == 13) || (event.which == 10)) 
			{
				//alert (formMethod )
				if ( formMethod == "done"  )
				{
					parent.frames[1].done();
				}
				else if ( formMethod == "submit"  )
				{
					parent.frames[1].submit();
				}
    
			}
		}

</script>

<%
        String languageStr = request.getHeader("Accept-Language");      
        
        // read the related business object attributes
        DomainObject dmObj = new DomainObject(sObjId);
        Map attrMap = dmObj.getAttributeDetails(context);
//Bug Fix ID:279264 start 
		java.util.Properties mxProperties = null;
		String iDateFormat = "2";
		String strDateFrm = "";
		String sDisplayTime = "false";
		try {
			mxProperties = ServletUtil.getPropertiesFromBundle("emxSystem",application);
			//set the filter pattern for parameters in the Request bean
			if(mxProperties!=null)
			{
				strDateFrm		= mxProperties.getProperty("emxFramework.DateTime.DisplayFormat");
				sDisplayTime	= mxProperties.getProperty("emxFramework.DateTime.DisplayTime");
			}
			else
			{
				strDateFrm		= (String)FrameworkProperties.getProperty("emxFramework.DateTime.DisplayFormat");
				sDisplayTime	= (String)FrameworkProperties.getProperty("emxFramework.DateTime.DisplayTime");
			}
			if("SHORT".equals(strDateFrm))
				iDateFormat = (new Integer(java.text.DateFormat.SHORT)).toString();
			if("MEDIUM".equals(strDateFrm))
				iDateFormat = (new Integer(java.text.DateFormat.MEDIUM)).toString();
			if("LONG".equals(strDateFrm))
				iDateFormat = (new Integer(java.text.DateFormat.LONG)).toString();
			if("FULL".equals(strDateFrm))
				iDateFormat = (new Integer(java.text.DateFormat.FULL)).toString();
    
		}catch(Exception e){
				 System.out.println("Initailization Exception: " + e);
				 mxProperties = null;
		}
//Bug Fix ID:279264 End
        for(Iterator iterator = attrMap.keySet().iterator(); iterator.hasNext();)
        {
            Map valueMap    = (Map)attrMap.get((String)iterator.next());
            String sAttrName = (String)valueMap.get("name");
            String sAttrValue = (String)valueMap.get("value");
            sAttrValue = replaceString(sAttrValue,"\"", "&quot;");
            String sDataType = (String)valueMap.get("type");
            String sAttrMultiLine = (String)valueMap.get("multiline");

            String sAppliedRule = checkAttributeForRule(context,sAttrName);
            if(sAppliedRule.equalsIgnoreCase("alert") && bHasModifyAttributes){
%>
                <script language="javascript">
                    alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.Common.NoReadAcess</framework:i18nScript>");
                    parent.window.close();                  
                </script>
<%              
            break;
            }else{
                boolean bUserList = false;

                sAttrName = sAttrName.trim();
                sAttrValue = sAttrValue.trim();
                sDataType = sDataType.trim();
                
                if (bHasModifyAttributes && !sAttrValue.equalsIgnoreCase("#DENIED!")) 
                {
                    //Edit mode
                    if ((sAttrMultiLine == null) 
                        || ("null".equalsIgnoreCase(sAttrMultiLine)) 
                        || ("".equals(sAttrMultiLine))) 
                    {
                        //Check for multiline
                        matrix.db.MQLCommand mqlCmd = new MQLCommand();
                        String sCommand = "print attribute '" + sAttrName + "' select multiline dump \"|\"";
                        String sResult ="";
                        try 
                        {
                            mqlCmd.open(context);
                            mqlCmd.executeCommand(context, sCommand);
                            sResult = mqlCmd.getResult();
                            mqlCmd.close(context);
                        } 
                        catch(Exception me) 
                        {
                            String sErrorMsg = "print attribute failed: " + me;
                            throw me;
                        } // End of try-catch

                        if(sResult.trim().equalsIgnoreCase("TRUE")) 
                        {
                            //Attribute is multiline
                            sAttrMultiLine = "true";
                        } 
                        else 
                        {
                            sAttrMultiLine = "false";
                        } // End of if
                    } // End of if ((sAttrMultiLine == null) ||

                    //To attach user chooser if the special property of the attrinbute is set
                    //The special attribute is 'DisplayPopup_UserChooser'
                    matrix.db.MQLCommand mqlCmd1 = new MQLCommand();             
                    String sCommand1 = "print attribute '" + sAttrName + "' select property[DisplayPopup_UserChooser].value dump \"|\"";
                    String sResult1 ="";
                    try 
                    {
                        mqlCmd1.open(context);
                        mqlCmd1.executeCommand(context, sCommand1);
                        sResult1 = mqlCmd1.getResult();
                        mqlCmd1.close(context);
                    } 
                    catch(Exception me) 
                    {
                        String sErrorMsg = "print attribute failed: " + me;
                        throw me;
                    } // End of try-catch
                    if(sResult1.trim().toLowerCase().equalsIgnoreCase("yes")) 
                    {
                        //Attach the user chooser
                        bUserList = true;
                    } 
                    else 
                    {
                        bUserList = false;
                    } // End of if
                } 
//End of if (bHasModifyAttributes)
if(!isAttributeEditable(sAttrName)){
%>
                <tr>
				<!--XSSOK CAUSED REG-->				
                    <td <%=strLabelColor%> valign="top"><%=i18nNow.getMXI18NString(sAttrName, "", request.getHeader("Accept-Language"),"Attribute")%></td>            

<%
                if (bHasModifyAttributes && !sAttrValue.equalsIgnoreCase("#DENIED!")) 
                {
					String valFromLastPage = emxGetParameter(request, sAttrName);
			if((valFromLastPage == null) || ("null".equals(valFromLastPage)))
						valFromLastPage = sAttrValue.trim();

                    //Edit mode
                    if(null != valueMap.get("choices") && (((StringList)valueMap.get("choices")).size() > 0) ){
		    if(sAttrName.equals(revModeAttrActualName))
		    {
%>
            <!--XSSOK-->
			<td <%=strCellColor%>><%=i18nNow.getMXI18NString(sAttrValue,sAttrName, request.getHeader("Accept-Language"),"Range")%></td>
<%
		    }
		    else{
%>
				<!--XSSOK-->
                    <td <%=strCellColor%>>
					    <!--XSSOK-->
						<input type="hidden" name="<%=sAttrName%>" value="<%=valFromLastPage%>" <%=sAppliedRule%> onkeypress="javascript:submitThis(event , submitAction);">
<%
                        if(sAppliedRule.length() ==0){
%>                      
<!--XSSOK-->                      
                        <select name="<%=sAttrName+"_combo"%>"  onChange="changeTextValue('<%=sAttrName+"_combo"%>','<%=sAttrName%>')" <%=sAppliedRule%> onkeypress="javascript:submitThis(event , submitAction);">
<%
                        //Get the attribute choice list
                        matrix.util.StringList choiceList = (StringList)valueMap.get("choices");
                        choiceList.sort();

                        //Loop through the attribute choice list
                        for(int count=0; count < choiceList.size(); count++){
                            String sChoiceVal = choiceList.get(count).toString().trim();
                            if (sChoiceVal.equalsIgnoreCase(valFromLastPage)) {
%>
                                <!--XSSOK-->
                                <option selected value="<%=sChoiceVal%>"><%=i18nNow.getMXI18NString(sChoiceVal,sAttrName, request.getHeader("Accept-Language"),"Range")%></option>
<%
                            } else {
%>
                                <!--XSSOK-->
                                <option value="<%=sChoiceVal%>"><%=i18nNow.getMXI18NString(sChoiceVal,sAttrName, request.getHeader("Accept-Language"),"Range")%></option>
<%
                            } // End of (sChoiceVal.equalsIgnoreCase(sAttrValue))               
                        } //End of for loop for choice list         
			}
%>
                         </select>
<%
                        } // End of if(sAppliedRule.length() ==0)
                            //if it is timestamp type then display calendar chooser
                            if (sDataType.equals("timestamp") && sAppliedRule.length() ==0) 
                            {
%>
                                <a href='javascript:showCalendar("<xss:encodeForJavaScript><%=strForm%></xss:encodeForJavaScript>","<%=sAttrName%>","");' ><img src="images/iconCalendarSmall.gif" border=0></a>
<%       
                            }  
%>
                    </td>
<%
                    // End of if(null != valueMap.get("choices"))
                    } else if (sDataType.equalsIgnoreCase("real") || sDataType.equalsIgnoreCase("integer")) {
%>
					<!--XSSOK-->
                    <td <%=strCellColor%>>
					<!--XSSOK-->
                        <input type="text" name="<%=sAttrName%>" value="<%=valFromLastPage%>" <%=sAppliedRule%> onkeypress="javascript:submitThis(event , submitAction);">
						<!--XSSOK-->
                        <input type="hidden" name="<%=sAttrName%>_numeric">
                    </td>
<%
                    } else if (sDataType.equalsIgnoreCase("timestamp")) {
//Bug Fix ID:279264 start 
						double iClientTimeOffset = (new Double((String)session.getValue("timeZone"))).doubleValue();
						Hashtable hashDateTime = new Hashtable();
						String strDate = "";
						if (sAttrValue != null && !"".equals(sAttrValue) )
						{
							if(sDisplayTime.equalsIgnoreCase("true"))
								strDate = eMatrixDateFormat.getFormattedDisplayDateTime(sAttrValue,iClientTimeOffset,request.getLocale());
							else
								strDate = eMatrixDateFormat.getFormattedDisplayDate(sAttrValue,iClientTimeOffset,request.getLocale());
						}
//Bug Fix ID:279264 End
                        if(sAppliedRule.length() ==0){
%>
                            <!--XSSOK-->
                            <td <%=strCellColor%>><input readonly="readonly" type="text" name="<%=sAttrName%>" value="<%=strDate%>" onkeypress="javascript:submitThis(event , submitAction);">&nbsp;&nbsp;<a href='javascript:showCalendar("<%=strForm%>","<%=sAttrName%>","");' ><img src="images/iconCalendarSmall.gif" border=0></a></td>
<%
                        }else{
%>
                            <!--XSSOK-->
                            <td <%=strCellColor%>><input readonly="readonly" type="text" name="<%=sAttrName%>" value="<%=strDate%>" onkeypress="javascript:submitThis(event , submitAction);"></td>
<%
                        }
                    } else if ("true".equals(sAttrMultiLine)) {
%>
                    <!--XSSOK-->
                    <td <%=strCellColor%>><textarea name="<%=sAttrName%>" rows="5" cols="36" wrap <%=sAppliedRule%>><%=valFromLastPage%></textarea></td>
<%
                    } else if (bUserList) {
%>
                    <!--XSSOK-->
                    <td <%=strCellColor%>>
					    <!--XSSOK-->
                        <input type=text readonly="readonly" name="<%=sAttrName%>" id="<%=sAttrName%>" value="<%=valFromLastPage%>" onkeypress="javascript:submitThis(event , submitAction);">&nbsp;
<%
                        if(sAppliedRule.length() ==0)
%>
                            <!--XSSOK-->
                            <input type="button" id="btnUser" value="..." alt="..." onClick="javascript:setFieldAndShowUserSelector('<%=sAttrName%>');">                 
                    </td>
<%
                    } else {
                        if(sDataType.equalsIgnoreCase("boolean")){
%>
                    <!--XSSOK-->
                    <td <%=strCellColor%>>
<%
                        if(sAppliedRule.length() ==0){
%>                      <!--XSSOK-->
                        <select name="<%=sAttrName%>" <%=sAppliedRule%>>
<%
                            if("true".equalsIgnoreCase(valFromLastPage)){
%>
                                <option value="true" selected>TRUE</option>
                                <option value="false">FALSE</option>
<%
                            }else{
%>
                                <option value="true">TRUE</option>
                                <option value="false" selected>FALSE</option>
<%
                            }
%>                          
                        </select>
<%
                        }else{
%>
                            <!--XSSOK-->
                            <input type="text" name="<%=sAttrName%>" value="<%=valFromLastPage%>" <%=sAppliedRule%> onkeypress="javascript:submitThis(event , submitAction);">
<%                      
                        }
%>
                    </td>
<%
                        }
			else
			{

			String attModelType = com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_ModelType");
			String attDesignatedUser = com.matrixone.MCADIntegration.server.beans.MCADMxUtil.getActualNameForAEFData(context, "attribute_DesignatedUser");

				if(sAttrName.equals(attModelType) || sAttrName.equals(attDesignatedUser))
				{
					if(valFromLastPage != null && valFromLastPage.equals("Unassigned"))
					{
				valFromLastPage = i18nStringNowLocal("emxIEFDesignCenter.Common.Unassigned", request.getHeader("Accept-Language"));
						String tempAttrName = sAttrName + "_dummy";
						
%>
                        <!--XSSOK-->
						<td <%=strCellColor%>><input type="text" name="<%=tempAttrName%>" value="<%=valFromLastPage%>" <%=sAppliedRule%> onkeypress="javascript:submitThis(event , submitAction);"></td>
						<!--XSSOK-->
						<td><input type="hidden" name="<%=sAttrName%>" value="<%=valFromLastPage%>" <%=sAppliedRule%> onkeypress="javascript:submitThis(event , submitAction);"></td>
<%
					}
				}
				else
				{
%>
                    <!--XSSOK-->
                    <td <%=strCellColor%>><input type="text" name="<%=sAttrName%>" value="<%=valFromLastPage%>" <%=sAppliedRule%> onkeypress="javascript:submitThis(event , submitAction);"></td>
<%
                        }
                    }
            }
                }else
                {
                    //Read mode
                    if(sAttrValue.length() == 0){
                        sAttrValue = "&nbsp;";
                    }
                    if(sAttrValue.equalsIgnoreCase("#DENIED!"))
                        sAttrValue = i18nStringNowLocal("emxIEFDesignCenter.Common.NoReadAcess", request.getHeader("Accept-Language"));
					if(sAttrValue != null)
						sAttrValue = sAttrValue.trim();
if("timestamp".equals(sDataType) && (sAttrValue != null) && !("".equals(sAttrValue)) && !("&nbsp;".equals(sAttrValue)))
{
%>  
                    <!--XSSOK-->
                    <td <%=strCellColor%>><framework:lzDate displaydate="true" displaytime="<%=sDisplayTime%>" localize="i18nId" tz='<%=(String)session.getValue("timeZone")%>' format='<%=iDateFormat%>' ><%=sAttrValue%></framework:lzDate></td>
<%
} else {
%>  
                    <!--XSSOK-->
                    <td <%=strCellColor%>><%=i18nNow.getMXI18NString(sAttrValue,sAttrName, request.getHeader("Accept-Language"),"Range")%></td>
<%            
}
                } // End of if (bHasModifyAttributes)
%>
                </tr>   
<%          
           }
            }// End of if(sAppliedRule.equalsIgnoreCase("alert"))
        } // End of for loop of iterator        
    }
    catch(Exception ex) 
    {
        String sError = ex.getMessage();
        //display error
%>
        <script language=javascript>
		//XSSOK
        showError("<%=sError%>");
        </script>
<%
    }
%>        
</table>
<!-- content ends here -->
