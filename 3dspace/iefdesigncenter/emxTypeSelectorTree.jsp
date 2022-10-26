<%--  emxTypeSelectorTree.jsp

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%--
    $Archive: /InfoCentral/src/infocentral/emxTypeSelectorTree.jsp $
--%>

<%--
 *
 * $History: emxTypeSelectorTree.jsp $
 *
 * *****************  Version 18  *****************
 * User: Rahulp       Date: 5/02/03    Time: 17:22
 * Updated in $/InfoCentral/src/infocentral
 *
 ************************************************
 *
--%>

<%@include file="emxInfoCentralUtils.inc"%> 			<%--For context, request wrapper methods, i18n methods--%>
<%@ page import="com.matrixone.apps.domain.util.MapList,
				 com.matrixone.apps.common.util.JSPUtil,
                 com.matrixone.apps.domain.util.FrameworkUtil,
                 com.matrixone.apps.domain.DomainObject,
                 com.matrixone.apps.framework.taglib.*"  %>

<html>
<head>
  <link rel="stylesheet" href="../common/styles/emxUITree.css" type="text/css">
  <title></title>
<script language="JavaScript">

  var progressBarCheck = 1;

  function removeProgressBar(){
    progressBarCheck++;
    if (progressBarCheck < 10){
      if (parent.frames[0].document.progress){
        parent.frames[0].document.progress.src = "../common/images/utilSpacer.gif";
      }else{
        setTimeout("removeProgressBar()",500);
      }
    }
    return true;
  }
