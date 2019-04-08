//
//  LLTagCollectionViewCell.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/5.
//

#import "LLTagCollectionViewCell.h"
#import "UILabel+LLTools.h"

@interface LLTagCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation LLTagCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.titleLabel = [UILabel labelWithFrame:CGRectZero text:@"" font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] textAlign:NSTextAlignmentCenter];
        
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
    self.titleLabel.text = model;
}
@end
