define("DS/Leaflet/MPMapView",["UWA/Controls/Abstract","UWA/Core","WebappsUtils/WebappsUtils","DS/Leaflet/MPGeolocationManager","css!DS/Leaflet/MPMapView.css","DS/Leaflet/LeafletLoader","css!DS/Leaflet/Leaflet.css","DS/Leaflet/MarkerClusterLoader","css!DS/Leaflet/assets/plugin/MarkerCluster/MarkerCluster.Default.css","css!DS/Leaflet/assets/plugin/MarkerCluster/MarkerCluster.css",],function(k,i,g,q,b,a,c,h,j,o){var n="Leaflet/assets/images",l="http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",m=[48.866667,2.333333],f=[[90,-180],[-90,180]],d=1,p=18,e=12;return k.extend({init:function(r){r=r||{};this._parent(r);this._imagePath=typeof r.imagePath==="string"?r.imagePath:g.getWebappsBaseUrl()+n;this._tileUrl=typeof r.imagePath==="string"?r.titleUrl:l;this._defaultPosition=(i.is(r.defaultPosition,"array")&&typeof r.defaultPosition[0]==="number"&&typeof r.defaultPosition[1]==="number")?r.defaultPosition:m;this._defaultZoom=typeof r.defaultZoom==="number"?r.defaultZoom:e;this._maxZoom=typeof r.maxZoom==="number"?r.maxZoom:p;this._minZoom=typeof r.minZoom==="number"?r.minZoom:d;this._scrollWheelZoom=typeof r.scrollWheelZoom==="boolean"?r.scrollWheelZoom:true;this._onCenterChangedCB=typeof r.onCenterChangedCB==="function"?r.onCenterChangedCB:null;this._onMapLoadedCB=typeof r.onMapLoadedCB==="function"?r.onMapLoadedCB:null;this._geolocation=typeof r.geolocation==="boolean"?r.geolocation:true;this._geolocationOnStart=typeof r.geolocationOnStart==="boolean"?r.geolocationOnStart:this._true;this._displayPosition=typeof r.displayPosition==="boolean"?r.displayPosition:true;this._displayAccuracy=typeof r.displayAccuracy==="boolean"?r.displayAccuracy:true;this._locationIsDisplay=typeof r._locationIsDisplay==="boolean"?r._locationIsDisplay:false;this._map=null;this._delegate=null;this._geoManager=null;this._userMarker=null;this.centerHasChanged=this.centerHasChanged.bind(this);this.onMapLoaded=this.onMapLoaded.bind(this);this._updateCurrentLocation=this._updateCurrentLocation.bind(this);this._buildSkeleton()},_buildSkeleton:function(){this.elements.container=i.createElement("div",{"class":"mp-map"})},loadMap:function(){L.Icon.Default.imagePath=this._imagePath;var s=i.createElement("div",{"class":"map-container",styles:{height:this.elements.container.style.height,}}).inject(this.elements.container);this._map=new L.Map(s,{center:this._defaultPosition,zoom:this._defaultZoom,scrollWheelZoom:this._scrollWheelZoom,maxZoom:this._maxZoom,minZoom:this._minZoom,maxBounds:f,}).on("moveend",this.centerHasChanged).whenReady(this.onMapLoaded);this._tileLayer=L.tileLayer(this._tileUrl,{attribution:"3DS",maxZoom:this._maxZoom,}).addTo(this._map);if(this._geolocation){this._initGeolocationManager()}var r=s.querySelector(".leaflet-control-attribution a");if(r){i.extendElement(r).setAttributes({target:"_blank"})}},onShow:function(){if(this._map){this._map._onResize()}},centerHasChanged:function(r){if(this._onCenterChangedCB){this._onCenterChangedCB(r)}},onMapLoaded:function(r){if(this._onMapLoadedCB){this._onMapLoadedCB(r)}},setMapPosition:function(r,s){if(r){if(!s){s=this._defaultZoom}if(this._map){this._map.setView(r,s)}}},setTileUrl:function(r){this._tileUrl=r;this._tileLayer.setUrl(r)},zoomOnPositions:function(r){r=r||{};if(this._map&&r.length){this._map.fitBounds(r,{padding:[25,25]})}},addMarker:function(t,s){var r=null;if(t&&this._map){r=L.marker(t,s);r.addTo(this._map)}return r},removeMarker:function(r){if(r){this._map.removeLayer(r)}},addPolygon:function(r,s){return i.is(r,"array")&&this._map?L.polygon(r,s).addTo(this._map):null},removePolygon:function(r){if(this._map){this._map.removeLayer(r)}},getBounds:function(){return this._map?this._map.getBounds():null},getCenter:function(){return this._map?this._map.getCenter():null},getSize:function(){return this._map?this._map.getSize():null},locationHasChanged:function(r){this._updateCurrentLocation(r)},_initGeolocationManager:function(){this._geoManager=new q();this._geoManager.setDelegate(this);var r=this._buildGeolocationControl();this._map.addControl(new r());if(this._geolocationOnStart){this._geoManager.getCurrentLocation(this._updateCurrentLocation)}},_buildGeolocationControl:function(){var r=function(){if(this._geoManager){var t=true;if(this._userMarker){var s=this._userMarker.getLatLng();t=this._map.getBounds().contains(s)}if(this._locationIsDisplay&&t){this._removeLocationMarker()}else{this._geoManager.getCurrentLocation(this._updateCurrentLocation)}}}.bind(this);return L.Control.extend({options:{position:"topleft",callback:r,},onAdd:function(t){var s=L.DomUtil.create("div","leaflet-bar leaflet-control leaflet-control-custom");this._link=L.DomUtil.create("a","leaflet-bar-part leaflet-bar-part-single",s);this._link.href="#";this._icon=L.DomUtil.create("span","fonticon fonticon-location locate-icon",this._link);L.DomEvent.on(this._link,"click",this.options.callback,this).on(this._link,"click",L.DomEvent.stopPropagation).on(this._link,"click",L.DomEvent.preventDefault).on(this._link,"dblclick",L.DomEvent.stopPropagation);return s},})},_updateCurrentLocation:function(s){if(s){var r=s.coords;if(this._displayPosition){this._addLocationMarker(r)}this.setMapPosition([r.latitude,r.longitude],10)}},_addLocationMarker:function(s){var t=s||{};var v=new L.LatLng(t.latitude,t.longitude);if(this._userMarker){this._userMarker.setLatLng(v)}else{var u=L.icon({iconUrl:this._imagePath+"/picto_geo.png",iconSize:[24,24],});this._userMarker=L.marker(v,{icon:u});this._userMarker.addTo(this._map)}if(this._displayAccuracy){var r=typeof t.accuracy==="undefined"?0:t.accuracy;if(this._accuracyCircle){this._accuracyCircle.setLatLng(v);this._accuracyCircle.setRadius(r)}else{this._accuracyCircle=L.circle(v,r,{color:"#036CC7",weight:1,fillColor:"#7ACADC",fillOpacity:0.2,}).addTo(this._map)}}this._locationIsDisplay=true},_removeLocationMarker:function(){if(this._userMarker){this._map.removeLayer(this._userMarker);this._userMarker=null}if(this._accuracyCircle){this._map.removeLayer(this._accuracyCircle);this._accuracyCircle=null}this._locationIsDisplay=false},})});