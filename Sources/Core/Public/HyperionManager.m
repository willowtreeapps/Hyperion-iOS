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

#import <Foundation/Foundation.h>
#import "HyperionManager.h"
#import "HYPSnapshotDebuggingWindow.h"
#import <objc/runtime.h>
#import "HYPPluginExtension.h"
#import "HYPPluginExtensionImp.h"
#import "HYPPlugin.h"
#import "HYPOverlayDebuggingWindow.h"
#import "HyperionWindowManager.h"
#import "HYPSnapshotViewController.h"
#import "HYPConfigurationConstants.h"
#import "HYPActivationGestureOptions.h"

@interface HyperionManager()

@property (nonatomic) NSArray<id<HYPPluginModule>> *pluginModules;
@property (nonatomic, weak) UIWindow *key;

@end

@implementation HyperionManager

@synthesize activationGestures = _activationGestures;

static HyperionManager *sharedManager;

+(HyperionManager *)sharedInstance
{
    static dispatch_once_t once = 0;

    dispatch_once(&once, ^{
        sharedManager = [[HyperionManager alloc] init];
        [sharedManager loadSettings];
    });

    return sharedManager;
}

-(void)loadSettings
{
    NSDictionary *configuartion = [[NSDictionary alloc] initWithContentsOfFile:[self configurationPath]];

#if (TARGET_OS_SIMULATOR)
    if ([[configuartion objectForKey:HYPConfigurationKeyTypeSimulator] isKindOfClass:[NSDictionary class]])
    {
        [self changeSettingsForConfiguration:[configuartion objectForKey:HYPConfigurationKeyTypeSimulator]];
    }
#else
    if ([[configuartion objectForKey:HYPConfigurationKeyTypeDevice] isKindOfClass:[NSDictionary class]])
    {
        [self changeSettingsForConfiguration:[configuartion objectForKey:HYPConfigurationKeyTypeDevice]];
    }
#endif

    if ([[configuartion objectForKey:HYPConfigurationKeyTypeDefault] isKindOfClass:[NSDictionary class]])
    {
        [self changeSettingsForConfiguration:[configuartion objectForKey:HYPConfigurationKeyTypeDefault]];
    }
}

-(void)changeSettingsForConfiguration:(NSDictionary *)dictionary
{
    NSArray *triggers = @[];

    if ([[dictionary objectForKey:HYPActivationTriggerKeyOptions] isKindOfClass:[NSArray class]])
    {
        triggers = [dictionary objectForKey:HYPActivationTriggerKeyOptions];
    }

    for (NSString *triggerKey in triggers)
    {
        if ([triggerKey isEqualToString:HYPActivationTriggerKeyGestureRightEdgeSwipe])
        {
            _activationGestures = _activationGestures | HYPActivationGestureRightEdgeSwipe;
        }
        else if ([triggerKey isEqualToString:HYPActivationTriggerKeyGestureShake])
        {
            _activationGestures = _activationGestures | HYPActivationGestureShake;

        }
        else if ([triggerKey isEqualToString:HYPActivationTriggerKeyGestureTwoFingerDoubleTap])
        {
            _activationGestures = _activationGestures | HYPActivationGestureTwoFingerDoubleTap;

        }
        else if ([triggerKey isEqualToString:HYPActivationTriggerKeyGestureThreeFingerSingleTap])
        {
            _activationGestures = _activationGestures | HYPActivationGestureThreeFingerSingleTap;
        }
    }
}

-(void)attachToWindow:(UIWindow *)window
{
    if (self.key == window)
    {
        //Hyperion is already attached to this window
        return;
    }

    self.key = window;
    [[HyperionWindowManager sharedInstance] attachSnapshotDebuggingWindowToWindow:window];
    [[HyperionWindowManager sharedInstance] attachOverlayDebuggingWindowToWindow:window];
    [self setActivationGesture:_activationGestures];
}

