//
//  LLTagCollectionViewCell.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/5.
//

#import "LLTagCollectionViewCell.h"
#import "UILabel+LLTools.h"
#import "LLHomeListResponseModel.h"

@interface LLTagCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation LLTagCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.titleLabel = [UILabel ll_labelWithFrame:CGRectZero text:@"" font:[UIFont systemFontOfSize:14] textColor:LLTheme.titleColor textAlign:NSTextAlignmentCenter];
        
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat titleH = 20;
    self.titleLabel.frame = CGRectMake(0, (CGRectGetHeight(self.bounds) - titleH)/2.0, CGRectGetWidth(self.bounds), titleH);
}

- (void)setModel:(id)model {
    [super setModel:model];
    LLTagResponseModel *item = model;
    self.titleLabel.text = item.catename;
}
@end
