define("DS/MPFPurchaseOrderModel/CartPurchaseOrderDataProxy",["UWA/String","DS/MPFDataProxy/DataProxy","DS/MPFError/NotImplementedError"],function(d,c,a){var b;b=c.extend({init:function(e,f){this._parent(e,"/mdcart/carts/{0}/po",f)},buildPath:function(f,e){return d.format(this.resourcePath,f.parentResourceId)},urlPut:a.emit,urlDelete:a.emit,doPut:a.emit,doDelete:a.emit});return b});define("DS/MPFPurchaseOrderModel/PurchaseOrderModel",["DS/MPFModel/MPFModel","DS/MPFModel/ModelValidator"],function(b,d){var a;var c={};c.NUMBER="number";c.LABEL="label";c.DOCUMENT_ID="docpid";a=b.extend({defaults:function(){var e={};e[c.NUMBER]=null;e[c.LABEL]=null;e[c.DOCUMENT_ID]=null;return e},setup:function(e,f){this._parent(e,f);this._type="PurchaseOrderModel";this.validator=new d({model:this,validations:[{attribute:c.NUMBER,required:true,isString:true,isNumber:true,requiredError:"A purchase order number is required"}]})},validate:function(e){return this.validator.validate(e)},getNumber:function(){return this.get(c.NUMBER)},setNumber:function(e){return this.set(c.NUMBER,e)},getLabel:function(){return this.get(c.LABEL)},setLabel:function(e){return this.set(c.LABEL,e)},getDocumentId:function(){return this.get(c.DOCUMENT_ID)},setDocumentId:function(e){return this.set(c.DOCUMENT_ID,e)}});a.Fields=Object.freeze(c);return a});define("DS/MPFPurchaseOrderModel/PurchaseOrderDocumentModel",["UWA/Promise","DS/MPFModel/MPFModel"],function(a,b){var c;c=b.extend({idAttribute:"documentIDs",setup:function(d,e){this._parent(d,e);this._type="PurchaseOrderDocumentModel"},saveFile:function(f,e){var d=a.deferred();var g;g=new FormData();g.append("file",f);if(!(e)){e={}}e.method="POST";e.data=g;e.onComplete=d.resolve;e.onFailure=d.reject;this.save(null,e);return d.promise}});return c});define("DS/MPFPurchaseOrderModel/CartPurchaseOrderDocumentDataProxy",["UWA/String","DS/MPFDataProxy/DataProxy","DS/MPFError/NotImplementedError"],function(d,c,b){var a;a=c.extend({init:function(e,f){this._parent(e,"/mdcart/carts/{0}/po/document",f)},buildPath:function(f,e){return d.format(this.resourcePath,f.parentResourceId)},urlGet:b.emit,urlPut:b.emit,urlPatch:b.emit,urlDelete:b.emit,doGet:b.emit,doPut:b.emit,doPatch:b.emit,doDelete:b.emit});return a});