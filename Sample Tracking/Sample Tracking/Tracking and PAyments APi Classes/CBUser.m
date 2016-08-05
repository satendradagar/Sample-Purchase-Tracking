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
+ (void) registerNewUserWithUserInfo:(NSDictionary *)registrationInfo{

    NSDictionary *localDetails = [registrationInfo copy];
    [CBCommonApiManager performPostAtSuffixUrl:@"user/register" parameters:registrationInfo success:^(id responseObject) {
        
        NSDictionary *response = (NSDictionary *)responseObject;
        NSString *result = [response objectForKey:@"result"];
//        "registrationID": 4
        NSNumber *regId = [response objectForKey:@"registrationID"];
        
        NSLog(@"MSG: %@",result);
        if (regId) {
            
            [[NSUserDefaults standardUserDefaults] setObject:regId forKey:kDefaultsUserID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSDictionary *deviceActivationInfo = @{
                                                    @"user_id":regId,
                                                    @"userEmailID":[localDetails objectForKey:@"email"],
                                                    @"deviceDetail":[localDetails objectForKey:@"additionalInfo"]
                                                   
                                                   };
            [CBDeviceAssociation registerDeviceDetailsWithUserDetails:deviceActivationInfo];
        }
        else
            {
            
                NSDictionary *deviceActivationInfo = @{
                                                       @"userEmailID":[localDetails objectForKey:@"email"],
                                                       @"deviceDetail":[localDetails objectForKey:@"additionalInfo"]
                                                       
                                                       };
                [CBDeviceAssociation registerDeviceDetailsWithUserDetails:deviceActivationInfo];
            }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"Error %@",error);
    }];

}

@end
