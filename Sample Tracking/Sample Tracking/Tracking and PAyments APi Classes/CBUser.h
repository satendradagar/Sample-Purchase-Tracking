//
//  CBUser.h
//  Tracking Library: @CoreBits 
//
//  Created by Satendra Singh on 04/07/16.
//
//

#import <Foundation/Foundation.h>

@interface CBUser : NSObject


@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) CBUser *name;

@property (nonatomic, strong) NSString *emailId;

@property (nonatomic, strong) NSString *phoneNumber;

@property (nonatomic, strong) NSString *additionalInfo;

+(CBUser *)currentUser;

    //username, name, email , phone, password, additionalInfo
+ (void) registerNewUserWithUserInfo:(NSDictionary *)registrationInfo completion:(void(^)(NSDictionary *response,NSError *error))completion;;

+ (void)signInUserWithId:(NSString *)userId password:(NSString *)password completion:(void(^)(NSDictionary *response,NSError *error))completion;

@end
