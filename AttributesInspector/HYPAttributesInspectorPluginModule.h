//
//  HYPAttributesInspectorPluginModule.h
//  Pods
//
//  Created by Chris Mays on 6/19/17.
//
//

#import <Foundation/Foundation.h>
#import "HYPPluginModule.h"
#import "HYPPluginExtension.h"

@interface HYPAttributesInspectorPluginModule : NSObject<HYPPluginModule>

-(instancetype)initWithPluginExtension:(id<HYPPluginExtension>)extension;

@end
