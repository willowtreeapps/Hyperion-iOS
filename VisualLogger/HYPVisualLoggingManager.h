//
//  HYPVisualLoggingManager.h
//  HyperionCore
//
//  Created by Chris Mays on 6/26/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class HYPVisualLoggingContainerView;

@interface HYPVisualLoggingManager : NSObject

@property (nonatomic, readonly) HYPVisualLoggingContainerView *loggingView;

-(void)postMessage:(NSString *)message data:(NSDictionary *)data color:(UIColor *)color;

@end
