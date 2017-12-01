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
@property (nonatomic) NSMutableArray<UITapGestureRecognizer *> *tapGestures;
@property (nonatomic) UIStackView *pluginList;

@end

@implementation PluginListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pluginList = [[UIStackView alloc] initWithFrame:CGRectZero];

    self.tapGestures = [[NSMutableArray alloc] init];

    self.pluginList.spacing = 20;
    
    [self.view addSubview:self.pluginList];

    self.pluginList.translatesAutoresizingMaskIntoConstraints = NO;

    self.pluginList.axis = UILayoutConstraintAxisVertical;

    self.view.backgroundColor = [UIColor clearColor];

    [self.pluginList.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.pluginList.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.pluginList.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;

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
