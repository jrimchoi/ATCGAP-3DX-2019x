<%--  DSCCreateCADStructureDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  DSCCreateCADStructureDialog.jsp   -   Displays the templated available for assembly as well as component
  
--%>

<%@include file ="../integrations/MCADTopInclude.inc"%>
<%@include file ="emxInfoUtils.inc"%>
<%@page import = "com.matrixone.apps.domain.util.*" %>
<%@page import="com.matrixone.apps.domain.util.ENOCsrfGuard"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd"> 
<%!
	private Vector getAssignedIntegrationsList(MCADIntegrationSessionData integSessionData)
	{
		Vector assignedIntegrationsList = new Vector();

		MCADLocalConfigObject localConfigObject = integSessionData.getLocalConfigObject();
		Hashtable integrationNameGCONameMap		= new Hashtable();

		if(localConfigObject != null)
			integrationNameGCONameMap = localConfigObject.getIntegrationNameGCONameMapping();

		Enumeration integrationNameElements = integrationNameGCONameMap.keys();
		while(integrationNameElements.hasMoreElements())
		{
			String integName = (String)integrationNameElements.nextElement();

			assignedIntegrationsList.addElement(integName);
		}

		return assignedIntegrationsList;
	}

	private String getSelectControlString(String controlName, Hashtable optionsTable)
    {
        String returnString = "";
        if(optionsTable != null && optionsTable.size()>0)
        {
			StringBuffer selectControlBuffer = new StringBuffer(" <select name=\"" + controlName + "\">\n");
            Enumeration optionsElements = optionsTable.keys();
            while(optionsElements.hasMoreElements())
            {
                String optionName	= (String)optionsElements.nextElement();
				String optionValue	= (String)optionsTable.get(optionName);

				selectControlBuffer.append(" <option value=\"" + optionName + "\">" + optionValue + "</option>\n");
			}

			selectControlBuffer.append(" </select>\n");
			returnString = selectControlBuffer.toString();
        }
        
        return returnString;
    }

	private String getSelectControlStringForIntegrations(String controlName, String defaultValue, Vector integrationsList, String selectedIntegrationName)
    {
		if(selectedIntegrationName == null || selectedIntegrationName.equals(""))
			selectedIntegrationName = defaultValue;

        StringBuffer selectControlBuffer = new StringBuffer(" <select name=\"" + controlName + "\" onChange=\"javascript:selectedIntegration(this)\">\n");

        if(integrationsList != null)
        {
            for(int i=0; i<integrationsList.size(); i++)
            {
                String integrationName = (String)integrationsList.elementAt(i);

				if(integrationName.equalsIgnoreCase(selectedIntegrationName))
					selectControlBuffer.append(" <option value=\"" + integrationName + "\" selected>" + integrationName + "</option>\n");
				else
					selectControlBuffer.append(" <option value=\"" + integrationName + "\">" + integrationName + "</option>\n");
            }
        }

        selectControlBuffer.append(" </select>\n");

        return selectControlBuffer.toString();
    }
%>

