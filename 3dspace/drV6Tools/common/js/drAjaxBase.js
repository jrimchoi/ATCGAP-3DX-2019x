/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

if (!window.drAjaxBase) {
    window.drAjaxBase={};
    
}
drAjaxBase.RootNode = "drAjaxBase";
drAjaxBase.main = function(urlToProcess, className, methodName, params, encoding,functionCall, async) {
    
    var functionCallType = (typeof functionCall);
    var returnFunctionCallType = (functionCallType == "function" || functionCallType == "object") || !async;
    var xmlDoc = drAjaxBase.createXmlDocument(drAjaxBase.RootNode,className,methodName,returnFunctionCallType,params);
    var xmlHttpReq=drAjaxBase.createXMLHttpRequest();      
    drAjaxBase.returnAsyncResponse(returnFunctionCallType,functionCall,async,xmlHttpReq); 
    xmlHttpReq.open("POST",urlToProcess,async);
    xmlHttpReq.setRequestHeader('Content-Type','text/xml; charset='+encoding);
    xmlHttpReq.send(xmlDoc);    
    drAjaxBase.returnSyncResponse(async,xmlHttpReq); 
    
}

drAjaxBase.serialize=function(input, node) {
    var ownerDoc = node.ownerDocument;
    if (input==null) {
        node.appendChild(ownerDoc.createElement("null"));
    } else {
        var type = typeof input;
        if (type=="string" || type=="number") {
            node.appendChild(ownerDoc.createTextNode(input));
        } else if (type=="boolean") {
            node.appendChild(ownerDoc.createTextNode(input ? "true" : "false"));
        } else if (type=="object") {
            if (String.prototype.isPrototypeOf(input) 
                || Number.prototype.isPrototypeOf(input)
                || Boolean.prototype.isPrototypeOf(input)) {
                node.appendChild(ownerDoc.createTextNode(input.toString()));
            } else if (Date.prototype.isPrototypeOf(input)) {
                node.appendChild(d.createTextNode(drAjaxBase.FormatToDate(input)));
            } else if (Array.prototype.isPrototypeOf(input)) {
                var arr = ownerDoc.createElement("array");
                node.appendChild(arr);
                for (var i = 0; i<input.length; i++) {
                    var item = ownerDoc.createElement("item");
                    arr.appendChild(item);
                    drAjaxBase.serialize(input[i], item);
                }
            } else {
                if (typeof input.nodeType == "number") {
                    switch (input.nodeType) {
                        case 9:
                            input = input.documentElement;
                        case 1:
                            if (input) {
                                var xml = ownerDoc.createElement("xml");
                                node.appendChild(xml);
                                if (ownerDoc.importNode) {
                                    xml.appendChild(ownerDoc.importNode(input,true));
                                } else {
                                    xml.appendChild(input);
                                }
                            }
                            break;
                    }
                } else if ((typeof input.length == "number") && (typeof input.join != "undefined")) {
                    var eleArr = ownerDoc.createElement("array");
                    node.appendChild(eleArr);
                    for (var cnt = 0; cnt<input.length; cnt++) {
                        var eleItem = ownerDoc.createElement("item");
                        eleArr.appendChild(eleItem);
                        drAjaxBase.serialize(input[cnt], eleItem);
                    }
                } else if (typeof input.toGMTString != "undefined") {
                    node.appendChild(ownerDoc.createTextNode(drAjaxBase.FormatToDate(input)));
                } else {
                    var structure = ownerDoc.createElement("struct");
                    node.appendChild(structure);
                    for (var indx in input) {
                        var ele = ownerDoc.createElement(indx);
                        structure.appendChild(ele);
                        var val = eval("input."+indx);
                        drAjaxBase.serialize(val, ele);
                    }
                }
            }
        }
    }
}

drAjaxBase.deserialize=function(element) {
    var nValue="";
    var childNodes=element.childNodes;
    for (var i=0; i<childNodes.length; i++) {
        var childNode = childNodes[i];
        switch (childNode.nodeType) {
            case 1:
                switch (childNode.tagName) {
                    case "null":
                        return null;
                    case "array":
                        var arr=[];
                        var l=childNode.childNodes;
                        for (var j=0; j<l.length; j++) {
                            if (l[i].nodeType==1) {
                                arr.push(drAjaxBase.deserialize(l[j]));
                            }
                        }
                        return arr;
                    case "struct":
                        var structure={};
                        var n=childNode.childNodes;
                        for (var j=0; j<n.length; j++) {
                            if (n[j].nodeType==1) {
                                eval("structure."+n[j].tagName+" = drAjaxBase.deserialize(n[j])");
                            }
                        }
                        return structure;
                    case "xml":
                        var xml=childNode.childNodes;
                        for (var j=0; j<xml.length; j++) {
                            if (xml[j].nodeType==1) {
                                return xml[j];
                            }
                        }
                        return null;
                    default:
                        throw new Error("unknown element: "+childNode.tagName);
                }
            case 3:
            case 4:
                nValue+=childNode.nodeValue;
                break;
        }
    }
    if (nValue.length==0) {
        return nValue;
    }
    if (!isNaN(nValue)) {
        return parseFloat(nValue);
    }
    if (nValue=="true") {
        return true;
    }
    if (nValue=="false") {
        return false;
    }
    var d=drAjaxBase.ParseToDate(nValue);
    if (d!=null) {
        return d;
    }
    return nValue;
}

