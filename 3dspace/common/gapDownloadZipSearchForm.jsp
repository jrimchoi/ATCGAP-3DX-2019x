<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.Integer" %>
<%@ page import="java.lang.Integer" %>
<%@ page import="com.dassault_systemes.vplmposadministrationui.uiutil.AdminUtilities"%>
<%@include file = "../common/emxPLMOnlineIncludeStylesScript.inc"%>
<%@include file = "../common/emxPLMOnlineAdminAttributesCalculation.jsp"%>

<%--
    Document   : gapDownloadZipSearchForm.jsp
    Author     : ENGMASA
    Modified : 19/10/2010 -> New UI 
--%>
 <%
        /*get request parameters*/
        String source = "DocTitle";// emxGetParameter(request,"source");
 final String ENGINEERING_STRING_RESOURCE = "emxEngineeringCentralStringResource";
 final String strLanguage = request.getHeader("Accept-Language");
        %>
<html>
    <head>
    	
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script language="javascript" src="../common/scripts/jquery-latest.js"></script>
	<script language="javascript" src="../common/scripts/emxUICore.js"></script>
	<script language="javascript" src="../common/scripts/emxUIModal.js"></script>
	<script language="JavaScript" src="scripts/emxUICoreMenu.js"></script>
<script language="JavaScript" src="scripts/emxUIActionbar.js"></script>
<script language="JavaScript" src="scripts/emxUIToolbar.js"></script>
<script language="javascript" src="scripts/emxNavigatorHelp.js"></script>

