<%--  emxInfoObjectDetails.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%-- emxInfoObjectDetails.jsp - Updates Attributes of any Business Object

  $Archive: /InfoCentral/src/infocentral/emxInfoObjectDetails.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoObjectDetails.jsp $
 * 
 *****************  Version 52  *****************
 * User: Rajesh/Nagesh Date: 12/17/03    Time: 7:00p
 * Updated in $/InfoCentral/src/infocentral
 * To enable the esc key and key board support
 ************************************************ 
 *
 * *****************  Version 24  *****************
 * User: Manasr       Date: 1/30/03    Time: 7:28p
 * Updated in $/InfoCentral/src/infocentral
 * Made changes for menu manager.
 * 
 * *****************  Version 23  *****************
 * User: Snehalb      Date: 1/15/03    Time: 6:49p
 * Updated in $/InfoCentral/src/infocentral
 * changes for configurable menu
 * 
 * *****************  Version 22  *****************
 * User: Rahulp       Date: 1/14/03    Time: 4:00p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 21  *****************
 * User: Rahulp       Date: 1/13/03    Time: 4:07p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 19  *****************
 * User: Rahulp       Date: 1/03/03    Time: 1:51p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 18  *****************
 * User: Shashikantk  Date: 12/05/02   Time: 4:17p
 * Updated in $/InfoCentral/src/infocentral
 * Code changed to refresh the opener window
 * 
 * *****************  Version 17  *****************
 * User: Gauravg      Date: 12/04/02   Time: 4:29p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 16  *****************
 * User: Shashikantk  Date: 12/03/02   Time: 10:35a
 * Updated in $/InfoCentral/src/infocentral
 * 
 * *****************  Version 15  *****************
 * User: Shashikantk  Date: 12/02/02   Time: 6:18p
 * Updated in $/InfoCentral/src/infocentral
 * Clicking on previous link restores the values
 * 
 * *****************  Version 14  *****************
 * User: Shashikantk  Date: 11/23/02   Time: 5:59p
 * Updated in $/InfoCentral/src/InfoCentral
 * Code cleanup
 * 
 * *****************  Version 13  *****************
 * User: Shashikantk  Date: 11/21/02   Time: 6:56p
 * Updated in $/InfoCentral/src/InfoCentral
 * Removed the space between <%@include file and '='.
 * 
 * *****************  Version 14  *****************
 * User: ManasR  Date: 01/30/03   Time: 6:56p
 * Updated in $/InfoCentral/src/InfoCentral
 * Taking menu manager from session.
 * 
 * ***********************************************
 *
--%>
<%@ page import="com.matrixone.MCADIntegration.uicomponents.beans.*" %>

<%@include file="emxInfoCentralUtils.inc"%>		<%--For context, request wrapper methods, i18n methods--%>
<%@include file="emxInfoUtils.inc"%>             <%--Put IEF Menu Name in session--%>
<%@include file="../common/emxNavigatorTopErrorInclude.inc"%>
<script language="JavaScript" src="../common/scripts/emxUIConstants.js"></script> <%--Required by emxUIActionbar.js below and required for findFrame() function--%>
<script language="JavaScript" src="../common/scripts/emxUIActionbar.js" type="text/javascript"></script> <%--To show javascript error messages--%>


<!-- 12/17/2003        start    rajeshg   -->
<script language="JavaScript">
// Main function
  function cptKey(e) 
  {
    var pressedKey = ("undefined" == typeof (e)) ? event.keyCode : e.keyCode ;
		// for disabling backspace
		if (((pressedKey == 8) ||((pressedKey == 37) && (event.altKey)) || ((pressedKey == 39) && (event.altKey))) &&((event.srcElement.form == null) || (event.srcElement.isTextEdit == false)))
			return false;
		if( (pressedKey == 37 && event.altKey) || (pressedKey == 39 && event.altKey) && (event.srcElement.form == null || event.srcElement.isTextEdit == false))
			return false;

    if (pressedKey == "27") 
    { 
       // ASCII code of the ESC key
       top.window.close();
    }
  }
