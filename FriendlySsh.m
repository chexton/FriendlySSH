//
//  IPMenulet.m
//  IPMenulet
//
//  Created by Chris Hexton on 25/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FriendlySsh.h"

@implementation FriendlySsh


//---------- THESE START OFF THE APP ---------------//

-(void)dealloc
{
    [statusItem release];
	[hosts release];
	[super dealloc];
}

- (void)awakeFromNib
{	
	// Set the array of hosts
	hosts = [[NSMutableArray alloc] init];
	[self loadFromFile:[self defaultFileName]];
	
	//Set the basic menu item (always visible)
	statusItem = [[[NSStatusBar systemStatusBar] 
				   statusItemWithLength:NSVariableStatusItemLength]
				  retain];
	[statusItem setHighlightMode:YES];
	[statusItem setTitle:[NSString 
						  stringWithString:@"SSH Hosts"]]; 
	[statusItem setEnabled:YES];
	[statusItem setToolTip:@"IPMenulet"];
	
	//Setup the menu (from the menuBar item)
	[statusItem setMenu:theMenu];
	NSString *test = nil;
	if([hosts count] == 0) {
		test = @"blah";
	} else {
		//test = [[hosts objectAtIndex:0] host];
		[self updateMenu:hosts];
	}
	ipMenuItem = [[NSMenuItem alloc] initWithTitle:test
											action:@selector(updateIPAddress:) keyEquivalent:@""];
	[ipMenuItem setTarget:self];
	[theMenu insertItem:ipMenuItem atIndex:0];
}

-(IBAction)updateIPAddress:(id)sender
{
	NSString *ipAddr = [NSString stringWithContentsOfURL:
						[NSURL URLWithString:
						 @"http://highearthorbit.com/service/myip.php"]];
	if(ipAddr != NULL)
		[statusItem setTitle:
		 [NSString stringWithString:ipAddr]]; 
}


//---------- THIS LAUNCHES THE TUNNEL ---------------//

-(IBAction)doLaunchSshTunnel:(id)sender
{
}


//---------- UPDATES THE MENU ---------------//
-(void)updateMenu:(NSMutableArray *)hostsArray
{
	NSMenuItem *tempMenuItem;
	int index;
	for (index=0; index<[hostsArray count]; index++) {
		Host *host = [hosts objectAtIndex:index];
		
		tempMenuItem = [[NSMenuItem alloc] initWithTitle:[host host]
												action:@selector(updateIPAddress:) keyEquivalent:@""];
		[tempMenuItem setTarget:self];
		[theMenu insertItem:tempMenuItem atIndex:index];
	}
}

//---------- THESE APPLY TO ADDING AND SAVING A NEW HOST ---------------//

- (IBAction) doConfirmAddHost: (id)pId 
{
	id host = [[Host alloc] init];
	
	[host setTitle:[panelInputUsername stringValue]];
	[host setHost:[panelInputHost stringValue]];
	[host setPort:[panelInputPort stringValue]];
	
	[hosts addObject:host];
    
    [panelInputUsername setStringValue:@""];
    [panelInputHost setStringValue:@""];
    [panelInputPort setStringValue:@""];
    [NSApp endSheet:panelSheet];
    
    [self saveToFile:[self defaultFileName]];
}

- (IBAction)doAddHost: (id)sender
{    
	HostController *window = [[HostController alloc] init];
    [window.window makeKeyAndOrderFront:self];
}

- (IBAction)doCancelEditHost:(id)pId {
    [panelInputUsername setStringValue:@""];
    [panelInputHost setStringValue:@""];
    [panelInputPort setStringValue:@""];
    [NSApp endSheet:panelSheet];
}


//---------- THESE APPLY TO LOADING & SAVING THE ARRAY ---------------//

- (void) saveToFile: (NSString *)fileName {
    id plist = [[NSMutableArray alloc] init];
	int index;
    for (index=0;index<[hosts count]; index++) {
        id dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[[hosts objectAtIndex:index] identifier] forKey:@"identifier"];
        [dict setValue:[[hosts objectAtIndex:index] username] forKey:@"title"];
        [dict setValue:[[hosts objectAtIndex:index] host] forKey:@"host"];
        [dict setValue:[[hosts objectAtIndex:index] port] forKey:@"port"];
        [plist addObject:dict];
    }
    
    NSString *error;
    NSData *xmlData = [NSPropertyListSerialization dataFromPropertyList:plist
                                                                 format:NSPropertyListXMLFormat_v1_0
                                                       errorDescription:&error];
	
    if (xmlData) {
        [xmlData writeToFile:fileName atomically:YES];
    } else {
        NSLog(error);
        [error release];
    }
}

- (void) loadFromFile: (NSString *)fileName {
    NSData *xmlData = [NSData dataWithContentsOfFile:fileName];
    NSString *error;
    NSPropertyListFormat format;
    id plist;
    
    plist = [NSPropertyListSerialization propertyListFromData:xmlData
                                             mutabilityOption:NSPropertyListImmutable
                                                       format:&format
                                             errorDescription:&error];
    
    if (!plist) {
        NSLog(error);
        [error release];
    } else {
		int index;
        for (index=0; index<[plist count]; index++) {
            Host *host = [[Host alloc] init];
            [host setIdentifier:[[plist objectAtIndex:index] valueForKey:@"identifier"]];
            [host setTitle:[[plist objectAtIndex:index] valueForKey:@"title"]];
            [host setHost:[[plist objectAtIndex:index] valueForKey:@"host"]];
            [host setPort:[[plist objectAtIndex:index] valueForKey:@"port"]];
            
            [hosts addObject:host];
        }
    }
}

- (NSString *) defaultFileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Hosts"
                                                     ofType:@"plist"];
    return path;
}

@end
