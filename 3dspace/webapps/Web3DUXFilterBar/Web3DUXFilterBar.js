/*!  Copyright 2017 Dassault Systemes. All rights reserved. */
define("DS/Web3DUXFilterBar/Web3DUXFilterBar",["UWA/Core","UWA/Controls/Abstract","DS/Core/PointerEvents","DS/CoreEvents/Events","DS/Visualization/ThreeJS_DS","css!DS/Web3DUXFilterBar/Web3DUXFilterBar.css"],function(f,e,b,a,c){var d=e.extend({defaultOptions:{body:null,actionBar:null,frmWindow:null,heightElem:"32px",widthElem:"32px",updateVisibilty:true,typeSeparator:"line",lJsonElement:[],classpanel:"",Idpanel:"",position:null},init:function(y){this._parent(y);var k=this,P=this.options||{};var s=null,t=[],g=[],r;var i={},R={};var w=null,N=null,m=null,q=null;var o=P.position,l,D,L,F,M;var Q=false,x=false;var p,J;function S(U,T){var V=f.createElement("div",{html:"",id:U,"class":U});V.style.display="block";if(T){V.inject(T)}return V}function v(U){var T=U.length,V=[],X={};for(var W=0;W<T;W++){X[U[W]]=X[U[W]]>=1?X[U[W]]+1:1}for(var Y in X){if(X[Y]>1){V.push(Y)}}return V}function I(V,U){var T=function(){};if(U.bexclude){T=function(){for(var W=0;W<t.length;W++){if(V!==t[W]){G(t[W]);if((t[W].parentNode)&&(t[W].parentNode.id==="Web3DUXFilterBody")){t[W].style.opacity=1}}}}}return T}function O(V,U){var T=function(){};var W=new RegExp("Web3DUXFilterInactiveState");if(U.bexclude){T=function(){for(var X=0;X<t.length;X++){if(V!==t[X]){if(!W.test(t[X].className)){H(t[X]);if((t[X].parentNode)&&(t[X].parentNode.id==="Web3DUXFilterBody")){t[X].style.opacity=0.5}}}}}}return T}function j(T){T.addClassName("Web3DUXFilterExcludeType")}function E(T){T.addClassName("Web3DUXFilterActiveState")}function H(T){T.addClassName("Web3DUXFilterInactiveState")}function B(T){T.removeClassName("Web3DUXFilterActiveState")}function G(T){T.removeClassName("Web3DUXFilterInactiveState")}function A(ad,T,X,U){var W=f.createElement("div",{"class":"Web3DUXFilterBtn",id:ad.id,title:ad.nls,styles:{top:X,left:U,height:P.heightElem,width:P.widthElem}}).inject(T);var ac=new f.Controls.Img({url:ad.url,width:"25px",height:"25px"}).inject(W);ac.elements.container.setStyles({position:"absolute",display:"block",padding:"4px"});i[ad.id]=ad.callback;t.push(W);var V=new RegExp("Web3DUXFilterActiveState");var aa=new RegExp("Web3DUXFilterInactiveState");var Z=new RegExp("Web3DUXFilterExcludeType");var ab=O(W,ad);var Y=I(W,ad);if(ad.bexclude){j(W)}if(ad.bstateActif){E(W)}W.addEvent(b.POINTERUP,function(af){if(aa.test(this.className)&&!V.test(this.className)&&ad.bexclude){G(this);E(this);for(var ae=0;ae<t.length;ae++){if(W!==t[ae]&&Z.test(t[ae].className)){B(t[ae]);if(i[t[ae].id]){i[t[ae].id].call(k,af)}H(t[ae])}}if(ad.callback){ad.callback.call(k,af)}if(ab){ab.call(k,af)}}else{if((aa.test(this.className)&&!V.test(this.className)&&!ad.bexclude)||(aa.test(this.className)&&V.test(this.className)&&!ad.bexclude)){G(this);if(!V.test(this.className)){E(this);if(ad.callback){ad.callback.call(k,af)}}for(var ae=0;ae<t.length;ae++){t[ae].style.opacity=1;if(W!==t[ae]){if(V.test(t[ae].className)){B(t[ae]);if(i[t[ae].id]){i[t[ae].id].call(k,af)}}if(aa.test(t[ae].className)){G(t[ae])}}}if(ab){ab.call(k,af)}m.style.opacity=1}else{if(!V.test(this.className)){E(this);if(ad.callback){ad.callback.call(k,af)}if(ab){ab.call(k,af)}}else{B(this);if(ad.callback){ad.callback.call(k,af)}if(Y){Y.call(k,af)}}}}});W.addEvent("mouseenter",function(){if(ad.onEnterCB){ad.onEnterCB({button:ad})}});W.addEvent("mouseleave",function(){if(ad.onLeaveCB){ad.onLeaveCB({button:ad})}});return W}function n(){r=[];var U=0;for(var T=0;T<P.lJsonElement.length;T++){if(P.lJsonElement[T].type==="separator"){U++}}p=U+1;w=f.createElement("div",{id:"Web3DUXFilterMainDiv"+(P.Idpanel?(" "+P.Idpanel):""),"class":"Web3DUXFilterMainDiv"+(P.classpanel?(" "+P.classpanel):"")});w.addEvent("dragstart",function(V){V.preventDefault()});if(p===1){m=S("Web3DUXFilterBody",w)}else{if(p===2){if(P.lJsonElement[0].bexclude){N=S("Web3DUXFilterLeftDiv",w);m=S("Web3DUXFilterBody",w);r.push(h(m))}else{m=S("Web3DUXFilterBody",w);q=S("Web3DUXFilterRightDiv",w);r.push(h(q))}}else{if(p===3){N=S("Web3DUXFilterLeftDiv",w);m=S("Web3DUXFilterBody",w);r.push(h(m));q=S("Web3DUXFilterRightDiv",w);r.push(h(q))}}}k.setVisibleFlag(true)}function h(T){var U=f.createElement("div",{"class":"Web3DUXFilterSeparator"}).inject(T);U.addClassName(P.typeSeparator==="bubble"?"Web3DUXFilterBubble":"Web3DUXFilterLine");return U}function u(){if(p===1){return m}else{if(p===2){if(P.lJsonElement[0].bexclude){return N}else{return m}}else{if(p===3){return N}}}}function K(){L=((36+8)*t.length);w.style.width=L+"px";var T=P.frmWindow.getContent().offsetHeight;M=(P.body.getStyle("width").replace(/px/g,""))/2-(L/2);if(P.actionBar&&P.actionBar.elements&&P.actionBar.elements.container&&P.actionBar.elements.container.getStyle("height")&&parseInt(P.actionBar.elements.container.getStyle("height").replace(/px/g,""),10)>0){l=parseInt(P.actionBar.elements.container.getStyle("height").replace(/px/g,""),10)*1.75}else{l=145}F=T-l}function z(){if(!w){return}K();var T=o&&!isNaN(o.x)?o.x:M;var U=o&&!isNaN(o.y)?o.y:F;w.style.left=T+"px";w.style.top=U+"px";J=new c.Box2(new c.Vector2(T,U),new c.Vector2(T+L,U+D));if(x){w.style.opacity=0.5}}function C(U){if(!w||!x||!J){return}if(!U){U=window.event}var Y=J.distanceToPoint(new c.Vector2(U.pageX?U.pageX:U.clientX,U.pageY?U.pageY:U.clientY));var aa=1,Z=0.5,T=200,X=100;var V=(Z-aa)/(T-X);var W=Math.min((aa-X*V)+V*Y,aa);W=Math.max(W,Z);w.style.opacity=W}this.build=function(){if(!P.body||!P.lJsonElement||(P.lJsonElement&&!P.lJsonElement.length)){return}k.clear();var Y=[];for(var af=0;af<P.lJsonElement.length;af++){if(P.lJsonElement[af].type!=="separator"){Y.push(P.lJsonElement[af].id)}}var X=v(Y);if(!X||X.length===0){n();var Z=u();var V=P.lJsonElement.length;D=0;var ac=0,U=0,aa;var T=0,ae=0,W=6;for(var af=0;af<P.lJsonElement.length;af++){var ad=(-(((P.lJsonElement.length/2)-1)*2)+(2*af)+((parseInt(P.widthElem,10)+8)*af))+ae;if(af>(P.lJsonElement.length/2)){aa=-(W*(af-(P.lJsonElement.length/2)))}else{aa=-(((P.lJsonElement.length/2)-1)*W)+(W*af)}if(V<=3){U=ad}else{if((V%2)===0){if(af===(P.lJsonElement.length/2)||af===((P.lJsonElement.length/2)-1)){U=ad}else{if(af>=(P.lJsonElement.length/2)){var ab=-(((P.lJsonElement.length/2)-1)*2)+(2*(af-1))+((parseInt(P.widthElem,10)+8)*af)+ae;ac=aa;U=ab}else{ac=aa;U=ad}}}else{if(af===(P.lJsonElement.length/2-0.5)){U=ad}else{ac=aa;U=ad}}}if(P.lJsonElement[af].type==="separator"){if(Z===N){Z=m}else{if(Z===m){Z=q}}if(P.typeSeparator==="bubble"){r[T].style.top=(ac+18)+"px";if(T>=1){r[T].style.marginLeft="2px"}}else{r[T].style.top=ac+"px"}r[T].style.left=U+"px";if((T>=1&&P.typeSeparator!=="bubble")||(Z===q&&P.typeSeparator!=="bubble")){r[T].style.transform="translate3d(0%, 0%, 0px) rotate(-15deg) rotateY(85deg)"}T++;ae=-(parseInt(P.widthElem,10)+4)*(T)}else{if(af===0){D=ac+36}A(P.lJsonElement[af],Z,ac+"px",U+"px")}}if(P.body){z();w.inject(P.body);x=false;if(P.updateVisibilty&&P.body.parentNode&&P.body.parentNode.parentNode){P.body.parentNode.parentNode.addEvent(b.POINTERMOVE,C);x=true}s=a.subscribe({event:"/VISU/onWindowResized"},function(ag){if(ag.eventType==="@onWindowResized"){Q=true;z();Q=false}})}}};this.setPosition=function(T){o=T;z()},this.getActiveState=function(V){if(!w){return}var U=new RegExp("Web3DUXFilterActiveState");for(var T=0;T<t.length;T++){if(t[T].id===V&&U.test(t[T].className)){return true}}return false};this.setVisibleFlag=function(T){if(w){w.style.display=T?"block":"none"}};this.getVisibleFlag=function(){if(w){return w.style.display==="block"}return false};this.clear=function(){t=g=[];i=R={};if(w){w.destroy();w=null}if(N){N.destroy();N=null}if(m){m.destroy();m=null}if(q){q.destroy();q=null}if(x&&P.body&&P.body.parentNode&&P.body.parentNode.parentNode){P.body.parentNode.parentNode.removeEvent(b.POINTERMOVE,C)}if(s){a.unsubscribe(s);s=null}}}});return d});