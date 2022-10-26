<%--  emxInfoUtils.inc

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxInfoUtils.inc   -  This is a utility JSP
  $Archive: /InfoCentral/src/infocentral/emxInfoUtils.inc $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$


--%>



<%@ page import="javax.servlet.http.HttpServletRequest,
                 com.matrixone.MCADIntegration.uicomponents.beans.IEF_INFMenuManager" %>

<%!

/*
 * This is a utility method which checks whether menu manager object
 * is present in session. If present it gets menu name from this
 * object, else it creates a new menu manager object, puts it into
 * session and returns menu name.
 */
public static String getINFMenuName( HttpServletRequest request,
Context context, String busObjId ) throws Exception
{

    IEF_INFMenuManager menuMgr = (IEF_INFMenuManager)request.getSession().getAttribute(
    "IEF_INFMenuManager" );

    if(menuMgr != null)
    {
        return menuMgr.getINFMenuName( context, busObjId );
    }
    else
    {
        menuMgr = new IEF_INFMenuManager();
        request.getSession().setAttribute( "IEF_INFMenuManager", menuMgr );
        return menuMgr.getINFMenuName( context, busObjId );
    }
}


%>

<%!
    // Call this method to internationalize variables in java.
    // i18nStringNow("stringid", request.getHeader("Accept-Language"));
    static public String i18nStringNowLocal(String text, String languageStr) 
	{
		String returnString = text;
        com.matrixone.apps.domain.util.i18nNow  infoLoc = new com.matrixone.apps.domain.util.i18nNow();
		String I18NreturnString = infoLoc.GetString("emxIEFDesignCenterStringResource ", languageStr, text);
        if ((!"".equals(I18NreturnString)) && (I18NreturnString != null)){
                returnString = I18NreturnString.trim();
            }
        return returnString;
    }
%>

<%!
    // Call this method to internationalize variables in java.
    // i18nStringNowUtil("key", resourceBundle, request.getHeader("Accept-Language"));

    static public String i18nStringNowUtilLocal( String text, String Bundle, String languageStr) {

        com.matrixone.apps.domain.util.i18nNow loc = new com.matrixone.apps.domain.util.i18nNow();
        String returnString = (String)loc.GetString(Bundle, languageStr, text);
        if(returnString != null || !"null".equalsIgnoreCase(returnString)){
        	returnString = returnString.trim();
        }
        return returnString;
    }
%>
