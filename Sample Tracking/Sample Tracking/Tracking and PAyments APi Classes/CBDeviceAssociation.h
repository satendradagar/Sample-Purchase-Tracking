//
//  CBDeviceAssociation.h
//  Tracking Library: @CoreBits 
//
//  Created by Satendra Singh on 04/07/16.
//
//

#import <Foundation/Foundation.h>
#import "CBUser.h"

@interface CBDeviceAssociation : NSObject

@property (nonatomic, strong) NSString *userDeviceID;

@property (nonatomic, strong) NSString *hardwareID;

@property (nonatomic, strong) NSString *serialNumber;

@property (nonatomic, strong) CBUser *linkedUser;

@property (nonatomic, strong) NSString *userEmailID;

@property (nonatomic, strong) NSString *hostName;

@property (nonatomic, strong) NSString *modelName;

@property (nonatomic, strong) NSString *macVersion;

+(BOOL) isDeviceRegistered;

+(CBDeviceAssociation *)currentDevice;

+(void)registerDeviceDetailsWithUserDetails:(NSDictionary *)userKeys  completion:(void(^)(NSDictionary *response,NSError *error))completion;

+(void)getDeviceDetailsForCurrentDevice:(void(^)(NSDictionary *response,NSError *error))completion;

+ (void)fetchUserDevicesForEmail:(NSString *)userEmail completion:(void(^)(NSDictionary *response,NSError *error))completion;

//Upate is accepted with following set of key values: user_id,deviceDetail,userEmailID
+(void)updateDetailsForCurrentDevice:(NSDictionary *)updateParams completion:(void(^)(NSDictionary *response,NSError *error))completion;

+ (NSString *)getSerialNumber;

+(NSString *)productCode;

@end
