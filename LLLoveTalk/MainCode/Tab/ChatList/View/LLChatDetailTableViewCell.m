//
//  LLChatDetailTableViewCell.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/17.
//

#import "LLChatDetailTableViewCell.h"

@interface LLChatDetailTableViewCell ()
@property (nonatomic, strong) UIImageView *thumbView;

@end

@implementation LLChatDetailTableViewCell

+ (CGFloat)cellHeightWithModel:(nullable id)model {
    LLChatDetailItemModel *item = model;
    return item.height * SCREEN_WIDTH / item.width * 1.0;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.thumbView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [self addSubview:self.thumbView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.thumbView.frame = CGRectMake(0, 0, self.width, [[self class] cellHeightWithModel:self.model]);
}

- (void)setModel:(id)model {
    [super setModel:model];
    LLChatDetailItemModel *item = model;
    [self.thumbView yy_setImageWithURL:[NSURL URLWithString:item.url] options:YYWebImageOptionProgressive];
}
@end
