<%--  emxInfoTreeTableUtil.inc

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
$Archive: /InfoCentral/src/infocentral/emxInfoTreeTableUtil.inc $
$Revision: 1.3.1.3$
$Author: ds-mbalakrishnan$
		 

--%>

<%--
*
* $History: emxInfoTreeTableUtil.inc $
* 
* *****************  Version 64  *****************
* User: Shashikantk  Date: 2/07/03    Time: 7:40p
* Updated in $/InfoCentral/src/infocentral
* 
* ************************************************
*
--%>
<%@ page import="com.matrixone.apps.framework.ui.UITable"%>
<%@ page import = "com.matrixone.apps.domain.DomainObject" %>
<%@ page import="com.matrixone.MCADIntegration.uicomponents.beans.*" %>
<%@include file="emxInfoUtils.inc"%>             <%--Put IEF Menu Name in session--%>
<%--CueTip-Start--%>
<%@ page import = "com.matrixone.MCADIntegration.uicomponents.util.*"%>
// Function FUN080585 : Removal of Cue, Tips and Views
<%--CueTip-End--%>

<!-- IEF imports Start -->
<%@ page import = "matrix.db.*, matrix.util.*,com.matrixone.servlet.*,java.util.*" %>
<%@ page import = "com.matrixone.MCADIntegration.server.beans.*,com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.*,com.matrixone.apps.domain.util.*" %>
<!-- IEF imports End -->
<script language="JavaScript" type="text/javascript" src="../common/scripts/emxUICore.js"></script>

	<script language="JavaScript" >
	function checkoutWithValidation(integrationName, objectID, instanceName, representationName, dmuSessionName)
{
	var integrationFrame = getIntegrationFrame(this);
	//cannot go ahead if unable to locate integration frame.
	if(integrationFrame == null)
	{
		alert("Integration Applet is not available. Please close the browser and login again.");
		return;
	}

	var checkoutStatusDetails = integrationFrame.getAppletObject().callCommandHandlerSynchronously(integrationName, "getValidCheckoutObjectID", objectID);

	//Type casting to String type
	checkoutStatusDetails = checkoutStatusDetails + "";

	var checkoutStatusElements	= checkoutStatusDetails.split('|');
	var checkoutDetails			= checkoutStatusElements[1] + "|" + instanceName + "|" + representationName + "|" + dmuSessionName;

	checkout(integrationName, checkoutStatusElements[0], checkoutDetails, checkoutStatusElements[2], "interactive", "false");
}
	</script>


<%!

// define index constants
static public int iLabelInx = 0;
static public int iExpressionInx = 1;
static public int iWidthInx = 2;
static public int iUseBusBoolInx = 3;
static public int iRelObj = 4;
static public int iTableWidth = 100;
static public int isEditableInx= 4;
static public int iColumnTypeInx   = 4;
static public int iProgramNameInx  = 5;
static public int iFunctionNameInx = 6;

// open the table and return the label, expression and width for each column
static public Vector openTable(matrix.db.Context context, String sTableName) throws MatrixException
{
    // read the default table list, and look this table up
    String sRoleName = null;
    Role role = null;
	if(sTableName.indexOf("::") != -1){
		sRoleName = sTableName.substring(0, sTableName.indexOf("::"));
		sTableName = sTableName.substring(sTableName.indexOf("::") +2);		
		role = new Role(sRoleName);
	}   
	
	//Visuals visualsDefault = null;
	//FUN080585: Removal of deprecated function getDefaultVisuals
	
	if(sRoleName == null || "null".equalsIgnoreCase(sRoleName)){
		//visualsDefault = null; //context.getDefaultVisuals();
    }else{
		try{
			context.connect();
			role.open(context,true);				            
			//visualsDefault = null; //role.getDefaultVisuals(context);
			role.close(context);
		}catch(Exception matrixexception) {System.out.println("Matrix Exception-->emxInfoTreeTableUtil.inc.openTable()--> " + matrixexception.getMessage()); }
        finally
        {
            try
            {
                context.disconnect();
            }
            catch(Exception matrixexception1) {System.out.println("Matrix Exception--> Finally-->emxInfoTreeTableUtil.inc.openTable() --> " + matrixexception1.getMessage()); }
        }
		
    }
    
    Table tableGeneric = null;
    Vector vectorColList = new Vector();
    
    //if (null != visualsDefault)
    //	visualsDefault.getTables().find(sTableName);
	
    //if table is not found through an exception
    if( tableGeneric == null )
    {
        //throw ( new MatrixException() );
    }
    else
    {
	    tableGeneric.open(context, true);
		
	    int iScaledTotal = 0;
		
	    // read the table column definitions
	    TableColumnItr tableColItrGeneric = new TableColumnItr(tableGeneric.getTableColumns());
	    tableGeneric.close(context);
	    	
		while (tableColItrGeneric.next()) {
			Vector vectorColDef = new Vector();
	        TableColumn column = (TableColumn)tableColItrGeneric.obj();
			// define the label for the column
			String sLabel = column.getLabel();
			if (sLabel == null || sLabel.equals("(Untitled)")) {
				sLabel = "&nbsp;";
			}
			vectorColDef.add(sLabel);
			//table expression
			String sExp = column.getExpression();
			
			vectorColDef.add(sExp);
			
			// scale down the pixel values to fit within table definition
			int iScaledWidth = ((int)column.getWidth());
			
			iScaledTotal = iScaledTotal + iScaledWidth;
			vectorColDef.add(new Integer(iScaledWidth));
			
			
			Boolean boolUseBus = new Boolean(column.usesBusinessObject());
			vectorColDef.add(boolUseBus);
			
			vectorColDef.add(new Boolean(column.isEditable())); 
			
			vectorColList.add(vectorColDef);
			
	    }
    }
	
    // need to add round of correction here
    return vectorColList;
}

// open the table and return the label, expression and width for each column
static public Vector openTableWithCheckBox(matrix.db.Context context, String sTableName) throws MatrixException
{
	Vector vectorColList = openTable(context, sTableName);

	//For checkbox column in workspace tables.
	Vector tempVector = new Vector();
	tempVector.add("");
	tempVector.add("checkbox");
	tempVector.add(new Integer(iTableWidth));
	tempVector.add(new Boolean(true));
	tempVector.add("icon");
	tempVector.add("");
	tempVector.add("");
	vectorColList.add(0, tempVector);
	
    // need to add round of correction here
    return vectorColList;
}
%>
<%!

static public String replaceString(String str,String replace,String newString){
	while(str.indexOf(replace)!=-1){
		int index =str.indexOf(replace);
		String restStr=str.substring(index+replace.length());
		str=str.substring(0,index)+newString+restStr;
	}
	return str;
}

%>
<%!
// open the table and return the table headings as a formatted String for Default table
static public String getFlatTableHeadings(Vector vectorTableCols,HttpServletRequest req,boolean isDefaultTable, String sortDirection, String sortColumnName, String sPFmode)
{
	String sHeaderStr = "";
	Enumeration eNumCol = vectorTableCols.elements();
	Vector vectorTempCol = null;
	Integer iWidth = null;
	String sLabel = null;
	
	while (eNumCol.hasMoreElements()) {
		vectorTempCol = (Vector)eNumCol.nextElement();
		iWidth = (Integer)vectorTempCol.elementAt(2);
		sLabel = (String)vectorTempCol.elementAt(0);
		if (isDefaultTable) {
			sLabel = i18nStringNowLocal(sLabel,req.getHeader("Accept-Language"));
		}
		//encode the label
		//	sLabel = java.net.URLEncoder.encode( sLabel );
		String sortImage = "";
		String nextSortDirection = "";
		if (sortDirection.compareTo("ascending") == 0)
		{
			nextSortDirection = "descending";
			sortImage = "../common/images/utilSortArrowUp.gif";
		} else {
			nextSortDirection = "ascending";
			sortImage = "../common/images/utilSortArrowDown.gif";
		}
		
		if( sPFmode != null && sPFmode.equals("true") )
		{
			sHeaderStr = sHeaderStr + "<th align='left' class=heading nowrap >";
			sHeaderStr = sHeaderStr + sLabel + "</th>";
		}
		else
		{
			if( sortColumnName.compareTo(sLabel) == 0 )
			{
				//column name matches with this ...display the image next to this column
				//on this column sorting again changes the direction
				String progArgument = "'" + sLabel +"','" + nextSortDirection + "','true'"; 
				
				sHeaderStr = sHeaderStr + "<th align='left' class=heading nowrap ><table border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><tr><th>";
				sHeaderStr = sHeaderStr + "<a href= ";
				sHeaderStr = sHeaderStr + "\"javascript:reloadTable(" + progArgument + ")\">" + sLabel + "</a>";
				sHeaderStr = sHeaderStr + "</th><td><img src=" + sortImage + " " + "align=\"absmiddle\" border=\"0\" /></td></tr></table>";
				sHeaderStr = sHeaderStr + "</th>"; 
				
			}
			else
			{
				//for rest of the columns sort direction remains the same
				String progArgument = "'" + sLabel +"','" + sortDirection + "','true'";
				
				sHeaderStr = sHeaderStr + "<th align='left' class=heading nowrap >";
				sHeaderStr = sHeaderStr + "<a href= ";
				sHeaderStr = sHeaderStr + "\"javascript:reloadTable(" + progArgument + ")\">" + sLabel + "</a></th>";
			}
		}
		
	}
	return sHeaderStr;
}
%>