</script>
</head>
<%@include file = "../common/enoviaCSRFTokenValidation.inc"%>
<%!
    String loadJSChildren ( matrix.db.Context context,
        HttpSession session,
        ServletContext application,
        BusinessType busType,String languageStr )
    {
        String strResult = "";
        try
        {
            busType.open(context);
            String typeName = busType.getName();
            BusinessTypeList lstChildren = busType.getChildren(context);


            if (lstChildren != null)
            {
                strResult += "tb.tree.nodeMap['"
                    + busType.getName()
                    + "|"
                    + i18nNow.getTypeI18NString(busType.getName(),languageStr)
                    + "'].childNodes = new Array;";
					lstChildren.sort();

                for (int i=0; i < lstChildren.size(); i++)
                {
                    BusinessType tempType = (BusinessType) lstChildren.elementAt(i);
                    tempType.open(context);
					String sTypeName = tempType.getName();

                    strResult += "tb.tree.nodeMap['" + tempType.getParent(context)+"|"+i18nNow.getTypeI18NString(tempType.getParent(context),languageStr) +"'].addChild(\"" + tempType.getName()+"|"+i18nNow.getTypeI18NString(tempType.getName(),languageStr) + "\", \""+ drawIcon(context, application, sTypeName) +"\", " + String.valueOf(tempType.isAbstract(context)) + ", " + String.valueOf(tempType.hasChildren(context)) + ");\n";
                    tempType.close(context);
                }
            }

            strResult += "tb.tree.nodeMap['" + busType.getName() +"|"+i18nNow.getTypeI18NString(busType.getName(),languageStr) +"'].loaded = true;";
            busType.close(context);
        }
        catch (Exception e)
        {
          strResult += "" + e.toString();
        }
        return strResult;
    }

    String createJSTree( matrix.db.Context context,
        BusinessType busType,
        String languageStr )
    {
        String strResult = "";

        try
        {
            busType.open(context);
            BusinessTypeList lstChildren = busType.getChildren(context);

            if (lstChildren != null)
            {
				lstChildren.sort();
                for (int i=0; i < lstChildren.size(); i++)
                {
                    BusinessType tempType = (BusinessType) lstChildren.elementAt(i);
                    tempType.open(context);
                    strResult += "tb.tree.nodeMap['"
                        + tempType.getParent(context)
                        + "|"
                        + i18nNow.getTypeI18NString(tempType.getParent(context),languageStr)
                        +"'].addChild(\"" + tempType.getName()
                        + "\", \"\", "
                        + (tempType.isAbstract(context)? "true" : "false")
                        + ", " + (tempType.hasChildren(context)? "true" : "false")
                        + ");\n";
                    tempType.close(context);
                    strResult += createJSTree(context, tempType,languageStr);
                }
            }
            busType.close(context);
        }
        catch (Exception e)
        {
            strResult += e.toString();
        }
        return strResult;
    }

	 public ArrayList removeHiddenType(String types,Context context,boolean expand,HttpServletRequest request,boolean topLevel)
    {

        MQLCommand mqlCmd = new MQLCommand();
        String selectStatement =" hidden name ";
        if(expand)
        selectStatement += "  derivative ";
        String sResult ="";
      	ArrayList  arrTypeList = new ArrayList();
        HashMap typeList=new HashMap();
        try
        {
          mqlCmd.open(context);
		  if(expand)
			mqlCmd.executeCommand(context, "list type $1 select $2 $3 $4 dump $5",types,"hidden","name","derivative","|");
		  else
			mqlCmd.executeCommand(context, "list type $1 select $2 $3 dump $4",types,"hidden","name","|");
          sResult = mqlCmd.getResult();
//          sResult = sResult.replace('\n','~');
          mqlCmd.close(context);
          StringTokenizer strTkParent = new StringTokenizer(sResult,"\n");
          while(strTkParent.hasMoreTokens()){
            String token = strTkParent.nextToken();
            StringTokenizer strTkParentRow = new StringTokenizer(token,"|");
            String hidden =  strTkParentRow.nextToken();
            String name =  strTkParentRow.nextToken();
            if(hidden.equalsIgnoreCase("false")){
			  String sResultTop="";
			  if(topLevel){
    		  MQLCommand mqlCmdTop = new MQLCommand();
			  mqlCmdTop.open(context);
              mqlCmdTop.executeCommand(context, "print type $1 select $2 dump $3",name,"derived","|");
              sResultTop = mqlCmdTop.getResult();
			  if(sResultTop!=null){
				  sResultTop=sResultTop.replace('\n',' ');
  				  sResultTop=sResultTop.trim();
			  }
			  }
			  if("".equals(sResultTop)){
              typeList.put(name,name);
			  }
            }
            if(expand && !topLevel){
            String derivatives ="";
            while(strTkParentRow.hasMoreTokens()){
            String subType = strTkParentRow.nextToken();
            MQLCommand mqlCmdDerived = new MQLCommand();
            mqlCmdDerived.open(context);
            mqlCmdDerived.executeCommand(context, "list type $1 select  hidden name dump $2",subType,"|");
            String sResultDerived = mqlCmdDerived.getResult();
//            sResultDerived = sResultDerived.replace('\n','~');
            mqlCmdDerived.close(context);
            StringTokenizer strTkDerived = new StringTokenizer(sResultDerived,"\n");
            while(strTkDerived.hasMoreTokens()){
            String token1 = strTkDerived.nextToken();
            StringTokenizer strTkDerivedRow = new StringTokenizer(token1,"|");
            String derivedHidden =  strTkDerivedRow.nextToken();
            String derivedName =  strTkDerivedRow.nextToken();
            if(derivedHidden.equalsIgnoreCase("false")){
               typeList.put(derivedName,derivedName);
            }
            }
            }
            }
          }
		  ArrayList displayNameList= new ArrayList();
		  ArrayList nameList=new ArrayList();
          Iterator itr = typeList.keySet().iterator();
          while(itr.hasNext()){
              String s_TypeName = (String)itr.next();
			  String displayName=i18nNow.getMXI18NString(s_TypeName.trim(), "",request.getHeader("Accept-Language"),"Type");
			  nameList.add(s_TypeName);
			  displayNameList.add(displayName);
			  /*String strTypeName = "\"" + s_TypeName
                    + "|"
                    + getMXI18NString(s_TypeName.trim(), "",request.getHeader("Accept-Language"),"Type")
                    + "\",";
					*/

			//  arrTypeList.add(strTypeName);
         }
          ArrayList sortedTypeList = sortArrayList(displayNameList,nameList,request);
          nameList = (ArrayList)sortedTypeList.get(0);
		  displayNameList = (ArrayList)sortedTypeList.get(1);
     	  for(int l=0; l<nameList.size();l++){
			 String s_TypeName  =(String)nameList.get(l);
    		 String displayName =(String)displayNameList.get(l);
			 String strTypeName = "\"" + s_TypeName
                    + "|"
                    + displayName
                    + "\",";
			arrTypeList.add(strTypeName);
			}
        }
        catch(Exception me)
        {
          System.out.println("ERROR # " + me);
        }
        return arrTypeList;
    }
    public ArrayList sortArrayList(ArrayList displayNameList,ArrayList nameList,
	    HttpServletRequest request){
		java.text.Collator myCollator = java.text.Collator.getInstance(request.getLocale());
		Object as[] = displayNameList.toArray();
		Object names[] = nameList.toArray();
		int i=0;
		int j= as.length -1;
        for(int k = (j - i) + 1; k > 1;)
        {
            if(k < 5)
                k = 1;
            else
                k = (5 * k - 1) / 11;
            for(int l = j - k; l >= i; l--)
            {
                String s = (String)as[l];
				String s1 = (String)names[l];
                int i1;
                for(i1 = l + k; i1 <= j && myCollator.compare(s,(String)as[i1]) > 0; i1 += k){
                    as[i1 - k] = as[i1];
					names[i1 - k] = names[i1];
				}
                as[i1 - k] = s;
				names[i1 - k] = s1;
            }
        }
        ArrayList arrList1 = new ArrayList();
		ArrayList arrList2 = new ArrayList();
		for(int l=0; l<as.length;l++){
			arrList1.add(names[l]);
			arrList2.add(as[l]);
		}
        ArrayList arrList = new ArrayList();
		arrList.add(arrList1);
		arrList.add(arrList2);
		return arrList;
    }
