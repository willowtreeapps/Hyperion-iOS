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

#import "HYPSnapshotViewController.h"
#import "PluginListViewController.h"
#import "HYPPluginExtension.h"
#import "HYPPluginExtensionImp.h"
#import "HYPPlugin.h"
#import "HYPSnapshotContainer.h"
#import "HYPSnapshotDebuggingWindow.h"
#import "HyperionManager.h"
#import <objc/runtime.h>
#import "HYPViewSelectionTableViewController.h"
#import "HYPPluginHelper.h"
#import "HYPPopoverViewController.h"

@interface HYPSnapshotViewController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, HYPSnapshotContainerDelegate, HYPPopoverViewControllerDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) HYPSnapshotContainer *scrollViewContainer;

@property (nonatomic) UIView *currentSnapshotView;
@property (nonatomic) id<HYPPluginExtension> pluginExtension;

@property (nonatomic) NSArray<id<HYPPluginModule>> *pluginModules;

@property (nonatomic) PluginListViewController *pluginListViewController;
@property (nonatomic, weak) HYPSnapshotDebuggingWindow *snapshotDebuggingWindow;

@property (nonatomic) UIPanGestureRecognizer *deactivateDrawerPanGesture;
@property (nonatomic) UITapGestureRecognizer *dismissDrawerTapGesture;

@property (nonatomic) BOOL drawerActive;
@property (nonatomic) UIWindow *attachedWindow;
@property (nonatomic) UIView *snapshotContainerView;

@property (nonatomic) HYPPopoverViewController *contextMenu;
@property (nonatomic) CGPoint contextMenuPosition;

@end

@implementation HYPSnapshotViewController
@synthesize overlayModule;
const CGFloat MaxPopoverWidth = 300;
const CGFloat MaxPopoverHeight = 300;

const CGFloat PluginListWidth = 280;

-(instancetype)initWithDebuggingWindow:(HYPSnapshotDebuggingWindow *)snapshotDebuggingWindow attachedWindow:(UIWindow *)attachedWindow
{
    self = [super init];

    _snapshotDebuggingWindow = snapshotDebuggingWindow;
    _attachedWindow = attachedWindow;
    _snapshotDebuggingWindow.windowLevel = 10000001;

    _dismissDrawerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deactivate)];

    [self setupGestureRecognizers:snapshotDebuggingWindow];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
}

