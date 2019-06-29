//
//  LLBuyItemTableViewCell.m
//  LLAiLove
//
//  Created by lifuqing on 2019/4/17.
//

#import "LLBuyItemTableViewCell.h"

@interface LLBuyItemTableViewCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *buyButton;
@end

@implementation LLBuyItemTableViewCell

+ (CGFloat)cellHeightWithModel:(nullable id)model {
    return 50+18;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
        self.bgView.backgroundColor = LLTheme.auxiliaryColor;
        self.bgView.layer.cornerRadius = 8;
        self.bgView.layer.masksToBounds = YES;
        
        self.titleLabel = [UILabel ll_labelWithFrame:CGRectZero text:@"" font:[UIFont boldSystemFontOfSize:16] textColor:LLTheme.subTitleColor textAlign:NSTextAlignmentLeft];
        
        self.buyButton = [UIButton ll_buttonWithFrame:CGRectZero target:self title:@"购买" font:[UIFont systemFontOfSize:16] textColor:LLTheme.mainColor selector:@selector(buyButtonActionClick:)];
        self.buyButton.backgroundColor = [UIColor whiteColor];
        self.buyButton.layer.cornerRadius = 4;
        self.buyButton.layer.masksToBounds = YES;
        
        [self addSubview:self.bgView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.buyButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bgView.frame = CGRectMake(29, 0, CGRectGetWidth(self.bounds) - 29*2, 50);
    self.titleLabel.frame = CGRectMake(44, (self.bgView.height - 18)/2.0, CGRectGetWidth(self.bounds) - 44*2 - 60, 18);
    self.buyButton.frame = CGRectMake(self.width - 48 - 53, (self.bgView.height - 26)/2.0, 53, 26);
}

- (void)setModel:(id)model {
    [super setModel:model];
    LLBuyItemModel *item = (LLBuyItemModel *)model;
    if (item.productName && item.productPrice) {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@： %@元", item.productName, item.productPrice] attributes:@{NSForegroundColorAttributeName:LLTheme.titleColor, NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        [attr addAttribute:NSForegroundColorAttributeName value:LLTheme.mainColor range:NSMakeRange(attr.length - (item.productPrice.length + 1), item.productPrice.length+1)];
        self.titleLabel.attributedText = attr;
    }
}

- (void)buyButtonActionClick:(UIButton *)sender {
    if (self.clickBuyBlock) {
        self.clickBuyBlock(self.model);
    }
}
@end
