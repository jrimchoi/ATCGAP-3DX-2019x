<%@page import = "com.matrixone.apps.domain.util.MapList"%>
<%@page import = "com.matrixone.apps.domain.util.EnoviaResourceBundle"%>
<%@page import = "com.matrixone.apps.domain.util.mxType"%>
<%@page import = "com.matrixone.apps.domain.util.PersonUtil"%>
<%@page import = "com.matrixone.apps.domain.DomainObject"%>
<%@page import = "com.matrixone.apps.domain.DomainRelationship"%>
<%@page import = "com.matrixone.apps.domain.DomainConstants"%>
<%@page import = "matrix.db.Context"%>
<%@page import = "java.util.List"%>
<%@page import = "matrix.db.JPO"%>

<%@page import = "matrix.util.StringList"%>
<%@page import = "java.util.HashMap"%>
<%@page import = "java.util.Vector"%>
<%@page import = "java.util.Map"%>
<%@page import = "java.util.Set"%>

<%@page import = "java.util.ArrayList"%>
<%@page import = "java.util.Locale"%>
<%@page import = "com.matrixone.apps.domain.util.FrameworkException"%>

<%@page import = "com.matrixone.apps.effectivity.EffectivityFramework"%>
<%@page import = "com.matrixone.apps.effectivity.EffectivitySettingsManager"%>

<%@page import = "com.matrixone.apps.enterprisechange.EnterpriseChangeConstants"%>
<%@page import = "com.matrixone.apps.enterprisechange.EnterpriseChangeUtil"%>
<%@page import = "com.matrixone.apps.enterprisechange.Decision"%>

<%@include file = "../emxI18NMethods.inc"%>
<%@include file = "../emxUICommonAppInclude.inc"%>
<%@include file = "../common/emxUIConstantsInclude.inc"%>

<%
String infinitySymbolStr = EffectivityFramework.INFINITY_SYMBOL_STORAGE;
String parentSeparatorStr = EffectivityFramework.PARENT_SEPARATOR;
String rangeSeparatorStorageStr = EffectivityFramework.RANGE_SEPARATOR_STORAGE;
String valueSeparatorStorageStr = EffectivityFramework.VALUE_SEPARATOR_STORAGE;
String rangeSeparatorStr = EffectivityFramework.RANGE_SEPARATOR_DIALOG;
String valueSeparatorStr = EffectivityFramework.VALUE_SEPARATOR_DIALOG;
String seriesCloseBracket = EffectivityFramework.SERIES_CLOSE_BRACKET;
EffectivityFramework ef = new EffectivityFramework();
String infinitySymbolDisp = ef.getInfinitySymbolDisplay(context);
String infinitySymbolKeyIn = ef.getInfinitySymbolKeyIn(context);
String strURLParamValSepComma = ",";

String tempObjectId = emxGetParameter(request,"objectId"); // Model ID
String tempRootObjectId = emxGetParameter(request,"rootObjectId"); //Decision ID
String changeDiscipline = emxGetParameter(request,"changeDiscipline");
String tempEffectivityTypes = emxGetParameter(request,"effectivityTypes");

//set RPE to display effectivity for ECH
PropertyUtil.setGlobalRPEValue(context, "ENO_ECH", "true");
//get separator from template .xls
String prodNameRevSep = "-"; //default
String revSuffix = "";//default
if(tempObjectId != null && !tempObjectId.isEmpty()){
  String DUMMYPRODUCTNAME = "_DUMMYPRODUCTNAMEXYZ_";
  String DUMMYPRODUCTREV  = "_DUMMYPRODUCTREVISIONXYZ_";
  MapList dummyMapList = new MapList();
  Map dummyObjMap = new HashMap();
  dummyObjMap.put(DomainObject.SELECT_TYPE, EnterpriseChangeConstants.TYPE_PRODUCTS);
  dummyObjMap.put(DomainObject.SELECT_NAME, DUMMYPRODUCTNAME);
  dummyObjMap.put(DomainObject.SELECT_REVISION, DUMMYPRODUCTREV);
  dummyMapList.add(dummyObjMap);
  Map dummyContentMap = new HashMap();
  dummyContentMap.put("contextModelId", tempObjectId);
  dummyContentMap.put("applicableItemsList", dummyMapList);
  String dummyDisplayExpression = ef.getDisplayExpression(context, dummyContentMap);
  if(dummyDisplayExpression != null && !dummyDisplayExpression.isEmpty()){
      int productNameIdx = dummyDisplayExpression.indexOf(DUMMYPRODUCTNAME);
      int productRevIdx = dummyDisplayExpression.indexOf(DUMMYPRODUCTREV);
      prodNameRevSep = dummyDisplayExpression.substring(productNameIdx + DUMMYPRODUCTNAME.length(), productRevIdx);
      revSuffix = dummyDisplayExpression.substring(productRevIdx + DUMMYPRODUCTREV.length(), dummyDisplayExpression.length());
  }   
}
Map exprMap = new HashMap();
MapList appItemsList = new MapList();
if ((tempObjectId!=null && !tempObjectId.isEmpty()) && (tempRootObjectId!=null && !tempRootObjectId.isEmpty()) && (changeDiscipline!=null && !changeDiscipline.isEmpty())) {
	Decision decision = new Decision(tempRootObjectId);
	Map<String,Map<String,Map<String,MapList>>> applicableItemsSortedByMastersAndDisciplinesAndTypes = decision.getApplicabilitySummary(context, null, new StringList(changeDiscipline), null);
	if (applicableItemsSortedByMastersAndDisciplinesAndTypes!=null && !applicableItemsSortedByMastersAndDisciplinesAndTypes.isEmpty()) {
		Map<String,Map<String,MapList>> masterApplicableItems = applicableItemsSortedByMastersAndDisciplinesAndTypes.get(tempObjectId);
		if (masterApplicableItems!=null && !masterApplicableItems.isEmpty()) {
			Map<String,MapList> applicableItemsByTypes = masterApplicableItems.get(changeDiscipline);
			if (applicableItemsByTypes!=null && !applicableItemsByTypes.isEmpty()) {
				//Get all Type keys
				Set<String> typeKeys = applicableItemsByTypes.keySet();
				Iterator<String> typeKeysItr = typeKeys.iterator();
				while (typeKeysItr.hasNext()) {
					String typeKey = typeKeysItr.next();
					if (typeKey!=null && !typeKey.isEmpty()) {
						MapList applicableItems = applicableItemsByTypes.get(typeKey);
						if (applicableItems!=null && !applicableItems.isEmpty()) {
							Iterator<Map<String,String>> applicableItemsItr = applicableItems.iterator();
							boolean hasNext = false;
							while (applicableItemsItr.hasNext()) {
								Map<String,String> applicableItem = applicableItemsItr.next();
								if (applicableItem!=null && !applicableItem.isEmpty()) {
									String applicableItemId = applicableItem.get(DomainConstants.SELECT_ID);
                                    //DomainObject domapplicableItemId = new DomainObject(applicableItemId);
                                    String applicableItemName = applicableItem.get(DomainConstants.SELECT_NAME);
									String applicableItemPhyId = applicableItem.get("physicalid");
									String applicableItemType = applicableItem.get(DomainConstants.SELECT_TYPE);
									String applicableItemRevision = applicableItem.get(DomainConstants.SELECT_REVISION);
									String applicableItemBuildUnitNumber = applicableItem.get("attribute[" + EnterpriseChangeConstants.ATTRIBUTE_BUILD_UNIT_NUMBER + "]");
									String applicableItemUpwardCompatibility = applicableItem.get("attribute[" + EnterpriseChangeConstants.ATTRIBUTE_UPWARD_COMPATIBILITY + "]");
									
									String applicableItemParentId = applicableItem.get("to[" + EnterpriseChangeConstants.RELATIONSHIP_MAIN_PRODUCT + "].from.id");
									
									if(applicableItemParentId == null || "null".equalsIgnoreCase(applicableItemParentId) || "".equalsIgnoreCase(applicableItemParentId)){
										applicableItemParentId = applicableItem.get("to[" + EnterpriseChangeConstants.RELATIONSHIP_PRODUCTS + "].from.id");
									}
									
									
									// still it is null that means Root MP is used in Expression
									if(applicableItemParentId == null || "null".equalsIgnoreCase(applicableItemParentId) || "".equalsIgnoreCase(applicableItemParentId)){
										applicableItemParentId = applicableItem.get("to[" + EnterpriseChangeConstants.RELATIONSHIP_MANAGED_ROOT + "].from.from[" + EnterpriseChangeConstants.RELATIONSHIP_SERIES_MASTER + "].to.id");
									}
									//Still it is null then it's MP object
									if(applicableItemParentId == null || "null".equalsIgnoreCase(applicableItemParentId) || "".equalsIgnoreCase(applicableItemParentId)){															
										applicableItemParentId = applicableItem.get("to[" + EnterpriseChangeConstants.RELATIONSHIP_MANAGED_SERIES + "].from.from[" + EnterpriseChangeConstants.RELATIONSHIP_SERIES_MASTER + "].to.id");
									}														
									if(applicableItemParentId == null || "null".equalsIgnoreCase(applicableItemParentId) || "".equalsIgnoreCase(applicableItemParentId)){
										applicableItemParentId = applicableItem.get("to[" + EnterpriseChangeConstants.RELATIONSHIP_MAIN_DERIVED + "].from.id");
									}
									if(applicableItemParentId == null || "null".equalsIgnoreCase(applicableItemParentId) || "".equalsIgnoreCase(applicableItemParentId)){
										applicableItemParentId = applicableItem.get("to[" + EnterpriseChangeConstants.RELATIONSHIP_DERIVED + "].from.id");
									}

									
									
									String applicableItemParentPhyId = applicableItem.get("to[" + EnterpriseChangeConstants.RELATIONSHIP_DERIVED + "].from.physicalid");
									if((applicableItemParentPhyId == null || "null".equalsIgnoreCase(applicableItemParentPhyId) ||  "".equalsIgnoreCase(applicableItemParentPhyId))){
										applicableItemParentPhyId = applicableItem.get("to[" + EnterpriseChangeConstants.RELATIONSHIP_MAIN_DERIVED + "].from.physicalid");
									}
									//Still it is null then it's MP object
									if((applicableItemParentPhyId == null || "null".equalsIgnoreCase(applicableItemParentPhyId) ||  "".equalsIgnoreCase(applicableItemParentPhyId))){															
										applicableItemParentId = applicableItem.get("to[" + EnterpriseChangeConstants.RELATIONSHIP_MANAGED_SERIES + "].from.from[" + EnterpriseChangeConstants.RELATIONSHIP_SERIES_MASTER + "].to.physicalid");
									}														
									// still it is null that means Root MP is used in Expression
									if((applicableItemParentPhyId == null || "null".equalsIgnoreCase(applicableItemParentPhyId) ||  "".equalsIgnoreCase(applicableItemParentPhyId))){
										applicableItemParentId = applicableItem.get("to[" + EnterpriseChangeConstants.RELATIONSHIP_MANAGED_ROOT + "].from.from[" + EnterpriseChangeConstants.RELATIONSHIP_SERIES_MASTER + "].to.physicalid");
									}
									// still it is null that means Root Product is used in Expression
									if(applicableItemParentId == null || "null".equalsIgnoreCase(applicableItemParentId) || "".equalsIgnoreCase(applicableItemParentId)){
										applicableItemParentId = applicableItem.get("to[" + EnterpriseChangeConstants.RELATIONSHIP_MAIN_PRODUCT + "].from.physicalid");
									}

									Map appItem = new HashMap();
                                    if (applicableItemType!=null && (mxType.isOfParentType(context, applicableItemType, EnterpriseChangeConstants.TYPE_PRODUCTS) || mxType.isOfParentType(context, applicableItemType, EnterpriseChangeConstants.TYPE_MANUFACTURING_PLAN))) {
                                        appItem.put(DomainObject.SELECT_REVISION, applicableItemRevision);
                                    } else if(applicableItemType!=null && mxType.isOfParentType(context, applicableItemType, EnterpriseChangeConstants.TYPE_BUILDS)) {
                                        appItem.put(DomainObject.SELECT_REVISION, applicableItemBuildUnitNumber);
                                    }                                   
									appItem.put("objId", applicableItemId);
                                    appItem.put("objType", applicableItemType);
                                    appItem.put("objName", applicableItemName);
									if (applicableItemType!=null && (mxType.isOfParentType(context, applicableItemType, EnterpriseChangeConstants.TYPE_PRODUCTS) || mxType.isOfParentType(context, applicableItemType, EnterpriseChangeConstants.TYPE_MANUFACTURING_PLAN))) {
										appItem.put("seqSel", applicableItemRevision);
									} else if(applicableItemType!=null && mxType.isOfParentType(context, applicableItemType, EnterpriseChangeConstants.TYPE_BUILDS)) {
										appItem.put("seqSel", applicableItemBuildUnitNumber);
									}
									if (applicableItemUpwardCompatibility.equalsIgnoreCase(EnterpriseChangeConstants.RANGE_YES)) {
										appItem.put("upwardCompatible", "true");
									} else if (applicableItemUpwardCompatibility.equalsIgnoreCase(EnterpriseChangeConstants.RANGE_NO)) {
										appItem.put("upwardCompatible", "false");
									}
									appItem.put("parentId", applicableItemParentId);
                                    appItem.put("physicalid", applicableItemPhyId);
                                    appItem.put("contextId", tempObjectId);
									appItemsList.add(appItem);
								}
							}//End of while applicableItemsItr
							if (appItemsList!=null && !appItemsList.isEmpty()) {
								String strEffectivityType = "";
								if (tempEffectivityTypes!=null && !tempEffectivityTypes.isEmpty()) {
									StringList effectivityCommandsList = FrameworkUtil.split(tempEffectivityTypes, ",");
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
									HashMap requestMap = new HashMap();
									requestMap.put("AppItemsList",appItemsList);
									requestMap.put("EffectivityType", strEffectivityType);
									if (EnterpriseChangeUtil.isCFFInstalled(context)) {
                                        Map tempExprMap = (Map) JPO.invoke(context, "emxEffectivityFramework", null, "formatExpressionforApplicabilityContext", JPO.packArgs(requestMap), Map.class);
										if (tempExprMap!=null && !tempExprMap.isEmpty()) {
											if (exprMap!=null && !exprMap.isEmpty()) {
												String displayValue = (String)exprMap.get("displayValue") + " OR " + (String)tempExprMap.get("displayValue");
												String actualValue = (String)exprMap.get("actualValue") + " OR " + (String)tempExprMap.get("actualValue");
												String listValue = (String)exprMap.get("listValue") + "@delimitter@OR@delimitter@" + (String)tempExprMap.get("listValue");
												String listValueActual = (String)exprMap.get("listValueActual") + "@delimitter@OR@delimitter@" + (String)tempExprMap.get("listValueActual");
												
												exprMap.put("displayValue", displayValue);
												exprMap.put("actualValue", actualValue);
												exprMap.put("listValue", listValue);
												exprMap.put("listValueActual", listValueActual);
											} else {
												exprMap = tempExprMap;
											}
										}
									}
								}
							}
							if (typeKeysItr.hasNext()) {
								hasNext = true;
							} else {
								hasNext = false;
							}
						}
					}
				}//End of while typeKeysItr
			}
		}
	}
}

int noEffTypes = 0;
double iClientTimeOffset = (new Double((String)session.getAttribute("timeZone"))).doubleValue();

// Added for Applicalbility Defination Dialog
String strApplicabilityMode = "true";//emxGetParameter(request, "applicabilityMode");
boolean bApplicabilityMode = true; 


%>
<script Language="Javascript">
var infinitySymbol = "<%=XSSUtil.encodeForJavaScript(context,infinitySymbolStr)%>";
var infinitySymbolDisp = "<%=XSSUtil.encodeForJavaScript(context,infinitySymbolDisp)%>";
var infinitySymbolKeyIn = "<%=XSSUtil.encodeForJavaScript(context,infinitySymbolKeyIn)%>";
var rangeSeparator = "<%=XSSUtil.encodeForJavaScript(context,rangeSeparatorStr)%>";
var valueSeparator = "<%=XSSUtil.encodeForJavaScript(context,valueSeparatorStr)%>";
var parentSeparator = "<%=XSSUtil.encodeForJavaScript(context,parentSeparatorStr)%>";
var rangeSeparatorStorage = "<%=XSSUtil.encodeForJavaScript(context,rangeSeparatorStorageStr)%>";
var valueSeparatorStorage = "<%=XSSUtil.encodeForJavaScript(context,valueSeparatorStorageStr)%>";
var postProcessURL="";
var iClientTimeOffset = "<%=XSSUtil.encodeForJavaScript(context,String.valueOf(iClientTimeOffset) )%>";
var bApplicabilityMode = "<%=XSSUtil.encodeForJavaScript(context,String.valueOf(bApplicabilityMode))%>";
var selectedAppObj = new Object();
var cntAppObj = 0;
var PRODUCTNAMEREVSEP = "<%=XSSUtil.encodeForJavaScript(context,prodNameRevSep)%>";
var REVSUFFIX = "<%=XSSUtil.encodeForJavaScript(context,revSuffix)%>";
<%String sPostProcessURL = emxGetParameter(request, "postProcessCFFURL");
if(sPostProcessURL != null)
{
%>
postProcessURL = "<%=XSSUtil.encodeForJavaScript(context,sPostProcessURL)%>";
<%}%>
var showContext = false;
<%String sShowContext = emxGetParameter(request, "showContext");
if(sShowContext != null)
{
	boolean bshowContext = Boolean.parseBoolean(sShowContext);
%>
showContext = <%=XSSUtil.encodeForJavaScript(context,String.valueOf(bshowContext)) %>;
<%}
if (!appItemsList.isEmpty()) {
	for (Iterator appItemsItr = appItemsList.iterator(); appItemsItr.hasNext();) {
		Map appItemData = (Map) appItemsItr.next();
		String strObjId = (String) appItemData.get("objId");
        String strObjType = (String) appItemData.get("objType");
        String strObjName = (String) appItemData.get("objName");
		String strSeqSel = (String) appItemData.get("seqSel");
		String strParentId = (String) appItemData.get("parentId");
		String strPhyId = (String) appItemData.get("physicalid");
        String contextId = (String)appItemData.get("contextId");
		%>
		   var selectedObj = new Object();
		   selectedObj["seqSel"] = "<%=XSSUtil.encodeForJavaScript(context,strSeqSel)%>";
		   selectedObj["upwardCompatible"] = "<%=XSSUtil.encodeForJavaScript(context,"true")%>";
		   selectedObj["objId"] = "<%=XSSUtil.encodeForJavaScript(context,strObjId)%>";
           selectedObj["objType"] = "<%=XSSUtil.encodeForJavaScript(context,strObjType)%>";
           selectedObj["objName"] = "<%=XSSUtil.encodeForJavaScript(context,strObjName)%>";
		   selectedObj["parentId"] = "<%=XSSUtil.encodeForJavaScript(context,strParentId)%>";
		   selectedObj["physicalid"] = "<%=XSSUtil.encodeForJavaScript(context,strPhyId)%>";
            selectedObj["contextId"] = "<%=XSSUtil.encodeForJavaScript(context,contextId)%>";
		   selectedAppObj[cntAppObj++]= selectedObj;
		<%
	}
}
%>
</script>

