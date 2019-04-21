//
//  LLIAPHelper.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/21.
//

#import <Foundation/Foundation.h>
#import "StoreKit/StoreKit.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^IAPProductsResponseBlock)(SKProductsRequest* request , SKProductsResponse* response);

typedef void (^IAPbuyProductCompleteResponseBlock)(SKPaymentTransaction* transcation);

typedef void (^checkReceiptCompleteResponseBlock)(NSString* _Nullable response, NSError* _Nullable error);

typedef void (^resoreProductsCompleteResponseBlock) (SKPaymentQueue* payment,NSError* _Nullable error);

@interface LLIAPHelper : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic,strong) NSSet *productIdentifiers;
@property (nonatomic,strong) NSArray * products;
@property (nonatomic,strong) NSMutableSet *purchasedProducts;
@property (nonatomic,strong, nullable) SKProductsRequest *request;
@property (nonatomic) BOOL production;

@property (nonatomic,copy, nullable) IAPbuyProductCompleteResponseBlock buyProductCompleteBlock;

//init With Product Identifiers
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;

//get Products List
- (void)requestProductsWithCompletion:(IAPProductsResponseBlock)completion;


//Buy Product
- (void)buyProduct:(SKProduct *)productIdentifier onCompletion:(IAPbuyProductCompleteResponseBlock)completion;

//restore Products
- (void)restoreProductsWithCompletion:(resoreProductsCompleteResponseBlock)completion;

//check isPurchased or not
- (BOOL)isPurchasedProductsIdentifier:(NSString*)productID;

//check receipt but recommend to use in server side instead of using this function
- (void)checkReceipt:(NSData*)receiptData onCompletion:(checkReceiptCompleteResponseBlock)completion;

- (void)checkReceipt:(NSData*)receiptData AndSharedSecret:(NSString* _Nullable)secretKey onCompletion:(checkReceiptCompleteResponseBlock)completion;


//saved purchased product
- (void)provideContentWithTransaction:(SKPaymentTransaction *)transaction;

//clear the saved products
- (void)clearSavedPurchasedProducts;
- (void)clearSavedPurchasedProductByID:(NSString*)productIdentifier;


//Get The Price with local currency
- (NSString *)getLocalePrice:(SKProduct *)product;

@end

NS_ASSUME_NONNULL_END
