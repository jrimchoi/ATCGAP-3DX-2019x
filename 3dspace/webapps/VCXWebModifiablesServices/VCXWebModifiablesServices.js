define("DS/VCXWebModifiablesServices/VCXModifiablesServices",["UWA/Class","DS/Visualization/ThreeJS_DS","DS/VCXWebProperties/VCXProperty","DS/VCXWebProperties/VCXPropertyInfo","DS/VCXWebProperties/VCXPropertyValueLocation","DS/VCXWebProperties/VCXPropertyValueFrame","DS/VCXWebVisibility/VCXIVisibility",],function(d,g,e,f,h,b,a){var c=d.singleton({init:function(){},isModifiable:function(i){var j=i.QueryInterface?i.QueryInterface("VCXIModifiable"):null;return i===j},buildPropertyLocationWithTranslationInWCS:function(l,n){if(!(this.isModifiable(l))||!n instanceof g.Vector3){console.error("A VCXModifiable and a THREE.Vector3 objects are needed !");return}var x=l.QueryInterface("W3AISGNodeHolder").getPathElement().getParentPath().getWorldMatrix(l.GetObject()._experienceBase.getManager("VCXContextManager").getMainViewer());var w=new g.Matrix4().getInverse(x);var p=new g.Matrix4().extractRotation(w);var o=new g.Vector3().copy(n).applyMatrix4(p);var s=l.GetProperty("Actor.Position");var v=s.GetPropertyValue();var j=v.GetFrame().GetValue();var q=v.GetPivot().GetValue();for(var u=0;u<=11;++u){j.elements[u]=parseFloat(j.elements[u])}var i=new g.Vector3().getPositionFromMatrix(j).add(o);var m=new g.Matrix4().copy(j).setPosition(i);var r=new g.Vector3().getPositionFromMatrix(q).add(o);var k=new g.Matrix4().copy(q).setPosition(r);var t=this.buildPropertyLocationWithFramePivot(m,k);return t},buildPropertyLocationWithRotationInWCS:function(x,l,i){if(!(this.isModifiable(x))||!(l instanceof g.Matrix4)){console.error("At least a VCXModifiableOccurrence and a THREE.Matrix4 objects are needed !");return}var r=x.GetProperty("Actor.Position");var u=r.GetPropertyValue();var y=x.QueryInterface("W3AISGNodeHolder").getPathElement().getParentPath().getWorldMatrix(x.GetObject()._experienceBase.getManager("VCXContextManager").getMainViewer());var t=new g.Matrix4().getInverse(y);var w;if(i===null||i===undefined){w=u.GetPivot().GetValue()}else{if(i instanceof g.Vector3){var z=new g.Matrix4().setPosition(i);w=new g.Matrix4().copy(t).multiply(z)}else{if(i instanceof g.Matrix4){w=new g.Matrix4().copy(t).multiply(i)}else{console.warn("Pivot specified not compatible, using modifiable's pivot as rotation pivot");w=u.GetPivot().GetValue()}}}var n=new g.Matrix4().getInverse(w);var j=new g.Matrix4().copy(n).multiply(t);var o=new g.Matrix4().extractRotation(j);var v=new g.Matrix4().getInverse(o);var p=u.GetFrame().GetValue();var k=u.GetPivot().GetValue();if(i!==null&&i!==undefined){k=w.clone()}var A=new g.Matrix4().copy(o).multiply(l).multiply(v);var q=new g.Matrix4().copy(w).multiply(A).multiply(n);var s=new g.Matrix4().copy(q).multiply(p);var m=new g.Matrix4().copy(q).multiply(k);var B=this.buildPropertyLocationWithFramePivot(s,m);return B},buildPropertyLocationWithFramePivot:function(j,l){if(!(j instanceof g.Matrix4)||!(l instanceof g.Matrix4)){console.error("2 THREE.Matrix4 objects are needed as arguments..");return}var n=new b();n.SetValue(j);var i=new b();i.SetValue(l);var m=new h();m.SetFrame(n);m.SetPivot(i);var k=new e(new f("Actor.Position",0),m);return k},GetFrameInWCSAtTime:function(r,q,l,k,i){var n="Actor.Position";var v=q.GetObjectAnimation(l.GetHashing());var t=null;var w=r.GetNeutrals(l.GetHashing());if(w){if(v&&v._Tracks&&v._Tracks[n]){var s=l.GetInterpolator(n);if(typeof s==="undefined"||s===null){s=r.GetDefaultInterpolator(n)}t=s.GetInterpolatedValue(w,n,k,v._Tracks).GetFrame().GetValue()}else{var o=w.GetProperty(n);t=o&&o.GetPropertyValue().GetFrame().GetValue()}}if(!t){t=l.GetProperty(n).GetPropertyValue().GetFrame().GetValue()}var p=l.GetObject();var m=p.QueryInterface("VCXIModelNavigable").getParent();var u=null;if(m){u=m.GetObject()}if(u){var j=u.QueryInterface("VCXIModifiable");var x=this.GetFrameInWCSAtTime(r,q,j,k);return new g.Matrix4().copy(x).multiply(t)}else{return t}},getDisplayPriority:function(n){var j=n.QueryInterface("VCXIVisibility");if(j){if(j.GetVisibility()===a.EVisState.Hidden){return -10}}if(n.GetObject().IsKindOf("VCXComponentHotspot")){var i=n.GetProperty("Actor.Enable");if(i&&i.GetPropertyValue()&&i.GetPropertyValue().Value){return 10}else{return -10}}var l=1;var m=n.GetProperty("Actor.Opacity");if(m&&m.GetPropertyValue()&&m.GetPropertyValue().Value===0){return -9}if(n.GetObject().IsDressup){if(n.GetPropertyValue("Collab.3D.Paper.Positioning.Type")<=1000){if(n.GetPropertyValue("Collab.3D.Paper.Is.Background")){return -5+n.GetPropertyValue("Collab.3D.Paper.Depth")*0.00001}else{return +7+n.GetPropertyValue("Collab.3D.Paper.Depth")*0.00001}}else{if(n.GetPropertyValue("Actor.IsAlwaysOnTop")){return +5}else{return 0}}}else{var k=n.GetProperty("Actor.Priority");if(k&&k.GetPropertyValue()){return k.GetPropertyValue().Value}else{return 0}}},sortListDisplayPriority:function(i,j){j.sort(function(m,k){var n=i.ComponentsMap.GetComponentFromID(m);var l=i.ComponentsMap.GetComponentFromID(k);if(n&&l){var q=n.QueryInterface("VCXIModifiable");var o=l.QueryInterface("VCXIModifiable");if(q&&o){var r=c.getDisplayPriority(q);var p=c.getDisplayPriority(o);return p-r}}});return j},isModifiableUnderMouse:function(k,j){var m=k.GetObject()._experienceBase.getManager("VCXContextManager").getMainViewer();var i=k.GetProperty("Collab.3D.Paper.Positioning.Type");if(i&&i.GetPropertyValue().Value<=1000){if(!j.vcxPaperPos){j.vcxPaperPos=k.GetObject()._experienceBase.getManager("VCXPaperManager").PixelToMM2(null,j.from[0].getCurrentPosition(m.canvas))}var l=k.GetObject().shapeInfo;if(l){if(Math.abs(k.GetPropertyValue("Collab.3D.Paper.Paper.Position.X")+l.center.x-j.vcxPaperPos.x)<l.size.x*0.5&&Math.abs(k.GetPropertyValue("Collab.3D.Paper.Paper.Position.Y")+l.center.y-j.vcxPaperPos.y)<l.size.y*0.5){return true}}}return false},hasModifiableVisibleProperties:function(k){var j=k.GetProperties();for(var i in j._map){if(j._map.hasOwnProperty(i)){if(j._map[i].GetPropertyInfo().IsVisible()){return true}}}return false},filterChildrenOfModsFromArray:function(i){if(!Array.isArray(i)||i.length===0){return i}if(i[0].QueryInterface("VCXIModifiable")!==i[0]){return i}return this.filterChildrenOfCompsFromArray(i)},filterChildrenOfCompsFromArray:function(m){if(!Array.isArray(m)||m.length===0){return m}var l=m;var j=l.map(function(r){var s=r.QueryInterface("W3AISGNodeHolder");return s&&s.getPathElement()});var o=[];for(var i=0;i<j.length;++i){var k=j[i];if(!k){continue}for(var p=i+1;p<j.length;++p){var q=j[p];if(!q){continue}if(k.isAParentOf(q)){j[p]=null;l[p]=null}else{if(q.isAParentOf(k)){j[i]=null;l[i]=null;break}}}}var n=l.filter(function(r){return r!==null});return n}});return c});define("DS/VCXWebModifiablesServices/VCXModifiablesAccess",["DS/Visualization/ThreeJS_DS","DS/Visualization/PathElement"],function(a,b){var c={getBestIdxElementCandidate:function(f){var e=0;for(var d=f.length-1;d>0;d--){if(!f[d].productType&&!f[d].worktype){if(f[d]._isDressupNode){return d+1}}else{if(f[d].productType&&f[d].productType==="Instance3D"||f[d].worktype&&(f[d].worktype==="VPMInstance"||f[d].worktype==="VPMRepInstance")){return d+1}}}},CleanPathElement:function(f){var h=[];if(f){h=f.externalPath}else{console.log("Missing pathElement !");return}var j=[];var g=h.length;for(var e=0;e<g;e++){j[e]=h[e]}var d=this.getBestIdxElementCandidate(j);if(d!==null&&d<j.length){j.splice(d,j.length-d)}return j},BuildCleanedPathElement:function(d){return new b(this.CleanPathElement(d))},GetModifiableFromPathElement:function(e,d){if(typeof e==="undefined"){return null}var f=null;var h=this.CleanPathElement(e);var g=d.ComponentsMap.GetComponentFromExternalPath(h);if(g){f=g.QueryInterface("VCXIModifiable")}return f},ValuateLinkedProperties:function(e,p,h,m,j){var u=e;var g="";var s=/([^$]|^)\$\(([0-9a-z._-\s]*)#([0-9]*)#([0-9a-z._-]*)\)/i;var d=u.match(s);while(d){var f=d[0];var i=d.index;var t=f.length;if(i>0){g+=u.substring(0,i+1)}var o=d[2];if(o===""){o=h}if(o===""||o==="0"){o=m}var q=parseInt(d[3]);var l=d[4];var v=p.ComponentsMap.GetComponentFromID(o);if(v){while(q>0){var n=v.QueryInterface("VCXIModelNavigable").getParent().GetObject();if(n){v=n}else{console.log("/! ValuateLinkedProperties: bad parent level")}q--}var w=v.QueryInterface("VCXIModifiable");if(w){var k=w.GetProperty(l);if(k){var r="";if(j){r=j(k,p)}else{r=k.GetPropertyValue().ToString()}r=this.ValuateLinkedProperties(r,p,o,m,j);g+=r}}}u=u.substring(i+t);while(u&&u[0]==="\n"){u=u.substring(1);g+="\n"}d=u.match(s)}g+=u;return g},GetPathElementFromEvent:function(h,e){var i=e.getManager("VCXContextManager").getMainViewer();if(!i.canvas){return null}var d=i.getMousePosition(h.from[0].getCurrentPosition(i.canvas));var f=i.pick(d,"mesh",false);var g=null;if(f&&f.path&&f.path.length>0){g=f.path[0].clone()}return g},GetModifiableFromEvent:function(g,d){var f=this.GetPathElementFromEvent(g,d);var e=f&&c.GetModifiableFromPathElement(f,d);return e}};return c});define("DS/VCXWebModifiablesServices/VCXModifiablesChangeServices",["DS/VCXWebModifiablesServices/VCXModifiablesAccess","DS/VCXWebComponents/VCXWebComponentOccurrence"],function(a,b){return{Ghost:function(d,e,i,h){var c=true;var f=a.GetModifiableFromPathElement(e,d);if(!f){return false}var g=1;if(i){g=0.1;f.GetObject().setOpacity(g,true);f.GetObject().setMaterial(null,true)}else{f.GetObject().setOpacity(null,true);f.GetObject().setMaterial(null,true);f.GetObject().setDirtyFlag(b.FDirty.Alpha);f.GetObject().setDirtyFlag(b.FDirty.Material)}if(i){f.GetObject().setPickability("IGNORED",true)}else{f.GetObject().setPickability("PICKABLE",true)}return c},}});