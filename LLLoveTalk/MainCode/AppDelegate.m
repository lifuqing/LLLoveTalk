//
//  AppDelegate.m
//  LLAiLove
//
//  Created by lifuqing on 2019/4/5.
//

#import "AppDelegate.h"
#import "LLTabBarViewController.h"
#import "LLBaseNavigationController.h"
#import <StoreKit/StoreKit.h>
#import "LLIAPShare.h"
#import "LLProductListResponseModel.h"
#import "LLUser.h"

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [LLConfig sharedInstance].isDebug = NO;
    [LLConfig sharedInstance].isNeedLog = NO;
    
    [LLURLCacheManager sharedInstance].userID = ^NSString *{
        return [LLUser sharedInstance].userid;
    };
    
    [self configUI];
 
    [self registerSomething];
    
    [self runSomething];
    
    [self delayRunSometing];
    
    return YES;
}

- (void)configUI {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    LLTabBarViewController *tab = [[LLTabBarViewController alloc] init];
    self.window.rootViewController = tab;
    
    [self.window makeKeyAndVisible];
    
}

- (void)runSomething {
    [self checkState];
}

- (void)registerSomething {
    
    // 初始化OSSClient实例
    [self setupOSSClient];
    
    if ([LLUser sharedInstance].isLogin && ![LLUser sharedInstance].isSuperVIP) {
        [self observeIAPStatus];
    }
}

- (void)delayRunSometing {
    [[LLUser sharedInstance] fetchUserInfoCompletion:nil];
}

- (void)setupOSSClient {
    
    // 初始化具有自动刷新的provider
//    OSSAuthCredentialProvider *credentialProvider = [[OSSAuthCredentialProvider alloc] initWithAuthServerUrl:[LLConfig sharedInstance].OSS_STS_URL];
    
    OSSCustomSignerCredentialProvider *provider = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
        
        // 用户应该在此处将需要签名的字符串发送到自己的业务服务器(AK和SK都在业务服务器保存中,从业务服务器获取签名后的字符串)
        OSSFederationToken *token = [OSSFederationToken new];
        token.tAccessKey = [LLConfig sharedInstance].OSS_ACCESSKEY;
        token.tSecretKey = [LLConfig sharedInstance].OSS_SECRETKEY;
        
        NSString *signedContent = [OSSUtil sign:contentToSign withToken:token];
        return signedContent;
    }];
    
    NSError *error;
    NSLog(@"%@",[provider sign:@"abc" error:&error]);
    
    // client端的配置,如超时时间，开启dns解析等等
    OSSClientConfiguration *cfg = [[OSSClientConfiguration alloc] init];
    
    _client = [[OSSClient alloc] initWithEndpoint:[LLConfig sharedInstance].OSS_ENDPOINT credentialProvider:provider clientConfiguration:cfg];
    
}

- (void)checkState {
    WEAKSELF();
    LLURL *llurl = [[LLURL alloc] initWithParser:@"InitParser" urlConfigClass:[LLAiLoveURLConfig class]];
    [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:self success:^(NSURLResponse * _Nullable response, NSDictionary * _Nullable result, LLBaseResponseModel * _Nullable model, BOOL isLocalCache) {
        BOOL ischeck = [result[@"data"][@"state"] boolValue];
        [LLConfig sharedInstance].isPassedCheck = !ischeck;
        [LLConfig sharedInstance].isPassedCheck = NO;
        if (ischeck) {
            NSString *message = result[@"data"][@"alert_box"];
            if (message) {
                [weakSelf showAlertWithMessage:message];
            }
        }
    } failure:^(NSURLResponse * _Nullable response, NSError * _Nullable error, LLBaseResponseModel * _Nullable model) {
        //
    }];
}

- (void)showAlertWithMessage:(NSString *)message {
    if (message.length > 0) {
        [UIAlertController ll_showAlertWithTarget:[LLNav topViewController] title:@"提示" message:message cancelTitle:@"好的" otherTitles:nil completion:nil];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)observeIAPStatus {
    WEAKSELF();
    LLURL *llurl = [[LLURL alloc] initWithParser:@"GetProductInfoParser" urlConfigClass:[LLAiLoveURLConfig class]];
    
    [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:self success:^(NSURLResponse * _Nullable response, NSDictionary * _Nullable result, LLBaseResponseModel * _Nullable model, BOOL isLocalCache) {
        LLProductListResponseModel *productListModel = (LLProductListResponseModel *)model;
        NSSet<NSString *> *productIds = [NSSet setWithArray:[productListModel.list valueForKey:@"productId"]];
        [weakSelf configIAPWithIdentifiers:productIds];
    } failure:^(NSURLResponse * _Nullable response, NSError * _Nullable error,  LLBaseResponseModel * _Nullable model) {
    }];
}

- (void)configIAPWithIdentifiers:(NSSet *)identifiers {
    WEAKSELF();
    if(![LLIAPShare sharedHelper].iap) {
        [LLIAPShare sharedHelper].iap = [[LLIAPHelper alloc] initWithProductIdentifiers:identifiers];
    }
    
    if ([LLConfig sharedInstance].isDebug) {
        [LLIAPShare sharedHelper].iap.production = NO;
    }
    else {
        //审核时提供给Apple用于验证使用
        if ([[LLUser sharedInstance].phone isEqualToString:@"12345678910"]) {
            [LLIAPShare sharedHelper].iap.production = NO;
        }
        else {
            [LLIAPShare sharedHelper].iap.production = YES;
        }
    }
    
    
    LLIAPHelper *iap = [LLIAPShare sharedHelper].iap;
    iap.buyProductCompleteBlock = ^(SKPaymentTransaction *transcation) {
        STRONGSELF();
        if (transcation.transactionState == SKPaymentTransactionStatePurchased) {
            // 订阅特殊处理
            if (transcation.originalTransaction) {
                // 如果是自动续费的订单,originalTransaction会有内容
                [strongSelf checkReciept:transcation];
                DLog(@"自动续费的订单,originalTransaction = %@",transcation.originalTransaction);
            } else {
                // 普通购买，以及第一次购买自动订阅
                DLog(@"普通购买，以及第一次购买自动订阅");
            }

        }
    };
}

- (void)checkReciept:(SKPaymentTransaction *)transcation {
    NSData *receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    [[LLIAPShare sharedHelper].iap checkReceipt:receiptData AndSharedSecret:[LLConfig sharedInstance].shareSecret onCompletion:^(NSString *response, NSError *error) {
        
        //Convert JSON String to NSDictionary
        NSDictionary* rec = [LLIAPShare toJSON:response];
        
        if([rec[@"status"] integerValue]==0)
        {
            [[LLIAPShare sharedHelper].iap provideContentWithTransaction:transcation];
            NSString *receiptBase64 = [NSString base64StringFromData:receiptData];
            [[LLUser sharedInstance] uploadBuyProductId:transcation.payment.productIdentifier receiptBase64:receiptBase64 completion:nil];
        }
    }];
}

@end
