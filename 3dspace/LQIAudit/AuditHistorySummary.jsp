<%--
   Copyright (c) 2014-2018 Dassault Systemes.
   All Rights Reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes,Inc.
   Copyright notice is precautionary only and does not evidence any
   actual or intended publication of such program

   $Rev: 296 $
   $Date: 2008-02-05 07:39:05 -0700 (Tue, 05 Feb 2008) $
--%>
<%@page import="com.dassault_systemes.enovia.lsa.Helper"%>
<%@page import="matrix.db.Context"%>
<%@page import="com.dassault_systemes.enovia.lsa.LSAException"%>
<%!
       private String getEncodedI18String(Context context, String key) throws LSAException {
              try {
                     return XSSUtil.encodeForJavaScript(context,Helper.getI18NString(context, Helper.StringResource.AUDIT, key));
              } catch (Exception e) {
                     throw new LSAException(e);
              }
       }
%> 

<html>
<%@include file = "../common/emxNavigatorInclude.inc"%>

<head>
<title><%=/*XSS OK*/getEncodedI18String(context,"LQIAudit.Command.History")%></title>

<%@include file = "../common/emxUIConstantsInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>

<%@include file = "../emxStyleDefaultInclude.inc"%>
<%@include file = "../emxStyleListInclude.inc"%>
<%@page import="com.dassault_systemes.enovia.lsa.Helper"%>

<script language="javascript">
    addStyleSheet("emxUIMenu");
</script>

<script src="../common/scripts/emxNavigatorHelp.js" type="text/javascript"></script>
</head>

<%
  DomainObject boGeneric = DomainObject.newInstance(context);

  boolean isPrinterFriendly = false;
  String Header=emxGetParameter(request, "Header");
  String sHistory = "";
  String itemHistory = "";
  String sAction  = "";
  String sActionProp  = "";
  String sActionI18N = "";
  String sUser    = "";
  String sTime    = "";
  String sDescription  = "";
  String sState   = "";
  String sActionDetails="";
  String hiddenActions="";
  String sComma=",";
  String HistoryMode ="";
  String SpecialCaseAccesses ="";
  String SpecialCaseStates ="";
  TreeMap TMap=new TreeMap();
  String subHeader                = emxGetParameter(request, "subHeader");
  String sFilter                  = emxGetParameter(request, "txtFilter");
  HistoryMode                     = emxGetParameter(request, "HistoryMode");
  String aFilter                  = emxGetParameter(request, "hiddenActionFilter");
  String sBusId                   = emxGetParameter(request, "objectId");
  String jsTreeID                 = emxGetParameter(request,"jsTreeID");
  String suiteKey                 = emxGetParameter(request,"suiteKey");
  String sParams                  = "jsTreeID="+jsTreeID+"&objectId="+sBusId+"&suiteKey="+suiteKey;
  String printerFriendly          = emxGetParameter(request, "PrinterFriendly");

  String revisionlist             = emxGetParameter(request, "revisionlist");
  String fromlist                 = emxGetParameter(request, "fromlist");
  String tolist                   = emxGetParameter(request, "tolist");
  String objectId                 = emxGetParameter(request, "objectId");
  String preFilter                = emxGetParameter(request,"preFilter");
  String showFilterAction         = emxGetParameter(request,"showFilterAction");
  String showFilterTextBox        = emxGetParameter(request,"showFilterTextBox");

  String DateFrm = PersonUtil.getPreferenceDateFormatString(context);

  if(preFilter!=null  && !preFilter.equalsIgnoreCase("null") && !preFilter.equalsIgnoreCase("*") && !preFilter.equals("")) {
    aFilter=preFilter;
  }

  BusinessObject lastestRevObject = new BusinessObject();
  BusinessObjectList bObjList     = new BusinessObjectList();
  String subHeaderOriginal        = subHeader;

  SpecialCaseAccesses = FrameworkProperties.getProperty("emxFramework.History.SpecialActionType");
  if(SpecialCaseAccesses==null || SpecialCaseAccesses.equals("")){
      SpecialCaseAccesses="change owner,change policy,change type,change name,change vault,modify form";
  }

  SpecialCaseStates = FrameworkProperties.getProperty("emxFramework.History.SpecialStates");
  if(SpecialCaseStates==null || SpecialCaseStates.equals("")){
      SpecialCaseStates="In Process";
  }

  if (printerFriendly != null && !"null".equals(printerFriendly) && !"".equals(printerFriendly)) {
    isPrinterFriendly = "true".equals(printerFriendly);
  }
      String sSubHeader = Helper.getI18NString(context,Helper.StringResource.AEF,subHeader);
      if(sSubHeader==null || sSubHeader.equals(""))
        sSubHeader="Revision";
