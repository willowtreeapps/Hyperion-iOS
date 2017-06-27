//
//  UIWindow+Swizzling.h
//  HyperionCore
//
//  Created by Chris Mays on 6/23/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYPDebuggingWindow.h"
#import "HYPInAppDebuggingWindow.h"

@interface UIWindow (Swizzling)

@property (nonatomic, readonly) HYPDebuggingWindow *debugWindow;

@end
