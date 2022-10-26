<%@include file = "../common/emxNavigatorInclude.inc"%>


<%@page import="com.matrixone.apps.domain.util.EnoviaResourceBundle"%>
<%@page import="com.matrixone.apps.domain.util.i18nNow"%>
<html>
	<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
	
	<head>
		<title></title>
		
		<%@include file = "../common/emxUIConstantsInclude.inc"%>
		
		<%@page import="java.util.HashMap"%>
		<%@page import="java.util.Iterator"%>
		<%@page import="java.util.Map"%>
		<%@page import="java.util.Set"%>
		
		<%@page import="com.matrixone.apps.domain.DomainConstants"%>
		<%@page import="com.matrixone.apps.domain.DomainObject"%>
		<%@page import="com.matrixone.apps.domain.util.mxType"%>
		<%@page import="com.matrixone.apps.enterprisechange.EnterpriseChangeConstants"%>
		<%@page import="com.matrixone.apps.enterprisechange.EnterpriseChangeUtil"%>
		<%@page import="com.matrixone.json.JSONObject"%>
		
	</head>
	
	
	<body>
		<%
		try {
                        PropertyUtil.setGlobalRPEValue(context, "ENO_ECH", "true");
			String applicabilityContextId = emxGetParameter(request, "objectId");
			String changeDiscipline = emxGetParameter(request, "changeDiscipline");
			String effectivityTypes = emxGetParameter(request, "effectivityTypes");
			String languageStr = emxGetParameter(request, "languageStr");
            String DecObjectId = emxGetParameter(request, "parentOID");
			String checkedValue = "";
			String checkedDisplayValue = "";
			
            StringList sels = new StringList(8);
            sels.add(DomainObject.SELECT_ID);
            sels.add(DomainObject.SELECT_TYPE);
            sels.add(DomainObject.SELECT_NAME);
            sels.add(DomainObject.SELECT_REVISION);
            sels.add(DomainObject.SELECT_CURRENT);
            sels.add(DomainObject.SELECT_POLICY);
            sels.add("revindex");
            sels.add("attribute[" + EnterpriseChangeConstants.ATTRIBUTE_BUILD_UNIT_NUMBER + "]");            
			String errorMessage = "";
			MapList notCompliantObjects = new MapList();
			
			String formName = emxGetParameter(request,"formName");
			if (formName == null || formName.length() == 0){
		        formName = "0";
		    }else{
		        formName = "\"" + formName + "\"";
		    }

			String fieldNameActual = emxGetParameter(request,"fieldNameActual");
			String fieldNameDisplay = emxGetParameter(request,"fieldNameDisplay");
                    String contextModelId = emxGetParameter(request, "contextModelId");
            String xmlApplicabilityExpression = "";
			String appObjs = emxGetParameter(request, "applicabilityObjs");
			if (appObjs != null) {
				Map<String,StringList> allowedPolicyStates = new HashMap<String,StringList>();
				String applicableItemCurrents = EnoviaResourceBundle.getProperty(context, "emxEnterpriseChange." + changeDiscipline.replace(" ", "") + ".ApplicableItemCurrent");
				StringList applicableItemCurrentsList = FrameworkUtil.split(applicableItemCurrents, ",");
				Iterator<String> applicableItemCurrentsListItr = applicableItemCurrentsList.iterator();
				while (applicableItemCurrentsListItr.hasNext()) {
					String applicableItemCurrent = applicableItemCurrentsListItr.next();
					if (applicableItemCurrent!=null && !applicableItemCurrent.isEmpty()) {
						StringList listPolicyState = FrameworkUtil.split(applicableItemCurrent, ".");
						if(listPolicyState!=null && listPolicyState.size()==2){
							String applicableItemPolicy = (String)listPolicyState.get(0);
							String applicableItemState = (String)listPolicyState.get(1);
							if(PropertyUtil.getSchemaProperty(context,applicableItemPolicy)!=null && !PropertyUtil.getSchemaProperty(context,applicableItemPolicy).equalsIgnoreCase("")){
								if(PropertyUtil.getSchemaProperty(context,"policy", PropertyUtil.getSchemaProperty(context,applicableItemPolicy), applicableItemState)!=null && !PropertyUtil.getSchemaProperty(context,"policy", PropertyUtil.getSchemaProperty(context,applicableItemPolicy), applicableItemState).equalsIgnoreCase("")){
									//Policy and state exist
									StringList allowedStates = new StringList();
									if (allowedPolicyStates.containsKey(applicableItemPolicy)) {
										allowedStates = allowedPolicyStates.get(applicableItemPolicy);
									}
									allowedStates.addElement(applicableItemState);
									allowedPolicyStates.put(applicableItemPolicy, allowedStates);
								}
							}
						}
					}
				}//End of while applicableItemCurrentsListItr
				
				
				if (allowedPolicyStates!=null && !allowedPolicyStates.isEmpty()) {
					Map<String,MapList> applicableItemsSortedByTypes = new HashMap<String,MapList>();
					//1. Parse the input from the browser in order to get a json object
					JSONObject appObjsJSON = new JSONObject(appObjs);
					Iterator<String> appObjsJSONKeysItr = appObjsJSON.keys();
					while (appObjsJSONKeysItr.hasNext()) {
						String appObjsJSONKey = appObjsJSONKeysItr.next();
						JSONObject appObjJSON = new JSONObject(appObjsJSON.getString(appObjsJSONKey));
						if (appObjJSON!=null) {
							String appObjJSONId = appObjJSON.getString("objId");
							
							String appObjParentId = "";
							
							if(appObjJSON.contains("contextId")){							
							appObjParentId = appObjJSON.getString("contextId");
							}
							
							if(null ==appObjParentId || "".equals(appObjParentId) || "null".equals(appObjParentId) ){
								appObjParentId = appObjJSON.getString("parentId");
							}
							
							
							String appObjJSONUpwardCompatible = appObjJSON.getString("upwardCompatible");
							if ((appObjJSONId!=null && !appObjJSONId.isEmpty()) && (appObjJSONUpwardCompatible!=null && !appObjJSONUpwardCompatible.isEmpty())) {
                                            DomainObject applicableItemDom = DomainObject.newInstance(context, appObjJSONId);
                                            //get item's info all at once
                                            Map itemMap = applicableItemDom.getInfo(context, sels);
								String type = "";
								Map<String,String> tempMap = new HashMap<String,String>();
								tempMap.put("parentId",appObjParentId);
								String sortBy = "";
								if (applicableItemDom.isKindOf(context, EnterpriseChangeConstants.TYPE_PRODUCTS)) {
									type = EnterpriseChangeConstants.TYPE_PRODUCTS;
									tempMap.put(DomainConstants.SELECT_TYPE, type);
                                                        tempMap.put(DomainConstants.SELECT_REVISION, (String)itemMap.get(DomainConstants.SELECT_REVISION));
									sortBy = "revindex";
								} else if (applicableItemDom.isKindOf(context, EnterpriseChangeConstants.TYPE_MANUFACTURING_PLAN)) {
									type = EnterpriseChangeConstants.TYPE_MANUFACTURING_PLAN;
									tempMap.put(DomainConstants.SELECT_TYPE, type);
                                                        tempMap.put(DomainConstants.SELECT_REVISION, (String)itemMap.get(DomainConstants.SELECT_REVISION));
									sortBy = "revindex";
								} else if (applicableItemDom.isKindOf(context, EnterpriseChangeConstants.TYPE_BUILDS)) {
									type = EnterpriseChangeConstants.TYPE_BUILDS;
									tempMap.put(DomainConstants.SELECT_TYPE, type);
                                                        tempMap.put(DomainConstants.SELECT_REVISION, (String)itemMap.get(DomainConstants.SELECT_REVISION));
                                                        tempMap.put("attribute[" + EnterpriseChangeConstants.ATTRIBUTE_BUILD_UNIT_NUMBER + "]", (String)itemMap.get("attribute[" + EnterpriseChangeConstants.ATTRIBUTE_BUILD_UNIT_NUMBER + "]"));
									sortBy = "attribute[" + EnterpriseChangeConstants.ATTRIBUTE_BUILD_UNIT_NUMBER + "]";
								}
								
								if (Boolean.parseBoolean(appObjJSONUpwardCompatible)) {
									tempMap.put("attribute[" + EnterpriseChangeConstants.ATTRIBUTE_UPWARD_COMPATIBILITY + "]", EnterpriseChangeConstants.RANGE_YES);
								} else {
									tempMap.put("attribute[" + EnterpriseChangeConstants.ATTRIBUTE_UPWARD_COMPATIBILITY + "]", EnterpriseChangeConstants.RANGE_NO);
								}
								
								if (type!=null && !type.isEmpty()) {
                                                    tempMap.put(DomainConstants.SELECT_ID, (String)itemMap.get(DomainConstants.SELECT_ID));
                                                    tempMap.put(DomainConstants.SELECT_NAME, (String)itemMap.get(DomainConstants.SELECT_NAME));
                                                    tempMap.put(DomainConstants.SELECT_POLICY, (String)itemMap.get(DomainConstants.SELECT_POLICY));
                                                    tempMap.put(DomainConstants.SELECT_CURRENT, (String)itemMap.get(DomainConstants.SELECT_CURRENT));
                                                    tempMap.put("revindex", (String)itemMap.get("revindex"));
									//Check if Map with the type already exists
									MapList applicableItems = new MapList();
									if (applicableItemsSortedByTypes.containsKey(type)) {
										applicableItems = (MapList) applicableItemsSortedByTypes.get(type);
									}
									applicableItems.add(tempMap);
									if (sortBy!=null && !sortBy.isEmpty()) {
										applicableItems.sort(sortBy, "ascending", "integer");
									}
									applicableItemsSortedByTypes.put(type,applicableItems);
								}
							}
						}
					}//End of while appObjsJSONKeysItr
					if (applicableItemsSortedByTypes!=null && !applicableItemsSortedByTypes.isEmpty()) {
						Map<String,Map<String,MapList>> applicableItemsSortedByDisciplinesAndTypes = new HashMap<String,Map<String,MapList>>();
						applicableItemsSortedByDisciplinesAndTypes.put(changeDiscipline, applicableItemsSortedByTypes);
						
						Map<String,Map<String,Map<String,MapList>>> applicableItemsSortedByMastersAndDisciplinesAndTypes = new HashMap<String,Map<String,Map<String,MapList>>>();
						applicableItemsSortedByMastersAndDisciplinesAndTypes.put(applicabilityContextId, applicableItemsSortedByDisciplinesAndTypes);
                        xmlApplicabilityExpression = EnterpriseChangeUtil.generateDerivationsXMLApplicabilityExpression(context, applicableItemsSortedByMastersAndDisciplinesAndTypes);
						if (xmlApplicabilityExpression!=null && !xmlApplicabilityExpression.isEmpty()) {
							StringBuffer strBuffer = new StringBuffer();
							//Get all Type keys
							Set<String> typeKeys = applicableItemsSortedByTypes.keySet();
							Iterator<String> typeKeysItr = typeKeys.iterator();
							while (typeKeysItr.hasNext()) {
								String typeKey = typeKeysItr.next();
								if (typeKey!=null && !typeKey.isEmpty()) {
									//strBuffer.append(i18nNow.getTypeI18NString(typeKey,languageStr));
									//strBuffer.append(": ");
									MapList applicableItems = applicableItemsSortedByTypes.get(typeKey);
									if (applicableItems!=null && !applicableItems.isEmpty()) {
										MapList appItemsList = new MapList();
										Iterator<Map<String,String>> applicableItemsItr = applicableItems.iterator();
										while (applicableItemsItr.hasNext()) {
											Map<String,String> applicableItem = applicableItemsItr.next();
											if (applicableItem!=null && !applicableItem.isEmpty()) {
												boolean notCompliant = false;
												String applicableItemParentId = applicableItem.get("parentId");
												String applicableItemId = applicableItem.get(DomainConstants.SELECT_ID);
												String applicableItemType = applicableItem.get(DomainConstants.SELECT_TYPE);
                                                                        String applicableItemName = applicableItem.get(DomainConstants.SELECT_NAME);
												String applicableItemRevision = applicableItem.get(DomainConstants.SELECT_REVISION);
												String applicableItemBuildUnitNumber = applicableItem.get("attribute[" + EnterpriseChangeConstants.ATTRIBUTE_BUILD_UNIT_NUMBER + "]");
												String applicableItemUpwardCompatibility = applicableItem.get("attribute[" + EnterpriseChangeConstants.ATTRIBUTE_UPWARD_COMPATIBILITY + "]");
												String applicableItemPolicySymbolic = FrameworkUtil.getAliasForAdmin(context, "policy", applicableItem.get(DomainConstants.SELECT_POLICY), true);
												String applicableItemCurrentSymbolic = FrameworkUtil.reverseLookupStateName(context, applicableItem.get(DomainConstants.SELECT_POLICY), applicableItem.get(DomainConstants.SELECT_CURRENT));
												//Check if Policy and State are allowed
												if ((applicableItemPolicySymbolic!=null && !applicableItemPolicySymbolic.isEmpty()) && (applicableItemCurrentSymbolic!=null && !applicableItemCurrentSymbolic.isEmpty())) {
													if (allowedPolicyStates.containsKey(applicableItemPolicySymbolic)) {
														StringList allowedStates = allowedPolicyStates.get(applicableItemPolicySymbolic);
														if (!(allowedStates!=null && allowedStates.contains(applicableItemCurrentSymbolic))) {
															notCompliant = true;
														}
													} else {
														notCompliant = true;
													}
												} else {
													notCompliant = true;
												}
												
												if (notCompliant) {
													Map notCompliantObject = new HashMap();
													notCompliantObject.put(DomainConstants.SELECT_TYPE, applicableItemType);
													notCompliantObject.put(DomainConstants.SELECT_NAME, new DomainObject(applicableItemId).getInfo(context, DomainConstants.SELECT_NAME));
													if (applicableItemType!=null && (mxType.isOfParentType(context, applicableItemType, EnterpriseChangeConstants.TYPE_PRODUCTS) || mxType.isOfParentType(context, applicableItemType, EnterpriseChangeConstants.TYPE_MANUFACTURING_PLAN))) {
														notCompliantObject.put(DomainConstants.SELECT_REVISION, applicableItemRevision);
													} else if(applicableItemType!=null && mxType.isOfParentType(context, applicableItemType, EnterpriseChangeConstants.TYPE_BUILDS)) {
														notCompliantObject.put(DomainConstants.SELECT_REVISION, applicableItemBuildUnitNumber);
													}
													notCompliantObjects.add(notCompliantObject);
												}
												
												
												
												Map appItem = new HashMap();
                                                                        appItem.put(DomainObject.SELECT_ID, applicableItemId);
                                                                        appItem.put(DomainObject.SELECT_TYPE, applicableItemType);
                                                                        appItem.put(DomainObject.SELECT_NAME, applicableItemName);
												if (applicableItemType!=null && (mxType.isOfParentType(context, applicableItemType, EnterpriseChangeConstants.TYPE_PRODUCTS) || mxType.isOfParentType(context, applicableItemType, EnterpriseChangeConstants.TYPE_MANUFACTURING_PLAN))) {
                                                                                appItem.put(DomainObject.SELECT_REVISION, applicableItemRevision);
												} else if(applicableItemType!=null && mxType.isOfParentType(context, applicableItemType, EnterpriseChangeConstants.TYPE_BUILDS)) {
                                                                                appItem.put(DomainObject.SELECT_REVISION, applicableItemBuildUnitNumber);
												}
												if (applicableItemUpwardCompatibility.equalsIgnoreCase(EnterpriseChangeConstants.RANGE_YES)) {
													appItem.put("upwardCompatible", "true");
												} else if (applicableItemUpwardCompatibility.equalsIgnoreCase(EnterpriseChangeConstants.RANGE_NO)) {
													appItem.put("upwardCompatible", "false");
												}
												appItem.put("parentId", applicableItemParentId);
												appItemsList.add(appItem);
											}
										}//End of while applicableItemsItr
										if (appItemsList!=null && !appItemsList.isEmpty()) {
											String strEffectivityType = "";
											if (effectivityTypes!=null && !effectivityTypes.isEmpty()) {
												StringList effectivityCommandsList = FrameworkUtil.split(effectivityTypes, ",");
												Iterator<String> effectivityCommandsListItr = effectivityCommandsList.iterator();
												while (effectivityCommandsListItr.hasNext()) {
													String effectivityCommand = effectivityCommandsListItr.next();
													if (effectivityCommand!=null && !effectivityCommand.isEmpty()) {
														if (effectivityCommand.contains(typeKey.replace(" ", ""))) {
															strEffectivityType = effectivityCommand.substring("CFFEffectivity".length());
														}
													}	
												}//End of while
											}
											
											if (strEffectivityType!=null && !strEffectivityType.isEmpty()) {
                                                /* uses .xsl to format display expression*/
                                                if (EnterpriseChangeUtil.isCFFInstalled(context)) {
												HashMap requestMap = new HashMap();
                                                    requestMap.put("applicableItemsList", appItemsList);
                                                    if(contextModelId != null && contextModelId.length() > 0){
                                                        requestMap.put("contextModelId", applicabilityContextId);   
														}
                                                    String displayExpression = (String) JPO.invoke(context, "emxEffectivityFramework", null, "getDisplayExpression", JPO.packArgs(requestMap), String.class);
                                                    displayExpression = displayExpression.replace("<", "\u003C");                                                                           
                                                    strBuffer.append(displayExpression);
												}
											}
										}
									}
								}
							}//End of while typeKeysItr
                            checkedValue = xmlApplicabilityExpression;
                            checkedValue = checkedValue.replaceAll("<", "&lt;");
                            checkedValue = checkedValue.replaceAll(">", "&gt;");
                            checkedValue = checkedValue.replaceAll("\"", "&quot;");
                            checkedValue = checkedValue.replaceAll(" ", "&nbsp;");
                            checkedValue = FrameworkUtil.encodeURL(checkedValue,"UTF-8");
							checkedDisplayValue = strBuffer.toString();
						}
						if (notCompliantObjects!=null && !notCompliantObjects.isEmpty()) {
							StringBuffer strBuffer = new StringBuffer();
							//create the errorMessage
							strBuffer.append((String)(EnoviaResourceBundle.getProperty(context,"EnterpriseChange","emxEnterpriseChange.Alert.DecisionApplicability.NotCompliant",languageStr)).trim());
							Iterator<Map<String,String>> notCompliantObjectsItr = notCompliantObjects.iterator();
		                    while(notCompliantObjectsItr.hasNext()){
		                    	Map<String,String> notCompliantObject = notCompliantObjectsItr.next();
		                    	if(notCompliantObject!=null && !notCompliantObject.isEmpty()){
		                    		String notCompliantObjectType = notCompliantObject.get(DomainConstants.SELECT_TYPE);
		                    		String notCompliantObjectName = notCompliantObject.get(DomainConstants.SELECT_NAME);
		                    		String notCompliantObjectRevision = notCompliantObject.get(DomainConstants.SELECT_REVISION);
		                    		if((notCompliantObjectType!=null && !notCompliantObjectType.isEmpty()) && (notCompliantObjectName!=null && !notCompliantObjectName.isEmpty()) && (notCompliantObjectRevision!=null && !notCompliantObjectRevision.isEmpty())){
		                    			String notCompliantObjectTypeNLS = i18nNow.getTypeI18NString(notCompliantObjectType, languageStr);

		                    			if(strBuffer!=null && !strBuffer.toString().isEmpty()){
		                    				strBuffer.append("\n");
		                    			}

		                    			if(notCompliantObjectTypeNLS!=null && !notCompliantObjectTypeNLS.isEmpty()){
		                    				strBuffer.append(notCompliantObjectTypeNLS);
		                    			}else{
		                    				strBuffer.append(notCompliantObjectType);
		                    			}
		                    			strBuffer.append(" ");
		                    			strBuffer.append(notCompliantObjectName);
		                    			strBuffer.append(" ");
		                    			strBuffer.append(notCompliantObjectRevision);
		                    		}
		                    	}
		                    }//End of while notCompliantObjectsItr
		                    errorMessage = strBuffer.toString();
						}
					}
				} else {
					errorMessage =  (String)(EnoviaResourceBundle.getProperty(context,"EnterpriseChange","emxEnterpriseChange.Alert.ApplicableItemCurrent.NotDefined",languageStr)).trim();
				}
			}
            HashMap requestMap = new HashMap();
            requestMap.put("parentOID",DecObjectId);
            HashMap paramMap = new HashMap();
            paramMap.put("objectId", applicabilityContextId);
            paramMap.put("New Value", xmlApplicabilityExpression);
            HashMap columnMap = new HashMap();
            columnMap.put("name", changeDiscipline);
            HashMap programMap = new HashMap();
            programMap.put("requestMap",requestMap);
            programMap.put("paramMap",paramMap);
            programMap.put("columnMap",columnMap);
            
			if (errorMessage!=null && !errorMessage.isEmpty()) {
				%>
				<script language="javascript" type="text/javaScript">
				alert("<%=XSSUtil.encodeForJavaScript(context,errorMessage)%>");
				</script>
				<%
			} else {
				JPO.invoke(context, "emxApplicabilityDecision", null, "updateDecisionApplicabilityDisciplineSummary", JPO.packArgs(programMap),Object.class );
				%>
					<script language="JavaScript">
					
					var fieldNameActual = "<%=XSSUtil.encodeForJavaScript(context,fieldNameActual)%>";
					var fieldNameDisplay = "<%=XSSUtil.encodeForJavaScript(context,fieldNameDisplay)%>";
					var objForm = emxUICore.getNamedForm(window.parent.getTopWindow().getWindowOpener(),<%=XSSUtil.encodeForJavaScript(context,formName)%>);
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
			}
			
			%>
			<script language="javascript" type="text/javaScript">
				window.getTopWindow().close();
			    //getTopWindow().location.href = "../common/emxCloseWindow.jsp";
			</script>
			<%
		} catch (Exception e) {
			session.putValue("error.message", e.toString());
		}
		%>
	
	
	</body>
	
	<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>
	
</html>


