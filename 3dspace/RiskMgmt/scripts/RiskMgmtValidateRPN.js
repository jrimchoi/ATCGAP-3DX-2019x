
function severityFieldChangeHdlr()
{
    var severityField  = document.forms[0].Severity;
    var occurenceField = document.forms[0].Occurence;
    var RPNField       = document.forms[0].RPN;

    if(severityField.value == '-' && occurenceField.value != '-')
    {
	occurenceField.value = '-';

	if(RPNField.value != '-')
	{
	    RPNField.value = '-';
	    RPNField.style.backgroundColor = 'white';
	}
    }
    else if(severityField.value != '-' && occurenceField.value != '-')
    {
	RPNField.value = severityField.value * occurenceField.value;
	setRPNFieldColor(severityField.value, occurenceField.value, RPNField);
    }
}

function occurenceFieldChangeHdlr()
{
    var severityField  = document.forms[0].Severity;
    var occurenceField = document.forms[0].Occurence;
    var RPNField       = document.forms[0].RPN;

    if(occurenceField.value == '-' && severityField.value != '-')
    {
	severityField.value = '-';

	if(RPNField.value != '-')
	{
	    RPNField.value = '-';
	    RPNField.style.backgroundColor = 'white';
	}
    }
    else if(occurenceField.value != '-' && severityField.value != '-')
    {
	RPNField.value = severityField.value * occurenceField.value;
	setRPNFieldColor(severityField.value, occurenceField.value, RPNField);
    }
}

function setRPNFieldColor(severity, occurence, RPNField)
{
    if(severity == 5 || (severity==4 && occurence > 2) || (severity==3 && occurence == 5))
    {
	RPNField.style.backgroundColor = '#FF3030'; //red
    }
    else if(severity*occurence <= 2 || (severity == 2 && occurence == 2) || (severity == 1 && occurence == 3))
    {
	RPNField.style.backgroundColor = '#00FF00'; //green
    }
    else
    {
	RPNField.style.backgroundColor = '#FFFF00'; //yellow
    }
}

function updateRPNField()
{
    var severityField  = document.forms[0].Severity;
    var occurenceField = document.forms[0].Occurence;
    var RPNField       = document.forms[0].RPN;

    if(occurenceField.value == '-')
    {
	if(severityField.value != '-')
	{
	    severityField.value  = '-'
	}
	
	if(RPNField.value != '-')
	{
	    RPNField.value = '-';
	}
    }
    else if(severityField.value == '-')
    {
	if(occurenceField.value != '-')
	{
	    occurenceField.value = '-';
	}
	
	if(RPNField.value != '-')
	{
	    RPNField.value = '-';
	}
    }
    else
    {
	 RPNField.value =  severityField.value * occurenceField.value;
    }
}

function updateHazardTypeField()
{
    if(document.forms[0].ImpactType.value.indexOf('Hazard') < 0)
    {
	document.forms[0].HazardType.value = "None";
    }
}


