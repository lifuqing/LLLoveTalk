//
//  TDOrderForAliPay.m
//  HappyWeek
//
//  Created by 李福庆 on 15/4/6.
//
//

#import "TDOrderForAliPay.h"
#import "LLSNItem.h"
//#import "DataSigner.h"

@implementation TDOrderForAliPay
- (id)init{
    self = [super init];
    if (self) {
        self.partner = [LLConfig sharedInstance].aliPartnerID;
        self.seller = [LLConfig sharedInstance].aliSellerID;
        self.notifyURL =  @"http://test1.e.kumi.cn/alipay/index.php"; //回调URL
        
        self.service = @"mobile.securitypay.pay";
        self.paymentType = @"1";
        self.inputCharset = @"utf-8";
        self.itBPay = @"30m";
        self.showUrl = @"m.alipay.com";
    }
    return self;
}

- (id)initWithItem:(id)item{
    self = [self init];
    if (self) {
        if ([item isMemberOfClass:[LLSNItem class]]) {
            self.tradeNO = ((LLSNItem *)item).type_sn; //订单ID（由商家自行制定）
            self.productName = ((LLSNItem *)item).title; //商品标题
            //        self.productDescription = item.body; //商品描述
            self.amount = [NSString stringWithFormat:@"%.2f",[((LLSNItem *)item) totalPrice]]; //商品价格
        }
        //将商品信息拼接成字符串
        NSString *orderSpec = [self description];
        NSLog(@"orderSpec = %@",orderSpec);
        
        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//        id<DataSigner> signer = CreateRSADataSigner([LLConfig sharedInstance].aliPrivateKey);
//        NSString *signedString = [signer signString:orderSpec];
//
//        //将签名成功字符串格式化为订单字符串,请严格按照该格式
//        self.orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                                 orderSpec, signedString, @"RSA"];
        
    }
    return self;
}

@end
