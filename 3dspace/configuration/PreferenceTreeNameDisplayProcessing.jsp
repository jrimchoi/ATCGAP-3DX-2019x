<%--

  PreferenceTreeNameDisplayProcessing.jsp
  Copyright (c) 1993-2018 Dassault Systemes.
  All Rights Reserved.
  This program contains proprietary and trade secret information of
  Dassault Systemes.
  Copyright notice is precautionary only and does not evidence any actual
  or intended publication of such program
--%>


<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<%@include file = "../common/enoviaCSRFTokenValidation.inc" %>

<%
    // check if change has been submitted or just refresh mode
    // Get language
    String prefTreeNameDisplay = emxGetParameter(request, "prefTreeNameDisplay");
        if( (prefTreeNameDisplay == null) || ("".equals(prefTreeNameDisplay)) )
        {
        	prefTreeNameDisplay="";
        }
    // if change has been submitted then process the change
        try
        {
            ContextUtil.startTransaction(context, true);
            if(prefTreeNameDisplay !=null)
                PersonUtil.setTreeNameDisplayPreference(context,prefTreeNameDisplay.trim());
        }
        catch (Exception ex) {
            ContextUtil.abortTransaction(context);

            if(ex.toString()!=null && (ex.toString().trim()).length()>0)
            {
                emxNavErrorObject.addMessage("prefTreeNameDisplay:" + ex.toString().trim());
            }
        }
        finally
        {
            ContextUtil.commitTransaction(context);
        }
%>

<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
