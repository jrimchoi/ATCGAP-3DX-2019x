define("DS/XCTInfActionButton/XCTInfActionButton",["UWA/Core","UWA/Class","DS/WebappsUtils/WebappsUtils","DS/UIKIT/Tooltip"],function(g,e,d,b){var f="mac-action-button";var a="mac-action-button-active";var c=e.extend({init:function(h){this.options=h;var i=h.elementType||"li";this.button=new g.Element(i,{Class:f});if(h.classList){h.classList.forEach(function(j){this.button.classList.add(j)},this)}if(h.icon){this.setIcon(h.icon)}if(h.label){this.label=new g.Element("span",{html:h.label}).inject(this.button)}if(h.tooltip){this._createToolTip(this.button,h.tooltip,h.tooltipPosition||"right")}this.button.onclick=this.handleClick.bind(this);if(this.options.toggled){this.toggleOn()}else{this.toggleOff()}},_createToolTip:function(j,i,h){return new b({target:j,body:i,position:h})},inject:function(h){this.button.inject(h)},remove:function(){this.button.remove()},setIcon:function(h){this.button.style.backgroundImage="url('"+d.getWebappsBaseUrl()+h+"')"},toggleOn:function(){this.toggled=true;this.button.classList.add(a);if(this.options.iconOn){this.setIcon(this.options.iconOn)}},toggleOff:function(){this.toggled=false;this.button.classList.remove(a);if(this.options.iconOff){this.setIcon(this.options.iconOff)}},swapIcons:function(){if(this.toggled){this.toggleOff()}else{this.toggleOn()}},handleClick:function(h){if(this.disabled){return}this.swapIcons();if(this.options.clickCommand){this.executeCommand(this.options.clickCommand)}if(this.options.onClick){this.options.onClick(this.toggled,h)}}});return c});