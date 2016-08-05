//
//  CBDeviceAssociation.h
//  Tracking Library: @CoreBits 
//
//  Created by Satendra Singh on 04/07/16.
//
//

#import <Foundation/Foundation.h>

@interface CBDeviceAssociation : NSObject

+(BOOL) isDeviceRegistered;

+ (void) checkAndRegisterDeviceWithUserDetails:(NSDictionary *)userKeys;

+(void)registerDeviceDetailsWithUserDetails:(NSDictionary *)userKeys;

+ (NSString *)getSerialNumber;

+(NSString *)productCode;

@end
