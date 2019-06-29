//
//  LLExampleTableViewCell.m
//  LLAiLove
//
//  Created by lifuqing on 2019/4/14.
//

#import "LLExampleTableViewCell.h"
#import "LLTagExampleListResponseModel.h"

#define kContentWidth (SCREEN_WIDTH - 40)

@interface UICopyTextView : UITextView

@end

@implementation UICopyTextView


- (BOOL)canBecameFirstResponder {
    return YES;
}

/* 选中文字后的菜单响应的选项 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copy:) ||
        action == @selector(selectAll:)) {
        return YES;
    }
    // 事实上一个return NO就可以将系统的所有菜单项全部关闭了
    return NO;
    
}
@end



@interface LLExampleTableViewCell () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UICopyTextView *titleTextView;
@property (nonatomic, strong) UIView *line;
@end

@implementation LLExampleTableViewCell

+ (CGFloat)cellHeightWithModel:(LLTagExampleModel *)model {
    return [model.dialog boundingRectWithSize:CGSizeMake(kContentWidth, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin  attributes:model.textAttributes context:nil].size.height + 16;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.titleTextView = [UICopyTextView ll_textViewWithFrame:CGRectZero];
        CGFloat padding = self.titleTextView.textContainer.lineFragmentPadding;
        
        self.titleTextView.textContainerInset = UIEdgeInsetsMake(0, -padding, 0, -padding);
        
//        self.titleTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //当光标在最后一行时，始终显示低边距，需使用contentInset设置bottom.
        self.titleTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //防止在拼音打字时抖动
        self.titleTextView.layoutManager.allowsNonContiguousLayout=NO;
        self.titleTextView.scrollEnabled = NO;
        
        self.line = [[UIView alloc] initWithFrame:CGRectZero];
        self.line.backgroundColor = LLTheme.mainColor;
        
        [self addSubview:self.titleTextView];
        [self addSubview:self.line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleTextView.frame = CGRectMake(20, 8, kContentWidth, self.height - 16);
    self.line.frame = CGRectMake(0, self.height - 1, self.width, 1);
}

- (void)setModel:(id)model {
    [super setModel:model];
    LLTagExampleModel *exampleModel = model;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:exampleModel.dialog?:@"" attributes:exampleModel.textAttributes];
    self.titleTextView.attributedText = attr;
}

@end
