//  Copyright (c) 2017 WillowTree, Inc.

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "HYPOverlayDebuggingWindow.h"
#import "HYPInAppOverlayContainer.h"
#import "HYPOverlayDebuggingViewController.h"
#import "HyperionWindowManager.h"
#import "HYPSnapshotContainer.h"
#import "HYPOverlayViewProvider.h"

@interface HYPOverlayDebuggingWindow () <HYPOverlayContainerDelegate>
@end

@implementation HYPOverlayDebuggingWindow
@synthesize overlayModule;

static HYPOverlayDebuggingWindow *debuggingWindow;

+(HYPOverlayDebuggingWindow *)sharedInstance
{
    static dispatch_once_t once = 0;

    dispatch_once(&once, ^{
        debuggingWindow = [[HYPOverlayDebuggingWindow alloc] initWithFrame:[[[UIApplication sharedApplication] keyWindow] frame]];
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

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return [self.overlayContainer hitTest:point withEvent:event];
}

-(void)setup
{
    self.overlayContainer = [[HYPInAppOverlayContainer alloc] init];
    self.overlayContainer.delegate = self;
    [self setRootViewController:[HYPOverlayDebuggingViewController new]];

    self.backgroundColor = UIColor.clearColor;
    self.overlayContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.overlayContainer];

    [self.overlayContainer.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.overlayContainer.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [self.overlayContainer.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.overlayContainer.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;

    self.hidden = NO;
    self.backgroundColor = [UIColor clearColor];
}

-(void)overlayModuleChanged:(id<HYPPluginModule, HYPOverlayPluginViewProvider>)overlayModule
{
    self.hidden = !overlayModule;
}

-(void)makeKeyWindow
{
    [[HyperionWindowManager sharedInstance] decideNewKeyWindow];
}

@end
