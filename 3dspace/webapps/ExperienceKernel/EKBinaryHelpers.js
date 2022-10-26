if(typeof define==="undefined"){define=function(e,d,f){BinaryHelpers=f();define=undefined}}define("DS/ExperienceKernel/EKBinaryHelpers",[],function(){var e={};e.BinaryWriter=function(m){this.arrayBuffer=new ArrayBuffer(m||0);this.dataView=new DataView(this.arrayBuffer);this.offset=0};var a=function(o,p){if(o.arrayBuffer.byteLength<o.offset+p){var m=o.arrayBuffer.byteLength+o.arrayBuffer.byteLength/2;if(m<o.offset+p){m=o.offset+p}m=Math.ceil(m);var n=new Uint8Array(m);n.set(new Uint8Array(o.arrayBuffer));o.arrayBuffer=n.buffer;o.dataView=new DataView(o.arrayBuffer)}};e.BinaryWriter.prototype.tell=function(){return this.offset};e.BinaryWriter.prototype.seek=function(m){if(this.arrayBuffer.byteLength>=m){this.offset=m+0}return this};e.BinaryWriter.prototype.writeInt8=function(m){a(this,1);this.dataView.setInt8(this.offset,m);this.offset++;return this};e.BinaryWriter.prototype.writeUint8=function(m){a(this,1);this.dataView.setUint8(this.offset,m);this.offset++;return this};e.BinaryWriter.prototype.writeInt16=function(m){a(this,2);this.dataView.setInt16(this.offset,m,true);this.offset+=2;return this};e.BinaryWriter.prototype.writeUint16=function(m){a(this,2);this.dataView.setUint16(this.offset,m,true);this.offset+=2;return this};e.BinaryWriter.prototype.writeInt32=function(m){a(this,4);this.dataView.setInt32(this.offset,m,true);this.offset+=4;return this};e.BinaryWriter.prototype.writeUint32=function(m){a(this,4);this.dataView.setUint32(this.offset,m,true);this.offset+=4;return this};e.BinaryWriter.prototype.writeInt64=function(p){a(this,8);var m=Math.pow(2,32);var n=Math.floor(p/m);var o=p-n*m;if(p<0){n+=m}this.dataView.setUint32(this.offset,o,true);this.offset+=4;this.dataView.setUint32(this.offset,n,true);this.offset+=4;return this};e.BinaryWriter.prototype.writeUint64=function(p){a(this,8);var m=Math.pow(2,32);var n=Math.floor(p/m);var o=p-n*m;this.dataView.setUint32(this.offset,o,true);this.offset+=4;this.dataView.setUint32(this.offset,n,true);this.offset+=4;return this};e.BinaryWriter.prototype.writeFloat=function(m){a(this,4);this.dataView.setFloat32(this.offset,m,true);this.offset+=4;return this};e.BinaryWriter.prototype.writeDouble=function(m){a(this,8);this.dataView.setFloat64(this.offset,m,true);this.offset+=8;return this};e.BinaryWriter.prototype.writeChar=function(m){a(this,1);this.dataView.setInt8(this.offset,m.charCodeAt(0));this.offset++;return this};e.BinaryWriter.prototype.writeBool=function(m){a(this,1);this.dataView.setUint8(this.offset,m?1:0);this.offset++;return this};e.BinaryWriter.prototype.writeNodeId=function(m){if(m.isConnected()){this.writeString(m.impl.nodeImpl.ip);this.writeInt32(m.impl.nodeImpl.port);this.writeString(m.impl.nodeImpl.pool);this.writeInt32(m.impl.ws.name.hypervisorId);this.writeInt32(m.impl.ws.name.id)}return this};e.BinaryWriter.prototype.writeString=function(o){o=o||"";a(this,4*o.length+4);var m=unescape(encodeURIComponent(o));this.writeUint32(m.length);for(var n=0;n<m.length;++n){this.dataView.setUint8(this.offset,m.charCodeAt(n));this.offset++}return this};e.BinaryWriter.prototype.writeStrings=function(n){n=n||[];for(var m=0;m<n.length;++m){this.writeString(n[m])}return this};function i(m,n){if(m instanceof n){return m}if(m.buffer instanceof ArrayBuffer){return new n(m.buffer,m.byteOffset,m.byteLength)}return new n(m)}e.BinaryWriter.prototype.writeBoolArray=function(m){return this.writeUint8Array(m)};e.BinaryWriter.prototype.writeUint8Array=function(n){n=i(n,Uint8Array);a(this,n.byteLength);var m=new Uint8Array(this.arrayBuffer);m.set(n,this.offset);this.offset+=n.byteLength;return this};e.BinaryWriter.prototype.writeInt8Array=function(m){m=i(m,Int8Array);return this.writeUint8Array(m)};e.BinaryWriter.prototype.writeUint16Array=function(m){m=i(m,Uint16Array);return this.writeUint8Array(m)};e.BinaryWriter.prototype.writeInt16Array=function(m){m=i(m,Int16Array);return this.writeUint8Array(m)};e.BinaryWriter.prototype.writeUint32Array=function(m){m=i(m,Uint32Array);return this.writeUint8Array(m)};e.BinaryWriter.prototype.writeInt32Array=function(m){m=i(m,Int32Array);return this.writeUint8Array(m)};e.BinaryWriter.prototype.writeFloatArray=function(m){m=i(m,Float32Array);return this.writeUint8Array(m)};e.BinaryWriter.prototype.writeDoubleArray=function(m){m=i(m,Float64Array);return this.writeUint8Array(m)};e.BinaryWriter.prototype.writeArrayBuffer=function(m){return this.writeUint8Array(m)};e.BinaryWriter.prototype.writeKeys=function(o,m){this.writeUint32(m.port);this.writeString(m.hostname);this.writeUint64(o.length);for(var n=0;n<o.length;++n){if(o[n].get===undefined){this.writeUint32(o[n].low);this.writeUint32(o[n].high)}else{this.writeUint64(o[n].get())}}};e.BinaryWriter.prototype.createArrayBuffer=function(){var m=this.arrayBuffer;if(this.offset!==this.arrayBuffer.byteLength){m=this.arrayBuffer.slice(0,this.offset)}this.arrayBuffer=new ArrayBuffer(0);this.offset=0;return m};e.BinaryReader=function(m){this.dataView=new DataView(m);this.offset=0};e.BinaryReader.prototype.getSize=function(){return this.dataView.byteLength};e.BinaryReader.prototype.tell=function(){return this.offset};e.BinaryReader.prototype.seek=function(m){this.offset=m+0;return this};var g=function(m){try{return m()}catch(n){}};e.BinaryReader.prototype.readBool=function(){var m=this;return g(function(){var n=m.dataView.getUint8(m.offset);m.offset++;return n!==0})};e.BinaryReader.prototype.readInt8=function(){var m=this;return g(function(){var n=m.dataView.getInt8(m.offset);m.offset++;return n})};e.BinaryReader.prototype.readUint8=function(){var m=this;return g(function(){var n=m.dataView.getUint8(m.offset);m.offset++;return n})};e.BinaryReader.prototype.readInt16=function(){var m=this;return g(function(){var n=m.dataView.getInt16(m.offset,true);m.offset+=2;return n})};e.BinaryReader.prototype.readUint16=function(){var m=this;return g(function(){var n=m.dataView.getUint16(m.offset,true);m.offset+=2;return n})};e.BinaryReader.prototype.readInt32=function(){var m=this;return g(function(){var n=m.dataView.getInt32(m.offset,true);m.offset+=4;return n})};e.BinaryReader.prototype.readUint32=function(){var m=this;return g(function(){var n=m.dataView.getUint32(m.offset,true);m.offset+=4;return n+0})};e.BinaryReader.prototype.readInt64=function(){var m=this;return g(function(){var p=m.dataView.getUint32(m.offset,true);m.offset+=4;var o=m.dataView.getUint32(m.offset,true);m.offset+=4;var n=Math.pow(2,32);if(o<Math.pow(2,31)){return p+n*o}return -((n-p)+n*(n-1-o))})};e.BinaryReader.prototype.readUint64=function(){var m=this;return g(function(){var o=m.dataView.getUint32(m.offset,true);m.offset+=4;var n=m.dataView.getUint32(m.offset,true);m.offset+=4;return o+Math.pow(2,32)*n})};e.BinaryReader.prototype.readFloat=function(){var m=this;return g(function(){var n=m.dataView.getFloat32(m.offset,true);m.offset+=4;return n})};e.BinaryReader.prototype.readDouble=function(){var m=this;return g(function(){var n=m.dataView.getFloat64(m.offset,true);m.offset+=8;return n})};e.BinaryReader.prototype.readChar=function(){var m=this;return g(function(){var n=m.dataView.getInt8(m.offset);m.offset++;return String.fromCharCode(n)})};e.BinaryReader.prototype.readString=function(n){var m=this;return g(function(){if(typeof n!=="number"){n=m.dataView.getUint32(m.offset,true);m.offset+=4}var p="";for(var o=0;o<n;++o){p+=String.fromCharCode(m.dataView.getUint8(m.offset));m.offset++}return decodeURIComponent(escape(p))})};e.BinaryReader.prototype.readStrings=function(o){var n=[];for(var m=0;m<o;++m){n.push(this.readString())}return n};e.BinaryReader.prototype.readArrayBuffer=function(n){var m=this;return g(function(){var o;if(n>0){o=m.dataView.buffer.slice(m.offset,m.offset+n);m.offset+=n}else{o=new ArrayBuffer(0)}return o})};e.BinaryReader.prototype.readBoolArray=function(o){var n=Uint8Array.BYTES_PER_ELEMENT;var m=this.readArrayBuffer(n*o);return new Uint8Array(m)};e.BinaryReader.prototype.readUint8Array=function(o){var n=Uint8Array.BYTES_PER_ELEMENT;var m=this.readArrayBuffer(n*o);return new Uint8Array(m)};e.BinaryReader.prototype.readInt8Array=function(o){var n=Int8Array.BYTES_PER_ELEMENT;var m=this.readArrayBuffer(n*o);return new Int8Array(m)};e.BinaryReader.prototype.readUint16Array=function(o){var n=Uint16Array.BYTES_PER_ELEMENT;var m=this.readArrayBuffer(n*o);return new Uint16Array(m)};e.BinaryReader.prototype.readInt16Array=function(o){var n=Int16Array.BYTES_PER_ELEMENT;var m=this.readArrayBuffer(n*o);return new Int16Array(m)};e.BinaryReader.prototype.readUint32Array=function(o){var n=Uint32Array.BYTES_PER_ELEMENT;var m=this.readArrayBuffer(n*o);return new Uint32Array(m)};e.BinaryReader.prototype.readInt32Array=function(o){var n=Int32Array.BYTES_PER_ELEMENT;var m=this.readArrayBuffer(n*o);return new Int32Array(m)};e.BinaryReader.prototype.readFloatArray=function(o){var n=Float32Array.BYTES_PER_ELEMENT;var m=this.readArrayBuffer(n*o);return new Float32Array(m)};e.BinaryReader.prototype.readDoubleArray=function(o){var n=Float64Array.BYTES_PER_ELEMENT;var m=this.readArrayBuffer(n*o);return new Float64Array(m)};e.BinaryReader.prototype.readKeys=function(p,n){var m=this.offset;this.readUint32();this.readString();var r=this.readUint64();var q=this.offset-m+r*8;var o=this.dataView.buffer.slice(m,m+q);this.offset=m+q;p.readKeys(o,n)};e.BinaryReader.prototype.readNodeId=function(o){var q=this.readString();var m=this.readInt32();var n=this.readString();var p=this.readInt32();var r=this.readInt32();return o.impl.unserializeNodeId(o,q,m,n,p,r)};var d=16980;var k=1;var b=Object.freeze({booleanType:0,int8Type:1,uint8Type:2,int16Type:3,uint16Type:4,int32Type:5,uint32Type:6,int64Type:7,uint64Type:8,floatType:9,doubleType:10,stringType:11,stringsType:12,booleanArrayType:13,int8ArrayType:14,uint8ArrayType:15,int16ArrayType:16,uint16ArrayType:17,int32ArrayType:18,uint32ArrayType:19,floatArrayType:22,doubleArrayType:23,binaryType:24});e.TypedBinaryWriter=function(m){this.writer=new e.BinaryWriter(m);this.writer.writeUint16(d);this.writer.writeUint16(k)};var f={writeBool:b.booleanType,writeInt8:b.int8Type,writeUint8:b.uint8Type,writeInt16:b.int16Type,writeUint16:b.uint16Type,writeInt32:b.int32Type,writeUint32:b.uint32Type,writeInt64:b.int64Type,writeUint64:b.uint64Type,writeFloat:b.floatType,writeDouble:b.doubleType,writeString:b.stringType,writeStrings:b.stringsType,writeBoolArray:b.booleanArrayType,writeInt8Array:b.int8ArrayType,writeUint8Array:b.uint8ArrayType,writeInt16Array:b.int16ArrayType,writeUint16Array:b.uint16ArrayType,writeInt32Array:b.int32ArrayType,writeUint32Array:b.uint32ArrayType,writeFloatArray:b.floatArrayType,writeDoubleArray:b.doubleArrayType,writeArrayBuffer:b.binaryType};function l(m){return function(n,q){this.writer.writeString(n);var o=f[m];this.writer.writeUint8(o);if(o>=b.stringsType){var p=q.length!==undefined?q.length:q.byteLength||0;this.writer.writeUint64(p)}e.BinaryWriter.prototype[m].call(this.writer,q);return this}}for(var h in f){if(f.hasOwnProperty(h)){e.TypedBinaryWriter.prototype[h]=l(h)}}e.TypedBinaryWriter.prototype.createArrayBuffer=function(){return this.writer.createArrayBuffer()};e.TypedBinaryReader=function(m){this.arrayBuffer=m};function j(m){return function(){var n=this.readUint64();return m.call(this,n)}}var c={};c[b.booleanType]={read:e.BinaryReader.prototype.readBool,type:"bool"};c[b.int8Type]={read:e.BinaryReader.prototype.readInt8,type:"int8"};c[b.uint8Type]={read:e.BinaryReader.prototype.readUint8,type:"uint8"};c[b.int16Type]={read:e.BinaryReader.prototype.readInt16,type:"int16"};c[b.uint16Type]={read:e.BinaryReader.prototype.readUint16,type:"uint16"};c[b.int32Type]={read:e.BinaryReader.prototype.readInt32,type:"int32"};c[b.uint32Type]={read:e.BinaryReader.prototype.readUint32,type:"uint32"};c[b.int64Type]={read:e.BinaryReader.prototype.readInt64,type:"int64"};c[b.uint64Type]={read:e.BinaryReader.prototype.readUint64,type:"uint64"};c[b.floatType]={read:e.BinaryReader.prototype.readFloat,type:"float"};c[b.doubleType]={read:e.BinaryReader.prototype.readDouble,type:"double"};c[b.stringType]={read:e.BinaryReader.prototype.readString,type:"string"};c[b.stringsType]={read:j(e.BinaryReader.prototype.readStrings),type:"strings"};c[b.booleanArrayType]={read:j(e.BinaryReader.prototype.readBoolArray),type:"boolArray"};c[b.uint8ArrayType]={read:j(e.BinaryReader.prototype.readUint8Array),type:"uint8Array"};c[b.int8ArrayType]={read:j(e.BinaryReader.prototype.readInt8Array),type:"int8Array"};c[b.uint16ArrayType]={read:j(e.BinaryReader.prototype.readUint16Array),type:"uint16Array"};c[b.int16ArrayType]={read:j(e.BinaryReader.prototype.readInt16Array),type:"int16Array"};c[b.uint32ArrayType]={read:j(e.BinaryReader.prototype.readUint32Array),type:"uint32Array"};c[b.int32ArrayType]={read:j(e.BinaryReader.prototype.readInt32Array),type:"int32Array"};c[b.floatArrayType]={read:j(e.BinaryReader.prototype.readFloatArray),type:"floatArray"};c[b.doubleArrayType]={read:j(e.BinaryReader.prototype.readDoubleArray),type:"doubleArray"};c[b.binaryType]={read:j(e.BinaryReader.prototype.readArrayBuffer),type:"arrayBuffer"};e.TypedBinaryReader.prototype.apply=function(r){var m=new e.BinaryReader(this.arrayBuffer);if(m.readUint16()!==d||m.readUint16()!==k){return false}var p=m.getSize();while(m.tell()<p){var o=m.readString();var n=c[m.readUint8()];var q=n?n.read.apply(m):undefined;if(q===undefined||!r.visit(o,q,n.type)){return false}}return true};return e});