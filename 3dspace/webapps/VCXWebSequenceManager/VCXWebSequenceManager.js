define("DS/VCXWebSequenceManager/VCXScenarioSequence",["UWA/Class","DS/CoreEvents/Events"],function(b,a){var c=b.extend({init:function(){this._listScenariosId=[];this._sequenceType=0;this._name=""},GetType:function(){return this.componentType},GetListScenariosId:function(){return this._listScenariosId},GetIndexOfScenario:function(d){return this._listScenariosId.indexOf(d)},FindScenario:function(d){if(this._listScenariosId.indexOf(d)!==-1){return true}return false},PushScenario:function(e){var d=this.FindScenario(e);if(!d){this._listScenariosId.push(e)}},InsertScenarioAtIndex:function(e,f){var d=this.FindScenario(e);if(!d){this._listScenariosId.splice(f,0,e)}},InsertScenarioAfter:function(f,d){var e=this.FindScenario(f);if(!e){var g=this.GetIndexOfScenario(d);this._listScenariosId.splice(g+1,0,f)}},RemoveScenario:function(e){var d=this.GetIndexOfScenario(e);if(d>=0){this._listScenariosId.splice(d,1)}},GetPreviousScenarioId:function(e){var f="";var d=this.GetIndexOfScenario(e);if(d>0){d--;f=this._listScenariosId[d]}return f},GetNextScenarioId:function(f){var e="";var d=this.GetIndexOfScenario(f);if(d!==-1&&d!==this._listScenariosId.length-1){d++;e=this._listScenariosId[d]}return e},Clone:function(l){if(l){}else{return}var k=this.GetListScenariosId();for(var j=0;j<k.length;j++){l._listScenariosId[j]=k[j]}var g=this.QueryInterface("VCXIModifiable");var f;if(g){f=g.GetProperties()}var e=l.QueryInterface("VCXIModifiable");if(e){if(f){for(var d in f._map){if(f._map.hasOwnProperty(d)){var h=f.GetProperty(d);e.OnChangeProperty(d,h.GetPropertyValue())}}}}},SetSequenceType:function(d){this._sequenceType=d},GetSequenceType:function(){return this._sequenceType},SetName:function(d){if(this._name!==d){this._name=d;a.publish({event:"VCX_SEQUENCE_NAME_CHANGED",data:this})}},GetName:function(){return this._name},MoveScenario:function(e,f){if(f!==undefined){var d=this.GetIndexOfScenario(e);if(d>=0&&d!==f){this._listScenariosId.splice(f,0,this._listScenariosId.splice(d,1)[0])}}else{this.RemoveScenario(e);this.PushScenario(e)}}});Object.defineProperty(c.prototype,"componentType",{enumerable:true,get:function(){return"VCXScenarioSequence"}});return c});define("DS/VCXWebSequenceManager/VCXCmdChangeScenarioSequence",["DS/CoreEvents/Events","DS/VCXWebKernelCommands/VCXCommand","DS/VCXWebKernelCommands/VCXCmdChangeScenario","DS/VCXWebExperienceLoader/VCXExperienceSaverBase","DS/VCXWebKernelCommands/VCXCmdChangeNeutralProperties"],function(b,d,f,e,a){var c=d.extend({init:function(g,h,i){this._parent();this._sequenceManager=g;this._commandManager=h;this._ComponentsMap=i;this._scenarioToAdd=null;this._scenarioToRemove=null;this._sequenceIDForAdd="";this._sequenceIDForRemove="";this._scenarioAddIdx=-1;this._scenarioRemoveIdx=-1;this._bPush=false;this._bLockEvents=false;this._bMove=false;this._bIsLoading=false},GetType:function(){return"VCXCmdChangeScenarioSequence"},GetTitle:function(){return"Change scenario sequence"},MoveScenario:function(i,h,j){this._bMove=true;var g=this._ComponentsMap.GetComponentFromID(i);if(g){this.RemoveScenarioFromSequence(g);if(j!==undefined){this.InsertScenarioInSequence(g,h,j)}else{this.PushScenarioInSequence(g,h)}}},PushScenarioInSequence:function(h,k){this._bPush=true;this._scenarioToAdd=h;var j=null;var m=this._sequenceManager.GetListSequences();if(m[0]){j=m[0]}var i=this._sequenceManager.GetSequenceFromId(k);if(i){this._sequenceIDForAdd=k}else{if(j){this._sequenceIDForAdd=j.GetID();i=j}else{return}}var g=i.GetListScenariosId();var l=g.length;this._scenarioAddIdx=l},InsertScenarioInSequence:function(g,h,i){this._scenarioToAdd=g;this._sequenceIDForAdd=h;this._scenarioAddIdx=i},RemoveScenarioFromSequence:function(g){this._scenarioToRemove=g},Do:function(){var l={};if(this._scenarioToAdd){l={sequenceIdForAdd:this._sequenceIDForAdd,scenarioToAdd:this._scenarioToAdd,bLinked:this._bLinkedCmd,scenarioAddIdx:this._scenarioAddIdx};if(this._bMove){this._sequenceManager.MoveScenarioInSequence(this._scenarioToAdd.GetID(),this._sequenceIDForAdd,this._scenarioAddIdx)}else{var u=new f(this._sequenceManager._scenarioManager,this._commandManager,this._ComponentsMap);u.AddScenarios(this._scenarioToAdd);this._commandManager.Push(u);var m=this._scenarioToAdd.GetID();if(this._bPush){this._sequenceManager.PushScenarioInSequence(m,this._sequenceIDForAdd)}else{this._sequenceManager.InsertScenarioAtIndex(m,this._sequenceIDForAdd,this._scenarioAddIdx)}if(this._bIsLoading===false){var k=this._sequenceManager._experienceBase.getManager("VCXCAT3DXModelManager");if(k&&!k.IsLocalMode()){var g=this._sequenceManager._experienceBase.getManager("VCXDocManager").actorDocManager;var z=g.QueryInterface("VCXIModifiable");var v=new a(this._sequenceManager._experienceBase.getManager("VCXScenarioManager"));v.CaptureNeutralProperties(z);v.Do();var o=m;var r=this._sequenceIDForAdd;var s=new e();var q=s._ScenarioToJson(this._sequenceManager._experienceBase,this._scenarioToAdd);var h=s._VisibilityToJson(this._scenarioToAdd.GetVisibility(),this._sequenceManager._experienceBase);q.visibility=h;var i=[];i.push(q);var w={};w.listScenarios=i;var p=JSON.stringify(w,null,4);var j={};j.neutrals=s._NeutralsToJson(this._sequenceManager._experienceBase);var x=JSON.stringify(j,null,4);k.CreateState(x,r,o,p)}}}}if(this._scenarioToRemove){var y={sequenceIdForRemove:this._sequenceIDForRemove,scenarioToRemove:this._scenarioToRemove,scenarioRemovedIdx:this._scenarioRemoveIdx,bLinked:this._bLinkedCmd};var m=this._scenarioToRemove.GetID();if(this._bMove){Object.assign(l,y)}else{l=y;var u=new f(this._sequenceManager._scenarioManager,this._commandManager,this._ComponentsMap);u.RemoveScenarios(this._scenarioToRemove);this._commandManager.Push(u);var n=this._sequenceManager.GetSequenceFromId(this._sequenceIDForRemove);n.RemoveScenario(m);if(this._bIsLoading===false){var k=this._sequenceManager._experienceBase.getManager("VCXCAT3DXModelManager");if(k&&!k.IsLocalMode()){var t=this;k.DeleteState(m,n.GetID()).done(function(){var A=t._sequenceManager._experienceBase.getManager("VCXDocManager").actorDocManager;var E=A.QueryInterface("VCXIModifiable");var C=new a(t._sequenceManager._experienceBase.getManager("VCXScenarioManager"));C.CaptureNeutralProperties(E);C.Do();var D=new e();var I={};I.neutrals=D._NeutralsToJson(t._sequenceManager._experienceBase);var H=JSON.stringify(I,null,4);var F="";var G="";var B="";k.CreateState(H,F,G,B);console.log("DeleteState DONE")})}}}}if(this._bLockEvents){}else{if(this._bMove){b.publish({event:"VCX_SCENARIO_MOVED",data:l,})}else{b.publish({event:"VCX_SCENARIO_CHANGED",data:l,})}}},SaveContext:function(){if(this._scenarioToRemove){var g=this._sequenceManager.GetSequenceFromScenarioId(this._scenarioToRemove.GetID());this._sequenceIDForRemove=g.GetID();this._scenarioRemoveIdx=g.GetIndexOfScenario(this._scenarioToRemove.GetID())}},Invert:function(){var h=this._scenarioToAdd;this._scenarioToAdd=this._scenarioToRemove;this._scenarioToRemove=h;var i=this._sequenceIDForAdd;this._sequenceIDForAdd=this._sequenceIDForRemove;this._sequenceIDForRemove=i;var g=this._scenarioAddIdx;this._scenarioAddIdx=this._scenarioRemoveIdx;this._scenarioRemoveIdx=g},SetLockEvents:function(g){this._bLockEvents=g}});return c});define("DS/VCXWebSequenceManager/VCXModifiableSequence",["DS/CoreEvents/Events","DS/VCXWebProperties/VCXPropertyValueString","DS/VCXWebProperties/VCXPropertyValueEnum","DS/VCXWebProperties/VCXProperty","DS/VCXWebProperties/VCXPropertyInfo","DS/VCXWebProperties/VCXPropertyInfoEnum","DS/VCXWebProperties/VCXPropertySet","DS/VCXWebModifiables/VCXModifiable"],function(c,i,a,h,f,b,e,d){var g=d.extend({init:function(){this._parent();this._name="";this._sequenceDescription="";this._scenarioSequence=null},OnChangeProperty:function(k,j){if(k==="Actor.Name"){this.GetObject().SetName(j.GetValue())}else{if(k==="Actor.Description"){this._sequenceDescription=j.GetValue()}else{if(k==="Actor.Sequence.Type"){this.GetObject().SetSequenceType(j.GetValue())}else{this._parent(k,j)}}}},GetProperty:function(m){var j=null;if(m==="Actor.Name"){var l=new i();l.SetValue(this.GetObject().GetName());j=new h(new f(m,f.EBehaviorType.Singleton,true,"VCXWebSequenceManager/VCXWebSequenceManager"),l)}else{if(m==="Actor.Description"){var l=new i();l.SetValue(this._sequenceDescription);j=new h(new f(m,f.EBehaviorType.Singleton,true,"VCXWebSequenceManager/VCXWebSequenceManager"),l)}else{if(m==="Actor.Sequence.Type"){var k=new a();k.SetValue(this.GetObject().GetSequenceType());var n=new b(m,f.EBehaviorType.Singleton,true,"VCXWebSequenceManager/VCXWebSequenceManager");var o={0:"sequence.type.scenarios",1:"sequence.type.layers",2:"sequence.type.CAD"};n.SetMapChoiceEnum(o);n.SetVisible(false);j=new h(n,k)}else{j=this._parent(m)}}}return j},GetProperties:function(){var j=new e();j.AddOrModifyProperty(this.GetProperty("Actor.Name"));j.AddOrModifyProperty(this.GetProperty("Actor.Description"));j.AddOrModifyProperty(this.GetProperty("Actor.Sequence.Type"));return j}});return g});define("DS/VCXWebSequenceManager/VCXModifiableSequenceManager",["DS/VCXWebModifiables/VCXModifiable","DS/VCXWebProperties/VCXPropertySet",],function(a,c){var b=a.extend({init:function(){this._parent()},OnChangeProperty:function(e,d){return true},GetProperty:function(e){var d=null;return d},GetProperties:function(){var d=new c();return d}});return b});define("DS/VCXWebSequenceManager/VCXSequenceManager",["DS/WebApplicationBase/W3AAManager",],function(b){var a=b.extend({initialize:function(){this._listSequences=[];this._maxIndex=0},unInitialize:function(){this._listSequences=[];this._maxIndex=0},postInitialize:function(){this._scenarioManager=this._experienceBase.getManager("VCXScenarioManager");this._Factory=this._experienceBase.Factory},GetListSequences:function(){return this._listSequences},GetListSequencesFromType:function(d){var f=[];for(var e=0;e<this._listSequences.length;e++){var g=this._listSequences[e];var c=g.GetSequenceType();if(c===d){f.push(g)}}return f},GetIndexOfSequence:function(c){return this._listSequences.indexOf(c)},GetSequenceFromId:function(f){for(var d=0;d<this._listSequences.length;d++){var c=this._listSequences[d].GetID();if(c===f){var e=this._listSequences[d];return e}}},GetSequenceFromScenarioId:function(f){var e=null;for(var d=0;d<this._listSequences.length;d++){var c=this._listSequences[d];if(c.FindScenario(f)){e=c;break}}return e},BuildSequenceFromListScenarios:function(f){var g=this._Factory.BuildComponent("VCXScenarioSequence");var d=this._scenarioManager.GetScenarios();if(f==="smg"){for(var e in d){if(d.hasOwnProperty(e)){var c=d[e].QueryInterface("VCXIModifiable");if(c.GetName()!=="Animation smg"){g.PushScenario(e)}}}this.PushSequence(g)}else{for(var e in d){if(d.hasOwnProperty(e)){g.PushScenario(e)}}this.PushSequence(g)}return g},PushSequence:function(d){var c=d.GetID();if(c){this._listSequences.push(d)}else{console.log("VCXSequenceManager::InsertSequenceAfter -> ID of sequence empty! you need to call CmdChangeComponent Before")}this._maxIndex++},RemoveSequence:function(c){var d=this.GetSequenceFromId(c);if(d){var e=this.GetIndexOfSequence(d);this._listSequences.splice(e,1)}},PushScenarioInSequence:function(e,c){var d=this.GetSequenceFromId(c);if(d){}else{d=this._listSequences[0]}d.PushScenario(e)},InsertScenarioAfter:function(f,e,c){var d=this.GetSequenceFromId(e);d.InsertScenarioAfter(f,c)},InsertScenarioAtIndex:function(e,d,f){var c=this.GetSequenceFromId(d);c.InsertScenarioAtIndex(e,f)},RemoveScenarioFromSequence:function(d){var c=this.GetSequenceFromScenarioId(d);if(c){c.RemoveScenario(d)}},GetPreviousScenarioId:function(d){var c="";var e=this.GetSequenceFromScenarioId(d);if(e){c=e.GetPreviousScenarioId(d)}return c},GetNextScenarioId:function(d){var c="";var e=this.GetSequenceFromScenarioId(d);if(e){c=e.GetNextScenarioId(d)}return c},GetPreviousSequence:function(g,e){var f=null;var c=this.GetIndexOfSequence(g);if(c>0){if(e){for(c--;c>=0;c--){var d=this._listSequences[c];if(e.indexOf(d._sequenceType)!=-1){f=this._listSequences[c];return f}}}else{c--;f=this._listSequences[c]}}return f},GetNextSequence:function(g,e){var f=null;var c=this.GetIndexOfSequence(g);if(c<(this._listSequences.length-1)){if(e){for(c++;c<this._listSequences.length;c++){var d=this._listSequences[c];if(e.indexOf(d._sequenceType)!=-1){f=this._listSequences[c];return f}}}else{c++;f=this._listSequences[c]}}return f},GetListScenariosInSequence:function(g){var c=[];var d=this._scenarioManager.GetScenarios();var f=g.GetListScenariosId();for(var e=0;e<f.length;e++){var h=f[e];c[e]=d[h]}return c},InsertSequenceAfter:function(d,e){var c=d.GetID();if(c){var f=this.GetIndexOfSequence(e);this._listSequences.splice(f+1,0,d)}else{console.log("VCXSequenceManager::InsertSequenceAfter -> ID of sequence empty! you need to call CmdChangeComponent Before")}this._maxIndex++},MoveScenarioInSequence:function(e,c,f){var g=this.GetSequenceFromScenarioId(e);if(g.GetID()===c){g.MoveScenario(e,f)}else{g.RemoveScenario(e);var d=this.GetSequenceFromId(c);if(typeof f!=="undefined"){d.InsertScenarioAtIndex(e,f)}else{d.PushScenario(e)}}},GetCurrentSequenceID:function(){var d=this._experienceBase.getManager("VCXScenarioManager").GetCurrentScenario();var c=this.GetSequenceFromScenarioId(d);if(c){return c.GetID()}}});Object.defineProperty(a.prototype,"componentType",{enumerable:true,get:function(){return"VCXSequenceManager"}});return a});define("DS/VCXWebSequenceManager/VCXCmdChangeSequence",["DS/CoreEvents/Events","DS/VCXWebKernelCommands/VCXCommand","DS/VCXWebKernelCommands/VCXCmdChangeModifiable","DS/VCXWebKernelCommands/VCXCmdChangeComponent","DS/VCXWebSequenceManager/VCXCmdChangeScenarioSequence"],function(a,f,c,b,e){var d=f.extend({init:function(g,h,i){this._parent();this._sequenceManager=g;this._commandManager=h;this._ComponentsMap=i;this._sequenceToAdd=null;this._sequenceToRemove=null;this._scenariosToRemove=[];this._prevSequence=null;this._bPush=false;this._bLockEvents=false;this._bIsLoading=false},GetType:function(){return"VCXCmdChangeSequence"},GetTitle:function(){return"Change sequence"},PushSequence:function(g){this._bPush=true;this._sequenceToAdd=g},InsertSequence:function(h,g){this._sequenceToAdd=h;this._prevSequence=g},RemoveSequence:function(g){this._sequenceToRemove=g},Do:function(){var s=new c(this._sequenceManager._scenarioManager);var h=new b(this._commandManager,this._ComponentsMap);if(this._sequenceToAdd){h.AddComponents(this._sequenceToAdd);s.AddModifiables(this._sequenceToAdd.QueryInterface("VCXIModifiable"))}else{if(this._sequenceToRemove){h.RemoveComponents(this._sequenceToRemove);s.RemoveModifiables(this._sequenceToRemove.QueryInterface("VCXIModifiable"))}}this._commandManager.Push(h);this._commandManager.Push(s);if(this._sequenceToAdd){if(!this._bIsLoading){var n=this._sequenceManager._experienceBase.getManager("VCXCAT3DXModelManager");if(n&&!n.IsLocalMode()){var g=this._sequenceToAdd.GetName();var k=this._sequenceToAdd.GetID();n.CreateStateCollection(g,k)}}if(this._bPush){this._sequenceManager.PushSequence(this._sequenceToAdd)}else{this._sequenceManager.InsertSequenceAfter(this._sequenceToAdd,this._prevSequence)}for(var m=0;m<this._scenariosToRemove.length;m++){var p=this._scenariosToRemove[m];var j=new e(this._sequenceManager,this._commandManager,this._ComponentsMap);j.PushScenarioInSequence(p,this._sequenceToAdd.GetID());this._commandManager.Do(j)}}else{if(this._sequenceToRemove){var q=this._sequenceManager._scenarioManager.GetScenarios();var o=this._sequenceToRemove.GetListScenariosId();for(var m=0;m<this._scenariosToRemove.length;m++){var p=this._scenariosToRemove[m];var j=new e(this._sequenceManager,this._commandManager,this._ComponentsMap);j.RemoveScenarioFromSequence(p,this._sequenceToRemove.GetID());this._commandManager.Do(j);p=this._scenariosToRemove.pop()}this._sequenceManager.RemoveSequence(this._sequenceToRemove.GetID())}}if(this._bLockEvents){}else{var r=this._sequenceManager.GetIndexOfSequence(this._prevSequence);var l={previousSeqIndex:r,sequenceToAdd:this._sequenceToAdd,sequenceToRemove:this._sequenceToRemove};a.publish({event:"VCX_SEQUENCE_CHANGED",data:l})}},SaveContext:function(){var i=this._sequenceManager._scenarioManager.GetScenarios();if(this._sequenceToAdd){if(this._bPush){var k=this._sequenceManager.GetListSequences();var n=k.length-1;this._prevSequence=k[n]}}else{if(this._sequenceToRemove){this._prevSequence=this._sequenceManager.GetPreviousSequence(this._sequenceToRemove);var j=this._sequenceToRemove.GetListScenariosId();var g=j.length-1;for(var m=g;m>=0;m--){var l=j[m];var h=i[l];this._scenariosToRemove.push(h)}}}},Invert:function(){var g=this._sequenceToAdd;this._sequenceToAdd=this._sequenceToRemove;this._sequenceToRemove=g},SetLockEvents:function(g){this._bLockEvents=g}});return d});