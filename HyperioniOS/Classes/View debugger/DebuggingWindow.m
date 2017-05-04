//
//  DebuggingWindow.m
//  WhatIsThatFont
//
//  Created by Chris Mays on 5/2/17.
//  Copyright © 2017 Willow. All rights reserved.
//

#import "DebuggingWindow.h"
#import "TabStack.h"
#import "TabView.h"
#import "AttributeInspectorInteractionView.h"
#import "ToolsTabViewController.h"

@interface TabViewTuple : NSObject

@property (nonatomic) TabView *tab;
@property (nonatomic) UIViewController *viewController;

@end

@implementation TabViewTuple


@end

@interface DebuggingWindow() <UIGestureRecognizerDelegate, InteractionViewDatasource, TabStackDelegate, ToolsTabViewControllerDelegate>

@property (nonatomic) TabStack *tabStack;
@property (nonatomic) UINavigationController *menuContainer;
@property (nonatomic) NSLayoutConstraint *menuTrailingConstraint;
@property (nonatomic) NSMutableArray<TabViewTuple *> *menuTabTuples;
@property (nonatomic) InteractionView *currentInteractionView;

@end

@implementation DebuggingWindow

const CGFloat MenuWidth = 300;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    [self setup];

    return self;
}

-(instancetype)init
{
    self = [super init];

    [self setup];

    return self;
}

-(void)setup
{
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];

    UIPanGestureRecognizer *deactivatePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];

    [self addGestureRecognizer:deactivatePanGesture];

    [self setRootViewController:[[UIViewController alloc] init]];
    self.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
}

-(void)setRootViewController:(UIViewController *)rootViewController
{
    [super setRootViewController:rootViewController];


    self.menuTabTuples = [[NSMutableArray alloc] init];

    self.currentInteractionView = [[AttributeInspectorInteractionView alloc] initWithFrame:CGRectZero];
    self.currentInteractionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.rootViewController.view  addSubview:self.currentInteractionView];

    [self.currentInteractionView.leadingAnchor constraintEqualToAnchor:self.rootViewController.view.leadingAnchor].active = true;
    [self.currentInteractionView.trailingAnchor constraintEqualToAnchor:self.rootViewController.view.trailingAnchor].active = true;
    [self.currentInteractionView.topAnchor constraintEqualToAnchor:self.rootViewController.view.topAnchor].active = true;
    [self.currentInteractionView.bottomAnchor constraintEqualToAnchor:self.rootViewController.view.bottomAnchor].active = true;

    self.currentInteractionView.datasource = self;

    self.tabStack = [[TabStack alloc] initWithTabs:@[]];

    _menuContainer = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
    _menuContainer.view.translatesAutoresizingMaskIntoConstraints = NO;

    [self.rootViewController addChildViewController:_menuContainer];

    [self.rootViewController.view addSubview:_menuContainer.view];
    [self.rootViewController.view addSubview:self.tabStack];

    [_menuContainer.view.topAnchor constraintEqualToAnchor:self.rootViewController.view.topAnchor].active = YES;
    [_menuContainer.view.bottomAnchor constraintEqualToAnchor:self.rootViewController.view.bottomAnchor].active = YES;
    [_menuContainer.view.leadingAnchor constraintEqualToAnchor:self.tabStack.trailingAnchor].active = YES;
    [_menuContainer.view.widthAnchor constraintEqualToConstant:MenuWidth].active = YES;


    self.tabStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.tabStack.delegate = self;

    self.menuTrailingConstraint = [self.tabStack.trailingAnchor constraintEqualToAnchor:self.rootViewController.view.trailingAnchor];
    self.menuTrailingConstraint.active = YES;
    [self.tabStack.bottomAnchor constraintEqualToAnchor:self.rootViewController.view.bottomAnchor].active = YES;

    [self addToolsTab];

}

