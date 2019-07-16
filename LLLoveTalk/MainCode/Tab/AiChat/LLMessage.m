//
//  LLMessage.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/7/10.
//

#import "LLMessage.h"
#import "JSQPhotoMediaItem.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"
#import "JSQMessagesBubbleImageFactory.h"

@implementation LLPhotoMediaItem
- (UIView *)mediaView
{
    UIView *view = [super mediaView];
    if (view) {
        BOOL isOutgoing = self.appliesMediaViewMaskAsOutgoing;
        JSQMessagesBubbleImageFactory *factory =  [[JSQMessagesBubbleImageFactory alloc] initWithBubbleImage:LLImage(@"icon_bubble_outcoming_bg") capInsets:UIEdgeInsetsMake(25, 20, 10, 20) layoutDirection:[UIApplication sharedApplication].userInterfaceLayoutDirection];
        JSQMessagesMediaViewBubbleImageMasker *masker = [[JSQMessagesMediaViewBubbleImageMasker alloc] initWithBubbleImageFactory:factory];
        
        if (isOutgoing) {
            [masker applyOutgoingBubbleImageMaskToMediaView:view];
        }
        else {
            [masker applyIncomingBubbleImageMaskToMediaView:view];
        }
    }
    
    return view;
}
@end

@implementation LLMessage
- (instancetype)initWithMessageItemModel:(LLMessageItemModel *)itemModel {
    if ([itemModel.type isEqualToString:@"image"]) {
        LLPhotoMediaItem *photoItem = [[LLPhotoMediaItem alloc] initWithImage:nil];
        self = [super initWithSenderId:itemModel.userid?:@""
                     senderDisplayName:itemModel.username?:@""
                                  date:[NSDate dateWithTimeIntervalSince1970:itemModel.timestamp]
                                 media:photoItem];
    }
    else {
        self = [super initWithSenderId:itemModel.userid?:@"" senderDisplayName:itemModel.username?:@"" date:[NSDate dateWithTimeIntervalSince1970:itemModel.timestamp] text:itemModel.content?:@""];
    }
    
    if (self) {
        self.model = [itemModel.model copy];
        self.head_file = [itemModel.head_file copy];
        self.showTimeDesc = itemModel.showTimeDesc;
        self.image = [itemModel.image copy];
    }
    return self;
}

@end
