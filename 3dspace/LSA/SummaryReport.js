
function saveAsPDF()
{
	var pdfReport = document.getElementsByName("pdfReportForm")[0];
	var ReportType = document.getElementById('ReportType');
	ReportType.setAttribute("value",'PDF');
	pdfReport.submit();
}
function email()
{
	var contextPath = document.getElementById('contextPath');
	var emailSubject = document.getElementById('EmailSubject');
	var id = document.getElementById('ObjectId');
	var origin = window.location.origin;
	var mail = "mailto:?subject="+emailSubject.value+"&body="+origin+contextPath.value+"/common/emxNavigator.jsp?objectId="+id.value;
	var a = document.createElement("a");
	a.href = mail;
	document.body.appendChild(a);
	a.click();
}
function saveHTML()
{
	var pdfReport = document.getElementsByName("pdfReportForm")[0];
	var ReportType = document.getElementById('ReportType');
	ReportType.setAttribute("value",'HTML');
	pdfReport.submit();
}

function loadTitles()
{
	var saveAsPDF = document.getElementById('SaveAsPDF');
	var email = document.getElementById('Email');
	var saveAsHTML = document.getElementById('SaveAsHTML');
	var print = document.getElementById('Print');

	var strURL = "../LSA/Execute.jsp?executeAction=com.dassault_systemes.enovia.lsa.services.ui.emxReportGeneration:getReportActionSpecificI18NString&ajaxMode=true&suiteKey=LSACommonFramework";
	var stringTitles = emxUICore.getData(strURL);
	var jsonTitles = JSON.parse(stringTitles);
	var resultArray = jsonTitles.result;
	for(var index=0;index<= resultArray.length-1;index++)
	{
		var key = resultArray[index].text;
		switch(key){
			case 'saveAsPDF':
				saveAsPDF.setAttribute('title',resultArray[index].value);
				break;
			case 'email':
				email.setAttribute('title',resultArray[index].value);
				break;
			case 'saveAsHTML':
				saveAsHTML.setAttribute('title',resultArray[index].value);
				break;
			case 'print':
				print.setAttribute('title',resultArray[index].value);
				break;
		}
	}
}
