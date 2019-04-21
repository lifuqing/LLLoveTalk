//
//  LLTagExampleListResponseModel.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/14.
//

#import "LLTagExampleListResponseModel.h"
@implementation LLTagExampleModel

- (NSDictionary *)textAttributes {
    if (!_textAttributes) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;
        //        paragraph.minimumLineHeight =
        paragraphStyle.minimumLineHeight = 18;
        paragraphStyle.maximumLineHeight = 18;
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16],
                                     NSForegroundColorAttributeName : LLTheme.titleColor,
                                     NSParagraphStyleAttributeName : paragraphStyle};
        _textAttributes = attributes;
    }
    return _textAttributes;
}

@end

@implementation LLTagExampleListResponseModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [LLTagExampleModel class]};
}
@end
