//
//  HYPDebuggingOverlayViewController.m
//  Pods
//
//  Created by Chris Mays on 6/22/17.
//
//

#import "HYPDebuggingOverlayViewController.h"
#import "TabStack.h"
#import "TabView.h"
#import "ToolsTabViewController.h"
#import "HYPPluginExtension.h"
#import "HYPPluginExtensionImp.h"
#import "HYPPlugin.h"
#import "HYPOverlayContainerImp.h"
#import "HYPDebuggingWindow.h"
#import <objc/runtime.h>
#import "HYPInAppDebuggingWindow.h"

@interface TabViewTuple : NSObject

@property (nonatomic) TabView *tab;
@property (nonatomic) UIViewController *viewController;
@end

@implementation TabViewTuple

@end

@interface HYPDebuggingOverlayViewController () <UIGestureRecognizerDelegate, TabStackDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, HYPOverlayContainerListener>
@property (nonatomic) TabStack *tabStack;
@property (nonatomic) UINavigationController *menuContainer;
@property (nonatomic) NSLayoutConstraint *menuTrailingConstraint;
@property (nonatomic) NSLayoutConstraint *menuWidthConstraint;
@property (nonatomic) NSMutableArray<TabViewTuple *> *menuTabTuples;
@property (nonatomic) InteractionView *currentInteractionView;
@property (nonatomic) TabViewTuple *toolsTuple;;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) HYPOverlayContainerImp *scrollViewContainer;
@property (nonatomic) UIView *currentSnapshotView;

@property (nonatomic) id<HYPPluginExtension> pluginExtension;

@property (nonatomic) NSArray<id<HYPPluginModule>> *pluginModules;
@property (nonatomic) NSArray<UITableViewCell *> *pluginViews;
@property (nonatomic) ToolsTabViewController *toolsTabViewController;
@property (nonatomic, weak) HYPDebuggingWindow *debuggingWindow;

@property (nonatomic) UIView *fadeView;

@property (nonatomic) UIPanGestureRecognizer *deactivateDrawerPanGesture;
@property (nonatomic) UIScreenEdgePanGestureRecognizer *internalPanGestureRecognizer;

@property (nonatomic) UIWindow *inAppOverlayWindow;
@property (nonatomic) HYPOverlayContainerImp *inAppOverlayContainer;

@property (nonatomic) BOOL drawerActive;

@property (nonatomic) HYPInAppDebuggingWindow *inAppDebuggingWindow;

@end

@implementation HYPDebuggingOverlayViewController
const CGFloat MenuWidth = 300;


