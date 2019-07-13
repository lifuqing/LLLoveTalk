//
//  LLImageTools.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/7/2.
//

#import "LLImageTools.h"
@interface LLImageTools ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray <UIImageView *> *imageViews;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation LLImageTools
//
//+ (void)showWithUrls:(NSArray <NSString *> *)urls defaultIndex:(NSUInteger)defaultIndex {
//    LLImageTools *tools = [[LLImageTools alloc] init];
//    tools.imageViews = [NSMutableArray array];
//    [urls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0 + idx * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
//        [view sd_setImageWithURL:[NSURL URLWithString:obj]];
//        view.centerY = SCREEN_HEIGHT/2.0;
//        [tools.imageViews addObject:view];
//        [tools.scrollView addSubview:view];
//    }];
//    tools.pageControl.numberOfPages = tools.imageViews.count;
//    
//    [[UIApplication sharedApplication].keyWindow addSubview:tools.scrollView];
//    [[UIApplication sharedApplication].keyWindow addSubview:tools.pageControl];
//    
//}
//
//+ (void)showWithImages:(NSArray <UIImage *> *)images defaultIndex:(NSUInteger)defaultIndex {
//    
//}
//
//- (UIScrollView *)scrollView {
//    if (!_scrollView) {
//        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
//        _scrollView.backgroundColor = [UIColor blackColor];
//        _scrollView.pagingEnabled = YES;
//    }
//    return _scrollView;
//}
//
//- (UIPageControl *)pageControl {
//    if (!_pageControl) {
//        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 100)];
//        _pageControl.backgroundColor = [UIColor redColor];
//    }
//    return _pageControl;
//}



static CGRect oldframe;

+(void)scanBigImageWithImage:(UIImage *)image frame:(CGRect)pOldframe canSaveToAlbum:(BOOL)canSave{
    oldframe = pOldframe;
    //当前视图
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//    [backgroundView setBackgroundColor:[UIColor colorWithRed:107/255.0 green:107/255.0 blue:99/255.0 alpha:0.6]];
    [backgroundView setBackgroundColor:[UIColor blackColor]];
    //此时视图不会显示
    [backgroundView setAlpha:0];
    //将所展示的imageView重新绘制在Window中
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
    [imageView setImage:image];
    [imageView setTag:1024];
    [backgroundView addSubview:imageView];
    //将原始视图添加到背景视图中
    [LLNav.windowsRootViewController.view addSubview:backgroundView];
    
    //添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [backgroundView addGestureRecognizer:tapGestureRecognizer];
    
    //动画放大所展示的ImageView
    
    [UIView animateWithDuration:0.4 animations:^{
        CGFloat y,width,height;
        y = ([UIScreen mainScreen].bounds.size.height - image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width) * 0.5;
        //宽度为屏幕宽度
        width = [UIScreen mainScreen].bounds.size.width;
        //高度 根据图片宽高比设置
        height = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
        [imageView setFrame:CGRectMake(0, y, width, height)];
        
        //重要！ 将视图显示出来
        [backgroundView setAlpha:1];
    } completion:^(BOOL finished) {
        if (canSave) {
            imageView.userInteractionEnabled = YES;
            //创建长按手势
            UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imglongTapClick:)];
            //添加手势
            [imageView addGestureRecognizer:longTap];
        }
        
    }];
    
}

/**
 *  @param contentImageview 图片所在的imageView
 */

+(void)ImageZoomWithImageView:(UIImageView *)contentImageview{
    [self ImageZoomWithImageView:contentImageview canSaveToAlbum:NO];
}

+(void)ImageZoomWithImageView:(UIImageView *)contentImageview canSaveToAlbum:(BOOL)canSave {
    
    //    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self scanBigImageWithImage:contentImageview.image frame:[contentImageview convertRect:contentImageview.bounds toView:LLNav.windowsRootViewController.view] canSaveToAlbum:canSave];
}
/**
 *  恢复imageView原始尺寸
 *
 *  @param tap 点击事件
 */
+(void)hideImageView:(UITapGestureRecognizer *)tap{
    UIView *backgroundView = tap.view;
    //原始imageview
    UIImageView *imageView = [tap.view viewWithTag:1024];
    //恢复
    [UIView animateWithDuration:0.3 animations:^{
        [imageView setFrame:oldframe];
        [backgroundView setAlpha:0];
    } completion:^(BOOL finished) {
        [imageView.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UILongPressGestureRecognizer class]]) {
                [imageView removeGestureRecognizer:obj];
            }
        }];
        imageView.userInteractionEnabled = NO;
        //完成后操作->将背景视图删掉
        [backgroundView removeFromSuperview];
    }];
}

+ (void)imglongTapClick:(UILongPressGestureRecognizer*)gesture

{
    
    if(gesture.state==UIGestureRecognizerStateBegan)
        
    {
        
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"保存图片" message:nil preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

            NSLog(@"取消保存图片");
        }];

        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

            NSLog(@"确认保存图片");
        
            // 保存图片到相册
            UIImageWriteToSavedPhotosAlbum(((UIImageView *)gesture.view).image,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
            
        }];

        [alertControl addAction:cancel];
        [alertControl addAction:confirm];

        [LLNav.windowsRootViewController presentViewController:alertControl animated:YES completion:nil];
        
    }
    
}

+ (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:  (NSError*)error contextInfo:(id)contextInfo

{
    NSString *message;
    
    if(!error) {
        
        message =@"成功保存到相册";
        
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertControl addAction:action];
        
        [LLNav.windowsRootViewController presentViewController:alertControl animated:YES completion:nil];
        
    }else
        
    {
        
        message = [error description];
        
        
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertControl addAction:action];
        
        [LLNav.windowsRootViewController presentViewController:alertControl animated:YES completion:nil];
        
    }
    
}
@end
