define("DS/MPFPaymentCardTokenModel/IndividualPayementCardTokenDataProxy",["UWA/String","DS/MPFDataProxy/DataProxy","DS/MPFError/NotImplementedError"],function(d,c,b){var a;a=c.extend({init:function(e){this._parent(e,"/people/{0}/cctokens")},urlGet:function(g,f){var i;var h;var e;i=g.parentResourceId;h=d.format(this.resourcePath,i);e=this.connector.url(h,f);return e},urlPost:b.emit,urlPut:b.emit,urlPatch:b.emit,urlDelete:b.emit,doPost:b.emit,doPut:b.emit,doPatch:b.emit,doDelete:b.emit});return a});define("DS/MPFPaymentCardTokenModel/CompanyPaymentCardTokenDataProxy",["UWA/String","DS/MPFDataProxy/DataProxy","DS/MPFError/NotImplementedError"],function(d,c,a){var b;b=c.extend({init:function(e){this._parent(e,"/company/{0}/cctokens")},urlGet:function(h,g){var e;var i;var f;e=h.parentResourceId;i=d.format(this.resourcePath,e);f=this.connector.url(i,g);return f},urlPost:a.emit,urlPut:a.emit,urlPatch:a.emit,urlDelete:a.emit,doPost:a.emit,doPut:a.emit,doPatch:a.emit,doDelete:a.emit});return b});define("DS/MPFPaymentCardTokenModel/PaymentCardTokenModel",["DS/MPFModel/MPFModel"],function(b){var a;var c={};c.CARD_ID="cardID";c.CARD_TYPE="cardType";c.CARD_NAME="cardName";c.CARD_NUMBER="cardNumber";c.CARD_EXP_MONTH="cardExpMonth";c.CARD_EXP_YEAR="cardExpYear";c.PSP="psp";c.PLATFORM="platform";a=b.extend({defaults:function(){var d={};d[c.CARD_ID]=null;d[c.CARD_TYPE]=null;d[c.CARD_NAME]=null;d[c.CARD_NUMBER]=null;d[c.CARD_EXP_MONTH]=null;d[c.CARD_EXP_YEAR]=null;return d},setup:function(d,e){this._parent(d,e);this._type="PaymentCardTokenModel"},getCardId:function(){return this.get(c.CARD_ID)},setCardId:function(d){this.set(c.CARD_ID,d)},getCardType:function(){return this.get(c.CARD_TYPE)},setCardType:function(d){this.set(c.CARD_TYPE,d)},getCardName:function(){return this.get(c.CARD_NAME)},setCardName:function(d){this.set(c.CARD_NAME,d)},getCardNumber:function(){return this.get(c.CARD_NUMBER)},setCardNumber:function(d){this.set(c.CARD_NUMBER,d)},getCardExpMonth:function(){return this.get(c.CARD_EXP_MONTH)},setCardExpMonth:function(d){this.set(c.CARD_EXP_MONTH,d)},getCardExpYear:function(){return this.get(c.CARD_EXP_YEAR)},setCardExpYear:function(d){this.set(c.CARD_EXP_YEAR,d)},getPsp:function(){return this.get(c.PSP)},getPlatform:function(){return this.get(c.PLATFORM)}});a.Fields=Object.freeze(c);return a});define("DS/MPFPaymentCardTokenModel/PaymentCardTokenDataProxy",["DS/MPFDataProxy/DataProxy","DS/MPFError/NotImplementedError"],function(c,b){var a;a=c.extend({init:function(d){this._parent(d,"/me/cctokens")},urlPost:b.emit,urlPut:b.emit,urlPatch:b.emit,urlDelete:b.emit,doPost:b.emit,doPut:b.emit,doPatch:b.emit,doDelete:b.emit});return a});define("DS/MPFPaymentCardTokenModel/PaymentCardTokenCollection",["DS/MPFModel/MPFCollection","DS/MPFPaymentCardTokenModel/PaymentCardTokenModel"],function(c,a){var b;b=c.extend({model:a});return b});