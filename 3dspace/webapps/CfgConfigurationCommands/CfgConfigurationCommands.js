define("DS/CfgConfigurationCommands/commands/CfgEditConfigurationContextCmd",["DS/UIKIT/Alert","UWA/Core","DS/ApplicationFrame/Command","DS/i3DXCompassPlatformServices/i3DXCompassPlatformServices","DS/PADUtils/PADContext","DS/CfgBaseUX/scripts/CfgController","DS/CfgBaseUX/scripts/CfgUtility","DS/Notifications/NotificationsManagerUXMessages","DS/Notifications/NotificationsManagerViewOnScreen","i18n!DS/CfgConfigurationCommands/assets/nls/CfgConfigurationCommands","i18n!DS/CfgFilterUX/assets/nls/CfgFilterUX","DS/Utilities/Utils"],function(h,l,b,a,i,f,m,c,e,d,g,j){var k=b.extend({contextDialog:null,init:function(n){var o=this;this._parent(n,{mode:"exclusive",isAsynchronous:false});this._isConfigAvailable=0;this.enable();var o=this;m.rolesAvailable(function(p){if(p.isCFGRoleAvail){o._isConfigAvailable=1;o._setStateCmd()}});if(i.get!==undefined&&i.get()!==null){this._SelectorManager=i.get().getPADTreeDocument().getXSO()}else{this._SelectorManager=null}if(null!==this._SelectorManager){if(undefined!==this._SelectorManager.onPostAdd){this._SelectorManager.onPostAdd(this._checkSelection.bind(this))}if(undefined!==this._SelectorManager.onPostRemove){this._SelectorManager.onPostRemove(this._checkSelection.bind(this))}if(undefined!==this._SelectorManager.onEmpty){this._SelectorManager.onEmpty(this._checkSelection.bind(this))}}var o=this;if(i.get!==undefined&&i.get()!==null){i.get().addEvent("editModeModified",function(p){if(p===true){o._checkSelection()}else{o.disable()}})}},_checkSelection:j.debounce(function(){var n=this;this._SelectedID="";var o=this.getData().selectedNodes;require(["text!DS/CfgBaseUX/assets/CfgUXEnvVariables.json"],function(p){var q=JSON.parse(p);if(q.isAddMultipleContextEnabled&&q.isAddMultipleContextEnabled===true){if(o.length>=1){n._SelectedID=o[0].id||"";n._SelectedAlias=o[0].alias||"?"}n._setStateCmd()}else{if(o.length===1){n._SelectedID=o[0].id||"";n._SelectedAlias=o[0].alias||"?"}n._setStateCmd()}})},200),_setStateCmd:function(){var n=0;if(undefined!==this._SelectedID&&""!==this._SelectedID){n=1;if(this._isConfigAvailable==0){n=0}}if(i.get!==undefined&&i.get()!==null&&i.get().getEditMode()!==true){n=0}if(1===n){this.enable()}else{this.disable()}},destroy:function(){if(this.contextDialog){this.contextDialog.closeDialog()}},execute:function(){var o=this;this.disable();var n=o.getData().selectedNodes;if(n.length===1){this._SelectedID=n[0].id||"";this._SelectedAlias=n[0].alias||"?"}console.log(n);var o=this;f.init();if(widget.getValue("x3dPlatformId")){enoviaServerFilterWidget.tenant=widget.getValue("x3dPlatformId")}else{enoviaServerFilterWidget.tenant="OnPremise"}m.populate3DSpaceURL().then(function(){var s=m.populateSecurityContext();var t=function q(u){o.onSecurityContext(u,o)};var r=function p(u){o.enable()};s.then(t,r)})},onSecurityContext:function(n,o){var p=this._SelectedID;var o=this;require(["text!DS/CfgBaseUX/assets/CfgUXEnvVariables.json"],function(q){var v=JSON.parse(q);if(v.isAddMultipleContextEnabled&&v.isAddMultipleContextEnabled===true){var u=o.getData().selectedNodes.length;var r=[];for(var s=0;s<u;s++){r.push(o.getData().selectedNodes[s].id)}var t=new Promise(function(B,A){var y=function(C,D){A(D.errorMessage)};var x="/resources/modeler/configuration/navigationServices/getMultipleConfigurationContextInfo";var w=function(C){for(var D=0;D<C.contextInfo.length;D++){if(C.contextInfo[D].content.results[0]!=undefined&&C.contextInfo[D].content.results[0].notification!=undefined&&C.contextInfo[D].content.results[0].notification.code=="unaccessible"&&C.contextInfo[D].content.results[0].notification.type=="ERROR"){m.showwarning(g.Filter_unaccessiblecode_Error,"error");return}}B(C)};var z={version:"1.0",pidList:r,modelMask:"Read",enabledCriteria:"YES",cfgCtxt:"YES"};z=JSON.stringify(z);m.makeWSCall(x,"POST","enovia","application/ds-json",z,w,y,true)});t.then(function(w){var x={};var z=0;x.response=w;x.selection=o.getData().selectedNodes;for(var y=0;y<x.response.referencesInfo.length;y++){if(x.response.referencesInfo[y].isConfigurable=="NO"){z++}}if(z>=1&&z<x.response.referencesInfo.length){m.showwarning(d.Error_Incorrect_Type_Partial_Fail,"error");return}else{if(z==x.response.referencesInfo.length){m.showwarning(d.Error_Incorrect_Type_Complete_Fail,"error");return}else{require(["DS/CfgConfigurationContextUX/CfgEditMultipleConfigurationContextDialog"],function(A){o.contextDialog=new A(x);o.contextDialog.render();o.enable()})}}console.log(w)},function(x){o.enable();window.notifs=c;e.setNotificationManager(window.notifs);var y=x;var w=y.search("Incorrect type");var z={level:"error",title:"",subtitle:"",sticky:false};if((w!=="")&&(w>=0)){z.message=d.Error_Models_Incorrect_Type}else{z.message=d.Error_Models}window.notifs.addNotif(z)})}else{if(p!=null&&p!=""){var t=new Promise(function(A,z){var y=function(B,C){z(C.errorMessage)};var x="/resources/modeler/configuration/navigationServices/getConfiguredObjectInfo/pid:"+p+"?cfgCtxt=1&enabledCriteria=1";var w=function(B){if(B.contexts.content.results[0]!=undefined&&B.contexts.content.results[0].notification!=undefined&&B.contexts.content.results[0].notification.code=="unaccessible"&&B.contexts.content.results[0].notification.type=="ERROR"){m.showwarning(g.Filter_unaccessiblecode_Error,"error");return}A(B)};m.makeWSCall(x,"GET","enovia","application/ds-json","",w,y,true)});t.then(function(w){var x={};x.response=w;x.selection=o.getData().selectedNodes;require(["DS/CfgConfigurationContextUX/CfgEditConfigurationContextDialog"],function(y){o.contextDialog=new y(x);o.contextDialog.render();o.enable()});console.log(w)},function(x){o.enable();window.notifs=c;e.setNotificationManager(window.notifs);var y=x;var w=y.search("Incorrect type");var z={level:"error",title:"",subtitle:"",sticky:false};if((w!=="")&&(w>=0)){z.message=d.Error_Models_Incorrect_Type}else{z.message=d.Error_Models}window.notifs.addNotif(z)})}}})},getData:function(){var r={selectedNodes:[]};if(i.get!==undefined&&i.get()!==null){var o=i.get().getPADTreeDocument().getSelectedNodes();var n,q=o.length;for(n=0;n<q;n++){if(o[n].isRoot()){var p={id:o[n].getID(),alias:o[n].getLabel()};r.selectedNodes.push(p)}else{var p={id:o[n].getID(),alias:o[n].getLabel(),parentID:o[n].getParent().getID(),parentalias:o[n].getParent().getLabel()};r.selectedNodes.push(p)}}}return r}});return k});