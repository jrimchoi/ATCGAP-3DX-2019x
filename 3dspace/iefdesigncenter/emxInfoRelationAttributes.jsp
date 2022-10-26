<%--  emxInfoRelationAttributes.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  This page enables editing of relationships attributes for objects being connected.

 
  
  static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxInfoRelationAttributes.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>


<%@ page import = "java.net.*" %>
<%@ page import = "com.matrixone.apps.domain.DomainRelationship" %>
<%@include file   ="emxInfoCentralUtils.inc"%>          <%--For context, request wrapper methods, i18n methods--%>

<!-- content begins here -->
<html>
<head>
<link rel="stylesheet" href="../common/styles/emxUIDefault.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIList.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIForm.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIDialog.css" type="text/css" ><!--This is required for the cell (td) back ground colour-->
<link rel="stylesheet" href="../emxUITemp.css" type="text/css">
<%@include file="../common/emxUIConstantsInclude.inc"%>
<script language="JavaScript" src="../common/scripts/emxUIModal.js"></script>
<script language="JavaScript" src="../common/scripts/emxUICalendar.js"></script>
</head>
<body class="content" onload ="redirect()">

<!-- content begins here -->
<script language="Javascript">
    function connect()
    {
        document.relationshipAttri.submit(); 
    }

    function closeWindow()
    {
        parent.window.close();
    }

    //Validate the Textfield, If nonnumeric Charecters are entered then
    //throw an alert message
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
    var editForm = document.relationshipAttri;
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
<%!
  static public String replaceString(String str,String replace,String newString){
      while(str.indexOf(replace)!=-1){
          int index =str.indexOf(replace);
          String restStr=str.substring(index+replace.length());
          str=str.substring(0,index)+newString+restStr;
      }
      return str;
  }
%>

