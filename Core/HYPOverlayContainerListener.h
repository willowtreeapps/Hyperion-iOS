//
//  HYPOverlayContainerListener.h
//  Pods
//
//  Created by Chris Mays on 6/19/17.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol HYPPluginModule;
@protocol HYPOverlayViewProvider;

@protocol HYPOverlayContainerListener <NSObject>

-(void)overlayModuleChanged:(id<HYPPluginModule, HYPOverlayViewProvider>)overlayProvider;

@end