-(instancetype)initWithDebuggingWindow:(HYPDebuggingWindow *)debuggingWindow
{
    self = [super init];

    _debuggingWindow = debuggingWindow;

    _debuggingWindow.windowLevel = 10000001;

    self.panGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.panGesture setEdges:UIRectEdgeRight];

    self.panGesture.delegate = self;

    self.internalPanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.internalPanGestureRecognizer setEdges:UIRectEdgeRight];
    self.internalPanGestureRecognizer.delegate = self;

    [self setupInAppDebuggingView];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setup
{
    [self.view addGestureRecognizer:self.internalPanGestureRecognizer];
    self.menuTabTuples = [[NSMutableArray alloc] init];

    self.deactivateDrawerPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];

    ToolsTabViewController *toolsTab = [[ToolsTabViewController alloc] init];
    self.toolsTabViewController = toolsTab;

    [toolsTab.view addGestureRecognizer:self.deactivateDrawerPanGesture];

    self.scrollView = [[UIScrollView alloc] init];
    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview: self.scrollView];
    [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;

    self.scrollView.backgroundColor = [UIColor blackColor];

    self.scrollViewContainer = [[HYPOverlayContainerImp alloc] initWithFrame:self.view.frame];

    self.scrollViewContainer.backgroundColor = [UIColor whiteColor];

    [self.scrollViewContainer addContainerListener:self];

    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollView.heightAnchor constraintEqualToConstant:self.view.frame.size.height].active = YES;
    [self.scrollView.widthAnchor constraintEqualToConstant:self.view.frame.size.width].active = YES;
    [self.scrollView.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor].active = YES;
    [self.scrollView.centerYAnchor constraintEqualToAnchor:self.scrollView.centerYAnchor].active = YES;


    self.scrollView.minimumZoomScale = 0.0;
    self.scrollView.maximumZoomScale = 10.0;

    [self.scrollView setZoomScale:0.2];
    self.scrollView.delegate = self;

    [self takeSnapshot];

    [self setupFadeView];

    _menuContainer = [[UINavigationController alloc] initWithRootViewController:self.toolsTabViewController];
    _menuContainer.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.menuContainer.delegate = self;
    [self addChildViewController:_menuContainer];

    [self.view addSubview:_menuContainer.view];
    [self.view addSubview:self.tabStack];

    [_menuContainer.view.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [_menuContainer.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    self.menuTrailingConstraint =[_menuContainer.view.leadingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
    self.menuTrailingConstraint.active = YES;
    _menuWidthConstraint = [_menuContainer.view.widthAnchor constraintEqualToConstant:MenuWidth];
    _menuWidthConstraint.active = YES;

    self.pluginExtension = [[HYPPluginExtensionImp alloc] initWithOverlayContainer:self.scrollViewContainer inAppOverlay:self.inAppDebuggingWindow.overlayContainer hypeWindow:_debuggingWindow];

    [self initializePlugins];
}

-(void)setupFadeView
{
    self.fadeView = [[UIView alloc] init];
    self.fadeView.backgroundColor = [UIColor blackColor];
    self.fadeView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.fadeView];

    [self.fadeView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.fadeView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.fadeView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.fadeView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
}

-(void)setupInAppDebuggingView
{
    self.inAppDebuggingWindow = [[HYPInAppDebuggingWindow alloc] initWithFrame:[[[UIApplication sharedApplication] keyWindow] frame]];
    self.inAppDebuggingWindow.backgroundColor = [UIColor clearColor];
    [self.inAppDebuggingWindow setRootViewController:[UIViewController new]];
    self.inAppDebuggingWindow.hidden = NO;
    self.inAppDebuggingWindow.rootViewController.view.backgroundColor = [UIColor clearColor];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.zoomScale <= 1)
    {
        self.scrollViewContainer.center = self.scrollView.center;
    }
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
    NSMutableArray<id<HYPPluginModule>> *mutablePluginModules = [[NSMutableArray alloc] init];
    NSMutableArray<UITableViewCell *> *mutablePluginViews = [[NSMutableArray alloc] init];


    NSArray *plugins = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HyperionDependencies" ofType:@"plist"]];

    //Fallback to internal list
    if (!plugins)
    {
        plugins = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HyperionDependencies-Internal" ofType:@"plist"]];
    }

    NSMutableArray *pluginClasses = [[NSMutableArray alloc] init];

    for (NSString *pluginStrings in plugins)
    {
        Class pluginClass = NSClassFromString(pluginStrings);
        if (pluginClass)
        {
            [pluginClasses addObject:pluginClass];
        }
        else
        {
            NSLog(@"Failed to load class: %@", pluginStrings);
        }
    }


    //Fallback to internal list
    if (!plugins)
    {
        int numClasses;
        Class * classes = NULL;

        classes = NULL;
        numClasses = objc_getClassList(NULL, 0);

        if (numClasses > 0 )
        {
            classes = (Class *)malloc(sizeof(Class) * numClasses);
            numClasses = objc_getClassList(classes, numClasses);

            for (int i = 0; i < numClasses; i++)
            {
                Class class = classes[i];
                Protocol *pluginProtocol = @protocol(HYPPlugin);
                if (class_conformsToProtocol(class, pluginProtocol))
                {
                    [pluginClasses addObject:class];
                }
            }

            free(classes);
        }
    }





    for (Class pluginClass in pluginClasses)
    {
        id<HYPPlugin> plugin = [[pluginClass alloc] init];

        if ([plugin conformsToProtocol:@protocol(HYPPlugin)])
        {
            id <HYPPluginModule> module = [plugin createPluginModule:self.pluginExtension];
            [mutablePluginModules addObject:module];
            [mutablePluginViews addObject:[module pluginView]];
        }
        else
        {
            NSLog(@"The class %@, fails to conform to HYPPlugin", pluginClass);
        }
    }

    self.pluginModules = mutablePluginModules;
    self.pluginViews = mutablePluginViews;

    self.toolsTabViewController.pluginModules = self.pluginModules;
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.scrollViewContainer;
}

-(void)takeSnapshot
{
    [self.currentSnapshotView removeFromSuperview];

    self.currentSnapshotView = [[[UIApplication sharedApplication] keyWindow] snapshotViewAfterScreenUpdates:NO];
    self.currentSnapshotView.frame = self.view.bounds;
    [self.currentSnapshotView setClipsToBounds:YES];
    [self.scrollViewContainer setSnapshotView:self.currentSnapshotView];

    [self performSelector:@selector(takeSnapshot) withObject:nil afterDelay:1.0];
}

-(void)pan:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        self.debuggingWindow.hidden = NO;

        if (recognizer.view == self.toolsTabViewController.view)
        {
            CGPoint toolsTabLocation = [recognizer locationInView:self.toolsTabViewController.view];

            if (toolsTabLocation.x > 30)
            {
                return;
            }
        }

    }

    CGPoint touches = [recognizer locationInView:self.view];

    self.menuTrailingConstraint.constant = -(self.view.frame.size.width - touches.x);

    CGFloat percentage = MIN(self.menuTrailingConstraint.constant / -MenuWidth, 1.0);

    self.fadeView.alpha = 0.6 * percentage;

    if (recognizer.state == UIGestureRecognizerStateEnded)
    {

        if (self.drawerActive)
        {
            if (self.menuTrailingConstraint.constant < -MenuWidth * (3/4))
            {
                self.menuTrailingConstraint.constant = 0;
            }
            else
            {
                self.menuTrailingConstraint.constant = -MenuWidth;
            }
        }
        else
        {
            if (self.menuTrailingConstraint.constant < -MenuWidth/4)
            {
                self.menuTrailingConstraint.constant = -MenuWidth;
            }
            else
            {
                self.menuTrailingConstraint.constant = 0;
            }
        }

        self.drawerActive = self.menuTrailingConstraint.constant <= -10;

        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
            self.fadeView.alpha = self.drawerActive ? 0.6 : 0.0;
        }
         completion:^(BOOL finished) {
             if (!self.drawerActive && self.scrollViewContainer.numberOfOverlays == 0)
             {
                 [self.debuggingWindow setHidden:YES];
             }
         }];
    }

}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma HYPOverlayContainerListener
-(void)overlayModuleChanged:(id<HYPPluginModule, HYPOverlayViewProvider>)overlayProvider;
{
    self.scrollView.layer.borderColor = self.scrollViewContainer.numberOfOverlays > 0 ? [[UIColor purpleColor] CGColor] : [[UIColor clearColor] CGColor];
    self.scrollView.layer.borderWidth = 3;

    if (self.scrollViewContainer.numberOfOverlays == 0)
    {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }
}

@end
