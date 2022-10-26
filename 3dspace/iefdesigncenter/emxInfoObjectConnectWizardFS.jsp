<%--  emxInfoObjectConnectWizardFS.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>

<%@include file="emxInfoCentralUtils.inc"%>
<%@include file="emxInfoVisiblePageInclude.inc"%>
<%@page import ="com.matrixone.MCADIntegration.server.*,com.matrixone.MCADIntegration.server.beans.*,com.matrixone.MCADIntegration.utils.*" %>

	<%
	String featureName	= MCADGlobalConfigObject.FEATURE_CONNECT;
    // rajeshg - changed for custom relationship addition- 01/09/04 
    String relationshipName = null ;

	String sConnect = (String)session.getAttribute("DirectConnect");
	String radFrom  = (String)session.getAttribute("radFrom");

	String relatedObjectId = emxGetParameter(request,"parentOID"); 

	if(relatedObjectId == null || relatedObjectId.equals(""))
		relatedObjectId = emxGetParameter(request, "objectId");

	String isTemplateType  = emxGetParameter(request, "isTemplateType");
	session.setAttribute("isTemplateType", isTemplateType);
		
	String CustomRelationshipName = null ;

	String acceptLanguage						  = request.getHeader("Accept-Language");
	MCADServerResourceBundle serverResourceBundle = new MCADServerResourceBundle(acceptLanguage);
	if ( (sConnect != null) && !("null".equals(sConnect)) && ("true".equals(sConnect)))
	{
		//session.setAttribute("DirectConnect" , "true");
		CustomRelationshipName = (String)session.getAttribute("CustomRelationshipName");
		
		String sRelDirection= emxGetParameter(request, "sRelDirection");
		String sRelName = null;
		BusinessObject  boObject  = null;
		StringList exceptionList = new StringList();

		String fromChecked="checked";
		String toChecked="";
		String sBustype= null;
		boolean hasToAccess = true ;
		String hasToAccessStr = "";
		boolean hasFromAccess = true ;
		String hasFromAccessStr = "" ;
		try
		{
			MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute(MCADServerSettings.MCAD_INTEGRATION_SESSION_DATA_OBJECT);

			if(integSessionData == null)
			{
				MCADServerException.createException(serverResourceBundle.getString("mcadIntegration.Server.Message.ServerFailedToRespondSessionTimedOut"), null);
			}
			else
			{
				MCADMxUtil util			= new MCADMxUtil(context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());
				String sIntegName		= util.getIntegrationName(context, relatedObjectId);
				String isFeatureAllowed	= integSessionData.isFeatureAllowedForIntegration(sIntegName, featureName);
				if(!isFeatureAllowed.startsWith("true"))
				{
					MCADServerException.createException(isFeatureAllowed.substring(isFeatureAllowed.indexOf("|")+1, isFeatureAllowed.length()), null);
				}
			}

			boObject  = new BusinessObject(relatedObjectId);
			boObject.open(context);
		    
			BusinessType btConnObj = null ;
			btConnObj = boObject.getBusinessType(context);
			btConnObj.open(context);
			sBustype = btConnObj.getName();

			boolean to =true;
			boolean from =false;
		
			String access="ToConnect";
	
			hasToAccess = FrameworkUtil.hasAccess(context,boObject,access);	
			String sMsgKey = "emxIEFDesignCenter.Common.No" + access;
			String sErrorToMsg = FrameworkUtil.i18nStringNow(sMsgKey, request.getHeader("Accept-Language"));
			hasToAccessStr = new Boolean(hasToAccess).toString();
			access = "FromConnect";
			hasFromAccess = FrameworkUtil.hasAccess(context,boObject,access);	
			sMsgKey = "emxIEFDesignCenter.Common.No" + access;
			String sErrorFromMsg= FrameworkUtil.i18nStringNow(sMsgKey, request.getHeader("Accept-Language"));
			hasFromAccessStr = new Boolean(hasFromAccess).toString();

			// we dont want to show the to-from page.
			to = true;
			from = false;
			fromChecked="";
			toChecked="";
			String sRelNameConn = null ;
			for (int i = 0 ; i < 2 ; i++ )
			{
				RelationshipTypeList relTypeListObjConn = btConnObj.getRelationshipTypes(context,to,from,true);

				relTypeListObjConn.sort();
				
				RelationshipTypeItr  relTypeItrObjConn = new RelationshipTypeItr(relTypeListObjConn);
				while ( relTypeItrObjConn.next() ) 
				{
					RelationshipType  relTypeObjConn = (RelationshipType) relTypeItrObjConn.obj();
					relTypeObjConn.open(context);
					sRelNameConn = relTypeObjConn.getName() ;
					String displayRelName= getRelationshipNameI18NString(sRelNameConn,request.getHeader("Accept-Language"));
					relTypeObjConn.close(context);
					if( (displayRelName != null) && (displayRelName.equals(CustomRelationshipName)) && (i == 0))
						fromChecked="present";
					else if( (displayRelName != null) && (displayRelName.equals(CustomRelationshipName)) && (i == 1))
						toChecked="present";
				}
				to = false;
				from = true;
			}
			btConnObj.close(context);
		}
        catch(MatrixException exception)
		{
			String busMsg= FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Error.BusinessObject", request.getHeader("Accept-Language"));
			exceptionList.add(exception.toString().trim()+" "+busMsg+" ");
        } 
		//end of for(int index=0; index<rowIds.length;index++)
		catch(Exception exception)
		{
			String busMsg= FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Error.BusinessObject", request.getHeader("Accept-Language"));
			exceptionList.add(exception.toString().trim()+" "+busMsg+" ");
		}

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
		
		if(("present".equals( toChecked )) && ("present".equals( fromChecked)) )
		{
			// This means that this relationship contains in from and to list.
			// here check what the user wants by the radFrom flag set in the
			// command object.
			
			if((radFrom == null) || (radFrom.equals("null")))
				radFrom = "unknown" ;
			else if("true".equals(radFrom))
				sRelDirection = "from" ;
			else
				sRelDirection = "to" ;
		}
		else if( (toChecked == null) || (toChecked == "") || (toChecked.equals("null")) )
		{
			if( (fromChecked == null) || (fromChecked == "") || (fromChecked.equals("null")) )
			{
				// This means that the object is not related.
				radFrom = "unknown" ;
%>
			<script language=javascript>
				alert("<framework:i18nScript localize='i18nId'>emxIEFDesignCenter.ConnectObject.RelationMismatch</framework:i18nScript> ");
				parent.window.close();
			</script>
<%
			}
			else
				sRelDirection = "from" ;
		}
		else
			sRelDirection = "to" ;
		
		request.setAttribute( "sRelName", CustomRelationshipName );
		request.setAttribute( "objectId", relatedObjectId );
		request.setAttribute( "sObjType", sBustype );
		request.setAttribute( "sRelDirection", sRelDirection );
		request.setAttribute( "DirectConnect", "true" );
		
		if( !("unknown".equals(radFrom)) )
		{
		   if((fromChecked.equals("present") && hasFromAccessStr.equals("true"))|| (fromChecked.equals("") && hasToAccessStr.equals("true")))
		   {
	   
%>				<jsp:forward page="emxInfoConnectSearchDialogFS.jsp" />

<%
			}
		}	
	}
	// end

    framesetObject fs = new framesetObject();
    String initSource = emxGetParameter(request,"initSource");

    if (initSource == null){
        initSource = "";
    }
    String jsTreeID     = emxGetParameter(request,"jsTreeID");
    String suiteKey     = emxGetParameter(request,"suiteKey");

    fs.setDirectory(appDirectory);

