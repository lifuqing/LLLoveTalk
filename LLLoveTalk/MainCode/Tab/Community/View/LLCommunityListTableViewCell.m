//
//  LLCommunityListTableViewCell.m
//  LLAiLove
//
//  Created by lifuqing on 2019/6/26.
//

#import "LLCommunityListTableViewCell.h"
#import <DateTools/NSDate+DateTools.h>
#import "LLLoginViewController.h"

NSNotificationName const kFavoriteStatusChangedNotification = @"kFavoriteStatusChanged";

@interface LLCommunityListTableViewCell()
@property (nonatomic, strong) UIImageView *headIcon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) NSMutableArray <UIImageView *> *photoViews;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *favorButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIView *line;

@end

@implementation LLCommunityListTableViewCell

+ (CGFloat)cellHeightWithModel:(LLCommunityItemModel *)model {
    CGFloat contentW = SCREEN_WIDTH - 62 - 18;
    
    return 40 + MIN([model.text boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin  attributes:model.textAttributes context:nil].size.height, 40) + 46 + (model.images.count > 0 ? [self realPhotoWidth] + 15 : 0);
}

+ (CGFloat)realPhotoWidth {
    return MIN((SCREEN_WIDTH - 62 - 15 - 2*7)/3.0, 95);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.photoViews = [NSMutableArray array];
        
        self.headIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.headIcon.layer.cornerRadius = 4;
        self.headIcon.layer.masksToBounds = YES;
        self.headIcon.contentMode = UIViewContentModeScaleAspectFill;
        
        self.nameLabel = [UILabel ll_labelWithFrame:CGRectZero text:@"" font:[UIFont fontWithName:@"PingFang-SC-Heavy" size: 14] textColor:LLTheme.titleSecondColor textAlign:NSTextAlignmentLeft];
        
        self.messageLabel = [UILabel ll_labelWithFrame:CGRectZero text:@"" font:[UIFont fontWithName:@"PingFang-SC-Medium" size: 14] textColor:LLTheme.titleSecondColor textAlign:NSTextAlignmentLeft];
        self.messageLabel.numberOfLines = 2;
        
        self.timeLabel = [UILabel ll_labelWithFrame:CGRectZero text:@"" font:[UIFont fontWithName:@"PingFang-SC-Medium" size: 10] textColor:LLTheme.subTitleColor textAlign:NSTextAlignmentLeft];
        
        self.favorButton = [UIButton ll_buttonWithFrame:CGRectZero target:self normalImage:LLImage(@"icon_favor_normal") selector:@selector(favorButtonActionClick:)];
        [self.favorButton setImage:LLImage(@"icon_favor_selected") forState:UIControlStateSelected];
        
        [self.favorButton setTitleColor:LLTheme.subTitleColor forState:UIControlStateNormal];
        self.favorButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 13];
        
        self.commentButton = [UIButton ll_buttonWithFrame:CGRectZero target:self normalImage:LLImage(@"icon_comment") selector:@selector(commentButtonActionClick:)];
        self.commentButton.userInteractionEnabled = NO;
        [self.commentButton setTitleColor:LLTheme.subTitleColor forState:UIControlStateNormal];
        self.commentButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 13];
        
        self.line = [[UIView alloc] initWithFrame:CGRectZero];
        self.line.backgroundColor = LLTheme.lineColor;
        
        [self addSubview:self.headIcon];
        [self addSubview:self.nameLabel];
        [self addSubview:self.messageLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.favorButton];
        [self addSubview:self.commentButton];
        [self addSubview:self.line];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favoriteStatusChangedNotification:) name:kFavoriteStatusChangedNotification object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.headIcon.frame = CGRectMake(15, 15, 36, 36);
    self.nameLabel.frame = CGRectMake(self.headIcon.right + 11 , 18, self.width - (self.headIcon.right + 11) - 18, 14);
    CGFloat messageWidth = SCREEN_WIDTH - 62 - 18;
    CGFloat messageheight = MIN([((LLCommunityItemModel *)self.model).text boundingRectWithSize:CGSizeMake(messageWidth, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin  attributes:((LLCommunityItemModel *)self.model).textAttributes context:nil].size.height, 40);
    
    self.messageLabel.frame = CGRectMake(62, self.nameLabel.bottom + 8, messageWidth, messageheight);
    CGFloat w = [LLCommunityListTableViewCell realPhotoWidth];
    [self.photoViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(62 + idx * (w + 7), self.messageLabel.bottom + 15, w, w);
    }];
    
    self.timeLabel.frame = CGRectMake(self.messageLabel.left, self.messageLabel.bottom + 15 + w + 18, 80, 10);
    self.favorButton.frame = CGRectMake(self.width - 90 - 60, self.timeLabel.top - 4, 60, 18);
    
    self.commentButton.frame = CGRectMake(self.width - 15 - 60, self.favorButton.top, 60, 18);
    
    self.line.frame = CGRectMake(0, self.height - 1, self.width, 1);
}

