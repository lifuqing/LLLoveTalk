//
//  LLExampleTableViewCell.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/14.
//

#import "LLExampleTableViewCell.h"
#import "LLTagExampleListResponseModel.h"

@interface LLExampleTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation LLExampleTableViewCell


+ (CGFloat)cellHeightWithModel:(LLTagExampleModel *)model {
    return [model.dialog boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel = [UILabel labelWithFrame:CGRectZero text:@"" font:[UIFont systemFontOfSize:14] textColor:LLTheme.titleColor textAlign:NSTextAlignmentLeft];
        self.titleLabel.numberOfLines = 0;
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setModel:(id)model {
    [super setModel:model];
    LLTagExampleModel *exampleModel = model;
    self.titleLabel.text = exampleModel.dialog;
}

@end
