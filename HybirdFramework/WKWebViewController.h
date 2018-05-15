#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WKWebViewController : UIViewController

@property (nonatomic,strong)WKWebView  *webView;
@property (nonatomic,strong)NSMutableDictionary *pluginKeyMap;

- (void)initWKWebViewHTML:(NSString *)htmlPath;
- (instancetype)initWithHTML:(NSString*) htmlPath;

@end
