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

#import "HYPPluginExtensionImp.h"
#import "HYPListenerContainer.h"
#import "HYPSnapshotViewController.h"

@interface HYPPluginExtension ()
@property (nonatomic) id<HYPSnapshotContainer> snapshotContainer;
@property (nonatomic) id<HYPOverlayContainer> overlayContainer;
@property (nonatomic, weak) UIWindow *hypeWindow;
@property (nonatomic, weak) UIWindow *attachedWindow;
@end

@implementation HYPPluginExtension

-(instancetype)initWithSnapshotContainer:(id<HYPSnapshotContainer>)snapshotContainer overlayContainer:(id<HYPOverlayContainer>)overlayContainer hypeWindow:(UIWindow *)hypeWindow attachedWindow:(UIWindow *)attachedWindow
{
    self = [super init];

    _snapshotContainer = snapshotContainer;
    _hypeWindow = hypeWindow;
    _overlayContainer = overlayContainer;
    _attachedWindow = attachedWindow;

    return self;
}

-(UIWindow *)attachedWindow
{
    return _attachedWindow;
}

-(UIWindow *)hypeWindow
{
    return _hypeWindow;
}

-(id<HYPSnapshotContainer>)snapshotContainer
{
    return _snapshotContainer;
}

-(id<HYPOverlayContainer>)overlayContainer
{
    return _overlayContainer;
}

-(void)presentViewControllerOverDrawer:(UIViewController *_Nullable)controller animated:(BOOL)animated
{
    [_hypeWindow.rootViewController presentViewController:controller animated:YES completion:nil];
}

@end
