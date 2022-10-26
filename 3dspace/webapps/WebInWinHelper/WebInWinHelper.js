define("DS/WebInWinHelper/WebInWinHelper",["UWA/Class","DS/WebToWinInfra/WebToWinCom","DS/WebappsUtils/WebappsUtils","DS/LifecycleServices/LifecycleServicesSettings"],function(a,d,c,b){return a.singleton({init:function(){},createWebInWinSocket:function(f){var e=d.createSocket({socket_id:f+Math.floor((Math.random()*100000)+1)});return e},parseContextualMenu:function(e){return d.parseContextualMenu(e)},createJSONArraySelect:function(k){var j=this;var g=[];var e=[];for(var h=0;h<k.length;h++){var f={id:k[h].physicalid,session_object:false};g.push(f)}var l='{ "objects_name": '+JSON.stringify(g)+"}";return l},createJSONArraySelectWithCSOTrue:function(k){var j=this;var g=[];var e=[];for(var h=0;h<k.length;h++){var f={id:k[h].physicalid,session_object:true};g.push(f)}var l='{ "objects_name": '+JSON.stringify(g)+"}";return l},createJSONArrayActionWithArgs:function(f,h){var e={action:f,objectIds:[],Args:[]};for(var g=0;g<h.length;g++){e.objectIds.push(h[g].physicalid);e.Args.push({Name:h[g].Name,Value:h[g].Value})}return JSON.stringify(e)},setContextRestoreSelection:function(e,f){},setCSOSelection:function(e,g,j){var h=this;var i=[];g.forEach(function(n){var k;if(typeof n.physicalId!=="undefined"){k=n.physicalId}else{if(typeof n.physicalid!=="undefined"){k=n.physicalid}else{if(typeof n.id!=="undefined"){k=n.id}else{if(typeof n._options!=="undefined"&&typeof n._options.id!=="undefined"){k=n._options.id}}}}var m;if(typeof n.name!=="undefined"){m=n.name}else{if(typeof n.displayName!=="undefined"){m=n.displayName}else{if(typeof n._options!=="undefined"&&typeof n._options.label!=="undefined"){m=n._options.label}}}var l={physicalid:k,name:m};i.push(l)});var f=this.createJSONArraySelect(i);e.dispatchEvent("onDispatchToWin",{notif_name:(j!==undefined&&j===true)?"onAddToCSODirect":"onAddToCSO",notif_parameters:f},"lf_web_in_win")},setCSOSelectionIteration:function(e,g){var h=this;var i=[];g.forEach(function(m){var j;if(typeof m.physicalId!=="undefined"){j=m.physicalId}else{if(typeof m.physicalid!=="undefined"){j=m.physicalid}else{if(typeof m.id!=="undefined"){j=m.id}}}var l;if(typeof m.name!=="undefined"){l=m.name}else{if(typeof m.displayName!=="undefined"){l=m.displayName}}var k={physicalid:j,name:l};i.push(k)});var f=this.createJSONArraySelectWithCSOTrue(i);e.dispatchEvent("onDispatchToWin",{notif_name:"onAddToCSO",notif_parameters:f},"lf_web_in_win")},fetchContextFromSelection:function(e,g){var h=this;var i=[];g.forEach(function(m){var j;if(typeof m.physicalId!=="undefined"){j=m.physicalId}else{if(typeof m.physicalid!=="undefined"){j=m.physicalid}}var l;if(typeof m.name!=="undefined"){l=m.name}else{if(typeof m.displayName!=="undefined"){l=m.displayName}}var k={physicalid:j,name:l};i.push(k)});var f=this.createJSONArraySelect(i);e.dispatchEvent("onDispatchToWin",{notif_name:"onActionClickDottedNoCSO",notif_parameters:f},"lf_web_in_win")},closePanel:function(e){e.dispatchEvent("onDispatchToWin",{notif_name:"ClosePanel",notif_parameters:"ClosePanel"},"lf_web_in_win")},fireWintopCommand:function(e,i,k){var h=this;var g=[];if(null!==i){g.push({physicalid:i.id,id:i.id,displayName:i.displayName})}var j=d.createJSONArrayAction(k,g);if(j.length>0){var f=null;this.setCSOSelection(e,g);e.dispatchEvent("onDispatchToWin",{notif_name:"onCtxMenuClick",notif_parameters:j},"lf_web_in_win")}else{}},onBuildWinContextMenu:function(g,f,q,l){var m=this;var p;var n=c.getWebappsBaseUrl()+"WebInWinHelper/assets/icons/32/";for(var s=0;s<f.length;s++){var j=f[s];if(typeof j.items==="undefined"){var e=j.actionId;if(e!="Copy"){var o=j.icon;var i=j.menu;var r=j.text;var u=j.accelerator;if(o==""||(typeof(o)=="undefined")){p=""}else{o=o.replace(".png","");p="url("+n+o+".png)"}this.addMenuContextNode(g,q,e,r,u,p,l)}}else{var t=[];var k="PushItem";this.onBuildWinContextMenu(g,j.items,t,l);var h={title:j.text,submenu:t,type:k};q.push(h)}}},addMenuContextNode:function(g,n,e,p,q,m,j){var k=this;var f=e;var h="PushItem";var o=function l(){k.fireWintopCommand(g,j,f)};var i={callback:o};n.push({title:p,type:h,icon:m,action:i,accelerator:q})},launchWinRestoreIterations:function(e,i,g){var j="CATImmRestoreItertionCmd";var f=[];if(null!==i){f.push({physicalid:i.physicalid})}if(null!==g){f.push({physicalid:g.physicalid})}var h=d.createJSONArrayAction(j,f);if(h.length>0){e.dispatchEvent("onDispatchToWin",{notif_name:"onCtxMenuClick",notif_parameters:h},"lf_web_in_win")}else{}},launchWinCompareIterations:function(e,i,g){var j="CATImmCompareIterationBaseCmd";var f=[];if(null!==i){f.push({physicalid:i.physicalid,Name:"name1",Value:i.name})}if(null!==g){f.push({physicalid:g.physicalid,Name:"name2",Value:g.name})}var h=this.createJSONArrayActionWithArgs(j,f);if(h.length>0){e.dispatchEvent("onDispatchToWin",{notif_name:"onCtxMenuClick",notif_parameters:h,},"lf_web_in_win")}else{}},sendGetLicenseNotif:function(e){e.dispatchEvent("onDispatchToWin",{notif_name:"controlLicense",},"lf_web_in_win")},launchWinOpenIterations:function(m,k){var f="CATImmOpenIterationCmd";var l={action:f,Args:[]};if(k.length==0){return}for(var q=0;q<k.length;q++){var h="name";var n="date";var r="physicalId";var p=q+1;var o=h.concat(p);var e=n.concat(p);var s=r.concat(p);l.Args.push({Name:o,Value:k[q].name},{Name:e,Value:k[q].date},{Name:s,Value:k[q].physicalid})}var g=JSON.stringify(l);if(g.length>0){m.dispatchEvent("onDispatchToWin",{notif_name:"onCtxMenuClick",notif_parameters:g},"lf_web_in_win")}else{}},launchWinCompare:function(e,i,g){var j="CATPLMCompareHdr";var f=[];if(null!==g){f.push({physicalid:g.id})}if(null!==i){f.push({physicalid:i.id})}var h=d.createJSONArrayAction(j,f);if(h.length>0){e.dispatchEvent("onDispatchToWin",{notif_name:"onCtxMenuClick",notif_parameters:h},"lf_web_in_win")}else{}},getJSONArrayFromSelectionData:function(e,h,f){if(h!==null){if(h.selectedNodes!==undefined){var g;for(g=0;g<h.selectedNodes.length;g++){f.push({physicalid:h.selectedNodes[g]._options.id,displayName:h.selectedNodes[g]._options.label,})}}}},fireWintopCommandWithArgs:function(e,i,j){var k=j;var f=[];if(i!==null){if(i.selectedNodes!==undefined){var g;for(g=0;g<i.selectedNodes.length;g++){f.push({physicalid:i.selectedNodes[g]._options.id})}}}var h=d.createJSONArrayAction(k,f);if(h.length>0){e.dispatchEvent("onDispatchToWin",{notif_name:"onCtxMenuClick",notif_parameters:h},"lf_web_in_win")}else{}},getServices:function(g){if(g.options.wintop){var f;if(typeof g.options.platform_services==="undefined"){f=g.options.serverUrl}else{f=g.options.platform_services}var e={wintop:g.options.wintop,platform_services:f};return b.getInstance(e)}return b},initTenant:function(e){if(e.options.wintop){if(typeof e.options.serverUrl!=="undefined"&&e.options.serverUrl.length>0){if(typeof e.options.serverUrl[0].platformId!=="undefined"){e.tenant=e.options.serverUrl[0].platformId}}}},loadCssfile:function(e){var f=document.createElement("link");if(typeof f!="undefined"){f.setAttribute("rel","stylesheet");f.setAttribute("type","text/css");f.setAttribute("href",e);document.getElementsByTagName("head")[0].appendChild(f)}},})});