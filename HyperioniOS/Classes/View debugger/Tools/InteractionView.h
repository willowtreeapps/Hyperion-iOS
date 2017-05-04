//
//  InteractionView.h
//  WhatIsThatFont
//
//  Created by Chris Mays on 5/2/17.
//  Copyright © 2017 Willow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InteractionViewDatasource.h"

@interface InteractionView : UIView

@property (nonatomic, weak) id<InteractionViewDatasource> datasource;

-(NSMutableArray<UIView *> *)findViewsInSubviews:(NSArray *)subviews intersectingPoint:(CGPoint)point;
-(BOOL)view:(UIView *)view surrondsPoint:(CGPoint)point;

@end
