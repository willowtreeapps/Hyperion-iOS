//  Copyright (c) 2018 WillowTree, Inc.

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

#import "HYPOverlayPluginModule.h"
#import "HYPPluginMenuItem.h"
#import "HyperionManager.h"

@interface HYPOverlayPluginModule() <HYPPluginMenuItemDelegate>

@end

@implementation HYPOverlayPluginModule

@synthesize pluginMenuItem = _pluginMenuItem;

-(void)pluginMenuItemSelected:(UIView *)pluginView
{
    bool shouldActivate = ![self active];
    
    if (shouldActivate)
    {
        self.extension.overlayContainer.overlayModule = self;
    }
    else
    {
        self.extension.overlayContainer.overlayModule = nil;
    }
    
    if ([self shouldHideDrawerOnSelection])
    {
        [[HyperionManager sharedInstance] togglePluginDrawer];
    }
}

-(BOOL)active
{
    return self.extension.overlayContainer.overlayModule == self;
}

-(BOOL)shouldHideDrawerOnSelection
{
    return YES;
}

/**
 * This gets called when the plugin view should activate in the provided context.
 * Simply add your plugin interation view as a subview to the provided context.
 *
 * Note: Contexts are changed each plugin activation.
 * @param context The provided view the plugin interaction view should be added to.
 */
-(void)activateOverlayPluginViewWithContext:(nonnull UIView *)context
{
    [self.pluginMenuItem setSelected:YES animated:YES];
}

-(void)deactivateOverlayPluginView
{
    [self.pluginMenuItem setSelected:NO animated:YES];
}

@end

