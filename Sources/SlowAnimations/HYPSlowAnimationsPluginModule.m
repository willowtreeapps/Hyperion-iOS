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

#import "HYPSlowAnimationsPluginModule.h"
#import "HYPPluginMenuItem.h"
#import "HYPSlowAnimationsPluginMenuItem.h"

@interface HYPSlowAnimationsPluginModule () <HYPPluginMenuItemDelegate, HYPSlowAnimationsPluginMenuItemDelegate, HYPSlowAnimationsPluginMenuItemDataSource>

@end

@implementation HYPSlowAnimationsPluginModule
@synthesize pluginMenuItem = _pluginMenuItem;

-(UIView *)pluginMenuItem
{
    if (_pluginMenuItem)
    {
        return _pluginMenuItem;
    }

    HYPSlowAnimationsPluginMenuItem *pluginView = [[HYPSlowAnimationsPluginMenuItem alloc] init];
    [pluginView bindWithTitle:@"Slow Animations" image:[UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"timer" ofType:@"png"]]];

    pluginView.delegate = self;
    pluginView.speedDelegate = self;
    pluginView.speedDatasource = self;
    
    _pluginMenuItem = pluginView;

    bool slowAnimationsOn = self.extension.attachedWindow.layer.speed != 1.0;

    [_pluginMenuItem setSelected:slowAnimationsOn animated:false];

    return  _pluginMenuItem;
}

-(void)userInitiatedSpeedChange:(HYPAnimationSpeed)speed
{
    CGFloat layerSpeed = 1.0;

    if (speed == HYPAnimationSpeedQuarter)
    {
        layerSpeed = .25;
    }
    else if (speed == HYPAnimationSpeedHalf)
    {
        layerSpeed = 0.5;
    }
    else if (speed == HYPAnimationSpeedThreeQuarters)
    {
        layerSpeed = 0.75;
    }

    self.extension.attachedWindow.layer.speed = layerSpeed;
}

-(HYPAnimationSpeed)currentAnimationSpeed
{
    if (self.extension.attachedWindow.layer.speed >= .24 && self.extension.attachedWindow.layer.speed <= .26)
    {
        return HYPAnimationSpeedQuarter;
    }
    else if (self.extension.attachedWindow.layer.speed >= .49 && self.extension.attachedWindow.layer.speed <= .51)
    {
        return HYPAnimationSpeedHalf;
    }
    else if (self.extension.attachedWindow.layer.speed >= .74 && self.extension.attachedWindow.layer.speed <= .76)
    {
        return HYPAnimationSpeedThreeQuarters;
    }
    else
    {
        return HYPAnimationSpeedNormal;
    }
}

-(void)pluginMenuItemSelected:(UIView *)pluginView
{
    bool slowAnimationsShouldTurnOn = self.extension.attachedWindow.layer.speed == 1.0;

    self.extension.attachedWindow.layer.speed = slowAnimationsShouldTurnOn ? 0.5 : 1.0;

    [(HYPPluginMenuItem *)_pluginMenuItem setSelected:slowAnimationsShouldTurnOn animated:true];
}

@end
