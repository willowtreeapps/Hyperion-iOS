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
#import "HYPOverlayViewProvider.h"
#import "HYPViewSelectionDelegate.h"

@protocol HYPPluginModule;

/**
 *  The HYPSnapshotContainer provides a mechanism of displaying custom UI over a Snapshot of the current app. This allows the user to zoom on the app and inspect tiny details, but also prevents the user from interacting with the app. The HYPSnapshotContainer holds the HYPSnapshotPluginViewProvider's view when a snapshot plugin becomes active. It also provides convenience methods for presenting common UI across the Snanshot plugin platform.
 */
@protocol HYPSnapshotContainer <NSObject>

/**
 * This presents a popover view controller with a list a views that intersect with the provided point. The views listed are in order of front to back.
 *
 * Note: This is used to select views that are covered by other views. This is typically called after a long press gesture on a certain point, but it is up to the plugin to decide when to present this.
 * @param point The point at which the popover presents itself.
 * @param delegate The delegate that notifies when a view has been selected.
 */
-(void)presentViewListPopoverForPoint:(CGPoint)point delegate:(nullable id<HYPViewSelectionDelegate>)delegate;

/**
 * This presents a popover containing the view controller provided.
 * @param popoverController The view controller to display inside the popover.
 * @param height The requested height to make the popover. This value caps out at 300.
 * @param view The view at which the popover should present itself around.
 */
-(void)presentPopover:(nonnull UIViewController *)popoverController recommendedHeight:(CGFloat)height forView:(nonnull UIView *)view;

/**
 * This presents a popover containing the view controller provided.
 * @param popoverController The view controller to display inside the popover.
 * @param height The requested height to make the popover. This value caps out at 300.
 * @param point The position at which the popover should present itself.
 */
-(void)presentPopover:(nonnull UIViewController *)popoverController recommendedHeight:(CGFloat)height atPosition:(CGPoint)point;

/**
 * Dismisses the current popover if there is one.
 */
-(void)dismissCurrentPopover;

/**
 * Presents a view controller modally over the snapshot container.
 *
 * Note: This is typically used when a popover does not provide enough real estate for the information being displayed.
 * @param controller The ViewController to present modally.
 * @param animated Whether or not the presentation is animated.
 */
-(void)presentViewController:(nonnull UIViewController *)controller animated:(bool)animated;

/**
 * The current active plugin module.
 *
 * Note: This can be set to nil to deactivate the current plugin.
 */
@property (nonatomic, nullable) id<HYPPluginModule, HYPSnapshotPluginViewProvider> overlayModule;

@end

/**
 *   The HYPOverlayContainer provides a mechanism for displaying custom UI over an app while still allowing the user to interact with it. The HYPOverlayContainer holds the HYPOverlayViewProvider's when an overlay plugin becomes active.
 */
@protocol HYPOverlayContainer <NSObject>

/**
 * The current active plugin module.
 *
 * Note: This can be set to nil to deactivate the current plugin.
 */
@property (nonatomic, nullable) id<HYPPluginModule, HYPOverlayPluginViewProvider> overlayModule;

@end
