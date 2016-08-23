//
//  CBOrder.h
//  Tracking Library: @CoreBits 
//
//  Created by Satendra Singh on 05/07/16.
//
//

#import <Foundation/Foundation.h>
#import "CBDeviceAssociation.h"

@interface CBOrder : NSObject

@property (nonatomic, strong) NSString *orderPaymentID;// unique order id or simple product name to use
@property (nonatomic, strong) NSString *linkedUserEmail;//User email id
@property (nonatomic, strong) NSString *userDeviceID;//Current Device ID
@property (nonatomic, strong) NSString *associatedProductID;//Product purchasing the order
@property (nonatomic, strong) NSString *appleID;
@property (nonatomic, strong) NSString *appleTransactionID;//Transaction received from Apple/ serial number send to customer
@property (nonatomic, strong) NSDate *expiryDate;//Expiry date of order/purchase
@property (nonatomic, strong) NSNumber *isPaymentFailed;
@property (nonatomic, strong) NSNumber *isPaymentSuccess;
@property (nonatomic, strong) NSNumber *isReceiptVerified;
@property (nonatomic, strong) NSNumber *isTrialPlan;
@property (nonatomic, strong) NSNumber *isUserCanceled;
@property (nonatomic, strong) NSNumber *isUserInitiated;
@property (nonatomic, strong) NSNumber *planPrice;//double number
@property (nonatomic, strong) NSString *transactionCountry;
@property (nonatomic, strong) NSDate *purchaseDate;
@property (nonatomic, strong) NSString *receiptData;
@property (nonatomic, strong) NSString *statusSequence;

+(CBOrder *)prefilledObject;

+ (void) addNewOrderWithUser:(NSString *)emailID andTransationId:(NSString *)transactionID completion:(void(^)(NSDictionary *response,NSError *error))completion;
//+ (void) addNewOrderAndDeviceWithUser:(NSString *)emailID andTransationId:(NSString *)transactionID;
//Assign order id and updated optional values and call the method
+ (void)updateOrder:(CBOrder *)order completion:(void(^)(NSDictionary *response,NSError *error))completion;
+(void)getOrder:(NSString *)orderId completion:(void(^)(NSDictionary *response,NSError *error))completion;

+(void)getAllOrdersForDevice:(CBDeviceAssociation *)device completion:(void(^)(NSDictionary *response,NSError *error))completion;
+(void)getAllOrdersForUser:(CBUser *)user completion:(void(^)(NSDictionary *response,NSError *error))completion;



@end
