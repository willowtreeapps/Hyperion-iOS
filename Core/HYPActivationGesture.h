//
//  HYPActivationGesture.h
//  HyperionCore
//
//  Created by Matt Kauper on 7/19/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

typedef enum HYPActivationGesture : NSUInteger {
    HYPActivationGestureNone                    = 1 << 0,
    HYPActivationGestureTwoFingerDoubleTap      = 1 << 1,
    HYPActivationGestureThreeFingerSingleTap    = 1 << 2,
    HYPActivationGestureRightEdgeSwipe          = 1 << 3
} HYPActivationGesture;
