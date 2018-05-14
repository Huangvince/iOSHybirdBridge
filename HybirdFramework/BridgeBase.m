#import "BridgeBase.h"
@implementation BridgeBase

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&err];
    if(err){
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


- (NSString *)translateToJSON:(id)object{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
        NSLog(@"json解析失败：%@",error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (NSString *)baseJavascriptString:(NSString *)callback andStatus:(ResponseStatus) callBackType{
  return [NSString stringWithFormat:@"window.APPBridges.__callbackCollections__['%@'](%@",callback,callBackType == ResponseStatus_OK ? @"1":@"0"];
}

- (void)deleteCallbackCollectionsfiled:(NSString *)callback{
    [self execJS:[NSString stringWithFormat:@"delete window.APPBridges.__callbackCollections__['%@']",callback]];
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
    [self execJS:[NSString stringWithFormat:@"%@,%@);",baseJavascript,[self translateToJSON:message]]];
    [self deleteCallbackCollectionsfiled:callback];
}


- (void)execJsCallbackFunctionByCallbackId:(NSString *)callback messageWithReturnArray:(NSArray *)message andStatus:(ResponseStatus) callBackType{
    NSString *baseJavascript = [self baseJavascriptString:callback andStatus:callBackType];
    [self execJS:[NSString stringWithFormat:@"%@,%@);",baseJavascript,[self translateToJSON:message]]];
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
