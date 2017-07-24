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

    HYPDebuggingWindow *window = [HYPDebuggingWindow sharedInstance];

    if ((gesture & HYPActivationGestureNone) == HYPActivationGestureNone)
    {
        [window.twoFingerTapRecognizer setEnabled:NO];
        [window.threeFingerTapRecognizer setEnabled:NO];
        [window.edgeSwipeRecognizer setEnabled:NO];
        [window.overlayVC.twoFingerTapRecognizer setEnabled:NO];
        [window.overlayVC.threeFingerTapRecognizer setEnabled:NO];
        [window.overlayVC.edgeSwipeRecognizer setEnabled:NO];
        return;
    }

    BOOL twoFingerTapEnabled = ((gesture & HYPActivationGestureTwoFingerDoubleTap) == HYPActivationGestureTwoFingerDoubleTap);
    [window.twoFingerTapRecognizer setEnabled:twoFingerTapEnabled];
    [window.overlayVC.twoFingerTapRecognizer setEnabled:twoFingerTapEnabled];

    BOOL threeFingerTapEnabled = ((gesture & HYPActivationGestureThreeFingerSingleTap) == HYPActivationGestureThreeFingerSingleTap);
    [window.threeFingerTapRecognizer setEnabled:threeFingerTapEnabled];
    [window.overlayVC.threeFingerTapRecognizer setEnabled:threeFingerTapEnabled];

    BOOL edgeSwipeEnabled = ((gesture & HYPActivationGestureRightEdgeSwipe) == HYPActivationGestureRightEdgeSwipe);
    [window.edgeSwipeRecognizer setEnabled:edgeSwipeEnabled];
    [window.overlayVC.edgeSwipeRecognizer setEnabled:edgeSwipeEnabled];
}

@end
