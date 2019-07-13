//
//  LLDBManager.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/7/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLDBManager : NSObject


- (instancetype)initWithDBName:(NSString *)dbName;

- (BOOL)addItem:(NSDictionary *)dict;

- (BOOL)addItems:(NSArray <NSDictionary *> *)array;

- (BOOL)deleteItemWith:(NSPredicate *)predicate;

- (BOOL)deleteItemAtIndex:(NSUInteger)index;

- (BOOL)modifyItemWith:(NSPredicate *)predicate descDict:(NSDictionary *)descDict;


- (NSArray <NSDictionary *> *)findItemsWith:(NSPredicate *)predicate;

- (NSArray <NSDictionary *> *)findAllItems;

- (BOOL)clearDB;
@end

NS_ASSUME_NONNULL_END
