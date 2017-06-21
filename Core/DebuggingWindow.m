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
#import "ToolsTabViewController.h"
#import "HYPPluginExtension.h"
#import "HYPPluginExtensionImp.h"
#import "HYPPlugin.h"
#import "HYPAttributesInspectorPlugin.h"
#import "HYPOverlayContainerImp.h"

@interface TabViewTuple : NSObject

@property (nonatomic) TabView *tab;
@property (nonatomic) UIViewController *viewController;

@end

@implementation TabViewTuple

@end

@interface DebuggingWindow() <UIGestureRecognizerDelegate, TabStackDelegate, ToolsTabViewControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>

@property (nonatomic) TabStack *tabStack;
@property (nonatomic) UINavigationController *menuContainer;
@property (nonatomic) NSLayoutConstraint *menuTrailingConstraint;
@property (nonatomic) NSLayoutConstraint *menuWidthConstraint;
@property (nonatomic) NSMutableArray<TabViewTuple *> *menuTabTuples;
@property (nonatomic) InteractionView *currentInteractionView;
@property (nonatomic) TabViewTuple *toolsTuple;;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) HYPOverlayContainerImp *scrollViewContainer;
@property (nonatomic) UIView *currentSnapshotView;

@property (nonatomic) id<HYPPluginExtension> pluginExtension;

@property (nonatomic) NSArray<id<HYPPluginModule>> *pluginModules;
@property (nonatomic) NSArray<UITableViewCell *> *pluginViews;
@property (nonatomic) ToolsTabViewController *toolsTabViewController;

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
    self.panGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.panGesture setEdges:UIRectEdgeRight];

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

    self.scrollView = [[UIScrollView alloc] init];
    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.rootViewController.view addSubview: self.scrollView];
    [self.scrollView.leadingAnchor constraintEqualToAnchor:self.rootViewController.view.leadingAnchor].active = YES;
    [self.scrollView.trailingAnchor constraintEqualToAnchor:self.rootViewController.view.trailingAnchor].active = YES;
    [self.scrollView.topAnchor constraintEqualToAnchor:self.rootViewController.view.topAnchor].active = YES;
    [self.scrollView.bottomAnchor constraintEqualToAnchor:self.rootViewController.view.bottomAnchor].active = YES;

    self.scrollView.backgroundColor = [UIColor blackColor];

    self.scrollViewContainer = [[HYPOverlayContainerImp alloc] initWithFrame:self.frame];

    self.scrollViewContainer.backgroundColor = [UIColor whiteColor];

    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollView.heightAnchor constraintEqualToConstant:self.frame.size.height].active = YES;
    [self.scrollView.widthAnchor constraintEqualToConstant:self.frame.size.width].active = YES;
    [self.scrollView.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor].active = YES;
    [self.scrollView.centerYAnchor constraintEqualToAnchor:self.scrollView.centerYAnchor].active = YES;


    self.scrollView.minimumZoomScale = 0.0;
    self.scrollView.maximumZoomScale = 10.0;

    [self.scrollView setZoomScale:0.2];
    self.scrollView.delegate = self;

    [self takeSnapshot];




    self.tabStack = [[TabStack alloc] initWithTabs:@[]];

    _menuContainer = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
    _menuContainer.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.menuContainer.delegate = self;
    [self.rootViewController addChildViewController:_menuContainer];

    [self.rootViewController.view addSubview:_menuContainer.view];
    [self.rootViewController.view addSubview:self.tabStack];

    [_menuContainer.view.topAnchor constraintEqualToAnchor:self.rootViewController.view.topAnchor].active = YES;
    [_menuContainer.view.bottomAnchor constraintEqualToAnchor:self.rootViewController.view.bottomAnchor].active = YES;
    [_menuContainer.view.leadingAnchor constraintEqualToAnchor:self.tabStack.trailingAnchor].active = YES;
    _menuWidthConstraint = [_menuContainer.view.widthAnchor constraintEqualToConstant:MenuWidth];
    _menuWidthConstraint.active = YES;


    self.tabStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.tabStack.delegate = self;

    self.menuTrailingConstraint = [self.tabStack.trailingAnchor constraintEqualToAnchor:self.rootViewController.view.trailingAnchor];
    self.menuTrailingConstraint.active = YES;
    [self.tabStack.bottomAnchor constraintEqualToAnchor:self.rootViewController.view.bottomAnchor].active = YES;

    [self addToolsTab];

    self.pluginExtension = [[HYPPluginExtensionImp alloc] initWithOverlayContainer:self.scrollViewContainer hypeWindow:self];

    [self initializePlugins];
}

