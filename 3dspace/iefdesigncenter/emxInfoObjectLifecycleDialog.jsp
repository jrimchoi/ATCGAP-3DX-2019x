<%--  emxInfoObjectLifecycleDialog.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
    $Archive: /InfoCentral/src/infocentral/emxInfoObjectLifecycleDialog.jsp $
    $Revision: 1.3.1.3$
    $Author: ds-mbalakrishnan$

    Name of the File : emxInfoObjectLifecycleDialog.jsp

    Description : This Page displays branched lifcycle for a given business object.

    Features:

    1. It displays all states in the lifecycle.
    2. It takes care of forward, backward, self-branches.
    3. It balances the branches on either side of the row displaying states.
    4. It sorts branches depending on the destination state in descending order to
        keep number of intersections to be minimal.
    5. It clips longer state names to the size of 12 & displays complete
        state-name in the tooltip for a given state

--%>
<%--
 *
 * $History: emxInfoObjectLifecycleDialog.jsp $
 *
 * *****************  Version 21  *****************
 * User: Snehalb      Date: 12/06/02   Time: 11:18a
 * Updated in $/InfoCentral/src/infocentral
 * removed extra <td>
 *
 * *****************  Version 20  *****************
 * User: Snehalb      Date: 11/26/02   Time: 6:28p
 * Updated in $/InfoCentral/src/InfoCentral
 * added few comments
 *
 * ***********************************************
 *
--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">

<html>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="matrix.db.*" %>
<%@ page import="com.matrixone.MCADIntegration.uicomponents.util.*" %>
<%@ page import="com.matrixone.MCADIntegration.uicomponents.beans.*" %>
<%@ page import="com.matrixone.apps.domain.*" %>

<%@include file="emxInfoCentralUtils.inc"%>
<%@include file= "../common/emxNavigatorTopErrorInclude.inc"%>
<%@include file="../emxUICommonHeaderBeginInclude.inc"%>
<%@include file = "../common/emxUIConstantsInclude.inc"%>


<link rel="stylesheet" href="../common/styles/emxUILifecycle.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIList.css" type="text/css">
<link rel="stylesheet" href="../common/styles/emxUIMenu.css" type="text/css">
<script language="JavaScript" src="../common/scripts/emxUIConstants.js" type="text/javascript"></script>
<script language="JavaScript">

  var progressBarCheck = 1;

  function removeProgressBar(){
    progressBarCheck++;
    if (progressBarCheck < 10){
		var framepageheader = findFrame(parent,"pageheader");
      if (framepageheader && framepageheader.document.imgProgress){
        framepageheader.document.imgProgress.src = "../common/images/utilSpacer.gif";
      }else{
        setTimeout("removeProgressBar()",500);
      }
    }
    return true;
  }

</script>
<body class="content" onLoad="removeProgressBar()">
<center>
<%
    //Array of arrayLists eah arrayList represents row for HTM table
    ArrayList[] htmlTableCells = null;

    try
    {
        /*******************************************************************/
        /* Steps involved in rendering life cycle for a given object
         *
         * 1. Using object id, get policy details.
         * 2. Instantiate a helper class/service class "IEF_LifeCycleImageData" that
         *      is used to find intersection of various images used while rendering
         *      LifeCycle.
         * 3. Create an instance of IEF_LifeCycleTablePresentation that is used to
         *      store the 2D representation of IEF_LifeCycle.
         *      This table is finally used to render HTML table.
         * 4. Analyze policy & create a table of images that represents branched lifecycle.
         *
        /*******************************************************************/

        ContextUtil.startTransaction(context, false);

	    //This variable stores policy detais of an object
	    HashMap policyDetails =  null;

	    //This variable stores Image resultant data required for life cycle rendering
	    IEF_LifeCycleImageData imageData = 	IEF_LifeCycleImageData.getInstance();
	    IEF_LifeCyclePolicyDetails objDetails = new IEF_LifeCyclePolicyDetails();

	    IEF_LifeCycleTablePresentation tableData = new IEF_LifeCycleTablePresentation();

        //This varibale is refers to interface which stores image urls required
	    //for branch lifecycle renedering
	    IEF_ImageUrlConstants imageRef;

	    String sObjectId = emxGetParameter(request, "objectId" );
        policyDetails = objDetails.getPolicyDetails(context,
            sObjectId,
            request.getHeader("Accept-Language"));

	    if ( policyDetails != null )
            htmlTableCells = tableData.generateTableForPresentation(policyDetails,
                sObjectId);

        ContextUtil.commitTransaction(context);
    }
    catch (Exception ex)
    {
        ContextUtil.abortTransaction(context);

        if( ( ex.toString() !=null )
            && ( ( ex.toString().trim()).length()>0 ) )
            emxNavErrorObject.addMessage(ex.toString().trim());
    }
    finally
    {
    }
%>

<table style="width : 45%" cellpadding = 0 cellspacing = 0 border = 0 >
<%
    if( htmlTableCells != null )
	{
    	ArrayList eachRow = null;

		//get the table for presentation - name of array is htmlTableCells
		for (int i=0; i < htmlTableCells.length; i++)
		{
			//each element of htmlTableCells contains an arraylist which
			//holds list of cells to be displayed in the table

			//get the arraylist from table array
			eachRow = (ArrayList) htmlTableCells[i];
%>
		    <tr>
<%			for( int j=0; j < eachRow.size(); j+=3 )
			{
				//renders three images in one iteration
%>
            	<%=( (IEF_HtmlRenderable) eachRow.get(j ) ).renderImage(38 , 26 )%>
				<%=( (IEF_HtmlRenderable) eachRow.get(j + 1) ).renderImage(90 , 26 )%>
				<%=( (IEF_HtmlRenderable) eachRow.get(j + 2 ) ).renderImage(22 , 26 )%>
<%
            }
%>
        </tr>
<%
		}
	}
%>
</table>

</center>
<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
</body>
</html>
