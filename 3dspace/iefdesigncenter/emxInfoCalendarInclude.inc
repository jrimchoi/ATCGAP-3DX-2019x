<%--  emxInfoCalendarInclude.inc

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--     emxInfoCalendarInclude.jsp This file includes the Calendar dialog


   static const char RCSID[] = "$Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxInfoCalendarInclude.inc 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$";

--%>


<script language="Javascript">

  //get date to start with
  todayDate=new Date();
  thismonth=todayDate.getMonth()+1;
  thisday=todayDate.getDate();
  thisyear=todayDate.getYear();

  //incorrect year is obtained in netscape (add 1900 if below 500)
  if (thisyear < 500){
    thisyear = thisyear + 1900;
  }

  originalLocation = "emxInfoCalendarPopup.jsp?day=" + thisday + "&month=" + thismonth + "&year=" + thisyear;

  function getDate(formName,dateField){
// updatedLocation = originalLocation + "&formName=" + formName + "&dateField=" + escape(dateField);
   var dateFieldEnoded=dateField;
   var isIE = navigator.userAgent.toLowerCase().indexOf("msie") > -1;	
   if(!isIE)
	dateFieldEnoded = escape(dateFieldEnoded);
   else{
      while(dateFieldEnoded.indexOf(" ")!=-1){
	  dateFieldEnoded=dateFieldEnoded.replace(' ','+');
      }
   }

  updatedLocation = originalLocation + "&formName=" + formName + "&dateField=" + dateFieldEnoded;
  window.open(updatedLocation,'SelectDate','height=280,width=300,screenX=238,left=238,screenY=135,top=135,status=no,toolbar=no,menubar=no,location=no');
  }

  //To change the date value
  function changeDate(m,d,y,formName,dateField){
    // DATE FORMAT MM/DD/YYYY
    formattedDate = m + "/" + d + "/" + y;
    var formObject = document.forms[formName];
    var k;
    var obj;
    for(k=0;k<formObject.elements.length;k++)
    {
       obj = formObject.elements[k];
	if(obj.name == dateField){
		obj.value=formattedDate;
		break;
	}
    }
    //var fieldObject = formObject.elements[dateField];    
    //fieldObject.value=formattedDate;
  }

</script>

<%--        Sample code showing a table and how to get a formatted date

            getDate(  FORM NAME , FIELD NAME )

<form name=tempform >

<input type=text name=date value="">
<a href="javascript:getDate('tempform','date')" ><img src="images/iconCalendarSmall.gif" border=0></a>

</form>


--%>
