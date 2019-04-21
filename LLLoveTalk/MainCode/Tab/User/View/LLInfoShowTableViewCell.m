//
//  LLInfoShowTableViewCell.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/17.
//

#import "LLInfoShowTableViewCell.h"
@interface LLInfoShowTableViewCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation LLInfoShowTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        self.titleLabel = [UILabel ll_labelWithFrame:CGRectZero text:@"" font:[UIFont systemFontOfSize:13] textColor:LLTheme.subTitleColor textAlign:NSTextAlignmentLeft];
        
        [self addSubview:self.iconView];
        [self addSubview:self.titleLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconView.frame = CGRectMake(40, 0, 30, 38);
    self.titleLabel.frame = CGRectMake(self.iconView.right + 24, (38 - 16)/2.0, CGRectGetWidth(self.bounds) - (self.iconView.right + 24) - 10, 16);
}

- (void)configCellWithImage:(UIImage *)image title:(NSString *)title {
    self.iconView.image = image;
    self.titleLabel.text = title;
}
@end
