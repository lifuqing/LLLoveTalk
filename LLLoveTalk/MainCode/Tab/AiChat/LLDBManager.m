//
//  LLDBManager.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/7/9.
//

#import "LLDBManager.h"
@interface LLDBManager ()
@property (nonatomic, copy) NSString *dbName;
@property (nonatomic, strong) NSMutableArray *dbArray;
@end

@implementation LLDBManager

- (instancetype)initWithDBName:(NSString *)dbName {
    self = [super init];
    if (self) {
        _dbName = [dbName copy];
    }
    return self;
}

- (BOOL)addItem:(NSDictionary *)dict {
    if (dict) {
        return [self addItems:@[dict]];
    }
    return NO;
}

- (BOOL)addItems:(NSArray <NSDictionary *> *)array {
    if (array.count > 0) {
        NSMutableArray *mArray = [self db_readAllItems];
        [mArray addObjectsFromArray:array];
        return [self db_writeItems:mArray];
    }
    return NO;
}

- (BOOL)deleteItemWith:(NSPredicate *)predicate {
    NSAssert(predicate, @"predicate must not be `nil`");
    
    NSMutableArray *mArray = [self db_readAllItems];
    
    NSArray *filterArray = [mArray filteredArrayUsingPredicate:predicate];
    
    [mArray removeObjectsInArray:filterArray];
    
    [self db_writeItems:mArray];
    
    return YES;
}

- (BOOL)deleteItemAtIndex:(NSUInteger)index {
    
    NSMutableArray *mArray = [self db_readAllItems];
    
    [mArray removeObjectAtIndex:index];
    
    [self db_writeItems:mArray];
    
    return YES;
}

- (BOOL)modifyItemWith:(NSPredicate *)predicate descDict:(NSDictionary *)descDict {
    NSAssert(predicate, @"predicate must not be `nil`");
    
    NSMutableArray <NSDictionary *> *mArray = [self db_readAllItems];
    
    NSArray <NSDictionary *> *filterArray = [mArray filteredArrayUsingPredicate:predicate];
    
    [mArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([filterArray containsObject:obj]) {
            [obj setValuesForKeysWithDictionary:descDict];
        }
    }];
    
    return [self db_writeItems:mArray];
}


- (NSArray <NSDictionary *> *)findItemsWith:(NSPredicate *)predicate {
    NSAssert(predicate, @"predicate must not be `nil`");
    
    NSMutableArray *mArray = [self db_readAllItems];
    
    NSArray *filterArray = [mArray filteredArrayUsingPredicate:predicate];
    
    return filterArray;
}

- (NSArray <NSDictionary *> *)findAllItems {
    return [[self db_readAllItems] copy];
}

- (BOOL)clearDB {
    NSString *path = [self db_dbPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    [fileManager removeItemAtPath:path error:&error];
    if (error) {
        return NO;
    }
    return YES;
}

#pragma mark - private

- (NSMutableArray<NSDictionary *> *)db_readAllItems {
    NSString *path = [self db_dbPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL Exists = [fileManager fileExistsAtPath:path];
    if (!Exists) {
        return [NSMutableArray array];
    } else {
        return [[NSMutableArray alloc] initWithContentsOfFile:path];
    }
}

- (BOOL)db_writeItems:(NSArray *)items {
    if ([items writeToFile:[self db_dbPath] atomically:YES]) {
        return YES;
    }
    return NO;

}

- (NSString *)db_dbPath {
    NSAssert(_dbName.length > 0, @"dbName must not be `nil`");
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"com.db.%@.plist", _dbName]];
    return path;
}
@end
