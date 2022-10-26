define("DS/ENOGantt/Data/CrudManager",["UWA/Class","DS/PlatformAPI/PlatformAPI","DS/Foundation2/FoundationV2Data","DS/ENOGantt/Ven/Bryntum","DS/ENOGantt/Data/TaskStore","DS/ENOGantt/Data/ResponseUtil"],function(b,a,e,d,c,f){return b.extend({init:function(){var i=this;var g=new c();g=g.getStore();Ext.define("DS.ENOGantt.Data.CrudManager",{extend:"Gnt.data.CrudManager",autoLoad:false,taskStore:g,prepareRemoved:function(o){var j=[],n;for(var m=0,k=o.length;m<k;m++){n={};n[o[m].idProperty]=o[m].getId();if("Gnt.model.Dependency"==o[m].$className){n.To=o[m].get("To");n.From=o[m].get("From")}if("Gnt.model.Assignment"==o[m].$className){n.TaskId=o[m].get("TaskId")}j.push(n)}return j},sendRequest:function(){var q=this;var u=App.Infra.isCustomizedEnvironment;var n="live";var o=q.transport.sync.params;if(o&&o.AddRemoveTask){n=""}var v=arguments[0].success;var p=JSON.parse(arguments[0].data);var r=p.type;var j="GET";var m=1;if(App.Infra.Load.Level!=undefined){m=App.Infra.Load.Level}else{App.Infra.Load.Level=m}var s=enoviaServer.physicalId;if(enoviaServer.referenceId!=undefined&&enoviaServer.referenceId!="null"&&enoviaServer.referenceId!=""){s=s+","+enoviaServer.referenceId}var l="";if(App.Infra.ViewId==App.Infra.Views.VIEW_STATUS_REPORT){m=1}if(App.Infra.ViewId==App.Infra.Views.VIEW_STATUS_REPORT&&!enoviaServer.initGantt){var w="/resources/v1/modeler/tasks/";var k="none";if(enoviaServer.AddDeliverable=="true"){k=k+"deliverables"}l=w+s+"?isDPMTask=true&$include="+k+"&isCustomizedEnvironment="+u+"$indexBasedImages=false&$fields=title,isSummaryTask,typeicon,modifyAccess,policy,actualStartDate,actualFinishDate,estimatedStartDate,dueDate,predictiveActualFinishDate,estimatedDurationInputValue,estimatedDurationInputUnit"}else{l="/resources/v1/modeler/projects/"+s+"?isDPMTask=true&$indexBasedImages=false&rollup="+n+"&isCustomizedEnvironment="+u+"&$include=none,tasks,predecessors,assignees&level="+m+"&$fields=none,";if(r=="sync"||App.Infra.loadProjectSelectable||m!=1){l=l+"title,PALId,sequenceOrder,state,policy,modifyAccess,estimatedStartDate,estimatedFinishDate,dueDate,actualStartDate,actualFinishDate,percentComplete,estimatedDurationInputValue,estimatedDurationInputUnit,actualDuration,constraintDate,defaulConstraintType,scheduleFrom,scheduleBasedOn,typeicon,"}l=l+"tasks.title,tasks.modifyAccess,tasks.deleteAccess,tasks.freeFloat,tasks.totalFloat,tasks.PALId.transient,tasks.state,tasks.notes,tasks.predictiveActualFinishDate,tasks.estimatedDuration,tasks.percentComplete,tasks.estimatedStartDate,tasks.dueDate,tasks.estimatedDurationInputValue,tasks.estimatedDurationInputUnit,tasks.actualStartDate,tasks.actualFinishDate,tasks.actualDuration,tasks.constraintType,tasks.Deviation,tasks.constraintDate,tasks.policy,tasks.isSummaryTask,tasks.sourceId,tasks.taskProjectId,tasks.criticalTask,tasks.status,tasks.typeicon,tasks.sequenceOrder,predecessors.title, predecessors.PALId,predecessors.lagTime,predecessors.dependencyType,predecessors.LagUnit,predecessors.From,predecessors.predTaskSeqNumber,predecessors.To,predecessors.predProjectName,predecessors.predProjectId,assignees.fullname,assignees.allocation"}if(enoviaServer.securityContext&&enoviaServer.securityContext!="ctx::undefined"){l=l+"&SecurityContext="+enoviaServer.securityContext}this.transport.load.url=l;var t={};var p={};if(r=="sync"){j="PUT";t=this.getChangeSetPackage();p.data=f.format6WData(this,t);p.csrf={name:App.csrf.name,value:App.csrf.value,}}p=this.encode(p);e.ajaxRequest({data:p,url:l,type:j,dataType:"json",callback:function(z){var A=z.data;var x=z.csrf;if(x){App.csrf=x}if(this.type=="PUT"||this.method=="PUT"){var y=q.transport.sync.params;var F=f.syncFormat(A,false,y,q);q.transport.sync.params={};var D=q.encode(F);v.call(q,D);if(y&&y.AddRemoveTask||y&&y.AddRemoveDep){if(!App.Infra.loadProjectSelectable){App.Infra.loadProjectSelectable=true}if(App.Infra.Load.Level!=undefined&&App.Infra.Load.Level!=0){App.Infra.Load.Level=App.Infra.Load.Level+1}q.load()}}else{if(App.Infra.ViewId==App.Infra.Views.VIEW_STATUS_REPORT&&!enoviaServer.initGantt){var E={};E.relateddata={};E.relateddata.tasks=A;A=[E]}else{console.time("loadFormat");if(A.length>1){var G=A[1];f.getsourceIdData(G);A.splice(1,1)}}var C=f.loadFormat(A);console.timeEnd("loadFormat");var D=q.encode(F);console.time("call");v.call(q,C,D);q.taskStore.store.autoNormalizeNodes=true;if(q.transport.load.resolve){console.log("Reolve in CRUD");var B=q.transport.load.resolve;B();delete q.transport.load.resolve}console.timeEnd("call");if(App.Infra.loadProjectSelectable){App.Infra.loadProjectSelectable=false}}}})},transport:{load:{method:"GET",url:"/resources/v1/modeler/projects/"+enoviaServer.physicalId+"/dpmgantt",requestConfig:{timeout:60000}},sync:{url:"/resources/v1/modeler/projects/"+enoviaServer.physicalId+"/dpmgantt",requestConfig:{timeout:60000},params:{}}},});var h=Ext.create("DS.ENOGantt.Data.CrudManager");h.on("sync",function(o,k){if(k!=null&&k.error){alert(k.error);this.reject()}else{if(k.assignments.rows.length>0||k.assignments.removed.length>0||k.resources.rows.length>0||k.resources.removed.length>0){var m=Ext.ComponentQuery.query("#dpmresourceutilizationpanel")[0];var j=m.getStore();j.commitChanges();this.commit()}if(this.hasChanges()){console.log("============SYNC CALLED========");this.sync();this.commit()}else{this.commit()}var n=Ext.getCmp("tBarActionSaveAll");var l=Ext.getCmp("tBarActionResetAll");if(!n.isDisabled()||!l.isDisabled()){n.disable();l.disable()}}});h.on("haschanges",function(m,k){var l=Ext.getCmp("tBarActionSaveAll");var j=Ext.getCmp("tBarActionResetAll");if(l.isDisabled()||j.isDisabled()){l.enable();j.enable()}});h.on("nochanges",function(m,k){var l=Ext.getCmp("tBarActionSaveAll");var j=Ext.getCmp("tBarActionResetAll");if(l&&j){if(!(l.isDisabled())||!(j.isDisabled())){l.disable();j.disable()}}});h.on("beforeload",function(l,m,j){var k=Ext.ComponentQuery.query("#dpmprojectgantt")[0];if(k.rendered){k.setLoading({msg:k.L("loadingText")})}});h.on("beforesync",function(l,k){var j=Ext.ComponentQuery.query("#dpmprojectgantt")[0];if(j.rendered){j.setLoading({msg:k.type==="load"?j.L("loadingText"):j.L("savingText")})}});this.crudManager=h}})});