<%
	MCADIntegrationSessionData integSessionData   = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
	String acceptLanguage						  = request.getHeader("Accept-Language");
	Context context					              = null;
	MCADMxUtil util					              = null;
	Vector assignedIntegrationsList               = new Vector();
	HashMap integrationNameGCOMap				  = new HashMap();
	MCADServerResourceBundle serverResourceBundle = new MCADServerResourceBundle(acceptLanguage);
	String featureName							  = MCADGlobalConfigObject.FEATURE_CREATE_CAD_STRUCTURE;
	String isFeatureAllowed						  = ""; 

	String errorMessage = "";

	if(integSessionData == null)
		errorMessage = serverResourceBundle.getString("mcadIntegration.Server.Message.ServerFailedToRespondSessionTimedOut");
	else 
	{
		context					 = integSessionData.getClonedContext(session);
		util					 = new MCADMxUtil(context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
		assignedIntegrationsList = getAssignedIntegrationsList(integSessionData);
	}
	
	String integrationName	= Request.getParameter(request,"integrationName"); //This is passed if user changes the selected integration
	String jsTreeID			= Request.getParameter(request,"jsTreeID");
	String suiteKey			= Request.getParameter(request,"suiteKey");
	String objectId			= Request.getParameter(request,"objectId");
	String partId			= Request.getParameter(request,"partId");
	String folderId			= Request.getParameter(request,"folderId");
	String folderName			= Request.getParameter(request,"folderName");
	String isIntegSelected  = Request.getParameter(request,"isIntegSelected"); //This is passed if user changes the selected integration
	
	String integrationsComboControlString		= "";
	String assemblyTemplatesComboControlString	= "";
	String componentTemplatesComboControlString = "";
	Hashtable integrationTemplateDetailTable	= new Hashtable();

	String integName = "";


	ResourceBundle iefProperties		= PropertyResourceBundle.getBundle("ief");	
	String supportFamilyInStartDesign	= "false";
	try
	{
	if(iefProperties.getString("mcadIntegration.SupportFamilyInStartDesign") != null)
	{
		supportFamilyInStartDesign = iefProperties.getString("mcadIntegration.SupportFamilyInStartDesign");
	}
	}
	catch(Exception ex)
	{
		supportFamilyInStartDesign	= "false";
	}
	if(supportFamilyInStartDesign.equalsIgnoreCase("false"))
	{
		if(assignedIntegrationsList != null && assignedIntegrationsList.size() > 0 && assignedIntegrationsList.contains("SolidWorks"))
		{
			assignedIntegrationsList.remove("SolidWorks");
		}
	}
	
	for(int i=0; i < assignedIntegrationsList.size(); i++)
	{
		integName		 = (String)assignedIntegrationsList.elementAt(i);
		isFeatureAllowed = integSessionData.isFeatureAllowedForIntegration(integName, featureName);
		
		if(isFeatureAllowed.startsWith("true"))
		{
			MCADGlobalConfigObject globalConfigObject = integSessionData.getGlobalConfigObject(integName,context);

			String[] packedGCO = new String[2];
			packedGCO = JPO.packArgs(globalConfigObject);

			String[] args = new String[7];
			args[0]  = packedGCO[0];
			args[1]  = packedGCO[1];
			args[2]  = integSessionData.getLanguageName();
			args[3]  = integName;

			Hashtable structureCreationData = (Hashtable)util.executeJPO(context, "IEFCreateTemplateObjectDetails", "getTemplateObjectDetails", args, Hashtable.class);

			integrationTemplateDetailTable.put(integName,structureCreationData);
		}
	}

	if(integrationTemplateDetailTable.isEmpty())
	{
		Hashtable exceptionDetails = new Hashtable();
		exceptionDetails.put("NAME",integSessionData.getStringResource("mcadIntegration.Server.Feature."+featureName));
		if(integSessionData.isNonIntegrationUser())
			errorMessage = integSessionData.getStringResource("mcadIntegration.Server.Message.FeatureNotAllowedForNonIntegrationUser",exceptionDetails);
		else
			errorMessage = integSessionData.getStringResource("mcadIntegration.Server.Message.FeatureNotAllowedForAssignedIntegrations",exceptionDetails);
	}
	else if(isIntegSelected != null && isIntegSelected.equals("true"))
	{
		Hashtable structureCreationData				= (Hashtable)integrationTemplateDetailTable.get(integrationName);
		Hashtable assemblyTemplateObjectsTable		= (Hashtable)structureCreationData.get("assemblyTemplateObjectsTable");
		Hashtable componentTemplateObjectsTable		= (Hashtable)structureCreationData.get("componentTemplateObjectsTable");

		integrationsComboControlString				= getSelectControlStringForIntegrations("integrationName", integName, assignedIntegrationsList, integrationName);
		assemblyTemplatesComboControlString			= getSelectControlString("assemblyTemplate", assemblyTemplateObjectsTable);
		componentTemplatesComboControlString		= getSelectControlString("componentTemplate", componentTemplateObjectsTable);
	}
	else
	{
		Enumeration  keys = integrationTemplateDetailTable.keys();

		while(keys.hasMoreElements())
		{
			integName = (String)keys.nextElement();
			Hashtable structureCreationData				= (Hashtable)integrationTemplateDetailTable.get(integName);
			Hashtable assemblyTemplateObjectsTable		= (Hashtable)structureCreationData.get("assemblyTemplateObjectsTable");
			Hashtable componentTemplateObjectsTable		= (Hashtable)structureCreationData.get("componentTemplateObjectsTable");

			integrationsComboControlString				= getSelectControlStringForIntegrations("integrationName", integName, assignedIntegrationsList, integrationName);
			assemblyTemplatesComboControlString			= getSelectControlString("assemblyTemplate", assemblyTemplateObjectsTable);
			componentTemplatesComboControlString		= getSelectControlString("componentTemplate", componentTemplateObjectsTable);

			if(!componentTemplatesComboControlString.equals("") && !assemblyTemplatesComboControlString.equals(""))
				break;
		}
	}

%>

<html>
<head>
<title>CAD Structure Creator</title>

<style type="text/css"> 
	body { background-color: white; }
	body, th, td, p, select, option { font-family: Verdana, Arial, Helvetica, Sans-Serif; font-size: 10pt; }
	a { color: #003366; }
	a:hover { }
	td.pageHeader {  font-family: Arial, Helvetica, Sans-Serif; font-size: 13pt; font-weight: bold; color: #990000; } 
	td.pageBorder {  background-color: #003366; } 
	th { text-align: left; color: white; background-color: #336699; font-size: 10pt;}
</style>

<script language="JavaScript" src="../emxUIPageUtility.js" type="text/javascript"></script>
<script language="JavaScript" src="../integrations/scripts/IEFUIModal.js"></script>

<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>

<script language="JavaScript">


function selectedIntegration(integrationField)
{
	var integrationName = integrationField.options[integrationField.selectedIndex].value;
	var integrationForm = document.forms["UpdateIntegrationName"];
	integrationForm.integrationName.value = integrationName;
	integrationForm.submit();
}

function submit()
{
	startProgressBar(true);
	var templateObjectsForm = document.forms["TemplateObjectsForm"];
	//XSSOK
	var folderIdStr = '<%=folderId%>';
	//XSSOK
	var integName = '<%=integName%>';
	//XSSOK
	var integrationName = '<%=integrationName%>';	
	if(integrationName =="" || integrationName == "null")
	{
		integrationName = integName;
	}	
	if(integrationName != null && integrationName == "SolidWorks")
	{
		if(folderIdStr == "" || folderIdStr == "null" || folderIdStr.length == 0)
		{
		    //XSSOK
			alert("<%=integSessionData.getStringResource("mcadIntegration.Server.Message.PleaseSelectAFolder")%>");
		}
		else
		{
				templateObjectsForm.folderId.value = folderIdStr;
	templateObjectsForm.submit();
}
	}
	else
	{
			templateObjectsForm.folderId.value = folderIdStr;
			templateObjectsForm.submit();
	}
}

function showFolderChooser()
{
    //XSSOK
	var integName = '<%=integName%>';
	//XSSOK
	var integrationName = '<%=integrationName%>';	
	if(integrationName =="" || integrationName == "null")
	{
		integrationName = integName;
	}
	var url = "../integrations/MCADFolderSearchDialogFS.jsp" + "?integrationName="+integrationName;	
	showIEFModalDialog(url, 430, 400, true);
}
function doGlobalSelect(objectId, objectName, applyToChild)
{
	var integrationForm = document.forms["UpdateIntegrationName"];
	integrationForm.folderId.value = objectId;
	integrationForm.folderName.value = objectName;
	
	//XSSOK
	var integName = '<%=integName%>';
	//XSSOK
	var integrationName = '<%=integrationName%>';
	if(integrationName =="" || integrationName == "null")
	{
		integrationName = integName;
	}
	integrationForm.integrationName.value = integrationName;
	integrationForm.submit();
}

</script>
</head>

<body>
<form name="TemplateObjectsForm" method="post" target="_self" action="DSCCreateCADStructure.jsp">	

<%
boolean csrfEnabled = ENOCsrfGuard.isCSRFEnabled(context);
if(csrfEnabled)
{
  Map csrfTokenMap = ENOCsrfGuard.getCSRFTokenMap(context, session);
  String csrfTokenName = (String)csrfTokenMap .get(ENOCsrfGuard.CSRF_TOKEN_NAME);
  String csrfTokenValue = (String)csrfTokenMap.get(csrfTokenName);
%>
  <!--XSSOK-->
  <input type="hidden" name= "<%=ENOCsrfGuard.CSRF_TOKEN_NAME%>" value="<%=csrfTokenName%>" />
  <!--XSSOK-->
  <input type="hidden" name= "<%=csrfTokenName%>" value="<%=csrfTokenValue%>" />
<%
}
//System.out.println("CSRFINJECTION::DSCCreateCADStructureDialog.jsp");
%>

<%
	if(!componentTemplatesComboControlString.equals("") && !assemblyTemplatesComboControlString.equals(""))
	{
%>
	<table border="0" width="100%">
		<tr><th width="100%"><%=i18nStringNowLocal("emxIEFDesignCenter.CreateCADStructure.SelectIntegration", acceptLanguage)%></th></tr>
	</table>

	<table border="0" width="70%">
		<tr>
			<td width="30%" nowrap><b><%=i18nStringNowLocal("emxIEFDesignCenter.CreateCADStructure.IntegrationName", acceptLanguage)%></b></td>
			<!--XSSOK-->
			<td width="70%"><%= integrationsComboControlString %></td>
		</tr>
		<tr><td>&nbsp</td></tr>
		<tr><td>&nbsp</td></tr>
	</table>
	<table border="0" width="100%">
	<tr>
	<%
		String folderDisplayName = "";		
		if(folderName != null && folderName.length() > 0)
		{
			folderDisplayName = MCADUrlUtil.hexDecode(folderName);
		}

	%>
	<!--XSSOK-->
	<td class="label"><b><%=integSessionData.getStringResource("mcadIntegration.Server.SelectFolder")%> &nbsp;&nbsp;&nbsp;</b></td>
		<td class="inputField"><input type="text" size="35" readonly="readonly" name="folder" value="<%=folderDisplayName%>" />
		<input type="button"  name="btn" value="..." onClick="javascript:showFolderChooser()"  />
	</tr>
	</table>
	<TABLE>
	<TR>&nbsp;
	</TR>
	<TR>	&nbsp;	
	</TR>
	</TABLE>
	<table border="0" width="100%">
	  <tr><th width="100%"><%=i18nStringNowLocal("emxIEFDesignCenter.CreateCADStructure.SelectTemplateObjects", acceptLanguage)%></th></tr>
	</table>

	<table border="0" width="100%">
<%  
	if(integrationName == null || integrationName.equals(""))
	{
		integrationName = integName;
	}

	if(integrationName.equalsIgnoreCase(MCADAppletServletProtocol.MICROSTATION))
	{  
%>
	    <tr>
	       <td width="30%" nowrap><b><%=i18nStringNowLocal("emxIEFDesignCenter.CreateCADStructure.SelectDesignTemplate", acceptLanguage)%></b></td>
		   <!--XSSOK-->
		   <td width="70%"><%= assemblyTemplatesComboControlString %></td>
	    </tr>
<%  } else 
	 {	
		String selectTemplateForAssem	= "emxIEFDesignCenter.CreateCADStructure.SelectAssemblyTemplate";
		String selectTemplateForComp	= "emxIEFDesignCenter.CreateCADStructure.SelectComponentTemplate";
		if(supportFamilyInStartDesign.equalsIgnoreCase("true"))
		{
			 selectTemplateForAssem	= "emxIEFDesignCenter.CreateCADStructure.SelectAssemblyFamilyTemplate";
			 selectTemplateForComp	= "emxIEFDesignCenter.CreateCADStructure.SelectComponentFamilyTemplate";
		}
%>
        
         <tr>
			<td width="40%" nowrap><b><%=i18nStringNowLocal(selectTemplateForAssem, acceptLanguage)%></b></td>
			<!--XSSOK-->
			<td width="60%"><%= assemblyTemplatesComboControlString %></td>
		</tr>
		<tr>
			<td width="40%" nowrap><b><%=i18nStringNowLocal(selectTemplateForComp, acceptLanguage)%></b></td>
			<!--XSSOK-->
			<td width="60%"><%= componentTemplatesComboControlString %></td>
		</tr>
<%  
	 }   
%>
	</table>
<%
	}
	else if (!"".equals(errorMessage.trim()))
	{
%>
	<tr>
	    <!--XSSOK-->
		<td><b><%=errorMessage%></b></td>
	</tr>
<%
	}
	else
	{
%>
	<tr>
		<td><b><%=i18nStringNowLocal("emxIEFDesignCenter.Message.MissingTemplate", acceptLanguage)%></b></td>
	</tr>
<%
	}
%>
	<input type="hidden" name="jsTreeID" value="<xss:encodeForHTMLAttribute><%= jsTreeID %></xss:encodeForHTMLAttribute>">
	<input type="hidden" name="suiteKey" value="<xss:encodeForHTMLAttribute><%= suiteKey %></xss:encodeForHTMLAttribute>">
	<input type="hidden" name="objectId" value="<xss:encodeForHTMLAttribute><%= objectId %></xss:encodeForHTMLAttribute>">
	<input type="hidden" name="partId" value="<xss:encodeForHTMLAttribute><%= partId %></xss:encodeForHTMLAttribute>">
	<input type="hidden" name="folderId" value="">
</form>

<form name="UpdateIntegrationName" method="post" action="DSCCreateCADStructureDialog.jsp" target="_self">

<%
boolean csrfEnabled1 = ENOCsrfGuard.isCSRFEnabled(context);
if(csrfEnabled1)
{
  Map csrfTokenMap1 = ENOCsrfGuard.getCSRFTokenMap(context, session);
  String csrfTokenName1 = (String)csrfTokenMap1 .get(ENOCsrfGuard.CSRF_TOKEN_NAME);
  String csrfTokenValue1 = (String)csrfTokenMap1.get(csrfTokenName1);
%>
  <!--XSSOK-->
  <input type="hidden" name= "<%=ENOCsrfGuard.CSRF_TOKEN_NAME%>" value="<%=csrfTokenName1%>" />
  <!--XSSOK-->
  <input type="hidden" name= "<%=csrfTokenName1%>" value="<%=csrfTokenValue1%>" />
<%
}
//System.out.println("CSRFINJECTION::DSCCreateCADStructureDialog.jsp::form ::UpdateIntegrationName");
%>

	<input type="hidden" name="integrationName" value="">
	<input type="hidden" name="jsTreeID" value="<xss:encodeForHTMLAttribute><%= jsTreeID %></xss:encodeForHTMLAttribute>">
	<input type="hidden" name="suiteKey" value="<xss:encodeForHTMLAttribute><%= suiteKey %></xss:encodeForHTMLAttribute>">
	<input type="hidden" name="objectId" value="<xss:encodeForHTMLAttribute><%= objectId %></xss:encodeForHTMLAttribute>">
	<input type="hidden" name="partId" value="<xss:encodeForHTMLAttribute><%= partId %></xss:encodeForHTMLAttribute>">
	<input type="hidden" name="isIntegSelected" value="true">
	<input type="hidden" name="folderId" value="">
	<input type="hidden" name="folderName" value="">
</form>
</body>
</html>


