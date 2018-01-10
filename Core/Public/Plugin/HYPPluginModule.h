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
#import "HYPPluginExtension.h"
#import "HYPPluginExtension.h"

@protocol HYPPluginMenuItem;

/**
 * HYPPluginModule protocol represents an instance of a plugin.
 */
@protocol HYPPluginModule <NSObject>
/**
 *  Creates a new plugin module with the provided extension.
 *  @param extension The extension the plugin module should be created with.
 */
-(nonnull instancetype)initWithExtension:(nonnull id<HYPPluginExtension>)extension;

/**
 *  The item that appears in the plugin menu list.
 */
@property (nonatomic, readonly, nullable) UIView<HYPPluginMenuItem> *pluginMenuItem;

/**
 *  Represents if the plugin is currently active.
 */
@property (nonatomic, readonly) BOOL active;

/**
 *  The extension that the plugin module was intialized with.
 */
@property (nonatomic, readonly, nonnull) id<HYPPluginExtension> extension;

/**
 * The title that should display for the plugin menu Item.
 * @return The title that should display for the plugin menu Item.
 */
-(nonnull NSString *)pluginMenuItemTitle;

/**
 * The image that should display for the plugin menu Item.
 * @return The image that should display for the plugin menu Item.
 */
-(nonnull UIImage *)pluginMenuItemImage;

/**
 *  Determines whether the drawer should hide when the plugin becomes active/inactive.
 *  @return Yes if the drawer should hide when the plugin becomes active/inactive.
 */
-(BOOL)shouldHideDrawerOnSelection;

@end

/**
 * HYPPluginModule class represents an instance of a plugin.
 */
@interface HYPPluginModule : NSObject <HYPPluginModule>

@end
