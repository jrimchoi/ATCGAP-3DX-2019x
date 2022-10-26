define("DS/3DPlayDMUExperience/3DPlayDMUExperience",["UWA/Core","UWA/Utils","DS/3DPlayExperienceModule/PlayExperience3D","DS/Visualization/ThreeJS_DS","DS/DMUReadPersistence/DMUReviewPersistenceServices","DS/DMUBaseUI/DMUInitialization","DS/DMUPlaySlide/DMUSlideServices","DS/DMUBaseExperience/EXPImportServices","DS/SceneGraphOverrides/SceneGraphOverrideSet","DS/DMUControls/EXPNotify","DS/DMUBaseExperience/DMUContextManager","DS/DMUControls/DMU2DSheetManager","DS/DMUBaseExperience/EXPManagerSet","DS/Visualization/Node3D","DS/DMUPlaySlide/controllers/DMUSlideShowController","DS/ApplicationFrame/CommandsManager","DS/VisuDataAccess/Ox4TypeHelper","i18n!DS/3DPlayDMUExperience/assets/nls/3DPlayDMUExperience"],function(d,e,h,p,c,f,m,l,k,n,q,o,j,i,b,a,r,g){return h.extend({init:function(u){var x=new c();var K,B,y=false,C,w;var E=this;var v;var F,L=true;var M=false;if(window.location.search!==""){var J={};d.extend(J,e.parseQuery(window.location.search));if(J.widgetDomain){d.extend(J,e.parseQuery(J.widgetDomain))}var A=Object.keys(J);M=A.indexOf("testWkb")!==-1}var t=true;function s(N){if(typeof N==="boolean"){t=N}var O=a.getCommand("Rotate",u.ctx);if(O){if(t){O.enable()}else{O.disable()}}else{setTimeout(s,100)}}var G=false,I=0;function H(N){G=N;if(!I){I=setInterval(function(){var O=a.getCommandCheckHeader("CATWebUXSlideShowHdr",u.ctx);if(O){clearInterval(I);I=0;if(G){O.enable()}else{O.disable()}}},100)}}function D(N){if(N.markupId!==undefined){x.getDnDReviewAndJSONFile(N,function(O){if(!F){F=new b({context:E.pad3DViewer});F.subscribe("onActiveStateModified",function(R){L=!R.state})}if(!y){m.setSlidePreferences({context:E.frmWindow,preferences:{playMode:true,displayNominal:true}});C=new k(E.frmWindow.getViewer().getRootNode().getChildByName("RootBag"));E.frmWindow.getViewer().getSceneGraphOverrideSetManager().pushSceneGraphOverrideSet(C);y=true}q.removeReviewContext({context:E.pad3DViewer});var Q=f.createReviewContext({context:E.pad3DViewer});Q.setReadOnly(true);var P=new l({viewer:E.frmWindow.getViewer(),experience:Q,appType:"3dPlay"});P.importDataModel(O.jsonObj,function(){P.postImport();Q.refreshNode();E.frmWindow.getViewer().render();Q._reviewPhysId={reviewId:O.reviewPid,reviewThumbId:O.reviewThumbId};var R=Q.getCurrentReview();if(R&&R.getChildren("DMUSlide").length){H(true)}})},function(){if(K){K.destroy()}K=new n({body:E.frmWindow.getUIFrame(),type:"error",messages:g.noMarkup})})}}function z(N,P){var O=["DS/PADUtils/PADUtilsServices","DS/PADUtils/PADSettingsMgt"];require(O,function(S,Q){try{r.InitWithUrl(S.get3DSpaceUrl(),Q.getSetting("x3dPlatformId"),"passport");if(r.IsInit()){r.GetParentsBusType(N,function(T){P([N].concat(T))})}else{P()}}catch(R){P()}})}this.internalLoad=function(P,N){q.removeReviewContext({context:E.pad3DViewer});if(w){E.frmWindow.getViewer().getRootNode().getChildByName("RootBag").removeChild(w);w=null}H(false);v=P?JSON.stringify(P):null;if(!P){return}var R=P.asset.physicalid;if(R){var Q=function(){if(K){K.destroy()}K=new n({body:E.frmWindow.getUIFrame(),type:"error",messages:g.loadError});s(true)};var O=function(S){var T=P.asset;T.physicalid=S.data[0].dataelements.parentId;T.dtype=S.data[0].relateddata&&S.data[0].relateddata.parents&&S.data[0].relateddata.parents.length?S.data[0].relateddata.parents[0].type:"VPMReference";T.markupId=R;var V=function(){D(T);if(!N){s(true);P.forceParentLoad=true;E.loadAsset(P)}};var U=function(){D(T);if(!N){if(!B){B=new o({ctxViewer:E.pad3DViewer});j.addManager({name:"DMU2DSheetManager",context:E.frmWindow,manager:B})}w=new i();E.frmWindow.getViewer().getRootNode().getChildByName("RootBag").addChild(w);B.load2DDocument({phyID:T.physicalid,parentNode:w,onLoadingStarted:function(){E.onModelLoadingStarted(true)},onComplete:function(){E.onModelLoadingCompleted();s(false);B.setNavBarVisibleFlag(false)},onFailure:function(){E.onModelLoadingCompleted();E.clearView();Q()}})}};if(T.dtype==="Drawing"||T.dtype==="CATDrawing"){U()}else{z(T.dtype,function(W){if(W&&W.length&&(W.indexOf("Drawing")!==-1||W.indexOf("CATDrawing")!==-1)){U()}else{V()}})}};x.getProductByMarkerId(P.asset,O,Q)}};this.internalClear=function(){q.removeReviewContext({context:E.pad3DViewer});if(w){E.frmWindow.getViewer().getRootNode().getChildByName("RootBag").removeChild(w);w=null}if(F){F.clean();F=null}if(B){B.clean2DDocument()}};this.internalDispose=function(){v=null;if(E.internalClear){E.internalClear()}E.frmWindow.getContextualUIManager().unregister("3DPlayDMUExperience");if(C){E.frmWindow.getViewer().getSceneGraphOverrideSetManager().removeSceneGraphOverrideSet(C)}m.removeSlidePreferences({context:E.frmWindow});j.removeManager({name:"DMU2DSheetManager",context:E.frmWindow});s(true);C=x=B=null;y=false};this.internalRefresh=function(){if(v){E.internalClear();E.internalLoad(JSON.parse(v),true)}};this.internalPostCreate=function(){var N=function(T,P){var Q;if(L&&P&&P.XmousePosition){var O=new p.Vector2(P.XmousePosition,P.YmousePosition);var R=E.frmWindow.getViewer().getMousePosition(O);var S=E.frmWindow.getViewer().pick(R,"mesh",true);if(S.path.length===0){Q={cmdList:[{name:"NoEnv",line:1,hdr_list:["VisuNoEnv"]},{name:"V6",line:1,hdr_list:["VisuV6Env"]},{name:"CleanSpace",line:1,hdr_list:["VisuCleanSpaceEnv"]},{name:"Blue",line:1,hdr_list:["VisuDarkBlueEnv"]},{name:"Grey",line:1,hdr_list:["VisuDarkGreyEnv"]},{name:"Shiny",line:1,hdr_list:["VisuShinyEnv"]}]}}}return Q};this.frmWindow.getContextualUIManager().register({subscriberId:"3DPlayDMUExperience",workbenchName:"3DPlayDMUExperience",context:E.pad3DViewer.getCommandContext(),cmdPrefix:"",fileName:M?"3DPlayDMUExperience_TST.xml":"3DPlayDMUExperience.xml",module:M?"DMU3DReviewFileWeb":"3DPlayDMUExperience",onContextualMenuReady:N});this.pad3DViewer.getViewer().currentViewpoint.control.lockZ=false};u.commandApplication=false;u.workbenchs=u.workbenchs||[];u.workbenchs.push({name:M?"3DPlayDMUExperience_TST":"3DPlayDMUExperience",module:M?"DMU3DReviewFileWeb":"3DPlayDMUExperience"});u.workbenchs.push({name:"3DPlayShare.xml",module:"3DPlay"});this._parent(u)},clearView:function(){if(this.internalClear){this.internalClear()}this._parent()},onPostCreate:function(){window.widget.setMetas({helpPath:"3DPlayDMUExperience/assets/help"});window.widget.dispatchEvent("onPlayExperienceReady",[{pad3DViewer:this.pad3DViewer}]);if(this.internalPostCreate){this.internalPostCreate()}},dispose:function(){this.clearView();window.widget.setMetas({helpPath:undefined});if(this.internalDispose){this.internalDispose()}this._parent()},refresh:function(){if(this.internalRefresh){this.internalRefresh()}return true},loadAsset:function(s){if(s&&s.asset&&s.asset.physicalid&&this.internalLoad&&!s.forceParentLoad){this.clearView();this.internalLoad(s)}else{this._parent(s)}}})});