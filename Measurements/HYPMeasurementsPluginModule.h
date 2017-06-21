//
//  HYPMeasurementsPluginModule.h
//  Pods
//
//  Created by Christopher Mays on 6/20/17.
//
//

#import <Foundation/Foundation.h>
#import "HYPPluginModule.h"
#import "HYPPluginExtension.h"

@interface HYPMeasurementsPluginModule : NSObject<HYPPluginModule>

-(instancetype)initWithPluginExtension:(id<HYPPluginExtension>)extension;

@end
