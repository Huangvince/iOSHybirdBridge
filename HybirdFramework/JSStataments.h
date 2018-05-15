#ifndef JSStataments_h
#define JSStataments_h

static NSString *const CAN_NOT_FIND_HTML = @"<html><body><h1>Can not Find target HTML</h1></body></html>";
static NSString *const JS_BRIDGE_OBJECT = @"window.APPBridges = {__callbackCollections__:{},usePromise:false,__throwException__:function(name,message){throw new Error(name,message);}};";

#define SET_JS_CALL_OC_METHOD(method,...) [NSString stringWithFormat:@"window.APPBridges.__%@ = window.webkit.messageHandlers.%@;window.APPBridges.%@ = function(message,cb){var uniqueCallbackid = 'callback__' + Date.now();if(this.usePromise){ var that = this; return new Promise(function(resolve,reject){that.__callbackCollections__[uniqueCallbackid] = function(err,data){if(err){reject(err);return;}resolve(data);};message.callbackid = uniqueCallbackid;that.__%@.postMessage(message);})}if(cb){this.__callbackCollections__[uniqueCallbackid] =cb; message.callbackid = uniqueCallbackid;}this.__%@.postMessage(message);}",method,method,method,method,method]

#define DELETE_JS_CALLBACK_IN_CALLBACK_COLLECTIONS(callbackId) [NSString stringWithFormat:@"delete window.APPBridges.__callbackCollections__['%@']",callbackId]

#define THROW_EXCEPTION(name,message) [NSString stringWithFormat:@"window.APPBridges.__throwException(%@,%@)",name,message]

#define EXEC_CALLBACK(callbackid,err) [NSString stringWithFormat:@"window.APPBridges.__callbackCollections__['%@'](%@",callbackid,err]

#endif /* JSStataments_h */