<%@include file = "../emxTagLibInclude.inc"%>
<SCRIPT language="javascript" src="../common/scripts/emxUICore.js"></SCRIPT>
<SCRIPT language="javascript" src="../common/scripts/emxUIJson.js"></SCRIPT>
<script>
var SETTING_KEYWORD = "<%=XSSUtil.encodeForJavaScript(context, EffectivitySettingsManager.CMD_SETTING_KEYWORD)%>";
</script>
<script language="javascript" type="text/javascript" src="../effectivity/scripts/emxUIEffectivityFramework.js"></script>
<%
String acceptLanguage = request.getHeader("Accept-Language");

//Code to be inserted for the bundle to be read from prop file.
String bundle = "EffectivityStringResource";
String ECHBundle = "emxEnterpriseChangeStringResource";
String DateFrm = "";
%>

<framework:localize id="i18nId" bundle="EffectivityStringResource"
        locale="<xss:encodeForJavaScript><%=acceptLanguage%></xss:encodeForJavaScript>"/>


<%!
  private static final String DOUBLE_QUOTES = "\"";
  private static final String SPACE = " ";
  private static final String ID = DomainConstants.SELECT_ID;
%>
		<script src="../common/scripts/emxNavigatorHelp.js" type="text/javascript">
		</script>
<script language="javascript" type="text/javascript" src="../common/scripts/emxUICalendar.js"></script>

<% 

String RELATIONSHIP_MODEL_PRODUCT    = PropertyUtil.getSchemaProperty(context,"relationship_ModelProduct");
String Directory              = emxGetParameter(request,"dir");
  if( Directory == null || "".equals(Directory) || "null".equals(Directory) )
  {
      Directory = emxGetParameter(request,"Directory");
  }

  String langStr = request.getHeader("Accept-Language");
  String lStr = i18nStringNowUtil("emxFramework.HelpDirectory","emxFrameworkStringResource", langStr);
  
  String langOnlineStr = i18nStringNowUtil("emxFramework.OnlineXML.HelpDirectory", "emxFrameworkStringResource", lStr);

    String strInvockedFrom = emxGetParameter(request, "invockedFrom");
    if (strInvockedFrom == null || strInvockedFrom.equals("null") || strInvockedFrom.equals(""))
    {
	    strInvockedFrom = "fromForm";
    }
//Checking the mode create or edit 
    String strmode                      = emxGetParameter(request,"modetype");
    String strFieldNameEffTypes         = emxGetParameter(request,"fieldNameEffTypes");
    String strFieldNameEffExprActual    = emxGetParameter(request,"fieldNameEffExprActual");
    String strFieldNameEffExprDisplay   = emxGetParameter(request,"fieldNameEffExprDisplay");
    String strFieldNameEffExprList   = emxGetParameter(request,"fieldNameEffExprActualList");
    String strFieldNameDisplay              = emxGetParameter(request,"fieldNameDisplay");
    String strFieldNameActual              = emxGetParameter(request,"fieldNameActual");
    String strFieldNameEffExprListAc   = emxGetParameter(request,"fieldNameEffExprActualListAc");
    String strFieldNameEffExprOID   = emxGetParameter(request,"fieldNameEffExprOID");
    String strFormName                  = emxGetParameter(request,"formName");
    String strExpandProgram                  = emxGetParameter(request,"expandProgram");
    String strRelationship                 = emxGetParameter(request,"relationship");
    String strRootId                 = emxGetParameter(request,"rootObjectId");
	String strEffRelationship = emxGetParameter(request,
			"effectivityRelationship");
	String showOrCommandLine = emxGetParameter(request, "showOr");
	String showAndCommandLine = emxGetParameter(request, "showAnd");
	String showInfCommandLine = emxGetParameter(request, "showInfinity");
	String CFFExpressionListAc = emxGetParameter(request,"CFFExpressionList");
	String CFFExpressionListDisp = emxGetParameter(request,"CFFExpressionListDisp");
	String strModelContext = emxGetParameter(request, "modelContext");
	String strChangeDiscipline = emxGetParameter(request,"changeDiscipline");
	String strEffectivityTypes = emxGetParameter(request,"effectivityTypes");
	StringTokenizer strTok = new StringTokenizer(strEffectivityTypes,",");
	MapList typeEffectivityList = new MapList();
	
	
	
    String str_Relationship_Name        = "" ;
    String str_Type_Name                = "" ;
    String strContextObjectId           = "" ;
    String strRootType  = "";
    String strObjectId                  = "" ;
    String quoteSeparatedIds = "";
    String quoteSeparatedIdsAc = "";

    String strincruleID = DomainConstants.EMPTY_STRING;
    String strTempExp = "" ; 
    Locale Local = request.getLocale();
    String strParentObjectId = emxGetParameter(request,"parentOID");
    if(strmode!=null && strmode.equalsIgnoreCase("create"))
    {
    	strParentObjectId  = emxGetParameter(request,"parentOID");
    }
    else if(strInvockedFrom.equalsIgnoreCase("fromTable"))
    {
	    //strRootId is the object Id of the root node in the navigation tree
	    DomainObject rootDom = new DomainObject(strRootId);
    	strRootType = rootDom.getInfo(context, DomainConstants.SELECT_TYPE);
    }
    else
    {
    	strParentObjectId  = emxGetParameter(request,"objectId");
    }
	//Boolean to show Or, And and Not buttons in the dialog
	boolean bShowOrCommandLine = true;
	boolean bShowAndCommandLine = true;
	boolean bShowInfCommandLine = true;
	if (showOrCommandLine != null) {
		bShowOrCommandLine = Boolean.parseBoolean(showOrCommandLine);
	}
	if (showAndCommandLine != null) {
		bShowAndCommandLine = Boolean.parseBoolean(showAndCommandLine);
	}
	if (showInfCommandLine != null) {
		bShowInfCommandLine = Boolean.parseBoolean(showInfCommandLine);
	}

//	boolean bShowAndNot = false;
	boolean bShowSingleOperator = true;
	String sShowSingleOperator = "";
	try {
		sShowSingleOperator = EnoviaResourceBundle.getProperty(context,
				"emxEffectivity.Dialog.AllowSingleOperator");
	} catch (Exception ex) {
		sShowSingleOperator = "true";
	}
	if (sShowSingleOperator != null) {
		bShowSingleOperator = Boolean.parseBoolean(sShowSingleOperator);
	}

	//Boolean to show Or, And and Not buttons in the dialog
    String oId = emxGetParameter(request, "objectId");
    String parentOID = emxGetParameter(request, "parentOID");
    
    // dam - added this line to get structure browser edits working???
    strContextObjectId = strParentObjectId;

    
    // get vault 
    matrix.db.Vault defaultVault=context.getVault();

    String strContextPage = emxGetParameter(request, "contextPage");
    String strRelId = emxGetParameter(request, "relId");
    
    String strParentOID = emxGetParameter(request, "parentOID");
    String strProductID1 = emxGetParameter(request,"productID");
    
    String strRuleExp = DomainConstants.EMPTY_STRING;

    String strFromWhere = emxGetParameter(request, "fromWhere");
    

    if(strApplicabilityMode != null && strApplicabilityMode.equalsIgnoreCase("true")){
    	showOrCommandLine = "false";
    	//Modified by IXE the value to TRUE for OR operator chagne
    	bShowOrCommandLine = true;
    	showInfCommandLine = "false";
    	bShowInfCommandLine = false;
    	bApplicabilityMode = Boolean.parseBoolean(strApplicabilityMode);
    	
    	
    }
    
    double clientTZOffset = Double.parseDouble((String)session.getValue("timeZone")); 
    MapList mlEffectivityExpr = null;
    EffectivityFramework EFF = new EffectivityFramework();
    List listValue = new ArrayList();
    List listValueActual = new ArrayList();
    StringBuffer sbListValue = new StringBuffer();
    try {
    	
	//get the actual and display effectivity expression values for the current context object or rel
        if (strmode!=null && (strmode.equals("structureEdit") || strmode.equals("edit") ||  strInvockedFrom.equalsIgnoreCase("fromTable")))
        {
            if (strRelId != null && !"null".equalsIgnoreCase(strRelId) && !"".equals(strRelId))
            {
           mlEffectivityExpr = EFF.getRelExpression(context, strRelId, clientTZOffset, true);
           Map mapExpression = null;
           mapExpression = (Map)mlEffectivityExpr.get(0);
           listValue = (List)mapExpression.get("listValue");  
           listValueActual = (List)mapExpression.get("listValueActual");
            }
          else if (strObjectId != null && strObjectId.length() > 0)
          {
           mlEffectivityExpr = EFF.getObjectExpression(context, strObjectId, clientTZOffset, true);
           Map mapExpression = null;
           mapExpression = (Map)mlEffectivityExpr.get(0);
           listValue = (List)mapExpression.get("listValue");
           listValueActual = (List)mapExpression.get("listValueActual");
          }
        }
        if(strInvockedFrom != null && strInvockedFrom.equalsIgnoreCase("fromTable"))
        {
        	for(int i=0;i<listValue.size();i++)
            {
              sbListValue.append(listValue.get(i));
              sbListValue.append("@delimitter@");
            }
            String strListValue = sbListValue.toString();
            sbListValue.delete(0, sbListValue.length());
            for(int i=0;i<listValueActual.size();i++)
            {
              sbListValue.append(listValueActual.get(i));
              sbListValue.append("@delimitter@");
            }
            quoteSeparatedIds = strListValue.substring(0, strListValue.length());
            String strListValueAc = sbListValue.toString();
            quoteSeparatedIdsAc = strListValueAc.substring(0, strListValueAc.length());
	
        }
    }catch(Exception e)
    {
        e.printStackTrace();
    }

    String strContextName   = "";
    String strContextRevision = "";
    String strContextType   = "";
    MapList mlEffTypes = new MapList();

    if (strmode!=null && (strmode.equalsIgnoreCase("structureEdit") || strmode.equals("edit")) && strRelId != null && !"null".equalsIgnoreCase(strRelId) && !"".equals(strRelId))
    {
	   strContextName   = "";
	   strContextRevision = "";
	   strContextType   = "";
	   mlEffTypes = EFF.getRelEffectivityTypes(context, strRelId); 	   
    }
    else if (strContextObjectId != null && strContextObjectId.length() > 0)
    {
       DomainObject domObj      = DomainObject.newInstance(context,strContextObjectId);
       strContextName   = domObj.getInfo(context,DomainConstants.SELECT_NAME);
       strContextRevision = domObj.getRevision(context);
       strContextType   = domObj.getInfo(context,DomainConstants.SELECT_TYPE);
       mlEffTypes = EFF.getObjectEffectivityTypes(context, strContextObjectId);
    }
    
    
	
    String strCtxType = "";
    String strCtxName = "";
    String strCtxRev = ""; 

%>


<%@page import="java.util.StringTokenizer"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title><emxUtil:i18n localize="i18nId">Effectivity.Label.EditEffectivityDefinitionHeading</emxUtil:i18n></title>
<link rel="stylesheet" type="text/css" media="screen" href="../common/styles/emxUIDefault.css" />
<link rel="stylesheet" type="text/css" media="screen" href="../common/styles/emxUIMenu.css"/>
<link rel="stylesheet" type="text/css" media="screen" href="../common/styles/emxUIStructureBrowser.css" />
<link rel="stylesheet" type="text/css" media="screen" href="../effectivity/styles/emxUIExpressionBuilder.css" />
<link rel="stylesheet" type="text/css" media="screen" href="../effectivity/styles/emxUIRuleLayerDialog.css" />


<script language="JavaScript" type="text/javascript"
	src="../common/emxUIConstantsJavaScriptInclude.jsp"></script>
<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
<script language="javascript" src="../common/emxUIPageUtility.js"></script>
<script language="javascript" src="../common/scripts/emxUIModal.js"></script>
<script language="javascript" src="../common/scripts/emxUICore.js"></script>


<script Language="Javascript">
var currentEffTypes;
var currentEffExprActual;
var currentEffExprDisp;
var currentEffExpr;
var currentEffExprAc;
//var currentEffTypesArr = new Array();
//var currentEffTypesArrActual = new Array();
var currentEffTypesModeArr = new Array();
var currentEffTypesModeArrActual = new Array();
var showValidMsg = true;
var showOrCommandLine = <%=XSSUtil.encodeForJavaScript(context,showOrCommandLine)%>;
var showAndCommandLine = <%=XSSUtil.encodeForJavaScript(context,showAndCommandLine)%>;
var showInfCommandLine = <%=XSSUtil.encodeForJavaScript(context,showInfCommandLine)%>;
var cnt = 0;
<%

if(bApplicabilityMode){
    String effType = ""; 
    String effTypeActual = ""; 
	while(strTok.hasMoreTokens()){
		String cmmdName = strTok.nextToken();
		cmmdName = cmmdName.replaceAll("CFFEffectivity","");
        Map effTypeMap = new HashMap();
        effTypeActual = cmmdName; 
        effType =  EffectivitySettingsManager.getEffectivityLabel(context,cmmdName );
        
        effTypeMap.put(EffectivityFramework.ACTUAL_VALUE, effTypeActual);
        effTypeMap.put(EffectivityFramework.DISPLAY_VALUE, effType);
        mlEffTypes.add(effTypeMap);
        %>	    
        currentEffTypesArr[cnt] = "<%=XSSUtil.encodeForJavaScript(context,effType)%>";
        currentEffTypesArrActual[cnt] = "<%=XSSUtil.encodeForJavaScript(context,effTypeActual)%>";
	    cnt++
	    <%	 
    }
}


//get the valid effectivity types for the context object and/or rel
if (strmode!=null && (strmode.equals("structureEdit") ||  strInvockedFrom.equalsIgnoreCase("fromTable")))
{   
    Map mapExpression = null;
    if (mlEffectivityExpr!=null && mlEffectivityExpr.size() > 0)
    {
    mapExpression = (Map)mlEffectivityExpr.get(0);  
    }
    else
    {
	mapExpression = new HashMap();
	mapExpression.put("actualValue", "");
	mapExpression.put("displayValue", "");
    }
    MapList relEffTypes = null;
    String[] strRelArr = null;
    if(strExpandProgram != null && !("").equalsIgnoreCase(strExpandProgram))
    {
        if (strEffRelationship == null || "null".equalsIgnoreCase(strEffRelationship) || "".equals(strEffRelationship) || "*".equals(strEffRelationship))
        {    // If effectivityRelationship parameter is not defined assume all Relationships on the given Type that have been configured for Effectivity 
        relEffTypes = EFF.getEffectivityForAllRelTypes(context, strRootType);
        }
        else if(strEffRelationship.contains(","))
        {
            strRelArr=strEffRelationship.split(",");
            relEffTypes = EFF.getRelEffectivity(context,strRelArr[0]);
            for(int i = 1; i < strRelArr.length; i++)
            {
                relEffTypes.addAll(EFF.getRelEffectivity(context,strRelArr[i]));
            }
        }
        else
        {
                relEffTypes = EFF.getRelEffectivity(context,strEffRelationship);
        }
    }
    else
    {
    	if(strRelationship == null && strRelId != null && !"null".equalsIgnoreCase(strRelId) && !"".equalsIgnoreCase(strRelId))
    	{
    	    DomainRelationship domRel = new DomainRelationship(strRelId);
    	    domRel.open(context);
    	    String relName = domRel.getTypeName();
    	    String relAlias = FrameworkUtil.getAliasForAdmin(context, "relationship", relName, true);        
    	    relEffTypes = EFF.getRelEffectivity(context, relAlias); 	
    		//relEffTypes = EFF.getEffectivityForAllRelTypes(context, strRootType);
    	}
    	else if ("*".equals(strRelationship))
    	{//dam
    		relEffTypes = EFF.getEffectivityForAllRelTypes(context, strRootType);    		    	
    	}
    	else if(strRelationship.contains(","))
        {
            strRelArr=strRelationship.split(",");
            relEffTypes = EFF.getRelEffectivity(context,strRelArr[0]);
            for(int i = 1; i < strRelArr.length; i++)
            {
                relEffTypes.addAll(EFF.getRelEffectivity(context,strRelArr[i]));
            }
        }
        else
        {
                relEffTypes = EFF.getRelEffectivity(context,strRelationship);
        }
    }
    Map effTypeMap = null;
    String effType = ""; 
    String effTypeActual = ""; 
    for (int idx=0; idx < relEffTypes.size(); idx++)
    {
	    effTypeMap = (Map)relEffTypes.get(idx);
	    effType = (String)effTypeMap.get("displayValue");
	    effTypeActual = (String)effTypeMap.get("actualValue");
%>	    
        currentEffTypesArr[cnt] = "<%=XSSUtil.encodeForJavaScript(context,effType)%>";
        currentEffTypesArrActual[cnt] = "<%=XSSUtil.encodeForURL(context,effTypeActual)%>";
	    cnt++
<%	    
   }
    noEffTypes = relEffTypes.size();
%>
    currentEffExprActual = "<%=XSSUtil.encodeForJavaScript(context,String.valueOf(mapExpression.get("actualValue")))%>";		
    currentEffExprDisp = "<%=XSSUtil.encodeForJavaScript(context,String.valueOf(mapExpression.get("displayValue")))%>";		
    currentEffExpr = "<%=XSSUtil.encodeForURL(context,quoteSeparatedIds)%>";     
    currentEffExprAc = "<%=XSSUtil.encodeForURL(context,quoteSeparatedIdsAc)%>";
<%    
}
else if (strContextObjectId != null && strContextObjectId.length() > 0)
{
	if(("fromEffToolbar").equalsIgnoreCase(strInvockedFrom) || strmode.equalsIgnoreCase("filter"))
	{
		Map mapExpression = null;
		StringList slEffTypes = new StringList();
		MapList objEffTypes = EFF.getObjectEffectivityTypes(context,strContextObjectId);
	    MapList relEffTypes = new MapList();
	    String[] strRelArr = null;
	    if(strExpandProgram != null && !("").equalsIgnoreCase(strExpandProgram))
	    {
		    if (strEffRelationship == null || "null".equalsIgnoreCase(strEffRelationship) || "".equals(strEffRelationship))
		    {    // If effectivityRelationship parameter is not defined assume all Relationships on the given Type that have been configured for Effectivity 
			relEffTypes = EFF.getEffectivityForAllRelTypes(context, strContextType);
		    }else if(strEffRelationship.contains(","))
	    	{
	    		strRelArr=strEffRelationship.split(",");
	    		relEffTypes = EFF.getRelEffectivity(context,strRelArr[0]);
	    		for(int i = 1; i < strRelArr.length; i++)
	    		{
	    			relEffTypes.addAll(EFF.getRelEffectivity(context,strRelArr[i]));
	    		}
	    	}
	    	else
	    	{
	    	    	relEffTypes = EFF.getRelEffectivity(context,strEffRelationship);
	    	}
	    }
	    else
	    {
	    	if(strRelationship == null || strRelationship.equals("*"))
	        {
	            relEffTypes = EFF.getEffectivityForAllRelTypes(context, strContextType);
	        }
	        else if(strRelationship.contains(","))
	        {
	            strRelArr=strRelationship.split(",");
	            relEffTypes = EFF.getRelEffectivity(context,strRelArr[0]);
	            for(int i = 1; i < strRelArr.length; i++)
	            {
	                relEffTypes.addAll(EFF.getRelEffectivity(context,strRelArr[i]));
	            }
	        }
	        else
	        {
	                relEffTypes = EFF.getRelEffectivity(context,strRelationship);
	        }
	    }
	    
	    Map effTypeMap = null;
	    Map effRelMap = null;
	    String effType = "";
	    String effTypeActual = "";
	   
	    for (int idx=0; idx < objEffTypes.size(); idx++)
	    {
	        effTypeMap = (Map)objEffTypes.get(idx);
	        effType = (String)effTypeMap.get("displayValue");
	        effTypeActual = (String)effTypeMap.get("actualValue");
	        slEffTypes.add(effType);
	%>     
	        currentEffTypesArr[cnt] = "<%=XSSUtil.encodeForJavaScript(context,effType)%>";
	        currentEffTypesArrActual[cnt] = "<%=XSSUtil.encodeForURL(context,effTypeActual)%>";
	        cnt++;
	<%    
	   }
	    
	   for (int idx=0; idx < relEffTypes.size(); idx++)
	   {
		   effRelMap = (Map)relEffTypes.get(idx);
	       effType = (String)effRelMap.get("displayValue");
	       effTypeActual = (String)effRelMap.get("actualValue");
	       if(!slEffTypes.contains(effType))
	       {
	    %>      
	         currentEffTypesArr[cnt] = "<%=XSSUtil.encodeForJavaScript(context,effType)%>";
	         currentEffTypesArrActual[cnt] = "<%=XSSUtil.encodeForURL(context,effTypeActual)%>";
	          cnt++;
	    <%  
	       }
	    }
	   noEffTypes = objEffTypes.size() + relEffTypes.size();
	}
				if (CFFExpressionListDisp != null) {%>
				currentEffExpr = "<%=XSSUtil.encodeForJavaScript(context,CFFExpressionListDisp)%>";
				<%}%>
				<%if (CFFExpressionListAc != null) {%>
				currentEffExprAc = "<%=XSSUtil.encodeForJavaScript(context,CFFExpressionListAc)%>";
				<%}%>
			    var displayExprField = parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.CFFExpressionFilterInput;
			    if(displayExprField)
			        currentEffExprDisp = displayExprField.value;
			    var actualExprListField = parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.CFFExpressionList;
			    if(actualExprListField)
			        currentEffExprAc = actualExprListField.value;
			    var displayExprListField = parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.CFFExpressionListDisp;
			    if(displayExprListField)
			        currentEffExpr = displayExprListField.value;
	
				<%}
