
<%@ page import = "com.matrixone.servlet.Framework" %>
<%@ page import = "matrix.db.Context"%>
<%@ page import = "com.matrixone.MCADIntegration.server.beans.MCADMxUtil" %>

<%
 			String vCADMxRelAttributesMap = (String) session.getAttribute("CADMxRelAttributesMap");			

			Context context= Framework.getMainContext(session);
			String ATTR_RELMODSTATUSINMATRIX = MCADMxUtil.getActualNameForAEFData(context, "attribute_RelationshipModificationStatusinMatrix");
%>

function computeRelModStatus()
{
	var aRows =  emxUICore.selectNodes(oXML,"/mxRoot/rows//r[@status='changed']");
	
	if(aRows.length > 0){
		var relMapping ="<%=vCADMxRelAttributesMap%>";
		var attrRelModStatus ="<%=ATTR_RELMODSTATUSINMATRIX%>";
				
		var pattern = /attribute\[(.*?)\]/;
		
		//There is a possibility that columns name could be differnt than the attribute name.
		//So through pattern, we are filltering following columns.
		//processColumns and  processAttr : store columns name and attribute value to be processed
		//modifyColumns : Columns to be updated with modified value
		
		//Here first we have filtered all the columns. Then we processed these columns in each row.

		var processColumns = new Array();
		var processAttr = new Array();		
		var modifyColumns = new Array();	
		
		for(var k=0;k < colMap.columns.length; k++){
					var columnType = colMap.columns[k].getAttribute("typeofColumn");
					var expression = colMap.columns[k].getAttribute("expression");
					var columnName = colMap.columns[k].getAttribute("name");
					
					if(columnType == "relationship"){
						var attrName = expression.match(pattern);
						if(attrName[1] == attrRelModStatus){
						modifyColumns[modifyColumns.length] = columnName ;
						}
						
						var isPresent = relMapping.indexOf(attrName[1]) > -1;					
						if(isPresent == true){						
							processColumns[processColumns.length] = columnName ;
							processAttr[processAttr.length] = attrName[1] ;
						}
					}
			}
					
		//Check each Row
		for(var i=0; i < aRows.length; i++)
		{
			 var id = aRows[i].getAttribute("id");
			 var relType = aRows[i].getAttribute("rel");
		
			for(var i=0; i < processColumns.length ;i++){
				var tempTypeAttr = relType+","+processAttr[i];
				if(relMapping.indexOf(tempTypeAttr) > -1){
					var currentCell = emxEditableTable.getCellValueByRowId(id, processColumns[i]);
					if(currentCell.value.old.actual != currentCell.value.current.actual){				
						for(var j=0; j < modifyColumns.length ;j++){			
						  emxEditableTable.setCellValueByRowId(id,modifyColumns[j],'modified', 'modified',true);			  
						}
					 break;
					}
			  }
			}	
		}
	}
	emxEditableTable.performXMLDataPost();
}
