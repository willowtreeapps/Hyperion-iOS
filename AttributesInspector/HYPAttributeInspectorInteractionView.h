//
//  HYPAttributeInspectorInteractionView.h
//  WhatIsThatFont
//
//  Created by Chris Mays on 5/2/17.
//  Copyright © 2017 Willow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InteractionView.h"
#import "HYPPluginExtension.h"

@interface HYPAttributeInspectorInteractionView : InteractionView

@property (nonatomic) UIView *highlightView;
@property (nonatomic) UIView *lastSelectedView;

-(instancetype)initWithPluginExtension:(id<HYPPluginExtension>)extension;

@end
