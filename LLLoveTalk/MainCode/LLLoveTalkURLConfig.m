//
//  LLLoveTalkURLConfig.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/5.
//

#import "LLLoveTalkURLConfig.h"
@interface LLLoveTalkURLConfig ()
@property (nonatomic, copy) NSString *server;
@end

@implementation LLLoveTalkURLConfig
- (instancetype)init {
    self = [super init];
    if (self) {
        self.server = [LLConfig sharedInstance].server;//@"http://apillbd.simache.com";//@"http://116.62.90.52"
    }
    return self;
}

- (NSDictionary *)commonParams {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[[UIDevice currentDevice] appVersion] forKey:@"version"];
    [dict setValue:@([LLConfig sharedInstance].isCheck) forKey:@"check_state"];
    [dict setValue:[LLUser sharedInstance].phone ?:@"" forKey:@"phone"];
    return [dict copy];
}

- (NSArray *)loadUrlInfo{
    NSArray *arr = @[
#pragma mark -示例普通接口
                     @{
                         @"parser"     : @"ExampleRequestParser", //parser用来区分不同的请求,命名XXXXParser
                         @"server"     : @"domain",//domain，子类自行维护传入
                         @"url"        : @"/index.php",   //short url，不带host
                         @"method"     : @"get",      //支持post和get
                         @"cache"      : @(NO),     //是否存取json数据
                         @"params"     : @{},          //该接口默认参数
                         //@"modelClass" : @"LLXXXResponseModel"  //继承自LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -示例列表接口
                     @{
                         @"parser"     : @"ExampleListParser",//,命名规则XXXXListParser
                         @"server"     : @"domain",//domain，子类自行维护传入
                         @"url"        : @"/zhuanti.php",
                         @"method"     : @"get",
                         @"cache"      : @(NO),
                         @"params"     : @{},
                         @"modelClass" : @"LLXXXListResponseModel"  //继承自LLListResponseModel(列表页)或者LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -初始化接口
                     @{
                         @"parser"     : @"InitParser",//,命名规则XXXXListParser
                         @"server"     : self.server,
                         @"url"        : @"/state_check",
                         @"method"     : @"get",
                         @"cache"      : @(NO),
                         @"params"     : @{},
                         },
#pragma mark -首页列表接口
                     @{
                         @"parser"     : @"HomeListParser",//,命名规则XXXXListParser
                         @"server"     : self.server,
                         @"url"        : @"/homepage",
                         @"method"     : @"get",
                         @"cache"      : @(YES),
                         @"params"     : @{},
                         @"modelClass" : @"LLHomeListResponseModel"  //继承自LLListResponseModel(列表页)或者LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -搜索接口
                     @{
                         @"parser"     : @"SearchListParser",//,命名规则XXXXListParser
                         @"server"     : self.server,
                         @"url"        : @"/search",
                         @"method"     : @"get",
                         @"cache"      : @(NO),
                         @"params"     : @{},
                         @"modelClass" : @"LLTagExampleListResponseModel"  //继承自LLListResponseModel(列表页)或者LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -恋爱详情列表接口
                     @{
                         @"parser"     : @"LoveDetailListParser",//,命名规则XXXXListParser
                         @"server"     : self.server,
                         @"url"        : @"/lianai_xiangqing",
                         @"method"     : @"get",
                         @"cache"      : @(NO),
                         @"params"     : @{},
                         @"modelClass" : @"LLTagExampleListResponseModel"  //继承自LLListResponseModel(列表页)或者LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -聊天实战聊天列表接口
                     @{
                         @"parser"     : @"ChatListParser",//,命名规则XXXXListParser
                         @"server"     : self.server,
                         @"url"        : @"/liaotian_list",
                         @"method"     : @"get",
                         @"cache"      : @(YES),
                         @"params"     : @{},
                         @"modelClass" : @"LLChatListResponseModel"  //继承自LLListResponseModel(列表页)或者LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -聊天实战详情接口
                     @{
                         @"parser"     : @"ChatDetailParser",//,命名规则XXXXListParser
                         @"server"     : self.server,
                         @"url"        : @"/liaotian_xiangqing",
                         @"method"     : @"get",
                         @"cache"      : @(NO),
                         @"params"     : @{},
                         @"modelClass" : @"LLChatDetailListResponseModel"  //继承自LLListResponseModel(列表页)或者LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -聊天实战恋爱解析列表接口
                     @{
                         @"parser"     : @"LoveListParser",//,命名规则XXXXListParser
                         @"server"     : self.server,
                         @"url"        : @"/jiexi_list",
                         @"method"     : @"get",
                         @"cache"      : @(YES),
                         @"params"     : @{},
                         @"modelClass" : @"LLChatListResponseModel"  //继承自LLListResponseModel(列表页)或者LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -聊天实战恋爱解析详情接口
                     @{
                         @"parser"     : @"LoveDetailParser",//,命名规则XXXXListParser
                         @"server"     : self.server,
                         @"url"        : @"/jiexi_xiangqing",
                         @"method"     : @"get",
                         @"cache"      : @(NO),
                         @"params"     : @{},
                         @"modelClass" : @"LLChatDetailListResponseModel"  //继承自LLListResponseModel(列表页)或者LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -发送验证码接口
                     @{
                         @"parser"     : @"SendCodeParser", //parser用来区分不同的请求,命名XXXXParser
                         @"server"     : self.server,
                         @"url"        : @"/sendcode",   //short url，不带host
                         @"method"     : @"get",      //支持post和get
                         @"cache"      : @(NO),     //是否存取json数据
                         @"params"     : @{},          //该接口默认参数
                         //@"modelClass" : @"LLXXXResponseModel"  //继承自LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -登录接口
                     @{
                         @"parser"     : @"LoginParser", //parser用来区分不同的请求,命名XXXXParser
                         @"server"     : self.server,
                         @"url"        : @"/login",   //short url，不带host
                         @"method"     : @"post",      //支持post和get
                         @"cache"      : @(NO),     //是否存取json数据
                         @"params"     : @{},          //该接口默认参数
                         @"modelClass" : @"LLUserResponseModel"  //继承自LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -修改用户名接口
                     @{
                         @"parser"     : @"ModifyUserParser", //parser用来区分不同的请求,命名XXXXParser
                         @"server"     : self.server,
                         @"url"        : @"/modify_username",   //short url，不带host
                         @"method"     : @"post",      //支持post和get
                         @"cache"      : @(NO),     //是否存取json数据
                         @"params"     : @{},          //该接口默认参数
                         //@"modelClass" : @"LLXXXResponseModel"  //继承自LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -获取用户信息接口
                     @{
                         @"parser"     : @"GetUserInfoParser", //parser用来区分不同的请求,命名XXXXParser
                         @"server"     : self.server,
                         @"url"        : @"/get_user_info",   //short url，不带host
                         @"method"     : @"get",      //支持post和get
                         @"cache"      : @(NO),     //是否存取json数据
                         @"params"     : @{},          //该接口默认参数
                         @"modelClass" : @"LLUserResponseModel"  //继承自LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -获取产品信息接口
                     @{
                         @"parser"     : @"GetProductInfoParser", //parser用来区分不同的请求,命名XXXXParser
                         @"server"     : self.server,
                         @"url"        : @"/get_package",   //short url，不带host
                         @"method"     : @"get",      //支持post和get
                         @"cache"      : @(YES),     //是否存取json数据
                         @"params"     : @{},          //该接口默认参数
                         @"modelClass" : @"LLProductListResponseModel"  //继承自LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -通知服务端购买成功接口
                     @{
                         @"parser"     : @"BuyProductNotifyParser", //parser用来区分不同的请求,命名XXXXParser
                         @"server"     : self.server,
                         @"url"        : @"/place_order",   //short url，不带host
                         @"method"     : @"post",      //支持post和get
                         @"cache"      : @(NO),     //是否存取json数据
                         @"params"     : @{},          //该接口默认参数
                         @"modelClass" : @"LLUserResponseModel"  //继承自LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
                     ];
    return arr;
}
@end