-(void)initializePlugins
{
    NSMutableArray<id<HYPPluginModule>> *mutablePluginModules = [[NSMutableArray alloc] init];
    NSMutableArray<UITableViewCell *> *mutablePluginViews = [[NSMutableArray alloc] init];


    NSArray *plugins = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HyperionDependencies" ofType:@"plist"]];
    
    //Fallback to internal list
    if (!plugins)
    {
        plugins = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HyperionDependencies-Internal" ofType:@"plist"]];
    }
    
    NSMutableArray *pluginClasses = [[NSMutableArray alloc] init];
    
    for (NSString *pluginStrings in plugins)
    {
        Class pluginClass = NSClassFromString(pluginStrings);
        if (pluginClass)
        {
            [pluginClasses addObject:pluginClass];
        }
        else
        {
            NSLog(@"Failed to load class: %@", pluginStrings);
        }
    }
    
    
    for (Class pluginClass in pluginClasses)
    {
        id<HYPPlugin> plugin = [[pluginClass alloc] init];

        if ([plugin conformsToProtocol:@protocol(HYPPlugin)])
        {
            id <HYPPluginModule> module = [plugin createPluginModule:self.pluginExtension];
            [mutablePluginModules addObject:module];
            [mutablePluginViews addObject:[module createPluginView]];
        }
        else
        {
            NSLog(@"The class %@, fails to conform to HYPPlugin", pluginClass);
        }
    }

    self.pluginModules = mutablePluginModules;
    self.pluginViews = mutablePluginViews;

    self.toolsTabViewController.customTools = self.pluginViews;
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.scrollViewContainer;
}

-(void)takeSnapshot
{
    [self.currentSnapshotView removeFromSuperview];

    self.currentSnapshotView = [[[UIApplication sharedApplication] keyWindow] snapshotViewAfterScreenUpdates:NO];
    self.currentSnapshotView.frame = self.bounds;
    [self.currentSnapshotView setClipsToBounds:YES];
    [self.scrollViewContainer setSnapshotView:self.currentSnapshotView];

    [self performSelector:@selector(takeSnapshot) withObject:nil afterDelay:1.0];
}

-(void)addToolsTab
{
    TabView *tab = [[TabView alloc] initWithTitle:@"Tools"];

    tab.translatesAutoresizingMaskIntoConstraints = NO;

    ToolsTabViewController *toolsTab = [[ToolsTabViewController alloc] init];
    toolsTab.delegate = self;

    TabViewTuple *tuple = [[TabViewTuple alloc] init];
    tuple.tab = tab;
    tuple.viewController = toolsTab;
    [tuple.viewController.view setBackgroundColor:[UIColor redColor]];

    [self.menuTabTuples addObject:tuple];

    [self.tabStack addTab:tab];

    self.toolsTuple = tuple;

    self.toolsTabViewController = toolsTab;

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
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        [self activateDebugMenu];
    }

}

-(void)activateDebugMenu
{
    self.hidden = !self.hidden;

    [self removeExtraTabs];
}


#pragma mark - TabStackDelegate

-(void)tabViewDidBecomActive:(TabView *)tab
{
    self.menuContainer.viewControllers = @[[self viewControllerForTab:tab]];
    [self layoutIfNeeded];

    [UIView animateWithDuration:0.3 animations:^{
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

//-(void)toolSelectedWithInteractionView:(InteractionView *)view
//{
//    view.datasource = self;
//
//    [self removeExtraTabs];
//
//    [UIView animateWithDuration:0.3 animations:^{
//        self.menuTrailingConstraint.constant = 0;
//        [self layoutIfNeeded];
//    }];
//
//    [self.currentInteractionView removeFromSuperview];
//
//    self.currentInteractionView = view;
//    [self.scrollViewContainer  addSubview:self.currentInteractionView];
//    self.currentInteractionView.frame = self.currentSnapshotView.frame;
//}

-(void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    if (!hidden)
    {
        [self.scrollView setZoomScale:1.0];
        [self.scrollView setZoomScale:0.9 animated:YES];
    }
}

-(void)removeExtraTabs
{
    for (TabView *tab in self.tabStack.tabs)
    {
        if (tab != self.toolsTuple.tab)
        {
            [self.tabStack removeTab:tab];
        }
    }
}

@end
