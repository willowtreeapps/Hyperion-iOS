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

@protocol HYPOverlayContainer <NSObject>

-(void)addOverlayView:(UIView *)view;
-(void)removeOverlayView:(UIView *)view;

-(void)addContainerListener:(NSObject<HYPOverlayContainerListener> *)listener;
-(void)removeContainerListener:(NSObject<HYPOverlayContainerListener> *)listener;

-(BOOL)containsOverlaysOfClass:(Class)overlayClass;
-(BOOL)removeAllOverlaysOfClass:(Class)overlayClass;

@end
