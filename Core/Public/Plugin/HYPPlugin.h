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
#import "HYPPluginModule.h"
#import "HYPPluginExtension.h"

/**
 * The HYPPlugin protocol defines a mechanism for creating instances of plugins and providing
 * metadata about a plugin.
 *
 * @since v1.0
 */
@protocol HYPPlugin <NSObject>

/**
 * This method is called in order to create a new plugin instance.
 * @param pluginExtension Extra data that the plugin might need in order to function.
 * @return A new plugin module instance the represents the HYPPlugin.
 */
+(nonnull id<HYPPluginModule>)createPluginModule:(_Nonnull id<HYPPluginExtension>)pluginExtension;

/**
 * This method is used to retrieve the plugin's version.
 * @return The semantic version for the plugin.
 */
+(nonnull NSString *)pluginVersion;

@optional

/**
 * This method is used to retrieve a view controller that represents
 * a guide on how to use the plugin.
 *
 * Note: This view controller will be presented in a NavigationController.
 * @return A ViewController that guides the user on how to
 */
+(nullable UIViewController *)createPluginGuideViewController;

/**
 * This method is used to retrieve an image that represents the plugin. This can be used so
 * outside sources (like the HyperionExample app) can represent the plugin.
 *
 * Note: This is not the image used in the plugin list.
 * @return An image that represents the plugin.
 */
+(nonnull UIImage *)pluginGuideImage;

/**
 * This method is used to retrieve a name that represents the plugin. This can be used so
 * outside sources (like the HyperionExample app) can represent the plugin.
 *
 * Note: This is not the name used in the plugin list.
 * @return A name that represents the plugin.
 */
+(nonnull UIImage *)pluginGuideName;

@end
