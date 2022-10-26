define("DS/NewBranchWidget/NewBranchObjectList2",["i18n!DS/NewBranchWidget/assets/nls/NewBranchObjectListNls","UWA/Core","UWA/Controls/Abstract","DS/Controls/LineEditor"],function(c,d,e,a){var b=e.extend({defaultOptions:{className:"newbranch-objectlist",showProposedRevisionColumn:false},objectsTableBody:null,init:function(f){this._parent(f);this.buildSkeleton()},buildSkeleton:function(){var j=this.options;var f=d.createElement("table",{"class":j.className+" table table-striped table-condensed",id:"tableNames"});this.elements.container=f;var i=d.createElement("thead");var h=d.createElement("tfoot");this.objectsTableBody=d.createElement("tbody",{id:"tableBody"});i.inject(f);this.objectsTableBody.inject(f);h.inject(f);var g=[];g.push({tag:"th",text:""});g.push({tag:"th",text:c.title});g.push({tag:"th",text:c.type});if(this.options.showProposedRevisionColumn){g.push({tag:"th",text:c.proposedRevision});g.push({tag:"th",text:c.fromRevision})}else{g.push({tag:"th",text:c.revision})}g.push({tag:"th",text:c.current});var k=d.createElement("tr",{html:g});i.appendChild(k)},setObjects:function(i){var h=this;this.empty();if(h.objectsTableBody!==null){var g=0;var f=0;i.forEach(function(j){var k="";if(j.hasOwnProperty("attribute[PLMEntity.V_Name]")){k=j["attribute[PLMEntity.V_Name]"]}else{k=j.title}if(f<k.length){f=k.length}});i.forEach(function(m){var q=g;g++;if(m.hasOwnProperty("physicalid")){q=m.physicalid}var p=[];var k=d.createElement("td");UWA.createElement("img",{src:m.imageUrl,width:"16px",height:"16px"}).inject(k);p.push(k);var r="";var l=false;if(m.hasOwnProperty("attribute[PLMEntity.V_Name]")){r=m["attribute[PLMEntity.V_Name]"];l=true}else{r=m.title}var s=d.createElement("div");var k=d.createElement("td");s.inject(k);var o=new a({placeholder:r,value:r,sizeInCharNumber:f+5,displayClearFieldButtonFlag:true,id:q});o.inject(s);o.addEventListener("change",function(t){if(o.value===r){if(l&&m.hasOwnProperty("vnameChanged")){delete m.vnameChanged}else{if(m.hasOwnProperty("titleChanged")){delete m.titleChanged}}}else{if(o.value===""){if(l&&m.hasOwnProperty("vnameChanged")){delete m.vnameChanged}else{if(m.hasOwnProperty("titleChanged")){delete m.titleChanged}}o.setProperties({placeholder:r,value:r})}else{if(l){m.vnameChanged=o.value}else{m.titleChanged=o.value}}}});p.push(k);p.push({tag:"td",text:m.type});if(h.options.showProposedRevisionColumn){if(m.hasOwnProperty("proposedRevision")){var j=m.proposedRevision;var s=d.createElement("div");var k=d.createElement("td");s.inject(k);var o=new a({placeholder:j,value:j,sizeInCharNumber:j.length+5,displayClearFieldButtonFlag:true,id:q});o.inject(s);o.addEventListener("change",function(t){if(o.value===j){if(m.hasOwnProperty("revisionChanged")){delete m.revisionChanged}}else{if(o.value===""){if(m.hasOwnProperty("revisionChanged")){delete m.revisionChanged}o.setProperties({placeholder:j,value:j})}else{m.revisionChanged=o.value}}});p.push(k)}else{p.push({tag:"td",text:""})}}p.push({tag:"td",text:m.revision});p.push({tag:"td",text:m.current});var n=d.createElement("tr",{html:p,id:q});h.objectsTableBody.appendChild(n)})}},empty:function(){if(this.objectsTableBody!==null){while(this.objectsTableBody.firstChild){this.objectsTableBody.removeChild(this.objectsTableBody.firstChild)}}}});return b});define("DS/NewBranchWidget/NewBranchObjectProp",["i18n!DS/NewBranchWidget/assets/nls/NewBranchObjectListNls","i18n!DS/NewBranchWidget/assets/nls/NewBranchWidgetNls","UWA/Core","UWA/Controls/Abstract","DS/EditPropWidget/facets/Properties/Properties","DS/EditPropWidget/models/EditPropAttributeModel","DS/EditPropWidget/models/EditPropModel",],function(e,b,g,h,f,a,d){var c=h.extend({defaultOptions:{className:"newbranch-objectlist",showProposedRevisionColumn:false,editable:true},propUI:null,init:function(i){this._parent(i);this.container=UWA.createElement("div",{name:"newbranch_prop","class":"newbranch_prop","data-rec-id":"newbranch_prop_rec-id"})},model:null,_currentIntent:null,isIntentModified:function(){if(this.model==null){return false}var j=null;var i=this.model.getChangedValues();if(i.hasOwnProperty("intentsList")){j=i.intentsList}if(j!==null){return j.modified}return false},getIntent:function(){return this._currentIntent},_onObjectAttributeValueHasChanged:function(k,m,j,l,i){if(i&&!k.hasOwnProperty("modifiedAttributes")){return}if(!k.hasOwnProperty("modifiedAttributes")){k.modifiedAttributes={}}if(i&&k.modifiedAttributes.hasOwnProperty(j)){delete k.modifiedAttributes[j];if(Object.getOwnPropertyNames(k.modifiedAttributes).length==0){delete k.modifiedAttributes}}else{k.modifiedAttributes[j]=l}},setObject:function(D,u,w){var C=0;var B=44;var s=24;this.options.showProposedRevisionColumn=true;var A={};var q=this;var y=[];if(D.hasOwnProperty("attributes_mask")){y=D.attributes_mask}var i="";var x=true;if(D.hasOwnProperty("attribute[PLMEntity.V_Name]")){i=D["attribute[PLMEntity.V_Name]"];y.forEach(function(E){if(E.selectable=="attribute[PLMEntity.V_Name]"&&E.readOnly===true){x=false}})}else{if(D.hasOwnProperty("Title")){i=D.Title;y.forEach(function(E){if(E.selectable=="Title"&&E.readOnly===true){x=false}})}}if(D.hasOwnProperty("modifiedAttributes")){if(D.modifiedAttributes.hasOwnProperty("PLMEntity.V_Name")){i=D.modifiedAttributes["PLMEntity.V_Name"]}else{if(D.modifiedAttributes.hasOwnProperty("Title")){i=D.modifiedAttributes.Title}}}if(x){var j=new a({name:"title",path:"title",label:e.title,valueDB:i,readOnly:false});A[j.name]=j;C=C+B}else{var j=new a({name:"title",path:"title",label:e.title,value:i});A[j.name]=j;C=C+s}if(this.options.showProposedRevisionColumn){var v=D.proposedRevision;if(D.hasOwnProperty("modifiedAttributes")&&D.modifiedAttributes.hasOwnProperty("revision")){v=D.modifiedAttributes.revision}var k=false;y.forEach(function(E){if(E.selectable=="revision"&&E.readOnly===false){k=true}});if(!k){var t=new a({name:"proposedRevision",path:"proposedRevision",label:e.proposedRevision,value:v});A[t.name]=t;C=C+s}else{var t=new a({name:"proposedRevision",path:"proposedRevision",label:e.proposedRevision,valueDB:v,readOnly:false,});A[t.name]=t;C=C+B}var l=new a({name:"fromRevision",path:"fromRevision",label:e.fromRevision,value:D.revision});A[l.name]=l;C=C+s}else{var r=new a({name:"fromRevision",path:"fromRevision",label:e.fromRevision,value:D.revision});A[r.name]=r;C=C+s}var o={};y.forEach(function(H){if(H.selectable=="revision"){return}if(H.selectable=="attribute[PLMEntity.V_Name]"){return}if(H.selectable=="Title"){return}var G="";var F=false;if(H.hasOwnProperty("value")){G=H.value}if(H.hasOwnProperty("readOnly")){F=!H.readOnly}if(D.hasOwnProperty("modifiedAttributes")&&D.modifiedAttributes.hasOwnProperty(H.path)){G=D.modifiedAttributes[H.path]}o[H.selectable]=H.path;if(!F){var E=new a({name:H.selectable,path:H.selectable,label:H.nls,value:G});A[E.name]=E;C=C+s}else{var E=new a({name:H.selectable,path:H.selectable,label:H.nls,valueDB:G,readOnly:false,});A[E.name]=E;C=C+B}});if(u.length>0){var m=[];var n=[];u.forEach(function(E){m.push(E.operation);n.push(E.nls)});if(w!==null){this._currentIntent=w}else{this._currentIntent=m[0]}var p=new a({name:"intentsList",path:"intentsList",label:b.IntentSelection,authorizedValues:m,authorizedValuesNLS:n,valueDB:this._currentIntent,readOnly:false});A[p.name]=p;C=C+B}this.model=new d();this.model.set(A);var z=false;if(this.propUI!==null){z=true}if(!z){this.propUI=new f({setCloseButton:false,editMode:this.options.editable,readOnly:!this.options.editable})}this.propUI.initData([this.model]);this.model.clearChangedValue();if(!z){this.propUI.elements.container.setStyle("height",C+"px");this.propUI.elements.container.setStyle("min-width","500px");this.propUI.inject(this.container)}this.model.addEvent("onChangeAttributes",function(F,E){E.forEach(function(G){if(G.name==="intentsList"){if(G.valueDB!==q._currentIntent){q.dispatchEvent("onIntentChanged")}q._currentIntent=G.valueDB}else{if(G.name==="title"&&D.hasOwnProperty("attribute[PLMEntity.V_Name]")){q._onObjectAttributeValueHasChanged(D,D.physicalid,"PLMEntity.V_Name",G.valueDB,false)}else{if(G.name==="title"&&D.hasOwnProperty("Title")){q._onObjectAttributeValueHasChanged(D,D.physicalid,"Title",G.valueDB,false)}else{if(G.name==="proposedRevision"){q._onObjectAttributeValueHasChanged(D,D.physicalid,"revision",G.valueDB,false)}else{q._onObjectAttributeValueHasChanged(D,D.physicalid,o[G.name],G.valueDB,false)}}}}})})},});return c});define("DS/NewBranchWidget/NewBranchObjectList",["i18n!DS/NewBranchWidget/assets/nls/NewBranchObjectListNls","UWA/Core","UWA/Controls/Abstract"],function(b,c,d){var a=d.extend({defaultOptions:{className:"newbranch-objectlist",showProposedRevisionColumn:false},objectsTableBody:null,init:function(e){this._parent(e);this.buildSkeleton()},buildSkeleton:function(){var i=this.options;var e=c.createElement("table",{"class":i.className+" table table-striped table-condensed",id:"tableNames"});this.elements.container=e;var h=c.createElement("thead");var g=c.createElement("tfoot");this.objectsTableBody=c.createElement("tbody",{id:"tableBody"});h.inject(e);this.objectsTableBody.inject(e);g.inject(e);var f=[];f.push({tag:"th",text:""});f.push({tag:"th",text:b.title});f.push({tag:"th",text:b.type});if(this.options.showProposedRevisionColumn){f.push({tag:"th",text:b.proposedRevision});f.push({tag:"th",text:b.fromRevision})}else{f.push({tag:"th",text:b.revision})}f.push({tag:"th",text:b.current});var j=c.createElement("tr",{html:f});h.appendChild(j)},setObjects:function(f){var e=this;this.empty();if(e.objectsTableBody!==null){f.forEach(function(h){if(h.hasOwnProperty("visible")&&h.visible==false){return}var g=[];var j=c.createElement("td");UWA.createElement("img",{src:h.imageUrl,width:"16px",height:"16px"}).inject(j);g.push(j);if(h.hasOwnProperty("attribute[PLMEntity.V_Name]")){g.push({tag:"td",text:h["attribute[PLMEntity.V_Name]"]})}else{g.push({tag:"td",text:h.title})}g.push({tag:"td",text:h.type});if(e.options.showProposedRevisionColumn){if(h.hasOwnProperty("proposedRevision")){g.push({tag:"td",text:h.proposedRevision})}else{g.push({tag:"td",text:""})}}g.push({tag:"td",text:h.revision});g.push({tag:"td",text:h.current});var i=c.createElement("tr",{html:g});e.objectsTableBody.appendChild(i)})}},empty:function(){if(this.objectsTableBody!==null){while(this.objectsTableBody.firstChild){this.objectsTableBody.removeChild(this.objectsTableBody.firstChild)}}}});return a});define("DS/NewBranchWidget/NewBranchWidget",["css!DS/NewBranchWidget/NewBranchWidget","UWA/Controls/Abstract","i18n!DS/LifecycleWidget/assets/nls/LifecycleWidgetNls","i18n!DS/NewBranchWidget/assets/nls/NewBranchWidgetNls","DS/LifecycleServices/LifecycleCommandManager","DS/LifecycleServices/LifecycleServices","DS/LifecycleServices/LifecycleServicesSettings","DS/WAFData/WAFData","DS/WebToWinInfra/WebToWinCom","DS/WebInWinHelper/WebInWinHelper","DS/UIKIT/Input/Button","DS/Controls/ComboBox","DS/Controls/LineEditor","DS/NewBranchWidget/NewBranchObjectList","DS/NewBranchWidget/NewBranchObjectProp","DS/LifecycleControls/CommandDialog","DS/LifecycleCmd/MessageMediator"],function(r,m,k,o,l,a,p,b,g,i,j,f,q,h,n,e,c){var d=m.extend({odtmode:false,wintop:false,selectionList:null,objectsList:null,intentsList:null,isThereLinearData:null,nbDisplayedObjects:0,context:null,tenant:null,folderId:null,objectsListTable:null,objectProp:null,intentsListSel:null,dupStringDiv:null,dupStringInput:null,init:function(u,s,t){this._parent(t);this.selectionList=[];this.objectsList=[];this.intentsList=[];this.context={};this.isThereLinearData=false;this.commandManager=new l();this.container=UWA.createElement("div",{"class":"newbranch_container","data-rec-id":"newbranch_container_rec-id"});this.content=UWA.createElement("div",{"class":"newbranch_content","data-rec-id":"newbranch_content_rec-id"});this.content.inject(this.container);if(t!==undefined&&t!==null&&t.hasOwnProperty("odtmode")){this.odtmode=true}if(t!==undefined&&t!==null&&t.hasOwnProperty("wintop")&&t.wintop==true){this.wintop=true;i.initTenant(this);i.getServices(this);this.webToWinCom_Socket=g.createSocket({socket_id:"WebInWin_NewBranchWidget_Socket_"+Math.floor((Math.random()*100000)+1)});if(typeof this.options.serverUrl!=="undefined"&&this.options.serverUrl.length>0){if(typeof this.options.serverUrl[0].platformId!=="undefined"){var v=this.options.serverUrl[0].platformId;this.tenant=v}}this.footerDiv=UWA.createElement("div",{"class":"newbranch_footer modal-footer","data-rec-id":"newbranch_footer_rec-id"});this.footerDiv.inject(this.container)}},initDatafromWin:function(s){var t=this;var u=[];s.forEach(function(y){var v=y.physicalId;var x=y.name;var w={physicalid:v,name:x,displayName:x};u.push(w)});this.executeCmd(u,{},function(){t._executeCmdEnded()})},onAcceptFromWin:function(){if(this.wintop){this.webToWinCom_Socket.dispatchEvent("onDispatchToWin",{notif_name:"ClosePanel",notif_parameters:"ClosePanel"},"lf_web_in_win")}},onRejectFromWin:function(){if(this.wintop){this.webToWinCom_Socket.dispatchEvent("onDispatchToWin",{notif_name:"ClosePanel",notif_parameters:"ClosePanel"},"lf_web_in_win")}},onRefresh:function(){console.log("onRefresh called from win")},onResize:function(){console.log("onResize called from win")},_executeCmdEnded:function(){if(this.wintop){this.webToWinCom_Socket.dispatchEvent("onDispatchToWin",{notif_name:"ClosePanel",notif_parameters:"ClosePanel"},"lf_web_in_win")}},_logToConsole:function(s){if(this.wintop){this.webToWinCom_Socket.dispatchEvent("onDispatchToWin",{notif_name:"onLogLineToCNEXTOUTPUT",notif_parameters:s},"lf_web_in_win");console.log(s)}else{console.log(s)}},_setWaitingResponse:function(){if(this.widget!==undefined&&this.widget!==null){this.widget.body.style.cursor="wait"}else{document.body.style.cursor="wait"}},_setEndWaitingResponse:function(){if(this.widget!==undefined&&this.widget!==null){this.widget.body.style.cursor="default"}else{document.body.style.cursor="default"}},executeCmd:function(t,s,x){var u=this;this.addEvent("onReady",function(y){u._showCommandUI()});this.addEvent("onComplete",function(y){x()});if(s.hasOwnProperty("context")){this.context=s.context}this.folderId=s.targetFolderId;try{if(p.getActiveFolder!==undefined){var v=p.getActiveFolder();if(v.id!==null){this.folderId=v.id;this.securityContex=v.sc!==""&&v.sc!==undefined?v.sc:this.securityContex;require(["DS/PlatformAPI/PlatformAPI"],function(y){y.publish("FolderEditor.ActiveFolderCallBack",{id:v.id,label:v.label})})}}}catch(w){this.folderId=s.targetFolderId;this.securityContex=p.getCurrentFolderSecurityContext()}if(t.length===0){throw k.noObject}t.forEach(function(y){if(!y.hasOwnProperty("physicalid")||y.physicalid===""){throw k.epmtyPhysicalId}if(u.tenant===null){u.tenant=y.tenant;u.commandManager.setTenant(u.tenant)}});a.getSecurityContextPromise(this.tenant).then(function(y){u._verifyAndSetObjects(t,y)})["catch"](function(y){u.showError(y)})},_verifyAndSetObjects:function(D,E){this._setWaitingResponse();var B=this;this.selectionList=D;var x=[];var t=[];var w=[];var v=false;if(!this.wintop&&this.context!==undefined&&this.context!==null&&typeof this.context.getSelectedNodes==="function"){var s=this.context.getSelectedNodes();var A=function(G){if(typeof G.getID!=="function"){return false}var H=false;s.forEach(function(I){if(typeof I.getID!=="function"){return}if(G.getID()==I.getID()){H=true}});return H};var u=function(H){if(H==null||H==undefined){return false}if(typeof H.getParent!=="function"){return true}var G=H.getParent();if(A(G)){return false}return true};var C=function(I){if(I==null||I==undefined){return I}if(typeof I.getParent!=="function"){return I}if(t.hasOwnProperty(I.getID())){return t[I.getID()]}var G=I.getParent();if(G==null||G==undefined||typeof G.getID!=="function"){t[I.getID()]=I;w[I.getID()]=I.getID();return I}if(A(G)){var H=C(G);t[I.getID()]=H;w[I.getID()]=H.getID();return H}t[I.getID()]=I;w[I.getID()]=I.getID();return I};if(this.selectionList.length>1&&s.length>0){v=true}s.forEach(function(I){if(!v){return}if(I==null||I==undefined){v=false;return}if(typeof I.getID!=="function"){v=false;return}var H=I.getID();var J=false;B.selectionList.forEach(function(K){if(H==K){J=true}});if(!J){v=false;return}if(u(I)){x[I.getID()]=true}else{x[I.getID()]=false}var G=C(I);t[I.getID()]=G;w[I.getID()]=G.getID()})}var z=["baseType","current","attribute[PLMEntity.V_Name]","Title","displayName"];if(this.wintop){z.push("imageUrl")}var y={data:this.selectionList,attributes:z};var F=p.get3DSpaceWSUrl(this.tenant,"/resources/lifecycle/newbranch/prepare_newbranch",null);b.authenticatedRequest(F,{method:"POST",type:"json",headers:p.getHeaders(E),timeout:600000,data:JSON.stringify(y),onComplete:function(K){B._logToConsole("PREPARE BRANCH:");B._logToConsole(K);B._setEndWaitingResponse();var J=null;if(K.hasOwnProperty("results")){J=K.results}var I=[];if(K.hasOwnProperty("intents")&&K.intents!==undefined&&K.intents!==null){I=K.intents}var H=false;if(K.hasOwnProperty("status")&&K.status==="error"&&K.hasOwnProperty("report")){var G=K.report;if(G.length>0&&G[0].hasOwnProperty("message")){B.showNotification(G[0].message)}B._onComplete()}else{if(J===null||J.length===0){B.showNotification(k.objectNotFound);B._onComplete()}else{var M=true;var L=true;J.forEach(function(O){if(!O.hasOwnProperty("physicalid")||O.physicalid===""){M=false}var N=false;if(O.hasOwnProperty("nlvCompatible")&&O.nlvCompatible===true){N=true}else{H=true}if(!N&&(!O.hasOwnProperty("EvolutionAvailability")||O.EvolutionAvailability!=="Yes")){L=false}if(v){if(O.hasOwnProperty("physicalid")&&x.hasOwnProperty(O.physicalid)&&x[O.physicalid]){O.isRoot=true}else{O.isRoot=false}}if(O.hasOwnProperty("visible")&&O.visible==true){B.nbDisplayedObjects++}});if(B.nbDisplayedObjects<=0){B.showNotification(k.objectNotFound);B._onComplete()}else{if(M&&L){B.objectsList=J;B.intentsList=I;B.isThereLinearData=H;B.dispatchEvent("onReady",{})}else{if(!M){B.showError(k.epmtyPhysicalId);B._onComplete()}else{if(!L){if(J.length==1){B.showError(k.evolutionAvailabilityFalseMonoSelection)}else{B.showError(k.evolutionAvailabilityFalseMultiSelection)}B._onComplete()}}}}}}},onFailure:function(G,H){B._setEndWaitingResponse();B._logToConsole("verifyMultipleSelection:Failure..."+G);B.showError(a.parseWebServiceError(G,H));B._onComplete()},ontimeout:function(){B._setEndWaitingResponse();B._logToConsole("verifyMultipleSelection: A connection timeout occured.");B.showError(k.timeout);B._onComplete()},})},_onComplete:function(){this.dispatchEvent("onComplete",{})},_showCommandUI:function(){var x=this;var y=this.content;var s=UWA.createElement("div",{"class":"newbranch-objectsList"});s.inject(y);var A={className:"objectlist-newbranch"};if(x.nbDisplayedObjects>1){if(this.intentsList.length>0){A.showProposedRevisionColumn=true}this.objectsListTable=new h(A);this.objectsListTable.inject(s);this.objectsListTable.setObjects(x.objectsList)}else{this.objectProp=new n(A);this.objectProp.inject(s);this.objectsList.forEach(function(E){if(!E.hasOwnProperty("modifiedAttributes")){E.modifiedAttributes={}}if(E.hasOwnProperty("attribute[PLMEntity.V_Name]")&&!E.modifiedAttributes.hasOwnProperty("PLMEntity.V_Name")){E.modifiedAttributes["PLMEntity.V_Name"]=E["attribute[PLMEntity.V_Name]"]}if(E.hasOwnProperty("Title")&&!E.modifiedAttributes.hasOwnProperty("Title")){E.modifiedAttributes.Title=E.Title}if(!E.hasOwnProperty("attributes_mask")){E.attributes_mask=[]}var F=false;var D=false;E.attributes_mask.forEach(function(G){if(G.selectable=="attribute[PLMEntity.V_Name]"){F=true}if(G.selectable=="Title"){D=true}});if(!F&&E.hasOwnProperty("nlvCompatible")&&E.nlvCompatible===true){E.attributes_mask.push({selectable:"attribute[PLMEntity.V_Name]",readOnly:true})}if(!D&&E.hasOwnProperty("nlvCompatible")&&E.nlvCompatible===true){E.attributes_mask.push({selectable:"Title",readOnly:true})}});this.objectProp.setObject(this.objectsList[0],this.intentsList,null);this.objectProp.addEvent("onIntentChanged",function(){a.getSecurityContextPromise(x.tenant).then(function(D){x._onItentSeletion(D)})["catch"](function(D){x.showError(D)})})}if(this.nbDisplayedObjects>1&&this.isThereLinearData){this.dupStringDiv=UWA.createElement("div",{"class":"newbranch-dupString","data-rec-id":"newbranch-dupStringDiv"});this.dupStringDiv.inject(y);new UWA.Element("text",{text:o.Prefix,"class":"newbranch-dupstring_title"}).inject(this.dupStringDiv);var t=UWA.createElement("div",{"class":"newbranch-dupstring_input","data-rec-id":"newbranch-dupStringInputDiv"});t.inject(this.dupStringDiv);this.dupStringInput=new q({"class":"newbranch_dupstring_input",recId:"newbranch-dupStringInput"});this.dupStringInput.inject(t);this.dupStringDiv.style.display="none";this.dupStringDiv.style.display="block"}if(this.nbDisplayedObjects>1&&this.intentsList.length>0){var B=UWA.createElement("div",{"class":"newbranch-intentsList"});B.inject(y);new UWA.Element("text",{text:o.IntentSelection}).inject(B);var v=[];this.intentsList.forEach(function(D){v.push({labelItem:D.nls,valueItem:D.operation})});this.intentsListSel=new f({elementsList:v,selectedIndex:0,recId:"newbranch-intentInput"});this.intentsListSel.inject(B);this.intentsListSel.addEventListener("change",function(){a.getSecurityContextPromise(x.tenant).then(function(D){x._onItentSeletion(D)})["catch"](function(D){x.showError(D)})})}if(!this.wintop){var w=new e();var z=w.create(y,{title:o.CommandDialogTitle,closeButton:true,resizable:true,imageUrl:this.selectionList[0].imageUrl||"",onOk:function(){x._executeNewBranch(function(D){w.destroy();x._onComplete()})},onClose:function(){x._onComplete()}});z.inject(widget.body);z.setNewSize({})}else{var u=new j({value:o.BtnOK,recId:"NewBranchButtonOk_rec-id",name:"NewBranchButtonOk",className:"default medium primary"});var C=new j({value:o.BtnCancel,recId:"NewBracnButtonCancel_rec-id",name:"NewBracnButtonCancel",className:"default medium"});u.inject(this.footerDiv);C.inject(this.footerDiv);u.addEvents({onClick:function(){x.onAcceptFromWin()}});C.addEvents({onClick:function(){x.onRejectFromWin()}});this.onAcceptFromWin=function(){x._executeNewBranch(function(D,E){x._onComplete()})}}},_onItentSeletion:function(t){this._setWaitingResponse();var s=this;var u=this._computeRequest({reason:"proposals_newbranch"});var v=p.get3DSpaceWSUrl(this.tenant,"/resources/lifecycle/newbranch/proposals_newbranch",null);b.authenticatedRequest(v,{method:"POST",type:"json",headers:p.getHeaders(t),timeout:600000,data:JSON.stringify(u),onComplete:function(y){s._logToConsole("BRANCH INTENT CHANGED:");s._logToConsole(y);s._setEndWaitingResponse();var x=y.results;if(x===null||x.length===0){s.showNotification(k.objectNotFound)}else{var w={};x.forEach(function(A){if(A.hasOwnProperty("proposedRevision")&&A.hasOwnProperty("physicalid")){w[A.physicalid]=A.proposedRevision}});s.objectsList.forEach(function(A){if(w.hasOwnProperty(A.physicalid)&&A.hasOwnProperty("proposedRevision")){A.proposedRevision=w[A.physicalid]}});if(s.nbDisplayedObjects>1){if(s.objectsListTable!==null){s.objectsListTable.setObjects(s.objectsList)}}else{if(s.objectProp!==null){var z=s.objectProp.getIntent();s.objectProp.setObject(s.objectsList[0],s.intentsList,z)}}}},onFailure:function(w,x){s._setEndWaitingResponse();s._logToConsole("verifyMultipleSelection:Failure..."+w);s.showError(a.parseWebServiceError(w,x));s._onComplete()},ontimeout:function(){s._setEndWaitingResponse();s._logToConsole("verifyMultipleSelection: A connection timeout occured.");s.showError(k.timeout);s._onComplete()},})},_onCancel:function(){var t={severity:"warning",message:"NewBranch canceled"};var s=g.createJSONArrayMessage("onDisplayErrorMessage",t);if(s.length>0){this.webToWinCom_Socket.dispatchEvent("onDispatchToWin",{notif_name:"onDisplayErrorMessage",notif_parameters:s},"lf_web_in_win");this.webToWinCom_Socket.dispatchEvent("onDispatchToWin",{notif_name:"ClosePanel",notif_parameters:"ClosePanel"},"lf_web_in_win")}},_computeRequest:function(s){var t=this;var u={data:[]};this.objectsList.forEach(function(v){var w={physicalid:v.physicalid};if(v.hasOwnProperty("modifiedAttributes")&&Object.getOwnPropertyNames(v.modifiedAttributes).length>0){w.modifiedAttributes=v.modifiedAttributes}u.data.push(w)});if(this.objectProp!==null&&this.nbDisplayedObjects==1){u.intent=this.objectProp.getIntent();u.prefix="";u.duplication_string=""}else{if(this.intentsListSel!==null){u.intent=this.intentsListSel.currentValue}if(this.dupStringInput!==null){u.prefix=this.dupStringInput.value;u.duplication_string=u.prefix}}if(s.reason==="newbranch"&&this.folderId!==null){u.folderid=this.folderId}return u},_executeNewBranch:function(y){var v=this;var w=this._computeRequest({reason:"newbranch"});var u=JSON.stringify(w);var t=function(z){v._setEndWaitingResponse();y(z)};var v=this;if(typeof v.context.getSecurityContext==="function"){var x=v.context.getSecurityContext();var s=x.SecurityContext;v.newBranchServiceRequest(w,t,s)}else{a.getSecurityContextPromise(this.tenant).then(function(z){v.newBranchServiceRequest(w,t,z)})["catch"](function(z){v.showError(z)})}},showNotification:function(s){if(this.wintop){this.webToWinCom_Socket.dispatchEvent("onDispatchToWin",{notif_name:"onDisplayErrorMessage",notif_parameters:{severity:"warning",message:s}},"lf_web_in_win")}else{if(typeof this.context.displayNotification==="function"){var t={eventID:"primary",msg:s};this.context.displayNotification(t);this._logToConsole(s)}else{this._logToConsole(s)}}},showError:function(t){if(this.wintop){this.webToWinCom_Socket.dispatchEvent("onDispatchToWin",{notif_name:"onDisplayErrorMessage",notif_parameters:{severity:"error",message:t}},"lf_web_in_win")}else{if(typeof this.context.displayNotification==="function"){var s={eventID:"warning",msg:t};this.context.displayNotification(s);this._logToConsole(t)}else{this._logToConsole(t)}}},newBranchServiceRequest:function(v,t,z){this._setWaitingResponse();var w=this;this._logToConsole("NEW BRANCH:");this._logToConsole(v);var x=JSON.stringify(v);var s=p.get3DSpaceWSUrl(this.tenant,"/resources/lifecycle/newbranch/execute_newbranch",null);var y=function(C){w._logToConsole("NEW BRANCH: COMPLETED");w._logToConsole(C);if(C!==undefined&&C!==null&&C.hasOwnProperty("status")&&C.hasOwnProperty("report")){if(C.status==="failure"){if(C.report.length>0){var B=[];w.selectionList.forEach(function(G){B[G.physicalid]=G.displayName});C.report.forEach(function(G){if(G.hasOwnProperty("physicalids")){var J="";for(var I=0;I<G.physicalids.length;I++){var H=G.physicalids[I];if(B.hasOwnProperty(H)){J+=B[H];if(I===G.physicalids.length-1){J+=":\n"}else{J+=",\n"}}}J+=G.error;w.showError(J)}else{w.showError(G.error)}})}else{w.showError(k.newBranchFailed)}t();return}}w.showNotification(k.newBranchSuccessful);var D={created:[],deleted:[],modified:[]};D.context=w.context;var E=[];w.objectsList.forEach(function(G){if(!G.hasOwnProperty("isRoot")||G.isRoot){E[G.physicalid]=true}});var F=C.results;F.forEach(function(G){var I=null;if(G.hasOwnProperty("derivedfromphysicalid")){I=G.derivedfromphysicalid}if(!E.hasOwnProperty(I)){return}var J={physicalid:G.physicalid,sourceObjectId:I,operation:"Duplicate"};var H=[w.folderId];J.folders=H;D.refreshFolder=true;D.created.push(J)});if(w.wintop){w.webToWinCom_Socket.dispatchEvent("onDispatchToWin",{notif_name:"WebToWinAction",notif_parameters:{action:"WebToWinAction_AfterNewBranch",data:D}},"lf_web_in_win");console.log("NEW BRANCH, after WebToWinAction_AfterNewBranch:");console.log(D)}else{c.dispatchEvent("onModification",D);console.log("NEW BRANCH, after onModification:");console.log(D)}t()};var u=function(B,C){w.showError(a.parseWebServiceError(B,C));w._logToConsole("Failed to retrieve data from the server");w._logToConsole(C);t()};var A=function(B){w.showError(k.timeout);w._logToConsole("Timeout error");t()};b.authenticatedRequest(s,{method:"POST",headers:p.getHeaders(z),timeout:600000,onComplete:y,data:x,onTimeout:A,onFailure:u,type:"json"})},});return d});