//
//  HYPAttributesInspectorPluginModule.m
//  Pods
//
//  Created by Chris Mays on 6/19/17.
//
//

#import "HYPAttributesInspectorPluginModule.h"
#import "HYPAttributeInspectorInteractionView.h"
#import "HYPOverlayContainerListener.h"
#import "AttributesTabViewController.h"

@interface HYPAttributesInspectorPluginModule () <HYPOverlayContainerListener, HYPTargetViewListener>

@property (nonatomic) id<HYPPluginExtension> extension;
@property (nonatomic) UINavigationController *attributesNavigation;
@property (nonatomic) BOOL active;
@property (nonatomic) NSLayoutConstraint *attributesNavigationFromBottomConstraint;

@property (nonatomic) BOOL inspectionWindowOpen;

@end

@implementation HYPAttributesInspectorPluginModule

@synthesize pluginView = _pluginView;

const CGFloat InspectorHeight = 350;

-(id)initWithPluginExtension:(id<HYPPluginExtension>)extension
{
    self = [super init];

    _extension = extension;

    [_extension.overlayContainer addContainerListener:self];
    [_extension.getViewTarget addTargetViewListener:self];

    return self;
}

-(UITableViewCell *)pluginView
{
    if (_pluginView)
    {
        return _pluginView;
    }

    UITableViewCell *tableViewCell = [[UITableViewCell alloc] init];

    tableViewCell.textLabel.text = @"Attributes Inspector";

    _pluginView = tableViewCell;

    return  tableViewCell;
}

-(void)navigationTap:(UITapGestureRecognizer *)pan
{
    if (self.attributesNavigationFromBottomConstraint.constant == -50)
    {
        self.attributesNavigationFromBottomConstraint.constant = -InspectorHeight;
    }
    else
    {
        self.attributesNavigationFromBottomConstraint.constant = -50;
    }
    
    UIView *rootView = self.extension.hypeWindow.rootViewController.view;
    [UIView animateWithDuration:0.3 animations:^{
        [rootView layoutIfNeeded];
    }];
    
}
-(void)navigationPan:(UIPanGestureRecognizer *)pan
{
    UIView *rootView = self.extension.hypeWindow.rootViewController.view;

    CGPoint point = [pan locationInView:rootView];

    self.attributesNavigationFromBottomConstraint.constant = point.y - rootView.frame.size.height;

    if (pan.state == UIGestureRecognizerStateEnded)
    {
        CGFloat val = 0;

        CGFloat inspectionWindowOpenThreshold = self.inspectionWindowOpen ? -(InspectorHeight * 3/4) : -(InspectorHeight * 1/4);

        if((point.y - rootView.frame.size.height) < inspectionWindowOpenThreshold)
        {
            val = -InspectorHeight;
            self.inspectionWindowOpen = YES;
        }
        else if ((point.y - rootView.frame.size.height) < -(InspectorHeight * 1/8))
        {
            val = -50;
            self.inspectionWindowOpen = NO;
        }
        else
        {
            val = 0;
            self.inspectionWindowOpen = NO;
        }

        self.attributesNavigationFromBottomConstraint.constant = val;

        [UIView animateWithDuration:0.3 animations:^{
            [rootView layoutIfNeeded];
        }];

    }
}

-(void)pluginViewSelected:(UITableViewCell *)pluginView
{
    HYPAttributeInspectorInteractionView *view = [[HYPAttributeInspectorInteractionView alloc] initWithPluginExtension:self.extension];

    _active = YES;

    [self.extension.overlayContainer addOverlayView:view];
}

-(void)overlayViewChanged:(UIView *)overlayView
{
    self.active = [overlayView isKindOfClass:[HYPAttributeInspectorInteractionView class]];

    if (self.active)
    {
        _pluginView.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        _pluginView.accessoryType = UITableViewCellAccessoryNone;
        [self.attributesNavigation removeFromParentViewController];
        [self.attributesNavigation.view removeFromSuperview];
    }
}

-(void)targetViewChanged:(UIView *)overlayView
{
    if (self.active)
    {
        if (!self.attributesNavigation || !self.attributesNavigation.parentViewController)
        {
            self.attributesNavigation = [[UINavigationController alloc] initWithRootViewController:[[AttributesTabViewController alloc] initWithSelectedView:nil]];
            
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(navigationPan:)];
                    
            [self.attributesNavigation.view addGestureRecognizer:pan];

            UIView *rootView = self.extension.hypeWindow.rootViewController.view;
            
            [self.extension.hypeWindow.rootViewController addChildViewController:self.attributesNavigation];
            [rootView addSubview:self.attributesNavigation.view];
            
            self.attributesNavigation.view.translatesAutoresizingMaskIntoConstraints = NO;
            
            [self.attributesNavigation.view.leadingAnchor constraintEqualToAnchor:rootView.leadingAnchor].active = YES;
            
            [self.attributesNavigation.view.trailingAnchor constraintEqualToAnchor:rootView.trailingAnchor].active = YES;
            
            self.attributesNavigationFromBottomConstraint = [self.attributesNavigation.view.topAnchor constraintEqualToAnchor:rootView.bottomAnchor constant:0];
            self.attributesNavigationFromBottomConstraint.active = YES;
            [self.attributesNavigation.view.heightAnchor constraintEqualToConstant:InspectorHeight].active = YES;
        }
    
        UIView *rootView = self.extension.hypeWindow.rootViewController.view;
        [self.attributesNavigation setViewControllers:@[[[AttributesTabViewController alloc] initWithSelectedView:overlayView]]];
        
        [rootView layoutIfNeeded];

        self.attributesNavigation.title = [[overlayView class] description];
        
        if (self.attributesNavigationFromBottomConstraint.constant >= 0)
        {
            self.attributesNavigationFromBottomConstraint.constant = -50;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            [rootView layoutIfNeeded];
        }];

        self.inspectionWindowOpen = self.attributesNavigationFromBottomConstraint.constant < -50;
    }
}

@end
