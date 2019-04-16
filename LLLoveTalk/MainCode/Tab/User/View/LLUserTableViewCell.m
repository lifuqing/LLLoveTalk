//
//  LLUserTableViewCell.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/14.
//

#import "LLUserTableViewCell.h"
@interface LLUserTableViewCell ()
@property (nonatomic, strong) UIView *bgView;
@end

@implementation LLUserTableViewCell

+ (CGFloat)cellHeightWithModel:(nullable id)model {
    return 108;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
        self.bgView.backgroundColor = LLTheme.auxiliaryColor;
        
        self.thumbView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        self.titleLabel = [UILabel labelWithFrame:CGRectZero text:@"" font:[UIFont boldSystemFontOfSize:16] textColor:LLTheme.titleColor textAlign:NSTextAlignmentLeft];
        
        self.descLabel = [UILabel labelWithFrame:CGRectZero text:@"" font:[UIFont boldSystemFontOfSize:16] textColor:RGB(220, 89, 119) textAlign:NSTextAlignmentRight];
        
        [self addSubview:self.bgView];
        [self addSubview:self.thumbView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.descLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat titleH = 18, top = 22, height = 86;
    self.bgView.frame = CGRectMake(0, top, self.width, height);
    self.thumbView.frame = CGRectMake(21, top + (height - 58)/2.0, 58, 58);
    self.titleLabel.frame = CGRectMake(self.thumbView.right + 21, top + (height - titleH)/2.0, CGRectGetWidth(self.bounds) - self.thumbView.right - 21*2, titleH);
    self.descLabel.frame = CGRectMake(self.width - 150 - 16, self.titleLabel.top, 150, titleH);
}


@end
