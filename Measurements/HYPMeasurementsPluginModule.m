//
//  HYPMeasurementsPluginModule.m
//  Pods
//
//  Created by Christopher Mays on 6/20/17.
//
//

#import "HYPMeasurementsPluginModule.h"
#import "HYPMeasurementsInteractionView.h"

@interface HYPMeasurementsPluginModule () <HYPOverlayContainerListener>

@property (nonatomic) id<HYPPluginExtension> extension;
@property (nonatomic) BOOL active;
@end

@implementation HYPMeasurementsPluginModule
@synthesize pluginView = _pluginView;

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
    _active = ![self.extension.overlayContainer removeAllOverlaysOfClass:[HYPMeasurementsInteractionView class]];

    if (_active)
    {
        HYPMeasurementsInteractionView *view = [[HYPMeasurementsInteractionView alloc] initWithPluginExtension:self.extension];
        [self.extension.overlayContainer addOverlayView:view];
    }
}

-(void)overlayViewChanged:(UIView *)overlayView
{
    if ([overlayView isKindOfClass:[HYPMeasurementsInteractionView class]])
    {
        _pluginView.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        _pluginView.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
