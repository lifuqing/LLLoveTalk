//
//  LLCommunityNewStatusViewController.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/7/3.
//

#import "LLCommunityNewStatusViewController.h"
#import "UIImage+LLTools.h"
#import "LLImageTools.h"
#import <HXPhotoPicker/HXPhotoPicker.h>
#import "AppDelegate.h"
@interface LLImageModel : NSObject
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) BOOL hasUpload;
@end
@implementation LLImageModel


@end
@interface LLCommunityNewStatusViewController () <UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableArray <LLImageModel *> *photos;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) HXPhotoManager *manager;

@end

@implementation LLCommunityNewStatusViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.photos = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBackBarItemWithTitle:@"发布动态"];
    
    [self.view addSubview:self.textView];
    
    [self.view addSubview:self.contentView];
    
    [self.view addSubview:self.sendButton];
    
    [self layoutUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:nil];
}

#pragma mark - public

#pragma mark - private

- (void)textViewTextDidChangeNotification:(NSNotification *)notify {
    [self handleStatus];
}
- (void)handleStatus {
    if (self.textView.text.length > 0 && self.photos.count > 0) {
        self.sendButton.enabled = YES;
    }
    else {
        self.sendButton.enabled = NO;
    }
}
- (void)layoutUI {
    [[_contentView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    CGFloat w = [self realPhotoWidth];
    [self.photos enumerateObjectsUsingBlock:^(LLImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15 + (w + 15) * idx, 15, w, w)];
        imgView.image = obj.image;
        imgView.userInteractionEnabled = YES;
        imgView.layer.cornerRadius = 6;
        imgView.layer.masksToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhoto:)];
        [imgView addGestureRecognizer:tap];
        [self.contentView addSubview:imgView];
        
        UIButton *closeBtn = [UIButton ll_buttonWithFrame:CGRectMake(imgView.right - 15, imgView.top - 15, 30, 30) target:self normalImage:LLImage(@"icon_community_delete") selector:@selector(closeBtnActionClick:)];
        closeBtn.adjustsImageWhenHighlighted = NO;
        closeBtn.tag = 888+idx;
        [self.contentView addSubview:closeBtn];
    }];
    
    if (self.photos.count < 3) {
        [self.contentView addSubview:self.addButton];
        self.addButton.frame = CGRectMake(15 + (w + 15) * self.photos.count, 15, w, w);
    }
    [self handleStatus];
}

- (CGFloat)realPhotoWidth {
    return MIN((SCREEN_WIDTH - 4*15)/3.0, 75);
}

#pragma mark - action
- (void)tapPhoto:(UITapGestureRecognizer *)tap {
    UIImageView *photo = (UIImageView *)tap.view;
    [LLImageTools ImageZoomWithImageView:photo canSaveToAlbum:NO];
}

- (void)addButtonActionClick:(UIButton *)sender {
    
    HXWeakSelf
    [self hx_presentSelectPhotoControllerWithManager:self.manager didDone:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL isOriginal, UIViewController *viewController, HXPhotoManager *manager) {
        NSSLog(@"block - all - %@",allList);
        NSSLog(@"block - photo - %@",photoList);
        NSSLog(@"block - video - %@",videoList);
        [photoList hx_requestImageWithOriginal:NO completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
            NSSLog(@"images - %@", imageArray);
            [weakSelf.photos removeAllObjects];
            
            [imageArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                LLImageModel *model = [[LLImageModel alloc] init];
                model.image = obj;
                model.identifier = [[NSString stringWithFormat:@"image_%@_%lu.png", @([[NSDate date] timeIntervalSince1970]), idx] llurlMd5Digest];
                
                [weakSelf.photos addObject:model];
            }];
            
            [weakSelf layoutUI];

        }];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
        NSSLog(@"block - 取消了");
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }];
    
}

- (void)closeBtnActionClick:(UIButton *)sender {
    NSInteger idx = sender.tag - 888;
    if (self.photos.count > idx) {
        HXPhotoModel *model = self.manager.afterSelectedPhotoArray[idx];
        [self.manager afterSelectedListdeletePhotoModel:model];
        [self changeSelectedListModelIndex];
        [self.photos removeObjectAtIndex:idx];
        [self layoutUI];
    }
}

- (void)changeSelectedListModelIndex {
    int i = 0;
    for (HXPhotoModel *model in self.manager.afterSelectedPhotoArray) {
        model.selectedIndex = i;
        model.selectIndexStr = [NSString stringWithFormat:@"%d",i + 1];
        i++;
    }
}