if(("fromForm").equalsIgnoreCase(strInvockedFrom))
{
if(strFieldNameEffTypes!=null)
{%>
currentEffTypes = parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.<%=XSSUtil.encodeForJavaScript(context,strFieldNameEffTypes)%>;
<%}%>
<%
if(strFieldNameEffExprActual!=null)
{%>
currentEffExprActual = parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.<%=XSSUtil.encodeForJavaScript(context,strFieldNameEffExprActual)%>.value;
<%}%>
<%
if(strFieldNameEffExprDisplay!=null)
{%>
currentEffExprDisp = parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.<%=XSSUtil.encodeForJavaScript(context,strFieldNameEffExprDisplay)%>.value;
<%}%>
<%
if(strFieldNameEffExprList!=null)
{%>
currentEffExpr = parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.<%=XSSUtil.encodeForJavaScript(context,strFieldNameEffExprList)%>.value;
<%}%>
<%
if(strFieldNameEffExprListAc!=null)
{%>
currentEffExprAc = parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.<%=XSSUtil.encodeForJavaScript(context,strFieldNameEffExprListAc)%>.value;
<%}
}

if(!exprMap.isEmpty())
{
	String strAppDispExp_app = (String)exprMap.get("displayValue");
	String strAppActExp_app = (String)exprMap.get("actualValue");
	String strAppDispExp = (String)exprMap.get("listValue");
    //replace "[" with separator (between name and revision) defined in template .xlm for Display
    strAppDispExp = strAppDispExp.replace("[", prodNameRevSep);
    //replace "<" with resivion suffix defined in template .xlm for Display     
    if(!revSuffix.isEmpty()){
        strAppDispExp = strAppDispExp.replace("<", revSuffix);
    }
	String strAppActExp = (String)exprMap.get("listValueActual");
	%>
	currentEffExprDisp = "<%=XSSUtil.encodeForJavaScript(context,strAppDispExp_app)%>";
	currentEffExprActual = "<%=XSSUtil.encodeForJavaScript(context,strAppActExp_app)%>";
	currentEffExpr= "<%=XSSUtil.encodeForJavaScript(context,strAppDispExp)%>";
	currentEffExprAc= "<%=XSSUtil.encodeForJavaScript(context,strAppActExp)%>";
	<%
}

%>

var expArrAc = new Array();
var lstExpression;
var asdf = new Array();
var expArr = new Array();
var computeRule = "" ;
if(currentEffExpr != null)
{
    var currentEffExprList = currentEffExpr.split("@delimitter@");
}
if(currentEffExprList != null && currentEffExprList[0] != null)
{
	var idx = 0; 
    for (var i=0; i < currentEffExprList.length; i++ ) {
        	expArr[idx] = currentEffExprList[i];
            idx++;
    }
}
if(currentEffExprAc!=null)
{
    var currentEffExprListAc = currentEffExprAc.split("@delimitter@");
    if(currentEffExprListAc != null && currentEffExprListAc[0] != null)
    {
        var idx = 0; 
        for (var i=0; i < currentEffExprListAc.length; i++ ) {
            expArrAc[idx] = currentEffExprListAc[i];
                        idx++;
         }
    }
}
</script>

</head>
<body onload="getEffTypes();addSettingFields();displayEffTypes();formLeftExpApplicabilityDialog();computedRuleApplicabilityDialog();addKeyInDiv();mx_setHeightApplicabilityDialog();">
<div id = "keyInDiv" style="position:absolute;top:0px;left:0px;border:solid 1px black;z-index:10000;"></div>
<!-- check for mode and make this conditional add method getModeTypes()-->
<form action="" method="post" name="BCform">
<div id="pageHeadDiv">
    <table >
        <tr>
            <td class="page-title">
            <h2><emxUtil:i18n localize="i18nId">Effectivity.Label.EditApplicabilityDefinitionHeading</emxUtil:i18n></h2>

            <%
        
            if (strCtxName != null && strCtxName.length() > 0)
            {
            %>
                <h3><emxUtil:i18n localize="i18nId">Effectivity.Label.ApplicabilityExpressionSubHeading</emxUtil:i18n><%=strCtxType + " " + strCtxName + " " + strCtxRev%></h3>
            <%
            }
            %>
            </td>
            <td class="buttons">
              <table border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td><a href='javascript:openHelp("emxhelpeffectivityedit","effectivity","<%=XSSUtil.encodeForURL(context,lStr)%>","<%=XSSUtil.encodeForURL(context,langOnlineStr)%>")'><img src="../common/images/iconActionHelp.gif" width="16" height="16" border="0"  alt="<emxUtil:i18n localize="i18nId">Effectivity.Button.Help</emxUtil:i18n>" /></a></td>
                    <td><input type="button" name="validate" value="<emxUtil:i18n localize="i18nId">Effectivity.Button.Validate</emxUtil:i18n>" class="mx_btn-validate" onClick="fnValidate();" /></td>
                    <td><input type="submit" name="done" value="<emxUtil:i18n localize="i18nId">Effectivity.Common.Done</emxUtil:i18n>" class="mx_btn-done" onclick="computedRuleApplicabilityDialog('','left');submitRule();return false" /></td>
                    <td><input type="button" name="cancel" value="<emxUtil:i18n localize="i18nId">Effectivity.Button.Cancel</emxUtil:i18n>" class="mx_btn-cancel" onClick="JavaScript:getTopWindow().window.close();" /></td>
                  </tr>
              </table>
            </td>
        </tr>
    </table>
<!-- end #mx_divPageHead -->
</div>
<div id="mx_divPageBody">
<div id="mx_divContent">
  <div id="mx_divSource">
    <div id="mx_divFilter">
	    <h1><emxUtil:i18n localize="i18nId">Effectivity.Label.ApplicabilitySelector</emxUtil:i18n>
	</h1>
        <table>
            <tbody>
                <tr>
                    <td><div id="mx_divFilter1"></div></td>
                    <td><div id="mx_divFilter2"></div></td>
                </tr>
            </tbody>
        </table>
    </div>
    <div id="mx_divSourceList">
    </div>
  <!-- end #mx_divSource -->
  </div>
  <div id="mx_divExpression">
    <div class="mx_expression">
        <!-- if this is the only expression module present, the title should reflect the rule/expression type -->
        <div id="mx_divRuleLeft">
			<h1><emxUtil:i18n localize="i18nId">Effectivity.Form.Label.ApplicabilityExpression</emxUtil:i18n></h1>
			<div id="RuleLeft">
				  <img src="../common/images/iconActionNewWindow.gif" onClick=" showRuleLeftDialog()"/>
			</div>
        </div>

        <table class="mx_expression" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>
                <div id="mx_divObjectManipulation">
                                        <div class="mx_button"><a href="#" onclick="removeApplicabilityDialog('left'),computedRuleApplicabilityDialog('','left')" class="mx_button-remove" title="<emxUtil:i18n localize="i18nId">Effectivity.Button.Remove</emxUtil:i18n>"><img src="../common/images/utilSpacer.gif" border="0" /></a></div>
                    <div class="mx_button"><a href="#" onclick="insertFeatureOptionsApplicabilityDialog('left'),computedRuleApplicabilityDialog('','left')" class="mx_button-insert" title="<emxUtil:i18n localize="i18nId">Effectivity.Button.Insert</emxUtil:i18n>"><img src="../common/images/utilSpacer.gif" border="0" /></a></div>
                    <div class="mx_button"><a href="#"  onclick="moveUp('left'),computedRuleApplicabilityDialog('','left')" class="mx_button-move-up" title="<emxUtil:i18n localize="i18nId">Effectivity.Button.MoveUp</emxUtil:i18n>"><img src="../common/images/utilSpacer.gif" border="0" /></a></div>
                    <div class="mx_button"><a href="#" onclick="moveDown('left'),computedRuleApplicabilityDialog('','left')" class="mx_button-move-down" title="<emxUtil:i18n localize="i18nId">Effectivity.Button.MoveDown</emxUtil:i18n>"><img src="../common/images/utilSpacer.gif" border="0" /></a></div>
                    <div class="mx_button mx_separator"><img src="../common/images/utilSpacer.gif" border="0" /></div>
                    <div class="mx_button"><a href="#" onClick="clearAllApplicabilityDialog('left'),computedRuleApplicabilityDialog('','left')" class="mx_button-clear" title="<emxUtil:i18n localize="i18nId">Effectivity.Button.ClearExpression</emxUtil:i18n>"><img src="../common/images/utilSpacer.gif" border="0" /></a></div>
                    <div class="mx_clear-floats"></div>
                </div>
            </td>
            <td><table id = "operatorsTable" class="mx_operators" border="0" cellpadding="0" cellspacing="0">
              <tr>
              
                <td>
                <% if(!bApplicabilityMode){%>
                <input type="button" name="l-paren" value="(" onclick='operatorInsert("(","left"),computedRuleApplicabilityDialog("(","left")' />
                <%
                }
                	if (bShowOrCommandLine)
                	{
                %>
                  <input type="button" id="or" name="or" value="OR" onclick='operatorInsert("OR","left"),computedRuleApplicabilityDialog("OR","left")' />
                 <%}
                	  if(!bApplicabilityMode){
                	%>                  
                
                  <input type="button" name="r-paren" id="r-paren" value=")" onclick='operatorInsert(")","left"),computedRuleApplicabilityDialog(")","left")' />
                  
                  <input type="button" name="infinity" value=<%=XSSUtil.encodeForHTMLAttribute(context,infinitySymbolDisp)%> onclick='insertInfinity(),computedRuleApplicabilityDialog(")","left")' />
                  <% } %>
                  </td>                  
                 </tr>
                </table>
              <div id="divSelect" style="overflow:auto;width:280px;height:122px;margin:0;"  oncontextmenu="return false" onscroll="OnDivScroll();">
                 <select size="10" name="LeftExpression" id="IncExp" style="width:550px;" multiple  oncontextmenu="return false" onfocus="OnSelectFocus();" onchange="resetKeyInDiv();"></select>
                 <iframe id="helper" src="javascript:'&lt;html&gt;&lt;/html&gt;';" scrolling="no" frameborder="0" 
  style="position:absolute;width:50px;height:120px;top:0px;left:0px;"></iframe> 
                 
            </div>
            </td>
          </tr>
        </table>
    <!-- end .mx_expression -->
    </div>

    <div id="mx_divCompletedRule" >     
        <h1><emxUtil:i18n localize="i18nId">Effectivity.Label.CompletedExpression </emxUtil:i18n>
        </h1>
        
        <div id="RuleComplete"> 
        <img src="../common/images/iconActionNewWindow.gif" onClick="showRuleCompleteDialog()"/>    
        </div>
        <div id="mx_divRuleText" style = "word-wrap:break-word;"><!-- end #mx_divRuleText -->    </div>
    <!-- end #mx_divCompletedRule s-->
    </div>
    <!-- end #mx_divCompletedRule s-->
    </div>

  <!-- end #mx_divExpression -->
  </div>
<!-- end #mx_divContent -->
</div>
<!-- end #mx_divPageBody -->
</div>

<input type="hidden" name="completedRuleText" value="" />
<input type="hidden" name="completedRuleActual" value="" />
<input type="hidden" name="completedRuleTextList" value="" />
<input type="hidden" name="completedRuleActualList" value="" />
<input type="hidden" name="leftExpObjectExpObjIds" value="" />
<input type="hidden" name="leftExpObjectExp" value="" />
<input type="hidden" name="compatibilityType" id="compatibilityType" value="" />
<input type="hidden" name="featureType" value="" />
<input type="hidden" name="hLeftExp" value="" />
<input type="hidden" name="txtObjectId" value="<%=XSSUtil.encodeForHTMLAttribute(context,strincruleID) %>" />
<input type="hidden" name="txtParentObjectId" value="<%=XSSUtil.encodeForHTMLAttribute(context,strParentOID) %>" />
<input type="hidden" name="txtProductObjectId" value="<%=XSSUtil.encodeForHTMLAttribute(context,strProductID1) %>" />
<input type="hidden" name="txtContextPage" value="<%=XSSUtil.encodeForHTMLAttribute(context,strContextPage) %>" />
<input type="hidden" name="txtFeatureOId" value="<%=XSSUtil.encodeForHTMLAttribute(context,strObjectId)%>" />
 <input type="hidden" name="txtRootType" id="txtRootType" value="<%=XSSUtil.encodeForHTMLAttribute(context,strRootType)%>" />
<input type="hidden" name="invockedfromfield" value="<%=XSSUtil.encodeForHTMLAttribute(context,strInvockedFrom) %>" />
<!-- Mode Field on Effectivity Definition Dialog  -->>
<%
	


  if((strmode.compareTo("create")==0))  {%>

	<input type="hidden" name="txtObjectId" value="<%=XSSUtil.encodeForHTMLAttribute(context,strContextObjectId)%>" />

<% } 
  if((strmode.compareTo("edit")==0))  {%>

	<input type="hidden" name="txtObjectId" value="<%=XSSUtil.encodeForHTMLAttribute(context,strObjectId) %>" />

<% } %>

</form>


<script type="text/javascript" Language="Javascript">
function addSettingFields()
{
    if(currentEffTypesArrActual != null && currentEffTypesArrActual[0] != null)
    {
        for (var i=0; i < currentEffTypesArrActual.length; i++ ) 
        {
            var settingFieldName = "EffSettingsField_" + currentEffTypesArrActual[i];
            var element = document.createElement("input");
            element.setAttribute("type", "hidden");
            element.setAttribute("name", settingFieldName);
            element.setAttribute("id", settingFieldName);
            var jsonString = "";
            var URL = "../effectivity/EffectivityServices.jsp?mode=getSettings&effActual="+currentEffTypesArrActual[i];
            jsonString = emxUICore.getData(URL);
            element.setAttribute("value", jsonString);
            document.BCform.appendChild(element);            
        }
    }
}

function getEffTypes()
{
    var idx = 0; 
    if (typeof(currentEffTypes)=='undefined')
    {
        return;
    }
    if(currentEffTypes != null && currentEffTypes[0] != null)
    {
        for (var i=0; i < currentEffTypes.length; i++ ) {
            if (currentEffTypes[i].checked) {   
                var displayActual = currentEffTypes[i].value.split("@displayactual@");
                currentEffTypesArrActual[idx] = displayActual[0];
                currentEffTypesArr[idx] = displayActual[1];
                idx++;
            }
        }
    }
    else
    {   
        if (currentEffTypes.checked) {
            var displayActual = currentEffTypes.value.split("@displayactual@");
            currentEffTypesArrActual[0] = displayActual[0];
            currentEffTypesArr[0] = displayActual[1];
        }
    }    
}

