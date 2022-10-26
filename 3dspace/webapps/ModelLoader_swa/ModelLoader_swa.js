define("DS/ModelLoader_swa/loader",["DS/Mesh/Mesh","DS/Visualization/SceneGraphFactory","DS/Visualization/Node3D","DS/Visualization/Utils","DS/Visualization/ThreeJS_DS","DS/GEONavDriveAPI/GEOdriveServices","DS/GEOV1Loader/GEOstrServices","DS/GEOV1Loader/GEOdtmServices","DS/GEOV1Loader/GEOsdmServices","DS/WebInfraUI/Notification","DS/WebSystem/Nls","DS/Core/Events"],function(d,g,f,b,h,a,c,m,e,j,k,l){var i=function(){this.errorCallbackFunc=null;this.load=function(p,y,t,s,v,z){var A=this;A.errorCallbackFunc=(v!==undefined)?v:null;var u=p.filename;var x=false;var w=false;var r=false;A.scene=new f();A.scene.name="scene";A.scene.productType="Reference3D";var q=0;var o=0;A.doneDTM=function(B){var D=B.length;for(var C=0;C<D;C++){B[C].mesh3js.sceneGraph.children[0].solid=1;A.scene.addChild(B[C])}o++;if(o==q){s()}};A.doneStr=function(B){var D=B.length;for(var C=0;C<D;C++){A.scene.addChild(B[C])}if(z){z({hack:true,updateInfinitePlane:true})}o++;if(o==q){s()}};A.doneSdm=function(D){var C=D.length;for(var B=0;B<C;B++){A.scene.addChild(D[B])}if(z){z({hack:true,updateInfinitePlane:true})}o++;if(o==q){s()}};A.errorSwaItemCB=function(B){A._errorLoader("LOAD_SWA_ITEM",p)};A.processSwa=function(H){var C=new m();var F=new c();var O=new e();if(H.files==undefined){return false}var D=H.files.length;var L=true;var M=JSON.stringify(p);var J=JSON.parse(M);var K=(p.serverurl?p.serverurl:"");var E="";var N=-1;var B=0;var P=false;for(var G=0;G<D;G++){var I="";if(r||x||w||H.directLocation[G]||H.directPath[G]){P=true}if(H.paths[G].length&&P){I=H.paths[G]+"/"+H.files[G]}else{I=H.files[G]}N=H.files[G].lastIndexOf("/");B=H.files[G].length;var E="";if(N!=-1){E=H.files[G].substring(N+1,B)}if(x){I=E;J.serverurl="";J.filename=K+"/"+H.files[G]}else{if(w){J.serverurl="";I=E;if(H.paths[G].length){J.filename=K+"/"+H.paths[G]+"/"+H.files[G]}else{J.filename=K+"/"+H.files[G]}}else{if(H.directLocation[G]==true){I=E;J.serverurl="";J.filename=K+"/"+H.files[G]}else{if(H.directPath[G]==true){I=E;J.serverurl="";if(H.paths[G].length){J.filename=K+"/"+H.paths[G]+"/"+H.files[G]}else{J.filename=K+"/"+H.files[G]}}}}}if(H.files[G].indexOf(".dtm")!=-1){var Q={multiLoad:true,path:I,isRelativePathName:L,rootPath:"",itemDoneCB:function(R){A.doneDTM(R)}};C.load(J,Q,y,t,s,A.errorSwaItemCB,z)}else{if(H.files[G].indexOf(".str")!=-1){var Q={multiLoad:true,path:I,isRelativePathName:L,rootPath:"",itemDoneCB:function(R){A.doneStr(R)}};F.load(J,Q,y,t,s,A.errorSwaItemCB,z)}else{if(H.files[G].indexOf(".sdm")!=-1){var Q={multiLoad:true,path:I,isRelativePathName:L,rootPath:"",itemDoneCB:function(R){A.doneSdm(R)}};O.load(J,Q,y,t,s,A.errorSwaItemCB,z)}}}}return true};A.parseSwa=function(aj){var ag=function(aD){var ap=aD.replace(/(\s+)/gi," ");var am=ap.replace(/(\()(\w+)(\s)/gi,function(aF,aI,aH,aG){return'{"'+aH+'":['});var al=am.replace(/(\))/gi,"]}");var an=al.split('"');var aE="";for(var aw=0;aw<=an.length;aw++){var at="";if(!(aw%2)){at=an[aw].replace(/(\s)/gi,",")}else{at=an[aw]}aE+=at;if(aw<=an.length){aE+='"'}}var aC=aE.replace(/(\()/gi,"{[");var aA=aC.replace(/(\{)(\[)(.*?)(\])(\})/gi,function(aF){var aG=aF.replace(/(\{)/gi,"").replace(/(\})/gi,"");return aG});var ay=aA.replace(/(\,)(\])/gi,"]");var av=ay.replace(/(\[)(\,)/gi,"[");var aB=av.replace(/([:;,{\[])((?:[a-z][a-z0-9_]*))([:;,}\]])/gi,function(aF,aJ,aI,aH){var aG;if(aJ=='"'&&aH=='"'){aG=aF}else{aG=aJ+'"'+aI+'"'+aH}return aG});var az=aB.replace(/(\d*\.{0,1}\d+)([^.a-zA-Z0-9_])/gi,function(aF,aK,aJ,aI,aG){var aH=parseFloat(aK);return aH+aJ});var ax=az.replace(/(\\)/gi,"/");var aq=ax.split('["end"]');var au="["+aq[0]+'["end"]]';var ao="";try{var ao=JSON.parse(au)}catch(ar){console.log("swa2JSON error="+ar+"\n");return""}return ao};var ak=new m();var H=ag(ak._ensureString(aj));var I=0;var af=0;var W=0;var ae=[];var C=true;var R=[];for(var ai=0;ai<H.length;ai++){if(H[ai]["viewport"]){I++;W=0;af=0;var F={};var ac=H[ai]["viewport"];var J=ac.length;if(I>1){A._errorLoader("PARSE_ONE_VIEWPORT",p);return}if(ac.length==0){A._errorLoader("PARSE_SWA",p);return}for(var V=0;V<J;V++){if(ac[V]["datum"]){W++;if(W>1){C=false;break}var Z=ac[V]["datum"];if(Z.length!=3){C=false;break}F.datumX=Z[0]*1000;F.datumY=Z[1]*1000;F.datumZ=Z[2]*1000}if(ac[V]["camera"]){af++;if(af>1){C=false;break}var K=ac[V]["camera"];var L=K.length;for(var U=0;U<L;U++){if(K[U]["position"]){var ab=K[U]["position"];if(ab.length!=3){C=false;break}F.positionX=ab[0]*1000;F.positionY=ab[1]*1000;F.positionZ=ab[2]*1000}if(K[U]["target"]){var B=K[U]["target"];if(B.length!=3){C=false;break}F.targetX=B[0]*1000;F.targetY=B[1]*1000;F.targetZ=B[2]*1000}if(K[U]["up"]){var Y=K[U]["up"];if(Y.length!=3){C=false;break}F.upX=Y[0]*1000;F.upY=Y[1]*1000;F.upZ=Y[2]*1000}if(K[U]["field"]){var E=K[U]["field"];if(E.length!=2){C=false;break}F.fieldWidth=E[0]*1000;F.fieldHeight=E[1]*1000}if(K[U]["projection"]){F.projection=K[U]["projection"]}}}}ae.push(F)}if(H[ai]["layer"]){var D=H[ai]["layer"];var S={};var J=D.length;for(var O=0;O<J;O++){if(D[O]["name"]){if(D[O]["name"][0]){S.name=D[O]["name"][0]}}if(D[O]["styles"]){if(D[O]["styles"][0]){S.styles=D[O]["styles"][0].replace(/(\/)/gi,"\\")}}if(D[O]["files"]){S.files=[];S.paths=[];S.directLocation=[];S.directPath=[];for(var M=0;M<D[O]["files"].length;M++){var N=D[O]["files"][M];if(N.fileSpec){var Q=N.fileSpec;var G="";var X="";var T=false;var aa=false;for(var ad=0;ad<Q.length;ad++){if(Q[ad]["location"]&&Q[ad]["location"].length){var P=Q[ad]["location"][0].split("surpac2dtm:");if(P.length){G=P[P.length-1]}else{G=Q[ad]["location"][0]}G.replace(/(\/)/gi,"\\")}if(Q[ad]["path"]&&Q[ad]["path"].length){if(Q[ad]["path"][0].length){X=Q[ad]["path"][0].replace(/(\/)/gi,"\\")}}if(Q[ad]["directPath"]){T=true}if(Q[ad]["directLocation"]){aa=true}}G=G.replace(/\\/g,"/");X=X.replace(/\\/g,"/");S.files.push(G);S.paths.push(X);S.directLocation.push(aa);S.directPath.push(T)}}}}R.push(S)}else{if(H[ai]=="directLocation"){x=true}else{if(H[ai]=="directPath"){w=true}else{if(H[ai]=="activeLocalPath"){r=true}}}}}q=R.length;for(var ah=0;ah<q;ah++){if(!A.processSwa(R[ah])){o++;if(o==q){s()}}}if(C&&ae.length){l.publish({event:"GEOSwaViewpoint",data:{viewport:ae[0]}})}};A.errorSwaCB=function(B){A._errorLoader("LOAD_SWA",p)};var n="";a.load(p,n,A.parseSwa,A.errorSwaCB);if(y){y(A.scene)}};this._errorLoader=function(p,n){var o=this;console.log("type message="+p+"\n");k.nls("ModelLoader_swa/GEOV1SWALoader_errors",p,function(q){console.log(q)});if(o.errorCallbackFunc){o.errorCallbackFunc({type:[p],url:[JSON.stringify(n)],rsc:"ModelLoader_swa/GEOV1SWALoader_errors",level:j.error})}}};return i});