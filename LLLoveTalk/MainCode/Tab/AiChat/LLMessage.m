//
//  LLMessage.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/7/10.
//

#import "LLMessage.h"
#import "JSQPhotoMediaItem.h"

@implementation LLMessage
- (instancetype)initWithMessageItemModel:(LLMessageItemModel *)itemModel {
    if ([itemModel.type isEqualToString:@"image"]) {
        JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:nil];
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
