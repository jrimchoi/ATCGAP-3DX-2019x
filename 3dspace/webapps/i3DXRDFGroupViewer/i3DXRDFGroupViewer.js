/*!  Copyright 2018 Dassault Systemes. All rights reserved. */
"use strict";define("DS/i3DXRDFGroupViewer/js/Viewer/SkeletonConfiguration/IdCardsOptions",["DS/W3DXComponents/Skeleton","i18n!DS/i3DXRDFGroupViewer/assets/nls/group"],function(c,b){var a={getMyGroupsIdCardOptions:function(){return{thumbnail:function(){return{squareFormat:false,url:this.get("image")}},attributesMapping:{title:function(){return this.escape("name")},ownerName:function(){var d=this.get("owner");return d?this.get("owner").givenName+" "+this.get("owner").familyName:""},description:function(){return this.get("memberCount")+" "+b.get("tile.member")}},facets:function(){var d=[{name:"members",text:b.get("facet.members"),icon:"users",handler:c.getRendererHandler("membersRenderer")},{name:"properties",text:b.get("facet.properties"),icon:"doc-text",handler:c.getRendererHandler("groupPropertiesRenderer")}];return d}}}};return a});"use strict";define("DS/i3DXRDFGroupViewer/js/Viewer/Models/GroupModel",["UWA/Class/Model","DS/WebappsUtils/WebappsUtils"],function(g,d){var c=d.getWebappsAssetUrl("i3DXRDFGroupViewer","img/default-group.png");var f,e,b="?$mask=dsaccess:Mask.GroupUI.Properties";var a=g.extend({idAttribute:"@id",defaults:{name:"",description:"",groupMembers:[],memberCount:0,image:c,readOnly:false},setup:function(h,i){f=i.usersGroupURL;e=i.customRequest},urlRoot:function(){return f+"/resources"},url:function(){var h=this._parent();return h+b},sync:function(j,i,h){h.ajax=e;this._parent(j,i,h)},parse:function(i,j){var k;if(i.value){k=i.value}else{k=i}var h=k.owner;return{"@id":k["@id"],name:k.name,description:k.description,memberCount:k.memberCount?k.memberCount.totalItems:0,owner:{"@id":h["@id"],givenName:h.givenName.member[0],familyName:h.familyName.member[0]}}}});return a});"use strict";define("DS/i3DXRDFGroupViewer/js/Viewer/Models/MemberModel",["UWA/Class/Model","DS/WebappsUtils/WebappsUtils"],function(d,c){var b=c.getWebappsAssetUrl("i3DXRDFGroupViewer","img/default-member.png");var a=d.extend({idAttribute:"@id",defaults:{image:b},parse:function(e,f){return{"@id":e["@id"],givenName:e.givenName.member[0],familyName:e.familyName.member[0]}}});return a});"use strict";define("DS/i3DXRDFGroupViewer/js/Viewer/Views/GroupProperties",["DS/UIKIT/Form","DS/UIKIT/Input/Button","UWA/Class/View","DS/W3DXComponents/Views/Layout/ScrollView","i18n!DS/i3DXRDFGroupViewer/assets/nls/group"],function(b,a,f,d,e){var c=f.extend({tagName:"div",className:"group-properties",setup:function(g){this.form=this.buildForm();this.form.disable();this.elements.formScrollView=new d({view:this.form,useInfiniteScroll:false,usePullToRefresh:false})},buildForm:function(){var i=this;var g=[{type:"text",multiline:true,rows:5,name:"description",label:e.get("form.description"),value:this.model.get("description")},{type:"text",name:"owner",label:e.get("form.owner")}];var h=new b({fields:g});h.setValue("owner",this.model.get("owner").givenName+" "+this.model.get("owner").familyName);h.render=function(){};h.container=h.elements.container;return h},destroy:function(){this.stopListening();this.model=null;this.form=null;this._parent()},render:function(){this.elements.formScrollView.render().inject(this.container);return this}});return c});"use strict";define("DS/i3DXRDFGroupViewer/js/Viewer/Collections/MemberCollection",["UWA/Class/Collection","DS/i3DXRDFGroupViewer/js/Viewer/Models/MemberModel"],function(d,a){var b="dsaccess:Mask.GroupUI.Members",c,f;var e=d.extend({model:a,setup:function(i,g){this._parent(i,g);c=g._modelKey;var h=g.usersGroupURL;this.swymURL=g.swymURL;f=g.customRequest;this.url=h+"/resources/"+c.id+"/groupMembers";this.state={hasNextPage:true,skip:0,itemsPerPage:50}},sync:function(i,h,g){g.ajax=f;this._parent(i,h,g)},fetch:function(g){var h=this.state.itemsPerPage;if(!g.getNextPage){this.state.skip=0;this.state.hasNextPage=true}else{if(g.getNextPage){this.state.skip+=h}}g.data={$mask:b,$skip:this.state.skip,$top:h,$orderby:"familyName"};if(g.onTimeout){g.onTimeout=g.onTimeout.bind(this)}this._parent(g)},parse:function(g){var h=g.member;if(!h||!h.length){this.state.hasNextPage=false}return h},onAdd:function(h,i,g){if(this.swymURL){h.set("image",this.swymURL+"/api/user/getpicture/login/"+h.get("@id").substring("iam:".length))}}});return e});"use strict";define("DS/i3DXRDFGroupViewer/js/Viewer/SkeletonConfiguration/RenderersOptions",["UWA/Class/Promise","DS/W3DXComponents/Views/EmptyView","DS/W3DXComponents/MemberSet","DS/i3DXRDFGroupViewer/js/Viewer/Collections/MemberCollection","DS/i3DXRDFGroupViewer/js/Viewer/Views/GroupProperties","i18n!DS/i3DXRDFGroupViewer/assets/nls/group"],function(f,c,g,a,e,h){function i(l,j,k){j.add({message:k});l.state.hasNextPage=false}function b(j,l,m){var o=j.collection;var k=j.scrollView;var n=function(p){k.endLoading();k.container.offsetParent.removeClassName("loading");if((p&&!o.state.hasNextPage)||!p){k.useInfiniteScroll(false);j.dispatchEvent("infiniteScrollEnd")}};if(o.state.hasNextPage){o.fetch({getNextPage:true,remove:false,onComplete:function(){n(true)},onFailure:function(){n(false);i(o,l,m)},onTimeout:function(){n(false);i(this,l,m)}})}else{n(false)}}var d={getRenderers:function(m){var q=m.usersGroupURL;var l=m.swymURL;var n=m.customRequest;var k=m.errorAlert;var o=m.onUserClick;var p={fetchMode:"never",view:e,viewOptions:{errorAlert:k}};var j={collection:a,collectionOptions:{usersGroupURL:q,swymURL:l,customRequest:n},fetchMode:"once",fetchOptions:{onFailure:function(r){i(r,k,h.get("member.fetchError"))},onTimeout:function(){i(this,k,h.get("member.fetchError"))}},view:g,viewOptions:function(r){return{className:"loading",contents:{selectionMode:"",headers:[{label:h.get("header.firstName"),property:"header_gname"},{label:h.get("header.lastName"),property:"header_fname"}],emptyView:c,itemViewOptions:{icon:"users",title:h.get("noMembers"),mapping:{title:function(){return(this.model.escape("givenName")+" "+this.model.escape("familyName"))},header_gname:function(){return this.model.escape("givenName")},header_fname:function(){return this.model.escape("familyName")}}},useInfiniteScroll:true,events:{onInfiniteScroll:function(){b(this,k,h.get("member.fetchError"))},onItemViewClick:function(s,t){o&&o(t.model.get("@id").substring("iam:".length))}}}}}};return{groupPropertiesRenderer:p,membersRenderer:j}}};return d});"use strict";define("DS/i3DXRDFGroupViewer/js/GroupViewer",["UWA/Class/View","DS/i3DXCompassPlatformServices/i3DXCompassPlatformServices","DS/UIKIT/Alert","DS/WAFData/WAFData","DS/W3DXComponents/Skeleton","DS/W3DXComponents/Views/EmptyView","DS/UIKIT/Mask","DS/i3DXRDFGroupViewer/js/Viewer/Models/GroupModel","DS/i3DXRDFGroupViewer/js/Viewer/SkeletonConfiguration/RenderersOptions","DS/i3DXRDFGroupViewer/js/Viewer/SkeletonConfiguration/IdCardsOptions","i18n!DS/i3DXRDFGroupViewer/assets/nls/group","css!DS/i3DXRDFGroupViewer/i3DXRDFGroupViewer.css"],function(a,c,i,l,b,e,h,k,j,n,q){var p=new i({className:"create-alert",closable:true,visible:true,autoHide:true,messageClassName:"error"});var o,d,g;var f=function(s,r){s+=(s.indexOf("?")===-1?"?":"&");s+="tenant=dstenant:"+d;var t=r.headers||{};t["Accept-Language"]=o;r.headers=t;return l.authenticatedRequest(s,r)};var m=a.extend({className:"GroupViewer",setup:function(r){d=r.platformId;o=r.language||"en";var s=r.groupId;g=(s.indexOf("<")!==-1&&s.indexOf(">")!==-1)?s.slice(s.indexOf("<")+"<".length,s.indexOf(">")):s},_buildSkeleton:function(r){r.errorAlert=p;var s=new b(j.getRenderers(r),{rootIdCardOptions:UWA.merge(n.getMyGroupsIdCardOptions(),{model:r.model}),events:{}});this.bones=s},render:function(){var s=this,r=this.options.onUserClick;h.mask(s.container);c.getPlatformServices({platformId:d,onComplete:function(t){var w=t.usersgroup+"/3drdfindex/v0";var u=t["3DSwym"];var v=new k({"@id":g},{usersGroupURL:w,customRequest:f});v.fetch({onComplete:function(){s._buildSkeleton({model:v,languagePref:o,usersGroupURL:w,swymURL:u,customRequest:f,onUserClick:r});h.unmask(s.container);p.inject(s.container);s.bones.render().inject(s.container)},onFailure:function(A,y,z){var x=z.request.xhr.status;h.unmask(s.container);var B=new e({icon:"alert",title:x===404?q.get("group.notFound"):q.get("group.fetchError")});B.render().inject(s.container)}})},onFailure:function(){h.unmask(s.container);var t=new e({icon:"alert",title:q.get("compassError")});t.render().inject(s.container)}});return this},destroy:function(){if(this.bones){this.bones.destroy()}this._parent()}});return m});