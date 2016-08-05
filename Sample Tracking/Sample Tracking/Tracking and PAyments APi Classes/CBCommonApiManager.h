//
//  CBCommonApiManager.h
//  Tracking Library: @CoreBits 
//
//  Created by Satendra Singh on 04/07/16.
//
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>

//const NSString *baseUrl;

@interface CBCommonApiManager : NSObject

    //user_id,userEmailID,deviceDetail
+ (void)performPostAtSuffixUrl:(NSString *)suffix parameters:(NSDictionary *)params success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;


+ (void)performGetAtSuffixUrl:(NSString *)suffix success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;


@end
