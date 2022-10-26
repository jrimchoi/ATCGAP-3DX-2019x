define("DS/DibWebUtils/DibQueryToolbox",["UWA/Core","DS/WAFData/WAFData","DS/WebappsUtils/WebappsUtils","DS/PADUtils/PADSettingsMgt"],function(e,a,f,d){var h=function(l){if(!e.is(l.objectPhysicalid,"array")){throw new Error("No phy id defined")}if(!e.is(l.onComplete,"function")){throw new Error("No onComplete defined")}if(!e.is(l.onFailure,"function")){throw new Error("No onFailure defined")}if(!l.serverUrl){throw new Error("No server URL")}if(!l.securityContext){throw new Error("No security context")}var n="/cvservlet/fetch/v2";var k=l.serverUrl+n+"?SecurityContext="+l.securityContext;var j={label:"UDL_"+Date.now(),physicalid:l.objectPhysicalid,select_file:["udl"]};var m=parseInt(d.getSetting("webapi_timeout"),10);var i={data:JSON.stringify(j),method:"POST",headers:{Accept:"application/json","Content-Type":"application/json"},onComplete:function(p){var o=JSON.parse(p);l.onComplete(o)},onFailure:l.onFailure};return b(k,i)};var g=function(l){if(!e.is(l.objectPhysicalid,"string")){throw new Error("No phy id defined")}if(!e.is(l.onComplete,"function")){throw new Error("No onComplete defined")}if(!e.is(l.onFailure,"function")){throw new Error("No onFailure defined")}if(!l.serverUrl){throw new Error("No server URL")}if(!l.securityContext){throw new Error("No security context")}var n="/cvservlet/expand";var k=l.serverUrl+n+"?SecurityContext="+l.securityContext;var j={label:"UDL_"+Date.now(),root_physicalid:l.objectPhysicalid,expand_iter:"-1",select_bo:["physicalid","ds6w:type","bo.PLMEntity.V_Name","bo.DIFAbstractSheet.V_DIFFormatHeight","bo.DIFAbstractSheet.V_DIFFormatWidth","bo.DIFAbstractView.V_DIFScale","bo.DIFAbstractView.V_DIFScaleStatus"],select_rel:["physicalid","ds6w:type","ro.DIFAbstractViewInstance.V_DIFScale","ro.DIFAbstractViewInstance.V_DIFPosX","ro.DIFAbstractViewInstance.V_DIFPosY","ro.DIFAbstractViewInstance.V_DIFAngle"]};var m=parseInt(d.getSetting("webapi_timeout"),10);var i={data:JSON.stringify(j),method:"POST",headers:{Accept:"application/json","Content-Type":"application/json"},onComplete:function(p){var o=JSON.parse(p);l.onComplete(o)},onFailure:l.onFailure};return b(k,i)};var b=function(j,i){return a.authenticatedRequest(j,i)};var c={getUDLData:function(i){return h(i)},expandDifComponent:function(i){return g(i)}};return c});define("DS/DibWebUtils/DibFavoriteContextAccess",["UWA/Core","DS/WAFData/WAFData","DS/WebappsUtils/WebappsUtils","DS/PADUtils/PADSettingsMgt","DS/PADUtils/PADUtilsServices"],function(f,a,g,e,h){var d=function(l){if(!f.is(l.ObjectPhysicalid,"string")){throw new Error("No phy id defined")}if(!f.is(l.onComplete,"function")){throw new Error("No onComplete defined")}if(!f.is(l.onFailure,"function")){throw new Error("No onFailure defined")}var n="/cvservlet/navigate";var k=h.get3DSpaceUrl()+n+"?SecurityContext=preferred";var j={input_physical_ids:[l.ObjectPhysicalid],primitives:[{navigate_to_sr:{id:1,filter:{semantics:["1"],role:["318"]},mode:"path"}}],patterns:{ROOT_PRODUCT_PATH:[{id:1}]},attributes:[],flags:["noReturnThumbnails"],version:3,label:"FavoriteContextQuerry"};var m=parseInt(e.getSetting("webapi_timeout"),10);var i={data:JSON.stringify(j),timeout:m,method:"POST",headers:{Accept:"application/json","Content-Type":"application/json"},onComplete:l.onComplete,onFailure:l.onFailure};return b(k,i)};var b=function(j,i){var k=null;var l=e.getSetting("cors_activated");if(l===true){k=a.authenticatedRequest(j,i)}else{i.proxy="passport";k=a.proxifiedRequest(j,i)}return k};var c={getFavoriteContextInfos:function(j){if(!f.is(j.ObjectPhysicalid,"string")){throw new Error("No onComplete defined")}if(!f.is(j.onComplete,"function")){throw new Error("No onComplete defined")}if(!f.is(j.onFailure,"function")){throw new Error("No onFailure defined")}var m={RootObject:null,PathOfInstances:[],Error:null};var l="/cvservlet/navigate";var i=h.get3DSpaceUrl()+l+"?SecurityContext=preferred";var k={ObjectPhysicalid:j.ObjectPhysicalid,onComplete:function(s){var q=f.is(s,"string")?JSON.parse(s):s;if(!f.is(q.result,"array")){j.onComplete(m);return}if(q.result.length<1){j.onComplete(m);return}if(!f.is(q.result[0].outputs.ROOT_PRODUCT_PATH,"array")){j.onComplete(m);return}if(q.result[0].outputs.ROOT_PRODUCT_PATH.length<1){m.Error=new Error("Bad length of the path of instances, it should be at least one element");j.onComplete(m);return}if(q.result[0].outputs.ROOT_PRODUCT_PATH[0].elements<1){m.Error=new Error("Bad length of the path of instances, it should be at least one element");j.onComplete(m);return}var p=q.result[0].outputs.ROOT_PRODUCT_PATH[0].elements[0];var o=q.result[0].outputs.ROOT_PRODUCT_PATH[0].elements;if((p["ds6w:businessType"]==="VPMRepInstance")||(p["ds6w:businessType"]==="VPMInstance")){var n={input_physical_ids:[p.physicalid],primitives:[{navigate_from_rel:{id:1}}],patterns:{ROOT_PRODUCT:[{id:1,iter:1}]},attributes:[],flags:["noReturnThumbnails"],version:3,label:"FavoriteContextInfosQuerry"};var r=parseInt(e.getSetting("webapi_timeout"),10);var t={data:JSON.stringify(n),timeout:r,method:"POST",headers:{Accept:"application/json","Content-Type":"application/json"},onComplete:function(v){var u=f.is(v,"string")?JSON.parse(v):v;if(!f.is(u.result,"array")){j.onComplete(m);return}if(u.result.length<1){j.onComplete(m);return}if(!f.is(u.result[0].outputs.ROOT_PRODUCT,"array")){j.onComplete(m);return}if(u.result[0].outputs.ROOT_PRODUCT.length<1){j.onComplete(m);return}p=u.result[0].outputs.ROOT_PRODUCT[0];m.PathOfInstances=o;m.RootObject=p;j.onComplete(m)},onFailure:j.onFailure};return b(i,t)}else{m.RootObject=p;j.onComplete(m)}},onFailure:j.onFailure};return d(k)},getFilters:function(l){if(!f.is(l.ObjectPhysicalid,"string")){throw new Error("No onComplete defined")}if(!f.is(l.onComplete,"function")){throw new Error("No onComplete defined")}if(!f.is(l.onFailure,"function")){throw new Error("No onFailure defined")}var m=parseInt(e.getSetting("webapi_timeout"),10);var n="/cvservlet/navigate";var k=h.get3DSpaceUrl()+n+"?SecurityContext=preferred";var i={input_physical_ids:[l.ObjectPhysicalid],primitives:[{navigate_to_sr:{id:1,filter:{semantics:["4"],role:["319"]},mode:"first"}}],patterns:{FILTERS:[{id:1}]},attributes:[],flags:["noReturnThumbnails"],version:3,label:"FavoriteContextQuerryFilter"};var j={data:JSON.stringify(i),timeout:m,method:"POST",headers:{Accept:"application/json","Content-Type":"application/json"},onComplete:l.onComplete,onFailure:l.onFailure};return b(k,j)}};return c});