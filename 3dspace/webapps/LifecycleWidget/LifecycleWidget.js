function mock(b,a){if(!(this instanceof mock)){return new mock(b,a)}this.object=b;this.fn=a;this.orgFn=b[a];return this}mock.prototype={returnValue:function(b){var a=function(){return b};this.object[this.fn]=a;return this},callFake:function(b){var a=this;this.object[this.fn]=function(){var c=Array.prototype.slice.call(arguments);c.push(a);return b.apply(this,c)}}};define("DS/LifecycleWidget/utils/LifecycleAlert",["DS/Logger/Logger","UWA/Class","css!DS/UIKIT/UIKIT.css","DS/UIKIT/Alert"],function(c,b,e,d){var a=b.singleton({name:"lifecycle_alert",_logger:null,_alert:null,_error:null,init:function(){this._logger=c.getLogger(a);_alert=null;_error=null},resetContainer:function(f){this._logger.log("resetContainer");if(!f){throw new Error("Invalid Container")}this._alert=new d({className:this.name,closable:true,visible:true,autoHide:true,hideDelay:3000}).inject(f,"top");this._error=new d({className:this.name,closable:true,visible:true,autoHide:false}).inject(f,"top")},setContainer:function(f){this._logger.log("setContainer");if(this._alert){throw new Error("LifecycleAlert Container already set")}if(!f){throw new Error("Invalid Container")}this.resetContainer(f)},displayNotification:function(f){this._logger.log("displayNotification");if(this._alert===null){throw new Error("LifecycleAlert Container has not been set")}if(!f.msg){console.error("displayNotification: message has not been set");return}var g=f.msg;if(typeof g.replace==="function"){g=g.replace(/(?:\r\n|\r|\n)/g,"<br />")}if(f.eventID==="warning"){this._error.add({className:f.eventID,message:g})}else{this._alert.add({className:f.eventID?f.eventID:"primary",message:g})}}});return a});define("DS/LifecycleWidget/CommandRouter",["UWA/Class","DS/LifecycleCmd/DuplicateCmd","DS/LifecycleCmd/ReviseCmd","DS/LifecycleCmd/NewBranchCmd","DS/LifecycleCmd/ReviseFromCmd","DS/LifecycleCmd/DeleteCmd","DS/LifecycleCmd/IterationsCmd","DS/LifecycleCmd/MaturityCmd","DS/LifecycleCmd/HistoryCmd"],function(b,h,f,d,i,g,c,e,a){return b.singleton({init:function(){this.router={DeleteHdr:{commandName:"Delete",oldPath:"DS/LifecycleWidget/LifecycleCmd",newPath:"DS/LifecycleCmd/DeleteCmd",cmd:null,factory:function(j){return new g(j)}},RevisionHdr:{commandName:"Revise",oldPath:"DS/LifecycleWidget/LifecycleCmd",newPath:"DS/LifecycleCmd/ReviseCmd",cmd:null,factory:function(j){return new f(j)}},NewBranchHdr:{commandName:"NewBranch",oldPath:"DS/LifecycleWidget/LifecycleCmd",newPath:"DS/LifecycleCmd/NewBranchCmd",cmd:null,factory:function(j){return new d(j)}},ReviseFromHdr:{commandName:"ReviseFrom",oldPath:"DS/LifecycleWidget/LifecycleCmd",newPath:"DS/LifecycleCmd/ReviseFromCmd",cmd:null,factory:function(j){return new i(j)}},DuplicateHdr:{commandName:"Duplicate",oldPath:"DS/LifecycleWidget/LifecycleCmd",newPath:"DS/LifecycleCmd/DuplicateCmd",cmd:null,factory:function(j){return new h(j)}},IterationsHdr:{commandName:"Iterations",oldPath:"DS/LifecycleWidget/LifecycleCmd",newPath:"DS/LifecycleCmd/IterationsCmd",cmd:null,factory:function(j){return new c(j)}},MaturityHdr:{commandName:"Maturity",oldPath:"DS/LifecycleWidget/LifecycleCmd",newPath:"DS/LifecycleCmd/MaturityCmd",cmd:null,factory:function(j){return new e(j)}},HistoryHdr:{commandName:"History",oldPath:"DS/LifecycleWidget/LifecycleCmd",newPath:"DS/LifecycleCmd/HistoryCmd",cmd:null,factory:function(j){return new a(j)}}}},isRoutedCommand:function(j){return this.router.hasOwnProperty(j)},initCommand:function(k){if(!this.router.hasOwnProperty(k.ID)){console.error("Invalid header sent to CommandRouter.initCommand");return}var j=this.router[k.ID];if(j.cmd){console.error("Command "+j.commandName+"already initialized");return}console.warn("Deprecated command path for "+j.commandName+" command.",'Old deprecated path: "'+j.oldPath+'"','Use new path:  "'+j.newPath+'"');j.cmd=j.factory(k)},execute:function(k){if(!this.router.hasOwnProperty(k)){console.error("Invalid header sent to CommandRouter.execute");return}var j=this.router[k];if(!j.cmd){console.error("Command "+j.commandName+"is not initialized");return}j.cmd.execute()}})});define("DS/LifecycleWidget/LifecycleSelection",["UWA/Controls/Abstract"],function(b){var a=b.extend({init:function(c){this.object=c},getLabel:function(){return this.object.displayName},getDisplayName:function(){return this.object.displayName+" "+this.object.revision},getID:function(){return this.object.physicalid},getTenant:function(){return this.object.tenant}});return a});define("DS/LifecycleWidget/DesignMode/mockRequest",["text!DS/LifecycleWidget/DesignMode/MockData/simpleAssy_part1/attributeList.json","text!DS/LifecycleWidget/DesignMode/MockData/simpleAssy_part1/attributeListNewRevFrom.json","text!DS/LifecycleWidget/DesignMode/MockData/simpleAssy_part1/navigate.json","text!DS/LifecycleWidget/DesignMode/MockData/simpleAssy_part1/navigateDup.json","text!DS/LifecycleWidget/DesignMode/MockData/simpleAssy_part1/state.json","text!DS/LifecycleWidget/DesignMode/MockData/simpleAssy_part1/family.json","text!DS/LifecycleWidget/DesignMode/MockData/simpleAssy_part1/links.json","text!DS/LifecycleWidget/DesignMode/MockData/simpleAssy_part1/dupOpts.json","text!DS/LifecycleWidget/DesignMode/MockData/simpleAssy_part1/deleteOpts.json","text!DS/LifecycleWidget/DesignMode/MockData/culasse110/attributeList.json","text!DS/LifecycleWidget/DesignMode/MockData/culasse110/state.json","text!DS/LifecycleWidget/DesignMode/MockData/culasse110/family.json","text!DS/LifecycleWidget/DesignMode/MockData/culasse110/links.json","text!DS/LifecycleWidget/DesignMode/MockData/culasse110/delOptions.json","text!DS/LifecycleWidget/DesignMode/MockData/culasse110/dupOptions.json","text!DS/LifecycleWidget/DesignMode/MockData/culasse110/expand.json","text!DS/LifecycleWidget/DesignMode/MockData/culasse110/expandDup.json","text!DS/LifecycleWidget/DesignMode/MockData/culasse110/expandDupAdvanced.json","text!DS/LifecycleWidget/DesignMode/MockData/culasse110/attributeListNewRevFrom.json","text!DS/LifecycleWidget/DesignMode/MockData/culbuteur/attListNewRevPick1.json","text!DS/LifecycleWidget/DesignMode/MockData/culbuteur/attListNewRevPick2.json","text!DS/LifecycleWidget/DesignMode/MockData/culbuteur/attributeList.json","text!DS/LifecycleWidget/DesignMode/MockData/culbuteur/family.json","text!DS/LifecycleWidget/DesignMode/MockData/culbuteur/links.json","text!DS/LifecycleWidget/DesignMode/MockData/culbuteur/state.json","text!DS/LifecycleWidget/DesignMode/MockData/culbuteur/expand.json","text!DS/LifecycleWidget/DesignMode/MockData/culbuteur/expandPick1.json","text!DS/LifecycleWidget/DesignMode/MockData/culbuteur/expandPick2.json","text!DS/LifecycleWidget/DesignMode/MockData/simpleAssy_part1/securityContext.json","text!DS/LifecycleWidget/DesignMode/MockData/common/enforceFolderLink.json"],function(y,m,r,d,G,s,g,D,j,C,c,l,p,E,u,k,B,f,F,i,x,a,e,A,q,w,v,t,h,b){var o=function(K){var L=0,I,J,H;if(K.length===0){return L}for(I=0,H=K.length;I<H;I++){J=K.charCodeAt(I);L=((L<<5)-L)+J;L|=0}return L};function n(){this.map=[];this.add(-1580602268,y,true);this.add(-1711554991,y,true);this.add(-742845072,y,true);this.add(1834356537,s,false);this.add(684301714,G,true);this.add(-499419683,g,false);this.add(-2023735749,g,false);this.add(716480295,r,true);this.add(-368422264,D,true);this.add(575246942,j,true);this.add(1408127645,C,true);this.add(-850201785,C,true);this.add(1881182438,C,true);this.add(-716167182,l,false);this.add(1391380968,c,true);this.add(-345377001,c,true);this.add(1496977470,c,true);this.add(-626771260,p,false);this.add(-924744780,p,false);this.add(-1550534267,E,true);this.add(-223640063,u,true);this.add(-525842663,k,true);this.add(-1520147171,B,true);this.add(1943635073,F,true);this.add(654572325,f,true);this.add(-1165212465,a,true);this.add(-700969585,a,true);this.add(2110900526,a,true);this.add(-1698767068,e,false);this.add(1148999378,A,false);this.add(-1388157850,A,false);this.add(929462890,q,true);this.add(0,i,true);this.add(0,x,true);this.add(-460782979,w,true);this.add(0,v,true);this.add(0,t,true);this.add(2011935415,h,true);this.add(-1302739405,b,true)}n.prototype={add:function(I,H,J){this.map.push({key:I,data:H,parseJson:J})},find:function(I){var J=this.map.length;for(var H=0;H<J;++H){if(this.map[H].key===I){if(this.map[H].parseJson){return JSON.parse(this.map[H].data)}else{return this.map[H].data}}}return null}};var z={call:function(L,H,I){if(L.indexOf("mocked")==-1){I.orgFn.apply(this,arguments);return}var K;if(H.data!==undefined){K=o(L+H.data)}else{K=o(L)}this.reqMap=this.reqMap||new n();var J=this.reqMap.find(K);if(J==null){console.log("Missing mock data");console.log("hash:",K);console.log("path:",L);console.log("data",H.data);H.onFailure("Mock data not found!\nURL:"+L);return}window.setTimeout(function(){H.onComplete(J)},0)}};return z});define("DS/LifecycleWidget/DesignMode/setup",["DS/LifecycleServices/LifecycleServicesSettings","DS/WAFData/WAFData","DS/LifecycleWidget/DesignMode/mockRequest","DS/i3DXCompassPlatformServices/i3DXCompassPlatformServices","text!DS/LifecycleWidget/DesignMode/MockData/simpleAssy_part1/platformSvc.json"],function(d,b,f,e,c){var a={init:function(){console.log("setup.init()");designModeLC=true;mock(e,"getPlatformServices").callFake(function(g){g.onComplete(JSON.parse(c))});mock(UWA.Data,"request").callFake(function(i,g,h){f.call(i,g,h)});mock(b,"authenticatedRequest").callFake(function(i,g,h){f.call(i,g,h)});d.init();mock(d,"get3DSpaceWSUrl").callFake(function(h,g){return"http://mocked"+g});mock(d,"get3DSpaceBaseUrl").callFake(function(g){return"http://mocked"});mock(d,"getCurrentFolderID").returnValue(42);mock(d,"hasPARRole").callFake(function(g){g(true)})},onLoaded:function(g){console.log("setup.onLoaded()");g.uwaUrl="https://mocked/3DSpace/webapps/LifecycleWidget/LifecycleWidget.html";g.myLifecycleWidget.setObjects([{physicalid:"061AB556976F000053D3465784280A00"}])}};return a});define("DS/LifecycleWidget/LifecycleCmd",["css!DS/LifecycleWidget/LifecycleWidget","DS/ApplicationFrame/Command","DS/LifecycleWidget/CommandRouter"],function(d,b,c){var a=b.extend({name:"lifecycle_actionbar",context:null,init:function(e){if(c.isRoutedCommand(e.ID)){c.initCommand(e)}this._parent(e,{mode:"exclusive",isAsynchronous:false})},execute:function(){if(c.isRoutedCommand(this._id)){c.execute(this._id);return}try{switch(commandHdr){}}catch(f){if(typeof that.context.displayNotification==="function"){var g=f;if(f.hasOwnProperty("message")){g=f.message}var e={eventID:"warning",msg:g};that.context.displayNotification(e)}console.log(f.message)}},});return a});define("DS/LifecycleWidget/LifecycleWidget",["UWA/Controls/Abstract","UWA/Class/Promise","DS/ENO6WPlugins/jQuery","DS/PlatformAPI/PlatformAPI","DS/MaturityWidget/MaturityWidget","DS/ApplicationFrame/ActionBar","DS/LifecycleWidget/LifecycleCmd","DS/HistoryMultiPanel/HistoryMultiPanel","DS/LifecycleWidget/LifecycleSelection","DS/LifecycleServices/LifecycleAlert","DS/ApplicationFrame/CommandsManager","DS/WAFData/WAFData","i18n!DS/LifecycleWidget/assets/nls/LifecycleWidgetNls","UWA/Utils/InterCom","DS/LifecycleServices/LifecycleServicesSettings","DS/LifecycleServices/LifecycleServices","DS/LifecycleServices/LifecycleObjectBlacklist","DS/LifecycleCmd/MessageMediator","DS/HistoryExplorer/ExternalRefresh","DS/RuntimeView/NLSManager"],function(s,g,m,f,n,a,p,t,q,i,c,d,e,l,u,b,v,h,k,o){var r="DS/CfgAuthoringContextUX/scripts/CfgAuthoringContext";var j=s.extend({name:"Lifecycle-container",tenant:null,enovia3dspaceurl:null,collabsharing:false,init:function(z,w,x){this.widget=z;this.widget.lifecycleWidget=this;this.parentWidget=w;var y=this;this.widgetType="LifecycleWidget";if(window.location.href.indexOf("ENOLCMS_AP")>-1){console.log("LifecycleWidget: In Collab Sharing App!!!");y.collabsharing=true}this.droppable=x.droppable;if(typeof x.droppable==="undefined"){this.droppable=true}else{this.droppable=x.droppable}this._parent(x);this.objects=null;this.setTitle(e.lifecycleTitle);this.selectedNodes=[];this.stack=[];this.buildSkeleton();u.app_initialization(function(){y.tenant=u.getTenant();var A=u.getOption("platform_services",null);if(A!==undefined&&A!==null&&A.length>0){if(Array.isArray(A)){A.forEach(function(B){if(B!==undefined&&B!==null&&B.hasOwnProperty("platformId")){b.getSecurityContextList(B.platformId,function(){y.reloadSavedObjects();y.useCompassContent();y.setCurrentWidgetPreferences()})}})}}});require([r])},setCurrentWidgetPreferences:function(){var w=u.getOption(u.getTenant(),null);if(w){widget.addPreference(w);widget.setValue("Current_security_credentials",w.value)}},buildSkeleton:function(){var A=this;var w=this.elements.container=UWA.createElement("div",{"class":this.getClassNames()}).inject(widget.body);this.dropArea=document.createElement("div");this.dropArea.className="lifecycle-main";w.appendChild(this.dropArea);this.droppableArea=document.createElement("div");this.droppableArea.className="lifecycle-filter";this.dropArea.appendChild(this.droppableArea);if(this.droppable===true){this.dropArea.addEventListener("drop",function(O){A.onDrop(O)});this.dropArea.addEventListener("dragover",function(O){A.onDragOver(O)});this.dropArea.addEventListener("dragenter",function(O){A.onDragEnter(O)});this.dropArea.addEventListener("dragleave",function(O){A.onDragLeave(O)})}UWA.createElement("div",{"class":"dropZoneImage fonticon fonticon-download",draggable:"false"}).inject(this.droppableArea);this.droppableTxt=document.createElement("div");this.droppableArea.appendChild(this.droppableTxt);UWA.createElement("text",{"class":"font-3dsregular dropZoneText",text:e.dropHere}).inject(this.droppableTxt);var I=this.lifecycleDiv=document.createElement("div");I.className="lifecycle";this.dropArea.appendChild(I);var K=document.createElement("div");K.className="lifecycle-container maturity";I.appendChild(K);var x=document.createElement("div");x.className="lifecycle-header maturity";var J=document.createElement("div");J.className="lifecycle-expand";x.appendChild(J);x.addEventListener("click",function(Q){var O=document.querySelector("div.lifecycle-content.maturity");var P=O.style.display;if(P==="none"){O.style.display="block";J.className=J.className.replace(" no","")}else{O.style.display="none";J.className=J.className+" no"}});K.appendChild(x);var D=document.createTextNode("Maturity Graph");x.appendChild(D);var C=UWA.Element("div");C.className="lifecycle-content maturity";K.appendChild(C);this.maturityWidget=new n({context:A,type:"lifecycleWidget"});this.maturityWidget.inject(C);var G=document.createElement("div");G.className="lifecycle-container revision";I.appendChild(G);var F=document.createElement("div");F.className="lifecycle-header revision";var M=document.createElement("div");M.className="lifecycle-expand";F.appendChild(M);F.addEventListener("click",function(Q){var O=document.querySelector("div.lifecycle-content.revision");var P=O.style.display;if(P==="none"){O.style.display="block";M.className=M.className.replace(" no","")}else{O.style.display="none";M.className=M.className+" no"}});G.appendChild(F);var L=document.createTextNode("History Explorer");F.appendChild(L);var B=document.createElement("div");B.className="lifecycle-content revision";G.appendChild(B);var y={wintop:false,};var H=this;var z={setObjects:function(P,O,Q){H.setObjectsWithExceptions(P,O,Q)},setTitleFromObject:function(O){H.setTitleFromObject(O)},onDropEvent:function(O){H.onDrop(O)}};this.historyMultiPanel=new t(this,this.widget,this.parentWidget,y,z);var E={load:function(O){H.setObjectsWithExceptions([O],false,false)},clear:function(){H.empty()}};this.externalRefresh=new k(this.historyMultiPanel.revisionFamily,E);this.historyMultiPanel.inject(B);this.widget.onResize=function(){A.historyMultiPanel.revisionFamily.onResize()};var N=A.widget.getValue("lang");if(A.widget.hasOwnProperty("lang")){N=A.widget.lang}o.DEFAULT_LANGUAGE=N;this.addEvent("actionBarCreated",function(){try{A._actionBar.onActionBarReady(function(){A.updateCommands(A.selectedNodes);require(["DS/CompareCmd/CompareCmd"],function(P){},function(P){m(w).find(".wux-afr-cmdstarter[data-command='CompareHdr']").attr("hidden","true");m(w).find(".wux-afr-cmdstarter[data-command='ReviseFromHdr']").attr("hidden","true")})})}catch(O){}});if(Boolean(this.collabsharing)){this._actionBar=new a({context:A,file:"lifecycle_fromlifecycle_cs.xml",module:"LifecycleWidget"}).inject(w);this.dispatchEvent("actionBarCreated",{})}else{u.hasPARRole(function(O){var P="lifecycle_fromlifecycle_cnv.xml";if(O==true){P="lifecycle_fromlifecycle.xml"}A._actionBar=new a({context:A,file:P,module:"LifecycleWidget"}).inject(w);A.dispatchEvent("actionBarCreated",{})})}require(["DS/CfgAuthoringContextUX/scripts/CfgAuthoringContext"],function(P){var O=A.elements.container.querySelector(".lifecycle-content.revision");var Q="show";P.initialize2(O,null,Q,"bottom-right",function(R){A.dispatchEvent("onAuthoringCtxAvailable",R)})});widget.endEdit=this.changeCurrentCredential.bind(this);this._updateUI(false)},changeCurrentCredential:function(w){if(w!==undefined&&w!==null&&w.hasOwnProperty("submitted")){if(w.submitted){if(widget.hasPreference("Current_security_credentials")){var A=widget.getPreference("Current_security_credentials");var y=widget.getValue("Current_security_credentials");if(A.hasOwnProperty("optionsNonNls")&&A.optionsNonNls!==undefined&&A.optionsNonNls!==null&&A.optionsNonNls.length>0){if(A.hasOwnProperty("options")&&A.options!==undefined&&A.options!==null&&A.options.length>0){for(var z=0;z<A.options.length;z++){var x=A.options[z];if(x.hasOwnProperty("value")){if(x.value==y){A.defaultValue=A.options[z].value;A.defaultValueNonNls=A.optionsNonNls[z];A.value=A.defaultValue;widget.addPreference(A);u.setOption(u.getTenant(),{defaultValue:A.defaultValue,defaultValueNonNls:A.defaultValueNonNls,value:A.defaultValue});break}}}}}}}}},_updateUI:function(w){if(w){this.lifecycleDiv.style.display="";this.droppableArea.style.display="none"}else{this.lifecycleDiv.style.display="none";this.droppableArea.style.display="block"}},updateObjectTitle:function(w,x){this.historyMultiPanel.updateObjectTitle(w,x)},refreshFromStack:function(w){var x=this;b.getSecurityContextPromise(this.tenant).then(function(y){x.refreshFromStackReq(w,y)})},refreshFromStackReq:function(w,C){var z=this;var B=u.get3DSpaceWSUrl(this.tenant,"/resources/lifecycle/product/getFirtsValidObjFromStack",null);var x=this.getAttributesId();var A=null;if(w!==undefined&&w!==null&&w.length>0){var y=w[0];if(y!==undefined&&y!==null&&y.hasOwnProperty("id")&&y.id!==undefined&&y.id!==null){A={stack:[y.id],attributes:x}}else{A={stack:y,attributes:x}}}d.authenticatedRequest(B,{type:"json",method:"POST",proxy:"passport",data:UWA.Json.encode(A),headers:u.getHeaders(C),onComplete:function(E){var D=E.results;if(D==null||D.length==0){z.empty()}else{if(D[0]["owner"]=="#DENIED!"){z.empty()}else{z.updateObjects(D)}}},onFailure:function(D){console.log("refreshFromStack: Failure..."+D)},onTimeout:function(){console.log("refreshFromStack: A connection timeout occured.")}});return},getExtendedStack:function(){this.stack=[this.historyMultiPanel.revisionFamily.currentObject];return this.stack},refresh:function(){this.refreshFromStack(this.getExtendedStack())},setTenant:function(w){this.tenant=w;widget.setValue("x3dPlatformId",w);u.setTenant(w)},onDrop:function(A){A.preventDefault();this.selectedNodes=[];this.stack=[];var w=0;var z=UWA.is(A.dataTransfer.types.indexOf,"function")?"indexOf":"contains",C="";var G=["text/searchitems","text/plain","Text"];for(var E=0;E<G.length&&C==="";E++){var D=A.dataTransfer.types[z](G[E]);if((UWA.is(D,"number")&&D>=0)||(UWA.is(D,"boolean")&&D===true)){C=G[E]}}if(C!==""){w=A.dataTransfer.getData(C)}var x=JSON.parse(w);if(u.getTenant()!=x.data.items[0].envId){this.setTenant(x.data.items[0].envId);this.setCurrentWidgetPreferences();var B={eventID:"info",msg:e.currentPlatformHasChanged+x.data.items[0].envId+".\n"+e.currentSecurityContextHasChanged+widget.getValue("Current_security_credentials")};this.displayNotification(B)}if(this.externalRefresh){this.externalRefresh.setTenant(this.tenant)}var y={physicalid:x.data.items[0].objectId,displayName:x.data.items[0].displayName};var F=[];F.push(y);this.setObjects(F)},onDragOver:function(w){w.preventDefault()},onDragEnter:function(w){w.preventDefault()},onDragLeave:function(w){w.preventDefault()},checkBlacklistedTypes:function(x){if(v.isBlacklisted(x)){var w={eventID:"warning",msg:e.objectTypeNotSupported};this.displayNotification(w);return true}return false},updateObjects:function(z,y,A){if(this.checkBlacklistedTypes(z)){return}try{this.historyMultiPanel.setObjects(z,y,A)}catch(w){}try{this.maturityWidget.setObjects(z)}catch(w){console.log("updateObject Error: "+w)}this.updateLifecycleWidget(z);var x=JSON.stringify(z);widget.setValue("Custo_roots_pids",x)},updateLifecycleWidget:function(w){this.objects=w;this.setTitleFromObject(w[0]);this.setSelectedNodes(w);if(this.stack.indexOf(w[0].physicalid)===-1){this.stack=[w[0].physicalid]}},setTitleFromObject:function(x){var w=x.displayName||x["attribute[PLMEntity.V_Name]"];if(x&&w){if((widget.getValue("x3dPlatformId")=="OnPremise")||(typeof widget.getValue("x3dPlatformId")=="undefined")){this.setTitle(w+" "+x.revision)}else{this.setTitle(widget.getValue("x3dPlatformId")+" - "+w+" "+x.revision)}if(this.selectedNodes&&this.selectedNodes[0]&&this.selectedNodes[0].object&&!this.selectedNodes[0].object.displayName){this.selectedNodes[0].object.displayName=w}}},setTitle:function(w){this.widget.setTitle(w)},updateIterationsCommand:function(y){var x=c.getCommand("IterationsHdr",this);if(x==null){return}if(y.length==1){var w=y[0];if(w.type=="CATPart"||w.type=="3DShape"){x.enable()}else{x.disable()}}else{x.disable()}},updateCommands:function(C){var E=this;h.dispatchEvent("LC_CmdMgr_UpdateUI",{getSelectedNodes:function(){var F=E.getSelectedNodes();if(F.length===1&&F[0].object){return[F[0].object]}return[]}});var z=this;var x=false;var A=C.length===1?true:false;if(A){var w=C[0].type;var D=["Workspace","Workspace Vault","Personal Workspace","Folder"];if(D.indexOf(w)!==-1){x=true}}var B=["CompareHdr","ActionBar_Attributes"];B.forEach(function(G){var F=c.getCommand(G,z);if(F){F.enable()}});var y=c.getCommand("CompareHdr",z);if(y){y.setCommandAvailability(y.getEnableCmd())}y=c.getCommand("ListSnapshotsHdr",z);if(y){y.setCommandAvailability(y.getEnableCmd())}y=c.getCommand("CreateSnapshotHdr",z);if(y){y.setCommandAvailability(y.getEnableCmd())}y=c.getCommand("ActionBar_ReserveCmd",z);if(y){z.disableIfNoneSelected(y,C.length)}y=c.getCommand("ActionBar_UnreserveCmd",z);if(y){z.disableIfNoneSelected(y,C.length)}y=c.getCommand("SubscribeHdr",z);if(y){z.disableIfNoneSelected(y,C.length)}y=c.getCommand("UnSubscribeHdr",z);if(y){z.disableIfNoneSelected(y,C.length)}y=c.getCommand("EditSubscribeHdr",z);if(y){z.disableIfNoneSelected(y,C.length)}y=c.getCommand("ActionBar_ChangeOwner",z);if(y){z.disableIfNoneSelected(y,C.length)}y=c.getCommand("ActionBar_AccessRightCmd",z);if(y){z.disableIfNoneSelected(y,C.length)}},disableIfNoneSelected:function(x,w){if(x){if(w===0){x.disable()}else{x.enable()}}},reportSelection:function(x){if(x.length>0){var w=x[0].physicalid;b.getSecurityContext(u.getTenant(),function(z){var y={objectId:w,envId:u.getTenant(),contextId:z};require(["DS/i3DXCompassServices/i3DXCompassPubSub"],function(A){A.publish("setObject",y)});require(["DS/WidgetServices/commandProxy/CommandProxy"],function(B){var A=[w];B.publishSelect({data:{paths:[A]}})})},function(y){console.log("reportSelection ",y)})}},setX3DContent:function(z){var x=[];if(z.length>0){x.push({envId:"",serviceId:"",contextId:"",objectId:z[0].physicalid,objectType:z[0].type,displayName:z[0].displayName})}var w={protocol:"3DXContent",version:"1.0",source:"ENOSTDE_AP",data:{items:x}};var y=new l.Socket("compassPageSocket");y.subscribeServer("com.ds.compass",window.parent);y.dispatchEvent("onSetX3DContent",w,"compassPageSocket")},setSelectedNodes:function(x){this.reportSelection(x);this.setX3DContent(x);this.selectedNodes=[];var w=this;x.forEach(function(y){var z=new q(y);w.selectedNodes.push(z)});w.updateCommands(x)},getSelectedNodes:function(){return this.selectedNodes},refreshView:function(w){},getObjectAttributes:function(x){var w=this;return new UWA.Class.Promise(function(z,y){b.getSecurityContextPromise(w.tenant).then(function(A){w.getObjectAttributesReq(x,A).then(function(B){z(B)})["catch"](function(B){console.log(B)})})["catch"](function(A){console.log(A)})})},getObjectAttributesReq:function(y,x){var w=this;return new UWA.Class.Promise(function(C,B){var A=w.getAttributesId();var z={data:y,attributes:A};var D=u.get3DSpaceWSUrl(w.tenant,"/resources/lifecycle/product/attributeList",null);d.authenticatedRequest(D,{type:"json",method:"POST",proxy:"passport",data:UWA.Json.encode(z),headers:u.getHeaders(x),onComplete:function(F){var E=F.results;if(E&&E[0]){E[0].tenant=w.tenant}C(E)},onFailure:function(E){B("getAttributeList:Failure..."+E)},onTimeout:function(){B("getMaturitySatus: A connection timeout occured.")}})})},getAttributesId:function(){var w=[];w.push("owner");w.push("project");w.push("organization");w.push("revision");w.push("current");w.push("physicalid");w.push("logicalid");w.push("type");w.push("name");w.push("locker");w.push("majorid");w.push("minorrevision");w.push("majorrevision");w.push("versionid");w.push("policy");w.push("attribute[DOCUMENTS.Title]");w.push("attribute[PLMEntity.PLM_ExternalID]");w.push("attribute[PLMEntity.V_usage]");w.push("attribute[PLMEntity.V_Name]");w.push("attribute[PLMReference.V_DerivedFrom]");w.push("attribute[PLMReference.V_fromExternalID]");w.push("attribute[PLMReference.V_isLastVersion]");w.push("attribute[PLMCoreRepReference.V_isOnceInstantiable]");w.push("tenant");return w},setObjects:function(x){if(this.checkBlacklistedTypes(x)){return}this._updateUI(true);var w=this;this.getObjectAttributes(x).then(function(y){if(y==null||y.length==0){var A=null;if(w.stack.length>0){A=w.stack[w.stack.length-1]}if(A){var B=[{physicalid:A}];w.setObjects(B)}else{w.empty();var z={eventID:"warning",msg:e.objectNotFound};w.displayNotification(z)}}else{if(w.checkBlacklistedTypes(y)){return}w.updateObjects(y,false,false)}})},setObjectsWithExceptions:function(y,w,z){var x=this;this.getObjectAttributes(y).then(function(A){if(A.length>0){x.updateObjects(A,w,z)}else{x.historyMultiPanel.revisionFamily.displayError(e.noObject);var B={errorMsg:e.noObject};x.maturityWidget.displayError(B)}})},displayNotification:function(w){i.displayNotification(w)},empty:function(){this.stack=[];this.selectedNodes=[];this.objects=null;this.setTitle(e.lifecycleTitle);widget.setValue("Custo_roots_pids","[]");this.updateCommands(this.selectedNodes);this._updateUI(false)},gotSavedObjects:function(){if(widget.getValue("Custo_roots_pids")){var w=JSON.parse(widget.getValue("Custo_roots_pids"));if(w!=="undefined"&&w!==null&&w.length>0){return true}}return false},reloadSavedObjects:function(){if(this.gotSavedObjects()){var x=JSON.parse(widget.getValue("Custo_roots_pids"));var w={physicalid:x[0].physicalid,displayName:x[0].displayName,tenant:x[0].tenant};var y=[];y.push(w);this.setTenant(x[0].tenant);if(this.externalRefresh){this.externalRefresh.setTenant(this.tenant)}this.setObjects(y)}else{widget.addPreference({name:"Custo_roots_pids",type:"hidden",defaultValue:"[]"})}},useCompassContent:function(){if(!this.gotSavedObjects()){var A=(typeof(this.widget.getValue("X3DContentId"))!=="undefined")?JSON.parse(widget.getValue("X3DContentId")):null;if(A!==null){var x=A.data;if(x!==null){var y=[];if(x.items.length>0){var z=x.items[0];if(z.objectId!==null&&z.objectId!==undefined){this.setTenant(z.envId);if(this.externalRefresh){this.externalRefresh.setTenant(this.tenant)}var w={physicalid:z.objectId};if(z.displayName!==null&&z.displayName!==undefined){w.displayName=z.displayName}if(z.objectType!==null&&z.objectType!==undefined){w.objectType=z.objectType}y.push(w)}}if(y.length>0){this.setObjects(y)}}}}}});return j});