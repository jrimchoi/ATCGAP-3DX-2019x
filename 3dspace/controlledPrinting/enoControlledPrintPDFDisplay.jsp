<%--  enoControlledPrintPDFDisplay.jsp
   Copyright (c) 1992-2018 Dassault Systemes.
   All Rights Reserved.
   This program contains proprietary and trade secret information of MatrixOne,Inc.
   Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

   static const char RCSID[] = $Id: emxRenderPDFDisplay.jsp.rca 1.6 Wed Oct 22 15:48:13 2008 przemek Experimental przemek $
--%>
<%@page import="com.dassault_systemes.enovia.controlledprinting.ControlledPrintingConstants"%>
<%@page import="com.matrixone.apps.domain.util.EnoviaResourceBundle"%>
<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<%@ page import="java.net.URLEncoder" %>
<html>
<head>
<title> 
 <emxUtil:i18n localize="i18nId">emxFramework.RenderPDF.Tooltip</emxUtil:i18n>
</title>
<%@include file = "../common/emxUIConstantsInclude.inc"%>
  <script language="javascript" src="../common/scripts/emxUIModal.js"></script>
  <script language="javascript" src="../emxUIPageUtility.js"></script>
  <script type="text/javascript">
      addStyleSheet("emxUIDefault");
  </script>
</head>

<%
  String renderPDFProcessingMessage = EnoviaResourceBundle.getProperty(context, ControlledPrintingConstants.CONTROLLED_PRINT_STRINGRESOURCE,context.getLocale(), "enoControlledPrinting.RenderPDF.RenderPDFProcessingMessage");
  String renderPDFMessage = EnoviaResourceBundle.getProperty(context, ControlledPrintingConstants.CONTROLLED_PRINT_STRINGRESOURCE,context.getLocale(), "enoControlledPrinting.RenderPDF.RenderPDFMessage");
  String renderPDFDoneMessage = EnoviaResourceBundle.getProperty(context, ControlledPrintingConstants.CONTROLLED_PRINT_STRINGRESOURCE,context.getLocale(), "enoControlledPrinting.RenderPDF.RenderPDFDoneMessage");
  String printSuccessfull = EnoviaResourceBundle.getProperty(context, ControlledPrintingConstants.CONTROLLED_PRINT_STRINGRESOURCE,context.getLocale(), "enoControlledPrinting.RenderPDF.PrintSucessfull");
  String failToPrint = EnoviaResourceBundle.getProperty(context, ControlledPrintingConstants.CONTROLLED_PRINT_STRINGRESOURCE,context.getLocale(), "enoControlledPrinting.ControlledPrint.PDFGenerationFail");
  
  String printPDFMessage = EnoviaResourceBundle.getProperty(context, ControlledPrintingConstants.CONTROLLED_PRINT_STRINGRESOURCE,context.getLocale(), "enoControlledPrinting.RenderPDF.RenderPrintMessage");
  String printPDFDoneMessage = EnoviaResourceBundle.getProperty(context, ControlledPrintingConstants.CONTROLLED_PRINT_STRINGRESOURCE,context.getLocale(), "enoControlledPrinting.RenderPDF.RenderPrintDoneMessage");
  
  String queryString = request.getQueryString();
  String url = "../controlledPrinting/Execute.jsp?executeAction=ENOControlledPrint:getControlledCopy&submitAction=doNothing&ajaxMode=true&suiteKey=ControlledPrinting";
  String strQueryString="";
  String encodedURL="";
  String printMethod="";
%>
<%
    Map<String, String[]> parameterMap1 = new HashMap<String, String[]>();
    Enumeration paramEnum1 = emxGetParameterNames (request);
    while (paramEnum1.hasMoreElements()) {
        String parameter1 = (String)paramEnum1.nextElement();
        
        String[] values1 = emxGetParameterValues(request, parameter1);
        if(parameter1.equals("PrintMethod"))
        {
			printMethod=values1[0];
        }
          for (String value1 : values1) {
        	   strQueryString+="&" + parameter1 + "="+ URLEncoder.encode(value1);
            }
    }
	
    %>
