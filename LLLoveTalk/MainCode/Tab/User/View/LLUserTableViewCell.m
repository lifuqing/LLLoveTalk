//
//  LLUserTableViewCell.m
//  LLAiLove
//
//  Created by lifuqing on 2019/4/14.
//

#import "LLUserTableViewCell.h"
#import "UITextField+LLTools.h"

@interface LLUserTableViewCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong, readwrite) UIImageView *arrow;
@end

@implementation LLUserTableViewCell

+ (CGFloat)cellHeightWithModel:(nullable id)model {
    return 45;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
        self.bgView.backgroundColor = [UIColor whiteColor];
        
        
        self.arrow = [[UIImageView alloc] initWithImage:LLImage(@"icon_right_arrow")];
        
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.arrow];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat titleH = 15, height = [LLUserTableViewCell cellHeightWithModel:nil];
    self.bgView.frame = CGRectMake(15, 0, self.width - 30, height);
    self.arrow.frame = CGRectMake(self.bgView.width - 15, (height - 12)/2.0, 7, 12);
    
    _thumbView.frame = CGRectMake(15, 13, 20, 20);
    _titleLabel.frame = CGRectMake(_thumbView.right + 15, (height - titleH)/2.0, 100, titleH);
    _descLabel.frame =  CGRectMake(100, (height - titleH)/2.0, self.bgView.width - 100 - 20, titleH);
    _descTextField.frame = CGRectMake(100, (height - titleH)/2.0, self.bgView.width - 100 - 20, titleH);
}

- (void)configUIWithImage:(nullable UIImage *)image title:(nullable NSString *)title desc:(nullable NSString *)desc descTextField:(nullable NSString *)descTextField descPlaceholder:(nullable NSString *)descPlaceholder {
    if (image) {
        self.thumbView.image = image;
    }
    else {
        [self.thumbView removeFromSuperview];
        _thumbView = nil;
    }
    
    if (title.length > 0) {
        self.titleLabel.text = title;
    }
    else {
        [self.titleLabel removeFromSuperview];
        _titleLabel = nil;
    }
    
    if (desc.length > 0) {
        self.descLabel.text = desc;
    }
    else {
        [self.descLabel removeFromSuperview];
        _descLabel = nil;
    }
    
    if (descPlaceholder.length > 0) {
        self.descTextField.placeholder = descPlaceholder;
    }
    
    if (descTextField.length > 0) {
        self.descTextField.text = descTextField;
    }
    
    if (descPlaceholder.length == 0 && descTextField.length == 0) {
        [self.descTextField removeFromSuperview];
        _descTextField = nil;
    }
    
    
}
- (UIImageView *)thumbView {
    if (!_thumbView) {
        _thumbView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.bgView addSubview:_thumbView];
    }
    return _thumbView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel ll_labelWithFrame:CGRectZero text:@"" font:[UIFont fontWithName:@"PingFang-SC-Medium" size: 14] textColor:LLTheme.grayTextColor textAlign:NSTextAlignmentLeft];
        [self.bgView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [UILabel ll_labelWithFrame:CGRectZero text:@"" font:[UIFont fontWithName:@"PingFang-SC-Medium" size: 14] textColor:LLTheme.grayTextColor textAlign:NSTextAlignmentRight];
        [self.bgView addSubview:_descLabel];
    }
    return _descLabel;
}


- (UITextField *)descTextField {
    if (!_descTextField) {
        _descTextField = [UITextField ll_textFieldWithFrame:CGRectZero placeholder:@"" font:[UIFont fontWithName:@"PingFang-SC-Medium" size: 14] textColor:LLTheme.grayTextColor textAlign:NSTextAlignmentRight];;
        _descTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.bgView addSubview:_descTextField];
    }
    return _descTextField;
}

@end
