define("DS/ReviseWidget/ReviseWidget",["css!DS/ReviseWidget/ReviseWidget","UWA/Controls/Abstract","i18n!DS/LifecycleWidget/assets/nls/LifecycleWidgetNls","DS/LifecycleServices/LifecycleCommandManager","DS/LifecycleServices/LifecycleServices","DS/LifecycleServices/LifecycleServicesSettings","DS/WAFData/WAFData","DS/LifecycleServices/LifecycleObjectList","DS/LifecycleServices/DictionaryServices","DS/LifecycleControls/CommandDialog","DS/LifecycleCmd/MessageMediator","DS/LifecycleCmd/Dictionary","DS/LifecycleServices/IllegalCharMapping","DS/WidgetServices/WidgetServices","DS/WebToWinInfra/WebToWinCom"],function(j,h,c,o,e,d,n,k,f,g,i,l,a,p,b){var m=h.extend({physicalIds:null,context:null,objectListDiv:null,objectsList:null,tenant:null,folderId:null,useNLV:false,init:function(q){this._parent(q);this.physicalIds=[];this._newTitles=new l();this.illegalChars="";this.IllegalCharMapping=new a();this.commandManager=new o();if(q!==undefined&&q!==null&&q.hasOwnProperty("wintop")&&q.wintop==true){this.container=UWA.createElement("div",{name:"new_revision","class":"revise_popup"})}this.reviseOptions=[]},executeCmd:function(r,q,u){this.addEvent("onReady",function(v){this._showCommandUI(r)},this);this.addEvent("onComplete",function(v){u()});this.isMultipleSelection=r.length>1;this.context=q.context;this.folderId=q.targetFolderId;try{if(d.getActiveFolder!==undefined){var s=d.getActiveFolder();if(s.id!==null){this.folderId=s.id;this.securityContex=s.sc!==""&&s.sc!==undefined?s.sc:this.securityContex;require(["DS/PlatformAPI/PlatformAPI"],function(v){v.publish("FolderEditor.ActiveFolderCallBack",{id:s.id,label:s.label})})}}}catch(t){this.folderId=q.targetFolderId;this.securityContex=d.getCurrentFolderSecurityContext()}if(this.isMultipleSelection){this._createObjectsList()}this.setObjects(r)},_createSingleSelContent:function(r){var s=this;var q=document.createElement("div");var t=document.createElement("div");t.innerHTML=c.createRevision+r[0].displayName+c.questionMark;q.appendChild(t);if(r[0].type){f.getIsKindOfPromise(s.tenant,["VPMReference"],r[0].type).then(function(u){if(u){var w=document.createElement("div");w.className="lifecycle-option";var y=document.createElement("div");y.className="lifecycle-textOptionKey";var x=document.createElement("b");x.innerHTML=c.title+":";y.appendChild(x);var v=document.createElement("input");v.className="lifecycle-option-title";v.type="text";v.name="title";v.value=r[0].name;v.physID=r[0].physicalid;v.addEventListener("input",function(){s._newTitles.add(v.physID,v.value)},true);w.appendChild(y);w.appendChild(v);q.appendChild(w)}})}return q},_showCommandUI:function(y){var v=this;var w=document.createElement("div");w.className="revise_popup";if(this.isMultipleSelection){this.objectListDiv.inject(w)}else{var q=this._createSingleSelContent(y);w.appendChild(q)}var s=this;var u=new g();var x=u.create(w,{className:"ENO_Revise",closeButton:true,title:c.newRevision,resizable:true,imageUrl:y[0].imageUrl||"",onOk:function(){s._executeRevise(function(B,C){if(C){u.destroy();s._onComplete();if(v.options!==undefined&&v.options!==null&&v.options.hasOwnProperty("wintop")&&v.options.wintop==true){s._onReviseComplete(B)}s.dispatchEvent("onClose")}else{u.updateUI()}})},onClose:function(){s._onComplete();if(v.options!==undefined&&v.options!==null&&v.options.hasOwnProperty("wintop")&&v.options.wintop==true){s._onCancel()}},events:{onResizeFloating:function(){if(v.objectsList){v.objectsList.objectsTable.resizeTable()}}}});x.inject(widget.body);var z=this.isMultipleSelection?600:500;var t=this.isMultipleSelection?340:210;var r=this.isMultipleSelection?350:330;var A=this.isMultipleSelection?250:200;x.setNewSize({width:z,height:t});setTimeout(function(){x.setMinSize(r,A)},10)},_onComplete:function(){this.dispatchEvent("onComplete",{})},_onReviseComplete:function(t){var u="NewVersionWebInWinResults";var r=[];if(t!==undefined&&t!==null&&t.hasOwnProperty("results")&&t.results.hasOwnProperty("length")&&t.results.length>0){for(var s=0;s<t.results.length;s++){r.push({argname:"revised_physicalid"+s,argvalue:t.results[s].physicalid})}}var q=b.createJSONArrayArg(u,r);if(q.length>0){this.options.webToWinComSocket.dispatchEvent("onDispatchToWin",{notif_name:"onCtxMenuClick",notif_parameters:q},"lf_web_in_win")}this.options.webToWinComSocket.dispatchEvent("onDispatchToWin",{notif_name:"ClosePanel",notif_parameters:"ClosePanel"},"lf_web_in_win")},_onCancel:function(){var r={severity:"warning",message:"Revise canceled"};var q=b.createJSONArrayMessage("onDisplayErrorMessage",r);if(q.length>0){this.options.webToWinComSocket.dispatchEvent("onDispatchToWin",{notif_name:"onDisplayErrorMessage",notif_parameters:q},"lf_web_in_win");this.options.webToWinComSocket.dispatchEvent("onDispatchToWin",{notif_name:"ClosePanel",notif_parameters:"ClosePanel"},"lf_web_in_win")}},setObjects:function(t){var r=this;if(t.length===0){throw c.noObject}t.forEach(function(u){if(u.hasOwnProperty("physicalid")&&(u.physicalid===""||!UWA.is(u.physicalid))){throw c.epmtyPhysicalId}r.physicalIds.push(u.physicalid);if(r.tenant===null){r.tenant=u.tenant;r.commandManager.setTenant(r.tenant)}});this.commandManager.addEvent("onCompleteGetOptions",function(y){this.reviseOptions=y;var v=r.reviseOptions.objects;for(var w=0;w<v.length;++w){var x=v[w];if(x["type.property[IPML.NonLinearVersioningAvailability].value"]){this.useNLV=true}var u=x.CADOrigin||"CATIAV5";var z="";if(u==="CATIAV5"){z=":!"}r.IllegalCharMapping.addCADType(u,z)}console.log("BEGIN: Getting illegal char mappings");this.IllegalCharMapping.getMappings().then(function(A){console.log("END: Getting illegal char mappings");r.illegalChars=A.find("CATIAV5")||"";if(r.isMultipleSelection){r._verifyMultipleSelection(t);r.objectsList.setObjects(t)}else{r.dispatchEvent("onReady",{})}})},this);try{var s=this;document.body.style.cursor="wait";var q={data:[{physicalid:this.physicalIds[0]}],command:"revise"};this.commandManager.getOptions(q,function(u){s.showError(u);s._onComplete()})}finally{document.body.style.cursor="default"}},_createObjectsList:function(){this.objectListDiv=UWA.createElement("div",{"class":"revise-objectList"});this.objectsList=new k({className:"objectlist-Revise",showDisplayNameColumn:false,showNameColumn:true,showRevisionColumn:true});this.objectsList.inject(this.objectListDiv)},_verifyMultipleSelection:function(r){var q=this;var s=function(v){if(v===null||v.length===0){q.showNotification(c.objectNotFound)}else{var w=v.some(function(y){return y.baseType&&y.baseType!=="PLMEntity"});var t=function(A,z,y){return y.some(function(B){return(A.physicalid!=B.physicalid&&A.versionid==B.versionid)})};var u=v.filter(t);if(!w&&u.length==0){q.dispatchEvent("onReady",{})}else{if(w){q.showError(c.multipleSelectionTypes)}else{u.sort(function(z,y){if(z.displayName<y.displayName){return -1}if(z.displayName>y.displayName){return 1}return 0});var x=c.multObjsSameFamily+"<br>";u.forEach(function(A,z,y){x+=A.displayName;if(z<y.length-1){x+="<br>"}});q.showError(x)}q._onComplete()}}};e.getSecurityContextPromise(this.tenant).then(function(t){q._attributeListRequest(r,t,s)})["catch"](function(t){q.showError(t)})},_attributeListRequest:function(u,t,w){document.body.style.cursor="wait";var s=this;var r=["baseType","logicalid","versionid"];var q={data:u,attributes:r};var v=d.get3DSpaceWSUrl(this.tenant,"/resources/lifecycle/product/attributeList",null);n.authenticatedRequest(v,{method:"POST",type:"json",headers:d.getHeaders(t),timeout:600000,data:JSON.stringify(q),onComplete:function(y){document.body.style.cursor="default";var x=y.results;w(x)},onFailure:function(x,y){document.body.style.cursor="default";console.log("verifyMultipleSelection:Failure..."+x);s.showError(e.parseWebServiceError(x,y));s._onComplete()},ontimeout:function(){document.body.style.cursor="default";console.log("verifyMultipleSelection: A connection timeout occured.");s.showError(c.timeout);s._onComplete()}})},_strContainsIllegalChars:function(r,q){if(r){if(p.commonChar(r,q,true)>0){return true}}return false},_strIsLegal:function(q){return !this._strContainsIllegalChars(q,this.illegalChars)},_verifyTitles:function(q){if(q.some(function(r){return !this._strIsLegal(r.title)},this)){this.showError(c.replace(c.illegalTitle,{illegalChars:this.illegalChars}));return false}return true},_executeNLVRevise:function(q){},_executeRevise:function(w){var t=this;var u={data:[]};this.physicalIds.forEach(function(x){var y={physicalid:x};if(t._newTitles.contains(x)){y.title=t._newTitles.find(x)}u.data.push(y)});if(!this._verifyTitles(u.data)){w(null,false);return}var s=JSON.stringify(u);u.folderid=this.folderId;var r=function(x){document.body.style.cursor="default";w(x,true)};var t=this;if(typeof t.context.getSecurityContext==="function"){var v=t.context.getSecurityContext();var q=v.SecurityContext;t.reviseServiceRequest(u,r,q)}else{e.getSecurityContextPromise(this.tenant).then(function(x){t.reviseServiceRequest(u,r,x)})["catch"](function(x){t.showError(x)})}},showNotification:function(q,s){if(typeof this.context.displayNotification==="function"){var r={eventID:typeof s==="string"?s:"primary",msg:q};this.context.displayNotification(r)}else{alert(q)}},showError:function(r){if(typeof this.context.displayNotification==="function"){var q={eventID:"error",msg:r};this.context.displayNotification(q)}else{alert(r)}},reviseServiceRequest:function(w,r,D){var y=this;console.log("REVISE:");console.log(w);var A=JSON.stringify(w);var q=d.get3DSpaceWSUrl(this.tenant,"/resources/lifecycle/revise/major",null);if(y.useNLV){q=d.get3DSpaceWSUrl(this.tenant,"/resources/v1/dslc/addversions",null);var B="E";var z=[];for(var v=0,x=w.data.length;v<x;v++){var u=[];u.push({semantic:B,id:w.data[v].physicalid});var t=[];if(w.data[v].title){t.push({name:"PLMEntity.V_Name",value:w.data[v].title})}z.push({copyId:w.data[v].physicalid,ancestors:u,attributes:t})}A=JSON.stringify({addRequests:z})}var C=function(H){console.log("revise: COMPLETED");console.log(H);if(y.options!==undefined&&y.options!==null&&y.options.hasOwnProperty("wintop")&&y.options.wintop==true){r(H)}else{r()}var I={created:[],deleted:[],modified:[]};I.context=y.context;var F=w.data;if(H!==undefined&&H!==null&&H.hasOwnProperty("status")&&H.hasOwnProperty("report")){if(H.status==="failure"){if(H.report.length!==0){y.showError(H.report[0].error)}else{y.showError(c.reviseFailed)}return}var L=H.results;var K=y.commandManager.findObjectDerivedFromSelection(L,F);var G=0;K.forEach(function(N){var M=false;if(N.hasOwnProperty("derivedfromphysicalid")){M=true}var O={physicalid:N.physicalid,sourceObjectId:w.data[G].physicalid,operation:"Revise",refreshPSD:M};if(N.hasOwnProperty("folders")){I.refreshFolder=true;O.folders=N.folders}I.created.push(O);++G})}if(y.useNLV&&H!==undefined&&H!==null&&H.hasOwnProperty("addRequests")){var J=H.addRequests;J.forEach(function(N){var M=true;var O={physicalid:N.id,sourceObjectId:N.copyId,operation:"Revise",refreshPSD:M};I.created.push(O)})}y.showNotification(c.reviseSuccessful);i.dispatchEvent("onModification",I);if(typeof y.callback==="function"){y.callback(returnedData)}};var s=function(F,G){r();y.showError(e.parseWebServiceError(F,G));console.log("Failed to retrive data from the server")};var E=function(F){r();y.showError(c.timeout);console.log("Timeout error")};document.body.style.cursor="wait";n.authenticatedRequest(q,{method:"POST",headers:d.getHeaders(D),timeout:600000,onComplete:C,data:A,ontimeout:E,onFailure:s,type:"json"})}});return m});