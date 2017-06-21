//
//  HYPMeasurementsPlugin.m
//  Pods
//
//  Created by Christopher Mays on 6/20/17.
//
//

#import "HYPMeasurementsPlugin.h"
#import "HYPPluginModule.h"
#import "HYPMeasurementsPluginModule.h"
@implementation HYPMeasurementsPlugin

-(id<HYPPluginModule>)createPluginModule:(id<HYPPluginExtension>)pluginExtension
{
    return [[HYPMeasurementsPluginModule alloc] initWithPluginExtension:pluginExtension];
}

@end
