define("DS/RTwebrtcAPI/js/RTEmbeddedStartCallUserView",["UWA/Class","UWA/Class/View","DS/RTPresenceAPI/RTPresenceAPI","DS/UIKIT/Tooltip","css!RTwebrtcAPI/RTwebrtcAPI.css"],function(a,c,d,b){return c.extend({tagName:"div",className:"RTEmbeddedStartCallUserView",setup:function(e){this.listenTo(this.model,"onChange:username",this.changeUsername)},render:function(){this.container.setContent([{"class":"RTEmbeddedStartCallUserView_presence",tag:"div",id:"RTEmbeddedStartCallUserView_presence_"+this.model.cid},{"class":"RTEmbeddedStartCallUserView_username",tag:"div",id:"RTEmbeddedStartCallUserView_username_"+this.model.cid,text:this.model.get("username")}]);this.statusIcon=new d({username:this.model.get("username"),userId:this.model.get("login"),tenant:this.model.get("tenant"),clickable:false,button:false,content:this.container.children["RTEmbeddedStartCallUserView_presence_"+this.model.cid],callbacks:{onPresenceChanged:this.presenceListenerFactory(this)}});this.statusIcon.getStatus()},changeUsername:function(f,e){this.container.children["RTEmbeddedStartCallUserView_username_"+f.cid].innerText=f.get("username")},presenceListenerFactory:function(e){return function(f,g){e.model.set({presence:f})}}})});define("DS/RTwebrtcAPI/js/RTEmbeddedStartCallComponentModel",["UWA/Class","UWA/Class/Model","i18n!DS/RTwebrtcAPI/assets/nls/feed"],function(a,c,b){return c.extend({urlRoot:"/startCall",defaults:{state:"disconnected",orderId:"Print Order",login:"unknown",presence:"Online"},setConnected:function(){this.set({state:"connected"})},setDisconnected:function(){this.set({state:"disconnected"})},setOncall:function(){this.set({state:"oncall"})}})});define("DS/RTwebrtcAPI/js/RTEmbeddedStartCallUserModel",["UWA/Class","UWA/Class/Model","i18n!DS/RTwebrtcAPI/assets/nls/feed"],function(a,c,b){return c.extend({defaults:{username:"Louis Aragon",presence:"Offline",login:"pne1",tenant:"dsdev"},setup:function(d){if(d&&!d.username){if(d.displayname){this.set({username:d.displayname})}else{this.set({username:d.login+" "+d.login})}}}})});define("DS/RTwebrtcAPI/js/RTEmbeddedStartCallComponentView",["UWA/Class","UWA/Class/View","DS/UIKIT/Input/Button","DS/UIKIT/DropdownMenu","i18n!DS/RTwebrtcAPI/assets/nls/feed","DS/RTwebrtcAPI/js/RTEmbeddedStartCallUserView","DS/RTwebrtcAPI/js/RTEmbeddedStartCallUserModel","css!RTwebrtcAPI/RTwebrtcAPI.css"],function(d,g,b,c,f,a,e){return g.extend({findDropdownItemByLogin:function(h){if(!this.contactList){return false}if(this.contactList.items.find){return this.contactList.items.find(function(i){return i.name===h})}for(var j=0;j<this.contactList.items.length;j++){if(this.contactList.items[j].name===h){return this.contactList.items[j]}}},addMessageToList:function(h){this.contactList.addItem({className:"notOnline",text:h})},addContactToList:function(h){if(!h instanceof e){return UWA.log("RTWebRTCAPI RTEmbeddedStartCallComponentView addContact bad format","error")}var j=new a({model:h});j.render();if(this.contactList){this.contactList.addItem({className:h.get("presence")=="Online"?"":"notOnline",name:j.model.get("login"),text:j.model.get("username")});var i=this.contactList.items[this.contactList.items.length-1];i.elements.content.setContent(j.getContent());this.updateSelectability(h,h.get("presence"))}else{return true}},removeContactFromList:function(h){if(!h instanceof e||!h.login){return UWA.log("RTWebRTCAPI RTEmbeddedStartCallComponentView removeContact bad format","error")}if(!this.contactList){return true}var i=this.findDropdownItemByLogin(h.login);if(!i){return UWA.log("removeContact contact "+h.login+" not found","error")}return this.contactList.removeItem(i.id)},updateSelectability:function(i,j){var h=this.findDropdownItemByLogin(i.get("login"));if(!h){return false}h.presence=j;if(j=="Online"){h.elements.container.removeClassName("notOnline")}else{h.elements.container.addClassName("notOnline")}if(this.contactList.getBody().getElementsByClassName("notOnline").length==this.contactList.items.length){this.setActive(true)}else{this.setActive()}},setActive:function(h){if(h){this.container.children["RTEmbeddedStartCallComponentView_"+this.model.cid].children["RTEmbeddedStartCallComponentViewPhone_"+this.model.cid].classList.remove("RTEmbeddedwebrtc_icon_active")}else{this.container.children["RTEmbeddedStartCallComponentView_"+this.model.cid].children["RTEmbeddedStartCallComponentViewPhone_"+this.model.cid].classList.add("RTEmbeddedwebrtc_icon_active")}},phoneIconListener:function(h){var i=function(l,k){if(h&&k.contactList.isVisible){return k.container.children["RTEmbeddedStartCallComponentView_"+k.model.cid].click()}if(!k.contactList.isVisible){k.container.children["RTEmbeddedStartCallComponentView_"+k.model.cid].click()}var m=k.container.children["RTEmbeddedStartCallComponentView_"+k.model.cid].getDimensions();var n=k.container.children["RTEmbeddedStartCallComponentView_"+k.model.cid].getClientRects()[0].top-2;var j=k.container.children["RTEmbeddedStartCallComponentView_"+k.model.cid].getClientRects()[0].left+50;if(document.body.clientWidth<j+k.contactList.getContent().getDimensions().width){j=document.body.clientWidth-k.contactList.getContent().getDimensions().width;n+=40}k.contactList.getContent().setPosition({x:j,y:n})};return(function(j){return function(k){return i(k,j)}})(this)},render:function(h){this.container.setContent([{tagname:"div",id:"RTEmbeddedStartCallComponentView_"+this.model.cid,"class":"RTEmbeddedStartCallComponentView",html:[{id:"RTEmbeddedStartCallComponentViewPhone_"+this.model.cid,tag:"span","class":"RTEmbeddedwebrtc_icon fonticon handler",html:'<svg xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:cc="http://creativecommons.org/ns#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:svg="http://www.w3.org/2000/svg" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"  x="0px" y="0px" viewBox="0 0 20 20" enable-background="new 0 0 20 20" xml:space="preserve"><path xmlns="http://www.w3.org/2000/svg" d="m 8.768474,11.230366 c -1.582,-1.5830005 -3.096,-3.4170005 -2.371,-4.1420005 1.037,-1.037 1.941,-1.677 0.102,-3.965 -1.838,-2.28699995 -3.064,-0.53 -4.068,0.475 -1.16,1.16 -0.062,5.484 4.211,9.7580005 4.274001,4.273 8.598001,5.368 9.758001,4.207 1.006,-1.005 2.762,-2.225 0.475,-4.063 -2.287,-1.839 -2.927,-0.936 -3.965,0.103 -0.725,0.722 -2.559,-0.791 -4.142001,-2.373 z" id="path4571"/><path xmlns="http://www.w3.org/2000/svg" d="m 8.768474,11.230366 c -1.582,-1.5830005 -3.096,-3.4170005 -2.371,-4.1420005 1.037,-1.037 1.941,-1.677 0.102,-3.965 -1.838,-2.28699995 -3.064,-0.53 -4.068,0.475 -1.16,1.16 -0.062,5.484 4.211,9.7580005 4.274001,4.273 8.598001,5.368 9.758001,4.207 1.006,-1.005 2.762,-2.225 0.475,-4.063 -2.287,-1.839 -2.927,-0.936 -3.965,0.103 -0.725,0.722 -2.559,-0.791 -4.142001,-2.373 z" id="path4571"/></svg>',events:{click:this.phoneIconListener(),mouseenter:this.phoneIconListener()}}]}]);this.contactList=new c({target:this.container.children["RTEmbeddedStartCallComponentView_"+this.model.cid],className:"RTEmbeddedStartCallComponentViewDropDown",multiSelect:false,position:"bottom right",closeOnClick:true,handler:function(){console.log("lol")},items:[],events:{onClick:(function(i){return function(k,j){i.dispatchEvent("contactClicked",{login:j.name,presence:j.presence,username:j.text})}})(this)}});if(h){this.addMessageToList(f.notCompatible)}},onSelfPresence:function(h,i){},setup:function(){this.listenTo(this.model,"onChange:presence",this.onSelfPresence)}})});define("DS/RTwebrtcAPI/js/RTEmbeddedStartCallComponentController",["UWA/Class","UWA/Class/Collection","UWA/Class/Events","DS/RTwebrtcAPI/js/RTEmbeddedStartCallUserModel","DS/RTwebrtcAPI/js/RTEmbeddedStartCallComponentView","DS/RTwebrtcAPI/js/RTEmbeddedStartCallComponentModel"],function(b,e,a,d,c,f){return a.extend({init:function(g){this.startCall=g.startCall||UWA.log;this.model=new f(g);this.view=new c({model:this.model});this.notCompatible=false;this.contacts=new e([],{url:"/RTEmbeddedStartCallContacts",model:d});if(navigator.userAgent.indexOf("MSIE")!==-1||navigator.appVersion.indexOf("Trident/")>0||navigator.platform.indexOf("iPhone")!=-1||navigator.platform.indexOf("iPod")!=-1||navigator.platform.indexOf("iPad")!=-1){this.notCompatible=true;return true}this.contacts.addEvents({onAdd:this.view.addContactToList,onRemove:this.view.removeContactFromList,"onChange:presence":this.view.updateSelectability},this.view);this.view.addEvent("contactClicked",function(h){h.orderId=this.model.get("orderId");UWA.log("RTwebrtcAPI launch call to "+h.login+" (presence = "+h.presence+") for order "+h.orderId);if(h.presence!="Online"){UWA.log("RTwebrtcAPI won't launch a call to a user who is not Online")}else{if(this.model.get("presence")!="Online"){UWA.log("RTwebrtcAPI won't launch a call from a user who is not Online")}else{this.startCall(h)}}},this)},updateSelf:function(g){if(g.presence){this.model.set({presence:g.presence})}if(g.login){this.model.set({login:g.login})}},findContactByLogin:function(g){return this.contacts.findWhere({login:g})},addContact:function(g){if(!g.login){return UWA.log("RTWebRTCAPI addContact login is missing.","error")}if(this.findContactByLogin(g.login)){return UWA.log("RTWebRTCAPI tried to add a contact who already exists.")}this.contacts.add(new d(g))},removeContact:function(h){if(!h){return UWA.log("RTWebRTCAPI removeContact login is missing.","error")}var g=this.findContactByLogin(h);if(!g){return UWA.log("RTWebRTCAPI tried to remove a contact who already unexists.")}g.login=h;this.contacts.remove(g)},renderTo:function(g){this.view.render(this.notCompatible);this.view.inject(g||document.body);if(!this.notCompatible){this.contacts.forEach(function(h){this.view.addContactToList(h)},this)}}})});define("DS/RTwebrtcAPI/RTwebrtcAPI",["UWA/Class","UWA/Class/Events","DS/PlatformAPI/PlatformAPI","DS/RTwebrtcAPI/js/RTEmbeddedStartCallComponentController"],function(c,a,b,e){var d=c.extend(a,{init:function(f){if(!f){var f={}}f.startCall=function(h){h.action="startCall";h.type=h.type||"audio";b.publish("im.ds.com",h)};this.component=new e(f);this.platformListenner=(function(h){return function(i){switch(i.action){case"setStatus":if(i&&i.login&&i.presence&&i.login==h.login){h.component.updateSelf({presence:i.presence})}else{return null}break;case"youare":if(!i.login||!i.userId){return UWA.log("RTwebrtcAPI received event 'youare' without login|userId","error")}h.login=i.login;h.userId=i.userId;h.component.updateSelf({login:i.login});b.publish("im.ds.com",{action:"getStatus",login:i.login});b.subscribe(i.userId,function(j){switch(j.action){case"setStatus":if(j&&j.login&&j.presence&&j.login==h.login){h.component.updateSelf({presence:j.presence})}else{}}});break}}})(this);b.publish("im.ds.com",{action:"whoami"});b.subscribe("im.ds.com",this.platformListenner);if(f&&f.users){for(var g in f.users){this.component.addContact(f.users[g])}}},renderTo:function(f){this.component.renderTo(f)},addContact:function(f){this.component.addContact(f)},removeContact:function(f){this.component.removeContact(f.login||f)}});return d});