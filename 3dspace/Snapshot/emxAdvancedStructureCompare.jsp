<%--  emxStructureCompareAdvanced.jsp
   Copyright (c) 1992-2018 Dassault Systemes.
   All Rights Reserved.
   This program contains proprietary and trade secret information of Dassault Systemes
   Copyright notice is precautionary only and does not evidence any actual or
   intended publication of such program
--%>

<%@page import="com.matrixone.apps.domain.util.XSSUtil"%>
<%@include file="../common/emxNavigatorInclude.inc"%>
<%@include file="../common/emxNavigatorTopErrorInclude.inc"%>
<%@include file = "../common/emxUIConstantsInclude.inc"%>
<%@include file = "../emxUICommonHeaderBeginInclude.inc" %>

<%

String strObjectId1 = "";
String strObjectId2 = "";
String contentURL = "";
boolean isPortalDispaly = false;
String objSelectLimitMsg = "";
String sQueryForBPS = "";

String suiteKey = emxGetParameter(request,"suiteKey");
if(suiteKey.indexOf('?')!=-1)
{
	StringList suiteKeyList  = FrameworkUtil.split(suiteKey, "?");
	suiteKey = (String)suiteKeyList.get(0);
}
String targetLocation = emxGetParameter(request,"targetLocation");
String helpMarker = emxGetParameter(request,"HelpMarker");
String AppSuiteKey = emxGetParameter(request,"AppSuiteKey");
String preProcessJS = emxGetParameter(request,"preProcessJavaScript");
String strHeader = emxGetParameter(request,"header");
String tableRowIdList[] = emxGetParameterValues(request,"emxTableRowId");
int intNumRows = 0;
String strLanguage = request.getHeader("Accept-Language");
String scTimeStamp = emxGetParameter(request,"SCTimeStamp");

String strResourceFile = UINavigatorUtil.getStringResourceFileId(context,suiteKey);

String strSCHeader =    "emxFramework.Common.StructureCompare";
String cellWrap = emxGetParameter(request,"cellwrap");
cellWrap = UITableIndented.getSBWrapStatus(context, cellWrap);

String expandFilter = emxGetParameter(request,"expandFilter");
String showDiffIcon = emxGetParameter(request,"diffCodeIcons");
String summaryIcons = emxGetParameter(request,"summaryIcons");

if(UIUtil.isNullOrEmpty(strHeader))
{
    strHeader = strSCHeader;
}
  
if (tableRowIdList!= null)
{
    intNumRows = tableRowIdList.length;
    if (intNumRows > 2)
    {
        objSelectLimitMsg = EnoviaResourceBundle.getProperty(context, "emxFrameworkStringResource", new Locale(strLanguage), "emxFramework.FreezePane.SBCompare.SelectMinObjects");
    }
}


if(UIUtil.isNullOrEmpty(objSelectLimitMsg))
	