%>
<%
	String strType = emxGetParameter(request,"strType");
	String chkbxToplevel = emxGetParameter(request,"chkbxTopLevel");
	ArrayList  arrTypeArrayContentList = removeHiddenType(strType,context,true,request,"true".equals(chkbxToplevel));
	if(arrTypeArrayContentList.size() != 0)
	{
%>
		<script language="javascript">
			function loadTree()
			{
				//get the type browser object
				var tb = parent.tb;
<%
				try
				{
					String languageStr = request.getHeader("Accept-Language");
					String sVaultname = context.getVault().getName();
					Vault sVault = new Vault(sVaultname);
					String sType = emxGetParameter(request,"txtName");

					if ((sType != null)&&(!sType.equalsIgnoreCase("null")))
					{
						BusinessType busType = new BusinessType(sType,sVault);
%>
                        //XSSOK
		                <%=loadJSChildren(context, session, application, busType,languageStr)%>
<%
					}
					else
					{
						int iNumTypes = arrTypeArrayContentList.size();

						for (int i=0; i < iNumTypes; i++)
						{
							String strTemp = arrTypeArrayContentList.get(i).toString();
							strTemp = strTemp.substring(0,strTemp.indexOf("|")).replace('"', ' ').trim();
							BusinessType baseType = new BusinessType(strTemp, sVault);
							baseType.open(context);
							String sTypeName = baseType.getName();
							boolean bHasChildren = false;

/*							if("true".equalsIgnoreCase(chkbxToplevel.trim()))
							{
								bHasChildren = false;
							}
							else
							{
							 bHasChildren = baseType.hasChildren(context);
							}
*/
							bHasChildren = baseType.hasChildren(context);
%>
                            //XSSOK
							tb.tree.root.addChild(<%=arrTypeArrayContentList.get(i).toString().replace(',',' ').trim()%>,"<%=drawIcon( context, application, strTemp)%>",<%=baseType.isAbstract(context)%>,<%=bHasChildren%>);
<%
							baseType.close(context);
						}// End of For loop
					} // End of if-else
%>
					//tell the tree that it's loaded and draw it
					tb.tree.refresh();
<%
				}
				catch (Exception e)
				{
%>
					alert("Java Exception Occured:\n<%= e %>");
<%
				}
%>
				removeProgressBar()
			} //end of function loadTree()
		</script>
		<body class="tree" onload="loadTree()">
		</body>
<%
	}else{
%>
	<body class="tree" onLoad="javascript:removeProgressBar()">
		<table width="100%" border="0">
		<tr bgcolor="#eeeeee">
		  <td align=center><framework:i18n localize="i18nId">emxIEFDesignCenter.Chooser.NoItemsFound</framework:i18n></td>
		</tr>
		</table>
	</body>
<%
	} // End of if(arrTypeArrayContentList.size() != 0)
%>
</html>
