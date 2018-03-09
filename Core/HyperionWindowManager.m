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

#import "HyperionWindowManager.h"
#import "HYPSnapshotDebuggingWindow.h"
#import "HYPOverlayDebuggingWindow.h"
#import "HYPSnapshotViewController.h"

@interface HyperionWindowManager()

@property (nonatomic) HYPOverlayDebuggingWindow *overlayWindow;
@property (nonatomic) HYPSnapshotDebuggingWindow *snapshotWindow;
@property (nonatomic, weak) UIWindow *currentAttachedWindow;

@end

@implementation HyperionWindowManager

static HyperionWindowManager *sharedWindowManager;

+(HyperionWindowManager *)sharedInstance
{
    static dispatch_once_t once = 0;

    dispatch_once(&once, ^{
        sharedWindowManager = [[HyperionWindowManager alloc] init];
    });

    return sharedWindowManager;
}

-(void)attachOverlayDebuggingWindowToWindow:(UIWindow *)attachedWindow
{
    _currentAttachedWindow = attachedWindow;
    _overlayWindow = [[HYPOverlayDebuggingWindow alloc] initWithFrame:attachedWindow.frame];
    _overlayWindow.hidden = YES;
    _overlayWindow.frame = attachedWindow.frame;
}

-(void)attachSnapshotDebuggingWindowToWindow:(UIWindow *)attachedWindow
{
    _currentAttachedWindow = attachedWindow;
    _snapshotWindow = [[HYPSnapshotDebuggingWindow alloc] initWithAttachedWindow:attachedWindow];
    _snapshotWindow.frame = CGRectMake(0, 0, attachedWindow.frame.size.width, attachedWindow.frame.size.height);
    [attachedWindow addGestureRecognizer:_snapshotWindow.overlayVC.twoFingerTapRecognizer];
    [attachedWindow addGestureRecognizer:_snapshotWindow.overlayVC.threeFingerTapRecognizer];
    [attachedWindow addGestureRecognizer:_snapshotWindow.overlayVC.edgeSwipeRecognizer];
    _snapshotWindow.accessibilityLabel = @"HyperionWindow";
}

-(void)togglePluginDrawer
{
    [_snapshotWindow togglePluginDrawer];
}

-(HYPSnapshotDebuggingWindow *)currentSnapshotWindow
{
    return _snapshotWindow;
}
-(HYPOverlayDebuggingWindow *)currentOverlayWindow
{
    return _overlayWindow;
}

-(void)decideNewKeyWindow
{
    if (!_currentAttachedWindow.hidden)
    {
        [_currentAttachedWindow makeKeyWindow];
    }
    else
    {
        [[[[UIApplication sharedApplication] windows] firstObject] makeKeyWindow];
    }

}

@end
