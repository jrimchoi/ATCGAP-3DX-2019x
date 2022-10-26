define("DS/Core/ModelEvents",["DS/CoreEvents/ModelEvents"],function(a){console.log("Please, now use DS/CoreEvents/ModelEvents instead of DS/Core/ModelEvents");return a});define("DS/Core/PointerEvents",["UWA/Core","UWA/Event","UWA/Class/Events","UWA/Class","UWA/Utils/Client"],function(i,c,n,w,x){var e=false;var f;var t="DS";var l=t+"pointerup";var g=t+"pointermove";var E=t+"pointerdown";var h=t+"pointerleave";var F=t+"pointerhit";var D=t+"pointerout";var u=t+"pointerenter";var m=t+"hold";var d=t+"longhold";var q=300;var k=1000;var A=5;var y={capture:false};var p={touchstart:{value:null,options:{passive:false,capture:false}},mousedown:{value:null,options:y},pointerdown:{value:null,options:y},touchend:{value:null,options:y},pointerup:{value:null,options:y},mouseup:{value:null,options:y},click:{value:null,options:y},touchmove:{value:null,options:{passive:false,capture:false}},mousemove:{value:null,options:y},pointermove:{value:null,options:y},mouseleave:{value:null,options:y},mouseout:{value:null,options:y},mouseenter:{value:null,options:y},};var z={mousedown:E,mouseup:l,click:F,mousemove:g,mouseleave:h,mouseout:D,mouseenter:u};var v={touchstart:E,touchend:l,click:F,touchmove:g};var o={pointerdown:E,pointerup:l,click:F,pointermove:g,pointerout:D,pointerenter:u,pointerleave:h};var b={mousedown:E,mouseup:l,click:F,mousemove:g,mouseleave:h,mouseout:D,mouseenter:u};var s={mousedown:E,mouseup:l,click:F,mousemove:g,mouseleave:h,mouseout:D,mouseenter:u};var a={mousedown:E,mousemove:g,click:F,mouseup:l,mouseleave:h,mouseout:D,mouseenter:u};var C=true;var B=null;var r=function(H,G){var I=document.createEvent("MouseEvents");if(G.type.substr(0,5)=="touch"&&G.changedTouches&&G.changedTouches.length){I.initMouseEvent(H,G.bubbles,G.cancelable,G.view,G.detail,G.changedTouches[0].screenX,G.changedTouches[0].screenY,G.changedTouches[0].clientX,G.changedTouches[0].clientY,G.ctrlKey,G.altKey,G.shiftKey,G.metaKey,G.button,G.relatedTarget);I.changedTouches=G.changedTouches;I.touches=G.touches}else{I.initMouseEvent(H,G.bubbles,G.cancelable,G.view,G.detail,G.screenX,G.screenY,G.clientX,G.clientY,G.ctrlKey,G.altKey,G.shiftKey,G.metaKey,G.button,G.relatedTarget)}I.originalEvent=G;I.oldPreventDefault=I.preventDefault;I.oldStopPropagation=I.stopPropagation;I.oldStopImmediatePropagation=I.stopImmediatePropagation;G.target.dispatchEvent(I)};var j=w.singleton({POINTERUP:l,POINTERMOVE:g,POINTERDOWN:E,POINTERLEAVE:h,POINTERENTER:u,POINTEROUT:D,HOLD:m,LONGHOLD:d,POINTERHIT:F,init:function(G){this._parent(false);this._lastPointers=[];this._lastX=-1;this._lastY=-1;this.timerhold,this.timerlonghold;this.hasHoldTime=false;this.hasLongHoldTime=false;this.lockTimer;this.clickTimer=null;this._multipleHitCount=0},disable:function(){C=false},isLastEventTouch:function(G){if(G!==undefined){this.isTouch=G}else{return this.isTouch}},isTouchEvent:function(I){var H=false;function G(){if(window.navigator&&window.navigator.platform){if(window.navigator.platform.indexOf("Linux armv")>-1||window.navigator.platform.indexOf("Android")>-1){return true}return false}return false}var J=I.mozInputSource;if(I.touchFlag){H=true}else{if(J!=null&&J===5){H=true}else{if(I.changedTouches){H=true}else{if(G()){H=true}else{if(I.pointerType==="touch"){H=true}else{if(I.sourceCapabilities&&I.sourceCapabilities.firesTouchEvents){H=true}else{if(window.navigator.userAgent&&window.navigator.platform.match(/iPhone|iPod|iPad/)){H=true}else{if(I.type==="touchstart"||I.type==="touchend"||I.type==="touchmove"){H=true}}}}}}}}I.touchFlag=H;return H},_initTimer:function(){if(this.timerhold&&this.timerlonghold){clearTimeout(this.timerhold);clearTimeout(this.timerlonghold);this.timerhold=0;this.timerlonghold=0;this.hasHoldTime=false;this.hasLongHoldTime=false;this.lockTimer=false}},enable:function(){var J=this;var H={timeStamp:0,target:null,type:null};var M=undefined,L=undefined,K=false;function G(O){if(C){var P=j.isTouchEvent(O);var V=x.Engine;var W;if(V.ie||window.navigator.userAgent.indexOf("Edge")>=0){if(P){W=o[O.type]}else{W=b[O.type]}}else{if(V.safari||V.safari7){if(P){W=v[O.type]}else{W=z[O.type]}}else{if(V.chrome||V.webkit){if(P){W=v[O.type]}else{W=z[O.type]}}else{if(V.firefox){if(P){W=v[O.type]}else{W=s[O.type]}}}}}if(W){var T=(typeof O.which!=="undefined")?O.which:O.button;if(T===3){return}var R=document.createEvent("MouseEvents");R.initEvent(W,true,true);if(O.type.substr(0,5)=="touch"&&O.changedTouches&&O.changedTouches.length){R.initMouseEvent(W,O.bubbles,O.cancelable,O.view,O.detail,O.changedTouches[0].screenX,O.changedTouches[0].screenY,O.changedTouches[0].clientX,O.changedTouches[0].clientY,O.ctrlKey,O.altKey,O.shiftKey,O.metaKey,O.button,O.relatedTarget);R.changedTouches=O.changedTouches;R.touches=O.touches}else{R.initMouseEvent(W,O.bubbles,O.cancelable,O.view,O.detail,O.screenX,O.screenY,O.clientX,O.clientY,O.ctrlKey,O.altKey,O.shiftKey,O.metaKey,O.button,O.relatedTarget)}if(O){var U={timeStamp:O.timeStamp,target:O.target,type:O.type};if(O.type!=="click"&&H&&U.timeStamp===H.timeStamp&&U.target===H.target||U.timeStamp==0){return}}R.originalEvent=O;R.oldPreventDefault=R.preventDefault;R.oldStopPropagation=R.stopPropagation;R.oldStopImmediatePropagation=R.stopImmediatePropagation;R.preventDefault=function(X){R.oldPreventDefault();O.preventDefault()};R.stopPropagation=function(X){R.oldStopPropagation();O.stopPropagation()};R.stopImmediatePropagation=function(X){R.oldStopImmediatePropagation();O.stopImmediatePropagation()};var N=J._lastPointers[0];var S=N&&N.changedTouches?N.changedTouches[0].screenX:N?N.screenX:-1;var Q=N&&N.changedTouches?N.changedTouches[0].screenY:N?N.screenY:-1;if(true&&N&&N.type==R.type&&S===R.screenX&&Q===R.screenY&&R.screenX===J._lastX&&R.screenY===J._lastY){if(e){console.warn("stop event",O.type)}}else{J._lastX=R.screenX;J._lastY=R.screenY;if(O.type==="touchstart"||O.type==="touchend"||O.type==="touchmove"){H={timeStamp:O.timeStamp,target:O.target,type:O.type}}if(R.type==="DSpointerdown"){M=R.screenX;L=R.screenY;K=true;J._initTimer();if(J.lockTimer){return}J.timerhold=setTimeout(function(X){r("DShold",O)},q);J.timerlonghold=setTimeout(function(X){r("DSlonghold",O)},k);J.lockTimer=true;J._downExist=true}if(R.type==="DSpointerhit"){if(!J._targetOnClick){J._targetOnClick=O.target}if(J._targetOnClick===O.target){J._multipleHitCount++}J._targetOnClick=O.target;R.multipleHitCount=J._multipleHitCount;if(J.clickTimer===null){J.clickTimer=setTimeout(function(){J.clickTimer=null;J._multipleHitCount=0;J._targetOnClick=undefined;clearTimeout(J.clickTimer)},500)}}if(R.type==="DSpointermove"){if(K&&M&&L&&M===R.screenX&&L===R.screenY){K=undefined;return}else{if(Math.sqrt(Math.pow(R.screenX-M,2)+Math.pow(R.screenY-L,2))>A){J._initTimer()}}}if(R.originalEvent.type==="mouseup"&&H.type==="touchend"&&J._downExist===undefined){B=R;return}else{j.isLastEventTouch(P);R.touchFlag=P;O.target.dispatchEvent(R)}if(R.type==="DSpointerup"){J._initTimer();J._downExist=undefined}B=R;if(e){clearTimeout(f);console.warn(O.type,"-->",R.type,R.timeStamp);f=setTimeout(function(){},5000)}J._lastPointers[0]=R}}}}for(var I in p){if(x.Engine.ie){document.addEventListener(I,G,p[I].options.capture)}else{document.addEventListener(I,G,p[I].options)}}}});return j});define("DS/Core/ActionsStack",["UWA/Core","UWA/Class","DS/Utilities/Data"],function(d,c,b){var a=c.extend({init:function(){this._stack=[];this._index=-1;this._isRunning=false;this._lastRecordTimeStamp=new Date()},_execute:function(g,e,f){if(!g||typeof g[e]!=="function"){return this}this._isRunning=true;if(f){g[e](f)}else{g[e]()}this._isRunning=false;return this},pushAction:function(e,f){this.registerAction(e);if(f){f()}},registerAction:function(f){d.extend({undoObj:null,undoFunc:null,undoParamsList:[],undoTitle:"Undo",actionObj:null,actionFunc:null,actionParamsList:[],actionTitle:"run",redoObj:null,redoFunc:null,redoParamsList:[],redoTitle:"Redo"},f);var e=new Date();var g=e-this._lastRecordTimeStamp;this._lastRecordTimeStamp=e;this._add({undoTitle:f.undoTitle,actionTitle:f.actionTitle,redoTitle:f.redoTitle,deltaTime:g,actionParamsList:f.actionParamsList,undo:function(){f.undoFunc.apply(f.undoObj,f.undoParamsList)},redo:function(){f.redoFunc.apply(f.redoObj,f.redoParamsList)},run:function(h){if(h){f.actionFunc.apply(f.actionObj,h)}else{f.actionFunc.apply(f.actionObj,f.actionParamsList)}}})},_add:function(e){if(this._isRunning){return this}this._stack.splice(this._index+1,this._stack.length-this._index);this._stack.push(e);this._index=this._stack.length-1;if(this.callback){this.callback()}return this},setCallback:function(e){this.callback=e},getUndoTitle:function(){return this._stack[this._index]&&this._stack[this._index].undoTitle?this._stack[this._index].undoTitle:"Undo"},getRedoTitle:function(){return this._stack[this._index+1]&&this._stack[this._index+1].redoTitle?this._stack[this._index+1].redoTitle:"Redo"},undo:function(){var e=this._stack[this._index];if(!e){return this}this._execute(e,"undo");this._index-=1;if(this.callback){this.callback()}return this},redo:function(){var e=this._stack[this._index+1];if(!e){return this}this._execute(e,"redo");this._index+=1;if(this.callback){this.callback()}return this},play:function(e){var f=this;var g=function(h){var j=f._stack[h];if(j){if(e){setTimeout(function(){f._execute(j,"run");h++;g(h)},h===0?0:j.deltaTime)}else{f._execute(j,"run");h++;g(h)}}};g(0)},process:function(e){var f=this;e=d.extend({actionParamsList:null,chunckProcess:true},e);if(e.chunckProcess){b.forEach(f._stack,function(h){f._execute(h,"run",e.actionParamsList)},10)}else{var g=function(h){var j=f._stack[h];if(j){f._execute(j,"run",e.actionParamsList);h++;g(h)}};g(0)}},clear:function(){var e=this._stack.length;this._stack=[];this._index=-1;if(this.callback&&(e>0)){this.callback()}},hasUndoAction:function(){return this._index!==-1},hasRedoAction:function(){return this._index<(this._stack.length-1)},getActions:function(){return this._stack}});return a});define("DS/Core/BaseComponent",["UWA/Controls/Abstract","DS/Utilities/Utils"],function(a,d){var c=false;var e=false;var b=a.extend({init:function(f){if(e){console.time("component creation")}this._properties=this._properties||{};this._parent();for(var g in this.publishedProperties){this._properties[g]={value:(Array.isArray(this.publishedProperties[g].defaultValue))?this.publishedProperties[g].defaultValue.slice():this.publishedProperties[g].defaultValue,dirty:true}}if(this._preBuild){this._preBuild(f)}if(this._build){this._build()}this.setProperties(f,true);if(this._postBuild){this._postBuild()}if(e){console.timeEnd("component creation")}},isDirty:function(f){if(!this._properties){return false}else{if(!this._properties[f]){return false}}return this._properties[f].dirty},setProperties:function(h){var f={};var i=(arguments.length>1)?arguments[1]:false;var g=i;for(var j in h){if(this._properties[j]){if(!this.publishedProperties[j].readOnly||i){if(this._properties[j].value!==h[j]){f[j]=this._properties[j].value;this._properties[j].value=h[j];this._properties[j].dirty=true;g=true}}else{if(c){console.log(j+" is a readOnly published property")}}}else{if(c){console.log(j+" is not a published property")}}}if(g){this._applyProperties(f);for(var j in this._properties){this._properties[j].dirty=false}}},_forceApplyProperties:function(h){var f={};for(var g=0;g<h.length;g++){if(this._properties[h[g]]){this._properties[h[g]].dirty=true;f[h[g]]=this._properties[h[g]].value}else{console.log(i+" is not a published property")}}this._applyProperties(f);for(var i in this._properties){this._properties[i].dirty=false}},_propertyChanged:function(f,g,h){if(c){console.log("property changed",f,g,"-->",h)}}});b.inherit=d.inherit;return b});define("DS/Core/Events",["DS/CoreEvents/Events"],function(a){console.log("Please, now use DS/CoreEvents/Events instead of DS/Core/Events");return a});var WUXDockAreaEnum={NoneDockArea:0,TopDockArea:1<<0,BottomDockArea:1<<1,LeftDockArea:1<<2,RightDockArea:1<<3};Object.freeze(WUXDockAreaEnum);var WUXManagedFontIcons={FontAwesome:0,Font3DS:1};Object.freeze(WUXManagedFontIcons);define("DS/Core/Core",["css!DS/Core/wux.css","css!DS/Core/wux-3ds-fonticons.css","DS/WebappsUtils/WebappsUtils","UWA/Core","UWA/Event","UWA/Class","DS/Core/PointerEvents","UWA/Controls/Abstract","DS/UIBehaviors/TooltipManager","UWA/Class/Promise","DS/Utilities/TouchUtils"],function(y,l,h,i,B,v,k,u,e,g,c){var n;var x=5.5;var d=200;var m=false;var t="1.1.4";function A(D,C){if(!C){C=window.location.href}D=D.replace(/[\[\]]/g,"\\$&");var F=new RegExp("[?&]"+D+"(=([^&#]*)|&|#|$)"),E=F.exec(C);if(!E){return null}if(!E[2]){return""}return decodeURIComponent(E[2].replace(/\+/g," "))}function b(C,F){if(F===undefined){F=0}var E="";for(var G in C){var D=C[G]&&C[G].toString?C[G].toString():C[G];E=E+"\r"+G+": "+D+","}F++;E="{"+E+"\r }";return E}var f=u.singleton({defaultOptions:{},init:function(C){this._parent(C);this._buildView()},_buildView:function(){var C=this;this.elements.container=new i.Element("div",{styles:{position:"absolute",top:0,width:0,right:0,bottom:0,borderLeft:"1px solid silver",background:"white",fontFamily:"consolas",overflow:"hidden",zIndex:100000,boxShadow:"0px 1px 5px #CCC"}});this.elements.titleContainer=new i.Element("div",{html:"Console",styles:{width:"100%",background:"#358EC4",color:"white",padding:5,position:"relative"}}).inject(this.elements.container);this.elements.emptyConsole=new i.Element("div",{styles:{background:"url("+h.getWebappsBaseUrl()+"Core/assets/icons/trash.png)",backgroundSize:"contain",backgroundRepeat:"no-repeat",width:20,height:16,position:"absolute",top:3,right:10}}).inject(this.elements.titleContainer);this.elements.emptyConsole.addEvent(k.POINTERUP,function(){C.elements.console.empty()});this.elements.console=new i.Element("div",{styles:{padding:5}}).inject(this.elements.container)},_pushMessage:function(I,E){var D="black";var M="white";var G="silver";switch(E){case"log":D="#999";M="white";G="#EBEAE9";break;case"warn":D="#F07E00";M="#FEF5D3";G=D;break;case"info":D="#1DBCDE";M="#E9FDFE";G=D;break}var H=new Date();var J=H.getHours();var F=H.getMinutes();var K=H.getSeconds();var L=new i.Element("div",{html:I,styles:{textAlign:"left",padding:"2px 5px",marginBottom:10,color:D,borderRadius:2,border:"1px solid "+G,background:M}}).inject(this.elements.console,"top");var C=new i.Element("div",{html:J+":"+F+":"+K,styles:{fontSize:9,padding:"2px 5px",marginBottom:0,color:"silver",textAlign:"right"}}).inject(L,"top")},_prettyPrint:function(D){D=Array.prototype.slice.call(D);var C="";D.forEach(function(E){if(i.typeOf(E)==="[object Object]"||i.typeOf(E)==="object"){var F=b(E);C=C+" "+F}else{C=C+" "+E}});return C},addButton:function(C){var D=new i.Element("div",{html:C.label,events:C.events,"class":"wux-controls-button"}).inject(this.elements.console,"bottom")},log:function(){this._pushMessage(this._prettyPrint(arguments),"log")},warn:function(C){this._pushMessage(this._prettyPrint(arguments),"warn")},info:function(C){this._pushMessage(this._prettyPrint(arguments),"info")}});var p=function(){var C=document.getElementsByTagName("SCRIPT");var E="";if(C&&C.length>0){for(var D in C){if(C[D].src&&C[D].src.match(/WUX\/Core\.js$/)){E=C[D].src.replace(/(.*)WUX\/Core\.js$/,"$1")}}}return E};var a=v.singleton({options:{debug:{enabled:false,fullscreen:false,logLevel:false}},init:function(){this._parent();w()},getVersion:function(){return x},isDebug:function(){return this.options.debug.enabled},enableWUXConsole:function(){m=true;f.getContent().setStyles({width:d});document.body.appendChild(f.getContent())},disableWUXConsole:function(){m=false},isWUXConsoleEnabled:function(){return m},getWUXConsole:function(){return f},setFullscreen:function(){s(h.getWebappsBaseUrl()+"Controls/nv-patch.css");console.warn("==========================================================================");console.warn("WUX.setFullscreen() is for debug purpose only! DO NOT use in production...");console.warn("==========================================================================");if(this.options){this.options.debug.fullscreen=true}var C=i.extend(document.querySelector(".module"));if(C){C.setStyles({position:"absolute",top:0,width:"auto",left:0,right:m?d:0,bottom:0})}},enableFullscreen:function(){this.setFullscreen()},disableFullscreen:function(){o(h.getWebappsBaseUrl()+"Controls/nv-patch.css");var C=i.extend(document.querySelector(".module"));if(C){C.setStyles({position:"",top:"",width:"",left:"",right:"",bottom:""})}},isFullscreen:function(){if(this.options){return this.options.debug.fullscreen}},setLogLevel:function(C){if(this.options){this.options.debug.logLevel=C}},info:function(C){},log:function(C,D){if(D===undefined){D=0}if(this.options){if(this.options.debug.logLevel&&D<=this.options.debug.logLevel){console.log("["+this.options.debug.logLevel+"] : %o",C)}}},warn:function(C,D){if(D===undefined){D=0}if(this.options){if(this.options.debug.logLevel&&D<=this.options.debug.logLevel){console.warn("["+this.options.debug.logLevel+"] : %o",C)}}},warnDev:function(C,D){console.warn("["+C+"] - "+D)},getLocalization:function(){if(window.widget){return window.widget.lang}else{if(navigator){if(navigator.language){return navigator.language}else{if(navigator.languages){return navigator.languages[0]}else{return"en"}}}else{return"en"}}},onlanguagechange:function(C){j.addEvent("onlanguagechange",C)},offlanguagechange:function(C){j.removeEvent("onlanguagechange",C)},POLYMER_ENABLED:Boolean(A("WUX_POLYMER_ENABLED"))});var j=new i.Class.Events();function s(C){n=document.createElement("link");n.type="text/css";n.rel="stylesheet";n.href=C;document.getElementsByTagName("head")[0].appendChild(n)}function r(C){n=document.createElement("link");n.rel="import";n.href=C;document.getElementsByTagName("head")[0].appendChild(n)}function z(C){n=document.createElement("script");n.type="text/JavaScript";n.src=C;document.getElementsByTagName("head")[0].appendChild(n)}function o(D){var E=i.extendElement(document);var C=document.querySelector('link [href="'+D+'"]');i.extendElement(n).destroy()}function w(){var C=a.getLocalization();Object.defineProperty(window.WUX,"currentLanguage",{get:function(){return C},set:function(D){C=D;j.dispatchEvent("onlanguagechange")}})}a.PointerEvents=k;k.enable();a.TooltipManager=e;e.enable();c.init();if(a.POLYMER_ENABLED){z("../Polymer-"+t+"/webcomponents-lite.js");r("../Polymer-"+t+"/polymer.html");window.Polymer=window.Polymer||{};window.Polymer.dom="shadow"}function q(C){return new g(function(E,D){require(C,function(F){E(F)},function(F){D(F)})})}a.startUnsafeHTMLDisplay=function(){var C=[];C.push(q(["DS/Developer/UnsafeHTMLDisplay"]));g.all(C).then(function(D){D[0].startUnsafeHTMLDisplay()})["catch"](function(D){console.error("There were an error on startUnsafeHTMLDisplay call")})};a.stopUnsafeHTMLDisplay=function(){var C=[];C.push(q(["DS/Developer/UnsafeHTMLDisplay"]));g.all(C).then(function(D){D[0].stopUnsafeHTMLDisplay()})["catch"](function(D){console.error("There were an error on stopUnsafeHTMLDisplay call")})};return i.namespace("WUX",a,window,true)});