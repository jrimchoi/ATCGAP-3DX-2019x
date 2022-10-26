<%--  DSCCreateCADStructure.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--  DSCCreateCADStructure.jsp   -   Creates CAD Structure by taking partId as input
  
--%>

<%@page import="com.matrixone.MCADIntegration.server.beans.MCADServerGeneralUtil, com.matrixone.apps.domain.util.*, com.matrixone.MCADIntegration.utils.*, matrix.db.BusinessObjectWithSelect"%>
<%@include file ="../integrations/MCADTopInclude.inc"%>
<%@include file ="./emxInfoUtils.inc"%>



<%!
private String getI18NString(MCADIntegrationSessionData integSessionData, String type, String key) throws Exception
	{	
		key	= removeSpacesInKey(key);
		//special case: If CAD object attributes(key) contains "-" in their name.
		if(key.contains("-"))
		{
			key = key.replace("-", "");
		}
		
		String i18nKey		= "mcadIntegration.Server." + type + "." + key;
		String i18nString	= integSessionData.getStringResource(i18nKey);

		if(i18nString == null || "null".equals(i18nString) || "".equals(i18nString) || i18nString.equals(i18nKey))
		{
			i18nString = key;
		}
		
		return i18nString;
	}

	private String	removeSpacesInKey(String key)throws Exception
	{
		StringTokenizer tokenizer	= new StringTokenizer(key," ");
		StringBuffer tempStringBuff	= new StringBuffer();
		while (tokenizer.hasMoreElements())
		{
			tempStringBuff.append(tokenizer.nextElement());
		}
		return tempStringBuff.toString();
	}

	private void getRelatedObjectNames(IEFSimpleObjectExpander simpleobjectExpander, String busId, ArrayList inputObjList, String unsupportedChars)
	{
		HashMap relidBusidMap = simpleobjectExpander.getRelidChildBusIdList(busId);
		if(relidBusidMap != null)
		{
			Iterator childRelidIterator = relidBusidMap.keySet().iterator();

			while (childRelidIterator.hasNext())
			{
				if(inputObjList.isEmpty())
				{
					String childRelId = (String) childRelidIterator.next();
					String childBusId = (String) relidBusidMap.get(childRelId);

					BusinessObjectWithSelect businessObjectWithSelect = simpleobjectExpander.getBusinessObjectWithSelect(childBusId);

					String levelObjectName	= (String)businessObjectWithSelect.getSelectData(DomainObject.SELECT_NAME);
					boolean validation		= MCADNameValidationUtil.validateForBadChars(unsupportedChars, levelObjectName);
					if(!validation)
					{
						inputObjList.add(levelObjectName);
						break;
					}
					getRelatedObjectNames(simpleobjectExpander, childBusId, inputObjList, unsupportedChars);
				}
				else
					break;
			}
		}
	}
	private void setSSOCookie(Context context,HttpServletRequest request) throws Exception 
	{
		Cookie  cookies[] 	= request.getCookies();
		StringBuffer sCooke = new StringBuffer("");
		for(int y=0;y<cookies.length;y++)
		{
			sCooke.append(cookies[y].getName() + "=" + cookies[y].getValue());
			if(y != (cookies.length -1))
				sCooke.append(";");
		}
		context.getSession().setCookieString(sCooke.toString());
	}
%>

