//
//  CBDeviceAssociation.m
//  Tracking Library: @CoreBits 
//
//  Created by Satendra Singh on 04/07/16.
//
//

#import "CBDeviceAssociation.h"
#import "CBCommonApiManager.h"

#define kDefaultsIsRegisteredDevice @"IS_Tracking_Intiated"
#define kAPI_PRODUCT_UNIQUE_CODE @"smartLister"
@implementation CBDeviceAssociation

+(BOOL) isDeviceRegistered{
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:kDefaultsIsRegisteredDevice];
}

+ (void) checkAndRegisterDeviceWithUserDetails:(NSDictionary *)userKeys
{
    if ([CBDeviceAssociation isDeviceRegistered]) {
        
        return;
    }
    else{
        
        [CBDeviceAssociation registerDeviceDetailsWithUserDetails:userKeys completion:nil];
    }
}

+(CBDeviceAssociation *)currentDevice{
   
    NSDictionary *deviceDict = [CBCommonApiManager decryptedDataAtFile:kDeviceDataFile];

    if (deviceDict) {
        
        CBDeviceAssociation *da = [CBDeviceAssociation new];
        da.userDeviceID = [deviceDict objectForKey:@"userEmailID"];
        da.hardwareID = [deviceDict objectForKey:@"hardwareID"];
        da.serialNumber = [deviceDict objectForKey:@"serialNumber"];
        da.hostName = [deviceDict objectForKey:@"hostName"];
        da.userEmailID = [deviceDict objectForKey:@"userEmailID"];
        da.macVersion = [deviceDict objectForKey:@"macVersion"];
        da.modelName = [deviceDict objectForKey:@"modelName"];
        return da;
    }
    return nil;
    
}

+(void)updateDetailsForCurrentDevice:(NSDictionary *)updateParams completion:(void(^)(NSDictionary *response,NSError *error))completion{

//    NSString *deviceUUID = [CBDeviceAssociation getSystemUUID];
    NSString *hostName = [[NSHost currentHost] localizedName];
    NSString * macVersion = [[NSProcessInfo processInfo] operatingSystemVersionString];

    NSString *serialNumber = [CBDeviceAssociation getSerialNumber];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                                @"serialNumber": serialNumber,
                                @"hostName": hostName,
                                @"macVersion": macVersion
                                }];
    [parameters addEntriesFromDictionary:updateParams];
    [CBCommonApiManager performPostAtSuffixUrl:[NSString stringWithFormat:@"device/update/%@",serialNumber] parameters:parameters success:^(id responseObject) {
        
        NSDictionary *response = (NSDictionary *)responseObject;
        NSLog(@"MSG: %@",[response objectForKey:@"message"]);
        NSLog(@"Track: %@",response);
        if ([[response objectForKey:@"message"] isEqualToString:@"Success"]) {
            
                //Stored successfully
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDefaultsIsRegisteredDevice];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self getDeviceDetailsForCurrentDevice:^(NSDictionary *response, NSError *error) {
                NSLog(@"Updated local values");
            }];
        }
        
        completion(response, nil);
    } failure:^(NSError *error) {
        
        completion(nil, error);

        NSLog(@"Error %@",error);
        
    }];
    
}

+(void)registerDeviceDetailsWithUserDetails:(NSDictionary *)userKeys  completion:(void(^)(NSDictionary *response,NSError *error))completion{
    
    NSString *deviceUUID = [CBDeviceAssociation getSystemUUID];
    NSString *hostName = [[NSHost currentHost] localizedName];
    NSString * macVersion = [[NSProcessInfo processInfo] operatingSystemVersionString];
    size_t len = 0;
    NSString *modelName = nil;
    sysctlbyname("hw.model", NULL, &len, NULL, 0);
    if (len) {
        char *model = malloc(len*sizeof(char));
        sysctlbyname("hw.model", model, &len, NULL, 0);
        printf("%s\n", model);
        modelName = [NSString stringWithFormat:@"%s",model];
        free(model);
    }
//    user_id userEmailID deviceDetail
    NSString *serialNumber = [CBDeviceAssociation getSerialNumber];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      @"userDeviceID": deviceUUID,
                                                                                      @"hardwareID": kAPI_PRODUCT_UNIQUE_CODE,
                                                                                      @"serialNumber": serialNumber,
                                                                                      @"hostName": hostName,
                                                                                      @"macVersion": macVersion,
                                                                                      @"modelName": modelName
                                                                                      }];
    if (userKeys) {
        [parameters setObject:[userKeys objectForKey:@"user_id"] forKey:@"user_id"];
            //                      @"deviceDetail": [userKeys objectForKey:@"deviceDetail"],
//        @"userEmailID": [userKeys objectForKey:@"userEmailID"],


    }
    [CBCommonApiManager performPostAtSuffixUrl:@"device/add" parameters:parameters success:^(id responseObject) {
        
        NSDictionary *response = (NSDictionary *)responseObject;
        NSLog(@"MSG: %@",[response objectForKey:@"message"]);
        NSLog(@"Track: %@",response);
        if ([[response objectForKey:@"message"] isEqualToString:@"Success"]) {
            
                //Stored successfully
            [[NSUserDefaults standardUserDefaults] setBool:yearMask forKey:kDefaultsIsRegisteredDevice];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [CBCommonApiManager encryptAndSaveRegistration:parameters atFile:kDeviceDataFile];
        }
        completion(response, nil);
        
    } failure:^(NSError *error) {

        completion(nil, error);
        NSLog(@"Error %@",error);

    }];
    
}

