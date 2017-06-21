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

-(UIWindow *)appWindow;
-(UIWindow *)hypeWindow;
-(id<HYPOverlayContainer>)overlayContainer;
-(id<HYPTargetView>)getViewTarget;

@end
