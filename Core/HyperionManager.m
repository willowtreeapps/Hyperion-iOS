//
//  HyperionManager.m
//  HyperionCore
//
//  Created by Matt Kauper on 7/21/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyperionManager.h"
#import "HYPDebuggingWindow.h"

@implementation HyperionManager : NSObject

+(void)setActivationGesture:(HYPActivationGestureOptions)gesture {

    if ((gesture & HYPActivationGestureNone) == HYPActivationGestureNone)
    {
        [[[HYPDebuggingWindow sharedInstance] tapGestureRecognizer] setEnabled:NO];
        return;
    }

    if ((gesture & HYPActivationGestureTwoFingerDoubleTap) == HYPActivationGestureTwoFingerDoubleTap)
    {

    }

    if ((gesture & HYPActivationGestureThreeFingerSingleTap) == HYPActivationGestureThreeFingerSingleTap)
    {

    }

    if ((gesture & HYPActivationGestureRightEdgeSwipe) == HYPActivationGestureRightEdgeSwipe)
    {

    }
}

@end
