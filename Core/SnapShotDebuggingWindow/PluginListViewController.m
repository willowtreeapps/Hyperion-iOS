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

    if (self.containerViews.count == 0) {
        [self addEmptyState];
    }
}

- (void)addEmptyState
{
    UIView *emptyStateView = [[UIView alloc] init];

    UILabel *noPluginsLabel = [[UILabel alloc] init];

    noPluginsLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    noPluginsLabel.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:147.0/255.0 alpha:1.0];
    noPluginsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    noPluginsLabel.numberOfLines = 0;
    noPluginsLabel.text = NSLocalizedString(@"Oops! You don't have any plugins yet.", nil);
    [emptyStateView addSubview:noPluginsLabel];

    UILabel *linkLabel = [[UILabel alloc] init];
    [linkLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(linkTap:)]];
    linkLabel.userInteractionEnabled = true;

    linkLabel.textColor = [UIColor colorWithRed:43.0/255.0 green:87.0/255.0 blue:244.0/255.0 alpha:1.0];
    linkLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    linkLabel.lineBreakMode = NSLineBreakByWordWrapping;
    linkLabel.numberOfLines = 0;
    NSMutableAttributedString *linkString = [[NSMutableAttributedString alloc]
                                             initWithString:NSLocalizedString(@"Follow this guide to add plugins   ", nil)];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"linkButton" ofType:@"png"]];

    [linkString appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
    linkLabel.attributedText = linkString;
    [emptyStateView addSubview:linkLabel];

    emptyStateView.translatesAutoresizingMaskIntoConstraints = false;
    noPluginsLabel.translatesAutoresizingMaskIntoConstraints = false;
    linkLabel.translatesAutoresizingMaskIntoConstraints = false;

    [noPluginsLabel.topAnchor constraintEqualToAnchor:emptyStateView.topAnchor].active = true;
    [noPluginsLabel.centerXAnchor constraintEqualToAnchor:emptyStateView.centerXAnchor].active = true;
    [noPluginsLabel.widthAnchor constraintEqualToConstant:147].active = true;
    [noPluginsLabel.heightAnchor constraintEqualToConstant:70].active = true;
    [noPluginsLabel.bottomAnchor constraintEqualToAnchor:linkLabel.topAnchor constant:-30].active = true;

    [linkLabel.widthAnchor constraintEqualToConstant:141.3].active = true;
    [linkLabel.centerXAnchor constraintEqualToAnchor:emptyStateView.centerXAnchor].active = true;

    [emptyStateView.heightAnchor constraintEqualToConstant:150].active = true;

    [self.pluginList addArrangedSubview:emptyStateView];
}

- (void)linkTap:(UITapGestureRecognizer *)recognizer
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/willowtreeapps/Hyperion-iOS/blob/master/README.md?utm_source=hyperion-core&utm_medium=referral&utm_campaign=introducing-hyperion#installation"]];
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
