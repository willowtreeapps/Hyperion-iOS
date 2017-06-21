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

-(id<HYPPluginModule>)createPluginModule:(id<HYPPluginExtension>)pluginExtension;

@end
