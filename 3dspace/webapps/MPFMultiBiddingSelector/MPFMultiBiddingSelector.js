define("DS/MPFMultiBiddingSelector/CartSlot",["UWA/Class/View","DS/MPFView/EmptyView"],function(c,a){var b;b=c.extend({className:"mpf-cart-slot",setup:function(d){this.tile=d.tile},render:function(){this.container.setContent(this.tile.render());return this},destroy:function(){this._parent()}});return b});define("DS/MPFMultiBiddingSelector/CartTile",["UWA/Core","UWA/Class/View","DS/MPFModelFactory/ShopFactory","DS/MPFView/InitialsDot"],function(e,d,a,c){var b;b=d.extend({className:"mpf-cart-tile",setup:function(f){this.cart=f.cart;this.shopFactory=f.shopFactory;this.shopLogo=this._createShopLogo();this.shopName=this._createShopName();this.removeButton=this._createRemoveButton()},render:function(){this.container.setContent([this.shopLogo,this.shopName,this.removeButton]);return this},fetchShopLogo:function(){var f;f=this.shopFactory.createModel(a.Types.SHOP);f.set("id",this.cart.getShopId());f.fetchPromise().then(this._updateShopLogoImg.bind(this))},destroy:function(){this.cart=null;this._parent()},remove:function(){this.dispatchEvent("removeCart",{cart:this.cart})},_createShopLogo:function(){var f;f=new c({title:this.cart.getShopName()});return e.createElement("div",{"class":"mpf-shop-logo",html:[f]})},_updateShopLogoImg:function(h){var f;var g;g=h.getLogo();if(g){f=e.createElement("img",{"class":"mpf-shop-logo-img",src:g});this.shopLogo.setContent(f)}},_createShopName:function(){return e.createElement("p",{"class":"mpf-shop-name",text:this.cart.getShopName()})},_createRemoveButton:function(){return e.createElement("div",{"class":"mpf-shop-remove fonticon fonticon-close",events:{click:this.remove.bind(this)}})}});return b});define("DS/MPFMultiBiddingSelector/MultiBiddingCommands",["UWA/Class/View","DS/UIKIT/Input/Button","i18n!DS/MPFMultiBiddingSelector/assets/nls/MultiBiddingSelector"],function(c,a,b){var d;d=c.extend({className:"mpf-multi-bidding-commands",setup:function(e){this.carts=e.carts;this.nextButton=this._createNextButton()},render:function(){this.container.setContent(this.nextButton);return this},destroy:function(){this._parent()},onNext:function(){this.dispatchEvent("mpfNext")},_createNextButton:function(){return new a({className:"primary",icon:"chevron-right right",value:b.get("next"),events:{onClick:this.onNext.bind(this)}})}});return d});define("DS/MPFMultiBiddingSelector/MultiBiddingCounter",["UWA/Core","UWA/Class/View","i18n!DS/MPFMultiBiddingSelector/assets/nls/MultiBiddingSelector"],function(d,c,b){var a;a=c.extend({className:"mpf-multi-bidding-counter",setup:function(e){this.carts=e.carts;this.capacity=e.capacity;this.counter=this._createCounter();this.listenTo(this.carts,"onAdd",this.update.bind(this));this.listenTo(this.carts,"onRemove",this.update.bind(this))},render:function(){this.container.setContent(this.counter);return this},destroy:function(){this.stopListening(this.carts);this.carts=null;this._parent()},update:function(){this.counter.getElement(".mpf-number").setText(this.carts.length)},_createCounter:function(){return d.createElement("p",{"class":"mpf-counter",html:[{tag:"span",text:b.get("selectedLabs"),"class":"mpf-label"},{tag:"span",text:this.carts.length,"class":"mpf-number"},{tag:"span",text:"/","class":"mpf-separator"},{tag:"span",text:this.capacity,"class":"mpf-total"}]})}});return a});define("DS/MPFMultiBiddingSelector/CartSlots",["UWA/Core","UWA/Class/View","DS/MPFMultiBiddingSelector/CartSlot","DS/MPFMultiBiddingSelector/CartTile","DS/MPFView/EmptyView"],function(f,e,c,a,b){var d;d=e.extend({className:"mpf-cart-slots",setup:function(g){this.capacity=g.capacity;this.carts=g.carts;this.shopFactory=g.shopFactory;this.slots=this._createSlots();this.listenTo(this.carts,"onAdd",this.onAddCart.bind(this))},render:function(){var g;g=this.slots.map(function(h){return h.render()});this.container.setContent(g);return this},destroy:function(){this.stopListening(this.carts);this.carts=null;this._parent()},onAddCart:function(){this.slots.forEach(function(g){this.stopListening(g)},this);this.slots=this._createSlots();this.render();this.slots[this.carts.size()-1].tile.fetchShopLogo()},onRemoveCart:function(g){this.carts.remove(g.cart);this.slots.forEach(function(h){this.stopListening(h)},this);this.slots=this._createSlots();this.carts.forEach(function(i,h){this.slots[h].tile.fetchShopLogo()},this);this.render()},_createSlots:function(){var h=[];var k;var j;var g;for(g=0;g<this.capacity;g++){k=this.carts.at(g);if(k){j=new a({cart:k,shopFactory:this.shopFactory});this.listenTo(j,"removeCart",this.onRemoveCart.bind(this))}else{j=new b()}h.push(new c({tile:j}))}return h}});return d});define("DS/MPFMultiBiddingSelector/MultiBiddingSelector",["UWA/Class/View","DS/MPFMultiBiddingSelector/MultiBiddingCounter","DS/MPFMultiBiddingSelector/CartSlots","DS/MPFMultiBiddingSelector/MultiBiddingCommands","DS/MPFCartModel/CartCollection","DS/MPFCartModel/CartModel","DS/MPFServices/ObjectService","DS/MPFDataProxy/NoDataProxy","css!DS/MPFMultiBiddingSelector/MPFMultiBiddingSelector.css"],function(a,h,d,e,i,c,g,b){var f;f=a.extend({className:"mpf-multi-bidding-selector",setup:function(j){this.shopFactory=j.shopFactory;this.carts=this._createCartCollection();this.capacity=j.capacity||3;this.counter=this._createCounter();this.cartSlots=this._createCartSlots();this.commands=this._createCommands();this.listenTo(this.commands,"mpfNext",this.onNext.bind(this))},render:function(){this.container.setContent([this.counter.render(),this.cartSlots.render(),this.commands.render()]);return this},addCart:function(k){var j;g.requiredOfPrototype(k,c,"The cart parameter muste be a CartModel");j=this.carts.length<this.capacity;if(j){this.carts.push(k);this.render()}return j},onNext:function(){this.dispatchEvent("mpfNext",{carts:this.carts.toArray()})},destroy:function(){this.stopListening(this.commands);this.counter.destroy();this.cartSlots.destroy();this._parent()},_createCartCollection:function(){return new i([],{dataProxy:b.getInstance()})},_createCounter:function(){return new h({capacity:this.capacity,carts:this.carts})},_createCartSlots:function(){return new d({capacity:this.capacity,carts:this.carts,shopFactory:this.shopFactory})},_createCommands:function(){return new e({carts:this.carts})}});return f});