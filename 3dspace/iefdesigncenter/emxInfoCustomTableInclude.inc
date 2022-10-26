<%--  emxInfoCustomTableInclude.inc

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  
  $Archive: /InfoCentral/src/infocentral/emxInfoCustomTableInclude.inc $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$
  
  Name of the File :emxInfoCustomTableInclude.inc
  
  Description : This jsp page includes common javascript and jsp functions for
                Custom Table 


--%>

<%--
 *
 * $History: emxInfoCustomTableInclude.inc $
 * 
 * *****************  Version 23  *****************
 * User: Rahulp       Date: 1/15/03    Time: 1:25p
 * Updated in $/InfoCentral/src/infocentral
 * 
 ***********************************************
 --%>
<%@include file = "emxInfoCentralUtils.inc"%>

<jsp:useBean id="emxNavErrorObject" class="com.matrixone.apps.domain.util.FrameworkException" scope="request"/>
<script language="JavaScript">
    function cleanupCustomTableSession (timeStamp)
    {
               
        var url = "emxInfoCustomTableCleanupSession.jsp?timeStamp=" + timeStamp;
	var winparams = "width=1,height=1,screenX=2000,screenY=2000,top=2000,left=2000,resizable=no";
	var win = window.open(url,"",winparams);		
    
    }
        
    function reloadCustomTable(sortKey, nextSortDirection,sortType)
    {
        var url = "emxInfoCustomTableBody.jsp?custReSortKey=" + sortKey + "&custPageNo=1";
        if (nextSortDirection != null)
            url = url + "&custSortDirection=" + nextSortDirection + "&custSortType=" + sortType;
           
        // Change the sortColumnName in footer
        parent.listFoot.document.footerForm.custSortColumnName.value = sortKey;
        parent.listFoot.document.footerForm.custReSortKey.value = sortKey;

        var footerUrl = "emxInfoCustomTableFooter.jsp?custPageNo=1&custSortColumnName=" + sortKey;
        document.emxTableForm.action = footerUrl;
        document.emxTableForm.target = "listFoot";
        document.emxTableForm.submit();

        document.emxTableForm.custSortColumnName.value = sortKey;
        document.emxTableForm.action = url;
        document.emxTableForm.target = "_self";
        document.emxTableForm.submit();

        // parent.listFoot.location.href=parent.listFoot.location.href;
        // parent.listFoot.document.footerForm.reSortKey.value = sortKey;
    }
    
    var printDialog = null;
function openPrinterFriendlyPage()
{
	openCustomTablePrinterFriendlyPage();
}
    function openCustomTablePrinterFriendlyPage()
    {
        var strURL = "";
        currentURL = parent.frames[1].document.location.href;
        if (currentURL.indexOf("?") == -1)
            strURL = currentURL + "?PFmode=true";
        else
            strURL = currentURL + "&PFmode=true";

        //make sure that there isn't a window already open
		if (!printDialog || printDialog.closed) {

			var strFeatures = "scrollbars=yes,toolbar=yes,location=no,resizable=yes";
            printDialog = window.open("../common/emxBlank.jsp", "PF" + (new Date()).getTime(), strFeatures);

			//set focus to the dialog
			printDialog.focus();

		} else {
					//if there is already a window open, just bring it to the forefront (NCZ, 6/4/01)
			if (printDialog) printDialog.focus();
		}

		strTarget = printDialog.name;
		

        // var pageUrl = "emxTableBody.jsp?PFmode=true";
        var pageUrl = strURL;
        parent.listDisplay.document.emxTableForm.action = pageUrl;
        parent.listDisplay.document.emxTableForm.target = strTarget;
        parent.listDisplay.document.emxTableForm.submit();
    }
 
    function emxTableColumnLinkClick(href, width, height, modal, target)
    {
        var url = href;
        var windowObject;
        var targetFrame;
        if (target == "popup")
        {
            if (modal == "true")
                windowObject = showModalDialog(url, width, height);
            else
                windowObject = showNonModalDialog(url, width, height);
        } else {

            targetFrame = findFrame(top, target);
         
	        //if there is a target, assign the form's target to it
	        if (targetFrame)
	        {
		        //document.emxTableForm.target = targetFrame.name;
                //assign the URL to the form's action (NCZ, 1/15/02)
	            //document.emxTableForm.action = href;

	            //submit the form (NCZ, 1/15/02)
	            //document.emxTableForm.submit();
	             targetFrame.location = href;
	     
            } else {
                alert("Unable to find the target frame : " + target);
                windowObject = showNonModalDialog(url, '750', '600');
            }
        }
    }

    function doCheck()
    {
       if (document.emxTableForm.emxTableRowId)
       {
          for (var i = 0; i < document.emxTableForm.elements.length; i++)
          {
              var checkbox = document.emxTableForm.elements[i];
              if ((checkbox.name == 'emxTableRowId') && (checkbox.type == 'checkbox')){
			 // if(checkbox.disabled==false)
              checkbox.checked = document.emxTableForm.chkList.checked;
			  }
          }
      }
    }