{

    String fromContext  = emxGetParameter(request,"fromContext");
    String strForm      = emxGetParameter(request,"form");
    String strSubmitURL = emxGetParameter(request,"submitURL");
    String strTable     = emxGetParameter(request,"table");
    String selectedTable            =   emxGetParameter(request, "selectedTable");
    String userTable = emxGetParameter(request, "userTable");
    
    if(Boolean.parseBoolean(userTable)  && UIUtil.isNotNullAndNotEmpty(selectedTable)){    	
    	selectedTable = UITableCustom.getSystemTableName(context, selectedTable);
    }
     if(strTable == null){
         strTable           =   selectedTable;
     }
    String strObjId     = emxGetParameter(request,"objectId");
    
    
    String strRel               =   emxGetParameter(request, "relationship");
    String strDir               =   emxGetParameter(request, "direction"); 
    String strExpandProgram     =   emxGetParameter(request, "expandProgram");
    
    String strconnectionProgram  =  emxGetParameter(request, "connectionProgram");
    
    StringBuffer appendURL = new StringBuffer();
    appendURL.append("&relationship=");appendURL.append(strRel);
    appendURL.append("&direction=");appendURL.append(strDir);
    appendURL.append("&toolbar=AEFStructureCompareToolbar");
    appendURL.append("&connectionProgram=");appendURL.append(strconnectionProgram);
    appendURL.append("&expandProgram=");
    appendURL.append(strExpandProgram);
    boolean isBPSStructureCompareReport = (UIUtil.isNullOrEmpty(strForm) && UIUtil.isNullOrEmpty(strSubmitURL)) ? true : false;
    
    if(UIUtil.isNullOrEmpty(strObjectId1))
    {
        strObjectId1 = emxGetParameter(request,"objectId1");
    }
    
    if (UIUtil.isNullOrEmpty(strObjectId1) && tableRowIdList!= null)
    {
        intNumRows = tableRowIdList.length;
        
        if (intNumRows == 2)
        {
            String strRowInfo = tableRowIdList[0];
            StringList strlRowInfo = FrameworkUtil.split(strRowInfo, "|");
           
            if (strlRowInfo.size() == 3)
            {
                strObjectId1 = (String) strlRowInfo.get(0);
            }
            else
            {
                strObjectId1 = (String) strlRowInfo.get(1);
            }
    
            strRowInfo = tableRowIdList[1];
            strlRowInfo = FrameworkUtil.split(strRowInfo, "|");
            if (strlRowInfo.size() == 3)
            {
                strObjectId2 = (String) strlRowInfo.get(0);
            }
            else
            {
                strObjectId2 = (String) strlRowInfo.get(1);
            }
        }
        else if (intNumRows == 1)
        {
            String strRowInfo = tableRowIdList[0];
            StringList strlRowInfo = FrameworkUtil.split(strRowInfo, "|");
    
            if (strlRowInfo.size() == 3)
            {
                strObjectId1 = (String) strlRowInfo.get(0);
            }
            else
            {
                strObjectId1 = (String) strlRowInfo.get(1);
            }
        }
    }
    
    if(UIUtil.isNullOrEmpty(strObjectId2))
    {
        strObjectId2 = emxGetParameter(request,"objectId2");
    }
    
    if (strObjectId1 == null)
    {
        strObjectId1 = emxGetParameter(request,"objectId");
    }
    
    String objIDs = strObjectId1 + "," + strObjectId2 + "," + strObjId;
    
    if(UIUtil.isNullOrEmpty(scTimeStamp))
    {
        scTimeStamp = UIComponent.getTimeStamp()+"";
    }
    
    Map requestMapToSubmit = UINavigatorUtil.getRequestParameterMap(request);

    java.util.Set ketSet = requestMapToSubmit.keySet();
    Iterator itrKey = ketSet.iterator();
    
    while(itrKey.hasNext()) {
        String sKey = (String)itrKey.next();
        String sVal = "";
        try {
            sVal = (String)requestMapToSubmit.get(sKey);
        } catch (Exception e) {
            //Do nothing
        } if(!sVal.equals("")) {
        	if(sKey.equalsIgnoreCase("submitURL")) {
        		sVal = XSSUtil.encodeForURL(context, sVal);
        	}
            sQueryForBPS += sKey+"="+sVal+"&";
        }
    }
    sQueryForBPS = sQueryForBPS.substring(0, sQueryForBPS.length()-1);
    
    //When invoked from Channel commands
    if(!UIUtil.isNullOrEmpty(fromContext))
    {
        if(isBPSStructureCompareReport)
        {
			contentURL = "../common/emxStructureCompare.jsp?suiteKey=Framework&SCTimeStamp="+XSSUtil.encodeForJavaScript(context,scTimeStamp)+"&rowGrouping=false&SuiteDirectory=common&StringResourceFileId=emxFrameworkStringResource&objectId="+XSSUtil.encodeForJavaScript(context,strObjId)+"&objectId1="+XSSUtil.encodeForJavaScript(context,strObjectId1)+"&objectId2="+XSSUtil.encodeForJavaScript(context,strObjectId2)+"&table="+XSSUtil.encodeForJavaScript(context,strTable)+"&objIDs="+objIDs+appendURL.toString()+"&HelpMarker="+XSSUtil.encodeForJavaScript(context,helpMarker)+"&cellwrap="+XSSUtil.encodeForJavaScript(context,cellWrap);
        }
        else
        {
            if(null != AppSuiteKey)
            {
                suiteKey = AppSuiteKey;
            }

			String strPostProcessURL = "../common/emxStructureCompareIntermediate.jsp?rowGrouping=false&cellwrap="+XSSUtil.encodeForJavaScript(context,cellWrap);
            contentURL = "../common/emxForm.jsp?form="+XSSUtil.encodeForJavaScript(context,strForm)+"&SCTimeStamp="+XSSUtil.encodeForJavaScript(context,scTimeStamp)+"&submitMultipleTimes=true&submitLabel=Apply&hideCancel=true&resetForm=true&mode=Edit&submitAction=refreshCaller&postProcessURL="+strPostProcessURL+"&suiteKey="+XSSUtil.encodeForJavaScript(context,suiteKey)+"&findMxLink=false&showClipboard=false&IsStructureCompare=true&objectId1="+XSSUtil.encodeForJavaScript(context,strObjectId1)+"&objectId2="+XSSUtil.encodeForJavaScript(context,strObjectId2)+"&objectId="+XSSUtil.encodeForJavaScript(context,strObjectId1)+"&preProcessJavaScript="+preProcessJS+"&portalMode=true&hideLaunchButton=true"+"&submitURL="+XSSUtil.encodeForJavaScript(context,strSubmitURL)+"&HelpMarker="+XSSUtil.encodeForJavaScript(context,helpMarker);
                    
        }
    }
    else //Invoke the Portal
    {
    	isPortalDispaly = true;
        
        String portal = "";
        if("".equals(portal)) {
        	portal="SnapshotStructureComparePortal";
        }
        %>
            <input type="hidden" name="urlParameters" value="<xss:encodeForHTMLAttribute><%=sQueryForBPS%></xss:encodeForHTMLAttribute>" />
        <%
        if(isBPSStructureCompareReport)
        {
            contentURL = "../common/emxPortal.jsp?SCTimeStamp="+XSSUtil.encodeForJavaScript(context,scTimeStamp)+"&portal=AEFStructureComparePortal&header="+XSSUtil.encodeForJavaScript(context,strSCHeader)+"&suiteKey=Framework&SuiteDirectory=common&StringResourceFileId=emxFrameworkStringResource&objectId1="+XSSUtil.encodeForJavaScript(context,strObjectId1)+"&objectId2="+XSSUtil.encodeForJavaScript(context,strObjectId2)+"&table="+XSSUtil.encodeForJavaScript(context,strTable)+"&objIDs="+objIDs+"&objectId="+XSSUtil.encodeForJavaScript(context,strObjId)+appendURL.toString()+"&selectedTable="+selectedTable+"&HelpMarker="+XSSUtil.encodeForJavaScript(context,helpMarker);
        }
        else
        {
            contentURL = "../common/emxPortal.jsp?SCTimeStamp="+XSSUtil.encodeForJavaScript(context,scTimeStamp)+"&portal="+XSSUtil.encodeForJavaScript(context, portal)+"&header="+XSSUtil.encodeForJavaScript(context,strHeader)+"&AppSuiteKey="+XSSUtil.encodeForJavaScript(context,suiteKey)+"&suiteKey="+XSSUtil.encodeForJavaScript(context,suiteKey)+"&objectId1="+XSSUtil.encodeForJavaScript(context,strObjectId1)+"&objectId2="+XSSUtil.encodeForJavaScript(context,strObjectId2)+"&form="+XSSUtil.encodeForJavaScript(context,strForm)+"&submitURL="+XSSUtil.encodeForJavaScript(context,strSubmitURL)+"&HelpMarker="+XSSUtil.encodeForJavaScript(context,helpMarker)+"&"+sQueryForBPS;

        }
    }
	    
    if(UIUtil.isNotNullAndNotEmpty(expandFilter)){
    	contentURL +="&expandFilter="+expandFilter;
    }
    
    if(UIUtil.isNotNullAndNotEmpty(showDiffIcon)){
    	contentURL +="&diffCodeIcons="+showDiffIcon;
    }
    
    if(UIUtil.isNotNullAndNotEmpty(summaryIcons)){
    	contentURL +="&summaryIcons="+summaryIcons;
    }
}
%>
<script language="javascript" src="emxUIModal.js"></script>
<script language="JavaScript" type="text/javascript">

//XSSOK
var isPortalDispaly = "<%=isPortalDispaly%>";
var targetLocation = "<xss:encodeForJavaScript><%=targetLocation%></xss:encodeForJavaScript>";

if("<%=objSelectLimitMsg %>" != "")
{
    alert("<%=objSelectLimitMsg %>");
}
else
{
    if(isPortalDispaly == "true")
    {
        if(null !=targetLocation && targetLocation == "content") {
            var contentFrame = findFrame(parent.getTopWindow(),"content");
            if(contentFrame) {
            	//XSSOK
            contentFrame.location.href='<%=contentURL%>';   
            }
        } else {
        	//XSSOK
        	showAndGetNonModalDialog("<%=contentURL%>", "Max", "Max", "true");
        }
        
    }
    else
    {
    	var objForm = createRequestFormLSA('<%=sQueryForBPS%>');
		objForm.target = "AEFStructureCompareCriteria";
		objForm.action = '<%=contentURL%>';
		objForm.method = "post";
		objForm.submit();
    }
}
</script>