- (void)sendButtonActionClick:(UIButton *)sender {
    [self.textView resignFirstResponder];
    sender.enabled = NO;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WEAKSELF();
    [self uploadImageModelsCompletion:^(NSArray<LLImageModel *> *resultModels) {
        NSArray <LLImageModel *> *noUploadModels = [resultModels filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hasUpload == 0"]];
        if (noUploadModels.count > 0) {
            [MBProgressHUD showMessage:[NSString stringWithFormat:@"您有%@张图片上传失败", @(noUploadModels.count)] inView:weakSelf.view autoHideTime:1];
            sender.enabled = YES;
        }
        else {
            LLURL *llurl = [[LLURL alloc] initWithParser:@"SendPlazaParser" urlConfigClass:[LLAiLoveURLConfig class]];
            [llurl.params addEntriesFromDictionary:@{@"text":weakSelf.textView.text?:@""}];
            NSArray <NSString *> *identifierArr = [resultModels valueForKey:@"identifier"];
            [llurl.params addEntriesFromDictionary:@{@"images":[identifierArr componentsJoinedByString:@","]?:@""}];
            
            [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:weakSelf success:^(NSURLResponse * _Nullable response, NSDictionary * _Nullable result, LLBaseResponseModel * _Nullable model, BOOL isLocalCache) {
                sender.enabled = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kCommunityNewStatusCreateSuccessNotification" object:nil];
                [MBProgressHUD showMessage:@"发布成功" inView:weakSelf.view autoHideTime:1 interactionEnabled:NO completion:^{
                    [weakSelf commonPushBack];
//                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            } failure:^(NSURLResponse * _Nullable response, NSError * _Nullable error, LLBaseResponseModel * _Nullable model) {
                sender.enabled = YES;
                [MBProgressHUD showMessage:model.errorMsg ?: @"发布失败" inView:weakSelf.view autoHideTime:1];
            }];
        }
    }];
    
    
}

- (void)uploadImageModelsCompletion:(void (^)(NSArray <LLImageModel *> *resultModels))completion {
    __block NSInteger resultCount = 0;
    [self.photos enumerateObjectsUsingBlock:^(LLImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self uploadWithImageModel:obj completion:^(BOOL success, NSError *error) {
            resultCount++;
            obj.hasUpload = success;
            if (resultCount == self.photos.count) {
                if (completion) {
                    completion(self.photos);
                }
            }
        }];
    }];
}

- (void)uploadWithImageModel:(LLImageModel *)imageModel completion:(void (^)(BOOL success, NSError *error))completion {
    if (imageModel.hasUpload) {
        if (completion) {
            completion(YES, nil);
        }
        return;
    }
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // 必填字段
//    put.bucketName = @"<bucketName>";
//    put.objectKey = @"<objectKey>";
    put.bucketName = [LLConfig sharedInstance].OSS_BUCKETNAME;
    
    put.objectKey = imageModel.identifier;
    
    put.isAuthenticationRequired = YES;
//    put.uploadingFileURL = [NSURL fileURLWithPath:@"<filepath>"];
    put.uploadingData = UIImagePNGRepresentation(imageModel.image);
    // 可选字段，可不设置
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
        NSSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    // 以下可选字段的含义参考： https://docs.aliyun.com/#/pub/oss/api-reference/object&PutObject
    // put.contentType = @"";
    // put.contentMd5 = @"";
    // put.contentEncoding = @"";
    // put.contentDisposition = @"";
    // put.objectMeta = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value1", @"x-oss-meta-name1", nil]; // 可以在上传时设置元信息或者其他HTTP头部
    OSSTask * putTask = [appdelegate.client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSSLog(@"upload object success! task = %@", task);
        } else {
            NSSLog(@"upload object failed, error: %@" , task.error);
        }
        if (completion) {
            completion(!task.error, task.error);
        }
        return nil;
    }];
//     [putTask waitUntilFinished];
    // [put cancel];
}
#pragma mark - lazyloading

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 14, self.view.width - 30, 80)];
        _textView.placeholder = @"此时此地，想和大家分享什么？";
        _textView.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 14];
        _textView.delegate = self;
    }
    return _textView;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 105, self.view.width, 90)];
    }
    return _contentView;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton ll_buttonWithFrame:CGRectZero target:self normalImage:LLImage(@"icon_community_add") selector:@selector(addButtonActionClick:)];
        [_addButton setBackgroundColor:RGBS(224)];
        _addButton.adjustsImageWhenHighlighted = NO;
        _addButton.layer.cornerRadius = 6;
        _addButton.layer.masksToBounds = YES;
    }
    return _addButton;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton ll_buttonWithFrame:CGRectMake(15, _contentView.bottom + 25, self.view.width - 30, 44) target:self title:@"发送" font:[UIFont fontWithName:@"PingFang-SC-Bold" size: 16] textColor:[UIColor whiteColor] selector:@selector(sendButtonActionClick:)];
        [_sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_sendButton setBackgroundImage:[UIImage ll_createImageWithColor:RGBS(208)] forState:UIControlStateDisabled];
        [_sendButton setBackgroundImage:[UIImage ll_createImageWithColor:LLTheme.mainColor] forState:UIControlStateNormal];
        _sendButton.layer.cornerRadius = 6;
        _sendButton.layer.masksToBounds = YES;
        _sendButton.enabled = NO;
        _sendButton.adjustsImageWhenHighlighted = NO;
    }
    return _sendButton;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_textView resignFirstResponder];
}




