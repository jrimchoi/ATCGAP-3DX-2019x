function editPCAction(){require(["DS/ConfiguratorWebClient/ConfiguratorWebClient"],function(b){var a=b.getActionURL("edit");parent.location.href=a})}function openConfiguratorHelp(){var a=emxUIConstants.BROWSER_LANGUAGE;var b=emxUIConstants.STR_HELP_ONLINE_LANGUAGE;parent.openHelp("emxhelpproductconfigurationcreate","configuration",a,b,"","Configuration")}function viewPCAction(){require(["DS/ConfiguratorWebClient/ConfiguratorWebClient"],function(a){a.refreshParent()})}function cancelAction(a){require(["DS/ConfiguratorWebClient/ConfiguratorWebClient"],function(b){b.refreshParent(a);var c=b.getParameterByName("fromPCComparePage");if("true"==c){getTopWindow().closeWindow()}})}function createUpdateProductConfiguration(a){require(["DS/ConfiguratorWebClient/ConfiguratorWebClient"],function(c){c.createUpdateProductConfiguration(a);var d=c.getParameterByName("fromPCComparePage");if("true"==d){var b=window.parent.getTopWindow().getWindowOpener().parent;if(b!=null){b.editableTable.loadData();b.rebuildView()}getTopWindow().closeWindow()}})}function createEmptyProductConfiguration(a,b){require(["DS/ConfiguratorWebClient/ConfiguratorWebClient"],function(c){c.createEmptyProductConfiguration(a,b)})}function releaseSolver(){require(["DS/ConfiguratorWebClient/ConfiguratorWebClient"],function(a){a.releaseSolver()})}define("DS/ConfiguratorWebClient/ConfiguratorWebClient",function(){var b;var a={updateConfigServices:function(c){b=c},getHostURL:function(){var c=location.pathname.substring(0,location.pathname.indexOf("/",1));if(!window.location.origin){window.location.origin=window.location.protocol+"//"+window.location.hostname+(window.location.port?":"+window.location.port:"");return window.location.origin.concat(c)}else{return location.origin.concat(c)}},initData:function(){var g=this.getParameterByName("contextId");var m=this.getParameterByName("strProductContextId");console.log("load data ...."+g);var f=this.getHostURL();var n;var d=this.getParameterByName("txtStartEffectivity");var i=this.getParameterByName("txtEndEffectivity");var k=this.getParameterByName("strMilestoneId");console.log("load data strStartEffectivityDate : "+d);console.log("load data strEndEffectivityDate : "+i);console.log("load data strMilestoneId : "+k);var e="";var l=this.getParameterByName("strAction");if(d!=""||i!=""||k!=""){e='{"date":{"startDate":"'+d+'","endDate":"'+i+'"}, "milestone":{"id":"'+k+'"}, "productState":{"productRev":""}}'}var c=f+"/resources/cfg/configurator/solver/initialization/context/"+g;if(e==""){e="{}"}c=c+"?parentContextId="+m+"&random="+Math.random();UWA.Data.request(c,{method:"POST",type:"json",async:false,onComplete:h,onFailure:j,data:{configurationCriteria:e,actionMode:l}});function h(o){n=o;console.log("Success getDictionary ="+n)}function j(o){console.log("failed while getting initData ="+o);alert(arguments[1].message)}return n},getSelectedFeatureOptions:function(g,f){var j=g;var i=this.getHostURL();if(j==""){j=f}var h;var e=i+"/resources/cfg/configurator/configuration/"+j+"?random="+Math.random();UWA.Data.request(e,{method:"GET",type:"json",async:false,onComplete:d,onFailure:c});function d(k){h=k;console.log("Success setConfigurationCriteria ="+h)}function c(k){console.log("failed while getting selected options ="+k);alert(arguments[1].message)}return h},getHypervisorDetails:function(){var f=this.getHostURL();var e;url=f+"/resources/cfg/configurator/solver/hypervisordetails?random="+Math.random();UWA.Data.request(url,{method:"GET",type:"json",async:false,onComplete:d,onFailure:c});function d(g){console.log("Success getHypervisorDetais ="+g);e=g}function c(g){console.log("failed while getting getHypervisorDetais ="+g);alert(arguments[1].message)}return e},getRuleParamDetails:function(g){var f=this.getHostURL();var d;url=f+"/resources/cfg/configurator/configuration/ruleparam/"+g+"?random="+Math.random();UWA.Data.request(url,{method:"GET",type:"json",async:false,onComplete:e,onFailure:c});function e(h){console.log("Success setAppRuleParams ="+h);d=h}function c(h){console.log("failed while getting initData ="+h);alert(arguments[1].message)}return d},createUpdateProductConfiguration:function(t){if(b.checkInvalidKeyInFeatures&&!b.checkInvalidKeyInFeatures()){return}var c=this.getParameterByName("strAction");console.log("call createupdate PC service strAction :"+c);if("view"==c){window.getTopWindow().close();return}var g=this.getParameterByName("contextId");var v=this.getParameterByName("strProductContextId");var n=this.getParameterByName("txtProductConfigurationName");var u=this.getParameterByName("txtProductConfigurationMarketingName");var h=this.getParameterByName("txtProductConfigurationMarketingText");var f=this.getParameterByName("hidDefaultRevision");var y=localStorage.getItem("desc");var l=(y==null)?"":decodeURIComponent(localStorage.getItem("desc").replace(/\+/g," "));var D=this.getParameterByName("derivedFromId");var j=this.getParameterByName("topLevelPart");var A=this.getParameterByName("txtProductConfigurationPolicy");var v=this.getParameterByName("strProductContextId");var q=this.getParameterByName("txtProductConfigurationVault	");var B=this.getParameterByName("radProductConfigurationSalesIntentValue");var m=this.getParameterByName("radProductConfigurationPurposeValue");var k=this.getParameterByName("txtStartEffectivity");var p=this.getParameterByName("txtEndEffectivity");var C=this.getParameterByName("txtProductConfigurationOwner");var r=this.getParameterByName("strMilestoneId");var e="";var x=this.getListPriceValue();if("edit"==c){e=this.getParameterByName("pcId")}var o=JSON.stringify({contextid:g,strParentProductId:v,strName:n,strProductConfigurationOwner:C,strMarketingName:u,strMarketingText:h,strRevision:f,strDescription:l,strDerivedFromId:D,strTopLevelPart:j,strPolicy:A,strParentProductId:v,strVault:q,strSalesIntent:B,strPurpose:m,strStartEffectivityDate:k,strEndEffectivityDate:p,strMilestoneId:r,pcId:e,strListPriceValue:x,strAction:c});var w=this.getConfigurationCriteria();w=JSON.stringify(w);console.log("createProductConfiguration : selectedCriteria "+w);var z=this.getAppRuleParams();z=JSON.stringify(z);console.log("createProductConfiguration : appRuleParam "+z);var d=this.getHostURL();var i=d+"/resources/cfg/configurator/configuration?random="+Math.random();var s=this;UWA.Data.request(i,{headers:{"Content-Type":"application/json"},method:"POST",type:"json",async:false,onComplete:function(E){localStorage.removeItem("desc");s.refreshParent(t)},onFailure:function(E){console.log("failed while creating pc ="+E);alert(arguments[1].message)},data:{productConfigDetails:o,selectedCriteria:w,appRuleParam:z}})},createEmptyProductConfiguration:function(p,h){var f=this.getHostURL();this.closing=false;var w=this;p=JSON.parse(p);var B="";var F="";var k=f+"/resources/cfg/configurator/configuration?random="+Math.random();var e=true;var r=p.strDerivedFromId;if(!(r==undefined||r=="")){selectedCriteriaJSON=this.getSelectedFeatureOptions(p.pcId,r);var n=p.contextid;var z=p.strParentProductId;var o="";var l=p.strStartEffectivityDate;var u=p.strEndEffectivityDate;var v=p.strMilestoneId;if(l!=""||u!=""||v!=""){o='{"date":{"startDate":"'+l+'","endDate":"'+u+'"}, "milestone":{"id":"'+v+'"}, "productState":{"productRev":""}}'}if(o==""){o="{}"}dictionaryData=this.getDictionary(n,z,o);var G=[];var t=dictionaryData.dictionary.features;for(var E=0;E<t.length;E++){var A=t[E].keyInType;if(A!="Blank"){var d=undefined;for(var D=0;D<selectedCriteriaJSON.configurationCriteria.length;D++){if(selectedCriteriaJSON.configurationCriteria[D].Id=="KeyIn_"+t[E].ruleId){d=selectedCriteriaJSON.configurationCriteria[D];break}}if(!d){continue}var c=d.State;if(c=="chosen"||c=="chosenInConflict"){var s=d.Value;var C;if(A=="Integer"){C=this.inputNumberCheck(s,0,1)}else{if(A=="Real"){C=this.inputNumberCheck(s,2,1)}else{if(A=="Input"||A=="Text Area"){C=this.checkForBadChars(s,false)}else{if(A=="Date"){C=this.inputDateCheck(s,"M dd, yy")}}}}if(!C){G.push(t[E].displayName)}}}}y(widget.lang);if(G.length>0){e=false;var m="";for(var E=0;E<G.length;E++){if(m.length>0){m+=", "}m+=G[E]}var x=UWA.i18n("KeyIn Type has been changed for #FEATURES#");x=x.replace("#FEATURES#",m);alert(x)}else{e=true}B=JSON.stringify(selectedCriteriaJSON.configurationCriteria);F=JSON.stringify(selectedCriteriaJSON.appRuleParam)}if(e==true){UWA.Data.request(k,{headers:{"Content-Type":"application/json"},method:"POST",type:"json",async:false,onComplete:g,onFailure:q,data:{productConfigDetails:JSON.stringify(p),selectedCriteria:B,appRuleParam:F}})}function g(i){w.closing=true}function q(i){console.log("Failed creating empty PC ="+i);w.closing=false;alert(arguments[1].message)}function y(H){var i=w.getHostURL()+"/webapps/ConfiguratorWebView/assets/nls/langWW_"+H+".json";var j=true;UWA.Data.request(i,{type:"json",method:"GET",async:false,onComplete:function(I){j=false;UWA.i18n(I)},onFailure:function(I,J){j=false;UWA.i18n(J)},onCancel:function(){},onTimeout:function(I){}});if(j==true&&H!="en"){y("en")}}if(h){h(this.closing)}},inputNumberCheck:function(j,e,k){var h=".";var l=false;var d="";var c="";var f="";var g=0;var m=true;if(j==""){return m}if(k&&j.charAt(g)=="-"){f="-";g++}if(isNaN(j)){m=false;return m}for(g;g<j.length;g++){d=j.charAt(g);if(d==h){if(!l){l=true}}else{if(d>="0"&&d<="9"){}}}if(l&&e==0){m=false}c=j;if(c.length==0&&e==0){returnObj.message=UWA.i18n("Please Enter an Integer Value.")}else{if(c.length==0&&e==2){returnObj.message=UWA.i18n("Please Enter a Decimal Value.")}}if(c==""){return m}return m},inputDateCheck:function(j){var o=false;var c=["January","February","March","April","May","June","July","August","September","October","November","December"];if(j&&j.length>0){var h=j.split(",");if(h.length==2){var g=h[0].split(" ");if(g.length==2){var i=g[0];var l=g[1];var k=h[1];var n=c.indexOf(i)==-1?false:true;var f=this.inputNumberCheck(l,0);var d=f.isValid;var e=this.inputNumberCheck(k,0);var m=e.isValid;if(n&&d&&m){o=true}}}}else{o=true}return o},checkForBadChars:function(f,c){var j=false;var g=new Array("#","+","|");var h=true;var d="";for(var e=0;e<g.length;e++){if(f.indexOf(g[e])>-1){d+=g[e]+" "}}if(d.length>0){j=true}if(j){h=false;return h}return h},getDictionary:function(g,f,e){var c;var j=this.getHostURL();var h=j+"/resources/cfg/configurator/feature/context/"+g;h=h+"?parentContextId="+f+"&random="+Math.random();UWA.Data.request(h,{method:"GET",type:"json",async:false,onComplete:i,onFailure:d,data:{configurationCriteria:e}});function i(k){c=k;console.log("Success getDictionary ="+c)}function d(k){console.log("failed while getting initData ="+k);alert(arguments[1].message)}return c},getParameterByName:function(c){c=c.replace(/[\[]/,"\\[").replace(/[\]]/,"\\]");var e=new RegExp("[\\?&]"+c+"=([^&#]*)"),d=e.exec(location.search);return d==null?"":decodeURIComponent(d[1].replace(/\+/g," "))},getActionURL:function(g){var f=parent.location.href;var c=this.getParameterByName("strAction");if(c.toLowerCase()=="create"){return f}var d="strAction";var e=new RegExp("([?&])"+d+"=.*?(&|$)","i");var h=f.indexOf("?")!==-1?"&":"?";if(f.match(e)){return f.replace(e,"$1"+d+"="+g+"$2")}else{return f+h+d+"="+g}},releaseSolver:function(){var f=this.getHostURL();var d=f+"/resources/cfg/configurator/solver/release";UWA.Data.request(d,{method:"POST",type:"json",timeout:5000,aysnc:false,onComplete:e,onFailure:c});function e(){console.log("Release Solver")}function c(){console.log("Failed in Releasing Solver")}},refreshParent:function(d){var c=this.getParameterByName("strAction");console.log("sAction ::"+c);if(c.toLowerCase()!="create"){d=this.getActionURL("view")}if(d){parent.location.href=d}},getConfigurationCriteria:function(){var c=b.getActualConfigurationCriteria();console.log("selectedCriteria -- > selectedCriteria : "+c);return c},getListPriceValue:function(){var c=b.getListPrice();return c},getAppRuleParams:function(){var c=b.getAppRulesParam();console.log("appRuleParam -- > appRuleParam : "+c);return c},callSetServices:function(d){var c=this.initData();var n=this.getParameterByName("strAction");var l=this.getParameterByName("derivedFromId");var h=this.getParameterByName("radProductConfigurationPurposeValue");var e=this.getParameterByName("refineSelMode");var g=l;var j=this.getParameterByName("pcId");b.setAction(n);b.setDictionaryJSON(c.dictionary);b.setPCPurpose(h);b.setRefineSelMode(e);if(g==undefined||g==""){g=j}if(n.toLowerCase()=="edit"||n.toLowerCase()=="view"||g!=""){var f=this.getSelectedFeatureOptions(j,l);b.setConfigurationCriteriaJSON(f.configurationCriteria);console.log("callSetservices -- > appRuleParamJSON.rulesMode      =  "+f.appRuleParam.rulesMode);console.log("callSetservices -- > appRuleParamJSON.multiSelection = "+f.appRuleParam.multiSelection);console.log("callSetservices -- > appRuleParamJSON.rules 		  = "+f.appRuleParam.rules);var i=JSON.parse('{"appRulesParam": '+JSON.stringify(f.appRuleParam)+"}");b.setAppRulesParamJSON(i);var k='{"app_Func": {"features": "yes","productState": "yes","manufacturingPlan": "yes","milestone": "yes","date": "yes","units": "yes","multiSelection": "yes","selectionMode_Build": "yes","selectionMode_Refine": "no","rulesMode_ProposeOptimizedConfiguration": "no","rulesMode_SelectCompleteConfiguration": "no","rulesMode_EnforceRequiredOptions": "yes","rulesMode_DisableIncompatibleOptions": "yes"}}';k=JSON.parse(k);b.setAppFuncJSON(k);b.initPanel(false);console.log("callSetservices -- > init Panel  loaded!!")}else{var m='{"app_Func": {"features": "yes","productState": "yes","manufacturingPlan": "yes","milestone": "yes","date": "yes","units": "yes","multiSelection": "yes","selectionMode_Build": "yes","selectionMode_Refine": "yes","rulesMode_ProposeOptimizedConfiguration": "no","rulesMode_SelectCompleteConfiguration": "no","rulesMode_EnforceRequiredOptions": "yes","rulesMode_DisableIncompatibleOptions": "yes"}}';m=JSON.parse(m);b.setAppFuncJSON(m);var i='{"appRulesParam": {"multiSelection": "false","selectionMode": "selectionMode_Build","rulesMode": "RulesMode_EnforceRequiredOptions","rulesActivation": "true","completenessStatus": "Unknown","rulesCompliancyStatus": "Unknown"}}';i=JSON.parse(i);b.setAppRulesParamJSON(i);b.initPanel(true);console.log("callSetservices -- > init Panel  loaded!!")}}};return UWA.namespace("DS/ConfiguratorWebClient/ConfiguratorWebClient",a)});