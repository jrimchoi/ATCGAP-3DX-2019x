<%--  emxInfoUIConstantsInclude.inc

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  

   static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxInfoUIConstantsInclude.inc 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>

<%
// String Resource file to be used
String ResFileId = "emxFrameworkStringResource";

// Intenationalization of Javascript contants
String STR_NAME = UINavigatorUtil.getI18nString("emxFramework.Basic.Name", ResFileId, request.getHeader("Accept-Language"));
String STR_TYPE = UINavigatorUtil.getI18nString("emxFramework.Basic.Type", ResFileId, request.getHeader("Accept-Language"));
String STR_REV = UINavigatorUtil.getI18nString("emxFramework.IconMail.Common.Rev", ResFileId, request.getHeader("Accept-Language"));
String STR_STATUS = UINavigatorUtil.getI18nString("emxFramework.IconMail.Common.Status", ResFileId, request.getHeader("Accept-Language"));
String STR_LOADING = UINavigatorUtil.getI18nString("emxNavigator.UIMenuBar.Loading", ResFileId, request.getHeader("Accept-Language"));
String STR_REASON = UINavigatorUtil.getI18nString("emxFramework.Common.Reason", ResFileId, request.getHeader("Accept-Language"));
String STR_REPLY = UINavigatorUtil.getI18nString("emxFramework.IconMail.Common.Reply", ResFileId, request.getHeader("Accept-Language"));
String STR_ERROR_HEADER = UINavigatorUtil.getI18nString("emxFramework.Login.Error", ResFileId, request.getHeader("Accept-Language"));
String STR_SUBSCRIPTION = UINavigatorUtil.getI18nString("emxFramework.Common.Subscription", ResFileId, request.getHeader("Accept-Language"));
String STR_SUBSCRIBE = UINavigatorUtil.getI18nString("emxFramework.Common.Subscribe", ResFileId, request.getHeader("Accept-Language"));

String ERR_SELECT_ONLY_ONE = UINavigatorUtil.getI18nString("emxFramework.Common.PleaseSelectOneItemOnly", ResFileId, request.getHeader("Accept-Language"));
String ERR_NONE_SELECTED = UINavigatorUtil.getI18nString("emxFramework.Common.PleaseSelectitem", ResFileId, request.getHeader("Accept-Language"));


//months to display on the calendar popup
String January = UINavigatorUtil.getI18nString("emxFramework.Calendar.January", ResFileId, request.getHeader("Accept-Language"));
String February = UINavigatorUtil.getI18nString("emxFramework.Calendar.February", ResFileId, request.getHeader("Accept-Language"));
String March = UINavigatorUtil.getI18nString("emxFramework.Calendar.March", ResFileId, request.getHeader("Accept-Language"));
String April = UINavigatorUtil.getI18nString("emxFramework.Calendar.April", ResFileId, request.getHeader("Accept-Language"));
String May = UINavigatorUtil.getI18nString("emxFramework.Calendar.May", ResFileId, request.getHeader("Accept-Language"));
String June = UINavigatorUtil.getI18nString("emxFramework.Calendar.June", ResFileId, request.getHeader("Accept-Language"));
String July = UINavigatorUtil.getI18nString("emxFramework.Calendar.July", ResFileId, request.getHeader("Accept-Language"));
String August = UINavigatorUtil.getI18nString("emxFramework.Calendar.August", ResFileId, request.getHeader("Accept-Language"));
String September = UINavigatorUtil.getI18nString("emxFramework.Calendar.September", ResFileId, request.getHeader("Accept-Language"));
String October = UINavigatorUtil.getI18nString("emxFramework.Calendar.October", ResFileId, request.getHeader("Accept-Language"));
String November = UINavigatorUtil.getI18nString("emxFramework.Calendar.November", ResFileId, request.getHeader("Accept-Language"));
String December = UINavigatorUtil.getI18nString("emxFramework.Calendar.December", ResFileId, request.getHeader("Accept-Language"));

