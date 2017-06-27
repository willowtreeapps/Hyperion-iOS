//
//  HYPPluginExtensionImp.h
//  Pods
//
//  Created by Chris Mays on 6/19/17.
//
//

#import <Foundation/Foundation.h>
#import "HYPPluginExtension.h"
#import "HYPTargetView.h"
#import "HYPOverlayContainer.h"
@interface HYPTargetViewImp : NSObject<HYPTargetView>

@end

@interface HYPPluginExtensionImp : NSObject<HYPPluginExtension>

-(instancetype)initWithOverlayContainer:(id<HYPOverlayContainer>)overlayContainer inAppOverlay:(id<HYPOverlayContainer>)inAppOverlay hypeWindow:(UIWindow *)hypeWindow;

@end
