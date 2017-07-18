//
//  HYPImpeccablePluginModule.m
//  HyperionCore
//
//  Created by Chris Mays on 6/28/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

#import "HYPImpeccablePluginModule.h"
#import "HYPImpeccableOverlayView.h"
#import "HYPImpeccableZepPhotoPickerViewController.h"

@interface HYPImpeccablePluginModule () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, HYPImpeccableZepPhotoPickerDelegate>

@property (nonatomic) id<HYPPluginExtension> extension;
@property (nonatomic) HYPImpeccableOverlayView *overlay;
@property (nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic) UINavigationController *currentPicker;
@end

@implementation HYPImpeccablePluginModule

@synthesize pluginView = _pluginView;
@synthesize overlayView = _overlayView;

-(instancetype)initWithPluginExtension:(id<HYPPluginExtension>)extension
{
    self = [super init];

    _extension = extension;

    return self;
}


-(UITableViewCell *)pluginView
{
    if (_pluginView)
    {
        return _pluginView;
    }

    UITableViewCell *tableViewCell = [[UITableViewCell alloc] init];

    tableViewCell.textLabel.text = @"Impeccable";

    _pluginView = tableViewCell;

    return  tableViewCell;
}

-(void)pluginViewSelected:(UITableViewCell *)pluginView
{
    _overlay = [[HYPImpeccableOverlayView alloc] init];
    _overlayView = _overlay;
    bool _active = ![self.extension.inAppOverlayContainer.overlayModule isKindOfClass:[self class]];

    if (_active)
    {
    }
    else
    {
       self.extension.inAppOverlayContainer.overlayModule = nil;
    }
}

-(void)cancelPressed
{
    [self.currentPicker  dismissViewControllerAnimated:YES completion:nil];
}

-(void)screenSelected:(UIImage *)screen
{
    _overlay.overlayImage = screen;
    [self.currentPicker dismissViewControllerAnimated:YES completion:nil];
}


@end
