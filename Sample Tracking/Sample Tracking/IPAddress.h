//
//  IPAddress.h
//  Sample Tracking
//
//  Created by Satendra Singh on 02/08/16.
//  Copyright © 2016 Satendra Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPAddress : NSObject

@property (nonatomic, strong) NSString *IPAddress;

- (id)initWithString:(NSString *)ipaddress;

- (BOOL)isLocalHost;
- (BOOL) isIPV4;
- (BOOL) isIPV6;

@end
