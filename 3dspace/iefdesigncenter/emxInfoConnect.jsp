<%--  emxInfoConnect.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%-- emxInfoConnectSearchDialog.jsp - This page displays objects and relationships to connect.


  
  static const char RCSID[] = $Id: /ENODesignerCentral/CNext/webroot/iefdesigncenter/emxInfoConnect.jsp 1.3.1.3 Sat Apr 26 10:22:24 2008 GMT ds-mbalakrishnan Experimental$
--%>


<%@ page import = "java.net.*,com.matrixone.apps.domain.util.*"%>
<%@include file="emxInfoCentralUtils.inc"%>
<%@include file="../common/emxNavigatorTopErrorInclude.inc"%>
<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script> <%--To get findFrame() function and required by emxUIActionbar.js below--%>
<script language="JavaScript" src="../common/scripts/emxUIActionbar.js" type="text/javascript"></script>

<%@include file = "../common/enoviaCSRFTokenValidation.inc"%>
<%!

  static public String replaceString(String str,String replace,String newString){
	  while(str.indexOf(replace)!=-1){
		  int index =str.indexOf(replace);
		  String restStr=str.substring(index+replace.length());
		  str=str.substring(0,index)+newString+restStr;
	  }
	  return str;
  }

%>

<%
        //bug fix 277294[support linguistic character in Type] -start
		//cleanup session data
		if( session.getAttribute("connectObjprop_KEY") != null )
			session.removeAttribute("connectObjprop_KEY") ;
		if( session.getAttribute("sRelationName") != null )
			session.removeAttribute("sRelationName");
		//bug fix 277294[support linguistic character in Type] -end
		
        String parentId =emxGetParameter(request,"parentOID");
        String rowIds[] =emxGetParameterValues(request, "emxTableRowId");
        String sRelDirection =emxGetParameter(request,"sRelDirection");
        String sRelName=emxGetParameter(request,"sRelationName");
        StringList exceptionList = new StringList();
		double tz = (new Double((String)session.getValue("timeZone"))).doubleValue();

        for(int index=0; index<rowIds.length;index++)
        {
            String ids = rowIds[index];
            String busId="";
            StringTokenizer strTk = new StringTokenizer(ids,"|");

            if(strTk.countTokens()==1)
            {
                busId = strTk.nextToken();
            }
            else
            {
                int tokenIndex = 0;
                while(strTk.hasMoreTokens())
                {
                    if(tokenIndex==1)
                        busId = strTk.nextToken();
                    else
                        strTk.nextToken();
                    tokenIndex++;
                }
            }
   			String atrrExtension="";
			String names[]=emxGetParameterValues(request, busId+"name");
			int k =0;
			int l =0;
			if(names!=null)
            {
			    for(int j=0; j<names.length; j++)
			    {
				    String name = names[j];
					String fieldName = busId.replace('.','a')+name;
				    String value = emxGetParameter(request,fieldName);
					if(value!=null)
						value=value.trim();
					if(value==null || value.equals(""))
						value = emxGetParameter(request,fieldName+"_combo");
					if(value==null)
						value="";
					if((busId+"dateFieldTimeStamp").equals(value)){
						value=emxGetParameter(request,fieldName+"_date");
						if (value != null && !value.equals("") && !value.equals("null") )
							value = com.matrixone.apps.domain.util.eMatrixDateFormat.getFormattedInputDate(value, tz, request.getLocale());
					}
					value =value.replace('\'',' ');
	   			    atrrExtension+="'" + name+"' '"+value+"' ";
			    }
            }
	        try
            {
                ContextUtil.startTransaction(context, true);
                
     		    MqlUtil.mqlCommand(context, "connect bus $1 relationship $2 $3 $4 $5 $6",parentId,sRelName,"preserve",sRelDirection,busId,atrrExtension);
                ContextUtil.commitTransaction(context);
            }
            catch(Exception exception)
			{
                ContextUtil.abortTransaction(context);
				BusinessObject obj = new BusinessObject(busId);
				obj.open(context);
				String busMsg= FrameworkUtil.i18nStringNow("emxIEFDesignCenter.Error.BusinessObject", 
                    request.getHeader("Accept-Language"));
				exceptionList.add(exception.toString().trim()+" "
                    +busMsg+" "+obj.getTypeName()+" "+obj.getName()
                    + " "+obj.getRevision());
				obj.close(context);
            }
        } 
		//end of for(int index=0; index<rowIds.length;index++)
		
		String exceptionMsg = null ;
		for (int k =0 ;k<exceptionList.size();k++)
		{
			 exceptionMsg=((String)(exceptionList.get(k))).trim();
             exceptionMsg = exceptionMsg.replace('\n',' ');
%>

 <script language="JavaScript">
            //XSSOK
            alert("<%=exceptionMsg%>");
</script>		
<%
		}
    // rajeshg - changed for custom relationship addition- 01/09/04
		if( (exceptionMsg == null) || ("null".equals(exceptionMsg)) || (exceptionMsg == "") )
		{
%>
<script language="JavaScript">
	var sTargetFrame = findFrame(parent.window.opener.parent, "detailsDisplay");
	sTargetFrame.location.href = sTargetFrame.location.href ;
</script>  
<%
		}
// end 
%>
<%@include file= "../common/emxNavigatorBottomErrorInclude.inc"%>		
<script language="javascript">
	parent.window.close();
</script>  
