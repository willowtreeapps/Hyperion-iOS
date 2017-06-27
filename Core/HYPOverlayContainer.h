//
//  HYPOverlayContainer.h
//  Pods
//
//  Created by Chris Mays on 6/19/17.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HYPOverlayContainerListener.h"
#import "HYPOverlayViewProvider.h"

@protocol HYPPluginModule;

@protocol HYPOverlayContainer <NSObject>

@property (nonatomic) id<HYPPluginModule, HYPOverlayViewProvider> overlayModule;

-(void)addContainerListener:(NSObject<HYPOverlayContainerListener> *)listener;
-(void)removeContainerListener:(NSObject<HYPOverlayContainerListener> *)listener;

@end
