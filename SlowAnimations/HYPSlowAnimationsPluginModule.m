//
//  HYPSlowAnimationsPluginModule.m
//  Pods
//
//  Created by Christopher Mays on 6/19/17.
//
//

#import "HYPSlowAnimationsPluginModule.h"

@interface HYPSlowAnimationTableViewCell : UITableViewCell

@property (nonatomic) UISwitch *slowAnimationsSwitch;

@end

@implementation HYPSlowAnimationTableViewCell

-(instancetype)init
{
    self = [super init];
    
    [self setup];
    
    return self;
}

-(void)setup
{
    self.textLabel.text = @"Slow Animations";
    self.slowAnimationsSwitch = [[UISwitch alloc] init];
    
    self.slowAnimationsSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.slowAnimationsSwitch];
    
    [self.slowAnimationsSwitch.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [self.slowAnimationsSwitch.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
}

@end

@interface HYPSlowAnimationsPluginModule ()

@property (nonatomic) id<HYPPluginExtension> extension;

@end

@implementation HYPSlowAnimationsPluginModule

@synthesize pluginView = _pluginView;

-(id)initWithPluginExtension:(id<HYPPluginExtension>)extension
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

    HYPSlowAnimationTableViewCell *slowAnimationsCell = [[HYPSlowAnimationTableViewCell alloc] init];
    
    [slowAnimationsCell.slowAnimationsSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    slowAnimationsCell.slowAnimationsSwitch.on = self.extension.appWindow.layer.speed <= 0.5;

    _pluginView = slowAnimationsCell;

    return slowAnimationsCell;
}

-(void)switchChanged:(UISwitch *)slowAnimation
{
    self.extension.appWindow.layer.speed = slowAnimation.on ? 0.08 : 1.0;
}

-(void)pluginViewSelected:(UITableViewCell *)pluginView
{
    
}

@end
