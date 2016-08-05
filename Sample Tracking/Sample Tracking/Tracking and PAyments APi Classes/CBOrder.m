//
//  CBOrder.m
//  Tracking Library: @CoreBits 
//
//  Created by Satendra Singh on 05/07/16.
//
//

#import "CBOrder.h"
#import "CBDeviceAssociation.h"
#import "CBCommonApiManager.h"

#define kDefaultsIsOrderPlaced @"IS_ORDER_Placed"

@implementation CBOrder

+(CBOrder *)prefilledObject{
    
    CBOrder *order = [CBOrder new];
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    NSString *country = [locale displayNameForKey: NSLocaleCountryCode value: countryCode];
    order.transactionCountry = country;
    order.purchaseDate = [NSDate date];
    order.orderPaymentID = [CBDeviceAssociation productCode];
    order.appleTransactionID = @"000-0000-0000-0000-0000-000";
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* bundleID = [infoDict objectForKey:@"CFBundleIdentifier"];
    order.associatedProductID = bundleID;
    order.appleID = [order.associatedProductID stringByAppendingString:@".p0"];
    order.isTrialPlan = @0;
    order.isPaymentSuccess = @1;
//    order.isUserInitiated = @1;
//    order.isUserCanceled = @0;
//    order.isPaymentFailed = @0;
//    order.isReceiptVerified = @1;

    order.planPrice = @100;
    order.statusSequence = @"I-A-S";
    order.userDeviceID = [CBDeviceAssociation getSerialNumber];
//    order.receiptData = @"";
    order.expiryDate = [NSDate date];
    return order;
    
}

+ (void) addNewOrderWithUser:(NSString *)emailID andTransationId:(NSString *)transactionID{

    CBOrder *pre = [CBOrder prefilledObject];
    pre.linkedUserEmail = emailID;
    pre.appleTransactionID = transactionID;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    if (pre.transactionCountry) {
        
        [dictionary setValue:pre.transactionCountry forKey:@"transactionCountry"];
    }
    
    if (pre.purchaseDate) {
        
        [dictionary setValue:[pre.purchaseDate description] forKey:@"purchaseDate"];
 
    }
    
    
    if (pre.orderPaymentID) {
        
        [dictionary setValue:pre.orderPaymentID forKey:@"orderPaymentID"];
        
    }
    
    if (pre.appleTransactionID) {
        
        [dictionary setValue:pre.appleTransactionID forKey:@"appleTransactionID"];
        
    }
    
    
    if (pre.associatedProductID) {
        
        [dictionary setValue:pre.associatedProductID forKey:@"associatedProductID"];
        
    }

    
    if (pre.isTrialPlan) {
        
        [dictionary setValue:pre.isTrialPlan forKey:@"isTrialPlan"];
        
    }
   
    
    if (pre.isPaymentSuccess) {
        
        [dictionary setValue:pre.isPaymentSuccess forKey:@"isPaymentSuccess"];
        
    }
   
    
    if (pre.isUserInitiated) {
        
        [dictionary setValue:pre.isUserInitiated forKey:@"isUserInitiated"];
        
    }
    
    
    if (pre.isUserCanceled) {
        
        [dictionary setValue:pre.isUserCanceled forKey:@"isUserCanceled"];
        
    }
    
    if (pre.isPaymentFailed) {
        
        [dictionary setValue:pre.isPaymentFailed forKey:@"isPaymentFailed"];
        
    }
    
    if (pre.planPrice) {
        
        [dictionary setValue:pre.planPrice forKey:@"planPrice"];
        
    }
    
    
    if (pre.statusSequence) {
        
        [dictionary setValue:pre.statusSequence forKey:@"statusSequence"];
        
    }

    
    if (pre.userDeviceID) {
        
        [dictionary setValue:pre.userDeviceID forKey:@"userDeviceID"];
        
    }
    
    if (pre.linkedUserEmail) {
        
        [dictionary setValue:pre.linkedUserEmail forKey:@"linkedUserEmail"];
        
    }

    
    if (pre.appleID) {
        
        [dictionary setValue:pre.appleID forKey:@"appleID"];
        
    }
    
    
    if (pre.receiptData) {
        
        [dictionary setValue:pre.receiptData forKey:@"receiptData"];
        
    }
    
    
    if (pre.receiptData) {
        
        [dictionary setValue:pre.receiptData forKey:@"receiptData"];
        
    }
    
    
    if (pre.expiryDate) {
        
        [dictionary setValue:[pre.expiryDate description] forKey:@"expiryDate"];
        
    }
    

    [CBCommonApiManager performPostAtSuffixUrl:@"order/add" parameters:dictionary success:^(id responseObject) {
        
        NSDictionary *response = (NSDictionary *)responseObject;
        NSLog(@"MSG: %@",[response objectForKey:@"message"]);
        NSLog(@"Track: %@",response);
        if ([[response objectForKey:@"message"] isEqualToString:@"Success"]) {
            
                //Stored successfully
            [[NSUserDefaults standardUserDefaults] setBool:yearMask forKey:kDefaultsIsOrderPlaced];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"Error %@",error);
        
    }];

}

+ (void) addNewOrderAndRegisterDeviceWithUser:(NSString *)emailID andTransationId:(NSString *)transactionID{

    NSDictionary *userDict = @{
       
       @"user_id":emailID,
       @"userEmailID":emailID,
       @"deviceDetail":transactionID
       
    };
    
    [CBDeviceAssociation registerDeviceDetailsWithUserDetails:userDict];
    
    [self addNewOrderAndRegisterDeviceWithUser:emailID andTransationId:transactionID];
    
}
@end
