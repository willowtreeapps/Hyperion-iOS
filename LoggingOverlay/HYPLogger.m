//
//  HYPLogger.m
//  LoggingOverlay
//
//  Created by Erik LaManna on 1/10/18.
//  Copyright © 2018 WillowTree. All rights reserved.
//

#import "HYPLogger.h"

@implementation HYPLogger

NSString* const HYPERION_LOG_NOTIFICATION = @"HYPERION_LOG_NOTIFICATION";
NSString* const HYPERION_LOG_CATEGORY = @"HYPERION_LOG_CATEGORY";
NSString* const HYPERION_LOG_MESSAGE = @"HYPERION_LOG_MESSAGE";

@synthesize log = _log;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.log = [NSMutableArray new];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logMessage:) name:HYPERION_LOG_NOTIFICATION object:nil];
    }
    
    return self;
}

- (void)logMessage:(NSNotification*)notification {
    
    NSString* message = [notification.userInfo valueForKey:HYPERION_LOG_MESSAGE];
    NSString* category = [notification.userInfo valueForKey:HYPERION_LOG_CATEGORY];
    
    // TODO: Probably store the log message in a better place (also verify nullability of message and category
    NSString *logMessage = [NSString stringWithFormat:@"%@ %@", message, category];
    [self.log addObject:logMessage];
    [self.delegate loggedMessage:message withCategory:category];
}

@end
