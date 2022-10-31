//  Copyright (c) 2017 WillowTree, Inc.

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "HYPPluginHelper.h"

@implementation HYPPluginHelper

+(NSMutableArray<UIView *> *)findSubviewsInView:(UIView *)view intersectingPoint:(CGPoint)point
{
    NSMutableArray<UIView *> *potentialSelectionViews = [[NSMutableArray alloc] init];
    NSArray *subviews = [view subviews];
    NSSet *blackList = [self blacklistedViews];

    for (UIView *subView in [subviews reverseObjectEnumerator])
    {
        if (subView.alpha > 0 && !subView.hidden)
        {
            [potentialSelectionViews addObjectsFromArray:[self findSubviewsInView:subView intersectingPoint:point]];

            if ([self view:subView surrondsPoint:point] && ![blackList containsObject:NSStringFromClass([subView class])])
            {
                [potentialSelectionViews addObject:subView];
            }
        }
    }

    return potentialSelectionViews;
}

+(BOOL)view:(UIView *)view surrondsPoint:(CGPoint)point
{
    CGRect viewRect = [view.superview convertRect:view.frame toView:[[UIApplication sharedApplication] keyWindow]];

    return  viewRect.origin.x <= point.x && (viewRect.size.width + viewRect.origin.x) >= point.x &&
    viewRect.origin.y <= point.y && (viewRect.size.height + viewRect.origin.y) >= point.y;
}

/**
 *  This returns a list of views that we do not want to show up as selectable views.
 *  Reference: https://github.com/willowtreeapps/Hyperion-iOS/issues/31
 */
+(NSSet *)blacklistedViews
{
    NSMutableSet *blackListedViews = [[NSMutableSet alloc] initWithArray:@[@"_UINavigationControllerPaletteClippingView"]];

    return blackListedViews;
}

@end