function selectorTable(divEl){
    var vSelected = document.getElementById('typeSelector_mx_divFilter1').selectedIndex;
    var vDisplayType=document.getElementById('typeSelector_mx_divFilter1').options[vSelected].text;
    var vActualType = document.getElementById('typeSelector_mx_divFilter1').options[vSelected].value;
    var vformatType = getEffSetting("<%=XSSUtil.encodeForHTMLAttribute(context,EffectivitySettingsManager.CMD_SETTING_FORMAT)%>", vActualType);
    displayOperatorEffTypeSetting(vActualType);
    var target = document.getElementById("mx_divSourceList");   
    var optionResponse = "";
    var vFieldName;
    var expDisplayField;
    //show search icon
    document.getElementById("searchType").style.display = 'block';
    document.getElementById("searchType").style.visibility = 'hidden';
   //TODO: Empty Checks
    if(vformatType=="date")
    {
        //hide search icon
        document.getElementById("searchType").style.display = 'none';
        expDisplayField =  "<%=i18nStringNowUtil("Effectivity.EffectivityType.Date", bundle,acceptLanguage)%> ";
        var element = document.createElement("table");
        //target.removeElement(element);        
        element.cellpadding = 0;
        element.cellspacing = 0;
        optionResponse = "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">";
        optionResponse = optionResponse + "</table>";
        var input1=createNamedElement("table",vFieldName);
        target.innerHTML = optionResponse;
        target.appendChild(element);  
        lastDateIndex = 0;
        for(var i=1; i<=2; i++) 
        {
            insertDateField(i);
            updateDateFieldArray(i-1, vFieldName);
        }       
                       
        
    }
    if(vformatType=="list")
    {
        //show search icon
       document.getElementById("searchType").style.display = 'block';
       optionResponse = "<iframe  name=\"EffectivitySourceList\" src=\"javascript:'&lt;html&gt;&lt;/html&gt;';\" id=\"EffectivitySourceList\" height=\"100%\" width=\"100%\"></iframe>";
       target.innerHTML = optionResponse;        
    }

    if(vformatType=="structure")
    {
        //show search icon
       document.getElementById("searchType").style.display = 'block';
       optionResponse = "<iframe  name=\"EffectivitySourceList\" id=\"EffectivitySourceList\" height=\"100%\" width=\"100%\"></iframe>";
       target.innerHTML = optionResponse;  
    }
    
    if(vformatType=="structure")
    {
    
     expandStructureMode();   
    }   
    insertAsRange();

}
function giveAlert(alertFlag,keyIn)
{
    if(alertFlag == "INVALID_LE")
    {
        alert("<%=i18nStringNowUtil("Effectivity.LeftExpression.Invalid", bundle,acceptLanguage)%>");
    }
    else if(alertFlag == "RANGE_VALIDATION")
    {
        alert("<%=i18nStringNowUtil("Effectivity.Validation.ValidateRangeAlert", bundle,acceptLanguage)%>");
    }
    else if(alertFlag == "USER_SELECTION")
    {
        alert("<%=i18nStringNowUtil("Effectivity.Validation.UserSelectionRequirement", bundle,acceptLanguage)%>");
    }
    else if(alertFlag == "INVALID_DATE_RANGE")
    {
        alert("<%=i18nStringNowUtil("Effectivity.Validation.InvalidDateRange", bundle,acceptLanguage)%>");
    }
    else if(alertFlag == "INVALID_UNIT_RANGE")
    {
        alert("<%=i18nStringNowUtil("Effectivity.Validation.InvalidUnitRange", bundle,acceptLanguage)%>");
    }
    else if(alertFlag == "DATE_FIELD_DELETION_RESTRICT")
    {
    	alert("<%=i18nStringNowUtil("Effectivity.Validation.RowDeletionNotPermitted", bundle,acceptLanguage)%>");
    }
    else if(alertFlag == "REQUEST_DATE_SELECTION")
    {
        alert("<%=i18nStringNowUtil("Effectivity.Validation.RequestDateSelection", bundle,acceptLanguage)%>");
    }
    else if(alertFlag == "END_DATE_BEFORE_START_DATE")
    {
        alert("<%=i18nStringNowUtil("Effectivity.Validation.EndBeforeStart", bundle,acceptLanguage)%>");
    }
    else if(alertFlag == "INVALID_INFINITY")
    {
        alert("<%=i18nStringNowUtil("Effectivity.Validation.Infinity", bundle,acceptLanguage)%>");
    }
    else if(alertFlag == "ELEMENT_SELECTION")
    {
        alert("<%=i18nStringNowUtil("Effectivity.Request.Selection", bundle,acceptLanguage)%>");
    }
    else if(alertFlag == "SEQUENCE_VALIDATION_FAILED")
    {
        alert("<%=i18nStringNowUtil("Effectivity.Validation.Failure", bundle,acceptLanguage)%>");
    }
    else if(alertFlag == "KEYIN_INFINITY_AS_SEQUENCE_VALUE")
    {
        alert("<%=i18nStringNowUtil("Effectivity.KeyinValidation.InfinitySymbolSequence",bundle,acceptLanguage)%>");
    }
    else if(alertFlag == "KEYIN_NOT_VALID_INTEGER_KEYWORD")
    {
        var temp = "<%=i18nStringNowUtil("Effectivity.KeyinValidation.InvalidIntKeyword",bundle,acceptLanguage)%>";
        temp += keyIn;
        alert(temp);
    }
    else if(alertFlag == "KEYIN_NO_GREATER_THAN_ZERO")
    {
        alert("<%=i18nStringNowUtil("Effectivity.KeyinValidation.NoGreaterThanZero",bundle,acceptLanguage)%>");
    }
    else if(alertFlag == "START_RANGE_GREATER_END_RANGE")
    {
        alert("<%=i18nStringNowUtil("Effectivity.KeyinValidation.StartLessThanEnd",bundle,acceptLanguage)%>");
    }
    else if(alertFlag == "KEYIN_EMPTY_VALUE_ENETERED")
    {
        alert("<%=i18nStringNowUtil("Effectivity.KeyinValidation.EmptyValue",bundle,acceptLanguage)%>");
    }
    else if(alertFlag == "USER_SELECTION_LIST")
    {
        alert("<%=i18nStringNowUtil("Effectivity.List.UserSelectionRequirement", bundle,acceptLanguage)%>");
    }
    else if(alertFlag == "KEYIN_INFINITY_AS_START_SEQUENCE_VALUE")
    {
    	alert("<%=i18nStringNowUtil("Effectivity.KeyinValidation.InfinitySymbolSequenceStart",bundle,acceptLanguage)%>");
    }
}
function setEffectivityType1() {
    var target = document.getElementById("mx_divFilter");
    var typeLabel =  "<%=i18nStringNowUtil("Effectivity.Label.Type", bundle,acceptLanguage)%> ";
    var insertAsRangeLabel =  "<%=i18nStringNowUtil("Effectivity.Label.InsertAsRange", bundle,acceptLanguage)%> ";
    var optionResponse = "";
    optionResponse = "<table border=\"0\" class=\"mx_filter\" cellpadding=\"0\" cellspacing=\"0\">";
    optionResponse = optionResponse + "<tr>";
    optionResponse = optionResponse + "<td>" + typeLabel + "</td>";
    optionResponse = optionResponse + "<td>";
    optionResponse = optionResponse + "<select name=\"typeSelector\" id=\"typeSelector\" onchange=\"selectorTable();\">";                         
    //TODO need to handle translations
    for (var i=0; i < currentEffTypesArr.length ; i++) 
    {
        optionResponse = optionResponse + "<option value=\"" + currentEffTypesArr[i] + "\">" + currentEffTypesArr[i] + "</option>";
    }
    optionResponse = optionResponse + "</select>";
    optionResponse = optionResponse + "</td>";
    optionResponse = optionResponse + "<td><a name = \"searchType\" id=\"searchType\" href=\"\"><img src=\"../common/images/iconActionSearch.gif\" border=\"0\" onclick=\"javascript:setContext();\" /></a></td>";
    optionResponse = optionResponse + "</tr>";
    optionResponse = optionResponse + "<tr>";
    optionResponse = optionResponse + "<td><input name=\"insertAsRange\" id=\"insertAsRange\" type=\"checkbox\" />";
    optionResponse = optionResponse + insertAsRangeLabel + "</td>";
    optionResponse = optionResponse + "</tr>";
    optionResponse = optionResponse + "</table>";

    target.innerHTML = optionResponse.toString();   
}


function displayOperatorEffTypeSetting(vActualType)
{
	var showOr = getEffSetting("<%=XSSUtil.encodeForJavaScript(context,EffectivitySettingsManager.CMD_SETTING_SHOWOR)%>", vActualType);
	var showAnd = getEffSetting("<%=XSSUtil.encodeForJavaScript(context,EffectivitySettingsManager.CMD_SETTING_SHOWAND)%>", vActualType);
	var showInf = getEffSetting("<%=XSSUtil.encodeForJavaScript(context,EffectivitySettingsManager.CMD_SETTING_SHOWINF)%>", vActualType);
	
	if(showAndCommandLine == 'undefined' || showAndCommandLine == null || showAndCommandLine == "null")
	{
		var andButton  = document.getElementById("and");
		if(andButton)
		{
		 if(showAnd != null && showAnd == "false")
		 {
			 andButton.disabled=true;
		 }
		 else
		 {
			 andButton.disabled=false;
		 }
	}
	}
	if(showOrCommandLine == 'undefined' || showOrCommandLine == null || showOrCommandLine == "null")
	{
	      var orButton  = document.getElementById("or");
	      if(orButton)
	      {
	      if(showOr != null && showOr == "false")
	      {
	          orButton.disabled=true;
	      }
	      else
	      {
	          orButton.disabled=false;
	       }
	    }
	}
	
	if(showInfCommandLine == 'undefined' || showInfCommandLine == null || showInfCommandLine == "null")
	{
		var infButton  = document.getElementById("infinity");

		if(infButton)
		{
			if(showInf != null && showInf == "false")
		    {
				infButton.disabled=true;
				infButton.style.visibility='hidden';
		    }
		    else
		    {
		    	infButton.disabled=false;
		        infButton.style.visibility='visible';
		    }
		}
     }
}
                       
function setContext(divEl){

//get selected Type
	var vSelected = document.getElementById('typeSelector_mx_divFilter1').selectedIndex;
	var vDisplayType=document.getElementById('typeSelector_mx_divFilter1').options[vSelected].text;
	var vActualType = document.getElementById('typeSelector_mx_divFilter1').options[vSelected].value;
    var searchType = getEffSetting("<%=XSSUtil.encodeForURL(context,EffectivitySettingsManager.CMD_SETTING_SEARCHTYPE)%>", vActualType);
	var vformatType = getEffSetting("<%=XSSUtil.encodeForURL(context,EffectivitySettingsManager.CMD_SETTING_FORMAT)%>", vActualType);
	var vcategoryType = getEffSetting("<%=XSSUtil.encodeForURL(context,EffectivitySettingsManager.CMD_SETTING_CATEGORYTYPE)%>", vActualType);
	var expandProgram = getEffSetting("<%=XSSUtil.encodeForURL(context,EffectivitySettingsManager.CMD_SETTING_EXPANDPROGRAM)%>", vActualType);
	var selectorToolbar = "";
    var vExpandParam = "";
    var vSelectorToolbar = "";
    var selection = getEffSetting("<%=XSSUtil.encodeForURL(context,EffectivitySettingsManager.CMD_SETTING_SELECTION)%>", vActualType);
    var defnTable = getEffSetting("<%=XSSUtil.encodeForURL(context,EffectivitySettingsManager.CMD_SETTING_TABLE)%>", vActualType);
  
    if (selectorToolbar != "" && selectorToolbar != null && selectorToolbar != "null") 
    {
    	vSelectorToolbar = "" + selectorToolbar;
    }
    
    if (expandProgram != "" && expandProgram != null && expandProgram != "null") //expandProgram takes presidence
    {
        vExpandParam = "&expandProgramCFF=" + expandProgram;
    }
    else //if expandProgram not there, then use relationship
    {
 	    expandProgram = getEffSetting("<%=XSSUtil.encodeForURL(context,EffectivitySettingsManager.CMD_SETTING_RELATIONSHIP)%>", vActualType);
        if (expandProgram != "" && expandProgram != null && expandProgram != "null")
        {
            vExpandParam = "&relationshipCFF=" + expandProgram;
        }        
    }
    var vCategoryTypeParam = "&categoryType=" + vcategoryType; 
    var vFormatParam = "&formatType=" + vformatType;
    var vCffTable ="&cffTable="+defnTable;
    var vEffectivtyType = "&effectivityType=" + vActualType;
    var vSelection = "&CFFselection=" + selection;
    if (searchType!=null && searchType!="")
    {
		var sURL='../common/emxFullSearch.jsp?field=TYPES=' + searchType + '&table=AEFGeneralSearchResults&selection=multiple&formName=BCform&submitAction=refreshCaller&hideHeader=true&HelpMarker=emxhelpfullsearch&submitURL=../effectivity/EffectivityDefinitionSearch.jsp?' + vFormatParam + vExpandParam + vSelection + vEffectivtyType + vCffTable + vSelectorToolbar + vCategoryTypeParam;
		showChooser(sURL, 850, 630);
	}
}

//reading  rule Expression  length from properties file
var ruleExpressionLength = "<%= EnoviaResourceBundle.getProperty(context,"emxEffectivity.RuleDialogExpression.Expression.Length")%>";
//for leftExpression textArea onmouse Dialog
function showRuleLeftDialog()
{
	var selectedDiv = "";	
	var divId;
	var exp;	
	var expression = new Array;
	var textArea;
	if(document.getElementById("IncExp").options.length != 0 )
	{
	document.BCform.LeftExpression.style.visibility="hidden";
	  divId = "RuleLeft";
	  textArea="leftEx";
    for(var i=0; i<document.getElementById("IncExp").options.length; i++) 
    {
	exp = document.getElementById("IncExp").options[i].text;	
 	if(exp.length>ruleExpressionLength)
	{
	var value;	
	while(true)
	{	
	value = exp.substr(0,ruleExpressionLength);
	expression.push(value);
	expression.push("\n");
	exp = exp.substr(ruleExpressionLength);

	if(exp.length<ruleExpressionLength)
	{
	expression.push(exp);
	expression.push("\n");
	 break;
	}
	else
	{
	 continue;
	}
	
	}	
	
	}else{ 	
 	expression.push(exp); 	
 	expression.push("\n");
    } 	
    } 	
	displayOptionRuleExpression(expression, divId,textArea)	;	
	}
}
	
//for completed Rule textArea onmouse Dialog	
function showRuleCompleteDialog()
{	
	var textArea;	
	var expression = new Array;		
	var expressionValue ;		
	if(document.getElementById("IncExp").options.length != 0 )
	{
	divId = "RuleComplete";
	textArea="comRule";
	var objDIV = document.getElementById("mx_divRuleText"); 
	computeRule = objDIV.innerHTML;
	expressionValue = computeRule.toString();	
	if(expressionValue.length>ruleExpressionLength)
	{	
	var value;	
	while(true)
	{	
	value = expressionValue.substr(0,ruleExpressionLength);			
	expression.push(value);
	expression.push("\n");
	expressionValue = expressionValue.substr(ruleExpressionLength);
	if(expressionValue.length<ruleExpressionLength)
	{
	expression.push(expressionValue);
	expression.push("\n");
	 break;
	}
	else
	{
	 continue;
	}
	
	}	
	
	}
	else{			
    expression.push(expressionValue);  	
    }
	displayOptionRuleExpression( expression, divId,textArea);	
	}
}

 function displayOptionRuleExpression(exp, divID,textArea)
	{  

   	var target = document.getElementById(divID);	
    var optionResponse;
    var expression = new Array();
    var expValue;
    var  ruletxArea =textArea;
    var ruleExpValue;
    var header = "<%=i18nStringNowUtil("Effectivity.Label.RuleExpressionDialog", bundle,acceptLanguage)%> ";
     
    if(ruletxArea=="leftEx")
    {
    expValue =  "<%=i18nStringNowUtil("emxFramework.Label.Left_Expression", bundle,acceptLanguage)%> ";
    }	
    if(ruletxArea=="comRule")
    {
    expValue = "<%=i18nStringNowUtil("Effectivity.Label.CompletedRule", bundle,acceptLanguage)%> ";
    }

   
    ruleExpValue = exp.join("");
  
 expression.push("<span onclick=retainValue('"+divID+"')><html><head></head><body><div id=\"mx_divLayerDialog\" class=\"mx_option-details \" ><div id=\"mx_divLayerDialogHeader\">" +
            	"<h1><NOBR>"+header+"</NOBR> </h1></div><div id=\"mx_divLayerDialogBody\">" +
				"<div class=\"mx_option-detail context\" ><table BGCOLOR=FFFFCC >"+
				"<tr><td><h1> <NOBR>"+ expValue+"</NOBR></h1></td></tr>"+
				"<tr><td>"+ruleExpValue+"</td></tr>"+			
				"</table></div>");
	optionResponse = expression;
	target.innerHTML = optionResponse;	
}	
 function retainValue(divID)
 {
 	var target = document.getElementById(divID);	
	var funName;
 	if(divID=="RuleLeft")
 	{
 	document.BCform.LeftExpression.style.visibility="visible";
 	funName ="showRuleLeftDialog()";
 	} 	
 	if(divID=="RuleComplete")
 	{
 	funName ="showRuleCompleteDialog()";
 	}
 	
 	htmlText = "<img src=\"../common/images/iconActionNewWindow.gif\"  onClick="+funName+" />"; 	
 	target.innerHTML = htmlText;
 }
 
 
 var arrNoOfObjs = new Array;
  arrNoOfObjs[0] = 0 ;
 function callback(levelsExpanded  ){
 
		var noOfObjs = 0 ; 
		
		if( arrNoOfObjs.length == 1 ){
			noOfObjs = 0 ; 
		}else if( levelsExpanded == arrNoOfObjs.length ){
			noOfObjs = 0 ; 		
		}else{

			noOfObjs = arrNoOfObjs[levelsExpanded];
		}
	
		//var noOfObjs = arrNoOfObjs[levelsExpanded];
		
		arrNoOfObjs[levelsExpanded] =  noOfObjs+1 ; 
		
		//alert("arrNoOfObjs "+arrNoOfObjs);
		
		spanRowCounter = document.getElementById("mx_spanRowCounter");
        levelCounter = document.getElementById("mx_spanlevelCounter");
        
        if (isIE) {
        	levelCounter.innerText = " " + levelsExpanded + " " + emxUIConstants.STR_OBJMSG2 + ": ";
            spanRowCounter.innerText = arrNoOfObjs[levelsExpanded];
            
         }
         else {
         		levelCounter.textContent = " " + levelsExpanded  + " " + emxUIConstants.STR_OBJMSG2 + ": ";
	            spanRowCounter.textContent = arrNoOfObjs[levelsExpanded];
			}
			
 }
 
 //arrNoOfObjs = [];
 
	 var dialogLayerOuterDiv, dialogLayerInnerDiv, objTable1, iframeEl;
   
    function addMask()
    {
    
    try{ 
        spanRowCounter = null;
        levelCounter = null;
        dialogLayerOuterDiv = document.createElement("div");
        dialogLayerOuterDiv.className = "mx_divLayerDialogMask";
        document.body.appendChild(dialogLayerOuterDiv);
    
        if (isIE) {
            iframeEl = document.createElement("IFRAME");
            iframeEl.frameBorder = 0;
            iframeEl.src = "javascript:;";
            iframeEl.className = "hider";
            document.body.insertBefore(iframeEl, dialogLayerOuterDiv);
        }
        dialogLayerInnerDiv = document.createElement("div");
        dialogLayerInnerDiv.className = "mx_alert";
        dialogLayerInnerDiv.setAttribute("id", "mx_divLayerDialog");
        

		var sourceListTop = document.getElementById('mx_divSourceList').offsetTop;	
	    
        dialogLayerInnerDiv.style.top = sourceListTop ;
        dialogLayerInnerDiv.style.left = emxUICore.getWindowWidth()/3 + "px"; 
        
        document.body.appendChild(dialogLayerInnerDiv);
        
        var divLayerDialogHeader = document.createElement("div");
        divLayerDialogHeader.setAttribute("id", "mx_divLayerDialogHeader");
        if(isIE) {
            divLayerDialogHeader.innerText = emxUIConstants.STR_EXPAND_HEADERNSG1;
        }else {
            divLayerDialogHeader.textContent = emxUIConstants.STR_EXPAND_HEADERNSG1;
        }
        
        var divLayerDialogBody = document.createElement("div");
        divLayerDialogBody.setAttribute("id", "mx_divLayerDialogBody");
        
        var paraElement1 = document.createElement("p");
        if(isIE) {
            paraElement1.innerText = emxUIConstants.STR_OBJMSG1;
        }else {
            paraElement1.textContent = emxUIConstants.STR_OBJMSG1;
        }

        var spanElement1 = document.createElement("span");
        spanElement1.className = "mx_rows-retrieved";
        spanElement1.setAttribute("id", "mx_spanRowCounter");
        var spanElement2 = document.createElement("span");
        spanElement2.setAttribute("id", "mx_spanlevelCounter");

        paraElement1.appendChild(spanElement2);
        paraElement1.appendChild(spanElement1);

        var paraElement2 = document.createElement("p");
        paraElement2.className = "mx_processing-message";

        if(isIE) {
            paraElement2.innerText = emxUIConstants.STR_EXPAND_WAIT;
        }else {
            paraElement2.textContent = emxUIConstants.STR_EXPAND_WAIT;
        }

        divLayerDialogBody.appendChild(paraElement1);
        divLayerDialogBody.appendChild(paraElement2);

        var divLayerDialogFooter = document.createElement("div");
        divLayerDialogFooter.setAttribute("id", "mx_divLayerDialogFooter");

  	/*    var stopBtn = document.createElement("input");
        stopBtn.setAttribute("type", "button");
        stopBtn.setAttribute("id", "stopBtn");
        stopBtn.setAttribute("value", emxUIConstants.STR_EXPAND_STOP);
        stopBtn.onclick = function () {
        							alert("Inside Stop ")	 ; 
                                    stopBtn.setAttribute("disabled", "true");
                                    if(isIE) {
                                        divLayerDialogHeader.innerText = emxUIConstants.STR_EXPAND_HEADERNSG2;
                                        paraElement2.innerText = emxUIConstants.STR_EXPAND_ABORTED1 + " " + (levelsExpanded + 1) + " " + emxUIConstants.STR_EXPAND_ABORTED2;
                                    }else {
                                        divLayerDialogHeader.textContent = emxUIConstants.STR_EXPAND_HEADERNSG2;
                                        paraElement2.textContent = emxUIConstants.STR_EXPAND_ABORTED1 + " " + (levelsExpanded + 1) + " " + emxUIConstants.STR_EXPAND_ABORTED2;
                                    }
                                     setTimeout("removeMask()", 1);
                                 
                      };
*/
        objTable1 = document.createElement("table");
        objTable1.border = 0;
        objTable1.cellPadding = 0;
        objTable1.cellSpacing = 0;

        var objTBody = document.createElement("tbody");
        var objTR = document.createElement("tr");
   //     var objCol = document.createElement("td");
        divLayerDialogFooter.appendChild(objTable1);
        objTable1.appendChild(objTBody);
        objTBody.appendChild(objTR);
  //     objCol.appendChild(stopBtn);
   //    objTR.appendChild(objCol);

        dialogLayerInnerDiv.appendChild(divLayerDialogHeader);
        dialogLayerInnerDiv.appendChild(divLayerDialogBody);
        dialogLayerInnerDiv.appendChild(divLayerDialogFooter);
        
        }catch(exec ){
        	//alert(exec);
        }

    }
    
	function removeMask(){
//	alert("Inside remove Mask ");
        document.body.removeChild(dialogLayerInnerDiv);
        document.body.removeChild(dialogLayerOuterDiv);
        if (isIE)
        {
            document.body.removeChild(iframeEl);
        }
		arrNoOfObjs = new Array;
		arrNoOfObjs[0] = 0 ;
    }

