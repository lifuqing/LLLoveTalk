//
//  LLUser.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/5.
//

#import "LLUser.h"
#import "LLUserResponseModel.h"

NSString *const kUserInfoChangedNotification = @"kUserInfoChangedNotification";
NSString *const kUserLoginStateChangedNotification = @"kUserLoginStateChangedNotification";
NSString *const kUserVIPChangedNotification = @"kUserVIPChangedNotification";


NSString *const kUserIsLogin                = @"com.user.isLogin";
NSString *const kUsername                   = @"com.user.username";
NSString *const kUserPhone                  = @"com.user.phone";
NSString *const kUserIsVip                  = @"com.user.isVip";
NSString *const kUserRemainDays             = @"com.user.remaindays";


NSString *const kIAPReceiptKey = @"receipt";
NSString *const kIAPProductIdKey = @"productId";

@interface LLUser (IAPPrivate)
- (void)fetchNoUploadAndUploadToServerProductIds;

@end

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
        
        if (self.isLogin && self.phone) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self fetchNoUploadAndUploadToServerProductIds];
            });
            
        }
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
    [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:self success:^(NSURLResponse * _Nullable response, NSDictionary * _Nullable result, LLBaseResponseModel * _Nonnull model, BOOL isLocalCache) {
        if (completion) {
            completion(YES, @"验证码发送成功");
        }
    } failure:^(NSURLResponse * _Nonnull response, NSError * _Nullable error,  LLBaseResponseModel * _Nonnull model) {
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
    [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:self success:^(NSURLResponse * _Nullable response, NSDictionary * _Nullable result, LLBaseResponseModel * _Nonnull model, BOOL isLocalCache) {
        STRONGSELF();
        strongSelf.login = YES;
        [strongSelf configWithModel:(LLUserResponseModel *)model];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginStateChangedNotification object:nil];
        if (completion) {
            completion(YES, @"登录成功");
        }
    } failure:^(NSURLResponse * _Nonnull response, NSError * _Nullable error,  LLBaseResponseModel * _Nonnull model) {
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
    [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:self success:^(NSURLResponse * _Nullable response, NSDictionary * _Nullable result, LLBaseResponseModel * _Nonnull model, BOOL isLocalCache) {
        STRONGSELF();
        strongSelf.username = username;
        [strongSelf storeUserInfoToUserDefault];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChangedNotification object:nil];
        if (completion) {
            completion(YES, @"修改成功");
        }
    } failure:^(NSURLResponse * _Nonnull response, NSError * _Nullable error,  LLBaseResponseModel * _Nonnull model) {
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
        [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:self success:^(NSURLResponse * _Nullable response, NSDictionary * _Nullable result, LLBaseResponseModel * _Nonnull model, BOOL isLocalCache) {
            STRONGSELF();
            [strongSelf configWithModel:(LLUserResponseModel *)model];
            if (completion) {
                completion(YES, @"信息获取成功");
            }
        } failure:^(NSURLResponse * _Nonnull response, NSError * _Nullable error,  LLBaseResponseModel * _Nonnull model) {
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

- (void)setRemaindays:(NSInteger)remaindays {
    _remaindays = remaindays;
    self.isSuperVIP = remaindays == 99999;
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

@end


@implementation LLUser (IAP)

#pragma mark - IAP

- (void)saveToLocalWithProductInfo:(NSDictionary *)productInfo {
    NSMutableArray<NSDictionary *> *m = [self mutableNoUploadProductInfos];
    if (!m) {
        m = [NSMutableArray array];
    }
    __block BOOL exist = NO;
    [m enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[kIAPReceiptKey] isEqualToString:productInfo[kIAPReceiptKey]]) {
            exist = YES;
            *stop = YES;
        }
    }];
    
    if (productInfo && !exist) {
        [m addObject:productInfo];
        [[NSUserDefaults standardUserDefaults] setObject:m forKey:[self noUploadIdentifier]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)deleteFromLocalWithProductInfo:(NSDictionary *)productInfo {
    NSMutableArray<NSDictionary *> *m = [self mutableNoUploadProductInfos];
    if (productInfo && m) {
        [m removeObject:productInfo];
        [[NSUserDefaults standardUserDefaults] setObject:m forKey:[self noUploadIdentifier]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (nullable NSMutableArray<NSDictionary *> *)mutableNoUploadProductInfos {
    NSArray<NSDictionary *> *arr = [[NSUserDefaults standardUserDefaults] arrayForKey:[self noUploadIdentifier]];
    if (arr) {
        return [NSMutableArray arrayWithArray:arr];
    }
    return nil;
}

- (void)fetchNoUploadAndUploadToServerProductIds {
    NSArray<NSDictionary *> *ids = [[self mutableNoUploadProductInfos] copy];
    WEAKSELF();
    [ids enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[LLUser sharedInstance] uploadBuyProductId:obj[kIAPProductIdKey] receiptBase64:obj[kIAPReceiptKey]  completion:^(BOOL success, NSString * _Nullable errorMsg) {
            STRONGSELF();
            if (success) {
                [strongSelf deleteFromLocalWithProductInfo:obj];
            }
        }];
    }];
}

- (NSString *)noUploadIdentifier {
    return [@"iapNoUploadList-" stringByAppendingString:[LLUser sharedInstance].phone];
}



- (void)uploadBuyProductId:(NSString *)productId receiptBase64:(NSString *)receiptBase64 completion:(void (^ __nullable)(BOOL success, NSString *__nullable errorMsg))completion {
    WEAKSELF();
    LLURL *llurl = [[LLURL alloc] initWithParser:@"BuyProductNotifyParser" urlConfigClass:[LLLoveTalkURLConfig class]];
    [llurl.params setValue:[LLUser sharedInstance].phone ?:@"" forKey:@"phone"];
    [llurl.params setValue:productId forKey:@"productid"];
    [llurl.params setValue:receiptBase64 forKey:@"receipt"];
    [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:self success:^(NSURLResponse * _Nullable response, NSDictionary * _Nullable result, LLBaseResponseModel * _Nonnull model, BOOL isLocalCache) {
        STRONGSELF();
        LLUserResponseModel *userModel = (LLUserResponseModel *)model;
        strongSelf.remaindays = userModel.remaindays;
        strongSelf.ispaid = userModel.ispaid;
        [strongSelf storeUserInfoToUserDefault];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChangedNotification object:nil];
        if (completion) {
            completion(YES, @"上传成功");
        }
    } failure:^(NSURLResponse * _Nonnull response, NSError * _Nullable error,  LLBaseResponseModel * _Nonnull model) {
        STRONGSELF();
        if (productId && receiptBase64) {
 
            [strongSelf saveToLocalWithProductInfo:@{kIAPProductIdKey:productId, kIAPReceiptKey:receiptBase64}];
        }
        
        if (completion) {
            completion(NO, model.errorMsg ?: @"上传失败");
        }
    }];
    
}

@end
