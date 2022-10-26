<%--
  iw_ApprovalMatrixPeopleChooserProcess.jsp

  Copyright (c) 2007 Integware, Inc.  All Rights Reserved.
  This program contains proprietary and trade secret information of
  Integware, Inc.
  Copyright notice is precautionary only and does not evidence any
  actual or intended publication of such program.

  $Rev: 6 $
  $Date: 2008-01-22 16:55:57 -0700 (Tue, 22 Jan 2008) $
--%>

<%@include file = "../emxUITopInclude.inc"%>
<%@include file = "iw_ApprovalMatrixJS.inc"%>
<%!
// This will show the username (fullname) if set to true else just username
public static final boolean SHOW_FULL_NAME     = false;
public static final String ROLE_OR_GROUP       = "role_or_group"; // Unique key for map
public static final String ROLE_OR_GROUP_NAME  = "role_or_group_name"; // Unique key for map
%>
<%
    String returnValue         = emxGetParameter(request, "returnValue"); // Provided by the IWApprovalMatrixPeopleChooserSearchLink command
    String emxTableRowId       = emxGetParameter(request, "emxTableRowId"); // Provided by the standard table function

    // Delimited string of values
    String dialog_data         = emxGetParameter(request, DIALOG_DATA);
    StringTokenizer tokenizer  = new StringTokenizer(dialog_data, DELIMITER);
    String roleOrGroup         = tokenizer.nextToken();
    String roleOrGroupName     = tokenizer.nextToken();
    String approverTagName     = tokenizer.nextToken();


    /*
     *  Need to determine if we need to return to the search page or
     *  process the data selected in the Person Chooser results table.
     */
    if(returnValue == null || !returnValue.equals("true"))
    {
        BusinessObject person = new BusinessObject(emxTableRowId);
        person.open(context);
        String personName = person.getName();
        person.close(context);

        /* Full name? */
        String displayName = personName;

        if( SHOW_FULL_NAME )
        {
            displayName = personName + " (" + com.matrixone.apps.domain.util.PersonUtil.getFullName(context,personName) + ")";
        }
%>
        <script type="text/javascript" language="javascript">

        getTopWindow().getWindowOpener().document.getElementById('<%=approverTagName%>').value = "<%= personName %>";
        getTopWindow().getWindowOpener().document.getElementById('<%=roleOrGroupName%>').value = "<%= displayName %>";
        getTopWindow().close();

        </script>
<%
    }
    else
    {
%>
        <script type="text/javascript" language="javascript">

        searchPerson('<%=roleOrGroup%>', '<%=roleOrGroupName%>', '<%=approverTagName%>', 0);

        </script>
<%
    }
%>

