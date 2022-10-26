define("DS/3DPlayApplication/Legacy3DplayManagerCompatibility",["DS/WebApplicationBase/W3AAManager","DS/WebSystem/Environment"],function(c,a){var b=a.isBoolActive("3DPlay.ProfileLoading");return c.extend({init:function(e,d){this._parent();this.experience=e;this.application=d;this._ID="3DPLAYMANAGER";this.renderProfile},initialize:function(){},update:function(){this.experience.skipRender=false;this.experience._step.apply(this.experience,[arguments[0].time,arguments[0].profiler]);this.application.options.iWebApplication.skipFrame=this.experience.skipRender},postRender:function(e){var d=e.renderingTime;this.experience.lastRender=d;this.experience.renderTime=this.experience.renderTime||0;if(this.experience.modelLoadComplete===false){if(b){console.log("3DPlay.ProfileLoading frame TIME ",d)}this.experience.renderTime+=d;this.experience.nbrender=this.experience.nbrender||0;this.experience.nbrender++}},uninitialize:function(){this.experience=null;this.application=null}})});define("DS/3DPlayApplication/3DPlayApplication",["UWA/Class","DS/3DPlay/Loader","DS/3DPlay/3DPlay","DS/WebSystem/Nls","DS/WebSystem/Environment","DS/3DPlayApplication/Legacy3DplayManagerCompatibility","UWA/Promise","DS/WebUtils/ProbesManager"],function(a,h,b,g,e,f,d,c){return a.extend({init:function(i){this.options=UWA.extend({},i,true);if(this.options&&!this.options.ctx){this.options.ctx="3DShare"}this._parent(this.options.ctx)},onPreCreate:function(i,j){this.options.iWebApplication=i;this.options.endDom=j;this.options.i3DPlayApp=this;c.end("WebApplication");b.createExperience(this.options)},onPostCreate:function(i,k){this.experience.frmWindow=i.webApplication.frmWindow;this.experience.experienceBase=i;this.man=new f(this.experience,this);i._ManagerSet._ManagerArray.push(this.man);this.experience.webapp=i.webApplication;this.experience.frmWindow.experience=this.experience;var j=this;return new d(function(m,l){j.experience.initExperienceBase(i,function(){m();k&&k(0);j=null})})},onFinished:function(){if(!this.experience._3DPlayAppInit){this.experience._3DPlayAppInit=true;this.experience.initExperience2()}},disposeExperienceBase:function(j){var i=this;return new d(function(l,k){i.experience.disposeExperienceBase&&i.experience.disposeExperienceBase(function(){l();j&&j(0);i=null})})},getModelLoader:function(){return this.experience.modelLoader},dispose:function(){this.experience.experienceBase=null;this.experience.webapp=null;this.options.i3DPlayApp=null;this.options=null;this.experience.webapp=null;this.experience=null;this.man.uninitialize();this.nam=null;this._parent()}})});