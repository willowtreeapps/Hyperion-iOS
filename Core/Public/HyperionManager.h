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

#import <UIKit/UIKit.h>
#import "HYPActivationGestureOptions.h"

@protocol HYPPlugin;
@protocol HYPPluginModule;

/**
 *  `HyperionManager` is the interaction point between Hyperion and the app it's integrated in.
 *
 *  Note: Hyperion handles embedding itself on it's own, so using HyperionManager is not required.
 */

@interface HyperionManager : NSObject

/**
 *  The HyperionManager singleton.
 *
 *  Note: This should be the only way used to retrieve an instance of HyperionManager.
 */
+(HyperionManager *)sharedInstance;

/**
 *  Attaches Hyperion to the provided window.
 *  @param window The window to attach Hyperion to.
 */
-(void)attachToWindow:(UIWindow *)window;

/**
 *  Toggles Hyperion's plugin drawer.
 */
-(void)togglePluginDrawer;

/**
 *  Provides a list of plugin classes.
 *  @return A list of plugin classes.
 */
-(NSArray<Class<HYPPlugin>> *)retrievePluginClasses;


/**
 *  Provides a cached list of plugin modules.
 *  @return A cached list of plugin modules.
 */
-(NSArray<id<HYPPluginModule>> *)retrievePluginModules;

/**
 *  Force refreshes the plugin modules.
 *  @return The latest available plugin modules.
 */
-(NSArray<id<HYPPluginModule>> *)forceRefreshPluginModules;

/**
 *  A bitmask of gestures that can be used to activate Hyperion.
 */
@property (nonatomic, readonly) HYPActivationGestureOptions activationGestures;

@end
