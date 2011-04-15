//
//  IPMenulet.h
//  IPMenulet
//
//  Created by Chris Hexton on 25/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HostController.h"
#import "Host.h"

@interface FriendlySsh : NSObject {
	// StatusItem
    NSStatusItem *statusItem;
	// The Menu
	IBOutlet NSMenu *theMenu;
	NSMenuItem *ipMenuItem;
	// Hosts array
	NSMutableArray *hosts;
	// The Add panel
    IBOutlet id panelSheet;
    IBOutlet id panelInputUsername;
    IBOutlet id panelInputHost;
    IBOutlet id panelInputPort;
}

// Test
-(IBAction)updateIPAddress:(id)sender;
// To update the menu
-(void)updateMenu:(NSMutableArray *)hostsArray;
// To launch the tunnel
-(IBAction)doLaunchSshTunnel:(id)sender;
// Add the hosts
-(IBAction)doConfirmAddHost:(id)pId;
-(IBAction)doAddHost:(id)sender;
-(IBAction)doCancelEditHost: (id)pId;
// Retreive and save hosts
- (void) saveToFile: (NSString *)fileName;
- (void) loadFromFile: (NSString *)fileName;
- (NSString *) defaultFileName;

@end