drAjaxBase.FormatToDate=function(date) {
    return date.getFullYear()+
    "-"+
    drAjaxBase.FormatToInt(date.getMonth()+1,2)+
    "-"+
    drAjaxBase.FormatToInt(date.getDate(),2)+
    "T"+
    drAjaxBase.FormatToInt(date.getHours(),2)+
    ":"+
    drAjaxBase.FormatToInt(date.getMinutes(),2)+
    ":"+
    drAjaxBase.FormatToInt(date.getSeconds(),2);
}

drAjaxBase.createXmlDocument=function(rootNodeName,className,methodName,returnFunctionCallType,params){
    var doc = null;
    if (document.implementation && document.implementation.createDocument) {
        doc=document.implementation.createDocument("", rootNodeName, null);
    } else if (window.ActiveXObject) {
        doc=new ActiveXObject("Msxml2.FreeThreadedDOMDocument.3.0");
        doc.appendChild(doc.createElement(rootNodeName));
    }
    var docElement = doc.documentElement;
    docElement.setAttribute("className", className);
    docElement.setAttribute("methodName", methodName);
    docElement.setAttribute("returnValue", ""+returnFunctionCallType);
    if (params) {
        for (var i=0; i<params.length; i++) {
            var element=doc.createElement("params");
            docElement.appendChild(element);
            drAjaxBase.serialize(params[i], element);
        }
    }
    return doc;
}

drAjaxBase.ParseToInt=function(str) {
    while (str.charAt(0)=='0') {
        str = str.substring(1);
    }
    return str.length>0 ? parseInt(str) : 0;
}

drAjaxBase.createXMLHttpRequest=function(){
    var xmlHttpReq=null;
    if (window.XMLHttpRequest) {
        xmlHttpReq=new XMLHttpRequest();
    } else if (window.ActiveXObject) {
        xmlHttpReq=new ActiveXObject("Microsoft.XMLHTTP");
    }
    return xmlHttpReq;
}

drAjaxBase.FormatToInt=function(val, num) {
    var s = ""+val;
    while (s.length<num) {
        s = "0"+s;
    }
    return s;
}

drAjaxBase.returnAsyncResponse=function(callbackType,functionCall,async,xmlHttpReq){
    if (callbackType && async) {
        xmlHttpReq.onreadystatechange=function() {
            if (xmlHttpReq.readyState==4) {
                var retValue=drAjaxBase.returnResponse(xmlHttpReq);
                functionCall(retValue[0],retValue[1]);
            }
        };
    }
    return;
}

drAjaxBase.ParseToDate=function(date) {
    var n = [];
    var t = ['-','-','T',':',':'];
    var o=0;
    var e=-1;
    var s=null;
    for (var i=0; i<t.length; i++) {
        e = date.indexOf(t[i], o);
        if (e==-1) {
            return null;
        }
        s = date.substring(o,e);
        if (isNaN(s)) {
            return null;
        }
        n.push(drAjaxBase.ParseToInt(s));
        o=e+1;
    }
    s = d.substring(o);
    if (isNaN(s)) {
        return null;
    }
    n.push(drAjaxBase.ParseToInt(s));
    return new Date(n[0],n[1]-1,n[2],n[3],n[4],n[5]);
}

drAjaxBase.returnSyncResponse=function(async,xmlHttpReq){
    if (!async) {
        var retValue=drAjaxBase.returnResponse(xmlHttpReq);
        if (retValue[1]) {
            return retValue[0];
        } else {
            throw retValue[0];
        }
        
    }  
    return;
}

drAjaxBase.returnResponse=function(xmlHttpReq) {
    try {
        if (xmlHttpReq.status==200) {
            var docElement=xmlHttpReq.responseXML.documentElement;
            try {
                var returnValueTag=docElement.getElementsByTagName("returnValue");
                if (returnValueTag.length==1) {
                    return [drAjaxBase.deserialize(returnValueTag.item(0)),true];
                }else {
                    var errorFlag=docElement.getElementsByTagName("errorOccurred");
                    if (errorFlag.length==1) {
                        var errorOcccured = errorFlag.item(0);
                        if(errorOcccured.text == "true"){
                             var errorMsg = docElement.getElementsByTagName("errorMessage");
                              if (errorMsg.length==1) {
                                  alert("Error occured while getting response: "+errorMsg.item(0).text);
                                  throw new Error("Error occured in response: "+errorMsg.item(0).text);
                              }
                            
                        }
                     
                    }
                } 
            } catch (Ex) {
                return[Ex,false];
            }
        } else {
            return [new Error("Error: "+xmlHttpReq.status+" ("+xmlHttpReq.statusText+")"),false];
        }
    } catch (X) {
        return [X,false];
    }
}