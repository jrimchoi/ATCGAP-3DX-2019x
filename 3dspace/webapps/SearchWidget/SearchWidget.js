define("DS/SearchWidget/SearchWidgetConstant",[],function(){var a={TYPE_FULL:"all",TYPE_PERSON:"user ",TYPE_PROJECT:"collabspace",TYPE_ORGANIZATION:"org",EXTTYPE_USERGRP:"userGrp"};return a});define("DS/SearchWidget/models/SW_ItemModel",["UWA/Controls/Abstract"],function(b){var a=b.extend({init:function(d){this.itemTitle="";this.itemId="";this.itemIcon="";this.isSW_ItemModel=true;for(var c in d){this[c]=d[c]}},getTitle:function(){return this.itemTitle},getId:function(){return this.itemId},getIcon:function(){return this.itemIcon},setTitle:function(c){this.itemTitle=c},setId:function(c){this.itemId=c},setIcon:function(c){this.itemIcon=c}});return a});define("DS/SearchWidget/componentUI/SearchWidgetUI",["UWA/Core","UWA/Controls/Abstract","UWA/Json","DS/WidgetServices/WidgetServices","DS/UIKIT/Spinner","DS/UIKIT/Input/Text","DS/UIKIT/Input/Button","DS/UIKIT/Scroller","i18n!DS/SearchWidget/assets/nls/langSW"],function(h,g,k,j,c,a,d,b,e){var i="js-selected";var f=g.extend({_timerLastKey:null,defaultOptions:{className:"SW_InputWithFilter",id:"SW_SearchPeople",Label:"",hint:"",MaxNumber:"6",MaxSize:"",position:"auto",acceptEmpty:false,setBorderColor:false,wintop:false},init:function(l){this._parent(l);this._currentNotif=null;this.parentBody=j.getWidgetBody();this._currentPosition="auto";if(this.options.position==="auto"){this._currentPosition="top"}else{this._currentPosition=this.options.position}this.mainScrollerSearch=null;this.currentChoice=null;this.initUI();this.mouseIsInBlock=false},_timeEnd:function(){this._timerLastKey=null;this.dispatchEvent("onUserChoice")},_elementIsButton:function(l){return l&&l.hasClassName("SW_ButtonMoreContainer")},initUI:function(){var q=this;var p=q.parentBody.getParent("body");p=p?p:q.parentBody;q.container=UWA.createElement("div",{"class":"SW_upperContainer "+q.options.className,html:""});q.labelArea=UWA.createElement("label",{id:"label_"+q.options.id,html:q.options.Label});if(q.options.Label==""){q.labelArea.hide()}q.searchDiv=UWA.createElement("div",{"class":"SW_SearchInputClass",id:q.options.id,"data-rec-id":"RecSearchsearchDiv"});q.inputDiv=UWA.createElement("div",{"class":"SW_inputDivClass input-group","data-rec-id":"RecSearchinputDiv"});q.saveIDUser=UWA.createElement("span",{"class":"SW_SaveIDUser",text:""});if(q.options.hint==""){q.options.hint=e.get("hintSearch")}var n=null;q.searchInput=new a({value:"",name:"SW_SearchInput",className:"SW_SearchInput",attributes:{placeholder:q.options.hint+" ",autocomplete:"none","data-rec-id":"RecSearchinputText"},events:{onKeyDown:function(u){u.stopPropagation();q.currentOwner=null;var s=[39,37,16,9,20];if(u.which==13){var t=q.filterAreaContent.getElement("."+i);if(t){var v=q._elementIsButton(t);if(v){q.selectNextOrPreviousResult("previous");t.click();q.selectNextOrPreviousResult("next")}else{q.__setInput(t)}}else{q.dispatchEvent("onUserChoice")}}else{if(u.which===40){q.selectNextOrPreviousResult("next")}else{if(u.which===38){q.selectNextOrPreviousResult("previous")}else{if(s.indexOf(u.which)<0&&!u.ctrlKey&&!u.altKey){q.currentChoice=null;setTimeout(function(){var w=q.searchInput.getValue();if(q.options.setBorderColor&&(!q.options.acceptEmpty||w!=="")){q.container.addClassName("SW_unvalid")}else{q.container.removeClassName("SW_unvalid")}});if(u.which!==32){q._removeAllSelections()}if(q._timerLastKey!=null){clearTimeout(q._timerLastKey)}q._timerLastKey=setTimeout(function(){q._timeEnd()},200);setTimeout(function(){q.dispatchEvent("onUnvalid")},0)}}}}},onClick:function(){q.dispatchEvent("onUserChoice")}}});if(q.searchInput.elements&&q.searchInput.elements.input){q.searchInput.elements.input.addEvent("mouseup",function(){setTimeout(function(){var s=q.getCurrentValue();if(s===""){q.currentOwner=null;q.dispatchEvent("onUnvalid")}},100)});q.searchInput.elements.input.addEvent("drop",function(s){s.preventDefault()});q.searchInput.elements.input.addEvent("paste",function(s){if(q.getCurrentValue()!==s.clipboardData.getData("text/plain")){q.dispatchEvent("onUnvalid")}})}n=new d({attributes:{title:e.get("AR_SearchButton")},value:"",className:"default AR_SearchButton",icon:"search",name:"SW_SearchInputButton"});n.getContent().setAttribute("data-rec-id","dataRecSearchInputButton");n.addEvents({onClick:function(){q.searchInput.setFocus(true);q.closeDialog();q.currentOwner=null;q.dispatchEvent("onUserChoice")}});var m=this.options.className?" SWD_"+this.options.className:"";q.filterContainer=UWA.createElement("div",{"class":"searchComponent_filter dropdown-menu dropdown dropup"+m,"data-rec-id":"datarecfilterContainer",html:""});this._handleStopPropagation=function(s){s.stopPropagation()};this._handleCloseDialog=function(s){if(!q.mouseIsInBlock){q.closeDialog()}};var r=q.searchInput.elements.input;r.addEvents({mousedown:q._handleStopPropagation,touchstart:q._handleStopPropagation});document.addEventListener("mousedown",q._handleCloseDialog,false);document.addEventListener("touchstart",q._handleCloseDialog,false);q.filterContainer.addEvents({mousedown:q._handleStopPropagation,touchstart:q._handleStopPropagation});q.warningArea=UWA.createElement("div",{"class":"SW_warningArea"}).inject(q.filterContainer).hide();q.warningArea.addEventListener("click",q.warningArea.hide);q.filterAreaMaster=UWA.createElement("div",{name:"masterFilterArea","class":"masterFilterArea","data-rec-id":"datarecfilterAreaMaster",html:""}).inject(q.filterContainer);q.tempFilterArea=UWA.createElement("div",{"class":"tempFilterAreaContent  dropdown-menu dropdown dropup"}).inject(p);q.filterArea=UWA.createElement("div",{name:"filterArea","class":"filterArea","data-rec-id":"datarecfilterArea",html:""}).inject(q.filterAreaMaster);q.filterAreaContent=UWA.createElement("div",{"class":"filterAreaContent atLeastOneIcon","data-rec-id":"datarecfilterAreaContent",});q.filterAreaContent.inject(q.filterArea);q.mainScrollerSearch=new b({element:q.filterArea}).inject(q.filterAreaMaster);var o=q.mainScrollerSearch.elements.content;o.setAttribute("data-rec-id","dataRecmainScrollerSearch");q.loadingGif=new c({className:"SW_filterSpinner",visible:true});q.loadingGif.inject(q.filterContainer);q.filterContainer.hide();q.searchInput.inject(q.inputDiv);q.inputDiv.setStyle("width","100%");if(n!=null){var l=UWA.createElement("span",{"class":"input-group-btn"});n.inject(l);l.inject(q.inputDiv)}q.filterContainer.inject(p);q.saveIDUser.inject(q.searchDiv);q.labelArea.inject(q.searchDiv);q.inputDiv.inject(q.searchDiv);q.searchDiv.inject(q.container);this._actionOnMoveOrResize=function(){if(q._dialogIsOpened()){q.openDialog()}};j.addWidgetResizeEvent(q._actionOnMoveOrResize)},actionOnMove:function(){this.closeDialog()},selectNextOrPreviousResult:function(s){var o=this.filterAreaContent.getElement("."+i);var t=this._elementIsButton(o);var n=null;if(!o){n=this.filterAreaContent.getElement(".SW_LiData")}else{if(t&&s!=="next"){var p=o.previousSibling;var l=p.getElements(".SW_LiData:not(.SW_hiddenLine)");if(l&&l.length>0){n=l[l.length-1]}}if(!n){n=!t?s==="next"?o.nextSibling:o.previousSibling:null}if(!n||n.getStyle("display")==="none"){var q=o.getParent(".SW_DivPeople");if(!t&&s==="next"){n=q.getElement(".SW_ButtonMoreContainer");n=n&&n.getStyle("display")!=="none"?n:null}if(!n&&q){var r=s==="next"?q.nextSibling:q.previousSibling;if(r){n=null;if(s==="next"){n=r.getElement(".SW_LiData")}else{n=r.getElement(".SW_ButtonMoreContainer");n=n&&n.getStyle("display")!=="none"?n:null;if(null===n){var l=r.getElements(".SW_LiData:not(.SW_hiddenLine)");if(l&&l.length>0){n=l[l.length-1]}}}}}}}if(n&&n.getStyle("display")!=="none"){n.addClassName(i);if(o){o.removeClassName(i)}var m=this._getElementPositionInScroller(n);if(m!=null){this.mainScrollerSearch.scrollTo(0,m-25)}}},_removeAllSelections:function(){var l=this.filterAreaContent.getElements("."+i);l.forEach(function(m){m.removeClassName(i)})},setData:function(l){var n=this;var m=this.getCurrentChoiceId();l.forEach(function(s){var o=s.getClass();var r=UWA.createElement("div",{"class":"SW_DivPeople "+o,"data-rec-id":"datarecdivPeople",html:{tag:"div",text:s.getTitle(),"class":"SW_TitleSection"}}).inject(n.filterAreaContent);if(o!=""){o+=o+"List"}var q=UWA.createElement("ul",{"class":"filterSSArea dropdown-menu-wrap "+o,"data-rec-id":"datarecfilterSSArea",html:""}).inject(r);var p=false;s.getListItems().forEach(function(x,z){if(z==n.options.MaxNumber){var w=UWA.createElement("div",{"class":"SW_ButtonMoreContainer fonticon fonticon-down-open",events:{click:function(F){n.displayMore(F,o)}}}).inject(r);new UWA.createElement("a",{"class":"SW_MoreButton","data-rec-id":"datarecMoreButton",html:e.get("MoreButton")}).inject(w);p=true}var y=x.getId();var A=x.getTitle();var u=n.getListOfSearchingWord();var t=u.listWord;var v=t.length;for(var B=0;B<v;B++){var E=new RegExp("("+t[B]+")","ig");A=A.replace(E,"<b>$1</b>")}if(A!=""){var D=[];if(m===y){D.push({tag:"span","class":"SW_liSelected"})}D.push(x.getIcon());D.push({tag:"span","data-rec-id":"RecdataUser","class":"userName",html:A,});var C=UWA.createElement("li",{"class":"SW_LiData item ","data-rec-id":"RecSearchLiData"+z,IDOwner:y,title:x.getTitle(),html:D});C;if(p==true){n._hideLine(C)}C.inject(q);C.addEvent("click",function(F){n._setInput(F)})}})});this.selectNextOrPreviousResult("next")},_getElementPositionInScroller:function(n){var o=null;if(n){var m=n.getOffsets();var l=this.filterAreaContent.getOffsets();o=m.y-l.y}return o},getCurrentValue:function(){return this.searchInput.getValue()},getListOfSearchingWord:function(){var m=this;var n=m.searchInput.getValue();n=n.trim();n=n.replace(/\s+/g," ");n=n.replace(/\*/g,".*");var o=[];if(n!=""){o=n.split(" ")}var l=o.length;for(var p=l-1;p>=0;p--){if(o[p].search(/^<?([/b]|\/b)>?$/i)>=0){o.splice(p,1)}}return{valueSearched:n,listWord:o}},_hideLine:function(l){l.addClassName("SW_hiddenLine")},_showLine:function(l){l.removeClassName("SW_hiddenLine")},displayMore:function(l,m){var o=this;var q=l.target.getClosest(".SW_DivPeople").getElements("li");var n=0;var p=true;q.every(function(s,r){if(s.getStyle("display")=="none"){o._showLine(s);n++}if(n>=o.options.MaxNumber){if(r!=q.length-1){p=false}return false}return true});if(p==true){l.target.getClosest(".SW_ButtonMoreContainer").hide()}this.updateScroller()},getCurrentChoiceId:function(){return this.currentChoice},_setInput:function(l){var m=l.currentTarget.getClosest(".SW_LiData");this.__setInput(m)},__setInput:function(m){this._removeAllSelections();if(m){var n=m.getElement(".userName").getText();var l=m.getAttribute("IDOwner");this.currentChoice=l;this.setDisplayValue(n);this.closeDialog();if(this.options.setBorderColor){this.container.removeClassName("SW_unvalid")}this.dispatchEvent("onValid")}},setDisplayValue:function(l){this.searchInput.setValue(l)},getDisplayValue:function(){this.searchInput.getValue()},_dialogIsOpened:function(){return this.filterContainer?this.filterContainer.getStyle("display")!=="none":false},openDialog:function(){var l=this;var m=this.searchDiv.getSize().height;var n=this._getMaxSize();if(this.options.position==="auto"){this._currentPosition="top";if(n!=null){if(n.top>n.bottom){this._currentPosition="top"}else{this._currentPosition="bottom"}}}this.filterContainer.setStyle("left",n.left+"px");if(this._currentPosition==="top"){this.filterContainer.setStyle("bottom",(n.bottom+m)+"px");this.filterContainer.setStyle("top","auto")}else{this.filterContainer.setStyle("top",(n.top+m)+"px");this.filterContainer.setStyle("bottom","auto")}this.filterContainer.show();this.filterArea.hide();this.warningArea.hide();if(this._currentNotif){this.filterContainer.addClassName("SW_FilterWithNotif");this.warningArea.setText(this._currentNotif.message);this.warningArea.show()}else{this.filterContainer.removeClassName("SW_FilterWithNotif");this.filterArea.show()}this.mouseIsInBlock=false;this.updateScroller()},destroy:function(){var l=this;var m=l.searchInput.elements.input;m.removeEvents({mousedown:l._handleStopPropagation,touchstart:l._handleStopPropagation});if(this.parentBody){this.parentBody.removeEvents({mousedown:l._handleCloseDialog,touchstart:l._handleCloseDialog})}l.filterContainer.removeEvents({mousedown:l._handleStopPropagation,touchstart:l._handleStopPropagation});this.tempFilterArea.destroy();this.filterContainer.destroy();j.removeWidgetResizeEvent(this._actionOnMoveOrResize);this._parent()},updateScroller:function(){var r=this;var o=h.clone(r.filterAreaContent);r.tempFilterArea.empty();r.tempFilterArea.appendChild(o);var s={x:0,y:0};var u=this.searchDiv.getSize().width;var x=r.tempFilterArea.getSize();var y=null;var n=this._getMaxSize();var p=x.width;var w=this.parentBody.getSize();var m=n.right>0?w.width-n.right:w.width;var l=r.filterAreaMaster.getDimensions();var t=l.outerWidth-l.innerWidth;var v=m-n.left;if(n){r.filterContainer.setStyle("max-width",v+"px");if(this._currentPosition==="top"){y=n.top}else{y=n.bottom}p=x.width+t>v-t?v-t:x.width+t}if((r.options.MaxSize!=""&&r.options.MaxSize<y)||y==null){y=r.options.MaxSize}var z=x.height;var q=p;if(x.height>y||x.width>v){z=x.height>y?y:x.height}r.filterArea.setStyle("height",z)},showLoadingGif:function(){this.openDialog(false);this.filterAreaMaster.hide();this.loadingGif.show()},hideLoadingGif:function(){this.filterAreaMaster.show();this.loadingGif.hide()},clearAllResult:function(){this.filterAreaContent.empty()},isResultEmpty:function(){return this.filterAreaContent.getHTML()===""},ClearDialog:function(){this.clearAllResult();this.filterContainer.hide()},closeDialog:function(){var l=this;this._removeAllSelections();this.filterArea.hide();this.filterContainer.hide()},resetError:function(){this._currentNotif=null},raiseError:function(l){if(l.eventID==="warning"){this._currentNotif=l;this.openDialog()}else{this.dispatchEvent("onError",l)}},clearTextArea:function(){this.ClearDialog();this.clearInput()},clearInput:function(){this.searchInput.setValue("");this.currentChoice=null;this.dispatchEvent("onUnvalid")},_getMaxSize:function(){var n=null;var m=this.searchDiv.getBoundingClientRect();var l=this.parentBody.getBoundingClientRect();n={};n.bottom=l.height+l.top-m.bottom;n.right=l.width+l.left-m.right;n.top=m.top;n.left=m.left;return n}});return f});define("DS/SearchWidget/models/SW_GroupModel",["UWA/Controls/Abstract"],function(b){var a=b.extend({init:function(d){this.groupTitle="";this.groupClass="";this.groupItems=[];this.isSW_GroupModel=true;for(var c in d){this[c]=d[c]}},getTitle:function(){return this.groupTitle},getClass:function(){return this.groupClass},getListItems:function(){return this.groupItems},setTitle:function(c){this.groupTitle=c},setClass:function(c){this.groupClass=c},setListItems:function(c){this.groupItems=c}});return a});define("DS/SearchWidget/controllers/SW_Base_Controller",["UWA/Controls/Abstract","UWA/Json","DS/SearchWidget/SearchWidgetConstant","DS/WidgetServices/WidgetServices","DS/SearchWidget/models/SW_GroupModel","DS/SearchWidget/models/SW_ItemModel","DS/SearchWidget/componentUI/SearchWidgetUI","i18n!DS/SearchWidget/assets/nls/langSW"],function(f,h,g,a,d,i,b,c){var e=f.extend({defaultOptions:{serverName:"",serverUri:"",showEmptyCategory:true,ForbiddenChar:'"#$@%*,?\\<>[]|:',urlService:"",wintop:false,webParams:null,dropdown:false},searchWidgetUI:null,init:function(j){var l=this;if(j.type===undefined){j.type=g.TYPE_FULL}this._parent(j);var k=j.events;if(k==null){k={}}k.onUserChoice=function(){l.filter()};j.events=k;this.searchWidgetUI=this.container=new b(j);this.searchWidgetUI.hideLoadingGif();this.folder="SearchWidget";this._initVariables()},switchDropdownMode:function(j){this.options.dropdown=j===true},_showDropdown:function(){return this.options.dropdown},_initVariables:function(){this._selectedItems=[];this.requestObject=null;this.currentSearch=null;this.lastSearch="";this.initSearch="";this.listLastSearch={};this.listInitSearch={};this.listOwner=[];this.repeatSearch=0},destroy:function(){if(this.searchWidgetUI){this.searchWidgetUI.destroy()}this._parent()},actionOnMove:function(){if(this.searchWidgetUI){this.searchWidgetUI.actionOnMove()}},actionOnScroll:function(){this.actionOnMove()},clearTextArea:function(){this.searchWidgetUI.clearTextArea()},clearInput:function(){this.searchWidgetUI.clearInput()},sortResponse:function(k){var n=this;var j=k.owner;var m={person:[],securityContext:[],collabSpace:[],organization:[],userGrp:[]};var o=j.length;if(j&&o!=0){for(var l=0;l<o;l++){if((n.options.type==g.TYPE_FULL||n.options.type==g.TYPE_PERSON)&&j[l].hasOwnProperty("person")){m.person.push(j[l])}else{if(n.options.type==g.TYPE_FULL&&j[l].hasOwnProperty("collabSpace")&&j[l].hasOwnProperty("organization")){m.securityContext.push(j[l])}else{if((n.options.type==g.TYPE_FULL||n.options.type==g.TYPE_PROJECT)&&j[l].hasOwnProperty("collabSpace")){m.collabSpace.push(j[l])}else{if((n.options.type==g.TYPE_FULL||n.options.type==g.TYPE_ORGANIZATION)&&j[l].hasOwnProperty("organization")){m.organization.push(j[l])}else{if(n.options.exttype==g.EXTTYPE_USERGRP&&j[l].hasOwnProperty("userGrp")){m.userGrp.push(j[l])}}}}}}}return m},getOwnerProperties:function(k){var l="";var j="";if(k.hasOwnProperty("person")){l=k.person.personID;j=k.person.personFullName}else{if(k.hasOwnProperty("collabSpace")||k.hasOwnProperty("organization")){if(k.hasOwnProperty("collabSpace")&&k.hasOwnProperty("organization")){l=k.collabSpace.collabSpaceID+k.organization.orgID;j=k.organization.orgID+" / "+k.collabSpace.collabSpaceID}else{if(k.hasOwnProperty("collabSpace")){l=k.collabSpace.collabSpaceID;j=k.collabSpace.collabSpaceID}else{if(k.hasOwnProperty("organization")){l=k.organization.orgID;j=k.organization.orgID}}}}else{if(k.hasOwnProperty("userGrp")){l=k.userGrp.id;j=k.userGrp.label}}}var m={IDOwner:l,Name:j};return m},JSFilterPerson:function(m,k){var l=[];var n=true;var j=true;m.forEach(function(o){n=true;j=true;var q=o.person.personID.toLowerCase();var p=o.person.personFullName.toLowerCase();k.every(function(r){r=r.toLowerCase();if(n&&q.indexOf(r)<0){n=false}if(j&&p.indexOf(r)<0){j=false}if(n==false&&j==false){return false}return true});if(n||j){l.push(o)}});return l},JSFilterSC:function(j,k){var m=[];var l=true;j.forEach(function(n){l=true;var p="";var o="";if(n.hasOwnProperty("collabSpace")){p=n.collabSpace.collabSpaceID.toLowerCase()}if(n.hasOwnProperty("organization")){o=n.organization.orgID.toLowerCase()}k.every(function(q){q=q.toLowerCase();if(p.indexOf(q)<0&&o.indexOf(q)<0){l=false;return false}return true});if(l){m.push(n)}});return m},JSFilterUserGrp:function(m,j){var l=[];var k=true;m.forEach(function(n){k=true;var o="";if(n.hasOwnProperty("userGrp")){o=n.userGrp.label.toLowerCase()}j.every(function(p){p=p.toLowerCase();if(o.indexOf(p)<0){k=false}return k});if(k){l.push(n)}});return l},getDisplayedResult:function(){return this.searchWidgetUI.getCurrentValue()},setValue:function(j){this.searchWidgetUI.setDisplayValue(j)},getValue:function(){return this.searchWidgetUI.getDisplayValue()},updateFilter:function(o,F){var s=this;var H=false;this.listOwner=[];this.searchWidgetUI.clearAllResult();var v="";var t=[];if(this.searchWidgetUI!=null){var w=this.searchWidgetUI.getListOfSearchingWord();var v=w.valueSearched;var t=w.listWord}this.lastSearch=v;var x=UWA.clone(o);this.listLastSearch=x;if(F==true){this.initSearch=v;this.listInitSearch=UWA.clone(o)}else{if(this.listLastSearch.person){this.listLastSearch.person=this.JSFilterPerson(this.listLastSearch.person,t)}if(this.listLastSearch.collabSpace){this.listLastSearch.collabSpace=this.JSFilterSC(this.listLastSearch.collabSpace,t)}if(this.listLastSearch.organization){this.listLastSearch.organization=this.JSFilterSC(this.listLastSearch.organization,t)}if(this.listLastSearch.securityContext){this.listLastSearch.securityContext=this.JSFilterSC(this.listLastSearch.securityContext,t)}if(this.listLastSearch.userGrp){this.listLastSearch.userGrp=this.JSFilterUserGrp(this.listLastSearch.userGrp,t)}}var r=[];var j=false;for(var C=0;C<4;C++){var G=null;var k=[];var I="";var l="";var A="";if(this.options.type&&C==0){G=a.getImageUser(1,"small");k=x.person;if(this.options.showEmptyCategory==false&&k.length==0){continue}I=c.get("peopleTile");A="SW_DivPerson"}else{if(this.options.type&&C==1){G=a.getImageUser(2,"small");k=x.collabSpace;if(k.length==0){k=x.securityContext}else{j=true}if(this.options.showEmptyCategory==false&&k.length==0){continue}I=c.get("CSTitle");A="SW_DivCS"}else{if(this.options.type&&C==2){G=a.getImageUser(2,"small");k=x.organization;if(k.length==0&&(j==false||this.options.showEmptyCategory==false)){continue}I=c.get("OrgTitle");A="SW_DivOrg"}else{if(this.options.exttype&&C==3){G=a.getImageUser(3,"small");k=x.userGrp;if(k.length==0&&this.options.showEmptyCategory==false){continue}I=c.get("UserGrpTitle");A="SW_DivUserGrp"}else{continue}}}}var y=[];var z=k.length;var u=false;if(k&&z!=0){H=true;u=false;var n="";for(var q=0;q<z;q++){var E=this.getOwnerProperties(k[q]);var B=E.IDOwner;var n=E.Name;if(n!=""){var p=new i();p.setTitle(n);p.setId(B);p.setIcon(G);y.push(p);s.listOwner.push({owner:k[q],IDOwner:B,category:C})}}}var m=new d();m.setTitle(I);m.setClass(A);m.setListItems(y);r.push(m)}this.searchWidgetUI.setData(r);if(H){this.searchWidgetUI.resetError();this.searchWidgetUI.openDialog()}else{var D={message:c.get("WarningNotFound"),code:"WARN",customClass:"SW_WarningNotFound",type:"warning",eventID:"warning"};this.searchWidgetUI.raiseError(D)}},getOwnerElementFromId:function(k){var j=null;this.listOwner.every(function(l){if(l.IDOwner==k){j=l;return false}return true});return j},getNewOwner:function(){var j={};var k="-";var l=this.searchWidgetUI.getCurrentChoiceId();var m=this.getOwnerElementFromId(l);if(m!=null){j=m.owner;j.comment=k}return j},_onComplete:function(k){this.requestObject=null;var j=this;this.currentSearch=null;this.repeatSearch=0;this.searchWidgetUI.hideLoadingGif();this.searchWidgetUI.ClearDialog();if(k.success==true){var l=j.sortResponse(k);j.updateFilter(l,!this._showDropdown())}else{if(k.hasOwnProperty("error")){this.searchWidgetUI.raiseError(k.error)}}},_onTimeout:function(){this.requestObject=null;var k=this;this.currentSearch=null;this.searchWidgetUI.hideLoadingGif();var j={message:c.get("ErrorTimeOut"),code:"TO"};this.searchWidgetUI.raiseError(j);this.searchWidgetUI.ClearDialog()},_onFailure:function(j,k,m){this.requestObject=null;var l=this;this.currentSearch=null;this.searchWidgetUI.hideLoadingGif();var n={};if(k!=null&&k.hasOwnProperty("error")){n=k.error}else{n={message:c.get("UnknownError"),code:"ERROR"}}this.searchWidgetUI.raiseError(n);this.searchWidgetUI.ClearDialog()},_onCancel:function(){this.requestObject=null;this.currentSearch=null;this.searchWidgetUI.hideLoadingGif();this.searchWidgetUI.ClearDialog()},});return e});define("DS/SearchWidget/controllers/SW_BasePnO_Controller",["DS/SearchWidget/controllers/SW_Base_Controller","DS/WAFData/WAFData","UWA/Json","DS/SearchWidget/SearchWidgetConstant","DS/WidgetServices/securityContextServices/SecurityContextServices","DS/WidgetServices/WidgetServices","DS/WidgetServices/MultipleAsynchronousRequests","i18n!DS/SearchWidget/assets/nls/langSW"],function(a,f,j,g,b,i,e,c){var h=0;var d=a.extend({getData:function(){},canBeLaunched:function(){return true},getWebservicesParam:function(){},setSelectedItemList:function(k){this._selectedItems=k;this.lastSearch="";this.initSearch="";this.listLastSearch={};this.listInitSearch={};h=0},_ajaxCall:function(A){var r=this;var p=A.serverUrl;var w=A.query;var y=A.securityContext;var u=this.getWebservicesParam();var n=this.options.webParams;var v=n&&typeof n.getQueryParams==="function"?n.getQueryParams():{};v.pattern=w;if(m){v.tenant=m}var m=i.getTenantID();var l=p+u.url;var z="?";for(var x in v){l+=z+x+"="+v[x];z="&"}var k=u.method;var o={Accept:"application/json","Content-Type":"application/json"};if(y){o.SecurityContext=encodeURIComponent(y.SecurityContext)}var q=n&&typeof n.getData==="function"?n.getData():{};q.businessObject=r._selectedItems;var s=k=="GET"?"":j.encode(q);var t="";if(r.options.wintop==false){t="passport"}r.searchWidgetUI.showLoadingGif();o["Accept-Language"]=i.getLanguage();r.requestObject=f.authenticatedRequest(l,{type:"json",method:k,proxy:t,data:s,headers:o,timeout:3600000,onComplete:function(B){A.onComplete(B)},onFailure:function(B,C,D){r._onFailure(B,C,D)},onCancel:function(){r._onCancel()},onTimeout:function(B){r._onTimeout()}})},_spaceSearch:function(k){var l=this;i.get3DSpaceUrlAsync({wintop:l.options.wintop,serverUrl:l.options.serverUrl,onComplete:function(m){b.getInstance().getSecurityContext({onSuccess:function(n){k.securityContext=n;k.serverUrl=m;l._ajaxCall(k)},onFailure:function(n){l._ajaxCall(k)}})}})},_fedSearch:function(k){var l=this;i.get3DSearchUrlAsync({wintop:l.options.wintop,serverUrl:l.options.serverUrl,onComplete:function(p){var m=p+"/search";var n=i.getTenantID();if(n){m+="?tenant="+n}var o=i.getLanguage();var s={};s.select_predicate=["groupuri","ds6w:label"];s.locale=o;s.nresults=25;s.tenant=n;s.query='[ds6w:type]:"Group" AND [ds6w:label]:('+k.query+")";s.start=0;var q={Accept:"application/json","content-type":"application/json","Accept-Language":o};var u=l.options.wintop==false?"passport":"";var v="searchUserGrp";var r=window.top.dsUserLogin?window.top.dsUserLogin:"unknown";var t=v+"-"+r+"-"+(new Date()).getTime();s.label=t;l.requestObject=f.authenticatedRequest(m,{type:"json",method:"POST",proxy:u,data:UWA.Json.encode(s),headers:q,onComplete:function(w){k.onComplete(w)},onFailure:function(w,x,y){l._onFailure(w,x,y)},onCancel:function(){l._onCancel()},onTimeout:function(w){l._onTimeout()}})}})},filter:function(){var p=this;var t=this.searchWidgetUI.getCurrentValue();var l=true;var m=p.options.ForbiddenChar.length;for(var o=0;o<m;o++){var q=p.options.ForbiddenChar[o];if(t.indexOf(q)!=-1){l=false;var r={code:"",message:c.get("This character is forbidden : {0}").format(q)};this.searchWidgetUI.raiseError(r);break}}t=t.trim();var u=t.replace(/\s+/g," ");if(!this._showDropdown()&&u.length<3){l=false}t=u.replace(/\s/g,"* *");t="*"+t+"*";var v=this.currentSearch!==null?u.toLowerCase()===this.currentSearch.toLowerCase():false;var s=u.toLowerCase()===this.lastSearch.toLowerCase()&&(this.lastSearch!==""||!this._showDropdown());if(this.requestObject!=null){if(!s&&!v){this.requestObject.cancel()}else{this.searchWidgetUI.openDialog();return}}if((!this._showDropdown()&&u.length<=0)||!this.canBeLaunched()){return}if(t&&l){if(v){if(this._showDropdown()){this.searchWidgetUI.openDialog()}}else{if(h<3&&s&&!this.searchWidgetUI.isResultEmpty()){h++;this.searchWidgetUI.openDialog()}else{if(!s&&this.lastSearch.length>0&&u.indexOf(this.lastSearch)>=0){h=0;p.updateFilter(this.listLastSearch,false);p.currentSearch=u}else{if(!s&&this.initSearch.length>0&&u.indexOf(this.initSearch)>=0){h=0;p.updateFilter(this.listInitSearch,false);p.currentSearch=u}else{if(this.getData()){h=0;p.updateFilter(this.getData(),false);p.currentSearch=u}else{h=0;var n=null;var k=[];n=new e(k,function(){p.currentSearch=u;var w=this.getAnswer("A");var x=null;if(w){x=UWA.clone(w)}else{x={success:true}}x.owner=x.owner?x.owner:[];var y=this.getAnswer("B");if(y&&y.results){y.results.forEach(function(A){if(A.attributes){var B=null;var z=null;A.attributes.every(function(C){if(C.name==="ds6w:label"){z=C.value}if(C.name==="groupuri"){B=C.value}return B===null||z===null});if(B===null){A.attributes.every(function(C){if(C.name==="resourceid"){B=C.value}return(B===null)})}if(B!==null||z!==null){x.owner.push({userGrp:{id:B,label:z}})}}})}p._onComplete(x)});if(this.options.type){n.addRequest("A")}if(this.options.exttype){n.addRequest("B")}if(this.options.type){this._spaceSearch({query:t,onComplete:function(w){n.setAnswer("A",w)}})}if(this.options.exttype){this._fedSearch({query:t,onComplete:function(w){n.setAnswer("B",w)}})}}}}}}}}});return d});define("DS/SearchWidget/controllers/SW_Restricted_Controller",["DS/SearchWidget/controllers/SW_BasePnO_Controller","DS/WAFData/WAFData","UWA/Json","DS/WidgetServices/securityContextServices/SecurityContextServices","DS/WidgetServices/WidgetServices"],function(d,a,c,f,e){var b=d.extend({requestObject:null,defaultOptions:{methodType:"POST"},init:function(g){this._parent(g)},getWebservicesParam:function(){var g=this.options.urlService;var i=this.options.methodType;var h=g.indexOf("/");if(!g){if(h!==0){g="/resources/pno/ownership/owner"}}return{method:i,url:g}},canBeLaunched:function(){return this._selectedItems.length>0}});return b});define("DS/SearchWidget/controllers/SW_FullPos_Controller",["DS/SearchWidget/controllers/SW_BasePnO_Controller","DS/WAFData/WAFData","UWA/Json","DS/SearchWidget/SearchWidgetConstant","DS/WidgetServices/securityContextServices/SecurityContextServices","DS/WidgetServices/WidgetServices"],function(e,b,d,a,g,f){var c=e.extend({requestObject:null,defaultOptions:{type:a.TYPE_FULL,data:null,methodType:"GET"},init:function(h){if(h.data){h.data=this._formatData(h.data)}this._parent(h)},setData:function(h){this._initVariables();this.options.data=this._formatData(h)},getData:function(){return this.options.data},_formatData:function(l){var i=null;if(l){var i={person:[],securityContext:[],collabSpace:[],organization:[]};var k={persons:"person",collabSpaces:"collabSpace",organizations:"organization",securityContexts:"securityContext"};for(var j in k){if(l[j]){var h=k[j];l[j].forEach(function(m){var n={};n[h]=m;i[h].push(n)})}}}return i},getWebservicesParam:function(){var h=this.options.urlService;var j=this.options.methodType;var i=h.indexOf("/");if(!h){if(i!==0){if(this.options.type==a.TYPE_PERSON){j="POST";h="/resources/pno/ownership/owner"}else{h="/resources/pno/ownership/transfertarget/"+this.options.type}}}return{method:j,url:h}}});return c});define("DS/SearchWidget/SearchWidget",["UWA/Controls/Abstract","DS/SearchWidget/controllers/SW_FullPos_Controller","DS/SearchWidget/controllers/SW_Restricted_Controller","css!DS/SearchWidget/SearchWidget.css","i18n!DS/SearchWidget/assets/nls/langSW"],function(d,b,a){var c={FULL:"FullTriplet",RESTRICTED:"Restrict",getSearchWidget:function(f,e){if(f==this.FULL){return new b(e)}else{if(f==this.RESTRICTED){return new a(e)}}}};return c});