// Add a handler
document.onkeypress = cptKey ;

</script>
<!-- content begins here -->
<%
	String sName        = "";
	String sRevision    = "";
	String sVault       = "";

	String sBusId = emxGetParameter(request, "objectId");
	String sDescription = emxGetParameter(request, "txtDescription");
//bug fix: 278616 - Weird encoding for some URLs - start
	String hasModify = emxGetParameter(request, "hasModify");
	String contentPageIsDialog = emxGetParameter(request, "contentPageIsDialog");
	String warn = emxGetParameter(request, "warn");
	
	String strOrgDescription= emxGetParameter(request, "orgBODescription");
	String encodeOrgDesc = "";
	if(strOrgDescription !=null && !"null".equals(strOrgDescription) ){
		strOrgDescription = strOrgDescription.trim();
		encodeOrgDesc = java.net.URLEncoder.encode(strOrgDescription);
	}
	String encodeDesc = "";
	if( sDescription != null && !"null".equals(sDescription)) 
		encodeDesc = java.net.URLEncoder.encode(sDescription);
//bug fix: 278616 - Weird encoding for some URLs - END
	double tz = (new Double((String)session.getValue("timeZone"))).doubleValue();
	boolean bClone = false;	
	BusinessObject boGeneric = null;
    
    String strOrgBOName = ""; // enable MQL notice change
	if("true".equalsIgnoreCase(emxGetParameter(request, "doClone"))){
		bClone = true;
	}

	String queryString = "?objectId="+sBusId+ "&hasModify=" +hasModify+ "&txtDescription=" +encodeDesc+ "&orgBODescription="+encodeOrgDesc+ "&doClone=" +bClone+ "&warn=" +warn+ "&contentPageIsDialog=" +contentPageIsDialog;	//Bug fix: 278616 - Weired encoding for some URLs

    try
    {
		//Starts Database transaction  
    	 ContextUtil.startTransaction(context, true);

        boGeneric = new BusinessObject(sBusId);    
        boGeneric.open(context);
        strOrgBOName = boGeneric.getName();//Added on 28/1/2004
        String sClonedId=null;
	    //******************This code is used if the object is cloned**********
	    if(bClone)
            {	
		    sName        = emxGetParameter(request, "txtName");
		    sRevision    = emxGetParameter(request, "txtRevision");
		    sVault       = emxGetParameter(request, "txtVault");		
		    sDescription = emxGetParameter(request, "txtNewDescription");
			if( sDescription != null && !"null".equals(sDescription))
			encodeDesc = java.net.URLEncoder.encode(sDescription);

			queryString += "&txtName="+java.net.URLEncoder.encode(sName)+ "&txtRevision=" +java.net.URLEncoder.encode(sRevision)+ "&txtVault=" +sVault+ "&txtNewDescription=" +encodeDesc;//Bug fix: 278616 - Weired encoding for some URLs

		    //Clone the business object and get the new business object id
		    BusinessObject boCloneObj = boGeneric.clone(context,sName.trim(),sRevision,sVault);
                    //Added on 4/2/2004 for bug fix:enable mql notice,event=copy,trigger=override,return=1
                  sClonedId = boCloneObj.getObjectId();
                  if(sClonedId!=null && !"null".equals(sClonedId) && !"".equals(sClonedId))
                  {
                    //End of add on 4/2/2004
                    boGeneric.close(context);                    
		    boCloneObj.open(context);
		    boCloneObj.close(context);
		    sBusId = sClonedId;				
		    boGeneric = new BusinessObject(sBusId);		
		    boGeneric.open(context);
	    }
	      }
	    //******************Above code is used if the object is cloned*********

        if(sDescription != null && sDescription.length() > 0)
            sDescription = sDescription.trim();

			if(!sDescription.equals(strOrgDescription)) //Added by nagesh on 5/1/2004
			{
        //Update the description of the object
        boGeneric.setDescription(sDescription);
			}

        //Get the attibute list associated with the BO id
        BusinessObjectAttributes boAttrGeneric = boGeneric.getAttributes(context);
        AttributeItr attrItrGeneric   = new AttributeItr(boAttrGeneric.getAttributes());
        AttributeList attrListGeneric = new AttributeList();

        String sAttrValue   = "";
        String sTrimVal     = "";
        String sAttrVal  = "";
		String encodeAttrVal ="";
        String sAttrComboVal = "";
        String sAttName     = "";
        
		String strOrgAttrValue = null;
		boolean blnHasChoice = false;
        //Loop through the attribute list
		  while (attrItrGeneric.next())
		  {
			blnHasChoice = false;
	        //To get the type of the attribute
	        Attribute attrGeneric = attrItrGeneric.obj();
	        AttributeType attrTypeGeneric = attrGeneric.getAttributeType();
	        attrTypeGeneric.open(context);
			//Added by nagesh on 7/1/2004 
			if(attrGeneric.hasChoices())
				 blnHasChoice = true;
			strOrgAttrValue = attrGeneric.getValue();
			//End of Add by nagesh on 7/1/2004 

	        String sDataType       = attrTypeGeneric.getDataType();
	        attrTypeGeneric.close(context);
	        sAttrComboVal  = "" ;
	        sAttrVal = "";
	        sAttName = attrGeneric.getName(); 
	        sAttrVal = emxGetParameter(request, sAttName);

		if("timestamp".equals(sDataType))
		{
			if (sAttrVal != null && !sAttrVal.equals("") && !sAttrVal.equals("null") ){
				sAttrVal = com.matrixone.apps.domain.util.eMatrixDateFormat.getFormattedInputDate(sAttrVal,tz,request.getLocale());
			}
		}
		if( sAttrVal !=null && !"null".equals(sAttrVal) )
			encodeAttrVal = java.net.URLEncoder.encode(sAttrVal);
		queryString = queryString + "&" + java.net.URLEncoder.encode(sAttName) + "=" + encodeAttrVal;//Bug fix: 278616 - Weired encoding for some URLs
    	    sAttrComboVal = emxGetParameter(request, sAttName+"_combo");			
			// 7/1/2004 Added by nagesh
			 if(blnHasChoice && (strOrgAttrValue == null || "null".equals(strOrgAttrValue) ))
			  {
					attrListGeneric.addElement(attrGeneric);
	        }
			  else if ((sAttrVal != null) && (!sAttrVal.equals("")) && !sAttrVal.equals("null")) 
			  {
                            sTrimVal = sAttrVal.trim();
			    attrGeneric.setValue(sTrimVal);
		        attrListGeneric.addElement(attrGeneric);
	        }
			  else if("".equals(sAttrVal) )
			  {
                            attrGeneric.setValue(sAttrVal);
                            attrListGeneric.addElement(attrGeneric);
			  }
			 // End 7/1/2004 Added by nagesh
		}
        //Update the attributes on the Business Object
        boGeneric.setAttributes(context, attrListGeneric);
        boGeneric.update(context);
		session.removeAttribute("New_Name");
		session.removeAttribute("New_Revision");
		session.removeAttribute("New_Vault");        
%>
<%@include file= "../common/emxNavigatorBottomErrorInclude.inc"%>  <!-- enable MQL notice change -->	
<%
        if(bClone)
	{
            //Added on 4/2/2004 for bug fix:enable mql notice,event=copy,trigger=override,return=1
	  if(sClonedId!=null && !"null".equals(sClonedId) && !"".equals(sClonedId))
          {   
	     //End of add on 4/2/2004
	        //******************This code is used if the object is cloned******
            String menuName = getINFMenuName( request, context, sBusId );
	        String sActionURL	=  "../common/emxTree.jsp?objectId=" + sBusId + "&treeMenu=" + menuName;
%>
	        <script language="JavaScript">
		        var url = "<%=XSSUtil.encodeForJavaScript(context,sActionURL)%>";
				var sFrame = parent.window.opener.parent;
				var sTargetFrame = findFrame(sFrame, "content");
				if(sTargetFrame){
					sTargetFrame.location=url;
				}else{
                    parent.window.opener.parent.parent.document.location = url;//Enable AEF style toolbar change
				}
		        parent.window.close();
	        </script>
<%
               //added on 4/2/2004
                }else{
%>
                        <script language="Javascript">
                        parent.window.close();
                         </script>   
<%
  }            //End of add on 4/2/2004 
	    }else{	
	    //##################This code is used if the object is modified########
%>	
	        <script language="JavaScript">
				var sFrame = parent.window.opener.parent;
				var sTargetFrame = findFrame(sFrame, "pagecontent");
				if(sTargetFrame){
					sTargetFrame.location.href=sTargetFrame.location.href;
				}else{
					//check if the content frame exists 
					if(parent.window.opener.parent.frames[1].frames[1])
						parent.window.opener.parent.frames[1].frames[1].location.href=parent.window.opener.parent.frames[1].frames[1].location.href;
					else //this is a pop up window
						parent.window.opener.parent.frames[0].frames[1].frames[1].location.href=parent.window.opener.parent.frames[0].frames[1].frames[1].location.href;
				}
		        parent.window.close();
	        </script>
<%
		
	    }		
    } 
    catch (MatrixException e)
	{
		// abort Transaction
		ContextUtil.abortTransaction(context);		
        String sError = e.getMessage();
	    if(sError.indexOf("Message:") >=0)
	    {
	    	sError = sError.substring(sError.indexOf("Message:")+8);
	    	if(sError.indexOf("Severity:") >=0){
	    		sError = sError.substring(0,sError.indexOf("Severity:"));
	    	}
			//queryString = Framework.encodeURL(response, queryString);
			String url = "";
			if(bClone)
			{
				url = "emxInfoObjectCloneAttributes.jsp";
                           //try-catch block added on 28/1/2004 
                           try
                           {
                                if(!strOrgBOName.equals(boGeneric.getName()))
				boGeneric.remove(context);
                           }catch(Exception exp){
                            System.out.println("Exception:"+exp.getMessage());
                            }
                            //End of Add on 28/1/2004    
			}
			else
            {
				url = "emxInfoObjectDetailsDialog.jsp";
            }
%>    
		<script language=javascript>
		      //XSSOK
			  showError("<%=sError%>");
		</script>

<!-- Added on 28/1/2004 to enable MQL error/notices-->	
		<%@include file= "../common/emxNavigatorBottomErrorInclude.inc"%>		
		<script language=javascript>
			  top.frames[1].location.href="<%=url+queryString%>";
		</script>
<!--End of  Add on 28/1/2004 to enable MQL error/notices-->	


<%
	    }else{
                    if(bClone)
                    {
			//If the object with the same Type, Name and Revision is already present.
%>    	
				<script language=javascript>	
                    //XSSOK				
					showError("<framework:i18nScript localize='i18nId'>emxIEFDesignCenter.Common.CloneObject</framework:i18nScript> \n <%=sError%>");
					parent.window.close();
				</script>
<%
			}else{	
%>
				<script language=javascript>
				    //XSSOK
					showError("<framework:i18nScript localize='i18nId'>emxIEFDesignCenter.EditDetails.UpdateError</framework:i18nScript> \n <%=sError%>");
					parent.window.close();
				</script>
<%
			}
		}
    }
	finally 
	{
    	ContextUtil.commitTransaction(context);
	}
	boGeneric.close(context);
%>

<!-- content ends here -->
