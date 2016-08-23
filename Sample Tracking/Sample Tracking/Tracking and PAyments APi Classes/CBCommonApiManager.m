//
//  CBCommonApiManager.m
//  Tracking Library: @CoreBits 
//
//  Created by Satendra Singh on 04/07/16.
//
//

#import "CBCommonApiManager.h"
#import "NSData+CommonCrypto.h"
#import "CBDeviceAssociation.h"

 NSString *baseUrl = @"http://products.corebitss.com/";


@implementation CBCommonApiManager

+ (void)performGetAtSuffixUrl:(NSString *)suffix success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure{
    
    [self performRequestAtSuffixUrl:suffix parameters:nil success:success failure:failure htttpMethod:@"GET"];
    
}

+ (void)performPostAtSuffixUrl:(NSString *)suffix parameters:(NSDictionary *)params success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
{
    [self performRequestAtSuffixUrl:suffix parameters:params  success:success failure:failure htttpMethod:@"POST"];
    
}

+ (void)performRequestAtSuffixUrl:(NSString *)suffix parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure htttpMethod:(NSString *)method{

    NSString *fullApiUrl = [baseUrl stringByAppendingPathComponent:suffix];
    

    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache"
                               };
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullApiUrl]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:method];
    [request setAllHTTPHeaderFields:headers];
    
    if (parameters) {
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        
        [request setHTTPBody:postData];
        
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
       
        if (connectionError) {
            failure(connectionError);
        }
        else{
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSLog(@"%@", httpResponse);
            
            if (200 == [httpResponse statusCode]) {
               
                
                if (data.length) {
                    
                    NSError *parsingError = nil;
                    id response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
                    
                    if (nil == parsingError) {
                        
                        success(response);
                    }
                    else{
                        
                        failure([NSError errorWithDomain:@"Invalid Data format recived, unable to parse" code:98 userInfo:nil]);
                    }
                }
                else{
                    
                    failure([NSError errorWithDomain:@"No content received" code:99 userInfo:nil]);
                }
                
            }
            else{
                
                failure([NSError errorWithDomain:@"Server send unexpected response" code:97 userInfo:nil]);
                
            }
        }
    }];
}


+ (NSURL *)applicationDocumentsDirectory {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.CoreBits.ScanLister" in the user's Application Support directory.
    NSURL *appSupportURL = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"com.sampleTracking.CoreBits"];
}

+ (NSURL *)appSpecificSupportDirectoryURL{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationDocumentsDirectory = [self applicationDocumentsDirectory];
    BOOL shouldFail = NO;
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
        // Make sure the application files directory is there
    NSDictionary *properties = [applicationDocumentsDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    if (properties) {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            failureReason = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationDocumentsDirectory path]];
            shouldFail = YES;
        }
    } else if ([error code] == NSFileReadNoSuchFileError) {
        error = nil;
        [fileManager createDirectoryAtPath:[applicationDocumentsDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    return applicationDocumentsDirectory;
}


+ (void)encryptAndSaveRegistration:(NSDictionary *)successResponse atFile:(NSString *)filePath;
{
    
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:successResponse];
    if (myData) {
        NSString *key = [CBDeviceAssociation getSerialNumber];
        CCAlgorithm algo = kCCAlgorithmAES128;
        CCOptions opts = kCCOptionPKCS7Padding;
        CCCryptorStatus status = kCCSuccess;
        myData = [myData dataEncryptedUsingAlgorithm:algo key:key initializationVector:nil options:opts error:&status];
        
        [myData writeToURL:[[self appSpecificSupportDirectoryURL] URLByAppendingPathComponent:@"sipher_Registration.content"] atomically:YES];
        
    }
    
}

+(NSDictionary *)decryptedDataAtFile:(NSString *)filePath
{
    NSData *myData = [NSData dataWithContentsOfURL:[[self appSpecificSupportDirectoryURL] URLByAppendingPathComponent:@"sipher_activation.content"]];
    if (myData) {
            //        CCCryptorStatus *error = nil;
            //        myData = [myData decryptedDataUsingAlgorithm:kCCAlgorithmAES128 key:@"mykeyname213578g" error:error];
        NSString *key = [CBDeviceAssociation getSerialNumber];
        CCAlgorithm algo = kCCAlgorithmAES128;
        CCOptions opts = kCCOptionPKCS7Padding;
        CCCryptorStatus status = kCCSuccess;
        myData = [myData decryptedDataUsingAlgorithm:algo key:key initializationVector:nil options:opts error:&status];
        NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData: myData];
        NSLog(@"dictionary = %@",dictionary);
        return dictionary;
        
    }
    return nil;
}

@end
