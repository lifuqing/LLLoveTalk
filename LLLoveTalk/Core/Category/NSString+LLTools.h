//
//  NSString+LLTools.h
//  LLAiLove
//
//  Created by lifuqing on 2019/4/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LLTools)
+ (NSString *)base64StringFromData:(NSData *)data;

- (NSString *)sha1;
- (NSString *)md5Digest;
@end

NS_ASSUME_NONNULL_END
