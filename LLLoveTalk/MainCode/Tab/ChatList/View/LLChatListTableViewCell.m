//
//  LLChatListTableViewCell.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/8.
//

#import "LLChatListTableViewCell.h"

@interface LLChatListTableViewCell ()
@property (nonatomic, strong) UIImageView *thumbView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation LLChatListTableViewCell

+ (CGFloat)cellHeightWithModel:(nullable id)model {
    return 70;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.thumbView = [[UIImageView alloc] initWithImage:LLImage(@"icon_chat_thumb1")];
        
        self.titleLabel = [UILabel ll_labelWithFrame:CGRectZero text:@"" font:[UIFont systemFontOfSize:14] textColor:LLTheme.titleColor textAlign:NSTextAlignmentLeft];
        self.titleLabel.numberOfLines = 2;

        self.subTitleLabel = [UILabel ll_labelWithFrame:CGRectZero text:@"聊天案例" font:[UIFont systemFontOfSize:12] textColor:LLTheme.subTitleColor textAlign:NSTextAlignmentLeft];
        
        self.line = [[UIView alloc] initWithFrame:CGRectZero];
        self.line.backgroundColor = LLTheme.mainColor;
        
        [self addSubview:self.thumbView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
        [self addSubview:self.line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat titleH = 34;
    self.thumbView.frame = CGRectMake(13, (self.height - 58)/2.0, 58, 58);
    self.titleLabel.frame = CGRectMake(self.thumbView.right + 13, 7, CGRectGetWidth(self.bounds) - self.thumbView.right - 26, titleH);
    self.subTitleLabel.frame = CGRectMake(self.titleLabel.left, self.height - 7 - 14, 80, 14);
    self.line.frame = CGRectMake(0, self.height - 1, self.width, 1);
}

- (void)setModel:(id)model {
    [super setModel:model];
    LLChatItemModel *item = model;
    self.titleLabel.text = item.title;
}

@end
