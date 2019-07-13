//
//  UIImage+LLTools.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/7/3.
//

#import "UIImage+LLTools.h"

@implementation UIImage (LLTools)
+ (UIImage *)ll_createImageWithColor:(UIColor *)color {
    //图片尺寸
    CGRect rect = CGRectMake(0, 0, 1, 1);
    //填充画笔
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //根据所传颜色绘制
    CGContextSetFillColorWithColor(context, color.CGColor);
    //显示区域
    CGContextFillRect(context, rect);
    //得到图片信息
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    //消除画笔
    UIGraphicsEndImageContext();
    return image;
}
@end
