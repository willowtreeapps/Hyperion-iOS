//
//  HYPVisualLoggerPlugin.m
//  HyperionCore
//
//  Created by Chris Mays on 6/26/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import "HYPVisualLoggerPlugin.h"
#import "HYPVisualLoggerPluginModule.h"
@implementation HYPVisualLoggerPlugin

-(id<HYPPluginModule>)createPluginModule:(id<HYPPluginExtension>)pluginExtension
{
    return [[HYPVisualLoggerPluginModule alloc] initWithPluginExtension:pluginExtension];
}

@end
