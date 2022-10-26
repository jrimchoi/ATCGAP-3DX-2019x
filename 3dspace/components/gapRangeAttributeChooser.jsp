<%-- gapRangeAttributeChooser.jsp - This JSP displays the signers dialog page for selection.
	@author 	 : Mayuri Sangde (ENGMASA)
	@date   	 : 08-June-2019
	@description : This page displays document signers for selection
--%>


<%@page import="com.matrixone.apps.domain.util.PropertyUtil"%>
<%@page import="com.matrixone.apps.domain.util.PersonUtil"%>
<%@page import="com.matrixone.apps.framework.ui.UIUtil"%>
<%@page import="java.util.HashMap"%>
<%@page import="matrix.db.JPO"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Vector"%>
<%@page import="com.matrixone.apps.domain.util.FrameworkUtil"%>
<%@page import="matrix.util.StringList"%>
<%@page import="java.util.Locale"%>
<%@page import="com.matrixone.apps.domain.util.EnoviaResourceBundle"%>
<%@page import="java.util.Map"%>
<%@page import="com.matrixone.apps.domain.util.MapList"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.matrixone.apps.domain.DomainObject"%>
<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<%
String languageStr = request.getHeader("Accept-Language");
String I18NResourceBundle = "emxFrameworkStringResource";
String strCancel = UINavigatorUtil.getI18nString("emxFramework.Button.Cancel",I18NResourceBundle,languageStr);
String strSelect = UINavigatorUtil.getI18nString("emxFramework.IconMail.Common.Select",I18NResourceBundle,languageStr);

String strRefinementSep =EnoviaResourceBundle.getProperty(context, "emxFramework.FullTextSearch.RefinementSeparator");
String strAttrSymName = emxGetParameter(request,"attributeName");
String strAttrDefaultVal = emxGetParameter(request,"attributeVal");
String strAttrDispName = emxGetParameter(request,"attrDispName");
String strFormName = emxGetParameter(request,"formName");
String strFieldName = emxGetParameter(request,"fieldActual");

String pageHeading = "Select "+strAttrDispName;

%>

<html>
<head>
<title><%=pageHeading%></title><!-- XSSOK -->
<%@include file="../common/emxUIConstantsInclude.inc" %>
<script language="javascript" src="../emxUIFilterUtility.js"></script>
<script src="scripts/emxNavigatorHelp.js" type="text/javascript"></script>

<script language="javascript" src="scripts/emxUICoreMenu.js"></script>
<script language="javascript" src="scripts/emxUIToolbar.js"></script>
<script language="javascript" src="scripts/emxUIDOMTypeChooser.js"></script>
<script type="text/javascript" src="../common/scripts/jquery-latest.js"></script>
<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
<script type="text/javascript">
	addStyleSheet("emxUIDefault");
	addStyleSheet("emxUIDialog");
	addStyleSheet("emxUIToolbar");
    addStyleSheet("emxUIMenu");
    addStyleSheet("emxUIList");
    if(Browser.MOBILE){
    	addStyleSheet("emxUIMobile", "mobile/styles/");	
    }
</script>
<script language="JavaScript" type="text/javascript">
$(document).ready(function(){
	  $("#txtFilter").on("keyup", function() {
	    var value = $(this).val().toLowerCase();
	    $("#rangeCol tr").filter(function() {
	        $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
	      });
	  });
	});
	function setdivPageBodyTopPos(){
		var divPageBody = document.getElementById("divPageBody");
		if(divPageBody){
			toppos = jQuery('#pageHeadDiv').height();
			divPageBody.style.top = toppos + "px";
		}
	}
	// function to set selected value in field actual
	function setValueToActualField()
	{
		var vElement = "<%=strAttrSymName%>";
		var vRadioName = "input[name='"+vElement+"']:checked";
  		var radioValue = $(vRadioName).val();
		//alert(radioValue);
		var vFormName = "<%=strFormName%>";
		var vFieldName = "<%=strFieldName%>";
		
		var vFormField = getTopWindow().getWindowOpener().document.forms[vFormName].elements[vFieldName];
		//alert(vFormField.value);
		vFormField.value = radioValue;
		
		closeWindow();
	}
	// function to close window
  function closeWindow() {
	  parent.window.closeWindow();
  }
