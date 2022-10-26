define("DS/XCTInfToolbar/XCTInfToolbar",[],function(){return{}});define("DS/XCTInfToolbar/XCTToolbar",["UWA/Core","UWA/Class","DS/UIKIT/Tooltip","DS/WebappsUtils/WebappsUtils","DS/CoreEvents/Events","DS/Selection/HSOManager","css!DS/XCTInfToolbar/XCTInfToolbar.css"],function(f,a,j,d,e,c){var b="xct-toolbar";var h="xct-toolbar-item";var l="xct-toolbar-item-list";var k="xct-toolbar-separator";var i="xct-toolbar-item-active";var m="xct-toolbar-panel-wrapper";var g=a.extend({CLOSE_EVENT:"XCT:Toolbar:panel:closed",init:function(n){this.initToolbar(n);this._toolbarPanelWrapper=f.createElement("div",{Class:m}).inject(this._toolbarNode);this.initToolbarEvents()},initToolbar:function(o){this._currentItem=undefined;this._toolbarItems=[];var n=document.getElementById("canvas-div");if(o&&o.parent){n=o.parent}this._toolbarNode=f.createElement("div",{Class:b}).inject(n);this._listNode=f.createElement("ul",{Class:l}).inject(this._toolbarNode)},initToolbarEvents:function(){this.token=e.subscribe({event:this.CLOSE_EVENT},function(){this._closeActivePanel()}.bind(this));c.onAdd(this._handleSceneNodeSelected.bind(this))},createToolTip:function(p,o,n){return new j({target:p,body:o,position:n})},addToolbarItem:function(n){var q=n.classList||[];q.push([h]);var p=this._createToolbarButton(n.icon,q,n.tooltip);if(n.tooltip){this.createToolTip(p,n.tooltip,"right")}this._listNode.appendChild(p);var o={node:p,panel:n.panel,showPanelOnSceneItemSelect:n.showPanelOnSceneItemSelect||false,nodeTypes:n.nodeTypes};this._toolbarItems.push(o);p.onclick=this._handleSelectToolbarItem.bind(this,o,n.onClickCallback);return p},addToolbarSeparator:function(){f.createElement("li",{Class:k}).inject(this._listNode)},getToolbarNode:function(){return this._toolbarNode},getToolbarPanelWrapperNode:function(){return this._toolbarPanelWrapper},getCurrentItem:function(){return this._currentItem},addHighlight:function(n){n.classList.add(i)},removeHighlight:function(n){n.classList.remove(i)},_createToolbarButton:function(n,p){var o=f.createElement("li");if(n){o.style.backgroundImage="url('"+d.getWebappsBaseUrl()+n+"')"}p.forEach(function(q){o.classList.add(q)});return o},_clearHighlights:function(){this._toolbarItems.forEach(function(n){this.removeHighlight(n.node)}.bind(this))},_handleSelectToolbarItem:function(p,n){var o=this._currentItem;this._closeActivePanel();if(!o||p.node!==o.node){if(p.panel){p.panel.show()}this.addHighlight(p.node);this._currentItem=p}if(n){n(this._currentItem)}},_closeActivePanel:function(){if(this._currentItem){if(this._currentItem.panel){this._currentItem.panel.close()}this._currentItem=undefined;this._clearHighlights()}},_handleSceneNodeSelected:function(q){if(!this._currentItem||!this._currentItem.showPanelOnSceneItemSelect){return}var p=q.pathElement.getLastElement().getNodeType();if(p){var n=this._toolbarItems.filter(function(r){return r.nodeTypes&&(r.nodeTypes.indexOf(p)!==-1)});if(n.length){var o=n[0];if(o.panel.PANELTYPE!==this._currentItem.panel.PANELTYPE){this._closeActivePanel();this._handleSelectToolbarItem(o)}}}}});return g});define("DS/XCTInfToolbar/XCTToolbarBasePanel",["UWA/Core","UWA/Class","DS/XCTInfToolbar/XCTToolbar","DS/WebappsUtils/WebappsUtils","DS/CoreEvents/Events"],function(h,k,f,c,e){var d="xct-panel-header";var j="xct-panel-content";var i="xct-panel-actions";var a="xct-toolbar-panel-title";var b="xct-panel-close";var g="xct-toolbar-open";return k.extend({CLOSE_EVENT:f.prototype.CLOSE_EVENT,init:function(l){if(l){this.toolbar=l.toolbar;this.toolbarPanelWrapper=l.toolbarPanelWrapper;this.frmWindow=l.frmWindow}},show:function(m,l){this.panel=h.createElement("div",{Class:m}).inject(this.toolbarPanelWrapper);this.panelHeader=h.createElement("div",{Class:d}).inject(this.panel);if(!l){this.panelActions=h.createElement("div",{Class:i}).inject(this.panel)}this.panelContent=h.createElement("div",{Class:j}).inject(this.panel);this._slideIn()},close:function(){this._slideOut();this._cleanPanel(this.toolbarPanelWrapper)},_cleanPanel:function(l){l.getChildren().forEach(function(m){l.removeChild(m)})},_slideIn:function(){this.toolbarPanelWrapper.classList.add(g)},_slideOut:function(){this.toolbarPanelWrapper.classList.remove(g)},showHeader:function(m){var n=h.createElement("div",{Class:a,html:m});var l=h.createElement("div",{Class:b,styles:{backgroundImage:"url('"+c.getWebappsBaseUrl()+"XCTIIS/assets/icons/20/closePanel.png')"}}).inject(n);l.onclick=function(){e.publish({event:this.CLOSE_EVENT})}.bind(this);this.panelHeader.appendChild(n)}})});