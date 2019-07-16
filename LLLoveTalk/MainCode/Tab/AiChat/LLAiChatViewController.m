//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "LLAiChatViewController.h"
#import "UIImage+LLTools.h"
#import "LLMessage.h"
#import "LLImageTools.h"

@interface LLAiChatViewController ()
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation LLAiChatViewController

#pragma mark - View lifecycle

/**
 *  Override point for customization.
 *
 *  Customize your view.
 *  Look at the properties on `JSQMessagesViewController` and `JSQMessagesCollectionView` to see what is possible.
 *
 *  Customize your layout.
 *  Look at the properties on `JSQMessagesCollectionViewFlowLayout` to see what is possible.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"AI小蜜";

    self.collectionView.backgroundColor = RGBS(245);
    self.inputToolbar.contentView.backgroundColor = RGBS(235);
    self.inputToolbar.contentView.textView.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 13];
    self.inputToolbar.contentView.textView.layer.borderWidth = 0;
    
    self.collectionView.collectionViewLayout.messageBubbleFont = [UIFont fontWithName:@"PingFang-SC-Medium" size: 14];
    self.collectionView.collectionViewLayout.sectionInset = UIEdgeInsetsMake(10.0f, 12.f, 10.0f, 12.f);
    self.collectionView.collectionViewLayout.minimumLineSpacing = 15.0f;
    self.collectionView.collectionViewLayout.messageBubbleTextViewTextContainerInsets = UIEdgeInsetsMake(8.0f, 10.0f, 6.0f, 10.0f);
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(36, 36);
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(36, 36);
    
    /**
     *  Load up our fake data for the demo
     */
    self.demoData = [[DemoModelData alloc] init];

    
    self.showLoadEarlierMessagesHeader = NO;
    self.automaticallyScrollsToMostRecentMessage = NO;


    /**
     *  Customize your toolbar buttons
     *
     *  self.inputToolbar.contentView.leftBarButtonItem = custom button or nil to remove
     *  self.inputToolbar.contentView.rightBarButtonItem = custom button or nil to remove
     */
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    
    [self.inputToolbar.contentView.rightBarButtonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.inputToolbar.contentView.rightBarButtonItem setTitleColor:[[UIColor whiteColor] jsq_colorByDarkeningColorWithValue:0.1f] forState:UIControlStateHighlighted];
    [self.inputToolbar.contentView.rightBarButtonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
    self.inputToolbar.contentView.rightBarButtonItem.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 13];
    self.inputToolbar.contentView.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [self.inputToolbar.contentView.rightBarButtonItem setBackgroundImage:[UIImage ll_createImageWithColor:RGBS(208)] forState:UIControlStateDisabled];
    [self.inputToolbar.contentView.rightBarButtonItem setBackgroundImage:[UIImage ll_createImageWithColor:LLTheme.mainColor] forState:UIControlStateNormal];
    self.inputToolbar.contentView.rightBarButtonItem.layer.cornerRadius = 6;
    self.inputToolbar.contentView.rightBarButtonItem.layer.masksToBounds = YES;
    self.inputToolbar.contentView.rightBarButtonItemWidth = 50;
    

    /**
     *  Set a maximum height for the input toolbar
     *
     *  self.inputToolbar.maximumHeight = 150;
     */
    self.inputToolbar.maximumHeight = 150;
    
    [self setupTimer];
}

- (void)dealloc {
    [self invalidateTimer];
}

