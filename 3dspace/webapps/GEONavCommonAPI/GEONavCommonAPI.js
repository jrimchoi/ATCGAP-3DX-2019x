define("DS/GEONavCommonAPI/GEONavCommonServices",["UWA/Core","DS/i3DXCompassPlatformServices/i3DXCompassPlatformServices","DS/WAFData/WAFData"],function(e,d,a){var c="X-DS-CSRFTOKEN";var b={_csrf:"",callService:function(f,j,h){var i=this;var g=f.envId?f.envId:widget.getValue("x3dPlatformId");d.getServiceUrl({serviceName:f.serviceName,platformId:g,onComplete:function(l){var k;if(Array.isArray(l)){if(l.length){k=l[0].url}}else{if(l.constructor===String){k=l}}i.requestService({url:k+f.URI,requestOptions:f.requestOptions},j,h)},onFailure:function(l){console.log(l.message);var k={message:"The "+f.serviceName+" Service has not been found in the platform"};h(k)}})},callFCSService:function(h,j,i){var g={method:"GET",type:"text",onComplete:function(k){j(k)},onFailure:function(l){console.log(l.message);var k={message:"GEONavCommonServices: error calling FCS service"};i(k)}};var f=UWA.extend(UWA.clone(g),h.requestOptions);a.authenticatedRequest(h.actionurl,f)},requestService:function(h,k,i){var j=this;var g={method:"GET",type:"json",onComplete:function(o,n,m){var l=j.getCSRFTokenFromHeader(n);if(l){j._csrf=l}k(o)},onFailure:function(m){console.log(m.message);var l={message:"error calling web service"};i(l)}};var f=UWA.extend(UWA.clone(g),h.requestOptions);if(!f.headers){f.headers={}}f.headers[c]=j._csrf||"";a.authenticatedRequest(h.url,f)},getCSRFTokenFromHeader:function(f){if(f===undefined){return""}return f[c]||f[c.toLowerCase()]}};return b});