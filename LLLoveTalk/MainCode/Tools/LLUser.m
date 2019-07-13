//
//  LLUser.m
//  LLAiLove
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
NSString *const kUserId                     = @"com.user.userid";
NSString *const kUserSig_love               = @"com.user.sig_love";
NSString *const kUserSig_self               = @"com.user.sig_self";
NSString *const kUserHead_file              = @"com.user.head_file";


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
        self.username   = [userDefaults stringForKey:kUsername];
        self.phone      = [userDefaults stringForKey:kUserPhone];
        self.ispaid     = [userDefaults boolForKey:kUserIsVip];
        self.remaindays = [userDefaults integerForKey:kUserRemainDays];
        self.login      = [userDefaults boolForKey:kUserIsLogin];
        self.userid     = [userDefaults stringForKey:kUserId];
        self.sig_self   = [userDefaults stringForKey:kUserSig_self];
        self.sig_love   = [userDefaults stringForKey:kUserSig_love];
        self.head_file  = [userDefaults stringForKey:kUserHead_file];
        
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
    LLURL *llurl = [[LLURL alloc] initWithParser:@"SendCodeParser" urlConfigClass:[LLAiLoveURLConfig class]];
    [llurl.params setValue:phone forKey:@"phone"];
    [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:self success:^(NSURLResponse * _Nullable response, NSDictionary * _Nullable result, LLBaseResponseModel * _Nullable model, BOOL isLocalCache) {
        if (completion) {
            completion(YES, @"验证码发送成功");
        }
    } failure:^(NSURLResponse * _Nullable response, NSError * _Nullable error,  LLBaseResponseModel * _Nullable model) {
        if (completion) {
            completion(NO, model.errorMsg ?: @"验证码发送失败");
        }
    }];
}

- (void)loginWithPhone:(NSString *)phone code:(NSString *)code completion:(void (^ __nullable)(BOOL success, NSString *__nullable errorMsg))completion {
    LLURL *llurl = [[LLURL alloc] initWithParser:@"LoginParser" urlConfigClass:[LLAiLoveURLConfig class]];
    [llurl.params setValue:phone forKey:@"phone"];
    [llurl.params setValue:code forKey:@"code"];
    WEAKSELF();
    [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:self success:^(NSURLResponse * _Nullable response, NSDictionary * _Nullable result, LLBaseResponseModel * _Nullable model, BOOL isLocalCache) {
        STRONGSELF();
        strongSelf.login = YES;
        [strongSelf configWithModel:(LLUserResponseModel *)model];
        [strongSelf fetchNoUploadAndUploadToServerProductIds];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginStateChangedNotification object:nil];
        if (completion) {
            completion(YES, @"登录成功");
        }
    } failure:^(NSURLResponse * _Nullable response, NSError * _Nullable error,  LLBaseResponseModel * _Nullable model) {
        if (completion) {
            completion(NO, model.errorMsg ?: @"登录失败");
        }
    }];
}

- (void)modifyUserInfo:(NSString *)text type:(EModifyInfoType)type completion:(void (^ __nullable)(BOOL success, NSString *__nullable errorMsg))completion {
    NSString *parser = @"";
    NSDictionary *dict = nil;
    if (type == EModifyInfoTypeUserName) {
        parser = @"ModifyUserParser";
        dict = @{@"username":text?:@""};
    } else if (type == EModifyInfoTypeSigSelf) {
        parser = @"ModifySigSelfParser";
        dict = @{@"sigself":text?:@""};
    } else if (type == EModifyInfoTypeSigLove) {
        parser = @"ModifySigLoveParser";
        dict = @{@"siglove":text?:@""};
    }
    
    LLURL *llurl = [[LLURL alloc] initWithParser:parser urlConfigClass:[LLAiLoveURLConfig class]];
    [llurl.params addEntriesFromDictionary:dict];
    WEAKSELF();
    [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:self success:^(NSURLResponse * _Nullable response, NSDictionary * _Nullable result, LLBaseResponseModel * _Nullable model, BOOL isLocalCache) {
        STRONGSELF();
        
        if (type == EModifyInfoTypeUserName) {
            strongSelf.username = text;
        } else if (type == EModifyInfoTypeSigSelf) {
            strongSelf.sig_self = text;
        } else if (type == EModifyInfoTypeSigLove) {
            strongSelf.sig_love = text;
        }
        
        [strongSelf storeUserInfoToUserDefault];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChangedNotification object:nil];
        if (completion) {
            completion(YES, @"修改成功");
        }
    } failure:^(NSURLResponse * _Nullable response, NSError * _Nullable error,  LLBaseResponseModel * _Nullable model) {
        if (completion) {
            completion(NO, model.errorMsg ?: @"修改失败");
        }
    }];
}

