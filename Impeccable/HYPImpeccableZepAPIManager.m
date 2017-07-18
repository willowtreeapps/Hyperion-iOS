//
//  HYPImpeccableZepAPIManager.m
//  HyperionCore
//
//  Created by Chris Mays on 6/28/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import "HYPImpeccableZepAPIManager.h"
#import "HYPImpeccableAsset.h"
#import "HYPImpeccableAsset.h"

@implementation HYPImpeccableZepAPIManager

-(void)getWithURL:(NSURL *)url withSize:(CGSize)size Assets:(void (^)(NSArray<HYPImpeccableAsset *> *assets))completion
{
    url = [NSURL URLWithString:@"[URL HERE]"];
    NSURLSession *session = [NSURLSession sharedSession];

    NSMutableURLRequest *assetsRequest = [[NSMutableURLRequest alloc] initWithURL:url];

    [assetsRequest setValue:@"[Token HERE]" forHTTPHeaderField:@"Zeplin-Token"];
    [assetsRequest setValue:@"[Socket ID HERE]" forHTTPHeaderField:@"Zeplin-Socket-Id"];
    [assetsRequest setValue:@"Zeplin/1.17.2 (Mac OS X Version 10.12.5 (Build 16F73))" forHTTPHeaderField:@"User-Agent"];
    [assetsRequest setValue:@"en-US;q=1" forHTTPHeaderField:@"Accept-Language"];

    [[session dataTaskWithRequest:assetsRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSDictionary *serialization = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *screens = serialization[@"screens"];
        NSMutableArray *allScreens = [[NSMutableArray alloc] init];
        for (NSDictionary *screen in screens)
        {
            HYPImpeccableAsset *asset = [[HYPImpeccableAsset alloc] initWithJSONObject:screen];
            [allScreens addObject:asset];
        }

        NSMutableArray<HYPImpeccableAsset *> *eligibleScreens = [[NSMutableArray<HYPImpeccableAsset *> alloc] init];

        for (HYPImpeccableAsset *asset in allScreens)
        {
            if (asset.assetDimensions.width == size.width)
            {
                [eligibleScreens addObject:asset];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(eligibleScreens);
        });

    }] resume];
}

@end
