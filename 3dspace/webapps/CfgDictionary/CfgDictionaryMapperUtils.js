define("DS/CfgDictionary/CfgDictionaryMapperUtils",["DS/CfgDictionary/CfgDictionaryTypeEnum"],function(e){var d={};var b=function(g,i,h){if(h.kind==="reference"){g[h.rel_lid]={type:e.OPTION,parent:i,name:h.attributes._name,kind:"reference"}}else{if(h.kind==="instance"){}else{}}};var f=function(j,k,h){var g=0;if(h.kind==="reference"){j[h.lid]={type:e.VARIANT,parent:k,name:h.attributes._name,values:[],kind:"reference"};for(g=0;g<h.values.member.length;g+=1){j[h.lid].values.push(h.values.member[g].rel_lid);j[h.values.member[g].rel_lid]={type:e.VALUE,parent:h.lid,name:h.values.member[g].attributes._name,kind:"reference"};j[h.values.member[g].id]={type:e.VALUE,parent:h.lid,name:h.values.member[g].attributes._name,kind:"reference"}}}else{}};var c=function(l,n,g){var k=0;l[g.lid]={parent:n,name:g.attributes._name,type:e.VARIABILITY_GROUP,content:[]};var h=g.variants?g.variants.member:[];for(k=0;k<h.length;k+=1){f(l,g.lid,h[k]);l[g.lid].content.push(h[k].lid)}var j=g.options?g.options.member:[];for(k=0;k<j.length;k+=1){b(l,null,j[k]);if(j[k].rel_lid){l[g.lid].content.push(j[k].rel_lid)}}var m=g.variabilityGroups?g.variabilityGroups.member:[];for(k=0;k<m.length;k+=1){c(l,g.lid,m[k]);l[g.lid].content.push(m[k].lid)}};var a=function(g,h){g[h.id]={name:h.attributes._name,type:h.attributes._type}};d.dicoMinifiedV3ToMap=function(o){var h={};if(o._version!=="3.0"){return null}var j=0;var k=(o.portfolioClasses)?o.portfolioClasses.member[0].portfolioComponents.member[0]:o;var n=k.options?k.options.member:[];var g=k.variants?k.variants.member:[];var m=k.variabilityGroups?k.variabilityGroups.member:[];var l=k.rules&&k.rules.member?k.rules.member:[];for(j=0;j<n.length;j+=1){b(h,null,n[j])}for(j=0;j<g.length;j+=1){f(h,null,g[j])}for(j=0;j<m.length;j+=1){c(h,null,m[j])}for(j=0;j<l.length;j+=1){a(h,l[j])}return h};return d});