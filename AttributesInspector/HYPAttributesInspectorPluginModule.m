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

#import "HYPAttributesInspectorPluginModule.h"
#import "HYPAttributeInspectorInteractionView.h"
#import "HyperionManager.h"

@interface HYPAttributesInspectorPluginModule ()

@property (nonatomic) HYPAttributeInspectorInteractionView *currentAttributesInteractionView;

@end

@implementation HYPAttributesInspectorPluginModule

@synthesize snapshotPluginView = _snapshotPluginView;

const CGFloat InspectorHeight = 350;

-(NSString *)pluginMenuItemTitle
{
    return @"Attributes Inspector";
}

-(UIImage *)pluginMenuItemImage
{
    return [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"attributeInspector" ofType:@"png"]];
}

-(void)activateSnapshotPluginViewWithContext:(UIView *)context
{
    [super activateSnapshotPluginViewWithContext:context];
    [_snapshotPluginView removeFromSuperview];
    self.currentAttributesInteractionView = [[HYPAttributeInspectorInteractionView alloc] initWithExtension:self.extension];
    _snapshotPluginView = self.currentAttributesInteractionView;
    _snapshotPluginView.translatesAutoresizingMaskIntoConstraints = false;
    [context addSubview:_snapshotPluginView];
    [_snapshotPluginView.leadingAnchor constraintEqualToAnchor:context.leadingAnchor].active = true;
    [_snapshotPluginView.trailingAnchor constraintEqualToAnchor:context.trailingAnchor].active = true;
    [_snapshotPluginView.topAnchor constraintEqualToAnchor:context.topAnchor].active = true;
    [_snapshotPluginView.bottomAnchor constraintEqualToAnchor:context.bottomAnchor].active = true;
}

-(void)snapshotContextWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super snapshotContextWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.currentAttributesInteractionView interactionViewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

-(void)snapshotContextDidTransitionToSize:(CGSize)size
{
    [super snapshotContextDidTransitionToSize:size];
    [self.currentAttributesInteractionView interactionViewDidTransitionToSize:size];
}

-(void)deactivateSnapshotPluginView
{
    [super deactivateSnapshotPluginView];
    [_snapshotPluginView removeFromSuperview];
}

@end
