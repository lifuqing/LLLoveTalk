//
//  LLHeaderCollectionReusableView.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/5.
//

#import "LLHeaderCollectionReusableView.h"
#import "UILabel+LLTools.h"

@interface LLHeaderCollectionReusableView ()

@end

@implementation LLHeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        self.titleLabel = [UILabel labelWithFrame:CGRectZero text:@"" font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] textAlign:NSTextAlignmentLeft];
        
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat leftPadding = 20, titleH = 20;
   self.titleLabel.frame = CGRectMake(leftPadding, (CGRectGetHeight(self.bounds) - titleH)/2.0, CGRectGetWidth(self.bounds) - 20, titleH);
}

@end