function callPostProcessURL()
{
	
	//if(!postProcessURL)
	//{
	//	finalSubmit();
	//	return;
	//}
	var params = getPostProcessURLParams();
	var postProcessURLWithParams = postProcessURL;
    //if(params!="")
    //    postProcessURLWithParams+="?"+params;
	//Next Gen-Starts--commented below for Next Gen
    var sHTML = emxUICore.getDataPost(postProcessURLWithParams, params);
    //showPostProcessURLPopup(postProcessURLWithParams);
	
    /*--Commented for Next Gen*/
	if(sHTML != "")
		showPostProcessURLPopup(sHTML);
    else
        finalSubmit();
    /*Next Gen-Ends */

}

function getPostProcessURLParams()
{
	var Params = "";
    var mode = "<%=XSSUtil.encodeForJavaScript(context,strmode)%>";
     var contextModelId = "<%=XSSUtil.encodeForJavaScript(context,tempObjectId)%>";
	var actualExpression = document.BCform.completedRuleActual.value;

	if(actualExpression!="")
	{
	    Params+="actualExpression="+actualExpression;

	var displayExpression = document.BCform.completedRuleText.value;

	if(displayExpression!="");
	Params+="&displayExpression="+displayExpression;
	if(selectedAppObj)
		Params+="&applicabilityObjs="+selectedAppObj.toJSONString()
	}
	if(mode!=null)
	{
		Params+="&modetype=<%=XSSUtil.encodeForJavaScript(context,strmode)%>";
    }
 if(contextModelId != null){
        Params+="&contextModelId="+contextModelId;
	}
	<%
    StringBuffer parametersBuffer = new StringBuffer();
    Map parameters = request.getParameterMap();
    java.util.Set keys = parameters.keySet();
    Iterator keysItr = keys.iterator();
    while (keysItr.hasNext()) {
        String key = (String) keysItr.next();
        String value[] = (String[])parameters.get(key);
              
        if (parametersBuffer!=null && !parametersBuffer.toString().isEmpty()) {
            parametersBuffer.append("&");
        }
        if (key.equalsIgnoreCase("suiteKey")) {
        	parametersBuffer.append(key + "=" + "EnterpriseChange");
        } else if (key.equalsIgnoreCase("SuiteDirectory")) {
        	parametersBuffer.append(key + "=" + "enterprisechange");
        } else if (key.equalsIgnoreCase("StringResourceFileId")) {
        	parametersBuffer.append(key + "=" + "emxEnterpriseChangeStringResource");
        } else if (key.equalsIgnoreCase("fieldValues")){
        } else if(key.equalsIgnoreCase("modeType")){
        	parametersBuffer.append(key + "=" + XSSUtil.encodeForURL(context,strmode));
        }else if(key.equalsIgnoreCase("changeDiscipline")){
        	parametersBuffer.append(key + "=" + XSSUtil.encodeForURL(context,strChangeDiscipline));
        }else if(key.equalsIgnoreCase("effectivityTypes")){
        	parametersBuffer.append(key + "=" + XSSUtil.encodeForURL(context,tempEffectivityTypes));
        }else if(key.equalsIgnoreCase("languageStr")){
        	parametersBuffer.append(key + "=" + XSSUtil.encodeForURL(context,value[0]));
        }else if(key.equalsIgnoreCase("rowRelId")){
        	parametersBuffer.append(key + "=" + XSSUtil.encodeForURL(context,value[0]));
        }else if(key.equalsIgnoreCase("relId")){
        	parametersBuffer.append(key + "=" + XSSUtil.encodeForURL(context,value[0]));
        }else if(key.equalsIgnoreCase("fieldName")){
        	parametersBuffer.append(key + "=" + XSSUtil.encodeForURL(context,value[0]));
        }else if(key.equalsIgnoreCase("fieldNameActual")){
        	parametersBuffer.append(key + "=" + XSSUtil.encodeForURL(context,value[0]));
        }else if(key.equalsIgnoreCase("fieldValues")){
        	parametersBuffer.append(key + "=" + XSSUtil.encodeForURL(context,value[0]));
        }else if(key.equalsIgnoreCase("level")){
        	parametersBuffer.append(key + "=" + XSSUtil.encodeForURL(context,value[0]));
        }else if(key.equalsIgnoreCase("timeStamp")){
        }else if(key.equalsIgnoreCase("formName")){
        	//parametersBuffer.append(key + "=" + XSSUtil.encodeForURL(context,value[0]));
        }else if(key.equalsIgnoreCase("rowObjectId")){
        	parametersBuffer.append(key + "=" + XSSUtil.encodeForURL(context,value[0]));
        }else if(key.equalsIgnoreCase("uiType")){
        	parametersBuffer.append(key + "=" + XSSUtil.encodeForURL(context,value[0]));
        }else if(key.equalsIgnoreCase("isFromChooser")){
        	parametersBuffer.append(key + "=" + XSSUtil.encodeForURL(context,value[0]));
        }else {
        	parametersBuffer.append(key + "=" + XSSUtil.encodeForURL(context,value[0]));
        }
    }
    
    %>
     //XSSOK
    Params+="&<%=parametersBuffer.toString()%>";
	 
	return Params; 
}

function showPostProcessURLPopup(iHTML)
{
	var popUp = document.getElementById("PostProcessURLPopup");
	if(!popUp)
		popUp = createPostProcessURLPopup();

    var doc  = popUp.contentWindow.document;
    /*Next Gen-Starts--Passing the control postProcessURL instead constructing HTML and writing into the document*/
    doc.open();
    //alert("iHTML-->"+iHTML);
    doc.write(iHTML);
    doc.close();   
    /*Next Gen-Ends*/
    //doc.location.href = iHTML;
	popUp.style.display="block";
    getTopWindow().getWindowOpener().location.href = getTopWindow().getWindowOpener().location.href;
    //parent.window.close();    
}

function closePostProcessURLPopup()
{
	var popUp = document.getElementById("PostProcessURLPopup");
	if(popUp)
		popUp.style.display="none";
	
}

function createPostProcessURLPopup()
{
    var popUp = document.createElement("iframe");
	popUp.setAttribute("id", "PostProcessURLPopup");
	popUp.style.display="none";
	popUp.style.position="absolute";
    popUp.style.top = "0px";
    popUp.style.left = "0px";
    popUp.style.width = "100%";
    popUp.style.height = "100%";
    popUp.style.border ="1px solid #CCC";
    popUp.style.backgroundColor="white";
	document.body.appendChild(popUp);
	return popUp;
}

function submitRule(){

	showValidMsg = false;
	var vRes = fnValidate();
	if(vRes == "true")
	{
		callPostProcessURL();
		}
	else
	{
	    showValidMsg = true;
		return;
	}
}  

function finalSubmit()
{
        closePostProcessURLPopup();
		var vInvockedFrom = document.BCform.invockedfromfield.value;
		//alert(vInvockedFrom);
        if(vInvockedFrom == "fromEffToolbar")
        {
            parent.window.getWindowOpener().document.emxTableForm.CFFExpressionFilterInput.value = document.BCform.completedRuleText.value;
	        parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.CFFExpressionFilterInput_actualValue.value = document.BCform.completedRuleActual.value;
            parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.CFFExpressionFilterInput.setAttribute("title", document.BCform.completedRuleText.value);
           // parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.CFFExpressionFilterInput_OID.value = document.BCform.completedRuleTextList.value;
            
            var url="../effectivity/EffectivityUtil.jsp?mode=getBinary&effExpr="+document.BCform.completedRuleActual.value;
            var vRes = emxUICore.getData(url);
            parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.CFFExpressionFilterInput_OID.value = vRes;

            //1. Store the delimited actual expression
            currentEffExprAc = document.BCform.completedRuleActualList.value;
            var  CFFExpressionListAc = parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.CFFExpressionList;
            if(CFFExpressionListAc == undefined || CFFExpressionListAc == null)
            {
            	CFFExpressionListAc = parent.window.getWindowOpener().document.createElement('input');
            	CFFExpressionListAc.setAttribute('type', 'hidden');
            	CFFExpressionListAc.setAttribute('name', 'CFFExpressionList');
            	CFFExpressionListAc.setAttribute('id', 'CFFExpressionList');
                parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.appendChild(CFFExpressionListAc);
            }
            CFFExpressionListAc.setAttribute('value', currentEffExprAc);

            //2. Store the delimited display expression
            var  CFFExpressionListDisp = parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.CFFExpressionListDisp;
            if(CFFExpressionListDisp == undefined || CFFExpressionListDisp == null)
            {
            	CFFExpressionListDisp = parent.window.getWindowOpener().document.createElement('input');
            	CFFExpressionListDisp.setAttribute('type', 'hidden');
            	CFFExpressionListDisp.setAttribute('name', 'CFFExpressionListDisp');
            	CFFExpressionListDisp.setAttribute('id', 'CFFExpressionListDisp');
                parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.appendChild(CFFExpressionListDisp);
            }
            CFFExpressionListDisp.setAttribute('value', document.BCform.completedRuleTextList.value);

            //Commented since the mode field was removed
            //1. Get the Mode display string     
            //var vModeDisplayString = getCompleteModeDisplayString();
                        
            //2. Set the Mode display string in the Effectivity toolbar
           // parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.CFFExpressionFilterMode.value = vModeDisplayString;
           // parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.CFFExpressionFilterMode.setAttribute("title", vModeDisplayString);

            //3. get the mode actual string
           // var vModeActualString = getCompleteModeActualString();
            
            //4. create the hidden node CFFExpressionFilterMode_actualValue if not present
            // var vModeActualValueNode = parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.CFFExpressionFilterMode_actualValue;
            //if(vModeActualValueNode == undefined || vModeActualValueNode == null)
            //{
              // vModeActualValueNode = parent.window.getWindowOpener().document.createElement('input');
               //vModeActualValueNode.setAttribute('type', 'hidden');
               //vModeActualValueNode.setAttribute('name', 'CFFExpressionFilterMode_actualValue');
               //vModeActualValueNode.setAttribute('id', 'CFFExpressionFilterMode_actualValue');
               //vModeActualValueNode.setAttribute('value', '');
               //parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.appendChild(vModeActualValueNode);
            //}

            //4. Set the Mode display string in the hidden parameter 
            //parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.CFFExpressionFilterMode_actualValue.value = vModeActualString;
            //End of Commented since the mode field was removed
            
        }
        else if(vInvockedFrom == "fromForm")
        {
            <%if(strFieldNameEffExprDisplay != null && strFieldNameEffExprActual != null && strFieldNameEffExprList != null && strFieldNameEffExprListAc!= null){%>
            parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.<%=XSSUtil.encodeForJavaScript(context,strFieldNameEffExprDisplay)%>.setAttribute("title", document.BCform.completedRuleText.value);
     	    parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.<%=XSSUtil.encodeForJavaScript(context,strFieldNameEffExprDisplay)%>.value = document.BCform.completedRuleText.value;
            parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.<%=XSSUtil.encodeForJavaScript(context,strFieldNameEffExprActual)%>.value = document.BCform.completedRuleActual.value;
            parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.<%=XSSUtil.encodeForJavaScript(context,strFieldNameEffExprList)%>.value = document.BCform.completedRuleTextList.value;
            parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.<%=XSSUtil.encodeForJavaScript(context,strFieldNameEffExprListAc)%>.value = document.BCform.completedRuleActualList.value;
            <%}%>
            //store the compiled binary if this is filter mode
            <%if(strmode != null && strmode.equalsIgnoreCase("filter")){%>
            var url="../effectivity/EffectivityUtil.jsp?mode=getBinary&effExpr="+document.BCform.completedRuleActual.value;
	        var vRes = emxUICore.getData(url);
	        parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.<%=XSSUtil.encodeForJavaScript(context,strFieldNameEffExprOID)%>.value = vRes;
            <%}%>            
            currentEffExprActual = document.BCform.completedRuleActual.value;
            currentEffExprDisp = document.BCform.completedRuleText.value;
            currentEffExpr = document.BCform.completedRuleTextList.value;
            currentEffExprAc = document.BCform.completedRuleActualList.value;
        }
        else
        {    
        	// code to handle the expression to be set in the structure browser columns
        	var displayVal = ' ';
        	var actualVal = ' ';       
        	//alert("top="+top);
        	var targetWindow = getTopWindow().getWindowOpener();
        	//alert("targetWindow="+targetWindow);
        	//alert("targetWindow.document="+targetWindow.document);
        	var tmpFieldNameActual = "<%=XSSUtil.encodeForJavaScript(context,strFieldNameActual)%>";
        	var tmpFieldNameDisplay = "<%=XSSUtil.encodeForJavaScript(context,strFieldNameDisplay)%>";

            var vfieldNameActual = targetWindow.document.getElementById(tmpFieldNameActual);
            var vfieldNameDisplay = targetWindow.document.getElementById(tmpFieldNameDisplay);
            //alert("vfieldNameActual="+vfieldNameActual);
            if (vfieldNameActual==null && vfieldNameDisplay==null) {
            vfieldNameActual=targetWindow.document.forms[0][tmpFieldNameActual];
            vfieldNameDisplay=targetWindow.document.forms[0][tmpFieldNameDisplay];
            }
            //alert("vfieldNameActual="+vfieldNameActual);
            if (vfieldNameActual==null && vfieldNameDisplay==null) {
            vfieldNameActual=targetWindow.document.getElementsByName(tmpFieldNameActual)[0];
            vfieldNameDisplay=targetWindow.document.getElementsByName(tmpFieldNameDisplay)[0];
            }
            //alert(tmpFieldNameActual+"vfieldNameActual="+vfieldNameActual);
            if (vfieldNameActual==null && vfieldNameDisplay==null) {
                var elem = targetWindow.document.getElementsByTagName("input");
                var att;
                var iarr;
                for(i = 0,iarr = 0; i < elem.length; i++) {
                   att = elem[i].getAttribute("name");
                   if(tmpFieldNameDisplay == att) {
                       vfieldNameDisplay = elem[i];
                       iarr++;
                   }
                   if(tmpFieldNameActual == att) {
                       vfieldNameActual = elem[i];
                       iarr++;
                   }
                   if(iarr == 2) {
                       break;
                   }
               }
           }
           // alert("vfieldNameActual="+vfieldNameActual);
<%          //System.out.println("strFieldNameDisplay="+strFieldNameDisplay);
            //System.out.println("strFormName="+strFormName);
                        
            if(strFieldNameDisplay != null)
            {
%>
                displayVal = document.BCform.completedRuleText.value;

                if (displayVal == '')
                {
                    displayVal = ' ';
                }
                /*vDisplayField = parent.window.getWindowOpener().document.<%=strFormName%>.<%=strFieldNameDisplay%>;*/
                //alert("vfieldNameDisplay="+vfieldNameDisplay);                
                vfieldNameDisplay.value = displayVal;
<%  
            }
            //System.out.println("strFieldNameActual="+strFieldNameActual);
            if(strFieldNameActual != null)
            {
%>
                actualVal = document.BCform.completedRuleActual.value;
                if (actualVal == '')
                {
                   actualVal = ' ';
                }
                /*vActualField = parent.window.getWindowOpener().document.<%=strFormName%>.<%=strFieldNameActual%>;*/
                //alert("vfieldNameActual="+vfieldNameActual);
                vfieldNameActual.value = actualVal;
<%          }
%>
       }
       parent.window.close();
	
}  
function fnValidate(){

    var formName = document.BCform;
    lstExpression =  new Array;
    var strInvockedFrom = "<%=XSSUtil.encodeForJavaScript(context,strInvockedFrom)%>";
    for(var i=0; i<document.getElementById("IncExp").options.length; i++) 
    {
        var strLExpOption = document.getElementById("IncExp").options[i];
        
        if(strLExpOption.value.indexOf("[]") != -1)
        {
        	alert("<%=i18nStringNowUtil("Effectivity.Expression.Invalid", bundle,acceptLanguage)%> ");
            /*validated = false;*/
            return "false";
        }
        if (strInvockedFrom != "fromTable" && strInvockedFrom != "fromEffToolbar"){
            if(strInvockedFrom != "fromTable" && (currentEffExprList==null || currentEffExprList=="null" || currentEffExprList == ""))
            {
                <%if(strFieldNameEffExprList != null && strFieldNameEffExprListAc != null)
                {%>
                   parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.<%=XSSUtil.encodeForJavaScript(context,strFieldNameEffExprList)%>.value += strLExpOption.text;
                   parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.<%=XSSUtil.encodeForJavaScript(context,strFieldNameEffExprList)%>.value += "@delimitter@";
        	       parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.<%=XSSUtil.encodeForJavaScript(context,strFieldNameEffExprListAc)%>.value += strLExpOption.value;
        	      parent.window.getWindowOpener().document.<%=XSSUtil.encodeForJavaScript(context,strFormName)%>.<%=XSSUtil.encodeForJavaScript(context,strFieldNameEffExprListAc)%>.value += "@delimitter@";
                <%} %>
            }
        }
        	
        
        if(strLExpOption.value != "AND" && strLExpOption.value != "OR" && strLExpOption.value != "NOT" && strLExpOption.value != "(" && strLExpOption.value != ")")
        {
            lstExpression[i] = "TRUE"
        }
        else
        {
        	lstExpression[i] = strLExpOption.value;
        }
    }
    
    var urlParam = "mode=ValidateExpression&ContextId=<%=XSSUtil.encodeForURL(context,strContextObjectId)%>&LeftExpression="+lstExpression;
	var vRes = emxUICore.getDataPost("../effectivity/EffectivityUtil.jsp", urlParam);
    vRes = trim(vRes)
     if(vRes == "true" && showValidMsg == true)
    {
    	 alert("<%=i18nStringNowUtil("Effectivity.Expression.Valid", bundle,acceptLanguage)%> ");
    	 /*validated = true;*/
    }
     if(vRes == "false")
     {
    	 alert("<%=i18nStringNowUtil("Effectivity.Expression.Invalid", bundle,acceptLanguage)%> ");
    	 /*validated = false;*/
     }
    return vRes;
} // end of function