<%!
// open the table and return the table values s a formatted string
//strings in table cells are truncated at a logical percentage of total column width
// Function FUN080585 : Removal of Cue, Tips and Views
static public String loadTableValues(Vector vectorTableCols, Hashtable data, RelationshipWithSelect relSelect, HttpServletRequest request,Context context,boolean isAdminTable,String tableName,boolean isPrinterFriendly)
{
	String sDataStr = "";
	//get users session based on the request
	HttpSession session = request.getSession();
	boolean truncate = true;
	Enumeration eNumCol = vectorTableCols.elements();
	
	//use noop javascript method to get hand icon and place for an alt tag
	String sHref = "javascript:void(0)";
	String link = "";
	String sTarget = " ";
	String id = (String)data.get("id");
	String relId = (String)data.get("id[connection]");

	boolean editable = true;
	boolean bReadAccess=true;
	
	//Added by nagesh on 9/2/2004
	if(id.equals("#DENIED!"))
	{           
		bReadAccess=false;
	}
	
	//Added by nagesh on 10/2/2004
	boolean IsbrowserIE=false;
	String browser_agent = request.getHeader("USER-AGENT");
	if(!(browser_agent.indexOf("MSIE") > 0))
	{           
		IsbrowserIE = true;
	}
	//End of Add by nagesh on 10/2/2004
	
	Hashtable relDataHash =null;
	if (relSelect != null)
	{
		relDataHash = relSelect.getRelationshipData();
	}

	//iterate through each column and get data from passed into Hashtable @ iExpressionInx
	while (eNumCol.hasMoreElements()) 
	{
		Vector vectorTempCol = (Vector)eNumCol.nextElement();
		double dWidth = ((Integer)vectorTempCol.elementAt(2)).doubleValue();
		boolean useBusBool = ((Boolean)vectorTempCol.elementAt(iUseBusBoolInx)).booleanValue();
		String sExp = (String)vectorTempCol.elementAt(iExpressionInx);
		char charAtStart = sExp.charAt(0);
		

		sExp = sExp.replace(charAtStart,Character.toLowerCase(charAtStart));

		String columnType   = null;
		String programName  = null;
		String functionName = null;

		if(vectorTempCol.size() > iColumnTypeInx+1)
		{
			columnType   = (String)vectorTempCol.elementAt(iColumnTypeInx);
			programName  = (String)vectorTempCol.elementAt(iProgramNameInx);
			functionName = (String)vectorTempCol.elementAt(iFunctionNameInx);
		}

		String sValue="";
		if(useBusBool)
		{
			if (columnType != null && columnType.equalsIgnoreCase("icon") ) 
			{
				truncate = false;		
				String menuName = "";
				try
				{
					menuName = getINFMenuName( request, context, id );
				}
				catch( Exception me )
				{
					System.out.println("Exception: "+me.getMessage());
					me.printStackTrace();
				}

				if(sExp.equals("checkbox"))
				{
					String checkboxName = "emxTableRowId";
					String sCheckboxValue =  relId + "|" + id;
					
					if(isPrinterFriendly)
					{
						sValue = sValue + "<img src='images/iconCheckoffdisabled.gif'>";
					}
					else
					{
						sValue = sValue + "<input type='checkbox' name='" + checkboxName+ "' value='" + sCheckboxValue + "' onclick='parent.doCheckboxClick(this);parent.doSelectAllCheck()'>";
					}
				}
				else
				{
					String detailsURL = "../common/emxTree.jsp?AppendParameters=true&objectId=" + id;
					sValue = sValue + "&nbsp;<a href='javascript:parent.showDetailsPopup(\"" + detailsURL + "\")'><img src='../common/images/iconActionNewWindow.gif' border='0'/></a>&nbsp;";

				}
			}
			else if(columnType != null && columnType.equals("programHTMLOutput"))
			{
				truncate = false;
				try
				{
					HashMap programMap  = new HashMap();
					HashMap paramList =   new HashMap();
					if (programName != null && functionName != null)
					{
						/* IEF additions Start */
						MCADIntegrationSessionData integSessionData = (MCADIntegrationSessionData) session.getAttribute(MCADServerSettings.MCAD_INTEGRATION_SESSION_DATA_OBJECT);

						if(integSessionData != null)
						{
							HashMap globalConfigObjectTable = new HashMap();
							globalConfigObjectTable = (HashMap)integSessionData.getIntegrationNameGCOTable(integSessionData.getClonedContext(session));

							programMap.put("GCOTable", globalConfigObjectTable);
							programMap.put("LocaleLanguage", integSessionData.getLanguageName());
							programMap.put("languageStr", integSessionData.getLanguageName());

							paramList.put("languageStr",integSessionData.getLanguageName());
							paramList.put("portCmdName","");
							programMap.put("paramList", paramList);
						}
						MapList relBusObjPageList = new MapList();
						HashMap objMap = new HashMap();
						objMap.put("id", id);
						relBusObjPageList.add(objMap);

						programMap.put("objectList", relBusObjPageList);
						programMap.put("paramList", programMap);
						/* IEF additions End */

						Vector columnResult = new Vector();
						String[] methodargs = JPO.packArgs(programMap);
						try 
						{
							columnResult = (Vector)JPO.invoke(context, programName, null, functionName, methodargs, Vector.class);
							if(columnResult.size() > 0)
								sValue += (String)columnResult.get(0);
						} 
						catch (MatrixException me) 
						{
							columnResult.add("");
						}
					}
				}
				catch(Exception e)
				{
					System.out.println("Error occured in executing JPOs. Error: " + e.getMessage());
				}
			}
			else
			{
				Object val = data.get(sExp);
				if(val!=null)
				{
					Class cls = val.getClass();
					if(cls.getName().equals("java.lang.String"))
						sValue = (String)val;
					else if(cls.getName().equals("matrix.util.StringList"))
					{
						StringList strList = (StringList)data.get(sExp);
						StringItr sItr = new StringItr(strList);
						while(sItr.next())
						{
							sValue += sItr.obj() + "  ";
						}
					}
				}
			}
		}
		else
		{
			sValue="";
			String tempVal = "";
			if (relSelect != null)
			{
				Enumeration relDataHashKeys = relDataHash.keys();
				tempVal = "";
				while (relDataHashKeys.hasMoreElements())
				{
					String strKey = (String)relDataHashKeys.nextElement();
					String strVal="";
					Object val = relDataHash.get(strKey);
					if(val!=null)
					{
						Class cls = val.getClass();
						if(cls.getName().equals("java.lang.String"))
							strVal = (String)val;
						else if(cls.getName().equals("matrix.util.StringList"))
						{
							StringList strList = (StringList)data.get(sExp);
							StringItr sItr = new StringItr(strList);
							while(sItr.next())
							{
								strVal += sItr.obj() + "  ";
							}
						}
					}
					if ((strVal != null) && (!"".equals(strVal)) && (sExp.equals(strKey))){
						sValue = strVal;
					}
				}
			}
		}
        //2/1/2004 NAGESH  CODE REMOVED FROM HERE
        if ((sValue == null)|| sValue.equals("<null>"))
        {
			sValue = "";
			editable=false;
		}

		//use factor that looks good at res of 800x600
		double diffFactor = .35;
		double dbStrLength = (new Integer(sValue.length())).doubleValue();
		double diff = dbStrLength / dWidth;
        // replace new line characters with spaces
		String sOrg ="";
		if( sValue != null )
		{		    
			sValue = replaceNewLines(sValue);
			sOrg =sValue;
			/*
			sValue = sValue.replace( '"' , 'v_a_l_q_u_o_t_e' );
			sValue = sValue.replace( '\\' , '`');
			sValue = sValue.replace( '\'' , '$');
			*/
			sValue = replaceString(sValue,"\"","v_a_l_q_u_o_t_e");			
			sValue = replaceString(sValue,"\\","v_a_l_f_o_r_s_l_a_s_h");
			sValue = replaceString(sValue,"'","v_a_l_a_p_o_s");
		}	
		String sValueTrunc = sValue;
		// code added for editing table cell 
		//2/1/2004 CHECK ACCESSS CODE REMOVED FROM HERE   
		if(!isAdminTable && bReadAccess && !sExp.equals("checkbox"))
		{
			String attriName = "";
			String atrri = "attribute";
			String isDescription = "false";
			if(!sExp.equals("description"))
			{
				int index    = sExp.indexOf(atrri);
				if(index!=-1)
				{
					int index1 =index+atrri.length()+1;
					int index2 =sExp.length()-1;
					attriName = sExp.substring(index1,index2).trim();
				}
			}
			else
			{
				attriName="description";
				isDescription="true";
			}
			
			boolean  found = false;
			boolean isBusAttri=false;
			boolean isEditable = ((Boolean)vectorTempCol.elementAt(isEditableInx)).booleanValue();
			if(relId==null || relId.equals("null"))
			{
				isEditable = false;
			}
			
			boolean isBus = ((Boolean)vectorTempCol.elementAt(iUseBusBoolInx)).booleanValue();
			if(isEditable && !attriName.equals("") && editable )
			{ 
				if(attriName.equals("description"))
					found=true;
				else
				{
					Attribute attribute = null;
					if(isBus)
					{
						try
						{
							DomainObject  obj =  new DomainObject(id);
							attribute = obj.getAttribute(context,attriName);
							found = attribute==null?false:true;
							isBusAttri=found;
						}
						catch(Exception e)
						{
							attribute=null;
							found = false;				
						}
					}
					else
					{
						try
						{
							if(relId!=null && !relId.equals("null")&&!found)
							{
								Relationship relationShip = new Relationship(relId);
								relationShip.open(context);
								AttributeList list = relationShip.getAttributeValues(context,false);
								for(int no=0; no<list.size();no++)
								{
									Attribute attr = (Attribute)list.get(no);
									if(attr.getName().equals(attriName))
									{
										found = true;
										break;
									}
								}
							}
						}
						catch(Exception e)
						{
							found = false;
						}
					}
				}
			}

			if(found)
			{ 
                                // Function FUN080585 : Removal of Cue, Tips and Views
				StringBuffer stbEditURL = new StringBuffer();
				stbEditURL.append("emxInfoEditTableDialogFS.jsp?busId=");
				stbEditURL.append(id);
				stbEditURL.append("&relId=");
				stbEditURL.append(relId);
				stbEditURL.append("&isBusAttri=");
				stbEditURL.append(new Boolean(isBusAttri).toString());
				stbEditURL.append("&isDescription=");
				stbEditURL.append(isDescription);
				stbEditURL.append("&navigator=true");
                                // Function FUN080585 : Removal of Cue, Tips and Views
				stbEditURL.append("&attributeValue=");
				stbEditURL.append(sOrg);
				stbEditURL.append("&attributeName=");
				stbEditURL.append(attriName);
				stbEditURL.append("&tableName=");
				stbEditURL.append(tableName);
				String editURL = stbEditURL.toString();
				
				//String editURL ="emxInfoEditTableDialogFS.jsp?busId="+id+"&relId="+relId+"&isBusAttri="+new Boolean(isBusAttri).toString()+"&isDescription="+isDescription+"&navigator=true" + strCuesTips;
				//editURL+="&attributeValue="+sOrg+"&attributeName="+attriName+"&tableName="+tableName;
				//30/12/2003 Nagesh End
				
                if(!(browser_agent.indexOf("MSIE") > 0))
				{
					editURL = FrameworkUtil.encodeURLParamValues(editURL);   
				}
				else
				{
					editURL=editURL.replace(' ','+'); 
					editURL = replaceString(editURL,"\"","q_u_o_t_e");
					editURL = replaceString(editURL,"\\","f_o_r_s_l_a_s_h");
					editURL = replaceString(editURL,"'","a_p_o_s");
					editURL = replaceString(editURL,"#","h_a_s_h_1");
					
				}							
				
				//  editURL = FrameworkUtil.encodeURLParamValues(editURL);   
				sHref = "javascript:parent.emxShowModalDialog('"+editURL+"',400,450,false)";
				if(sValueTrunc.equals(""))
					sValueTrunc="_";
			}
		}
		sValueTrunc = replaceString(sValueTrunc,"v_a_l_q_u_o_t_e","\\\"");
		sValueTrunc = replaceString(sValueTrunc,"v_a_l_f_o_r_s_l_a_s_h","\\\\");
		sValueTrunc = replaceString(sValueTrunc,"v_a_l_a_p_o_s","'");
		sOrg = replaceString(sOrg,"'","`");
		sOrg = replaceString(sOrg,"\"","``");
		sValue = sOrg;

		//30/12/2003 Nagesh start
		StringBuffer stbDataStr = new StringBuffer();
		//30/12/2003 Nagesh end
		
		//test if larger than defined column width, if so truncate string but show whole string in tip.
		if ((diff > diffFactor) && (sValueTrunc.length() > 5) && (truncate))
		{
			double newDbStrLength = dWidth * diff ;
			int newStrLength = new Double(newDbStrLength).intValue();
			sValueTrunc = sValueTrunc.substring(0,newStrLength);
			
			if(sValueTrunc.equals(""))
				sValueTrunc += "... ";

			//30/12/2003 Nagesh start
			stbDataStr.append(sDataStr);
			stbDataStr.append("<td align='left' nowrap class='");
                        // Function FUN080585 : Removal of Cue, Tips and Views
			stbDataStr.append("'>&nbsp;");
			stbDataStr.append(link);
			stbDataStr.append("<a href=\\\"");
			stbDataStr.append(sHref);
			stbDataStr.append("\\\" onMouseOut=\\\"parent.hideAlt()\\\" onMouseOver=\\\"parent.showAlt(this,event,'");
			stbDataStr.append(sValue);
			stbDataStr.append("')\\\" title='");
			stbDataStr.append(sValue);
			stbDataStr.append("' ");
			stbDataStr.append(sTarget);
			stbDataStr.append(" class='");
                        // Function FUN080585 : Removal of Cue, Tips and Views
			stbDataStr.append("'>");
			stbDataStr.append(sValueTrunc);
			stbDataStr.append("</a>&nbsp;</td>");
			sDataStr = stbDataStr.toString(); 
			//sDataStr = sDataStr + "<td align='left' nowrap class='"+strCueClass+"'>&nbsp;"+link+"<a href=\\\"" + sHref + "\\\" onMouseOut=\\\"parent.hideAlt()\\\" onMouseOver=\\\"parent.showAlt(this,event,'" + sValue + "')\\\" title='" + sValue + "' " + sTarget + " class='"+strCueClass+"'>" + sValueTrunc + "</a>&nbsp;</td>";
			//30/12/2003 Nagesh end
		}
		else if (truncate)
		{
			if(isPrinterFriendly)
			{
				stbDataStr.append(sDataStr);
				stbDataStr.append("<td align='left' nowrap" );
                                // Function FUN080585 : Removal of Cue, Tips and Views
				stbDataStr.append("'>&nbsp;");
				stbDataStr.append(sValueTrunc);
				stbDataStr.append("&nbsp;</td>");
				//put value without truncating.
				sDataStr = stbDataStr.toString(); 
			}
			else
			{
				//put value without truncating.
				//30/12/2003 Nagesh start
				stbDataStr.append(sDataStr);
				stbDataStr.append("<td align='left' nowrap" );
                                // Function FUN080585 : Removal of Cue, Tips and Views
				stbDataStr.append(">&nbsp;");
				stbDataStr.append(link);
				stbDataStr.append("<a href=\\\"");
				stbDataStr.append(sHref);
				stbDataStr.append("\\\" onMouseOut=\\\"parent.hideAlt()\\\" onMouseOver=\\\"parent.showAlt(this,event,'none')\\\"  ");
				stbDataStr.append(sTarget);
                                // Function FUN080585 : Removal of Cue, Tips and Views
				stbDataStr.append("'>");
				stbDataStr.append(sValueTrunc);
				stbDataStr.append("</a>&nbsp;</td>");
				//put value without truncating.
				sDataStr = stbDataStr.toString(); 

				//30/12/2003 Nagesh end
				//sDataStr = sDataStr + "<td align='left' nowrap class='"+strCueClass+"'>&nbsp;"+link+"<a href=\\\"" + sHref + "\\\" onMouseOut=\\\"parent.hideAlt()\\\" onMouseOver=\\\"parent.showAlt(this,event,'none')\\\"  " + sTarget + " class='"+strCueClass+"'>" + sValueTrunc + "</a>&nbsp;</td>";
			}
		}
		else
		{
			//put value without truncating or other formatting
			stbDataStr.append(sDataStr);
			stbDataStr.append("<td align='left' nowrap");
                        // Function FUN080585 : Removal of Cue, Tips and Views
			stbDataStr.append(">");
                        stbDataStr.append(sValueTrunc);
			stbDataStr.append("</td>");
			sDataStr = stbDataStr.toString(); 
			//sDataStr = sDataStr + "<td align='left' nowrap class='"+strCueClass+"'>" + sValueTrunc + "</td>";
		}
		
		truncate = true;

		sDataStr = sDataStr + "<td><img src='images/utilLineVert.gif' width='16' height='20'></td>";
	}
	sDataStr = "<STYLE TYPE='text/css'> </STYLE>" + sDataStr;

	return sDataStr;
}
%>

