//
//  AppDelegate.m
//  Sample Tracking
//
//  Created by Satendra Singh on 26/07/16.
//  Copyright © 2016 Satendra Singh. All rights reserved.
//

#import "AppDelegate.h"
#import "IPAddress.h"
#import "PortMapper.h"
#import "STUNClient.h"
#import "GCDAsyncUdpSocket.h"
#import "CBDeviceAssociation.h"

@interface AppDelegate ()
{
    STUNClient *stunClient;
    GCDAsyncUdpSocket *udpSocket;
}

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
        //                      @"deviceDetail": [userKeys objectForKey:@"deviceDetail"],
        //        @"userEmailID": [userKeys objectForKey:@"userEmailID"],
    [CBDeviceAssociation registerDeviceDetailsWithUserDetails:@{@"deviceDetail": @"Hello sample",@"userEmailID": @"satendradagar@gmail.com",@"user_id": @"satendradagar@gmail.com"}];
    [CBDeviceAssociation getDeviceDetailsForCurrentDevice:^(NSDictionary *response, NSError *error) {
        
    }];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark -
#pragma mark STUNClientDelegate

-(void)didReceivePublicIPandPort:(NSDictionary *) data{
    NSLog(@"Public IP=%@, public Port=%@, NAT is Symmetric: %@", [data objectForKey:publicIPKey],
          [data objectForKey:publicPortKey], [data objectForKey:isPortRandomization]);
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"result" message:[data description] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//    [alert show];
//    [alert release];
//    
//    [stunClient startSendIndicationMessage];
}

@end
