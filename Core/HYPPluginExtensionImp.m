//
//  HYPPluginExtensionImp.m
//  Pods
//
//  Created by Chris Mays on 6/19/17.
//
//

#import "HYPPluginExtensionImp.h"
#import "HYPTargetViewListener.h"
#import "HYPListenerContainer.h"

@interface HYPTargetViewImp ()

@property (nonatomic) NSMutableArray<HYPTargetViewListener> *listeners;

@end

@implementation HYPTargetViewImp

@synthesize targetView = _targetView;

-(void)setTargetView:(UIView *)targetView
{
    _targetView = targetView;

    [self notifyTargetViewChanged:targetView];
}

-(void)notifyTargetViewChanged:(UIView *)overlayView
{
    for (HYPListenerContainer *container in self.listeners)
    {
        id<HYPTargetViewListener> listener = (id<HYPTargetViewListener>)container.listener;

        if ([listener conformsToProtocol:@protocol(HYPTargetViewListener)])
        {
            [listener targetViewChanged:overlayView];
        }
    }
}

-(void)addTargetViewListener:(NSObject<HYPTargetViewListener> *)listener
{
    HYPListenerContainer *container = [[HYPListenerContainer alloc] initWithListener:listener];

    self.listeners = self.listeners ?: [[NSMutableArray alloc] init];

    [self.listeners addObject:container];

}

-(void)removeTargetViewListener:(NSObject<HYPTargetViewListener> *)listener
{
    NSMutableArray<HYPTargetViewListener> *mutableListeners = [[NSMutableArray<HYPTargetViewListener> alloc] initWithArray:self.listeners];

    for (HYPListenerContainer *listenerContainer in self.listeners)
    {
        if (listenerContainer.listener != listener)
        {
            [mutableListeners addObject:listenerContainer];
        }
    }

    self.listeners = mutableListeners;
}


@end


@interface HYPPluginExtensionImp ()
@property (nonatomic) id<HYPTargetView> targetView;
@property (nonatomic) id<HYPOverlayContainer> overlayContainer;
@property (nonatomic) id<HYPOverlayContainer> inAppOverlayContainer;
@property (nonatomic, weak) UIWindow *hypeWindow;
@end

@implementation HYPPluginExtensionImp

-(instancetype)initWithOverlayContainer:(id<HYPOverlayContainer>)overlayContainer inAppOverlay:(id<HYPOverlayContainer>)inAppOverlay hypeWindow:(UIWindow *)hypeWindow;
{
    self = [super init];

    _targetView = [[HYPTargetViewImp alloc] init];
    _overlayContainer = overlayContainer;
    _hypeWindow = hypeWindow;
    _inAppOverlayContainer = inAppOverlay;
    
    return self;
}

-(UIWindow *)appWindow
{
    return [[UIApplication sharedApplication] keyWindow];
}

-(UIWindow *)hypeWindow
{
    return _hypeWindow;
}

-(id<HYPOverlayContainer>)overlayContainer
{
    return _overlayContainer;
}

-(id<HYPOverlayContainer>)inAppOverlayContainer
{
    return _inAppOverlayContainer;
}

-(id<HYPTargetView>)getViewTarget
{
    return _targetView;
}

@end
