//
//  HYPVisualLoggerPluginModule.m
//  HyperionCore
//
//  Created by Chris Mays on 6/26/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import "HYPVisualLoggerPluginModule.h"
#import "HYPVisualLoggingManager.h"
#import "HYPVisualLoggingContainerView.h"

@interface HYPVisualLoggerPluginModule () <HYPOverlayContainerListener>

@property (nonatomic) UITableViewCell *pluginView;
@property (nonatomic) id<HYPPluginExtension> extension;
@property (nonatomic) HYPVisualLoggingManager *loggingManager;

@end

@implementation HYPVisualLoggerPluginModule
@synthesize overlayView = _overlayView;

-(instancetype)initWithPluginExtension:(id<HYPPluginExtension>)extension
{
    self = [super init];

    _extension = extension;
    [_extension.inAppOverlayContainer addContainerListener:self];

    _loggingManager = [[HYPVisualLoggingManager alloc] init];

    return self;
}

-(UITableViewCell *)pluginView
{
    if (_pluginView)
    {
        return _pluginView;
    }

    UITableViewCell *tableViewCell = [[UITableViewCell alloc] init];

    tableViewCell.textLabel.text = @"Visual Logging";

    _pluginView = tableViewCell;

    return  tableViewCell;
}

-(void)pluginViewSelected:(UITableViewCell *)pluginView
{
    bool _active = ![self.extension.inAppOverlayContainer.overlayModule isKindOfClass:[self class]];

    if (_active)
    {
        _overlayView = _loggingManager.loggingView;
        self.extension.inAppOverlayContainer.overlayModule  = self;

        _overlayView.frame = CGRectMake(0, 0, 300, 200);
    }
    else
    {
        self.extension.inAppOverlayContainer.overlayModule = nil;
    }
}

-(void)overlayModuleChanged:(id<HYPPluginModule, HYPOverlayViewProvider>)overlayProvider;
{
    if ([overlayProvider isKindOfClass:[self class]])
    {
        _pluginView.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        _pluginView.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
