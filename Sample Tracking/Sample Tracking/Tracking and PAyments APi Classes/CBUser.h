//
//  CBUser.h
//  Tracking Library: @CoreBits 
//
//  Created by Satendra Singh on 04/07/16.
//
//

#import <Foundation/Foundation.h>

@interface CBUser : NSObject

    //username, name, email , phone, password, additionalInfo
+ (void) registerNewUserWithUserInfo:(NSDictionary *)registrationInfo;

@end
