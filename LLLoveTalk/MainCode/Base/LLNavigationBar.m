//
//  LLNavigationBar.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/6.
//

#import "LLNavigationBar.h"
#import "UILabel+LLTools.h"
#import "UIButton+LLTools.h"

@interface LLNavigationBar ()
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) dispatch_block_t backBlock;
@end

@implementation LLNavigationBar
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backButton.frame = CGRectMake(0, 0, self.height, self.height);
    self.titleLabel.frame = CGRectMake(self.backButton.right, (self.height - 20)/2.0, self.width - self.backButton.right, 20);
}

- (void)addTopBackBlock:(dispatch_block_t)backBlock title:(NSString *)title {
    _backBlock = [backBlock copy];
    [self addSubview:self.backButton];
    if (title) {
        [self addSubview:self.titleLabel];
        self.titleLabel.text = title;
    }
}

- (void)addTopCloseBlock:(dispatch_block_t)closeBlock title:(NSString *)title {
    _backBlock = [closeBlock copy];
    if (title) {
        [self addSubview:self.titleLabel];
        self.titleLabel.text = title;
    }
}

- (void)backButtonActionClick:(UIButton *)sender {
    if (_backBlock) {
        _backBlock();
    }
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithFrame:CGRectZero target:self normalImage:LLImage(@"") selector:@selector(backButtonActionClick:)];
    }
    return _backButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFrame:CGRectZero text:@"" font:[UIFont systemFontOfSize:18] textColor:[UIColor redColor] textAlign:NSTextAlignmentCenter];
    }
    return _titleLabel;
}
@end
