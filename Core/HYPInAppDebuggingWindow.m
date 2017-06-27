//
//  HYPInAppDebuggingWindow.m
//  HyperionCore
//
//  Created by Chris Mays on 6/26/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import "HYPInAppDebuggingWindow.h"
#import "HYPInAppOverlayContainer.h"

@interface HYPInAppDebuggingWindow ()

@end

@implementation HYPInAppDebuggingWindow

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    [self setup];

    return self;
}

-(instancetype)init
{
    self = [super init];

    [self setup];

    return self;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return [self.overlayContainer hitTest:point withEvent:event];
}

-(void)setup
{
    self.overlayContainer = [[HYPInAppOverlayContainer alloc] init];
    [self setRootViewController:[[UIViewController alloc] init]];

    self.overlayContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.overlayContainer];

    [self.overlayContainer.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.overlayContainer.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [self.overlayContainer.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.overlayContainer.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;

    self.hidden = NO;
    self.backgroundColor = [UIColor clearColor];
}

@end
