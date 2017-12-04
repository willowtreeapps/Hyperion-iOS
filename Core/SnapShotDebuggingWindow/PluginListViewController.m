//  Copyright (c) 2017 WillowTree, Inc.

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "PluginListViewController.h"

@interface PluginContainerView : UIView

@property (nonatomic) UIView *pluginView;
@property (nonatomic) HYPPluginModule *pluginModule;

@end

@implementation PluginContainerView

-(instancetype)initWithPluginModule:(HYPPluginModule *)module pluginView:(UIView *)pluginView
{
    self = [super init];

    _pluginView = pluginView;
    _pluginModule = module;

    _pluginView.translatesAutoresizingMaskIntoConstraints = false;

    [self addSubview:_pluginView];
    [_pluginView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = true;
    [_pluginView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = true;
    [_pluginView.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
    [_pluginView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = true;

    return self;
}


@end

@interface PluginListViewController ()

@property (nonatomic) NSArray<PluginContainerView *> *containerViews;
@property (nonatomic) UIStackView *pluginList;
@property (nonatomic) UIScrollView *pluginScrollView;

@end

@implementation PluginListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];

    self.pluginScrollView = [[UIScrollView alloc] init];
    self.pluginScrollView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:self.pluginScrollView];
    
    [self.pluginScrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [self.pluginScrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
    [self.pluginScrollView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
    [self.pluginScrollView.topAnchor constraintGreaterThanOrEqualToAnchor:self.view.topAnchor constant:0].active = true;
    [self.pluginScrollView.bottomAnchor constraintLessThanOrEqualToAnchor:self.view.bottomAnchor constant:0].active = true;
    
    self.pluginList = [[UIStackView alloc] initWithFrame:CGRectZero];
    self.pluginList.spacing = 20;
    [self.pluginScrollView addSubview:self.pluginList];
    
    self.pluginList.translatesAutoresizingMaskIntoConstraints = NO;
    self.pluginList.axis = UILayoutConstraintAxisVertical;
    
    [self.pluginList.leadingAnchor constraintEqualToAnchor:self.pluginScrollView.leadingAnchor].active = YES;
    [self.pluginList.trailingAnchor constraintEqualToAnchor:self.pluginScrollView.trailingAnchor].active = YES;
    [self.pluginList.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [self.pluginList.topAnchor constraintEqualToAnchor:self.pluginScrollView.topAnchor constant:15].active = YES;
    [self.pluginList.bottomAnchor constraintEqualToAnchor:self.pluginScrollView.bottomAnchor constant:15].active = YES;

    NSLayoutConstraint *heightContraint = [self.pluginList.heightAnchor constraintEqualToAnchor:_pluginScrollView.heightAnchor];
    
    //This constraint will only stick around if the plugin list is not big enough to scroll
    [heightContraint setPriority:250];
    heightContraint.active = true;
    
    [self loadTabs];
}

-(void)loadTabs
{
    for (UIView *arrangedViews in self.pluginList.arrangedSubviews)
    {
        [arrangedViews removeFromSuperview];
    }

    for (PluginContainerView *view in self.containerViews)
    {
        [self.pluginList addArrangedSubview:view];
    }
}

-(void)setPluginModules:(NSArray<id<HYPPluginModule>> *)pluginModules
{
    _pluginModules = pluginModules;

    NSMutableArray<PluginContainerView *> *containerViews = [[NSMutableArray alloc] init];

    for (id<HYPPluginModule> module in pluginModules)
    {
        UIView *pluginModuleView = [module pluginMenuItem];
        if (pluginModuleView)
        {

            PluginContainerView *container = [[PluginContainerView alloc] initWithPluginModule:module pluginView:pluginModuleView];

            [containerViews addObject:container];
        }
    }

    _containerViews = containerViews;

    [self loadTabs];
}

@end