<script language="javascript" src="../common/scripts/emxUIObjMgr.js"></script>
<script language="JavaScript" src="../common/scripts/jquery-latest.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/jshashtable/jshashtable.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/jquery-numberformatter/jquery-numberformatter.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUITableUtil.js" type="text/javascript"></script>
<script language="javascript" src="../common/scripts/emxUIFormUtil.js" type="text/javascript"></script>
<script language="JavaScript" src="../common/scripts/emxUIPopups.js" type="text/javascript"></script>
<script language="javascript" src="scripts/emxUICalendar.js"></script>
<script language="javascript" src="scripts/emxQuery.js"></script>
<script type="text/javascript" src="../webapps/AmdLoader/AmdLoader.js"></script>
<script type="text/javascript">window.dsDefaultWebappsBaseUrl = "../webapps/";</script>
<script type="text/javascript" src="../webapps/WebappsUtils/WebappsUtils.js"></script>
<script type="text/javascript" src="../webapps/c/UWA/js/UWA_W3C_Alone.js"></script>
<script language="javascript" src="scripts/emxTypeAhead.js"></script>
<script type="text/javascript" src="scripts/emxUIFormHandler.js"></script>	
    <link rel="stylesheet" type="text/css" href="../common/styles/emxUIForm.css" />
        <script>
        $(document).ready(function(){
        	$('textarea').keyup(function(vKey) {
                var vCharCode = vKey.keyCode;
                var vFieldName = $(this).attr("name");
                // if not file name
                if (vFieldName!="FileName" && vFieldName!="DocTitle" && vFieldName!="Description")
                {
                 /* if (vCharCode==56)
                  {
                  //	alert($(this).val());
                      var vVal = $(this).val();
                      vVal = vVal.slice(0, -1);
                      $(this).val(vVal);// = vVal.slice(0, -1);
                  }*/
               	 if ($(this).val().match(/[^a-zA-Z0-9 ]/g)) 
	                   {
	                    $(this).val($(this).val().replace(/[^-0-9A-Za-z.,_& ]/, ''));
	                   }
                }
                  // allow comma and hyhen characters      
                  if ($(this).val().match(/[^a-zA-Z0-9 ]/g)) 
                  {
                    // allow comma and hyhen only and for Docuname field
                  // if (vFieldName=="DocName")
                   {
                   	 $(this).val($(this).val().replace(/[^-0-9A-Za-z.*,_& ]/, ''));
                   }
                 //  else
                  //	$(this).val($(this).val().replace(/[^a-zA-Z0-9., ]/g, ''));
                  }
               // ENGMASA :: Added below code to enable loading ePart specifications : START
      		    // if PartNumber value pasted then enable ref doc      		    
	            	  if (vFieldName=="PartNumber" && $(this).val()!="") {
	            		  $("input[name='loadReferenceDocs']").removeAttr("disabled");
	            		}
	            	  else
	            	  {
	            		  $("input[name='loadReferenceDocs']").attr("disabled", true);
	            	  }
	             // ENGMASA :: Added below code to enable loading ePart specifications : END
            });
	        	 $('input').keyup(function(vKey) {
	                 var vCharCode = vKey.keyCode;
	                 var vFieldName = $(this).attr("name");
	                 // if not file name
	                 if (vFieldName!="FileName" && vFieldName!="DocTitle" && vFieldName!="Description")
	                 {
	                  /* if (vCharCode==56)
	                   {
	                   //	alert($(this).val());
	                       var vVal = $(this).val();
	                       vVal = vVal.slice(0, -1);
	                       $(this).val(vVal);// = vVal.slice(0, -1);
	                   }*/
	                	 if ($(this).val().match(/[^a-zA-Z0-9 ]/g)) 
		                   {
		                    $(this).val($(this).val().replace(/[^-0-9A-Za-z.,_& ]/, ''));
		                   }
	                 }
	                   // allow comma and hyhen characters      
	                   if ($(this).val().match(/[^a-zA-Z0-9 ]/g)) 
	                   {
	                     // allow comma and hyhen only and for Docuname field
	                   // if (vFieldName=="DocName")
	                    {
	                    	 $(this).val($(this).val().replace(/[^-0-9A-Za-z.*,_& ]/, ''));
	                    }
	                  //  else
	                   //	$(this).val($(this).val().replace(/[^a-zA-Z0-9., ]/g, ''));
	                   }
	                 
	             });
	        	 
	        	 $("textarea").bind("paste", function(e){
	        		    // access the clipboard using the api
	        		    var pastedData = e.originalEvent.clipboardData.getData('text');
	        		   var vFieldName = $(this).attr("name");
	        			// replaces new lins if any
	        			pastedData=  pastedData.replace(/(\r\n|\n|\r)/gm,",");	 
	        			
	        			// remove extra comma
	        			if (pastedData.endsWith(","))
	        			{
	        				pastedData = pastedData.slice(0, -1);
	        			}
	        			
	        			if (vFieldName=="FileName" || vFieldName=="DocTitle" || vFieldName=="Description")
	        			{
	        				pastedData = pastedData.replace(/[^-0-9A-Za-z.*,_& ]/g, '');   				
	        			}
	        			else
	        			{
	        				pastedData = pastedData.replace(/[^-0-9A-Za-z.,_& ]/g, '');
	        			}
	        			var vCurrentVal =  $(this).val();
	        			vCurrentVal = vCurrentVal+pastedData;
	        		    $(this).val(vCurrentVal);
	        		 // ENGMASA :: Added below code to enable loading ePart specifications : START
	        		    // if PartNumber value pasted then enable ref doc
	        		    
		            	  if (vFieldName=="PartNumber" && vCurrentVal!="") {
		            		  $("input[name='loadReferenceDocs']").removeAttr("disabled");
		            		}
		            	  else
		            	  {
		            		  $("input[name='loadReferenceDocs']").attr("disabled", true);
		            	  }
		             // ENGMASA :: Added below code to enable loading ePart specifications : END
	        		    return false;    
	        		 });
     
     	
	        	 $("input").bind("paste", function(e){
	        		    // access the clipboard using the api
	        		    var pastedData = e.originalEvent.clipboardData.getData('text');
	        		   var vFieldName = $(this).attr("name");
	        			// replaces new lins if any
	        			pastedData=  pastedData.replace(/(\r\n|\n|\r)/gm,",");	 
	        			
	        			// remove extra comma
	        			if (pastedData.endsWith(","))
	        			{
	        				pastedData = pastedData.slice(0, -1);
	        			}
	        			
	        			if (vFieldName=="FileName" || vFieldName=="DocTitle" || vFieldName=="Description")
	        			{
	        				pastedData = pastedData.replace(/[^-0-9A-Za-z.*,_& ]/g, '');   				
	        			}
	        			else
	        			{
	        				pastedData = pastedData.replace(/[^-0-9A-Za-z.,_& ]/g, '');
	        			}
	        			var vCurrentVal =  $(this).val();
	        			vCurrentVal = vCurrentVal+pastedData;
	        		    $(this).val(vCurrentVal);
	        		    return false;    
	        		 });
	        	 // ENGMASA :: Added below code to enable loading ePart specifications : START
	        	 $('#calc_gapProjectNumber a').closest('td').closest('tr').append( '<td width="150" class="label">ePart Specifications</td><td width="195.5" class="field"><input type="checkbox" size="20" name="loadPartSpecs" value="loadPartSpecs" id="loadPartSpecs"></td>' );
	             var vePartTitle = "When checked, you can only view specifications related to selected Project's ePart folder!";
	             $('#loadPartSpecs').attr('title', vePartTitle);
	             
	             /* $("input[name='loadPartSpecs']").attr("disabled", true);
	              $('input[name=gapProjectNumberDisplay]').change(function() { 
	            var vProjectNo = $("[name='gapProjectNumberDisplay']").val();
	             if (vProjectNo=="") {
	            	 $("input[name='loadPartSpecs']").attr("disabled", true);
	             } else {
	            	 $("input[name='loadPartSpecs']").removeAttr("disabled");
	             }
	            });*/
	              // disable ref doc checkbox on load. Enable only when material field or ePartSpec selection is selected
	              $("input[name='loadReferenceDocs']").attr("disabled", true);
	              //$("input[name='loadPartSpecs']").attr("disabled", true);
	              var enablerefDocCheckbox = false;
	              $('input[name=loadPartSpecs]').change(function() {
	            	  enablerefDocCheckbox = true;
	            	  if ($("#loadPartSpecs").is(":checked")) {
	            		  enablerefDocCheckbox =true;
	            		  $("input[name='loadReferenceDocs']").removeAttr("disabled");
	            		}
	            	  else
	            	  {
	            		  $("input[name='loadReferenceDocs']").attr("disabled", true);
	            	  }	            	  
	              });
	              // handle on part number field as well	              
	              $('input[name=PartNumber]').bind('input propertychange', function() { 
	            	  var vPartumber =$("[name='PartNumber']").val();
	            	  if (vPartumber!="") {
	            		  $("input[name='loadReferenceDocs']").removeAttr("disabled");
	            		}
	            	  else
	            	  {
	            		  $("input[name='loadReferenceDocs']").attr("disabled", true);
	            	  }	            	  
	              });
	              $('input[name=gapProjectNumberDisplay]').bind('input propertychange', function() { 
	            	  var vProjectNu =$("[name='gapProjectNumberDisplay']").val();
	            	  if (vPartumber!="") {
	            		  $("input[name='loadReferenceDocs']").removeAttr("disabled");
	            		}
	            	  else
	            	  {
	            		  $("input[name='loadReferenceDocs']").attr("disabled", true);
	            	  }	            	  
	              });
	        	 // ENGMASA :: Added below code to enable loading ePart specifications : END
        	});
        document.onkeypress = keyPress;
        function loadDVForm(){        	
        	$("tbody tr td.requiredNotice").each(
        	        function(){
        	                $(this).text("<%=EnoviaResourceBundle.getProperty(context,ENGINEERING_STRING_RESOURCE,new Locale(strLanguage),"emxEngineeringCentral.Notice.RequiredField")%>"); 
        	                $(this).css("color","blue");
        	        }
        	    );
        	
        	$("tbody tr td.labelRequired label").each(
        	        function(){
        	        	$(this).css("color","blue");
        	        }
        	    );
        	}
        function keyPress(e){
          var x = e || window.event;
          var key = (x.keyCode || x.which);
          if(key == 13 || key == 3){
           //  myFunc1();
        	  getValue();
          }
        }
        function replaceSpecialCharacters(vFieldName, isAsteriskAllowed)
        {
        	var vField = document.getElementById(vFieldName);
        	if (vField!="" || vField!=" ")
        	{
	        	var vValueEntered = vField.value;
	        	if (vValueEntered!="" || vValueEntered!=" ") {
	        	if (isAsteriskAllowed)
	        	{
	        		vValueEntered = vValueEntered.replace(/[^-0-9A-Za-z.*,_ ]/g, "");
	        	}
	        	else
	        	{
	        		vValueEntered = vValueEntered.replace(/[^-0-9A-Za-z.,_ ]/g, "");
	        	}
	        	vField.value = vValueEntered;
	        	}
        	}
        }
            function getValue(){
               var plmId = document.getElementById('send');
                var vDocTitle = document.forms["submitForm"].DocTitle.value;

                var vDocName       = document.forms["submitForm"].DocName.value;
                var vPartNumber    = document.forms["submitForm"].PartNumber.value;
                var vProjectNumber = document.forms["submitForm"].gapProjectNumber.value;
                var vFileName      = document.forms["submitForm"].FileName.value;
                var vDocCode       = document.forms["submitForm"].gapDocumentCode.value;
                var vDocDesc       = document.forms["submitForm"].Description.value;
              
                // if empty then make it start                
                if (vDocTitle == "")
                {
                	document.forms["submitForm"].DocTitle.value = "";
                }
                if (vDocName == "")
                {
                	document.forms["submitForm"].DocName.value = "";
                }
                if (vPartNumber == "")
                {
                	document.forms["submitForm"].PartNumber.value = "";
                }
                if (vProjectNumber == " ")
                {
                	document.forms["submitForm"].gapProjectNumber.value = "";
                }
                if (vFileName == "")
                {
                	document.forms["submitForm"].FileName.value = "";
                }
            
             // check if only one field entered
                var vErr = "";
                if ( vDocName=="" && vPartNumber=="" && ( vProjectNumber==" " || vProjectNumber=="" ) && vFileName=="" )
                	vErr = "<%=EnoviaResourceBundle.getProperty(context,ENGINEERING_STRING_RESOURCE,new Locale(strLanguage),"emxEngineeringCentral.warning.EnterAtleastOneSearchCriteria")%>"
                if (vErr=="" && vErr!=null)
                {
                	var target = plmId.href;
                	// replace special characters from Material number and G Number field if any
                	replaceSpecialCharacters("PartNumber", false);
                	replaceSpecialCharacters("DocName", false);
                	replaceSpecialCharacters("FileName", true);
                	replaceSpecialCharacters("DocTitle", true);
                	replaceSpecialCharacters("Description", true);
                	// if part number entered then fetch values from real time
                	if (vPartNumber!="")
                	{     
                		var vPartNumberLength = 1;
                		if (vPartNumber.match(/,/g))
                		{
                			vPartNumberLength = (vPartNumber.match(/,/g)).length;
                		}                		
                		
                		// check if searching for more than 15 parts then block
                		if (vPartNumberLength>15)
                		{
                			var vMaxParts = "<%=EnoviaResourceBundle.getProperty(context,ENGINEERING_STRING_RESOURCE,new Locale(strLanguage),"emxEngineeringCentral.Notice.OnlyTenPartsAllowed")%>";
                			alert(vMaxParts);
                			return false;
                		}
                		else
                		{
                		 // clear G - Number
                		 // ignore other fields and list Specifications connected to Parts only
                		 target = target + "&parts="+vPartNumber+ "&docCode="+vDocCode+"&DocName="+vDocName+ "&DocTitle="+vDocTitle+ "&DocDesc="+vDocDesc + "&gapFileName="+vFileName;
                		// ENGMASA :: Added below code to enable loading ePart specifications : START
                		 if ($("#loadPartSpecs").is(":checked"))
                		 {
                			 target = target + "&loadPartSpecs=true";
                		 }
                		 if ($("#loadReferenceDocs").is(":checked"))
                		 {
                			 target = target + "&loadReferenceDocs=true";
                		 }
                		// ENGMASA :: Added below code to enable loading ePart specifications : END
                		 target = target + "&program=gapDirectViewInPLM:getSpecificationsLinkedToPart";
                		}
                	}
                	else if (vProjectNumber != " " && vProjectNumber != "")
                	{
                		var vProjectOId = document.forms["submitForm"].gapProjectNumberOID.value;
                		var vProjectName = document.forms["submitForm"].gapProjectNumber.value;
                		target = target + "&project="+vProjectOId + "&projectName="+vProjectName+ "&docCode="+vDocCode+"&DocName="+vDocName+ "&DocTitle="+vDocTitle+ "&DocDesc="+vDocDesc + "&gapFileName="+vFileName;
                		// ENGMASA :: Added below code to enable loading ePart specifications : START
	               		 if ($("#loadPartSpecs").is(":checked"))
	               		 {
	               			 target = target + "&loadPartSpecs=true";
	               		 }
	               		 if ($("#loadReferenceDocs").is(":checked"))
	               		 {
	               			 target = target + "&loadReferenceDocs=true";
	               		 }
	               		// ENGMASA :: Added below code to enable loading ePart specifications : END
                		target = target + "&program=gapDirectViewInPLM:getSpecificationsLinkedToProject";
                	}
                	else
                	{                		
                		target = target + "&docCode="+vDocCode+"&DocName="+vDocName+ "&DocTitle="+vDocTitle+ "&DocDesc="+vDocDesc + "&gapFileName="+vFileName;
                		target = target + "&queryLimit=100&program=gapDirectViewInPLM:getSpecificationsForOtherFields";
                	}

					parent.document.getElementById("frameCol").cols="20,80";
					parent.Topos.location.href=target;
                }
                else
                	alert(vErr);
            }

             function submitQueryRSC(){
                parent.document.getElementById("frameCol").cols="20,80";
                var prjName = document.getElementById("DocName").value;
                parent.Topos.location.href="emxIndentedTable.jsp?sortColumnName=Name&selection=multiple&header=emxEngineeringCentral.Label.gapDownloadPDF&freezePane=Name,Title&toolbar=gapDownloadZipToolbar&table=gapDirectViewResults&StringResourceFileId=emxEngineeringCentralStringResource&HelpMarker=emxhelppartspecifications&suiteKey=EngineeringCentral";
            }
             function isNumberKey(evt){
            	    var charCode = (evt.which) ? evt.which : evt.keyCode
            	    	//	alert(charCode);
            	    		 // allow asterisk and comma
            	    		if (charCode ==44 || charCode==42)
                    	    	return true;
            	    		else if (charCode > 31 && (charCode != 46 &&(charCode < 48 || charCode > 57)))
            	    			return false;
            	   
            	    
            	    return true;
            	}
          </script>
    </head>
    <body onload="loadDVForm()">
        <%
        /*get request parameters*/
        
        /*Prepare NLS Words*/
        String dest = (String)emxGetParameter(request,"dest");
        String ByProjectName= EnoviaResourceBundle.getProperty(context,ENGINEERING_STRING_RESOURCE,new Locale(strLanguage),"emxEngineeringCentral.Label.gapDownloadPDF");
        String Name = EnoviaResourceBundle.getProperty(context,ENGINEERING_STRING_RESOURCE,new Locale(strLanguage),"emxEngineeringCentral.Common.DocumentName");
        String sTitle = EnoviaResourceBundle.getProperty(context,ENGINEERING_STRING_RESOURCE,new Locale(strLanguage),"emxEngineeringCentral.Common.DocumentTitle");
        String Search = getNLS("Search");
        String strPersonId =PersonUtil.getPersonObjectID(context);
		String strPersonName =context.getUser();

        String FilterProject = "*";
 
	%>
        <form action="javascript:getValue" name="submitForm" id="submitForm " target="_parent">
	
             <a id="send" name="send" href="emxIndentedTable.jsp?sortColumnName=Name&selection=multiple&pageSize=50&header=emxEngineeringCentral.Label.gapDownloadPDF&freezePane=Name,Title&toolbar=gapDownloadZipToolbar&table=gapDirectViewResults&StringResourceFileId=emxEngineeringCentralStringResource&HelpMarker=emxhelppartspecifications&suiteKey=EngineeringCentral"></a>
             <div id="imgProgressDiv">&nbsp;<img src="../common/images/gap_DirectView.png" width="100%" height="100%" name="progress" align="absmiddle" /></div>
             <div id="searchPage">
 			<jsp:include page = "../common/emxFormEditDisplay.jsp" flush="true">
   				<jsp:param name="form" value="gapDirectViewFieldsForm"/>
   				<jsp:param name="objectId" value="<%=strPersonId%>"/>
   			</jsp:include>
   		</div>
         
         
        </form>
        <script>addFooter("javascript:getValue()","images/buttonDialogApply.gif","<%=Search%>","<%=Search%>");</script>
       
     </body>
</html>

