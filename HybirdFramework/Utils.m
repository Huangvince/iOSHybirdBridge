//
//  Utils.m
//

#import "Utils.h"

@implementation Utils

+ (id)getPlistValueForKey:(NSString *)key{
    if(key && key.length>0){
        return [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
    }
    return nil;
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    NSError *err = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&err];
    return err != nil ? nil :dic;
}

+ (NSString *)translateToJSON:(id)object{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    return error != nil ? nil : [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