#pragma mark - timer
- (void)setupTimer
{
    [self invalidateTimer];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(fetchBroadcastMessage) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - Actions

- (void)fetchBroadcastMessage {
    LLURL *llurl = [[LLURL alloc] initWithParser:@"FetchBotMessageParser" urlConfigClass:[LLAiLoveURLConfig class]];
    WEAKSELF();
    [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:self success:^(NSURLResponse * _Nullable response, NSDictionary * _Nullable result, LLBaseResponseModel * _Nullable model, BOOL isLocalCache) {
        LLAiMessageListModel *listModel = (LLAiMessageListModel *)model;
        if (listModel.list.count) {
            weakSelf.showTypingIndicator = !weakSelf.showTypingIndicator;
            [listModel.list enumerateObjectsUsingBlock:^(LLBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [weakSelf receiveMessageWith:(LLMessageItemModel *)obj];
            }];
            [weakSelf finishReceivingMessageAnimated:YES];
            [weakSelf scrollToBottomAnimated:YES];
        }
    } failure:^(NSURLResponse * _Nullable response, NSError * _Nullable error, LLBaseResponseModel * _Nullable model) {
//        [weakSelf finishReceivingMessageAnimated:YES];
    }];
    
}

- (void)sendMessageToAIWith:(NSString *)message {
    LLURL *llurl = [[LLURL alloc] initWithParser:@"SendBotMessageParser" urlConfigClass:[LLAiLoveURLConfig class]];
    [llurl.params addEntriesFromDictionary:@{@"message":message?:@""}];
    WEAKSELF();
    self.showTypingIndicator = !self.showTypingIndicator;
    [self scrollToBottomAnimated:YES];
    [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:self success:^(NSURLResponse * _Nullable response, NSDictionary * _Nullable result, LLBaseResponseModel * _Nullable model, BOOL isLocalCache) {
        LLAiMessageListModel *listModel = (LLAiMessageListModel *)model;
        [listModel.list enumerateObjectsUsingBlock:^(LLBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf receiveMessageWith:(LLMessageItemModel *)obj];
        }];
        [weakSelf finishReceivingMessageAnimated:YES];
        [weakSelf scrollToBottomAnimated:YES];
    } failure:^(NSURLResponse * _Nullable response, NSError * _Nullable error, LLBaseResponseModel * _Nullable model) {
        [weakSelf finishReceivingMessageAnimated:YES];
    }];
    
}

- (void)receiveMessageWith:(LLMessageItemModel *)itemModel {
    [self.demoData addMessageWithModel:itemModel];
    LLMessage *message = [self.demoData.messages lastObject];
    if (message.isMediaMessage) {
        JSQPhotoMediaItem *photoItem = (JSQPhotoMediaItem *)message.media;
        photoItem.appliesMediaViewMaskAsOutgoing = NO;
        photoItem.image = nil;
        [self scrollToBottomAnimated:YES];
        [self requestMeidaWithMessage:message];
    }

}

- (void)requestMeidaWithMessage:(LLMessage *)message {
    if ([message.media isKindOfClass:[JSQPhotoMediaItem class]]) {
        WEAKSELF();
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:message.image] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            JSQPhotoMediaItem *photoItem = (JSQPhotoMediaItem *)message.media;
            photoItem.image = image;
            [weakSelf.collectionView reloadData];
        }];
    }
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */

    // [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    LLMessageItemModel *item = [[LLMessageItemModel alloc] init];
    item.content = text;
    item.timestamp = [date timeIntervalSince1970];
    item.model = @"dialog";
    item.type = @"text";
    item.userid = senderId;
    item.username = senderDisplayName;
    item.head_file = [LLUser sharedInstance].head_file;
    
    [self receiveMessageWith:item];
    
    [self finishSendingMessageAnimated:YES];
    
    [self scrollToBottomAnimated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sendMessageToAIWith:text];
    });
    
}



#pragma mark - JSQMessages CollectionView DataSource

- (NSString *)senderId {
    return [LLUser sharedInstance].userid;
}

- (NSString *)senderDisplayName {
    return [LLUser sharedInstance].username;
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.demoData.messages objectAtIndex:indexPath.item];
}


- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] initWithBubbleImage:LLImage(@"icon_bubble_outcoming_bg") capInsets:UIEdgeInsetsMake(25, 20, 10, 20) layoutDirection:[UIApplication sharedApplication].userInterfaceLayoutDirection];

    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor whiteColor]];
    }
    
    return [bubbleFactory incomingMessagesBubbleImageWithColor:LLTheme.mainColor];
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
    LLMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    JSQMessagesAvatarImage *avatar = [[JSQMessagesAvatarImage alloc] initWithAvatarImageUrl:message.head_file placeholderImage:LLImage(@"my_user_head")];
    return avatar;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    LLMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    if (message.showTimeDesc) {
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    LLMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        LLMessage *previousMessage = [self.demoData.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.demoData.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    cell.messageBubbleTopLabel.hidden = YES;
    cell.cellTopLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 11];
    
    LLMessage *msg = [self.demoData.messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }

    
    return cell;
}


#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (self.demoData.messages[indexPath.item].showTimeDesc) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault + 18;
    }

    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Tapped message bubble!");
    LLMessage *message = self.demoData.messages[indexPath.item];
    if (message.isMediaMessage) {
        if ([message.media isKindOfClass:[JSQPhotoMediaItem class]]) {
            JSQPhotoMediaItem *item = (JSQPhotoMediaItem *)message.media;
            if (item.image) {
//                JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
//                [LLImageTools ImageZoomWithImageView:cell.messageBubbleImageView canSaveToAlbum:YES];
            }
            else {
                [self requestMeidaWithMessage:message];
            }
        }
    }
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}


@end
