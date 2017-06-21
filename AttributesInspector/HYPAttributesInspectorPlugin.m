//
//  HYPAttributesInspectorModule.m
//  Pods
//
//  Created by Chris Mays on 6/19/17.
//
//

#import "HYPAttributesInspectorPlugin.h"
#import "HYPAttributesInspectorPluginModule.h"

@implementation HYPAttributesInspectorPlugin

-(id<HYPPluginModule>)createPluginModule:(id<HYPPluginExtension>)pluginExtension
{
    return [[HYPAttributesInspectorPluginModule alloc] initWithPluginExtension:pluginExtension];
}

@end
