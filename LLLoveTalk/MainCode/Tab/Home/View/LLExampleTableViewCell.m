//
//  LLExampleTableViewCell.m
//  LLLoveTalk
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
@property (nonatomic, strong) UICopyTextView *titleLabel;
@property (nonatomic, strong) UIView *line;
@end

@implementation LLExampleTableViewCell

+ (CGFloat)cellHeightWithModel:(LLTagExampleModel *)model {
    return [model.dialog boundingRectWithSize:CGSizeMake(kContentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height + 16;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel = [UICopyTextView ll_textViewWithFrame:CGRectZero text:@"" font:[UIFont systemFontOfSize:14] textColor:LLTheme.titleColor textAlign:NSTextAlignmentLeft];
        
        self.titleLabel.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //当光标在最后一行时，始终显示低边距，需使用contentInset设置bottom.
        self.titleLabel.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //防止在拼音打字时抖动
        self.titleLabel.layoutManager.allowsNonContiguousLayout=NO;
        self.titleLabel.scrollEnabled = NO;
        
        self.line = [[UIView alloc] initWithFrame:CGRectZero];
        self.line.backgroundColor = LLTheme.mainColor;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.line];
        
//        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
//        longPress.delegate = self;
//        longPress.minimumPressDuration = 1;
//        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(20, 8, kContentWidth, self.height - 16);
    self.line.frame = CGRectMake(0, self.height - 1, self.width, 1);
}

- (void)setModel:(id)model {
    [super setModel:model];
    LLTagExampleModel *exampleModel = model;
    self.titleLabel.text = exampleModel.dialog;
}

//- (void)longPressAction:(UILongPressGestureRecognizer *)ges {
//    if (self.longPressBlock) {
//        self.longPressBlock(self.model);
//    }
//
//}

@end