/**
 * returns the URL for the selector table when the showContext parameter is true
 */
function getStructureURLForShowContext()
{
	var vSelected = document.getElementById('typeSelector_mx_divFilter1').selectedIndex;
    return "../common/emxIndentedTable.jsp?program=emxEffectivityFramework:getContextsFromExpression&effectivityExpression="+document.BCform.completedRuleActual.value+"&effectivityType="+document.getElementById('typeSelector_mx_divFilter1').options[vSelected].value;	
}

/**
* returns the URL for selector table based on the root id
*/
function getStructureURLByRootId()
{
	var rootId= getRootId();

    if(rootId == "")
    {
        var mx_iframeStructureListEl = document.getElementById("EffectivitySourceList");
        var vURL = "../effectivity/EffectivityServices.jsp?mode=blankRoot";
        mx_iframeStructureListEl.src= vURL;
        mx_iframeStructureListEl.contentWindow.location.href = vURL;
        return;
     }   

    return "../common/emxIndentedTable.jsp?objectId="+rootId;
}

/**
* returns the URL by the includeContextProgram setting on the current effectivity type
*/
function getStructureURLByIncludeContextPrg()
{
	var vSelectedEffTypeIndex = document.getElementById('typeSelector_mx_divFilter1').selectedIndex;
	var sEffType = document.getElementById('typeSelector_mx_divFilter1').options[vSelectedEffTypeIndex].value;
	if(!sEffType)
		return '';

    var sIncludeContextPrg = emxUICore.getData("../effectivity/EffectivityUtil.jsp?mode=getEffTypeSetting&settingName=includeContextProgram&effType="+sEffType);
    sIncludeContextPrg = sIncludeContextPrg.replace(/(\r\n|\n|\r)/gm,"");

    if(sIncludeContextPrg == "")
    {
        return '';
    }

    return "../common/emxIndentedTable.jsp?program="+sIncludeContextPrg;
}

function expandStructureMode()
	{
	var mx_iframeStructureListEl = document.getElementById("EffectivitySourceList");
	var selectedMode = "";
	var expandProgramOrRelationship = "";
	var effType = "";
	var vSelected = document.getElementById('typeSelector_mx_divFilter1').selectedIndex;
	var vRootType = "";
	vRootType =document.getElementById('txtRootType').value;
	var vDisplayType=document.getElementById('typeSelector_mx_divFilter1').options[vSelected].text;
	var vActualType = document.getElementById('typeSelector_mx_divFilter1').options[vSelected].value;
	var selection = getEffSetting("<%=XSSUtil.encodeForURL(context,EffectivitySettingsManager.CMD_SETTING_SELECTION)%>", vActualType);
	var defnTable = getEffSetting("<%=XSSUtil.encodeForURL(context,EffectivitySettingsManager.CMD_SETTING_TABLE)%>", vActualType);
	var selectorToolbar = "";
	 var vURL ='';
	 //1. try to get url throught the includeContextProgram setting on the current effectivity type
	 vURL = getStructureURLByIncludeContextPrg();

	 if(!vURL)
	 {
		   //2. Check if showContext is true and the current effectivity expression is not empty
	if(showContext == true && document.BCform.completedRuleActualList.value != "")
	{
	    	   //3. If yes get the URL for the show context
		   vURL = getStructureURLForShowContext();	
	}   

	//3. if showContext is not set Search for the rootId
	else
	{
	//4. Get the URL for displaying the rootid
		vURL = getStructureURLByRootId();
	}
	 }
	if(vURL == null || vURL=="")
		return;
	
	expandProgramOrRelationship = getExpandOrRelSetting();
	selectorToolbar = getSelectorTableToolbar() ;      
        
    //5. Append the common URL parameters
        vURL +="&table="+defnTable+expandProgramOrRelationship+selectorToolbar;
        vURL += "&portalMode=false";
        vURL += "&massPromoteDemote=false";
        vURL += "&customize=true";
        vURL += "&objectCompare=false";
        vURL += "&showPageURLIcon=false";
        vURL += "&uiType=form&pageType=form";
        vURL += "&printerFriendly=false&editLink=false";
        vURL += "&export=false&multiColumnSort=false";
        vURL += "&selection="+selection;
        vURL += "&suiteKey=Effectivity";
        vURL += "&HelpMarker=emxhelpeffectivityedit&splitView=false";
        vURL += "&autoFilter=false";
        vURL += "&direction=from";
        vURL += "&hideHeader=true";
        vURL += "&effectivityType="+vActualType;        
        vURL += "&sortColumnName=SequenceSelectable";         
        vURL += "&parentID="+"<%=XSSUtil.encodeForURL(context,strParentObjectId)%>";
        vURL += "&rootID="+"<%=XSSUtil.encodeForURL(context,strRootId)%>";
        vURL += "&objectId="+"<%=XSSUtil.encodeForURL(context,oId)%>";
        if("<%=XSSUtil.encodeForJavaScript(context,strModelContext)%>" != null && "<%=XSSUtil.encodeForJavaScript(context,strModelContext)%>" != "null" && "<%=XSSUtil.encodeForJavaScript(context,strModelContext)%>" !=""){
        	vURL += "&modelContext="+"<%=XSSUtil.encodeForURL(context,strModelContext)%>";
        }
        mx_iframeStructureListEl.src = vURL;     
        //For onload event, the page doesnt get refreshed, hence set the location href of the content window
        mx_iframeStructureListEl.contentWindow.location.href = vURL;
}


function getRootId()
{
	var rootId = "";
	var vSelected = document.getElementById('typeSelector_mx_divFilter1').selectedIndex;
    var vRootType = "";
    var objectId = "";
    var parentId = "";
    
    vRootType =document.getElementById('txtRootType').value;
    var vDisplayType=document.getElementById('typeSelector_mx_divFilter1').options[vSelected].text;
    var vActualType = document.getElementById('typeSelector_mx_divFilter1').options[vSelected].value;
    var searchType = getEffSetting("<%=XSSUtil.encodeForURL(context,EffectivitySettingsManager.CMD_SETTING_SEARCHTYPE)%>", vActualType);
    var parentWindow = "getTopWindow().getWindowOpener().parent";
    var locHref = ".location.href";
    var treeHref = eval(parentWindow + locHref); 
    var ctr = 0;
    var vRes = "";
    var url = "";
    while (treeHref)
    {
        if(ctr == 5)
        {
            break;
        }
        if (treeHref.indexOf("emxTree.jsp") > 0 )
        {
          //search for objected, or parentOID
          var idx = treeHref.indexOf("objectId=");
          if(idx > 0)
          {
              objectId = treeHref.substring(idx+9, idx+32);
              url="../effectivity/EffectivityUtil.jsp?mode=CompareRoot&searchType="+searchType+"&objectId="+objectId;
              vRes = emxUICore.getData(url);
          }
          
          if(vRes != "" && trim(vRes)=="true")
          {
              rootId = objectId;
              break;
          }
          else
          {
              var idx = treeHref.indexOf("parentOID=");
              if(idx > 0)
              {
               parentId = treeHref.substring(idx+10, idx+33);
               url="../effectivity/EffectivityUtil.jsp?mode=CompareRoot&searchType="+searchType+"&parentOID="+parentId;
               vRes = emxUICore.getData(url);
               if(trim(vRes)=="true")
               {
                 rootId = parentId;
                 break;
               } 
              }
             
          }
        }
        else
        {
            parentWindow+=".parent"
            treeHref = eval(parentWindow + locHref);
        }
        ctr++;

    }//end of recursive call to caller's parent windows
    if(vRes == "" || trim(vRes) == "false")//If emxTree never found
    {
        if(vRootType != "")//for fromTable case
        {
            url="../effectivity/EffectivityUtil.jsp?mode=CompareRoot&searchType="+searchType+"&rootType="+vRootType;
            vRes = emxUICore.getData(url);
            if(trim(vRes)=="true")
            {
                <%if(strRootId!=null)
                {%>
                rootId = "<%=XSSUtil.encodeForJavaScript(context,strRootId)%>";
                <%}%>
            }
        
        }
        else//all other cases
        {
               //Edit Effectivity and Effectivity Filter toolbar might come here    
               <%
               if(oId != null)
               {%>
                url="../effectivity/EffectivityUtil.jsp?mode=CompareRoot&searchType="+searchType+"&objectId=<%=XSSUtil.encodeForURL(context,oId)%>";
                vRes = emxUICore.getData(url);
                if(trim(vRes) == "true")
                {
                	rootId="<%=XSSUtil.encodeForJavaScript(context,oId)%>";
                 }
               <%}
               if(parentOID != null)//Create page might come here, as there is no object id
               {%>
                 if(vRes == "" || trim(vRes) == "false")
                 {
                    url="../effectivity/EffectivityUtil.jsp?mode=CompareRoot&searchType="+searchType+"&parentOID=<%=XSSUtil.encodeForURL(context,parentOID)%>";
                    vRes = emxUICore.getData(url);
                    if(trim(vRes)=="true")
                    {
                    	rootId="<%=XSSUtil.encodeForJavaScript(context,parentOID)%>";
                    }
                 }
                    
               <%}%>
       }
    }
    return rootId;
}

function getExpandOrRelSetting()
{
	   var mx_iframeStructureListEl = document.getElementById("EffectivitySourceList");
	   var vSelected = document.getElementById('typeSelector_mx_divFilter1').selectedIndex;
	   var vDisplayType=document.getElementById('typeSelector_mx_divFilter1').options[vSelected].text;
	   var vActualType = document.getElementById('typeSelector_mx_divFilter1').options[vSelected].value;
	   var vExpandParam = "";
	   var expandProgram = getEffSetting("<%=XSSUtil.encodeForURL(context,EffectivitySettingsManager.CMD_SETTING_EXPANDPROGRAM)%>", vActualType);
	   if (expandProgram != "" && expandProgram != null && expandProgram != "null") //expandProgram takes presidence
	    {
	        vExpandParam = "&expandProgram=" + expandProgram;
	    }
	    else //if expandProgram not there, then use relationship
	    {
	        expandProgram = getEffSetting("<%=XSSUtil.encodeForURL(context,EffectivitySettingsManager.CMD_SETTING_RELATIONSHIP)%>", vActualType);
	        if (expandProgram != "" && expandProgram != null && expandProgram != "null")
	        {
	            vExpandParam = "&relationship=" + expandProgram;
	        }        
	    }
	   return vExpandParam;
	
}

function getStructure()
{
// get whether the mode present or not
//if present, read settings like table, expandProgram, relationship
	var mx_iframeStructureListEl = document.getElementById("EffectivitySourceList");
    var vSelected = document.getElementById('typeSelector').selectedIndex;
    var vRootType = "";
    vRootType =document.getElementById('txtRootType').value;
    var vDisplayType=document.getElementById('typeSelector').options[vSelected].text;
    var vActualType = document.getElementById('typeSelector').options[vSelected].value;
    var searchType = getEffSetting("<%=XSSUtil.encodeForURL(context,EffectivitySettingsManager.CMD_SETTING_SEARCHTYPE)%>", vActualType);
    var vformatType = getEffSetting("<%=XSSUtil.encodeForJavaScript(context,EffectivitySettingsManager.CMD_SETTING_FORMAT)%>", vActualType);
    var expandProgram = getEffSetting("<%=XSSUtil.encodeForURL(context,EffectivitySettingsManager.CMD_SETTING_EXPANDPROGRAM)%>", vActualType);
    var selectorToolbar = "";
    var vExpandParam = "";
	var parentWindow = "getTopWindow().getWindowOpener().parent";
	var locHref = ".location.href";
	var treeHref = eval(parentWindow + locHref);
    var ctr = 0;
    var objectId = "";
    var parentId = "";
    var vRootType;
    var url = "";
    var vRes = "";
    var vURL = "";
    while (treeHref)
    {
        if(ctr == 5)
        {
            break;
        }
        if (treeHref.indexOf("emxTree.jsp") > 0 )
        {
          //search for objected, or parentOID
          var idx = treeHref.indexOf("objectId=");
          if(idx > 0)
          {
        	  objectId = treeHref.substring(idx+9, idx+32);
        	  url="../effectivity/EffectivityUtil.jsp?mode=CompareRoot&searchType="+searchType+"&objectId="+objectId;
        	  vRes = emxUICore.getData(url);
          }
          
          if(vRes != "" && trim(vRes)=="true")
          {
        	  vURL = "../common/emxIndentedTable.jsp?objectId="+objectId;
        	  break;
          }
          else
          {
        	  var idx = treeHref.indexOf("parentOID=");
        	  if(idx > 0)
        	  {
        	   parentId = treeHref.substring(idx+10, idx+33);
        	   url="../effectivity/EffectivityUtil.jsp?mode=CompareRoot&searchType="+searchType+"&parentOID="+parentId;
        	   vRes = emxUICore.getData(url);
        	   if(trim(vRes)=="true")
        	   {
        		  vURL = "../common/emxIndentedTable.jsp?objectId="+parentId;
                 break;
               } 
        	  }
        	 
          }
        }
        else
        {
        	parentWindow+=".parent"
            treeHref = eval(parentWindow + locHref);
        }
        ctr++;

    }//end of recursive call to caller's parent windows
    if(vRes == "" || trim(vRes) == "false")//If emxTree never found
    {
        if(vRootType != "")//for fromTable case
        {
            url="../effectivity/EffectivityUtil.jsp?mode=CompareRoot&searchType="+searchType+"&rootType="+vRootType;
            vRes = emxUICore.getData(url);
            if(trim(vRes)=="true")
            {
                <%if(strRootId!=null)
                {%>
                vURL = "../common/emxIndentedTable.jsp?objectId=<%=XSSUtil.encodeForURL(context,strRootId)%>";
                <%}%>
            }
        
        }
        else//all other cases
        {
               //Edit Effectivity and Effectivity Filter toolbar might come here    
               <%
               if(oId != null)
               {%>
        	    url="../effectivity/EffectivityUtil.jsp?mode=CompareRoot&searchType="+searchType+"&objectId=<%=XSSUtil.encodeForURL(context,oId)%>";
        	    vRes = emxUICore.getData(url);
        	    if(trim(vRes) == "true")
        	    {
        	      vURL = "../common/emxIndentedTable.jsp?objectId=<%=XSSUtil.encodeForURL(context,oId)%>";
        	     }
        	   <%}
        	   if(parentOID != null)//Create page might come here, as there is no object id
        	   {%>
        	     if(vRes == "" || trim(vRes) == "false")
        	     {
        	        url="../effectivity/EffectivityUtil.jsp?mode=CompareRoot&searchType="+searchType+"&parentOID=<%=XSSUtil.encodeForURL(context,parentOID)%>";
        	        vRes = emxUICore.getData(url);
        	        if(trim(vRes)=="true")
                    {
                        vURL = "../common/emxIndentedTable.jsp?objectId=<%=XSSUtil.encodeForURL(context,parentOID)%>";
                    }
        	     }
        	        
        	   <%}%>
       }
    }
    if (expandProgram != "" && expandProgram != null && expandProgram != "null") //expandProgram takes presidence
    {
        vExpandParam = "&expandProgram=" + expandProgram;
    }
    else //if expandProgram not there, then use relationship
    {
        expandProgram = getEffSetting("<%=XSSUtil.encodeForURL(context,EffectivitySettingsManager.CMD_SETTING_RELATIONSHIP)%>", vActualType);
        if (expandProgram != "" && expandProgram != null && expandProgram != "null")
        {
            vExpandParam = "&relationship=" + expandProgram;
        }        
    }
    if(vURL == "")
    {
        giveAlert("ROOT_MISSING");
        
    }   
    else
    {
         vURL += "&table=CFFDefinitionTable";
         if(vformatType == "list")
         {
           vURL +="&program="+vExpandParam;
         }
         else
         {
            vURL += vExpandParam;
         }
         if (selectorToolbar != "" && selectorToolbar != null && selectorToolbar != "null") 
         {
        	 vURL += "&toolbar="+selectorToolbar;
         }
         vURL += "&portalMode=false";
         vURL += "&massPromoteDemote=false";
         vURL += "&customize=false";
         vURL += "&objectCompare=false";
         vURL += "&showPageURLIcon=false";
         vURL += "&uiType=form&pageType=form";
         vURL += "&printerFriendly=false&editLink=false";
         vURL += "&export=false&multiColumnSort=false";
         vURL += "&selection=multiple";
         vURL += "&suiteKey=Effectivity";
         vURL += "&HelpMarker=emxhelpeffectivityedit&splitView=false";
         vURL += "&autoFilter=false";
         vURL += "&direction=from";
         vURL += "&hideHeader=true";
         vURL += "&effectivityType="+vActualType;
         vURL += "&sortColumnName=SequenceSelectable";
         mx_iframeStructureListEl.src = vURL;
    }
    
}

