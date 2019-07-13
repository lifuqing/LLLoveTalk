//
//  LLImageTools.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/7/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLImageTools : NSObject

//+ (void)showWithUrls:(NSArray <NSString *> *)urls defaultIndex:(NSUInteger)defaultIndex;
//
//+ (void)showWithImages:(NSArray <UIImage *> *)images defaultIndex:(NSUInteger)/defaultIndex;
//

/**
 点击全屏展示图片，不支持长按保存
 */
+(void)ImageZoomWithImageView:(UIImageView *)contentImageview;

/**
 点击全屏展示图片，长按可选择保存

 @param contentImageview 图片所在的imageView
 @param canSave 是否可以长按保存
 */
+(void)ImageZoomWithImageView:(UIImageView *)contentImageview canSaveToAlbum:(BOOL)canSave;
@end

NS_ASSUME_NONNULL_END
