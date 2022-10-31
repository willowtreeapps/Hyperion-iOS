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

#import "HYPSnapshotContainer.h"

@interface HYPSnapshotContainer ()

@property (nonatomic) UIView *currentOverlay;
@property (nonatomic) NSMutableArray *listeners;
@property (nonatomic) UIView *currentPluginContainer;

@end

@implementation HYPSnapshotContainer

@synthesize overlayModule = _overlayModule;

-(void)setOverlayModule:(id<HYPPluginModule, HYPSnapshotPluginViewProvider>)overlayModule
{
    [self.delegate dismissCurrentPopover];
    [_overlayModule deactivateSnapshotPluginView];
    _overlayModule = overlayModule;

    [_currentPluginContainer removeFromSuperview];

    if (overlayModule == nil)
    {
        [self.delegate overlayModuleChanged:nil];
        return;
    }

    _currentPluginContainer = [[UIView alloc] init];
    _currentPluginContainer.backgroundColor = [UIColor clearColor];
    [self addSubview:_currentPluginContainer];
    _currentPluginContainer.translatesAutoresizingMaskIntoConstraints = false;
    [_currentPluginContainer.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = true;
    [_currentPluginContainer.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = true;
    [_currentPluginContainer.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
    [_currentPluginContainer.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = true;

    [_overlayModule activateSnapshotPluginViewWithContext:_currentPluginContainer];

    [self.delegate overlayModuleChanged:_overlayModule];
}

-(void)presentPopover:(nonnull UIViewController *)popoverController recommendedHeight:(CGFloat)height atPosition:(CGPoint)point
{
    [self.delegate presentPopover:popoverController recommendedHeight:height atPosition:point];
}

-(void)presentViewListPopoverForPoint:(CGPoint)point delegate:(id<HYPViewSelectionDelegate>)delegate
{
    [self.delegate presentViewListPopoverForPoint:point delegate:delegate];
}

-(void)presentPopover:(nonnull UIViewController *)popoverController recommendedHeight:(CGFloat)height forView:(nonnull UIView *)view
{
    [self.delegate presentPopover:popoverController recommendedHeight:height  forView:view];
}

-(void)dismissCurrentPopover
{
    [self.delegate dismissCurrentPopover];
}

-(void)setSnapshotView:(UIView *)snapshotView
{
    [_snapshotView removeFromSuperview];
    _snapshotView = snapshotView;
    _currentOverlay.frame = _snapshotView.frame;
    [self addSubview:snapshotView];
    [self sendSubviewToBack:snapshotView];
}


-(void)presentViewController:(nonnull UIViewController *)controller animated:(bool)animated
{
    [self.delegate presentViewController:controller animated:animated];
}

@end
