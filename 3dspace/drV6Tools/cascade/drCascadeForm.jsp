<%-- 
    Document   : drCascaseForm
    Created on : 02-Jul-2013, 10:10:03
    Author     : farhana
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@taglib uri="/WEB-INF/drv6toolsHTML.tld" prefix="drCore"%>
<!-- saved from url=(0014)about:internet -->
<!-- saved from url=(0016)http://localhost -->
<!DOCTYPE html>
<html>

    <drCore:drPageTagHandler continueButtonImgSrc ="../common/images/buttonDialogDone.gif"
                             continueLabel="Apply"
                             cancelLabel="Close"
                             cancelButtonImgSrc ="../common/images/buttonDialogCancel.gif"
                             cancelAction="javascript:closeMe();">
        <head>

            <meta http-equiv="X-UA-Compatible" content="IE=8" />
            <title><s:property value="getText('drV6Tools.cascade.cascadeform.title')"/></title>
            <link rel="stylesheet" type="text/css" href="../common/styles/emxUIDefault.css"/>
            <link rel="stylesheet" type="text/css" href="../common/styles/emxUIForm.css"/>
            <link rel="stylesheet" type="text/css" href="../common/styles/emxUIDialog.css"/>
            <link rel="stylesheet" type="text/css" href="../common/styles/emxUIToolbar.css"/>
            <link rel="stylesheet" type="text/css" href="../common/styles/emxUIDOMLayout.css"/>

            <script type="text/javascript" src="../drV6Tools/common/js/drAjaxBase.js"></script>
            <script type="text/javascript" src="../drV6Tools/cascade/js/drCascadeUtil.js"></script>
            <script type="text/javascript" src="../drV6Tools/common/js/json.js"></script>
            <!--<script type="text/javascript" src="../drV6Tools/common/js/spin.min.js"></script>-->
            <script type="text/javascript" src="../common/scripts/emxUISlideIn.js"></script>
            <script type="text/javascript" src="../drV6Tools/common/js/jquery-1.9.1.js"></script>
            <script type="text/javascript" src="../drV6Tools/common/js/jquery-ui.js"></script>
			 <script type="text/javascript" src="../drV6Tools/common/js/jquery.blockUI.js"></script>
            <link type="text/css" href="../drV6Tools/cascade/css/jquery-ui.css" rel="stylesheet" />
            <link rel="stylesheet" href="../drV6Tools/cascade/css/DatePickerstyle.css" /> 






            <drCore:drAjaxServices className="com.designrule.drv6tools.actions.cascade.drCascadeAjaxUtils"/>

			 </head>
        <body>
		 <div id='busy'></div>
			
            <script type="text/javascript">
           

                var CascadeData;		
                var updatedCascadeObject;
               	var processing;				
				var uploadResponse="";
             	
			
	   
                $(document).ready(function() {
					var refreshTable = false;
					uploadResponse = getParameterByName("uploadResponse");	
					
                    var data = document.getElementById("json").value;
                    if(data !== ""){
                        CascadeData = JSON.parse(data);	
									
                        generateToLevel('topTD');
						manageGUI();		
						
                    } 
					// setting the window type from target location
					var tarLocation = getParameterByName("targetLocation");
					refreshTable = getParameterByName("refreshTable");
					
						
					
					if(tarLocation == ""){
						tarLocation = getParameterByName(".targetLocation");
					}	
					
					document.getElementById("windowType").value = tarLocation;
					document.getElementById("refreshTable").value = refreshTable;	
					
					
			
				});
				
				


				function submitForm(){		
					processSubmit();
				
					
				}
				
			
   
            
               /* var spinner;
                function showBusy() {
                   var opts = {
                        lines: 13, // The number of lines to draw
                        length: 7, // The length of each line
                        width: 4, // The line thickness
                        radius: 10, // The radius of the inner circle
                        rotate: 0, // The rotation offset
                        color: '#000', // #rgb or #rrggbb
                        speed: 1, // Rounds per second
                        trail: 60, // Afterglow percentage
                        shadow: false, // Whether to render a shadow
                        hwaccel: false, // Whether to use hardware acceleration
                        className: 'spinner', // The CSS class to assign to the spinner
                        zIndex: 2e9, // The z-index (defaults to 2000000000)
                        top: 'auto', // Top position relative to parent in px
                        left: 'auto' // Left position relative to parent in px
                    } 					
					
                    var target = document.getElementById('busy')
                    spinner = new Spinner(opts).spin(target)
              }		*/	
				
				
				
           </script>


       
		<div id="pageHeadDiv" >
				   <table>
				   <tr>
				   <td id="tdHeaderInfo" style="height:60px;">
				   </td>
				   </tr>
				   </table>
				</div>			
	
            <div id="divPageBody" > 
                <form id="form1" name="form1" method="post" action = "drCascade.action">
				<table id="droppedFileTable">				
					
				</table>
		            <table border="0" width="100%" cellspacing="0" cellpadding="1">
                        <tbody id="formTable">						
                            <tr >
                                <td class="labelRequired" id="sidepanel">                                 
                                </td>
                                <td id="topTD" class="inputField">

                                    <textarea name="json"  id ="json" rows=20 cols=60 style="display:none">
                                        <s:property value="json"/>
                                    </textarea>
                                    <select id="action" name="action" style="display:none">
                                        <option value="init">
                                            init
                                        </option>
                                        <option value="complete">
                                            complete
                                        </option>
                                        <option value="error">
                                            error
                                        </option>
                                    </select>
                                </td>

                            </tr>	

                        </tbody>
                    </table>
                   
				<input type="hidden" id="windowType" name="windowType">	
				<input type="hidden" id="refreshTable" name="refreshTable">	
				
	                </form>
	
            </div>
       </body>
 
    </drCore:drPageTagHandler>
</html>
