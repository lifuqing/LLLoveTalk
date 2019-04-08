//
//  TDOrderForAliPay.h
//  HappyWeek
//
//  Created by 李福庆 on 15/4/6.
//
//

#import "Order.h"
//#import "LLSNItem.h"
#import <AlipaySDK/AlipaySDK.h>

@interface TDOrderForAliPay : Order

@property (nonatomic, copy) NSString *orderString;
///item为LLSNItem,TDMultiSNItem
- (id)initWithItem:(id)item;
@end
