
function createRequestFormLSA(query) {
   var FORM_DATA = new Object();
   var objHiddenWindow = findFrame(getTopWindow(), "submitHiddenFrame");
   if(objHiddenWindow == null){
   		objHiddenWindow = document.createElement("IFRAME");
   		objHiddenWindow.width="0%" ;
   		objHiddenWindow.height="0%" ;
   		objHiddenWindow.name = "submitHiddenFrame";
   		objHiddenWindow.src = "../common/emxBlank.jsp";
   		if(getTopWindow().document.body) {
   			getTopWindow().document.body.appendChild(objHiddenWindow);
   		}
   		else {
   		document.body.appendChild(objHiddenWindow);
   	}
   	}
   var objHiddenWindowDocument = objHiddenWindow.document;
   if(!objHiddenWindowDocument){
	   objHiddenWindowDocument = objHiddenWindow.contentDocument;
	   objHiddenWindowDocument.write("<body></body>");
   }
   var docfrag = objHiddenWindowDocument.createDocumentFragment();
   var objForm    = objHiddenWindowDocument.createElement('form');
   objForm.name   = "postHiddenForm";
   objForm.id   = "postHiddenForm";

   docfrag.appendChild(objForm);
   var oldform = objHiddenWindowDocument.getElementById("postHiddenForm");
   if(oldform){
	   objHiddenWindowDocument.body.removeChild(oldform);
   }
   objHiddenWindowDocument.body.appendChild(docfrag);

  var separator = ',';
  query = query.substring((query.indexOf('?')) + 1);
  if (query.length < 1) { return false; }
  var keypairs = new Object();
  var numKP = 1;
  while (query.indexOf('&') > -1)
   {
    keypairs[numKP] = query.substring(0,query.indexOf('&'));
    query = query.substring((query.indexOf('&')) + 1);
    numKP++;
  }
  keypairs[numKP] = query;
  for (i in keypairs)
  {
    keyName = keypairs[i].substring(0,keypairs[i].indexOf('='));
    keyValue = keypairs[i].substring((keypairs[i].indexOf('=')) + 1);
    while (keyValue.indexOf('+') > -1)
    {
      keyValue = keyValue.substring(0,keyValue.indexOf('+')) + ' ' + keyValue.substring(keyValue.indexOf('+') + 1);
    }
    keyValue = unescape(keyValue);
    var hiddenEle = document.createElement("input");
    hiddenEle.setAttribute("type","hidden");
    hiddenEle.setAttribute("name", keyName);
    hiddenEle.setAttribute("value", keyValue);
    objForm.appendChild(hiddenEle);
    FORM_DATA[keyName] = keyValue;
  }
  return objForm;
}
