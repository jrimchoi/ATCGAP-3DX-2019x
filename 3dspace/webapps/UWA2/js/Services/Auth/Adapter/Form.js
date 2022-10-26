define("UWA/Services/Auth/Adapter/Form",["UWA/Core","UWA/Utils","UWA/Ajax","UWA/Json","UWA/Data","UWA/Services/Auth/Adapter/Abstract"],function(g,e,d,a,c,f){var b=f.extend({defaultOptions:{timeout:15000,checkUrl:"https://example.com/myapp/test.json",loginUrl:"https://example.com/global/2.0/login.fcc",logoutUrl:"https://example.com/global/2.0/logout.fcc",params:{},fields:{},variables:{}},isAjaxPostAllowed:function(){return c.allowCrossOriginRequest},hasIdentity:function(j,i){var h=this.options;a.request(h.target,{useOfflineCache:false,timeout:h.timeout,onComplete:function(k){if(typeof j==="function"){j(k)}}.bind(this),onFailure:function(k){if(typeof i==="function"){i(k)}}.bind(this)})},getIdentity:function(i,h){h(new Error("Not implemented."))},clearIdentity:function(h){h=h||function(){};if(this.isAjaxPostAllowed()){this.clearIdentityUsingAjax(h)}else{this.clearIdentityUsingFrame(h)}},authenticate:function(n,k,j){k=k||function(){};n=n||function(){};if(!j.login||!j.password){k(new Error("Invalid credentials values."))}else{var i=this.options,m=i.loginUrl,l=function(){this.hasIdentity(n,k)}.bind(this),h=i.fields;m+=(m.indexOf("?")>-1?"&":"?")+e.toQueryString(i.params).replace(/%25/g,"-%");if(this.isAjaxPostAllowed()){this.authenticateUsingAjax(h,m,l,k)}else{this.authenticateUsingFrame(h,m,l,k)}}},authenticateUsingFrame:function(m,n,l){var p,j,o=e.random(1,100000),h=g.createElement("div"),k=g.createElement("iframe",{src:"about:blank",id:"formAuth:frame:"+o,name:"formAuth:frame:"+o,styles:{position:"absolute",top:"-2000px",left:"0px"}}).inject(h),i=g.createElement("form",{target:"formAuth:frame:"+o,action:n,method:"post"}).inject(h);for(p in m){if(m.hasOwnProperty(p)){j=m[p];g.createElement("input",{type:"hidden",name:p,value:j}).inject(i)}}h.inject(document.body);k.addEvent("load",function(){l();h.destroy()});i.submit()},clearIdentityUsingFrame:function(i){var j,h=this.options.logoutUrl;h+=(h.indexOf("?")>-1?"&":"?")+"rnd="+Math.random();j=g.createElement("iframe",{src:h,styles:{position:"absolute",top:"-2000px",left:"0"},events:{load:function(){i();j.destroy()}}}).inject(document.body)},authenticateUsingAjax:function(h,k,j,i){d.request(k,{onComplete:j,onFailure:i,method:"POST",data:h})},clearIdentityUsingAjax:function(i){var h=this.options.logoutUrl;h+=((h.indexOf("?")>-1)?"&":"?")+"rnd="+Math.random();d.request(h,{onComplete:i,onFailure:i,method:"GET"})}});return g.namespace("Services/Auth/Adapter/Form",b,g)});