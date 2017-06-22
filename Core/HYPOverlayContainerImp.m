//
//  HYPOverlayContainerImp.m
//  Pods
//
//  Created by Chris Mays on 6/19/17.
//
//

#import "HYPOverlayContainerImp.h"
#import "HYPOverlayContainerListener.h"
#import "HYPListenerContainer.h"

@interface HYPOverlayContainerImp ()

@property (nonatomic) UIView *currentOverlay;
@property (nonatomic) NSMutableArray *listeners;

@end

@implementation HYPOverlayContainerImp

-(void)addOverlayView:(UIView *)view
{
    for (UIView *subview in self.subviews)
    {
        if (subview != self.snapshotView)
        {
            [subview removeFromSuperview];
        }
    }

    view.frame = _snapshotView.frame;

    _currentOverlay = view;

    [self addSubview:view];

    [self notifyOverlayViewChanged:_currentOverlay];
}

-(void)removeOverlayView:(UIView *)view
{
    if (view == _currentOverlay)
    {
        _currentOverlay = nil;
        [view removeFromSuperview];
        [self notifyOverlayViewChanged:nil];
    }
    else
    {
        [view removeFromSuperview];
    }
}


-(BOOL)containsOverlaysOfClass:(Class)overlayClass
{
    for (UIView *subview in self.subviews)
    {
        if (subview != self.snapshotView && [subview isKindOfClass:overlayClass])
        {
            return YES;
        }
    }

    return NO;
}

-(BOOL)removeAllOverlaysOfClass:(Class)overlayClass
{
    BOOL containedOverlays = false;

    for (UIView *subview in self.subviews)
    {
        if (subview != self.snapshotView && [subview isKindOfClass:overlayClass])
        {
            containedOverlays = true;
            [self removeOverlayView:subview];
        }
    }

    return containedOverlays;
}

-(void)setSnapshotView:(UIView *)snapshotView
{
    [_snapshotView removeFromSuperview];
    _snapshotView = snapshotView;
    _currentOverlay.frame = _snapshotView.frame;
    [self addSubview:snapshotView];
    [self sendSubviewToBack:snapshotView];
}

-(void)notifyOverlayViewChanged:(UIView *)overlayView
{
    for (HYPListenerContainer *container in self.listeners)
    {
        id<HYPOverlayContainerListener> listener = (id<HYPOverlayContainerListener>)container.listener;

        if ([listener conformsToProtocol:@protocol(HYPOverlayContainerListener)])
        {
            [listener overlayViewChanged:overlayView];
        }
    }
}

-(void)addContainerListener:(NSObject<HYPOverlayContainerListener> *)listener
{
    HYPListenerContainer *container = [[HYPListenerContainer alloc] initWithListener:listener];

    self.listeners = self.listeners ?: [[NSMutableArray alloc] init];

    [self.listeners addObject:container];

}

-(void)removeContainerListener:(NSObject<HYPOverlayContainerListener> *)listener
{
    NSMutableArray *mutableListeners = [[NSMutableArray alloc] initWithArray:self.listeners];

    for (HYPListenerContainer *listenerContainer in self.listeners)
    {
        if (listenerContainer.listener != listener)
        {
            [mutableListeners addObject:listenerContainer];
        }
    }

    self.listeners = mutableListeners;
}

-(NSUInteger)numberOfOverlays
{
    //Don't count the snapshotview
    return [[self subviews] count] - 1;
}

@end
