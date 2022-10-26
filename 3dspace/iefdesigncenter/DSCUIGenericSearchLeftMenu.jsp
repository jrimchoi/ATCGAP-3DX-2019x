<%--  DSCUIGenericSearchLeftMenu.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  

   static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/DSCUIGenericSearchLeftMenu.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>

<%@include file = "../integrations/DSCUITopInclude.inc"%>

<HTML>
<HEAD>
<title></title>
<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script>



<%
  String objectIdParam = emxGetParameter(request,"oidp");
  if( objectIdParam == null || "".equals(objectIdParam) || "null".equals(objectIdParam) )
  {
      objectIdParam = emxGetParameter(request,"objectIdParam");
  }
  String stringResourceFile     = emxGetParameter(request,"strfile");
  if( stringResourceFile == null || "".equals(stringResourceFile) || "null".equals(stringResourceFile) )
  {
      stringResourceFile = emxGetParameter(request,"stringResourceFile");
  }
  String sLanguage              = request.getHeader("Accept-Language");
  String MenuHeading            = emxGetParameter(request,"menuh");
  if( MenuHeading == null || "".equals(MenuHeading) || "null".equals(MenuHeading) )
  {
      MenuHeading = emxGetParameter(request,"MenuHeading");
  }
  String appDirectory           = emxGetParameter(request,"dir");
  if( appDirectory == null || "".equals(appDirectory) || "null".equals(appDirectory) )
  {
      appDirectory = emxGetParameter(request,"Directory");
  }

  boolean doTranslate = true;
  if ((stringResourceFile == null) || ("".equals(stringResourceFile))){
    doTranslate  = false;
  }

  //if no param, don't translate
  if (doTranslate){
    MenuHeading = i18nNow.getI18nString(MenuHeading,stringResourceFile,sLanguage);
    if ((objectIdParam != null) && (!"".equals(objectIdParam))){
      MenuHeading = com.matrixone.apps.framework.ui.UINavigatorUtil.parseStringMacro(context,session,MenuHeading,objectIdParam);
    }
  }


  String menuSection = emxGetParameter(request,"menuSection");
  if (menuSection == null)
    menuSection = "Search";
%>
<script language="javascript">
  function displayNavBar() {

	var objMgr = top.objMgr;
    objMgr.isSearch = 1;
    //create new navbar
	//XSSOK
    var navbar = objMgr.createNavBar("<%=menuSection%>", "emxUISearchPane.css");
    //set the frame to display in
    navbar.displayFrame = self.name;
    var temp;
<%
    String linkTarget = "searchContent";
    String links = emxGetParameter(request,"links");
    if( links == null || "".equals(links) || "null".equals(links) )
    {
        links = emxGetParameter(request,"NumLinks");
    }

    int numOfLinks = 0;
    if ( links != null && !"".equals(links) && !"null".equals(links) )
    {
      numOfLinks = new Integer(links).intValue();
    }

    String linkDisplay = "";
    String linkHref = "";
    String linkAccess = "";
    boolean showLink = false;
%>
    //XSSOK
    temp = navbar.addMenu("<%=MenuHeading%>");
<%
    for (int i=1; i < (numOfLinks+1); i++) {
      linkDisplay = emxGetParameter(request,"ldisp" + new Integer(i).toString());
      if( linkDisplay == null || "".equals(linkDisplay) || "null".equals(linkDisplay) )
      {
          linkDisplay = emxGetParameter(request,"LinkDisplay" + new Integer(i).toString());
      }

      if (doTranslate) {
        linkDisplay = i18nNow.getI18nString(linkDisplay,stringResourceFile,sLanguage);
        linkDisplay = com.matrixone.apps.framework.ui.UIExpression.substituteValues(context, linkDisplay);
      }
      linkHref = emxGetParameter(request,"lhref" + new Integer(i).toString());
      if( linkHref == null || "".equals(linkHref) || "null".equals(linkHref) )
      {
          linkHref = emxGetParameter(request,"LinkHref" + new Integer(i).toString());
      }

      linkAccess = emxGetParameter(request,"lacc" + new Integer(i).toString());
      if( linkAccess == null || "".equals(linkAccess) || "null".equals(linkAccess) )
      {
          linkAccess = emxGetParameter(request,"LinkAccess" + new Integer(i).toString());
      }

      StringTokenizer roleParser = new StringTokenizer(linkAccess,",");
      //parse allowable sub categories
      while (roleParser.hasMoreTokens()) {
        String role = (String)roleParser.nextElement();

        if (role != null){
          role = role.trim();
          if (role.equals("role_GlobalUser") )
          {
            showLink = true;
            break;
          }
        }

        if ((!"".equals(role)) && (role != null)){
          role = Framework.getPropertyValue(session, role);
          if (role != null){
            //test for role
            if (hasRole(context,session, role)){
              showLink = true;
              break;
            }
          }
        }
      }

      if(showLink) {
%>
        if(isMac || isNS6) {
         //XSSOK
          temp.addItem("<%=linkDisplay%>","<%=appDirectory%>/<%=linkHref%>","<%=linkTarget%>");
        } else {
		  //XSSOK
          temp.addItem("<%=linkDisplay%>","<%=linkHref%>","<%=linkTarget%>");
        }
<%
        showLink = false;
      }
    }
%>

    //draw it with javascript
    if (navbar.menus[0])
	{
		navbar.menus[0].expanded = true;
	}

	navbar.draw();
  }
</script>
</HEAD>

<BODY onLoad="displayNavBar()" >
</BODY>
</HTML>

