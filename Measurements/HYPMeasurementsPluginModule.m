//
//  HYPMeasurementsPluginModule.m
//  Pods
//
//  Created by Christopher Mays on 6/20/17.
//
//

#import "HYPMeasurementsPluginModule.h"
#import "HYPMeasurementsInteractionView.h"

@interface HYPMeasurementsPluginModule () <HYPOverlayContainerListener, HYPOverlayViewProvider>

@property (nonatomic) id<HYPPluginExtension> extension;
@property (nonatomic) BOOL active;
@end

@implementation HYPMeasurementsPluginModule
@synthesize pluginView = _pluginView;
@synthesize overlayView = _overlayView;

-(instancetype)initWithPluginExtension:(id<HYPPluginExtension>)extension
{
    self = [super init];
    
    _extension = extension;
    [_extension.overlayContainer addContainerListener:self];

    return self;
}

-(UITableViewCell *)pluginView
{
    if (_pluginView)
    {
        return _pluginView;
    }

    UITableViewCell *tableViewCell = [[UITableViewCell alloc] init];
    
    tableViewCell.textLabel.text = @"Measurements Tool";

    _pluginView = tableViewCell;

    return  tableViewCell;
}

-(void)pluginViewSelected:(UITableViewCell *)pluginView
{
    _active = ![self.extension.overlayContainer.overlayModule isKindOfClass:[self class]];

    if (_active)
    {
        _overlayView = [[HYPMeasurementsInteractionView alloc] initWithPluginExtension:self.extension];
        self.extension.overlayContainer.overlayModule  = self;
    }
    else
    {
        self.extension.overlayContainer.overlayModule = nil;
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
