define("DS/ENOGantt/View/Refinement",[],function(){return function a(){_reset=function(){App.Gantt.filter.filterBy={};_refine()};_refine=function(){var c=App.Gantt.gantt.taskStore;var b=App.Gantt.filter.filterBy;if(b&&Object.keys(b).length>0){c.filterTreeBy({filter:_matches,checkParents:true})}else{c.clearTreeFilter();App.Gantt.filter.filterBy={}}};_matches=function(c){if(c.get("parentId")=="root"){return true}if(c.get("ExternalTask")){return false}if(c.parentNode&&(!c.parentNode.isExpanded())){return false}var e=true;var k=App.Gantt.filter.filterBy;for(var i in k){if(k.hasOwnProperty(i)){var j=App.Gantt.filter.fields[i].fieldDataType;var h=i;var d=k[i].split("@");var b=c.get(h);if("Name"==i){var g=Ext.getCmp("filterField").getValue();e=_nameMatchFound(c);if(!e){break}}else{if("datefield"==j){e=_dateMatchFound(c,h,d);if(!e){break}}else{if("Deviation"==i){e=_deviationMatchFound(c,h,d,b);if(!e){break}}else{if(!(b==undefined)){if("numberfield"==j){b=Math.round(Number(b)*100)/100}var f=d.indexOf(b.toString());if(f>=0){continue}else{e=false;break}}else{e=false;break}}}}}}return e};_patternMatches=function(d,c){var b=new RegExp(Ext.String.escapeRegex(d),"i");return b.test(c)};_nameMatchFound=function(b){var e=Ext.getCmp("filterField").getValue();var d=b.get("Name");var c=_patternMatches(e,d);return c};_dateMatchFound=function(d,g,e){var f=new Date(e[0]);var c=new Date(e[1]);var b=new Date(d.get(g));b.setHours(0);b.setMinutes(0);b.setSeconds(0);if(!isNaN(f)&&!isNaN(c)){return(f<=b)&&(b<=c)}else{if(!isNaN(f)){return f<=b}else{return b<=c}}};_deviationMatchFound=function(b,h,j,g){var f=false;var l=App.Nls["emxProgramCentral.DurationUnits.Days"];if(g==null||g==""){return f}g=g.substring(0,g.indexOf(l));var c=parseInt(g);for(var e=0;e<j.length;e++){var n=[];var d=j[e];d=d.substring(0,d.indexOf(l));n=d.split(" - ");var m=parseInt(n[0]);var k=parseInt(n[1]);if(c>=m&&c<=k){f=true;break}}return f};this.matches=_matches;this.patternMatches=_patternMatches;this.refine=_refine;this.reset=_reset}});