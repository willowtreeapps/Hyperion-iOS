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

#import "HYPSnapshotDebuggingWindow.h"
#import "PluginListViewController.h"
#import "HYPPluginExtension.h"
#import "HYPPluginExtensionImp.h"
#import "HYPPlugin.h"
#import "HYPSnapshotContainer.h"
#import "HYPSnapshotViewController.h"
#import <objc/runtime.h>
#import "HyperionWindowManager.h"

@interface HYPSnapshotDebuggingWindow() <UIGestureRecognizerDelegate>

@property (nonatomic) NSString *associatedFlag;
@property (nonatomic, weak) UIWindow *attachedWindow;

@property (nonatomic) UIPanGestureRecognizer *deactivateDrawerPanGesture;
@property (nonatomic) UITapGestureRecognizer *dismissDrawerTapGesture;
@property (nonatomic) UITapGestureRecognizer *fadeViewTapRecognizer;

@end

@implementation HYPSnapshotDebuggingWindow

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    [self setup];

    return self;
}

-(instancetype)initWithAttachedWindow:(UIWindow *)attachedWindow
{
    self = [super initWithFrame:attachedWindow.frame];
    _attachedWindow = attachedWindow;
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
    self.overlayVC = [[HYPSnapshotViewController alloc] initWithDebuggingWindow:self attachedWindow:self.attachedWindow];

    [self setRootViewController:self.overlayVC];

    self.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
}

-(void)togglePluginDrawer
{
    [self.overlayVC togglePluginDrawer];
}

-(void)deactivate
{
    self.hidden = YES;
}

-(id<HYPSnapshotContainer>)snapshotContainer
{
    return self.overlayVC.snapshotContainer;
}

-(void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    [self cleanup];
}

-(void)cleanup
{
    if (self.hidden && [[UIApplication sharedApplication] keyWindow] != self.attachedWindow)
    {
        [self.attachedWindow makeKeyWindow];
    }
}


-(void)makeKeyWindow
{
    //Some plugins will have keyboards so it is expected to become
    //the key window.
    if (self.hidden)
    {
        [[HyperionWindowManager sharedInstance] decideNewKeyWindow];
    }
    else
    {
        [super makeKeyWindow];
    }
}

@end