//months (short name) to display on the calendar popup
String Jan = UINavigatorUtil.getI18nString("emxFramework.Calendar.Jan", ResFileId, request.getHeader("Accept-Language"));
String Feb = UINavigatorUtil.getI18nString("emxFramework.Calendar.Feb", ResFileId, request.getHeader("Accept-Language"));
String Mar = UINavigatorUtil.getI18nString("emxFramework.Calendar.Mar", ResFileId, request.getHeader("Accept-Language"));
String Apr = UINavigatorUtil.getI18nString("emxFramework.Calendar.Apr", ResFileId, request.getHeader("Accept-Language"));
String Jun = UINavigatorUtil.getI18nString("emxFramework.Calendar.Jun", ResFileId, request.getHeader("Accept-Language"));
String Jul = UINavigatorUtil.getI18nString("emxFramework.Calendar.Jul", ResFileId, request.getHeader("Accept-Language"));
String Aug = UINavigatorUtil.getI18nString("emxFramework.Calendar.Aug", ResFileId, request.getHeader("Accept-Language"));
String Sep = UINavigatorUtil.getI18nString("emxFramework.Calendar.Sep", ResFileId, request.getHeader("Accept-Language"));
String Oct = UINavigatorUtil.getI18nString("emxFramework.Calendar.Oct", ResFileId, request.getHeader("Accept-Language"));
String Nov = UINavigatorUtil.getI18nString("emxFramework.Calendar.Nov", ResFileId, request.getHeader("Accept-Language"));
String Dec = UINavigatorUtil.getI18nString("emxFramework.Calendar.Dec", ResFileId, request.getHeader("Accept-Language"));


//regular day names
String Sunday = UINavigatorUtil.getI18nString("emxFramework.Calendar.Sunday", ResFileId, request.getHeader("Accept-Language"));
String Monday = UINavigatorUtil.getI18nString("emxFramework.Calendar.Monday", ResFileId, request.getHeader("Accept-Language"));
String Tuesday = UINavigatorUtil.getI18nString("emxFramework.Calendar.Tuesday", ResFileId, request.getHeader("Accept-Language"));
String Wednesday = UINavigatorUtil.getI18nString("emxFramework.Calendar.Wednesday", ResFileId, request.getHeader("Accept-Language"));
String Thursday = UINavigatorUtil.getI18nString("emxFramework.Calendar.Thursday", ResFileId, request.getHeader("Accept-Language"));
String Friday = UINavigatorUtil.getI18nString("emxFramework.Calendar.Friday", ResFileId, request.getHeader("Accept-Language"));
String Saturday = UINavigatorUtil.getI18nString("emxFramework.Calendar.Saturday", ResFileId, request.getHeader("Accept-Language"));

//day abbreviation needed for inputting into a textbox from the calendar popup
String Sun = UINavigatorUtil.getI18nString("emxFramework.Calendar.Sun", ResFileId, request.getHeader("Accept-Language"));
String Mon = UINavigatorUtil.getI18nString("emxFramework.Calendar.Mon", ResFileId, request.getHeader("Accept-Language"));
String Tue = UINavigatorUtil.getI18nString("emxFramework.Calendar.Tue", ResFileId, request.getHeader("Accept-Language"));
String Wed = UINavigatorUtil.getI18nString("emxFramework.Calendar.Wed", ResFileId, request.getHeader("Accept-Language"));
String Thu = UINavigatorUtil.getI18nString("emxFramework.Calendar.Thu", ResFileId, request.getHeader("Accept-Language"));
String Fri = UINavigatorUtil.getI18nString("emxFramework.Calendar.Fri", ResFileId, request.getHeader("Accept-Language"));
String Sat = UINavigatorUtil.getI18nString("emxFramework.Calendar.Sat", ResFileId, request.getHeader("Accept-Language"));


