define("DS/ENOGantt/View/FindField",["DS/ENOGantt/View/Refinement"],function(a){return function b(){var e=new a();var d=null;var c;_find=function(v,t){var g=this.getValue();var q=new RegExp(Ext.String.escapeRegex(g),"i");var m=App.Gantt.gantt;var r=App.Gantt.gantt.taskStore;if(g){var o=r.toArray();var j=o[1];var f=o.length;var l=m.getSchedulingView();var p=m.columns;var u=p.length;c=o[this.lastMatchIndex];if(v==true){for(t;t>=0;t--){var h=o[t];if(_isNodeVisible(h,j)){var i=false;for(var n=0;n<u;n++){var s=h.get(p[n].dataIndex);i=e.patternMatches(g,s);if(i){_highlightTask(h);this.lastMatchIndex=t;break}}if(i){break}}}}else{for(t;t<f;t++){var h=o[t];if(_isNodeVisible(h,j)){var i=false;for(var n=0;n<u;n++){var s=h.get(p[n].dataIndex);i=e.patternMatches(g,s);if(i){_highlightTask(h);this.lastMatchIndex=t;break}}if(i){break}}}}}};_isNodeRefinedAlready=function(g){var f=App.Gantt.filter.filterBy;if(f&&Object.keys(f).length>0){return e.matches(g)}return false};_isParentVisible=function(h,f){var i=false;var g=h.parentNode;while(g&&(g!=f)){i=g.get("visible");if(i){break}g=g.parentNode}return i};_isNodeVisible=function(h,f){var j=h.get("visible");if(j){return true}var i=_isParentVisible(h,f);var g=_isNodeRefinedAlready(h);return j&&i&&g};_highlightTask=function(f){var g=gantt.getSchedulingView();var h=gantt.lockedGrid.getView().getSelectionModel();if(c){g.unhighlightTask(c);h.deselect(c)}g.scrollEventIntoView(f,false,false);g.highlightTask(f,false);h.select(f)};_unhighlightTask=function(){var g=App.Gantt.gantt.taskStore;var f=g.toArray();c=f[d.lastMatchIndex];var h=gantt.getSchedulingView();var i=gantt.lockedGrid.getView().getSelectionModel();if(c){h.unhighlightTask(c);i.deselect(c)}};Ext.define("Apps.Program.Gantt.Find",{extend:"Ext.form.TextField",id:"findField",width:175,height:30,enableKeyEvents:true,margin:0,border:0,fieldStyle:"border-left:0;border-right:0;border-bottom:0;background:#fff url(../../webapps/Bryntum/resources/images/search.png) no-repeat 5px center;padding:0px;padding-left:25px;height:100%;",find:_find,triggers:{clear:{cls:"x-fa fa-times",hidden:true,tooltip:App.Nls["emxProgramCentral.Common.Clear"],handler:"reset",scope:"this"},prev:{cls:"x-fa fa-chevron-up",scope:"this",tooltip:App.Nls["emxProgramCentral.Gantt.Toolbar.FindPrevious"],handler:function(){this.find(true,this.lastMatchIndex-1)},},next:{cls:"x-fa fa-chevron-down",scope:"this",tooltip:App.Nls["emxProgramCentral.Gantt.Toolbar.FindNext"],handler:function(){this.find(false,this.lastMatchIndex+1)},},},reset:function(g){this.callParent(arguments);var f=App.Gantt.gantt.getSchedulingView();_unhighlightTask();f.scrollVerticallyTo(0);d.lastMatchIndex=0},listeners:{specialkey:function(g,f){if(f.getKey()===f.ESC){this.reset(g)}else{if(f.getKey()===f.ENTER){this.find(false,this.lastMatchIndex+1)}}},beforerender:function(g,f){g.emptyText=App.Nls["emxProgramCentral.Common.Find"]},change:function(j,i,g,h){var f=this.getTrigger("clear");if(i.length>0){f.setVisible(true);if(i!=g){_unhighlightTask();this.find(false,this.lastMatchIndex)}}else{this.reset(j);f.setVisible(false)}}},});d=new Apps.Program.Gantt.Find({lastMatchIndex:1,});return d}});