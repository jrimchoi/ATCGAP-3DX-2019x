define("DS/DMUBaseCtxCommands/DMUBaseContextCmd",["DS/ApplicationFrame/Command","DS/DMUControls/EXPColorPicker","DS/Visualization/ThreeJS_DS","DS/DMUBaseExperience/EXPUtils","DS/Selection/CSOManager","DS/DMUBaseExperience/DMUContextManager","DS/DMUBaseExperience/EXPToolsVisualization","i18n!DS/DMUBaseCtxCommands/assets/nls/DMUBaseCtxCommands"],function(a,i,f,e,c,g,d,h){var b;return a.extend({init:function(k){var j=k||{};j.mode="shared";this._parent(j)},beginExecute:function(t){this._parent(t);var o=this;function q(v,B){if(!v.length){return}if(b&&b.data===JSON.stringify(B)){b.setVisibleFlag(!b.getVisibleFlag())}else{if(b){b.clean()}b=new i({frameWindow:o.getFrameWindow(),onDestroyCB:function(){b=null}});b.data=JSON.stringify(B);var A=[];for(var C=0;C<v.length;C++){A.push({color:v[C].getAttribute(B.colorAttr),opacity:B.opacityAttr?v[C].getAttribute(B.opacityAttr):"NotValuated",resetState:!v[C].getAttribute(B.colorAttr==="cFillStyleColor"?"bIsFilled":"bHasBorder")})}var w,D,z,x=B.opacityAttr?true:false,y=true,u=true;for(var C=0;C<A.length;C++){if(y){if(w===undefined){w=A[C].color}else{if((w!==null&&A[C].color!==null&&!w.equals(A[C].color))||(w===null&&A[C].color!==null)||(w!==null&&A[C].color===null)){w=null;y=false}}}if(x){if(D===undefined){D=A[C].opacity}else{if(D!==A[C].opacity){D=null;x=false}}}if(u){if(z===undefined){z=A[C].resetState}else{if(z!==A[C].resetState){z=null;u=false}}}}b.build({displayColorSlider:B.colorAttr?true:false,displayOpacitySlider:B.opacityAttr?true:false,displayResetButton:B.displayResetBtn?true:false,colorAndOpacityBinded:B.colorAttr!==null&&B.colorAttr!==undefined&&B.opacityAttr!==null&&B.opacityAttr!==undefined,defaultColor:w,onColorChangedCB:function(F){var E=new f.Color(F.color);for(var G=0;G<v.length;G++){v[G].setAttribute(B.colorAttr==="cFillStyleColor"?"bIsFilled":"bHasBorder",true);v[G].setAttribute(B.colorAttr,E);if(B.colorAttr==="cLineStyleColor"&&v[G].hasAttribute("cLeaderStyleColor")){v[G].setAttribute("cLeaderStyleColor",E)}if(B.colorAttr==="cFillStyleColor"&&v[G].getAttribute("cFontColor")!==undefined){v[G].setAttribute("cFontColor",new f.Color(E.getHSL().l*255>120?"#000000":"#ffffff"))}v[G].refreshNode()}},defaultOpacity:D,onOpacityChangedCB:function(E){for(var F=0;F<v.length;F++){v[F].setAttribute("bIsFilled",true);v[F].setAttribute(B.opacityAttr,E.opacity);v[F].refreshNode()}},defaultResetState:z,resetButtonLabel:B.colorAttr==="cFillStyleColor"?h.noFill:h.noBorder,onResetButtonPressedCB:function(){for(var E=0;E<v.length;E++){v[E].setAttribute(B.colorAttr==="cFillStyleColor"?"bIsFilled":"bHasBorder",false);v[E].refreshNode()}}})}}function p(u,v){if(!u||!u.hasAttribute("fLineStyleThickness")){return}if(v.thickness){u.setAttribute("fLineStyleThickness",v.thickness);if(u.hasAttribute("fLeaderStyleThickness")){u.setAttribute("fLeaderStyleThickness",v.thickness)}}if(v.type>=0){u.setAttribute("bHasBorder",v.type>0);if(v.type>0){u.setAttribute("sLineStylePattern",v.type.toString())}}u.refreshNode()}function j(u,w){if(!u||!u.hasAttribute("fFontSize")||u.GetType().indexOf("Picture")!==-1){return}var v=u.getAttribute("iFontSize");if(v){v=d.convertPixelToModel({sizeInPixels:v,viewer:u._viewer})}else{v=u.getAttribute("fFontSize")}if(w==="Increase"){u.setAttribute("fFontSize",v+1)}else{if(v-1>0){u.setAttribute("fFontSize",v-1)}}u.refreshNode()}var r=c.get();var l=this._id.replace("Marker_","").replace("Measure_","").replace("Section_","");var k=g.getReviewContext({viewer:this.getFrameWindow().getViewer()});if(l!=="DMUFillGraphicPropHdr"&&l!=="DMUBorderGraphicPropHdr"){for(var s=0;s<r.length;s++){var m=k.getCurrentReview().getDMUObjectFromPathElement(r[s].pathElement);if(m){switch(l){case"DMUNoBorderTypeHdr":p(m,{type:0});break;case"DMUBorder1TypeHdr":p(m,{type:1});break;case"DMUBorder2TypeHdr":p(m,{type:2});break;case"DMUBorder3TypeHdr":p(m,{type:3});break;case"DMUBorder4TypeHdr":p(m,{type:4});break;case"DMUBorder5TypeHdr":p(m,{type:5});break;case"DMUBorder6TypeHdr":p(m,{type:6});break;case"DMUBorder7TypeHdr":p(m,{type:7});break;case"DMUBorder1SizeHdr":p(m,{thickness:1});break;case"DMUBorder2SizeHdr":p(m,{thickness:2});break;case"DMUBorder3SizeHdr":p(m,{thickness:3});break;case"DMUBorder4SizeHdr":p(m,{thickness:4});break;case"DMUBorder5SizeHdr":p(m,{thickness:5});break;case"DMUBorder6SizeHdr":p(m,{thickness:6});break;case"DMUBorder7SizeHdr":p(m,{thickness:7});break;case"DMUBorder8SizeHdr":p(m,{thickness:8});break;case"DMUDefaultStyleHdr":if(m.hasAttribute("sFontStyle")&&m.GetType().indexOf("Picture")===-1){m.setAttributes([{name:"fOpacity",value:1},{name:"cFontColor",value:new f.Color("#000000")},{name:"sFontStyle",value:"normal"},{name:"cFillStyleColor",value:new f.Color("#ffffff")},{name:"bIsFilled",value:true},{name:"bHasBorder",value:true},{name:"fLineStyleThickness",value:1},{name:"sLineStylePattern",value:"1"},{name:"cLineStyleColor",value:new f.Color("#afafaf")},{name:"fLeaderStyleThickness",value:1},{name:"sLeaderStylePattern",value:"1"},{name:"cLeaderStyleColor",value:new f.Color("#3d3d3d")}]);m.refreshNode()}break;case"DMUMeasureStyleHdr":if(m.hasAttribute("sFontStyle")&&m.GetType().indexOf("Picture")===-1){m.setAttributes([{name:"fOpacity",value:1},{name:"cFontColor",value:new f.Color("#ffffff")},{name:"sFontStyle",value:"normal"},{name:"cFillStyleColor",value:new f.Color("#368ec4")},{name:"bIsFilled",value:true},{name:"bHasBorder",value:false},{name:"fLineStyleThickness",value:1},{name:"sLineStylePattern",value:"1"},{name:"cLineStyleColor",value:new f.Color("#3d3d3d")},{name:"fLeaderStyleThickness",value:1},{name:"sLeaderStylePattern",value:"1"},{name:"cLeaderStyleColor",value:new f.Color("#3d3d3d")}]);m.refreshNode()}break;case"DMUPostitStyleHdr":if(m.hasAttribute("sFontStyle")&&m.GetType().indexOf("Picture")===-1){m.setAttributes([{name:"fOpacity",value:1},{name:"cFontColor",value:new f.Color("#000000")},{name:"sFontStyle",value:"italic"},{name:"cFillStyleColor",value:new f.Color("#fee000")},{name:"bIsFilled",value:true},{name:"bHasBorder",value:false},{name:"fLineStyleThickness",value:1},{name:"sLineStylePattern",value:"1"},{name:"cLineStyleColor",value:new f.Color("#ff8a2e")},{name:"fLeaderStyleThickness",value:1},{name:"sLeaderStylePattern",value:"1"},{name:"cLeaderStyleColor",value:new f.Color("#ff8a2e")}]);m.refreshNode()}break;case"DMUValidateStyleHdr":if(m.hasAttribute("sFontStyle")&&m.GetType().indexOf("Picture")===-1){m.setAttributes([{name:"fOpacity",value:1},{name:"cFontColor",value:new f.Color("#ffffff")},{name:"sFontStyle",value:"normal"},{name:"cFillStyleColor",value:new f.Color("#57b847")},{name:"bIsFilled",value:true},{name:"bHasBorder",value:false},{name:"fLineStyleThickness",value:1},{name:"sLineStylePattern",value:"1"},{name:"cLineStyleColor",value:new f.Color("#477738")},{name:"fLeaderStyleThickness",value:1},{name:"sLeaderStylePattern",value:"1"},{name:"cLeaderStyleColor",value:new f.Color("#477738")}]);m.refreshNode()}break;case"DMUWarningStyleHdr":if(m.hasAttribute("sFontStyle")&&m.GetType().indexOf("Picture")===-1){m.setAttributes([{name:"fOpacity",value:1},{name:"cFontColor",value:new f.Color("#ffffff")},{name:"sFontStyle",value:"normal"},{name:"cFillStyleColor",value:new f.Color("#ff8a2e")},{name:"bIsFilled",value:true},{name:"bHasBorder",value:false},{name:"fLineStyleThickness",value:1},{name:"sLineStylePattern",value:"1"},{name:"cLineStyleColor",value:new f.Color("#8f4c00")},{name:"fLeaderStyleThickness",value:1},{name:"sLeaderStylePattern",value:"1"},{name:"cLeaderStyleColor",value:new f.Color("#8f4c00")}]);m.refreshNode()}break;case"DMUCautionStyleHdr":if(m.hasAttribute("sFontStyle")&&m.GetType().indexOf("Picture")===-1){m.setAttributes([{name:"fOpacity",value:1},{name:"cFontColor",value:new f.Color("#ffffff")},{name:"sFontStyle",value:"bold"},{name:"cFillStyleColor",value:new f.Color("#cc092f")},{name:"bIsFilled",value:true},{name:"bHasBorder",value:false},{name:"fLineStyleThickness",value:1},{name:"sLineStylePattern",value:"1"},{name:"cLineStyleColor",value:new f.Color("#6d2828")},{name:"fLeaderStyleThickness",value:1},{name:"sLeaderStylePattern",value:"1"},{name:"cLeaderStyleColor",value:new f.Color("#6d2828")}]);m.refreshNode()}break;case"DMULightStyleHdr":if(m.hasAttribute("sFontStyle")&&m.GetType().indexOf("Picture")===-1){m.setAttributes([{name:"fOpacity",value:1},{name:"cFontColor",value:new f.Color("#000000")},{name:"sFontStyle",value:"normal"},{name:"cFillStyleColor",value:new f.Color("#ffffff")},{name:"bIsFilled",value:false},{name:"bHasBorder",value:false},{name:"fLineStyleThickness",value:1},{name:"sLineStylePattern",value:"1"},{name:"cLineStyleColor",value:new f.Color("#3d3d3d")},{name:"fLeaderStyleThickness",value:1},{name:"sLeaderStylePattern",value:"1"},{name:"cLeaderStyleColor",value:new f.Color("#3d3d3d")}]);m.refreshNode()}break;case"DMUIncreaseFontSizeHdr":j(m,"Increase");break;case"DMUDecreaseFontSizeHdr":j(m,"Decrease");break}}}}else{var n=[];for(var s=0;s<r.length;s++){n.push(k.getCurrentReview().getDMUObjectFromPathElement(r[s].pathElement))}if(l==="DMUFillGraphicPropHdr"){q(n,{colorAttr:"cFillStyleColor",opacityAttr:"fOpacity",displayResetBtn:this._id.indexOf("Section_")===-1})}else{q(n,{colorAttr:"cLineStyleColor",displayResetBtn:false})}}this.end()}})});define("DS/DMUBaseCtxCommands/DMUHideShowCmd",["DS/ApplicationFrame/Command","DS/DMUControls/EXPNotify","DS/DMUBaseExperience/DMUContextManager","DS/Selection/CSOManager","i18n!DS/DMUBaseCtxCommands/assets/nls/DMUBaseCtxCommands"],function(e,c,d,b,a){return e.extend({init:function(g){this._parent(g,"shared");var f,h=this;this.beginExecute=function(){var p=d.getReviewContext({viewer:h.getFrameWindow().getViewer()});if(p&&!p.isReadOnly()&&p.getCurrentReview()&&!p.getCurrentReview().isReadOnly()){var l=b.get();var k=[];var i=p.getCurrentReview();var m=false,o;for(o=0;o<l.length;o++){var j=i.getDMUObjectFromPathElement(l[o].pathElement,i.getCurrentSlide()===null,true);if(j){k.push(j)}else{m=true}}for(o=0;o<k.length;o++){var n=k[o].getAttribute("bVisible");k[o].setAttribute("bVisible",n===undefined||n===null?false:!n);k[o].refreshNode()}b.empty();if(m){if(f){f.destroy()}f=new c({body:h.getFrameWindow().getUIFrame(),type:"warning",messages:a.slideNeededLabel})}}h.end()}}})});define("DS/DMUBaseCtxCommands/DMUDeleteCmd",["UWA/Core","DS/ApplicationFrame/Command","DS/DMUBaseExperience/DMUContextManager","DS/Selection/CSOManager","DS/DMUControls/DMUWarningPanel","i18n!DS/DMUBaseCtxCommands/assets/nls/DMUBaseCtxCommands"],function(g,e,d,b,a,c){var f;return e.extend({init:function(h){this._parent(h,"shared")},beginExecute:function(p){this._parent(p);var l=this;if(f){return l.end()}var n=b.get();var i=d.getReviewContext({viewer:this.getFrameWindow().getViewer()});var j=i?i.getCurrentReview():null;var h=[];for(var o=n.length-1;o>=0;o--){var m=j.getDMUObjectFromPathElement(n[o].pathElement);if(m&&!m.isReadOnly()){h.push(m)}}if(h.length){var k=function(){for(var q=h.length-1;q>=0;q--){if(h[q].sectionCancel){h[q].sectionCancel()}else{if(h[q].measureCancel){h[q].measureCancel()}else{h[q].remove()}}}};if(this._id.indexOf("Quick")===-1){f=new a({title:c.deleteWarningPanel.title,message:c.deleteWarningPanel.message,frmWindow:this.getFrameWindow(),callbacks:{onValidateCB:function(){k();f=null},onCancelCB:function(){l.end();f=null},onCloseCB:function(){l.end();f=null}}})}else{k()}}else{this.end()}},_destroy:function(){if(f){f.destroy()}this._parent()}})});