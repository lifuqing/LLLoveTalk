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
        self.titleLabel = [UILabel labelWithFrame:CGRectZero text:@"" font:[UIFont boldSystemFontOfSize:15] textColor:RGB(89, 88, 87) textAlign:NSTextAlignmentLeft];
        
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat leftPadding = 22, titleH = 20;
   self.titleLabel.frame = CGRectMake(leftPadding, (CGRectGetHeight(self.bounds) - titleH)/2.0, CGRectGetWidth(self.bounds) - leftPadding, titleH);
}

@end