function insertDateField(dateIndex){
    var vFieldName;
    var expDisplayField;
    var nextDateIdx = parseInt(dateIndex) + 1;
    lastDateIndex++;   
    expDisplayField =  "<%=i18nStringNowUtil("Effectivity.EffectivityType.Date",
                            bundle, acceptLanguage)%>";
    vFieldName = "Date" + lastDateIndex;
    var vFieldName_msVal = vFieldName+"_msvalue";
    expValue = expDisplayField + " " + lastDateIndex;
    var tbody = document.getElementById("mx_divSourceList").getElementsByTagName("TBODY")[0];
    var table = document.getElementById("mx_divSourceList").getElementsByTagName("TABLE")[0];
    if(tbody == null)
    {
        tbody = document.createElement("TBODY");
    }   
    table.appendChild(tbody);
    var row = document.createElement("TR");
    var td1 = document.createElement("TD");
    td1.className="label";
    td1.appendChild(document.createTextNode(expValue));
    var td2 = document.createElement("TD");
    td2.appendChild(document.createTextNode(""));
    var td3 = document.createElement("TD");
    td3.className="field";
    //var input1=document.createElement("INPUT");
    var input1=createNamedElement("INPUT",vFieldName);
    //input1.name= vFieldName;
    input1.id= vFieldName;
    input1.readOnly="readOnly";
    input1.type="text";    
    td3.appendChild(input1);
    //Create hidden field to store the millisecond value
    var input1_ms=createNamedElement("INPUT",vFieldName_msVal);
    //input1.name= vFieldName;
    input1_ms.id= vFieldName_msVal;
    input1_ms.type="hidden";    
    td3.appendChild(input1_ms);
    var td4 = document.createElement("TD");
    td4.appendChild(document.createTextNode(""));
    var td5 = document.createElement("TD");
    var anchor1=document.createElement("A");
    anchor1.href="javascript:showCalendar(\"BCform\",\""+vFieldName+ "\",\"\")";
    var img1=document.createElement("IMG");
    img1.src="../common/images/iconSmallCalendar.gif";
    img1.border="0";
    img1.valign="absmiddle";
    anchor1.appendChild(img1);
    td5.appendChild(anchor1);
    var td6 = document.createElement("TD");
    td2.appendChild(document.createTextNode(""));
    var td7 = document.createElement("TD");
    //var input2=document.createElement("INPUT");
    var input2=createNamedElement("INPUT","addDate");
    input2.type="button";
    //input2.name="addDate";
    input2.value="+";
    if(isIE){

  input2.onclick = function() {
	  insertDateField(nextDateIdx)
			  };
    }else{
        input2.setAttribute("onclick","insertDateField(\""+ nextDateIdx + "\")");
        }
    td7.appendChild(input2);
    var td8 = document.createElement("TD");
    td2.appendChild(document.createTextNode(""));
    var td9 = document.createElement("TD");
    var input3 = createNamedElement("INPUT","addDate");
    //var input3=document.createElement("INPUT");
    input3.type="button";
    //input3.name="addDate";
    input3.value="-";
    if(isIE){

    	input3.onclick = function() {removeDateField(vFieldName)};
     }else{
    	 input3.setAttribute("onclick","removeDateField(\"" + vFieldName + "\")");
    }
    td9.appendChild(input3);
    var anchor2=document.createElement("A");
    anchor2.href="javascript:clear(\"" +vFieldName_msVal+"\")"+",clear(\"" +vFieldName+"\")";
    var img2=document.createElement("IMG");
    img2.src="../common/images/iconActionUndo.gif";
    img2.border="0";
    img2.valign="absmiddle";
    anchor2.appendChild(img2);
    var td10 = document.createElement("TD");
    td10.appendChild(anchor2);
    row.appendChild(td1);
    row.appendChild(td2);
    row.appendChild(td3);
    row.appendChild(td4);
    row.appendChild(td5);
    row.appendChild(td6);
    row.appendChild(td7);
    row.appendChild(td8);
    row.appendChild(td9);
    row.appendChild(td10);
    tbody.appendChild(row);
    formDateFieldArray();
}
function insertAsRange(){

    var target = document.getElementById("mx_divFilter1");
    var table = document.createElement("table");
    var tbody = document.createElement("TBODY");
    var insertAsRangeLabel =  "<%=i18nStringNowUtil("Effectivity.Label.InsertAsRange", bundle,acceptLanguage)%> ";
    var vSelected = document.getElementById('typeSelector_mx_divFilter1').selectedIndex;
    var vActualType = document.getElementById('typeSelector_mx_divFilter1').options[vSelected].value;
    var vAllowRange = getEffSetting("<%=XSSUtil.encodeForJavaScript(context,EffectivitySettingsManager.CMD_SETTING_ALLOWRANGE)%>", vActualType);
    var tr2 = document.createElement("tr");
    var td21 = document.createElement("td");
    if(vAllowRange != null && vAllowRange == "true")
    {

    	 if(document.getElementById("insertAsRange")== null)
         {
	        var input = document.createElement("input");
	        var input = createNamedElement("input","insertAsRange");
	        input.id="insertAsRange"; 
	        input.type="checkbox";
	        var inputLabel = document.createTextNode(insertAsRangeLabel);
	        td21.appendChild(input);
	        td21.appendChild(inputLabel);
	        tr2.appendChild(td21);
	        tbody.appendChild(tr2);
	        table.appendChild(tbody);
	        target.appendChild(table);
         }
    }
    else
    {
        if(document.getElementById("insertAsRange")!= null)
        {
           
            var removeEl = target.lastChild;
            removeEl.parentNode.removeChild(removeEl);
        }
    }
}
//The NAME attribute cannot be set at run time on elements dynamically created with the createElement method. 
//To create an element with a name attribute, include the attribute and value when using the createElement method.
//eg: document.createElement("<input name='brian' />")
//The browser creates an element with the invalid type="<input name='brian'>". This is what Netscape 7.1 and Opera 8.5 do
//The code simply tries to create the element using the Internet Explorer method first; if this fails it uses the standard method.
function createNamedElement(type, name) {
	   var element = null;
	   // Try the IE way; this fails on standards-compliant browsers
	   try {
	      element = document.createElement('<'+type+' name="'+name+'">');
	   } catch (e) {
	   }
	   if (!element || element.nodeName != type.toUpperCase()) {
	      // Non-IE browser; use canonical method to create named element
	      element = document.createElement(type);
	      element.name = name;
	   }
	   return element;
	}

function addANDNOTButtons()
{
	<%if(bShowAndCommandLine)
	{
		
	    if(bShowSingleOperator)
	    {%>
	        var typeSelector = document.getElementById("typeSelector_mx_divFilter1");
	        //if(typeSelector.options.length < 2)
	        	//   return;
    	
        <%}%>
	//1. Get the operators table
    var operatorsTable = document.getElementById("operatorsTable");
    if(operatorsTable)
    {
        //2. Get the OR Button
        var ANDPrevButton = document.getElementById("or");

        //3. create the AND button
        var ANDButton = document.createElement("input");
        ANDButton.setAttribute('type', 'button');
        ANDButton.setAttribute('name', 'and');
        ANDButton.setAttribute('id', 'and');
        ANDButton.setAttribute('value', 'AND');
       	ANDButton.onclick = function() {
             	operatorInsert("AND","left");
        		computedRuleApplicabilityDialog("AND","left");
        		  };

     
        //5. Get the right parenthesis button
        var rParenButton = document.getElementById("r-paren");
        if(rParenButton == 'undefined')
            return;

        //6. create the NOT button
        var NOTButton = document.createElement("input");
        NOTButton.setAttribute('type', 'button');
        NOTButton.setAttribute('name', 'and');
        NOTButton.setAttribute('id', 'not');
        NOTButton.setAttribute('value', 'NOT');
        NOTButton.onclick = function() {
            operatorInsert("NOT","left");
            computedRuleApplicabilityDialog("NOT","left");
              };

        //7. Add the not button before the right parenthesis button
        var TableRows = operatorsTable.getElementsByTagName("tr");
        var firstRow = TableRows[0];
        var tableData = firstRow.getElementsByTagName("td");
        var firstData = tableData[0];
        
        //firstData.insertBefore(NOTButton, rParenButton);

      //4. Add the AND button before the OR button
       if(ANDPrevButton == 'undefined' || ANDPrevButton == 'null' || ANDPrevButton == null)
            ANDPrevButton = NOTButton;
        firstData.appendChild(ANDButton);
        

    }
    <%}%>
}

function displayEffTypes()
{
var div = "mx_divFilter1";

//1. Get the label for the select box
    var typeLabel =  "<%=i18nStringNowUtil("Effectivity.Label.Type", bundle,acceptLanguage)%> ";

//2. Get the target div where the effectivity has to be displayed
var target = document.getElementById("mx_divFilter1");

//3. Create the select box
var table = document.createElement("table");
var tbody = document.createElement("TBODY");
var tr1 = document.createElement("tr");

var td1 = document.createElement("td");
var td1Text = document.createTextNode(typeLabel);
td1.appendChild(td1Text);

var td2 = document.createElement("td");
var select = document.createElement("select");
select.name="typeSelector_"+div;
select.id="typeSelector_"+div;
select.onchange=function(){onCmdEffChanged();};
var options;
var optionsText;
for (var i=0; i < currentEffTypesArr.length ; i++) 
{
    options = document.createElement("option");
    options.value=currentEffTypesArrActual[i];
    //options.text=currentEffTypesArr[i];
    optionsText = document.createTextNode(currentEffTypesArr[i]);
    options.appendChild(optionsText);
    select.appendChild(options);
}
td2.appendChild(select);

//4. Set the first option as selected
select.selectedIndex = 0;

var td3 = document.createElement("td");
var anchor = document.createElement("a");
anchor.name="searchType";
anchor.id="searchType";
var img = document.createElement("img");
img.src="../common/images/iconActionSearch.gif";
img.setAttribute("onclick","javascript:setContext('" + div +"')");
img.border="0";
anchor.setAttribute("href","javascript:setContext('" + div +"')");
anchor.appendChild(img);
if(bApplicabilityMode == "true"){
	img.style.display = 'none';
	anchor.style.display = 'none';
}
td3.appendChild(anchor);


tr1.appendChild(td1);
tr1.appendChild(td2);
if(div == "mx_divFilter1")
{
    tr1.appendChild(td3);
}
tbody.appendChild(tr1);
table.appendChild(tbody);
target.appendChild(table);
onCmdEffChanged();
}

function onCmdEffChanged()
{
//1. Display the modes for this effectivity
displayModeEffTypes();

//3. refresh the UI for entering the effectivity
 var divE1 = "mx_divFilter1"
selectorTable(divE1);
}
function displayModeEffTypes()
{
//1. Get the selected cmd effectivity type
var vEffSelectBox =  document.getElementById("typeSelector_mx_divFilter1");

var vEffSelectedIndex = vEffSelectBox.selectedIndex;

var vEffOptions = vEffSelectBox.options;

var vEffSelectedOption = vEffOptions[vEffSelectedIndex];

var vEffActual = vEffSelectedOption.value;

//2. Get the modes for this effectivity
var url =  "../effectivity/EffectivityServices.jsp?mode=getModes&effActual="+vEffActual;
var modesJSON = emxUICore.getData(url);
var modesArray = modesJSON.parseJSON();

//3. display the modes in the UI
var target = document.getElementById("mx_divFilter2");
target.innerHTML = "";
if(modesArray.length==0)
	return;

var typeLabel =  "<%=i18nStringNowUtil("Effectivity.Label.Mode", bundle,acceptLanguage)%> ";
var optionResponse = "";
var table = document.createElement("table");
var tbody = document.createElement("TBODY");
var tr1 = document.createElement("tr");

var td1 = document.createElement("td");
var td1Text = document.createTextNode(typeLabel);
td1.appendChild(td1Text);

var td2 = document.createElement("td");
var select = document.createElement("select");
select.name="typeSelector_mx_divFilter2";
select.id="typeSelector_mx_divFilter2";
//  select.setAttribute("onchange","selectorTable();");
select.onchange=function(){onModeEffChanged();};
var options;
var optionsText;
for (var i=0; i < modesArray.length ; i++) 
{
	var mode = modesArray[i];
    options = document.createElement("option");
    options.value=mode["actualValue"];
    optionsText = document.createTextNode(mode["displayValue"]);
    options.appendChild(optionsText);
    select.appendChild(options);
}
td2.appendChild(select);
tr1.appendChild(td1);
tr1.appendChild(td2);
select.selectedIndex = 0;
tbody.appendChild(tr1);
table.appendChild(tbody);
target.appendChild(table);
onModeEffChanged();
}

function onModeEffChanged()
{
//1. populate the settings
populateEffSettings();

//2. refresh the UI for entering the effectivity
var divE1 = "mx_divFilter2"
selectorTable(divE1);
}

function populateEffSettings()
{
//1. Get the selected cmd effectivity
var vEffSelectBox =  document.getElementById("typeSelector_mx_divFilter1");

var vEffSelectedIndex = vEffSelectBox.selectedIndex;

var vEffOptions = vEffSelectBox.options;

var vEffSelectedOption = vEffOptions[vEffSelectedIndex];

var vCmdEffActual = vEffSelectedOption.value;

//2. Get the selected mode
var vModeSelectBox =  document.getElementById("typeSelector_mx_divFilter2");

var jsonString = "";
if(vModeSelectBox)
{
    var vModeSelectedIndex = vModeSelectBox.selectedIndex;

    var vModeOptions = vModeSelectBox.options;

    var vModeSelectedOption = vModeOptions[vModeSelectedIndex];

    var vModeEffActual = vModeSelectedOption.value;

    //3. Get the json string for settings from the server
    var URL = "../effectivity/EffectivityServices.jsp?mode=getSettings&effActual="+vCmdEffActual+"&modeActual="+vModeEffActual;
    jsonString = emxUICore.getData(URL);   
}
else
{
    var URL = "../effectivity/EffectivityServices.jsp?mode=getSettings&effActual="+vCmdEffActual;
    jsonString = emxUICore.getData(URL);
}
//4. get the hidden input box
var effSettingsField = document.getElementById("EffSettingsField_"+vCmdEffActual);
effSettingsField.value = jsonString;
}

function getEffSetting(settingName, effType)
{
var EffSettingVal = null;
//1. Get the hidden field that contains the json string
var effSettingsField = document.getElementById("EffSettingsField_"+effType);

if(effSettingsField)
{
//2. Get the json string for effectivity settings
    var EffJSONString = effSettingsField.value;
    if(EffJSONString && EffJSONString != "")
    {
//3. Get the json object by parsing the json string
        var EffSettingsObj = EffJSONString.parseJSON();
        if(EffSettingsObj)
        {
            EffSettingVal = EffSettingsObj[settingName];
        }
    }
}
if(EffSettingVal == null || EffSettingVal =="null" || EffSettingVal == "")
    return null;
return EffSettingVal;
}

function getEffSettingByKeyword(settingName, effKeyword)
{
    var EffSettingVal = null;
    //Run through all the setting fields looking for the keyword
    if(currentEffTypesArrActual != null && currentEffTypesArrActual[0] != null)
    {
        for (var i=0; i < currentEffTypesArrActual.length; i++ ) 
        {
            var keywordVal = getEffSetting("<%=XSSUtil.encodeForJavaScript(context,EffectivitySettingsManager.CMD_SETTING_KEYWORD)%>", currentEffTypesArrActual[i]);
            if (keywordVal == effKeyword)
            {
               EffSettingVal = getEffSetting(settingName, currentEffTypesArrActual[i]);
               break;
            }
        }
    }
    return EffSettingVal;
}


function getSelectorTableToolbar()
{
       var mx_iframeStructureListEl = document.getElementById("EffectivitySourceList");
       var vSelected = document.getElementById('typeSelector_mx_divFilter1').selectedIndex;
       var vDisplayType=document.getElementById('typeSelector_mx_divFilter1').options[vSelected].text;
       var vActualType = document.getElementById('typeSelector_mx_divFilter1').options[vSelected].value;
       var vSelectorToolbar = "";
       var selectorToolbar = "";
       if (selectorToolbar != "" && selectorToolbar != null && selectorToolbar != "null") 
        {
    	   vSelectorToolbar = "&toolbar=" + selectorToolbar;
        }        
       return vSelectorToolbar;
    
}
function mx_setHeightApplicabilityDialog() {
	var contentDivHeight = document.getElementById('mx_divContent').offsetHeight;
	var sourceListTop = document.getElementById('mx_divSourceList').offsetTop;
	var sourceList = document.getElementById('mx_divSourceList');
	
	var ruleText = document.getElementById('mx_divRuleText');
	var ruleTextTop = document.getElementById('mx_divRuleText').offsetTop;



	sourceList.style.height = "0";
	sourceList.style.height = (contentDivHeight - sourceListTop)-18 +"px";


	ruleText.style.height = "0";
	ruleText.style.height = (contentDivHeight - ruleTextTop)-24 +"px";
	resetKeyInDiv();
	document.BCform.IncExp.onmousedown=click;
}

/*
 * This is called when dialog is resized......
 */
window.onresize=mx_setHeightApplicabilityDialog;

