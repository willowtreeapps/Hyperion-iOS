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

#import "HYPPluginModule.h"
#import "HYPPluginMenuItem.h"

@interface HYPPluginModule() <HYPPluginMenuItemDelegate>

@end

@implementation HYPPluginModule
@synthesize pluginMenuItem = _pluginMenuItem;
@synthesize extension = _extension;
@synthesize active = _active;

-(instancetype)initWithExtension:(id<HYPPluginExtension>)extension
{
    self = [super init];

    _extension = extension;

    return self;
}

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

-(BOOL)shouldHideDrawerOnSelection
{
    return YES;
}


- (void)pluginMenuItemSelected:(UIView<HYPPluginMenuItem> *)pluginView {
    // nop;
}

@end
