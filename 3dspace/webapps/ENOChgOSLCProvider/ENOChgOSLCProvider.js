define("DS/ENOChgOSLCProvider/scripts/ChangeOSLCUtility",["DS/WAFData/WAFData","DS/WidgetServices/WidgetServices","DS/UIKIT/Alert",],function(a,d,c){var b={error:function(e){this.message(e,"error")},success:function(e){this.message(e,"success")},warn:function(e){this.message(e,"warning")},info:function(e){this.message(e,"primary")},message:function(g,f){if(this.alertCA!=null){this.alertCA.hide()}var e=true;if(f=="error"){e=false}this.alertCA=new c({closable:true,visible:true,autoHide:e,hideDelay:3500,className:"wp-alert"}).inject(document.body,"top");this.alertCA.add({className:f,message:g})},createCO:function(g,f,h){var e="/resources/v1/modeler/oslc/cm/services/changeorder";b.makeWSCall(e,"POST","enovia","application/json",g,f,h)},createCR:function(g,f,h){var e="/resources/v1/modeler/oslc/cm/services/changerequest";b.makeWSCall(e,"POST","enovia","application/json",g,f,h)},createCA:function(g,f,h){var e="/resources/v1/modeler/oslc/cm/services/changeaction";b.makeWSCall(e,"POST","enovia","application/json",g,f,h)},getCADetails:function(e){var f=new Promise(function(k,j){var g="/resources/v1/modeler/oslc/cm/services/changeaction/"+e;var h="";var i=function(l){k(l)};b.makeWSCall(g,"GET","enovia","application/json",h,i,j,false)});return f},getCODetails:function(e){var f=new Promise(function(k,j){var g="/resources/v1/modeler/oslc/cm/services/changeorder/"+e;var h="";var i=function(l){k(l)};b.makeWSCall(g,"GET","enovia","application/json",h,i,j,false)});return f},getCRDetails:function(e){var f=new Promise(function(k,j){var g="/resources/v1/modeler/oslc/cm/services/changerequest/"+e;var h="";var i=function(l){k(l)};b.makeWSCall(g,"GET","enovia","application/json",h,i,j,false)});return f},getPlatformUrls:function(){var e=new Promise(function(j,i){var g="/resources/v1/bps/oslc/cm/platform-urls";var h="";var f=function(k){var l={};l.platformurls=k;j(l)};b.makeWSCall(g,"GET","enovia","application/json",h,f,i,true)});return e},makeWSCall:function(j,f,n,i,l,p,k){var h="../..";ChgOSLCWidget.url=h;var e=h+j;var m=new Date().getTime();if(e.indexOf("?")==-1){e=e+"?tenant="+ChgOSLCWidget.tenant+"&timestamp="+m}else{e=e+"&tenant="+ChgOSLCWidget.tenant+"&timestamp="+m}var q=ChgOSLCWidget.securityContext;p=p||function(){};k=k||function(){};var g=widget.getValue("lang");if(widget.lang){g=widget.lang}var o={};o.method=f;o.timeout=ChgOSLCWidget.wsCallTimeout;o.type="json";if(ChgOSLCWidget.isNative){if(q){o.headers={Accept:"application/json","Content-Type":i,SecurityContext:q,"Accept-Language":g}}else{o.headers={Accept:"application/json","Content-Type":i,"Accept-Language":g}}}else{if(n){o.auth={passport_target:n}}o.proxy=ChgOSLCWidget.proxy;if(q){o.headers={Accept:"application/json","Content-Type":i,SecurityContext:q,"Accept-Language":g}}else{o.headers={Accept:"application/json","Content-Type":i,"Accept-Language":g}}}if(l){o.data=l}o.onComplete=function(r){console.log("Success calling url: "+e);console.log("Success data: "+JSON.stringify(r));p(r)};o.onFailure=function(s,r){console.log("Error in calling url: "+e);console.log("Additional Details:: httpMethod: "+f+" authentication: "+n+" securityContext: "+q+" ContentType: "+i);console.log("Error Detail: "+s);console.log("Error Data: "+JSON.stringify(r));k(s,r)};o.onTimeout=function(){console.log("Timedout for url: "+e)};a.authenticatedRequest(e,o)},};return b});define("DS/ENOChgOSLCProvider/scripts/ChangeObjectProperties",["UWA/Core","DS/ENOChgOSLCProvider/scripts/ChangeOSLCUtility","DS/WidgetServices/securityContextServices/SecurityContextServices","UWA/Class/Model","UWA/Date","DS/UIKIT/Scroller","css!DS/ENOChgOSLCProvider/ENOChgOSLCProvider","i18n!DS/ENOChgOSLCProvider/assets/nls/ChangeOSLCProvider","css!DS/UIKIT/UIKIT"],function(g,j,c,d,h,e,f,i,b){var a={model:null,init:function(l){window.ChgOSLCWidget={tenant:l.tenant?l.tenant:"OnPremise",wsCallTimeout:60000,isNative:false,proxy:window.UWA.Data.proxies.passport?"passport":"ajax",};var m=this;this.options=l;m.getParams();m.model=new d({id:l.id});var k=m.displayChangeProp(l)},displayChangeProp:function(k){this.MainContainer=UWA.Element("div",{"class":"OSLC_CHGProperties_MainContainer"});var m=this;var l=m.model.get("id");this._initscroller();switch(m.options.Entity){case"ChangeAction":this.ChangeData=j.getCADetails(l).then(function(n){m.UpdateUIForAttributes(n)});break;case"ChangeRequest":this.ChangeData=j.getCRDetails(l).then(function(n){m.UpdateUIForAttributes(n)});break;case"ChangeOrder":this.ChangeData=j.getCODetails(l).then(function(n){m.UpdateUIForAttributes(n)});break}this.MainContainer.inject(document.body)},CreateElements:function(o){var p=this;var l=o[0]?o[0]:"";var q=o[1]?o[1]:"";var n=UWA.Element("div",{"class":"AttOSCLCHGContainer"});var k=UWA.Element("div",{"class":"CHG_Attribute_Name",html:{text:l}});var m=UWA.Element("div",{"class":"CHG_Attribute_Value",html:{text:q}});n.addContent(k);n.addContent(m);return n},CreateElementFromObj:function(r){var o=UWA.Element("div",{"class":"AttOSCLCHGContainer1"});var q=this;var p=Object.keys(r);var n=Object.values(r);for(var m=0;m<p.length;m++){var l=Object.values(n[m]);o.addContent(q.CreateElements(l))}return o},_initscroller:function(){var m=this;this.scrollerContainer=document.getElementById("AttOSCLCHGContainer-scroll");if(!this.scrollerContainer){this.scrollerContainer=UWA.createElement("div",{id:"AttOSCLCHGContainer-scroll",styles:{height:"90%",display:"flex","flex-direction":"column"}})}this.scrollerContainer.empty();if(m.options.preview=="large"){var k=m.AttOSCLCHGBasic=UWA.Element("div",{"class":"AttOSCLCHGBasic",styles:{}});var o=m.AttOSCLCHGDetails=UWA.Element("div",{"class":"AttOSCLCHGDetails",styles:{}});var l=m.AttOSCLCHGTeam=UWA.Element("div",{"class":"AttOSCLCHGTeam",styles:{}});m.scrollerContainer.addContent(k);m.scrollerContainer.addContent(o);m.scrollerContainer.addContent(l)}else{var n=m.AttOSCLCHGShortPreview=UWA.Element("div",{"class":"AttOSCLCHGShortPreview",styles:{height:"90%"}});m.scrollerContainer.addContent(n)}},CreateBasicElements:function(n){var o=this;var k=UWA.Element("div",{"class":"AttOSCLCHGHeader",html:{text:i.ECM_CA_Header_Basic}});o.AttOSCLCHGBasic.addContent(k);if(o.options.Entity=="ChangeAction"){var l={AttName:{name:i.ECM_CA_Name,value:o.model.get("name")},AttTitle:{name:i.ECM_CA_Title,value:o.model.get("synopsis")},AttType:{name:i.ECM_CA_Type,value:o.model.get("type")},AttPolicy:{name:i.ECM_CA_Policy,value:o.model.get("policy")},AttDescription:{name:i.ECM_CA_Description,value:o.model.get("description")},AttState:{name:i.ECM_CA_State,value:o.model.get("currentDisplay")},AttOwner:{name:i.ECM_CA_Team_Owner,value:o.model.get("owner")},}}else{if(o.options.Entity=="ChangeRequest"){var l={AttName:{name:i.ECM_CA_Name,value:o.model.get("name")},AttDescription:{name:i.ECM_CA_Description,value:o.model.get("description")},AttType:{name:i.ECM_CA_Type,value:o.model.get("type")},AttInitiator:{name:i.ECM_CA_Intiator,value:o.model.get("originator")},AttOwner:{name:i.ECM_CA_Team_Owner,value:o.model.get("owner")},AttState:{name:i.ECM_CA_State,value:o.model.get("currentDisplay")},AttPolicy:{name:i.ECM_CA_Policy,value:o.model.get("policy")},AttCoOrdinator:{name:i.ECM_CA_Change_Coordinator,value:o.model.get("coordinator")},}}else{if(o.options.Entity=="ChangeOrder"){var l={AttName:{name:i.ECM_CA_Name,value:o.model.get("name")},AttDescription:{name:i.ECM_CA_Description,value:o.model.get("description")},AttType:{name:i.ECM_CA_Type,value:o.model.get("type")},AttInitiator:{name:i.ECM_CA_Intiator,value:o.model.get("originator")},AttOwner:{name:i.ECM_CA_Team_Owner,value:o.model.get("owner")},AttState:{name:i.ECM_CA_State,value:o.model.get("currentDisplay")},AttPolicy:{name:i.ECM_CA_Policy,value:o.model.get("policy")},}}}}var m=a.CreateElementFromObj(l);o.AttOSCLCHGBasic.addContent(m)},CreateDetailsElements:function(n){var k=UWA.Element("div",{"class":"AttOSCLCHGHeader",html:{text:i.ECM_CA_Header_Details}});var o=this;o.AttOSCLCHGDetails.addContent(k);switch(o.options.Entity){case"ChangeAction":var l={AttResp:{name:i.ECM_CA_Responsible_Organization,value:o.model.get("organization")},AttCO:{name:i.ECM_CA_Governing_CO,value:o.model.get("changeOrderName")},AttSev:{name:i.ECM_CA_Severity,value:o.model.get("severity")},AttCat:{name:i.ECM_CA_CategoryofChange,value:o.model.get("categoryofChange")},};break;case"ChangeRequest":var l={AttResp:{name:i.ECM_CA_Responsible_Organization,value:o.model.get("organization")},Attdeco:{name:i.ECM_CA_CHG_DECOMPOSITION,value:o.model.get("decomposition")},AttCat:{name:i.ECM_CA_CategoryofChange,value:o.model.get("categoryofChange")},AttSev:{name:i.ECM_CA_Severity,value:o.model.get("severity")},Attreason:{name:i.ECM_CA_ReasonForChange,value:o.model.get("reasonforchange")},Attreport:{name:i.ECM_CA_ReportedAgainst,value:o.model.get("reportedAgainst")},};break;case"ChangeOrder":var l={AttResp:{name:i.ECM_CA_Responsible_Organization,value:o.model.get("organization")},Attreport:{name:i.ECM_CA_ReportedAgainst,value:o.model.get("reportedAgainst")},AttParent:{name:i.ECM_CA_CHG_Parent_CO,value:o.model.get("parentCO")},Attreason:{name:i.ECM_CA_CHG_Related_CR,value:o.model.get("relatedCR")},AttCat:{name:i.ECM_CA_CategoryofChange,value:o.model.get("categoryofChange")},AttSev:{name:i.ECM_CA_Severity,value:o.model.get("severity")},};break}var m=a.CreateElementFromObj(l);o.AttOSCLCHGDetails.addContent(m)},CreateTeamElements:function(o){var k=UWA.Element("div",{"class":"AttOSCLCHGHeader",html:{text:i.ECM_CA_Header_Team}});var p=this;p.AttOSCLCHGTeam.addContent(k);var n=p.model.get("people");if(n){switch(p.options.Entity){case"ChangeAction":var m={AttResp:{name:i.ECM_CA_Assignees,value:n.assignee},AttCO:{name:i.ECM_CA_Reviewers,value:n.reviewer},AttSev:{name:i.ECM_CA_Followers,value:n.follower},};break;case"ChangeRequest":var m={};break;case"ChangeOrder":var m={AttSev:{name:i.ECM_CA_Approvers,value:n.approver},};break}var l=a.CreateElementFromObj(m);p.AttOSCLCHGTeam.addContent(l)}},CreateSmallPreviewElements:function(n){var o=this;var k=UWA.Element("div",{"class":"AttOSCLCHGHeader",html:{text:i.ECM_CA_Header_Preview}});o.AttOSCLCHGShortPreview.addContent(k);var l={AttName:{name:i.ECM_CA_Name,value:o.model.get("name")},AttSev:{name:i.ECM_CA_Severity,value:o.model.get("severity")},AttDescription:{name:i.ECM_CA_Description,value:o.model.get("description")},AttOwner:{name:i.ECM_CA_Team_Owner,value:o.model.get("owner")},AttState:{name:i.ECM_CA_State,value:o.model.get("currentDisplay")},AttDue:{name:i.ECM_CA_DueDate,value:o.model.get("due")},};var m=a.CreateElementFromObj(l);o.AttOSCLCHGShortPreview.addContent(m)},UpdateUIForAttributes:function(p){var n=this;var o="%Y-%m-%d";var m=null;switch(n.options.Entity){case"ChangeAction":m=p.changeaction;break;case"ChangeRequest":m=p.changerequest;break;case"ChangeOrder":m=p.changeorder;break}n.model.set("id",m.pid);var l=m.attributes;if(UWA.is(l)){l.forEach(function(q){if(q.name==="Category of Change"){n.model.set("categoryofChange",q.value)}else{if(q.name==="Estimated Completion Date"){n.model.set("due",(UWA.is(q.value)&&q.value!=="")?h.strftime(new Date(q.value),o):"");if(n.model.get("due")===""){n.model.set("due",i.ECM_CA_DUEDATE_UNASSIGNED)}}else{if(q.name==="Severity"){n.model.set("severity","",{silent:true});n.model.set("severity",q.value)}else{if(q.name==="Synopsis"){n.model.set("synopsis",q.value)}else{if(q.name==="project"){n.model.set("project_space",q.value)}}}}}})}var k={};if(UWA.is(m.people)){k.assignee=m.people.assignees;k.follower=m.people.followers;k.reviewer=m.people.reviewers;k.approver=m.people.approvers}n.model.set("people",k);n.model.set("owner",m.owner);n.model.set("originator",m.originator);n.model.set("coordinator",m.changeCoordinator);n.model.set("organization",m.organization);n.model.set("current",m.current);n.model.set("currentDisplay",i.get("ECM_CA_State_"+n.model.get("current")));n.model.set("name",m.name);n.model.set("description",m.description);n.model.set("policy",m.policy);n.model.set("type",m.type);if(UWA.is(m.reportedAgainst)){n.model.set("reportedAgainst",m.reportedAgainst.name)}if(UWA.is(m.relatedCR)){n.model.set("relatedCR",m.relatedCR.name)}if(UWA.is(m.parentCO)){n.model.set("parentCO",m.parentCO.name)}if(UWA.is(m.governingCO)&&UWA.is(m.governingCO.pid)){n.model.set("changeOrderName",m.governingCO.name);n.model.set("changeOrderId",m.governingCO.pid)}if(n.options.preview=="large"){a.CreateBasicElements();a.CreateDetailsElements();if(n.options.Entity!="ChangeRequest"){a.CreateTeamElements()}}else{a.CreateSmallPreviewElements()}n.scrollerContainer.inject(n.MainContainer)},getParams:function(){var o={};var p=document.createElement("a");p.href=location.href;var l=p.search.substring(1);var m=l.split("&");for(var k=0;k<m.length;k++){var n=m[k].split("=");this.options[n[0]]=decodeURIComponent(n[1])}return o},};return a});define("DS/ENOChgOSLCProvider/scripts/ChangeReportedAgainst",["UWA/Core","DS/UIKIT/Input","DS/LifecycleServices/LifecycleServicesSettings","DS/LifecycleCmd/OSLCConsumerCmd","DS/ENOChgOSLCProvider/scripts/ChangeOSLCUtility","i18n!DS/ENOChgOSLCProvider/assets/nls/ChangeOSLCProvider","css!DS/ENOChgOSLCProvider/ENOChgOSLCProvider",],function(g,e,d,c,b,f){var a=e.extend({defaultOptions:{placeholder:f.ECM_CA_ReportedAgainstPlaceHolder,fileBannedChars:["'","#","$","@","%"],multiple:false},routeTemplate:{},socket:null,init:function(h){g.merge(this.defaultOptions,h);this._parent(h)},buildInput:function(){var h=g.createElement("div",{"class":"eno-rt-search",html:this.options.text});this.mLabelElement=g.createElement("label",{html:f.ECM_CA_ReportedAgainst,}).inject(h);this.mInputElement=g.createElement("div",{"class":"eno-rt-input input-group"}).inject(h);this.mTextElement=g.createElement("input",{"class":"form-control",name:"txtIssueAffectedItem",placeholder:this.options.placeholder,disabled:true}).inject(this.mInputElement);this.mTextElementPID=g.createElement("input",{type:"hidden",name:"txtActualAffectedItem"}).inject(this.mInputElement);var i=this;i.nativeSearchButton=g.createElement("span",{"class":"input-group-addon",html:f.ECM_CA_Native,styles:{cursor:"pointer"},events:{click:i.onInputClick.bind(i)}}).inject(i.mInputElement);i.extSearchButton=g.createElement("span",{"class":"input-group-addon",html:f.ECM_CA_External,styles:{cursor:"pointer"},events:{click:i.onExtInputClick.bind(i)}}).inject(i.mInputElement);h.addEventListener("dragover",this.onInputDragOver.bind(this),false);h.addEventListener("dragleave",this.onInputDragLeave.bind(this),false);h.addEventListener("drop",this.onInputDrop.bind(this),false);return h},clear:function(){this.elements.container.removeClassName("error");this.elements.container.setText(this.options.placeholder)},selected_Objects_search:function(h){},onInputClick:function(){var l=this;var k=l.options;var j="../../webapps/ENOOSLCIssueProvider/ENODataGrid.html?showTitle="+k.showTitle+"&showDesc="+k.showDesc+"&relationships="+k.relationships+"&allowMultiSelect=N&cspid="+k.cspid;var i=window.open(j,"_blank","toolbar=yes,scrollbars=no,resizable=yes,top=300,left=300,width=800,height=500");if(window.focus){i.focus()}window.addEventListener("message",function(q){var s=q.data;s=s.replace("oslc-response:","").trim();var p=JSON.parse(s);var n=p["oslc:results"];if(n&&n.length>0){var m=new Array();var r=new Array();for(var o in n){m.push(n[o]["oslc:label"]);r.push(n[o]["oslc:PID"])}l.mTextElement.value=m.join("|");l.mTextElementPID.value=r.join("|")}i.close()},false);var h=this.mTextElement.parentNode;if(h){h.removeClassName("has-error")}},onExtInputClick:function(){var h=this;b.getPlatformUrls().then(function(i){require(["DS/ENOChgOSLCConsumer/scripts/ENOECMOSLCConsumer"],function(j){var k=new j();k.setupWithExternalSetting(i.platformurls);k.launchDelegatedUIWithExternalSetting(k.createReportedAgainstPostProcessCommon)})})},createChangePostProcessCommon:function(r){if(r&&r.objects&&r.objects.length>0){var o=document.getElementsByName("txtIssueAffectedItem")[0];var q=document.getElementsByName("txtActualAffectedItem")[0];var m="",j="";var p=true;if(o&&q){var n=r.objects;for(var l=0;l<n.length;l++){var k=n[l];var h=k.proxy;if(h&&h.id&&h.dataelements&&h.dataelements.name){if(p){j=h.id;m=h.dataelements.name;p=false}else{j=j+"|"+h.id;m=m+"|"+h.dataelements.name}}}o.value=m;q.value=j}}},onInputDragOver:function(h){},onInputDragLeave:function(h){},onInputDrop:function(h){},onInputChange:function(h){},getValue:function(){return this.mTextElement.value}});return a});define("DS/ENOChgOSLCProvider/scripts/ChangeObjectCreate",["UWA/Core","UWA/Date","UWA/Element","DS/WAFData/WAFData","UWA/Class/View","DS/UIKIT/Alert","UWA/Widget","UWA/Drivers/Alone","DS/UIKIT/Form","DS/UIKIT/Input/Button","DS/UIKIT/Input/Date","DS/ENOChgOSLCProvider/scripts/ChangeReportedAgainst","DS/ENOChgOSLCProvider/scripts/ChangeOSLCUtility","DS/ENOFrameworkPlugins/jQuery","i18n!DS/ENOChgOSLCProvider/assets/nls/ChangeOSLCProvider","css!DS/ENOChgOSLCProvider/ENOChgOSLCProvider","css!DS/UIKIT/UIKIT.css",],function(i,l,n,j,a,f,k,b,h,g,e,c,p,q,o){var d=new f({className:"csg-alert",closable:true,renderTo:document.body,visible:true,autoHide:true,hideDelay:5000,messageClassName:"error"});var m=a.extend({name:"createChange",tagName:"div",className:"create-change-view",init:function(r){var s=UWA.clone(r,false);["container","template","tagName","domEvents"].forEach(function(t){delete s[t]});m.options=r;window.widget=new k();window.ChgOSLCWidget={tenant:r.tenant?r.tenant:"OnPremise",wsCallTimeout:60000,isNative:false,proxy:window.UWA.Data.proxies.passport?"passport":"ajax",options:{Entity:r.Entity}};this._parent(s)},setup:function(){window.isIE=false;this.container.addClassName(this.getClassNames("-container"));this._initAlert();this._initForm();this._initListenKeyDown();this._detectBrowser(navigator.userAgent)},_detectBrowser:function(r){var s=/(msie|trident)/i.test(r);if(s){window.isIE=true}},_initAlert:function(){},_initForm:function(){var A=this,y=this.options,E=this.options.Entity,D,u,G=this.elements,t,J,C,v;var K=A.getParameterByName("cspid");var B=new c({cspid:K,showTitle:"Y",showDesc:"N",type:"type_Requirement"});var x={type:"textarea",name:"txtChangeDescription",rows:3,required:true,label:o.ECM_CA_Description,maxlength:"128",placeholder:o.ECM_CA_Description_PlaceHolder,events:{onChange:function(){var M=this.getValue().trim();if(M!==""){var L=this.elements.input.parentNode;if(L){L.removeClassName("has-error")}}}}};var z={type:"text",name:"txtAbstract",required:true,label:o.ECM_CA_Abstract,maxlength:"128",placeholder:o.ECM_CA_Abstract_PlaceHolder,events:{onChange:function(){var M=this.getValue().trim();if(M!==""){var L=this.elements.input.parentNode;if(L){L.removeClassName("has-error")}}}}};var r={type:"html",name:"ReportedAgainstElem",html:B};var w={type:"select",name:"txtPolicy",label:o.ECM_CA_Policy,nativeSelect:false,required:true,placeholder:false,options:[{value:"policy_FasttrackChange",label:o.ECM_CA_Policy_FastTrack,selected:true},{value:"policy_FormalChange",label:o.ECM_CA_Policy_FormalChange}]};var F={type:"select",name:"txtSeverity",label:o.ECM_CA_Severity,nativeSelect:false,placeholder:false,options:[{value:"Low",label:o.ECM_CA_Severity_Low,selected:true},{value:"Medium",label:o.ECM_CA_Severity_Medium},{value:"High",label:o.ECM_CA_Severity_High}]};var H=UWA.createElement("div",{id:"DueDateDiv",html:[{tag:"h5",html:o.ECM_CA_DueDate},{tag:"span","class":"due-date-span",html:this.createDueDateElem()},{tag:"input",type:"hidden",name:"DueDate_hidden",id:"DueDate_hidden",value:"",}]});var I={type:"html",html:H,name:"date-field"};var u=[];var s="";if(E=="ChangeAction"){u.push(z);u.push(x);u.push(F);u.push(I);s=o.ECM_ChangeAction_Definition}else{if(E=="ChangeOrder"||E=="ChangeRequest"){u.push(x);u.push(r);u.push(F);if(E=="ChangeOrder"){u.push(w);s=o.ECM_ChangeOrder_Definition}else{u.push(I);s=o.ECM_ChangeRequest_Definition}}}t=new h({fields:u,events:{onSubmit:function(){A.onCreate()},onInvalid:function(L){},onValid:function(){}}});A._form=t;var J=UWA.createElement("div",{"class":"header",html:s});C=new g({value:o.ECM_CA_Button_Done,className:"primary",events:{onClick:this.dispatchAsEventListener("onCreate")}});v=new g({value:o.ECM_CA_Cancel,events:{onClick:this.dispatchAsEventListener("onCancel")}});G.form=t;G.header=J;G.create=C;G.cancel=v},getCreateButton:function(){return this.elements.create},getCancelButton:function(){return this.elements.cancel},_initListenKeyDown:function(){this.onKeyDown=this.onKeyDown.bind(this);document.addEventListener("keydown",this.onKeyDown)},onKeyDown:function(r){},submitEnabled:function(){var r=this.elements.create.elements.content.getAttribute("disabled");return r===null?true:false},onCancel:function(){window.parent.postMessage('oslc-response:{"oslc:results":[]}',"*")},render:function(){var u=this.elements,t=u.form,r=u.create,v=u.header,s=u.cancel;this.container.setContent([v,t,{tag:"div","class":"footer",html:[r,s]}]);return this},_validateInput:function(u){var t=this;var s={txtChangeDescription:t.elements.form.getField("txtChangeDescription"),txtAbstract:t.elements.form.getField("txtAbstract"),txtPolicy:t.elements.form.getField("txtPolicy")};if("ChangeAction"==u){if(typeof s.txtAbstract.value=="undefined"||s.txtAbstract.value.trim()==""){d.add({message:o.ECM_OSLC_TitleEmptyFieldMessage});var r=s.txtAbstract.parentNode;if(r){r.addClassName("has-error")}s.txtAbstract.focus();return false}}if(typeof s.txtChangeDescription.value=="undefined"||s.txtChangeDescription.value.trim()==""){d.add({message:o.ECM_OSLC_DescriptionEmptyFieldMessage});var r=s.txtChangeDescription.parentNode;if(r){r.addClassName("has-error")}s.txtChangeDescription.focus();return false}if("ChangeOrder"==u){if(typeof s.txtPolicy.value=="undefined"||s.txtPolicy.value.trim()==""){d.add({message:o.ECM_OSLC_PolicyEmptyFieldMessage});var r=s.txtPolicy.parentNode;if(r){r.addClassName("has-error")}s.txtPolicy.focus();return false}}return true},onCreate:function(){var u=this,s="../../resources/v1/bps/oslc/cm/change";var t=u.options.Entity;if(this._validateInput(t)){u.elements.create.setDisabled();var v;if(window.isIE){v=navigator.userLanguage}else{v=navigator.language}v.replace("-","_");var r=this.getCreateEditData("create");switch(this.options.Entity){case"ChangeAction":p.createCA(JSON.stringify(r),this.onCompleteCallback,this.onFailureCallback);break;case"ChangeRequest":p.createCR(JSON.stringify(r),this.onCompleteCallback,this.onFailureCallback);break;case"ChangeOrder":p.createCO(JSON.stringify(r),this.onCompleteCallback,this.onFailureCallback);break}}},onCompleteCallback:function(r){var u=null;switch(window.ChgOSLCWidget.options.Entity){case"ChangeAction":u=r.changeaction;break;case"ChangeRequest":u=r.changerequest;break;case"ChangeOrder":u=r.changeorder}var s=u.pid;var t=u.name;var v=u["rdf:resource"];var w={"oslc:results":[{"oslc:label":t,"rdf:resource":v+"/"+s,}]};if(w!=null&&typeof w!="undefined"){window.parent.postMessage("oslc-response:"+JSON.stringify(w),"*")}p.success(w)},onFailureCallback:function(s,r){},sendErrorResponse:function(t,s){var r={"oslc:statusCode":s,"oslc:message":t};window.parent.postMessage("oslc-response:"+JSON.stringify(r),"*")},onDestroy:function(){},getParameterByName:function(s,r){if(!r){r=window.location.href}s=s.replace(/[\[\]]/g,"\\$&");var u=new RegExp("[?&]"+s+"(=([^&#]*)|&|#|$)"),t=u.exec(r);if(!t){return""}if(!t[2]){return""}return decodeURIComponent(t[2].replace(/\+/g," "))},createDueDateElem:function(){var r=UWA.createElement("span",{"class":"date-input-container",html:[(new e({name:"DueDate",id:"DueDate",required:false,min:new Date(),value:"",placeholder:o.ECM_CA_Date_PlaceHolder,events:{onChange:this.dueDateOnChange}})),{tag:"span","class":"cancel-span",html:this.createCancelBtnSpan()},{tag:"span","class":"calendar-span",html:this.createCalenderSpan()},]});return[{styles:{border:"1px solid #b4b6ba","border-radius":"5px",display:"flex","background-color":"#f4f5f6",},html:r}]},dueDateOnChange:function(){var t=i.extendElement(document.body).getElement("#DueDate");var s=i.extendElement(document.body).getElement("#DueDate_hidden");if(t.value){var u="%m/%d/%Y";s.value=l.strftime(this.getDate(),u);u="%Y-%m-%d";t.value=l.strftime(this.getDate(),u)}else{t.value="";s.value=""}var r=q("#duedatecancel");var v=q("#calenderspan");if(r){r.css("display","block");r.css("visibility","visible")}if(v){v.css("display","none")}},createCancelBtnSpan:function(){var r=UWA.createElement("span",{"class":"clear-filter fonticon fonticon-cancel-circled",id:"duedatecancel",});r.set({events:{click:function(u){var t=q("#DueDate");var w=q("#DueDate_Hidden");if(t){t.val("")}if(w){w.val("")}var s=q("#duedatecancel");var v=q("#calenderspan");if(s){s.css("display","none")}if(v){v.css("display","block")}}}});return[{html:r}]},createCalenderSpan:function(){var r=UWA.createElement("span",{"class":"fonticon fonticon-calendar",id:"calenderspan",});r.set({events:{click:function(t){var s=i.extendElement(document.body).getElement("#DueDate");s.click()}}});return[{html:r}]},getCreateEditData:function(s){var w=this.elements.form.getField("txtChangeDescription").value;var z=this.elements.form.getField("txtSeverity").value;if("ChangeAction"==this.options.Entity){var t=this.elements.form.getField("txtAbstract").value;var x=this.elements.form.getField("DueDate_hidden").value}else{if("ChangeRequest"==this.options.Entity||"ChangeOrder"==this.options.Entity){var v=this.elements.form.getField("txtIssueAffectedItem").value;var y=this.elements.form.getField("txtActualAffectedItem").value;if("ChangeOrder"==this.options.Entity){var u=this.elements.form.getField("txtPolicy").value}else{var x=this.elements.form.getField("DueDate_hidden").value}}}var r="";switch(this.options.Entity){case"ChangeAction":r={version:"v0",changeaction:{name:"",revision:"-",type:"type_ChangeAction",description:w,attributes:[{name:"Synopsis",value:t},{name:"Estimated Completion Date",value:x},{name:"Severity",value:z}]}};break;case"ChangeRequest":r={version:"v0",changerequest:{name:"",revision:"-",type:"type_ChangeRequest",description:w,reportedAgainst:{name:v,pid:y,},attributes:[{name:"Estimated Completion Date",value:x},{name:"Severity",value:z}]}};break;case"ChangeOrder":r={version:"v0",changeorder:{name:"",revision:"-",type:"type_ChangeOrder",description:w,policy:u,reportedAgainst:{name:v,pid:y,},attributes:[{name:"Severity",value:z}]}};break}return r}});return m});