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
        self.backgroundColor = LLTheme.navigationTintColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat top = SafeNavgBarAreaTop;
    self.backButton.frame = CGRectMake(8, top + (SafeNavBarHeight - top - 30)/2.0, 30, 30);
    self.titleLabel.frame = CGRectMake(self.backButton.right, top + ((self.height - top) - 20)/2.0, self.width - self.backButton.right * 2, 20);
}

- (void)addTopBackBlock:(dispatch_block_t)backBlock title:(nullable NSString *)title {
    _backBlock = [backBlock copy];
    [self addSubview:self.backButton];
    [self.backButton setImage:LLImage(@"btn_nav_back") forState:UIControlStateNormal];
    if (title) {
        [self addSubview:self.titleLabel];
        self.titleLabel.text = title;
    }
}

- (void)addTopCloseBlock:(dispatch_block_t)closeBlock title:(nullable NSString *)title {
    _backBlock = [closeBlock copy];
    [self addSubview:self.backButton];
    [self.backButton setImage:LLImage(@"btn_nav_close") forState:UIControlStateNormal];
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
        _backButton = [UIButton buttonWithFrame:CGRectZero target:self normalImage:LLImage(@"btn_fanhui") selector:@selector(backButtonActionClick:)];
    }
    return _backButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFrame:CGRectZero text:@"" font:LLTheme.navigationTitleFont textColor:LLTheme.navigationTitleColor textAlign:NSTextAlignmentCenter];
        _titleLabel.backgroundColor = LLTheme.navigationTintColor;
    }
    return _titleLabel;
}
@end