<%!
    public static String displayRelationField(Map mapValue,
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
        strAttrValue = replaceString(strAttrValue,"\"", "&quot;");
        //ATTRIBUTE_DETAILS_CHOICES
        StringList strListChoices = (StringList)mapValue.get("choices");

        String strDisplayField = "";
        if ("edit".equalsIgnoreCase(access)) 
        {
            //  boolean hasChoices = EngineeringUtil.attributeHasChoicesOnly(context, strAttrName);
            //  if ( hasChoices && strListChoices != null && strListChoices.size() > 0 )
                        
            if ( strListChoices != null && strListChoices.size() > 0 )
            {   
                strDisplayField += "<input type=\"text\" name=\"" + fieldName +"\" value=\"" +strAttrValue + "\">";
                strDisplayField +="<select name=\"" + fieldName+"_combo" +"\""+"                    onChange=\"changeTextValue('"+fieldName+"_combo"+"','"+ fieldName+"')\">";
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
                    "<a href=\"javascript:showCalendar('relationshipAttri','"+fieldName+"','');\"><img src=\"images/iconCalendarSmall.gif\" border=0></a>";
                }
            }
            else if (strAttrType.equals("real") || strAttrType.equals("integer"))
            {
                strDisplayField += "<input type=\"text\" name=\"" + fieldName +"\" value=\"" + strAttrValue +
                    "\"  onBlur=\"isNumeric(this)\">";
            }
            else if (strAttrType.equals("timestamp"))
            {
                String strDate = strAttrValue;
                String dateFieldName = fieldName+"_date";
                strDisplayField += "<input type=\"hidden\" name=\"" + fieldName+"\"           value=\""+busId+"dateFieldTimeStamp\">";
                strDisplayField += "<input type=\"text\" name=\"" + dateFieldName +"\" value=\"" + strDate +"\"   onFocus=blur();>&nbsp;&nbsp;";
                strDisplayField += "<a href=\"javascript:showCalendar('relationshipAttri','"+dateFieldName+"','');\"><img src=\"images/iconCalendarSmall.gif\" border=0></a>";

                
            }
            else if ("true".equals(strAttrMultiLine) )
            {
                strDisplayField += "<textarea name=\""+ fieldName +"\" rows=\"5\" cols=\"36\" wrap>" + strAttrValue + "</textarea>";
            }
            else if ("boolean".equals(strAttrType) )
            {
                strDisplayField +=" <select name=\"" + fieldName +"\">";
                String choices[]={"TRUE","FALSE"};
                for(int i =0 ; i<choices.length; i++)
                {
                    String obj = choices[i];
                    String rangeValI18 = "";
                   if ( obj.equalsIgnoreCase(strAttrValue) )
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
    //  strDisplayField+="</td>";
        return strDisplayField;
    }
%>

<%
    String parentOID =emxGetParameter(request,"parentOID");
    //String rowIds[] =emxGetParameterValues(request, "emxTableRowId");
    
    String timeStamp =  emxGetParameter(request,"timeStamp");
    //Retrieving objectids to be connected from session
    String[] rowIds = (String[])session.getAttribute("ObjectIds"+timeStamp);
    //Removing objectids from session
    session.removeAttribute("ObjectIds" + timeStamp);
        
    String sRelDirection =emxGetParameter(request,"sRelDirection");
    
	//bug fix 277294 [linguistic characters in relationship name] - start
	String sRelationName = (String)session.getAttribute("sRelationName");
	if(sRelationName == null || "null".equals(sRelationName)) sRelationName = emxGetParameter(request,"sRelationName");
	//bug fix 277294 [linguistic characters in relationship name] - end

    DomainRelationship domainRelationship = new DomainRelationship();
    Map  map = domainRelationship.getTypeAttributes(context,sRelationName);
    Iterator itr = map.keySet().iterator();
    String  hasAttri = "true";
	int iNoOfAttribs = map.size();
      
    if(!itr.hasNext())
    {
       hasAttri = "false";
     }
     BusinessObject parentBus = new BusinessObject(parentOID);
     parentBus.open(context);
     String parentName=parentBus.getName();
     String parentType=parentBus.getTypeName();
     String parentRevision=parentBus.getRevision();
     parentBus.close(context);
	 boolean parentFrom = true;
	 if(sRelDirection.equals("from"))
		parentFrom = false;
%>
<%@include file  ="emxInfoVisiblePageInclude.inc" %>
<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<form name=relationshipAttri action="emxInfoConnect.jsp" method="post" >

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

<input type=hidden name="sRelDirection" value="<%=XSSUtil.encodeForHTML(context,sRelDirection)%>">
<input type=hidden name="sRelationName" value="<%=XSSUtil.encodeForHTML(context,sRelationName)%>">
<input type=hidden name="parentOID" value="<%=XSSUtil.encodeForHTML(context,parentOID)%>">
<%
    for ( int index =0 ; index <rowIds.length; index++)
    {
        String emxTableRowId = rowIds[index];
%>
<!--XSSOK-->
<input type=hidden name="emxTableRowId" value="<%=emxTableRowId%>" >
<%
    }
    if(hasAttri.equals("true")){
%>
<table border="0" cellspacing="2" cellpadding="3" width="100%">
<tr>
<th><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.Relationship</framework:i18n></th>
<th><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.Type</framework:i18n></th>
<th><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.Name</framework:i18n></th>
<th><framework:i18n localize="i18nId">emxIEFDesignCenter.Common.Revision</framework:i18n></th>
<%
	Iterator attribIt = map.keySet().iterator();
	for(int i=0;attribIt.hasNext();i++)
	{
		HashMap attribMap = (HashMap)map.get(attribIt.next());
		String nm = (String)attribMap.get("name");
%>
<!--XSSOK-->
<th><%=nm%></th>
<%
	}
%>
</tr>
<%
    for ( int index =0 ; index <rowIds.length; index++)
    {
        String emxTableRowId = rowIds[index];
        String busId="";
        StringTokenizer strTk = new StringTokenizer(emxTableRowId,"|");
        if(strTk.countTokens()==1)
        {
            busId = strTk.nextToken();
        }
        else
        {
            int tokenIndex = 0;
            while(strTk.hasMoreTokens())
            {
                if(tokenIndex==1)
                    busId = strTk.nextToken();
                else
                    strTk.nextToken();
                tokenIndex++;
            }
       }

       BusinessObject bus = new BusinessObject(busId);
       bus.open(context);
%>
<tr>
<td class="field"><%=XSSUtil.encodeForHTML(context,sRelationName)%></td>
    <%
	if(parentFrom)
        {
        }
        else
        {
    %>
<td class="field"><%=bus.getTypeName()%></td>
<td class="field"><%=bus.getName()%></td>
<td class="field"><%=bus.getRevision()%></td>
    <%
        }
	if(!parentFrom)
        {
        }
        else
        {
    %>
<td class="field"><%=bus.getTypeName()%></td>
<td class="field"><%=bus.getName()%></td>
<td class="field"><%=bus.getRevision()%></td>
    <%
        }
    %>
<%
        itr = map.keySet().iterator();
        for(int i=0;itr.hasNext();i++)
        {
            HashMap attriMap = (HashMap)map.get(itr.next());
            String name = (String)attriMap.get("name");
            String value= (String)attriMap.get("value");
            String displayName= i18nNow.getAttributeI18NString(name,request.getHeader("Accept-Language"));
            if( ( value == null ) || value.equals( "null" ))
            {
                value="";
            }
%>
 <!--XSSOK-->
 <input type=hidden name=<%=busId+"name"%> value="<%=name%>" >
    <td class="field">
	<!--XSSOK-->
     <%=displayRelationField(attriMap,"edit",request.getHeader("Accept-Language"),session,busId,"")%>
    </td>
  <%
			}
%>
    </tr>
  <%
        }
  %>
  </table>
<%
    }
%>
</form>
</body>
<script language="Javascript">
    function redirect()
    {
	    //XSSOK
        var hasAttri = "<%=hasAttri%>"
        if(hasAttri=="false")
        document.relationshipAttri.submit(); 
    }
</script>
</html>
