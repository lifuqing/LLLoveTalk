//
//  LLIAPShare.h
//  LLAiLove
//
//  Created by lifuqing on 2019/4/21.
//

#import <Foundation/Foundation.h>
#import "LLIAPHelper.h"

NS_ASSUME_NONNULL_BEGIN
@interface LLIAPShare : NSObject

@property (nonatomic, strong, nullable) LLIAPHelper *iap;

+ (LLIAPShare *)sharedHelper;

+(id)toJSON:(NSString*)json;

@end
NS_ASSUME_NONNULL_END