- (void)fetchUserInfoCompletion:(void (^ __nullable)(BOOL success, NSString *__nullable errorMsg))completion {
    if (self.isLogin) {
        LLURL *llurl = [[LLURL alloc] initWithParser:@"GetUserInfoParser" urlConfigClass:[LLAiLoveURLConfig class]];
        [llurl.params setValue:self.phone forKey:@"phone"];
        WEAKSELF();
        [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:self success:^(NSURLResponse * _Nullable response, NSDictionary * _Nullable result, LLBaseResponseModel * _Nullable model, BOOL isLocalCache) {
            STRONGSELF();
            [strongSelf configWithModel:(LLUserResponseModel *)model];
            if (completion) {
                completion(YES, @"信息获取成功");
            }
        } failure:^(NSURLResponse * _Nullable response, NSError * _Nullable error,  LLBaseResponseModel * _Nullable model) {
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
        self.userid = userModel.userid;
        self.sig_love = userModel.sig_love;
        self.sig_self = userModel.sig_self;
        self.isnew = userModel.isnew;
        self.head_file = userModel.head_file;
    }
    else {
        self.phone = nil;
        self.username = nil;
        self.ispaid = NO;
        self.remaindays = 0;
        self.userid = nil;
        self.sig_love = nil;
        self.sig_self = nil;
        self.isnew = NO;
        self.head_file = nil;
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
    [userDefaults setValue:self.head_file forKey:kUserHead_file];
    
    [userDefaults setBool:self.isLogin forKey:kUserIsLogin];
    
    [userDefaults setValue:self.userid forKey:kUserId];
    [userDefaults setValue:self.sig_self forKey:kUserSig_self];
    [userDefaults setValue:self.sig_love forKey:kUserSig_love];
    
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
    //暂时不适用phone来作为标识，实际上还是需要后端来处理比较靠谱
    return @"iapNoUploadList-";
//    return [@"iapNoUploadList-" stringByAppendingString:[LLUser sharedInstance].phone];
}



- (void)uploadBuyProductId:(NSString *)productId receiptBase64:(NSString *)receiptBase64 completion:(void (^ __nullable)(BOOL success, NSString *__nullable errorMsg))completion {
    WEAKSELF();
    LLURL *llurl = [[LLURL alloc] initWithParser:@"BuyProductNotifyParser" urlConfigClass:[LLAiLoveURLConfig class]];
    [llurl.params setValue:[LLUser sharedInstance].phone ?:@"" forKey:@"phone"];
    [llurl.params setValue:productId forKey:@"productid"];
    [llurl.params setValue:receiptBase64 forKey:@"receipt"];
    [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:self success:^(NSURLResponse * _Nullable response, NSDictionary * _Nullable result, LLBaseResponseModel * _Nullable model, BOOL isLocalCache) {
        STRONGSELF();
        LLUserResponseModel *userModel = (LLUserResponseModel *)model;
        strongSelf.remaindays = userModel.remaindays;
        strongSelf.ispaid = userModel.ispaid;
        [strongSelf storeUserInfoToUserDefault];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChangedNotification object:nil];
        if (completion) {
            completion(YES, @"上传成功");
        }
    } failure:^(NSURLResponse * _Nullable response, NSError * _Nullable error,  LLBaseResponseModel * _Nullable model) {
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
