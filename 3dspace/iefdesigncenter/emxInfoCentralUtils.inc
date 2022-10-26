<%--  emxInfoCentralUtils.inc

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

<%--
 *
 * $History: emxInfoCentralUtils.inc $
 * 
 * *****************  Version 37  *****************
 * User: Rahulp       Date: 1/15/03    Time: 3:40p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 36  *****************
 * User: Rahulp       Date: 1/15/03    Time: 1:25p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 35  *****************
 * User: Rahulp       Date: 1/15/03    Time: 12:19p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 34  *****************
 * User: Rahulp       Date: 1/14/03    Time: 4:00p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 33  *****************
 * User: Snehalb      Date: 1/13/03    Time: 1:15p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 32  *****************
 * User: Shashikantk  Date: 12/11/02   Time: 3:00p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 31  *****************
 * User: Snehalb      Date: 11/29/02   Time: 10:00a
 * Updated in $/InfoCentral/src/infocentral
 * added try-catch around encode
 * 
 * ***********************************************
 *
--%>
<%@page contentType="text/html; charset=UTF-8"%>

<%@ page import="com.matrixone.apps.domain.util.*"%>
<%@ page import = "matrix.db.*,matrix.util.*"%>						
<%@ page import = "java.util.*,java.io.*"%>						
<%@ page import = "com.matrixone.servlet.*"%>
<%@ page import = "com.matrixone.apps.framework.ui.*"%>


<jsp:useBean id="vaultAwarePerson" 
    class="com.matrixone.apps.common.Person" scope="page" />

<%!
    static String suiteDir;  
    //    String DateFrm = (new Integer(java.text.DateFormat.MEDIUM)).toString();
    static String appDirectory = null;
    static String propertyAlias = null;
	static String sInfoCentralSuite = "eServiceSuiteDesignerCentral";
%>

<%
    if (appDirectory == null){
       appDirectory	 = FrameworkProperties.getProperty("eServiceSuiteDesignerCentral.Directory");
    }

    if (propertyAlias == null){
      propertyAlias  = FrameworkProperties.getProperty("eServiceSuiteDesignerCentral.PropertyFileAlias");
    }
%>

<%//Start Internationalization%>
<%@include file = "../emxTagLibInclude.inc"%>
<!--XSSOK-->
<framework:localize id="i18nId" bundle="emxIEFDesignCenterStringResource" locale='<%= request.getHeader("Accept-Language") %>'/>

<%
    String lStr = request.getHeader("Accept-Language");
    String langStr = i18nStringNow("emxIEFDesignCenter.HelpDirectory", lStr);
    if(langStr == null || "".equals(langStr))
        langStr = "en";
%>



<%!
    // SnehalB: why do need to copy this method to a local file of our own. 
	// it's available as a common resource in file \EMATRIX\emxUICommonAppInclude.jsp 

    // Call this method to internationalize variables in java.
    // i18nStringNowUtil("key", resourceBundle, request.getHeader("Accept-Language"));

    static public String i18nStringNowUtil( String text, String Bundle, String languageStr) {

        com.matrixone.apps.domain.util.i18nNow loc = new com.matrixone.apps.domain.util.i18nNow();
        String returnString = (String)loc.GetString(Bundle, languageStr, text);
        if(returnString != null || !"null".equalsIgnoreCase(returnString)){
        	returnString = returnString.trim();
        }
        return returnString;
    }
%>

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
<%//End Internationalization%>


