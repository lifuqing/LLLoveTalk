//
//  LLCommentTableViewCell.m
//  LLAiLove
//
//  Created by lifuqing on 2019/6/26.
//

#import "LLCommentTableViewCell.h"
#import "LLCommentListResponseModel.h"
#import <DateTools/NSDate+DateTools.h>

@interface LLCommentTableViewCell()
@property (nonatomic, strong) UIImageView *headIcon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *floorLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation LLCommentTableViewCell

+ (CGFloat)cellHeightWithModel:(LLCommentItemModel *)model {
    CGFloat contentW = SCREEN_WIDTH - 62 - 18;
    
    return 34 + [model.comment boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin  attributes:model.textAttributes context:nil].size.height + 36;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.headIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.headIcon.layer.cornerRadius = 4;
        self.headIcon.layer.masksToBounds = YES;
        
        self.nameLabel = [UILabel ll_labelWithFrame:CGRectZero text:@"" font:[UIFont fontWithName:@"PingFang-SC-Heavy" size: 14] textColor:LLTheme.titleSecondColor textAlign:NSTextAlignmentLeft];
        
        self.messageLabel = [UILabel ll_labelWithFrame:CGRectZero text:@"" font:[UIFont fontWithName:@"PingFang-SC-Medium" size: 14] textColor:LLTheme.titleSecondColor textAlign:NSTextAlignmentLeft];
        self.messageLabel.numberOfLines = 2;
        
        self.floorLabel = [UILabel ll_labelWithFrame:CGRectZero text:@"1楼" font:[UIFont fontWithName:@"PingFang-SC-Medium" size: 10] textColor:LLTheme.subTitleColor textAlign:NSTextAlignmentCenter];
        
        self.timeLabel = [UILabel ll_labelWithFrame:CGRectZero text:@"" font:[UIFont fontWithName:@"PingFang-SC-Medium" size: 10] textColor:LLTheme.subTitleColor textAlign:NSTextAlignmentLeft];
        
        self.line = [[UIView alloc] initWithFrame:CGRectZero];
        self.line.backgroundColor = LLTheme.lineColor;
        
        [self addSubview:self.headIcon];
        [self addSubview:self.nameLabel];
        [self addSubview:self.messageLabel];
        [self addSubview:self.floorLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.headIcon.frame = CGRectMake(15, 15, 36, 36);
    self.nameLabel.frame = CGRectMake(self.headIcon.right + 10 , 18, self.width - 60 - 18, 14);
    CGFloat messageWidth = SCREEN_WIDTH - 62 - 18;
    CGFloat messageheight = [((LLCommentItemModel *)self.model).comment boundingRectWithSize:CGSizeMake(messageWidth, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin  attributes:((LLCommunityItemModel *)self.model).textAttributes context:nil].size.height;
    
    self.messageLabel.frame = CGRectMake(62, self.nameLabel.bottom + 8, messageWidth, messageheight);
    
    self.timeLabel.frame = CGRectMake(self.messageLabel.left, self.height - 18, 80, 10);
    
    self.floorLabel.frame = CGRectMake(self.headIcon.left, self.timeLabel.top, self.headIcon.width, self.timeLabel.height);
    
    self.line.frame = CGRectMake(0, self.height - 1, self.width, 1);
}

- (void)setModel:(id)model {
    [super setModel:model];
    LLCommentItemModel *itemModel = model;
    
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:itemModel.head_file]];
    self.nameLabel.text = itemModel.username;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:itemModel.comment?:@"" attributes:itemModel.textAttributes];
    self.messageLabel.attributedText = attr;
    
    self.floorLabel.text = itemModel.floor;
    self.timeLabel.text = [NSDate timeAgoSinceDate:[NSDate dateWithTimeIntervalSince1970:itemModel.publish_time]];
    
    [self setNeedsLayout];
}


@end
