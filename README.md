# iOSHybirdBridge

## Feature

1. Using WKWebView
2. Config customer plugins
3. Config Inject common js code

## How to use it?

1. Integration  HybirdFramework, create www bundle folder
2. Create controller extend WKWebViewController
3. [[viewController alloc] initWithHTML:path]; or [[[viewController alloc] init] initWKWebviewHTML:path]

## How to Config JSBridge?

1. in your project plist create `JSBridgeConfig(NSDictionary)`
2. if you want to inject common scripts you can create `injectScripts(Array)` and then  add `item(NSDictionary)` included `path(NSString)`  which ignore www/ folder and `injectTime (Boolean)` NO is inject when document load  , YES is inject after document loaded.Both required!!!
3. If you want to add customer plugins you can create `plugins(Array)` and then add `item(NSDictionary)` included `ExportJsName(String)` which you js code call function name , `ClassName(String)` which you OC code. Both required!!!

## How to call native?

1. In JS, When your init the controller, WKWebViewController will inject window.APPBridges Object in webView, so you can call `window.APPBridges.ExportJsName({method:methodName,params:{}},callbackFunction);`callbackFunction is options. if you want to use `promise` you can set `window.APPBridges.usePromise = true;`

2. In Native, you should create a class which need extend `BridgeBase Class`. In this class  it have 2 properties and 6 instance methods.

   ```objective-c
   2 properties:webView and viewController
   6 instance methods:
   - (void)execJsCallbackFunctionByCallbackId:(NSString *)callback andStatus:(ResponseStatus) callBackType;
   - (void)execJsCallbackFunctionByCallbackId:(NSString *)callback messageWithReturnDictionary:(NSDictionary *)message andStatus:(ResponseStatus) callBackType;
   - (void)execJsCallbackFunctionByCallbackId:(NSString *)callback messageWithReturnArray:(NSArray *)message andStatus:(ResponseStatus) callBackType;
   - (void)execJsCallbackFunctionByCallbackId:(NSString *)callback messageWithReturnNumber:(NSNumber *)message andStatus:(ResponseStatus) callBackType;
   - (void)execJsCallbackFunctionByCallbackId:(NSString *)callback messageWithReturnString:(NSString *)message andStatus:(ResponseStatus) callBackType;
   - (void)execJsCallbackFunctionByCallbackId:(NSString *)callback messageWithReturnBoolean:(BOOL)message andStatus:(ResponseStatus) callBackType;	
   ```

3. After extend BridgeBase Class, you can wirte you instance methods,  one limit in instance , only have one param and which need BridgeModel type. BridgeModel included params and callbackId.params is you send by js code used `window.APPBridges.ExportJsName({method:methodName,params:{}});`callbackId just when you call this function, APPBridge create a unique id.

## To be continue

Thinking 