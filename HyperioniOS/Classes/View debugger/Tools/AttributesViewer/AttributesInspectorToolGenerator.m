//
//  AttributesInspectorToolGenerator.m
//  Hyperion
//
//  Created by Chris Mays on 5/3/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import "AttributesInspectorToolGenerator.h"
#import "InteractionView.h"
#import "AttributeInspectorInteractionView.h"

@implementation AttributesInspectorToolGenerator

-(instancetype)init
{
    self = [super initWithTitle:@"Attributes Inspector"];

    return self;
}

-(InteractionView *)generateInteractionView
{
    AttributeInspectorInteractionView *view = [[AttributeInspectorInteractionView alloc] init];

    view.backgroundColor = [UIColor clearColor];

    return view;

}

@end
