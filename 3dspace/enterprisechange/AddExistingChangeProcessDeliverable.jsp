<%-- emxAddExistingChangeProcessDeliverable.jsp

    Copyright (c) 1992-2018 Enovia Dassault Systemes.All Rights Reserved.
    This program contains proprietary and trade secret information of MatrixOne,Inc.
    Copyright notice is precautionary only and does not evidence any actual
    or intended publication of such program

    static const char RCSID[] =$Id: /web/enterprisechange/AddExistingChangeProcessDeliverable.jsp 1.1 Fri Dec 19 16:45:25 2008 GMT ds-panem Experimental$
--%>


<%@page import="com.matrixone.apps.domain.util.PropertyUtil"%><html>
	<head>
		<title>
		</title>
		<%@include file = "../common/emxNavigatorInclude.inc"%>
		<%@page import="com.matrixone.apps.domain.util.EnoviaResourceBundle"%>
		<%@page import="com.matrixone.apps.enterprisechange.EnterpriseChangeConstants"%>
		<%@page import="com.matrixone.apps.domain.util.XSSUtil"%>
		<script language="javascript" src="../common/scripts/emxUICore.js"></script>
	</head>

	<body>
		<%
		String objectid = emxGetParameter(request, "objectId");
		String delType = emxGetParameter(request, "delType");
		String strTaskId = XSSUtil.encodeForURL(context, objectid);

	    //get default types and current settings
	    //Added for IR-046491V6R2011
	    String changeDelChoice = com.matrixone.apps.domain.util.FrameworkProperties.getProperty("emxEnterpriseChange.Allow.MultipleChangeDeliverable");
	    //End IR-046491V6R2011
		String defaultTypes = com.matrixone.apps.domain.util.FrameworkProperties.getProperty("emxEnterpriseChange.Pdcm.DeliverableTypes");
		String defaultCurrent = "policy_ECR.state_Create,policy_ECR.state_Submit,policy_ECR.state_Evaluate,policy_ECR.state_Review,policy_ECO.state_Create,policy_ECO.state_DefineComponents,policy_ECO.state_DesignWork,policy_EngineeringChangeStandard.state_Submit,policy_EngineeringChangeStandard.state_Evaluate";

		//Added for IR-046491
		String selection="";
	    //End IR-046491
		String deliverableTypes = "";
		String deliverableCurrents = "";
	    //need to use dynamic interop design to get Types and Current values
	    HashMap cmdMap = null;
	    if("Change".equals(delType)){
	    	//cmdMap = UICache.getCommand(context, PropertyUtil.getSchemaProperty(context,"command_ECHInterOpDeliverableSearch"));

	        //Added for Change Discipline
	        DomainObject domTask = new DomainObject(strTaskId);

	        String strInterfaceName = EnterpriseChangeConstants.INTERFACE_CHANGE_DISCIPLINE;
			BusinessInterface busInterface = new BusinessInterface(strInterfaceName, context.getVault());
			AttributeTypeList listInterfaceAttributes = busInterface.getAttributeTypes(context);
			java.util.Iterator listInterfaceAttributesItr = listInterfaceAttributes.iterator();

			while(listInterfaceAttributesItr.hasNext()){
				String attrName = ((AttributeType) listInterfaceAttributesItr.next()).getName();
				String attrNameSmall = attrName.replaceAll(" ", "");
				String attrValue = domTask.getAttributeValue(context, attrName);
				if(attrValue.equalsIgnoreCase(EnterpriseChangeConstants.CHANGE_DISCIPLINE_TRUE)){
					//Retrieve allowed types
					StringList listDeliverableTypes = FrameworkUtil.split(com.matrixone.apps.domain.util.FrameworkProperties.getProperty(context, "emxEnterpriseChange." + attrNameSmall + ".DeliverableTypes"), ",");
					if(listDeliverableTypes!=null && !listDeliverableTypes.isEmpty()){
						Iterator listDeliverableTypesItr = listDeliverableTypes.iterator();
						while(listDeliverableTypesItr.hasNext()){
							String deliverableType = (String) listDeliverableTypesItr.next();
							if(deliverableType!=null && !deliverableType.equalsIgnoreCase("")){
								//Check if type exists
								if(PropertyUtil.getSchemaProperty(context,deliverableType)!=null && !PropertyUtil.getSchemaProperty(context,deliverableType).equalsIgnoreCase("")){
									//Type exists, add it to the search type list
									if(deliverableTypes.length() > 0){
										deliverableTypes += ",";
						    	    }
									deliverableTypes += deliverableType;
								}
							}
						}
					}

					//If allowed type list is not empty, retrieve allowed policy and state
					if(deliverableTypes!=null && !deliverableTypes.isEmpty()){
						StringList listDeliverableCurrents = FrameworkUtil.split(com.matrixone.apps.domain.util.FrameworkProperties.getProperty(context, "emxEnterpriseChange." + attrNameSmall + ".DeliverableCurrent"), ",");
						if(listDeliverableCurrents!=null && !listDeliverableCurrents.isEmpty()){
							Iterator listDeliverableCurrentsItr = listDeliverableCurrents.iterator();
							while(listDeliverableCurrentsItr.hasNext()){
								String deliverableCurrent = (String) listDeliverableCurrentsItr.next();
								if(deliverableCurrent!=null && !deliverableCurrent.equalsIgnoreCase("")){
									//String applicableItemCurrent is composed of policy.state --> should be splitted
									StringList listPolicyState = FrameworkUtil.split(deliverableCurrent, ".");
									if(listPolicyState!=null && listPolicyState.size()==2){
										String deliverablePolicy = (String)listPolicyState.get(0);
										String deliverableState = (String)listPolicyState.get(1);

										if(PropertyUtil.getSchemaProperty(context,deliverablePolicy)!=null && !PropertyUtil.getSchemaProperty(context,deliverablePolicy).equalsIgnoreCase("")){
											if(PropertyUtil.getSchemaProperty(context,"policy", PropertyUtil.getSchemaProperty(context,deliverablePolicy), deliverableState)!=null && !PropertyUtil.getSchemaProperty(context,"policy", PropertyUtil.getSchemaProperty(context,deliverablePolicy), deliverableState).equalsIgnoreCase("")){
												//Policy and state exist
												if(deliverableCurrents.length() > 0){
													deliverableCurrents += ",";
									    	    }
												deliverableCurrents += deliverableCurrent;
											}
										}
									}
								}
							}
						}
					}
				}
			}
	        //End added for Change Discipline
	    }else{
	    	cmdMap = UICache.getCommand(context, PropertyUtil.getSchemaProperty(context,"command_ECHInterOpDocTypeDeliverableSearch"));
	    }
	    if(cmdMap!=null && !"null".equals(cmdMap) && cmdMap.size()>= 0){
	    	HashMap settingsList = (HashMap) cmdMap.get("settings");
	        if(settingsList!=null && !"null".equals(settingsList) && settingsList.size()>0){
	        	for(Iterator itr = settingsList.keySet().iterator(); itr.hasNext();){
	        		String key = (String)itr.next();
	        		if(key.startsWith("Type")){
	        			if(deliverableTypes.length()>0){
	        				deliverableTypes += ",";
	        			}
	        			deliverableTypes += (String)settingsList.get(key);
	        		}else if(key.startsWith("Current")){
	        			if(deliverableCurrents.length()>0){
	        				deliverableCurrents += ",";
	        			}
	        			deliverableCurrents += (String)settingsList.get(key);
	        		}
	        	}
	        }
	    }
	    //if nothing set in command object then use ECH defaults
	    if(deliverableTypes.length()<=0){
		    //deliverableTypes = defaultTypes;
	    }
	    if(deliverableCurrents.length()<=0){
		    //deliverableCurrents = defaultCurrent;
	    }
		%>
		<script language="Javascript">
			var contentURL = "";
			<%
			if("Change".equals(delType)){
				//Added for IR-046491V6R2011
				if(changeDelChoice.equalsIgnoreCase("false")){
					selection="single";
				}else{
					selection="multiple";
				}
				//End of IR-046491V6R2011
				//Modified contentURL for IR-046491V6R2011
				//IR-041102 added &selection=multiple
				if(deliverableTypes!=null && !deliverableTypes.equalsIgnoreCase("")){
					String submitLabel = EnoviaResourceBundle.getProperty(context,"EnterpriseChange","emxCommonButton.Done",context.getSession().getLanguage());
	                String cancelLabel = EnoviaResourceBundle.getProperty(context,"EnterpriseChange","emxCommonButton.Cancel",context.getSession().getLanguage());
					%>contentURL = "../common/emxFullSearch.jsp?field=TYPES=<%=XSSUtil.encodeForURL(context,deliverableTypes)%>:IS_TASK_DELIVERABLE=False";<%
					if(deliverableCurrents!=null && !deliverableCurrents.equalsIgnoreCase("")){
						%>contentURL = contentURL + ":CURRENT=<%=XSSUtil.encodeForURL(context,deliverableCurrents)%>";<%
					}
					%>contentURL = contentURL + "&excludeOIDprogram=emxChangeTaskBase:excludeConnectedTaskDeliverablesAndECOECInReview&table=AEFGeneralSearchResults&cancelLabel=<%=cancelLabel%>&submitLabel=<%=submitLabel%>&hideHeader=true&HelpMarker=emxhelpfullsearch&objectId=<%=strTaskId%>&selection=<%=XSSUtil.encodeForURL(context,selection)%>&submitURL=../enterprisechange/AddExistingChangeProcessDeliverableProcess.jsp?delType=<%=XSSUtil.encodeForURL(context,delType)%>";<%
				}else{
		            String sllanguage=context.getSession().getLanguage();
		            String srAlert = (String)(EnoviaResourceBundle.getProperty(context,"EnterpriseChange","emxEnterpriseChange.Alert.NoApplicableItemDefined",sllanguage)).trim();
		            throw new FrameworkException(srAlert);
				}
			}else{
				String submitLabel = EnoviaResourceBundle.getProperty(context,"EnterpriseChange","emxCommonButton.Done" ,context.getSession().getLanguage());
				String cancelLabel = EnoviaResourceBundle.getProperty(context,"EnterpriseChange","emxCommonButton.Cancel" ,context.getSession().getLanguage());
				%>
				contentURL ="../common/emxFullSearch.jsp?field=TYPES=<%=XSSUtil.encodeForURL(context,deliverableTypes)%>:IS_TASK_DELIVERABLE=False&table=AEFGeneralSearchResults&cancelLabel=<%=XSSUtil.encodeForURL(context,cancelLabel)%>&submitLabel=<%=XSSUtil.encodeForURL(context,submitLabel)%>&hideHeader=true&HelpMarker=emxhelpfullsearch&objectId=<%=strTaskId%>&selection=multiple&submitURL=../enterprisechange/AddExistingChangeProcessDeliverableProcess.jsp?delType=<%=XSSUtil.encodeForURL(context,delType)%>";
				<%
			}
			%>
			getTopWindow().showModalDialog(contentURL,575,575,true,"Medium");
			
		</script>
	</body>
</html>