+(void)getDeviceDetailsForCurrentDevice:(void(^)(NSDictionary *response,NSError *error))completion{
        //    user_id userEmailID deviceDetail
    NSString *serialNumber = [CBDeviceAssociation getSerialNumber];
    [CBCommonApiManager performGetAtSuffixUrl:[NSString stringWithFormat:@"device/%@",serialNumber]  success:^(id responseObject) {
            //Stored successfully
//        [[NSUserDefaults standardUserDefaults] setBool:yearMask forKey:kDefaultsIsRegisteredDevice];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        [CBCommonApiManager encryptAndSaveRegistration:responseObject atFile:kDeviceDataFile];

        completion(responseObject,nil);
        
    } failure:^(NSError *error) {
        
        completion(nil,error);

    }];
    
}

+ (void)fetchUserDevicesForEmail:(NSString *)userEmail completion:(void(^)(NSDictionary *response,NSError *error))completion{
    
    
    [CBCommonApiManager performGetAtSuffixUrl:[NSString stringWithFormat:@"devices/%@",userEmail] success:^(id responseObject) {
        
        completion(responseObject, nil);
        
    } failure:^(NSError *error) {
        
        completion(nil, error);
        
    }];
}


//+ (instancetype)currentDevice{
//    
//    if ([[AppDelegate sharedAppDelegate] parseDeviceAssociation]) {
//        return [[AppDelegate sharedAppDelegate] parseDeviceAssociation];
//    }
//    
//    PFQuery *query = [PFQuery queryWithClassName:@"SLDeviceAssociation"];
//    [query whereKey:@"deviceUUID" equalTo:[CBDeviceAssociation getSystemUUID]];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//                // The find succeeded.
//            NSLog(@"Successfully retrieved %lu devices.", (unsigned long)objects.count);
//                // Do something with the found objects
//            for (PFObject *object in objects) {
//                NSLog(@"%@", object.objectId);
//            }
//            SLDeviceAssociation *deviceObject = nil;
//            if (0 == [objects count]) {
//                
//                deviceObject = [SLDeviceAssociation objectWithClassName:@"SLDeviceAssociation"];
//                deviceObject.deviceUUID = [SLDeviceAssociation getSystemUUID];
//                deviceObject.hostName = [[NSHost currentHost] localizedName];
//                NSString * operatingSystemVersionString = [[NSProcessInfo processInfo] operatingSystemVersionString];
//                size_t len = 0;
//                NSString *modelName = nil;
//                sysctlbyname("hw.model", NULL, &len, NULL, 0);
//                if (len) {
//                    char *model = malloc(len*sizeof(char));
//                    sysctlbyname("hw.model", model, &len, NULL, 0);
//                    printf("%s\n", model);
//                    modelName = [NSString stringWithFormat:@"%s",model];
//                    free(model);
//                }
//                deviceObject.macVersion = operatingSystemVersionString;
//                deviceObject.modelName = modelName;
//                [deviceObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//                    SLPaymentRecord *paymentRecord = [SLPaymentRecord objectWithClassName:@"SLPaymentRecord"];
//                    paymentRecord.deviceAssociation = deviceObject;
//                    paymentRecord.linkedDeviceID = [SLDeviceAssociation getSystemUUID];
//                    paymentRecord.expiryDate = [NSDate dateWithTimeIntervalSince1970:0];
//                    paymentRecord.appleID = Free_Plan_ID;
//                    paymentRecord.planPrice = [NSDecimalNumber zero];
//                    paymentRecord.appleTransactionId = @"00-00-00";
//                    paymentRecord.isTrialPlan = YES;
//                    paymentRecord.statusSequence = @"A";
//                    [paymentRecord saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//                        
//                    }];
//                    
//                }];
//            }
//            else
//                {
//                deviceObject = [objects firstObject];
//                }
//            [AppDelegate sharedAppDelegate].parseDeviceAssociation =deviceObject;
//            
//        } else {
//                // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
//    
//        //    NSString *deviceID =
//        //    SLDeviceAssociation *deviceAssociation = [PFObject objectWithoutDataWithObjectId:(nullable NSString *)]
//    return nil;
//}

+ (NSString *)getSystemUUID {
    io_service_t platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault,IOServiceMatching("IOPlatformExpertDevice"));
    if (!platformExpert)
        return nil;
    
    CFTypeRef serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert,CFSTR(kIOPlatformUUIDKey),kCFAllocatorDefault, 0);
    IOObjectRelease(platformExpert);
    if (!serialNumberAsCFString)
        return nil;
    
    return (__bridge NSString *)(serialNumberAsCFString);;
}

+ (NSString *)getSerialNumber
{
    NSString *serial = nil;
    io_service_t platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault,
                                                              IOServiceMatching("IOPlatformExpertDevice"));
    if (platformExpert) {
        CFTypeRef serialNumberAsCFString =
        IORegistryEntryCreateCFProperty(platformExpert,
                                        CFSTR(kIOPlatformSerialNumberKey),
                                        kCFAllocatorDefault, 0);
        if (serialNumberAsCFString) {
            serial = CFBridgingRelease(serialNumberAsCFString);
        }
        
        IOObjectRelease(platformExpert);
    }
    return serial;
}

+(NSString *)productCode{
    
    return kAPI_PRODUCT_UNIQUE_CODE;
}
@end
