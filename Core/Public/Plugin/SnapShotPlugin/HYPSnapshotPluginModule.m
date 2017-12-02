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

#import "HYPSnapshotPluginModule.h"
#import "HYPPluginMenuItem.h"
#import "HyperionManager.h"

@interface HYPSnapshotPluginModule() <HYPPluginMenuItemDelegate>

@end

@implementation HYPSnapshotPluginModule

@synthesize snapshotPluginView = _snapshotPluginView;
@synthesize pluginMenuItem = _pluginMenuItem;

-(UIView<HYPPluginMenuItem> *)pluginMenuItem
{
    if (_pluginMenuItem)
    {
        return _pluginMenuItem;
    }

    HYPPluginMenuItem *pluginItem = [[HYPPluginMenuItem alloc] init];
    pluginItem.delegate = self;
    [pluginItem bindWithTitle:[self pluginMenuItemTitle] image:[self pluginMenuItemImage]];

    _pluginMenuItem = pluginItem;

    return _pluginMenuItem;
}

-(NSString *)pluginMenuItemTitle
{
    return @"";
}

-(UIImage *)pluginMenuItemImage
{
    return nil;
}

-(void)pluginMenuItemSelected:(UIView *)pluginView
{
    bool shouldActivate = ![self active];

    if (shouldActivate)
    {
        self.extension.snapshotContainer.overlayModule = self;
    }
    else
    {
        self.extension.snapshotContainer.overlayModule = nil;
    }

    if ([self shouldHideDrawerOnSelection])
    {
        [[HyperionManager sharedInstance] togglePluginDrawer];
    }
}

-(BOOL)active
{
    return self.extension.snapshotContainer.overlayModule == self;
}

-(BOOL)shouldHideDrawerOnSelection
{
    return true;
}

-(void)activateSnapshotPluginViewWithContext:(nonnull UIView *)context
{
    [_pluginMenuItem setSelected:YES animated:YES];
}

-(void)deactivateSnapshotPluginView
{
    [_pluginMenuItem setSelected:NO animated:YES];
}

-(void)snapshotPluginViewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    //No op;
}

-(void)snapshotPluginViewDidTransitionToSize:(CGSize)size
{
    //No op;
}

@end
