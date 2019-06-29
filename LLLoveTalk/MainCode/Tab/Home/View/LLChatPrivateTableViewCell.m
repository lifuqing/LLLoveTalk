//
//  LLChatPrivateTableViewCell.m
//  LLAiLove
//
//  Created by lifuqing on 2019/4/13.
//

#import "LLChatPrivateTableViewCell.h"

@interface LLChatPrivateTableViewCell ()
@property (nonatomic, strong) UIImageView *thumbView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel1;
@property (nonatomic, strong) UILabel *subTitleLabel2;
@property (nonatomic, strong) UIView *line;

@end

@implementation LLChatPrivateTableViewCell

+ (CGFloat)cellHeightWithModel:(nullable id)model {
    return 70;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.thumbView = [[UIImageView alloc] initWithImage:LLImage(@"icon_chat_private")];
        
        self.titleLabel = [UILabel ll_labelWithFrame:CGRectZero text:@"※※※※请点击查看※※※※" font:[UIFont systemFontOfSize:16] textColor:LLTheme.titleColor textAlign:NSTextAlignmentCenter];
        
        self.subTitleLabel1 = [UILabel ll_labelWithFrame:CGRectZero text:@"※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※" font:[UIFont systemFontOfSize:12] textColor:LLTheme.subTitleColor textAlign:NSTextAlignmentCenter];
        self.subTitleLabel1.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.subTitleLabel2 = [UILabel ll_labelWithFrame:CGRectZero text:@"※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※" font:[UIFont systemFontOfSize:14] textColor:LLTheme.subTitleColor textAlign:NSTextAlignmentCenter];
        self.subTitleLabel2.lineBreakMode = NSLineBreakByCharWrapping;
        
        self.line = [[UIView alloc] initWithFrame:CGRectZero];
        self.line.backgroundColor = LLTheme.mainColor;
        
        [self addSubview:self.thumbView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel1];
        [self addSubview:self.subTitleLabel2];
        [self addSubview:self.line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat titleH = 20;
    self.thumbView.frame = CGRectMake(13, (self.height - 58)/2.0, 58, 58);
    self.titleLabel.frame = CGRectMake(self.thumbView.right + 13, 7, CGRectGetWidth(self.bounds) - self.thumbView.right - 26, titleH);
    self.subTitleLabel1.frame = CGRectMake(self.titleLabel.left, self.height - 13 - 14, self.width - self.titleLabel.left - 13, 14);
    self.subTitleLabel2.frame = CGRectMake(self.titleLabel.left, self.height - 13 - 28, self.width - self.titleLabel.left - 13, 14);
    self.line.frame = CGRectMake(0, self.height - 1, self.width, 1);
}

@end
