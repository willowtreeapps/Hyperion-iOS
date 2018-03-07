//
//  HYPLogger.h
//  LoggingOverlay
//
//  Created by Erik LaManna on 1/10/18.
//  Copyright © 2018 WillowTree. All rights reserved.
//

#import <Foundation/Foundation.h>

public static final NSNotificationName HYPERION_LOG_NOTIFICATION = @"HYPERION_LOG_NOTIFICATION";
public static final NSNotificationName HYPERION_LOG_CATEGORY = @"HYPERION_LOG_CATEGORY";
public static final NSNotificationName HYPERION_LOG_MESSAGE = @"HYPERION_LOG_MESSAGE";

@protocol HYPLoggerDelegate

- (void)loggedMessage:(NSString*)message withCategory:(NSString*)category;

@end

@interface HYPLogger : NSObject

@property (nonatomic, strong) NSMutableArray<NSString*> *log;
@property (nonatomic, weak) id<HYPLoggerDelegate> delegate;

@end
