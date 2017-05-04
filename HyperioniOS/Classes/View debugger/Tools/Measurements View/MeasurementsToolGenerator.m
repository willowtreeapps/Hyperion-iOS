//
//  MeasurementsToolGenerator.m
//  Hyperion
//
//  Created by Chris Mays on 5/3/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import "MeasurementsToolGenerator.h"
#import "MeasurementsInteractionView.h"

@implementation MeasurementsToolGenerator

-(instancetype)init
{
    self = [super initWithTitle:@"View Measurements"];

    return self;
}

-(InteractionView *)generateInteractionView
{
    MeasurementsInteractionView *view = [[MeasurementsInteractionView alloc] init];

    view.backgroundColor = [UIColor clearColor];

    return view;
    
}

@end
