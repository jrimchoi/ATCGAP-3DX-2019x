/*!  COPYRIGHT DASSAULT SYSTEMES 2015   */
define("DS/3DPlayDocumentViewer/Cmd2DPan",["DS/ApplicationFrame/Command","DS/VisuEvents/EventsManager"],function(b,a){var c=b.extend({init:function(d){this._parent(d,{isAsynchronous:true,mode:"exclusive"})},execute:function(){var f=this;var e=this.getFrameWindow();if(e&&e._3dViewer){var d=e._3dViewer;this.mouseDown=function(h){var g=f.getFrameWindow();if(g&&g._3dViewer){g._3dViewer.onMouseDown(h)}};this.mouseUp=function(h){f.end();var g=f.getFrameWindow();if(g&&g._3dViewer){g._3dViewer.onMouseUp(h)}};a.addEvent(d.viewerFrame,"onLeftMouseDown",this.mouseDown);a.addEvent(d.viewerFrame,"onLeftMouseUp",this.mouseUp)}},endExecute:function(){var e=this.getFrameWindow();if(e&&e._3dViewer){var d=e._3dViewer;a.removeEvent(d.viewerFrame,"onLeftMouseDown",this.mouseDown);a.removeEvent(d.viewerFrame,"onLeftMouseUp",this.mouseUp);this.mouseDown=null;this.mouseUp=null}}});return c});define("DS/3DPlayDocumentViewer/CmdDownloadDocument",["DS/3DPlayCommands/CmdShareBase"],function(b){var c;var a=b.extend({init:function(e){this._parent(e,{isAsynchronous:true});var d=this.getFrameWindow();if(d){var f=d.experience;if(f&&f.isCurrentDocumentPDF){this.enable()}else{this.disable()}c=this;this.loadingCompletedToken=d.experience.subscribe("ASSET/LOADINGFINISHED",function(g){if(f&&f.isCurrentDocumentPDF){c.enable()}else{c.disable()}})}},shareWithPanelManager:function(d){if(d){d._downloadSourceDocument()}},destroy:function(){if(c){c=null}if(this.loadingCompletedToken){var d=this.getFrameWindow();d.experience.unsubscribe(this.loadingCompletedToken)}}});return a});define("DS/3DPlayDocumentViewer/CmdReframe",["UWA/Core","DS/ApplicationFrame/Command"],function(c,a){var b=a.extend({init:function(d){this._parent(d,{isAsynchronous:false})},execute:function(){var d=this.getFrameWindow();if(d&&d._3dViewer){d._3dViewer.reframe()}}});return b});define("DS/3DPlayDocumentViewer/CmdScale",["UWA/Core","DS/ApplicationFrame/Command"],function(d,b){var a=[10,25,50,75,100,125,150,200,400,500];var c=b.extend({init:function(e){this._parent(e,{isAsynchronous:false});for(var f in e.arguments){if(e.arguments[f].ID==="Scale"){this.scaleMode=e.arguments[f].Value}}},execute:function(){var g=this.getFrameWindow();if(g&&g._3dViewer){var e=g._3dViewer.sheetCollection.layout.zoomScale;var f=this._getScale(e);g._3dViewer.setScale(f,true)}},_getScale:function(g){var h=100;g*=100;if(this.scaleMode==="+"){for(var f=0;f<a.length;++f){h=a[f];if(g<h){break}}}else{for(var e=a.length-1;e>=0;--e){h=a[e];if(g>h){break}}}return h/100}});return c});define("DS/3DPlayDocumentViewer/3DPlayDocumentViewer",["DS/3DPlayExperienceModule/PlayExperience2D","UWA/Core","DS/WebappsUtils/WebappsUtils","DS/ApplicationFrame/CommandsManager","DS/WebSystem/Nls","DS/WebSystem/Css","DS/WebSystem/Environment","DS/3DPlayAnnotation2D/AnnotationManager","DS/WebUtils/ContextedSingleton"],function(f,e,d,a,h,c,g,i,b){return f.extend({init:function(j){j.commandApplication=false;j.workbenchs=j.workbenchs||[];if(j&&j.input&&j.input.asset&&j.input.asset.originalAsset&&(j.input.asset.originalAsset.provider==="EV6"||j.input.asset.originalAsset.provider==="3DSPACE")&&(j.input.asset.originalAsset.type==="CATDrawing"||j.input.asset.originalAsset.type==="Drawing"||j.input.asset.originalAsset.type==="2DLayout")){j.workbenchs.unshift({name:"3DPlayDocumentViewerPrint",module:"3DPlayDocumentViewer"})}if(g.isSet("3DPlay.DisableViewerCanvas")){j.workbenchs.unshift({name:"3DPlayDocumentViewer",module:"3DPlayDocumentViewer"})}else{j.workbenchs.unshift({name:"3DPlayDocumentViewer_Canvas",module:"3DPlayDocumentViewer"})}this._parent(j)},onPreCreate:function(){this.isCurrentDocumentPDF=Boolean(this.args&&this.args.input&&this.args.input.asset&&this.args.input.asset.provider==="FILE"&&this.args.input.asset.type==="pdf");this.mabModelPDF={monoCmd:{id:"DownloadDocument",rsc:"3DPlayDocumentViewer/3DPlayDocumentViewer"}};this.mabModel2D={speeddial:[{id:"AnnotationCommands2D",rsc:"3DPlayDocumentViewer/3DPlayDocumentViewer"},{id:"Reframe",rsc:"3DPlayDocumentViewer/3DPlayDocumentViewer"},{id:"Share",icon:"3DPlay/assets/icons/32/I_3DSHAREShare.png",flyout:[]}],sections:[{id:"ScaleP",nls:"3DPlayDocumentViewer/3DPlayDocumentViewer",rsc:"3DPlayDocumentViewer/3DPlayDocumentViewer"},{id:"ScaleM",nls:"3DPlayDocumentViewer/3DPlayDocumentViewer",rsc:"3DPlayDocumentViewer/3DPlayDocumentViewer"},{id:"Previous",nls:"3DPlayDocumentViewer/3DPlayDocumentViewer",rsc:"3DPlayDocumentViewer/3DPlayDocumentViewer"},{id:"Next",nls:"3DPlayDocumentViewer/3DPlayDocumentViewer",rsc:"3DPlayDocumentViewer/3DPlayDocumentViewer"}]};if(this._iOS){this.mabModel2D.speeddial[2].flyout=[{id:"ShareTo3DSwYm",rsc:"3DPlay/3DPlay"},{id:"SharePrint",rsc:"3DPlay/3DPlay"}]}else{this.mabModel2D.speeddial[2].flyout=[{id:"ShareTo3DSwYm",rsc:"3DPlay/3DPlay"},{id:"ShareDownload",rsc:"3DPlay/3DPlay"},{id:"SharePrint",rsc:"3DPlay/3DPlay"}]}if(this.isCurrentDocumentPDF){this.mabModel=this.mabModelPDF}else{this.mabModel=this.mabModel2D}c("3DPlayDocumentViewer/3DPlayDocumentViewer.css",1);h.loadNls("3DPlayDocumentViewer/3DPlayDocumentViewer")},onPostCreate:function(){this._parent()},testBrowser:function(){return BrowserSupport.ok},createAnnotationManager:function(){b.add(this.ctx,"ANNOTATION_MANAGER",new i({frameWindow:this.frmWindow,context:this.ctx}))},destroyAnnotationManager:function(){var j=b.get(this.ctx,"ANNOTATION_MANAGER");if(j){b.remove(this.ctx,"ANNOTATION_MANAGER")}},dispose:function(j){this._parent(j);this.destroyAnnotationManager()},loadAsset:function(j,k){this.destroyAnnotationManager();this.createAnnotationManager();this._parent(j,k)}})});define("DS/3DPlayDocumentViewer/CmdRealSize",["UWA/Core","DS/ApplicationFrame/Command"],function(c,a){var b=a.extend({init:function(d){this._parent(d,{isAsynchronous:false})},execute:function(){var d=this.getFrameWindow();if(d&&d._3dViewer){d._3dViewer.realSize()}}});return b});define("DS/3DPlayDocumentViewer/CmdPrevious",["UWA/Core","DS/ApplicationFrame/Command","DS/WebUtils/EventDisposer"],function(c,b,a){return b.extend({init:function(e){this._parent(e,{isAsynchronous:false});var f=this.getFrameWindow();if(f){var g=this;var d=function(){g.disable()};f.onActionBarReady(function(){d()});this.EventDisposer=new a();this.EventDisposer.add(f.experience.subscribe("ASSET/LOADINGPROGRESS",d));this.EventDisposer.add(f.experience.subscribe("ASSET/LOADINGFINISHED",d))}},destroy:function(){if(this.EventDisposer){this.EventDisposer.dispose();this.EventDisposer=null}},execute:function(){var d=this.getFrameWindow();if(d&&d._3dViewer){d._3dViewer.goToSheet(d._3dViewer.getPrevious())}}})});define("DS/3DPlayDocumentViewer/Cmd2DZoom",["DS/ApplicationFrame/Command","DS/VisuEvents/EventsManager"],function(b,a){var c=b.extend({init:function(d){this._parent(d,{isAsynchronous:true,mode:"exclusive"})},execute:function(){var f=this;var e=this.getFrameWindow();if(e&&e._3dViewer){var d=e._3dViewer;this.mouseDown=function(i){var h=(i.from&&i.from.length)?i.from[0].event:null;var g=f.getFrameWindow();if(g&&g._3dViewer){g._3dViewer._startZoom(h.x,h.y)}};this.mouseUp=function(){f.end();var g=f.getFrameWindow();if(g&&g._3dViewer){g._3dViewer._stopZoom()}};a.addEvent(d.viewerFrame,"onLeftMouseDown",this.mouseDown);a.addEvent(d.viewerFrame,"onLeftMouseUp",this.mouseUp)}},endExecute:function(){var e=this.getFrameWindow();if(e&&e._3dViewer){var d=e._3dViewer;a.removeEvent(d.viewerFrame,"onLeftMouseDown",this.mouseDown);a.removeEvent(d.viewerFrame,"onLeftMouseUp",this.mouseUp);this.mouseDown=null;this.mouseUp=null}}});return c});define("DS/3DPlayDocumentViewer/CmdNext",["UWA/Core","DS/ApplicationFrame/Command","DS/WebUtils/EventDisposer"],function(c,b,a){return b.extend({init:function(e){this._parent(e,{isAsynchronous:false});var f=this.getFrameWindow();if(f){var g=this;var d=function(){var h=g.getFrameWindow();if(h&&h._3dViewer&&h._3dViewer.sheets&&h._3dViewer.sheets.length>1){g.enable()}else{g.disable()}};f.onActionBarReady(function(){d()});this.EventDisposer=new a();this.EventDisposer.add(f.experience.subscribe("ASSET/LOADINGPROGRESS",d));this.EventDisposer.add(f.experience.subscribe("ASSET/LOADINGFINISHED",d))}},destroy:function(){if(this.EventDisposer){this.EventDisposer.dispose();this.EventDisposer=null}},execute:function(){var d=this.getFrameWindow();if(d&&d._3dViewer){d._3dViewer.goToSheet(d._3dViewer.getNext())}}})});define("DS/3DPlayDocumentViewer/CmdFitWidth",["UWA/Core","DS/ApplicationFrame/Command"],function(c,a){var b=a.extend({init:function(d){this._parent(d,{isAsynchronous:false})},execute:function(){var d=this.getFrameWindow();if(d&&d._3dViewer){d._3dViewer.fitWidth()}}});return b});define("DS/3DPlayDocumentViewer/3DPlayDocumentViewerPreview",["DS/3DPlayDocumentViewer/3DPlayDocumentViewer"],function(a){var b=a.extend({init:function(c){this._parent(c);c.workbenchs=[];c.workbenchs.unshift({name:"3DPlayDocumentViewerPreview",module:"3DPlayDocumentViewer"})},dispose:function(){this._parent()},onPreCreate:function(){this.args.visu={picking:false};this._parent();var c=this;this.args.ui={keepActionbarClosed:true,onActionBarReady:function(){if(c&&c.frmWindow){c.frmWindow.getActionBar().close();c=undefined}}};this.mabModel={speeddial:[{id:"Reframe",rsc:"3DPlayDocumentViewer/3DPlayDocumentViewer"},{id:"Previous",rsc:"3DPlayDocumentViewer/3DPlayDocumentViewer"},{id:"Next",rsc:"3DPlayDocumentViewer/3DPlayDocumentViewer"}]}}});return b});