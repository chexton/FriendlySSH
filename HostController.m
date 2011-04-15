//
//  HostController.m
//  FriendlySsh
//
//  Created by Chris Hexton on 12/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HostController.h"


@implementation HostController

- (id) init
{
    self = [super initWithWindowNibName:@"HostWindow"];
    if (self) {}
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self showWindow:nil];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
