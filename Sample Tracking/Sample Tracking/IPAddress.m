//
//  IPAddress.m
//  Sample Tracking
//
//  Created by Satendra Singh on 02/08/16.
//  Copyright © 2016 Satendra Singh. All rights reserved.
//

#import "IPAddress.h"

@implementation IPAddress

- (id)initWithString:(NSString *)ipaddress {
    self = [super init];
    if (self) {
        self.IPAddress = ipaddress;
    }
    return self;
}

- (BOOL)isLocalHost {
    if (self.IPAddress == nil) return NO;
    if ([@"127.0.0.1" compare:self.IPAddress options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        return YES;
    }
    
    if ([@"localhost" compare:self.IPAddress options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        return YES;
    }
    
    if ([@"::1" compare:self.IPAddress options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        return YES;
    }
    
    return NO;
}

- (BOOL) isIPV4 {
    NSArray *ar = [self.IPAddress componentsSeparatedByString:@"."];
    if (ar.count == 4) {
        return YES;
    }
    return NO;
}

- (BOOL) isIPV6 {
    if (![self isIPV4]) {
        if ([self.IPAddress rangeOfString:@":"].location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}

@end
