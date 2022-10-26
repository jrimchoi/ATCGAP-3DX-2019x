/*!  Copyright 2018 Dassault Systemes. All rights reserved. */
define("DS/PIMwebViewModel/PIMwebUtils",["DS/WAFData/WAFData"],function(i){var h=function(k){return{input_physical_ids:[k],label:"PIMwebIsr"+Date.now(),primitives:[{navigate_to_rel:{id:1,filter:{bo_type:["dsc_Model_Category_Ref"]}}},{navigate_to_rel:{id:2}},{navigate_to_sr:{id:3,filter:{semantics:["5"],role:["79"]},mode:"last"}},{navigate_to_rel:{id:4,filter:{bo_type:["dsc_Result_Category_Ref"]}}},{navigate_to_rel:{id:5}}],patterns:{model:[{id:1},{id:2},{id:3}],itfCtxt:[{id:4},{id:5}]},fileAttributes:[],version:3}},j=function(k){return{input_physical_ids:[k],label:"PIMwebIsrToContext"+Date.now(),primitives:[{navigate_to_rel:{id:1,filter:{bo_type:["dsc_Model_Category_Ref"]}}},{navigate_to_rel:{id:2}},{navigate_to_sr:{id:3,filter:{semantics:["5"],role:["79"]},mode:"last"}}],patterns:{model:[{id:1},{id:2},{id:3}]},fileAttributes:[],version:3}},c=function(k){return{input_physical_ids:k,label:"PIMwebItfCtxt"+Date.now(),primitives:[{navigate_to_sr:{id:1,filter:{semantics:["6"],role:["198"]},mode:"last"}},{navigate_to_rel:{id:2}},{navigate_to_sr:{id:3,filter:{semantics:["5"],role:["201"]},mode:"path"}},{navigate_to_sr:{id:4,filter:{semantics:["5"],role:["197"]},mode:"path"}}],patterns:{ms:[{id:1}],r2sca:[{id:4}],sca2occ:[{id:1},{id:2},{id:3}]},attributes:["ds6w:label","ds6w:type","owner","current","bo.PLMEntity.V_description","bo.PLMPIMMetricReference.V_Itf_Analysis","bo.PLMPIMMetricReference.V_Itf_Previous_Analysis","bo.PLMPIMMetricReference.V_Itf_Type","bo.PLMPIMMetricReference.V_Itf_User_Type","bo.PLMPIMMetricReference.V_Itf_Real_Tolerance_Used_For_Computation","bo.PLMPIMMetricReferenceClashContact.V_Itf_Penetration_Value","bo.PLMPIMMetricReferenceClashContact.V_Itf_FirstPointFoundClash","bo.PLMPIMMetricReferenceClashContact.V_Itf_SecondPointFoundClash","bo.PLMPIMMetricReferenceClearance.V_Itf_Distance_Min","bo.PLMPIMMetricReferenceClearance.V_Itf_FirstPointFoundClearance","bo.PLMPIMMetricReferenceClearance.V_Itf_SecondPointFoundClearance"],fileAttributes:[],version:3}},e=function(k){return{input_physical_ids:k,label:"PIMwebItfMetric"+Date.now(),primitives:[{navigate_from_sr:{id:1,filter:{semantics:["6"],role:["198"]}}},{navigate_from_rel:{id:2}}],patterns:{itfCtxt:[{id:1}],isr:[{id:1},{id:2,iter:2}]},attributes:[],fileAttributes:[],version:3}},b=function(k){return{input_physical_ids:k,label:"PIMwebNavigateOneLevel"+Date.now(),primitives:[{navigate_to_rel:{id:1}}],patterns:{ref:[{id:1}]},fileAttributes:[],version:3}},d=function(m,o,k,l){var n={};Object.keys(m).forEach(function(p){n[p]=m[p]});n.method=o;n.url=(m.baseURL?m.baseURL:require("DS/PADUtils/PADUtilsServices").get3DSpaceUrl())+k;if(!n.securityContext){n.securityContext=require("DS/PADUtils/PADSettingsMgt").getSetting("pad_security_ctx")}n.tenant=n.tenant===null?"":("&tenant="+require("DS/PADUtils/PADUtilsServices").getPlatformId());n.data=l;return n},a=function(k){return i.authenticatedRequest(k.url+"?SecurityContext="+k.securityContext+k.tenant,{method:k.method,headers:{Accept:"application/json","Content-Type":"application/json",SecurityContext:k.securityContext},data:JSON.stringify(k.data),timeout:k.timeout,onComplete:k.onComplete,onFailure:k.onFailure,onTimeout:k.onTimeout||k.onFailure})};var g=Object.create({}),f=Object.getPrototypeOf(g);f._DEFAULT_PAGGING=500;f._navigateFromIsr=function(k){return a(d(k,"POST","/cvservlet/navigate",h(k.isrID)))};f._navigateFromIsrToContext=function(k){return a(d(k,"POST","/cvservlet/navigate",j(k.isrID)))};f._navigateFromContextualInterferences=function(k){return a(d(k,"POST","/cvservlet/navigate",c(k.ctxIDs)))};f._setAttrValue=function(k){return a(d(k,"POST","/resources/PIMwebModel/setAttributeValue",k.data))};f._navigateFromMetricToIsr=function(k){return a(d(k,"POST","/cvservlet/navigate",e(k.metricIDs)))};f._navigateOneLevel=function(k){return a(d(k,"POST","/cvservlet/navigate",b(k.ids)))};return g});define("DS/PIMwebViewModel/PIMwebUnits",["i18n!DS/PIMwebViewModel/assets/nls/PIMwebViewModel"],function(b){var a={Types:{Length:{name:"Length",defaultValue:"mm"},Angle:{name:"Angle",defaultValue:"deg"},Volume:{name:"Volume",defaultValue:"mm3"},Area:{name:"Area",defaultValue:"mm2"}},Length:{mm:{name:"mm",nls:b.units.mm,ratio:1},cm:{name:"cm",nls:b.units.cm,ratio:Math.pow(10,-1)},m:{name:"m",nls:b.units.m,ratio:Math.pow(10,-3)},km:{name:"km",nls:b.units.km,ratio:Math.pow(10,-6)},inch:{name:"inch",nls:b.units.inch,ratio:1/25.4},foot:{name:"foot",nls:b.units.foot,ratio:1/304.8}},Angle:{deg:{name:"deg",nls:b.units.deg,ratio:1},rad:{name:"rad",nls:b.units.rad,ratio:Math.PI/180}},Volume:{mm3:{name:"mm3",nls:b.units.mm3,ratio:1},cm3:{name:"cm3",nls:b.units.cm3,ratio:Math.pow(10,-3)},m3:{name:"m3",nls:b.units.m3,ratio:Math.pow(10,-9)},km3:{name:"km3",nls:b.units.km3,ratio:Math.pow(10,-18)},inch3:{name:"inch3",nls:b.units.inch3,ratio:1/16387.064},foot3:{name:"foot3",nls:b.units.foot3,ratio:1/28316846.6}},Area:{mm2:{name:"mm2",nls:b.units.mm2,ratio:1},cm2:{name:"cm2",nls:b.units.cm2,ratio:Math.pow(10,-2)},m2:{name:"m2",nls:b.units.m2,ratio:Math.pow(10,-6)},km2:{name:"km2",nls:b.units.km2,ratio:Math.pow(10,-12)},inch2:{name:"inch2",nls:b.units.inch2,ratio:1/645.16},foot2:{name:"foot2",nls:b.units.foot2,ratio:1/92903.04}}};return Object.freeze(a)});define("DS/PIMwebViewModel/PIMwebIsr",["UWA/Core","UWA/Class","DS/CoreEvents/ModelEvents","DS/PIMwebViewModel/PIMwebUtils"],function(m,s,k,i){var p=1,e={},l={1:"Clash",2:"Contact",3:"Clearance",4:"Contact",5:"NoInterference",6:"Undefined"},j={1:"OK",2:"KO",3:"NotAnalyzed",4:"NotAnalyzed",5:"NotAnalyzed"},b={"bo.PLMEntity.V_description":"itfDescription","bo.PLMPIMMetricReference.V_Itf_Analysis":"itfAnalysis","bo.PLMPIMMetricReference.V_Itf_Previous_Analysis":"itfPrevAnalysis","bo.PLMPIMMetricReference.V_Itf_Type":"itfSystemType","bo.PLMPIMMetricReference.V_Itf_User_Type":"itfUserType","bo.PLMPIMMetricReference.V_Itf_Real_Tolerance_Used_For_Computation":"itfTolerance","bo.PLMPIMMetricReferenceClashContact.V_Itf_Penetration_Value":"itfQuantifier","bo.PLMPIMMetricReferenceClearance.V_Itf_Distance_Min":"itfQuantifier","bo.PLMPIMMetricReferenceClashContact.V_Itf_FirstPointFoundClash":"itfQtfPt1","bo.PLMPIMMetricReferenceClashContact.V_Itf_SecondPointFoundClash":"itfQtfPt2","bo.PLMPIMMetricReferenceClearance.V_Itf_FirstPointFoundClearance":"itfQtfPt1","bo.PLMPIMMetricReferenceClearance.V_Itf_SecondPointFoundClearance":"itfQtfPt2",owner:"itfOwner",current:"itfCurrent"},g=["physicalid","type","itfMetricName","itfOwner","itfCurrent","itfDescription","itfAnalysis","itfPrevAnalysis","itfSystemType","itfUserType","itfTolerance","itfQuantifier","itfQtfPt1","itfQtfPt2"],o=["physicalid","itfCtxName"];function q(v){var u=Number(v);return isNaN(u)||u<0?null:u}function n(v){var u=Number(v);return isNaN(u)?null:u}function r(u){Object.keys(u).forEach(function(v){var w=b[v];if(w){u[w]=u[v];delete u[v]}});return u}function h(u){u.itfCtxName=u["ds6w:label"];r(u);Object.keys(u).forEach(function(v){if(o.indexOf(v)===-1){delete u[v]}});return u}function d(u){u.itfMetricName=u["ds6w:label"];u.type=u["ds6w:type"];r(u);Object.keys(u).forEach(function(v){if(g.indexOf(v)===-1){delete u[v]}});return u}function c(x,w){var u,v;for(u in x){if(x.hasOwnProperty(u)&&x[u]===w){v=u}}return v}function f(v){var u=String(window.widget?window.widget.id+"_":"")+v;window.top.performance.measure(u,u)}function t(u){window.top.performance.mark(String(window.widget?window.widget.id+"_":"")+u)}var a=(function(){var v=[],u=0,x=5,z=0,y=function(A,C,B){f("PIM_QueryCtx_"+A);u--;a();setTimeout(function(){B(C)},0)},w=function(B,A){t("PIM_QueryCtx_"+A);var C=m.clone(B,false);C.onComplete=function(D){y(A,D,B.onComplete)};C.onFailure=function(D){y(A,D,B.onFailure)};C.onTimeout=function(D){y(A,D,B.onTimeout||B.onFailure)};i._navigateFromContextualInterferences(C)};return function(A){if(A){v.push(A)}if(v.length&&u<x){u++;z++;w(v.shift(),z)}}}());return s.extend({init:function(z){var B=this,y={physicalid:z.id,isrContext:[],nbItfs:-1,itfs:{}},A=new k(),x=function(D,C){return A.publish({event:D,data:C,context:B})};function u(E){if(!E||!E.contextualIDs||!E.onProgress||!E.onComplete||!E.onFailure){return}if(E.contextualIDs.length===0){E.onComplete({itfIDs:[],metricIDs:[]})}var G=Math.floor((E.contextualIDs.length-1)/i._DEFAULT_PAGGING)+1,C=0,F=[],D=false;while(C<G&&!D){performance.mark("iteration"+C);a({ctxIDs:E.contextualIDs.slice(C*i._DEFAULT_PAGGING,(C+1)*i._DEFAULT_PAGGING),onComplete:function(V){if(D){return}var W=JSON.parse(V);if(!W||!W.infos||W.infos.status!=="OK"||!W.result){return}W=W.result;var S=W.length,U=[],J=[],H,R,M,T,O,I,Q,L,K,P,N;for(T=0;T<S;++T){H=W[T];R=h(H.input_object);M=H.outputs.ms?H.outputs.ms[0]:null;U.push(R.physicalid);if(M&&J.indexOf(M.physicalid)===-1){J.push(M.physicalid)}if(M&&!e[M.physicalid]){e[M.physicalid]=d(M)}else{if(M&&e[M.physicalid]){M=e[M.physicalid]}}if(M&&!M.ctxt){M.ctxt=[]}if(M&&M.ctxt&&M.ctxt.indexOf(R.physicalid)===-1){M.ctxt.push(R.physicalid)}R.metricID=M?M.physicalid:null;y.itfs[R.physicalid]=R;if(H.outputs.r2sca&&H.outputs.r2sca.length){R.r2sca=[];for(O=0,P=H.outputs.r2sca[0].elements.length;O<P;++O){L=H.outputs.r2sca[0].elements[O];R.r2sca.push({physicalid:L.physicalid,label:L["ds6w:label"],type:L["ds6w:type"]})}}if(H.outputs.sca2occ&&M&&!M.sca2occ){M.sca2occ=[];for(O=0,P=H.outputs.sca2occ.length;O<P;++O){Q=H.outputs.sca2occ[O];K=[];for(I=0;I<Q.elements.length;++I){L=Q.elements[I];K.push({physicalid:L.physicalid,label:L["ds6w:label"],type:L["ds6w:type"]})}N=typeof Q.sr_id==="number"?Q.sr_id-1:O;M.sca2occ[N]=K}}}E.onProgress({itfIDs:U,metricIDs:J});F.push.apply(F,U);if(F.length===E.contextualIDs.length){E.onComplete({itfIDs:F})}},onFailure:function(H){D=true;if(!H){H={}}H.step="Metrics";E.onFailure(H)}});C++}}function w(D){if(!y.physicalid){D.onFailure({error:"No valid Simulation ID parameter (iSimulationID)"});D.onFailure({step:"Simulation"});return}var C=p++;t("PIM_QueryIsr_"+C+"_"+y.physicalid);i._navigateFromIsr({isrID:y.physicalid,onComplete:function(G){f("PIM_QueryIsr_"+C+"_"+y.physicalid);var I=JSON.parse(G),E;if(!I||!I.result||I.result.length!==1){D.onFailure({step:"Simulation"});return}E=I.result[0];if(!E||Object.keys(E.outputs).length===0){D.onFailure({step:"Simulation"});return}y.label=E.input_object["ds6w:label"];y.type=E.input_object["ds6w:type"];y.nbItfs=E.outputs.itfCtxt?E.outputs.itfCtxt.length:0;var F=E.outputs.model?E.outputs.model[0]:null;y.isrContext=F?[{physicalid:F.physicalid,label:F["ds6w:label"],type:F["ds6w:type"]}]:[];D.onProgress({context:F?[F.physicalid]:[]});var H=(E.outputs.itfCtxt)?(E.outputs.itfCtxt.map(function(J){return J.physicalid})):[];u({contextualIDs:H,onProgress:D.onProgress,onComplete:D.onComplete,onFailure:D.onFailure})},onFailure:function(E){f("PIM_QueryIsr_"+C+"_"+y.physicalid);if(!E){E={}}E.step="Simulation";D.onFailure(E)}})}function v(E){var D=p++,G=[],C=false;function F(H){if(C){return}G.push.apply(G,H.itfs);if(H.error){C=true;H.error.step="Metrics";H.error.isrID=y.physicalid;E.onFailure(H.error)}else{if(G.length===E.contextualIDs.length){E.onComplete({isrID:y.physicalid,itfIDs:G})}}}t("PIM_QueryIsrToContext_"+D+"_"+y.physicalid);i._navigateFromIsrToContext({isrID:y.physicalid,onComplete:function(I){f("PIM_QueryIsrToContext_"+D+"_"+y.physicalid);var K=JSON.parse(I),H;if(!K||!K.result||K.result.length!==1){E.onFailure();return}y.label=K.result[0].input_object["ds6w:label"];H=K.result[0].outputs&&K.result[0].outputs.model?K.result[0].outputs.model[0]:null;if(H&&y.isrContext.length===0){y.isrContext.push({label:H["ds6w:label"],physicalid:H.physicalid,type:H["ds6w:type"]})}function J(O){var L=O.itfIDs,N=[],M=[];if(y.isrContext.length){L.forEach(function(R){var P=y.itfs[R],Q=[y.isrContext[0].physicalid];if(P.r2sca){P.r2sca.forEach(function(S){if(N.indexOf(S.physicalid)===-1){N.push(S.physicalid);Q.push(S.physicalid)}})}if(P.metricID&&e[P.metricID]&&e[P.metricID].sca2occ){e[P.metricID].sca2occ.forEach(function(U){var S=Q.slice();for(var T=0;T<U.length;++T){if(U[T].type==="VPMInstance"){if(N.indexOf(U[T].physicalid)===-1){N.push(U[T].physicalid)}}S.push(U[T].physicalid)}M.push(S)})}})}if(N.length){i._navigateOneLevel({ids:N,onComplete:function(R){var Q=JSON.parse(R),P={};if(!Q||!Q.infos||Q.infos.status!=="OK"||!Q.result){return}Q.result.forEach(function(S){P[S.input_object.physicalid]=S.outputs.ref[0].physicalid});M.forEach(function(U){for(var S=U.length-1,T;S>=0;--S){T=P[U[S]];if(T){U.splice(S+1,0,T)}}});E.onProgress({interferingParts:M,itfIDs:L,isrID:y.physicalid,metrics:O.metricIDs});F({itfs:L})},onFailure:function(){E.onProgress({itfIDs:L,isrID:y.physicalid,metrics:O.metricIDs});F({itfs:L})}})}else{E.onProgress({itfIDs:L,isrID:y.physicalid,metrics:O.metricIDs});F({itfs:L})}}u({contextualIDs:E.contextualIDs,onProgress:J,onComplete:function(){},onFailure:E.onFailure})},onFailure:function(){f("PIM_QueryIsrToContext_"+D+"_"+y.physicalid);E.onFailure()}})}this._fetch=function(C){if(!y.physicalid||!C||!C.onProgress||!C.onComplete||!C.onFailure){C.onFailure();return}if(!C.contextualIDs){w(C)}else{if(C.contextualIDs.length>0){v(C)}}};this.getIsrContextIDs=function(){return y.isrContext.map(function(C){return C.physicalid})};this.getItfIDs=function(){return Object.keys(y.itfs)};this.getInterferences=function(C){var E=[],D=!C?Object.keys(y.itfs):!Array.isArray(C)?[C]:C;D.forEach(function(G){var H=y.itfs[G],F=e[H.metricID];var I={itfuid:G,itfModelId:y.physicalid,itfCtxName:H.itfCtxName,itfR2Sca:H.r2sca};if(F){I.itfMetricName=F.itfMetricName;I.itfSystemType=l[F.itfSystemType];I.itfUserType=l[F.itfUserType];I.itfAnalysis=j[F.itfAnalysis];I.itfPrevAnalysis=j[F.itfPrevAnalysis];I.itfQuantifier=q(F.itfQuantifier);I.itfDescription=F.itfDescription;I.itfTolerance=q(F.itfTolerance);I.itfOwner=F.itfOwner;I.itfCurrent=F.itfCurrent;I.itfSca2occ=F.sca2occ;I.itfQtfPt1=I.itfQuantifier>0&&F.itfQtfPt1&&F.itfQtfPt1.length===3?F.itfQtfPt1.map(n):null;I.itfQtfPt2=I.itfQuantifier>0&&F.itfQtfPt2&&F.itfQtfPt2.length===3?F.itfQtfPt2.map(n):null;if(!I.itfQtfPt1||!I.itfQtfPt2){I.itfQtfPt1=I.itfQtfPt2=null}I.mID=F.physicalid;I.mType=F.type}else{I.itfMetricName=I.itfSystemType=I.itfUserType=I.itfAnalysis=I.itfPrevAnalysis=I.itfQuantifier=undefined;I.itfDescription=I.itfTolerance=I.itfOwner=I.itfCurrent=I.itfSca2occ=undefined}E.push(I)});return E};this.updateInterference=function(I){if(!I.id||!y.itfs[I.id]||typeof I.param!=="string"){x("itfUpdateFailed",[{id:I.id}]);return}var F=y.itfs[I.id],E=e[F.metricID],C,H,G;switch(I.param){case"itfCtxName":C=F.physicalid;H="PLMEntity.V_Name";G=I.newValue;break;case"itfMetricName":C=E?E.physicalid:null;H="PLMEntity.V_Name";G=I.newValue;break;case"itfUserType":C=E?E.physicalid:null;H="PLMPIMMetricReference.V_Itf_User_Type";G=c(l,I.newValue);break;case"itfAnalysis":C=E?E.physicalid:null;H="PLMPIMMetricReference.V_Itf_Analysis";G=c(j,I.newValue);break;case"itfDescription":C=E?E.physicalid:null;H="PLMEntity.V_description";G=I.newValue;break;default:}if(C){var D={data:{id:C,attrName:H,attrValue:G},onComplete:function(K){var L=typeof K==="string"?JSON.parse(K):{},J=[];if(L&&L.status==="success"){if(I.param==="itfCtxName"){F.itfCtxName=G;J.push(I.id)}else{E[I.param]=G;Array.prototype.push.apply(J,E.ctxt)}}else{J.push(I.id)}x("itfUpdateSuccess",J.map(function(M){return{id:M}}))},onFailure:function(){x("itfUpdateFailed",[{id:I.id}])}};i._setAttrValue(D)}else{setTimeout(function(){x("itfUpdateFailed",[{id:I.id}])},0)}};this.isPartiallyLoaded=function(){return y.nbItfs===-1};this.getAlias=function(){return y.label};this.subscribe=function(D,C){if(!D||!C){return null}return A.subscribe({event:D},C)};this.unsubscribe=function(C){if(C===null||C===undefined){return}A.unsubscribe(C)}}})});define("DS/PIMwebViewModel/PIMwebIsrMgr",["DS/PIMwebViewModel/PIMwebIsr","DS/PIMwebViewModel/PIMwebUtils","DS/CoreEvents/ModelEvents"],function(f,h,c){var g={},d={},i=new c();function a(l){var k=g[l];if(!k){window.console.log(l+" has not been loaded");return -1}k.lock++;return 0}function j(l){var k=g[l];if(!k){window.console.log(l+" has not been loaded");return -1}k.lock--;if(k.lock===0){k=g[l]=null;delete g[l]}return 0}function b(l,k){return i.publish({event:l,data:k})}function e(l){var k=g[l];if(!k){var m=new f({id:l});g[l]=k={isr:m,lock:0};d[l]=[];d[l].push(m.subscribe("itfUpdateSuccess",function(n){n.isrID=l;b("itfUpdateSuccess",n)}));d[l].push(m.subscribe("itfUpdateFailed",function(n){n.isrID=l;b("itfUpdateFailed",n)}))}return k.isr}return Object.freeze({subscribe:function(l,k){if(!l||!k||(l!=="itfUpdateSuccess"&&l!=="itfUpdateFailed")){window.console.error("Invalid event name");return null}return i.subscribe({event:l},k)},unsubscribe:function(k){if(k===null||k===undefined){return undefined}return i.unsubscribe(k)},getLoadedIsr:function(){var k={};Object.keys(g).forEach(function(l){k[l]=g[l].isr});return k},getIsr:function(l){var k=g[l];return k?k.isr:null},loadIsr:function(m){if(!m||!m.isrID||!m.onProgress||!m.onComplete||!m.onFailure){window.console.error("Invalid arguments");return}var l=m.isrID,k=e(l);if(k.isPartiallyLoaded()){k._fetch({onProgress:function(n){m.onProgress({itfIDs:n.itfIDs,context:n.context,isrID:l,isr:k})},onComplete:function(){m.onComplete({isrID:l,isr:k,wasFullyLoaded:false});if(g[l].lock===0){window.console.log("isr has not been locked!!!")}},onFailure:function(n){delete g[l];k=null;m.onFailure(n)}})}else{m.onProgress({itfIDs:k.getItfIDs(),context:k.getIsrContextIDs(),isrID:l,isr:k});m.onComplete({isrID:l,isr:k,wasFullyLoaded:true})}},loadIsrFromMetrics:function(k){if(!k||!k.metrics||!k.onProgress||!k.onComplete||!k.onFailure){k.onFailure();return}h._navigateFromMetricToIsr({metricIDs:k.metrics,onComplete:function(o){var l=JSON.parse(o),p={},m=[],n;if(!l||!l.infos||l.infos.status!=="OK"||!l.result){k.onFailure();return}l=l.result;if(!l||!Array.isArray(l)){k.onFailure();return}l.forEach(function(q){n=q.outputs.isr?q.outputs.isr[0].physicalid:null;if(!n){m.push(q.input_object.physicalid);return}if(!p[n]){p[n]={itfC:[],itfM:[],label:q.outputs.isr[0]["ds6w:label"]}}p[n].itfC=p[n].itfC.concat(q.outputs.itfCtxt.map(function(r){return r.physicalid}));if(p[n].itfM.indexOf(q.input_object.physicalid)===-1){p[n].itfM.push(q.input_object.physicalid)}});Object.freeze(p);k.onFilterIsr({isrIDs:p,metricsWithoutIsr:m,onComplete:function(s){var r=s.length,q=function(){if(--r===0){k.onComplete()}};if(s.length===0){r=1;q();return}s.forEach(function(u){if(p[u]){var t=e(u);t._fetch({contextualIDs:p[u].itfC,onProgress:k.onProgress,onComplete:function(){k.onComplete({isrID:u,isr:t,wasFullyLoaded:false});if(g[u].lock===0){window.console.log("isr has not been locked!!!")}q()},onFailure:function(){k.onFailure({isrID:u,isr:t,wasFullyLoaded:false})}})}})}})},onFailure:function(){k.onFailure()}})},lockIsr:a,unlockIsr:j})});