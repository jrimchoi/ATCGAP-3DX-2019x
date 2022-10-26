<%@include file = "../common/emxNavigatorInclude.inc"%>
<%@page import="com.dassault_systemes.enovia.documentcommon.DCDocument"%>
<%@ page import = "java.text.*,java.io.*, java.util.*,com.dassault_systemes.enovia.dcl.*,com.dassault_systemes.enovia.dcl.service.ControlledDocumentService"%>
<%@include file="../common/enoviaCSRFTokenValidation.inc"%>
<jsp:useBean id="indentedTableBean" class="com.matrixone.apps.framework.ui.UITableIndented" scope="session"/>
<%
java.io.File file = null;
try{
	
	context = Framework.getFrameContext(session);
	String strId = Request.getParameter(request, "parentOID");
	if(UIUtil.isNullOrEmpty(strId))
		strId=Request.getParameter(request, "objectId");
	String timeStamp = Request.getParameter(request, "timeStamp");
	String rowIds = Request.getParameter(request, "rowIds");
	String sbMode= Request.getParameter(request, "sbMode");
	String strReportTitle = Request.getParameter(request,"reportTitle");

	String strGroupingRows = Request.getParameter(request, "bGroupingRows");
	boolean bGroupingRows = false;
	if(strGroupingRows.equalsIgnoreCase("true")){
		bGroupingRows = true;
	}
	String[] groupData = null;
	int[] groupRowIndex = null;
	
	if(bGroupingRows){
		String tempGroupData = Request.getParameter(request, "groupData");
		StringTokenizer strTkns1 = new StringTokenizer(tempGroupData,",");
		groupData = new String[strTkns1.countTokens()];
		int i=0;
		while(strTkns1.hasMoreTokens()){
			groupData[i++] = strTkns1.nextToken();
		}
		
		String tempGroupRowIndex = Request.getParameter(request, "groupRowIndex");
		StringTokenizer strTkns2 = new StringTokenizer(tempGroupRowIndex,",");
		groupRowIndex = new int[strTkns2.countTokens()];
		i=0;
		while(strTkns2.hasMoreTokens()){
			groupRowIndex[i++] = Integer.parseInt(strTkns2.nextToken());
		}
	}
	String csvData = indentedTableBean.getCSVData(context,timeStamp,rowIds, sbMode, groupRowIndex, groupData,bGroupingRows);
	csvData = FrameworkUtil.findAndReplace(csvData,"&amp;","&");
	csvData = FrameworkUtil.findAndReplace(csvData,"&lt;","<");
	csvData = FrameworkUtil.findAndReplace(csvData,"&gt;",">");
	csvData = FrameworkUtil.findAndReplace(csvData,"0x08"," ");
	
	String fieldSeparator = PersonUtil.getFieldSeparator(context);
	String recordSeparator = PersonUtil.getRecordSeparator(context);
	String scarriageReturn = PersonUtil.getRemoveCarriageReturns(context);

	HashMap tableData = indentedTableBean.getTableData(timeStamp);
    HashMap tableControlMap = indentedTableBean.getControlMap(tableData);
    String header =indentedTableBean.getPageHeader(tableControlMap);
    //START---for table subheader display 
    String languageStr = request.getHeader("Accept-Language");
    HashMap requestMap=indentedTableBean.getRequestMap(tableData);
    String subHeader = Request.getParameter(request,"subHeader");
    if(!(subHeader == null || "null".equalsIgnoreCase(subHeader))){
       requestMap.put("subHeader", subHeader);
       tableControlMap.put("subHeader", subHeader);
    }
    String subHeaderLabel=(String)requestMap.get("subHeader");
    String suiteKey = (String)requestMap.get("suiteKey");
    String objectId = (String)requestMap.get("objectId");
    //END---for table subheader display 
	
	StringBuilder formattedExpData=new StringBuilder(512);
    String record;
	recordSeparator = "\r\n";
	if (fieldSeparator != null)	{
		fieldSeparator=getCharacterValue(fieldSeparator);
	} else {
		fieldSeparator=",";
	}
	StringTokenizer st1 = new StringTokenizer(csvData,"\n");
    String formattedRecord = "";
	while (st1.hasMoreTokens()){
		record = st1.nextToken().trim();
				
		if(record.indexOf('\r') != -1){
	    	StringList recordList = FrameworkUtil.split(record, ",");
	        record = "";
	        for (int itr = 0; itr < recordList.size(); itr++){
	        	String tempRecord = (String)recordList.get(itr);
	            if (tempRecord != null && tempRecord.indexOf("\"=") != -1 && tempRecord.indexOf('\r') != -1){
	                        tempRecord = tempRecord.substring(3, tempRecord.length() - 2);
	                    }

				if (record!=null && record.length() == 0){
	            	record = tempRecord;
				} else{
	            	 record = record + "," + tempRecord;
	            }
			}
		}

		record = FrameworkUtil.findAndReplace(record,"\r"," ");
	    record = FrameworkUtil.findAndReplace(record,",",fieldSeparator);
			   
		if(record.endsWith("\",")) {
			formattedRecord = record;
		}else {
	    	formattedRecord = FrameworkUtil.findAndReplace(record, ",", fieldSeparator+"");
		}
			   
		if(formattedRecord.endsWith(",")) {
	    	formattedRecord = formattedRecord.substring(0, formattedRecord.length() - 1) + fieldSeparator;
		}
		
		//START---for table subheader display 
		if ( (subHeaderLabel != null) && (subHeaderLabel.trim().length() > 0) ){
	    	if(formattedRecord.equalsIgnoreCase(subHeaderLabel)){
	        	String subHeaderValue=UINavigatorUtil.parseHeader(context, pageContext, subHeaderLabel, objectId, suiteKey, languageStr);
	        	formattedRecord=subHeaderValue;
			} 
		}
	    //END---for table subheader display 
	    formattedExpData.append(formattedRecord);   
	    formattedExpData.append(recordSeparator);

	}
	csvData = formattedExpData.toString();
	csvData = FrameworkUtil.findAndReplace(csvData, "<M:yN:ewLine>","\n");
	csvData = FrameworkUtil.findAndReplace(csvData, "N:Com:Sep", ",");
	csvData = FrameworkUtil.findAndReplace(csvData, "N:SemiCol:Sep", ";");
	
	String fileCreateTimeStamp =  Long.toString(System.currentTimeMillis());
	StringBuilder sbFileName = new StringBuilder(50);
	sbFileName.append(header.replaceAll("[\\\\/:?\\*<>\"|]", "_"));
	sbFileName.append(fileCreateTimeStamp);
	sbFileName.append(".csv");
	
	file = new java.io.File(sbFileName.toString());	
    Writer fileOutput = new BufferedWriter(new FileWriter(file));
    fileOutput.write(csvData);
    fileOutput.flush();
    fileOutput.close();

    DateFormat dateFormat = new SimpleDateFormat("ddMMMyyyy HH:mm:ss");
    Calendar cal = Calendar.getInstance();
	
    String strDocId = DCLUtil.createDocumentWithFile(context, file, strReportTitle+ " Assessment Report " + dateFormat.format(cal.getTime()));
    DomainObject dobj = DomainObject.newInstance(context, strDocId);
    String strDocName = dobj.getInfo(context, DomainObject.SELECT_NAME);
    
    DCDocument.addReferenceDocuments(context, strId ,new String[]{strDocId});
	String strSuccess = MessageUtil.getMessage(context, null, "enoDocumentControl.Alert.AssessmentReportAdded",
			new String[] {strDocName},
			null, context.getLocale(),
			 DCLConstants.DCL_STRING_RESOURCE);
    %>
    <script type="text/javascript">
	/* XSSOK */	alert("<%=strSuccess%>");
	</script>
    
    <%
}catch(Exception e){
	out.println(e.getMessage());
}finally{
	if(file!= null && file.exists())
	{
		file.delete();
	}
}
%>
<%!
static public String getCharacterValue(String strValue)
{
if(strValue==null || strValue.length() == 0){
    return "";
}else{
    if ( strValue.equalsIgnoreCase("Pipe") ){
        strValue = "|";
    }else if ( strValue.equalsIgnoreCase("Comma") ){
        strValue = ",";
    }else if ( strValue.equalsIgnoreCase("Tab") ){
        strValue = "\t";
    }else if ( strValue.equalsIgnoreCase("Semicolon") ){
        strValue = ";";
    }
}

return strValue;
}

%>