<%!
static public String getNavigatorTableData(String busId,String relId,String tableName,
										   Context context,Vector vectorTableCols, HttpServletRequest request)
{
	boolean truncate = true;
	String sDataStr = "";
    if(busId==null)
		return sDataStr;
    //iterate through each column and get data from passed into Hashtable @ iExpressionInx
    String idStr="";
    if(busId!=null && !busId.equals("null") && busId.trim().length()>0)
		idStr = " bus "+ busId;
    if(relId!=null && !relId.equals("null") && relId.trim().length()>0)
		idStr +=" rel " +relId;
	
    MQLCommand mql = new MQLCommand();
	
    if(tableName.indexOf("::") != -1){
		String sRoleName = tableName.substring(0,tableName.indexOf("::"));
		tableName = tableName.substring(tableName.indexOf("::") + 2);
		String command1 = "set workspace user '"+ sRoleName +"'";        	
		try{		  
			mql.executeCommand(context, command1);
		}
		catch(Exception e)
		{
			System.out.println("Exception in " +command1+ " --> " +e.getMessage());
		}    	
    } // End of if(tableName.indexOf("::") != -1)
    
    String command = "evaluate  Table '"+ tableName +"'"+idStr + " dump |";
    try{
		boolean ret = mql.executeCommand(context, command);
		if(ret)
		{
			String cellData = mql.getResult().substring(0,mql.getResult().length()-1);
			StringBuffer buf = new StringBuffer(cellData);
			StringTokenizer tokenizer = new StringTokenizer(cellData , "|",true);
			ArrayList tokens = new ArrayList();
			while(tokenizer.hasMoreElements()){
				String token = (String)tokenizer.nextElement();
				tokens.add(token);
			}
			
			ArrayList list = new ArrayList();
			for(int k=0;k<tokens.size();k++)
			{
				String token     = (String)tokens.get(k);
				if(!token.equals("|")){
					list.add(token);
				}
				else{
					if(k==0)
						list.add("");
					if(k+1<tokens.size()){
						String nextToken =(String)tokens.get(k+1);
						if(nextToken.equals("|"))
							list.add("");
					}
				}
			}
			
			for( int j =0 ;j<list.size();j++)
			{
				Vector vectorTempCol = (Vector)vectorTableCols.elementAt(j);
				String sExp = (String)vectorTempCol.elementAt(iExpressionInx);
				double dWidth = ((Integer)vectorTempCol.elementAt(2)).doubleValue();
				String sValue = (String)list.get(j);
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
				String sOrg="";
				if( sValue != null )
				{		    
					sValue = replaceNewLines(sValue);
					sOrg=sValue;
					/*
					sValue = sValue.replace( '"' , '^' );
					sValue = sValue.replace( '\\' , '`');
					sValue = sValue.replace( '\'' , '$');
					*/
					sValue = replaceString(sValue,"\"","v_a_l_q_u_o_t_e");			
					sValue = replaceString(sValue,"\\","v_a_l_f_o_r_s_l_a_s_h");
					sValue = replaceString(sValue,"'","v_a_l_a_p_o_s");
				}
				String sValueTrunc = sValue;
				// code added for editing table cell 
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
				else
				{
					attriName="description";
					isDescription="true";
				}
				boolean  found = false;
				boolean isBusAttri=false;
				boolean isEditable = ((Boolean)vectorTempCol.elementAt(isEditableInx)).booleanValue();
				if(relId==null || relId.equals("null")){
					isEditable = false;
				}
				boolean isBus      = ((Boolean)vectorTempCol.elementAt(iUseBusBoolInx)).booleanValue();
				if(isEditable && !attriName.equals("") && editable){ 
					if(attriName.equals("description"))
						found=true;
					else{
						Attribute attribute = null;
						if(isBus){
							try{
								DomainObject  obj =  new DomainObject(busId);
								attribute = obj.getAttribute(context,attriName);
								found = attribute==null?false:true;
								isBusAttri=found;
							}
							catch(Exception e){
								attribute=null;
								found = false;				
							}
						}
						else{
							try{
								if(relId!=null && !relId.equals("null")&&!found){
									Relationship relationShip = new Relationship(relId);
									relationShip.open(context);
									AttributeList attriList = relationShip.getAttributeValues(context,false);
									for(int no=0; no<attriList.size();no++)
									{
										Attribute attr = (Attribute)attriList.get(no);
										if(attr.getName().equals(attriName)){
											found = true;
											break;
										}
									}				
								}
							}
							catch(Exception e)
							{
								found = false;
							}
						}
					}
				}
				if(found){ 
					// Function FUN080585 : Removal of Cue, Tips and Views
					String editURL ="emxInfoEditTableDialogFS.jsp?busId="+busId+"&relId="+relId+"&isBusAttri="+new Boolean(isBusAttri).toString()+"&isDescription="+isDescription+"&navigator=true";
					editURL+="&attributeValue="+sOrg+"&attributeName="+attriName+"&tableName="+tableName;
					
					String browser_agent = request.getHeader("USER-AGENT");
					if(!(browser_agent.indexOf("MSIE") > 0)){
						editURL = FrameworkUtil.encodeURLParamValues(editURL);   
					}
					else{
						editURL=editURL.replace(' ','+');
						editURL = replaceString(editURL,"\"","q_u_o_t_e");
						editURL = replaceString(editURL,"\\","f_o_r_s_l_a_s_h");
						editURL = replaceString(editURL,"'","a_p_o_s");
						editURL = replaceString(editURL,"#","h_a_s_h_1");
						
					}
					
					//            editURL = FrameworkUtil.encodeURLParamValues(editURL);   
					
					sHref = "javascript:parent.emxShowModalDialog('"+editURL+"',400,450,false)";
					if(sValueTrunc.equals(""))
						sValueTrunc="_";
				}
				sValueTrunc = replaceString(sValueTrunc,"v_a_l_q_u_o_t_e","\\\"");
				sValueTrunc = replaceString(sValueTrunc,"v_a_l_f_o_r_s_l_a_s_h","\\\\");
				sValueTrunc = replaceString(sValueTrunc,"v_a_l_a_p_o_s","'");
				//test if larger than defined column width, if so truncate string but show whole string in tip.
				if ((diff > diffFactor) && (sValueTrunc.length() > 5) && (truncate)){
					double newDbStrLength = dWidth * diffFactor;
					int newStrLength = new Double(newDbStrLength).intValue();
					sValueTrunc = sValueTrunc.substring(0,newStrLength);
					sValueTrunc += "... ";
					sOrg = replaceString(sOrg,"'","`");
					sOrg = replaceString(sOrg,"\"","``");
					sValue = sOrg;
					sDataStr = sDataStr + "<td align='left' nowrap>&nbsp;"+link+"<a href=\\\"" + sHref + "\\\" onMouseOut=\\\"parent.hideAlt()\\\" onMouseOver=\\\"parent.showAlt(this,event,'" + sValue + "')\\\" title='" + sValue + "' " + sTarget + ">" + sValueTrunc + "</a>&nbsp;</td>";
				}else if (truncate){
					//put value without truncating.
					sDataStr = sDataStr + "<td align='left' nowrap>&nbsp;"+link+"<a href=\\\"" + sHref + "\\\" onMouseOut=\\\"parent.hideAlt()\\\" onMouseOver=\\\"parent.showAlt(this,event,'none')\\\"  " + sTarget + ">" + sValueTrunc + "</a>&nbsp;</td>";
				}else {
					//put value without truncating or other formatting
					sDataStr = sDataStr + "<td align='left' nowrap>" + sValueTrunc + "</td>";
				}
				truncate = true;
          }
    }
    }
    catch(Exception e)
    {
		System.out.println("Exception "+e);
    }
	
    // Function FUN080585 : Removal of Cue, Tips and Views
    return sDataStr;
  }
  %>
	  <%!
	  // load the table expressions into the select list
	  static public int getHtmlTableWidth(Vector vectorTableCols)
  {
	  if ((vectorTableCols == null) || (vectorTableCols.size() == 0)){
		  return 0;
	  }
	  
	  int tot = 0;
	  Integer i = null;
	  Enumeration eNumCol = vectorTableCols.elements();
	  while (eNumCol.hasMoreElements()) {
		  Vector vectorTempCol = (Vector)eNumCol.nextElement();
		  i = (Integer)vectorTempCol.elementAt(2);
		  tot += i.intValue();
	  }
	  
	  return tot;
  }
  %>
	  
  <%!
  // load the table expressions into the select list
  static public void loadTableExpressions(Vector vectorTableCols, SelectList selListPassed, SelectList selListPassedRels)
  {
	  Enumeration eNumCol = vectorTableCols.elements();
	  while (eNumCol.hasMoreElements()) 
	  {
		  Vector vectorTempCol = (Vector)eNumCol.nextElement();
		  String sExp = (String)vectorTempCol.elementAt(iExpressionInx);
		  boolean externalExpression = false;
		  
		  //if we did not process an external expression, add the string to select list
		  if (!externalExpression)
		  {
			  boolean useBusBool = ((Boolean)vectorTempCol.elementAt(iUseBusBoolInx)).booleanValue();
			  String columnType = null;
			  if(iColumnTypeInx+1 < vectorTempCol.size())
				  columnType = (String)vectorTempCol.elementAt(iColumnTypeInx);
			  if (useBusBool || (columnType != null && columnType.equals("icon"))){
				  selListPassed.add(sExp);
			  }
			  else
			  {
				  selListPassedRels.add(sExp);
			  }
		  }
		  externalExpression = false;
	  }
  }
  %>
	  
	  
	  <%!
	  //Method to get the icon of the Respective Type
	  //using the BusinessObjectType servlet
	  static public String drawIconInNavigate( Context context, ServletContext application, String sType)
  {
	  //If servlet is to be used for getting the icon uncomment the following line
	  //return "/servlet/type/" + replaceSpace(sType) + "/icon";
	  
	  String objectIcon = "";
	  
	  try
	  {
		  objectIcon = UINavigatorUtil.getTypeIconProperty(context, application, sType);
	  }
	  catch( Exception ex)
	  {
		  //do nothing
	  }
	  
	  if (objectIcon == null || objectIcon.length() == 0 )
		  objectIcon = "../common/images/iconSmallDefault.gif";
	  else
		  objectIcon = "../common/images/" + objectIcon;

	  return objectIcon;	  
  }
  %>
	  
	  
	  <%!
	  // method to determine if the current obj has children
	  // pass in the current number object within the vector, the Rel. object and the vector holding all Rel objects
	  static public boolean hasChildren(int iChildrenCount, RelationshipWithSelect relCurrent, Vector vectAllRels) 
  {
	  //check if last element, if so return false
	  if ((iChildrenCount + 1) >= vectAllRels.size())
		  return false;
	  
	  //get next element in vector and check against level of current obj
	  RelationshipWithSelect relWithSelNext = (RelationshipWithSelect)vectAllRels.elementAt(iChildrenCount + 1);
	  
	  if (relWithSelNext == null) {
		  return false;
	  }
	  
	  if (relWithSelNext.getLevel() > relCurrent.getLevel()) {
		  return true;
	  } else {
		  return false;
	  }
  }
  %>
	  
	  
	  <%!
	  // method to determine direction of arrow to display
	  // pass in the current relationship and the parent obj
	  static public String getArrowDirection(RelationshipWithSelect relwithSelectPassed, String sParentId, boolean bExpandTo, HttpServletRequest request) 
  {
	  String relAlt = null;
	  relAlt = i18nStringNowLocal("emxIEFDesignCenter.Tree.ClickRel",request.getHeader("Accept-Language"));
	  if (relwithSelectPassed.getTo().getObjectId().equals(relwithSelectPassed.getFrom().getObjectId())) {
		  if (bExpandTo) {
			  return "<img src=images/iconTreeFromArrow.gif border=0  align=absmiddle alt='" + relAlt + "' >";
		  } else {
			  return "<img src=images/iconTreeToArrow.gif border=0  align=absmiddle alt='" + relAlt + "' >";
		  }
	  }
	  
	  if (relwithSelectPassed.getTo().getObjectId().equals(sParentId)) {
		  return "<img src=images/iconTreeToArrow.gif border=0  align=absmiddle alt='" + relAlt + "' >";
	  } else {
		  return "<img src=images/iconTreeFromArrow.gif border=0  align=absmiddle alt='" + relAlt + "' >";
	  }
  }
  %>
	  
	  
  <%!/*
	 //To replace space with "+"
	 static public String replaceSpace(String sFormatStr)
	 {
	 return sFormatStr.replace(' ','+');
}*/
%>