%>

<body class="content">

<%

try {
  //To store the Filter parameter/ Business Id
  String languageStr = request.getHeader("Accept-Language");

  //By default set the filter to "*"
  if (sFilter == null || sFilter.trim().equals("")) {
    sFilter = "*";
  }else{
 sFilter = (sFilter.indexOf("*")!=0)?("*"+sFilter):sFilter;
  }

  //By default set History filter to "CurrentRevision"
  if (HistoryMode == null || HistoryMode.trim().equals("")) {
    HistoryMode = "CurrentRevision";
  }

  //By default set the action filter to "*"
  if (aFilter == null || aFilter.trim().equals("")) {
    aFilter = "*";
  }

  Vector ActionFilterValues=new Vector();
  boolean showAllHistoryItems=false;

 //if action filter is equal to "*" then show everything
 //else put all of the action filter choices in a vector called ActionFilterValues
 //to be used later to determine whiwer to display the history entry or not

  if(aFilter.equals("*"))
    showAllHistoryItems=true;
  else{
         if(aFilter.indexOf(",")<0)
         {
                   ActionFilterValues.addElement(aFilter);
         }else{
                    StringTokenizer actFilter = new StringTokenizer(aFilter, sComma);
                    while(actFilter.hasMoreTokens())
                     {
                       ActionFilterValues.addElement(actFilter.nextToken().trim());
                     }
              }
      }
  boolean showLatestRev=false;
  String displayDirection="";
  String displayList="";
  String displayon="";
  Vector displayVector=new Vector();


 //CHECK TO SEE IF A TOLIST AND FROM LIST VALUES HAVE BEEN PASSED IN
 //IF NOT, THEN WE NEED TO DISPLAY THE LATEST REVISION
 //IF FROMLIST AND TOLIST WAS PASSED IN, THEN GET THE DISPLAY RANGE
   if(HistoryMode.equalsIgnoreCase("AllRevisions"))  //SECTION M
   {
       if(fromlist==null || tolist==null || fromlist.equals("") || tolist.equals(""))
       {
              showLatestRev=true;

       }else {
                 int posFrom=revisionlist.indexOf("$"+fromlist+"$");
                 int posTo=revisionlist.indexOf("$"+tolist+"$");

                 if(posFrom==posTo){
                   displayDirection="none";
                 }else if(posFrom > posTo){
                   displayDirection="ascending";
                   displayList=revisionlist.substring(posTo,posFrom+fromlist.length()+2);
                 }else if(posFrom < posTo){
                   displayDirection="descending";
                   displayList=revisionlist.substring(posFrom,posTo+tolist.length()+2);
                 }
       }

       //IF THE DISPLAY RANGE IS NOT EMPTY, THEN THE SELECTION WAS A RANGE GREATER THAN ONE REVISION
       //MORE THAN ONE REVISION IS BEING REQUESTED, PUT THEM IN A VECTOR
        if(!displayList.equals(""))
        {
              displayList=displayList.substring(1,displayList.length()-1);
              StringTokenizer displayTokenizer = new StringTokenizer(displayList, "$");
               while(displayTokenizer.hasMoreTokens())
                 {
                    displayVector.addElement(displayTokenizer.nextToken().trim());
                 }

        //IF THE DISPLAY RANGE IS EMPTY, THEN EITHER WE NEED TO DISPLAY THE LATEST REVISION OR
        //A SINGLE REVISION THAT IS NOT THE LATEST REV--(COULD BE THE LATEST REV IF THE LATEST REV WAS
        //SELECTED ONLY)

        }else{

               if(showLatestRev)
               {
                           //get the latest revision
                           BusinessObject pObj = new BusinessObject(sBusId);
                           BusinessObjectList blist=new BusinessObjectList();
                           pObj.open(context);
                           blist=pObj.getRevisions(context);
                           lastestRevObject=blist.getElement(blist.size()-1);
                           displayVector.addElement(lastestRevObject.getRevision());
                           pObj.close(context);
               }else{
                         displayVector.addElement(fromlist);
               }

        }

   } //END of Section M

  boGeneric.setId(sBusId);
  boGeneric.open(context);
  String sPolicy = boGeneric.getPolicy(context).getName();


  boolean bMatch  = false;
  BusinessObject itemObj = null;
  String sBusRev2="";
  BusinessObjectList bObjList2=new BusinessObjectList();
      BusinessObject passedObj = new BusinessObject(sBusId);
      passedObj.open(context);

      if(HistoryMode.equalsIgnoreCase("AllRevisions"))  //Section H
      {
                  bObjList2 = passedObj.getRevisions(context);
                  if(displayDirection.equalsIgnoreCase("ascending")){
                         for (int asc=0;asc<bObjList2.size();asc++)
                           {
                               itemObj=bObjList2.getElement(asc);
                               sBusRev2=itemObj.getRevision();
                               if(displayVector.contains(sBusRev2))
                                 bObjList.addElement(itemObj);
                           }

                  }else if(displayDirection.equalsIgnoreCase("descending")){

                            for (int desc=bObjList2.size()-1;desc>=0;desc--)
                              {
                                  itemObj=bObjList2.getElement(desc);
                                  sBusRev2=itemObj.getRevision();
                                  if(displayVector.contains(sBusRev2))
                                    bObjList.addElement(itemObj);
                              }

                  }else{

                            if(showLatestRev)
                              bObjList.addElement(lastestRevObject);
                            else{
                                  for (int none=0;none<bObjList2.size();none++)
                                   {
                                       itemObj=bObjList2.getElement(none);
                                       sBusRev2=itemObj.getRevision();
                                       if(displayVector.contains(sBusRev2)){
                                         bObjList.addElement(itemObj);
                                         break;
                                       }
                                   }

                            }
                 }
      }else{            //Else for Section H

             bObjList.addElement(passedObj);
      }


      passedObj.close(context);
      int vectSize = bObjList.size();
      BusinessObject lastObj = null;
      int revCount=0;
      int revCount1=1;
      boolean StopDisplay=false;
      String theAction="";
      int position;
      boolean isSpecialAccess;
      String sSpecialAction="";
      boolean customaction=false;
    for( int i=0; i < vectSize; i++) {
        lastObj = bObjList.getElement(i);
        String sBusRev=lastObj.getRevision();
        HashMap hmaplist = new HashMap();

        hmaplist=UINavigatorUtil.getHistoryData(context,lastObj.getObjectId());

        Vector descriptionArray = (Vector)hmaplist.get("description");

        Vector timeArray = (Vector)hmaplist.get("time");
        Vector userArray = (Vector)hmaplist.get("user");
        Vector actionArray = (Vector)hmaplist.get("action");
        Vector stateArray = (Vector)hmaplist.get("state");
        StringItr sItrGeneric  = new StringItr(lastObj.getHistory(context));
        MapList templateMapList =  new MapList();

        if (descriptionArray == null || descriptionArray.size() == 0)
        {
            String noHistoryMsg = Helper.getI18NString(context,Helper.StringResource.AEF,"emxFramework.History.NoHistoryData");
            throw new MatrixException(noHistoryMsg);
        }

          for( int j=0; j < descriptionArray.size(); j++) {
              sHistory="";
              sDescription = (String)descriptionArray.get(j);

              sAction  = (String)actionArray.get(j);
              sUser    = (String)userArray.get(j);
              sTime    = (String)timeArray.get(j);
              sState   = (String)stateArray.get(j);


                sActionDetails="&nbsp;";
                isSpecialAccess=false;

                // changed index to always be zero since it is never found and actually
                // breaks if "=" appears in the value
                //int indx=sHistory.indexOf("=")+1;
                int indx = 0;

                String sSpace=" ";

                sTime = sTime.substring(sTime.indexOf("time: ") + 6, sTime.length());
                sUser = sUser.substring(sUser.indexOf("user: ") + 6, sUser.length());
                sState = sState.substring(sState.indexOf("state: ") + 7, sState.length());

                 if(sAction.indexOf(sSpace)<0)
                   sActionDetails="&nbsp;";
                 else{

                      int indexAction=0;
                      if(sAction!=null && !sAction.equalsIgnoreCase("null") && !sAction.equals(""))
                      {
                         if(sAction.indexOf("(")==0) {
                           String prelimVal=sAction.substring(sAction.indexOf("(")+1,sAction.length());
                           sActionDetails=prelimVal.substring(prelimVal.indexOf(")")+1,prelimVal.length());
                           sAction="("+prelimVal.substring(0,prelimVal.length()-1)+")";
                           customaction=true;
                         }
                         else{

                                StringTokenizer SpecialActionList = new StringTokenizer(SpecialCaseAccesses, ",");
                                   while(SpecialActionList.hasMoreTokens())
                                     {
                                            sSpecialAction=SpecialActionList.nextToken();
                                              if(sAction.indexOf(sSpecialAction)>=0)
                                              {
                                                 position=sAction.indexOf(sSpecialAction);
                                                 theAction=sAction.substring(0,position+sSpecialAction.length());
                                                 sActionDetails=sAction.substring(position+sSpecialAction.length(),sAction.length());
                                                 isSpecialAccess=true;
                                                 sAction=theAction;

                                             }
                                    }

                                 if(!isSpecialAccess){
                                 StringTokenizer completeAction = new StringTokenizer(sAction, sSpace);
                                   while(completeAction.hasMoreTokens())
                                     {
                                     if(indexAction==0)
                                            sAction=completeAction.nextToken();
                                     else{
                                            sActionDetails += completeAction.nextToken();
                                            sActionDetails +=sSpace;
                                         }
                                     indexAction++;
                                  }

                               }
                            }
                    }
                }

          //if this action has not been recorded , then add the action type

              if(!TMap.containsKey(sAction)){
                  TMap.put(sAction,sAction);
                }


                 HashMap historyHashMap   = new HashMap();
                 if(ActionFilterValues.contains(sAction) || showAllHistoryItems ){
                       bMatch = true;
                       historyHashMap.put("sAction", sAction);
                       if(sUser != null){
                          sUser=sUser.trim();
                       }
                       try{
                           sUser=PersonUtil.getFullName(context, sUser);
                       }catch(Exception e){
                           System.err.println("ERROR GETTING USER FULL NAME:"+e.toString());
                       }
                       historyHashMap.put("sUser", sUser);
                       historyHashMap.put("sTime", sTime);
                       historyHashMap.put("sDescription", sDescription);
                       String translatedState="";
                       if(sState!=null && sState.length()>0){
                          sState=sState.trim();
                          translatedState=getStateI18NString(sPolicy,sState.trim(),languageStr);
                       }
                       historyHashMap.put("sState", sState);
                       historyHashMap.put("sActionDetails", sActionDetails);
                       historyHashMap.put("translatedState", translatedState);

                       String timeZone=(String)session.getAttribute("timeZone");
                       double iClientTimeOffset = (new Double(timeZone)).doubleValue();
                       int iDateFormat = PersonUtil.getPreferenceDateFormatValue(context);
                       boolean bDisplayTime = true; //PersonUtil.getPreferenceDisplayTimeValue(context);
                       String formatedDate = eMatrixDateFormat.getFormattedDisplayDateTime(sTime, bDisplayTime, iDateFormat, iClientTimeOffset, request.getLocale());
                       String finalHistory = "";
                         //finalHistory += sAction;
                         finalHistory += sUser;
                         finalHistory += sDescription;
                         finalHistory += sState;
                         finalHistory += translatedState;
                         finalHistory += formatedDate;
                         finalHistory += sActionDetails;

                       if(finalHistory != null && finalHistory.indexOf(",")>-1){
                           finalHistory = finalHistory.replace(',','|');
                           sFilter = sFilter.replace(',','|');
                       }

                       Pattern patternGeneric = new Pattern(sFilter);
                       if(patternGeneric.match(finalHistory))
                       {
                         templateMapList.add(historyHashMap);
                       }
                 }

%>


<%
  if (!isPrinterFriendly && revCount==0 && (!StopDisplay)) {
%>
<form name=objectHistory method="get" action="AuditHistorySummary.jsp">
<%@include file = "../common/enoviaCSRFTokenInjection.inc"%>
  <table width="100%" cellspacing="2" cellpadding="3" border="0">
<%
   StopDisplay=true;
  }else if((isPrinterFriendly && revCount==0 && (!StopDisplay))){
     StopDisplay=true;
%>
     <table width="100%" cellspacing="2" cellpadding="3" border="0">
<%}%>

<%
        }


%>

   <%if(HistoryMode !=null && HistoryMode.equalsIgnoreCase("AllRevisions")){%>
   <tr><td colspan="6" bgcolor="#ffffff">
        <table border="0" cellspacing="0" cellpadding="0" width="100%">
          <tr>
               <td>&nbsp;</td>
          </tr>
          <tr>
               <td class="pageBorder"><img src="../common/images/UtilSpacer.gif" width="1" height="1" alt=""></td>
          </tr>
        </table>
   </td></tr>
    <tr><td colspan="6" bgcolor="#ffffff"><b>
         <%=XSSUtil.encodeForJavaScript(context,sSubHeader)%>&nbsp;<%=XSSUtil.encodeForJavaScript(context,sBusRev)%></b>
    </td></tr>

  <%}%>


  <framework:sortInit
     defaultSortKey="sTime"
     defaultSortType="date"
     mapList="<%=/* XSS OK*/templateMapList%>"
     resourceBundle="emxFrameworkStringResource"
     ascendText="emxFramework.Common.SortAscending"
     descendText="emxFramework.Common.SortDescending"
     params = "<%=XSSUtil.encodeForJavaScript(context,sParams)%>" />
   <tr>
     <th>
       <framework:sortColumnHeader
         title= "emxFramework.History.Date"
         sortKey="sTime"
         sortType="date"
         anchorClass="sortMenuItem"/>
     </th>
     <th>
       <framework:sortColumnHeader
         title="emxFramework.History.User"
         sortKey="sUser"
         sortType="string"
         anchorClass="sortMenuItem"/>
     </th>
     <th>
       <framework:sortColumnHeader
         title="emxFramework.History.Action"
         sortKey="sAction"
         sortType="string"
         anchorClass="sortMenuItem"/>
     </th>
     <th>
       <framework:sortColumnHeader
         title="emxFramework.History.State"
         sortKey="sState"
         sortType="string"
         anchorClass="sortMenuItem"/>
     </th>
     <th>
       <framework:sortColumnHeader
         title="emxFramework.History.Message"
         sortKey="sDescription"
         sortType="string"
         anchorClass="sortMenuItem"/>
     </th>
  </tr>

  <framework:mapListItr mapList="<%=/*XSS OK*/templateMapList%>" mapName="tempMap">

<%
         sAction  = (String)tempMap.get("sAction");
         if(customaction){
           sActionI18N=sAction;

         }else{
              sActionProp = "emxFramework.History." + sAction.replace(' ','_');
              sActionI18N =Helper.getI18NString(context,Helper.StringResource.AEF,sActionProp);
           //sActionI18N=sAction;
         }
         sUser    = (String)tempMap.get("sUser");
         sTime    = (String)tempMap.get("sTime");
         sDescription  = (String)tempMap.get("sDescription");
         sState   = (String)tempMap.get("sState");
         sActionDetails=(String)tempMap.get("sActionDetails");
%>
    <tr class='<framework:swap id ="1" />'>

      <td><emxUtil:lzDate displaydate="true" displaytime="true" localize="i18nId" tz='<%=XSSUtil.encodeForJavaScript(context,(String)session.getAttribute("timeZone"))%>' format='<%=XSSUtil.encodeForJavaScript(context,DateFrm) %>' ><%=XSSUtil.encodeForJavaScript(context,sTime)%></emxUtil:lzDate>&nbsp;&nbsp;
      </td>
      <td><%=XSSUtil.encodeForJavaScript(context,sUser)%>&nbsp;</td>
      <td><%=XSSUtil.encodeForJavaScript(context,sActionI18N)%>&nbsp;</td>
<%--
// In version 10.6 "Action Details" column was remove
      <td><%=XSSUtil.encodeForJavaScript(context,sActionDetails)%>&nbsp;</td>
--%>
      <td><%=XSSUtil.encodeForJavaScript(context,getStateI18NString(sPolicy,sState.trim(),languageStr))%>&nbsp;</td>
      <td><%=XSSUtil.encodeForJavaScript(context,sDescription)%>&nbsp;</td>
    </tr>
  </framework:mapListItr>
<%  revCount++;
revCount1++;
 if (!bMatch) {
%>
    <tr class="even">
      <td colspan="6" align="center" class="errorMessage">
        <emxUtil:i18n localize="i18nId">emxFramework.Common.NoMatchFound</emxUtil:i18n>
      </td>
    </tr>
<%


  }
     bMatch=false;

      }

%>

<%
} catch (MatrixException e) {
%>
  <table border="0" cellspacing="0" cellpadding="0" width="100%">
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td class="errorMessage"><%=XSSUtil.encodeForJavaScript(context,e.getMessage())%></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
  </table>
<%
    if(e.toString()!=null && (e.toString().trim()).length()>0)
        emxNavErrorObject.addMessage("emxHistorySummary : " + e.toString().trim());
}

  java.util.Set exportSet = TMap.keySet();
  Iterator exportIterator = exportSet.iterator();
  String skey = "";
  while(exportIterator.hasNext())
  {
    skey = (String)exportIterator.next();
    hiddenActions+= skey + "|";
  }
  Map csrfTokenMap = ENOCsrfGuard.getCSRFTokenMap(context, session);
  String csrfTokenName = (String)csrfTokenMap.get(ENOCsrfGuard.CSRF_TOKEN_NAME);
  String csrfTokenValue = (String)csrfTokenMap.get(csrfTokenName);
