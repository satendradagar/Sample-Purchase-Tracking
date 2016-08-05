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
//    NSLog(@"Addresses: %@", [[NSHost currentHost] addresses]);
//   NSString * publicAddressString = [PortMapper findPublicAddress];

        //   NSLog(@"Addresses: %@", publicAddressString);
        // request public IP and Port through STUN
//    udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//    
//    
//    stunClient = [[STUNClient alloc] init];
//    [stunClient requestPublicIPandPortWithUDPSocket:udpSocket delegate:self];
//    
//    for (NSString *s in [[NSHost currentHost] addresses]) {
//        IPAddress *addr = [[IPAddress alloc] initWithString:s];
//        if (![addr isLocalHost] && [addr isIPV4]) {
//                // do something
//            NSLog(@"%@",addr.IPAddress);
//        }
//    }
    
    NSURL *iPURL = [NSURL URLWithString:@"http://ip-api.com/json"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:iPURL];
        //    [httpClient setDefaultHeader:@"Accept" value:@"text/json"];
    [req setValue:@"text/json" forHTTPHeaderField:@"Accept"];
    [req setHTTPMethod:@"GET"];
    req.timeoutInterval = 45;
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (nil != data) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (dict) {
                NSLog(@"Response: %@",dict);
//                responseHandler([dict objectForKey:@"query"]);//Successfull case
            }
            else{
                
//                responseHandler(nil);
            }
        }
        else{
//            responseHandler(nil);
            
        }
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
