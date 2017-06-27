//
//  HYPVisualLoggingManager.m
//  HyperionCore
//
//  Created by Chris Mays on 6/26/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import "HYPVisualLoggingManager.h"
#import "HYPVisualLoggingContainerView.h"
#import "HYPLogItemView.h"

@implementation HYPVisualLoggingManager
@synthesize loggingView = _loggingView;

-(HYPVisualLoggingContainerView *)loggingView
{
    if (!_loggingView)
    {
        _loggingView = [[HYPVisualLoggingContainerView alloc] init];

    }

    return _loggingView;
}

-(void)postMessage:(NSString *)message data:(NSDictionary *)data color:(UIColor *)color
{
    HYPLogItemView *logItem = [[HYPLogItemView alloc] initWithMessageText:message detailText:[data description] color:color];

    [_loggingView addLogView:logItem forTime:10];
}

@end
