<%--  DSCFindLikeLinkInclude.inc

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  



  static const char RCSID[] = "$Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/DSCFindLikeLinkInclude.inc 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$"
--%>

<%@ page import = "matrix.db.*,matrix.util.*"%>						
<%@ page import = "com.matrixone.apps.framework.ui.*"%>

<%

context = Framework.getFrameContext(session);
String sLinkname              = emxGetParameter(request,"page");
String sSearchType            = emxGetParameter(request,"searchType");

if(sLinkname == null){
  sLinkname = "";
} 
if(sSearchType == null){
  sSearchType = "";
}  


%>
<script language="Javascript" >
  function goToFindLike(){

    var loc = top.location.href;
    document.location = "DSCFindLikeDialog.jsp?ComboType=<%=objectSymbolicName%>&typeString=<%=objectI18NString%>&objectIcon=<%=objectIcon%>&page=<%=XSSUtil.encodeForURL(context,sLinkname)%>&searchType=<%=XSSUtil.encodeForURL(context,sSearchType)%>&returnSearchFrameset=" + escape(loc);
  }
</script>
&nbsp;<a href="javascript:goToFindLike()" ><img src="../common/images/utilSearchPlus.gif" border="0" align="absmiddle" ></a>&nbsp;<a href="javascript:goToFindLike()" ><%=i18nNow.getI18NString("emxTeamCentralStringResource","emxTeamCentral.FindLike.More",request.getHeader("Accept-Language"))%></a>&nbsp;
