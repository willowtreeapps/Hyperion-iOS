//
//  TabView.m
//  WhatIsThatFont
//
//  Created by Chris Mays on 5/2/17.
//  Copyright © 2017 Willow. All rights reserved.
//

#import "TabView.h"

@interface TabView()

@end

@implementation TabView

-(instancetype)init
{
    self = [super init];

    self.translatesAutoresizingMaskIntoConstraints = NO;

    [self.widthAnchor constraintEqualToConstant:30].active = YES;
    [self.heightAnchor constraintEqualToConstant:60].active = YES;

    self.backgroundColor = [UIColor blueColor];

    return self;
}

@end
