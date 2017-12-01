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

#import "UIWindow+Swizzling.h"
#import "HyperionManager.h"
#import "HyperionWindowManager.h"
#import "HYPOverlayDebuggingWindow.h"
#import <objc/runtime.h>

@implementation UIWindow (Swizzling)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(makeKeyWindow);
        SEL swizzledSelector = @selector(xxx_makeKeyWindow);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }

        if ([[UIApplication sharedApplication] keyWindow])
        {
            [[HyperionManager sharedInstance] attachToWindow:[[UIApplication sharedApplication] keyWindow]];
        }
    });
}

-(void)xxx_makeKeyWindow
{
    [self xxx_makeKeyWindow];

    UIWindow *attachWindow = [[UIApplication sharedApplication] keyWindow];

    if ([self canAttachToWindow:attachWindow])
    {
        [[HyperionManager sharedInstance] attachToWindow:attachWindow];
    }
}

-(BOOL)canAttachToWindow:(UIWindow *)window
{
    return !([window isKindOfClass:[HYPOverlayDebuggingWindow class]] || [window isKindOfClass:[HYPSnapshotDebuggingWindow class]]);
}

@end
