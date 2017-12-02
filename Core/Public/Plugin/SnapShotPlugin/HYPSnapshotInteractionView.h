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

@protocol HYPPluginExtension;

/**
 *  This is a base implementation of a Snapshot plugins view that gets
 *  added to the HYPSnapshotContainer once active.
 */
@interface HYPSnapshotInteractionView : UIView

/**
 *  Creates a new HYPSnapshotInteractionView with the provided extension.
 *  @param extension The extension the HYPSnapshotInteractionView should be created with.
 */
-(__nonnull instancetype)initWithExtension:(__nullable id<HYPPluginExtension>)extension;

/**
 *  Called when the interaction view is about to change size.
 *  @param size The size that the interaction view is about to change to.
 *  @param coordinator The transition coordinator allows you to animate views in sync with the size change.
 */
-(void)interactionViewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(__nullable id<UIViewControllerTransitionCoordinator>)coordinator;

/**
 *  Called when the interaction view has changed size.
 *  @param size The size that the interaction view has changed to.
 */
-(void)interactionViewDidTransitionToSize:(CGSize)size;

/**
 *  The extension that the HYPSnapshotInteractionView was intialized with.
 */
@property (nonatomic, readonly, nullable) id<HYPPluginExtension> extension;

@end
