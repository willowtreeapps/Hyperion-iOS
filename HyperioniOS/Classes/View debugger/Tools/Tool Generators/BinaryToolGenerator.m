//
//  BinaryToolGenerator.m
//  Hyperion
//
//  Created by Chris Mays on 5/3/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import "BinaryToolGenerator.h"

@interface BinaryToolGenerator ()

//@property (nonatomic) UISwitch;

@end

@implementation BinaryToolGenerator

-(instancetype)initWithTitle:(NSString *)title active:(BOOL)active
{
    self = [super initWithTitle:title];

    _active = active;

    return self;
}

@end
