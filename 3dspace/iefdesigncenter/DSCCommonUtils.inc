<%--  DSCCommonUtils.inc

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoCentralUtils.inc $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$ 
--%>



<%!
    // Call this method to internationalize variables in java.
    // i18nStringNow("stringid", request.getHeader("Accept-Language"));
    static public String i18nStringNow(String text, String languageStr) 
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
  //
  // Get the I18N Translated String for the given Format Name
  //
  static public String getFormatI18NString(String formatString,String languageStr) throws MatrixException
  {
    return i18nNow.getMXI18NString(formatString,"",languageStr,"Format");
  }
%>

<%!
/************************************************
*  This method returns encoded string 
*************************************************/
    public static String encodeHref(HttpServletRequest httpservletrequest, String s)
    {
        s = FrameworkUtil.encodeURLParamValues(s);
        String s1 = httpservletrequest.getHeader("User-Agent");
        if(s1 == null)
            s1 = "";
        if(s1.indexOf("MSIE") != -1)
            s = FrameworkUtil.encodeURLParamValues(s);
        return s;
    }
%>