<!-- //XSSOK -->
<body class="confirmDownload" onload=submitForm('<%=url%>','<%=strQueryString %>') >
   <div id="confirmDownload">
     <p><%=renderPDFProcessingMessage%></p>
  <%   if(printMethod.equals(ControlledPrintingConstants.RANGE_PRINT_USING_LOCALMACHINE))
	  	{
  %>
	  		<p><%=renderPDFMessage%></p>
   		  	<p><%=renderPDFDoneMessage%></p>
  <%
		}
  else if(printMethod.equals(ControlledPrintingConstants.RANGE_PRINT_USING_SERVER))
  	{
	  %>
	  <p><%=printPDFMessage%></p>
     		<p><%=printPDFDoneMessage%></p>
	     	
 <%
 	}
  %> 
     <p><a href="javascript:getTopWindow().close()"><emxUtil:i18n localize="i18nId">emxFramework.Button.Cancel</emxUtil:i18n></a></p>
    </div>

   
<form name="forwardForm" method="post" target="">
    <%
    final boolean debug = "true".equalsIgnoreCase(emxGetParameter(request, "debug"));
    if (debug) {
        System.out.println("-----Parameters to " + request.getRequestURI() + "-----");
    }
    // Collect all the parameters
    Map<String, String[]> parameterMap = new HashMap<String, String[]>();
    Enumeration paramEnum = emxGetParameterNames (request);
    while (paramEnum.hasMoreElements()) {
        String parameter = (String)paramEnum.nextElement();
        String[] values = emxGetParameterValues(request, parameter);
        
        parameterMap.put(parameter, values);
        
        for (String value : values) {
            if (debug) {
                System.out.println(parameter + "=" + value);
            }
    %> <input type="hidden" name="<%=parameter%>"
    value="<xss:encodeForHTMLAttribute><%=value%></xss:encodeForHTMLAttribute>" /><%        
        }
    }
    if (debug) {
        System.out.println("-----");
    }%>
</form>

</body>
</html>

<script>
    function submitForm(url,strQueryString)
    {
	      	var finalStep = url.indexOf("final");
	    	if(finalStep<0){
		    	var responseText = emxUICore.getDataPost(url,strQueryString,successCallBack);
}
		
    }

function successCallBack(responseText )
{

	    		var zipName = responseText.split("|")[0];
		    	var enoviaURL = responseText.split("|")[1];
		    	var printMethod = responseText.split("|")[2];
		    	if(printMethod=='<%=ControlledPrintingConstants.RANGE_PRINT_USING_LOCALMACHINE%>')
		    	{
		    		var countFiles=1;
			    	var res = new Array();
			    	if(zipName.indexOf(",")>0)
			    	{
			    		
			    		res = zipName.split(",");
			    		countFiles=res.length;
			    	}
			    	else
			    		res[0]=zipName;
			    	
			    	for(var i=0;i<countFiles;i++)
		    		{
			    	
			    			enoviaURL = responseText.split("|")[1];
			    			var altURL = enoviaURL.concat("/myDownloadPackage&zipFileName="+res[i]);
					    	var parameters = new Object();
					        parameters.zipFileName = res[i];
					      
var isSafari = navigator.vendor && navigator.vendor.indexOf('Apple') > -1 &&
                   navigator.userAgent &&
                   navigator.userAgent.indexOf('CriOS') == -1 &&
                   navigator.userAgent.indexOf('FxiOS') == -1;
 

					       if(!isSafari){
					        parameters.ContentDisposition = "inline";
							}
					        formObj1 = document.forms["forwardForm"];
					        var newURL = enoviaURL.concat("/myDownloadPackage");
					        
					        var zipElement=document.getElementsByName("zipFileName")
					        if(zipElement.length>0)
					        	formObj1.removeChild(zipElement[0]);
					        
				        	for(var parameterName in parameters) {
					        		
				        			var inputElement = document.createElement("input");
						            inputElement.setAttribute("type", "hidden");
						            inputElement.setAttribute("name", parameterName);
						            inputElement.setAttribute("value", parameters[parameterName]);
						            formObj1.appendChild(inputElement);
				        	
					        }
	                       formObj1.setAttribute('method', "post");
						   formObj1.setAttribute('action', newURL);
						   formObj1.setAttribute("target",'formresult' + i);
						  window.open(newURL,'formresult' + i);
						   formObj1.submit();
					
			    		
			    	}
		    	}
		    	else if(printMethod=='<%=ControlledPrintingConstants.RANGE_PRINT_USING_SERVER%>') {
		    		alert('<%=printSuccessfull%>');
		    	}
		    	else
		    		alert('<%=failToPrint%>');


}
</script>