function insertFeatureOptionsApplicabilityDialog(textArea)
{
	var vSelected = document.getElementById('typeSelector_mx_divFilter1').selectedIndex;
	var vDisplayType = document.getElementById('typeSelector_mx_divFilter1').options[vSelected].text;
	var vActualType = document.getElementById('typeSelector_mx_divFilter1').options[vSelected].value;
	var vformatType = getEffSetting("Format", vActualType);
	var vcategoryType = getEffSetting("categoryType", vActualType);
	var vinsertAsRange = "";
	if(document.getElementById('insertAsRange') != null)
	{
		vinsertAsRange = document.getElementById('insertAsRange').checked;
	}
	if (vcategoryType == "date")
	{
		insertDateApplicabilityDialog(vSelected,vDisplayType,vActualType,vformatType,vinsertAsRange);
	}
	else if (vcategoryType == "sequence")
	{
		insertStructureApplicabilityDialog(vActualType,vinsertAsRange);
	}
	else if (vcategoryType == "relational")
	{
		insertRelational1(vActualType,vinsertAsRange);
	}else if (vformatType == "structure")
	{
		insertStructureApplicabilityDialog(vActualType,vinsertAsRange);
	}
}
function insertDateApplicabilityDialog(vSelected,vDisplayType,vActualType,vformatType,vinsertAsRange)
{
	var vSelected = document.getElementById('typeSelector_mx_divFilter1').selectedIndex;
	//var vDisplayType = document.getElementById('typeSelector_mx_divFilter1').options[vSelected].text;
	var vActualType = document.getElementById('typeSelector_mx_divFilter1').options[vSelected].value;
	//var vformatType = getEffSetting("Format");
	var vinsertAsRange = false;
	var vfield1;
	var vfieldValue;
	var fieldName;
	var vURL = "";
	var vLastRangeValue = "";
	var dateFieldArrayValues = new Array;
	var dateFieldArraySelected = new Array;
	var compiledDates = new Array();
	if(document.getElementById('insertAsRange') != null)
	{
		vinsertAsRange = document.getElementById('insertAsRange').checked;
	}
	if(lastDateIndex == 2)
	{
		formDateFieldArray();
	}
	var idx = 0;
	for ( var i = 0; i < dateFieldArray.length; i++) {
		fieldName = dateFieldArray[i]; // "Date" + i;
		vField1 = document.getElementById(fieldName);
		if (vField1 == null) {
			continue;
		}
		vfieldValue = vField1.value;
		if(vfieldValue != "")
		{
			dateFieldArrayValues[idx] = vfieldValue;
			dateFieldArraySelected[idx] = fieldName;
			idx++;
		}
	}
	idx--;

	if(dateFieldArrayValues.length == 0)
	{
		giveAlert("REQUEST_DATE_SELECTION");
		return;
	}
	if(vinsertAsRange)
	{
		if(dateFieldArrayValues.length == 1)
		{
			var firstField = dateFieldArray[0];
			firstFieldName = document.getElementById(firstField);
			var firstFieldValue = 	firstFieldName.value 
			if(firstFieldValue == "")
			{
				compiledDates[0] = "inf";
				compiledDates[1] = dateFieldArrayValues[0];
			}
			else
			{
				compiledDates[0] = dateFieldArrayValues[0];
				compiledDates[1] = "inf";
			}
		}
		else if(dateFieldArrayValues.length == 2)
		{
		//	var startDate = dateFieldArrayValues[0];
		//	var endDate =  dateFieldArrayValues[1];
		//	var dateStartDate = new Date(startDate);
		//	var dateEndDate = new Date(endDate);
			
			//2. Get the millisecond value for comparing the dates
			var startDate_ms = document.getElementById(dateFieldArraySelected[0]+"_msvalue").value;
			var endDate_ms = document.getElementById(dateFieldArraySelected[1]+"_msvalue").value;
			if(endDate_ms > startDate_ms)
			{
				for(var idx = 0; idx < dateFieldArrayValues.length; idx++)
				{
					compiledDates[idx] = dateFieldArrayValues[idx];
				}

			}
			else if(endDate_ms == startDate_ms)
			{
				giveAlert("END_DATE_SAME_START_DATE");
				return;
			}else{
				
				giveAlert("END_DATE_BEFORE_START_DATE");
				return;

			}

		}
		else
		{
			giveAlert("INVALID_DATE_RANGE");
			return;
		}
	}
	else
	{
		for(var idx = 0; idx < dateFieldArrayValues.length; idx++)
		{
			compiledDates[idx] = dateFieldArrayValues[idx];
		}
	}
	var DateJson ={"insertAsRange":vinsertAsRange,"values":compiledDates,"timezone":iClientTimeOffset};
	DateJson=DateJson.toJSONString();
	
	var vURL = "mode=format&effExpr="
		+ DateJson+ "&effType=" + vActualType;
	
	var vRes = emxUICore.getDataPost("../effectivity/EffectivityUtil.jsp",vURL);
	
	
	//var vURL = "../effectivity/EffectivityUtil.jsp?mode=format&effExpr="
	//	+ DateJson+ "&effType=" + vActualType;
	//var vRes = emxUICore.getData(vURL);
	//need to trim \r\n , in IE7 while rendering expression in Text Area, it would not adds newline between expression
	var vExpression = trim(vRes).split("-@clearSelectionValue@-");
	var expression = vExpression[0].split("-@ActualDisplay@-");
	var actualString = expression[0];
	var displayString = expression[1];
	var clearSelectionSetting = vExpression[1];
	var effType = getSelectedEffType();

	addOption(document.BCform.LeftExpression, displayString, actualString,"Operand",effType);

}
function insertStructureApplicabilityDialog(vActualType,vinsertAsRange)
{
	var isAppDialog = false;
	if(vinsertAsRange != true)
		vinsertAsRange = false;
	//get selected rows from structure browser
	var selectedContexts = getStructureValuesApplicabilityDialog();
	var effType = getSelectedEffType();
	if(selectedContexts == null || selectedContexts.length <= 0){
		giveAlert("USER_SELECTION");
		return 0;
	}
	var ctr = 0;
	var optionObjID = "";
	var toAddOR = false;
	
	for(var key in selectedContexts)
		{
		    if(key == "toJSONString" || key == "length")
		    	continue;
			var selectedValues = selectedContexts[key];
			if(vinsertAsRange)
 	        {
				if(selectedValues.length != 1 && selectedValues.length != 2)
				{
					giveAlert("INVALID_UNIT_RANGE");
					return 0;
				}

			}
			var selectedOptions = new Object();
			selectedOptions["insertAsRange"] = vinsertAsRange;
			selectedOptions["parentId"] = key;
			var selectedSeqSels = new Array();
			for(var i = 0; i < selectedValues.length; i++)
			{
				var selectedObj = selectedValues[i];
				if(selectedObj)
				{
				  selectedSeqSels[i] = selectedObj["seqSel"];
				  if(bApplicabilityMode && bApplicabilityMode == "true"){
					  isAppDialog = true;
					  var selectedAppSeqSels = new Array();
					  selectedAppSeqSels[i] = selectedObj["seqSel"];
					  selectedObj["upwardCompatible"] = "true";
					  selectedObj["parentId"] = key;
                      selectedOptions["parentId"] = selectedObj["objId"];
                      selectedOptions["physicalid"] = selectedObj["physicalid"];
                      //selectedOptions["parentId"] = selectedObj["contextId"];
                      selectedOptions["contextId"] = selectedObj["contextId"];
					  selectedOptions["values"] = selectedAppSeqSels;
					  selectedAppObj[cntAppObj++]= selectedObj;
					  optionObjID = optionObjID+"||"+selectedObj["objId"];
					  	var urlParam = "mode=format&ENO_ECH=true&effExpr=" + selectedOptions.toJSONString() + "&effType=" + vActualType;
						var vRes = emxUICore.getDataPost("../effectivity/EffectivityUtil.jsp", urlParam);
						//need to trim \r\n , in IE7 while rendering expression in Text Area, it would not adds newline between expression
						vExpression = trim(vRes).split("-@clearSelectionValue@-");
						var expression = vExpression[0].split("-@ActualDisplay@-");
						var actualString = expression[0];
						var displayString = expression[1];
                      //replace "[" (hard-coded in CFF getDisplayExpression()) with the separator used in template .xls                     
                      displayString = displayString.replace("[", PRODUCTNAMEREVSEP);
                      //replace "<" (hard-coded in CFF getDisplayExpression()) with the revision suffix in template .xls
                      if(REVSUFFIX != ""){
                          displayString =  displayString.replace("<", REVSUFFIX);
                      }

						if(toAddOR){
							operatorInsert("OR","left");
						}
						var optn = addOption(document.BCform.LeftExpression,displayString,actualString,"Operand",effType/*,true*/);
						optn.optObjId = optionObjID;
						ctr++;
						if(ctr < selectedValues.length)
						{//changed by IXe for OR operator
							//operatorInsert("AND","left");
							operatorInsert("OR","left");
						}
						toAddOR = false;
				  }
				  				  			  
				  var selectedNum = Number(selectedSeqSels[i]);
				  //need to check that the series value is a number that is an integer
				  if(vinsertAsRange && (isNaN(selectedNum) || isNaN(parseInt(selectedNum))))
                  {
                       giveAlert("KEYIN_NO_GREATER_THAN_ZERO");
                       return 0;
                  }
               }
			}
			if(!isAppDialog){
				selectedOptions["values"] = selectedSeqSels;
				
				var url = "../effectivity/EffectivityUtil.jsp?mode=format&effExpr=" + selectedOptions.toJSONString() + "&effType=" + vActualType;
				var vRes = emxUICore.getData(url);
				//need to trim \r\n , in IE7 while rendering expression in Text Area, it would not adds newline between expression
				vExpression = trim(vRes).split("-@clearSelectionValue@-");
				var expression = vExpression[0].split("-@ActualDisplay@-");
				var actualString = expression[0];
				var displayString = expression[1];
				var optn = addOption(document.BCform.LeftExpression,displayString,actualString,"Operand",effType/*,true*/);
				optn.optObjId = optionObjID;
				ctr++;
			}

				toAddOR=true;
				ctr=0;
			
			
		}
		if(vExpression[1])
		{
			clearSelection();
		}

}
//Function to compute completed rule for create rule
function computedRuleApplicabilityDialog(tmpOperator,textarea)
{
	var leftExp = document.BCform.LeftExpression;
	var leftExpText = "";
	var completedRuleText = "";
	var completedRuleActual = "";
	var completedRuleTextList = "";
	var completedRuleActualList = "";



	for (var i = 0; i < leftExp.length; i++)
		{
			leftExpText = leftExpText + leftExp.options[i].text + "\n";
			completedRuleText = completedRuleText + leftExp.options[i].text + " ";
			completedRuleActual = completedRuleActual + leftExp.options[i].value + " ";
			completedRuleTextList = trim(completedRuleTextList + leftExp.options[i].text) + "@delimitter@";
			completedRuleActualList = trim(completedRuleActualList + leftExp.options[i].value)+ "@delimitter@";
		}
	

	 computeRule = "<B>"+leftExpText + "</B> ";
	
    //format display expression based upon template .xsl
	var objDIV = document.getElementById("mx_divRuleText"); 
    objDIV.innerHTML = "";
    if(leftExp.length > 0){
        var url = "../effectivity/EffectivityUtil.jsp?";
        var params = "mode=getDisplayExpression&effExpr=" + selectedAppObj.toJSONString();
        var vRes = emxUICore.getDataPost(url, params);      
        objDIV.innerHTML = vRes;
    }    
    //objDIV.innerHTML = computeRule.toString();
	document.BCform.completedRuleText.value = completedRuleText;
	document.BCform.completedRuleActual.value = completedRuleActual;
	document.BCform.completedRuleTextList.value = completedRuleTextList;
	document.BCform.completedRuleActualList.value = completedRuleActualList;

} // end of function
	//Function to form left expression for edit
function formLeftExpApplicabilityDialog(){
		if(currentEffExprDisp == null || currentEffExprDisp == "null" || currentEffExprDisp == "")
		{
			return;
		}
		
		var tmp = currentEffExprDisp;
		var tmpId = currentEffExprActual;

		var textarea = "left";
		tmploopout = 0;

		formExpressionApplicabilityDialog(tmp,tmpId,textarea) ;

	} // end of function	
function formExpressionApplicabilityDialog(tmp,tmpId,textarea) {
		var ruleType = 'FullName';	
		if(textarea == "left"){
			insertExp = document.BCform.LeftExpression ;
		} 
		
		for (var vCount = 0 ; vCount < expArr.length ; vCount++ ){
			
			var vFeatureName = expArr[vCount];
			var vFeatureId = expArrAc[vCount];

			var vFName = trim(vFeatureName);
			var VFId = trim(vFeatureId)

			if (vFName ==""){
				continue;
			}
			// Logical Operators 
			if ( vFName == "AND" || vFName == "OR" || vFName == "NOT" || vFName == "(" || vFName == ")")
			{
				computeRule =  computeRule +" "+ "<B>" + vFName+" " + "</B>" ; 
				var objDIV = document.getElementById("mx_divRuleText"); 
				objDIV.innerHTML = computeRule.toString();
				addOption(insertExp,vFName,vFName,"Operator");
			
			}else {
				computeRule =  computeRule +" "+ "<B>" + vFName+" " + "</B>" ; 
				var objDIV = document.getElementById("mx_divRuleText"); 
				objDIV.innerHTML = computeRule.toString();
				addOption(insertExp,vFName,VFId,"Operand");
			}
			}
			computeRule1 = "<B>"+computeRule + "</B> "; 
			var objDIV1 = document.getElementById("mx_divRuleText"); 
			objDIV1.innerHTML = computeRule1.toString();
			
}
function getSelectedEffType()
{
		var vSelected = document.getElementById('typeSelector_mx_divFilter1').selectedIndex;
		var vDisplayType = document.getElementById('typeSelector_mx_divFilter1').options[vSelected].text;
		var vActualType = document.getElementById('typeSelector_mx_divFilter1').options[vSelected].value;
		return vActualType;
}
function getStructureValuesApplicabilityDialog()
{
		var sourceFrame = findFrame(window, "EffectivitySourceList");
		var checkedItem = sourceFrame.getCheckedCheckboxes();
		var i = 0;
		var commonParentLength = 0;
		var selectedContexts = new Object();
		for(var key in checkedItem)
		{
			var temp = checkedItem[key];
			var tempArr = temp.split("|");
			var relId = tempArr[0];
			var objId = tempArr[1];
			var parentId = tempArr[2];
			var rowId = tempArr[3];

             var ERROR_MESSAGE_FOR_ROOT_NODE_SELECTION  = "<%=i18nStringNowUtil("emxEnterpriseChange.Alert.ApplicabilityContext.RootNodeSelection", ECHBundle, acceptLanguage)%>";
			
		    var rowLevelArr = rowId.split(",");
		   if(rowLevelArr.length == 2)
	    	{
	    		//It is root node
	    		alert(ERROR_MESSAGE_FOR_ROOT_NODE_SELECTION);
	    		return 0;
	    	}
			
	    	
			if(relId == "")
			{
				parentId = objId;
				objId = "";
			}
			if(selectedContexts[parentId] == null || selectedContexts[parentId] == undefined || selectedContexts[parentId] == "undefined")
			{
				commonParentLength++;
			}
			var objColumnFN  = sourceFrame.colMap.getColumnByName("SequenceSelectable");
			var columnName = objColumnFN.name;
			var selSeq = sourceFrame.emxEditableTable.getCellValueByRowId(rowId ,columnName);
			var selectedValues = selectedContexts[parentId];
			
			if(!selectedValues)
				{
				selectedValues = new Array();
				selectedContexts[parentId] = selectedValues;
				}
			if (selSeq.value.current.actual != "")
			{
				var lvlArr = rowId.split(",");
				var contextLvlId = lvlArr[0]+","+lvlArr[1];
				
		        var temp = "/mxRoot/rows//r[@id ='" + contextLvlId + "']";
		        var contextObjRow = emxUICore.selectSingleNode(sourceFrame.oXML.documentElement,temp);
		        var caontextObjId = contextObjRow.getAttribute("o");
                var url = "../effectivity/EffectivityUtil.jsp?";
                var params = "mode=getObjectInfo&Parameter=type,name,physicalid&objectId=" + objId;
                var vRes = emxUICore.getDataPost(url, params);
                vRes = vRes.replace(/(\r\n|\n|\r)/gm,"");
                var objInfo = vRes.split(",");
			    var selectedObj = new Object();
			    selectedObj["objId"]=objId;
                selectedObj["objType"]=objInfo[0];
                selectedObj["objName"]=objInfo[1];
                selectedObj["physicalid"]=objInfo[2];
				selectedObj["contextId"]=caontextObjId;
			    selectedObj["seqSel"]=selSeq.value.current.actual;
                selectedValues[selectedValues.length]=selectedObj;
			}
			i++
		}
		selectedContexts.length=commonParentLength;
		return selectedContexts;
}	
//Function to remove the feature options
function clearAllApplicabilityDialog(textArea)
{

	if(textArea == 'left'){
	Exp = document.BCform.LeftExpression ;
	}
	
	for(i=Exp.length-1; i>=0; i--)
	{		  
		Exp.options[i] = null;	
		
	}
	
	if(bApplicabilityMode && bApplicabilityMode == "true"){
		selectedAppObj = new Object();
	}
		
}// end of method
//Function to remove the feature options
function removeApplicabilityDialog(textArea)
{

	if(textArea == 'left'){
		Exp = document.BCform.LeftExpression ;
	}


	ind = Exp.selectedIndex;

	if (ind == -1){
		giveAlert("USER_SELECTION_LIST");
		return;
	}

	var expValue = Exp.options[ind].value;
	var expText = Exp.options[ind].text;
            
	if (ind != -1) {
		for(i=Exp.length-1; i>=0; i--)
		{
			if(Exp.options[i].selected)
			{					
				var selectedValue = Exp.options[i].value;
				var selectedAppOptions = new Object(); 
				// Added to fix IR-201510V6R2014
				if(selectedValue!='OR'){
					for(var key in selectedAppObj)
					{
                        //selectedValue is actual expression
                        //extract physicalid to compare
                        var physicalId = "";                        
                        var iPhyIdPrefixIndex = selectedValue.indexOf("PHY@EF:");
                        var iSeriesOpenBracketIndex = selectedValue.indexOf("[");                       
                        if(iPhyIdPrefixIndex != -1 && iSeriesOpenBracketIndex != -1){
                            physicalId = selectedValue.substring(iPhyIdPrefixIndex+7, iSeriesOpenBracketIndex);
                        }
						selectedAppOptions = selectedAppObj[key];
						var optionObjSeq = selectedAppOptions["seqSel"];
                        var optionPhysicalId = selectedAppOptions["physicalid"];
                        if(physicalId==optionPhysicalId){
							delete selectedAppObj[key];
                            break;
						}					
					}
				}

				
				Exp.options[i] = null;
		} //end of for
	}	
		if (Exp.length > 0) {
			Exp.selectedIndex = ind == 0 ? 0 : ind - 1;
		}
	}

}// end of method



</script>
</body>
</html>
