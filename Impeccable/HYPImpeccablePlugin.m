//
//  HYPImpeccablePlugin.m
//  HyperionCore
//
//  Created by Chris Mays on 6/28/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import "HYPImpeccablePlugin.h"
#import "HYPImpeccablePluginModule.h"

@implementation HYPImpeccablePlugin

-(id<HYPPluginModule>)createPluginModule:(id<HYPPluginExtension>)pluginExtension
{
    return [[HYPImpeccablePluginModule alloc] initWithPluginExtension:pluginExtension];
}

@end
