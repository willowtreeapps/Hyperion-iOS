//
//  HYPMeasurementsPluginModule.m
//  Pods
//
//  Created by Christopher Mays on 6/20/17.
//
//

#import "HYPMeasurementsPluginModule.h"
#import "HYPMeasurementsInteractionView.h"

@interface HYPMeasurementsPluginModule ()

@property (nonatomic) id<HYPPluginExtension> extension;
@property (nonatomic) BOOL active;
@end

@implementation HYPMeasurementsPluginModule

-(instancetype)initWithPluginExtension:(id<HYPPluginExtension>)extension
{
    self = [super init];
    
    _extension = extension;
    
    return self;
}

-(UITableViewCell *)createPluginView
{
    UITableViewCell *tableViewCell = [[UITableViewCell alloc] init];
    
    tableViewCell.textLabel.text = @"Measurements Tool";
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activate)];
    
    [tableViewCell addGestureRecognizer:tapGesture];
    
    return  tableViewCell;
}

-(void)activate
{
    HYPMeasurementsInteractionView *view = [[HYPMeasurementsInteractionView alloc] initWithPluginExtension:self.extension];
    
    _active = YES;
    
    [self.extension.overlayContainer addOverlayView:view];
}

@end
