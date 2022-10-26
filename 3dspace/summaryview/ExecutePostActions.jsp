<%
   final String STRING_RESOURCE = "SummaryViewStringResource";
   final String LANGUAGE = request.getHeader("Accept-Language");
%>
<script type="text/javascript" language="javascript">

function addInputElement(form, id, name,type,value)
{
	var input = document.createElement("input");
	input.setAttribute("id", id);
	input.setAttribute("name", name);
	input.setAttribute("type", type);
	input.setAttribute("value", value);
	form.appendChild(input);
}

function loadHTMLReport(strObjectId)
{
	window.location.href = window.location.href.replace('loadSummaryView','showSummaryView') + "&objectId=" + strObjectId;
}

function showHTMLReport(strHTML,pdfPath,htmlPath,emailSubject,strObjectId) {
	var html = document.documentElement;
	var newHead = document.createElement("head");
	var newTitle = document.createElement("title");
	newTitle.appendChild(document.createTextNode("Summary Report"));
	html.replaceChild(newHead, html.childNodes[0]);
	window.document.write(strHTML);

	<%
	String servletPath = request.getContextPath();
	%>
	
	var form = document.createElement("form");
	form.setAttribute("name", "pdfReportForm");
    form.setAttribute("method", "POST");
    var contextPath = "<%=servletPath%>";
	form.setAttribute("action", contextPath+"/SummaryViewServlet");
	
	addInputElement(form, "pdfReport", "pdfReport", "hidden", pdfPath);
	addInputElement(form, "htmlReport", "htmlReport", "hidden", htmlPath);
	addInputElement(form, "ReportType", "ReportType", "hidden", "-");
	addInputElement(form, "EmailSubject", "EmailSubject", "hidden", emailSubject);
	addInputElement(form, "contextPath", "contextPath", "hidden", contextPath);
	addInputElement(form, "ObjectId", "ObjectId", "hidden", strObjectId);

	document.body.appendChild(form);
}



</script>
