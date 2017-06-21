//
//  HYPAttributesInspectorModule.m
//  Pods
//
//  Created by Chris Mays on 6/19/17.
//
//

#import "HYPSlowAnimationsPlugin.h"
#import "HYPSlowAnimationsPluginModule.h"

@implementation HYPSlowAnimationsPlugin

-(id<HYPPluginModule>)createPluginModule:(id<HYPPluginExtension>)pluginExtension
{
    return [[HYPSlowAnimationsPluginModule alloc] initWithPluginExtension:pluginExtension];
}

@end
