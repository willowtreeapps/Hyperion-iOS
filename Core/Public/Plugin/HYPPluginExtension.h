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
#import <UIKit/UIKit.h>
#import "HYPOverlayContainer.h"

/**
 * The HYPPluginExtension protocol provides the plugin with context about windows and containers that are available to it.
 */
@protocol HYPPluginExtension <NSObject>

/**
 * This method returns the window Hyperion is currently attached to.
 * @return The current window Hyperion is attached to.
 */
-(nullable UIWindow *)attachedWindow;

/**
 * This method returns the window that displays the Hyperion plugin drawer.
 * @return The window that displays the Hyperion plugin drawer.
 */
-(nullable UIWindow *)hypeWindow;

/**
 * This method returns the container that all of the snapshot plugins modules will use.
 * @return The container that HYPSnapshotPlugin 's will use to display.
 */
-(nonnull id<HYPSnapshotContainer>)snapshotContainer;

/**
 * This method returns the container that all of the overlay plugins modules will use.
 * @return The container that HYPOverlayPlugin 's will use to display.
 */
-(nonnull id<HYPOverlayContainer>)overlayContainer;

/**
 * This method will present a view controller modally over the Hyperion plugin drawer.
 *
 * Note: This is useful for plugins that display information that doesn't fit into the snapshot
 * or overlay category.
 * @param controller The ViewController to present modally.
 * @param animated Whether or not the presentation is animated.
 */
-(void)presentViewControllerOverDrawer:(UIViewController *_Nullable)controller animated:(BOOL)animated;

@end
