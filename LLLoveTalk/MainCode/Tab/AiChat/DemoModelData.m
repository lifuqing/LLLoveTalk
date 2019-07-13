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

#import "DemoModelData.h"
#import "LLDBManager.h"
#import <YYModel/YYModel.h>
#import "LLMessage.h"
/**
 *  This is for demo/testing purposes only.
 *  This object sets up some fake model data.
 *  Do not actually do anything like this.
 */
@interface DemoModelData ()
@property (nonatomic, strong) LLDBManager *dbManager;
@end

@implementation DemoModelData

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.messages = [NSMutableArray array];
        
        self.dbManager = [[LLDBManager alloc] initWithDBName:@"ai.message"];
        
        [self.dbManager clearDB];
        
//        [self loadLocalMessage];
        
    }
    
    return self;
}

- (BOOL)shouldShowTimeDesc:(LLMessageItemModel *)itemModel inArray:(NSArray<LLMessage *> *)array {
    LLMessage *final = [[array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"showTimeDesc == 1"]] lastObject];
    if (!final) {
        return YES;
    }
    if (itemModel.timestamp - [final.date timeIntervalSince1970] > 5 * 60) {
        return YES;
    }
    return NO;
}


- (void)loadLocalMessage {
    [[_dbManager findAllItems] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addMessageWithDict:obj];
    }];
}

- (void)insertMessage {
    for (int i = 0; i < 10; i++) {
        NSDictionary *dict = @{
                               @"content": [NSString stringWithFormat:@"这是第%d条数据", i],
                               @"timestamp": @([[NSDate date] timeIntervalSince1970] - 15*60*2 +i*60*2),
                               @"model": @"dialog",
                               @"type": @"text",
                               @"userid": i % 3 == 0 ? ([LLUser sharedInstance].userid?:@"") : @"system",
                               @"username": @"AI小蜜",
                               @"head_file": @"http://sss.jpg"
                               
                               };
        [self addMessageWithDict:dict];
    }
}

- (BOOL)addMessageWithModel:(LLMessageItemModel *)model {
    model.showTimeDesc = [self shouldShowTimeDesc:model inArray:self.messages];
    [self.messages addObject:[[LLMessage alloc] initWithMessageItemModel:model]];
    BOOL status = [_dbManager addItem:[model yy_modelToJSONObject]];
    if (self.messages.count > 100) {
        [self.messages removeObjectAtIndex:0];
        [_dbManager deleteItemAtIndex:0];
    }
    if (status) {
        DLog(@"[AiDEBUG] %@ 写入成功", model.content);
    }
    return status;
}

- (BOOL)addMessageWithDict:(NSDictionary *)dict {
    LLMessageItemModel *model = [LLMessageItemModel yy_modelWithJSON:dict];
    return [self addMessageWithModel:model];
}

@end
