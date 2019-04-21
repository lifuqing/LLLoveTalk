//
//  LLIAPShare.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/21.
//

#import "LLIAPShare.h"

@implementation LLIAPShare

+ (LLIAPShare *) sharedHelper {
    static LLIAPShare * _sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHelper = [[LLIAPShare alloc] init];
        _sharedHelper.iap = nil;
    });
    return _sharedHelper;
}

+(id)toJSON:(NSString *)json
{
    NSError* e = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData: [json dataUsingEncoding:NSUTF8StringEncoding]
                                                    options: NSJSONReadingMutableContainers
                                                      error: &e];
    
    if(e==nil) {
        return jsonObject;
    }
    else {
        NSLog(@"%@",[e localizedDescription]);
        return nil;
    }
    
}

@end
