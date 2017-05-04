//
//  TabStack.h
//  WhatIsThatFont
//
//  Created by Chris Mays on 5/2/17.
//  Copyright © 2017 Willow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabView;

@protocol TabStackDelegate <NSObject>

-(void)tabViewDidBecomActive:(TabView *)tab;
-(void)tabViewDidBecomInActive:(TabView *)tab;

@end

@interface TabStack : UIView

- (instancetype)initWithTabs:(NSArray<TabView *> *)tabs;

-(void)addTab:(TabView *)tab;

-(void)removeTab:(TabView *)tab;

@property (nonatomic, readonly) NSArray<TabView *> *tabs;

@property (nonatomic, weak) id<TabStackDelegate> delegate;

@end