// ----------------- Do Not Edit Above ------------------------------

    //String relatedObjectId = emxGetParameter(request,"parentOID");    
    fs.setObjectId(relatedObjectId);

    if( ( relationshipName == null ) || ( relationshipName.equals("null") ) )
        relationshipName = emxGetParameter(request,"sRelationName");
    String sRelDirection = emxGetParameter(request,"sRelDirection");

    // Specify URL to come in middle of frameset
    String contentURL = "emxInfoObjectConnectWizardDialog.jsp";
	
    // add these parameters to each content URL, and any others the App needs
    contentURL += "?suiteKey=" + suiteKey 
        + "&initSource=" + initSource 
        + "&jsTreeID=" + jsTreeID 
        + "&objectId=" + relatedObjectId
        + "&relationshipName=" + relationshipName
        + "&sRelDirection=" + sRelDirection;
    fs.setStringResourceFile("emxIEFDesignCenterStringResource");

    // Page Heading - Internationalized
    String PageHeading = "emxIEFDesignCenter.CreateObjectConnectWizardDialog.SpecifyDetails";

	// Marker to pass into Help Pages
    // icon launches new window with help frameset inside    
    String sHelpMarker = emxGetParameter(request, "HelpMarker"); //emxHelpInfoObjectConnectDialogFS

    fs.initFrameset(PageHeading,sHelpMarker,contentURL,false,true,false,false);

    fs.createFooterLink("emxIEFDesignCenter.Common.Next",
                      "submitForm()",
                      "role_GlobalUser",
                      false,
                      true,
                      "common/images/buttonDialogNext.gif",
                      3);

    fs.createFooterLink("emxIEFDesignCenter.Common.Cancel",
                      "closeWindow()",
                      "role_GlobalUser",
                      false,
                      true,
                      "common/images/buttonDialogCancel.gif",
                      3);

// ----------------- Do Not Edit Below ------------------------------
    fs.writePage(out);
%>
