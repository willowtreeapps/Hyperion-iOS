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

#import "HYPAttributeInspectorInteractionView.h"
#import "HYPPluginExtension.h"
#import "HYPAttributesPreviewViewController.h"
#import "HYPPluginHelper.h"
#import "HYPMoreAttributesListViewController.h"

@class UIButtonLabel;

@interface HYPAttributeInspectorInteractionView () <HYPViewSelectionDelegate, HYPAttributesPreviewViewControllerDelegate>
@property (nonatomic) UIView *currentlySelectedView;
@end

@implementation HYPAttributeInspectorInteractionView

-(instancetype)init
{
    self = [super init];

    [self setup];

    return self;
}

-(instancetype)initWithExtension:(id<HYPPluginExtension>)extension
{
    self = [super initWithExtension:extension];

    [self setup];

    return self;
}

-(void)setup
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];

    longPress.minimumPressDuration = 1;

    [self addGestureRecognizer:tap];
    [self addGestureRecognizer:longPress];
}

-(void)tapGesture:(UITapGestureRecognizer *)tapGesture
{
    UIWindow *attachedWindow = [self.extension attachedWindow];

    CGPoint point = [tapGesture locationInView:self];

    [_highlightView removeFromSuperview];

    _highlightView = [UIView new];
    _highlightView.backgroundColor = [UIColor colorWithRed:43.0/255.0 green:87.0/255.0 blue:244.0/255.0 alpha:0.08];
    [self addSubview:_highlightView];

    NSArray<UIView *> *selectedViews = [HYPPluginHelper findSubviewsInView:attachedWindow intersectingPoint:point];

    UIView *selectedView = [selectedViews firstObject];

    [self viewSelected:selectedView];
}

-(void)viewSelected:(UIView *)selection
{
    if (self.currentlySelectedView == selection)
    {
        [self.extension.snapshotContainer dismissCurrentPopover];
        self.currentlySelectedView = nil;

        return;
    }

    self.currentlySelectedView = selection;

    [self updateSelection];
}

-(void)interactionViewDidTransitionToSize:(CGSize)size
{
    [super interactionViewDidTransitionToSize:size];
    [self updateSelection];
}

-(void)updateSelection
{
    if (!self.currentlySelectedView)
    {
        return;
    }
    
    CGRect viewRect = [self.currentlySelectedView.superview convertRect:self.currentlySelectedView.frame toView:[self.extension attachedWindow]];
    
    self.highlightView.frame = viewRect;
    
    HYPAttributesPreviewViewController *attributesView = [[HYPAttributesPreviewViewController alloc] initWithSelectedView:self.currentlySelectedView];
    
    attributesView.delegate = self;
    
    [self.extension.snapshotContainer presentPopover:attributesView recommendedHeight:250 forView:self.currentlySelectedView];
}

-(void)moreButtonPressedForSelectedView:(UIView *)view
{
     HYPMoreAttributesListViewController *attributesViewController = [[HYPMoreAttributesListViewController alloc] initWithSelectedView:self.currentlySelectedView];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:attributesViewController];

    [self.extension.snapshotContainer presentViewController:navigation animated:true];
}

-(void)longPress:(UILongPressGestureRecognizer *)longGesture
{
    CGPoint point = [longGesture locationInView:self];
    UIViewController *viewListViewController = [[UIViewController alloc] init];
    viewListViewController.view.backgroundColor = [UIColor whiteColor];
    [self.extension.snapshotContainer presentViewListPopoverForPoint:point delegate:self];
}

@end
