define("UWA/Storage",["UWA/Internal/Deprecate","UWA/Core","UWA/Class","UWA/Class/Options","UWA/Class/Debug","UWA/Json"],function(e,g,c,b,f,a){var d=c.extend(b,f,{AdaptersInstances:null,currentAdapter:null,defaultOptions:{database:"default",adapter:null,adapterOptions:{},availableAdapters:[]},internalKeys:{keysIndex:"_keysIndex",lastUpdate:"_lastUpdate"},isReady:false,init:function(i){e.warn("UWA/Storage");var h,j=this;j.AdaptersInstances={};d.Instances.push(j);j.setOptions(i);h=j.options.adapter;if(!h||h==="auto"){j.setCurrentAdapterFromDetected()}else{j.setCurrentAdapter(h)}},initAvailableAdapters:function(){var h,j=this,i=j.options.availableAdapters,k=d.Adapter;if(i.length===0){for(h in k){if(k.hasOwnProperty(h)&&h!=="Abstract"){i.push(h)}}}i.forEach(function(l){j.getAdapterInstance(l)})},isAvailableAdapter:function(l){var i,j=this,h=false;try{i=j.getAdapterInstance(l);if(i&&i.isAvailable()){h=true;j.log('UWA.Storage:detectAvailableAdapter: "'+l+'" is available')}else{j.log('UWA.Storage:detectAvailableAdapter: "'+l+'" is not available')}}catch(k){j.log('UWA.Storage:detectAvailableAdapter: "'+l+'" is not available cause: '+k)}return h},getAdapterInstance:function(j){var i=this,h=i.AdaptersInstances;if(typeof j!=="string"){throw new Error('Bad adapterName param value "'+j+'" for getAdapterInstance.')}if(!h[j]){h[j]=new d.Adapter[j](i,i.options.adapterOptions);if(!(h[j] instanceof d.Adapter.Abstract)){throw new Error("UWA.Storage.Adapter."+j+" is not an instance of UWA.Storage.Adapter.Abstract")}}return h[j]},detectAvailableAdapter:function(){var j=this,i=j.options,h=[];j.initAvailableAdapters();i.availableAdapters.forEach(function(k){if(j.isAvailableAdapter(k)){h.push(k)}});i.availableAdapters=h},setCurrentAdapterFromDetected:function(){var i=this,h=i.options;i.detectAvailableAdapter();if(h.availableAdapters.length>0){i.setCurrentAdapter(h.availableAdapters[0])}else{throw new Error("UWA.Storage: No adapter available detected.")}},setCurrentAdapter:function(j){var i,h=this;if(typeof j!=="string"){throw new Error('Bad adapterName param value "'+j+'" for setCurrentAdapter.')}if(h.isAvailableAdapter(j)){i=h.getAdapterInstance(j);i.connect(h.options.database);h.log("UWA.Storage:setCurrentAdapter: "+j+";");h.adapter=j;h.currentAdapter=i}else{h.log('UWA.Storage:setCurrentAdapter: "'+j+'" fail fallback in auto detect mode');h.setCurrentAdapterFromDetected()}},store:function(i,l){var j,k=this,h=k.currentAdapter;if(h){j=k.safeResurrect(h.get(i));if(arguments.length===1){k.log('Get Key "'+i+'" with value "'+j+'"')}else{if(j!==l){j=k.safeStore(l);k.log('Update Key "'+i+'" with value "'+l+'" and stored value "'+j+'"');j=h.set(i,j)}}}return j},remove:function(h){var i=this;if(!i.currentAdapter){return false}i._updateLastUpdateDate();i._removeKeyFromKeysIndex(h);return i.safeResurrect(i.currentAdapter.rem(h))},get:function(h,l){var j,k,i=this;if(l){j=i._getKeysIndex();if(j.hasOwnProperty(h)&&(Date.now()-j[h])<=l){k=i.store(h)}}else{k=i.store(h)}return k},set:function(h,j){var i=this;i._updateLastUpdateDate();i._addKeyToKeysIndex(h);return i.store(h,j)},getAll:function(){var i=this,h=Object.keys(this._getKeysIndex()),j={};h.forEach(function(k){j[k]=i.get(k)});return j},safeStore:function(h){return a.encode(h)},safeResurrect:function(i){if(!g.is(i,"undefined")){try{if(a.isJson(i)){i=a.decode(i)}}catch(h){g.log("unsafe Resurrect JSON with value: "+i);g.log(h)}}return i},getLastUpdateDate:function(h){var i;if(h){i=this._getKeysIndex()[h]}else{i=this.get(this.internalKeys.lastUpdate)}return new Date().setTime(i)},_getKeysIndex:function(){var j=this,i=j.safeResurrect(j.currentAdapter.get(this.internalKeys.keysIndex)),h=g.typeOf(i);j.log("Get all keys from keysIndex");if(h==="array"){(function(){var k={},l=j.getLastUpdateDate();i.forEach(function(m){k[m]=l});i=k}())}else{if(h!=="object"){i={}}}return i},_removeKeyFromKeysIndex:function(j){var i,l=this,k=l._getKeysIndex(),h={};l.log('Remove key "'+j+'" from keysIndex');for(i in k){if(k.hasOwnProperty(i)&&i!==j){h[i]=k[i]}}l._storeKeysIndex(h)},_addKeyToKeysIndex:function(h){var j=this,i=j._getKeysIndex();j.log('Add key "'+h+'" to keysIndex');i[h]=Date.now();j._storeKeysIndex(i)},_storeKeysIndex:function(i){var h=this;h.currentAdapter.set(h.internalKeys.keysIndex,h.safeStore(i))},_updateLastUpdateDate:function(){var i=this,h=Date.now();i.currentAdapter.set(i.internalKeys.lastUpdate,i.safeStore(h));return h}});d.Instances=[];g.merge(d,{allInstancesReady:function(){return d.Instances.every(function(h){return h.isReady})}});return g.namespace("Storage",d,g)});