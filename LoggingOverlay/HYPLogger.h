//
//  HYPLogger.h
//  LoggingOverlay
//
//  Created by Erik LaManna on 1/10/18.
//  Copyright © 2018 WillowTree. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const _Nonnull HYPERION_LOG_NOTIFICATION;
extern NSString* const _Nonnull HYPERION_LOG_CATEGORY;
extern NSString* const _Nonnull HYPERION_LOG_MESSAGE;

@protocol HYPLoggerDelegate

- (void)loggedMessage:(nullable NSString*)message withCategory:(nullable NSString*)category;

@end

@interface HYPLogger : NSObject

@property (nonatomic, strong) NSMutableArray<NSString*>* _Nonnull log;
@property (nonatomic, weak) id<HYPLoggerDelegate> _Nullable delegate;

@end
