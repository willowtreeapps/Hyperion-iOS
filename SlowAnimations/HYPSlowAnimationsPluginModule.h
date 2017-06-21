//
//  HYPSlowAnimationsPluginModule.h
//  Pods
//
//  Created by Christopher Mays on 6/19/17.
//
//

#import <Foundation/Foundation.h>
#import "HYPPluginModule.h"
#import "HYPPluginExtension.h"

@interface HYPSlowAnimationsPluginModule : NSObject <HYPPluginModule>

-(id)initWithPluginExtension:(id<HYPPluginExtension>)extension;

@end
