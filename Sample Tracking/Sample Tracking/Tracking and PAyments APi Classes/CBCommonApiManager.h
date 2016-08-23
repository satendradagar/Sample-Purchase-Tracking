//
//  CBCommonApiManager.h
//  Tracking Library: @CoreBits 
//
//  Created by Satendra Singh on 04/07/16.
//
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>

#define kDeviceDataFile @"DeviceData.sipher"
#define kUserDataFile @"UserData.sipher"
#define kOrdersData @"OrdersData.sipher"

//const NSString *baseUrl;

@interface CBCommonApiManager : NSObject

    //user_id,userEmailID,deviceDetail
+ (void)performPostAtSuffixUrl:(NSString *)suffix parameters:(NSDictionary *)params success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;


+ (void)performGetAtSuffixUrl:(NSString *)suffix success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;


+(NSString *)applicationSupportFilePath;

+ (void)encryptAndSaveRegistration:(NSDictionary *)response atFile:(NSString *)filePath;


+(NSDictionary *)decryptedDataAtFile:(NSString *)filePath;

@end