-(void)setup
{
    self.snapshotContainerView = [UIView new];

    self.pluginListViewController = [[PluginListViewController alloc] init];

    self.scrollView = [[UIScrollView alloc] init];
    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.snapshotContainerView addSubview: self.scrollView];
    [self.scrollView.leadingAnchor constraintEqualToAnchor:self.snapshotContainerView.leadingAnchor].active = YES;
    [self.scrollView.trailingAnchor constraintEqualToAnchor:self.snapshotContainerView.trailingAnchor].active = YES;
    [self.scrollView.topAnchor constraintEqualToAnchor:self.snapshotContainerView.topAnchor].active = YES;
    [self.scrollView.bottomAnchor constraintEqualToAnchor:self.snapshotContainerView.bottomAnchor].active = YES;

    self.scrollView.backgroundColor = [UIColor blackColor];

    self.scrollViewContainer = [[HYPSnapshotContainer alloc] initWithFrame:self.view.frame];
    self.scrollViewContainer.delegate = self;

    self.scrollViewContainer.backgroundColor = [UIColor whiteColor];

    [self.scrollView addSubview:self.scrollViewContainer];

    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 10.0;

    [self.scrollView setZoomScale:0.2];
    self.scrollView.delegate = self;

    [self takeSnapshot];


    self.pluginListViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:self.pluginListViewController];

    [self.view addSubview:self.pluginListViewController.view];

    [self.pluginListViewController.view.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.pluginListViewController.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.pluginListViewController.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
    [self.pluginListViewController.view.widthAnchor constraintEqualToConstant:PluginListWidth].active = true;;

    [self initializePlugins];

    [self.view addSubview:self.snapshotContainerView];
    self.snapshotContainerView.translatesAutoresizingMaskIntoConstraints = false;
    [self.snapshotContainerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [self.snapshotContainerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
    [self.snapshotContainerView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
    [self.snapshotContainerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;

    [self.snapshotContainerView setBackgroundColor:[UIColor colorWithRed:244/255.0 green:245/255.0 blue:247/255.0 alpha:1]];

    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:247/255.0 alpha:1];

    [self.view layoutIfNeeded];

    [self.snapshotContainerView addGestureRecognizer:self.scrollView.pinchGestureRecognizer];
    [self.snapshotContainerView addGestureRecognizer:self.scrollView.panGestureRecognizer];
}

-(void)setupGestureRecognizers:(HYPSnapshotDebuggingWindow *)window
{
    self.twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activate)];
    [self.twoFingerTapRecognizer setNumberOfTapsRequired:2];
    [self.twoFingerTapRecognizer setNumberOfTouchesRequired:2];
    self.twoFingerTapRecognizer.delegate = self;

    window.twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activate)];
    [window.twoFingerTapRecognizer setNumberOfTapsRequired:2];
    [window.twoFingerTapRecognizer setNumberOfTouchesRequired:2];
    window.twoFingerTapRecognizer.delegate = self;
    [window addGestureRecognizer:window.twoFingerTapRecognizer];

    self.threeFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activate)];
    [self.threeFingerTapRecognizer setNumberOfTapsRequired:1];
    [self.threeFingerTapRecognizer setNumberOfTouchesRequired:3];
    self.threeFingerTapRecognizer.delegate = self;
    self.threeFingerTapRecognizer.enabled = NO;

    window.threeFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activate)];
    [window.threeFingerTapRecognizer setNumberOfTapsRequired:1];
    [window.threeFingerTapRecognizer setNumberOfTouchesRequired:3];
    window.threeFingerTapRecognizer.delegate = self;
    [window addGestureRecognizer:window.threeFingerTapRecognizer];
    window.threeFingerTapRecognizer.enabled = NO;

    self.edgeSwipeRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(activate)];
    [self.edgeSwipeRecognizer setEdges:UIRectEdgeRight];
    self.edgeSwipeRecognizer.delegate = self;
    self.edgeSwipeRecognizer.enabled = NO;

    window.edgeSwipeRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(activate)];
    [window.edgeSwipeRecognizer setEdges:UIRectEdgeRight];
    window.edgeSwipeRecognizer.delegate = self;
    [window addGestureRecognizer:window.edgeSwipeRecognizer];
    window.edgeSwipeRecognizer.enabled = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.zoomScale <= 1)
    {
        self.scrollViewContainer.center = self.scrollView.center;
    }

    [self updatePopOverFrame:self.contextMenu];
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView.zoomScale <= 1)
    {
        self.scrollViewContainer.center = self.scrollView.center;
    }
}

-(void)initializePlugins
{
    self.pluginListViewController.pluginModules = [[HyperionManager sharedInstance] retrievePluginModules];
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.scrollViewContainer;
}

-(void)takeSnapshot
{
    [self.currentSnapshotView removeFromSuperview];

    self.currentSnapshotView = [self.attachedWindow snapshotViewAfterScreenUpdates:NO];
    self.currentSnapshotView.frame = self.view.bounds;
    [self.currentSnapshotView setClipsToBounds:YES];
    [self.scrollViewContainer setSnapshotView:self.currentSnapshotView];

    [self performSelector:@selector(takeSnapshot) withObject:nil afterDelay:1.0];
}

-(void)togglePluginDrawer
{
    if (self.drawerActive)
    {
        [self deactivate];
    }
    else
    {
        [self activate];
    }
}

-(void)activate
{
    if (!self.drawerActive) {
        self.snapshotDebuggingWindow.hidden = NO;
        self.drawerActive = YES;

        CATransform3D xTranslation = CATransform3DTranslate(CATransform3DIdentity, -250, 0, 100);

        CATransform3D scale = CATransform3DScale(CATransform3DIdentity, 0.73, 0.73, 0.73);

        self.scrollViewContainer.userInteractionEnabled = false;

        [self.snapshotContainerView addGestureRecognizer:self.dismissDrawerTapGesture];

        [UIView animateWithDuration:0.3 animations:^{
            self.snapshotContainerView.clipsToBounds = true;
            self.snapshotContainerView.layer.cornerRadius = 45;
            self.snapshotContainerView.layer.transform = CATransform3DConcat(scale, xTranslation);
            [self.view layoutIfNeeded];
        }];
    }
}

