//
//  HYPMaskDetailViewAttribute.m
//  Pods
//
//  Created by Chris Mays on 5/10/17.
//
//

#import "HYPMaskDetailViewAttribute.h"
#import "HYPMaskDetailViewController.h"

@implementation HYPMaskDetailViewAttribute

-(instancetype)initWithMaskedView:(UIView *)maskedView
{
    self = [super initWithKey:@"Mask" value:@"Tap to View" selectedView:maskedView];

    return self;
}

-(UIViewController *)generateDetailViewController
{
    HYPMaskDetailViewController *maskVC = [[HYPMaskDetailViewController alloc] initWithMaskedView:self.selectedView];

    return maskVC;
}

@end
