<%--  emxInfoRelationshipDetails.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
  $Archive: /InfoCentral/src/infocentral/emxInfoRelationshipDetails.jsp $
  $Revision: 1.3.1.3$
  $Author: ds-mbalakrishnan$

--%>

<%--
 *
 * $History: emxInfoRelationshipDetails.jsp $
 * 
 * *****************  Version 13  *****************
 * User: Rahulp       Date: 1/20/03    Time: 6:33p
 * Updated in $/InfoCentral/src/infocentral
 * 
 * ***********************************************
 *
--%>

<%@include file= "../common/emxNavigatorInclude.inc"%>
<%@include file= "emxInfoTableInclude.inc" %>
<%@include file= "emxInfoTreeTableUtil.inc"%>
<jsp:useBean id="emxTableObject" class="com.matrixone.apps.framework.ui.UITable" scope="request"/>

<script language="JavaScript">
function findNode(parentNode,relId,nodes){
	if (parentNode.hasChildNodes) {
			for (var i=0; i < parentNode.childNodes.length; i++)
		    {
				var node = parentNode.childNodes[i];
				if(node.relId==relId ){
					nodes[nodes.length]=node;
				}
				findNode(node,relId,nodes);
			}
	}
}
function loadNode(parentNode,nodeId,nodeName){
	if (parentNode.hasChildNodes) {
			for (var i=0; i < parentNode.childNodes.length; i++)
		    {
	
				var node = parentNode.childNodes[i];
				if(node.nodeID==nodeId){
					node.name=nodeName;
					return ;
				}
				else
				   loadNode(node,nodeId,nodeName);

		  }
     }
}
</script>
<!-- content begins here -->

<%!
// open the table and return the table values s a formatted string
//strings in table cells are truncated at a logical percentage of total column width
static public String reloadTableRowValue(Vector vectorTableCols, Hashtable data,Hashtable relData,Context context)// Function FUN080585 : Removal of Cue, Tips and Views
{
	String sDataStr = "";
	//get users session based on the request
	boolean truncate = true;
	Enumeration eNumCol = vectorTableCols.elements();
	//iterate through each column and get data from passed into Hashtable @ iExpressionInx
	while (eNumCol.hasMoreElements()) 
	{
		Vector vectorTempCol = (Vector)eNumCol.nextElement();
		double dWidth = ((Integer)vectorTempCol.elementAt(2)).doubleValue();
		boolean useBusBool = ((Boolean)vectorTempCol.elementAt(iUseBusBoolInx)).booleanValue();
		String sExp = (String)vectorTempCol.elementAt(iExpressionInx);
		String sValue="";
		Object val=null;
		if(useBusBool)
		{
				val = data.get(sExp);
		}
		else
    			val = relData.get(sExp);
		if(val!=null){
		Class cls = val.getClass();
		if(cls.getName().equals("java.lang.String"))
			sValue = (String)val;
		else if(cls.getName().equals("matrix.util.StringList")){
			StringList strList = (StringList)data.get(sExp);
			StringItr sItr = new StringItr(strList);
			while(sItr.next()){
				sValue += sItr.obj() + "  ";
			}
		}
		}
		//use noop javascript method to get hand icon and place for an alt tag
		String sHref = "javascript:void(0)";
		String link = "";
		String sTarget = " ";
	
	    boolean editable = true;
	    if ((sValue == null)|| sValue.equals("<null>")){
			sValue = "";
			editable=false;
		}
		//use factor that looks good at res of 800x600
		double diffFactor = .35;
		double dbStrLength = (new Integer(sValue.length())).doubleValue();
		double diff = dbStrLength / dWidth;
        // replace new line characters with spaces
		if( sValue != null )
		{		    
			sValue = sValue.replace( '\n' , ' ' );
			sValue = sValue.replace( '\r' , ' ' );
		}
		String sValueTrunc = sValue;
       // code added for editing table cell 
	   // if(!isAdminTable)
		
		String attriName = "";
		String atrri = "attribute";
		String isDescription = "false";
		if(!sExp.equals("description")){
		int index    = sExp.indexOf(atrri);
        if(index!=-1){
		int index1 =index+atrri.length()+1;
		int index2 =sExp.length()-1;
        attriName = sExp.substring(index1,index2).trim();
		}
		}
		else{
			attriName="description";
			isDescription="true";
		}
	
		sValue = replaceString(sValue,"'","`");
		sValue = replaceString(sValue,"\"","``");
	
    	//test if larger than defined column width, if so truncate string but show whole string in tip.
		
		if ((diff > diffFactor) && (sValueTrunc.length() > 5) && (truncate)){
			double newDbStrLength = dWidth * diffFactor;
			int newStrLength = new Double(newDbStrLength).intValue();
			sValueTrunc = sValueTrunc.substring(0,newStrLength);
			sValueTrunc += "... ";
			// Function FUN080585 : Removal of Cue, Tips and Views
			sDataStr = sDataStr + "<td align='left' nowrap>&nbsp;"+link+"<a href=\\\"" + sHref + "\\\" onMouseOut=\\\"parent.hideAlt()\\\" onMouseOver=\\\"parent.showAlt(this,event,'" + sValue + "')\\\" title='" + sValue + "' " + sTarget + ">" + sValueTrunc + "</a>&nbsp;</td>";
		}else if (truncate){
			//put value without truncating.
			// Function FUN080585 : Removal of Cue, Tips and Views
			sDataStr = sDataStr + "<td align='left' nowrap>&nbsp;"+link+"<a href=\\\"" + sHref + "\\\" onMouseOut=\\\"parent.hideAlt()\\\" onMouseOver=\\\"parent.showAlt(this,event,'none')\\\"  " + sTarget + ">" + sValueTrunc + "</a>&nbsp;</td>";
		}else {
			//put value without truncating or other formatting
			// Function FUN080585 : Removal of Cue, Tips and Views
			sDataStr = sDataStr + "<td align='left' nowrap>&nbsp;" + sValueTrunc + "&nbsp;</td>";
		}

		truncate = true;
	}
	// Function FUN080585 : Removal of Cue, Tips and Views	
	return sDataStr;
}
%>

