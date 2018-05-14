#ifndef JSStataments_h
#define JSStataments_h

static NSString *const JS_BRIDGE_OBJECT = @"window.APPBridges = {__callbackCollections__:{},usePromise:false};";

#define SET_JS_CALL_OC_METHOD(method,...) [NSString stringWithFormat:@"window.APPBridges.__%@ = window.webkit.messageHandlers.%@;window.APPBridges.%@ = function(message,cb){var uniqueCallbackid = 'callback__' + Date.now();if(this.usePromise){return new Promise(function(resolve,reject){this.__callbackCollections__[uniqueCallbackid] = function(err,data){if(err){reject(err);return;}resolve(data);};message.callbackid = uniqueCallbackid;this.__%@.postMessage(message);})}if(cb){this.__callbackCollections__[uniqueCallbackid] =cb; message.callbackid = uniqueCallbackid;}this.__%@.postMessage(message);}",method,method,method,method]

#define DELETE_JS_CALLBACK_IN_CALLBACK_COLLECTIONS(callbackId) [NSString stringWithFormat:@"delete window.APPBridges.__callbackCollections__['%@']",callbackId]

#endif /* JSStataments_h */
