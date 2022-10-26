define("DS/MPF3DPMaterials/MPF3DPMaterialModel",["DS/MPFModel/MPFModel"],function(b){var a=b.extend({setup:function(c,d){this._parent(c,d)},parse:function(c){return{id:c.id,data:c.data,genericType:c["generic-type"].replace("MP3DP_GenType_",""),name:c.materialName,specificType:c["specific-type"].replace("MP3DP_SpecType_",""),supportedColors:typeof c.supportedColors==="string"?c.supportedColors.split(","):c.supportedColors}},sync:function(e,d,c){if(e==="read"){c.url=d.dataProxy.delegate.url(d)}return this._parent(e,d,c)},toJSON:function(){var c=Object.assign({},this._attributes);var e="";for(var d=0;d<c.supportedColors.length;d++){e+=c.supportedColors[d];if(d<c.supportedColors.length-1){e+=","}}c.materialName=c.name;c["specific-type"]=c.specificType;c.supportedColors=e;delete c.name;delete c.genericType;delete c.specificType;return c}});return a});define("DS/MPF3DPMaterials/MPF3DPMaterialGenericTypeModel",["DS/MPFModel/MPFModel"],function(b){var a=b.extend({defaults:{materialName:"",data:"",name:"",supportedColors:[],specificType:""},setup:function(c,d){this._parent(c,d)},parse:function(c){var d=c;d.specificTypes=d["material-specific-types"];delete d["material-specific-types"];return d}});return a});define("DS/MPF3DPMaterials/MPF3DPMaterialProcessModel",["DS/MPFModel/MPFModel"],function(b){var a=b.extend({setup:function(c,d){this._parent(c,d)},parse:function(c){return c}});return a});define("DS/MPF3DPMaterials/MPF3DPPublicMaterialSpecificTypeDataProxy",["DS/MPFDataProxy/DataProxy"],function(a){var b=a.extend({init:function(c,d){this._parent(c,"/mdmaterial/public/material-generic-types/"+d+"/material-specific-types")},request:function(d,c){return this._parent(d,c)},url:function(c){return this._parent(c)}});return b});define("DS/MPF3DPMaterials/MPF3DPPublicMaterialDataProxy",["DS/MPFDataProxy/DataProxy"],function(b){var a=b.extend({doGet:function(d,c){return this.connector.request(d,c)},init:function(c,d){this._parent(c,"/mdmaterial/public/material-specific-types/"+d+"/materials")},request:function(d,c){return this._parent(d,c)},url:function(c){return this._parent(c)}});return a});define("DS/MPF3DPMaterials/MPF3DPPrinterModel",["DS/MPFModel/MPFModel"],function(a){var b=a.extend({setup:function(c,d){this._parent(c,d)},sync:function(e,d,c){if(e==="read"){c.url=d.dataProxy.delegate.url(d)}return this._parent(e,d,c)},parse:function(c){var d={id:c.id,accuracy:c.Accuracy,diy:c.DIY.toLowerCase()==="true",image:c["Printer Image"],manufacturer:c.Manufacturer,materialType:c.materialType,maxVolumeX:c.MaxVolumeX,maxVolumeY:c.MaxVolumeY,maxVolumeZ:c.MaxVolumeZ,minLayerThickness:c.minLayerThickness,name:c["Printer name"]};if(c.hasOwnProperty("supportedMaterials")){d.supportedMaterials=c.supportedMaterials.map(function(e){return e.id})}if(c.hasOwnProperty("supportedAMProcess")){d.supportedAMProcess={name:c.supportedAMProcess.AMProcessName,id:c.supportedAMProcess.id}}if(c.hasOwnProperty("materialFamily")){d.materialFamilies=c.materialFamily!==""?c.materialFamily.split(","):[]}return d},toJSON:function(){return{Accuracy:this.get("accuracy"),DIY:this.get("diy"),Manufacturer:this.get("manufacturer"),materialFamily:this.get("materialFamilies").join(","),materialType:this.get("materialType"),MaxVolumeX:this.get("maxVolumeX"),MaxVolumeY:this.get("maxVolumeY"),MaxVolumeZ:this.get("maxVolumeZ"),minLayerThickness:this.get("minLayerThickness"),"Printer Image":this.get("image"),"Printer name":this.get("name"),supportedAMProcess:this.get("supportedAMProcess"),supportedMaterials:this.get("supportedMaterials")}}});return b});define("DS/MPF3DPMaterials/MPF3DPPublicPrinterDataProxy",["DS/MPFDataProxy/DataProxy"],function(b){var a=b.extend({doGet:function(d,c){return this._parent(d,c)},init:function(c){this._parent(c,"/mdprinter/public/printers")},request:function(d,c){this._parent(d,c)},url:function(c,d){return this._parent(c,d)},urlGet:function(c){var d=c.hasOwnProperty("id")?c.id:"";return c.dataProxy.delegate.connector.url(c.dataProxy.delegate.resourcePath+"/"+d)}});return a});define("DS/MPF3DPMaterials/MPF3DPPublicMaterialGenericTypeDataProxy",["DS/MPFDataProxy/DataProxy"],function(a){var b=a.extend({init:function(c){this._parent(c,"/mdmaterial/public/material-generic-types")},request:function(d,c){return this._parent(d,c)},url:function(c){return this._parent(c)}});return b});define("DS/MPF3DPMaterials/MPF3DPPublicMaterialProcessDataProxy",["DS/MPFDataProxy/DataProxy"],function(b){var a=b.extend({init:function(c){this._parent(c,"/mdmaterial/public/amprocessesv2")},request:function(d,c){return this._parent(d,c)},url:function(c){return this._parent(c)}});return a});define("DS/MPF3DPMaterials/MPF3DPMaterialSpecificTypeModel",["DS/MPFModel/MPFModel"],function(b){var a=b.extend({setup:function(c,d){this._parent(c,d)},parse:function(c){return c}});return a});define("DS/MPF3DPMaterials/MPF3DPPrinterDataProxy",["DS/MPFDataProxy/DataProxy","DS/MPF3DPMaterials/MPF3DPPublicPrinterDataProxy"],function(a,b){var c=a.extend({doGet:null,init:function(d){this._parent(d,"/mdprinter/printers",new b(d))},request:function(e,d){this._parent(e,d)},url:function(d,e){return this._parent(d,e)},urlGet:null});return c});define("DS/MPF3DPMaterials/MPF3DPMaterialCollection",["DS/MPFModel/MPFCollection","DS/MPF3DPMaterials/MPF3DPMaterialModel"],function(b,a){var c=b.extend({model:a,setup:function(e,d){this._parent(e,d)}});return c});define("DS/MPF3DPMaterials/MPF3DPMaterialGenericTypeCollection",["DS/MPFModel/MPFCollection","DS/MPF3DPMaterials/MPF3DPMaterialGenericTypeModel"],function(c,b){var a=c.extend({model:b,setup:function(e,d){this._parent(e,d)}});return a});define("DS/MPF3DPMaterials/MPF3DPPrinterCollection",["UWA/Promise","DS/MPFModel/MPFCollection","DS/MPF3DPMaterials/MPF3DPPrinterModel"],function(b,c,d){var a=c.extend({model:d,setup:function(f,e){this._parent(f,e)},fetchPromise:function(f){var g=this;var e=b.deferred();var h={onComplete:function(){e.resolve(g)},onFailure:e.reject};if(f.data){h.data=f.data}this.fetch(h);return e.promise},sync:function(g,f,e){return this._parent(g,f,e)}});return a});define("DS/MPF3DPMaterials/MPF3DPMaterialDataProxy",["DS/MPFDataProxy/DataProxy","DS/MPF3DPMaterials/MPF3DPPublicMaterialDataProxy"],function(a,b){var c=a.extend({doGet:null,init:function(d){this._parent(d,"/mdmaterial/materials",new b(d))},request:function(e,d){return this._parent(e,d)},url:function(d){return this._parent(d)}});return c});define("DS/MPF3DPMaterials/MPF3DPMaterialProcessCollection",["DS/MPFModel/MPFCollection","DS/MPF3DPMaterials/MPF3DPMaterialProcessModel"],function(c,a){var b=c.extend({model:a,setup:function(e,d){this._parent(e,d)}});return b});define("DS/MPF3DPMaterials/MPF3DPMaterialSpecificTypeCollection",["DS/MPFModel/MPFCollection","DS/MPF3DPMaterials/MPF3DPMaterialSpecificTypeModel"],function(b,a){var c=b.extend({model:a,setup:function(e,d){this.genericType=d.genericType;this._parent(e,d)}});return c});