</script>
<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
</head>
<body  class='dialog' onload="setdivPageBodyTopPos(); turnOffProgress()">
<!-- preload images -->
    <div style="display:none">
        <img src="images/utilTreeLineVert.gif" />
        <img src="images/utilTreeLineNodeClosed.gif" />
        <img src="images/utilTreeLineNode.gif" />
        <img src="images/utilTreeLineLastClosed.gif" />
        <img src="images/utilTreeLineLast.gif" />
        <img src="images/utilSpacer.gif" />
        <img src="images/iconStatusLoading.gif" />
    </div>
<div id="pageHeadDiv">
   <table>
     <tr>
   <td class="page-title">
      <h2><%=pageHeading%></h2>
    </td>
<%
         String progressImage = "../common/images/utilProgressBlue.gif";
         String processingText = UINavigatorUtil.getProcessingText(context, languageStr);
%>
        <td class="functions">
            <table><tr>
                <!-- //XSSOK -->
                <td class="progress-indicator"><div id="imgProgressDiv"><%=processingText%></div></td>
            </tr></table>
        </td>
        </tr>
      </table>

   
                <div class="toolbar-container"><div class="toolbar-frame" id="divToolbar"><div class="toolbar  toolbar-filter">
  <table border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td><input type="text" name="txtFilter" id="txtFilter" value="" size="50" onkeypress="" /></td>
      
    </tr>
  </table>      </div></div></div>
        </div>
        <div id="divPageBody"  class="listing">
					<table id="<%=strAttrSymName%>" class="list" cellpadding="0" cellspacing="0" style="table-layout: fixed; width: 100%">
					<tr>
					<tbody id="rangeCol">
					<%
						String strClass = "even";
						// get all attribute ranges
						StringList slRanges = FrameworkUtil.getRanges(context, PropertyUtil.getSchemaProperty(context, strAttrSymName));
						slRanges.sort();
						//System.out.println("strAttrDefaultVal :"+strAttrDefaultVal);
						String strRange = null;
						String strSelectedAssignee = null;
						for (int i=0; i<slRanges.size(); i++)
						{
							strRange = (String) slRanges.get(i);
							strRange = strRange.trim();
							strSelectedAssignee = DomainObject.EMPTY_STRING;
							if (strAttrDefaultVal.equals(strRange))
							  {
								  strSelectedAssignee =  "checked=\"checked\"";
							  }
							if (i % 2 == 0)
								strClass = "even";
						    else
								strClass = "odd";
					%>
					<tr class="<%=strClass%>">
		        	  <td><input type="radio" name="<%=strAttrSymName%>" id="<%=strAttrSymName%>" value="<%=strRange%>" <%=strSelectedAssignee%> />&nbsp;&nbsp;<%=strRange%></td>
		        	  </tr>
					  <%
						}
					  %>
					</tbody>
					</tr>
					</table>
        </div>

        <div id="divPageFoot">
				<table>
				<tr>
				<td class="functions">
				</td>
				<td class="buttons">                
                        <table>
                          <tr>
                            <!-- //XSSOK -->
							<td><a class="footericon" href="javascript:setValueToActualField()"><img src="../common/images/buttonDialogDone.gif" border="0" alt="<%=strSelect%>" /></a></td>
                            <!-- //XSSOK -->
							<td><a href="javascript:setValueToActualField()" class="button"><button class="btn-primary" type="button"><%=strSelect%></button></a></td>
                            <!-- //XSSOK -->
							<td><a class="footericon" href="javascript:closeWindow()"><img src="../common/images/buttonDialogCancel.gif" border="0" alt="<%=strCancel%>" /></a></td>
                            <!-- //XSSOK -->
							<td><a href="javascript:closeWindow()" class="button"><button class="btn-default" type="button"><%=strCancel%></button></a></td>
                          </tr>
                        </table>
                </td>
                </tr>
                </table>
                </div>
        <div id="divScreen"></div>
</body>
</html>
	