-(void)addToolsTab
{
    TabView *tab = [[TabView alloc] init];

    tab.translatesAutoresizingMaskIntoConstraints = NO;

    tab.backgroundColor = [UIColor redColor];

    ToolsTabViewController *toolsTab = [[ToolsTabViewController alloc] init];
    toolsTab.delegate = self;
    TabViewTuple *tuple = [[TabViewTuple alloc] init];
    tuple.tab = tab;
    tuple.viewController = toolsTab;
    [tuple.viewController.view setBackgroundColor:[UIColor redColor]];

    [self.menuTabTuples addObject:tuple];

    [self.tabStack addTab:tab];

}

-(void)addTab:(TabView *)tab withAssociatedViewController:(UIViewController *)vc
{

    TabViewTuple *tuple = [[TabViewTuple alloc] init];
    tuple.tab = tab;
    tuple.viewController = vc;

    [self.menuTabTuples addObject:tuple];

    [self.tabStack addTab:tab];
}

-(void)removeTab:(TabView *)tab
{
    for (TabViewTuple *tuple in self.menuTabTuples)
    {
        if (tuple.tab == tab)
        {
            [self.menuTabTuples removeObject:tuple];
        }
    }

    [self.tabStack removeTab:tab];
}

-(void)pan:(UIPanGestureRecognizer *)recognizer
{

    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        _start = [recognizer locationInView:[[UIApplication sharedApplication] keyWindow]];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        _end = [recognizer locationInView:[[UIApplication sharedApplication] keyWindow]];

        if (_start.x < 50 && _end.x > [[UIApplication sharedApplication] keyWindow].frame.size.width - 50 && _start.y < 100 && _end.y > [[UIApplication sharedApplication] keyWindow].frame.size.height - 70)
        {
            [self activateDebugMenu];
        }
    }
}

-(void)activateDebugMenu
{
    self.hidden = !self.hidden;
}


#pragma mark - TabStackDelegate

-(void)tabViewDidBecomActive:(TabView *)tab
{
    [UIView animateWithDuration:0.3 animations:^{
        self.menuContainer.viewControllers = @[[self viewControllerForTab:tab]];
        self.menuTrailingConstraint.constant = self.menuTrailingConstraint.constant == 0 ? -MenuWidth : 0;
        [self layoutIfNeeded];
    }];
}
-(void)tabViewDidBecomInActive:(TabView *)tab
{

}

-(UIViewController *)viewControllerForTab:(TabView *)tab
{

    for (TabViewTuple *tuple in self.menuTabTuples)
    {
        if (tuple.tab == tab)
        {
            return tuple.viewController;
        }
    }

    return nil;
}

-(void)toolSelectedWithInteractionView:(InteractionView *)view
{
    //HACK: Figure out better architecture for this...
    if ([view isKindOfClass:[AttributeInspectorInteractionView class]])
    {
        ((AttributeInspectorInteractionView *) view).datasource = self;
    }

    [UIView animateWithDuration:0.3 animations:^{
        self.menuTrailingConstraint.constant = 0;
    }];

    [self.currentInteractionView removeFromSuperview];

    self.currentInteractionView = view;

    self.currentInteractionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.rootViewController.view  addSubview:self.currentInteractionView];

    [self.currentInteractionView.leadingAnchor constraintEqualToAnchor:self.rootViewController.view.leadingAnchor].active = true;
    [self.currentInteractionView.trailingAnchor constraintEqualToAnchor:self.rootViewController.view.trailingAnchor].active = true;
    [self.currentInteractionView.topAnchor constraintEqualToAnchor:self.rootViewController.view.topAnchor].active = true;
    [self.currentInteractionView.bottomAnchor constraintEqualToAnchor:self.rootViewController.view.bottomAnchor].active = true;

    [self.rootViewController.view addSubview:self.currentInteractionView];

    [self.rootViewController.view bringSubviewToFront:self.menuContainer.view];
    [self.rootViewController.view bringSubviewToFront:self.tabStack];

}

@end