<%!
//create a vector similar to the vecotr created when opeing a WS Table
//this will act as a Default table

static public Vector openAdminTable( Context context, ServletContext application, HttpServletRequest request, String sTableName, UITable emxTableObject, Vector userRoleList) throws Exception
{	  
	  Vector parentVector = new Vector();
	  HashMap tableMap = new HashMap();
	  MapList columns = new MapList();
	  int noOfColumns = 0;

	  tableMap = emxTableObject.getTable(context, sTableName);
	  
	  if (tableMap == null)
	  {
		return parentVector;
	  } 
	  else
	  {
		columns = emxTableObject.getColumns(context, sTableName, userRoleList);
		  
		if (columns == null || columns.size() == 0 )
		{
			return parentVector;
		}
		else
		{
		    	noOfColumns = columns.size();
		}
	  }
  
	  Vector tempVector = null;
	  parentVector = new Vector(noOfColumns);
	  String strHeading = null;
	  String columnSelect = null;
	  String strWidth = null;
	  Integer intWidth = null;
	  String columnType = null;
	  boolean boolBusObjType = false;
	  String strName = null;
	  String programName = null;
	  String columnIcon = null;
	  String checkboxProgramName  = null;
	  String functionName = null;
	  String checkboxFunctionName = null;
	  boolean checkBoxDefined = false;
  
	  for (int i=0;i < noOfColumns;i++)
	  {
		  HashMap columnMap = (HashMap)columns.get(i);
		  strHeading = emxTableObject.getLabel(columnMap);
		  columnSelect = emxTableObject.getBusinessObjectSelect(columnMap);
          
		    columnType = emxTableObject.getSetting(columnMap, "Column Type");

            if (columnType != null && columnType.length() > 0 )
            {
                if (columnType.equalsIgnoreCase("program") )
                {
                    columnSelect = emxTableObject.getSetting(columnMap, "program");
                    if (columnSelect != null && columnSelect.trim().length() > 0)
                    {
                        programName = emxTableObject.getSetting(columnMap, "program");
                        functionName = emxTableObject.getSetting(columnMap, "function");
                    }
                } 
				else if (columnType.equalsIgnoreCase("programHTMLOutput") )
                {
					boolBusObjType = true;
                    columnSelect = emxTableObject.getSetting(columnMap, "program");
                    if (columnSelect != null && columnSelect.trim().length() > 0)
                    {
                        programName = emxTableObject.getSetting(columnMap, "program");
                        functionName = emxTableObject.getSetting(columnMap, "function");
                    }

                }
				else if (columnType.equalsIgnoreCase("icon") ) 
				{
                    columnIcon = emxTableObject.getSetting(columnMap, "Column Icon");
                    if (columnIcon != null && columnIcon.trim().length() > 0)
                    {
                        columnSelect = "";
                    }
                }
				else if (columnType.equalsIgnoreCase("checkbox") ) 
				{
                    checkboxProgramName = emxTableObject.getSetting(columnMap, "program");
                    checkboxFunctionName = emxTableObject.getSetting(columnMap, "function");
                    checkBoxDefined = true;
                }
            }
			else 
			{
                if (columnSelect != null && columnSelect.trim().length() > 0)
                {
					boolBusObjType = true;
                    columnType = "businessobject";
                    if ( columnSelect.indexOf("$") >=0 )
                        columnSelect = UIExpression.substituteValues(context, columnSelect);
                } else {
                    columnSelect = emxTableObject.getRelationshipSelect(columnMap);
                    if (columnSelect != null && columnSelect.trim().length() > 0)
                    {
					    boolBusObjType = false;
                        columnType = "relationship";
                        if ( columnSelect.indexOf("$") >=0 )
                            columnSelect = UIExpression.substituteValues(context, columnSelect);
                    }
                }
            }
		  
		  //TBD:
		  intWidth = new Integer(iTableWidth);
		  
		  //Get the string resource file ID of the registered suite ...for getting the internationalized strings of the labels
		  String registeredSuite = emxTableObject.getSetting(columnMap, "Registered Suite");
		  String stringResFileId = "";
		  
		  if (registeredSuite != null && registeredSuite.length() != 0) {
			  stringResFileId = UINavigatorUtil.getStringResourceFileId(application, registeredSuite);
		  }
		  
		  if( strHeading != null && strHeading.length() > 0 )
			  strHeading = UINavigatorUtil.getI18nString(strHeading, stringResFileId , request.getHeader("Accept-Language"));
		  else if (strHeading == null || strHeading.length() == 0)
                strHeading = "&nbsp;";

		  tempVector = new Vector(7);
		  tempVector.add(strHeading);
		  tempVector.add(columnSelect);
		  tempVector.add(intWidth);
		  tempVector.add(new Boolean(boolBusObjType));
		  tempVector.add(columnType);
		  tempVector.add(programName);
		  tempVector.add(functionName);

		  
		  //add the vector to the list
		  parentVector.add(tempVector);
	  }

	  tempVector = new Vector(7);
	  tempVector.add(""); //strHeading
	  tempVector.add("checkbox"); //columnSelect);
	  tempVector.add(intWidth);
	  tempVector.add(new Boolean(true));
	  tempVector.add("icon");
	  tempVector.add(programName);
	  tempVector.add(functionName);
	  parentVector.add(0, tempVector);

	  return parentVector;
  }
  
  %>
	  <%!
	  static public Vector evaluateTable(String busId,String relId,String tableName,Vector vectorTableCols,Context context)
  {
	  Vector rowData = new Vector();
	  if(busId==null)
		  return rowData;
	  //iterate through each column and get data from passed into Hashtable @ iExpressionInx
	  String idStr="";
	  if(busId!=null && !busId.equals("null") && busId.trim().length()>0)
		  idStr = " bus "+ busId;
	  if(relId!=null && !relId.equals("null") && relId.trim().length()>0)
		  idStr +=" rel " +relId;
	  MQLCommand mql = new MQLCommand();
	  String command = "";
	  if(tableName.indexOf("::") != -1){
		  String sRoleName = tableName.substring(0,tableName.indexOf("::"));
		  tableName = tableName.substring(tableName.indexOf("::") + 2);
		  command = "set workspace user '"+ sRoleName +"'; evaluate  Table '"+ tableName +"'"+idStr + " dump |";        	
	  }else{
		  command = "evaluate  Table '"+ tableName +"'"+idStr + " dump |";
	  } // End of if(tableName.indexOf("::") != -1)    
	  
	  try{      
		  
		  boolean ret = mql.executeCommand(context, command);      
		  if(ret)
		  {
			  String cellData = mql.getResult().substring(0,mql.getResult().length()-1);
			  StringBuffer buf = new StringBuffer(cellData);
			  StringTokenizer tokenizer = new StringTokenizer(cellData , "|",true);
			  ArrayList tokens = new ArrayList();
			  while(tokenizer.hasMoreElements()){
				  String token = (String)tokenizer.nextElement();
				  tokens.add(token);
			  }
			  
			  ArrayList list = new ArrayList();
			  for(int k=0;k<tokens.size();k++)
			  {
				  String token     = (String)tokens.get(k);
				  if(!token.equals("|")){
					  list.add(token);
				  }
				  else{
					  if(k==0)
						  list.add("");
					  if(k+1<tokens.size()){
						  String nextToken =(String)tokens.get(k+1);
						  if(nextToken.equals("|"))
							  list.add("");
					  }
				  }
			  }
			  
			  for( int j =0 ;j<vectorTableCols.size();j++)
			  {
				  
				  Vector vectorTempCol = (Vector)vectorTableCols.elementAt(j);
				  String sExp = (String)vectorTempCol.elementAt(iExpressionInx);
				  rowData.add(list.get(j));
			  }
		  }else{
			  ArrayList list = new ArrayList();
			  for( int j =0 ;j<vectorTableCols.size();j++)
			  {
				  Vector vectorTempCol = (Vector)vectorTableCols.elementAt(j);
				  String sExp = (String)vectorTempCol.elementAt(iExpressionInx);
				  //rowData.add("");
			  }
		  }
	  }
	  catch(Exception e)
	  {
		  System.out.println("Exception in evaluating table "+e);
	  }
	  
	  return rowData;
  }
  %>
	  <%!
	  private static String replaceNewLines(String s)
  {
	  String s1 = s;
	  if(s != null && (s.indexOf('\n') != -1 || s.indexOf('\r') != -1))
	  {
		  StringBuffer stringbuffer = new StringBuffer(s.length());
		  for(int i = 0; i < s.length(); i++)
		  {
			  char c = s.charAt(i);
			  if((c == '\n') || (c == '\r'))
				  stringbuffer.append("<br>");
			  else
				  stringbuffer.append(c);
		  }
		  
		  s1 = stringbuffer.toString();
	  }
	  return s1;
  }
  %>
	  <%!
	  // open the table and return the table values s a formatted string
	  //strings in table cells are truncated at a logical percentage of total column width
	  
	  static public String loadFlatTableValues(Vector vectorTableCols, Vector data, HttpServletRequest request,String tableEntryClass,HashMap elementMap,Context context,String sPFmode,boolean bReadAccess)
  {
	  String sDataStr = "";
	  if(data==null)
		  return sDataStr;
	  boolean pfMode    = "true".equals(sPFmode);
	  //class to apply to each table entry
	  String strTableEntryClass = "";
	  if(tableEntryClass != null )
	  {
		  strTableEntryClass = tableEntryClass;
	  }
	  
	  
	  //Get the ID outside the while so that this can be used for obj details pop up link below
	  String id = (String)elementMap.get("id");
	  String relId = (String)elementMap.get("id[connection]");
	  //	boolean bReadAccess = !"#DENIED!".equals(id);
	  
	  Enumeration eNumCol = vectorTableCols.elements();
	  //iterate through each column and get data from passed into Hashtable @ iExpressionInx
	  int colIndex=0;
	  while (eNumCol.hasMoreElements()) {
		  boolean editable = true;
		  Vector vectorTempCol = (Vector)eNumCol.nextElement();		
		  double dWidth = ((Integer)vectorTempCol.elementAt(2)).doubleValue();
		  boolean useBusBool = ((Boolean)vectorTempCol.elementAt(iUseBusBoolInx)).booleanValue();
		  String sExp = (String)vectorTempCol.elementAt(iExpressionInx);
		  String sValue="";
		  if(bReadAccess){		
			  Object val = null;			
			  if(data.size() > 0) val = data.get(colIndex);			
			  if(val!=null){			
				  Class cls = val.getClass();
				  if(cls.getName().equals("java.lang.String"))
					  sValue = (String)val;
				  else if(cls.getName().equals("matrix.util.StringList")){
					  StringList strList = (StringList)val;
					  StringItr sItr = new StringItr(strList);
					  while(sItr.next()){
						  sValue += sItr.obj() + "  ";
					  }
				  }
			  }
			  String sHref = "javascript:void(0)";
			  String sTarget = " ";
			  if ((sValue == null)|| sValue.equals("<null>")){
				  sValue = "";
				  editable=false;
			  }
		  }
		  else{
			  if(sExp.equals("type")||sExp.equals("name")||sExp.equals("revision")){
				  if(useBusBool)
					  sValue = (String)elementMap.get(sExp);
				  else if(!sExp.equals("revision")){
					  sValue = (String)elementMap.get("rel_"+sExp);
					  if(sValue==null)
						  sValue="";
				  }
			  }
			  else{
				  sValue = i18nStringNowLocal("emxIEFDesignCenter.Common.NoReadAcess", request.getHeader("Accept-Language"));
			  }
		  }
		  try{
			  if(sExp.equals("type") && useBusBool)
				  sValue = i18nNow.getMXI18NString(sValue.trim(), "", request.getHeader("Accept-Language"),"Type");
			  if((sExp.equals("type")||sExp.equals("name")) && !useBusBool)
				  sValue = i18nNow.getMXI18NString(sValue.trim(),"",request.getHeader("Accept-Language"),"Relationship");
			  
			  
		  }catch(Exception e){
			  
		  }
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
		  String displayedValue=sValue;
		  if( sValue != null )
		  {		    
			  sValue = replaceNewLines(sValue);
		  }
		  
		  boolean  found = false;
		  boolean isBusAttri=false;
		  boolean isEditable = ((Boolean)vectorTempCol.elementAt(isEditableInx)).booleanValue();
		  boolean isBus      = ((Boolean)vectorTempCol.elementAt(iUseBusBoolInx)).booleanValue();
		  if(isEditable && !attriName.equals("") && editable && bReadAccess && !pfMode ){
			  if(attriName.equals("description"))
				  found=true;
			  else{
				  Attribute attribute = null;
				  if(isBus){
					  try{
						  DomainObject  obj =  new DomainObject(id);
						  attribute = obj.getAttribute(context,attriName);
						  found = attribute==null?false:true;
						  isBusAttri=found;
					  }
					  catch(Exception e){
						  attribute=null;
						  found = false;
					  }
				  }
				  else{
					  try{
						  if(relId!=null && !relId.equals("null")&&!found){
							  Relationship relationShip = new Relationship(relId);
							  relationShip.open(context);
							  AttributeList list = relationShip.getAttributeValues(context,false);
							  for(int no=0; no<list.size();no++)
							  {
								  Attribute attr = (Attribute)list.get(no);
								  if(attr.getName().equals(attriName)){
									  found = true;
									  break;
								  }
							  }				
						  }
					  }
					  catch(Exception e)
					  {
						  found = false;
					  }
				  }
			  }
			  if(found){ 
				  String editURL ="emxInfoEditTableDialogFS.jsp?busId="+id+"&relId="+relId+"&isBusAttri="+new Boolean(isBusAttri).toString()+"&isDescription="+isDescription;
				  editURL+="&attributeValue="+sValue+"&attributeName="+attriName;
				  
				  String browser_agent = request.getHeader("USER-AGENT");
				  if(!(browser_agent.indexOf("MSIE") > 0)){
					  editURL = FrameworkUtil.encodeURLParamValues(editURL);   
				  }
				  else{
					  editURL=  editURL.replace(' ','+');
					  editURL = replaceString(editURL,"\"","q_u_o_t_e");
					  editURL = replaceString(editURL,"\\","f_o_r_s_l_a_s_h");
					  editURL = replaceString(editURL,"'","a_p_o_s");
					  editURL = replaceString(editURL,"#","h_a_s_h_1");
				  }
				  
				  String link="";
				  if(!sValue.equals("")){
					  link +="<a href=\"javascript:emxShowModalDialog('"+editURL+"',400,450,false)\" class=" + strTableEntryClass + ">"+displayedValue+"</a>";
					  
				  }
				  else{
					  link +="<a href=\"javascript:emxShowModalDialog('"+editURL+"',400,450,false)\" class=" + strTableEntryClass + ">"+"&nbsp;&nbsp;"+"</a>";
				  }
				  sValue=link;
			  }
		  }
		  sDataStr = sDataStr + "<td align='left' class=" + strTableEntryClass + " >" + sValue + "</td>";
		  colIndex++;
    }
	//Pop up window to show object details
	if(bReadAccess ){
		if(!pfMode){
			
			String menuName = "";
			try
			{
				menuName = getINFMenuName( request, context, id );
			}
			catch( Exception me )
			{
				System.out.println("Exception: "+me.getMessage());
				me.printStackTrace();
			}
			
			String detailsURL = "../common/emxTree.jsp?AppendParameters=true&objectId=" + id;
			sDataStr = sDataStr + "<td align='left'>&nbsp;<a href='javascript:showDetailsPopup(\"" + detailsURL + "\")'><img src=\"../common/images/iconActionNewWindow.gif\" border=\"0\"/></a>&nbsp;</td>";
		}
	}
	else{
		if(!pfMode){
			sDataStr = sDataStr+"<td align='left'>&nbsp;<img src=\"../common/images/iconActionNewWindow.gif\" border=\"0\"/>&nbsp;</td>";
		}
	}
	return sDataStr;
}

