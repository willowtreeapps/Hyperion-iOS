//
//  BinaryToolGenerator.h
//  Hyperion
//
//  Created by Chris Mays on 5/3/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import "ToolGenerator.h"
#import "BinaryToolGenerator.h"

@interface BinaryToolGenerator : ToolGenerator

-(instancetype)initWithTitle:(NSString *)title active:(BOOL)active;

@property (nonatomic, getter=isActive) BOOL active;

@end
