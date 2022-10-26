 /*
 * iwPrinterUtils.js
 *
 * Copyright (c) 2010 Integware, Inc.  All Rights Reserved.
 * This program contains proprietary and trade secret information of
 * Integware, Inc.
 * Copyright notice is precautionary only and does not evidence any
 * actual or intended publication of such program.
 *
 * $Rev: 319 $
 * $Date: 2009-10-06 15:41:58 -0600 (Tue, 06 Oct 2009) $
 */

//=================================================================
// JavaScript iwPrinterUtils
//
// Copyright (c) 1992-2010 MatrixOne, Inc.
// All Rights Reserved.
// This program contains proprietary and trade secret information of MatrixOne,Inc.
// Copyright notice is precautionary only
// and does not evidence any actual or intended publication of such program
//=================================================================
// iwPrinterUtils
//-----------------------------------------------------------------
 
    var printDialog = null;
    function callPrinterPage(heading){
		    var randomnumber=Math.floor(Math.random()*123456789101112);
		    strURL = "";
		    var strFilterit="";
		    var filteringValue="";
		    var objFrame = document.getElementById('objectHistoryFrame');
		    currentURL = objFrame.contentDocument.location.href;
		
		
		    if (currentURL.indexOf("?") == -1){
		      strURL = currentURL + "?PrinterFriendly=true&mx.rnd=" + randomnumber + "&pfheading=" + heading;
		    }else{
		      strURL = currentURL + "&PrinterFriendly=true&mx.rnd=" + randomnumber + "&pfheading=" + heading;
		    }
		    iWidth = "700";
		    iHeight = "600";
		    bScrollbars = true;
		
		      //make sure that there isn't a window already open
		    if (!printDialog || printDialog.closed) {
		
		      //build up features string
		      var strFeatures = "width=" + iWidth  + ",height= " +  iHeight + ",resizable=yes";
		
		      //calculate center of the screen
		      var winleft = parseInt((screen.width - iWidth) / 2);
		      var wintop = parseInt((screen.height - iHeight) / 2);
		
		      if (isIE)
		        strFeatures += ",left=" + winleft + ",top=" + wintop;
		      else
		        strFeatures += ",screenX=" + winleft + ",screenY=" + wintop;
		
		      strFeatures +=  ",toolbar=yes";
		
		      //are there scrollbars?
		      if (bScrollbars) strFeatures += ",scrollbars=yes";
		
		      //open the window
		      printDialog = window.open(strURL, "printDialog" + (new Date()).getTime(), strFeatures);
		
		      //set focus to the dialog
		      printDialog.focus();
		
		    } else {
		          //if there is already a window open, just bring it to the forefront (NCZ, 6/4/01)
		      if (printDialog) printDialog.focus();
		    }
		  }
		   
		   function openPrinterFriendlyPage(){
		       callPrinterPage('<%=header%>');
		   }

