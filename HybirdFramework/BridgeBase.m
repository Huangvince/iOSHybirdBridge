#import "BridgeBase.h"
#import "JSStataments.h"
#import "Utils.h"

@implementation BridgeBase

- (NSString *)baseJavascriptString:(NSString *)callback andStatus:(ResponseStatus) callBackType{
    return EXEC_CALLBACK(callback,callBackType == ResponseStatus_OK ? @"null":@"{}");
}

- (void)deleteCallbackCollectionsfiled:(NSString *)callback{
    [self execJS:DELETE_JS_CALLBACK_IN_CALLBACK_COLLECTIONS(callback)];
}

- (void)execJS:(NSString *)javascript{
    [self.webView evaluateJavaScript:javascript completionHandler:nil];
}

- (void)execJsCallbackFunctionByCallbackId:(NSString *)callback andStatus:(ResponseStatus) callBackType{
    NSString *baseJavascript = [self baseJavascriptString:callback andStatus:callBackType];
    [self execJS:[NSString stringWithFormat:@"%@);",baseJavascript]];
    [self deleteCallbackCollectionsfiled:callback];
}

- (void)execJsCallbackFunctionByCallbackId:(NSString *)callback messageWithReturnDictionary:(NSDictionary *)message andStatus:(ResponseStatus) callBackType{
    NSString *baseJavascript = [self baseJavascriptString:callback andStatus:callBackType];
    [self execJS:[NSString stringWithFormat:@"%@,%@);",baseJavascript,[Utils translateToJSON:message]]];
    [self deleteCallbackCollectionsfiled:callback];
}

- (void)execJsCallbackFunctionByCallbackId:(NSString *)callback messageWithReturnArray:(NSArray *)message andStatus:(ResponseStatus) callBackType{
    NSString *baseJavascript = [self baseJavascriptString:callback andStatus:callBackType];
    [self execJS:[NSString stringWithFormat:@"%@,%@);",baseJavascript,[Utils translateToJSON:message]]];
    [self deleteCallbackCollectionsfiled:callback];
}

- (void)execJsCallbackFunctionByCallbackId:(NSString *)callback messageWithReturnNumber:(NSNumber *)message andStatus:(ResponseStatus) callBackType{
    NSString *baseJavascript = [self baseJavascriptString:callback andStatus:callBackType];
    [self execJS:[NSString stringWithFormat:@"%@,%@);",baseJavascript,message]];
    [self deleteCallbackCollectionsfiled:callback];
}

- (void)execJsCallbackFunctionByCallbackId:(NSString *)callback messageWithReturnString:(NSString *)message andStatus:(ResponseStatus) callBackType{
    NSString *baseJavascript = [self baseJavascriptString:callback andStatus:callBackType];
    [self execJS:[NSString stringWithFormat:@"%@,'%@');",baseJavascript,message]];
    [self deleteCallbackCollectionsfiled:callback];
}

- (void)execJsCallbackFunctionByCallbackId:(NSString *)callback messageWithReturnBoolean:(BOOL)message andStatus:(ResponseStatus) callBackType{
    NSString *baseJavascript = [self baseJavascriptString:callback andStatus:callBackType];
    [self execJS:[NSString stringWithFormat:@"%@,%@);",baseJavascript,message?@"true":@"false"]];
    [self deleteCallbackCollectionsfiled:callback];
}
@end