- (HXPhotoManager *)manager
{
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.deleteTemporaryPhoto = NO;
        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.supportRotation =NO;
        _manager.configuration.cameraCellShowPreview = NO;
        _manager.configuration.hideOriginalBtn = YES;
        _manager.configuration.photoMaxNum = 3;
        _manager.configuration.open3DTouchPreview = NO;
        _manager.configuration.photoCanEdit = NO;
        
        __weak typeof(self) weakSelf = self;
        // 使用自动的相机  这里拿系统相机做示例
        _manager.configuration.shouldUseCamera = ^(UIViewController *viewController, HXPhotoConfigurationCameraType cameraType, HXPhotoManager *manager) {
            
            // 这里拿使用系统相机做例子
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = (id)weakSelf;
            imagePickerController.allowsEditing = NO;
            NSString *requiredMediaTypeImage = ( NSString *)kUTTypeImage;
            NSString *requiredMediaTypeMovie = ( NSString *)kUTTypeMovie;
            NSArray *arrMediaTypes;
            if (cameraType == HXPhotoConfigurationCameraTypePhoto) {
                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeImage,nil];
            }else if (cameraType == HXPhotoConfigurationCameraTypeVideo) {
                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeMovie,nil];
            }else {
                arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeImage, requiredMediaTypeMovie,nil];
            }
            [imagePickerController setMediaTypes:arrMediaTypes];
            // 设置录制视频的质量
            [imagePickerController setVideoQuality:UIImagePickerControllerQualityTypeHigh];
            //设置最长摄像时间
            [imagePickerController setVideoMaximumDuration:60.f];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            imagePickerController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            [viewController presentViewController:imagePickerController animated:YES completion:nil];
        };
    }
    return _manager;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    HXWeakSelf
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (self.manager.configuration.saveSystemAblum) {
            [HXPhotoTools savePhotoToCustomAlbumWithName:self.manager.configuration.customAlbumName photo:image location:nil complete:^(HXPhotoModel *model, BOOL success) {
                if (success) {
                    if (weakSelf.manager.configuration.useCameraComplete) {
                        weakSelf.manager.configuration.useCameraComplete(model);
                    }
                }else {
                    [weakSelf.view hx_showImageHUDText:@"保存图片失败"];
                }
            }];
        }else {
            HXPhotoModel *model = [HXPhotoModel photoModelWithImage:image];
            if (self.manager.configuration.useCameraComplete) {
                self.manager.configuration.useCameraComplete(model);
            }
        }
    }else  if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *url = info[UIImagePickerControllerMediaURL];
        
        if (self.manager.configuration.saveSystemAblum) {
            [HXPhotoTools saveVideoToCustomAlbumWithName:self.manager.configuration.customAlbumName videoURL:url location:nil complete:^(HXPhotoModel *model, BOOL success) {
                if (success) {
                    if (weakSelf.manager.configuration.useCameraComplete) {
                        weakSelf.manager.configuration.useCameraComplete(model);
                    }
                }else {
                    [weakSelf.view hx_showImageHUDText:@"保存视频失败"];
                }
            }];
        }else {
            HXPhotoModel *model = [HXPhotoModel photoModelWithVideoURL:url];
            if (self.manager.configuration.useCameraComplete) {
                self.manager.configuration.useCameraComplete(model);
            }
        }
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
