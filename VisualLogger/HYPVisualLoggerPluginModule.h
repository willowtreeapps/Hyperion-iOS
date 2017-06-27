//
//  HYPVisualLoggerPluginModule.h
//  HyperionCore
//
//  Created by Chris Mays on 6/26/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYPPluginModule.h"

@interface HYPVisualLoggerPluginModule : NSObject<HYPPluginModule, HYPOverlayViewProvider>

-(instancetype)initWithPluginExtension:(id<HYPPluginExtension>)extension;

@end
