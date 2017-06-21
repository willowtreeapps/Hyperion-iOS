//
//  InteractionView.m
//  WhatIsThatFont
//
//  Created by Chris Mays on 5/2/17.
//  Copyright © 2017 Willow. All rights reserved.
//

#import "InteractionView.h"

@implementation InteractionView

-(NSMutableArray<UIView *> *)findViewsInSubviews:(NSArray *)subviews intersectingPoint:(CGPoint)point
{
    NSMutableArray<UIView *> *potentialSelectionViews = [[NSMutableArray alloc] init];
    for (UIView *subView in [subviews reverseObjectEnumerator])
    {
        [potentialSelectionViews addObjectsFromArray:[self findViewsInSubviews:[subView subviews] intersectingPoint:point]];

        if ([self view:subView surrondsPoint:point])
        {
            [potentialSelectionViews addObject:subView];
        }
    }

    return potentialSelectionViews;
}

-(BOOL)view:(UIView *)view surrondsPoint:(CGPoint)point
{

    CGRect viewRect = [view.superview convertRect:view.frame toView:[[UIApplication sharedApplication] keyWindow]];

    return  viewRect.origin.x <= point.x && (viewRect.size.width + viewRect.origin.x) >= point.x &&
    viewRect.origin.y <= point.y && (viewRect.size.height + viewRect.origin.y) >= point.y;
}

@end
