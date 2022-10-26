<%--  emxCollectionsDetails.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  emxCollectionsDetails.jsp   - Detail page for Collections.


   static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxCollectionsDetails.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>

<%@ include file="../emxUICommonAppInclude.inc" %>
<%@include file = "../common/emxCompCommonUtilAppInclude.inc" %>
<%@include file = "../emxUICommonHeaderBeginInclude.inc" %>

<%@ page import="com.matrixone.apps.domain.util.MapList,
                 com.matrixone.apps.domain.util.FrameworkUtil,
                 com.matrixone.apps.domain.util.SetUtil,
                 com.matrixone.apps.framework.taglib.*,
                 java.util.*" %>

    <%
    
              String languageStr = request.getHeader("Accept-Language");
              String jsTreeID    = emxGetParameter(request,"jsTreeID");
              String objectName  = emxGetParameter(request,"objectName");
              String setName = objectName;
              
			  String charSet = request.getCharacterEncoding();

			  if(charSet == null || charSet.equals(""))
				charSet = "UTF-8";
			  
			  objectName = FrameworkUtil.decodeURL(objectName,charSet);
            // objectName = FrameworkUtil.decodeURL(objectName,"UTF-8");
            
    %>
 
        <script language="Javascript" >
        function editCollection()
        {
            
            winHeight = Math.round(screen.height*75/100);
            winWidth = Math.round(screen.width*50/100);			
            //XSSOK			
            emxShowModalDialog("emxCollectionsEditDialogFS.jsp?objectName=<%=FrameworkUtil.encodeNonAlphaNumeric(setName, charSet)%>", winWidth, winHeight );
        }

        </script>


        <%@include file = "../emxUICommonHeaderEndInclude.inc" %>

        <%
                long collectionCnt = SetUtil.getCount(context, objectName);
                String output = MqlUtil.mqlCommand(context, "list property on set $1",objectName);
                int endNameIndex = output.indexOf("value");
                String  descriptionName ="";
                
                if(endNameIndex > -1)
                    descriptionName = output.substring(endNameIndex+6);

                if(descriptionName.equalsIgnoreCase("null")||  descriptionName==null)
                    descriptionName="";
        %>

        <table border="0" width="100%" cellpadding="5" cellspacing="2">
                <tr>
                        <td class="label"><emxUtil:i18n localize="i18nId">emxFramework.Common.Name</emxUtil:i18n></td>
						<!--XSSOK-->
                        <td class="field"><%=objectName%>&nbsp;</td>
                </tr>

                <tr>
                        <td class="label"><emxUtil:i18n localize="i18nId">emxFramework.Common.Description</emxUtil:i18n></td>
						<!--XSSOK-->
                        <td class="field"><%=descriptionName%>&nbsp;</td>
                </tr>

              <tr>
                    <td class="label"><emxUtil:i18n localize="i18nId">emxFramework.Collections.ItemCount</emxUtil:i18n></td>
                    <td class="field"><%=collectionCnt%>&nbsp;</td>
            </tr>
      </table>
      <%@include file = "../emxUICommonEndOfPageInclude.inc" %>
