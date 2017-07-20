//
//  HYPPlugin.h
//  Pods
//
//  Created by Chris Mays on 6/19/17.
//
//

#import <Foundation/Foundation.h>
#import "HYPPluginModule.h"
#import "HYPPluginExtension.h"

@protocol HYPPlugin <NSObject>

-(nonnull id<HYPPluginModule>)createPluginModule:(_Nonnull id<HYPPluginExtension>)pluginExtension;

@end