//day abbreviations shown in calendar popup
String Su = UINavigatorUtil.getI18nString("emxFramework.Calendar.SundayAbbr", ResFileId, request.getHeader("Accept-Language"));
String Mo = UINavigatorUtil.getI18nString("emxFramework.Calendar.MondayAbbr", ResFileId, request.getHeader("Accept-Language"));
String Tu = UINavigatorUtil.getI18nString("emxFramework.Calendar.TuesdayAbbr", ResFileId, request.getHeader("Accept-Language"));
String We = UINavigatorUtil.getI18nString("emxFramework.Calendar.WednesdayAbbr", ResFileId, request.getHeader("Accept-Language"));
String Th = UINavigatorUtil.getI18nString("emxFramework.Calendar.ThursdayAbbr", ResFileId, request.getHeader("Accept-Language"));
String Fr = UINavigatorUtil.getI18nString("emxFramework.Calendar.FridayAbbr", ResFileId, request.getHeader("Accept-Language"));
String Sa = UINavigatorUtil.getI18nString("emxFramework.Calendar.SaturdayAbbr", ResFileId, request.getHeader("Accept-Language"));

%>
<script language="javascript">

  //XSSOK
  var STR_NAME = "<%=STR_NAME%>";
  //XSSOK
  var STR_TYPE = "<%=STR_TYPE%>";
  //XSSOK
  var STR_STATUS = "<%=STR_STATUS%>";
  //XSSOK
  var STR_LOADING = "<%=STR_LOADING%>";
  //XSSOK
  var STR_REASON = "<%=STR_REASON%>";
  //XSSOK
  var ERR_SELECT_ONLY_ONE = "<%=ERR_SELECT_ONLY_ONE%>";
  //XSSOK
  var ERR_NONE_SELECTED = "<%=ERR_NONE_SELECTED%>";
  //XSSOK
  var STR_ERROR_HEADER = "<%=STR_ERROR_HEADER%>";
  //XSSOK
  var STR_REV = "<%=STR_REV%>";
  //XSSOK
  var STR_REPLY = "<%=STR_REPLY%>";
  //XSSOK
  var STR_SUBSCRIPTION = "<%=STR_SUBSCRIPTION%>";
  //XSSOK
  var STR_SUBSCRIBE = "<%=STR_SUBSCRIBE%>";



  //months to display on the calendar popup
  //XSSOK
  var ARR_LONG_MONTH_NAMES = new Array( "<%=January%>",
            "<%=(February)%>",
            "<%=(March)%>",
            "<%=(April)%>",
            "<%=(May)%>",
            "<%=(June)%>",
            "<%=(July)%>",
            "<%=(August)%>",
            "<%=(September)%>",
            "<%=(October)%>",
            "<%=(November)%>",
            "<%=(December)%>");

  //month abbreviations needed for inputting into a textbox from the calendar popup
  var ARR_SHORT_MONTH_NAMES = new Array("<%=(Jan)%>",
            "<%=(Feb)%>",
            "<%=(Mar)%>",
            "<%=(Apr)%>",
            "<%=(May)%>",
            "<%=(Jun)%>",
            "<%=(Jul)%>",
            "<%=(Aug)%>",
            "<%=(Sep)%>",
            "<%=(Oct)%>",
            "<%=(Nov)%>",
            "<%=(Dec)%>");

  //regular day names
  var ARR_LONG_DAY_NAMES = new Array(   "<%=(Sunday)%>",
            "<%=(Monday)%>",
            "<%=(Tuesday)%>",
            "<%=(Wednesday)%>",
            "<%=(Thursday)%>",
            "<%=(Friday)%>",
            "<%=(Saturday)%>");

  //day abbreviation needed for inputting into a textbox from the calendar popup
  var ARR_DB_DAY_NAMES = new Array(     "<%=(Sun)%>",
            "<%=(Mon)%>",
            "<%=(Tue)%>",
            "<%=(Wed)%>",
            "<%=(Thu)%>",
            "<%=(Fri)%>",
            "<%=(Sat)%>");

  //day abbreviations shown in calendar popup
  var ARR_SHORT_DAY_NAMES = new Array(  "<%=(Su)%>",
            "<%=(Mo)%>",
            "<%=(Tu)%>",
            "<%=(We)%>",
            "<%=(Th)%>",
            "<%=(Fr)%>",
            "<%=(Sa)%>");

</script>

<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>

<script language="javascript">
	//XSSOK
	emxUIConstants.STR_ERROR_HEADER  = "<%=STR_ERROR_HEADER%>";
	//XSSOK
	emxUIConstants.ERR_NONE_SELECTED = "<%=ERR_NONE_SELECTED%>";
</script> 