</script>    
<%!
static public String parseTableHeader(ServletContext application, Context context, String header, String objectId, String suiteKey, String locale)
{

    String registeredSuite = "";
    String suiteDir = "";
    String stringResFileId = "";
    
    try {

        if ( suiteKey != null && suiteKey.startsWith("eServiceSuite") )
            registeredSuite = suiteKey.substring(13);
        else if( suiteKey != null)
             registeredSuite = suiteKey;

        if ( (registeredSuite != null) && (registeredSuite.trim().length() > 0 ) )
        {
          suiteDir = UINavigatorUtil.getRegisteredDirectory(application, registeredSuite);
          stringResFileId = UINavigatorUtil.getStringResourceFileId(application, registeredSuite);
          
        }

        if( header != null && header.trim().length() > 0 )
        {
            // Get the label from string resource, if it does not contain macros.
            header = UINavigatorUtil.getI18nString(header, stringResFileId , locale);

            // Then if the label contain macros, parse them
            if (header.indexOf("$") >= 0 )
            {
                if (objectId != null && objectId.length() > 0 )
                {
                    header = UIExpression.substituteValues(context, header, objectId);
                } else {
                    header = UIExpression.substituteValues(context, header);
                }
            }
        }
    } catch (Exception ex) {
        System.out.println("emxTable:parseTableHeader - error : " + ex.toString() );
        return header;
    }

    return header;
}
%>
<%!
String convJS(Object s) {
// Convert special characters to JavaScript Escaped values
  if (s == null) {
    return "";
  }
  
  String t = (String)s;
  t = replace(t,"\\","\\\\"); // replace backslash with \\
  t = replace(t,"'","\\\'");  // replace an single quote with \'
  t = replace(t,"\"","\\\""); // replace a double quote with \"
  t = replace(t,"\r","\\r"); // replace CR with \r;
  t = replace(t,"\n","\\n"); // replace LF with \n;

  return t;
} 
%>

<%!
String replace(String s, String one, String another) {
// In a string replace one substring with another
  if (s.equals("")) return "";
  String res = "";
  int i = s.indexOf(one,0);
  int lastpos = 0;
  while (i != -1) {
    res += s.substring(lastpos,i) + another;
    lastpos = i + one.length();
    i = s.indexOf(one,lastpos);
  }
  res += s.substring(lastpos);  // the rest
  return res;  
}
%>


<%!
  
    static public String i18nStringNowUtil( String key,String languageStr) {

        com.matrixone.apps.domain.util.i18nNow loc = new com.matrixone.apps.domain.util.i18nNow();
        String returnString = (String)loc.GetString("emxIEFDesignCenterStringResource", languageStr, key);
        if(returnString != null || !"null".equalsIgnoreCase(returnString)){
        	returnString = returnString.trim();
        }
        return returnString;
    }

%>


<script language="JavaScript">
//Added on 27/3/2004 for AEF style toolbar change - start
    function checkAll()
    {
        
      if (document.emxTableForm.emxTableRowId)
      {
         
          for (var i = 0; i < document.emxTableForm.elements.length; i++)
          {
              var checkbox = document.emxTableForm.elements[i];

              if ((checkbox.name == 'emxTableRowId') && (checkbox.type == 'checkbox'))
	      {
	              checkbox.checked = document.emxTableForm.chkList.checked;
                      var strID = checkbox.value;
                if (checkbox.checked)
                    register(strID);
                else
                    unregister(strID);

              }
          }
      }
    }

function register(strID) {
	
	var toolBarFrame;
	if (parent.frames){
		toolBarFrame = findFrame(parent, "listHead");
		if (!toolBarFrame){
			toolBarFrame = parent.frames[0];
		}
	}

    if (!parent.ids) {
            parent.ids = "~";
    }

    if (parent.ids.indexOf(strID + "~") == -1) {
            parent.ids += strID + "~";
    }

	if (toolBarFrame && toolBarFrame.toolbars && toolBarFrame.toolbars.setListLinks) {
    	toolBarFrame.toolbars.setListLinks( parent.ids.length > 1);
	}
}

function unregister(strID) {
    var strTemp = parent.ids;
	var toolBarFrame;
	
	if (parent.frames){
		toolBarFrame = findFrame(parent, "listHead");
		if (!toolBarFrame){
			toolBarFrame = parent.frames[0];
		}		
	}
	        
    if (strTemp.indexOf("~" + strID + "~") > -1) {
            strTemp = strTemp.replace(strID + "~", "");
            parent.ids = strTemp;
    }
    if (toolBarFrame && toolBarFrame.toolbars && toolBarFrame.toolbars.setListLinks) {
            toolBarFrame.toolbars.setListLinks( parent.ids.length > 1);
    }
}


function doCheckboxClick(objCheckbox) {
    if (objCheckbox.checked)
        register(objCheckbox.value);
    else
        unregister(objCheckbox.value);
}
function doSelectAllCheck()
{
    var objForm = document.forms["emxTableForm"];
    var checkAll = true;
    if (objForm.emxTableRowId)
    {
        if (objForm.emxTableRowId[0])
        {                               
            for (var i = 0; i < objForm.emxTableRowId.length; i++)
            {
                if(!objForm.emxTableRowId[i].checked)
                {
                  checkAll=false;
                  break;
                }                    
            }
        } else { 
             
                if(!objForm.emxTableRowId.checked)
                 {
                    checkAll=false; 
                 }                
        }
       
       document.emxTableForm.chkList.checked=checkAll;
    }
}
//Added on 27/3/2004 for AEF style toolbar change - End
</script>

    

    
    
