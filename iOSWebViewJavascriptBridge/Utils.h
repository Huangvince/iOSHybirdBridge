//
//  Utils.h
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (id)getPlistValueForKey:(NSString *)key;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString *)translateToJSON:(id)object;

@end
