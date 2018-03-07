//
//  HYPLogger.m
//  LoggingOverlay
//
//  Created by Erik LaManna on 1/10/18.
//  Copyright © 2018 WillowTree. All rights reserved.
//

#import "HYPLogger.h"

@implementation HYPLogger

@synthesize log = _log;

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaulCenter] addObserver:self selector:@selector(logMessage:) name:HYPERION_LOG_NOTIFICATION object:nil];
    }
}

- (void)logMessage:(NSNotification*)notification {
    
    NSString* message = [notification valueForKey:HYPERION_LOG_MESSAGE];
    NSString* category = [notification valueForKey:HYPERION_LOG_CATEGORY];
    [self.delegate loggedMessage:message withCategory:category];
}

@end
