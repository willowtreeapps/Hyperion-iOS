//
//  DebuggingWindow.h
//  WhatIsThatFont
//
//  Created by Chris Mays on 5/2/17.
//  Copyright © 2017 Willow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYPDebuggingOverlayViewController.h"

@interface HYPDebuggingWindow : UIWindow

+(HYPDebuggingWindow *)sharedInstance;

@property (nonatomic) HYPDebuggingOverlayViewController *overlayVC;
@property (nonatomic) UIEvent *lastEvent;
@property (nonatomic) UIView *highlightView;
@property (nonatomic) UIView *lastSelectedView;
@property (nonatomic) UITapGestureRecognizer *twoFingerTapRecognizer;
@property (nonatomic) UITapGestureRecognizer *threeFingerTapRecognizer;
@property (nonatomic) UIScreenEdgePanGestureRecognizer *edgeSwipeRecognizer;
@property (nonatomic) CGPoint start;
@property (nonatomic) CGPoint end;

@end
