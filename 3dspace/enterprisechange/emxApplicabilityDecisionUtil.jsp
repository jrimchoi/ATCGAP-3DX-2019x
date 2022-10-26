<%-- emxApplicabilityDecisionUtil.jsp

    Copyright (c) 1992-2018 Enovia Dassault Systemes.All Rights Reserved.
    This program contains proprietary and trade secret information of MatrixOne,Inc.
    Copyright notice is precautionary only and does not evidence any actual
    or intended publication of such program

    static const char RCSID[] =$Id: /web/enterprisechange/emxApplicabilityDecisionUtil.jsp 1.1 Fri Oct 1 16:45:25 2010 GMT ds-panem Experimental$
--%>


<%@page import="com.matrixone.apps.domain.util.PropertyUtil"%>
<%@page import="com.matrixone.apps.domain.util.XSSUtil"%>

<%@page import="com.matrixone.apps.domain.util.EnoviaResourceBundle"%>
<html>
	<head>
		<title>
		</title>
		<%@page import="com.matrixone.apps.domain.DomainConstants"%>
		<%@page import="com.matrixone.apps.domain.DomainObject"%>
		<%@page import="com.matrixone.apps.domain.DomainRelationship"%>
		<%@page import="com.matrixone.apps.enterprisechange.EnterpriseChangeConstants"%>
		<%@page import="com.matrixone.apps.productline.ProductLineUtil"%>
		<%@page import="com.matrixone.apps.domain.util.FrameworkUtil"%>
		<%@page import="com.matrixone.apps.domain.util.MessageUtil"%>
		<%@page import="com.matrixone.apps.common.util.FormBean"%>
		<%@page import="com.matrixone.apps.framework.ui.UINavigatorUtil"%>

		<%@page import="matrix.util.StringList"%>
		<%@page import="matrix.util.Pattern"%>
		<%@page import="java.util.Iterator"%>
		<%@page import="java.util.Map"%>
		<%@page import="java.util.HashMap"%>

		<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
		<%@include file = "../components/emxComponentsCommonInclude.inc" %>
		<%@include file = "../emxUICommonAppInclude.inc"%>

		<emxUtil:localize id="i18nId" bundle="emxEnterpriseChangeStringResource" locale='<%=XSSUtil.encodeForHTMLAttribute(context, request.getHeader("Accept-Language") )%>' />

		<!--emxUIConstants.js is included to call the findFrame() method to get a frame-->
		<jsp:useBean id="tableBean" class="com.matrixone.apps.framework.ui.UITable" scope="session"/>
		<script language="JavaScript" src="../common/scripts/emxUICore.js"></script>
		<script language="Javascript" src="../common/scripts/emxUIConstants.js"></script>
		<script language="Javascript" src="../common/scripts/emxUIUtility.js"></script>
		<script language="javascript" src="../common/scripts/emxUIModal.js"></script>
		
	</head>

	<body>
		<form name="applicabilityDecisionUtil" action="emxApplicabilityDecisionUtil.jsp">
		<input type="hidden" name ="decisionId" value ="">
		<input type="hidden" name ="applicableItemId" value ="">
		<input type="hidden" name ="relatedApplicableItemRelId" value ="">

		<%
		String strMode = emxGetParameter(request,"mode");
		String jsTreeID = emxGetParameter(request, "jsTreeID");
		String strObjId = emxGetParameter(request, "objectId");
		String uiType = emxGetParameter(request,"uiType");
		String strMode1 = emxGetParameter(request,"context");
		String suiteKey = emxGetParameter(request, "suiteKey");
		String registeredSuite = emxGetParameter(request,"SuiteDirectory");

		String strContext = emxGetParameter(request,"context");
		String strLanguage = request.getHeader("Accept-Language");
		boolean bIsError = false;
		try{
			if(strMode.equalsIgnoreCase("")){
				try{
					%>
					<script language="javascript">
					window.parent.getTopWindow().getWindowOpener().parent.location.href = window.parent.getTopWindow().getWindowOpener().parent.location.href;
					window.getTopWindow().close();
					</script>
					<%
				}catch(Exception e){
					bIsError=true;
					session.putValue("error.message", e.toString());
				}
			}

			else if(strMode.equalsIgnoreCase("addExistingDecisionApplicableItems")){
				try{
					StringList objectSelects = new StringList(DomainConstants.SELECT_ID);
					StringList relationshipSelects = new StringList(DomainConstants.SELECT_RELATIONSHIP_ID);

					DomainObject domObject = DomainObject.newInstance(context,strObjId);
					String applicableItemTypes = "";
					String applicableItemCurrents = "";
					StringList listDisciplines = new StringList();

					String strInterfaceName = EnterpriseChangeConstants.INTERFACE_CHANGE_DISCIPLINE;
					BusinessInterface busInterface = new BusinessInterface(strInterfaceName, context.getVault());
					AttributeTypeList listInterfaceAttributes = busInterface.getAttributeTypes(context);

					//Get Applies To --> All Change Tasks
					MapList appliesToObjects = domObject.getRelatedObjects(context,
							DomainConstants.RELATIONSHIP_DECISION_APPLIES_TO,
							//DomainConstants.QUERY_WILDCARD,
							DomainConstants.TYPE_CHANGE_TASK,
							objectSelects,
							relationshipSelects,
							false,	//to relationship
							true,	//from relationship
							(short)1,
							DomainConstants.EMPTY_STRING, // object where clause
							DomainConstants.EMPTY_STRING, // relationship where clause
							0);

					//if Decision Applies To Change Task
					if(appliesToObjects!=null && appliesToObjects.size()>0){
						Iterator appliesToObjectsItr = appliesToObjects.iterator();
						while(appliesToObjectsItr.hasNext()){
							Map appliesToObject = (Map)appliesToObjectsItr.next();
							if(appliesToObject!=null && appliesToObject.size()>0){
								String appliesToObjectId = (String)appliesToObject.get(DomainConstants.SELECT_ID);
								if(appliesToObjectId!=null && !appliesToObjectId.equalsIgnoreCase("")){
									DomainObject appliesToDom = new DomainObject(appliesToObjectId);
									Iterator listInterfaceAttributesItr = listInterfaceAttributes.iterator();
									while(listInterfaceAttributesItr.hasNext()){
										String attrName = ((AttributeType) listInterfaceAttributesItr.next()).getName();
										String attrNameSmall = attrName.replaceAll(" ", "");
										String attrValue = appliesToDom.getAttributeValue(context, attrName);
										if(attrValue.equalsIgnoreCase(EnterpriseChangeConstants.CHANGE_DISCIPLINE_TRUE)){
											//Retrieve allowed types
											StringList listApplicableItemTypes = FrameworkUtil.split(EnoviaResourceBundle.getProperty(context, "emxEnterpriseChange." + attrNameSmall + ".ApplicableItemTypes"), ",");
											if(listApplicableItemTypes!=null && !listApplicableItemTypes.isEmpty()){
												Iterator listApplicableItemTypesItr = listApplicableItemTypes.iterator();
												while(listApplicableItemTypesItr.hasNext()){
													String applicableItemType = (String) listApplicableItemTypesItr.next();
													if(applicableItemType!=null && !applicableItemType.equalsIgnoreCase("")){
														//Check if type exists
														if(PropertyUtil.getSchemaProperty(context,applicableItemType)!=null && !PropertyUtil.getSchemaProperty(context,applicableItemType).equalsIgnoreCase("")){
															//Type exists, add it to the search type list
															if(applicableItemTypes.length() > 0){
																applicableItemTypes += ",";
												    	    }
															applicableItemTypes += applicableItemType;
														}
													}
												}
											}

											//If allowed type list is not empty, retrieve allowed policy and state
											if(applicableItemTypes!=null && !applicableItemTypes.isEmpty()){
												StringList listApplicableItemCurrents = FrameworkUtil.split(EnoviaResourceBundle.getProperty(context, "emxEnterpriseChange." + attrNameSmall + ".ApplicableItemCurrent"), ",");
												if(listApplicableItemCurrents!=null && !listApplicableItemCurrents.isEmpty()){
													Iterator listApplicableItemCurrentsItr = listApplicableItemCurrents.iterator();
													while(listApplicableItemCurrentsItr.hasNext()){
														String applicableItemCurrent = (String) listApplicableItemCurrentsItr.next();
														if(applicableItemCurrent!=null && !applicableItemCurrent.equalsIgnoreCase("")){
															//String applicableItemCurrent is composed of policy.state --> should be splitted
															StringList listPolicyState = FrameworkUtil.split(applicableItemCurrent, ".");
															if(listPolicyState!=null && listPolicyState.size()==2){
																String applicableItemPolicy = (String)listPolicyState.get(0);
																String applicableItemState = (String)listPolicyState.get(1);

																if(PropertyUtil.getSchemaProperty(context,applicableItemPolicy)!=null && !PropertyUtil.getSchemaProperty(context,applicableItemPolicy).equalsIgnoreCase("")){
																	if(PropertyUtil.getSchemaProperty(context,"policy", PropertyUtil.getSchemaProperty(context,applicableItemPolicy), applicableItemState)!=null && !PropertyUtil.getSchemaProperty(context,"policy", PropertyUtil.getSchemaProperty(context,applicableItemPolicy), applicableItemState).equalsIgnoreCase("")){
																		//Policy and state exist
																		if(applicableItemCurrents.length() > 0){
																			applicableItemCurrents += ",";
															    	    }
																		applicableItemCurrents += applicableItemCurrent;
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
					%>
		            <script language="javascript" type="text/javaScript">
		            	<%if(applicableItemTypes!=null && !applicableItemTypes.equalsIgnoreCase("")){%>
		            	//XSSOK
			            	var sURL="../common/emxFullSearch.jsp?objectId=<%=XSSUtil.encodeForURL(context,strObjId)%>&field=TYPES=<%=applicableItemTypes%>";
			            	<%if(applicableItemCurrents!=null && !applicableItemCurrents.equalsIgnoreCase("")){%>
			            		sURL = sURL + ":CURRENT=<%=XSSUtil.encodeForURL(context,applicableItemCurrents)%>";
			            	<%}%>
			            	sURL = sURL + "&excludeOIDprogram=emxApplicabilityDecision:excludeDecisionApplicableItems&table=ECHApplicableItemSearchResult&cancelLabel=Cancel&submitLabel=Done&hideHeader=true&HelpMarker=emxhelpfullsearch&selection=multiple&submitURL=../enterprisechange/ECHConnectApplicableItems.jsp";
							showChooser(sURL, 850, 630);
		            	<%}else{
				            String srAlert = (String)(EnoviaResourceBundle.getProperty(context,"EnterpriseChange","emxEnterpriseChange.Alert.NoApplicableItemDefined",strLanguage)).trim();
				            throw new FrameworkException(srAlert);
						}%>
					</script>
					<%
				}catch(Exception e){
					bIsError=true;
					session.putValue("error.message", e.toString());
				}
			}

			else if(strMode.equalsIgnoreCase("addExistingDecisionDesignApplicableItems")){
				try{
					String applicableItemTypes = "";
					String applicableItemCurrents = "";
					String changeDiscipline = EnterpriseChangeConstants.ATTRIBUTE_CHANGE_DISCIPLINE_DESIGN;

					//Retrieve allowed types
					StringList listApplicableItemTypes = FrameworkUtil.split(EnoviaResourceBundle.getProperty(context, "emxEnterpriseChange." + "ChangeDisciplineDesign" + ".ApplicableItemTypes"), ",");
					if(listApplicableItemTypes!=null && !listApplicableItemTypes.isEmpty()){
						Iterator listApplicableItemTypesItr = listApplicableItemTypes.iterator();
						while(listApplicableItemTypesItr.hasNext()){
							String applicableItemType = (String) listApplicableItemTypesItr.next();
							if(applicableItemType!=null && !applicableItemType.equalsIgnoreCase("")){
								//Check if type exists
								if(PropertyUtil.getSchemaProperty(context,applicableItemType)!=null && !PropertyUtil.getSchemaProperty(context,applicableItemType).equalsIgnoreCase("")){
									//Type exists, add it to the search type list
									if(applicableItemTypes.length() > 0){
										applicableItemTypes += ",";
						    	    }
									applicableItemTypes += applicableItemType;
								}
							}
						}
					}

					//If allowed type list is not empty, retrieve allowed policy and state
					if(applicableItemTypes!=null && !applicableItemTypes.isEmpty()){
						StringList listApplicableItemCurrents = FrameworkUtil.split(EnoviaResourceBundle.getProperty(context, "emxEnterpriseChange." + "ChangeDisciplineDesign" + ".ApplicableItemCurrent"), ",");
						if(listApplicableItemCurrents!=null && !listApplicableItemCurrents.isEmpty()){
							Iterator listApplicableItemCurrentsItr = listApplicableItemCurrents.iterator();
							while(listApplicableItemCurrentsItr.hasNext()){
								String applicableItemCurrent = (String) listApplicableItemCurrentsItr.next();
								if(applicableItemCurrent!=null && !applicableItemCurrent.equalsIgnoreCase("")){
									//String applicableItemCurrent is composed of policy.state --> should be splitted
									StringList listPolicyState = FrameworkUtil.split(applicableItemCurrent, ".");
									if(listPolicyState!=null && listPolicyState.size()==2){
										String applicableItemPolicy = (String)listPolicyState.get(0);
										String applicableItemState = (String)listPolicyState.get(1);

										if(PropertyUtil.getSchemaProperty(context,applicableItemPolicy)!=null && !PropertyUtil.getSchemaProperty(context,applicableItemPolicy).equalsIgnoreCase("")){
											if(PropertyUtil.getSchemaProperty(context,"policy", PropertyUtil.getSchemaProperty(context,applicableItemPolicy), applicableItemState)!=null && !PropertyUtil.getSchemaProperty(context,"policy", PropertyUtil.getSchemaProperty(context,applicableItemPolicy), applicableItemState).equalsIgnoreCase("")){
												//Policy and state exist
												if(applicableItemCurrents.length() > 0){
													applicableItemCurrents += ",";
									    	    }
												applicableItemCurrents += applicableItemCurrent;
											}
										}
									}
								}
							}
						}
					}

					%>
		            <script language="javascript" type="text/javaScript">
		            	<%if(applicableItemTypes!=null && !applicableItemTypes.equalsIgnoreCase("")){%>
		            	//XSSOK
			            	var sURL="../common/emxFullSearch.jsp?objectId=<%=XSSUtil.encodeForURL(context,strObjId)%>&field=TYPES=<%=applicableItemTypes%>";
			            	<%if(applicableItemCurrents!=null && !applicableItemCurrents.equalsIgnoreCase("")){%>
			            		sURL = sURL + ":CURRENT=<%=XSSUtil.encodeForURL(context,applicableItemCurrents)%>";
			            	<%}%>
			            	sURL = sURL + "&excludeOIDprogram=emxApplicabilityDecision:excludeDecisionDesignApplicableItems&table=ECHApplicableItemSearchResult&cancelLabel=Cancel&submitLabel=Done&hideHeader=true&HelpMarker=emxhelpfullsearch&selection=multiple&submitURL=../enterprisechange/ECHConnectApplicableItems.jsp&changeDiscipline=<%=XSSUtil.encodeForURL(context,changeDiscipline)%>";
							showChooser(sURL, 850, 630);
		            	<%}else{
				            String srAlert = (String)(EnoviaResourceBundle.getProperty(context,"EnterpriseChange","emxEnterpriseChange.Alert.NoApplicableItemDefined",strLanguage)).trim();
				            throw new FrameworkException(srAlert);
						}%>
					</script>
					<%
				}catch (Exception e){
					session.putValue("error.message", e.getMessage());
					throw e;
				}
			}

			else if(strMode.equalsIgnoreCase("addExistingDecisionManufacturingApplicableItems")){
				try{
					String strObjIdContext = emxGetParameter(request, "objectId");
					String[] strTableRowIds = emxGetParameterValues(request, "emxTableRowId");
					String strObjectID = null;
					String strRelID = null;
					String strModelId = null;
					String changeDiscipline = EnterpriseChangeConstants.ATTRIBUTE_CHANGE_DISCIPLINE_MANUFACTURING;
					
					//Retrieve allowed types
					StringList listApplicableItemTypes = FrameworkUtil.split(EnoviaResourceBundle.getProperty(context, "emxEnterpriseChange." + "ChangeDisciplineManufacturing" + ".ApplicableItemTypes"), ",");

					if(strTableRowIds != null && strTableRowIds.length > 0){
						if(strTableRowIds.length > 1){
				            String srAlert = (String)(EnoviaResourceBundle.getProperty(context,"EnterpriseChange","emxEnterpriseChange.Alert.SelectOnlyOneItem",strLanguage)).trim();
				            throw new FrameworkException(srAlert);
						}else{
							String strTableRowId = strTableRowIds[0];
							StringList slEmxTableRowId = FrameworkUtil.split(strTableRowId, "|");
							if (slEmxTableRowId.size() > 0)	{
								//Architecture: RelId|Id|ParentId|level
								String strTempRelId = (String)slEmxTableRowId.get(0);
								String strTempObjId = (String)slEmxTableRowId.get(1);
								if(strTempObjId!=null && !strTempObjId.equalsIgnoreCase("")){
									DomainObject domTempObj = new DomainObject(strTempObjId);
									//String strType = (String) domTempObj.getInfo(context, DomainConstants.SELECT_TYPE);
									//Added for IR-088327V6R2012 : ixe : 28.12.2010
									//Retrieve allowed types
									boolean canAdd = false;
									if(listApplicableItemTypes!=null && !listApplicableItemTypes.isEmpty()){
										Iterator listApplicableItemTypesItr = listApplicableItemTypes.iterator();
										
										while(listApplicableItemTypesItr.hasNext()){
											String applicableItemType = (String) listApplicableItemTypesItr.next();
											if(applicableItemType!=null && !applicableItemType.equalsIgnoreCase("")){
												//Check if type exists
												if(PropertyUtil.getSchemaProperty(context,applicableItemType)!=null && !PropertyUtil.getSchemaProperty(context,applicableItemType).equalsIgnoreCase("")){
													//Type exists,
													if(domTempObj.isKindOf(context, PropertyUtil.getSchemaProperty(context,applicableItemType))){
														canAdd = true;
													}
												}
											}
										}
									}
									if (canAdd) {
										%>
										 <script language="javascript" type="text/javaScript">
											showModalDialog("../common/emxFullSearch.jsp?objectId=<%=XSSUtil.encodeForURL(context,strTempObjId)%>&id[connection]=<%=XSSUtil.encodeForURL(context,strTempRelId)%>&field=TYPES=type_Products,type_LogicalFeature,type_Model&table=ECHApplicableItemSearchResult&Registered Suite=EnterpriseChange&HelpMarker=emxhelpfullsearch&selection=multiple&showSavedQuery=true&hideHeader=true&submitURL=../enterprisechange/emxApplicabilityDecisionUtil.jsp?mode=connectManufacturingApplicableItemManufacturingIntent",850,630);
										 </script>
										 <%
									} else {
							            String srAlert = (String)(EnoviaResourceBundle.getProperty(context,"EnterpriseChange","emxEnterpriseChange.Alert.CannotAddToThisNode",strLanguage)).trim();
							            throw new FrameworkException(srAlert);
									}
								}
							}
						}
					}else{
						String applicableItemTypes = "";
						String applicableItemCurrents = "";

						if(listApplicableItemTypes!=null && !listApplicableItemTypes.isEmpty()){
							Iterator listApplicableItemTypesItr = listApplicableItemTypes.iterator();
							while(listApplicableItemTypesItr.hasNext()){
								String applicableItemType = (String) listApplicableItemTypesItr.next();
								if(applicableItemType!=null && !applicableItemType.equalsIgnoreCase("")){
									//Check if type exists
									if(PropertyUtil.getSchemaProperty(context,applicableItemType)!=null && !PropertyUtil.getSchemaProperty(context,applicableItemType).equalsIgnoreCase("")){
										//Type exists, add it to the search type list
										if(applicableItemTypes.length() > 0){
											applicableItemTypes += ",";
							    	    }
										applicableItemTypes += applicableItemType;
									}
								}
							}
						}

						//If allowed type list is not empty, retrieve allowed policy and state
						if(applicableItemTypes!=null && !applicableItemTypes.isEmpty()){
							StringList listApplicableItemCurrents = FrameworkUtil.split(EnoviaResourceBundle.getProperty(context, "emxEnterpriseChange." + "ChangeDisciplineManufacturing" + ".ApplicableItemCurrent"), ",");
							if(listApplicableItemCurrents!=null && !listApplicableItemCurrents.isEmpty()){
								Iterator listApplicableItemCurrentsItr = listApplicableItemCurrents.iterator();
								while(listApplicableItemCurrentsItr.hasNext()){
									String applicableItemCurrent = (String) listApplicableItemCurrentsItr.next();
									if(applicableItemCurrent!=null && !applicableItemCurrent.equalsIgnoreCase("")){
										//String applicableItemCurrent is composed of policy.state --> should be splitted
										StringList listPolicyState = FrameworkUtil.split(applicableItemCurrent, ".");
										if(listPolicyState!=null && listPolicyState.size()==2){
											String applicableItemPolicy = (String)listPolicyState.get(0);
											String applicableItemState = (String)listPolicyState.get(1);

											if(PropertyUtil.getSchemaProperty(context,applicableItemPolicy)!=null && !PropertyUtil.getSchemaProperty(context,applicableItemPolicy).equalsIgnoreCase("")){
												if(PropertyUtil.getSchemaProperty(context,"policy", PropertyUtil.getSchemaProperty(context,applicableItemPolicy), applicableItemState)!=null && !PropertyUtil.getSchemaProperty(context,"policy", PropertyUtil.getSchemaProperty(context,applicableItemPolicy), applicableItemState).equalsIgnoreCase("")){
													//Policy and state exist
													if(applicableItemCurrents.length() > 0){
														applicableItemCurrents += ",";
										    	    }
													applicableItemCurrents += applicableItemCurrent;
												}
											}
										}
									}
								}
							}
						}

						%>
			            <script language="javascript" type="text/javaScript">
			            	<%if(applicableItemTypes!=null && !applicableItemTypes.isEmpty()){%>
				            	var sURL="../common/emxFullSearch.jsp?objectId=<%=XSSUtil.encodeForURL(context,strObjId)%>&field=TYPES=<%=XSSUtil.encodeForURL(context,applicableItemTypes)%>";
				            	<%if(applicableItemCurrents!=null && !applicableItemCurrents.isEmpty()){%>
				            		sURL = sURL + ":CURRENT=<%=XSSUtil.encodeForURL(context,applicableItemCurrents)%>";
				            	<%}%>
				            	sURL = sURL + "&excludeOIDprogram=emxApplicabilityDecision:excludeDecisionManufacturingApplicableItems&table=ECHApplicableItemSearchResult&cancelLabel=Cancel&submitLabel=Done&hideHeader=true&HelpMarker=emxhelpfullsearch&selection=multiple&submitURL=../enterprisechange/ECHConnectApplicableItems.jsp&changeDiscipline=<%=XSSUtil.encodeForURL(context,changeDiscipline)%>";
								showChooser(sURL, 850, 630);
			            	<%}else{
					            String srAlert = (String)(EnoviaResourceBundle.getProperty(context,"EnterpriseChange","emxEnterpriseChange.Alert.NoApplicableItemDefined",strLanguage)).trim();
					            throw new FrameworkException(srAlert);
							}%>
						</script>
						<%
					}
				}catch(Exception e){
					bIsError=true;
					session.putValue("error.message", e.toString());
				}
			}

			else if (strMode.equalsIgnoreCase("addExistingDecisionManufacturingIntents")) {
				try {
					String objectId = emxGetParameter(request, "objectId");
					String[] strTableRowIds = emxGetParameterValues(request, "emxTableRowId");
					String changeDiscipline = EnterpriseChangeConstants.ATTRIBUTE_CHANGE_DISCIPLINE_MANUFACTURING;
					
					//Retrieve allowed types
					StringList listApplicableItemTypes = FrameworkUtil.split(EnoviaResourceBundle.getProperty(context, "emxEnterpriseChange." + "ChangeDisciplineManufacturing" + ".ApplicableItemTypes"), ",");
					
					if (strTableRowIds != null && strTableRowIds.length > 0) {
						if(strTableRowIds.length > 1){
				            String srAlert = (String)(EnoviaResourceBundle.getProperty(context,"EnterpriseChange","emxEnterpriseChange.Alert.SelectOnlyOneItem",strLanguage)).trim();
				            throw new FrameworkException(srAlert);
						} else {
							String strTableRowId = strTableRowIds[0];
							StringList slEmxTableRowId = FrameworkUtil.split(strTableRowId, "|");
							if (slEmxTableRowId.size() > 0)	{
								//Architecture: RelId|Id|ParentId|level
								String strTempRelId = (String)slEmxTableRowId.get(0);
								String strTempObjId = (String)slEmxTableRowId.get(1);
								if(strTempObjId!=null && !strTempObjId.equalsIgnoreCase("")){
									DomainObject domTempObj = new DomainObject(strTempObjId);
									//String strType = (String) domTempObj.getInfo(context, DomainConstants.SELECT_TYPE);
									//Added for IR-088327V6R2012 : ixe : 28.12.2010
									//Retrieve allowed types
									boolean canAdd = false;
									if(listApplicableItemTypes!=null && !listApplicableItemTypes.isEmpty()){
										Iterator listApplicableItemTypesItr = listApplicableItemTypes.iterator();
										
										while(listApplicableItemTypesItr.hasNext()){
											String applicableItemType = (String) listApplicableItemTypesItr.next();
											if(applicableItemType!=null && !applicableItemType.equalsIgnoreCase("")){
												//Check if type exists
												if(PropertyUtil.getSchemaProperty(context,applicableItemType)!=null && !PropertyUtil.getSchemaProperty(context,applicableItemType).equalsIgnoreCase("")){
													//Type exists,
													if(domTempObj.isKindOf(context, PropertyUtil.getSchemaProperty(context,applicableItemType))){
														canAdd = true;
													}
												}
											}
										}
									}
									if (canAdd) {
										%>
										 <script language="javascript" type="text/javaScript">
											showModalDialog("../common/emxFullSearch.jsp?objectId=<%=XSSUtil.encodeForURL(context,strTempObjId)%>&id[connection]=<%=XSSUtil.encodeForURL(context,strTempRelId)%>&field=TYPES=type_Model&excludeOIDprogram=emxApplicabilityDecision:excludeDecisionManufacturingIntents&table=ECHApplicableItemSearchResult&Registered Suite=EnterpriseChange&HelpMarker=emxhelpfullsearch&selection=multiple&showSavedQuery=true&hideHeader=true&submitURL=../enterprisechange/emxApplicabilityDecisionUtil.jsp?mode=connectManufacturingApplicableItemManufacturingIntent",850,630);
										 </script>
										 <%
									} else {
							            String srAlert = (String)(EnoviaResourceBundle.getProperty(context,"EnterpriseChange","emxEnterpriseChange.Alert.CannotAddToThisNode",strLanguage)).trim();
							            throw new FrameworkException(srAlert);
									}
								}
							}
						}
					} else {
			            String srAlert = (String)(EnoviaResourceBundle.getProperty(context,"EnterpriseChange","emxEnterpriseChange.Pdcm.PleaseSelectAnItem",strLanguage)).trim();
			            throw new FrameworkException(srAlert);
					}
				}catch(Exception e){
					bIsError=true;
					session.putValue("error.message", e.toString());
				}
				
			}
			
			else if (strMode.equalsIgnoreCase("removeDecisionManufacturingIntents")) {
				try {
					String strObjIdContext = emxGetParameter(request, "objectId");
					String[] strTableRowIds = emxGetParameterValues(request, "emxTableRowId");
					
					//Retrieve allowed types
					StringList listApplicableItemTypes = FrameworkUtil.split(EnoviaResourceBundle.getProperty(context, "emxEnterpriseChange." + "ChangeDisciplineManufacturing" + ".ApplicableItemTypes"), ",");

					if(strTableRowIds != null && strTableRowIds.length > 0){
						Map objectMap = UIUtil.parseRelAndObjectIds(context, strTableRowIds, false);
						String[] objectIds = (String[])objectMap.get("objectIds");
						String[] relIds = (String[])objectMap.get("relIds");

						StringList cannotBeRemoved = new StringList();

						for (int i=0;i<objectIds.length;i++) {
							String strTempObj = objectIds[i];
							if (strTempObj!=null && !strTempObj.isEmpty()) {
								StringList slEmxTableRowId = FrameworkUtil.split(strTempObj, "|");
								if (slEmxTableRowId.size() > 0)	{
									//Architecture: RelId|Id|ParentId|level
									String strTempObjId = (String)slEmxTableRowId.get(0);
									DomainObject domTempObj = new DomainObject(strTempObjId);
									if(listApplicableItemTypes!=null && !listApplicableItemTypes.isEmpty()){
										Iterator listApplicableItemTypesItr = listApplicableItemTypes.iterator();
										
										while(listApplicableItemTypesItr.hasNext()){
											String applicableItemType = (String) listApplicableItemTypesItr.next();
											if(applicableItemType!=null && !applicableItemType.equalsIgnoreCase("")){
												//Check if type exists
												if(PropertyUtil.getSchemaProperty(context,applicableItemType)!=null && !PropertyUtil.getSchemaProperty(context,applicableItemType).equalsIgnoreCase("")){
													//Type exists,
													if(domTempObj.isKindOf(context, PropertyUtil.getSchemaProperty(context,applicableItemType))){
														if (!cannotBeRemoved.contains(strTempObjId)) {
															cannotBeRemoved.addElement(strTempObjId);
														}
													}
												}
											}
										}//End of while
									}
								}
							}
						}
						if (cannotBeRemoved!=null && !cannotBeRemoved.isEmpty()) {
				            String sllanguage=context.getSession().getLanguage();
				            StringBuffer warningMessage = new StringBuffer();
				            warningMessage.append((String)(EnoviaResourceBundle.getProperty(context,"EnterpriseChange","emxEnterpriseChange.Alert.ManufacturingIntent.CannotRemove",strLanguage)).trim());
				            Iterator<String> cannotBeRemovedItr = cannotBeRemoved.iterator();
				            while (cannotBeRemovedItr.hasNext()) {
				            	String cannotBeRemovedId = cannotBeRemovedItr.next();
				            	if (cannotBeRemovedId!=null && !cannotBeRemovedId.isEmpty()) {
				            		DomainObject cannotBeRemovedDom = new DomainObject(cannotBeRemovedId);
				            		warningMessage.append(cannotBeRemovedDom.getInfo(context, DomainConstants.SELECT_NAME) + " " + cannotBeRemovedDom.getInfo(context, DomainConstants.SELECT_REVISION));
				            		if (cannotBeRemovedItr.hasNext()) {
				            			warningMessage.append("\\n");
				            		}
				            	}
				            }
				            throw new FrameworkException(warningMessage.toString());
						} else {
							DomainRelationship.disconnect(context, relIds, false);
							%>
							<script language="javascript">
								parent.location.href = parent.location.href;
							</script>
							<%
						}

					}
				} catch(Exception e) {
					bIsError=true;
					session.putValue("error.message", e.toString());
				}
			}
			
			else if(strMode.equalsIgnoreCase("connectManufacturingApplicableItemManufacturingIntent")){
				try{
		    		HashMap programMap = new HashMap();
					programMap.put("objectId", strObjId);

					programMap.put("id[connection]", emxGetParameter(request, "id[connection]"));
					programMap.put("emxTableRowId", emxGetParameterValues(request, "emxTableRowId"));
					String[] methodargs =JPO.packArgs(programMap);

					String errorMessage = (String) JPO.invoke(context, "emxApplicabilityDecision", null, "connectManufacturingApplicableItemManufacturingIntent", methodargs, String.class);

		            if(!"".equals(errorMessage)){
			        	session.putValue("error.message",errorMessage);
		            }
					%>
		            <script language="javascript" type="text/javaScript">
					window.parent.getTopWindow().getWindowOpener().parent.location.href = window.parent.getTopWindow().getWindowOpener().parent.location.href;
					window.getTopWindow().close();
					//getTopWindow().location.href = "../common/emxCloseWindow.jsp";
					</script>
					<%

				}catch(Exception e){
					bIsError=true;
					session.putValue("error.message", e.toString());
				}
			}

			else if(strMode.equalsIgnoreCase("updateManufacturingApplicabilityImplementedAt")){
				try{
					String checkedValue = "";
					String checkedDisplayValue = "";

					String formName = emxGetParameter(request,"formName");
					if (formName == null || formName.length() == 0){
				        formName = "0";
				    }else{
				        formName = "\"" + XSSUtil.encodeForJavaScript(context,formName) + "\"";
				    }

					String fieldNameActual = emxGetParameter(request,"fieldNameActual");
					String fieldNameDisplay = emxGetParameter(request,"fieldNameDisplay");

					String emxTableRowIds[] = (String[])emxGetParameterValues(request, "emxTableRowId");
					//strTableRowId = Applicable Item
					String strTableRowId = "";
					StringList slEmxTableRowId = new StringList();
					for(int i = 0; i < emxTableRowIds.length; i++){
						strTableRowId = emxTableRowIds[i];
						slEmxTableRowId = FrameworkUtil.split(strTableRowId, "|");
						if(slEmxTableRowId.size() > 0){
							strTableRowId = (String)slEmxTableRowId.get(0);
							checkedValue = strTableRowId;
							DomainObject domObj = new DomainObject(strTableRowId);
							checkedDisplayValue = domObj.getInfo(context, DomainConstants.SELECT_NAME) + " " + domObj.getInfo(context, DomainConstants.SELECT_REVISION);
						}
					}
					%>
				    <script language="JavaScript">
				    var fieldNameActual ="<%= XSSUtil.encodeForJavaScript(context,fieldNameActual)%>";
			        var fieldNameDisplay = "<%=XSSUtil.encodeForJavaScript(context,fieldNameDisplay)%>";
				    var objForm = emxUICore.getNamedForm(window.parent.getTopWindow().getWindowOpener(),<%=formName%>);
				    var checkedValue = "<%=XSSUtil.encodeForJavaScript(context,checkedValue)%>";
				    var checkedDisplayValue = "<%=XSSUtil.encodeForJavaScript(context,checkedDisplayValue)%>";

				    if(fieldNameActual != null && fieldNameActual != "" && fieldNameActual != "undefined" && fieldNameActual != "null"){
				    	eval("objForm.elements[\"<%=XSSUtil.encodeForJavaScript(context,fieldNameActual)%>\"].value = \""+ checkedValue +"\";");
				    }
			        if(fieldNameDisplay != null && fieldNameDisplay != "" &&fieldNameDisplay != "undefined" && fieldNameDisplay != "null"){
			        	eval("objForm.elements[\"<%=XSSUtil.encodeForJavaScript(context,fieldNameDisplay)%>\"].value = \""+ checkedDisplayValue +"\";");
			        }

				    window.getTopWindow().close();
				    //getTopWindow().location.href = "../common/emxCloseWindow.jsp";
					</script>
					<%

				}catch (Exception e){
		             session.putValue("error.message", e.getMessage());
		             throw e;
		        }
			}

			else if(strMode.equalsIgnoreCase("connectDecisionAppliesTo")){
				try{
					String[] strRowId = emxGetParameterValues(request, "emxTableRowId");
					boolean preserve = false;
					for (int i = 0; i < strRowId.length; i++){
						String selObjId = strRowId[i].split("[|]")[1];
						DomainRelationship.connect(context, strObjId, EnterpriseChangeConstants.RELATIONSHIP_DECISION_APPLIES_TO, selObjId, preserve);
					}
					%>
					<script language="javascript" type="text/javaScript">
						window.parent.getTopWindow().getWindowOpener().parent.parent.location.href = window.parent.getTopWindow().getWindowOpener().parent.parent.location.href;
						window.getTopWindow().close();
						getTopWindow().location.href = "../common/emxCloseWindow.jsp";
					</script>
					<%
				}catch (Exception e){
			        session.putValue("error.message", e.getMessage());
			        throw e;
			   }
			}

			else if (strMode.equalsIgnoreCase("removeDecisionAppliesTo")){
				try{
					String[] oids = emxGetParameterValues(request, "emxTableRowId");
					Map objectMap = UIUtil.parseRelAndObjectIds(context, oids, false);
					oids = (String[])objectMap.get("objectIds");
					String[] relIds = (String[])objectMap.get("relIds");

					//First remove Decision Applies To objects
					DomainRelationship.disconnect(context, relIds, false);

					//Then call method to remove Decision Applicable Items which are not used if needed
					HashMap programMap = new HashMap();
					programMap.put("objectId", strObjId);
					String[] methodargs =JPO.packArgs(programMap);
					JPO.invoke(context, "emxApplicabilityDecision", null, "removeDecisionAppliesTo", methodargs);

					%>
					<script language="javascript">
						parent.location.href = parent.location.href;
					</script>
					<%
				}catch(Exception e){
					bIsError=true;
					session.putValue("error.message", e.toString());
				}
			}

			else if (strMode.equalsIgnoreCase("remove")){
				try{
					HashMap programMap = new HashMap();
					String[] oids = emxGetParameterValues(request, "emxTableRowId");
					Map objectMap = UIUtil.parseRelAndObjectIds(context, oids, false);
					oids = (String[])objectMap.get("objectIds");
					int m=0;
					boolean isRemove = true;
					for(int n=0; n<oids.length;n++){
					 StringTokenizer st = new StringTokenizer(oids[n],",");
					 if(n==0){
					 m = st.countTokens();
					 }
				      if(m != st.countTokens()){
				    	  isRemove = false;
				            String sllanguage=context.getSession().getLanguage();
				            String srAlert = (String)(EnoviaResourceBundle.getProperty(context,"EnterpriseChange","emxEnterpriseChange.Alert.SelectObjectsAtSameLevel",sllanguage)).trim();
				            throw new FrameworkException(srAlert);
				      }
					}
				if(isRemove){
					String[] relIds = (String[])objectMap.get("relIds");
					String action = emxGetParameter(request, "action");
					DomainRelationship.disconnect(context, relIds, false);
				 
					
					%>
					<script language="javascript">
						parent.location.href = parent.location.href;
					</script>
					<%
				} 
				}catch(Exception e){
					bIsError=true;
					session.putValue("error.message", e.toString());
				}
			}

		}catch(Exception e){
		    bIsError=true;
		    session.putValue("error.message", e.toString());
		}

		%>

		<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
	</body>
</html>
