#import <Foundation/Foundation.h>

@interface BridgeModel : NSObject

@property(nonatomic,assign)NSString *callbackId;

@property(nonatomic,strong)NSDictionary *params;

@end