- (void)setModel:(id)model {
    [super setModel:model];
    LLCommunityItemModel *itemModel = model;
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:itemModel.head_file] placeholderImage:[UIImage ll_createImageWithColor:[UIColor colorWithWhite:0.9 alpha:1]]];
    self.nameLabel.text = itemModel.username;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:itemModel.text?:@"" attributes:itemModel.textAttributes];
    self.messageLabel.attributedText = attr;
    
    [self.photoViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.photoViews removeAllObjects];
    
    [itemModel.images enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 95, 95)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = 4;
        imageView.layer.masksToBounds = YES;
        imageView.tag = 1000 + idx;
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:[UIImage ll_createImageWithColor:[UIColor colorWithWhite:0.9 alpha:1]]];
        [self.photoViews addObject:imageView];
        [self addSubview:imageView];
    }];
    
    self.timeLabel.text = [NSDate timeAgoSinceDate:[NSDate dateWithTimeIntervalSince1970:itemModel.publish_time]];
    
    [self.favorButton setTitle:[NSString stringWithFormat:@"%ld", itemModel.likes] forState:UIControlStateNormal];
    
    self.favorButton.selected = itemModel.collect;
    
    [self.commentButton setTitle:[NSString stringWithFormat:@"%ld", itemModel.comments_count] forState:UIControlStateNormal];
    
    [self setNeedsLayout];
}

- (void)favoriteStatusChangedNotification:(NSNotification *)notify {
    NSDictionary *dict = notify.object;
    NSString *contentid = dict[@"contentid"];
    BOOL collect = [dict[@"collect"] boolValue];
    NSInteger likes = [dict[@"likes"] integerValue];
    LLCommunityItemModel *itemModel = self.model;
    if ([itemModel.contentid isEqualToString:contentid]) {
        itemModel.collect = collect;
        itemModel.likes = likes;
        self.model = itemModel;
    }
}

- (void)favorButtonActionClick:(UIButton *)sender {
    if (![LLUser sharedInstance].isLogin) {
        LLLoginViewController *vc = [[LLLoginViewController alloc] init];
        [[LLNav topViewController] presentViewController:vc animated:YES completion:nil];
        return;
    }
    
    LLCommunityItemModel *itemModel = self.model;
    sender.enabled = NO;
    LLURL *llurl = [[LLURL alloc] initWithParser:@"CollectParser" urlConfigClass:[LLAiLoveURLConfig class]];
    [llurl.params addEntriesFromDictionary:@{@"contentid":itemModel.contentid?:@"", @"cancel":itemModel.collect?@"1" :@"0"}];
    [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:self success:^(NSURLResponse * _Nullable response, NSDictionary * _Nullable result, LLBaseResponseModel * _Nullable model, BOOL isLocalCache) {
        sender.enabled = YES;
        BOOL status = !itemModel.collect;
        NSInteger count = 0;
        
        if (result[@"data"][@"likes_count"]) {
            count = [result[@"data"][@"likes_count"] integerValue];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kFavoriteStatusChangedNotification object:@{@"contentid":itemModel.contentid, @"collect":@(status), @"likes":@(count)}];
    } failure:^(NSURLResponse * _Nullable response, NSError * _Nullable error, LLBaseResponseModel * _Nullable model) {
        sender.enabled = YES;
    }];
    
    if (self.favoriteActionBlock) {
        self.favoriteActionBlock(sender, self.model);
    }
}

- (void)commentButtonActionClick:(UIButton *)sender {
    
}

- (void)setPhotoViewActionBlock:(void (^)(UIImageView * _Nonnull, LLCommunityItemModel * _Nonnull))photoViewActionBlock {
    _photoViewActionBlock = photoViewActionBlock;
    
    [self.photoViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.userInteractionEnabled = NO;
        [[obj gestureRecognizers] enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj1 isMemberOfClass:[UITapGestureRecognizer class]]) {
                [obj removeGestureRecognizer:obj1];
            }
        }];
    }];
    
    if (_photoViewActionBlock) {
        [self.photoViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [obj addGestureRecognizer:tap];
        }];
    }
}

- (void)tapAction:(UIGestureRecognizer *)gesture {
    if (_photoViewActionBlock) {
        if (gesture.view) {
            _photoViewActionBlock((UIImageView *)gesture.view, self.model);
        }
        
    }
}
@end