-(void)setActivationGesture:(HYPActivationGestureOptions)gesture {

    HYPSnapshotDebuggingWindow *window = [[HyperionWindowManager sharedInstance] currentSnapshotWindow];

    if (gesture == 0)
    {
        [window.twoFingerTapRecognizer setEnabled:NO];
        [window.threeFingerTapRecognizer setEnabled:NO];
        [window.edgeSwipeRecognizer setEnabled:NO];
        [window.overlayVC.twoFingerTapRecognizer setEnabled:NO];
        [window.overlayVC.threeFingerTapRecognizer setEnabled:NO];
        [window.overlayVC.edgeSwipeRecognizer setEnabled:NO];
        return;
    }

    BOOL twoFingerTapEnabled = ((gesture & HYPActivationGestureTwoFingerDoubleTap) == HYPActivationGestureTwoFingerDoubleTap);
    [window.twoFingerTapRecognizer setEnabled:twoFingerTapEnabled];
    [window.overlayVC.twoFingerTapRecognizer setEnabled:twoFingerTapEnabled];

    BOOL threeFingerTapEnabled = ((gesture & HYPActivationGestureThreeFingerSingleTap) == HYPActivationGestureThreeFingerSingleTap);
    [window.threeFingerTapRecognizer setEnabled:threeFingerTapEnabled];
    [window.overlayVC.threeFingerTapRecognizer setEnabled:threeFingerTapEnabled];

    BOOL edgeSwipeEnabled = ((gesture & HYPActivationGestureRightEdgeSwipe) == HYPActivationGestureRightEdgeSwipe);
    [window.edgeSwipeRecognizer setEnabled:edgeSwipeEnabled];
    [window.overlayVC.edgeSwipeRecognizer setEnabled:edgeSwipeEnabled];
}

-(NSArray<Class<HYPPlugin>> *)retrievePluginClasses
{
    NSMutableArray<Class<HYPPlugin>> *pluginClasses = [[NSMutableArray alloc] init];

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

    return pluginClasses;
}

-(NSArray<id<HYPPluginModule>> *)retrievePluginModules
{
    //TODO: Cache Plugin Modules
    return [self forceRefreshPluginModules];
}

-(NSArray<id<HYPPluginModule>> *)forceRefreshPluginModules
{
    HYPPluginExtension *pluginExtension = [[HYPPluginExtension alloc] initWithSnapshotContainer:[[[HyperionWindowManager sharedInstance] currentSnapshotWindow] snapshotContainer] overlayContainer:[[[HyperionWindowManager sharedInstance] currentOverlayWindow] overlayContainer] hypeWindow:[[HyperionWindowManager sharedInstance] currentSnapshotWindow] attachedWindow:self.key];

    NSMutableArray<id<HYPPluginModule>> *mutablePluginModules = [[NSMutableArray alloc] init];
    NSArray<Class<HYPPlugin>> *pluginClasses = [self retrievePluginClasses];

    pluginClasses = [pluginClasses sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [[[obj1 class] description] compare:[[obj2 class] description]];
    }];

    for (Class<HYPPlugin> pluginClass in pluginClasses)
    {
        if ([pluginClass conformsToProtocol:@protocol(HYPPlugin)])
        {
            id <HYPPluginModule> module = [pluginClass createPluginModule:pluginExtension];
            if (module)
            {
                [mutablePluginModules addObject:module];
            }
            else
            {
                NSLog(@"%@ createPluginModule returned a nil plugin module", NSStringFromClass(pluginClass));
            }
        }
        else
        {
            NSLog(@"The class %@, fails to conform to HYPPlugin", pluginClass);
        }
    }

    self.pluginModules = mutablePluginModules;

    return mutablePluginModules;
}

-(void)togglePluginDrawer
{
    [[HyperionWindowManager sharedInstance] togglePluginDrawer];
}

-(NSString *)configurationPath
{
    NSString *config = [[NSBundle mainBundle] pathForResource:@"HyperionConfiguration" ofType:@"plist"];
    NSString *defaultConfig = [[NSBundle bundleForClass:[HyperionManager class]] pathForResource:@"HyperionDefaultConfiguration" ofType:@"plist"];

    return config ? config : defaultConfig;
}

@end
