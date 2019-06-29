//
//  LLUser.h
//  LLAiLove
//
//  Created by lifuqing on 2019/4/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kUserInfoChangedNotification;
extern NSString *const kUserLoginStateChangedNotification;
extern NSString *const kUserVIPChangedNotification;

@interface LLUser : NSObject
@property (nonatomic, assign, getter=isLogin) BOOL login;

@property (nonatomic, copy, nullable) NSString *phone;
@property (nonatomic, copy, nullable) NSString *username;
///付费用户
@property (nonatomic, assign) BOOL ispaid;
///永久会员
@property (nonatomic, assign) BOOL isSuperVIP;
@property (nonatomic, assign) NSInteger remaindays;

+ (instancetype)sharedInstance;


- (void)logout;


- (void)sendCodeWithPhone:(NSString *)phone completion:(void (^ __nullable)(BOOL success, NSString *__nullable errorMsg))completion;
- (void)loginWithPhone:(NSString *)phone code:(NSString *)code completion:(void (^ __nullable)(BOOL success, NSString *__nullable errorMsg))completion;
- (void)modifyUserName:(NSString *)username completion:(void (^ __nullable)(BOOL success, NSString *__nullable errorMsg))completion;
- (void)fetchUserInfoCompletion:(void (^ __nullable)(BOOL success, NSString *__nullable errorMsg))completion;
@end

@interface LLUser (IAP)
- (void)uploadBuyProductId:(NSString *)productId receiptBase64:(NSString *)receiptBase64 completion:(void (^ __nullable)(BOOL success, NSString *__nullable errorMsg))completion;
@end
NS_ASSUME_NONNULL_END
