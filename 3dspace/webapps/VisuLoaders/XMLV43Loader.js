define("DS/VisuLoaders/XMLV43Loader",["DS/Visualization/ThreeJS_DS","WebappsUtils/WebappsUtils","UWA/Utils","DS/Visualization/Utils","DS/VisuDataAccess/Ox4XHRWithProxyAbstraction","DS/ZipJS/zip-fs","DS/Visualization/Node3D","DS/Visualization/Mesh3D","DS/Visualization/MaterialManager","DS/Visualization/PathElement","DS/Visualization/SceneGraph","DS/SceneGraphNodes/AxisSystemNode","DS/Mesh/Mesh","DS/Visualization/LoaderUtils","DS/VisuLoaders/ThreeDXLoader","DS/ZipJS/LoaderInflate"],function(q,e,a,g,l,p,h,c,b,k,j,i,f,s,d,r){var m=function(u){var t=document.getElementsByTagName("script");for(var w=0;w<t.length;w++){var v=t.item(w);var x=v.getAttribute("src");if(x&&x.match(u)){return x.substring(0,x.lastIndexOf("/")+1)}}return"scripts/ThreeDS/Visualization/"};var o={TECHREP:{module:"DS/SIMAnimationWebMdl",file:"SIMAnimationRepRefUnstreamer"}};var n=function(aV,S){var D=false;var L=false;var ay=aV;var aU=undefined;if(q.supportedExtensions){aU=q.supportedExtensions.elementIndexUint?true:undefined}var Y=[];var aN=false;var aq=null;var I=(S!==undefined)?S:null;var aM=null;var aS=null;var av=null;var aj=null;var aT;var al=true;var A=null;var aG=4;var ao=null;var aI=[];var aJ=false;var K=0;var ak=0;var af=4;var aQ=0;var aD=[];var aX=null;var V="TESSELLATED";var R=[];var w=[];var aK=new Date().getTime();var M=2000;var ah=false;var u=false;var H=false;var aa=false;var au=null;var am={};var C=[];var ai=true;var aO=false;var aA=false;var at=false;var ag=false;var z=true;var ax=[];var aH=false;var Z=[];var G={};var aW={};var Q;var aF=null;var ac=[];var T={};function v(a0,a6,a1,a2,a3,a4){if(D){if(document.implementation&&document.implementation.createDocument){var a5=new XMLHttpRequest();if(a5.overrideMimeType){a5.overrideMimeType(a1)}if(a6==="blob"){a5.responseType="blob"}if(a6==="arraybuffer"){a5.responseType="arraybuffer"}a5.onreadystatechange=function(){if(a5.readyState===4){if(a5.status===0||a5.status===200){if(a5.response&&a5.responseType==="blob"){var a9=new Blob([a5.response],{type:a1});a2(a9,a0,a4)}if(a5.response&&a5.responseType==="arraybuffer"){a2(a5.response,a0,a4)}else{if(a5.responseXML){a2(a5.responseXML,a0,a4)}else{if(a5.responseText){a2(a5.responseText,a0,a4)}else{console.error("XMLV43Loader: Empty or non-existing file ("+a0+")");(typeof a3!=="undefined")&&a3(a0)}}}}else{(typeof a3!=="undefined")&&a3(a0)}}};a5.open("GET",a0,true);a5.send(null)}else{alert("Don't know how to parse XML!");(typeof a3!=="undefined")&&a3(a0)}}else{var aZ=a0.replace(/^.*[\\\/]/,"");var a7=aq.find(aZ);if(a7&&(aQ<af)){aQ++;if(a6==="blob"){a7.getBlob(a1,function(ba){aQ--;if(aD.length>0){var a9=aD[0];v(a9.url,a9.type,a9.mime,a9.cbLoad,a9.cbError,a9.args);aD.splice(0,1)}a2(ba,a0,a4)})}else{if(a6==="arraybuffer"){a7.getBlob(a1,function(bb){aQ--;if(aD.length>0){var ba=aD[0];v(ba.url,ba.type,ba.mime,ba.cbLoad,ba.cbError,ba.args);aD.splice(0,1)}var a9=new FileReader();a9.onload=function(bc){a2(bc.target.result,a0,a4)};a9.readAsArrayBuffer(bb)})}else{a7.getText(function(bb){aQ--;if(aD.length>0){var ba=aD[0];v(ba.url,ba.type,ba.mime,ba.cbLoad,ba.cbError,ba.args);aD.splice(0,1)}if(a6==="xml"){try{var bd=new DOMParser();var bc=bd.parseFromString(bb.target.result,"text/xml");a2(bc,a0,a4)}catch(a9){(typeof a3!=="undefined")&&a3(a0)}}else{if(a6==="string"){a2(bb.target.result,a0,a4)}}})}}}else{if(aQ>=af){aD.push({url:a0,type:a6,mime:a1,cbLoad:a2,cbError:a3,args:a4})}else{(typeof a3!=="undefined")&&a3(a0);if(aD.length>0){var a8=aD[0];aD.splice(0,1);v(a8.url,a8.type,a8.mime,a8.cbLoad,a8.cbError,a8.args)}}}}}function aC(a0){if(a0 instanceof Object){var aZ="Error loading 3DXML : "+a0.url+"\n";switch(a0.type){case"LOAD":case"LOAD_ARCHIVE":aZ+="Could not load the 3DXML file.";break;case"LOAD_ENTRY":aZ+="Could not read Zip entries for this 3DXML.";break;case"PARSE":aZ+="Could not parse XML data.";break;case"REPFORMAT":aZ+="Rep format is not supported.";break;case"VERSION":aZ+="This version is not supported.";break;case"REVIEW_MISSING":aZ+="3DXML file does not contain any review data, only briefcase.";break}}aZ+="The model is not found, corrupted or not entirely supported.";console.warn(aZ)}function B(aZ){C=[];if(!aZ){return}for(var a0 in aZ){C.push(a0)}}this.abort=function(){Y=[];ak=0;if(ao!==null){for(var aZ=0;aZ<ao.length;++aZ){if(ao[aZ]!==null){ao[aZ].terminate()}}aI=[];aJ=false;ao=null}if(A){A=null}ae()};this.load=function(a1,bb,aZ,a5,a3,bd,a8,a4,a0,a6,ba,bg,be,bh,bc,a7,a9,bf,a2){if(aN){Y.push({url:a1,readyCallback:bb,progressCallback:aZ,doneCallback:a5,errorCallback:a3,filterNavReps:bd,refreshTime:a8,readDeco:a4,newInfra:a0,primWithBS:a6,edgeTrans:ba,withSG:bg,sharedBuff:be,nmir:bh,ssb:bc,sag:a7,uvrWorker:a9,iapplicativeContainers:bf});return}aN=true;aT=a1;if(a1 instanceof Object){aT=a1.serverurl?a1.serverurl:"";aT+=a1.filename?a1.filename:"";if(a1.loaderSettings&&!!a1.loaderSettings.uncompressed){D=!!a1.loaderSettings.uncompressed;V=a1.loaderSettings.repType?a1.loaderSettings.repType:"CGR";if(V==="3DX"&&!aX){aX=new d()}}}ai=ba;aO=a2;aA=be;at=bh;aM=bb;aS=a5;av=aZ;aj=a3;L=bd;M=a8;ah=a4;u=a6;H=bc;aa=a7;al=a9;au=bf;B(au);ag=bg;z=a0;if(D){v(a1+"/CATMaterialRef.3dxml","xml","text/xml",ad,function(bi){ad(null,bi,true)})}else{aq=new p.fs.FS();aq.importHttpContent(a1,false,function(){var bi=v(aT+"/CATMaterialRef.3dxml","xml","text/xml",ad,function(bj){v(aT+"/CATMaterialDisciplines.3dxml","xml","text/xml",ad,function(bk){ad(null,bk,true)})})},a3?a3:aC)}};var aw=this.load;function ae(){if(aq){aq.closeZipReader();aq=null}aM=null;aS=null;av=null;aj=null;aT="";K=0;ak=0;aQ=0;aD=[];V="TESSELLATED";R=[];w=[];aK=new Date().getTime();ax=[];aH=false;Z=[];G={};aW={};Q="";aF=null;ac=[];T={};aN=false;if(Y.length){var aZ=Y.shift();aw(aZ.url,aZ.readyCallback,aZ.progressCallback,aZ.doneCallback,aZ.errorCallback,aZ.filterNavReps,aZ.refreshTime,aZ.readDeco,aZ.newInfra,aZ.primWithBS,aZ.edgeTrans,aZ.withSG,aZ.sharedBuff,aZ.nmir,aZ.ssb,aZ.sag,aZ.uvrWorker,aZ.iapplicativeContainers)}}function ad(bg,a1,a7){if((a7===undefined)||!a7){var aZ=bg.firstChild;if(aZ.nodeName!=="Model_3dxml"){return}for(var bb=0;bb<aZ.childNodes.length;bb++){var a2=aZ.childNodes[bb];if(a2.nodeName==="CATMaterialRef"){for(var a9=0;a9<a2.childNodes.length;a9++){var a5=a2.childNodes[a9];if((a5.nodeName!=="CATMatReference")&&(a5.nodeName!=="MaterialDomainInstance")&&(a5.nodeName!=="MaterialDomain")){continue}var a6=a5.getAttribute("id");var bh=a5.getAttribute("name");switch(a5.nodeName){case"CATMatReference":if(G[a6]!==undefined){G[a6].name=bh}else{G[a6]={name:bh}}break;case"MaterialDomainInstance":var ba=0;var bd=0;for(var a8=0;a8<a5.childNodes.length;a8++){var a4=a5.childNodes[a8];if(a4.nodeName==="IsAggregatedBy"){ba=a4.textContent}else{if(a4.nodeName==="IsInstanceOf"){bd=a4.textContent}}}G[a6]={parent:ba,instance:bd};if(G[ba]!==undefined){G[ba].instance=a6}else{G[ba]={instance:a6}}break;case"MaterialDomain":var bf=a5.getAttribute("associatedFile");var bc=a5.getAttribute("format");var be=[];be=bf.split("urn:3DXML:");bf=be[1];var a0=true;for(var a8=0;a8<a5.childNodes.length;a8++){var a4=a5.childNodes[a8];var a3=a4.textContent;if((a4.nodeName==="V_MatDomain")&&(a3.toUpperCase()!=="RENDERING")){a0=false;break}}if(!a0){break}if(G[a6]!==undefined){G[a6].filename=bf;G[a6].format=bc}else{G[a6]={filename:bf,format:bc}}break;default:break}}}}}v(aT+"/CATRepImage.3dxml","xml","text/xml",J,function(bi){v(aT+"/PLMDmtDocument.3dxml","xml","text/xml",J,function(bj){J(null,bj,true)})})}function J(bb,a1,bd){if((bd===undefined)||!bd){var a5="";var a7=bb.firstChild;if(a7.nodeName!=="Model_3dxml"){return}for(var a8=0;a8<a7.childNodes.length;a8++){var a3=a7.childNodes[a8];if(a3.nodeName==="CATRepImage"){for(var a6=0;a6<a3.childNodes.length;a6++){var a9=a3.childNodes[a6];if(a9.nodeName==="CATRepresentationImage"){var a2=a9.getAttribute("id");var a0=a9.getAttribute("name");var ba=a9.getAttribute("format");var a4=a9.getAttribute("associatedFile");var be=a4.split("urn:3DXML:");aW[a2]={filename:be[1],buffer:null}}}}}}var aZ=0;for(var bc in aW){if(aW.hasOwnProperty(bc)){aZ++}}t(aZ?(aZ-1):0)}function ar(aZ,a0){var a3=0;var a2=null;for(var a1 in aZ){if(aZ.hasOwnProperty(a1)){if(a3===a0){a2=a1;break}a3++}}return a2}function t(a6){if(a6===-1){var a3=0;for(var a0 in G){if(G.hasOwnProperty(a0)){a3++}}aL(a3?(a3-1):0);return}var a4=ar(aW,a6);if((aW[a4]===undefined)||(aW[a4].filename===undefined)||(aW[a4].filename==="")){t(a6-1)}else{var a2=/(?:\.([^.]+))?$/;var a1=a2.exec(aW[a4].filename)[1];var a5="image/";if(a1==="jpg"){a1="jpeg"}a5=a5+a1;var aZ="blob";if(a1==="dds"){a5="application/octet-stream";aZ="arraybuffer"}v(aT+"/"+aW[a4].filename,aZ,a5,E,(function(a7){return function(){t(a7-1)}})(a6),a6)}}function E(a1,aZ,a2){var a0=ar(aW,a2);aW[a0].buffer=a1;t(a2-1)}function aL(a0){if(a0===-1){v(aT+"/Manifest.xml","xml","text/xml",an);return}var aZ=ar(G,a0);if((G[aZ]===undefined)||(G[aZ].filename===undefined)){aL(a0-1)}else{if(G[aZ].format!=="UVR"){v(aT+"/"+G[aZ].filename,"xml","text/xml",aE,function(){},a0)}else{aL(a0-1)}}}function aE(bd,a0,a1){var a6={};a6.shading="Phong";a6.DiffuseMapWrap=[];a6.DiffuseMapRepeat=[0,0];var a8=bd.firstChild;if(a8.nodeName!=="Osm"){aL(a1-1);return}for(var a9=0;a9<a8.childNodes.length;a9++){var a3=a8.childNodes[a9];var a4=(a3.nodeName==="Feature")&&a3.getAttribute("Alias");if(a4&&(a4.indexOf("RenderingFeature")!==-1)){for(var a7=0;a7<a3.childNodes.length;a7++){var ba=a3.childNodes[a7];if(ba.nodeName==="Attr"){var bc=ba.getAttribute("Type");var bb=ba.getAttribute("Value");var aZ=ba.getAttribute("Name");switch(bc){case"int":bb=parseInt(bb,10);a6[aZ]=bb;switch(aZ){case"WrappingModeU":if(bb){a6.DiffuseMapWrap[0]="repeat";a6.DiffuseMapRepeat[0]=1}break;case"WrappingModeV":if(bb){a6.DiffuseMapWrap[1]="repeat";a6.DiffuseMapRepeat[1]=1}break;case"PreviewType":var a2=parseInt(bb);switch(a2){case 0:a6.mappingFunction="SPHERICAL_ENV_MAP";break;case 2:a6.mappingFunction="USER_MAPPING";break}break;default:break}break;case"double":switch(aZ){case"DiffuseColor":a6.colorDiffuse=X(bb);break;case"SpecularColor":a6.colorSpecular=X(bb);break;case"AmbientColor":a6.colorAmbient=X(bb);break;case"SpecularExponent":a6.shininess=128*parseFloat(bb);break;case"SpecularCoef":a6.specularCoef=parseFloat(bb);break;case"Reflectivity":a6.reflectivityCoef=parseFloat(bb);break;case"Transparency":a6.transparency=parseFloat(bb);a6.transparent=(a6.transparency>0);break;default:break}break;case"boolean":bb=(bb==="true");switch(aZ){case"AlphaTest":a6.alphaTest=bb?0.5:0;break;default:a6[aZ]=bb;break}break;case"external":var bf=[];bf=bb.split("urn:3DXML:");bb=bf[1];bf=bb.split("#");bb=bf[0];var a5=bf[1];if((aZ==="TextureImage")&&aW[a5]&&aW[a5].buffer){a6.DiffuseMap=aW[a5]}break;default:break}}}}}if(a1!==undefined){var be=ar(G,a1);if(G[be]===undefined){G[be]={}}a6.type="material3DXML";G[be].params=a6}aL(a1-1)}function an(a2,aZ){var a1=a2.firstChild;if(a1&&a1.childNodes){for(var a0=0;a0<a1.childNodes.length;a0++){var a3=a1.childNodes[a0];switch(a3.nodeName){case"Root":Q=a3.textContent;break;default:break}}}v(aT+"/"+Q,"xml","text/xml",O,function(a4){var a5=aj?aj:aC;if(a5){a5({url:a4,type:"REVIEW_MISSING"})}})}function O(bn,a1){var aZ=bn.firstChild;if(aZ&&aZ.nodeName==="Model_3dxml"){for(var be=0;be<aZ.childNodes.length;be++){var a3=aZ.childNodes[be];if(a3.nodeName==="Header"){for(var bc=0;bc<a3.childNodes.length;bc++){var a6=a3.childNodes[bc];if(a6.nodeName!=="SchemaVersion"){continue}var a0=a6.textContent;var bh=a0.substring(0,1);if(bh<4){var bg=aj?aj:aC;if(bg){bg({url:a1,type:"VERSION"})}return}}continue}if(a3.nodeName!=="ProductStructure"){continue}var bl=a3.getAttribute("root");for(var bc=0;bc<a3.childNodes.length;bc++){var a6=a3.childNodes[bc];if(a6.nodeName!=="Reference3D"&&a6.nodeName!=="Instance3D"&&a6.nodeName!=="ReferenceRep"&&a6.nodeName!=="InstanceRep"){continue}var a7=a6.getAttribute("id");var bo=a6.getAttribute("name");var a8=new h();switch(a6.nodeName){case"Reference3D":if(ac[a7]===undefined){ac[a7]=a8}else{a8=ac[a7]}if((bl===a7)&&(aF===null)){aF=a8}break;case"Instance3D":case"InstanceRep":ac[a7]=a8;var bd="";var bj="";var bb=null;for(var ba=0;ba<a6.childNodes.length;ba++){var a5=a6.childNodes[ba];if(a5.nodeName==="IsAggregatedBy"){bd=a5.textContent}else{if(a5.nodeName==="IsInstanceOf"){bj=a5.textContent}else{if(a5.nodeName==="RelativeMatrix"){var bm=x(a5.textContent);if(bb===null){bb=new q.Matrix4()}bb.set(bm[0],bm[3],bm[6],bm[9],bm[1],bm[4],bm[7],bm[10],bm[2],bm[5],bm[8],bm[11],0,0,0,1)}}}}if(bb!==null){a8._matrix=bb}if((bd!=="")&&(bj!=="")){if(ac[bd]===undefined){ac[bd]=new h()}ac[bd].addChild(a8);if(ac[bj]===undefined){ac[bj]=new h()}a8.addChild(ac[bj])}break;case"ReferenceRep":if(ac[a7]===undefined){ac[a7]=a8}else{a8=ac[a7]}var bj="";var a2=a6.getAttribute("format");var bi;if(a2&&(typeof a2==="string")){bi=a2.toUpperCase()}var a9=a6.getAttribute("associatedFile");if(bi==="UVR"||bi==="TESSELLATED"){if(V!=="3DX"){a2=bi;V=bi}else{a2="3DX"}}var bk=[];bk=a9.split("urn:3DXML:");a9=bk[1];var bf={file:a9,format:a2,node:a8};if(R[a9]!==undefined){R[a9].push(a8)}else{R[a9]=[a8];if(g.getExtension(a9)!=="ifc"){w.push(bf)}}T[a8.id]=bf;break;default:break}a8.name=bo;a8.productType=a6.nodeName;a8.persistentId=a7;a8.getPersistentId=function(){return this.persistentId}}}for(var be=0;be<aZ.childNodes.length;be++){var a3=aZ.childNodes[be];if(a3.nodeName!=="DefaultView"){continue}for(var bc=0;bc<a3.childNodes.length;bc++){var a6=a3.childNodes[bc];if(a6.nodeName!=="DefaultViewProperty"){continue}y(a6)}}for(var be=0;be<aZ.childNodes.length;be++){var a3=aZ.childNodes[be];if(a3.nodeName!=="CATMaterial"){continue}for(var bc=0;bc<a3.childNodes.length;bc++){var a6=a3.childNodes[bc];if(a6.nodeName!=="CATMatConnection"){continue}aP(a6)}}}if(L&&aF){aF.traverse(function(bq,bp){var br=bp.indexOf(bq);if(br!==-1){bp.splice(br,1);if(bq.productType==="ReferenceRep"){if(T[bq.id]){console.log(T[bq.id]);br=w.indexOf(T[bq.id]);if(br!==-1){w.splice(br,1)}}}for(var bs=0;bs<bq.children.length;bs++){bp.push(bq.children[bs])}return false}if(bq.productType==="Reference3D"){var bt=[];var bu=false;for(var bs=0;bs<bq.children.length;bs++){var bv=bq.children[bs];bu=bu||(bv.productType==="Instance3D");if(bv.productType==="InstanceRep"){bt.push(bv)}}if(bu){for(var bs=0;bs<bt.length;bs++){bp.push(bt[bs])}}}return false},new Array)}if(!w.length){var a4=aS;ae();a4()}else{aB()}}function y(a1){var bg=[];var aZ=true;var a2=false;var a7=null;var bc=null;var ba=new q.Color();var a0=1;for(var be=0;be<a1.childNodes.length;be++){var a3=a1.childNodes[be];if(a3.nodeName==="OccurenceId"){for(var bd=0;bd<a3.childNodes.length;bd++){var a9=a3.childNodes[bd];if(a9.nodeName==="id"){var a5="";var a4="";var bf=[];bf=a9.textContent.split("urn:3DXML:");a4=bf[1];bf=a4.split("#");a5=bf[0];a4=bf[1];if(ac[a4]!==undefined&&(bg.length===0||ac[a4]!==bg[bg.length-1])){bg.push(ac[a4]);if(ac[a4].children[0]!==undefined){bg.push(ac[a4].children[0])}}}}}else{if(a3.nodeName==="GraphicProperties"){for(var bd=0;bd<a3.childNodes.length;bd++){var a9=a3.childNodes[bd];if(a9.nodeName==="SurfaceAttributes"){for(var bb=0;bb<a9.childNodes.length;bb++){var a8=a9.childNodes[bb];if(a8.nodeName==="Color"){a2=true;ba.r=parseFloat(a8.getAttribute("red"));ba.g=parseFloat(a8.getAttribute("green"));ba.b=parseFloat(a8.getAttribute("blue"));if(a8.getAttribute("alpha")){a0=parseFloat(a8.getAttribute("alpha"))}if(ba.r===-1){return}}}}else{if(a9.nodeName==="GeneralAttributes"){if(a9.getAttribute("visible")){aZ=(a9.getAttribute("visible")==="true")}}}}}else{if(a3.nodeName==="RelativePosition"){var bh=x(a3.textContent);bc=new q.Matrix4();bc.set(bh[0],bh[3],bh[6],bh[9],bh[1],bh[4],bh[7],bh[10],bh[2],bh[5],bh[8],bh[11],0,0,0,1)}}}}if(a2){var a6=new b();a7=a6.getMaterialFromGAS({color:ba,opacity:a0})}ax.push({occPath:new k(bg),material:a7,matrix:bc,visible:aZ});if(bc){aH=true}}function aP(a6){var a1=a6.getAttribute("id");var a0=a6.getAttribute("name");var ba="";var a7="";var bc=[];var bb=null;for(var a8=0;a8<a6.childNodes.length;a8++){var a2=a6.childNodes[a8];if(a2.nodeName==="IsAggregatedBy"){ba=a2.textContent}else{if(a2.nodeName==="PLMRelation"){for(var a4=0;a4<a2.childNodes.length;a4++){var a9=a2.childNodes[a4];if(a9.nodeName==="C_Role"){a7=a9.textContent}else{if(a9.nodeName==="Ids"){for(var a3=0;a3<a9.childNodes.length;a3++){var a5=a9.childNodes[a3];if(a5.nodeName==="id"){if((a7==="CATMaterialMadeOfLink")||(a7==="CATMaterialDressByLink")){if(ac[a5.textContent]!==undefined&&(bc.length===0||ac[a5.textContent]!==bc[bc.length-1])){bc.push(ac[a5.textContent]);if(ac[a5.textContent].children[0]!==undefined){bc.push(ac[a5.textContent].children[0])}}}else{if(a7==="CATMaterialToReferenceLink"){var be=[];be=a5.textContent.split("urn:3DXML:");var bd=be[1];be=bd.split("#");var aZ=be[0];bd=be[1];bb={file:aZ,id:bd}}}}}}}}}}}if(bb!==null){ax.push({occPath:new k(bc),material:W(bb.id),visible:null})}}var aR=function(a5){var a0,a2,aZ,a4,a3,a1;a0="";aZ=a5.length;a2=0;while(a2<aZ){a4=a5[a2++];switch(a4>>4){case 0:case 1:case 2:case 3:case 4:case 5:case 6:case 7:a0+=String.fromCharCode(a4);break;case 12:case 13:a3=a5[a2++];a0+=String.fromCharCode(((a4&31)<<6)|(a3&63));break;case 14:a3=a5[a2++];a1=a5[a2++];a0+=String.fromCharCode(((a4&15)<<12)|((a3&63)<<6)|((a1&63)<<0));break}}return a0};var aY=function(a1,a3,bb){if(a3&&a1){for(var bc in a3){var a7=a3[bc].errorCallback;var ba=a3[bc].binaryOutput;if(a1[bc]){var a4=a1[bc];if(ba){if(!am[bc]){am[bc]=[]}for(var a5=0;a5<bb.length;a5++){am[bc].push({node:bb[a5],data:a4})}}else{if(!a4){a7();delete a3[bc];continue}var a2=a4.buffer.subarray(a4.options.offset,a4.options.compressed+a4.options.offset);if(a2.length<=2){a7();delete a3[bc];continue}if(a2[0]!==120){a7();delete a3[bc];continue}if(a2[1]!==218){a7();delete a3[bc];continue}var aZ=2;var a0=a2.subarray(aZ,a4.options.compressed);var a8=new r();var a9=a8.Inflate(a0);var a6=aR(a9);if(!am[bc]){am[bc]=[]}for(var a5=0;a5<bb.length;a5++){am[bc].push({node:bb[a5],xml:a6})}}}}}};function aB(){if(aH){for(var a5=0;a5<ax.length;a5++){var ba=ax[a5];if((ba!==undefined)&&ba.matrix){var a2=ba.occPath._getOccurrences();if(a2.length){for(var a4=0;a4<a2.length;a4++){a2[a4]._relativeMatrix=ba.matrix}}}}aF&&aF._updateMatrix()}if(V==="3DX"){ap(aM);return}if(ao!==null){for(var a5=0;a5<aG;++a5){ao[a5].terminate()}}ao=null;aI=[];aJ=false;var a6="";if(al||(V==="TESSELLATED")){if(ao===null){var a7=!a.matchUrl(e.getWebappsBaseUrl(),window.location)?"Passport":null;var a3=[];var aZ={provider:"FILE",filename:"AmdLoader.js",serverurl:e.getWebappsBaseUrl()+"AmdLoader/",requiredAuth:a7};var a8={provider:"FILE",filename:"EasySax.js",serverurl:e.getWebappsBaseUrl()+"EasySax/",requiredAuth:a7};var a1={provider:"FILE",filename:"ThreeJS_Base.js",serverurl:e.getWebappsBaseUrl()+"Mesh/",requiredAuth:a7};var a9={provider:"FILE",filename:"Mesh.js",serverurl:e.getWebappsBaseUrl()+"Mesh/",requiredAuth:a7};var a0={provider:"FILE",filename:"CGRFile.js",serverurl:e.getWebappsBaseUrl()+"Formats/",requiredAuth:a7};if((V==="UVR")||(V==="CGR")){a6={provider:"FILE",filename:"CGRWorkerNewInfra.js",serverurl:e.getWebappsBaseUrl()+"Workers/",requiredAuth:a7};a3=[aZ,a1,a9,a0,a6];a3.realWorkerUrl=e.getWebappsBaseUrl()+"Workers/CGRWorkerNewInfra.js"}else{if(V==="TESSELLATED"){a6={provider:"FILE",filename:"XMLV43Worker.js",serverurl:e.getWebappsBaseUrl()+"Workers/",requiredAuth:a7};a3=[aZ,a8,a1,a9,a6];a3.realWorkerUrl=e.getWebappsBaseUrl()+"Workers/XMLV43Worker.js"}}g.getWorkerBlobFromSpecs(a3,function(bd){ao=[];var bb={processText:aO,edgeTransparency:ai,sharedBuffers:aA,noMeshInRAM:at,primitiveWithBS:u,withSAG:aa};for(var bc=0;bc<aG;++bc){ao[bc]=new Worker(bd)}for(var bc=0;bc<aG;++bc){(function(be){ao[be].onmessage=function(bl){var bj=bl.data;if(bj.loaded){aI.push(be);if(!aJ){aJ=true;ap(aM)}}else{var bn=R[bj.node];ak--;if(bj.CGR){bb.fromCGR=true}s.processData(bn,bj,{materialLibrary:G,baseUrl:aT},ag,bb);if(bj.applicativesContainers){aY(bj.applicativesContainers,au,bn)}if(av!==null){av({loaded:K-ak,total:K})}var bf=new Date().getTime();if((aK+M<bf)||!ak){if(I){I({hack:true,updateInfinitePlane:true})}aK=bf;for(var bk=0;bk<ax.length;bk++){var bo=ax[bk];if(bo!==undefined){var bg=bo.occPath._getRenderableOccurrences();if(bg.length){for(var bi=0;bi<bg.length;bi++){if(bo.material){bo.material.force=true;bg[bi]._3dxmlMaterial=bo.material;bg[bi].material=bo.material}if(bo.visible!==null){bg[bi].visible=bo.visible;bg[bi]._occurrence.visible=bo.visible}}ax[bk]=undefined}}}}if(ak<=0){if(ao!==null){for(var bk=0;bk<ao.length;++bk){if(ao[bk]!==null){ao[bk].terminate()}}}if(A){A=null}aI=[];aJ=false;ao=null;if(aS!==null){var bh=aS;ae();bh();if(au){for(var bm in au){if(au[bm].doneCallback){if(am&&am[bm]&&au[bm].doneCallback){au[bm].doneCallback(am[bm])}else{au[bm].doneCallback([])}}}}}}}}})(bc)}})}else{if(aJ){ap(aM)}}}else{if(!A){require(["DS/Formats/CGRFile"],function(bb){A=bb;ap(aM)},function(bc){var bb=bc.requireModules&&bc.requireModules[0];console.log("Module "+bb+" is missing.");if(aj){aj()}})}else{ap(aM)}}}function N(){ak--;if(av){av({loaded:K-ak,total:K})}if(ak===0){if(ao!==null){for(var a0=0;a0<ao.length;++a0){if(ao[a0]!==null){ao[a0].terminate()}}aI=[];aJ=false;ao=null}if(A){A=null}if(aS){var aZ=aS;ae();aZ();if(au){for(var a1 in au){if(au[a1].doneCallback){if(am&&am[a1]&&au[a1].doneCallback){au[a1].doneCallback(am[a1])}else{au[a1].doneCallback([])}}}}}}}function ap(a7){ak=w.length;K=ak;for(var a3=0;a3<w.length;a3++){var a4=w[a3];var a1=a4.file;var a5=a4.format;var a0=a4.node;if(a1!==undefined){var aZ=aT+"/"+a1;var a2=aZ;if(a1!==""){if(a5==="3DX"){a2+=".3dxc";var a6=R[a1];aX.load({url:a2,concat:true,zipped:false,primitives:true,reps:true,ssb:false,destinationNodes:a6,readyCallback:function(ba){ak--;if(av!==null){av({loaded:K-ak,total:K})}var a9=new Date().getTime();if((aK+M<a9)||!ak){if(I){I({hack:true,updateInfinitePlane:true})}aK=a9}if(ak<=0){if(aS!==null){var a8=aS;ae();a8()}}}})}else{if(!al&&A&&(a5==="UVR")){(function(a9,a8){v(aZ,"arraybuffer","text/plain",function(bg){var bl={processText:aO,fromCGR:true,edgeTransparency:ai,sharedBuffers:aA,noMeshInRAM:at,primitiveWithBS:u,withSAG:aa};var bb=new Uint8Array(bg);var ba=new A([],false,u,ag,aU,H,aa);ba.setFileBuffer(bb);var bi=ba.open();var bj=R[a9];ak--;s.processData(bj,bi,{materialLibrary:G,baseUrl:aT},undefined,bl);if(av!==null){av({loaded:K-ak,total:K})}var bc=new Date().getTime();if((aK+M<bc)||!ak){if(I){I({hack:true,updateInfinitePlane:true})}aK=bc;for(var bh=0;bh<ax.length;bh++){var bk=ax[bh];if(bk!==undefined){var bd=bk.occPath._getRenderableOccurrences();if(bd.length){for(var bf=0;bf<bd.length;bf++){if(bk.material){bk.material.force=true;bd[bf]._3dxmlMaterial=bk.material;bd[bf].material=bk.material}if(bk.visible!==null){bd[bf].visible=bk.visible;bd[bf]._occurrence.visible=bk.visible}}ax[bh]=undefined}}}}if(ak<=0){if(ao!==null){for(var bh=0;bh<ao.length;++bh){if(ao[bh]!==null){ao[bh].terminate()}}aI=[];aJ=false;ao=null}if(A){A=null}if(aS!==null){var be=aS;ae();be()}}})})(a1,a3)}else{if(ao){switch(a5){case"UVR":case"CGR":if(a5==="CGR"){a2+=".cgr"}(function(a9,a8){v(a2,"arraybuffer","text/plain",function(bb,ba){var bc=aI[a8%aI.length];ao&&ao[bc].postMessage({inputFile:bb,node:a9,readDecoration:ah,primitiveWithBS:u,smartStaticBatching:H,withSAG:aa,applicativesContainers:C,withSceneGraph:ag,uint32Index:aU,uvr:true},[bb])})})(a1,a3);break;case"TESSELLATED":(function(a9,a8){v(aZ,"string","text/plain",function(bb,ba){var bc=aI[a8%aI.length];ao&&ao[bc].postMessage({path:bb,node:a9,uint32Index:aU})})})(a1,a3);break;default:if(o[a5]){(function(a8,ba,a9){v(aZ,"xml","text/xml",function(bd,bb){var bc=o[ba].module+"/"+o[ba].file;require([bc],function(be){var bf=new be();bf.unstream(bd,a8,a9);N()},function(bf){var be=bf.requireModules&&bf.requireModules[0];console.log("Module "+be+" is missing.");var bg=aj||aC;N();if(bg){bg({url:bb,type:"REPFORMAT"})}})},function(bb){var bc=aj||aC;N();if(bc){bc({url:bb,type:"REPFORMAT"})}})})(a1,a5,a0)}else{N()}break}}else{N()}}}}}}if(a7){if(aF===null){aF=new h()}a7(aF)}}function X(a0){var a2=[];var a1=new RegExp(/\[([0,1]|(?:[0-9]?\.[0-9]*(?:[eE][-+][0-9]+)?)),([0,1]|(?:[0-9]?\.[0-9]*(?:[eE][-+][0-9]+)?)),([0,1]|(?:[0-9]?\.[0-9]*(?:[eE][-+][0-9]+)?))\]/);var aZ=a1.exec(a0);if(aZ!==null){a2[0]=parseFloat(RegExp.$1);a2[1]=parseFloat(RegExp.$2);a2[2]=parseFloat(RegExp.$3)}else{a1=new RegExp(/\[([0,1]|(?:[0-9]?\.[0-9]*(?:[eE][-+][0-9]+)?)),([0,1]|(?:[0-9]?\.[0-9]*(?:[eE][-+][0-9]+)?)),([0,1]|(?:[0-9]?\.[0-9]*(?:[eE][-+][0-9]+)?)),([0,1]|(?:[0-9]?\.[0-9]*(?:[eE][-+][0-9]+)?))\]/);aZ=a1.exec(a0);if(aZ!==null){a2[0]=parseFloat(RegExp.$1);a2[1]=parseFloat(RegExp.$2);a2[2]=parseFloat(RegExp.$3);a2[3]=parseFloat(RegExp.$4)}}return a2}function W(a3){var a2=new b();var aZ=G[a3];if(aZ===undefined){return null}var a0=G[aZ.instance];if(a0===undefined){return null}var a1=G[a0.instance];if(a1===undefined){return null}if((a1.material===undefined)&&(a1.params!==undefined)){a1.material=a2.getMaterial3DXML(a1.params,aT,"XMLV43");a1.material.force=true}else{if(a1.params===undefined){a1.material=new q.MeshLambertMaterial();a1.material.force=true}}return a1.material}function ab(bc,a7,bf){var aZ=null;var a6=[];var a5=null;var bl=null;var bm=new q.Sphere();var a0=new q.Box3();var a9=new b();a9.cleanResources();var bk;for(var bj=0;bj<bc.length;bj++){var a1=bc[bj];var a8=new q.BufferGeometryDS();var be=new q.Vector3(a1.AABB.min[0],a1.AABB.min[1],a1.AABB.min[2]);var bi=new q.Vector3(a1.AABB.max[0],a1.AABB.max[1],a1.AABB.max[2]);if(a5===null){a5=be}if(bl===null){bl=bi}if(be.x<a5.x){a5.x=be.x}if(be.y<a5.y){a5.y=be.y}if(be.z<a5.z){a5.z=be.z}if(bi.x>bl.x){bl.x=bi.x}if(bi.y>bl.y){bl.y=bi.y}if(bi.z>bl.z){bl.z=bi.z}a0.set(a5,bl);bm.radius=bl.clone().sub(a5).multiplyScalar(0.5).length();bm.center=bl.clone().add(a5).multiplyScalar(0.5);var a3=null;var bb=null;for(var bh=0;bh<a1.drawingGroups.length;bh++){a1.drawingGroups[bh].geometry=a8;var bd=a1.drawingGroups[bh].gas;var ba=a1.drawingGroups[bh].material;if((ba!==null)&&(ba.file!=="")){a1.drawingGroups[bh].material=W(ba.id)}else{if((ba!==null)&&ba.id!==-1){if(Z[ba.id]!==null&&Z[ba.id]!==undefined){bk=Z[ba.id]}else{bk=a9.getMaterialCgr(a7[ba.id],undefined,"CGR",bf);Z[ba.id]=bk}a1.drawingGroups[bh].material=bk}}if(bd!==null){var bg=new q.Color();bg.setRGB(bd.color.r,bd.color.g,bd.color.b);a1.drawingGroups[bh].gas=a9.getMaterialFromGAS({color:bg,opacity:bd.opacity,linewidth:bd.linewidth,solid:bd.solid,symbol:bd.symbol,basic:bd.basic})}}a8.drawingGroups=a1.drawingGroups;a8.vertexPositionArray=a1.vertexPositionArray;if(a1.vertexNormalArray!==null){a8.vertexNormalArray=a1.vertexNormalArray}if(a1.vertexUvArray!==null){a8.vertexUvArray=a1.vertexUvArray}a8.vertexIndexArray=a1.vertexIndexArray;a6.push(a8)}var a4=new q.Color();a4.setRGB(bc[0].gas.fill.color.r,bc[0].gas.fill.color.g,bc[0].gas.fill.color.b);var a2=new q.Color();a2.setRGB(bc[0].gas.line.color.r,bc[0].gas.line.color.g,bc[0].gas.line.color.b);var ba=a9.getMaterialFromGAS({color:a4,opacity:bc[0].gas.fill.opacity,solid:bc[0].gas.fill.solid,basic:bc[0].gas.fill.basic});ba.line=a9.getMaterialFromGAS({color:a2,opacity:bc[0].gas.line.opacity,linewidth:bc[0].gas.line.linewidth});a6.boundingSphere=bm;a6.boundingBox=a0;aZ=new q.Mesh(a6,ba);aZ.matrixAutoUpdate=false;aZ.castShadow=true;aZ.receiveShadow=true;return new c(aZ)}function az(){var a0=new q.BufferGeometryDS();a0.boundingSphere=new q.Sphere();a0.boundingBox=new q.Box3();var aZ=new q.MeshPhongMaterial();var a1=new q.Mesh(a0,aZ);a1.matrixAutoUpdate=false;if(q.REVISION==="48"){a1.doubleSided=true}a1.castShadow=true;a1.receiveShadow=true;return new c(a1)}function U(aZ,a0){if(aZ.color===null||a0.color===null){return false}if((aZ.color.r!==a0.color.r)||(aZ.color.g!==a0.color.g)||(aZ.color.b!==a0.color.b)){return false}if(aZ.thickness&&a0.thickness&&(aZ.thickness!==a0.thickness)){return false}if(aZ.opacity!==a0.opacity){return false}return true}function x(a3){var a0=P(a3);var a2=[];for(var a1=0,aZ=a0.length;a1<aZ;a1++){a2.push(parseFloat(a0[a1]))}return a2}function P(aZ){return(aZ.length>0)?F(aZ).split(/\s+/):[]}function F(aZ){return aZ.replace(/^\s+/,"").replace(/\s+$/,"")}};return n});