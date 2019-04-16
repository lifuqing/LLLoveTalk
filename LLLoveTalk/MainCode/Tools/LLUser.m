//
//  LLUser.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/5.
//

#import "LLUser.h"

@interface LLUserResponseModel : LLBaseResponseModel

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, assign) BOOL ispaid;
@property (nonatomic, assign) NSInteger remaindays;
@end

@implementation LLUserResponseModel
@end

NSString *const kUserInfoChangedNotification = @"kUserInfoChangedNotification";
NSString *const kUserLoginStateChangedNotification = @"kUserLoginStateChangedNotification";
NSString *const kUserVIPChangedNotification = @"kUserVIPChangedNotification";


NSString *const kUserIsLogin                = @"com.user.isLogin";
NSString *const kUsername                   = @"com.user.username";
NSString *const kUserPhone                  = @"com.user.phone";
NSString *const kUserIsVip                  = @"com.user.isVip";
NSString *const kUserRemainDays           = @"com.user.remaindays";

@implementation LLUser

+(instancetype)sharedInstance
{
    static id instance = nil;
    if (instance == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[[self class] alloc] init];
        });
    }
    
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        self.username   = [userDefaults objectForKey:kUsername];
        self.phone      = [userDefaults objectForKey:kUserPhone];
        self.ispaid     = [userDefaults boolForKey:kUserIsVip];
        self.remaindays  = [userDefaults integerForKey:kUserRemainDays];
        
        self.login = [userDefaults boolForKey:kUserIsLogin];
    }
    return self;
}


- (void)logout {
    self.login = NO;
    [self configWithModel:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginStateChangedNotification object:nil];
}


#pragma mark - public

- (void)sendCodeWithPhone:(NSString *)phone completion:(void (^ __nullable)(BOOL success, NSString *__nullable errorMsg))completion {
    LLURL *llurl = [[LLURL alloc] initWithParser:@"SendCodeParser" urlConfigClass:[LLLoveTalkURLConfig class]];
    [llurl.params setValue:phone forKey:@"phone"];
    [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:self success:^(NSDictionary *result, LLBaseResponseModel *model, BOOL isLocalCache) {
        if (completion) {
            completion(YES, @"验证码发送成功");
        }
    } failure:^(LLBaseResponseModel *model) {
        if (completion) {
            completion(NO, model.errorMsg ?: @"验证码发送失败");
        }
    }];
}

- (void)loginWithPhone:(NSString *)phone code:(NSString *)code completion:(void (^ __nullable)(BOOL success, NSString *__nullable errorMsg))completion {
    LLURL *llurl = [[LLURL alloc] initWithParser:@"LoginParser" urlConfigClass:[LLLoveTalkURLConfig class]];
    [llurl.params setValue:phone forKey:@"phone"];
    [llurl.params setValue:code forKey:@"code"];
    WEAKSELF();
    [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:self success:^(NSDictionary *result, LLBaseResponseModel *model, BOOL isLocalCache) {
        STRONGSELF();
        strongSelf.login = YES;
        [strongSelf configWithModel:(LLUserResponseModel *)model];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginStateChangedNotification object:nil];
        if (completion) {
            completion(YES, @"登录成功");
        }
    } failure:^(LLBaseResponseModel *model) {
        if (completion) {
            completion(NO, model.errorMsg ?: @"登录失败");
        }
    }];
}

- (void)modifyUserName:(NSString *)username completion:(void (^ __nullable)(BOOL success, NSString *__nullable errorMsg))completion {
    LLURL *llurl = [[LLURL alloc] initWithParser:@"ModifyUserParser" urlConfigClass:[LLLoveTalkURLConfig class]];
    [llurl.params setValue:username forKey:@"username"];
    [llurl.params setValue:self.phone forKey:@"phone"];
    WEAKSELF();
    [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:self success:^(NSDictionary *result, LLBaseResponseModel *model, BOOL isLocalCache) {
        STRONGSELF();
        strongSelf.username = username;
        [strongSelf storeUserInfoToUserDefault];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChangedNotification object:nil];
        if (completion) {
            completion(YES, @"修改成功");
        }
    } failure:^(LLBaseResponseModel *model) {
        if (completion) {
            completion(NO, model.errorMsg ?: @"修改失败");
        }
    }];
}

- (void)fetchUserInfoCompletion:(void (^ __nullable)(BOOL success, NSString *__nullable errorMsg))completion {
    if (self.isLogin) {
        LLURL *llurl = [[LLURL alloc] initWithParser:@"GetUserInfoParser" urlConfigClass:[LLLoveTalkURLConfig class]];
        [llurl.params setValue:self.phone forKey:@"phone"];
        WEAKSELF();
        [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:self success:^(NSDictionary *result, LLBaseResponseModel *model, BOOL isLocalCache) {
            STRONGSELF();
            [strongSelf configWithModel:(LLUserResponseModel *)model];
            if (completion) {
                completion(YES, @"信息获取成功");
            }
        } failure:^(LLBaseResponseModel *model) {
            if (completion) {
                completion(NO, model.errorMsg ?: @"信息获取失败");
            }
        }];
    }
    else {
        if (completion) {
            completion(NO, @"用户未登录");
        }
    }
}
#pragma mark - private
- (void)configWithModel:(nullable LLUserResponseModel *)userModel {
    if (userModel) {
        self.phone = userModel.phone;
        self.username = userModel.username;
        self.ispaid = userModel.ispaid;
        self.remaindays = userModel.remaindays;
    }
    else {
        self.phone = nil;
        self.username = nil;
        self.ispaid = NO;
        self.remaindays = 0;
    }
    
    [self storeUserInfoToUserDefault];
}

- (void)storeUserInfoToUserDefault {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:self.phone forKey:kUserPhone];
    [userDefaults setValue:self.username forKey:kUsername];
    [userDefaults setBool:self.ispaid forKey:kUserIsVip];
    [userDefaults setInteger:self.remaindays forKey:kUserRemainDays];
    
    [userDefaults setBool:self.isLogin forKey:kUserIsLogin];
    
    [userDefaults synchronize];
}
#pragma mark - action

#pragma mark - lazyloading
@end
