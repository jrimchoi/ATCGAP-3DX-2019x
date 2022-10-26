define("DS/VCXWebTreeExtensions/VCXATreeNode",["UWA/Class","DS/VCXWebKernelCommands/VCXCmdChangeVisibility","DS/RuntimeView/RSCManager"],function(a,b,d){var c=a.extend({init:function(){this._rscUrlMap={};this._treeNodesModelsMap={}},SetNewTreeNodeModel:function(e,g){if(!this._treeNodesModelsMap[g]){this._treeNodesModelsMap[g]={}}var f=e._getID();if(!this._treeNodesModelsMap[g][f]){this._treeNodesModelsMap[g][f]=e}else{throw"ID already used"}},UnsetTreeNodeModel:function(e,g){var f=e._getID();if(this._treeNodesModelsMap[g]&&this._treeNodesModelsMap[g][f]===e){delete this._treeNodesModelsMap[g][f]}if(Object.getOwnPropertyNames(this._treeNodesModelsMap[g]).length===0){delete this._treeNodesModelsMap[g]}},_storeTreeNodeModelsFromTreeType:function(g){var f=[];for(var e in this._treeNodesModelsMap[g]){if(this._treeNodesModelsMap[g].hasOwnProperty(e)){f.push(this._treeNodesModelsMap[g][e])}}return f},GetTreeNodesModelsFromTree:function(g){var f=[];if(!g){for(var e in this._treeNodesModelsMap){if(this._treeNodesModelsMap.hasOwnProperty(e)){f=f.concat(this._storeTreeNodeModelsFromTreeType(e))}}}else{f=f.concat(this._storeTreeNodeModelsFromTreeType(g))}return f},hasTreeNodeModels:function(e){if(typeof e!=="string"){return Object.keys(this._treeNodesModelsMap).length>0}else{return typeof this._treeNodesModelsMap[e]!=="undefined"}},SetVisibility:function(h){var e=this.GetObject()._experienceBase;var i=e.getManager("VCXScenarioManager");var g=e.getManager("VCXCommandManager");var f=new b(i,e.ComponentsMap,g);f.ChangeVisibility([this.GetObject()],h);g.Push(f);return true},GetVisibility:function(){var g=null;var f=null;var e=this.GetObject().QueryInterface("VCXIVisibility");if(e){f=e.GetVisibility()}return f},GetName:function(){var g=this.GetObject().QueryInterface("VCXIModifiable");var f=g&&g.GetProperty("Actor.Name");var e=f&&f.GetPropertyValue().GetValue();if(!e){e=""}return e},GetParent:function(){var g=null;var f=this.GetObject().QueryInterface("VCXIModelNavigable");var e=f&&f.getParent();if(e){g=e.QueryInterface("VCXITreeNode")}return g},GetChildren:function(){var h=[];var f=this.QueryInterface("VCXIModelNavigable");if(!f){console.log("Something wrong, no ModelNavigable extension found for specified treenode.");return h}var j=f.getChildren();for(var g=0;g<j.length;g++){var e=j[g].QueryInterface("VCXITreeNode");if(e){h.push(e)}}return h},getTreeNodeComponentIcon:function(){},_loadIconFromFilenameAndKey:function(g,f){if(!g||!f){return}var e=this;if(this._rscUrlMap[g+"."+f]){this._setIconOnceLoaded(this._rscUrlMap[g+"."+f])}else{d.loadResource({resourceFile:g});d.onResourceLoaded({resourceFile:g},function(){var h=this.getIcon({key:f,size:"Normal"});if(h){e._setIconOnceLoaded(h);e._rscUrlMap[g+"."+f]=h}})}},_setIconOnceLoaded:function(g){var h=this.GetTreeNodesModelsFromTree();for(var e=0;e<h.length;++e){var i=h[e];var f=i.options.icons;if(!Array.isArray(f)||f[0]!==g){h[e].updateOptions({icons:[g]})}}},getTreeNodeVisibilityIcon:function(){var e=this.GetVisibility();var g=null;if(typeof e!=="number"){return}var f=e===1?"Visible":e===0?"Invisible":e===-1?"PartialVisible":console.warn("VisibilityStatus not recognized..");d.onResourceLoaded({resourceFile:"VCXWebGUI/VCXWebTreeExtensions"},function(){g=this.getIcon({key:f,size:"Normal"})});return g},Dispose:function(){for(var g in this._treeNodesModelsMap){if(this._treeNodesModelsMap.hasOwnProperty(g)){for(var f in this._treeNodesModelsMap[g]){if(this._treeNodesModelsMap[g].hasOwnProperty(f)){var e=this._treeNodesModelsMap[g][f];this._treeNodesModelsMap[g][f]=null}}this._treeNodesModelsMap[g]=null}}this._treeNodesModelsMap={}}});return c});define("DS/VCXWebTreeExtensions/VCXTreeNodeOccurrence",["DS/VCXWebTreeExtensions/VCXATreeNode"],function(b){var c={Root:{fileName:"VCXWebTreeGUI/VCXWebTreeGUI",key:"TreeNode.Root"},VCXComponentOccurrenceComposer:{fileName:"VCXWebTreeGUI/VCXWebTreeGUI",key:"TreeNode.GroupAsset"},VCXComponentAssetOccurrenceComposer:{fileName:"VCXWebTreeGUI/VCXWebTreeGUI",key:"TreeNode.GroupAsset"},VCXComponentMesh:{fileName:"VCXWebTreeGUI/VCXWebTreeGUI",key:"TreeNode.Group"},VCXComponentMeshPrimitive:{fileName:"VCXWebTreeGUI/VCXWebTreeGUI",key:"TreeNode.Primitive"},VCXComponentCompositePmi:{fileName:"VCXWebDressup/VCXWebDressup",key:"TreeNode.PMIs.Root"},VCXComponentCurveWire:{fileName:"VCXWebTreeGUI/VCXWebTreeGUI",key:"TreeNode.CurveWire"},VCXComponentPoint:{fileName:"VCXWebTreeGUI/VCXWebTreeGUI",key:"TreeNode.Point"},VCXComponentHotspot:{fileName:"VCXWebTreeGUI/VCXWebTreeGUI",key:"TreeNode.Hotspot"},CXPExperience_Spec:{fileName:"VCXWebTreeGUI/VCXWebTreeGUI",key:"TreeNode.Root"},Model_VPMReference_Spec:{fileName:"VCXWebTreeGUI/VCXWebTreeGUI",key:"TreeNode.GroupAsset"},VCXComponentVPMReference:{fileName:"VCXWebTreeGUI/VCXWebTreeGUI",key:"TreeNode.GroupAsset"},VCXComponentGroupHotspot:{fileName:"VCXWebTreeGUI/VCXWebTreeGUI",key:"TreeNode.Hotspot"},};var a=b.extend({init:function(){this._parent()},getTreeNodeComponentIcon:function(){var e="";var f="";var d=this.GetObject().GetType();if(!d){console.warn("Cannot get the component type. The component icon cannot be fetched.");return}if(!this.GetParent()&&d==="VCXComponentOccurrenceComposer"){d="Root"}f=c[d].fileName;e=c[d].key;this._loadIconFromFilenameAndKey(f,e)}});return a});define("DS/VCXWebTreeExtensions/VCXTreeNodeStyle",["DS/VCXWebTreeExtensions/VCXATreeNode"],function(a){var b=a.extend({init:function(){this._parent()},getTreeNodeComponentIcon:function(){this._loadIconFromFilenameAndKey("VCXWebDressup/VCXWebDressup","TreeNode.Markups.Root")}});return b});define("DS/VCXWebTreeExtensions/VCXTreeNodeDiggerGrp",["DS/VCXWebTreeExtensions/VCXATreeNode"],function(b){var a=b.extend({init:function(){this._parent()},getTreeNodeComponentIcon:function(){var d=this.GetObject().getName();var e="VCXWebDigger/VCXWebDigger";var c="TreeNode."+d+".Root";this._loadIconFromFilenameAndKey(e,c)}});return a});define("DS/VCXWebTreeExtensions/VCXTreeNodeDressup",["DS/VCXWebTreeExtensions/VCXATreeNode"],function(b){var a=b.extend({init:function(){this._parent()},getTreeNodeComponentIcon:function(){var e="";var i="VCXWebDressup/VCXWebDressup";var c=this.GetObject().GetType();if(!c){console.warn("Cannot get the component type. The component icon cannot be fetched.");return}var d;var h=c;var f=this.GetObject()._dressupFamily;if(h.indexOf("VCXComponent")===0){var g=c.slice();d=g.replace("VCXComponent","")}else{d=c.slice()}e="TreeNode."+f+"."+d;this._loadIconFromFilenameAndKey(i,e)}});return a});define("DS/VCXWebTreeExtensions/VCXTreeNodeDigger",["DS/VCXWebTreeExtensions/VCXTreeNodeDressup"],function(b){var a=b.extend({init:function(){this._parent()},getTreeNodeComponentIcon:function(){var h="VCXWebDigger/VCXWebDigger",d;var g=this.GetObject().GetType();var e=this.GetObject()._dressupFamily;if(!g||!e){console.warn("Component information is missing. The component icon cannot be fetched.");return}var f=g.slice();var c=f.replace("VCXComponent","");d="TreeNode."+e+"."+c;this._loadIconFromFilenameAndKey(h,d)}});return a});define("DS/VCXWebTreeExtensions/VCXTreeNodeAmbience",["DS/VCXWebTreeExtensions/VCXTreeNodeDressup","DS/VCXWebKernelCommands/VCXCmdChangePropertiesAutokey","DS/VCXWebProperties/VCXProperty","DS/VCXWebProperties/VCXPropertyInfo","DS/VCXWebProperties/VCXPropertyValueString"],function(f,b,c,e,a){var d=f.extend({SetVisibility:function(j){var n=this.GetObject()._experienceBase;var g=n.getManager("VCXContextManager");var l=g.getActiveViewport();if(l){var o=l.QueryInterface("VCXIModifiable");if(o){var k="";if(j){k=this.GetObject().GetID()}var i=new a(k);var h=new c(new e("Viewport.ActiveAmbience",0),i);var m=new b(n.getManager("VCXScenarioManager"),n.getManager("VCXCommandManager"),true);m.ChangeProperty(o,h);n.getManager("VCXCommandManager").Do(m)}}return this._parent(1)},GetVisibility:function(){var g=this.GetObject()._experienceBase;var k=false;var i=g.getManager("VCXContextManager");var h=i.getActiveViewport();var j=h.getActiveAmbienceID();if(j===this.GetObject().GetID()){return 1}return 0},});return d});define("DS/VCXWebTreeExtensions/VCXTreeNodeVisibilityFromChildren",["DS/VCXWebTreeExtensions/VCXATreeNode","DS/VCXWebKernelCommands/VCXCmdChangeVisibility",],function(c,a){var b=c.extend({init:function(){this._parent()},getTreeNodeComponentIcon:function(){var e="";var f="";var d=this.GetObject().GetType();if(!d){console.warn("Cannot get the component type. The component icon cannot be fetched.");return}f=_compTypeRscMap[d].fileName;e=_compTypeRscMap[d].key;this._loadIconFromFilenameAndKey(f,e)},SetVisibility:function(g){var j=this.GetObject();if(!j){console.log("There shouldn't be this case...");return false}var e=j.QueryInterface("VCXIModelNavigable").getChildren();if(e.length===0){this._visible=1}else{for(var i=0;i<e.length;++i){var l=e[i];e[i]=l.GetObject()}var h=j._experienceBase;var f=h.getManager("VCXScenarioManager");var k=h.getManager("VCXCommandManager");var d=new a(f,h.ComponentsMap,k);d.ChangeVisibility(e,g);k.Push(d)}return true},GetVisibility:function(){var h;var f=this.GetObject();if(!f){console.log("This shouldn't happen.");return}var e=f.QueryInterface("VCXIModelNavigable");var k=e&&e.getChildren();if(!k){console.log("No navigable is linked to this component..");return}if(k.length===0){h=this._visible}else{for(var g=0;g<k.length&&h!==-1;g++){var d=k[g];if(d){var j=d.QueryInterface("VCXIVisibility");if(j){if(typeof h==="undefined"){h=j.GetVisibility()}else{if(h!==j.GetVisibility()){h=-1}}}}}}return h}});return b});define("DS/VCXWebTreeExtensions/VCXTreeNodeDressupGrp",["DS/VCXWebTreeExtensions/VCXTreeNodeVisibilityFromChildren",],function(b){var a=b.extend({init:function(){this._parent()},getTreeNodeComponentIcon:function(){var e,d=this.GetObject().getName();if(d==="Diggers"){e="VCXWebDigger/VCXWebDigger"}else{e="VCXWebDressup/VCXWebDressup"}var c="TreeNode."+d+".Root";this._loadIconFromFilenameAndKey(e,c)},GetName:function(){var e=this.GetObject().getName();var d=this.GetObject()._experienceBase.getManager("VCXNLSManager");if(!d){return}var c=d.GetNLS(["VCXWebDressup/VCXWebDressup"]);if(c){return c.getTitle({key:"TreeNode."+e})}}});return a});define("DS/VCXWebTreeExtensions/VCXTreeNodeSelectionSet",["DS/VCXWebTreeExtensions/VCXTreeNodeVisibilityFromChildren",],function(b){var c={VCXComponentSelectionSet:{fileName:"VCXWebTreeGUI/VCXWebTreeGUI",key:"TreeNode.SelectionSet"},VCXComponentGroupSelectionSet:{fileName:"VCXWebTreeGUI/VCXWebTreeGUI",key:"TreeNode.SelectionSet"},};var a=b.extend({init:function(){this._parent()},getTreeNodeComponentIcon:function(){var e="";var f="";var d=this.GetObject().GetType();if(!d){console.warn("Cannot get the component type. The component icon cannot be fetched.");return}f=c[d].fileName;e=c[d].key;this._loadIconFromFilenameAndKey(f,e)},});return a});