%>

<%!

//This function server two purposes
//1. While sorting it reloads the entire tree & table
//2. When the view is changed the table data is repopulated
//hence it has got too many parameters

static public void PopulateTreeTableChildren( Context context, ServletContext application, HttpServletRequest request,MapList childMap, String strTmpNodeNameID, HashMap mapNavigateData , JspWriter jspwriter) throws IOException, MatrixException
{	
        // Function FUN080585 : Removal of Cue, Tips and Views
        //Flag to indicate whether any child is expanded or not
	boolean childExpanded = false;
	
	/**** COMMENTED BY NAGESH ON 9/2/2004
	//Added on 9/2/2004 for navigate performance
	Hashtable hshCheckAccess = (Hashtable)session.getAttribute("readAccessValues");
	Boolean objChkAccess = null;
	********/
	boolean readAccess = true;
	
	Hashtable hshDrawIcon = new Hashtable(50);
	Hashtable hshTypeMenuName = new Hashtable(10);
	String strNodeTypeIcon ="";
	String sMenuName="";
	//end of change on 9/2/2004 
	
	//Find the tree Node to which the children has to be added
	//Populate the tree & table nodes
    for (int k = 0; k < childMap.size(); k++)
    {
		//Extract all the properties of the node ( a row in tree or table )
		IEF_INFNavigateMap curNodeMap = ((IEF_INFNavigateMap)childMap.get(k));
		String sNodeId = (String)(curNodeMap.get("id"));
		
		String access="read";
        BusinessObject bObj = new BusinessObject(sNodeId);
		
		/*********** COMMENTED BY NAGESH ON 9/2/2004
		//Added on 9/2/2004 for navigate performance
		if(hshCheckAccess != null && hshCheckAccess.containsKey(sNodeId) )
		{
		objChkAccess = (Boolean)hshCheckAccess.get(sNodeId);
		if(objChkAccess!=null)
		readAccess= objChkAccess.booleanValue(); 
		}
		else
		{
		readAccess = FrameworkUtil.hasAccess(context,bObj,access);
		}
		//end of change on 9/2/2004 
		***********/
		
		boolean boolCanHaveChildren = curNodeMap.getCanHaveChildrenStatus();
		
		String sRelId = (String)(curNodeMap.get("id[connection]"));
		
		IEF_INFNavigateData nodeData = (IEF_INFNavigateData)mapNavigateData.get(sNodeId + "|" +sRelId);
		
		ArrayList nodeDataList = nodeData.getNodeData();
		
		//extract the values from the array list
		String sNodeName = (String)nodeDataList.get(0);
		String sNodeRevision=(String)nodeDataList.get(1);
		String sNodeType = (String)nodeDataList.get(2);
		String sNodeParentId  =(String)nodeDataList.get(3);
		String sNodeRelWithSelName  = (String)nodeDataList.get(4);
		String sNodeArrowDir  = (String)nodeDataList.get(5);
		String sNodeTableData  = (String)nodeDataList.get(6);
		String strCurNodeID = strTmpNodeNameID + "_"+ k;
		curNodeMap.put("NodeID", strCurNodeID);
		// Function FUN080585 : Removal of Cue, Tips and Views
		//internationalize the type name
		sNodeType = i18nNow.getMXI18NString(sNodeType.trim(), "", request.getHeader("Accept-Language"),"Type");
		
		//Add as a child to tree & table
        
        try
        {
			//Added by nagesh on 9/2/2004 for navigate performance
			if(!hshTypeMenuName.isEmpty() && hshTypeMenuName.containsKey(sNodeType))
			{
				sMenuName = (String)hshTypeMenuName.get(sNodeType);
			}
			else
			{
				sMenuName = getINFMenuName( request, context, sNodeId );
				hshTypeMenuName.put(sNodeType,sMenuName);
			}
			//End of change on 9/2/2004 
        }
        catch( Exception me )
        {
            System.out.println("Exception: "+me.getMessage());
            me.printStackTrace();
        }					
		
        //Added by nagesh on 9/2/2004 for navigate performance
		if(!hshDrawIcon.isEmpty() && hshDrawIcon.containsKey(sNodeType))
		{
			strNodeTypeIcon = (String)hshDrawIcon.get(sNodeType);
		}
		else    
		{
			strNodeTypeIcon = drawIconInNavigate(context, application, sNodeType);
			hshDrawIcon.put(sNodeType,strNodeTypeIcon);
		}
		
		StringBuffer stbBuffer1 = new StringBuffer();
		StringBuffer stbBuffer2 = new StringBuffer();
		
		
		//End Added by nagesh on 9/2/2004
		
		
		
		if( boolCanHaveChildren )
		{
			//	jspwriter.println( "tree.nodes['" + strTmpNodeNameID + "'].addChild(\"" + sNodeType + "&nbsp;" + sNodeName + "&nbsp;" + sNodeRevision+ "\",\"" + drawIconInNavigate(context, application,sNodeType) + "\",\"" + sNodeArrowDir + "\",\"" + sNodeRelWithSelName + "\",\"" + sNodeId + "\",\"" + sNodeParentId + "\", true,\"" + sCueStyle + "\",\"" + sCueClass + "\",\"" + sObjTip + "\",\"" + sMenuName + "\"," + readAccess + ");" );
			
			stbBuffer1.append("tree.nodes['");
			stbBuffer1.append(strTmpNodeNameID);
			stbBuffer1.append("'].addChild(\"");
			//stbBuffer1.append(sNodeType);
			stbBuffer1.append("&nbsp;");
			stbBuffer1.append(sNodeName);
			stbBuffer1.append("&nbsp;");
			//stbBuffer1.append(sNodeRevision);
			stbBuffer1.append("\",\"");
			stbBuffer1.append(strNodeTypeIcon);
			stbBuffer1.append("\",\"");
			stbBuffer1.append(sNodeArrowDir);
			stbBuffer1.append("\",\"");
			stbBuffer1.append(sNodeRelWithSelName);
			stbBuffer1.append("\",\"");
			stbBuffer1.append(sNodeId);
			stbBuffer1.append( "\",\"");
			stbBuffer1.append(sNodeParentId);
			stbBuffer1.append( "\", true,\"");
                        // Function FUN080585 : Removal of Cue, Tips and Views
			stbBuffer1.append(sMenuName);
			stbBuffer1.append( "\",");
			stbBuffer1.append(readAccess);
			stbBuffer1.append(");");
			
			jspwriter.println(stbBuffer1.toString());
			jspwriter.flush();
			//jspwriter.println( "tree.nodes['" + strTmpNodeNameID + "'].addChild(\"" + sNodeType + "&nbsp;" + sNodeName + "&nbsp;" + sNodeRevision+ "\",\"" + drawIconInNavigate(context, application,sNodeType) + "\",\"" + sNodeArrowDir + "\",\"" + sNodeRelWithSelName + "\",\"" + sNodeId + "\",\"" + sNodeParentId + "\", true,\"" + sCueStyle + "\",\"" + sCueClass + "\",\"" + sObjTip + "\",\"" + sMenuName + "\"," + readAccess + ");" );
			
			
			stbBuffer2.append("table.nodes['");
			stbBuffer2.append(strTmpNodeNameID);
			stbBuffer2.append("'].addChild(\"<td><img src=images/utilSpace.gif width=6 height=16 ></td>");
			stbBuffer2.append(sNodeTableData);
			stbBuffer2.append("\",\"");
			stbBuffer2.append(sNodeId);
			stbBuffer2.append("\",\"");
			stbBuffer2.append(sNodeParentId);
			stbBuffer2.append("\",true);");
			
			//jspwriter.println( "table.nodes['" + strTmpNodeNameID + "'].addChild(\"<td><img src=images/utilSpace.gif width=6 height=16 ></td>" + sNodeTableData + "\",\""+ sNodeId+ "\",\"" + sNodeParentId+ "\",true);" );
			jspwriter.println(stbBuffer2.toString());
			jspwriter.flush();
		}
		else
		{
			stbBuffer1.append("tree.nodes['");
			stbBuffer1.append(strTmpNodeNameID);
			stbBuffer1.append("'].addChild(\"");
			//stbBuffer1.append(sNodeType);
			stbBuffer1.append("&nbsp;");
			stbBuffer1.append(sNodeName);
			stbBuffer1.append("&nbsp;");
			//stbBuffer1.append(sNodeRevision);
			stbBuffer1.append( "\",\"");
			stbBuffer1.append(strNodeTypeIcon);
			stbBuffer1.append("\",\"");
			stbBuffer1.append(sNodeArrowDir);
			stbBuffer1.append("\",\"");
			stbBuffer1.append(sNodeRelWithSelName);
			stbBuffer1.append("\",\"");
			stbBuffer1.append(sNodeId);
			stbBuffer1.append("\",\"");
			stbBuffer1.append(sNodeParentId);
			stbBuffer1.append( "\", false,\"");
                        // Function FUN080585 : Removal of Cue, Tips and Views
			stbBuffer1.append(sMenuName);
			stbBuffer1.append( "\",");
			stbBuffer1.append(readAccess);
			stbBuffer1.append(");");
			
			jspwriter.println(stbBuffer1.toString());
			jspwriter.flush();
			//jspwriter.println( "tree.nodes['" + strTmpNodeNameID + "'].addChild(\"" + sNodeType + "&nbsp;" + sNodeName + "&nbsp;" + sNodeRevision+ "\",\"" + drawIconInNavigate(context, application,sNodeType) + "\",\"" + sNodeArrowDir + "\",\"" + sNodeRelWithSelName + "\",\"" + sNodeId + "\",\"" + sNodeParentId + "\", false,\"" + sCueStyle + "\",\"" + sCueClass + "\",\"" + sObjTip + "\",\"" + sMenuName + "\"," + readAccess + ");" );
			
			
			stbBuffer2.append("table.nodes['");
			stbBuffer2.append(strTmpNodeNameID);
			stbBuffer2.append("'].addChild(\"<td><img src=images/utilSpace.gif width=6 height=16 ></td>");
			stbBuffer2.append(sNodeTableData);
			stbBuffer2.append("\",\"");
			stbBuffer2.append(sNodeId);
			stbBuffer2.append("\",\"");
			stbBuffer2.append(sNodeParentId);
			stbBuffer2.append("\",false);");
			
			jspwriter.println(stbBuffer2.toString());
			jspwriter.flush();
			
			//jspwriter.println( "table.nodes['" + strTmpNodeNameID + "'].addChild(\"<td><img src=images/utilSpace.gif width=6 height=16 ></td>" + sNodeTableData + "\",\""+ sNodeId+ "\",\"" + sNodeParentId+ "\",false);" );
		}
		//if the node has children populate them too
		
		if( curNodeMap.hasChildren() )
		{
			PopulateTreeTableChildren( context, application, request, curNodeMap.getChildMap(), strCurNodeID , mapNavigateData , jspwriter);
		}
		
		//Set the Expanded Flag based on the set status on the server
		if( curNodeMap.getExpandStatus() )
		{
			childExpanded = true;
			jspwriter.println( "table.nodes['" + strCurNodeID + "'].expanded = true;" );
			
			jspwriter.println( "tree.nodes['" + strCurNodeID + "'].expanded = true;" );
		}
		//Set the Selection Status
		if( curNodeMap.getSelectedStatus() )
		{
			jspwriter.println( "table.nodes['" + strCurNodeID + "'].selected = true;" );
			
			jspwriter.println( "tree.nodes['" + strCurNodeID + "'].selected = true;" );
			
			//Also store the selected node
			jspwriter.println( "selectedNode = '" + strCurNodeID + "';" );
			jspwriter.println("selectedNodeBOId = '" + sNodeId + "';" );
			
		}
		
	} //end for
	
	//if any child is expanded ..expand its parent also
	if( childExpanded)
	{
		jspwriter.println( "table.nodes['" + strTmpNodeNameID + "'].expanded = true;" );
		
		jspwriter.println( "tree.nodes['" + strTmpNodeNameID + "'].expanded = true;" );
	}
	
	jspwriter.println( "table.nodes['" + strTmpNodeNameID + "'].loaded = true;" );
	jspwriter.println( "tree.nodes['" + strTmpNodeNameID + "'].loaded = true;" );
        // Function FUN080585 : Removal of Cue, Tips and Views
}
%>

