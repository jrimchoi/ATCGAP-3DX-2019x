define("DS/ModelLoader_mineschedanimation/GEOMSAResult3D",["UWA/Core","UWA/Class"],function(c,b){var a=b.extend({init:function(d){var e=this;if(d.canvassetting){e.canvassetting=c.extend({locations:{colouring:"by location"},mining:{visibility:"removed",visible:"true"},filling:{visibility:"added",visible:"true"},development:{visibility:"added",visible:"true"},activities:{visible:"true"},stockpiles:{visible:"true"},tags:{visible:"false"}},d.canvassetting,true);e.initCanvassetting=c.extend({locations:{colouring:"by location"},mining:{visibility:"removed",visible:"true"},filling:{visibility:"added",visible:"true"},development:{visibility:"added",visible:"true"},activities:{visible:"true"},stockpiles:{visible:"true"},tags:{visible:"false"}},d.canvassetting,true)}e.node=d.node;e.periods=[];if(d.periods&&d.periods.length){e.periods=d.periods}e.currentPeriod=0;e.msaNodes=[]},applyPeriod:function(f){var e=this;var d=e.currentPeriod;if(f!==undefined){d=f}if(d!==undefined){e.msaNodes.forEach(function(g){g.applyPeriod(d)});e.currentPeriod=d}},modifyFillingVisibility:function(g){var f=this;if((g==="added")||(g==="removed")||(g==="single")){f.canvassetting.filling.visible="true";var d=f.canvassetting.filling.visibility;var e=d.split(" ");f.canvassetting.filling.visibility=d.replace(e[0],g)}else{if(g==="false"){f.canvassetting.filling.visible="false"}}},modifyMiningVisibility:function(g){var f=this;if((g==="added")||(g==="removed")||(g==="single")){f.canvassetting.mining.visible="true";var d=f.canvassetting.mining.visibility;var e=d.split(" ");f.canvassetting.mining.visibility=d.replace(e[0],g)}else{if(g==="false"){f.canvassetting.mining.visible="false"}}},modifyDvlpVisibility:function(g){var f=this;if((g==="added")||(g==="removed")||(g==="single")){f.canvassetting.development.visible="true";var d=f.canvassetting.development.visibility;var e=d.split(" ");f.canvassetting.development.visibility=d.replace(e[0],g)}else{if(g==="false"){f.canvassetting.development.visible="false"}}},setting:function(e,f){var d=this;if((f!==undefined)&&(e!==undefined)){switch(f){case"activity":d.canvassetting.activities.visible=e;break;case"stockpile":d.canvassetting.stockpiles.visible=e;break;case"production":d.modifyDvlpVisibility(e);d.modifyFillingVisibility(e);d.modifyMiningVisibility(e);break;default:console.log("This parameter is not implemented")}}console.log("init");console.log(d.initCanvassetting)},restore:function(){var d=this;d.canvassetting.activities.visible=d.initCanvassetting.activities.visible;d.canvassetting.development.visible=d.initCanvassetting.development.visible;d.canvassetting.filling.visible=d.initCanvassetting.filling.visible;d.canvassetting.mining.visible=d.initCanvassetting.mining.visible;d.canvassetting.stockpiles.visible=d.initCanvassetting.stockpiles.visible;d.canvassetting.tags.visible=d.initCanvassetting.tags.visible;d.canvassetting.development.visibility=d.initCanvassetting.development.visibility;d.canvassetting.filling.visibility=d.initCanvassetting.filling.visibility;d.canvassetting.mining.visibility=d.initCanvassetting.mining.visibility},inWitchSetting:{mining:"mining",filling:"filling",development:"development",activity:"activities",stockpile:"stockpiles"}});return a});define("DS/ModelLoader_mineschedanimation/GEOMSAMeshNode",["UWA/Core","UWA/Class","DS/Visualization/ThreeJS_DS","DS/Mesh/Mesh"],function(e,b,c,d){var a=b.extend({init:function(f){var g=this;g.tag=f.tag;g.visibility=f.visibility;g.overridevisibility=f.overridevisibility;g.result3dNode=f.result3dNode;g.node=f.node;if(g.result3dNode&&g.result3dNode.msaResult3d&&g.result3dNode.msaResult3d.msaNodes){g.result3dNode.msaResult3d.msaNodes.push(g)}g.color=f.color;if(!g.node.css3DNode||g.visibility!=="stockpile"){g.period=f.period}},_getVisibility:function(){var h=this;var i="single";if(h.result3dNode&&h.result3dNode.msaResult3d&&h.result3dNode.msaResult3d.canvassetting&&h.visibility){var g=h.result3dNode.msaResult3d.inWitchSetting[h.visibility];if(h.result3dNode.msaResult3d.canvassetting[g].visibility){i=h.result3dNode.msaResult3d.canvassetting[g].visibility}if(h.overridevisibility){i=h.overridevisibility}}var f={};f.isAtStart=!h.period||i.includes("at start");if(i.includes("added")){f.mode="added"}else{if(i.includes("removed")){f.mode="removed";f.isAtStart=true}else{f.mode="single"}}return f},_getVisible:function(){var h=this;var f=true;if(h.result3dNode&&h.result3dNode.msaResult3d&&h.result3dNode.msaResult3d.canvassetting){if(!h.node.css3DNode||h.result3dNode.msaResult3d.canvassetting.tags.visible==="true"){if(h.visibility){var g=h.result3dNode.msaResult3d.inWitchSetting[h.visibility];if(h.result3dNode.msaResult3d.canvassetting[g].visible===undefined){f=true}else{f=h.result3dNode.msaResult3d.canvassetting[g].visible==="true"}}}else{f=false}}return f},_getColors:function(){var h=this;var f;if(h.color){f={"by location":h.color};if(h.visibility!=="mining"&&h.visibility!=="filling"&&h.visibility!=="development"){f["by period"]=f["by location"]}else{if(h.result3dNode&&h.result3dNode.msaResult3d&&h.result3dNode.msaResult3d.canvassetting){var g=h.period%12;f["by period"]={a:h.color.a};f["by period"].r=(g<3||g>9)?255:((g>3&&g<9)?0:127);f["by period"].g=(g<1||g>7)?0:((g>1&&g<7)?255:127);f["by period"].b=(g<5||g>11)?0:((g>5&&g<11)?255:127)}}}return f},applyColorSettings:function(){var j=this;var g=j._getColors();if(g&&g["by period"]&&g["by location"]&&j.result3dNode&&j.result3dNode.msaResult3d&&j.result3dNode.msaResult3d.canvassetting){var h;var f=new d.Color(g["by period"].r/255,g["by period"].g/255,g["by period"].b/255,g["by period"].a/255);var i=new d.Color(g["by location"].r/255,g["by location"].g/255,g["by location"].b/255,g["by location"].a/255);if(j.result3dNode.msaResult3d.canvassetting.locations&&j.result3dNode.msaResult3d.canvassetting.locations.colouring==="by period"){h=f}else{h=i}if(j.node.css3DNode){j.node.css3DNode.element.style.backgroundColor="rgba("+h.r*255+", "+h.g*255+", "+h.b*255+", 0.5)"}else{if(j.node.mesh3js){j.node.mesh3js.sceneGraph.children[0].primitives[0].group.gas.color.r=h.r;j.node.mesh3js.sceneGraph.children[0].primitives[0].group.gas.color.g=h.g;j.node.mesh3js.sceneGraph.children[0].primitives[0].group.gas.color.b=h.b}}}},applyPeriod:function(i){var h=this;var g=false;var f=h._getVisible();if(f){var j=h._getVisibility();if(h.node.css3DNode){if(h.period===undefined||j.mode==="added"&&h.period===i||j.mode==="single"&&h.period===i||j.mode==="removed"&&h.period===i+1){g=true;h.node.css3DNode.element.style.removeProperty("display")}else{g=false}}else{if(i===0){if(j.isAtStart&&!h.node.css3DNode){g=true}else{g=false}}else{if(h.period===undefined||j.mode==="added"&&h.period<=i||j.mode==="single"&&h.period===i||j.mode==="removed"&&h.period>i){g=true}else{g=false}}}}h.node.setVisibility(g)}});return a});define("DS/ModelLoader_mineschedanimation/loader",["UWA/Core","UWA/Utils","DS/WebappsUtils/WebappsUtils","DS/Mesh/Mesh","DS/Visualization/SceneGraphFactory","DS/Visualization/Node3D","DS/Visualization/ThreeJS_DS","DS/WAFData/WAFData","DS/Visualization/Utils","DS/SceneGraphNodes/CSS3DNode","DS/SceneGraphNodes/CSS2DNode","DS/ModelLoader_mineschedanimation/GEOMSAMeshNode","DS/ModelLoader_mineschedanimation/GEOMSAResult3D"],function(g,j,d,e,k,i,m,l,a,c,n,h,b){var f=function(){this.load=function(q,v,t,p){var s=this;s.scene=new i();s.scene.name="scene";var u=q;var r={scene:s.scene,url:u,callbacks:{progress:t,done:p}};s._readMineSchedAnimationFD1(r);if(v){v(s.scene)}};this._downloadFileFD1=function(q,p){if(q.provider&&q.provider==="FILE"){l.request(q.filename,{method:"GET",responseType:"arraybuffer",type:"arraybuffer",onComplete:p})}else{l.handlerequest(q,{method:"GET",responseType:"arraybuffer",type:"arraybuffer",onComplete:p})}};this.creDelegUnzip=function(s){var r=this;var p=r._msaworker.promises.length;s.id=p;var q={};var t=new Promise(function(u){r._msaworker.postMessage(s);q.resolve=function(v){u(v)}});r._msaworker.promises[p]=q;return t};this._readMineSchedAnimationFD1=function(C){var A=this;var r=d.getWebappsBaseUrl();var B=!j.matchUrl(r,window.location)?"Passport":null;var s={provider:"FILE",filename:"AmdLoader.js",serverurl:r+"AmdLoader/",requiredAuth:B};var t={provider:"FILE",filename:"ThreeJS_Base.js",serverurl:r+"Mesh/",requiredAuth:B};var z={provider:"FILE",filename:"mineschedanimationWorker.js",serverurl:r+"GEOV1Workers/",requiredAuth:B};var u={provider:"FILE",filename:"GEO7zip.js",serverurl:r+"GEO7zip/",requiredAuth:B};var p={provider:"FILE",filename:"minizip-asm.min.js",serverurl:r+"GEO7zip/nodejs/node_modules/minizip-asm.js/lib/",requiredAuth:B};var y=[s,t,u,p,z];if(!A._msaworker){A._msaworker={promises:[],initialize:function(E){if(A._msaworker.workers.length!==5){var D=setInterval(function(){if(A._msaworker.workers.length===5){clearInterval(D);A._msaworker.initialize(E)}},50);return}A._msaworker.workers.forEach(function(F){F.postMessage(E)})},postMessage:function(E){var D=A._msaworker.workers.shift();A._msaworker.workers.push(D);D.postMessage(E)},terminate:function(){A._msaworker.workers.forEach(function(D){D.terminate()})},workers:[]};var v=function(F){var E=A._msaworker.promises[F.data.id];var D={data:F.data.data,zipSize:F.data.zipSize,meshInputs:F.data.meshInputs};E.resolve(D)};for(var x=1;x<=5;x++){a.getWorkerBlobFromSpecs(y,function(E){var D=new Worker(E);D.onmessage=function(F){v(F)};A._msaworker.workers.push(D)})}}if(!A._plyworker){A._plyworker={promises:[],postMessage:function(E){var D=A._plyworker.workers.shift();A._plyworker.workers.push(D);D.postMessage(E)},terminate:function(){A._plyworker.workers.forEach(function(D){D.terminate()})},workers:[]};var q=function(F){var E=A._plyworker.promises[F.data.id];var D={meshInputs:F.data.meshInputs};E.resolve(D)};for(var w=1;w<=3;w++){a.getWorkerBlobFromSpecs(y,function(E){var D=new Worker(E);D.onmessage=function(F){q(F)};A._plyworker.workers.push(D)})}}A._downloadFileFD1(C.url,function(G){if(A._msaworker){var E=A._msaworker.promises.length;var F={};var D=new Promise(function(H){A._msaworker.initialize({arraybuffer:G,id:E});F.resolve=function(I){H(I)}});A._msaworker.promises[E]=F;D.then(function(){var H=A.creDelegUnzip({meshName:"results3d.xml"});return H.then(function(K){if(!A.totalprogress){A.totalprogress=K.zipSize;A.progress=0}A.progress+=1;if(C.callbacks.progress){C.callbacks.progress({loaded:A.progress,total:A.totalprogress})}var L=A._createResult3D(C,K.data);var I={loaderinputs:C,result3DEntry:K.data,result3DNode:L};var J=A._appendMeshes(I);return J}).then(function(){A._msaworker.terminate();A._plyworker.terminate();C.callbacks.done()})})}})};this._createResult3D=function(C,t){var J=new i();J.name="Result3dNode";J.productType="Reference3D";C.scene.addChild(J);var v=new DOMParser();var G=v.parseFromString(t.data,"text/xml");var p={};var z=G.evaluate("/results3d/settings/canvassettings/*",G,null,XPathResult.ORDERED_NODE_SNAPSHOT_TYPE,null);for(var I=0;I<z.snapshotLength;I++){var M=z.snapshotItem(I);if(!p.canvassetting){p.canvassetting={}}var s=M.nodeName;p.canvassetting[s]={};var E=G.evaluate("./*",M,null,XPathResult.ORDERED_NODE_SNAPSHOT_TYPE,null);for(var P=0;P<E.snapshotLength;P++){var B=E.snapshotItem(P);var L=B.nodeName;var A=B.textContent;p.canvassetting[s][L]=A}}var H=G.evaluate("/results3d/period",G,null,XPathResult.ORDERED_NODE_SNAPSHOT_TYPE,null);var R=[];var w;for(var F=0;F<H.snapshotLength;F++){if(F===0){R.push({number:0})}w=H.snapshotItem(F);var r=G.evaluate("./number",w,null,XPathResult.ANY_TYPE,null);var y=G.evaluate("./start",w,null,XPathResult.ANY_TYPE,null);var x=G.evaluate("./end",w,null,XPathResult.ANY_TYPE,null);var q=r.iterateNext().textContent;var Q=y.iterateNext();var K=x.iterateNext();var u=new Date(Q.attributes.year.value,Q.attributes.month.value,Q.attributes.day.value);var O=new Date(K.attributes.year.value,K.attributes.month.value,K.attributes.day.value);var N={number:parseInt(q),start:u,end:O};R.push(N)}p.node=J;p.periods=R;var D=new b(p);J.msaResult3d=D;return J};this._appendMeshes=function(r){var q=this;var p=[];p=p.concat(q._appendStaticMeshes(r));p=p.concat(q._appendMeshForPeriod(r));p=p.concat(q._appendScaledMesh(r));return Promise.all(p)};this._appendStaticMeshes=function(r){var w=this;var t=[];var q=new DOMParser();var x=q.parseFromString(r.result3DEntry.data,"text/xml");var D=x.evaluate("/results3d/staticmesh",x,null,XPathResult.ORDERED_NODE_SNAPSHOT_TYPE,null);var s;for(var y=0;y<D.snapshotLength;y++){s=D.snapshotItem(y);var F=x.evaluate("./filename",s,null,XPathResult.ANY_TYPE,null);var p=x.evaluate("./color/r",s,null,XPathResult.ANY_TYPE,null);var v=x.evaluate("./color/g",s,null,XPathResult.ANY_TYPE,null);var z=x.evaluate("./color/b",s,null,XPathResult.ANY_TYPE,null);var A=x.evaluate("./color/a",s,null,XPathResult.ANY_TYPE,null);var I=F.iterateNext().textContent;var u={Red:p.iterateNext().textContent,Green:v.iterateNext().textContent,Blue:z.iterateNext().textContent,Alpha:A.iterateNext().textContent};u.color={r:parseInt(u.Red),g:parseInt(u.Green),b:parseInt(u.Blue),a:parseInt(u.Alpha)};u.result3dNode=r.result3DNode;var B=x.evaluate("./tag/line",s,null,XPathResult.ORDERED_NODE_SNAPSHOT_TYPE,null);var C;if(B){u.Tags=[];u.tag=[];for(var H=0;H<B.snapshotLength;H++){C=B.snapshotItem(H);u.Tags.push(C.textContent);u.tag.push(C.textContent)}}if(w._msaworker){var J=w.creDelegUnzip({meshName:I});var E=Promise.resolve(u);var G=Promise.all([E,J]).then(function(L){var M=L[0];var K=L[1].data;return w._parsePLY(K.data,M).then(function(O){var P=O.createdMesh;var N=O.parameters;return new Promise(function(R){N.bs=P.getBoundingSphere();N.bb=P.getBoundingBox();var Q=w._createTagNode(N);r.result3DNode.addChild(P);if(Q){r.result3DNode.addChild(Q)}P.mesh3js.sceneGraph.children[0].solid=1;R(P)})})});t.push(G);G.then(function(){w.progress+=1;if(r.loaderinputs.callbacks.progress){r.loaderinputs.callbacks.progress({loaded:w.progress,total:w.totalprogress})}})}}return t};this._appendMeshForPeriod=function(r){var x=this;var t=[];var q=new DOMParser();var y=q.parseFromString(r.result3DEntry.data,"text/xml");var H=y.evaluate("/results3d/meshforperiod",y,null,XPathResult.ORDERED_NODE_SNAPSHOT_TYPE,null);var s;for(var z=0;z<H.snapshotLength;z++){s=H.snapshotItem(z);var I=y.evaluate("./filename",s,null,XPathResult.ANY_TYPE,null);var p=y.evaluate("./color/r",s,null,XPathResult.ANY_TYPE,null);var v=y.evaluate("./color/g",s,null,XPathResult.ANY_TYPE,null);var B=y.evaluate("./color/b",s,null,XPathResult.ANY_TYPE,null);var C=y.evaluate("./color/a",s,null,XPathResult.ANY_TYPE,null);var w=y.evaluate("./period",s,null,XPathResult.ANY_TYPE,null);var K=y.evaluate("./visibility",s,null,XPathResult.ANY_TYPE,null);var A=y.evaluate("./overridevisibility",s,null,XPathResult.ANY_TYPE,null);var M=I.iterateNext().textContent;var u={Red:p.iterateNext().textContent,Green:v.iterateNext().textContent,Blue:B.iterateNext().textContent,Alpha:C.iterateNext().textContent,Period:w.iterateNext().textContent};u.color={r:parseInt(u.Red),g:parseInt(u.Green),b:parseInt(u.Blue),a:parseInt(u.Alpha)};u.period=parseInt(u.Period);if(K){var G=K.iterateNext();if(G){u.visibility=G.textContent}}if(A){var D=A.iterateNext();if(D){u.overridevisibility=D.textContent}}u.result3dNode=r.result3DNode;var E=y.evaluate("./tag/line",s,null,XPathResult.ORDERED_NODE_SNAPSHOT_TYPE,null);var F;if(E){u.Tags=[];u.tag=[];for(var L=0;L<E.snapshotLength;L++){F=E.snapshotItem(L);u.Tags.push(F.textContent);u.tag.push(F.textContent)}}if(x._msaworker){var N=x.creDelegUnzip({meshName:M});var J=Promise.all([Promise.resolve(u),N]).then(function(P){var Q=P[0];var O=P[1].data;return x._parsePLY(O.data,Q).then(function(S){var T=S.createdMesh;var R=S.parameters;return new Promise(function(V){R.bs=T.getBoundingSphere();R.bb=T.getBoundingBox();var U=x._createTagNode(R);r.result3DNode.addChild(T);if(U){r.result3DNode.addChild(U)}T.mesh3js.sceneGraph.children[0].solid=1;V(T)})})});t.push(J);J.then(function(){x.progress+=1;if(r.loaderinputs.callbacks.progress){r.loaderinputs.callbacks.progress({loaded:x.progress,total:x.totalprogress})}})}}return t};this._appendScaledMesh=function(s){var z=this;var u=[];var q=new DOMParser();var A=q.parseFromString(s.result3DEntry.data,"text/xml");var J=A.evaluate("/results3d/scaledmesh",A,null,XPathResult.ORDERED_NODE_SNAPSHOT_TYPE,null);var t;for(var B=0;B<J.snapshotLength;B++){t=J.snapshotItem(B);var L=A.evaluate("./filename",t,null,XPathResult.ANY_TYPE,null);var p=A.evaluate("./color/r",t,null,XPathResult.ANY_TYPE,null);var y=A.evaluate("./color/g",t,null,XPathResult.ANY_TYPE,null);var D=A.evaluate("./color/b",t,null,XPathResult.ANY_TYPE,null);var F=A.evaluate("./color/a",t,null,XPathResult.ANY_TYPE,null);var G=A.evaluate("./location/x",t,null,XPathResult.ANY_TYPE,null);var E=A.evaluate("./location/y",t,null,XPathResult.ANY_TYPE,null);var C=A.evaluate("./location/z",t,null,XPathResult.ANY_TYPE,null);var x=A.evaluate("./scalefactors/factor",t,null,XPathResult.ORDERED_NODE_SNAPSHOT_TYPE,null);var P=[];for(var v=0;v<x.snapshotLength;v++){var r=x.snapshotItem(v);var N=A.evaluate("./period",r,null,XPathResult.ANY_TYPE,null);var K=A.evaluate("./scale",r,null,XPathResult.ANY_TYPE,null);P[v]={period:N.iterateNext().textContent,scale:K.iterateNext().textContent}}var Q=L.iterateNext().textContent;var w={Red:p.iterateNext().textContent,Green:y.iterateNext().textContent,Blue:D.iterateNext().textContent,Alpha:F.iterateNext().textContent,LocationX:G.iterateNext().textContent,LocationY:E.iterateNext().textContent,LocationZ:C.iterateNext().textContent,ScaleFactors:P};w.color={r:parseInt(w.Red),g:parseInt(w.Green),b:parseInt(w.Blue),a:parseInt(w.Alpha)};w.visibility="stockpile";var H=A.evaluate("./tag/line",t,null,XPathResult.ORDERED_NODE_SNAPSHOT_TYPE,null);var I;if(H){w.Tags=[];w.tag=[];for(var O=0;O<H.snapshotLength;O++){I=H.snapshotItem(O);w.Tags.push(I.textContent);w.tag.push(I.textContent)}}if(z._msaworker){var R=z.creDelegUnzip({meshName:Q});var M=Promise.all([Promise.resolve(w),R]).then(function(ac){var ae=ac[0];var af=ac[1].data;var S=ae.ScaleFactors;var X=ae.LocationX;var W=ae.LocationY;var V=ae.LocationZ;var U=new i(af.name);s.result3DNode.addChild(U);var ab=[];for(var aa=0;aa<S.length;aa++){var Z=S[aa];var ad=g.clone(ae);ad.Scale=Z.scale;ad.period=parseInt(Z.period);ad.result3dNode=s.result3DNode;var T=z._parsePLY(af.data,ad).then(function(ag){var ah=ag.createdMesh;return new Promise(function(ai){ah.translateX(X*1000);ah.translateY(W*1000);ah.translateZ(V*1000);U.addChild(ah);ah.mesh3js.sceneGraph.children[0].solid=1;ai(ah)})});ab.push(T)}ae.bs=U.getBoundingSphere();ae.bb=U.getBoundingBox();var Y=z._createTagNode(ae);if(Y){s.result3DNode.addChild(Y)}return Promise.all(ab)});u.push(M);M.then(function(){z.progress+=1;if(s.loaderinputs.callbacks.progress){s.loaderinputs.callbacks.progress({loaded:z.progress,total:z.totalprogress})}})}}return u};var o=function(y,w,A,q,p){var r=new e.PrimitiveGroup();r.fillAttr=new e.FillAttributes();r.lineAttr=new e.LineAttributes();r.pointAttr=new e.PointAttributes();var t=new e.Buffer();t.size=3*3*y;t.component=e.VertexComponentEnum.POSITION;t.format=e.DataTypeEnum.FLOAT;t.dimension=3;t.data=w;var u=new e.Buffer();u.size=3*3*y;u.component=e.VertexComponentEnum.NORMAL;u.format=e.DataTypeEnum.FLOAT;u.dimension=3;u.data=A;var C=null;if(q){C=new e.Buffer();C.size=4*y;C.component=e.VertexComponentEnum.DIFFUSE_COLOR;C.format=e.DataTypeEnum.FLOAT;C.dimension=4;C.data=p}r.addBuffer(0,t);r.addBuffer(1,u);if(q){r.addBuffer(2,C)}var x=new e.Primitive({identifier:"face"});x.geomType="FACE";x.nbIndices=3*y;x.connectivity=e.ConnectivityTypeEnum.TRIANGLES;x.attr={fill:new e.FillAttributes(new e.Color(p[0]/255,p[1]/255,p[2]/255,p[3]/255)),line:new e.LineAttributes(),point:new e.PointAttributes()};var B=new m.MeshPhongMaterial({color:new m.Color().setRGB(p[0]/255,p[1]/255,p[2]/255),opacity:p[3]/255,side:m.DoubleSide});B.force=true;x.material=B;var v=new e.VertexComponent();v.component=e.VertexComponentEnum.POSITION;v.nbVertices=3*y;v.nbValuesPerVertex=3;v.format=e.DataTypeEnum.FLOAT;v.cardinality=0;v.bufferId=0;v.indices=null;var z=new e.VertexComponent();z.component=e.VertexComponentEnum.NORMAL;z.nbVertices=3*y;z.nbValuesPerVertex=3;z.format=e.DataTypeEnum.FLOAT;z.cardinality=0;z.bufferId=1;z.indices=null;x.addVertexComponent(v);x.addVertexComponent(z);var s=null;if(q){s=new e.VertexComponent();s.component=e.VertexComponentEnum.DIFFUSE_COLOR;s.nbVertices=3*y;s.nbValuesPerVertex=4;s.format=e.DataTypeEnum.FLOAT;s.cardinality=0;s.bufferId=2;s.indices=null;x.addVertexComponent(s)}r.addPrimitive(x);return k.createMeshNode(r)};this._parsePLY=function(v,t){var s=this;if(s._plyworker.workers.length!==3){var r=setInterval(function(){if(s._plyworker.workers.length===3){clearInterval(r);_parsePLY(v,t)}},50);return}var p=s._plyworker.promises.length;var q={};var w=new Promise(function(x){s._plyworker.postMessage({ply:v,parameters:{color:t.color,Scale:t.Scale},id:p});q.resolve=function(y){x(y)}});s._plyworker.promises[p]=q;var u=Promise.all([Promise.resolve(t),w]).then(function(x){return new Promise(function(B){var A=x[0];var z=x[1].meshInputs;var C=o(z.nbFaces,z.vertices,z.normals,true,z.colors);var y=A.Tags;C.tags=y;A.node=C;var D=new h(A);C.msaNode=D;D.applyColorSettings();D.applyPeriod(0);B({createdMesh:C,parameters:A})})});return u};this._createTagNode=function(){var p;return p}};return f});