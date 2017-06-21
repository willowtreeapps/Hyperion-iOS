//
//  HYPAttributeInspectorInteractionView.m
//  WhatIsThatFont
//
//  Created by Chris Mays on 5/2/17.
//  Copyright © 2017 Willow. All rights reserved.
//

#import "HYPAttributeInspectorInteractionView.h"
#import "AttributesTabViewController.h"
#import "HYPPluginExtension.h"

@class UIButtonLabel;

@interface HYPAttributeInspectorInteractionView ()

@property (nonatomic) UIView *currentlySelectedView;
@property (nonatomic) TabView *lastTab;
@property (nonatomic) id<HYPPluginExtension> extension;
@end

@implementation HYPAttributeInspectorInteractionView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];

    [self addGestureRecognizer:tap];

    return self;
}

-(instancetype)init
{
    self = [super init];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];

    [self addGestureRecognizer:tap];

    return self;
}

-(instancetype)initWithPluginExtension:(id<HYPPluginExtension>)extension
{
    self = [super init];

    self.extension = extension;

    return self;
}

-(void)tapGesture:(UITapGestureRecognizer *)tapGesture
{
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];

    CGPoint point = [tapGesture locationInView:self];

    [_highlightView removeFromSuperview];

    _highlightView = [UIView new];
    _highlightView.backgroundColor = [UIColor greenColor];
    _highlightView.alpha = 0.4;
    [self addSubview:_highlightView];


    NSArray<UIView *> *selectedViews = [self findViewsInSubviews:[mainWindow subviews] intersectingPoint:point];

    UIView *selectedView;


    if ([selectedViews containsObject:self.lastSelectedView])
    {
        NSInteger index = [selectedViews indexOfObject:self.lastSelectedView];
        if (index + 1 < [selectedViews count] - 1)
        {
            selectedView = selectedViews[index + 1];
        }
        else
        {
            selectedView = [selectedViews firstObject];
        }
    }
    else
    {
        selectedView = [selectedViews firstObject];
    }

    if ([selectedView isKindOfClass:[NSClassFromString(@"UIButtonLabel") class]])
    {
        selectedView = selectedView.superview;
    }

    self.lastSelectedView = selectedView;

    CGRect viewRect = [selectedView.superview convertRect:selectedView.frame toView:[[UIApplication sharedApplication] keyWindow]];

    _highlightView.frame = viewRect;

    self.currentlySelectedView = selectedView;

    [self.extension.getViewTarget setTargetView:self.currentlySelectedView];
}

-(NSString *)infoForView:(UIView *)view
{
    NSMutableString *infoText = [[NSMutableString alloc] initWithString:@""];

    if ([view isKindOfClass:[UILabel class]])
    {
        UILabel *label = (UILabel *)view;

        [infoText appendString:@"Font Family: "];
        [infoText appendString:label.font.familyName];
        [infoText appendString:@"\n"];

        [infoText appendString:@"Font Name: "];
        [infoText appendString:label.font.fontName];
        [infoText appendString:@"\n"];
    }

    [infoText appendString:@"Superview Frame: "];
    [infoText appendString:[NSString stringWithFormat:@"(x: %f, y: %f, width: %f, height: %f)", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height]];
    [infoText appendString:@"\n"];

    CGRect windowRect = [view.superview convertRect:view.frame toView:[[UIApplication sharedApplication] keyWindow]];
    [infoText appendString:@"Window Frame: "];
    [infoText appendString:[NSString stringWithFormat:@"(x: %f, y: %f, width: %f, height: %f)", windowRect.origin.x, windowRect.origin.y, windowRect.size.width, windowRect.size.height]];
    [infoText appendString:@"\n"];

    return infoText;
}

-(void)printDetailsOfView:(UIView *)view
{
    if ([view isKindOfClass:[UILabel class]])
    {
        NSLog(@"%@", ((UILabel *)view).font.familyName);
        NSLog(@"%@", ((UILabel *)view).font.fontName);
    }
}


-(void)setCurrentlySelectedView:(UIView *)currentlySelectedView
{
    if (self.lastTab)
    {
        [self.datasource removeTab:self.lastTab];
    }

    _currentlySelectedView = currentlySelectedView;

    AttributesTabViewController *vc = [[AttributesTabViewController alloc] initWithSelectedView:currentlySelectedView];
    vc.title = @"View Attributes";

    self.lastTab = [[TabView alloc] initWithTitle:[NSString stringWithFormat:@"%@", [currentlySelectedView class]]];

    [self.datasource addTab:self.lastTab withAssociatedViewController:vc];

}


@end
