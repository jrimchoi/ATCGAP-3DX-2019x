/*!  COPYRIGHT DASSAULT SYSTEMES 2015   */
define("DS/3DPlayExploreScenario/3DPlayExploreScenario",["DS/3DPlay/3DPlayScenario","DS/WebSystem/Environment"],function(c,a){var b=c.extend({init:function(d){this._parent(d)},isMobileCompatible:function(){return true}});return b});define("DS/3DPlayExploreScenario/3DPlayExploreRegister",["DS/3DPlay/3DPlayRegister","DS/3DPlayExploreScenario/3DPlayExploreScenario","DS/3DPlayNavigationScenario/3DPlayNavigationScenario","DS/CAT3DAnnotationScenario/CAT3DAnnotationScenario"],function(e,c,a,b){var d=e.extend({init:function(f){this._parent(f);this._initScenarios()},_initScenarios:function(){this.scenarioManager.addScenario({registerID:this.registerID,scenario:c,available:true,name:"Explore"});this.scenarioManager.addScenario({registerID:this.registerID,scenario:a,available:true,name:"Navigation"});this.scenarioManager.addScenario({registerID:this.registerID,scenario:b,available:true,name:"FTA"})}});return d});