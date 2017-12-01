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
#import "HYPOverlayDebuggingWindow.h"

@class HYPSnapshotDebuggingWindow;
@class HYPOverlayDebuggingWindow;

@interface HyperionWindowManager : NSObject

+(HyperionWindowManager *)sharedInstance;

-(void)attachOverlayDebuggingWindowToWindow:(UIWindow *)attachedWindow;
-(void)attachSnapshotDebuggingWindowToWindow:(UIWindow *)attachedWindow;

-(void)togglePluginDrawer;

/*
     This chooses the most logical key window. It first attempts to make the window Hyperion
     is attached to key, but if the attached window is unavailable, then it it will choose, the
     bottom most window.
 */
-(void)decideNewKeyWindow;

-(HYPSnapshotDebuggingWindow *)currentSnapshotWindow;
-(HYPOverlayDebuggingWindow *)currentOverlayWindow;

@end
