//
//  HYPInAppOverlayContainer.m
//  HyperionCore
//
//  Created by Chris Mays on 6/26/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import "HYPInAppOverlayContainer.h"
#import "HYPListenerContainer.h"

@interface HYPInAppOverlayContainer ()
@property (nonatomic) NSMutableArray *listeners;
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

    if (hitTest == self)
    {
        return [[[UIApplication sharedApplication] keyWindow] hitTest:point withEvent:event];
    }

    return hitTest;
}

-(void)setOverlayModule:(id<HYPPluginModule, HYPOverlayViewProvider>)overlayModule
{
    _overlayModule = overlayModule;

    for (UIView *subview in self.subviews)
    {
        [subview removeFromSuperview];
    }

    if (!overlayModule)
    {
        [self notifyOverlayModuleChanged:nil];
        return ;
    }

    UIView *newOverlay = overlayModule.overlayView;

    [self addSubview:newOverlay];
    newOverlay.frame = self.bounds;
    [self notifyOverlayModuleChanged:_overlayModule];
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

-(void)notifyOverlayModuleChanged:(id<HYPPluginModule, HYPOverlayViewProvider>)overlayModule
{
    for (HYPListenerContainer *container in self.listeners)
    {
        id<HYPOverlayContainerListener> listener = (id<HYPOverlayContainerListener>)container.listener;

        if ([listener conformsToProtocol:@protocol(HYPOverlayContainerListener)])
        {
            [listener overlayModuleChanged:overlayModule];
        }
    }
}


@end