-(void)deactivate
{
    if (self.drawerActive) {
        self.drawerActive = NO;

        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
            self.snapshotContainerView.layer.cornerRadius = 0;
            self.snapshotContainerView.layer.transform = CATransform3DIdentity;
        }
        completion:^(BOOL finished) {
            self.scrollViewContainer.userInteractionEnabled = true;
            [self.snapshotContainerView removeGestureRecognizer:self->_dismissDrawerTapGesture];
            [self.snapshotContainerView removeGestureRecognizer:self.deactivateDrawerPanGesture];

            if (self.scrollViewContainer.overlayModule == nil) {
                [self.snapshotDebuggingWindow setHidden:YES];
            }
        }];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    UIViewController *top = [self.attachedWindow rootViewController];

    while (top.presentedViewController != nil) {
        top = top.presentedViewController;
    }

    return [top supportedInterfaceOrientations];
}

-(BOOL)shouldAutorotate
{
    UIViewController *top = [self.attachedWindow rootViewController];

    while (top.presentedViewController != nil) {
        top = top.presentedViewController;
    }

    return [top shouldAutorotate];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma HYPSnapshotContainerDelegate
-(void)overlayModuleChanged:(id<HYPPluginModule, HYPSnapshotPluginViewProvider>)overlayModule
{
    if (!overlayModule)
    {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }
}

-(void)presentViewListPopoverForPoint:(CGPoint)point delegate:(id<HYPViewSelectionDelegate>)delegate
{
    HYPViewSelectionTableViewController *table = [[HYPViewSelectionTableViewController alloc] initWithViewSelectionOptions:[HYPPluginHelper findSubviewsInView:_attachedWindow intersectingPoint:point] delegate:delegate];

    table.view.backgroundColor = [UIColor clearColor];
    table.tableView.backgroundColor = [UIColor clearColor];

    [self presentPopover:table recommendedHeight:300 atPosition:point];
}

-(void)presentPopover:(nonnull UIViewController *)popoverController recommendedHeight:(CGFloat)height forView:(nonnull UIView *)view
{

    CGRect frameMinusZoom = [view.superview convertRect:view.frame toView:self.attachedWindow];

    CGPoint optimalPosition;

    CGSize snapshotSize = [self snapshotAdjustedSize];

    CGFloat popoverHeight = MIN(height, MaxPopoverHeight);

    HYPPopoverPointerPosition recommendedArrowPosition;

    if (snapshotSize.height - frameMinusZoom.origin.y  > popoverHeight && snapshotSize.height - (frameMinusZoom.origin.y + frameMinusZoom.size.height) > popoverHeight)
    {
        optimalPosition = CGPointMake(frameMinusZoom.origin.x + (frameMinusZoom.size.width / 2), frameMinusZoom.origin.y + frameMinusZoom.size.height);
        recommendedArrowPosition = HYPPopoverPointerPositionTop;
    } else if (frameMinusZoom.origin.y > popoverHeight)
    {
        optimalPosition = CGPointMake(frameMinusZoom.origin.x + (frameMinusZoom.size.width / 2), frameMinusZoom.origin.y);
        recommendedArrowPosition = HYPPopoverPointerPositionBottom;
    }
    else
    {
        optimalPosition = CGPointMake(frameMinusZoom.origin.x + (frameMinusZoom.size.width / 2), frameMinusZoom.origin.y);
        recommendedArrowPosition = HYPPopoverPointerPositionTop;
    }

    [self presentPopover:popoverController recommendedHeight:popoverHeight atPosition:optimalPosition recommendedArrowPosition:recommendedArrowPosition];
}

-(void)presentPopover:(nonnull UIViewController *)popoverController recommendedHeight:(CGFloat)height atPosition:(CGPoint)point
{
    [self presentPopover:popoverController recommendedHeight:height atPosition:point recommendedArrowPosition:HYPPopoverPointerPositionNone];
}

-(void)presentPopover:(nonnull UIViewController *)popoverController recommendedHeight:(CGFloat)height atPosition:(CGPoint)point recommendedArrowPosition:(HYPPopoverPointerPosition)recommendedArrowPosition
{
    [self.contextMenu removeFromParentViewController];
    [self.contextMenu.view removeFromSuperview];

    self.contextMenu = [[HYPPopoverViewController alloc] initWithViewController:popoverController];
    self.contextMenu.delegate = self;
    self.contextMenu.arrowPosition = recommendedArrowPosition;

    self.contextMenu.view.frame = CGRectMake(0, 0, MaxPopoverWidth, MIN(height, MaxPopoverHeight));

    [self placePopover:self.contextMenu atPoint:point];
}

-(void)placePopover:(HYPPopoverViewController *)popover atPoint:(CGPoint)point
{
    popover.anchorPoint = point;
    CGPoint mutablePoint = point;

    if (mutablePoint.x - 150 < 0)
    {
        mutablePoint.x = 150;
    }
    else if (mutablePoint.x > self.scrollViewContainer.frame.size.width/self.scrollView.zoomScale - 150)
    {
        mutablePoint.x = self.scrollViewContainer.frame.size.width/self.scrollView.zoomScale - 150;
    }

    [self.snapshotContainerView addSubview:popover.view];
    [self addChildViewController:popover];

    [self updatePopOverFrame:popover];
}

-(void)dismissCurrentPopover
{
    [self.contextMenu removeFromParentViewController];
    [self.contextMenu.view removeFromSuperview];
}

-(void)popoverRequestedDismissal
{
    [self dismissCurrentPopover];
}

-(id<HYPSnapshotContainer>)snapshotContainer
{
    return self.scrollViewContainer;
}

-(void)updatePopOverFrame:(HYPPopoverViewController *)popOverViewController
{
    CGPoint mutablePoint = popOverViewController.anchorPoint;

    if (mutablePoint.x * self.scrollView.zoomScale - 150 < 0)
    {
        mutablePoint.x = 150/self.scrollView.zoomScale;
    }
    else if (mutablePoint.x * self.scrollView.zoomScale > self.scrollViewContainer.frame.size.width - 150)
    {
        mutablePoint.x = self.scrollViewContainer.frame.size.width/self.scrollView.zoomScale - 150/self.scrollView.zoomScale;
    }

    CGPoint newPoint = [self.scrollViewContainer convertPoint:mutablePoint toView:self.snapshotContainerView];

    CGRect newFrame = popOverViewController.view.frame;

    newFrame.origin.x = newPoint.x - 150;

    HYPPopoverPointerPosition position = popOverViewController.arrowPosition;

    if (popOverViewController.arrowPosition == HYPPopoverPointerPositionBottom)
    {
        newFrame.origin.y = newPoint.y - popOverViewController.view.frame.size.height;
    }
    else if (popOverViewController.arrowPosition == HYPPopoverPointerPositionTop)
    {
        newFrame.origin.y = newPoint.y;
    }

    else if ([self popover:self.contextMenu shouldGoAboveAnchorWithContainerSize:[self snapshotAdjustedSize]])
    {
        newFrame.origin.y = newPoint.y - popOverViewController.view.frame.size.height;
        position = HYPPopoverPointerPositionBottom;
    }
    else
    {
        newFrame.origin.y = newPoint.y;
        position = HYPPopoverPointerPositionTop;
    }

    popOverViewController.view.frame = newFrame;

    CGFloat arrowOffset = [self.scrollViewContainer convertPoint:popOverViewController.anchorPoint toView:popOverViewController.view].x;

    [popOverViewController setArrowPosition:position offset:arrowOffset];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self dismissCurrentPopover];
    
    [self.snapshotContainer.overlayModule snapshotContextWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    self.scrollView.zoomScale = 1;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self takeSnapshot];
        self.scrollViewContainer.frame = CGRectMake(0, 0, size.width, size.height);
        self.scrollView.zoomScale = 1;
        self.scrollView.contentOffset = CGPointZero;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self takeSnapshot];
        self.scrollView.zoomScale = 1;
        self.scrollView.contentOffset = CGPointZero;
        [self.snapshotContainer.overlayModule snapshotContextDidTransitionToSize:size];
    }];
}

-(void)presentViewController:(UIViewController *)controller animated:(bool)animated
{
    [self presentViewController:controller animated:YES completion:nil];
}

-(CGSize)snapshotAdjustedSize
{
    return CGSizeMake(self.scrollViewContainer.frame.size.width/self.scrollView.zoomScale, self.scrollViewContainer.frame.size.height/self.scrollView.zoomScale);
}

-(BOOL)popover:(HYPPopoverViewController *)popover shouldGoAboveAnchorWithContainerSize:(CGSize)size
{
    return size.height - popover.anchorPoint.y < popover.view.frame.size.height;
}

@end
