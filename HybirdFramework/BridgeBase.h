#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

typedef enum {
    ResponseStatus_ERROR = 0,
    ResponseStatus_OK
} ResponseStatus;

@interface BridgeBase : NSObject

@property(nonatomic,strong)WKWebView *webView;

@property(nonatomic,strong)UIViewController *viewController;

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
- (void)execJsCallbackFunctionByCallbackId:(NSString *)callback andStatus:(ResponseStatus) callBackType;
- (void)execJsCallbackFunctionByCallbackId:(NSString *)callback messageWithReturnDictionary:(NSDictionary *)message andStatus:(ResponseStatus) callBackType;
- (void)execJsCallbackFunctionByCallbackId:(NSString *)callback messageWithReturnArray:(NSArray *)message andStatus:(ResponseStatus) callBackType;
- (void)execJsCallbackFunctionByCallbackId:(NSString *)callback messageWithReturnNumber:(NSNumber *)message andStatus:(ResponseStatus) callBackType;
- (void)execJsCallbackFunctionByCallbackId:(NSString *)callback messageWithReturnString:(NSString *)message andStatus:(ResponseStatus) callBackType;
- (void)execJsCallbackFunctionByCallbackId:(NSString *)callback messageWithReturnBoolean:(BOOL)message andStatus:(ResponseStatus) callBackType;
@end
