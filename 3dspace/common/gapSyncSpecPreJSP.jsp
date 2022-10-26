<!DOCTYPE html>
<html>
<head>
</head>
<body>
<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<script language="javascript" src="../common/scripts/emxUIConstants.js"></script>
<script language="javascript" src="../common/scripts/emxUICore.js"></script>
<script language="javascript" src="../common/scripts/emxUIModal.js"></script>
<%
		String strObjectId  = emxGetParameter(request,"objectId");
		
		String strErrorMessage = null;
		try{
		Map programMap = new HashMap();		
		programMap.put("objectId", strObjectId);
		String[] strArgs1  = JPO.packArgs(programMap);
		//strErrorMessage    = (String) JPO.invoke(context, "gapSAPValidateUser", null, "syncSpecToSAP", strArgs1, String.class);
		DomainObject domchangeObj=DomainObject.newInstance(context);
		   domchangeObj.setId(strObjectId);
		   String typepattern=DomainConstants.TYPE_PART;
		   StringList selectStmts1	=	new StringList();
		   selectStmts1.addElement(DomainConstants.SELECT_ID);
		   selectStmts1.addElement(DomainConstants.SELECT_NAME);
		   selectStmts1.addElement(DomainConstants.SELECT_REVISION);
		   StringList selectrelStmts1	=	new StringList();
		   selectrelStmts1.addElement(DomainConstants.SELECT_RELATIONSHIP_ID);

		  MapList relatedSpec = domchangeObj.getRelatedObjects(context,
				  DomainConstants.RELATIONSHIP_PART_SPECIFICATION,
					"gapGAPSpecification",
					selectStmts1,
					selectrelStmts1,
					false,
					true,
					(short) 1,
					null,
					null);
		  StringBuffer sbMQL = new StringBuffer();
		  StringBuffer sbConnectionHistory = new StringBuffer();
		  
		  for (int i=0;i<relatedSpec.size();i++)
		  {
			  sbMQL.setLength(0);
			  
			  Map mp = (Map) relatedSpec.get(i);
			  
			  String strSpecId = (String) mp.get(DomainConstants.SELECT_ID);
			  String strSpecName = (String) mp.get(DomainConstants.SELECT_NAME);
			  String strSpecRev = (String) mp.get(DomainConstants.SELECT_REVISION);
			  sbConnectionHistory.append(strSpecName).append(" --> ").append(strSpecRev).append(" : ");
			  sbMQL.append("exec prog cenitEV6SAPJPO ")
			  	   .append(strSpecId)
			  	   .append(" RelationshipPartSpecificationCreateActionSyncToSAP 0 Online ").append(strObjectId);
			  String sResult = MqlUtil.mqlCommand(context, sbMQL.toString());
			  if (UIUtil.isNotNullAndNotEmpty(sResult))
				sbConnectionHistory.append(" FAILED ").append(sResult);
			  else
				sbConnectionHistory.append(" Done!");
			sbConnectionHistory.append("\\n");
		  }
		strErrorMessage = sbConnectionHistory.toString();
	}
	catch (Exception exp)
	{
		exp.printStackTrace();
		strErrorMessage = exp.getMessage();
		System.out.println("from JSP : "+strErrorMessage);
	}
%>
<script type="text/javascript">

//top.alert("Success2");
var sMsg = "<%=strErrorMessage%>";
top.alert(sMsg);
top.close();
</script>
</body>
</html>