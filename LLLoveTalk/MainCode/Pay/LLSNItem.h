//
//  LLSNItem.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/7.
//

#import "LLBaseResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLSNItem : LLBaseResponseModel

///商品id
@property (nonatomic, copy) NSString *articleId;
///商品标题
@property (nonatomic, copy) NSString *title;
///图片URL
@property (nonatomic, copy) NSString *thumb;
///商品类型
@property (nonatomic, assign) NSInteger type;

///订单id
@property (nonatomic, copy) NSString *baseId;
///订单号
@property (nonatomic, copy) NSString *type_sn;
///商品种类id
@property (nonatomic, copy) NSString *pid;
///创建时间
@property (nonatomic, copy) NSString *insertTime;
///数量
@property (nonatomic, copy) NSString *num;
///总量
@property (nonatomic, copy) NSString *counts;
///所选商品单价
@property (nonatomic, copy) NSString *unitPrice;
///所选商品使用的优惠券的价格
@property (nonatomic, copy) NSString *cprice;
///优惠券减免之后的价格
@property (nonatomic, copy) NSString *aprice;
///规格1名称描述
@property (nonatomic, copy) NSString *spec_name1;
///规格2名称描述
@property (nonatomic, copy) NSString *spec_name2;
///规格1，时间
@property (nonatomic, copy) NSString *timedesc;
///规格2，项目名称
@property (nonatomic, copy) NSString *name;
///订单的手机号,有需要有不需要的地方。
@property (nonatomic, copy) NSString *tel;
///备注
@property (nonatomic, copy) NSString *note;
///订单状态
@property (nonatomic, copy) NSString *status;
///订单状态详细描述
@property (nonatomic, copy) NSString *statusDesc;

///可用优惠券的数组TDMyCouponItem 提交订单的时候会有
@property (nonatomic, strong) NSMutableArray *myCoupons;

///电子券数组TDCouponItem,已完成订单才有
@property (nonatomic, strong) NSMutableArray *coupons;

///当前选择数量的总价
- (CGFloat)totalPrice;
@end

NS_ASSUME_NONNULL_END
