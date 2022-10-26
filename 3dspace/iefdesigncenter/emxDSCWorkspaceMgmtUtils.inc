<%--  emxDSCWorkspaceMgmtUtils.inc

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  IEFDSCWorkspaceMgmtUtils.jsp - Helper utilities for WSM

  

--%>

<%!
  /**
   * Extracts information from selections made against an emxDSCWorkspaceMgmtDetails table.
   * Non-matrix objects are optionally ignored.  The integration name can be obtained and verified
   * to be consistent across all selected objects (the caller must do appropriate error handling).   
   *
   * @param tableRowIds        The selected rows obtained from the "emxTableRowId" request parameter.
   * @param integSessionData   Session data.
   * @param util               An instance of MCADMxUtil.
   * @param getIntegrationName Flag indicating if the integration name should be determined.  If set 
   *                           the integration name for each selected object will be found and returned.
   *                           If items are selected across multiple integrations, this will be returned
   *                           as an empty string.               
   * @param matrixFilesOnly    Flag indicating if only Matrix managed files should be returned.  If false
   *                           non-managed files will have "" for their objectId entry.   
   * @return A Vector of (objectIds, fileNames, integrationName) where objectIds is a Vector of selected
   *                           object IDs.  fileNames is a Vector of selected file names (parallel to
   *                           objectIds), and integrationName is a String containing the integration name
   *                           if getIntegrationName was true.      
   * @exception Exception Any raised exceptions during processing are not caught.
   */

   public Vector parseSelection(Context context, String[] tableRowIds, MCADIntegrationSessionData integSessionData,
                                MCADMxUtil util, boolean getIntegrationName, boolean matrixFilesOnly)
                                throws Exception
   {
      String integrationName = "";
      boolean bMultiIntegrations = false;
      Vector objectIds = new Vector();
      Vector fileNames = new Vector();
      Vector wsEntryBoids = new Vector();

      // Cycle the selected objects and retrieve the object ID for each.  Optionally
      // ignore non-matrix managed entries in the table.  Add Matrix managed entries
      // to objectIds vector.
      
      for (int ii=0; ii < tableRowIds.length; ii++)
      {
         // Retrieve the objectID from the tableRowId (e.g. filename|111.222.333.444)
         StringTokenizer tokens = new StringTokenizer(tableRowIds[ii], "|");
         String fileName = tokens.nextToken();
         String objectId = "";
         String wsEntryBoid = "";
         if (!tokens.hasMoreTokens() && matrixFilesOnly) continue; // Skip non-object entries
         fileNames.add(fileName);
         if (tokens.hasMoreTokens()) objectId = tokens.nextToken();
         objectIds.add(objectId);

         if (tokens.hasMoreTokens()) wsEntryBoid = tokens.nextToken();
         wsEntryBoids.add(wsEntryBoid);

         if (objectId.length() > 0 && getIntegrationName)
         {
            String tmpIntegrationName = util.getIntegrationName(context, objectId);
            if (integrationName.length() == 0)
               integrationName = tmpIntegrationName;
            else if (!integrationName.equals(tmpIntegrationName))
               bMultiIntegrations = true;
         }
      }
   
      // If multiple integrations were found, reset the integration name
      if (bMultiIntegrations) integrationName = "";
   
      Vector returnVec = new Vector();
      returnVec.add(objectIds);
      returnVec.add(fileNames);
      returnVec.add(integrationName);
      returnVec.add(wsEntryBoids);
      return returnVec;
   }

%>
