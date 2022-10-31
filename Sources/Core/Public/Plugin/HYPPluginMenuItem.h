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

@protocol HYPPluginMenuItemDelegate;

/**
 * HYPPluginMenuItem Represents a row in the Hyperion plugin list.
 */
@protocol HYPPluginMenuItem

/**
 *  Sets the menu item to selected/unselected.
 *  @param selected Whether or not the menu item should be selected.
 *  @param animated Whether or not the selection should be animated.
 */
-(void)setSelected:(BOOL)selected animated:(BOOL)animated;

/**
 * The selection state of the menu item.
 */
@property (nonatomic, readonly, getter=isSelected) BOOL selected;

/**
 * The delegate that should get informed on menu item changes.
 */
@property (nonatomic, weak) id<HYPPluginMenuItemDelegate> delegate;

@end

/**
 *  A delegate to be informed on HYPPluginMenuItem actions.
 */
@protocol HYPPluginMenuItemDelegate

/**
 * Called when the plugin menu item has been selected.
 * @param pluginView The pluginView that was selected.
 */
-(void)pluginMenuItemSelected:(UIView<HYPPluginMenuItem> *)pluginView;

@end

/**
 * HYPPluginMenuItem Represents a row in the Hyperion plugin list.
 */
@interface HYPPluginMenuItem : UIView <HYPPluginMenuItem>

/**
 * Sets the title and image and styling of the menu item.
 * @param title The title of the menu item.
 * @param image The image of the menu item.
 */
-(void)bindWithTitle:(NSString *)title image:(UIImage *)image;

/**
 *  The tap gesture that determines when the menu item has been selected.
 *
 *  Note: This can be removed for customization purposes, but please ensure the proper
 *  delegate methods are called.
 */
@property (nonatomic) UITapGestureRecognizer *tapGesture;

/**
 * The label that displays the plugin image.
 */
@property (nonatomic) UILabel *titleLabel;

/**
 * The ImageView that displays the plugin image.
 */
@property (nonatomic) UIImageView *pluginImageView;

/**
 * The height of the plugin menu item. This value defaults to 130.
 */
@property (nonatomic) CGFloat height;

@end