<%
    // init. Variables
    matrix.db.Context context = null;
    String eMatrixPropertiesName = null;
    Properties eMatrixProperties = null;

    if (appDirectory == null){
        appDirectory = (String)application.getAttribute("eServiceSuiteDesignerCentral.Directory");
    }

    String emxTopIncDirName = Framework.getPagePathURL("");
    String useProxy = Framework.getPropertyValue("ematrix.proxy.server");
    if (useProxy != null && !useProxy.equalsIgnoreCase("null")) {
        emxTopIncDirName = useProxy + emxTopIncDirName;
    }

    String fileSite ="";
    if (!Framework.isLoggedIn(request)) {

        //String emxTopIncLoginURL = emxTopIncDirName + "emxLogin.jsp";
        //String loginPage = Framework.getPropertyValue("ematrix.login.page");
        String loginPage = emxTopIncDirName + "emxLogin.jsp";

        String reqURI = request.getRequestURI();
        if (reqURI.indexOf('/') > -1){
            reqURI = reqURI.substring(reqURI.lastIndexOf('/')+1,reqURI.length());
        }

        String pageURL = java.net.URLEncoder.encode(reqURI + "?" + emxGetQueryString(request));
        String hostSite = emxGetParameter(request,"hostSite");
        String cancelPageURL = emxGetParameter(request,"cancelPageURL");

        fileSite = emxGetParameter(request,"fileSite");
        String sPassedSuiteDir = emxGetParameter(request,"passSuitedir");
        if ( (sPassedSuiteDir != null) && (!sPassedSuiteDir.equals("") ) ) {
          session.setAttribute("passesSuitedir",sPassedSuiteDir);
        }

        if (( hostSite != null ) && ( fileSite != null ) && ( !"".equals(fileSite) )) {
            session.setAttribute("hostSite", hostSite);
            pageURL = Framework.getPagePathURL("infocentral") + "/" + pageURL;
            String FCSLoginPage =  Framework.getPropertyValue("ematrix.fcslogin.page");
            loginPage = FCSLoginPage;
            request.setAttribute("pageURL",pageURL);
            request.setAttribute("cancelPageURL",cancelPageURL);
        }

        String fcsTimeZone = emxGetParameter(request, "fcsTimeZone");
        if ( fcsTimeZone != null ) {
            session.setAttribute("timeZone", fcsTimeZone);
        }
%>

<!--XSSOK-->
<jsp:forward page="<%=loginPage%>" />
<%
    return;
    } else{
        // User is Logged in

        // set caching values
        response.setHeader("Cache-Control","no-store"); //HTTP 1.1
        response.setHeader("Pragma","no-cache"); //HTTP 1.0
        response.setDateHeader("Expires", 0); //prevents caching at the proxy server

        context = Framework.getFrameContext(session);

        if (context != null){
            //setPageContext(context);

            //get Directory from App. Properties Object
            eMatrixPropertiesName = (String)session.getAttribute("eMatrixPropertiesName");
            if(eMatrixPropertiesName != null) {
                eMatrixProperties = (Properties)application.getAttribute(eMatrixPropertiesName);
                suiteDir = eMatrixProperties.getProperty("eServiceSuiteDesignerCentral.Directory"); //suite directory name being picked up from properties file
            } else {
                suiteDir = (String)session.getAttribute("passesSuitedir");
            }
        }

        //set the Vault Awareness property
        String vaultAware = (String)session.getAttribute("vaultAware");
        if (vaultAware == null)
        {
            String vaString = (String)getInfoCentralProperty(application, session, "eServiceInfoCentral", "VaultAwareness");
            if (vaString != null)
            {
                 session.setAttribute("vaultAware", vaString);
                 if (vaString.equalsIgnoreCase("true"))
                 {
                      vaultAwarePerson.setToContext(context);
                      String companyVault = vaultAwarePerson.getVaultName(context);  //get the vault for the persons company
                      session.setAttribute("emxIEFDesignCenter.companyVault", companyVault);
                 }
            }
            else
            {
                 session.setAttribute("vaultAware", "false");
            }
        }
    }

%>

<%!
    public static String toNormalString (String inStr) throws UnsupportedEncodingException {

        String sBuff = "";
        byte[] bStr = new byte[inStr.length()+1];
		int i=0,j=0;
        for(;i<inStr.length();i++,j++) {
            sBuff = inStr.substring(i,i+2);
            bStr[j] = Integer.decode("0x"+sBuff).byteValue();
            i++;
        }
		byte[] bRet = new byte[j+1];
		for(int k=0;k<j;k++)
			bRet[k] = bStr[k];
        return new String(bRet, "UTF8");
    }  //---- endmethod toNormalString ----
%>

<%!
    // SnehalB: why do need to copy "getParam" to a local file of our own. 
	// it's available as a common resource in file \EMATRIX\eServiceFramework.inc

    //
    // check for URL appened values if not found, then look in Request Headers and return the string
    //
    static public String getParam(HttpServletRequest request, String parameter) throws MatrixException
    {
        String parameterValue = Request.getParameter(request,parameter);
        if (parameterValue == null || parameter.equalsIgnoreCase("null")) {
            parameterValue = (String)request.getAttribute(parameter);
        }
        return parameterValue;
    }
