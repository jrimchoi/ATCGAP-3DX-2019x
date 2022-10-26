<%--  emxInfoNewRevision.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoNewRevision.jsp $
  $Revision: 1.3.1.4$
  $Author: ds-hbhatia$


--%>

<%--
 *
 * $History: emxInfoNewRevision.jsp $
 * 
 * *****************  Version 8  *****************
 * User: Rahulp       Date: 12/09/02   Time: 5:37p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 7  *****************
 * User: Mallikr      Date: 11/26/02   Time: 4:07p
 * Updated in $/InfoCentral/src/InfoCentral
 * code cleanup
 *
 * ***********************************************
 *
--%>

<%@include file= "emxInfoCentralUtils.inc"%>
<%@include file="../common/emxNavigatorTopErrorInclude.inc"%><!-- Added to enable MQL error/notices-->	
<%@ page import="com.matrixone.MCADIntegration.server.beans.*,com.matrixone.MCADIntegration.utils.*,matrix.db.*,com.matrixone.MCADIntegration.server.*,com.matrixone.apps.domain.util.*"%>

<html>
<%@include file = "../common/enoviaCSRFTokenValidation.inc"%>
<%
    MCADIntegrationSessionData integSessionData		= (MCADIntegrationSessionData)session.getAttribute(MCADServerSettings.MCAD_INTEGRATION_SESSION_DATA_OBJECT);
	MCADServerResourceBundle resourceBundle     =  integSessionData.getResourceBundle();
	MCADMxUtil util		                        = new MCADMxUtil(context, integSessionData.getLogger(),resourceBundle,integSessionData.getGlobalCache());
	
	
    String sRevision         = emxGetParameter(request, "txtRevision");
    String sVault            = emxGetParameter(request, "txtVault") ;
    String objectId            = emxGetParameter(request, "objectId");
    StringList exceptionList = new StringList();
    BusinessObject boGeneric = new BusinessObject(objectId);
	BusinessObject boNewRevision=null;

	//bug fix: 278616 - Weird encoding for some URLs - start
	String querystring = "emxInfoRevisionAttributeDialog.jsp?&hasModify="+emxGetParameter(request, "hasModify");
	Enumeration enumParamNames = emxGetParameterNames(request);
	while(enumParamNames.hasMoreElements()) 
	{
		String paramName =java.net.URLEncoder.encode((String) enumParamNames.nextElement());
		String paramValue = emxGetParameter(request, paramName);
		if (paramValue != null && paramValue.trim().length() > 0 )
			paramValue = java.net.URLEncoder.encode(paramValue);
		querystring += "&"+paramName+ "=" +paramValue;
	}
	//bug fix: 278616 - Weird encoding for some URLs - end

	double tz = (new Double((String)session.getValue("timeZone"))).doubleValue();
	try
	{
		//  Construct busiess object
		boGeneric.open(context);
		ContextUtil.startTransaction(context, true);
		//Creates a new Revision Object
		boNewRevision = boGeneric.revise(context, sRevision, sVault);
		boGeneric.update(context);
        //added on 4/2/2004
        //fix for:enable mql notice. event=revision triger=Override,return=1 
        if(boNewRevision!=null && !boNewRevision.getObjectId().equalsIgnoreCase("") && !"null".equals(boNewRevision.getObjectId()) )
        {
		boNewRevision.open(context);
		String sDescription = emxGetParameter(request, "txtDescription");
		if (sDescription != null)
		  sDescription = sDescription.trim();

		//Update the description of the object
		
		boNewRevision.setDescription(sDescription);

		BusinessObjectAttributes boAttrGeneric = boNewRevision.getAttributes(context);
		AttributeItr attrItrGeneric   = new AttributeItr(boAttrGeneric.getAttributes());
		AttributeList attrListGeneric = new AttributeList();

		String sAttrValue   = "";
		String sAttName     = "";
		while (attrItrGeneric.next()) 
                {
		  Attribute attrGeneric = attrItrGeneric.obj();
		  //To get the name of the attribute
		  sAttName = attrGeneric.getName();
                  AttributeType attrTypeGeneric = attrGeneric.getAttributeType();
                  attrTypeGeneric.open(context);
                  String sDataType       = attrTypeGeneric.getDataType();
                  attrTypeGeneric.close(context);
		  sAttrValue = emxGetParameter(request, sAttName);
                  if("timestamp".equals(sDataType))
                  {
	             if (sAttrValue != null && !sAttrValue.equals("") && !sAttrValue.equals("null") )
		        sAttrValue = com.matrixone.apps.domain.util.eMatrixDateFormat.getFormattedInputDate(sAttrValue,tz,request.getLocale());
                  }
		  if ((sAttrValue != null)) 
                  {
			sAttrValue = sAttrValue.trim();
			attrGeneric.setValue(sAttrValue);
			attrListGeneric.addElement(attrGeneric);				
		  }
		}
		
	String newlyCreatedInMatrixAttrActualName	= util.getActualNameForAEFData(context,"attribute_NewlyCreatedinMatrix");
	String iefFileSourceAttrActualName	= util.getActualNameForAEFData(context,"attribute_IEF-FileSource");
        Attribute attributeToUpdate          = new Attribute(new AttributeType(iefFileSourceAttrActualName), MCADAppletServletProtocol.FILESOURCE_SAVEAS);
	attrListGeneric.addElement(attributeToUpdate);
        
		//Update the attributes on the Business Object
		boNewRevision.setAttributes(context, attrListGeneric);
		boNewRevision.update(context);
		ContextUtil.commitTransaction(context);
	}
     }//Added on 4/2/2004
	catch(Exception e)
	{
		ContextUtil.abortTransaction(context);
		exceptionList.add(e.toString().trim());
	}
	finally{
		if(boGeneric!=null)
			boGeneric.close(context);
		if(boNewRevision!=null)
			boNewRevision.close(context);
	}

if(exceptionList.size() > 0)
{
 for (int k =0 ;k<exceptionList.size();k++)
 {
 String exceptionMsg=((String)(exceptionList.get(k))).trim();
 exceptionMsg = exceptionMsg.replace('\n',' ');
%>

 <script language="JavaScript">
    //XSSOK
    alert("<%=exceptionMsg%>");
</script>		
<%
 }
%>

<%@include file= "../common/emxNavigatorBottomErrorInclude.inc"%>	<!-- Added to enable MQL error/notices-->	
<script language="JavaScript">
top.frames[1].location.href="<%=XSSUtil.encodeForJavaScript(integSessionData.getClonedContext(session),querystring)%>";

</script>
<%
}
else
{
%>
<%@include file= "../common/emxNavigatorBottomErrorInclude.inc"%>	<!-- Added to enable MQL error/notices-->	
<script language="JavaScript">
parent.window.opener.location = parent.window.opener.location;
parent.window.close();
//End of chang by nagesh on 9/1/2004

</script>  
<%
}
%>