%>
</table>
<input type=hidden name="objectId" value="<%=XSSUtil.encodeForJavaScript(context,sBusId)%>">
<input type="hidden" name="hiddenActionFilter" value=""/>
<input type="hidden" name="preFilter" value=""/>
<input type="hidden" name="txtFilter" value=""/>
<input type="hidden" name="hiddenActions" value="<%=XSSUtil.encodeForJavaScript(context,hiddenActions)%>"/>
<input type="hidden" name="HistoryMode" value="<%=XSSUtil.encodeForJavaScript(context,HistoryMode)%>"/>
<input type="hidden" name="Header" value="<%=XSSUtil.encodeForJavaScript(context,Header)%>"/>
<input type="hidden" name="subHeader" value="<%=XSSUtil.encodeForJavaScript(context,subHeaderOriginal)%>"/>
<input type="hidden" name="fromlist" value=""/>
<input type="hidden" name="tolist" value=""/>
<input type="hidden" name="revisionlist" value=""/>
<input type="hidden" name= "<%=XSSUtil.encodeForJavaScript(context,ENOCsrfGuard.CSRF_TOKEN_NAME)%>" value="<%=XSSUtil.encodeForJavaScript(context,csrfTokenName)%>"
<input type="hidden" name= "<%=XSSUtil.encodeForJavaScript(context,csrfTokenName)%>" value="<%=XSSUtil.encodeForJavaScript(context,csrfTokenValue)%>"

</form>

<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
</body>
</html>
