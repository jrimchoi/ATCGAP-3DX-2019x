define("UWA/Utils/InterCom",["UWA/Core","UWA/Utils","UWA/Class","UWA/Dispatcher","UWA/Class/Events","UWA/Class/Options","UWA/Class/Timed","UWA/Class/Debug","UWA/Json"],function(e,h,b,l,n,j,g,k,d){function a(q,s){var u,t,r,p;for(u=0,t=q.length;u<t;u++){for(r=0,p=s.length;r<p;r++){if(s[r]===q[u]){return true}}}return false}function o(p){var q=Boolean(p.UWA&&p.UWA.Utils&&p.UWA.Utils.InterCom);if(q&&!p.UWA.Utils.InterCom._listener){p.UWA.Utils.InterCom._listener=new n()}return p.UWA.Utils.InterCom._listener}var m,i="subscribe",f="unSubscribe",c=e.getGlobal();m={getAdapter:function(u){var r,q,p,s=m.Adapters,t=u?h.splat(u):Object.keys(s);for(r=0,q=t.length;r<q&&!p;r++){u=t[r];if(s.hasOwnProperty(u)){if(s[u].isAvailable(p)){p=s[u];break}}else{throw new Error('Unable to get InterCom Adapter with name "'+u+'"')}}if(!p){throw new Error("Unable to get InterCom Adapter")}return p}};m.Adapters={PostMessage:(function(){var p="uwa-intercom";var r;function q(t){var s;try{s=(typeof t.data==="string")&&t.data[0]==="{"&&JSON.parse(t.data)}catch(u){}if(s&&s.type===p){r.dispatch([s.payload,{origin:t.origin,source:t.source}])}}return{isAvailable:function(){return c.postMessage&&c.location&&c.location.protocol&&c.location.protocol.contains("http")},removeListener:function(s){if(r){r.remove(s);if(r.getNumListeners()===0){r.dispose();r=undefined;if(c.addEventListener){c.removeEventListener("message",q,false)}else{if(c.attachEvent){c.detachEvent("onmessage",q)}}}}},addListener:function(s){if(!r){r=r||new l();if(c.addEventListener){c.addEventListener("message",q,false)}else{if(c.attachEvent){c.attachEvent("onmessage",q)}}}r.add(s)},dispatchEvent:function(w,v,t){var u;if(!v){u=c.parent;v=u.postMessage?u:(u.document.postMessage?u.document:undefined)}t=(t&&t!=="*")?h.buildUrl(c.location,t):"*";if(v&&v.postMessage){var s={type:p,payload:w};v.postMessage(JSON.stringify(s),t)}}}}()),FrameCallback:(function(){var q=0,t,p=[],u=true,v=c.document;function s(){if(u&&v.body&&p.length>0){v.body.appendChild(p.shift())}if(p.length>0){setTimeout(s,10)}}function x(C,E,D){var G,y,A=c.location.toString(),B=h.parseUrl(D),F=B.protocol+"://"+B.domain+"/intercom.html",z={info:C,origin:A};G="#"+Date.now()+(q++)+"&"+d.encode(z);y=v.createElement("iframe");y.setAttribute("src",F+G);y.style.position="absolute";y.style.top="-2000px";y.style.left="0px";y.onload=function(){u=true;y.parentNode.removeChild(y)};p.push(y);setTimeout(s,10)}function w(z,y){var A=o(y);setTimeout(function(){A.dispatchEvent("message",[z,{origin:c.location.toString(),source:c}])})}function r(y){try{return(y===c||(y.location.host===c.location.host&&y.location.protocol===c.location.protocol))}catch(z){}}return{isAvailable:function(){t=o(c);return Boolean(t)},removeListener:function(y){t.removeEvent("message",y)},addListener:function(y){t.addEvent("message",y)},dispatchEvent:function(A,z,y){if(r(z)){w(A,z,y)}else{x(A,z,y)}}}}())};m.Server=b.extend(j,k,{id:null,uuid:null,sockets:null,listeners:null,defaultOptions:{adapter:null,autoconnect:true},init:function(q,p){var r=this;r.setServerId(q);r.sockets={};r.listeners=new n();r.setOptions(p);if(r.options.autoconnect){r.connect()}},setServerId:function(p){var r=this,q=m.Server.Instances=m.Server.Instances||{};r.uuid=r.uuid||h.getUUID();p=p||r.uuid;if(q[p]){q[p].disconnect();delete q[p]}r.id=p;q[p]=r;return r},connect:function(){var p=this;p.handleEvent=p.handleEvent.bind(p);p.adapter=m.getAdapter(p.options.adapter);p.adapter.addListener(p.handleEvent);return p},disconnect:function(){var p=this;if(p.adapter){Object.keys(p.sockets).forEach(function(q){p.unsubscribeSocket(q)});p.adapter.removeListener(p.handleEvent)}return p},handleEvent:function(r,p){var q,x,s,v=this,u=v.id,w=v.sockets,t=Object.keys(w);q=(p&&p.source&&p.origin&&r.event&&r.target&&r.origin&&r.target.servers&&Array.isArray(r.target.servers)&&r.target.sockets&&Array.isArray(r.target.sockets));x=q&&(w[r.origin.socket]&&w[r.origin.socket].uuid===r.uuid);s=q&&(r.target.sockets.length===0&&r.target.servers.indexOf(u)!==-1);if(q){if(s){v.log('SERVER: server "'+u+'" accept message for event "'+r.event+'"');if(r.event===i){if(!x){v.subscribeSocket(r.origin.socket,p.source,p.origin,r.uuid)}}else{if(x){if(r.event===f){v.unsubscribeSocket(r.origin.socket)}else{v.dispatchEvent(r.event,r.data,r.origin.socket,r.target.sockets)}}}}else{if(x&&a(r.target.sockets,t)&&a([r.origin.socket],t)){v.log('SERVER PREDISPATCH: server "'+u+'" dispatch event "'+r.event+'" from "'+r.origin.socket+'"');v.dispatchEvent(r.event,r.data,r.origin.socket,r.target.sockets)}else{v.log('SERVER: server "'+u+'" refuse message for event "'+r.event+'"')}}}else{v.log('SERVER: server "'+u+'" refuse invalid message for event "'+r.event+'"')}},subscribeSocket:function(s,u,p,r){var t=this,q=t.id;t.log('SERVER: server "'+q+'" register new socket "'+s+'"');t.sockets[s]={source:u,origin:p,uuid:r};t.dispatchEvent(i,{},undefined,s);return t},unsubscribeSocket:function(q){var r=this,p=r.id;if(r.sockets[q]){r.log('SERVER: server "'+p+'" unregister socket "'+q+'"');r.dispatchEvent(f,{},undefined,q);delete r.sockets[q]}return r},addListener:function(p,q){this.listeners.addEvent(p,q);return this},removeListener:function(p,q){this.listeners.removeEvent(p,q);return this},dispatchEvent:function(p,r,x,w){var t=this,s=t.id,u=t.sockets,v=t.adapter,q={event:p,data:r,target:{sockets:w},origin:{socket:x,server:s},uuid:t.uuid};if(!w||!w.length){w=Object.keys(t.sockets);if(w.indexOf(x)!==-1){w.splice(w.indexOf(x),1)}}else{w=h.splat(w)}if(!v){t.connect();v=t.adapter}if(w.length===0){t.log('SERVER: server "'+s+'" has no target socket for dispatchEvent "'+p+'"')}else{w.forEach(function(z){var y=u[z],A={event:p,data:r,target:{sockets:[z]},origin:{socket:x,server:s},uuid:t.uuid};t.log('SERVER: server "'+s+'" dispatchEvent "'+A.event+'" to "'+z+'"');try{v.dispatchEvent(A,y.source,y.origin)}catch(B){if(c.console){c.console.error('InterCom server "'+s+'": error while dispatching to socket '+z+": "+B+"\nDeleting socket")}delete u[z]}})}t.listeners.dispatchEvent(p,[r,q]);return t}});m.Socket=b.extend(j,k,{id:null,uuid:null,servers:null,listeners:null,defaultOptions:{adapter:null,autoconnect:false},init:function(q,p){var r=this;r.setSocketId(q);r.servers={};r.listeners=new n();r.setOptions(p)},setSocketId:function(p){var r=this,q=m.Socket.Instances=m.Socket.Instances||{};r.uuid=r.uuid||h.getUUID();p=p||r.uuid;if(q[p]){q[p].disconnect();delete q[p]}r.id=p;q[p]=this;return r},connect:function(){var p=this;p.handleEvent=p.handleEvent.bind(p);p.adapter=m.getAdapter(p.options.adapter);p.adapter.addListener(p.handleEvent);return p},disconnect:function(){var p=this;if(p.adapter){Object.keys(p.servers).forEach(function(q){p.unsubscribeServer(q)});p.adapter.removeListener(p.handleEvent)}return p},handleEvent:function(r,p){var t,v,q,s,u=this,w=u.id,x=u.servers;q=(p&&p.source&&p.origin&&r&&r.event&&r.target&&r.origin&&r.origin.server&&x[r.origin.server]&&r.target.sockets&&Array.isArray(r.target.sockets));v=q&&(x[r.origin.server]&&x[r.origin.server].uuid===r.uuid);s=q&&(r.target.sockets.length!==0&&r.target.sockets.indexOf(w)!==-1);if(q){if(s){t=u.servers[r.origin.server];u.log('SOCKET: socket "'+w+'" accept message for event "'+r.event+'"');if(r.event===i){if(!v){t.waiting=false;t.uuid=r.uuid;if(t.queue.length){t.queue.forEach(function(y){u.adapter.dispatchEvent(y,t.source,t.origin)});u.log('SOCKET: socket dispatch "'+t.queue.length+'" events in the queue for serverId "'+r.origin.server+'".');t.queue=[]}}u.listeners.dispatchEvent(r.event,[r.data,r])}else{if(v){if(r.event===f){delete u.servers[r.origin.server]}else{u.listeners.dispatchEvent(r.event,[r.data,r])}}else{u.log('SOCKET: socket "'+w+'" refuse invalid uuid for event "'+r.event+'"')}}}else{u.log('SOCKET: socket "'+w+'" refuse message for event "'+r.event+'"')}}else{u.log('SOCKET: socket "'+w+'" refuse invalid message for event "'+r.event+'"')}},subscribeServer:function(q,s,p){var r=this;s=s||c.parent;p=p||c.location.toString();r.servers[q]={waiting:true,queue:[],source:s,origin:p};r.dispatchEvent(i,undefined,undefined,q);return r},unsubscribeServer:function(p){var r=this,q=r.id;if(r.servers[p]){r.log('SOCKET: socket "'+q+'" unregister server "'+p+'"');r.dispatchEvent(f,{},undefined,p);delete r.servers[p]}return r},addListener:function(p,q){this.listeners.addEvent(p,q);return this},removeListener:function(p,q){this.listeners.removeEvent(p,q);return this},dispatchEvent:function(t,u,q,v){var s=this,r=s.id,w=s.servers,p=s.adapter;if(!v||!v.length){v=Object.keys(s.servers)}else{v=h.splat(v)}q=h.splat(q);if(!p){s.connect();p=s.adapter}u=d.prune(u);v.forEach(function(x){var z=w[x],y={event:t,data:u,target:{servers:[x],sockets:q},origin:{socket:r},uuid:s.uuid};if((z.queue.length===0&&!z.waiting)||(t===i||t===f)){s.log('SOCKET: socket "'+r+'" dispatch event "'+t+'"');p.dispatchEvent(y,z.source,z.origin)}else{s.log('SOCKET: socket "'+r+'" queue event "'+t+'" for serverId "'+x+'"');z.queue.push(y)}});return s}});return e.namespace("Utils/InterCom",m,e)});