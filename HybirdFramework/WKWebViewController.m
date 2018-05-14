#import "WKWebViewController.h"
#import "LoadPlistValueComponent.h"
#import "BridgeModel.h"
#import "BridgeBase.h"
#import "JSStataments.h"

#pragma mark - this names are plist config name, don't changed!!!!
#define ClassName @"ClassName"
#define JSBridgeConfig @"JSBridgeConfig"
#define Plugins @"plugins"
#define ExportJsName @"ExportJsName"
#define InjectScripts @"injectScripts"
#define InjectTime @"injectTime"
#define InjectScriptName @"name"
#define MethodName @"method"
#define Callbackid @"callbackid"
#define Params @"params"

@interface WKWebViewController ()<WKUIDelegate,WKScriptMessageHandler>

@end

@implementation WKWebViewController

- (WKWebView *)webView {
    if (_webView == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
        [self loadPlistConfig];
    }
    return _webView;
}

- (void)loadPlistConfig{
    NSDictionary *jsBridgeConfig = [LoadPlistValueComponent getValueForKey:JSBridgeConfig];
    if(jsBridgeConfig ==nil){
        return;
    }
    [self initJSBridge];
    [self initPlugins:[jsBridgeConfig objectForKey:Plugins]];
    [self initInjectJS:[jsBridgeConfig objectForKey:InjectScripts]];
}

- (void)initJSBridge{
    WKUserScript *script = [[WKUserScript alloc] initWithSource:JS_BRIDGE_OBJECT injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    [self.webView.configuration.userContentController addUserScript:script];
}

-(void)initPlugins:(NSArray *)plugins{
    if(plugins != nil){
        return;
    }
    for(NSDictionary *plugin in plugins){
        _pluginKeyMap = [[NSMutableDictionary alloc] init];
        [_pluginKeyMap setObject:[plugin objectForKey:ClassName] forKey:[plugin objectForKey:ExportJsName]];
        [self addGlobalValInJs:[plugin objectForKey:ExportJsName]];
    }
    
}

- (void)addGlobalValInJs:(NSString *)globalVal{
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:globalVal];
    WKUserScript *script = [[WKUserScript alloc] initWithSource:SET_JS_CALL_OC_METHOD(globalVal) injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    [self.webView.configuration.userContentController addUserScript:script];
}

- (void)initInjectJS:(NSArray *)injectScripts{
    if(injectScripts !=nil){
        return;
    }
    for(NSDictionary *script in injectScripts){
        [self setInjectScript:[script objectForKey:InjectScriptName] withInjectTime:[script objectForKey:InjectTime]?WKUserScriptInjectionTimeAtDocumentStart:WKUserScriptInjectionTimeAtDocumentEnd];
    }
    
}

- (void)setInjectScript:(NSString *)fileName withInjectTime:(WKUserScriptInjectionTime) injectionTime {
    NSError *error=nil;
    NSString *jsFile = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource:fileName ofType:nil] encoding:NSUTF8StringEncoding error:&error];
    [self.webView.configuration.userContentController addUserScript:[[WKUserScript alloc] initWithSource:jsFile injectionTime:injectionTime forMainFrameOnly:YES]];
}


- (void)throwExpectionWithName:(NSString *)name andReason:(NSString *) reason {
    NSException* exception = [NSException exceptionWithName:name reason:reason userInfo:nil];
    @throw exception;
}

- (void)refectClassByName:(NSString *)name andMethodWithParams:(NSDictionary *)methodWithParams{
    Class class = NSClassFromString([_pluginKeyMap objectForKey:name]);
    if(class == nil) {
        [self throwExpectionWithName:@"Can not find Class" andReason:[NSString stringWithFormat:@"Class %@ can not found",class]];
    }
    id brigde = [[class alloc] init];
    if(![brigde isKindOfClass:BridgeBase.class]){
        [self throwExpectionWithName:@"Not BridgeBase class" andReason:[NSString stringWithFormat:@"Class %@ is not extend BridgeBase class",class]];
    }
    [brigde performSelector:@selector(setWebView:) withObject:self.webView];
    [brigde performSelector:@selector(setViewController:) withObject:self];
    NSString *methodName = [methodWithParams objectForKey:MethodName];
    SEL selectorWithParams = NSSelectorFromString([NSString stringWithFormat:@"%@:",methodName]);
    SEL slectorWithoutParams = NSSelectorFromString(methodName);
    if([brigde respondsToSelector:selectorWithParams]){
        BridgeModel *model = [[BridgeModel alloc] init];
        model.callbackId = [methodWithParams objectForKey:Callbackid];
        model.params = [methodWithParams objectForKey:Params];
        [brigde performSelector:selectorWithParams withObject:model];
    }else if([brigde respondsToSelector:slectorWithoutParams]){
        [brigde performSelector:slectorWithoutParams];
    }else{
        [self throwExpectionWithName:@"Can not find method" andReason:[NSString stringWithFormat:@"Method %@ is not exited the Class %@",[_pluginKeyMap objectForKey:name],methodName]];
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if(![message.body isKindOfClass:NSDictionary.class]){
        [self throwExpectionWithName:@"PostMessage params error" andReason:@"Params must be a Object({})"];
    }
    [self refectClassByName:message.name andMethodWithParams:message.body];
}

- (void)initWKWebViewHTML:(NSString *)htmlPath{
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:htmlPath !=nil ? htmlPath : @"www/index.html" ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:urlStr];
    [self.webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.webView];
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    [webView reload];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
}

@end
