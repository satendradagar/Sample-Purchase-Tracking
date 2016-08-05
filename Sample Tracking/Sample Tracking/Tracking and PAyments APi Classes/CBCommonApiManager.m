//
//  CBCommonApiManager.m
//  Tracking Library: @CoreBits 
//
//  Created by Satendra Singh on 04/07/16.
//
//

#import "CBCommonApiManager.h"

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

@end
