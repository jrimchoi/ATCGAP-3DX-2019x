(function(){var a=["UWA/Core","UWA/Class"];if(window.location.protocol!=="file:"){a.push("text!DS/QualityManager/assets/mdl_GIVisualQualityPresets.json")}define("DS/QualityManager/QMGIPresetStreamer",a,function(b,d,c){var e=d.singleton({init:function(){this.GIQualityPresets=this.getQualityPresets();if(!b.is(this.GIQualityPresets)){return}},setItem:function(j,l){if(!b.is(localStorage)||!b.is(this.GIQualityPresets)){return}var k=this.GIQualityPresets;var f=j.split("/");var g=f.length;for(var h=0;h<g;h++){if(h==g-1){if(b.is(k)){k[f[h]]=l}}else{if(b.is(k)){k=k[f[h]]}}}},getItem:function(j){if(!b.is(localStorage)||!b.is(this.GIQualityPresets)){return null}var k=this.GIQualityPresets;var f=j.split("/");var g=f.length;for(var h=0;h<g;h++){if(b.is(k)){k=k[f[h]]}}return k},getQualityPresets:function(){var f=null;if(!b.is(localStorage)){return f}var g=localStorage.getItem("GIQualityPresets");if(b.is(g)){try{f=JSON.parse(g)}catch(h){console.error("Error parsing GIQualityPresets:",h)}}else{f=this.buidQualityPresets()}return f},commit:function(){if(!b.is(localStorage)||!b.is(this.GIQualityPresets)){return}localStorage.setItem("GIQualityPresets",JSON.stringify(this.GIQualityPresets))},retoreDB:function(){this.GIQualityPresets=this.getQualityPresets()},buidQualityPresets:function(){this.GIQualityPresets=c?JSON.parse(c):null;if(b.is(this.GIQualityPresets)){this.commit()}return this.GIQualityPresets},});return e})})();(function(){var a=["UWA/Core","UWA/Class"];if(window.location.protocol!=="file:"){a.push("text!DS/QualityManager/assets/mdl_QualityManagerPreset.json")}define("DS/QualityManager/QMPresetStreamer",a,function(b,d,c){var e=d.singleton({init:function(){this.databaseKey=null;this.qualityPresets=null},initDataBase:function(f){this.databaseKey=f;if(this.databaseKey==null){this.databaseKey="default_qualityPresets"}this.qualityPresets=this.getQualityPresets();if(!b.is(this.qualityPresets)){return}},setItem:function(j,l){if(!b.is(localStorage)||!b.is(this.qualityPresets)){return}var k=this.qualityPresets;var f=j.split("/");var g=f.length;for(var h=0;h<g;h++){if(h==g-1){if(b.is(k)){k[f[h]]=l}}else{if(b.is(k)){k=k[f[h]]}}}},getItem:function(j){if(!b.is(localStorage)||!b.is(this.qualityPresets)){return null}var k=this.qualityPresets;var f=j.split("/");var g=f.length;for(var h=0;h<g;h++){if(b.is(k)){k=k[f[h]]}}return k},getQualityPresets:function(){var f=null;if(!b.is(localStorage)){return f}var g=localStorage.getItem(this.databaseKey);if(b.is(g)){try{f=JSON.parse(g)}catch(h){console.error("Error parsing qualityPresets:",h)}}else{f=this.buidQualityPresets()}return f},commit:function(){if(!b.is(localStorage)||!b.is(this.qualityPresets)){return}localStorage.setItem(this.databaseKey,JSON.stringify(this.qualityPresets))},retoreDB:function(){this.qualityPresets=this.getQualityPresets()},buidQualityPresets:function(){this.qualityPresets=c?JSON.parse(c):null;if(b.is(this.qualityPresets)){this.commit()}return this.qualityPresets},});return e})})();define("DS/QualityManager/QMController",["UWA/Core","UWA/Class","DS/QualityManager/QMPresetStreamer"],function(b,c,d){var a=c.singleton({init:function(){this.isInitialized=true;d.init();this.currentUser=null;this.currentPreset=null;this.isLinked=null;this.prestToModify=null;this._webGLV6Viewers=[]},linkToViewer:function(e){this._webGLV6Viewers.push(e)},initPresetDB:function(e){d.initDataBase(e);this.currentUser=d.getItem("currentUser");var f="Users/"+this.currentUser+"/currentPreset";this.currentPreset=d.getItem(f);var f="Users/"+this.currentUser+"/isLinked";this.isLinked=d.getItem(f);this.prestToModify="Custom"},setCurrentUser:function(f){var g="Users/"+f;var e=d.getItem(g);if(b.is(e)){d.setItem("currentUser",f);this.currentUser=f}else{}},setCurrentRenderMode:function(g){var f="Users/"+this.currentUser+"/currentPreset";var e=d.getItem(f);if(b.is(e)){d.setItem(f,g);this.currentPreset=g}else{}},getCurrentRenderMode:function(){var f="Users/"+this.currentUser+"/currentPreset";var e=d.getItem(f);return e},setLinkedPresetStatus:function(g){var f="Users/"+this.currentUser+"/isLinked";var e=d.getItem(f);if(b.is(e)){d.setItem(f,g);this.isLinked=g}else{}},getLinkedPresetStatus:function(){var e="Users/"+this.currentUser+"/isLinked";var f=d.getItem(e);return f},getCurrentUserPresetQuery:function(){var e="Users/"+this.currentUser+"/Preset/";return e},validateAttribute:function(e,g){var f=true;if(e=="ReflectionsOnGround"||e=="Preset"){f=false}return f},setAttribute:function(i,f,e,g,h){this.setAttributeOnViewer(i,g,h);this.setAttributeOnDB(i,f,e,g,h)},setAttributeOnViewer:function(l,j,m){if(!this.validateAttribute(j,m)){return false}var k=false;var o=(l==="Dynamic")?"dynamicValue":"staticValue";var n;if(typeof m==="string"){n=JSON.parse('{"'+j+'":"'+m+'"}')}else{n=JSON.parse('{"'+j+'":'+m+"}")}for(var h=0;h<this._webGLV6Viewers.length;h++){var g=this._webGLV6Viewers[h];var e=g._getQMSetting(j);if(e[o]!==m){g._setQMSettings(n,l);var f=g._getQMSetting(j);if(f[o]!==e[o]){k=true}}}return k},setAttributeOnDB:function(l,g,e,h,k){var i=this.getCurrentUserPresetQuery()+l+"/"+this.prestToModify+"/"+e+"/";var j=i+h;d.setItem(j,k);var f=i+"Preset";d.setItem(f,g)},setAttributeOnDynamicMode:function(k,f,e,g,j){var h=this.getCurrentUserPresetQuery()+k+"/"+f+"/"+e+"/";var i=h+g;d.setItem(i,j)},setProperty:function(g,f,e){this.setPropertyOnViewer(g,f,e);this.setPropertyOnDB(g,f,e)},setPropertyOnViewer:function(l,g,f){var j=this.getCurrentUserPresetQuery()+l+"/"+g;var k=d.getItem(j);if(!b.is(k)){return false}var e=k[f];if(!b.is(e)){return false}for(var i in e){if(e.hasOwnProperty(i)){var h=e[i];this.setAttributeOnViewer(l,i,h)}}},setPropertyOnDB:function(l,g,f){var j=this.getCurrentUserPresetQuery()+l+"/"+g;var k=d.getItem(j);if(!b.is(k)){return false}var e=k[f];if(!b.is(e)){return false}for(var i in e){if(e.hasOwnProperty(i)){var h=e[i];this.setAttributeOnDB(l,g,f,i,h)}}},setGlobalPreset:function(g,f,e){this.setGlobalPresetOnViewer(g,f);this.setGlobalPresetOnDB(g,f,e)},setGlobalPresetOnViewer:function(i,f){var g=this.getCurrentUserPresetQuery()+i+"/"+f;var h=d.getItem(g);if(!b.is(h)){return false}for(var e in h){if(h.hasOwnProperty(e)){this.setPropertyOnViewer(i,f,e)}}},setGlobalPresetOnDB:function(j,g,e){var h=this.getCurrentUserPresetQuery()+j+"/currentGlobalPreset";d.setItem(h,g);if(!e){return}h=this.getCurrentUserPresetQuery()+j+"/"+g;var i=d.getItem(h);if(!b.is(i)){return false}for(var f in i){if(i.hasOwnProperty(f)){this.setPropertyOnDB(j,g,f)}}},getCurrentGlobalPreset:function(g){var f=this.getCurrentUserPresetQuery()+g+"/currentGlobalPreset";var e=d.getItem(f);return e},getPresetValue:function(h,e){var g=this.getCurrentUserPresetQuery()+h+"/"+e;var f=d.getItem(g);return f},commitToDB:function(){d.commit()},restoreFromDB:function(){d.retoreDB();var f=this.getCurrentRenderMode();var e=this.getCurrentGlobalPreset(f);this.setGlobalPreset(f,e,false)},dispose:function(){this._webGLV6Viewers=[]}});return a});define("DS/QualityManager/QMGIController",["UWA/Core","UWA/Class","DS/QualityManager/QMGIPresetStreamer"],function(a,b,d){var c=b.singleton({init:function(){this.isInitialized=true;this.initPresetDB();this.properties={};this._QMSettings={MaxSamples:{value:{Static:true,Batch:false}},MinSamples:{value:{Static:true,Batch:false}},Clamping:{value:{Static:true,Batch:true}},GaussFilter:{value:{Static:true,Batch:true}},Size:{value:{Static:true,Batch:true}},CenterWeight:{value:{Static:true,Batch:true}},MAxTraceDepth:{value:{Static:true,Batch:true}},GlossyThreshold:{value:{Static:true,Batch:true}},RenderRefractiveShadow:{value:{Static:true,Batch:true}},LocationBasedSampling:{value:{Static:true,Batch:true}},Distribution:{value:{Static:true,Batch:true}},Factor:{value:{Static:true,Batch:true}},PathTerminationDepth:{value:{Static:true,Batch:true}},VisualizationMode:{value:{Static:true,Batch:false}},EnableFinalGathering:{value:{Static:true,Batch:true}},NoOfPhotons:{value:{Static:true,Batch:true}},PathDepth:{value:{Static:true,Batch:true}},PhotonRadius:{value:{Static:true,Batch:true}},RefineMap:{value:{Static:true,Batch:true}},PrecalculateIrradiance:{value:{Static:true,Batch:true}},Caustics:{value:{Static:true,Batch:true}},CausticsPhotonNumber:{value:{Static:true,Batch:true}},CausticsPathDepth:{value:{Static:true,Batch:true}},CausticRadius:{value:{Static:true,Batch:true}},CausticRefinePhotonMap:{value:{Static:true,Batch:true}},RayOffset:{value:{Static:true,Batch:true}},AllowGroundShadows:{value:{Static:true,Batch:true}},AllowReflectionsOnGround:{value:{Static:true,Batch:true}},AllowBloom:{value:{Static:true,Batch:true}},AllowDepthOfField:{value:{Static:true,Batch:true}},DownsamplingFctor:{value:{Static:true,Batch:false}},}},initPresetDB:function(){d.init();this.currentUser=d.getItem("currentUser");var e="Users/"+this.currentUser+"/currentPreset";this.currentPreset=d.getItem(e);this.prestToModify="Custom"},setCurrentUser:function(f){var g="Users/"+f;var e=d.getItem(g);if(a.is(e)){d.setItem("currentUser",f);this.currentUser=f}else{}},setCurrentPreset:function(g){var f="Users/"+this.currentUser+"/currentPreset";var e=d.getItem(f);if(a.is(e)){d.setItem(f,g);this.currentPreset=g}else{}},getCurrentUserPresetQuery:function(){var e="Users/"+this.currentUser+"/Preset/";return e},getCurrentPreset:function(){var f="Users/"+this.currentUser+"/currentPreset";var e=d.getItem(f);return e},validateAttribute:function(e,g){var f=true;if(e=="ReflectionsOnGround"||e=="Preset"){f=false}return f},setAttribute:function(i,f,e,g,h){this.setAttributeOnDB(i,f,e,g,h)},setAttributeOnDB:function(l,g,e,h,k){var i=this.getCurrentUserPresetQuery()+l+"/"+this.prestToModify+"/"+e+"/";var j=i+h;d.setItem(j,k);var f=i+"Preset";d.setItem(f,g)},setProperty:function(g,f,e){this.setPropertyOnDB(g,f,e)},setPropertyOnDB:function(l,g,f){var j=this.getCurrentUserPresetQuery()+l+"/"+g;var k=d.getItem(j);if(!a.is(k)){return false}var e=k[f];if(!a.is(e)){return false}for(var i in e){if(e.hasOwnProperty(i)){var h=e[i];this.setAttributeOnDB(l,g,f,i,h)}}},setGlobalPreset:function(g,f,e){this.setGlobalPresetOnDB(g,f,e)},setGlobalPresetOnDB:function(j,g,e){var h=this.getCurrentUserPresetQuery()+j+"/currentGlobalPreset";d.setItem(h,g);if(!e){return}h=this.getCurrentUserPresetQuery()+j+"/"+g;var i=d.getItem(h);if(!a.is(i)){return false}for(var f in i){if(i.hasOwnProperty(f)){this.setPropertyOnDB(j,g,f)}}},getCurrentGlobalPreset:function(g){var f=this.getCurrentUserPresetQuery()+g+"/currentGlobalPreset";var e=d.getItem(f);return e},getPresetValue:function(h,e){var g=this.getCurrentUserPresetQuery()+h+"/"+e;var f=d.getItem(g);return f},commitToDB:function(){d.commit()},restoreFromDB:function(){d.retoreDB();var f=this.getCurrentPreset();var e=this.getCurrentGlobalPreset(f);this.setGlobalPreset(f,e,false)},setQMsetting:function(f,h,g){var e=this._QMSettings[f];if(g=="true"){e.value[h]=true}else{e.value[h]=false}},getQMsetting:function(f,g){var e=this._QMSettings[f];return e.value[g]},});return c});