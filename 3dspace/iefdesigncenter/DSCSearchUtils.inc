<%--  DSCSearchUtils.inc

   Copyright (c) 2016 Dassault Systemes. All rights reserved.
   This program contains proprietary and trade secret information of
   Dassault Systemes and its subsidiaries. Copyright notice is precautionary only
   and does not evidence any actual or intended publication of such program

--%>
<%@ page import="com.matrixone.MCADIntegration.utils.*,com.matrixone.MCADIntegration.server.beans.*,com.matrixone.apps.domain.util.*"  %>
<%!
    public String getParameter(HashMap paramMap, HttpServletRequest request, String paramName)
	{
	    String value = emxGetParameter(request, paramName);
		if (paramMap != null && value == null)
		{
		   value = (String)paramMap.get(paramName);
		}
		return value;
	}
	
	public String[] getParameterValues(HashMap paramMap, HttpServletRequest request, String paramName)
	{
	     String parameterValues[] = Request.getParameterValues(request, paramName);
		if (paramMap != null && parameterValues == null)
		{
		   String value = (String)paramMap.get(paramName);
		   if (value != null)
		   {
		      StringTokenizer tk = new StringTokenizer(value, "\n");
			  int count = tk.countTokens();
			  parameterValues = new String[count];
			  int i = 0;
			  while(tk.hasMoreTokens())
			  {
			     parameterValues[i++] = tk.nextToken();
				 
			  }
		   }
		}
		
		return parameterValues;
	}
	
	/*public static Enumeration getParameterNames(HashMap paramMap, HttpServletRequest request)
	{
	          Vector vectParamName = new Vector();
		Enumeration eNumObj = emxGetParameterNames(request);
		if(eNumObj!=null) 
                    {
		  while (eNumObj.hasMoreElements()) 
          {
			String sParam = (String)eNumObj.nextElement();
			vectParamName.add(sParam);
		  }
		}
	}*/
	
	public String getDefaultIntegrationName(HttpServletRequest request, MCADIntegrationSessionData integSessionData)
	{
	   String integrationName = Request.getParameter(request,"integrationName");
		
		if (integrationName == null || integrationName.equals(""))
		{
			MCADLocalConfigObject localConfigObject = integSessionData.getLocalConfigObject();
	       integrationName                         = localConfigObject.getPreferredIntegrationNameFromLCO();
	    }
	   
	   	if (integrationName == null || integrationName.equals(""))
		{
			MCADLocalConfigObject localConfigObject = integSessionData.getLocalConfigObject();

			if(null != localConfigObject)
			{			
				Hashtable integrationNameGCONameMap = localConfigObject.getIntegrationNameGCONameMapping();
				if (null != integrationNameGCONameMap && integrationNameGCONameMap.size()>0)
				{
					java.util.Set paramSet = integrationNameGCONameMap.keySet();
					Iterator paramIterator = paramSet.iterator();
					while(paramIterator.hasNext())
					{
						String skey = (String)paramIterator.next();
						integrationName = skey;
						break;
					}
				}
			}
		}

		if(null == integrationName)
			integrationName = "";

	    return integrationName;
	}
	
	public String getSearchEncodedParamValue(String paramName, String paramValue)
	{
	          if (paramName == null)
	               return paramValue;
				   
	         if (paramName.equals("txtName") ||
	                paramName.equals("txtType") ||
	                paramName.equals("txtRev") ||
	                paramName.equals("displayowner") ||
		     paramName.equals("keywords") ||
		     paramName.equals("txtVault") ||
		     paramName.equals("WorkspaceFolder") ||
	               paramName.startsWith("txtWhere"))
	         {
			 String  value = paramValue;
			 try
			 {
			    value = MCADUrlUtil.hexEncode(value);
		           }
		    catch (Exception e)
			{
			     System.out.println(e.toString());
			}
			 return value;
	          }

        return paramValue;			  
	}
	
	 // DSC Fiat Changes
    public Hashtable getTypeStates(Context context, String types)
    {
			Hashtable stateTable = new Hashtable();
			try
			{
				StringTokenizer tk = new StringTokenizer(types, ",");
				StringList typeList = new StringList();
				while(tk.hasMoreTokens())
			            {
					String strType = tk.nextToken();
					String realName	= PropertyUtil.getSchemaProperty( context, strType);
					typeList.addElement(realName);
				}
           
				for (int i = 0;  i < typeList.size(); i++)
				{
					String typeName = (String)typeList.get(i);
					MQLCommand _mql = new MQLCommand();
					_mql.executeCommand( context, "print type \"" + typeName + "\" select policy dump |" );
					String sPolicies = _mql.getResult();
					Hashtable stateMap = new Hashtable();
					if ( sPolicies != null ) {
						StringTokenizer stPolicies = new StringTokenizer( sPolicies, "|" );
						while ( stPolicies.hasMoreTokens() ) 
						{
							String strPolicy = (String)stPolicies.nextToken();
							strPolicy        = strPolicy.trim();

							try
							{
								String sStates = MqlUtil.mqlCommand( context, "print policy \"" + strPolicy + "\" select state dump | " );
								StringTokenizer stStates = new StringTokenizer( sStates, "|");
								while (stStates.hasMoreTokens())
								{
									String strState = (String)stStates.nextToken();
									stateTable.put(strState, "");
								}
							}
							catch (Exception  me)
							{
							}
						}
					}
				}
        }
        catch (Exception e)
        {
		            System.out.println("getTypeStates: " + e.toString());
		}
        return stateTable;
    }
    // DSC Fiat Changes
	
	    
%>
