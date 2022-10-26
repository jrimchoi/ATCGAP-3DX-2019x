define("DS/GEOswaExperience/GEOswaExperience",["DS/3DPlayExperienceModule/PlayExperience3D","UWA/Core","DS/Core/Events","DS/Visualization/ThreeJS_DS","DS/Visualization/Viewpoint"],function(d,f,a,e,c){var b=d.extend({init:function(h){that=this;this._parent(h);var i={basicGEOExp:{workbenchs:[{name:"GEOswaExperienceWkb",module:"GEOswaExperience"}],swapVisible:true,selection:true,preSelection:true,visu:{antiAliasing:true,useShadowMap:true,infinitePlane:true,displayGrid:false,displayLines:false,debugShadowLight:false,debugBSphere:false,debugBBox:false,control:"COMBINED",picking:true,displayPicking:true,prePicking:false,displayprePicking:false,autoUpdatePlane:true,useMirror:true,defaultAnimationLoop:false},ui:{displayTree:false,displayActionBar:true}}};var g=i.basicGEOExp;that.args=f.extend(h,g,true)},loadModel:function(o,n,q){this.backup=arguments;var k=this.frmWindow.getViewer();var j=o?o.asset:this.args.input?this.args.input.asset:null;var l=(j===null||j===undefined||j===""||((typeof j)!=="string")&&(j.filename===undefined||j.filename===null||j.filename==="")&&(j.physicalid===undefined||j.physicalid===null||j.physicalid===""));if(l===true){j=WebappsUtils.getWebappsBaseUrl()+"3DPlay/assets/models3d/3DS_emblem.cgr"}var g="";var i=j;if((typeof i)==="string"){if(i===""){return}g=i;var h=StringUtils.getExtension(i);if(h!==""){h=h.toLowerCase();if(h!="3dxml"){this.modelLoader.setFileType(h)}}}else{if(i.provider===undefined||i.provider===null||i.provider.toLowerCase()==="file"){g=i.filename;if(g===undefined||g===null||g===""){return}}if(n&&n.tenant){i.tenant=n.tenant}}if(this.pad3DViewer&&i.provider&&i.provider!=="FILE"){var m=this;o.asset.id=o.asset.physicalid;var p=[o.asset];m.pad3DViewer.addRoots({objects:p},false)}else{this.modelName=g.split("/").pop();this.modelLoader.loadModel(i)}this.onModelLoadingStarted(q)},onPreCreate:function(){if(this.args){this.args.visu={showReferenceAxisSystem:true}}this.mabModel={speeddial:[{id:"AnnotationCommands",rsc:"3DPlay/3DPlayExperience3D"},{id:"Reframe",rsc:"3DPlay/3DPlayExperience3D"}],sections:[{id:"ViewSelector",nls:"3DPlay/3DPlayExperience3D",rsc:"3DPlay/3DPlayExperience3D",hideAB:true,showBack:true},{id:"VisibilityCommands",nls:"3DPlay/3DPlayExperience3D",rsc:"3DPlay/3DPlayExperience3D"},{id:"EnhancedExplode",nls:"3DPlay/3DPlayExperience3D",rsc:"3DPlay/3DPlayExperience3D",hideAB:true,showBack:true},{id:"measure2CmdHdr",nls:"DMUBaseCommands/3DPlayPro",rsc:"DMUBaseCommands/3DPlayPro",hideAB:true},{id:"section2CmdHdr",nls:"DMUBaseCommands/3DPlayPro",rsc:"DMUBaseCommands/3DPlayPro"},{id:"AnnotationTour",nls:"3DPlay/3DPlayExperience3D",rsc:"3DPlay/3DPlayExperience3D",hideAB:true,showBack:true},{id:"Render",nls:"3DPlay/3DPlayExperience3D",rsc:"3DPlay/3DPlayExperience3D",flyout:[{id:"VisuShading",rsc:"ViewerCommands/ViewerCommands"},{id:"VisuShadingEdgesNoSmoothEdges",rsc:"ViewerCommands/ViewerCommands"},{id:"VisuShadingEdgesHiddenEdges",rsc:"ViewerCommands/ViewerCommands"},{id:"VisuShadingMaterialEdges",rsc:"ViewerCommands/ViewerCommands"},{id:"VisuShadingMaterial",rsc:"ViewerCommands/ViewerCommands"},{id:"VisuShadingIllustration",rsc:"ViewerCommands/ViewerCommands"},{id:"VisuNoShadingEdges",rsc:"ViewerCommands/ViewerCommands"}]},{id:"Ambiance",nls:"3DPlay/3DPlayExperience3D",rsc:"3DPlay/3DPlayExperience3D",flyout:[{id:"VisuNoEnv",rsc:"ViewerCommands/ViewerCommands"},{id:"VisuV6Env",rsc:"ViewerCommands/ViewerCommands"},{id:"VisuCleanSpaceEnv",rsc:"ViewerCommands/ViewerCommands"},{id:"VisuDarkBlueEnv",rsc:"ViewerCommands/ViewerCommands"},{id:"VisuDarkGreyEnv",rsc:"ViewerCommands/ViewerCommands"},{id:"VisuShinyEnv",rsc:"ViewerCommands/ViewerCommands"}]},{id:"HideShowFilter",nls:"GEOHideShowFilterCmd/GEOHideShowFilterWkb",rsc:"GEOHideShowFilterCmd/GEOHideShowFilterCmd"}]}},onPostCreate:function(){var g=this;var i=g.frmWindow.getViewer();var h=function(n,k){if(k&&k.XmousePosition){var j=new e.Vector2(k.XmousePosition,k.YmousePosition);var l=i.getMousePosition(j);var m=i.pick(l,"mesh",true);if(m.path.length==0){return{cmdList:[{name:"Dropdown_1",line:1,hdr_list:["VisuNoEnv"]},{name:"Dropdown_2",line:1,hdr_list:["VisuV6Env"]},{name:"Dropdown_2",line:1,hdr_list:["VisuCleanSpaceEnv"]},{name:"Dropdown_2",line:1,hdr_list:["VisuDarkBlueEnv"]},{name:"Dropdown_2",line:1,hdr_list:["VisuDarkGreyEnv"]},{name:"Dropdown_2",line:1,hdr_list:["VisuShinyEnv"]}]}}}};g.frmWindow.getContextualUIManager().register({workbenchName:"GEOswaExperienceWkb",module:"GEOswaExperience",cmdPrefix:"",fileName:"GEOswaExperienceWkb.xml",onContextualMenuReady:h});a.subscribe({event:"GEOSwaViewpoint"},function(m){var l=g.frmWindow.getViewpoint();var j=new e.Vector3(m.viewport.positionX+m.viewport.datumX,m.viewport.positionY+m.viewport.datumY,m.viewport.positionZ+m.viewport.datumZ);l.setEyePosition(j);var n=new e.Vector3(m.viewport.targetX+m.viewport.datumX,m.viewport.targetY+m.viewport.datumY,m.viewport.targetZ+m.viewport.datumZ);l.setTarget(n);var k=new e.Vector3(m.viewport.upX,m.viewport.upY,m.viewport.upZ);l.setUpDirection(k);l.setProjectionType(c.ORTHOGRAPHIC);i.render()})}});return b});