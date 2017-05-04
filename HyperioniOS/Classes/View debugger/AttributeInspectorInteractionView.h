//
//  AttributeInspectorInteractionView.h
//  WhatIsThatFont
//
//  Created by Chris Mays on 5/2/17.
//  Copyright © 2017 Willow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InteractionView.h"

@interface AttributeInspectorInteractionView : InteractionView

@property (nonatomic) UIView *highlightView;
@property (nonatomic) UIView *lastSelectedView;

@end