<%!

static public void PopulateTreeTableFirstLevelChildren( Context context, ServletContext application, HttpServletRequest request, MapList mapNavigateList, HashMap  mapNavigateData, boolean setExpandSelectStatus, JspWriter jspwriter) throws IOException,MatrixException
{
	//Populate the tree & table nodes
	// Function FUN080585 : Removal of Cue, Tips and Views
	/******** COMMENTED BY NAGESH ON 9/2/2004
	Hashtable hshCheckAccess = (Hashtable)session.getAttribute("readAccessValues");
	Boolean objChkAccess = null;
	**********/
	
	
	String access="read";
	boolean readAccess = true;
	
	//populate the data
	
	//Added on 6/2/2004 for navigate performance issue
	Hashtable hshDrawIcon = new Hashtable(50);
	Hashtable hshTypeMenuName = new Hashtable(10);
	String strNodeTypeIcon ="";
	String sMenuName="";
	//End of change on 6/2/2004
	
	
	for (int i = 0; i < mapNavigateList.size(); i++)
	{
		//Extract all the properties of the node ( a row in tree or table )
		IEF_INFNavigateMap nodeMap = ((IEF_INFNavigateMap)mapNavigateList.get(i));
		String sNodeId = (String)(nodeMap.get("id"));
		BusinessObject bObj = new BusinessObject(sNodeId);
		
		/******** COMMENTED BY NAGESH ON 9/2/2004
		// 2/1/2004 nagesh start
		if(hshCheckAccess != null && hshCheckAccess.containsKey(sNodeId) )
		{
		objChkAccess = (Boolean)hshCheckAccess.get(sNodeId);
		if(objChkAccess!=null)
		readAccess= objChkAccess.booleanValue(); 
		}
		else
		{
		readAccess = FrameworkUtil.hasAccess(context,bObj,access);
		}
		// 2/1/2004 nagesh end
		************/
		
		boolean boolCanHaveChildren = nodeMap.getCanHaveChildrenStatus();
		String sRelId = (String)(nodeMap.get("id[connection]"));
		IEF_INFNavigateData nodeData = (IEF_INFNavigateData)mapNavigateData.get( sNodeId + "|" +sRelId);
		ArrayList nodeDataList = nodeData.getNodeData();
		//extract the values from the array list
		String sNodeName = (String)nodeDataList.get(0);
		String sNodeRevision=(String)nodeDataList.get(1);
		String sNodeType = (String)nodeDataList.get(2);
		String sNodeBusId  =(String)nodeDataList.get(3);
		String sNodeRelWithSelName  = (String)nodeDataList.get(4);
		String sNodeArrowDir  = (String)nodeDataList.get(5);
		String sNodeTableData  = (String)nodeDataList.get(6);
		// Function FUN080585 : Removal of Cue, Tips and Views
		//internationalize the type name
		sNodeType = i18nNow.getMXI18NString(sNodeType.trim(), "", request.getHeader("Accept-Language"),"Type");
		String strNodeNameID = "root_" + i;
		nodeMap.put("NodeID", strNodeNameID);
		//Add as a child to tree & table
		//add tree nodes if it is not explicit table update ( view change )
		// replace new line characters with spaces
		if( sNodeTableData != null )
		{		    
			sNodeTableData = replaceNewLines(sNodeTableData);
		}
		
        try
        {
			//Added by nagesh on 6/2/2004 for navigate performance
			if(!hshTypeMenuName.isEmpty() && hshTypeMenuName.containsKey(sNodeType))
			{
                sMenuName = (String)hshTypeMenuName.get(sNodeType);
			}
			else
			{
				sMenuName = getINFMenuName( request, context, sNodeId );
                hshTypeMenuName.put(sNodeType,sMenuName);
			}
			//End of change on 6/2/2004 
        }
        catch( Exception me )
        {
            System.out.println("Exception: "+me.getMessage());
            me.printStackTrace();
        }
		//31/12/2003 Nagesh 
		//use string buffer to generate the js code for child
		StringBuffer stbBuffer1 = new StringBuffer();
		StringBuffer stbBuffer2 = new StringBuffer();
		
        //Added by nagesh on 6/2/2004 for navigate performance
		if(!hshDrawIcon.isEmpty() && hshDrawIcon.containsKey(sNodeType))
		{
			strNodeTypeIcon = (String)hshDrawIcon.get(sNodeType);
		}
		else    
		{
			strNodeTypeIcon = drawIconInNavigate(context, application, sNodeType);
			hshDrawIcon.put(sNodeType,strNodeTypeIcon);
		}
        //End Added by nagesh on 6/2/2004
		
		
		if( boolCanHaveChildren )
		{
			stbBuffer1.append("tree.root.addChild(\"");
			//stbBuffer1.append(sNodeType);
			stbBuffer1.append("&nbsp;");
			stbBuffer1.append(sNodeName);
			stbBuffer1.append("&nbsp;");
			//stbBuffer1.append(sNodeRevision);
			stbBuffer1.append("\",\"");
			stbBuffer1.append(strNodeTypeIcon);
			stbBuffer1.append("\",\"");
			stbBuffer1.append(sNodeArrowDir);
			stbBuffer1.append("\",\"");
			stbBuffer1.append(sNodeRelWithSelName);
			stbBuffer1.append("\",\"");
			stbBuffer1.append(sNodeId);
			stbBuffer1.append("\",\"");
			stbBuffer1.append(sNodeBusId);
			stbBuffer1.append("\", true,\"");
                        // Function FUN080585 : Removal of Cue, Tips and Views
			stbBuffer1.append(sMenuName);
			stbBuffer1.append("\",");
			stbBuffer1.append(readAccess);
			stbBuffer1.append( ");");
			
			//	jspwriter.println( "tree.root.addChild(\"" + sNodeType + "&nbsp;" + sNodeName + "&nbsp;" + sNodeRevision + "\",\"" + drawIconInNavigate(context, application, sNodeType) + "\",\"" + sNodeArrowDir + "\",\"" + sNodeRelWithSelName + "\",\"" + sNodeId + "\",\"" + sNodeBusId + "\", true,\"" + sCueStyle + "\",\"" + sCueClass + "\",\"" + sObjTip + "\",\"" + sMenuName + "\"," + readAccess + ");" );
			jspwriter.println(stbBuffer1.toString());
			
			stbBuffer2.append("table.root.addChild(\"<td><img src=images/utilSpace.gif width=6 height=16 ></td>");
			stbBuffer2.append(sNodeTableData);
			stbBuffer2.append("\",\"");
			stbBuffer2.append(sNodeId);
			stbBuffer2.append("\",\"");
			stbBuffer2.append(sNodeBusId);
			stbBuffer2.append("\",true);");
			
			//jspwriter.println( "table.root.addChild(\"<td><img src=images/utilSpace.gif width=6 height=16 ></td>" + sNodeTableData + "\",\"" + sNodeId + "\",\"" + sNodeBusId + "\",true);" );
			jspwriter.println(stbBuffer2.toString());
			jspwriter.flush();
			
			//	jspwriter.println( "table.root.addChild(\"<td><img src=images/utilSpace.gif width=6 height=16 ></td>" + sNodeTableData + "\",\"" + sNodeId + "\",\"" + sNodeBusId + "\",true);" );
		}
		else
		{
			stbBuffer1.append("tree.root.addChild(\"");
			//stbBuffer1.append(sNodeType);
			stbBuffer1.append("&nbsp;");
			stbBuffer1.append(sNodeName);
			stbBuffer1.append("&nbsp;");
			//stbBuffer1.append(sNodeRevision);
			stbBuffer1.append("\",\"");
			stbBuffer1.append(strNodeTypeIcon);
			stbBuffer1.append("\",\"");
			stbBuffer1.append(sNodeArrowDir);
			stbBuffer1.append("\",\"");
			stbBuffer1.append(sNodeRelWithSelName);
			stbBuffer1.append("\",\"");
			stbBuffer1.append(sNodeId);
			stbBuffer1.append("\",\"");
			stbBuffer1.append(sNodeBusId);
			stbBuffer1.append("\",false,\"");
                        // Function FUN080585 : Removal of Cue, Tips and Views
			stbBuffer1.append(sMenuName);
			stbBuffer1.append("\",");
			stbBuffer1.append(readAccess);
			stbBuffer1.append(");");
			
			//jspwriter.println( "tree.root.addChild(\"" + sNodeType + "&nbsp;" + sNodeName + "&nbsp;" + sNodeRevision + "\",\"" + drawIconInNavigate(context, application, sNodeType) + "\",\"" + sNodeArrowDir + "\",\"" + sNodeRelWithSelName + "\",\"" + sNodeId + "\",\"" + sNodeBusId + "\",false,\"" + sCueStyle + "\",\"" + sCueClass + "\",\"" + sObjTip + "\",\"" + sMenuName + "\"," + readAccess + ");" );
			jspwriter.println(stbBuffer1.toString()); 
			
			stbBuffer2.append("table.root.addChild(\"<td><img src=images/utilSpace.gif width=6 height=16 ></td>");
			stbBuffer2.append(sNodeTableData);
			stbBuffer2.append("\",\"");
			stbBuffer2.append(sNodeId);
			stbBuffer2.append("\",\"");
			stbBuffer2.append(sNodeBusId);
			stbBuffer2.append("\", false);");
			
			//jspwriter.println("table.root.addChild(\"<td><img src=images/utilSpace.gif width=6 height=16 ></td>" + sNodeTableData + "\",\"" + sNodeId + "\",\"" + sNodeBusId + "\", false);" );
			jspwriter.println(stbBuffer2.toString());
			jspwriter.flush();
		}
		//if the node has children populate them too
		if( nodeMap.hasChildren() )
		{
			PopulateTreeTableChildren( context, application, request, nodeMap.getChildMap(), strNodeNameID, mapNavigateData , jspwriter);
		}
		
		//31/12/2003  Nagesh
		StringBuffer stbExpand1 = new StringBuffer();
		StringBuffer stbExpand2 = new StringBuffer();
		StringBuffer stbSelect1 = new StringBuffer();
		StringBuffer stbSelect2 = new StringBuffer();
		//31/12/2003  Nagesh End
		
		//Set the Expanded Flag based on the set status on the server
		if( setExpandSelectStatus && nodeMap.getExpandStatus() )
		{
			stbExpand1.append("table.nodes['");
			stbExpand1.append(strNodeNameID );
			stbExpand1.append("'].expanded = true;");
			jspwriter.println(stbExpand1.toString());
			//	jspwriter.println( "table.nodes['" + strNodeNameID + "'].expanded = true;" );
			
			stbExpand2.append("tree.nodes['");
			stbExpand2.append(strNodeNameID);
			stbExpand2.append("'].expanded = true;");
			jspwriter.println(stbExpand2.toString());
			//	jspwriter.println( "tree.nodes['" + strNodeNameID + "'].expanded = true;" );
		}
		//Set the Selection Status
		if( setExpandSelectStatus && nodeMap.getSelectedStatus() )
		{
			stbSelect1.append("table.nodes['");
			stbSelect1.append(strNodeNameID );
			stbSelect1.append("'].selected = true;");
			jspwriter.println(stbSelect1.toString());
			//	jspwriter.println( "table.nodes['" + strNodeNameID + "'].selected = true;" );
			
			stbSelect2.append("tree.nodes['");
			stbSelect2.append(strNodeNameID);
			stbSelect2.append("'].selected = true;");
			stbSelect2.append("selectedNode = '");
			stbSelect2.append(strNodeNameID);
			stbSelect2.append("';" );
			jspwriter.println(stbSelect2.toString());
			//	jspwriter.println( "tree.nodes['" + strNodeNameID + "'].selected = true;" );
			
			//	jspwriter.println( "selectedNode = '" + strNodeNameID + "';" );			
		}
		
	} //end for
        // Function FUN080585 : Removal of Cue, Tips and Views
}
%>


