//
//  SlowAnimationBinaryToolGenerator.m
//  Hyperion
//
//  Created by Chris Mays on 5/3/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import "SlowAnimationBinaryToolGenerator.h"
#import <UIKit/UIKit.h>

@implementation SlowAnimationBinaryToolGenerator

-(instancetype)init
{
    BOOL active = [[UIApplication sharedApplication] keyWindow].layer.speed <= 0.5;
    self = [super initWithTitle:@"Slow Animations" active:active];

    return self;
}

-(void)setActive:(BOOL)active
{
    [super setActive:active];

    [[UIApplication sharedApplication] keyWindow].layer.speed = active ? 0.08 : 1.0;
}
@end
