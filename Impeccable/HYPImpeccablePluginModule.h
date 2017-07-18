//
//  HYPImpeccablePluginModule.h
//  HyperionCore
//
//  Created by Chris Mays on 6/28/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYPPluginExtension.h"
#import "HYPPluginModule.h"

@interface HYPImpeccablePluginModule : NSObject <HYPPluginModule, HYPOverlayViewProvider>

-(instancetype)initWithPluginExtension:(id<HYPPluginExtension>)extension;

@end