<%!
//this function make the sorting recursive
static public MapList sortNavigateObjects(Context context, MapList relBusObjList, Vector vectorColList, String sortColumnName, String Direction, HashMap paramMap)
{
	
	//sort the objects before creating tree/table nodes
	if (relBusObjList == null || vectorColList == null ||  sortColumnName == null)
	{
		return relBusObjList;
	}
	
	HashMap sortColumMap = new HashMap();
	Enumeration eNumCol = vectorColList.elements();
	Vector vectorTempCol = null;
	String sColumnName = null;
	String sExpression = "";
	while (eNumCol.hasMoreElements())
	{
		vectorTempCol = (Vector)eNumCol.nextElement();
		sColumnName = (String)vectorTempCol.elementAt(0);
		
		if (sColumnName != null && sColumnName.equals(sortColumnName) )
		{
			sExpression = (String)vectorTempCol.elementAt(1);
			sortColumMap = new HashMap();
			Boolean  columnBOTypes = (Boolean)vectorTempCol.elementAt(3);
			sExpression = (String)vectorTempCol.elementAt(1);
			
			if( columnBOTypes.booleanValue() )
			{
				sortColumMap.put("expression_businessobject", sExpression);
			}
			else
			{
				sortColumMap.put("expression_relationship",sExpression);
			}
			sortColumMap.put("name",sColumnName);
			break;
		}
		
	}
	//first sort the root list
	if( sortColumMap != null)
		relBusObjList = sortObjects(context, relBusObjList, sortColumMap, Direction, paramMap);
	
	// make the sorting recursive
    for (int i = 0; i < relBusObjList.size(); i++)
	{
        IEF_INFNavigateMap curNodeMap = (IEF_INFNavigateMap)relBusObjList.get(i);
		//if the node has children populate them too
		if( curNodeMap.hasChildren() )
		{
			sortNavigateObjects(context, curNodeMap.getChildMap(), vectorColList, sortColumnName, Direction, paramMap);
		}
		
	}
	
    return relBusObjList;
}

