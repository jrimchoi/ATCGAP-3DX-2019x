define("UWA/Dispatcher",["UWA/Core","UWA/Utils","UWA/Class"],function(d,c,b){var a=d.Class.extend({Binding:null,bindings:null,shouldPropagate:true,active:true,dispatching:0,init:function(){this.bindings=[]},registerListener:function(j,i,g,f){if(!d.is(j,"function")&&!(d.is(j,"object")&&d.is(j.handleEvent,"function"))){throw new Error("listener is a required param of add() and addOnce() and should be a Function or an object implementing the EventListener interface.")}var e,k,h=this;e=h.indexOfListener(j,g);k=h.bindings[e];if(k){if(k.isOnce!==i){throw new Error("You cannot add"+(i?"":"Once")+"() then add"+(!i?"":"Once")+"() the same listener without removing the relationship first.")}}else{k=new this.Binding(h,j,i,g,f);h.addBinding(k)}return k},addBinding:function(e){var g=this.bindings,f=g.length;do{--f}while(g[f]&&e.priority<=g[f].priority);g.splice(f+1,0,e)},indexOfListener:function(f,e){var h=this.bindings,g=h.length;while(g--){if(h[g].listener===f&&(e===undefined||h[g].context===e)){return g}}return -1},add:function(g,f,e){return this.registerListener(g,false,f,e)},addOnce:function(g,f,e){return this.registerListener(g,true,f,e)},remove:function(i,f){var e,j,g=this;if(!d.is(i,"function")&&!(d.is(i,"object")&&d.is(i.handleEvent,"function"))){throw new Error("listener is a required param of remove() and should be a Function or an object implementing the EventListener interface.")}e=g.indexOfListener(i,f);if(e!==-1){j=g.bindings[e];if(g.dispatching&&!j.isOnce){var h=g.bindings.indexOf(j);if(h!==-1){g.bindings.splice(h,1)}}else{j.destroy()}}return i},removeAll:function(e){var g,f=this,i=f.bindings,h=i.length;if(e){while(h--){g=i[h];if(g.context===e){g.destroy()}}}else{while(h--){i[h].destroy()}i.length=0}},getNumListeners:function(){return this.bindings.length},getListeners:function(){return this.bindings.map(function(e){return e.listener})},halt:function(){this.shouldPropagate=false},dispatch:function(j,f){var e,h,k,g=this;if(g.active){j=c.toArray(j);k=g.bindings.slice();g.shouldPropagate=true;g.dispatching++;try{for(e=k.length-1;e>=0;e--){h=k[e];if(h.execute(j,f)===false){break}if(!g.shouldPropagate){break}}}finally{g.dispatching--;if(g.bindings){for(e=0;e<k.length;e++){if(g.bindings.indexOf(k[e])<0){k[e].destroy()}}}}}},dispose:function(){var e=this;e.removeAll();e.active=false;delete e.bindings},toString:function(){var e=this;return"[Dispatcher active: "+e.active+" numListeners: "+e.getNumListeners()+"]"}});a.Binding=a.prototype.Binding=b.extend({listener:null,isOnce:false,context:null,dispatcher:null,priority:0,active:true,init:function(f,j,h,i,e){var g=this;g.listener=j;g.isOnce=h;g.context=i;g.dispatcher=f;g.priority=e||0},execute:function(j,f){var h,g=this,i=g.listener,e=d.is(g.context)?g.context:f;if(g.active){if(g.isOnce){g.detach()}if(typeof i.handleEvent==="function"){h=i.handleEvent.apply((e===undefined)?i:e,j||[])}else{h=i.apply(e,j||[])}}return h},detach:function(){var e=this;if(e.dispatcher){e.dispatcher.remove(e.listener,e.context)}return e.listener},getListener:function(){return this.listener},dispose:function(){var e=this;e.destroy()},destroy:function(){var g,f=this,e=f.dispatcher;if(e){g=e.bindings.indexOf(f);f.active=false;if(g!==-1){e.bindings.splice(g,1)}delete f.dispatcher}delete f.isOnce;delete f.listener;delete f.context},toString:function(){var e=this;return"[Dispatcher.Binding isOnce: "+e.isOnce+", active: "+e.active+"]"}});return d.namespace("Dispatcher",a,d)});