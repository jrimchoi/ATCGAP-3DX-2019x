define("DS/RTShareAPI/RTShareAPI",["UWA/Class","UWA/Class/Events","DS/PlatformAPI/PlatformAPI","i18n!DS/RTShareAPI/assets/nls/feed"],function(c,a,b,d){UWA.log("3DIM - RTShareAPI load");var e=c.extend(a,{init:function(f){if(!f){return UWA.log("3DIM - RTShareAPI Error : options missed.")}if(!f.content){return UWA.log("RTShareAPI Error : options content missed.")}this.item={};this.item.text=d.ShareWith||"Share with";this.item.handler=function(){var g=require("DS/MessageBus/MessageBus");UWA.log("3DIM API - RTShareAPI shareContent launched");var h={content:f.content,action:"shareContent"};b.publish("im.ds.com",h)}}});return e});