%>

<%!
// open the table and return the table headings as a formatted String for Default table
static public String getNavigateTableHeadings(Vector vectorTableCols,HttpServletRequest req,boolean isDefaultTable, String sortDirection, String sortColumnName, boolean sPFMode)
{
    String sHeaderStr = "";
    Enumeration eNumCol = vectorTableCols.elements();
    Vector vectorTempCol = null;
    Integer iWidth = null;
    String sLabel = null;
	
    while (eNumCol.hasMoreElements())
	{
		// 2/1/2004 Added by nagesh START
		StringBuffer stbHeader = new StringBuffer();
		// 2/1/2004 Added by nagesh END
		
		vectorTempCol = (Vector)eNumCol.nextElement();
		iWidth = (Integer)vectorTempCol.elementAt(2);
		sLabel = (String)vectorTempCol.elementAt(0);
		String sExp = (String)vectorTempCol.elementAt(iExpressionInx);
		if(sExp.equals("checkbox"))
		{
			if(sPFMode)
				sLabel = "<img src='images/iconCheckoffdisabled.gif'>";
			else
			{
				sLabel = "<input type='checkbox' name='chkList' onclick='parent.checkAll()'>";
			}
		}

		if (isDefaultTable) {
			sLabel = i18nStringNowLocal(sLabel,req.getHeader("Accept-Language"));
		}
		String sortImage = "";
		String nextSortDirection = "";
		if (sortDirection.compareTo("ascending") == 0)
		{
			nextSortDirection = "descending";
			sortImage = "../common/images/utilSortArrowDown.gif";
		} else {
			nextSortDirection = "ascending";
			sortImage = "../common/images/utilSortArrowUp.gif";
		}
		
		//in printer friendly mode do not show hyperlinks in the header
		if( sPFMode == true )
		{
			if( sortColumnName.compareTo(sLabel) == 0 )
			{
				//column name matches with this ...display the image next to this column
				String progArgument = "";
				if(sExp.equals("checkbox"))
					progArgument = "'','" + nextSortDirection + "'"; 
				else
					progArgument = "'" + sLabel +"','" + nextSortDirection + "'";

				// Added by nagesh 2/1/2004
				stbHeader.append(sHeaderStr);
				stbHeader.append("<th align='left' class=heading nowrap >");
				stbHeader.append(sLabel);
				stbHeader.append("&nbsp;");
				stbHeader.append("<img src=");
				stbHeader.append(sortImage);
				stbHeader.append(" ");
				stbHeader.append("align='absmiddle' border='0' />");
				stbHeader.append( "</th>");
				sHeaderStr = stbHeader.toString();
				// end Added by nagesh 2/1/2004
				
				//sHeaderStr = sHeaderStr + "<th align='left' class=heading nowrap >" + sLabel + "&nbsp;";
				//sHeaderStr = sHeaderStr + "<img src=" + sortImage + " " + "align='absmiddle' border='0' />";
				//sHeaderStr = sHeaderStr + "</th>"; 
				
			}
			else
			{
				//for rest of the columns sort direction remains the same
				String progArgument = "";
				if(sExp.equals("checkbox"))
					progArgument = "'','" + sortDirection + "'"; 
				else
					progArgument = "'" + sLabel +"','" + sortDirection + "'";; 
				
				//START Added by nagesh 2/1/2004
				stbHeader.append(sHeaderStr);
				stbHeader.append("<th align='left' class=heading nowrap >&nbsp;");
				stbHeader.append(sLabel);
				stbHeader.append("&nbsp;");
				stbHeader.append("</th>");
				sHeaderStr = stbHeader.toString();
				
				// end Added by nagesh 2/1/2004
				//sHeaderStr = sHeaderStr + "<th align='left' class=heading nowrap >&nbsp;" + sLabel + "&nbsp;";
				//sHeaderStr = sHeaderStr + "</th>";
			}
		}
		else
		{
			/*if( sortColumnName.compareTo(sLabel) == 0 )
			{
				//column name matches with this ...display the image next to this column
				//on this column sorting again changes the direction
				String progArgument = "";
				if(sExp.equals("checkbox"))
					progArgument = "'','" + nextSortDirection + "'"; 
				else
					progArgument = "'" + sLabel +"','" + nextSortDirection + "'"; 
				
				// START Added by nagesh 2/1/2004
				stbHeader.append(sHeaderStr);
				stbHeader.append("<th align='left' class=heading nowrap >");	
				stbHeader.append("<a class=heading href= ");	
				stbHeader.append("\\");	
				stbHeader.append("\"javascript:parent.sortNavigateTable(");	
				stbHeader.append(progArgument);	
				stbHeader.append(")");	
				stbHeader.append("\\");	
				stbHeader.append("\">");	
				stbHeader.append(sLabel);	
				stbHeader.append("</a>");	
				stbHeader.append("<img src=");	
				stbHeader.append(sortImage);
				stbHeader.append(" align='absmiddle' border='0' />");
				stbHeader.append("</th>");
				sHeaderStr = stbHeader.toString();
				// end Added by nagesh 2/1/2004
				
				//sHeaderStr = sHeaderStr + "<th align='left' class=heading nowrap >";
				//sHeaderStr = sHeaderStr + "<a class=heading href= ";
				//sHeaderStr = sHeaderStr + "\\" + "\"javascript:parent.sortNavigateTable(" + progArgument + ")" +"\\" +"\">" + sLabel + "</a>";
				//sHeaderStr = sHeaderStr + "<img src=" + sortImage + " " + "align='absmiddle' border='0' />";
				//sHeaderStr = sHeaderStr + "</th>"; 
				
			}
			else
			{*/
				//for rest of the columns sort direction remains the same
				//String progArgument = "'" + sLabel +"','" + sortDirection + "'";
				String progArgument = "";
				if(sExp.equals("checkbox"))
					progArgument = "'','" + sortDirection + "'"; 
				else
					progArgument = "'" + sLabel +"','" + sortDirection + "'";; 
				
				// START Added by nagesh 2/1/2004
				stbHeader.append(sHeaderStr);
				stbHeader.append("<th align='left' class=heading nowrap >");
				//stbHeader.append("<a class=heading href= ");
				//stbHeader.append("\\");
				//stbHeader.append("\"javascript:parent.sortNavigateTable(");
				//stbHeader.append( progArgument);
				//stbHeader.append( ")");
				//stbHeader.append("\\");
				//stbHeader.append("\">");
				stbHeader.append(sLabel);
				//stbHeader.append("</a>&nbsp;");
				stbHeader.append("</th>");
				sHeaderStr = stbHeader.toString();
				// end Added by nagesh 2/1/2004
				
				//sHeaderStr = sHeaderStr + "<th align='left' class=heading nowrap >&nbsp;";
				//sHeaderStr = sHeaderStr + "<a class=heading href= ";
				//sHeaderStr = sHeaderStr + "\\" + "\"javascript:parent.sortNavigateTable(" + progArgument + ")" +"\\" +"\">" + sLabel + "</a>&nbsp;&nbsp;";
				//sHeaderStr = sHeaderStr + "</th>";
			//}
		}
		sHeaderStr = sHeaderStr + "<th>&nbsp;</th>";
    }

    return sHeaderStr;
}
%>