<%
	MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute("MCADIntegrationSessionDataObject");
	Context context = integSessionData.getClonedContext(session);
	String isExtAuth = FrameworkProperties.getProperty("emxFramework.External.Authentication");
	if(isExtAuth != null && "true".equalsIgnoreCase(isExtAuth))
	{
		setSSOCookie(context,request);
	}
	
	String partID				= Request.getParameter(request,"partId");
	String integrationName		= Request.getParameter(request,"integrationName");
	String assemblyTemplateID	= Request.getParameter(request,"assemblyTemplate");
	String componentTemplateID	= Request.getParameter(request,"componentTemplate");
	String folderId				= "";
	
	if(Request.getParameter(request,"folderId") != null && !Request.getParameter(request,"folderId").equalsIgnoreCase("null"))
	{
		folderId = Request.getParameter(request,"folderId");
	}
	
	
	boolean isLicenseAssigned = false;
	String licenceMessage	  = "";
	try
	{
		Hashtable parametersTable = new Hashtable();
		parametersTable.put("IntegrationName",integrationName);
		
		//if no license is available for user then checkLicenseForDesignerCentral() throws exception
		IEFLicenseUtil.checkLicenseForDesignerCentral(context, parametersTable, integSessionData);
		isLicenseAssigned = true;
	}
	catch(Exception e)
	{
		isLicenseAssigned = false;
		licenceMessage = e.getMessage();
	}

	if(!isLicenseAssigned)
	{		
%>
		<script>
		    //XSSOK
			alert('<%=licenceMessage%>');
			top.close();
		</script>
<%	
	}
	else
	{

		if(integrationName != null && integrationName.equalsIgnoreCase(MCADAppletServletProtocol.MICROSTATION))
			componentTemplateID = assemblyTemplateID;
		
		String languageStr			= request.getHeader("Accept-Language");

		String errorString = null;

		if(integrationName != null && !integrationName.equals(""))
		{
			
			MCADGlobalConfigObject globalConfigObject = integSessionData.getGlobalConfigObject(integrationName,context);
			String unsupportedChars						= globalConfigObject.getNonSupportedCharacters();
			BusinessObject busObj						= new BusinessObject(partID); 
			busObj.open(context);
			String objectName	= busObj.getName();
			boolean validation	= MCADNameValidationUtil.validateForBadChars(unsupportedChars, objectName);
			if(!validation)
			{
				%>
				<script language="JavaScript" src="../integrations/scripts/MCADUtilMethods.js" type="text/javascript"></script>
				<script language="JavaScript" src="../common/scripts/emxUICore.js" type="text/javascript"></script>
				<script>
				    //XSSOK
					alert("<%= getI18NString(integSessionData, "Message", "CanNotCreateStrucure") %>" + "<%= getI18NString(integSessionData, "Message", "AlertInValidCharsInFileName") %>" + "\"<%=objectName%>\"\n" + "<%=unsupportedChars%>");
					top.close();
				</script>
				<%
			}
			else
			{
				String [] inputids		= new String[1];
				inputids[0]				= partID;
				Hashtable relsAndEnds	= new Hashtable();

				relsAndEnds.put(DomainObject.RELATIONSHIP_EBOM, "to");
				StringList busSelectList = new StringList(1);
				busSelectList.add(DomainObject.SELECT_NAME);
				StringList relSelects	= new StringList(1);
				ArrayList inputObjList 	= new ArrayList();
			
				IEFSimpleObjectExpander simpleObjectExpander = new IEFSimpleObjectExpander(inputids, relsAndEnds, busSelectList, relSelects, (short)0);
				simpleObjectExpander.expandInputObjects(context);

				getRelatedObjectNames(simpleObjectExpander, partID, inputObjList, unsupportedChars);
				if(!inputObjList.isEmpty())
				{	
					%>
					<script>
					    //XSSOK
						alert("<%= getI18NString(integSessionData, "Message", "CanNotCreateStrucure") %>" + "<%= getI18NString(integSessionData, "Message", "AlertInValidCharsInConnectFileName") %>" + "\"<%=inputObjList.get(0)%>\"\n" + "<%=unsupportedChars%>");
						top.close();
					</script>
					<%
				}
				else
				{
			MCADMxUtil util = new MCADMxUtil(context, integSessionData.getLogger(), integSessionData.getResourceBundle(), integSessionData.getGlobalCache());

			HashMap argumentsMap = new HashMap();
			argumentsMap.put("GCO", globalConfigObject);
			argumentsMap.put("LCO", integSessionData.getLocalConfigObject());
			argumentsMap.put("language", integSessionData.getLanguageName());
			argumentsMap.put("partID", partID);
			argumentsMap.put("integrationName", integrationName);
			argumentsMap.put("assemblyTemplateID", assemblyTemplateID);
			argumentsMap.put("componentTemplateID", componentTemplateID);
			argumentsMap.put("folderId", folderId);

			String[] args = JPO.packArgs(argumentsMap);

			try
			{
				//Start the transaction
				//util.startTransaction(context);
				ContextUtil.startTransaction(context, true);

				//invoke the JPO now to create startdesign objects
				Hashtable designObjIDTemplateObjIDMap = (Hashtable)JPO.invoke(context, "IEFCADStructureCreator", null, "createStructure", args, Hashtable.class);

				if(designObjIDTemplateObjIDMap!=null & designObjIDTemplateObjIDMap.size()>0)
				{	
					String operationStatus = (String)designObjIDTemplateObjIDMap.get("OPERATION_STATUS");
					if(operationStatus.equals("false"))
					{
						String errMessage = (String)designObjIDTemplateObjIDMap.get("ERROR_MESSAGE");
						MCADServerException.createException(errMessage,null);
					}
					
					String attrTitle				= "";
					String attrMoveFilesToVersion	= "";
					String attrIsVersionObject		= "";	
					String attrIEFFileMessageDigest	= "";	
					

					if(util.isAEFInstalled(context))
					{
						attrTitle = util.getActualNameForAEFData(context, "attribute_Title");
						attrMoveFilesToVersion   = util.getActualNameForAEFData(context, "attribute_MoveFilesToVersion");
						attrIsVersionObject		 = util.getActualNameForAEFData(context, "attribute_IsVersionObject");
						attrIEFFileMessageDigest = util.getActualNameForAEFData(context, "attribute_IEF-FileMessageDigest");
					}

					//Reached here means operation status is true, so remove this element from the table
					designObjIDTemplateObjIDMap.remove("OPERATION_STATUS");

					String workingDir	= integSessionData.getUserWorkingDirectory().getName();
					
					Enumeration designObjIDs = designObjIDTemplateObjIDMap.keys();
					while(designObjIDs.hasMoreElements())
					{
						String designObjDetails = (String)designObjIDs.nextElement();
						String templateObjID	= (String)designObjIDTemplateObjIDMap.get(designObjDetails);
						
						String designObjID		= "";
						String designObjName	= "";
						String designObjCADType = "";
						String hashcode = "";

						StringTokenizer tokens = new StringTokenizer(designObjDetails, "|");
						if(tokens.hasMoreTokens())
						{
							designObjID = tokens.nextToken();
						}
						if(tokens.hasMoreTokens())
						{
							designObjName = tokens.nextToken();
						}
						if(tokens.hasMoreTokens())
						{
							designObjCADType = tokens.nextToken();
						}

						BusinessObject templateObj = new BusinessObject(templateObjID);
						BusinessObject designObj   = new BusinessObject(designObjID);
						designObj.open(context);
						
						String majorPolicyName = designObj.getPolicy(context).getName();					
						
						designObj.close(context);

						templateObj.open(context);
						
						//get the mapped format for the template Type from GCO	
						String mappedFormat = globalConfigObject.getFormatsForType(templateObj.getTypeName(), designObjCADType);
						
						//Copy files from template Object to minor Object
						FormatList formatList = templateObj.getFormats(context);
						if (formatList != null || formatList.size() > 0)
						{	
							designObj.open(context);

							FormatItr formatItr = new FormatItr(formatList);
							while(formatItr.next())
							{
								String format = formatItr.obj().getName();

								if(!format.equals(mappedFormat))
								{
									continue;
								}

								//need to set the Title attribute with value as the file names
								String titleValue = "";
								FileList fileList = templateObj.getFiles(context, format);

								if (fileList.size() == 0)
								{
									String error = i18nStringNowUtilLocal("emxIEFDesignCenter.CreateCADStructure.Message.NoFileInTemplateObject", "emxIEFDesignCenterStringResource", languageStr);

									MCADServerException.createException(error,null);
								}

								FileItr  fileItr  = new FileItr(fileList);
								while (fileItr.next())
								{
									String fileName		= fileItr.obj().getName();
									String newFileName	= "";

									//Checkout file from template object
									templateObj.checkoutFile(context,false, format, fileName, workingDir);

									java.io.File originalFile = new java.io.File(workingDir + java.io.File.separator + fileName);
																		
									// Always change the file name on server, ignore gco flag
									// this is done to avoid cse side file rename in case 2 objects are
									// created from same template object - cse fails to rename file after checkout

									//In case of ProE chop the version number info
									if(integrationName.equalsIgnoreCase("MxPRO"))
									{
										Enumeration fileNameElements = MCADUtil.getTokensFromString(fileName, ".");

										if(fileNameElements.hasMoreElements())
										{
											fileName = (String)fileNameElements.nextElement();
										}

										if(fileNameElements.hasMoreElements())
										{
											fileName = fileName + "." + (String)fileNameElements.nextElement();
										}
									}

									String actualFileExtn  = fileName.substring(fileName.lastIndexOf('.'));
									newFileName = designObjName + actualFileExtn;

									java.io.File renamedFile = new java.io.File(workingDir + java.io.File.separator + newFileName);

									originalFile.renameTo(renamedFile);

									//Checkin the file into the design object
									util.checkinFile(context,designObj,workingDir, newFileName, format, null , majorPolicyName, designObjCADType, integrationName, integSessionData);

									/*BusinessObject MinorObj = null;
                                                                        MinorObj =      util.getActiveMinor(context, designObj);
								        String minorPolicyName = MinorObj.getPolicy(context).getName();
								 
									util.checkinFile(context,MinorObj,workingDir, newFileName, format, null , minorPolicyName, designObjCADType, integrationName, integSessionData);			 */
								 
									String hashcodeValue = IEFFileMessageDigest.computeHashCodeForFile(renamedFile.getAbsolutePath());
									hashcode = IEFServerHashCodeUtil.getIEFMessageDigestAttributeValue(format, newFileName, hashcodeValue);

									//delete the renamed file
									renamedFile.delete();

									if(!"".equals(titleValue))
									{
										titleValue += ";";
									}

									titleValue += newFileName;
								}

								MCADServerGeneralUtil _generalUtil = new MCADServerGeneralUtil(context, integSessionData, integrationName);

								Hashtable attrNameValTableForMajor = new Hashtable();
								Hashtable attrNameValTableForMinor = new Hashtable();
								if(util.isAEFInstalled(context))
								{
									//set the Title attribute here
									attrNameValTableForMinor.put(attrTitle,titleValue);
									attrNameValTableForMinor.put(attrMoveFilesToVersion, "False");
									attrNameValTableForMinor.put(attrIsVersionObject, "True");
									attrNameValTableForMinor.put(attrIEFFileMessageDigest, hashcode);
									_generalUtil.modifyBusObjForAttributes(context, designObj,attrNameValTableForMinor);									

									designObj.open(context);
									if(integrationName  != null && !integrationName.equalsIgnoreCase("solidworks"))
									{
										titleValue = designObj.getName();
									}
									attrNameValTableForMajor.put(attrTitle, titleValue);
									attrNameValTableForMajor.put(attrMoveFilesToVersion, "True");
									attrNameValTableForMajor.put(attrIsVersionObject, "False");	
									attrNameValTableForMajor.put(attrIEFFileMessageDigest, hashcode);
									_generalUtil.modifyBusObjForAttributes(context, designObj,attrNameValTableForMajor);
									designObj.close(context);					
								}

							}//format itr loop

							designObj.close(context);
						}
						templateObj.close(context);
					}
				}

				//Commit the transaction
			//util.commitTransaction(context);
			ContextUtil.commitTransaction(context);
			}
			catch(Exception exception)
			{
				try
				{
					if(context.isTransactionActive())
					context.abort();
				}
				catch(Exception commitException){}

				exception.printStackTrace();
				errorString = exception.getMessage();
			}
		}
			}
		}
%>
<%@include file = "../common/enoviaCSRFTokenValidation.inc"%>

<html>
<head>
</head>
<body>

<%	
	if(errorString != null)
	{
%>
    <!--XSSOK-->
	<h4><%= errorString %></h4>
<script language="javascript" >	
var formFooterURL  = "emxAppBottomPageInclude.jsp?beanName=null&dir=iefdesigncenter&links=1&dialog=true&usepg=false&ldisp1=emxIEFDesignCenter.Common.Close&lhref1=parent.window.close()&lacc1=role_GlobalUser &lpop1=false&ljs1=true&licon1=emxUIButtonCancel.gif&wsize1=0&oidp=null&strfile=emxIEFDesignCenterStringResource";

top.pagefooter.location.href = formFooterURL;
</script>
<%
	}
	else
	{
%>
	<script language="JavaScript">
		//top.opener.parent.location.reload();
		top.opener.parent.location.href = top.opener.parent.location.href;
		top.close();
	</script>		
<%
	}
%>
</body>
</html>

	<%}%>