%>

<%!

    //
    // check for URL appended values if not found, then look in Request Headers and return the string
    //
    static public String emxGetParameter(HttpServletRequest request, String parameter)
    {
        String parameterValue = Request.getParameter(request,parameter);
        return parameterValue;

     }
%>

<%!
    // SnehalB: why do need to copy "emxGetParameterValues" to a local file of our own. 
	// it's available as a common resource in file \EMATRIX\emxRequestWrapperMethods.jsp
    	
    //
    // check for URL appended values if not found, then look in Request Headers and return the string
    //
    static public String[] emxGetParameterValues(HttpServletRequest request, String parameter)
    {
        String parameterValues[] = Request.getParameterValues(request,parameter);
      /*  if( parameterValues != null )
        {
           String parameterDecodedValues[] = new String[parameterValues.length];
           for(int i=0;i<parameterValues.length;i++)
           {
                try
                {
		            parameterDecodedValues[i] = com.matrixone.apps.domain.util.XSSUtil.decodeFromURL(parameterValues[i]);
                }
                catch( Exception ex )
                {
                }		           
           }
           return parameterDecodedValues;
        }
        else return parameterValues; 
        */
        return parameterValues;
    }
%>

<%!
    //
    // return the list of parameter names
    //
   static Enumeration emxGetParameterNames(HttpServletRequest req)
    {
        Enumeration parameterNamesEnum = req.getParameterNames();
        return (parameterNamesEnum);
    }
%>

<%!
    //
    // return the Querystring of request
    //
    static public String emxGetQueryString(HttpServletRequest request)
    {

		String queryString = "";
		Enumeration enumParamNames = emxGetParameterNames(request);
		while(enumParamNames.hasMoreElements()) {
		String paramName=(String) enumParamNames.nextElement();
		String paramValue="";
		paramValue = (String)emxGetParameter(request, paramName);
		queryString+=paramName+"="+paramValue+"&";
        }

        if((null != queryString) && !("null".equalsIgnoreCase(queryString)) && (queryString.trim().length() != 0))
        	queryString=queryString.substring(0,queryString.length()-1);
        else
        	queryString = "";
        return queryString;
    }
%>




<%!
/*************************************************************************
* This method returns StringList of the infocentral properties requested
**************************************************************************/

    public static StringList getInfoCentralProperties(ServletContext servletcontext, 
        HttpSession httpsession, String strGroup, String strKey)
    {
        String strPropertyVal = getInfoCentralProperty(servletcontext, httpsession, strGroup, strKey);
        if(strPropertyVal == null || strPropertyVal.equals(""))
            return null;
        StringList stringlist = new StringList();
        
		String strToken;
        for( StringTokenizer stringtokenizer = new StringTokenizer(strPropertyVal, ",");
		    stringtokenizer.hasMoreTokens(); stringlist.addElement( strToken.trim()) )
        {
            strToken = stringtokenizer.nextToken();
            if(strToken == null)
                strToken = "";
        }
        return stringlist;
    }

