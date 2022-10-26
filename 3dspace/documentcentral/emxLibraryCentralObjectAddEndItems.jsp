<%--  emxLibraryCentralObjectAddEndItems.jsp
   Copyright (c) 1992-2016 Dassault Systemes.
   All Rights Reserved.
   This program contains proprietary and trade secret information of
   MatrixOne, Inc.
   Copyright notice is precautionary only and does not evidence any
   actual or intended publication of such program

   Description: Add contents to given Buisness object
   Parameters : childIds
                objectId

   Author     :
   Date       :
   History    :

    static const char RCSID[] = $Id: emxLibraryCentralObjectAddEndItems.jsp.rca 1.9 Wed Oct 22 16:02:16 2008 przemek Experimental przemek $;

   --%>
<%@include file = "../emxUICommonAppInclude.inc"%>
<%@include file = "../common/enoviaCSRFTokenValidation.inc"%>
<%@include file = "emxLibraryCentralUtils.inc" %>
<%
    String sClassification  = LibraryCentralConstants.TYPE_CLASSIFICATION;
    String parentId         = emxGetParameter(request, "objectId");
    String childIds[]       = getTableRowIDsArray(emxGetParameterValues(request,"emxTableRowId"));
    String folderContentAdd = emxGetParameter(request, "folderContentAdd");
	 String sNoConnectMessage = "";
	 StringBuffer errorMessage = new StringBuffer();
    try{
		StringList childInfoSelectable = new StringList();
		childInfoSelectable.add("current.access[toconnect]");
		MapList mlChildInfo = DomainObject.getInfo(context, childIds, childInfoSelectable);
		Iterator itr = mlChildInfo.iterator();
		String access = "";
		while(itr.hasNext()){
			 Map childInfo = (Map)itr.next();
			access = (String)childInfo.get("current.access[toconnect]");
			System.out.println("current.access[toconnect]:"+access);
		}
		String strResult = "";
		if(access.equalsIgnoreCase("TRUE"))
			  strResult  = (String)Classification.addEndItems(context,parentId,childIds);
		else
		{
			sNoConnectMessage = "".equals(sNoConnectMessage)?sNoConnectMessage = 
			 EnoviaResourceBundle.getProperty(context,"emxLibraryCentralStringResource", new Locale(context.getSession().getLanguage()),"emxLibraryCentral.Message.CannotConnectObjectAddItem")
			 : sNoConnectMessage;
		}
    } catch(Exception e) {
		e.printStackTrace();
        session.setAttribute("error.message",getSystemErrorMessage (e.getMessage()));
		// Changes added by PSA11 start(IR-532768-3DEXPERIENCER2018x).
		errorMessage.append(EnoviaResourceBundle.getProperty(context,"emxLibraryCentralStringResource", new Locale(context.getSession().getLanguage()),"emxLibraryCentral.Message.TypeNotClassifiable"));
		// Changes added by PSA11 end.
    }
%>

<script language="JavaScript" src="../components/emxComponentsTreeUtil.js" type="text/javascript"></script>
<script language="JavaScript" src="emxLibraryCentralUtilities.js" type="text/javascript"></script>
<script language="javascript" type="text/javaScript">
<% 
if(!"".equals(sNoConnectMessage)){
%>
    alert("<%=sNoConnectMessage%>");
<%
} else if(!"".equals(errorMessage.toString())){
%>	
	alert("<%=errorMessage.toString()%>");
<%	
} %>     

    try {
	 <% if("".equals(sNoConnectMessage)){%>
		var vTop         = "";
		if(getTopWindow().getWindowOpener()=='undefined' || getTopWindow().getWindowOpener()==null)//non popup
			vTop = getTopWindow();
		else
			vTop = getTopWindow().getWindowOpener().getTopWindow();
		updateCountAndRefreshTreeLBC("<xss:encodeForJavaScript><%=appDirectory%></xss:encodeForJavaScript>", vTop);
        getTopWindow().closeWindow();
    
    <%}%>
    }catch (ex){
    	getTopWindow().closeWindow();
    }
</script>

