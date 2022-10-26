define("DS/CfgSolver/CfgSolverServices",["DS/WAFData/WAFData","UWA/Utils","DS/i3DXCompassServices/i3DXCompassServices","UWA/Promise"],function(a,d,c){var b={solverUrlEndPoint:null,serviceUrl:null,method:"POST",_tenant:"OnPremise"};b.getDefaultImage=function(){var e="";if(this.serviceUrl!=null){e=this.serviceUrl+"/snresources/images/icons/large/iconLargeDefault.png"}return e};b.initSolver=function(g){var f="initialization/context/"+g.modelId;this._solverURL="/resources/cfg/configurator/solver/";this._computeURL="computeAnswer";this.method="POST";this.receivedTenant=g.tenant;return this._handleRequest(f,{type:"json",data:g.data}).then(function h(i){console.log("initialize solver successfull");return i},function e(i){console.log("failed while creating solver: ");console.log(i);return null})};b.hypervisordetails=function(g){var f="hypervisordetails?random="+Math.random();this.method="GET";return this._handleRequest(f,{type:"json",data:null}).then(function h(i){console.log("initialize solver successfull");return i},function e(i){console.log("failed while creating solver: ");console.log(i);return null})};b._handleRequest=function(f,e){e=e||{};var g=this;return new UWA.Promise(function(k,j){var h=UWA.extend({method:g.method,timeout:300000,type:null,onComplete:function(){k.apply(this,arguments)},onFailure:function(l){j.apply(this,arguments)}},e);var i=new UWA.Promise(function(m){if(g.serviceUrl){g.solverUrlEndPoint=g.serviceUrl+g._solverURL;m(g.solverUrlEndPoint)}else{var l="";if(window&&window.widget){l=window.widget.getValue("x3dPlatformId")}c.getServiceUrl({serviceName:"3DSpace",platformId:l,onComplete:function(n){if(typeof n==="string"){g.serviceUrl=n}else{if(UWA.is(n,"array")){g.serviceUrl=n[0].url;g._tenant=n[0]["platformId"];if(g.receivedTenant&&g.receivedTenant!=="OnPremise"){var o,p=n||[];for(o=0;o<p.length;o++){if(g.receivedTenant==p[o]["platformId"]){g.serviceUrl=p[o].url;g._tenant=p[o]["platformId"]}}}}}g.solverUrlEndPoint=g.serviceUrl+g._solverURL;m(g.solverUrlEndPoint)},onFailure:function(){console.log("Service initialization failed...")}})}});i.then(function(l){a.authenticatedRequest(l+f,h)})})};b.release=function(f){if(f==null){f=""}return this._handleRequest("release",{data:{solverKey:f}}).then(function g(h){return h},function e(h){console.log("failed while releasing the solver: "+h)})};b.computeAnswer=function(o,p,k,j){var e=this._computeURL||"compute";this.method="POST";var q=null;var l=o||{};if(UWA.is(o,"object")){l=JSON.stringify(o)}else{if(UWA.is(o,"string")){l=o}}p=(p==null)?"":p;var m={jsonMsg:l,solverKey:p};if(e==="computeAnswer"){m={selectedCriteria:l,solverId:p}}if(k){m.rand=k}var i=this;if(j){var g=(o&&o._from)?o._from:"apps";var f={_from:g,_to:"solver",_request:"abortRequest",_data:""};return this._handleRequest(e,{type:"application/ds-json",data:{solverKey:p,jsonMsg:(JSON.stringify(f))}}).then(function n(){console.debug("Aborting solver");return i._handleRequest(e,{type:"application/ds-json",data:m})},function h(){console.error("failed while trying to abort the solver")})}else{return this._handleRequest(e,{type:"application/ds-json",data:m})}};b.create=function(){var g=null;var f="create";this._solverURL="/resources/rulesolver/solver/";this._computeURL="compute";return this._handleRequest(f,{type:"json"}).then(function h(i){console.log("create solver successfull");return i},function e(i){console.log("failed while creating solver: ");console.log(i);return null})};b.initialize=function(i){var h={};h.jsonData=(i.jsonData)?JSON.stringify(i.jsonData):"{}";h.solverKey=(i.solverKey)?i.solverKey:null;var g=null;var f="initialize";return this._handleRequest(f,{type:"json",data:h}).then(function j(k){console.log("initialize solver successfull");return k},function e(k){console.log("failed while creating solver: ");console.log(k);return null})};b.clearSolver=function(g){var h=null;var f="clear";return this._handleRequest(f,{type:"json",data:{solverKey:g}}).then(function i(j){console.log("clear solver successfull");return j},function e(j){console.log("failed while clear solver: ");console.log(j);return null})};b.getWAFdata=function(){return a};b.setRuleActivation=function(g,e,f){var h={_from:"ruleEditor",_to:"solverRule",_request:"ruleActivation",_data:{ruleId:g,ruleActivation:e}};return this.computeAnswer(h,f)};b.callSolveForRules=function(e,g,h){var f={matrixDefinition:{constrainedCriteria:e.constrainedCriteria,constrainedValues:e.constrainedValues,drivingCriteria:e.drivingCriteria,drivingCombinationValues:e.drivingCombinationValues,states:e.states},buildtimeCheck:e.statesCauses?"validityWithCause":"validity",runtimeCheck:e.statesCauses?"validityWithCause":"validity"};if(e.statesCauses){f.matrixDefinition.statesCauses=e.statesCauses;e._clientData.statesCauses=e.statesCauses}var i={_from:"ruleEditor",_to:"solverRule",_version:"2.0",_request:"checkMatrixRuleValidity",_data:f,_clientData:e._clientData||{}};this.computeAnswer(i,g).then(function(j){var m=JSON.parse(j);var l=m._data;l.version=m._version;var k=UWA.merge(l,{version:m._version,_clientData:m._clientData});if(l._clientData&&l._clientData.statesCauses){h.publish({event:"checkMatrixRuleValidity_SolverReason",data:{answerData:k}})}else{h.publish({event:"checkMatrixRuleValidity_SolverAnswer",data:{answerData:l}})}},function(j){})};b.setAlwaysDiagnosed=function(g,e){var f={_from:"configurator",_to:"solverConfiguration",_request:"setAlwaysDiagnosed",_data:{alwaysDiagnosedIds:g}};return this.computeAnswer(f,e)};b.SetMultiSelectionOnSolver=function(f,e){var g={_from:"configurator",_to:"solverConfiguration",_request:"setMultiSelection",_data:f||"false"};return this.computeAnswer(g,e)};b.CheckRulesConsistency=function(){var e={_from:"configurator",_to:"solverConfiguration",_request:"checkModelConsistency",_data:""};return this.computeAnswer(e,this.solverKey)};b.setSelectionModeOnSolver=function(f,e){var g={_from:"configurator",_to:"solverConfiguration",_request:"setSelectionMode",_data:f};return this.computeAnswer(g,e)};b.CallSolveMethodOnSolver=function(f,e){var g={_from:"configurator",_to:"solverConfiguration",_request:"solveAndDiagnoseAll",_data:f};return this.computeAnswer(g,e)};b.getResultingStatusOriginators=function(f,e){var g={_from:"configurator",_to:"solverConfiguration",_request:"getResultingStatusOriginators",_data:f};return this.computeAnswer(g,e)};b.abortSolverCall=function(e){var f={_from:"configurator",_to:"solver",_request:"abortRequest",_data:""};return this.computeAnswer(f,e)};return b});define("DS/CfgSolver/CfgSolverDebug",["DS/CfgSolver/CfgSolverServices","DS/UIKIT/Input/Button","DS/UIKIT/Form","css!DS/CfgSolver/CfgSolverDebug.css","css!DS/UIKIT/UIKIT.css"],function(e,c,d,a,f){var b=function(){var h=null;var r=null;var o=null;var n=null;var k=null;var t=null;var l=null;var m=null;var p=null;var g=null;var j=null;var q=null;var i=function(){p=document.createElement("div");g=document.createElement("div");g.classList.add("solver-debug-title");g.innerHTML="Solver Debugger Tool";j=document.createElement("div");p.classList.add("solver-debug-panel");p.setAttribute("draggable","true");function x(z){var y=window.getComputedStyle(z.target,null);z.dataTransfer.setData("text/plain",(parseInt(y.getPropertyValue("left"),10)-z.clientX)+","+(parseInt(y.getPropertyValue("top"),10)-z.clientY))}function u(y){y.preventDefault();return false}function v(y){var D=y.dataTransfer.getData("text/plain").split(",");var E=-20;var B=(y.clientX+parseInt(D[0],10));var G=Math.max(E,B);var z=p.parentElement.offsetWidth-20;G=Math.min(G,z);var C=-20;var F=p.parentElement.offsetHeight-20;var A=(y.clientY+parseInt(D[1],10));A=Math.max(C,A);A=Math.min(A,F);p.style.left=G+"px";p.style.top=A+"px";y.preventDefault();return false}p.addEventListener("dragstart",x,false);document.body.addEventListener("dragover",u,false);document.body.addEventListener("drop",v,false);s();var w=document.createElement("button");w.setAttribute("type","button");w.setAttribute("title","close");w.classList.add("close");w.classList.add("solver-close");w.innerHTML="&times;";w.onclick=function(){p.parentNode.removeChild(p)};g.appendChild(w);p.appendChild(g);p.appendChild(j)};var s=function(){j.classList.add("solver-debug-body");var u=new c({icon:"record",value:"Record",className:"success solver-start"});u.elements.container.addEventListener("click",function(){q=true;console.log("send start traces SOLVER");var A={};A._from=o;A._to="solver";A._request="tracesActivation";A._data={};A._data.activation="yes";A._data.path=r;if(l===1){A._data.level="messagesAndSolver"}else{A._data.level="messages"}if(h){e.computeAnswer(A,h,Math.random())}else{var z=Object.keys(m);var y=null;var x=0;for(x=0;x<z.length;x+=1){y=z[x];var B=m[y];e.computeAnswer(A,B,Math.random())}}console.log(r);console.log(l);v.elements.container.removeAttribute("disabled");u.elements.container.setAttribute("disabled",true)});u.elements.container.setAttribute("disabled",true);var v=new c({icon:"stop",value:"Stop",className:"warning solver-stop"});v.addEvent("onClick",function(){q=false;console.log("send stop stump SOLVER");var A={};A._from=o;A._to="solver";A._request="tracesActivation";A._data={};A._data.activation="no";if(h){e.computeAnswer(A,h,Math.random())}else{var z=Object.keys(m);var y=null;var x=0;for(x=0;x<z.length;x+=1){y=z[x];var B=m[y];e.computeAnswer(A,B,Math.random())}}v.elements.container.setAttribute("disabled",true);u.elements.container.setAttribute("disabled",true);if(r!==""&&l>=0){u.elements.container.removeAttribute("disabled")}});v.elements.container.setAttribute("disabled",true);var w=new d({fields:[{type:"text",label:"Folder path",name:"path",placeholder:"Path..."},{type:"select",label:"level",placeholder:"Pick a level of traces...",className:"tracelevel",name:"tracelevel",options:[{label:"Exchanged messages",value:"0"},{label:"Messages with resolution traces",value:"1"}]}],events:{onChange:function(x,y){u.elements.container.setAttribute("disabled",true);switch(x){case"tracelevel":l=parseInt(y);break;case"path":r=y;break;default:break}if(r!==""&&l>=0&&!q){u.elements.container.removeAttribute("disabled")}}}});UWA.extendElement(j);w.inject(j);u.inject(j);v.inject(j)};this.init=function(v,u){r="";o=v;n="solver";t="";l=-1;m=u;q=false;i()};this.init2=function(v,u){r="";o=v;n="solver";t="";l=-1;h=u;q=false;i()};this.setPath=function(u){r=u};this.injectIn=function(u){u.appendChild(p)};this.getSolverServices=function(){return e}};return b});