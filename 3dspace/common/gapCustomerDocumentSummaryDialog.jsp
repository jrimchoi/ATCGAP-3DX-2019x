<%@ include file = "../emxUICommonAppInclude.inc"%>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.Integer" %>
<%@ page import = "com.matrixone.jsystem.util.StringUtils,matrix.db.MQLCommand,com.matrixone.apps.domain.util.MqlUtil,com.matrixone.apps.domain.util.FrameworkUtil" %>
<%@ page import = "com.matrixone.apps.library.LibraryCentralConstants"%>
<%@page import="com.matrixone.apps.domain.DomainObject"%>
<%@page import="matrix.util.StringList"%>
<%@ page import="com.dassault_systemes.vplmposadministrationui.uiutil.AdminUtilities"%>
<%@include file = "../common/emxPLMOnlineIncludeStylesScript.inc"%>
<%@include file = "../common/emxPLMOnlineAdminAttributesCalculation.jsp"%>

<%
	final String EMXENTERPRISECHANGEMGT_STRING_RESOURCE = "emxEnterpriseChangeMgtStringResource";
	final String strLanguage = request.getHeader("Accept-Language");
	String sHeader= EnoviaResourceBundle.getProperty(context,EMXENTERPRISECHANGEMGT_STRING_RESOURCE,new Locale(strLanguage),"EnterpriseChangeMgt.Label.gapChangesBasedonProjectNumber");
    String Search = "Search";
	String strObjectId    =  (String) emxGetParameter(request, "objectId");
	StringList slList = new StringList();
	try
	{
		String strDocumentFamily=MqlUtil.mqlCommand(context,"print bus 'Document Library' 'Customer Documents' '' select from[Subclass].to.id dump |");
		slList = FrameworkUtil.split(strDocumentFamily, "|");         
	}
	catch (Exception exp)
	{
		exp.printStackTrace();
	}
%>
<html>
   
    <body onload="">	
		<script language="JavaScript" src="../common/scripts/jquery-latest.js" type="text/javascript"></script>
		<script language="JavaScript" src="../common/scripts/emxUITableUtil.js" type="text/javascript"></script>
		<script language="javascript" src="../common/scripts/emxUIFormUtil.js" type="text/javascript"></script>
		<script language="JavaScript" src="../common/scripts/emxUIPopups.js" type="text/javascript"></script>
	<script language="javascript" >
	   function getValue()
	   {		   
			var sSerach = document.getElementById("gapCustomerFamily").value;
			var vShowAllrevisions = "No";
			 if ($("#AllRevisions").is(":checked"))
				 vShowAllrevisions = "yes";
			 var vSelected = $("#gapCustomerFamily option:selected").val();
			 var vURL = "../common/emxIndentedTable.jsp?freezePane=Name&HistoryMode=CurrentRevision &HelpMarker=emxhelpdocumentfamilydocuments&program=gap_Util:getCustomerDocuments&table=LBCDocumentSummary&selection=multiple&sortColumnName=Name&sortDirection=ascending&toolbar=LCClassifiedItemToolBar&header=emxDocumentCentral.Common.Documents&editLink=true&suiteKey=LibraryCentral&StringResourceFileId=emxLibraryCentralStringResource&SuiteDirectory=documentcentral&emxSuiteDirectory=&objectId="+vSelected+"&showAllRevisions="+vShowAllrevisions;
			parent.document.location.href=vURL
	   }
   </script>
		<div id="pageHeadDiv">
	    	<table>
	        	<tr>
	        		<td class="page-title">
	         			<h2 id="ph"></h2>
	        		</td>
	        		<td class="functions">
	        			<table>
	        					<tr>
	        						
	        					</tr>
	        			</table>
	        		</td>
	        	</tr>
	        </table>
	        <script language="JavaScript" src="" type="text/javascript"></script>
	        <div class="toolbar-container" id="divToolbarContainer">
	        	<div id="divToolbar" class="toolbar-frame"></div>
	        </div>
		</div>
	
	    <div id="divPageBody">	    	
	        <div id="divSearchCriteria">
	        	<table class="form">
					<tbody>
					
					<tr id="calc_DocFamilyName">
					
					<td width="150"><label for="DocFamilyName">Customer Document Family</label></td>
					
					<td class="inputField">
					<select name="gapCustomerFamily" id="gapCustomerFamily" title="Customer Document Family" onchange="changGAPLocation()">
						 <%
							String strDocFamilyId = null;
							String strDocFamilyName = null;
							DomainObject doObj = DomainObject.newInstance(context);
							for (int i=0; i< slList.size(); i++)
							{
								strDocFamilyId = (String) slList.get(i);
								strDocFamilyId = strDocFamilyId.trim();		  
								doObj.setId(strDocFamilyId);
								strDocFamilyName = doObj.getInfo(context, DomainObject.SELECT_NAME);
								%>
									  <option value="<%=strDocFamilyId%>" ><%=strDocFamilyName%> </option>
								<%
							}
						 %>
					</select>
					</td>
					</tr>
					<tr id="calc_AllRevisions">
					<td width="150" class="label">
						<label for="AllRevisions">Show all revisions</label>
					</td>
					<td class="inputField">
					<input type="hidden" name="AllRevisionsfieldValue" value="">
					<table border="0"><tbody><tr><td><input type="checkbox" name="AllRevisions" id="AllRevisions" value=""></td><td></td></tr></tbody></table></td>

					</tr>
					</tbody>
					</table>
	        </div>
			<div id="divSearchPane">
	        	<iframe name="searchPane" src="emxCommonSearchPane.jsp" allowtransparency="true" frameborder="0" style="display :none"></iframe>
	        </div>
		</div>
	   	<div id="divPageFoot" style="display :block">
		
		<table>
		<tbody>
		<tr>
		<td class="functions"></td>
		<td class="buttons">
		<table><tbody><tr><td><a title="Search" href="javascript:getValue()"><img title="Search" border="0" alt="Search" src="images/buttonDialogApply.gif"></a></td><td><a title="Search" href="javascript:getValue()" class="button">Search</a></td></tr></tbody></table></td></tr></tbody></table></div>
	</body>
</html>

