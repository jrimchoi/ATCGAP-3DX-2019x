
<%@include file = "../emxUICommonAppInclude.inc"%>
<%@page trimDirectiveWhitespaces="true" %>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="java.io.BufferedOutputStream"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="com.matrixone.servlet.FrameworkServlet"%>

<%@include file="../common/enoviaCSRFTokenValidation.inc"%>

<% 

try
{
	final int BUFSIZE = 4096;
	boolean isUserLoggedIn = new FrameworkServlet().isLoggedIn(request);
	
	
	if (!isUserLoggedIn) {
		throw new Exception(EnoviaResourceBundle.getProperty(context, "enoQuestionnaireStringResource", context.getLocale(),"Questionnaire.Error.Export.NoUserLogin"));
	}
	
	String strTimeStamp =request.getParameter("timestamp");
	
	Map paramMap=new HashMap();
	paramMap.put("timestamp",strTimeStamp);
	
	String args[]=JPO.packArgs(paramMap);
	
	Map mpFileInfo = (Map)JPO.invoke(context, "ENOQuestionUI", args, "getExportedFilePath", args, Map.class);
	
	String strFilePath=(String)mpFileInfo.get("filepath");
	String fileName=(String)mpFileInfo.get("filename");
	
	File file = new File(strFilePath);
	if (!file.exists()) {
		throw new Exception(EnoviaResourceBundle.getProperty(context, "enoQuestionnaireStringResource", context.getLocale(),"Questionnaire.Error.Export.FileNotExists"));
	}

	ByteArrayOutputStream byteOut = new ByteArrayOutputStream();
	BufferedOutputStream bufferedOutput = new BufferedOutputStream(byteOut);
	response.setContentType("application/csv");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\";");
	
	ServletOutputStream sos = response.getOutputStream();
			
	byte[] bytes = new byte[BUFSIZE];

	BufferedInputStream buffIn = new BufferedInputStream(new FileInputStream(file));

	int length;
	while ((length = buffIn.read(bytes)) >= 0) {
		bufferedOutput.write(bytes, 0, length);
	}
	buffIn.close();
	bufferedOutput.close();

	sos.write(byteOut.toByteArray());
	sos.flush();
	sos.close();
	return;
}

catch(Exception e)
{
	throw new ServletException(e);
}	
%>
