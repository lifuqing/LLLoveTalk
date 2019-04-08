//
//  UIDevice+LLTools.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (LLTools)
- (NSString *)machine;
- (NSNumber *)totalDiskSpace;
- (NSNumber *)freeDiskSpace;
- (NSString *)appName;
- (NSString *)appVersion;

- (NSString *) UUID;

//运营商+国家代码
- (NSString *)carrier;
- (NSString *) localIPAddress;

- (NSString *)defaultUserAgent;
@end

NS_ASSUME_NONNULL_END
