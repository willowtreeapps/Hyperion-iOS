//
//  InteractionViewDelegate.h
//  WhatIsThatFont
//
//  Created by Chris Mays on 5/2/17.
//  Copyright © 2017 Willow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TabView.h"

@protocol InteractionViewDatasource <NSObject>

-(void)addTab:(TabView *)tab withAssociatedViewController:(UIViewController *)vc;
-(void)removeTab:(TabView *)tab;

@end
