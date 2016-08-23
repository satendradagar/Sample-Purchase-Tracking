//
//  CBUser.m
//  Tracking Library: @CoreBits 
//
//  Created by Satendra Singh on 04/07/16.
//
//

#import "CBUser.h"
#import "CBCommonApiManager.h"
#import "CBDeviceAssociation.h"

#define kDefaultsUserID @"UserID"
@implementation CBUser

    //username, name, email , phone, password, additionalInfo
+ (void) registerNewUserWithUserInfo:(NSDictionary *)registrationInfo completion:(void(^)(NSDictionary *response,NSError *error))completion{

    NSDictionary *localDetails = [registrationInfo copy];
    [CBCommonApiManager performPostAtSuffixUrl:@"user/register" parameters:registrationInfo success:^(id responseObject) {
        
        [CBCommonApiManager encryptAndSaveRegistration:registrationInfo atFile:kUserDataFile];

//        NSDictionary *response = (NSDictionary *)responseObject;
//        NSString *result = [response objectForKey:@"result"];
//        NSNumber *regId = [response objectForKey:@"registrationID"];
        
        completion(responseObject, nil);

        
    } failure:^(NSError *error) {
        
        completion(nil, error);

        NSLog(@"Error %@",error);
    }];

}

+ (void)signInUserWithId:(NSString *)userId password:(NSString *)password completion:(void(^)(NSDictionary *response,NSError *error))completion{
    
    
}

+(CBUser *)currentUser{
    
    NSDictionary *deviceDict = [CBCommonApiManager decryptedDataAtFile:kUserDataFile];
    if (deviceDict) {
        CBUser *da = [CBUser new];
        da.userName = [deviceDict objectForKey:@"username"];
        da.emailId = [deviceDict objectForKey:@"email"];
        da.name = [deviceDict objectForKey:@"name"];
        da.phoneNumber = [deviceDict objectForKey:@"phone"];
        return da;
    }
    return nil;
    
}
@end
