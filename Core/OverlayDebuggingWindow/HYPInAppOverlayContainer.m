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

#import "HYPInAppOverlayContainer.h"
#import "HYPPluginContainerView.h"
#import "HYPOverlayViewProvider.h"

@interface HYPInAppOverlayContainer ()
@property (nonatomic) NSMutableArray *listeners;
@property (nonatomic) UIView *currentPluginContainer;
@end

@implementation HYPInAppOverlayContainer
@synthesize overlayModule = _overlayModule;

-(instancetype)init
{
    self = [super init];

    _listeners = [[NSMutableArray alloc] init];

    return self;
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitTest = [super hitTest:point withEvent:event];

    if (hitTest == self || [hitTest isKindOfClass:[HYPPluginContainerView class]] || !hitTest.userInteractionEnabled)
    {
        return [[[UIApplication sharedApplication] keyWindow] hitTest:point withEvent:event];
    }

    return hitTest;
}

-(void)setOverlayModule:(id<HYPPluginModule, HYPOverlayPluginViewProvider>)overlayModule
{
    [_overlayModule deactivateOverlayPluginView];
    _overlayModule = overlayModule;

    [_currentPluginContainer removeFromSuperview];

    if (overlayModule == nil)
    {
        return;
    }

    _currentPluginContainer = [[HYPPluginContainerView alloc] init];
    _currentPluginContainer.backgroundColor = [UIColor clearColor];
    [self addSubview:_currentPluginContainer];
    _currentPluginContainer.translatesAutoresizingMaskIntoConstraints = false;
    [_currentPluginContainer.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = true;
    [_currentPluginContainer.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = true;
    [_currentPluginContainer.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
    [_currentPluginContainer.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = true;

    [_overlayModule activateOverlayPluginViewWithContext:_currentPluginContainer];

    [_delegate overlayModuleChanged:overlayModule];
}

@end
