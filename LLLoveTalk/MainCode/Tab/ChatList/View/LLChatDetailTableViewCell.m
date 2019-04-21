//
//  LLChatDetailTableViewCell.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/17.
//

#import "LLChatDetailTableViewCell.h"

@interface LLChatDetailTableViewCell ()
@property (nonatomic, strong) UIImageView *thumbView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@end

@implementation LLChatDetailTableViewCell

+ (CGFloat)cellHeightWithModel:(nullable id)model {
    LLChatDetailItemModel *item = model;
    return item.width ? (item.height * SCREEN_WIDTH * 1.0 / item.width) : (SCREEN_HEIGHT - SafeNavBarHeight);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.thumbView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:self.thumbView];
        [self.thumbView addSubview:self.indicator];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.thumbView.frame = CGRectMake(0, 0, self.width, [[self class] cellHeightWithModel:self.model]);
    self.indicator.center = CGPointMake(self.thumbView.width/2.0, self.thumbView.height/2.0);
}

- (void)setModel:(id)model {
    [super setModel:model];
    __block LLChatDetailItemModel *item = model;
    
    if (!self.thumbView.image) {
        [self.indicator startAnimating];
    }
    
    WEAKSELF();
    if (item.width > 0 && item.height > 0) {
        [self.thumbView yy_setImageWithURL:[NSURL URLWithString:item.url] placeholder:nil options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            [weakSelf.indicator stopAnimating];
        }];
    }
    else {
        [self.thumbView yy_setImageWithURL:[NSURL URLWithString:item.url] placeholder:nil options:YYWebImageOptionAvoidSetImage completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            if (image) {
                [weakSelf.indicator stopAnimating];
            }
            
            if (image && (item.width == 0 || item.height == 0)) {
                item.width = image.size.width;
                item.height = image.size.height;
                if (weakSelf.imageDownloadFinishBlock) {
                    weakSelf.imageDownloadFinishBlock();
                }
            }
        }];
    }
}
@end
