<%--  emxInfoCalendarPopup.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--     

   static const char RCSID[] = "$Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxInfoCalendarPopup.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$";

--%>

<%@include file= "emxInfoCentralUtils.inc"%>

<%
  //prevent caching
  response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
  response.setHeader("Pragma","no-cache"); //HTTP 1.0
  response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
%>



<HTML>
<HEAD>
<meta http-equiv="Expires" content="0">
  <TITLE><framework:i18n localize="i18nId">emxIEFDesignCenter.CalendarPopup.SelectaDate</framework:i18n></TITLE>

</HEAD>

<BODY bgcolor="white" text="black" onBlur="self.focus()">
<CENTER>



<style type=text/css>
A {text-decoration:none;font-weight:bold;color:#336699}
A.activeday {text-decoration:none;font-weight:bold;color:#ffffff}
</style>

<%
  //get jsp parameters
  String day = emxGetParameter(request, "day");
  String month = emxGetParameter(request, "month");
  String year = emxGetParameter(request, "year");
  String formName = emxGetParameter(request, "formName");
  String dateField = emxGetParameter(request, "dateField");

%>


<SCRIPT LANGUAGE="JavaScript">

<!-- Begin
CURRENT_DAY_HIGHLITE_BGCOLOR="#336699";
MONTH_NAME_BGCOLOR="white";
MONTH_NAME_FONT_SIZE="4";
MONTH_NAME_FONT_COLOR="black";
MONTH_DAYS_BGCOLOR="white";
MONTH_DAYS_FONT_SIZE="3";
WEEK_DAY_HEADING_BGCOLOR="#336699";
WEEK_DAY_HEADING_FONT_SIZE="3";
WEEK_DAY_FONT_COLOR="white";
NON_MONTH_DAY_BGCOLOR="#AAAAAA";

//XSSOK
FORMNAME = "<%=formName%>";
//XSSOK
DATEFIELD = "<%=dateField%>";

monthnames = new Array(
"January",
"February",
"March",
"April",
"May",
"June",
"July",
"August",
"September",
"October",
"November",
"December");

var linkcount=0;

function addlink(month, day, href)
{
  var entry = new Array(3);
  entry[0] = month;
  entry[1] = day;
  entry[2] = href;
  this[linkcount++] = entry;
}

Array.prototype.addlink = addlink;
linkdays = new Array();
monthdays = new Array(12);
monthdays[0]=31;
monthdays[1]=28;
monthdays[2]=31;
monthdays[3]=30;
monthdays[4]=31;
monthdays[5]=30;
monthdays[6]=31;
monthdays[7]=31;
monthdays[8]=30;
monthdays[9]=31;
monthdays[10]=30;
monthdays[11]=31;


//XSSOK
todayDate=new Date(<%=year%>,(<%=month%>-1),<%=day%>);

// get vars from javascript data object
thisday=todayDate.getDay();
thismonth=todayDate.getMonth();
thisdate=todayDate.getDate();
thisyear=todayDate.getYear();





//browser details
browserAppName = navigator.appName;

//adjust year
if (browserAppName == "Netscape") {   //netscape detected
  thisyear = ((thisyear < 50) ? (2000 + thisyear) : (1900 + thisyear));
} else{
  thisyear = ((thisyear < 100) ? (1900 + thisyear) : (thisyear));
}

//adjust for leap year
if (((thisyear % 4 == 0) && !(thisyear % 100 == 0)) || (thisyear % 400 == 0))
  monthdays[1]++;

//find start spaces
var firstOfMonth = new Date (thisyear, thismonth, 1);
// GET THE DAY OF THE WEEK THE FIRST DAY OF THE MONTH FALLS ON
startspaces  = firstOfMonth.getDay();


while (startspaces > 7)
  startspaces-=7;


if (startspaces < 0)
  startspaces+=7;

//adjust month vars
thismonth++;

//create link vars for toggling by month
minusmonth = ((thismonth == 1) ? (12) : (thismonth-1));
plusmonth = ((thismonth == 12) ? (1) : (thismonth+1));
minusyear = ((thismonth == 1) ? (thisyear-1) : (thisyear));
plusyear = ((thismonth == 12) ? (thisyear+1) : (thisyear));





//next/previous button for months and years
document.write("<table width=220 border=0 cellpadding=0 cellspacing=0>");
document.write("<tr><td colspan=6 class=light><img src=images/utilSpace.gif width=1 height=1></td></tr>");
document.write("<tr><td ><a href=\"javascript:reloadspecific('" + (parseInt(minusmonth)) + "','" + (parseInt(minusyear)) + "')\" ><img src=images/iconCalendarPrevious.gif border=0></a></td><td valign=middle align=center class=ltgray><b>&nbsp;Month&nbsp;</b></td><td align=right><a href=\"javascript:reloadspecific('" + (parseInt(plusmonth)) + "','" + (parseInt(plusyear)) + "')\" ><img src=images/iconCalendarNext.gif border=0></a></td>");
document.write("<td ><a href=\"javascript:reloadspecific('" + (parseInt(thismonth)) + "','" + (parseInt(thisyear)-1) + "')\" ><img src=images/iconCalendarPrevious.gif border=0></a></td><td valign=middle align=center class=ltgray><b>&nbsp;Year&nbsp;</b></td><td align=right><a href=\"javascript:reloadspecific('" + (parseInt(thismonth)) + "','" + (parseInt(thisyear)+1) + "')\" ><img src=images/iconCalendarNext.gif border=0></a></td></tr>");
document.write("<tr><td colspan=6 class=light><img src=images/utilSpace.gif width=1 height=1></td></tr>");
document.write("<tr><td colspan=6 >&nbsp;</td></tr></table>");



document.write("<table border=2 bgcolor=white width=220 ");
document.write("bordercolor=\"black\"><font color=\"black\" face=\"arial, helvetica, sans-serif, swiss, verdana\">");
document.write("<tr><td colspan=7 bgcolor='"+MONTH_NAME_BGCOLOR+"'><font color=\""+MONTH_NAME_FONT_COLOR+"\" size="+MONTH_NAME_FONT_SIZE+" face=\"arial, helvetica, sans-serif, swiss, verdana\"><center><strong>" + monthnames[thismonth-1] + " " + thisyear + "</strong></center></font></td></tr>");
document.write("<tr bgcolor='"+WEEK_DAY_HEADING_BGCOLOR+"'>");
document.write("<td align=center><font color='"+WEEK_DAY_FONT_COLOR+"' size="+WEEK_DAY_HEADING_FONT_SIZE+" face=\"arial, helvetica, sans-serif, swiss, verdand\"><b>Su</font></td>");
document.write("<td align=center><font color='"+WEEK_DAY_FONT_COLOR+"' size="+WEEK_DAY_HEADING_FONT_SIZE+" face=\"arial, helvetica, sans-serif, swiss, verdand\"><b>M</font></td>");
document.write("<td align=center><font color='"+WEEK_DAY_FONT_COLOR+"' size="+WEEK_DAY_HEADING_FONT_SIZE+" face=\"arial, helvetica, sans-serif, swiss, verdand\"><b>Tu</font></td>");
document.write("<td align=center><font color='"+WEEK_DAY_FONT_COLOR+"' size="+WEEK_DAY_HEADING_FONT_SIZE+" face=\"arial, helvetica, sans-serif, swiss, verdand\"><b>W</font></td>");
document.write("<td align=center><font color='"+WEEK_DAY_FONT_COLOR+"' size="+WEEK_DAY_HEADING_FONT_SIZE+" face=\"arial, helvetica, sans-serif, swiss, verdand\"><b>Th</font></td>");
document.write("<td align=center><font color='"+WEEK_DAY_FONT_COLOR+"' size="+WEEK_DAY_HEADING_FONT_SIZE+" face=\"arial, helvetica, sans-serif, swiss, verdand\"><b>F</font></td>");
document.write("<td align=center><font color='"+WEEK_DAY_FONT_COLOR+"' size="+WEEK_DAY_HEADING_FONT_SIZE+" face=\"arial, helvetica, sans-serif, swiss, verdand\"><b>Sa</font></td>");
document.write("</tr>");
document.write("<tr>");

for (s=0;s<startspaces;s++)
  document.write("<td bgcolor='"+NON_MONTH_DAY_BGCOLOR+"'>&nbsp;</td>");


count=1;
while (count < (monthdays[(thismonth-1)]) + 1)
{
  for (b = startspaces; b < 7 ;b++)
  {
    linktrue=true;

    if(count==thisdate)
      document.write("<td bgcolor='"+CURRENT_DAY_HIGHLITE_BGCOLOR+"' align=center><font size='"+MONTH_DAYS_FONT_SIZE+"'>");
    else if(count < (monthdays[(thismonth-1)] + 1))
      document.write("<td bgcolor="+MONTH_DAYS_BGCOLOR+" align=center><font size='"+MONTH_DAYS_FONT_SIZE+"'>");
    else
      document.write("<td bgcolor='"+NON_MONTH_DAY_BGCOLOR+"'><font size='"+MONTH_DAYS_FONT_SIZE+"'>");


    if (count==thisdate)
      document.write("<font size='"+MONTH_DAYS_FONT_SIZE+"' ><strong>");

    if (count < (monthdays[(thismonth-1)] + 1))
    {
      document.write("<a ");
      if (count==thisdate)     document.write(" class=activeday ");

      // we need to return a 2 digit year
      // if the year comes back between 0-9 we need to apped a 0
      thisyear = thisyear % 100
      if (thisyear < 10)
         thisyear = "0" + thisyear;

      document.write(" href=\"javascript:setday('" + (thismonth) + "','" +  count + "','" + thisyear + "')\">")
      document.write("<font face='arial, helvetica, sans-serif, swiss, verdana'>")
      document.write(count);
      document.write("</font>")
      document.write("</a>")
    }
    else
      document.write("&nbsp;");
    if (count==thisdate)
      document.write("</strong></font>");
    if (linktrue)
      document.write("</a>");
    document.write("</td>");
    count++;
  }
  document.write("</tr>");
  document.write("<tr>");
  startspaces=0;
}
document.write("</table></p>");

 function setday(m,d,y){  
   opener.changeDate(m,d,y,FORMNAME,DATEFIELD);
   window.close();
 }

 function reloadspecific(newmonth,newyear){
   
  // newloc = "emxInfoCalendarPopup.jsp?day=1&month=" + newmonth + "&year=" + newyear + "&formName=" + escape(FORMNAME) + "&dateField=" + escape(DATEFIELD);
   var isIE = navigator.userAgent.toLowerCase().indexOf("msie") > -1;	
   if(!isIE){
	FORMNAME = escape(FORMNAME);
	DATEFIELD = escape(DATEFIELD);
   }
   else{
      while(FORMNAME.indexOf(" ")!=-1){
        FORMNAME = FORMNAME.replace(' ','+');
      }
      while(DATEFIELD.indexOf(" ")!=-1){
        DATEFIELD = DATEFIELD.replace(' ','+');
      }
   }
   newloc = "emxInfoCalendarPopup.jsp?day=1&month=" + newmonth + "&year=" + newyear + "&formName=" + FORMNAME + "&dateField=" + DATEFIELD;
   document.location = newloc;
 }
 function reload(){
   var isIE = navigator.userAgent.toLowerCase().indexOf("msie") > -1;	
   if(!isIE){
	FORMNAME = escape(FORMNAME);
	DATEFIELD = escape(DATEFIELD);
   }
   else{
      while(FORMNAME.indexOf(" ")!=-1){
        FORMNAME = FORMNAME.replace(' ','+');
      }
      while(DATEFIELD.indexOf(" ")!=-1){
        DATEFIELD = DATEFIELD.replace(' ','+');
      }
   }

  newloc = "emxInfoCalendarPopup.jsp?day=1&month=" + (document.form1.month.selectedIndex + 1) + "&year=" + (document.form1.year.selectedIndex + 1990) + "&formName=" + FORMNAME + "&dateField=" + DATEFIELD;
  document.location = newloc;
 }
// End -->
</SCRIPT>
</CENTER>

</BODY>
</HTML>
