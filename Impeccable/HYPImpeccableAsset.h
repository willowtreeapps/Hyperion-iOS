//
//  HYPImpeccableAsset.h
//  HyperionCore
//
//  Created by Chris Mays on 6/28/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface HYPImpeccableAsset : NSObject
-(instancetype)initWithJSONObject:(NSDictionary *)json;

@property (nonatomic, readonly) NSString *assetName;
@property (nonatomic, readonly) NSURL *assetURL;
@property (nonatomic, readonly) CGSize assetDimensions;

@end
