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

@property (nonatomic) HYPDebuggingOverlayViewController *overlayVC;
@property (nonatomic) NSString *associatedFlag;

@end

@implementation HYPDebuggingWindow

+ (void)load
{
    if ([[UIApplication sharedApplication] keyWindow])
    {
        dispatch_after(DISPATCH_TIME_NOW + (NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                HYPDebuggingWindow *window = [[HYPDebuggingWindow alloc] initWithFrame:[[[UIApplication sharedApplication] keyWindow] frame]];
                 [[[UIApplication sharedApplication] keyWindow] addGestureRecognizer:window.panGesture];
                objc_setAssociatedObject(self, @selector(associatedFlag), window, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

         });
    }
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

-(UIScreenEdgePanGestureRecognizer *)panGesture
{
    return self.overlayVC.panGesture;
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
