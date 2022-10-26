<%@page import="org.apache.commons.fileupload.*,java.util.*,java.io.*"%>
<%@page import="matrix.db.JPO"%>
<%@page import="com.matrixone.apps.domain.*"%>
<%@page import="com.matrixone.servlet.Framework"%>
<%@page import="com.matrixone.apps.domain.util.XSSUtil"%>



<%	
	String sFolderWIN 	= "c://temp//";
	String sFolderUNIX 	= "/tmp/";	
	String sLanguage 	= request.getHeader("Accept-Language");
	String sOID 		= com.matrixone.apps.domain.util.Request.getParameter(request, "objectId");	
	String sRelType 	= com.matrixone.apps.domain.util.Request.getParameter(request, "relationship");	
	String sCommand 	= com.matrixone.apps.domain.util.Request.getParameter(request, "documentCommand");
	String cascadeActivityName = com.matrixone.apps.domain.util.Request.getParameter(request, "drtoolsKey");
	String runCascadeForFileExtensions = com.matrixone.apps.domain.util.Request.getParameter(request, "runCascadeforFileExtensions");
	String cascadeTargetLocation = com.matrixone.apps.domain.util.Request.getParameter(request, "cascadeTargetLocation");
	String runCascadeWithCheckin = com.matrixone.apps.domain.util.Request.getParameter(request, "showCascadeForCheckin");
	String ResultHeader="";
	
	

	
    matrix.db.Context context 	= Framework.getFrameContext(session); 
	String sOSName 		= System.getProperty ( "os.name" );
	String sFolder 		= sOSName.contains("Windows") ? sFolderWIN : sFolderUNIX ;	
	StringBuilder sbResult  = new StringBuilder();
  
	// Save file on disk
	DiskFileUpload upload	= new DiskFileUpload();
	//List items 				= upload.parseRequest(request);  
	List files = upload.parseRequest(request);
	
	

	
		Iterator iter = files.iterator();
		int index;
		String sFilename="";
		FileItem file = null;
		File outfile = null;
		String myResult="";

		while (iter.hasNext())
			{
				file = (FileItem) iter.next();
				sFilename 		= file.getName();        
				if(sFilename.contains("/")) {
					index = sFilename.lastIndexOf("/");
					sFilename = sFilename.substring(index);
				}
				if(sFilename.contains("\\")) {
					index = sFilename.lastIndexOf("\\");
					sFilename = sFilename.substring(index+1);
				
				}
				
				outfile = new File(sFolder +  sFilename);
				// Modified by Razorleaf for the PDF drag and drop issue - Starts
				if(runCascadeWithCheckin.equals("true")){
					file.write(outfile);
				}
				// Modified by Razorleaf for the PDF drag and drop issue - Ends
				String fileNameWithFolder = sFilename + "|" + sFolder;
				myResult = myResult + "$"+fileNameWithFolder;

			}	

			sbResult.append("<div id='headerDropZone' style='float:left;padding-right:5px;display:block;'>");		
		     sbResult.append("<form id='formDrag' action='../drV6Tools/draganddrop/drFileUpload.jsp?relationship=").append(XSSUtil.encodeForURL(context, sRelType)).append("&documentCommand=").append(XSSUtil.encodeForURL(context, sCommand)).append("&objectId=").append(XSSUtil.encodeForURL(context, sOID)).append("'  method='post'  enctype='multipart/form-data'>\n");
			
			sbResult.append("<div id='divDrag' class='dropArea'");
			sbResult.append(" ondrop=\"drFileSelectHandlerHeader('"+cascadeActivityName+"','"+runCascadeForFileExtensions+"','"+cascadeTargetLocation+"',event, '" + sOID + "', 'formDrag', 'divDrag', 'divExtendedHeaderDocuments', '").append(sRelType).append("')\" ");
			sbResult.append(" ondragover=\"drFileDragHover(event, 'divDrag')\" ");
			sbResult.append(" ondragleave=\"drFileDragHover(event, 'divDrag')\">\n");		
			sbResult.append("<br/>Drop<br/>files<br/>here"); 
			sbResult.append("</div>");
			sbResult.append("</form>");
			sbResult.append("</div>");		
			sbResult.append("<div style='display:none'>");
			sbResult.append("@@");
			sbResult.append(myResult);	
			sbResult.append("</div>");		
			
			ResultHeader = sbResult.toString();	
		
		if(runCascadeWithCheckin.equals("false")) {			

				String initargs[] = {};		
				HashMap params = new HashMap();
				params.put("language",sLanguage);
				params.put("objectId",sOID);
				params.put("relationship",sRelType);
				params.put("documentCommand",sCommand);			
				params.put("folder",sFolder);	
				params.put("files",files);
				params.put("objectAction","create");
				params.put("timezone", (String)session.getAttribute("timeZone"));
				String JPOResult = (String)JPO.invoke(context, "emxDnD", initargs, "checkinFile", JPO.packArgs (params), String.class);	
				String replaceJspNameInResult = JPOResult.replace("common/emxFileUpload", "drV6Tools/draganddrop/drFileUpload");
				String replaceOnDropMethodNameInString = replaceJspNameInResult.replace("FileSelectHandlerHeader(", "drFileSelectHandlerHeader('"+cascadeActivityName+"','"+runCascadeForFileExtensions+"','"+cascadeTargetLocation+"',");
				String replaceOnDragMethodNameInString = replaceOnDropMethodNameInString.replaceAll("FileDragHover", "drFileDragHover");
				StringBuilder result = new StringBuilder();
				result.append(replaceOnDragMethodNameInString);			
				ResultHeader = result.toString();
					
		}
	  
%><%=ResultHeader%>