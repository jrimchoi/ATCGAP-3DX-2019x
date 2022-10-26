<%--  emxInfoEditTableDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoEditTableDialog.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>

<%--
 *
 * $History: emxInfoEditTableDialog.jsp $
 * 
 * *****************  Version 17  *****************
 * User: Rahulp       Date: 03/01/21   Time: 21:43
 * Updated in $/InfoCentral/src/infocentral
 * 
 * ***********************************************
 *
--%>

<%@ page import = "java.net.*" %>
<%@ page import = "com.matrixone.apps.domain.DomainRelationship" %>
<%@include file   ="emxInfoCentralUtils.inc"%>          <%--For context, request wrapper methods, i18n methods--%>

<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<!-- content begins here -->
<html>
<head>
<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIList.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIForm.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIDialog.css" type="text/css" ><!--This is required for the cell (td) back ground colour-->
<link rel="stylesheet" href="../emxUITemp.css" type="text/css">
<script language="JavaScript">
function submit(){
        document.editTableAttri.submit();
    }
function isNumeric(textBox)
{
    var varValue = textBox.value;
    if (isNaN(varValue) == true) 
    {
        alert("<framework:i18nScript localize="i18nId">emxIEFDesignCenter.ObjectDetails.AlertMsg1</framework:i18nScript>");
        textBox.value="";
        textBox.focus();        
    }
}
function changeTextValue(comboName,fieldName){
var editForm = document.editTableAttri;
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

</script>
</head>
<body class="content" >
<%@include file  ="emxInfoCalendarInclude.inc"%>        <%--Calendar control--%>

<%!

  public String replaceString(String str,String replace,String newString){
      while(str.indexOf(replace)!=-1){
          int index =str.indexOf(replace);
          String restStr=str.substring(index+replace.length());
          str=str.substring(0,index)+newString+restStr;
      }
      return str;
  }

%>
<%!
 public static String displayAttributeField(Map mapValue,
                                    String access,
                                    String sLanguage,
                                    HttpSession session,
                                    String busId,
                                    String sAttribParamName) throws Exception 
    {
        //ATTRIBUTE_DETAILS_TYPE
        String strAttrType = (String)mapValue.get("type");
        //ATTRIBUTE_DETAILS_MULTILINE
        String strAttrMultiLine = (String)mapValue.get("multiline");
        //ATTRIBUTE_DETAILS_NAME
        String strAttrName = (String)mapValue.get("name");
        String fieldName = busId.replace('.','a')+strAttrName;

        Context context = Framework.getFrameContext(session);
        if ((strAttrMultiLine == null) ||
            ("null".equalsIgnoreCase(strAttrMultiLine)) ||
            ("".equals(strAttrMultiLine))) 
        {
            matrix.db.MQLCommand mqlCmd = new MQLCommand();
            String sResult ="";
            try 
            {
                mqlCmd.open(context);
                mqlCmd.executeCommand(context, "print attribute $1 select $2 dump $3",strAttrName,"multiline","|");
                sResult = mqlCmd.getResult();
                mqlCmd.close(context);
            } 
            catch(Exception me) 
            {
                String sErrorMsg = "print attr failed: " + me;
                throw me;
            }

            if(sResult.trim().equalsIgnoreCase("TRUE")) 
            {
                strAttrMultiLine = "true";
            } 
            else 
            {
                strAttrMultiLine = "false";
            }
        }

        if( ( "".equals(sAttribParamName) )
            || (null == sAttribParamName) 
            || ("null".equals(sAttribParamName) ) )
            sAttribParamName = strAttrName;

        //SEL_ATTRIBUTE_VALUE
        String strAttrValue = (String)mapValue.get("value");
        //ATTRIBUTE_DETAILS_CHOICES
        StringList strListChoices = (StringList)mapValue.get("choices");

        String strDisplayField = "<td class=field>";
        if ("edit".equalsIgnoreCase(access)) 
        {
            //  boolean hasChoices = EngineeringUtil.attributeHasChoicesOnly(context, strAttrName);
            //  if ( hasChoices && strListChoices != null && strListChoices.size() > 0 )
                        
            if ( strListChoices != null && strListChoices.size() > 0 )
            {   
                strDisplayField += "<input type=\"text\" name=\"" + fieldName +"\" value=\"" + strAttrValue + "\"></td>";
                strDisplayField +="<td class=field><select name=\"" + fieldName+"_combo" +"\""+"      onChange=\"changeTextValue('"+fieldName+"_combo"+"','"+ fieldName+"')\">";
                StringItr strItr = new StringItr(strListChoices);
                while ( strItr.next() )
                {
                    // String rangeValI18 = getRangeI18NString(strAttrName,strItr.obj(), sLanguage);
                    String rangeValI18 =  i18nNow.getRangeI18NString(strAttrName,strItr.obj(), sLanguage);
                    boolean selected=false;
                    if((strAttrType.equals("real") || strAttrType.equals("integer"))&& !strAttrValue.equals("")){
                     double f1 = new Double(strAttrValue).doubleValue();
                     double f2 = new Double(strItr.obj()).doubleValue();
                     if(f1==f2)
                     selected=true;
                    }
                    else{
                     selected=strItr.obj().equals(strAttrValue);
                    }

                    if (selected)
                    {
                        strDisplayField += "<option selected value=\"" + strItr.obj() +"\">"+ rangeValI18 +"</option>";
                    }
                    else
                    {
                        strDisplayField += "<option value=\"" + strItr.obj() +"\">"+ rangeValI18 +"</option>";
                    }
                }
                strDisplayField += "</select>";
                if(strAttrType.equals("timestamp")){
                strDisplayField +=
                    "<a href=\"javascript:getDate('editTableAttri','"+fieldName+"');\"><img src=\"images/iconCalendarSmall.gif\" border=0></a>";
                }
            }
            else if (strAttrType.equals("real") || strAttrType.equals("integer"))
            {
                strDisplayField += "<input type=\"text\" name=\"" + fieldName +"\" value=\"" + strAttrValue +
                    "\"  onBlur=\"isNumeric(this)\">";
            }
            else if (strAttrType.equals("timestamp"))
            {
                double iClientTimeOffset = (new Double((String)session.getValue("timeZone"))).doubleValue();
                Hashtable hashDateTime = new Hashtable();
                String strDate = "";
                if (strAttrValue != null && !"".equals(strAttrValue) )
                {
                    hashDateTime = com.matrixone.apps.domain.util.eMatrixDateFormat.getFormattedDisplayInputDateTime(strAttrValue,iClientTimeOffset);
                    strDate = (String)hashDateTime.get("date");
                }
                String dateFieldName = fieldName+"_date";
                strDisplayField += "<input type=\"hidden\" name=\"" + fieldName+"\" value=\"dateFieldTimeStamp\">";
                strDisplayField += "<input type=\"text\" name=\"" + dateFieldName +"\" value=\"" + strDate +"\"   onFocus=blur();>&nbsp;&nbsp;";
                strDisplayField += "<a href=\"javascript:getDate('editTableAttri','"+dateFieldName+"');\"><img src=\"images/iconCalendarSmall.gif\" border=0></a>";                
            }
            else if ("true".equals(strAttrMultiLine) )
            {
                strDisplayField += "<textarea name=\""+ fieldName +"\" rows=\"5\" cols=\"30\" wrap>" + strAttrValue + "</textarea>";
            }
            else if ("boolean".equals(strAttrType) )
            {
                strDisplayField +=" <select name=\"" + fieldName +"\">";
                String choices[]={"TRUE","FALSE"};
                for(int i =0 ; i<choices.length; i++)
                {
                    String obj = choices[i];
                    //String rangeValI18 = getRangeI18NString(strAttrName,obj, sLanguage);
                    String rangeValI18 = "";               
                    if ( obj.equalsIgnoreCase(strAttrValue))
                    {
                        strDisplayField += "<option selected value=\"" + obj +"\">"+ obj +"</option>";
                    }
                    else
                    {
                        strDisplayField += "<option value=\"" + obj +"\">"+ obj +"</option>";
                    }
                }
                strDisplayField += "</select>";
            }
            else
            {
                strDisplayField += "<input type=\"text\" name=\"" + fieldName + "\" value=\"" + strAttrValue +"\">";
            }
        } //end of IF("edit".equalsIgnoreCase(access)) 
        else
        {
            strDisplayField +=   i18nNow.getRangeI18NString(strAttrName,strAttrValue, sLanguage);
        }
        strDisplayField+="</td>";
        return strDisplayField;
    }
%>

<% 
   String busId = emxGetParameter(request,"busId");
   String relId = emxGetParameter(request,"relId");
   String isDescription = emxGetParameter(request,"isDescription");
   String attributeName = emxGetParameter(request,"attributeName");
   String attributeValue =emxGetParameter(request,"attributeValue");

    attributeValue = replaceString(attributeValue,"q_u_o_t_e", "&quot;");
    attributeValue = replaceString(attributeValue,"f_o_r_s_l_a_s_h","\\");
    attributeValue = replaceString(attributeValue,"a_p_o_s", "'");
    attributeValue = replaceString(attributeValue,"h_a_s_h_1","#");

   String tableName =emxGetParameter(request,"tableName");
   if(tableName==null)
   tableName="";
   String navigator =emxGetParameter(request,"navigator");   
   String  isBusAttri = emxGetParameter(request,"isBusAttri");
//--Cue-Tip-Start------ 
   String sCueClassName = emxGetParameter(request,"strCueClassName");
   String sObjeTip = emxGetParameter(request,"strObjTip");   
   String sCueStyle = emxGetParameter(request,"strCueClassStyle");   
//--Cue-Tip-End------ 
 %>

<form name=editTableAttri method="post" action="emxInfoEditTable.jsp">

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
//System.out.println("CSRFINJECTION::emxInfoEditTableDialog.jsp::form::editTableAttri");
%>


<input type=hidden name="relId" value="<xss:encodeForHTMLAttribute><%=relId%></xss:encodeForHTMLAttribute>">
<input type=hidden name="busId" value="<xss:encodeForHTMLAttribute><%=busId%></xss:encodeForHTMLAttribute>">
<input type=hidden name="isBusAttri" value="<xss:encodeForHTMLAttribute><%=isBusAttri%></xss:encodeForHTMLAttribute>">
<!--XSSOK-->
<input type=hidden name="oldAttributeValue" value="<%=attributeValue%>">
<input type=hidden name="navigator" value="<xss:encodeForHTMLAttribute><%=navigator%></xss:encodeForHTMLAttribute>">
<input type=hidden name="tableName" value="<xss:encodeForHTMLAttribute><%=tableName%></xss:encodeForHTMLAttribute>">
<input type=hidden name="isDescription" value="<xss:encodeForHTMLAttribute><%=isDescription%></xss:encodeForHTMLAttribute>">
<!--Cue-Tip-Start-->
<input type=hidden name="strCueClassName" value="<xss:encodeForHTMLAttribute><%=sCueClassName%></xss:encodeForHTMLAttribute>">
<input type=hidden name="strObjTip" value="<xss:encodeForHTMLAttribute><%=sObjeTip%></xss:encodeForHTMLAttribute>">
<!--XSSOK-->
<input type=hidden name="strCueClassStyle" value="<%=sCueStyle%>">
<!--Cue-Tip-End-->
<table border="0" cellspacing="2" cellpadding="3" width="100%">
<%
          if(!"true".equals(isDescription)){
          AttributeTypeList attributetypelist = new AttributeTypeList();
          attributetypelist.addElement(new AttributeType(attributeName));
          Map  map = FrameworkUtil.toMap(context, attributetypelist);
          Iterator itr = map.keySet().iterator();
          itr = map.keySet().iterator();
         while(itr.hasNext())
        {
            HashMap attriMap = (HashMap)map.get(itr.next());
            String name = (String)attriMap.get("name");
            String value= (String)attriMap.get("value");
            String displayName= i18nNow.getAttributeI18NString(name,request.getHeader("Accept-Language"));
            if( ( value == null ) || value.equals( "null" ))
            {
                value="";
            }
            attriMap.put("value",attributeValue);
%>
 <!--XSSOK-->
 <input type=hidden name="<%=XSSUtil.encodeForHTML(context,busId)%>name" value="<%=name%>" >
  <tr>
    <!--XSSOK-->
    <td class="label"><%=displayName%></td>
	 <!--XSSOK-->
     <%=displayAttributeField(attriMap,"edit",request.getHeader("Accept-Language"),session,busId,"")%>
    </tr>
  <%
   }
   }
   else{
  %>
 <input type=hidden name="<%=XSSUtil.encodeForHTML(context,busId)%>name" value="<xss:encodeForHTMLAttribute><%=attributeName%></xss:encodeForHTMLAttribute>">
  <tr>
    <td class="label"><%=XSSUtil.encodeForHTML(context,attributeName)%></td>
    <td class="field">
	 <!--XSSOK-->
     <textarea name="<%=busId.replace('.','a')+attributeName%>" rows="5" cols="30" wrap><%=attributeValue%></textarea>
    </td>
  </tr>
  <%
   }
  %>
  </table>
  </form>
  </html>