/**********************************************************************
*  This method returns String of the infocentral property requested
***********************************************************************/

    public static String getInfoCentralProperty(ServletContext servletcontext, 
	    HttpSession httpsession, String strGroup, String strKey) 
    {
        String strPropFile = (String) servletcontext.getAttribute("eServiceSuiteDesignerCentral.PropertyFileAlias");
		String strMatrixPropFile = "eMatrixProperties";
        String strPropertyValue = null;
		if(strPropFile == null || strPropFile.equals(""))
        {
            if(strMatrixPropFile == null || strMatrixPropFile.equals(""))
                return null;
            Properties properties = (Properties)servletcontext.getAttribute(strMatrixPropFile);
            try 
			{
				if(properties != null)
					strPropertyValue = properties.getProperty(strGroup + "." + strKey);
				else
					strPropertyValue =	(String)FrameworkProperties.getProperty(strGroup + "." + strKey);
			} catch(Exception e)
			{
				System.out.println("Exception occured in emxInfoCentralUtils:getInfoCentralProperty: " + e.getMessage());
			}
            
		} else
        {
            Properties properties1 = (Properties)servletcontext.getAttribute(strPropFile);
            String strCompleteKey = "";
            if(strGroup == null || strGroup.equals(""))
            {
                if(strKey == null || strKey.equals(""))
                    strCompleteKey = "";
                else
                    strCompleteKey = strKey;
            }
	    else if(strKey == null || strKey.equals(""))
                strCompleteKey = strGroup;
            else
                strCompleteKey = strGroup + "." + strKey;
			try 
			{
				if(properties1 != null)
					strPropertyValue = properties1.getProperty(strCompleteKey);
				else
					strPropertyValue =	(String)FrameworkProperties.getProperty(strCompleteKey);
			} catch(Exception e)
			{
					System.out.println("Exception occured in emxInfoCentralUtils:getInfoCentralProperty: " + e.getMessage());
			}
			
            if(strPropertyValue == null || strPropertyValue.equals(""))
            {
                if(strMatrixPropFile == null || strMatrixPropFile.equals(""))
                    return null;
                Properties properties2 = (Properties)servletcontext.getAttribute( strMatrixPropFile );
				try 
				{
					if(properties2 != null)
						strPropertyValue = properties2.getProperty(strCompleteKey);
					else
						strPropertyValue = (String)FrameworkProperties.getProperty(strCompleteKey);
				} catch(Exception e)
				{
					System.out.println("Exception occured in emxInfoCentralUtils:getInfoCentralProperty: " + e.getMessage());
				}
                
            }
        }
        if(strPropertyValue == null || strPropertyValue.equals(""))
            return null;
        else
            return strPropertyValue;
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

<%!
 /*********************************************************************
  *
  * checking i18nNow.java to find how to avoid error message being displayed
  * on finding a particular value.
  *
  *
  ***********************************************************************/
  //
  // Get the I18N Translated String for the given Type Name
  //
  static public String getTypeI18NString(String typeString, String languageStr) throws MatrixException
  {
    return i18nNow.getMXI18NString(typeString ,"",languageStr,"Type");
  }
%>

<%!
  //
  // Get the I18N Translated String for the given Policy Name
  //
  static public String getPolicyI18NString(String typeString, String languageStr) throws MatrixException
  {
    return i18nNow. getMXI18NString(typeString ,"",languageStr,"Policy");
  }
%>

<%!
  //
  // Get the I18N Translated String for the given Vault Name
  //
  static public String getVaultI18NString(String typeString, String languageStr) throws MatrixException
  {
    return i18nNow. getMXI18NString(typeString ,"",languageStr,"Vault");
  }
%>

<%!
  //
  // Get the I18N Translated String for the given Attribute Range Value
  //
  static public String getRangeI18NString(String attrString, String rangeString, String languageStr) throws MatrixException
  {
    return i18nNow.getMXI18NString(rangeString,attrString ,languageStr,"Range");
  }
%>
<%!
  //
  // Get the I18N Translated String for the given Basic Value
  //
  static public String getBasicI18NString(String basicString, String languageStr) throws MatrixException
  {
    return i18nNow.getMXI18NString(basicString,"",languageStr,"Basic");
  }
%>
<%!
  //
  // Get the I18N Translated String for the given Attribute
  //
  static public String getAttributeI18NString(String attrString, String languageStr) throws MatrixException
  {
    return i18nNow.getMXI18NString(attrString,"",languageStr,"Attribute");
  }
%>
<%!

//
  // Get the I18N Translated String for the given RelationshipName Value
  //
  static public String getRelationshipNameI18NString(String relationshipString, String languageStr) throws MatrixException
  {
    return i18nNow. getMXI18NString(relationshipString,"",languageStr,"Relationship");
  }
%>
<%!
  //
  // Get the I18N Translated String for the given State Name
  //
  static public String getStateI18NString(String policyString, String stateString, String languageStr) throws MatrixException
  {
    return i18nNow.getMXI18NString(stateString ,policyString,languageStr,"State");
  }
%>
<%!
  //
  // Get the I18N Translated String for the given Format Name
  //
  static public String getFormatI18NString(String formatString,String languageStr) throws MatrixException
  {
    return i18nNow. getMXI18NString(formatString,"",languageStr,"Format");
  }
%>
<%!
  //
  // Get the I18N Translated String for the given String, passing in the prefix
  // Either: Attribute, Basic or Range
  // Return passed in String if property file not found
  //
  static public String getMXI18NString(String preString,String postString, String languageStr,String prefix) throws MatrixException
  {
    com.matrixone.apps.domain.util.i18nNow loc = new com.matrixone.apps.domain.util.i18nNow();
    String text = "";
    if (!"".equals(postString)){
      text = "emxFramework." + prefix + "." + postString.replace(' ','_') + "." +  preString.replace(' ','_');
    }else{
      text = "emxFramework." + prefix + "." + preString.replace(' ','_');
    }
    String returnString = preString;
    try{
      String I18NreturnString = (String) loc.GetString("emxFrameworkStringResource ", languageStr, text);
      if ((!"".equals(I18NreturnString)) && (I18NreturnString != null)){
        returnString = I18NreturnString;

      }
    }catch(Exception e){
      //Do Nothing Value Already Set
      //String must not have been in Property File or another Exception
	  System.out.println(text+" not found in emxFrameworkStringResource");
    }

    return returnString;
  }
%>

<%!
  //
  // return the current state for this object
  //
  static public State getCurrentState(matrix.db.Context context, HttpSession session,
                                      BusinessObject busObj) throws MatrixException
  {
    // get the current state for this object
    StateItr stateItr = new StateItr(busObj.getStates(context));
    while(stateItr.next()){
      if (stateItr.obj().isCurrent()) {
        break;
      }
    }
    return stateItr.obj();
  }
%>

<%!
    public static String replaceCarriageReturns(String s)
    {
        String s1 = s;
        if(s != null && (s.indexOf('\n') != -1 || s.indexOf('\r') != -1))
        {
            StringBuffer stringbuffer = new StringBuffer(s.length());
            for(int i = 0; i < s.length(); i++)
            {
                char c = s.charAt(i);
                if((c == '\n') || (c == '\r'))
                    stringbuffer.append("<br>");
				else
					stringbuffer.append(c);
            }

            s1 = stringbuffer.toString();
        }
        return s1;
    }
%>

<%!
//Method to get the icon of the Respective Type
//using the BusinessObjectType servlet

    static public String drawIcon( Context context, ServletContext application, String sType)
    {
		//If servlet is to be used for getting the icon uncomment the following line
		//return "/servlet/type/" + replaceSpace(sType) + "/icon";
		
		String objectIcon = UINavigatorUtil.getTypeIconProperty(context, application, sType);
		if (objectIcon == null || objectIcon.length() == 0 )
			objectIcon = "../common/images/iconSmallDefault.gif";
		else
			objectIcon = "../common/images/" + objectIcon;
		return objectIcon;	
	    	
    }

    //To replace space with "+"
    static public String replaceSpace(String sFormatStr)
    {
        return sFormatStr.replace(' ','+');
    }
%>

<%!
  // For enter-key press.
  // This variable is used in the text field on which if you hit the enter key the form will be submitted.
  // It will call the doSearch function. This is implemented only in search pages.

  private static final  String sKeyPress = " onkeypress=\"javascript:if((event.keyCode == 13) || (event.keyCode == 10) || (event.which == 13) || (event.which == 10)) doSearch()\"";
%>
<%!
 // DSC Changes
    public String escapeJavascript(String msg)
    {       

        StringBuffer sbuf = new StringBuffer();

        char [] cArray = msg.toCharArray();

        for(int i=0; i<cArray.length; i++)
        {
            char c[] = new char[1];
            c[0] = cArray[i];

            if((new String(c)).equals("\'"))
            {
                sbuf.append("\\");
                sbuf.append(new String(c));
            }
            else if((new String(c)).equals("\\"))
            {
                sbuf.append("\\");
                sbuf.append(new String(c));
            }
            else if((new String(c)).equals("\""))
            {
                sbuf.append("\\");
                sbuf.append(new String(c));
            }
            else
            {
                sbuf.append(new String(c));
            }

        }

        return sbuf.toString();
    }    
    // DSC Changes
%>
