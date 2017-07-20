//
//  HYPImpeccableAsset.m
//  HyperionCore
//
//  Created by Chris Mays on 6/28/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import "HYPImpeccableAsset.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation HYPImpeccableAsset

-(instancetype)initWithJSONObject:(NSDictionary *)json
{
    self = [super init];

    _assetURL = [NSURL URLWithString:json[@"currentSnapshot"][@"url"]];
    _assetName = json[@"name"];

    CGFloat width = [json[@"currentSnapshot"][@"width"] floatValue];
    CGFloat height = [json[@"currentSnapshot"][@"height"] floatValue];

    _assetDimensions = CGSizeMake(width, height);

    return self;
}

@end