<%
    String sReturnPage        = Framework.getCurrentPage(session);
    String quantityAttrActualName = MCADMxUtil.getActualNameForAEFData(context, "attribute_Quantity");
    String ATTR_RELMODSTATUSINMATRIX = MCADMxUtil.getActualNameForAEFData(context, "attribute_RelationshipModificationStatusinMatrix");
    String integrationName =Request.getParameter(request,"integrationName");    
    
    MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData)session.getAttribute("MCADIntegrationSessionDataObject");
    MCADGlobalConfigObject globalConfigObject	= integSessionData.getGlobalConfigObject(integrationName,context);
    
    try 
    {
    	// Function FUN080585 : Removal of Cue, Tips and Views
        String sRelId             = emxGetParameter(request, "relId");
		String sBusId            = emxGetParameter(request, "objectId");
        String sAttrValue = null;
        String sAttrVal  = "";
        String sAttrComboVal = "";
        String sAttName     = "";
		Hashtable relTable = new Hashtable();
		double tz = (new Double((String)session.getValue("timeZone"))).doubleValue();
		
        Relationship relGeneric   = new Relationship(sRelId);
        relGeneric.open(context);
		relTable.put("name",relGeneric.getTypeName());
        //Get all the attributes on the relationship into an iterator
        AttributeItr attrItrGeneric = new AttributeItr(relGeneric.getAttributeValues(context,false));
        AttributeList attrListGeneric = new AttributeList();
        //Get the attribute values from the dialog page and put them in a list
        String sTrimVal   = "";
        
        //modified in web ui
        boolean isModified = false;
        String relType = relGeneric.getTypeName();        
        
        while (attrItrGeneric.next()) {
	        //To get the type of the attribute
	        Attribute attrGeneric = attrItrGeneric.obj();
	        AttributeType attrTypeGeneric = attrGeneric.getAttributeType();
	        attrTypeGeneric.open(context);
	        String sDataType       = attrTypeGeneric.getDataType();
	        attrTypeGeneric.close(context);
	        sAttrComboVal  = "" ;
	        sAttrVal = "";
	        sAttName = attrGeneric.getName();
            
	        String sAttValueDB = attrGeneric.getValue();
	        
	        String[] arr = new String[2];
	        arr[0] = relType;
	        arr[1] = sAttName;	        
	        boolean isAttrPresent = globalConfigObject.isValuePresentInMxCADRelAttributesMap(arr);
	        
			//[IR-351183]:START
			//"Quantity" attribute is not editable on the rel details page.
			//So value computed and displayed, for two or more sub component relationships to same object
			//should not be updated back on relationship. Its just for display purpose.
			if( sAttName!= null && !sAttName.isEmpty() && sAttName.equalsIgnoreCase(quantityAttrActualName))
			{
				continue;
			}
			//[IR-351183]:END
	   	       
	        sAttrVal = emxGetParameter(request, sAttName);

			if(sAttrVal == null)
				sAttrVal = "";
				
			if( sDataType.equals("timestamp") && sAttrVal != null && !sAttrVal.equals("") && !sAttrVal.equals("null") ) //timestamp check Added to fix issue:288960 [Cannot edit relationship attributes of a connection]
			{
					sAttrVal = com.matrixone.apps.domain.util.eMatrixDateFormat.getFormattedInputDate(sAttrVal, tz, request.getLocale());
			}
    	    
    	    sAttrComboVal = emxGetParameter(request, sAttName+"_combo");

	        if( (sAttrVal != null) && (!sAttrVal.equals(""))) {
		        sAttrValue = sAttrVal;
	        } else {
		        sAttrValue = sAttrComboVal;
	        }
  
	        if ((sAttrValue != null) && (!sAttrValue.equals(""))) {
		        sTrimVal = sAttrValue.trim();
		        
		        if(isAttrPresent && !sTrimVal.equals(sAttValueDB)){
		        	isModified = true;		        	
		        }
		        
				relTable.put("attribute["+sAttName+"]",sTrimVal);
		        attrGeneric.setValue(sTrimVal);
		        attrListGeneric.addElement(attrGeneric);
	        }else{
				attrGeneric.setValue(sAttrVal);
				
				if(isAttrPresent && !sAttrVal.equals(sAttValueDB)){
		        	isModified = true;		        	
		               }
				
				relTable.put("attribute["+sAttName+"]",attrGeneric.getValue());
				attrListGeneric.addElement(attrGeneric);
			}
        }
        
        if(isModified)
        {
        	Attribute attrGeneric	= new Attribute(new AttributeType(ATTR_RELMODSTATUSINMATRIX), "modified");
        	relTable.put("attribute["+ATTR_RELMODSTATUSINMATRIX+"]","modified");
		attrListGeneric.addElement(attrGeneric);
        }
        
        //Update the attributes on the Business Object
        relGeneric.setAttributes(context, attrListGeneric);
        relGeneric.close(context);
		String tableName =emxGetParameter(request,"tableName");
		String isAdminTable =emxGetParameter(request,"isAdminTable");
		String sTableValues="<td ><img src=images/utilSpace.gif width=6 height=15 >&nbsp;</td>";
		if("false".equals(isAdminTable)){
		Vector vectorColList = null;
		//if null, user may have no tables defined, or tables defined with none selected
		try
		{
			vectorColList = openTable(context, tableName);
		}
		catch(MatrixException ex)
		{
			vectorColList = new Vector();
		}
		// Function FUN080585 : Removal of Cue, Tips and Views
		sTableValues += getNavigatorTableData(sBusId,sRelId,tableName,context,vectorColList,request);
	   }
	   else{
		
		Vector userRoleList = (Vector)session.getValue("emxRoleList");
    	Vector vectorColList = null;
		vectorColList = openAdminTable(context,application,request,tableName,emxTableObject,userRoleList) ;
		SelectList selListGeneric = new SelectList();
		SelectList selListGenericRels = new SelectList();
		loadTableExpressions(vectorColList, selListGeneric, selListGenericRels);
		BusinessObject bo = new BusinessObject(sBusId);
		bo.open(context);
		Hashtable busTable = bo.select(context,selListGeneric).getHashtable();
		bo.close(context);
		// Function FUN080585 : Removal of Cue, Tips and Views
    	sTableValues+=reloadTableRowValue(vectorColList, busTable,relTable,context);
	   }
	   
%>
	<script language="JavaScript">
		var table = parent.window.opener.table;
        var tree  = parent.window.opener.tree;
		if(table!=null && tree!=null){
		var nodes = new Array;
		//XSSOK
		var relID = '<%=sRelId%>';
		findNode(tree.root,relID,nodes);
		for( var i =0; i<nodes.length; i++){
		var nodeId = nodes[i].nodeID;
		//XSSOK
		loadNode(table.root,nodeId,"<%=sTableValues%>");
		}
		table.refresh();
		}
		parent.window.close();
	</script>
<%	
    } 
    catch (MatrixException e) 
    {
	  String sError = e.getMessage();
	  sError = sError.replace('\n',' ');
	  sError = sError.replace('\r',' ');
%>
	<script language="JavaScript">
	    //XSSOK
	    alert("<%=sError%>");
		parent.window.close();
	</script>
<%	
    }
%>
<!-- content ends here -->
