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

#import "HYPMeasurementsPluginModule.h"
#import "HYPMeasurementsInteractionView.h"
#import "HyperionManager.h"
#import "HYPOverlayViewProvider.h"

@interface HYPMeasurementsPluginModule()
@property (nonatomic) HYPMeasurementsInteractionView *currentMeasurementsView;
@end
@implementation HYPMeasurementsPluginModule
@synthesize snapshotPluginView = _snapshotPluginView;

-(instancetype)initWithExtension:(id<HYPPluginExtension>)extension
{
    self = [super initWithExtension:extension];

    return self;
}

-(NSString *)pluginMenuItemTitle
{
    return @"Measurements";
}

-(UIImage *)pluginMenuItemImage
{
    return [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"ruler" ofType:@"png"]];
}

-(void)activateSnapshotPluginViewWithContext:(UIView *)context
{
    [super activateSnapshotPluginViewWithContext:context];

    [self.snapshotPluginView removeFromSuperview];

    self.currentMeasurementsView = [[HYPMeasurementsInteractionView alloc] initWithExtension:self.extension];

    _snapshotPluginView = self.currentMeasurementsView;
    
    self.snapshotPluginView.translatesAutoresizingMaskIntoConstraints = false;
    [context addSubview:_snapshotPluginView];
    [self.snapshotPluginView.leadingAnchor constraintEqualToAnchor:context.leadingAnchor].active = true;
    [self.snapshotPluginView.trailingAnchor constraintEqualToAnchor:context.trailingAnchor].active = true;
    [self.snapshotPluginView.topAnchor constraintEqualToAnchor:context.topAnchor].active = true;
    [self.snapshotPluginView.bottomAnchor constraintEqualToAnchor:context.bottomAnchor].active = true;
}

-(void)snapshotContextWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super snapshotContextWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.currentMeasurementsView interactionViewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

-(void)snapshotContextDidTransitionToSize:(CGSize)size
{
    [super snapshotContextDidTransitionToSize:size];
    [self.currentMeasurementsView interactionViewDidTransitionToSize:size];
}

-(void)deactivateSnapshotPluginView
{
    [super deactivateSnapshotPluginView];
    [_snapshotPluginView removeFromSuperview];
}

@end
