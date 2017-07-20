//
//  HYPImpeccableZepAPIManager.h
//  HyperionCore
//
//  Created by Chris Mays on 6/28/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "HYPImpeccableAsset.h"

@interface HYPImpeccableZepAPIManager : NSObject

-(void)getWithURL:(NSURL *)url withSize:(CGSize)size Assets:(void (^)(NSArray<HYPImpeccableAsset *> *assets))completion;

@end
