//
//  TabStack.m
//  WhatIsThatFont
//
//  Created by Chris Mays on 5/2/17.
//  Copyright © 2017 Willow. All rights reserved.
//

#import "TabStack.h"
#import "TabView.h"

@interface TabStack ()

@property (nonatomic) UIStackView *stackView;
@property (nonatomic) NSMutableArray<TabView *> *mutableTabs;
@end

@implementation TabStack

- (instancetype)initWithTabs:(NSArray<TabView *> *)tabs
{
    self = [super init];

    _stackView = [[UIStackView alloc] init];
    _stackView.axis = UILayoutConstraintAxisVertical;
    _stackView.spacing= -15;
    _stackView.translatesAutoresizingMaskIntoConstraints = NO;

    self.mutableTabs = [[NSMutableArray alloc] init];

    [self addSubview:_stackView];

    [_stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [_stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [_stackView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [_stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;

    for (TabView *tab in tabs) {
        [self addTab:tab];
    }

    return self;
}

-(void)addTab:(TabView *)tab
{
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabSelected:)];

    [tab addGestureRecognizer:recognizer];

    [self.mutableTabs addObject:tab];

    [_stackView addArrangedSubview:tab];
}

-(void)removeTab:(TabView *)tab
{
    //TODO: Remove gesture recognized;

    [self.mutableTabs removeObject:tab];

    if ([tab superview] == self.stackView)
    {
        [tab removeFromSuperview];
    }
}

-(void)tabSelected:(UITapGestureRecognizer *)tap
{
    TabView *selectedTab = (TabView *)tap.view;
    selectedTab.layer.zPosition = 10000;

    for (TabView *tab in _mutableTabs)
    {
        tab.layer.zPosition = 9999;

        if (tab == selectedTab)
        {
            tab.layer.zPosition = 10000;
        }
    }
    [self.delegate tabViewDidBecomActive:selectedTab];
}

-(NSArray<TabView *> *)tabs
{
    return _mutableTabs;
}

@end
