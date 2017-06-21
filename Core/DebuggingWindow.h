//
//  DebuggingWindow.h
//  WhatIsThatFont
//
//  Created by Chris Mays on 5/2/17.
//  Copyright © 2017 Willow. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DebuggingWindow : UIWindow

@property (nonatomic) UIEvent *lastEvent;
@property (nonatomic) UIView *highlightView;
@property (nonatomic) UIView *lastSelectedView;
@property (nonatomic) UIScreenEdgePanGestureRecognizer *panGesture;
@property (nonatomic) CGPoint start;
@property (nonatomic) CGPoint end;

@end
