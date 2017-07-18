//
//  HYPPluginExtension.h
//  Pods
//
//  Created by Chris Mays on 6/19/17.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HYPTargetView.h"
#import "HYPOverlayContainer.h"

@protocol HYPPluginExtension <NSObject>

-(nonnull UIWindow *)appWindow;
-(nonnull UIWindow *)hypeWindow;
-(nonnull id<HYPOverlayContainer>)overlayContainer;
-(nonnull id<HYPOverlayContainer>)inAppOverlayContainer;
-(nullable id<HYPTargetView>)getViewTarget;

@end
