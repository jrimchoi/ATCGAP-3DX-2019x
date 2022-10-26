<script>
function enableOrdisablePrinterOptions()
{
	var printerOption= document.getElementsByName("PrintMethod");
	
	for (var i = 0, length = printerOption.length; i < length; i++) {
	    if (printerOption[i].checked) {

	    	if(printerOption[i].value=="Print Using Server")
	    	{
	    		emxFormDisableField("PrinterName",true);
	    		emxFormDisableField("SetDefaultPrinter",true);
	    	}
	    	else
	    	{
	    		emxFormDisableField("PrinterName",false);
	    		emxFormDisableField("SetDefaultPrinter",false);
	    	}
	        break;
	    }
	}
	
}
</script>
