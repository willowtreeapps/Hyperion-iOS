//
//  HYPDebuggingWindow.m
//
//  Created by Chris Mays on 5/2/17.
//  Copyright © 2017 Willow. All rights reserved.
//

#import "HYPDebuggingWindow.h"
#import "TabStack.h"
#import "TabView.h"
#import "ToolsTabViewController.h"
#import "HYPPluginExtension.h"
#import "HYPPluginExtensionImp.h"
#import "HYPPlugin.h"
#import "HYPOverlayContainerImp.h"
#import "HYPDebuggingOverlayViewController.h"
#import <objc/runtime.h>


@interface HYPDebuggingWindow() <UIGestureRecognizerDelegate>

@property (nonatomic) NSString *associatedFlag;

@end

@implementation HYPDebuggingWindow

static HYPDebuggingWindow *debuggingWindow;

+ (void)load
{
}

+(HYPDebuggingWindow *)sharedInstance
{
    static dispatch_once_t once = 0;

    dispatch_once(&once, ^{
        debuggingWindow = [[HYPDebuggingWindow alloc] initWithFrame:[[[UIApplication sharedApplication] keyWindow] frame]];
    });

    return debuggingWindow;
}

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

-(void)setup
{
    self.overlayVC = [[HYPDebuggingOverlayViewController alloc] initWithDebuggingWindow:self];
    [self setRootViewController:self.overlayVC];

    self.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
}

-(void)deactivate
{
    self.hidden = YES;
}

-(void)activateDebugMenu
{
    self.hidden = !self.hidden;
}


@end
